*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 03/30/2022 at 09:39:57
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZAWS09_FLIGHT...................................*
DATA:  BEGIN OF STATUS_ZAWS09_FLIGHT                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZAWS09_FLIGHT                 .
CONTROLS: TCTRL_ZAWS09_FLIGHT
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZS09_V_PF_FLIGHT................................*
TABLES: ZS09_V_PF_FLIGHT, *ZS09_V_PF_FLIGHT. "view work areas
CONTROLS: TCTRL_ZS09_V_PF_FLIGHT
TYPE TABLEVIEW USING SCREEN '0003'.
DATA: BEGIN OF STATUS_ZS09_V_PF_FLIGHT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZS09_V_PF_FLIGHT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZS09_V_PF_FLIGHT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZS09_V_PF_FLIGHT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZS09_V_PF_FLIGHT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZS09_V_PF_FLIGHT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZS09_V_PF_FLIGHT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZS09_V_PF_FLIGHT_TOTAL.

*.........table declarations:.................................*
TABLES: *ZAWS09_FLIGHT                 .
TABLES: ZAWS09_FLIGHT                  .
TABLES: ZS09_SCARR                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
