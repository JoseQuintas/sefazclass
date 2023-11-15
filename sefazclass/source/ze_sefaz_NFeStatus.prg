#include "sefazclass.ch"

FUNCTION ze_Sefaz_NFeStatus( Self, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   ::aSoapUrlList := WS_NFE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cUF $ 'MA,MS,MT,PI,GO,MG' .and. ::cNFCE == "S"
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4NfeStatusServico"
    ELSE
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4nfeStatusServicoNF"
   ENDIF

   ::cXmlEnvio    := [<consStatServ versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
   ::XmlSoapPost()
   ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )

   RETURN ::cXmlRetorno

FUNCTION ze_Sefaz_NFeStatusSVC( Self, cUF, cCertificado, cAmbiente, lSVCAN )

   LOCAL cVersao

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE

   cVersao := ::cVersao + iif( ::cAmbiente == WS_AMBIENTE_PRODUCAO, "P", "H" )

   ::aSoapUrlList := WS_NFE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/NfeStatusServico"

   IF lSVCAN
      ::cSoapURL  := ::SoapUrlNFe( ::aSoapUrlList, "SVCAN", cVersao )
   ELSE
      ::cSoapURL  := ::SoapURLNfe( ::aSoapUrlList, "SVCRS", cVersao )
   ENDIF

   ::cXmlEnvio    := [<consStatServ versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

