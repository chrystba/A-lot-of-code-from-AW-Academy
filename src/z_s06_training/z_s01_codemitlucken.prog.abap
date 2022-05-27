"code met lucken
**********************************************************************
*
REPORT z_s01_codemitlucken.
*
*CLASS C_auto DEFINITION.
*
*  PUBLIC SECTION.
*    EVENTS:
*      tank_leer.
*
*    METHODS:
*      constructor,
*      fahren,
*      tanken
*        FOR EVENT tank_leer OF c_auto.
*ENDCLASS.
*
*CLASS C_auto implementation.
*METHOD constructor.
*SET HANDLER me->tanken FOR me.
*ENDMETHOD.
*
*METHOD fahren.
*  WRITE: 'fahren'.
*  RAISE EVENT tank_leer.
*ENDMETHOD.
*
*METHOD tanken.
*  WRITE: 'tanken'.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS C_tankstelle DEFINITION.
*PUBLIC SECTION.
*  EVENTS:
*    guenstig.
*
*  METHODS:
*    set_preis IMPORTING im_preis TYPE i,
*  get_preis RETURNING VALUE(re_preis) TYPE i,
*  entscheiden,
*  verkaufen FOR EVENT guenstig OF c_tankstelle.
*
*  DATA:
*  preis TYPE i.
*  ENDCLASS.
*  CLASS C_tankstelle IMPLEMENTATION.
*  METHOD set_preis.
*me->preis = im_preis.
*  ENDMETHOD.
*
*    METHOD get_preis.
*     re_preis = me->preis.
*    ENDMETHOD.
*    METHOD entscheiden.
*      IF me->get_preis( ) < 5000.
*        RAISE EVENT guenstig.
*      ELSE.
*      WRITE:/ 'behalten'.
*      endif.
*      ENDMETHOD.
*      METHOD verkaufen.
*        WRITE: 'verkaufen'.
*      ENDMETHOD.
*ENDCLASS.
*
*START-OF-SELECTION.
*
*PARAMETERS:
*preis TYPE i DEFAULT 2000.
*
*DATA:
*  r_auto type REF TO c_auto,
*  r_tankstelle TYPE ref TO c_tankstelle.
*
*r_auto = new C_auto( ).
*r_tankstelle = new C_tankstelle( ).
*SET HANDLER r_tankstelle->verkaufen FOR r_tankstelle.
*r_auto->fahren(  ).
*r_tankstelle->set_preis( preis ).
*r_tankstelle->entscheiden( ).

**********************************************************************
"code mit fehler
**********************************************************************
PARAMETERS:
p_alter TYPE i.

DATA:
     alter TYPE i.

CLASS kauefer_zu_jung_exception DEFINITION
  INHERITING FROM cx_static_check.
ENDCLASS.

CLASS laden DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      alkoholkaufen
      IMPORTING alter TYPE i
      RAISING   kauefer_zu_jung_exception.

ENDCLASS.

CLASS laden IMPLEMENTATION.

  METHOD alkoholkaufen.

    IF alter > 18.
    message |Zum Wohl!| type 'S'.
    ELSE.
      RAISE EXCEPTION TYPE kauefer_zu_jung_exception.

    ENDIF.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  TRY.

      laden=>alkoholkaufen(
      exporting alter = p_alter ).

    CATCH kauefer_zu_jung_exception INTO DATA(e_text).
      MESSAGE e_text->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
  ENDTRY.
