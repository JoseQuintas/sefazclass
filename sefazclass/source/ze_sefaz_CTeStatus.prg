#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeStatus( Self, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := WS_CTE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.00"
      ::cSoapAction  := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT"
      ::cXmlEnvio    := [<consStatServCte versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
      ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
      ::cXmlEnvio    += [</consStatServCte>]
   ELSE
      ::cSoapAction  := "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT"
      ::cXmlEnvio    := [<consStatServCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
      ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
      ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
      ::cXmlEnvio    += [</consStatServCTe>]
   ENDIF

   ::XmlSoapPost()

   RETURN ::cXmlRetorno

