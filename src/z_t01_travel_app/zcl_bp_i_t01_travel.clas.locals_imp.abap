*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type declarations

CLASS lhc_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES tt_travel_update TYPE TABLE FOR UPDATE zi_t01_travel.

    METHODS validate_customer     FOR VALIDATE ON SAVE IMPORTING keys FOR travel~validateCustomer.
    METHODS validate_dates        FOR VALIDATE ON SAVE IMPORTING keys FOR travel~validateDates.
    METHODS validate_agency       FOR VALIDATE ON SAVE IMPORTING keys FOR travel~validateAgency.

    METHODS set_status_completed  FOR MODIFY IMPORTING   keys FOR ACTION travel~acceptTravel              RESULT result.
    METHODS get_features          FOR FEATURES IMPORTING keys REQUEST    requested_features FOR travel    RESULT result.

    METHODS CalculateTravelKey    FOR DETERMINE ON MODIFY IMPORTING keys FOR Travel~CalculateTravelKey.

ENDCLASS.

CLASS lhc_travel IMPLEMENTATION.

**********************************************************************
* Validate customer data when saving travel data
**********************************************************************
  METHOD validate_customer.

    READ ENTITY IN LOCAL MODE zi_t01_travel\\travel FROM VALUE #(
        FOR <root_key> IN keys ( %key-mykey = <root_key>-mykey
                                 %control   = VALUE #( customer_id = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_travel).

    DATA lt_customer TYPE SORTED TABLE OF zi_customer WITH UNIQUE KEY customerid.

    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_customer = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING customerid = customer_id EXCEPT * ).
    DELETE lt_customer WHERE customerid IS INITIAL.
    CHECK lt_customer IS NOT INITIAL.

    " Check if customer ID exist
    SELECT FROM zi_customer FIELDS customerid
      FOR ALL ENTRIES IN @lt_customer
      WHERE customerid = @lt_customer-customerid
      INTO TABLE @DATA(lt_customer_db).

    " Raise message for non existing customer id
    LOOP AT lt_travel INTO DATA(ls_travel).
      IF ls_travel-customer_id IS NOT INITIAL AND NOT line_exists( lt_customer_db[ customerid = ls_travel-customer_id ] ).
        APPEND VALUE #(  mykey = ls_travel-mykey ) TO failed-travel.
        APPEND VALUE #(  mykey = ls_travel-mykey
                         %msg      = new_message( id       = 'SXI_DEMO'
                                                  number   = '150' "Customer number &1 unknown
                                                  v1       = ls_travel-customer_id
                                                  severity = if_abap_behv_message=>severity-error )
                         %element-customer_id = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

**********************************************************************
* Check validity of date
**********************************************************************
  METHOD validate_dates.

    READ ENTITY IN LOCAL MODE zi_t01_travel\\travel FROM VALUE #(
        FOR <root_key> IN keys ( %key-mykey     = <root_key>-mykey
                                 %control = VALUE #( begin_date = if_abap_behv=>mk-on
                                                     end_date   = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result INTO DATA(ls_travel_result).

      IF ls_travel_result-end_date < ls_travel_result-begin_date.  "end_date before begin_date

        APPEND VALUE #( %key  = ls_travel_result-%key
                        mykey = ls_travel_result-mykey ) TO failed-travel.

        APPEND VALUE #( %key  = ls_travel_result-%key
                        %msg  = new_message( id       = 'HRPADIN01'
                                             number   = '349' "End date precedes Begin Date (End date < Begin Date)
                                             v1       = ls_travel_result-begin_date
                                             v2       = ls_travel_result-end_date
                                             v3       = ls_travel_result-travel_id
                                             severity = if_abap_behv_message=>severity-error )
                        %element-begin_date = if_abap_behv=>mk-on
                        %element-end_date   = if_abap_behv=>mk-on ) TO reported-travel.

      ELSEIF ls_travel_result-begin_date < cl_abap_context_info=>get_system_date( ).  "begin_date must be in the future

        APPEND VALUE #( %key  = ls_travel_result-%key
                        mykey = ls_travel_result-mykey ) TO failed-travel.

        APPEND VALUE #( %key = ls_travel_result-%key
                        %msg = new_message( id       = 'HRPAYCN'
                                            number   = '004' "Valid date of begin date &1 > system high_date
                                            severity = if_abap_behv_message=>severity-error )
                        %element-begin_date = if_abap_behv=>mk-on
                        %element-end_date   = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

