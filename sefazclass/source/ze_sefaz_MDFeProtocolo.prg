#include "sefazclass.ch"

FUNCTION ze_Sefaz_MDFeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   ::aSoapUrlList := SoapList()
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta/mdfeConsultaMDF"

   ::cXmlEnvio := [<consSitMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio +=    XmlTag( "chMDFe", cChave )
   ::cXmlEnvio += [</consSitMDFe>]
   IF DfeModFis( cChave ) != "58"
      ::cXmlRetorno := [<erro text="*ERRO* MDFEProtocolo() Chave não se refere a MDFE" />]
   ELSE
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
   ENDIF
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" }, ;
   ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" } }

