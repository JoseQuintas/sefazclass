#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeDistribuicao( Self, cCnpj, nUltNSU, nNSU, cChave, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   hb_Default( @nUltNSU, 0 )
   hb_Default( @nNSU, 0 )
   hb_Default( @cChave, "" )
   hb_Default( @cUF, "" )

   ::cUF := "AN"
   ::aSoapUrlList := SoapList()
   ::Setup( "AN", cCertificado, cAmbiente )
   ::cXmlEnvio    := [<distDFeInt ] + WS_XMLNS_NFE + [ versao="1.01">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   IF ! Empty( cUF )
      ::cXmlEnvio    +=    XmlTag( "cUFAutor", ::UFCodigo( cUF ) )
   ENDIF
   IF ValidCnpj( cCnpj )
      cCnpj := StrZero( Val( cCnpj ), 14 )
   ELSE
      cCnpj := StrZero( Val( cCnpj ), 11 )
   ENDIF
   ::cXmlEnvio    +=    XmlTag( iif( Len( cCnpj ) == 11, "CPF", "CNPJ" ), cCnpj )
   IF ! Empty( cChave )
      ::cXmlEnvio += [<consChNFe>]
      ::cXmlEnvio +=    XmlTag( "chNFe", cChave )
      ::cXmlEnvio += [</consChNFe>]
   ELSEIF nNSU != 0
      ::cXmlEnvio +=   [<consNSU>]
      ::cXmlEnvio +=      XmlTag( "NSU", StrZero( nNSU, 15 ) )
      ::cXmlEnvio +=   [</consNSU>]
   ELSE
      ::cXmlEnvio +=   [<distNSU>]
      ::cXmlEnvio +=      XmlTag( "ultNSU", StrZero( nUltNSU, 15 ) )
      ::cXmlEnvio +=   [</distNSU>]
   ENDIF
   ::cXmlEnvio   += [</distDFeInt>]
   ::XmlSoapPost()
   IF ! Empty( XmlNode( ::cXmlRetorno, "cStat" ) )
      ::nStatus := Val( XmlNode( ::cXmlRetorno, "cStat" ) )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "AN", "3.10H", "https://hom1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe/nfeDistDFeInteresse" }, ;
   ;
   { "AN", "3.10P", "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe/nfeDistDFeInteresse" }, ;
   ;
   { "AN", "4.00H", "https://hom1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe/nfeDistDFeInteresse" }, ;
   ;
   { "AN", "4.00P", "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe/nfeDistDFeInteresse" } }
