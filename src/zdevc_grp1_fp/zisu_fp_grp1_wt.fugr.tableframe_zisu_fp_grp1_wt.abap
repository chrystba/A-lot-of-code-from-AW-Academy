*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZISU_FP_GRP1_WT
*   generation date: 24.05.2022 at 14:16:17
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZISU_FP_GRP1_WT    .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
