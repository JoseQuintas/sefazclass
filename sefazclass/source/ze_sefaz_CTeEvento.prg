#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEvento( Self, cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )

   LOCAL cCnpj

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := WS_CTE_ENVIAEVENTO
   IF ::cVersao == "3.00"
      ::cSoapAction:= "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento"
   ELSE
      ::cSoapAction:= "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento"
   ENDIF
   ::Setup( cChave, cCertificado, cAmbiente )
   cCnpj = DfeEmitente( cChave )
   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( Len( cCnpj ) == 11 , "CPF", "CNPJ" ), cCnpj )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       cXml
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoCTe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      IF ::cStatus != "999"
         ::CTeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

