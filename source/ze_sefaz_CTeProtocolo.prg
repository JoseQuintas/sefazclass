#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := SoapList()
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlEnvio    := [<consSitCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chCTe", cChave )
   ::cXmlEnvio    += [</consSitCTe>]
   IF ! DfeModFis( cChave ) $ "57,67"
      ::cXmlRetorno := [<erro text="*ERRO* CteProtocolo() Chave não se refere a CTE" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "MG",      "3.00H", "https://hcte.fazenda.mg.gov.br/cte/services/CteConsulta", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "MS",      "3.00H", "https://homologacao.cte.ms.gov.br/ws/CteConsulta", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "MT",      "3.00H", "https://homologacao.sefaz.mt.gov.br/ctews/services/CteConsulta", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "PR",      "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteConsulta", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "RS/SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "SP/SVSP", "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   ;
   { "MG",      "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteConsulta", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "MS",      "3.00P", "https://producao.cte.ms.gov.br/ws/CteConsulta", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "MT",      "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteConsulta", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "PR",      "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteConsulta", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "RS/SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   { "SP/SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT" }, ;
   ;
   { "MG",      "4.00H", "https://hcte.fazenda.mg.gov.br/cte/services/CTeConsultaV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "MS",      "4.00H", "https://homologacao.cte.ms.gov.br/ws/CTeConsultaV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "MT",      "4.00H", "https://homologacao.sefaz.mt.gov.br/ctews2/services/CTeConsultaV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "PR",      "4.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte4/CTeConsultaV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "RS/SVRS", "4.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/CTeConsultaV4/CTeConsultaV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "SP/SVSP", "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeConsultaV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   ;
   { "MS",      "4.00P", "https://producao.cte.ms.gov.br/ws/CTeConsultaV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "MT",      "4.00P", "https://cte.sefaz.mt.gov.br/ctews2/services/CTeConsultaV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "PR",      "4.00P", "https://cte.fazenda.pr.gov.br/cte4/CTeConsultaV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "RS/SVRS", "4.00P", "https://cte.svrs.rs.gov.br/ws/CTeConsultaV4/CTeConsultaV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "SP/SVSP", "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeConsultaV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" } }
