#include "sefazclass.ch"

FUNCTION ze_Sefaz_MDFeStatus( Self, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico/mdfeStatusServicoMDF"

   ::cXmlEnvio := [<consStatServMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   //::cXmlEnvio += XmlTag( "cUF", ::UFCodigo( ::cUF ) ) // MDFE não importa UF
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServMDFe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" }, ;
   ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" } }

