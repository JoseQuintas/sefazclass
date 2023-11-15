#include "sefazclass.ch"

FUNCTION ze_Sefaz_MDFeRetEnvio( Self, cRecibo, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   ::aSoapUrlList := WS_MDFE_RETAUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao/mdfeRetRecepcao"

   ::cXmlEnvio := [<consReciMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio += [</consReciMDFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   IF ::cStatus != "999"
      IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
         ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
         ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
      ELSE
         ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
         ::cMotivo  := XmlNode( ::cXmlRetorno, "xMotivo" )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

