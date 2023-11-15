#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeGTIN( Self, cGTIN, cCertificado )

   ::cProjeto     := WS_PROJETO_NFE
   ::aSoapUrlList := WS_NFE_CONSULTAGTIN
   ::cVersao      := "1.00"
   ::Setup( ::cUF, cCertificado )
   ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/ccgConsGtin/ccgConsGTIN"

   ::cXmlEnvio := [<consGTIN versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio += [<GTIN>] + AllTrim( cGTIN ) + [</GTIN>]
   ::cXmlEnvio += [</consGTIN>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

