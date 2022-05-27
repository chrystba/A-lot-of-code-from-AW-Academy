*&---------------------------------------------------------------------*
*& Report Z_S05_RANGES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_S05_RANGES.


INCLUDE z_t04_i_flugdaten.

TABLES scarr.

DATA ls_scarr TYPE scarr.


*Beispiel SCARR
SELECT-OPTIONS so_carr FOR scarr-carrid NO INTERVALS DEFAULT 'ZZ' .

SORT lt_scarr BY carrid.

LOOP AT lt_scarr INTO ls_scarr WHERE carrid IN so_carr.
  WRITE: / |{ ls_scarr-carrid } - { ls_scarr-carrname }|.
ENDLOOP.
IF sy-subrc <> 0.
  MESSAGE:  |Keine Fluggeselschaft gefunden.| TYPE 'S'.
ENDIF.


**********************************************************************
*RANGES Reichweiten
*Beispiel TSTC - Tabelle aller Transaktionscodes  in SE16 ansehen, TCODE über SELECT-OPTION der SE16 einschränken.

*TYPISIERUNG der Range

.

****
**TYPISIERUNG DER RANGE
DATA lr_range TYPE RANGE OF scarr-carrid.
DATA ls_range LIKE line of lr_range.

**moramo tipizirati range kao oblik jednog polja tablice i pridodati mu strukturu tako da tipiziramo strukturu kao liniju range.
** tablica scarr-id ima zaglavlje dok ga struktura bez te tablice nema, zbog toga moramo range tipizirati kao range tablice scarr i njezinog polja carrid.
** posto opisujemo strukturu kao jednu liniju range moramo ispisati LIKE LINE OF.

*RANGES lr_range FOR scarr-carrid. " Ddie erzeuzge Tabelle mit Kopfzeile funktionirt so nicht in´objektorientierter Programmierung.

ls_range-sign   = 'I'.
ls_range-option = 'EQ'.
ls_range-low    = 'LH'.
ls_range-high   = ''.

APPEND ls_range TO lr_range.


*AUFGABE: Einschränkungkriterium Buchungsdatum 29.03.2021 UND zwischen 500 und 1000€ Kosten der Buchung.


DATA ls_sbook TYPE sbook.

DATA lt_sbook_result TYPE TABLE OF sbook.

*****Obsolote Deklarierung
*RANGES lr_datum FOR sbook-order_date
*RANGES lr_datum FOR sbook-order_date.
*RANGES lr_value FOR sbook-forcuram.


*Neue Deklarierung

DATA lr_datum TYPE RANGE OF sbook-order_date.
DATA ls_datum LIKE LINE OF lr_datum.

DATA lr_value TYPE RANGE OF sbook-forcuram.
DATA ls_value LIKE LINE OF lr_value.

DATA lv_currency TYPE sbook-forcurkey VALUE 'EUR'.

ls_datum-sign   = 'I'. " Möglichkeit INCLUDE oder EXCLUDE zu wählen.
ls_datum-option = 'EQ'.
ls_datum-low    = '20210928'.
ls_datum-high   = ''.
APPEND ls_datum TO lr_datum.

ls_value-sign   = 'I'.
ls_value-option = 'BT'.
ls_value-low    = 500.
ls_value-high   = 1000.
APPEND ls_value TO lr_value.



LOOP AT lt_sbook INTO ls_sbook
  WHERE
  order_date IN lr_datum AND
  forcurkey EQ lv_currency AND
  Forcuram IN lr_value
  .

  APPEND ls_sbook TO lt_sbook_result.

ENDLOOP.
