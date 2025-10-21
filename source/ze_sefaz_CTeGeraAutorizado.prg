#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeGeraAutorizado( Self, cXmlAssinado, cXmlProtocolo )

   ::cProjeto := WS_PROJETO_CTE
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
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
      ::cXmlRetorno := [<erro text="*ERRO* CTEGeraAutorizado() Não autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<cteProc versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protCTe", .T. ) // ?hb_Utf8ToStr()
   ::cXmlAutorizado += [</cteProc>]

   RETURN ::cXmlAutorizado

