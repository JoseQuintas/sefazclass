#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeRetEnvio( Self, cRecibo, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   ::aSoapUrlList := WS_CTE_RETAUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao/cteRetRecepcao"

   ::cXmlEnvio     := [<consReciCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec",  ::cRecibo )
   ::cXmlEnvio     += [</consReciCTe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno  // ? hb_Utf8ToStr()
   IF ::cStatus != "999"
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno // ? hb_Utf8ToStr()
