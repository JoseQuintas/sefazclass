#include "sefazclass.ch"

FUNCTION ze_Sefaz_NFeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   ::lConsumidor := ( DfeModFis( cChave ) == "65" )
   ::aSoapUrlList := SoapList()
   ::Setup( cChave, cCertificado, cAmbiente )
   //DO CASE
   //CASE ::cUF $ "AC,AL,AP,DF,ES,GO,MA,MG,MS,MT,PB,PE,PI,RJ,RN,RO,RR,SC,SE,TO"
   //   IF ::cUF == "MS" .AND. DfeModFis( cChave ) == "65"
   //      ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/NfeConsultaProtocolo"
   //   ELSE
   //      ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF"
   //   ENDIF
   //OTHERWISE
   //   ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaProtocolo4/nfeConsultaNF"
   //ENDCASE
   ::cXmlEnvio    := [<consSitNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chNFe", cChave )
   ::cXmlEnvio    += [</consSitNFe>]
   IF ! DfeModFis( cChave ) $ "55,65"
      ::cStatus     := "999"
      ::cMotivo     := "Chave não se refere a NFE/NFCE"
      ::cXmlRetorno := [<erro text="*ERRO* NfeConsultaProtocolo() ] + ::cMotivo + [" />]
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
   { "AM",    "4.00H", "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "BA",    "4.00H", "https://hnfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "CE",    "4.00H", "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "GO",    "4.00H", "https://homolog.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MG",    "4.00H", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MS",    "4.00H", "https://hom.nfe.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MT",    "4.00H", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "PE",    "4.00H", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "PR",    "4.00H", "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "RS",    "4.00H", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SP",    "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVAN",  "4.00H", "https://hom.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVCAN", "4.00H", "https://hom.svc.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVCRS", "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVRS",  "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeConsulta4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "GO",    "4.00HC", "https://homolog.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MT",    "4.00HC", "https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeConsulta4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   ;
   { "AM",    "4.00P", "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "BA",    "4.00P", "https://nfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "GO",    "4.00P", "https://nfe.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MG",    "4.00P", "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MS",    "4.00P", "https://nfe.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MT",    "4.00P", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "PE",    "4.00P", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "PR",    "4.00P", "https://nfe.sefa.pr.gov.br/nfe/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "RS",    "4.00P", "https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SP",    "4.00P", "https://nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVAN",  "4.00P", "https://www.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVCAN", "4.00P", "https://www.svc.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVCRS", "4.00P", "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVRS",  "4.00P", "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeConsulta4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "GO",    "4.00PC", "https://nfe.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MG",    "4.00PC", "https://nfce.fazenda.mg.gov.br/nfce/services/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MS",    "4.00PC", "https://nfce.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "MT",    "4.00PC", "https://nfce.sefaz.mt.gov.br/nfcews/services/NfeConsulta4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF" } }
