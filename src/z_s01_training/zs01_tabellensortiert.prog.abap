*&---------------------------------------------------------------------*
*& Report Z_S01_TABELLEN_SORTED
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_s01_tabellen_sorted.

*Verstanden.

*Struktur

TYPES: BEGIN OF lty_s_benutzer,
         id(8)     TYPE c,
         vname(10) TYPE c,
         nname(10) TYPE c,
       END OF lty_s_benutzer,

       lty_t_benutzer TYPE SORTED TABLE OF lty_s_benutzer.

*  DATA lt_benutzer TYPE lty_s_benutzer.

DATA ls_benutzer TYPE lty_s_benutzer. "

DATA lt_benutzer TYPE SORTED TABLE OF lty_s_benutzer WITH UNIQUE KEY id.  "Was geschieht hier? Ich dachte, wir hätten oben schon eine innere Tabelle."
"Unique Key sorgt dafür, dass nicht zwei gleiche werte, eingefügt werden."

*Datenbestand
ls_benutzer-id = 'ID000001'.
ls_benutzer-vname = 'Heinz'.
ls_benutzer-nname = 'Kriete'.
APPEND ls_benutzer TO lt_benutzer. "überträgt zur Tabelle

ls_benutzer-id = 'ID000002'.
ls_benutzer-vname = |Max|.
ls_benutzer-nname = |Mustermann|.
APPEND ls_benutzer TO lt_benutzer.

ls_benutzer-id = 'ID000003'.
ls_benutzer-vname = |Petra|.
ls_benutzer-nname = |Berger|.
APPEND ls_benutzer TO lt_benutzer.  "Wenn du denselben Benutzer 2 mal anmeldest, Fehler."

CLEAR ls_benutzer.


**********************************************************************
*Neuen Nutzer Hinzufügen: - wie überprüfen, ob es den schon gibt?
* Aufgabe: Wenn BenutzerId schon vergeben, die nächste vorschlagen, die nicht vergeben ist.

*READ TABLE lt_benutzer INTO ls_benutzer WITH TABLE KEY id . "TRANSPORTING NO FIELDS

DATA: lv_max_id_c(6) TYPE n. "n numerisches Textfeld.
DATA dummy TYPE string.
DATA lv_zeilenanzahl TYPE i.


ls_benutzer-id = 'ID000002'.
ls_benutzer-vname = |Max|.
ls_benutzer-nname = |Müller|.

*Fragen, was hier geschieht.

*Variante der Abfrage auf ID über READ TABLE
READ TABLE lt_benutzer WITH TABLE KEY id = ls_benutzer TRANSPORTING NO FIELDS. "
IF sy-subrc EQ 0.
  WRITE: |Benutzer mit der ID: { ls_benutzer-id } ist schon vergeben! (READ TABLE)|.
ENDIF.

*Variante der Abfrage auf ID über LOOP
LOOP AT lt_benutzer INTO ls_benutzer WHERE id EQ ls_benutzer-id.
ENDLOOP.

IF sy-subrc <> 0.
  APPEND ls_benutzer TO lt_benutzer.
ELSE.
  WRITE: / |Benutzer mit der ID: { ls_benutzer-id } ist schon vergeben! (LOOP)|.
  MESSAGE: |Benutzer mit der ID: { ls_benutzer-id } ist schon vergeben! (LOOP)| TYPE 'S' DISPLAY LIKE 'E'.

  "Annahme der Namenskonvention für Benutzer: ID<Laufende Nummer>.

*  LOOP AT lt_benutzer INTO ls_benutzer.
*  ENDLOOP.

  DESCRIBE TABLE lt_benutzer LINES lv_zeilenanzahl.
  READ TABLE lt_benutzer INDEX lv_zeilenanzahl INTO ls_benutzer.

  SPLIT ls_benutzer-id AT 'ID' INTO dummy lv_max_id_c.
  ADD 1 TO lv_max_id_c.

  ls_benutzer-id = |ID{ lv_max_id_c }|.
  WRITE / | Die nächste freie ID wäre: { ls_benutzer-id }|.

ENDIF.


BREAK-POINT.
