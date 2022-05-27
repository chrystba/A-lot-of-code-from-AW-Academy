*---------------------------------------------------------------------*
*    view related FORM routines
*   generation date: 03/30/2022 at 09:40:02
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZS11_V_PF_FLIGHT................................*
FORM GET_DATA_ZS11_V_PF_FLIGHT.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZS11_FLIGHT WHERE
(VIM_WHERETAB) .
    CLEAR ZS11_V_PF_FLIGHT .
ZS11_V_PF_FLIGHT-MANDANT =
ZS11_FLIGHT-MANDANT .
ZS11_V_PF_FLIGHT-CONNID =
ZS11_FLIGHT-CONNID .
ZS11_V_PF_FLIGHT-CARRID =
ZS11_FLIGHT-CARRID .
ZS11_V_PF_FLIGHT-AIRP_FROM =
ZS11_FLIGHT-AIRP_FROM .
ZS11_V_PF_FLIGHT-AIR_TO =
ZS11_FLIGHT-AIR_TO .
    SELECT SINGLE * FROM ZS11_SCARR WHERE
CARRID = ZS11_FLIGHT-CARRID .
    IF SY-SUBRC EQ 0.
ZS11_V_PF_FLIGHT-CARRNAME =
ZS11_SCARR-CARRNAME .
    ENDIF.
<VIM_TOTAL_STRUC> = ZS11_V_PF_FLIGHT.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZS11_V_PF_FLIGHT .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZS11_V_PF_FLIGHT.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZS11_V_PF_FLIGHT-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZS11_FLIGHT WHERE
  CONNID = ZS11_V_PF_FLIGHT-CONNID .
    IF SY-SUBRC = 0.
    DELETE ZS11_FLIGHT .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZS11_FLIGHT WHERE
  CONNID = ZS11_V_PF_FLIGHT-CONNID .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZS11_FLIGHT.
    ENDIF.
ZS11_FLIGHT-MANDANT =
ZS11_V_PF_FLIGHT-MANDANT .
ZS11_FLIGHT-CONNID =
ZS11_V_PF_FLIGHT-CONNID .
ZS11_FLIGHT-CARRID =
ZS11_V_PF_FLIGHT-CARRID .
ZS11_FLIGHT-AIRP_FROM =
ZS11_V_PF_FLIGHT-AIRP_FROM .
ZS11_FLIGHT-AIR_TO =
ZS11_V_PF_FLIGHT-AIR_TO .
    IF SY-SUBRC = 0.
    UPDATE ZS11_FLIGHT ##WARN_OK.
    ELSE.
    INSERT ZS11_FLIGHT .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZS11_V_PF_FLIGHT-UPD_FLAG,
STATUS_ZS11_V_PF_FLIGHT-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZS11_V_PF_FLIGHT.
  SELECT SINGLE * FROM ZS11_FLIGHT WHERE
CONNID = ZS11_V_PF_FLIGHT-CONNID .
ZS11_V_PF_FLIGHT-MANDANT =
ZS11_FLIGHT-MANDANT .
ZS11_V_PF_FLIGHT-CONNID =
ZS11_FLIGHT-CONNID .
ZS11_V_PF_FLIGHT-CARRID =
ZS11_FLIGHT-CARRID .
ZS11_V_PF_FLIGHT-AIRP_FROM =
ZS11_FLIGHT-AIRP_FROM .
ZS11_V_PF_FLIGHT-AIR_TO =
ZS11_FLIGHT-AIR_TO .
    SELECT SINGLE * FROM ZS11_SCARR WHERE
CARRID = ZS11_FLIGHT-CARRID .
    IF SY-SUBRC EQ 0.
ZS11_V_PF_FLIGHT-CARRNAME =
ZS11_SCARR-CARRNAME .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZS11_V_PF_FLIGHT-CARRNAME .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZS11_V_PF_FLIGHT USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZS11_V_PF_FLIGHT-CONNID TO
ZS11_FLIGHT-CONNID .
MOVE ZS11_V_PF_FLIGHT-MANDANT TO
ZS11_FLIGHT-MANDANT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZS11_FLIGHT'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZS11_FLIGHT TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZS11_FLIGHT'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZS11_V_PF_FLIGHT USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZS11_FLIGHT-MANDANT =
ZS11_V_PF_FLIGHT-MANDANT .
ZS11_FLIGHT-CONNID =
ZS11_V_PF_FLIGHT-CONNID .
ZS11_FLIGHT-CARRID =
ZS11_V_PF_FLIGHT-CARRID .
ZS11_FLIGHT-AIRP_FROM =
ZS11_V_PF_FLIGHT-AIRP_FROM .
ZS11_FLIGHT-AIR_TO =
ZS11_V_PF_FLIGHT-AIR_TO .
    SELECT SINGLE * FROM ZS11_SCARR WHERE
CARRID = ZS11_FLIGHT-CARRID .
    IF SY-SUBRC EQ 0.
ZS11_V_PF_FLIGHT-CARRNAME =
ZS11_SCARR-CARRNAME .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZS11_V_PF_FLIGHT-CARRNAME .
    ENDIF.
ENDFORM.

* base table related FORM-routines.............
INCLUDE LSVIMFTX .
