#include "sefazclass.ch"

FUNCTION ze_sefaz_MDFeGeraAutorizado( Self, cXmlAssinado, cXmlProtocolo )

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSE
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF
   //::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protMDFe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<erro text="*ERRO* MDFEGeraAutorizado() Não autorizado" />] + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<mdfeProc versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlAUtorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protMDFe", .T. )
   ::cXmlAutorizado += [</mdfeProc>]

   RETURN NIL

