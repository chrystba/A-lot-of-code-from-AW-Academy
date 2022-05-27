*&---------------------------------------------------------------------*
*& Report Z_S11_OOP_PKW_KLASSE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_s11_oop_pkw_klasse.

*
*CLASS pkw DEFINITION. "definitionsteil der Klasse
*  PUBLIC SECTION. "Öffentlich einsehbar
*    METHODS:
*      set_kennz
*        IMPORTING im_kz TYPE string,
*      set_anzahl_sitze
*        IMPORTING im_anzahl_sitze TYPE i,
*      fahren
*        IMPORTING
*          im_ziel TYPE string
*          im_dist TYPE i,
*      show_attributes.
*    PRIVATE SECTION. "Privat und nicht zugreifbar was in der PRIVATE SECTION steht
*    DATA:
*      farbe TYPE string.
*  PRIVATE SECTION.
*    DATA :
*      kennz        TYPE string,
*      anzahl_sitze TYPE i,
*      km_stand     TYPE i,
*      akt_ort      TYPE string.
*ENDCLASS.
*
*CLASS pkw IMPLEMENTATION.
*  METHOD show_attributes. "Methoden implementieren
*    WRITE: / 'Farbe:', farbe, 'Kennzeichen:', kennz, 'No. of seats :', anzahl_sitze.
*  ENDMETHOD.
*  METHOD set_kennz.
*    kennz = im_kz.
*  ENDMETHOD.
*  METHOD set_anzahl_sitze.
*    anzahl_sitze = im_anzahl_sitze.
*  ENDMETHOD.
*
*  METHOD fahren.
*    akt_ort = im_ziel.
*    km_stand = km_stand + im_dist.
*    ENDMETHOD.
*ENDCLASS.
*Hauptprogramm
*DATA:
*      mein_auto TYPE REF TO pkw. "auf die Klasse referenzieren
*
*START-OF-SELECTION. "Macht Zuweisen erreichbar
*  CREATE OBJECT mein_auto. "erzeugt das Objekt, damit darauf zugegriffen werden kann
*  mein_auto->farbe = 'rot'.
*  mein_auto->kennz = 'A - RK 1024'.
*  CALL METHOD mein_auto->set_kennz "Methode ermöglich sicher auf private Objekte zuzugreifen
*    EXPORTING
*      im_kz = 'A - RK 1024'.
*  CALL METHOD mein_auto->show_attributes.
*  CALL METHOD mein_auto->set_anzahl_sitze
*    EXPORTING
*      im_anzahl_sitze = 7.
*  call METHOD mein_auto->fahren
*  EXPORTING
*    im_ziel = 'München'.
*  im_dist = 85.
*    CALL METHOD mein_auto->show_attributes.


CLASS pkw DEFINITION.
  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          im_kz  TYPE string DEFAULT 'B-XX 9876'
          im_ort TYPE string OPTIONAL,
      set_kennz
        IMPORTING im_kz TYPE string,
      get_kennz
        RETURNING VALUE(re_kz) TYPE string,
      fahren
        IMPORTING
          im_ziel TYPE string
          im_dist TYPE i
        EXCEPTIONS
          zu_weit,
      tanken
        IMPORTING im_menge TYPE i,
      show_attributes.
    DATA:
      farbe TYPE string.
  PRIVATE SECTION.
    DATA:
      inhalt   TYPE i,
      akt_ort  TYPE string,
      km_stand TYPE i,
      kennz    TYPE string.
ENDCLASS.
*
CLASS pkw IMPLEMENTATION.
  METHOD constructor.
    kennz = im_kz.
    akt_ort = im_ort.
  ENDMETHOD.
  METHOD show_attributes.
    WRITE: / 'Farbe:', farbe, 'Kennzeichen:', kennz,
           'akt. Ort:', akt_ort, 'km:', km_stand,
           'akt. Inhalt:', inhalt.
  ENDMETHOD.
  METHOD set_kennz.
    kennz = im_kz.
  ENDMETHOD.
  METHOD get_kennz.
    re_kz = kennz.
  ENDMETHOD.
  METHOD fahren.
    IF im_dist >= 400.
      RAISE zu_weit.
    ELSE.
      akt_ort = im_ziel.
      km_stand = km_stand + im_dist.
    ENDIF.
  ENDMETHOD.
  METHOD tanken.
    inhalt = inhalt + im_menge.
  ENDMETHOD.
ENDCLASS.
* Hauptprogramm
PARAMETERS:
 p_dist TYPE i DEFAULT 333.
DATA:
      "akt_kz TYPE string,
  mein_auto TYPE REF TO pkw.
*
START-OF-SELECTION.
  CREATE OBJECT mein_auto.
  "EXPORTING "im_kz = 'A-BC 999'
  "im_ort = 'Berlin'.
  mein_auto->farbe = 'rot'.
  " mein_auto->kennz = 'A-RK 1024'.
  CALL METHOD mein_auto->show_attributes.
  CALL METHOD mein_auto->set_kennz
    EXPORTING
      im_kz = 'A-RK 1024'.
* Methode mit Returning-Parameter:
*  CALL METHOD mein_auto->get_kennz
*    RECEIVING re_kz = akt_kz.
*    akt_kz = mein_auto->get_kennz( ).
  WRITE: /5 'returning kz:', mein_auto->get_kennz( ).

  CALL METHOD mein_auto->show_attributes.
  CALL METHOD mein_auto->fahren
    EXPORTING
      im_ziel = 'Augsburg'
      im_dist = p_dist
    EXCEPTIONS
      zu_weit = 3
      OTHERS  = 99.
  CASE sy-subrc.
    WHEN 0. CALL METHOD mein_auto->show_attributes.
    WHEN 3. WRITE: / 'Reichweite überschritten' COLOR COL_NEGATIVE.
    WHEN OTHERS. WRITE: / 'irgendein Fehler'.
  ENDCASE.
  CALL METHOD mein_auto->fahren
    EXPORTING
      im_ziel = 'München'
      im_dist = 85.
  CALL METHOD mein_auto->show_attributes.
