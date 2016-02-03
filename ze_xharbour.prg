// compatibilidade xHarbour

#ifdef __XHARBOUR__
FUNCTION wapi_CreateObject( cObject )
   RETURN CreateObject( cObject )

FUNCTION hb_MemoWrit( cFile, cText )
   RETURN Memowrit( cFile, cText, .T. )
#endif