REPORT z02_dynpro_demo1.


TABLES:
  spfli, scarr, sflight.


DATA:
*      Container
  cont1      TYPE REF TO cl_gui_custom_container,
  dia        TYPE REF TO cl_gui_dialogbox_container,
  dock       TYPE REF TO cl_gui_docking_container,


*  Anwendungs-controls
  alv1       TYPE REF TO cl_gui_alv_grid,
  alv2       TYPE REF TO cl_gui_alv_grid,

  ls_spfli   TYPE spfli,
  lt_spfli   TYPE TABLE OF spfli,
  lt_sflight TYPE TABLE OF sflight.

DATA:
    my_caption TYPE c LENGTH 256.

CLASS lcl_listener DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_double_click
        FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row. "E_column.

ENDCLASS.


CLASS lcl_listener IMPLEMENTATION.

  METHOD handle_double_click.
    READ TABLE lt_spfli INDEX e_row-index INTO ls_spfli.
    CONCATENATE 'Flüge zur Fluglinie' ls_spfli-carrid ls_spfli-connid
    INTO my_caption SEPARATED BY space.

    SELECT * FROM sflight INTO TABLE lt_sflight
      WHERE carrid = ls_spfli-carrid AND
      connid = ls_spfli-connid.


      IF dia IS INITIAL.

        CREATE OBJECT dia
          EXPORTING
            width   = 500
            height  = 200
            top     = 50
            left    = 50
            caption = my_caption.

        CREATE OBJECT alv2
          EXPORTING
            i_parent = dia.
      ELSE.
        alv2->refresh_table_display( ).
      ENDIF.
      CALL METHOD alv2->set_table_for_first_display
        EXPORTING
*
          i_structure_name = 'SFLIGHT'
        CHANGING
          it_outtab        = lt_sflight.


    ENDMETHOD.

ENDCLASS.

DATA:
      my_event TYPE REF TO lcl_listener.



PARAMETERS:

p_side TYPE i DEFAULT 1.

START-OF-SELECTION.



  CALL SCREEN 100.



MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
    WHEN 'SHOW'.
      IF spflI-carrid IS INITIAL.
        SELECT * FROM sflight INTO TABLE lt_sflight.
*          SELECT * FROM spfli INTO TABLE lt_spfli.

          ELSE.
            SELECT * FROM spfli INTO TABLE lt_spfli
              WHERE carrid = spfli-carrid.


              SELECT * FROM sflight INTO TABLE lt_sflight
           WHERE carrid = spfli-carrid.
              ENDIF.

              IF sy-subrc <> 0.
                spfli-cityfrom = 'Nicht da'.
                CLEAR spfli.
                CLEAR sflight.
              ENDIF.
            WHEN 'BACK'.
              LEAVE PROGRAM.
          ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.


  IF cont1 IS INITIAL. "Is not bound
    CREATE OBJECT cont1
      EXPORTING
        container_name = 'CUCTRL'.




    CREATE OBJECT dock
      EXPORTING
        side = p_side.

    CREATE OBJECT my_event.

    CREATE OBJECT alv1
      EXPORTING
*       i_parent = dock.
        i_parent = cont1.
    SET HANDLER my_event->handle_double_click FOR alv1.


  ELSE.

    alv1->refresh_table_display( ).
  ENDIF.
  CALL METHOD alv1->set_table_for_first_display
    EXPORTING
*
      i_structure_name = 'SPFLI'
*
    CHANGING
      it_outtab        = lt_spfli.



  cl_gui_control=>set_focus( alv1 ).

ENDMODULE.