********************************************************************************
* Implements travel action (in our case: for setting travel overall_status to completed)
********************************************************************************
  METHOD set_status_completed.

    " Modify in local mode: BO-related updates that are not relevant for authorization checks
    MODIFY ENTITIES OF zi_t01_travel IN LOCAL MODE
           ENTITY travel
              UPDATE FROM VALUE #( FOR key IN keys ( mykey = key-mykey
                                                     overall_status = 'A' " Accepted
                                                     %control-overall_status = if_abap_behv=>mk-on ) )
           FAILED   failed
           REPORTED reported.

    " Read changed data for action result
    READ ENTITIES OF zi_t01_travel IN LOCAL MODE
         ENTITY travel
         FROM VALUE #( FOR key IN keys (  mykey = key-mykey
                                          %control = VALUE #(
                                            agency_id       = if_abap_behv=>mk-on
                                            customer_id     = if_abap_behv=>mk-on
                                            begin_date      = if_abap_behv=>mk-on
                                            end_date        = if_abap_behv=>mk-on
                                            booking_fee     = if_abap_behv=>mk-on
                                            total_price     = if_abap_behv=>mk-on
                                            currency_code   = if_abap_behv=>mk-on
                                            overall_status  = if_abap_behv=>mk-on
                                            description     = if_abap_behv=>mk-on
                                            created_by      = if_abap_behv=>mk-on
                                            created_at      = if_abap_behv=>mk-on
                                            last_changed_by = if_abap_behv=>mk-on
                                            last_changed_at = if_abap_behv=>mk-on
                                          ) ) )
         RESULT DATA(lt_travel).

    result = VALUE #( FOR travel IN lt_travel ( mykey = travel-mykey
                                                %param    = travel
                                              ) ).

  ENDMETHOD.

********************************************************************************
* Implements the dynamic feature handling for travel instances
********************************************************************************
  METHOD get_features.

    "%control-<fieldname> specifies which fields are read from the entities
    READ ENTITY IN LOCAL MODE zi_t01_travel FROM VALUE #( FOR keyval IN keys
                                                      (  %key                    = keyval-%key
                                                       "  %control-travel_id      = if_abap_behv=>mk-on
                                                         %control-overall_status = if_abap_behv=>mk-on
                                                        ) )
                                RESULT DATA(lt_travel_result).


    result = VALUE #( FOR ls_travel IN lt_travel_result
                       ( %key                           = ls_travel-%key
                         %features-%action-acceptTravel = COND #( WHEN ls_travel-overall_status = 'A'
                                                                    THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled   )
                      ) ).

  ENDMETHOD.

  METHOD calculatetravelkey.
    READ ENTITIES OF zi_t01_travel IN LOCAL MODE
        ENTITY Travel
          FIELDS ( travel_id )
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel).

    DELETE lt_travel WHERE travel_id IS NOT INITIAL.
    CHECK lt_travel IS NOT INITIAL.

    "Get max travelID
    SELECT SINGLE FROM zt01_travel FIELDS MAX( travel_id ) INTO @DATA(lv_max_travelid).

    "update involved instances
    MODIFY ENTITIES OF zi_t01_travel IN LOCAL MODE
      ENTITY Travel
        UPDATE FIELDS ( travel_id )
        WITH VALUE #( FOR ls_travel IN lt_travel INDEX INTO i (
                           %key      = ls_travel-%key
                           travel_id  = lv_max_travelid + i ) )
    REPORTED DATA(lt_reported).


  ENDMETHOD.

  METHOD validate_agency.
    READ ENTITY IN LOCAL MODE zi_t01_travel\\travel FROM VALUE #(
        FOR <root_key> IN keys ( %key-mykey     = <root_key>-mykey
                                 %control = VALUE #( agency_id = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_travel).

    DATA lt_agency TYPE SORTED TABLE OF zi_agency WITH UNIQUE KEY agencyid.

    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_agency = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING agencyid = agency_id EXCEPT * ).
    DELETE lt_agency WHERE agencyid IS INITIAL.
    CHECK lt_agency IS NOT INITIAL.

    " Check if customer ID exist
    SELECT FROM zi_agency FIELDS agencyid
      FOR ALL ENTRIES IN @lt_agency
      WHERE agencyid = @lt_agency-agencyid
      INTO TABLE @DATA(lt_agency_db).

    " Raise message for non existing customer id
    LOOP AT lt_travel INTO DATA(ls_travel).
      IF ls_travel-agency_id IS NOT INITIAL AND NOT line_exists( lt_agency_db[ agencyid = ls_travel-agency_id ] ).
        APPEND VALUE #(  mykey = ls_travel-mykey ) TO failed-travel.
        APPEND VALUE #(  mykey = ls_travel-mykey
                         %msg      = new_message( id       = 'SXI_DEMO'
                                                  number   = '151' "Agency with number &1 unknown
                                                  v1       = ls_travel-agency_id
                                                  severity = if_abap_behv_message=>severity-error )
                         %element-agency_id = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.
