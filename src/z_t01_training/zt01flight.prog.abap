*****           Implementation of object type ZT01FLIGHT           *****
INCLUDE <OBJECT>.
BEGIN_DATA OBJECT. " Do not change.. DATA is generated
* only private members may be inserted into structure private
DATA:
" begin of private,
"   to declare private attributes remove comments and
"   insert private attributes here ...
" end of private,
  BEGIN OF KEY,
      AIRLINE LIKE SFLIGHT-CARRID,
      CONNECTIONNUMBER LIKE SFLIGHT-CONNID,
      FLIGHTDATE LIKE SFLIGHT-FLDATE,
  END OF KEY,
      _SFLIGHT LIKE SFLIGHT.
END_DATA OBJECT. " Do not change.. DATA is generated

TABLES SFLIGHT.
*
GET_TABLE_PROPERTY SFLIGHT.
DATA SUBRC LIKE SY-SUBRC.
* Fill TABLES SFLIGHT to enable Object Manager Access to Table
* Properties
  PERFORM SELECT_TABLE_SFLIGHT USING SUBRC.
  IF SUBRC NE 0.
    EXIT_OBJECT_NOT_FOUND.
  ENDIF.
END_PROPERTY.
*
* Use Form also for other(virtual) Properties to fill TABLES SFLIGHT
FORM SELECT_TABLE_SFLIGHT USING SUBRC LIKE SY-SUBRC.
* Select single * from SFLIGHT, if OBJECT-_SFLIGHT is initial
  IF OBJECT-_SFLIGHT-MANDT IS INITIAL
  AND OBJECT-_SFLIGHT-CARRID IS INITIAL
  AND OBJECT-_SFLIGHT-CONNID IS INITIAL
  AND OBJECT-_SFLIGHT-FLDATE IS INITIAL.
    SELECT SINGLE * FROM SFLIGHT CLIENT SPECIFIED
        WHERE MANDT = SY-MANDT
        AND CARRID = OBJECT-KEY-AIRLINE
        AND CONNID = OBJECT-KEY-CONNECTIONNUMBER
        AND FLDATE = OBJECT-KEY-FLIGHTDATE.
    SUBRC = SY-SUBRC.
    IF SUBRC NE 0. EXIT. ENDIF.
    OBJECT-_SFLIGHT = SFLIGHT.
  ELSE.
    SUBRC = 0.
    SFLIGHT = OBJECT-_SFLIGHT.
  ENDIF.
ENDFORM.

BEGIN_METHOD ZT01MATGETDET CHANGING CONTAINER.
DATA:
      MATNR LIKE ZT01_MATNR,
      MARA LIKE ZT01_MARA,
      RETURN LIKE BAPIRET2.
  SWC_GET_ELEMENT CONTAINER 'Matnr' MATNR.
  CALL FUNCTION 'Z_BAPI_T01_MAT_GET_DET'
    EXPORTING
      MATNR = MATNR
    IMPORTING
      MARA = MARA
      RETURN = RETURN
    EXCEPTIONS
      OTHERS = 01.
  CASE SY-SUBRC.
    WHEN 0.            " OK
    WHEN OTHERS.       " to be implemented
  ENDCASE.
  SWC_SET_ELEMENT CONTAINER 'Mara' MARA.
  SWC_SET_ELEMENT CONTAINER 'Return' RETURN.
END_METHOD.
