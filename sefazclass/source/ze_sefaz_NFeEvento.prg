#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEvento( Self, cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )

   LOCAL cCnpj

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   hb_Default( @nSequencia, 1 )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   IF ::cUF $ "MS"
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4/RecepcaoEvento"
   ELSE
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4/nfeRecepcaoEvento"
   ENDIF
   cCnpj := DfeEmitente( cChave )
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cXmlDocumento := [<evento versao="1.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( Len( cCnpj ) == 11, "CPF", "CNPJ" ), cCnpj )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       cXml
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NfeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

