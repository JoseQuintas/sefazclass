#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeDistribuicao( Self, cCnpj, cUltNSU, cNSU, cChave, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )
   hb_Default( @cChave, "" )
   hb_Default( @cUF, "" )

   ::cUF := "AN"
   ::aSoapUrlList := WS_NFE_DISTRIBUICAO
   ::Setup( "AN", cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe/nfeDistDFeInteresse"
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
   ELSEIF ! Empty( cNSU )
      ::cXmlEnvio +=   [<consNSU>]
      ::cXmlEnvio +=      XmlTag( "NSU", StrZero( Val( cNSU ), 15 ) )
      ::cXmlEnvio +=   [</consNSU>]
   ELSE
      ::cXmlEnvio +=   [<distNSU>]
      ::cXmlEnvio +=      XmlTag( "ultNSU", StrZero( Val( cUltNSU ), 15 ) )
      ::cXmlEnvio +=   [</distNSU>]
   ENDIF
   ::cXmlEnvio   += [</distDFeInt>]
   ::XmlSoapPost()
   IF ! Empty( XmlNode( ::cXmlRetorno, "cStat" ) )
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ENDIF

   RETURN ::cXmlRetorno

