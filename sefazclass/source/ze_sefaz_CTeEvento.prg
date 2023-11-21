#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEvento( Self, cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )

   LOCAL cCnpj

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := SoapList()
   IF ::cVersao == "3.00"
      ::cSoapAction:= "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento"
   ELSE
      ::cSoapAction:= "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento"
   ENDIF
   ::Setup( cChave, cCertificado, cAmbiente )
   cCnpj = DfeEmitente( cChave )
   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, ;
      iif( ::cVersao == "3.00", 2, 3 ) ) + [">]
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

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/RecepcaoEvento" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteRecepcaoEvento" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
   { "PR",   "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" }, ;
   ;
   { "SP",   "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoEventoV4.asmx" }, ;
   { "PR",   "4.00P", "https://cte.fazenda.pr.gov.br/cte4/CTeRecepcaoEventoV4" }, ;
   ;
   { "SP",   "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoEventoV4.asmx" }, ;
   { "PR",   "4.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte4/CTeRecepcaoEventoV4" } }

