#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeGTIN( Self, cGTIN, cCertificado )

   ::cProjeto     := WS_PROJETO_NFE
   ::aSoapUrlList := SoapList()
   ::cVersao      := "1.00"
   ::Setup( ::cUF, cCertificado )
   ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/ccgConsGtin/ccgConsGTIN"

   ::cXmlEnvio := [<consGTIN versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio += [<GTIN>] + AllTrim( cGTIN ) + [</GTIN>]
   ::cXmlEnvio += [</consGTIN>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "**", "1.00P", "https://dfe-servico.svrs.rs.gov.br/ws/ccgConsGTIN/ccgConsGTIN.asmx" } }
