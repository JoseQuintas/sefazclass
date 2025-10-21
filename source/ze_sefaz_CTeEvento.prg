#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEvento( Self, cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )

   LOCAL cCnpj

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := SoapList()
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
      IF ::nStatus != 999
         ::CTeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "MG",      "3.00H", "https://hcte.fazenda.mg.gov.br/cte/services/RecepcaoEvento", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "MS",      "3.00H", "https://homologacao.cte.ms.gov.br/ws/CteRecepcaoEvento", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "MT",      "3.00H", "https://homologacao.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "PR",      "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "RS/SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "SP/SVSP", "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   ;
   { "MG",      "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/RecepcaoEvento", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "MS",      "3.00P", "https://producao.cte.ms.gov.br/ws/CteRecepcaoEvento", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "MT",      "3.00P", "https://cte.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "PR",      "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento" }, ;
   { "RS/SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   { "SP/SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento/cteRecepcaoEvento" }, ;
   ;
   { "MG",      "4.00H", "https://hcte.fazenda.mg.gov.br/cte/services/CTeRecepcaoEventoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "MS",      "4.00H", "https://homologacao.cte.ms.gov.br/ws/CTeRecepcaoEventoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "MT",      "4.00H", "https://homologacao.sefaz.mt.gov.br/ctews2/services/CTeRecepcaoEventoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "PR",      "4.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte4/CTeRecepcaoEventoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "RS/SVRS", "4.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/CTeRecepcaoEventoV4/CTeRecepcaoEventoV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "SP/SVSP", "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoEventoV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   ;
   { "MG",      "4.00P", "https://cte.fazenda.mg.gov.br/cte/services/CTeRecepcaoEventoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "MS",      "4.00P", "https://producao.cte.ms.gov.br/ws/CTeRecepcaoEventoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "MT",      "4.00P", "https://cte.sefaz.mt.gov.br/ctews2/services/CTeRecepcaoEventoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "PR",      "4.00P", "https://cte.fazenda.pr.gov.br/cte4/CTeRecepcaoEventoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "RS/SVRS", "4.00P", "https://cte.svrs.rs.gov.br/ws/CTeRecepcaoEventoV4/CTeRecepcaoEventoV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" }, ;
   { "SP/SVSP", "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoEventoV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeRecepcaoEventoV4/cteRecepcaoEvento" } }
