#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeStatus( Self, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.00"
      ::cXmlEnvio    := [<consStatServCte versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
      ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
      ::cXmlEnvio    += [</consStatServCte>]
   ELSE
      ::cXmlEnvio    := [<consStatServCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
      ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
      ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
      ::cXmlEnvio    += [</consStatServCTe>]
   ENDIF

   ::XmlSoapPost()
   ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "MG",      "3.00H", "https://hcte.fazenda.mg.gov.br/cte/services/CteStatusServico", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "MS",      "3.00H", "https://homologacao.cte.ms.gov.br/ws/CteStatusServico", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "MT",      "3.00H", "https://homologacao.sefaz.mt.gov.br/ctews/services/CteStatusServico", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "PR",      "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteStatusServico", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "RS/SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "SP/SVSP", "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   ;
   { "MG",      "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteStatusServico", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "MS",      "3.00P", "https://producao.cte.ms.gov.br/ws/CteStatusServico", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "MT",      "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteStatusServico", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "PR",      "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteStatusServico", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "RS/SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   { "SP/SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT" }, ;
   ;
   { "MG",      "4.00H", "https://hcte.fazenda.mg.gov.br/cte/services/CTeStatusServicoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "MS",      "4.00H", "https://homologacao.cte.ms.gov.br/ws/CTeStatusServicoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "MT",      "4.00H", "https://homologacao.sefaz.mt.gov.br/ctews2/services/CTeStatusServicoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "PR",      "4.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte4/CTeStatusServicoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "RS/SVRS", "4.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/CTeStatusServicoV4/CTeStatusServicoV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "SP/SVSP", "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeStatusServicoV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   ;
   { "MG",      "4.00P", "https://cte.fazenda.mg.gov.br/cte/services/CTeConsultaV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeConsultaV4/cteConsultaCT" }, ;
   { "MS",      "4.00P", "https://producao.cte.ms.gov.br/ws/CTeStatusServicoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "MT",      "4.00P", "https://cte.sefaz.mt.gov.br/ctews2/services/CTeStatusServicoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "PR",      "4.00P", "https://cte.fazenda.pr.gov.br/cte4/CTeStatusServicoV4", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "RS/SVRS", "4.00P", "https://cte.svrs.rs.gov.br/ws/CTeStatusServicoV4/CTeStatusServicoV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" }, ;
   { "SP/SVSP", "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeStatusServicoV4.asmx", "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT" } }

