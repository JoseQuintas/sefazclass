#include "sefazclass.ch"

FUNCTION ze_sefaz_MDFeGeraAutorizado( Self, cXmlAssinado, cXmlProtocolo )

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
      ::nStatus       := Val( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ) )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSE
      ::nStatus := Val( XmlNode( ::cXmlRetorno, "cStat" ) )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF
   IF hb_AScan( { 100, 101, 150, 301, 302 }, { | e | e == ::nStatus } ) == 0
      ::cXmlRetorno := [<erro text="*ERRO* MDFEGeraAutorizado() Não autorizado" />] + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<mdfeProc versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlAUtorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protMDFe", .T. )
   ::cXmlAutorizado += [</mdfeProc>]

   RETURN NIL

