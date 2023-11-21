#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeStatus( Self, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   ::cProjeto := WS_PROJETO_CTE
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.00"
      ::cSoapAction  := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico/cteStatusServicoCT"
      ::cXmlEnvio    := [<consStatServCte versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
      ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
      ::cXmlEnvio    += [</consStatServCte>]
   ELSE
      ::cSoapAction  := "http://www.portalfiscal.inf.br/cte/wsdl/CTeStatusServicoV4/cteStatusServicoCT"
      ::cXmlEnvio    := [<consStatServCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
      ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
      ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
      ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
      ::cXmlEnvio    += [</consStatServCTe>]
   ENDIF

   ::XmlSoapPost()

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteStatusServico" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteStatusServico" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteStatusServico" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteStatusServico" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
   { "SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteStatusServico.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
   { "PR",   "3.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte/CteStatusServico" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" }, ;
   ;
   { "SP",   "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeStatusServicoV4.asmx" }, ;
   { "PR",   "4.00P", "https://cte.fazenda.pr.gov.br/cte4/CTeStatusServicoV4" }, ;
   ;
   { "SP",   "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeStatusServicoV4.asmx" }, ;
   { "PR",   "4.00H", "https://homologacao.cte.fazenda.pr.gov.br/cte4/CTeStatusServicoV4" } }

