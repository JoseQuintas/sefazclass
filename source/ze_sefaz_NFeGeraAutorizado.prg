#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeGeraAutorizado( Self, cXmlAssinado, cXmlProtocolo )

   LOCAL cValue

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlRetorno, cXmlProtocolo )

   IF [<infProt>] $ cXmlProtocolo
      cValue := XmlNode( XmlNode( cXmlProtocolo, "infProt" ), "nProt" )
      IF ! Empty( cValue )
         cXmlProtocolo := StrTran( cXmlProtocolo, [<infProt>], [<infProt Id="ID] + cValue + [">] )
      ENDIF
   ENDIF

   IF ! Empty( XmlNode( cXmlProtocolo, "infProt" ) )
      ::cStatus       := Pad( XmlNode( XmlNode( cXmlProtocolo, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( cXmlProtocolo, "infProt" ), "xMotivo" )
   ELSE
      ::cStatus := Pad( XmlNode( cXmlProtocolo, "cStat" ), 3 )
      ::cMotivo := XmlNode( cXmlProtocolo, "xMotivo" )
   ENDIF
   IF ! ::cStatus $ "100,101,150"
      ::cXmlRetorno := [<erro text="*ERRO* NFeGeraAutorizado() N�o autorizado" />] + cXmlProtocolo
      RETURN Nil
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<nfeProc versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protNFe", .T. )
   ::cXmlAutorizado += [</nfeProc>]

   RETURN NIL

