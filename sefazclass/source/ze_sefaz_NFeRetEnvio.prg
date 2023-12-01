#include "sefazclass.ch"

FUNCTION ze_Sefaz_NFeRetEnvio( Self, cRecibo, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   //mg aqui funcionou caindo nas duas condicoes
   //IF ::cUF $ "MA,MS,MT,PI,GO,MG"
   //   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/NFeRetAutorizacao"
   //ELSE
   //   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote"
   //ENDIF
   ::cXmlEnvio     := [<consReciNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio     += [</consReciNFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   IF "<infProt" $ ::cXmlRetorno
      ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSEIF ::cStatus != "999"
      ::cMotivo       := XmlNode( ::cXmlRetorno, "xMotivo" )
      ::cStatus       := XmlNode( ::cXmlRetorno, "cStat" )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "AM",    "4.00H", "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "BA",    "4.00H", "https://hnfe.sefaz.ba.gov.br/webservices/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "CE",    "4.00H", "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "GO",    "4.00H", "https://homolog.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MG",    "4.00H", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MS",    "4.00H", "https://hom.nfe.sefaz.ms.gov.br/ws/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MT",    "4.00H", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "PE",    "4.00H", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/NFeRetAutorizacaoLote" }, ;
   { "PR",    "4.00H", "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/NFeRetAutorizacaoLote" }, ;
   { "RS",    "4.00H", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SP",    "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVAN",  "4.00H", "https://hom.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVCAN", "4.00H", "https://hom.svc.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVCRS", "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVRS",  "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "GO",    "4.00HC", "https://homolog.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.sefaz.ms.gov.br/ws/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MT",    "4.00HC", "https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/NFeRetAutorizacaoLote" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   ;
   { "AM",    "4.00P", "https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "BA",    "4.00P", "https://nfe.sefaz.ba.gov.br/webservices/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "GO",    "4.00P", "https://nfe.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MG",    "4.00P", "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MS",    "4.00P", "https://nfe.sefaz.ms.gov.br/ws/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MT",    "4.00P", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "PE",    "4.00P", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/NFeRetAutorizacaoLote" }, ;
   { "PR",    "4.00P", "https://nfe.sefa.pr.gov.br/nfe/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/NFeRetAutorizacaoLote" }, ;
   { "RS",    "4.00P", "https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SP",    "4.00P", "https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVAN",  "4.00P", "https://www.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVCAN", "4.00P", "https://www.svc.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVCRS", "4.00P", "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVRS",  "4.00P", "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "GO",    "4.00PC", "https://nfe.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MG",    "4.00PC", "https://nfce.fazenda.mg.gov.br/nfce/services/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MS",    "4.00PC", "https://nfce.sefaz.ms.gov.br/ws/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "MT",    "4.00PC", "https://nfce.sefaz.mt.gov.br/nfcews/services/NfeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeRetAutorizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/NFeRetAutorizacaoLote" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4/nfeRetAutorizacaoLote" } }

