*&---------------------------------------------------------------------*
*& Report Z_AW07_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


REPORT z_aw07_test4.

INTERFACE j.
EVENTS: e.
METHODS: ma,
on_e FOR EVENT e OF j.
DATA: Count TYPE i.
ENDINTERFACE.

CLASS k DEFINITION.
PUBLIC SECTION.
INTERFACES: j.
METHODS:
ma,
constructor IMPORTING im_limit TYPE i.

PRIVATE SECTION.

DATA: limit TYPE i VALUE 9.
ENDCLASS.

CLASS k IMPLEMENTATION.
METHOD constructor.
limit = im_limit.
SET HANDLER j~on_e FOR me.
ENDMETHOD.

METHOD ma.
WHILE j~count < limit.
WRITE: j~count.
ADD 1 TO j~count.
ENDWHILE.
RAISE EVENT j~e.
ENDMETHOD.

METHOD j~ma.
WHILE j~count > 0.
WRITE: j~count.
SUBTRACT 1 FROM j~count.
ENDWHILE.
RAISE EVENT j~e.
ENDMETHOD.

METHOD j~on_e.
WRITE: 'ok'. SKIP.
ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
DATA:
k_ref TYPE REF TO k.
PARAMETERS:
p_limit TYPE i DEFAULT 5.

CREATE OBJECT k_ref
EXPORTING
im_limit = p_limit.
k_ref->j~count = 3.

CALL METHOD : k_ref->j~ma, k_ref->ma.
