#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeGeraEventoAutorizado( Self, cXmlAssinado, cXmlProtocolo )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   IF ::cStatus != "999"
      ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "cStat" ), 3 )
      ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "xMotivo" ) // runner
   ENDIF
   IF ! ::cStatus $ "135,155"
      ::cXmlRetorno := [<erro text="*ERRO* NFEGeraEventoAutorizado() Status inválido pra autorização" />] + ::cXmlRetorno
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoNFe versao="1.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEvento versao="1.00">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEvento" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEvento>] // runner
   ::cXmlAutorizado += [</procEventoNFe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN NIL

