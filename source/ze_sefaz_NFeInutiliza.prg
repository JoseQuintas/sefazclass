#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeInutiliza( Self, cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, ;
   cJustificativa, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   //IF ::cUF $ "NA,MS,MT,SP,PI,GO,MG"
   //   ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/NfeInutilizacao"
   //ELSE
   //   ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF"
   //ENDIF

   ::cXmlDocumento := [<inutNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infInut Id="ID] + ::UFCodigo( ::cUF ) + Right( cAno, 2 ) + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDocumento +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDocumento +=       XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDocumento +=       XmlTag( "ano", Right( cAno, 2 ) )
   ::cXmlDocumento +=       XmlTag( "CNPJ", SoNumero( cCnpj ) )
   ::cXmlDocumento +=       XmlTag( "mod", cMod )
   ::cXmlDocumento +=       XmlTag( "serie", cSerie )
   ::cXmlDocumento +=       XmlTag( "nNFIni", cNumIni )
   ::cXmlDocumento +=       XmlTag( "nNFFin", cNumFim )
   ::cXmlDocumento +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDocumento +=    [</infInut>]
   ::cXmlDocumento += [</inutNFe>]

   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      IF ::cStatus != "999"
         ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
         ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      ENDIF
      IF ::cStatus == "102"
         ::cXmlAutorizado := XML_UTF8
         ::cXmlAutorizado += [<ProcInutNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
         ::cXmlAutorizado += ::cXmlDocumento
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno, "retInutNFe", .T. )
         ::cXmlAutorizado += [</ProcInutNFe>]
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "AM",    "4.00H", "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "BA",    "4.00H", "https://hnfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "CE",    "4.00H", "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "GO",    "4.00H", "https://homolog.sefaz.go.gov.br/nfe/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MG",    "4.00H", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MS",    "4.00H", "https://hom.nfe.sefaz.ms.gov.br/ws/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MT",    "4.00H", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "PE",    "4.00H", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "PR",    "4.00H", "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "RS",    "4.00H", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SP",    "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVAN",  "4.00H", "https://hom.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVCRS", "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVRS",  "4.00H", "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfce.sefaz.am.gov.br/nfce-services/services/NfeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "GO",    "4.00HC", "https://homolog.sefaz.go.gov.br/nfe/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.sefaz.ms.gov.br/ws/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MT",    "4.00HC", "https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeInutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   ;
   { "AM",    "4.00P", "https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "BA",    "4.00P", "https://nfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "GO",    "4.00P", "https://nfe.sefaz.go.gov.br/nfe/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MG",    "4.00P", "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MS",    "4.00P", "https://nfe.sefaz.ms.gov.br/ws/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MT",    "4.00P", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "PE",    "4.00P", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "PR",    "4.00P", "https://nfe.sefa.pr.gov.br/nfe/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "RS",    "4.00P", "https://nfe.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SP",    "4.00P", "https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVAN",  "4.00P", "https://www.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVCAN", "4.00P", "https://www.svc.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVCRS", "4.00P", "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVRS",  "4.00P", "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "GO",    "4.00PC", "https://nfe.sefaz.go.gov.br/nfe/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MG",    "4.00PC", "https://nfce.fazenda.mg.gov.br/nfce/services/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MS",    "4.00PC", "https://nfce.sefaz.ms.gov.br/ws/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "MT",    "4.00PC", "https://nfce.sefaz.mt.gov.br/nfcews/services/NfeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeInutilizacao4", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeInutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4/nfeInutilizacaoNF" } }
