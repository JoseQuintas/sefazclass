#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := SoapList()
   ::Setup( cChave, cCertificado, cAmbiente )
   IF ::cVersao == "3.00"
      ::cSoapAction := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta/cteConsultaCT"
   ELSE
      ::cSoapAction := "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT"
   ENDIF

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
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteConsulta" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteConsulta" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteConsulta" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteConsulta" }, ;
   { "SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteConsulta.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" }, ;
   ;
   { "PR",   "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteConsulta" }, ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" }, ;
   ;
   { "SP",   "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeConsultaV4.asmx" }, ;
   { "PR",   "4.00P", "https://cte.fazenda.pr.gov.br/cte4/CTeConsultaV4" }, ;
   ;
   { "SP",   "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeConsultaV4.asmx" }, ;
   { "PR",   "4.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte4/CTeConsultaV4" } }

