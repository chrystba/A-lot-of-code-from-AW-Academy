*---------------------------------------------------------------------*
*    view related FORM routines
*   generation date: 03/30/2022 at 09:40:06
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZS01_VPF_PFLIGHT................................*
FORM GET_DATA_ZS01_VPF_PFLIGHT.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZS01_FLIGHT WHERE
(VIM_WHERETAB) .
    CLEAR ZS01_VPF_PFLIGHT .
ZS01_VPF_PFLIGHT-MANDANT =
ZS01_FLIGHT-MANDANT .
ZS01_VPF_PFLIGHT-CONNID =
ZS01_FLIGHT-CONNID .
ZS01_VPF_PFLIGHT-CARRID =
ZS01_FLIGHT-CARRID .
ZS01_VPF_PFLIGHT-AIRP_FROM =
ZS01_FLIGHT-AIRP_FROM .
ZS01_VPF_PFLIGHT-AIR_TO =
ZS01_FLIGHT-AIR_TO .
    SELECT SINGLE * FROM ZS01_SCARR WHERE
CARRID = ZS01_FLIGHT-CARRID .
    IF SY-SUBRC EQ 0.
ZS01_VPF_PFLIGHT-CARRNAME =
ZS01_SCARR-CARRNAME .
    ENDIF.
<VIM_TOTAL_STRUC> = ZS01_VPF_PFLIGHT.
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
FORM DB_UPD_ZS01_VPF_PFLIGHT .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZS01_VPF_PFLIGHT.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZS01_VPF_PFLIGHT-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZS01_FLIGHT WHERE
  CONNID = ZS01_VPF_PFLIGHT-CONNID .
    IF SY-SUBRC = 0.
    DELETE ZS01_FLIGHT .
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
  SELECT SINGLE FOR UPDATE * FROM ZS01_FLIGHT WHERE
  CONNID = ZS01_VPF_PFLIGHT-CONNID .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZS01_FLIGHT.
    ENDIF.
ZS01_FLIGHT-MANDANT =
ZS01_VPF_PFLIGHT-MANDANT .
ZS01_FLIGHT-CONNID =
ZS01_VPF_PFLIGHT-CONNID .
ZS01_FLIGHT-CARRID =
ZS01_VPF_PFLIGHT-CARRID .
ZS01_FLIGHT-AIRP_FROM =
ZS01_VPF_PFLIGHT-AIRP_FROM .
ZS01_FLIGHT-AIR_TO =
ZS01_VPF_PFLIGHT-AIR_TO .
    IF SY-SUBRC = 0.
    UPDATE ZS01_FLIGHT ##WARN_OK.
    ELSE.
    INSERT ZS01_FLIGHT .
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
CLEAR: STATUS_ZS01_VPF_PFLIGHT-UPD_FLAG,
STATUS_ZS01_VPF_PFLIGHT-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZS01_VPF_PFLIGHT.
  SELECT SINGLE * FROM ZS01_FLIGHT WHERE
CONNID = ZS01_VPF_PFLIGHT-CONNID .
ZS01_VPF_PFLIGHT-MANDANT =
ZS01_FLIGHT-MANDANT .
ZS01_VPF_PFLIGHT-CONNID =
ZS01_FLIGHT-CONNID .
ZS01_VPF_PFLIGHT-CARRID =
ZS01_FLIGHT-CARRID .
ZS01_VPF_PFLIGHT-AIRP_FROM =
ZS01_FLIGHT-AIRP_FROM .
ZS01_VPF_PFLIGHT-AIR_TO =
ZS01_FLIGHT-AIR_TO .
    SELECT SINGLE * FROM ZS01_SCARR WHERE
CARRID = ZS01_FLIGHT-CARRID .
    IF SY-SUBRC EQ 0.
ZS01_VPF_PFLIGHT-CARRNAME =
ZS01_SCARR-CARRNAME .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZS01_VPF_PFLIGHT-CARRNAME .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZS01_VPF_PFLIGHT USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZS01_VPF_PFLIGHT-CONNID TO
ZS01_FLIGHT-CONNID .
MOVE ZS01_VPF_PFLIGHT-MANDANT TO
ZS01_FLIGHT-MANDANT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZS01_FLIGHT'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZS01_FLIGHT TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZS01_FLIGHT'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZS01_VPF_PFLIGHT USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZS01_FLIGHT-MANDANT =
ZS01_VPF_PFLIGHT-MANDANT .
ZS01_FLIGHT-CONNID =
ZS01_VPF_PFLIGHT-CONNID .
ZS01_FLIGHT-CARRID =
ZS01_VPF_PFLIGHT-CARRID .
ZS01_FLIGHT-AIRP_FROM =
ZS01_VPF_PFLIGHT-AIRP_FROM .
ZS01_FLIGHT-AIR_TO =
ZS01_VPF_PFLIGHT-AIR_TO .
    SELECT SINGLE * FROM ZS01_SCARR WHERE
CARRID = ZS01_FLIGHT-CARRID .
    IF SY-SUBRC EQ 0.
ZS01_VPF_PFLIGHT-CARRNAME =
ZS01_SCARR-CARRNAME .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZS01_VPF_PFLIGHT-CARRNAME .
    ENDIF.
ENDFORM.

* base table related FORM-routines.............
INCLUDE LSVIMFTX .
