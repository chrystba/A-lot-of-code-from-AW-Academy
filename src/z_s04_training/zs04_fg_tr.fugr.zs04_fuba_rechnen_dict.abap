FUNCTION ZS04_FUBA_RECHNEN_DICT .
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(I_A) TYPE  ZDB04_TY_BETRAG
*"     REFERENCE(I_OP) TYPE  ZDB04_TY_OPERATOR
*"     REFERENCE(I_B) TYPE  ZDB04_TY_BETRAG
*"  EXPORTING
*"     REFERENCE(E_RES) TYPE  ZDB04_TY_BETRAG
*"  EXCEPTIONS
*"      ZERO_DIVIDE
*"      WRONG_OPERATOR
*"      NEGATIVE_ARGUMENT
*"----------------------------------------------------------------------

  CASE i_op.
    WHEN '+'. e_res = i_a + i_b.
    WHEN '-'. e_res = i_a - i_b.
    WHEN '*'. e_res = i_a * i_b.
    WHEN '/'.
      IF i_b <> 0.
        e_res = i_a / i_b.
      ELSE.
        RAISE zero_divide.
        WRITE: / 'Divison durch "0" nicht möglich!' COLOR COL_NEGATIVE.
      ENDIF.
    WHEN 'r' OR 'R'. "Quadratwurzel
      IF i_a < 0.
        RAISE negative_argument.
      ELSE.
        e_res = sqrt( i_a ).
      ENDIF.
    WHEN OTHERS.
      RAISE wrong_operator.
      WRITE: / 'Ungültiger Operator!' COLOR COL_GROUP.
  ENDCASE.

ENDFUNCTION.
