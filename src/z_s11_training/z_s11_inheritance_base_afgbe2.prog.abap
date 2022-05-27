*&---------------------------------------------------------------------*
*& Report ZBC401_INHERITANCE_BASE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_s11_inheritance_base_afgbe2.

TYPE-POOLS icon.

CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          iv_name      TYPE string
          iv_planetype TYPE saplane-planetype
        EXCEPTIONS
          wrong_planetype,
*
      display_attributes.

    CLASS-METHODS:
      class_constructor,
      display_n_o_airplanes,
      get_n_no_airplanes
        RETURNING VALUE(rv_count) TYPE i.

PROTECTED SECTION. "sichtbarkeit in untere klasse
       CONSTANTS:
 c_pos_1 TYPE i VALUE 30.

  PRIVATE SECTION.

    TYPES:
    ty_planetypes TYPE TABLE OF saplane
    WITH NON-UNIQUE KEY planetype.

*    CONSTANTS:
*    c_pos_1 TYPE i VALUE 30.

    DATA: mv_name      TYPE string,
          mv_planetype TYPE saplane-planetype,
          mv_weight    TYPE saplane-weight,
          mv_tankcap   TYPE saplane-tankcap.

    CLASS-DATA:
      gv_n_o_airplanes TYPE i,
      gt_planetypes    TYPE ty_planetypes.

    CLASS-METHODS:
      get_technical_attributes
        IMPORTING
          iv_type    TYPE saplane-planetype
        EXPORTING
          ev_weight  TYPE saplane-weight
          ev_tankcap TYPE saplane-tankcap
        EXCEPTIONS
          wrong_planetype.

ENDCLASS. " lcl_airplane definition.
*------------------------------------
CLASS lcl_airplane IMPLEMENTATION.

  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE gt_planetypes. "filling the static attribute by calling static constructor
  ENDMETHOD.

  METHOD constructor.

    mv_name = iv_name.
    mv_planetype = iv_planetype.

    get_technical_attributes( "constructor calls the private static method get_technical_attributes
      EXPORTING
        iv_type         = iv_planetype
      IMPORTING
        ev_weight       = mv_weight
        ev_tankcap      = mv_tankcap
      EXCEPTIONS
        wrong_planetype = 1
    ).

    IF sy-subrc NE 0.
      RAISE wrong_planetype.
    ELSE.
      gv_n_o_airplanes = gv_n_o_airplanes + 1.
    ENDIF.

  ENDMETHOD." constructor.

  METHOD display_attributes.

    WRITE:
     / icon_ws_plane AS ICON,
     / 'Name of Airplane'(001) , AT c_pos_1 mv_name,
     / 'Type of Airplane'(002) , AT c_pos_1 mv_planetype,
     / 'Weight'(003) , AT c_pos_1 mv_weight LEFT-JUSTIFIED,
     / 'Tank Capacity'(004) , AT c_pos_1 mv_tankcap LEFT-JUSTIFIED.

  ENDMETHOD. " display_attributes.

  METHOD display_n_o_airplanes.
    SKIP.
    WRITE:
     / 'Number of Airplanes:'(ca1), AT c_pos_1 gv_n_o_airplanes  LEFT-JUSTIFIED.
  ENDMETHOD."  display_n_o_airplanes.

  METHOD get_n_no_airplanes.
    rv_count = gv_n_o_airplanes.
  ENDMETHOD." get_n_no_airplanes.

  METHOD get_technical_attributes.
    DATA: ls_planetype TYPE saplane.

    READ TABLE gt_planetypes INTO ls_planetype
    WITH TABLE KEY planetype = iv_type
    TRANSPORTING weight tankcap.

    IF sy-subrc = 0.
      ev_weight = ls_planetype-weight.
      ev_tankcap = ls_planetype-tankcap.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.

  ENDMETHOD." get_technical_atrributes.

ENDCLASS. " lcl_airplane implementation.

class lcl_passenger_plane definition inheriting from lcl_airplane.

  PUBLIC SECTION.
  methods:
  constructor
  importing
    iv_name type string
    iv_planetype type saplane-planetype
    iv_seats type s_seatsmax
    exceptions
      wrong_planetype,

display_attributes redefinition.
PROTECTED SECTION.
data : mv_seats type s_seatsmax.
  endclass.
  class lcl_passenger_plane implementation.
    method constructor.
      super->constructor(
      exporting
        iv_name = iv_name
        iv_planetype = iv_planetype
        exceptions
          wrong_planetype = 1
          ).
        IF sy-subrc NE 0.
      RAISE wrong_planetype .
    ENDIF.

    mv_seats = iv_seats.
    endmethod.

    method display_attributes.
       super->display_attributes( ).
        WRITE:
     / 'Max seats' , AT c_pos_1 mv_seats.
        uline.
    endmethod.
    endclass.

DATA: go_airplane  TYPE REF TO lcl_airplane,
      gt_airplanes TYPE TABLE OF REF TO lcl_airplane,
      gv_count     TYPE i,
go_passenger_plane type ref to lcl_passenger_plane.

START-OF-SELECTION.

  lcl_airplane=>display_n_o_airplanes( ). "static method call

**--------------------------------------------
  create object go_passenger_plane
      EXPORTING
      iv_name         = 'US Hercules'
        iv_planetype    = '747-200F'
        iv_seats = '15'
        exceptions
          wrong_planetype = 1.
  if sy-subrc = 0.
  append go_passenger_plane to gt_airplanes.
  endif.
*  go_passenger_plane->display_attributes( ).

*-------------------------
  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A321'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.

*-------------------------
  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'AA New York'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.

*-------------------------
  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Hercules'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.

  LOOP AT gt_airplanes INTO go_airplane.
    go_airplane->display_attributes( ).
  ENDLOOP.

  gv_count = lcl_airplane=>get_n_no_airplanes( ).
  SKIP 2.
  WRITE: / 'Number of Airplanes'(ca1), gv_count.

*  --------------------------------------------
*  create object go_passenger_plane
*      EXPORTING
*      iv_name         = 'US Hercules'
*        iv_planetype    = '747-200F'
*        iv_seats = '15'
*        exceptions
*          wrong_planetype = 1.
*  go_passenger_plane->display_attributes( ).
