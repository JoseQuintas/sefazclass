/*
ZE_XHARBOUR - compatibilidade xHarbour

* w32ole.prg baseada na win32ole.prg v 1.82 2005/04/29 do xharbour
*/

#ifdef __XHARBOUR__

FUNCTION win_OleCreateObject( cName )

   RETURN xhb_CreateObject( cName )

FUNCTION hb_MemoWrit( cFile, cText )

   RETURN MemoWrit( cFile, cText, .T. )

FUNCTION hb_At( cText, nStart, nEnd )

   RETURN At( cText, nStart, nEnd )

FUNCTION hb_Eol()

   RETURN Chr(13) + Chr(10)

FUNCTION wapi_MessageBox( nHwnd, cText, cTitle )

   RETURN Alert( cText )

FUNCTION hb_Hash()

   RETURN Hash()

FUNCTION HB_SYMBOL_UNUSED( x )

   RETURN Nil

FUNCTION hb_Default( xVar, xValue )

   IF xValue != NIL .AND. ( xVar == NIL .OR. ValType( xVar ) != ValType( xValue ) )
      xVar := xValue
   ENDIF

   RETURN Nil

FUNCTION HPDF_LOADJPEGIMAGEFROMMEM()

   // Isto vai impedir de usar imagens em memória,
   // mas se no XHarbour não tem, sem opção

   RETURN Nil

#endif
