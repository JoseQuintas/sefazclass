#include "sefazclass.ch"

FUNCTION ze_sefaz_MDFeEvento( Self, cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )

   LOCAL cCnpj

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cProjeto := WS_PROJETO_MDFE

   ::aSoapUrlList := SoapList()
   ::cSoapAction  := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento/mdfeRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )
   cCnpj := DfeEmitente( cChave )
   ::cXmlDocumento := [<eventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( Len( cCnpj ) == 11, "CPF", "CNPJ" ), cCnpj )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       cXml
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoMDFe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::MDFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" }, ;
   ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" } }


