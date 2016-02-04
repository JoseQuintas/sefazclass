// compatibilidade xHarbour

#ifdef __XHARBOUR__
FUNCTION wapi_CreateObject( cObject )
   RETURN CreateObject( cObject )

FUNCTION hb_MemoWrit( cFile, cText )
   RETURN Memowrit( cFile, cText, .T. )

FUNCTION hb_At( cText, nStart, nEnd )
   RETURN At( cText, nStart, nEnd )

FUNCTION hb_Eol()
   RETURN Chr(13) + Chr(10)

FUNCTION wapi_MessageBox( nHwnd, cText, cTitle )
   RETURN Alert( cText )
#endif