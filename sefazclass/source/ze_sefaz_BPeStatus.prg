#include "sefazclass.ch"

FUNCTION ze_sefaz_BPeStatus( Self, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
   ::cProjeto := WS_PROJETO_BPE
   ::aSoapUrlList := WS_BPE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/BpeStatusServicoBP"

   ::cXmlEnvio := [<consStatServBPe versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServBPe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

