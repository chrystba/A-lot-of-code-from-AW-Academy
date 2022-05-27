*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 03/30/2022 at 09:38:58
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZS05_V_PF_FLIGHT................................*
TABLES: ZS05_V_PF_FLIGHT, *ZS05_V_PF_FLIGHT. "view work areas
CONTROLS: TCTRL_ZS05_V_PF_FLIGHT
TYPE TABLEVIEW USING SCREEN '0003'.
DATA: BEGIN OF STATUS_ZS05_V_PF_FLIGHT. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZS05_V_PF_FLIGHT.
* Table for entries selected to show on screen
DATA: BEGIN OF ZS05_V_PF_FLIGHT_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZS05_V_PF_FLIGHT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZS05_V_PF_FLIGHT_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZS05_V_PF_FLIGHT_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZS05_V_PF_FLIGHT.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZS05_V_PF_FLIGHT_TOTAL.

*.........table declarations:.................................*
TABLES: ZAWS05_FLIGHT                  .
TABLES: ZS05_SCARR                     .
