#include "sefazclass.ch"

FUNCTION ze_Sefaz_NFeStatus( Self, cUF, cCertificado, cAmbiente, lContingencia )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   IF lContingencia != Nil
      ::lContingencia := lContingencia
   ENDIF
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )

   ::cXmlEnvio    := [<consStatServ versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
   ::XmlSoapPost()
   ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

FUNCTION ze_Sefaz_NFeStatusSVC( Self, cUF, cCertificado, cAmbiente )

   ze_Sefaz_NfeStatus( Self, cUF, cCertificado, cAmbiente, .T. )

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "AM",    "4.00H", "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "BA",    "4.00H", "https://hnfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "CE",    "4.00H", "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "GO",    "4.00H", "https://homolog.sefaz.go.gov.br/nfe/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MG",    "4.00H", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MS",    "4.00H", "https://hom.nfe.sefaz.ms.gov.br/ws/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MT",    "4.00H", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "PE",    "4.00H", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "PR",    "4.00H", "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "RS",    "4.00H", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SP",    "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVAN",  "4.00H", "https://hom.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVCAN", "4.00H", "https://hom.svc.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVCRS", "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVRS",  "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "AM",    "4.00HC", "https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "GO",    "4.00HC", "https://homolog.sefaz.go.gov.br/nfe/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.sefaz.ms.gov.br/ws/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MT",    "4.00HC", "https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   ;
   { "AM",    "4.00P", "https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "BA",    "4.00P", "https://nfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "GO",    "4.00P", "https://nfe.sefaz.go.gov.br/nfe/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MG",    "4.00P", "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MS",    "4.00P", "https://nfe.sefaz.ms.gov.br/ws/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MT",    "4.00P", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "PE",    "4.00P", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "PR",    "4.00P", "https://nfe.sefa.pr.gov.br/nfe/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "RS",    "4.00P", "https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SP",    "4.00P", "https://nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVAN",  "4.00P", "https://www.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVCAN", "4.00P", "https://www.svc.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVCRS", "4.00P", "https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVRS",  "4.00P", "https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "GO",    "4.00PC", "https://nfe.sefaz.go.gov.br/nfe/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MG",    "4.00PC", "https://nfce.fazenda.mg.gov.br/nfce/services/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MS",    "4.00PC", "https://nfce.sefaz.ms.gov.br/ws/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MS",    "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "MT",    "4.00PC", "https://nfce.sefaz.mt.gov.br/nfcews/services/NfeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeStatusServico4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4/nfeStatusServicoNF" } }
