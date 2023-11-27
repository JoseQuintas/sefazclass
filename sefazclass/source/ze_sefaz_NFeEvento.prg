#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEvento( Self, cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente, cCnpj )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   hb_Default( @nSequencia, 1 )
   ::lConsumidor := ( DfeModFis( cChave ) == "65" )
   ::aSoapUrlList := SoapList()
   IF ::cUF == "AN"
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4/nfeRecepcaoEventoNF"
   ELSEIF ::cUF $ "MA,MS,MT,PI,GO,MG"
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4/RecepcaoEvento"
   ELSE
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4/nfeRecepcaoEvento"
   ENDIF
   IF cCnpj == Nil
      cCnpj := DfeEmitente( cChave )
   ENDIF
   ::Setup( iif( ::cUF == "AN", "AN", cChave ), cCertificado, cAmbiente )
   ::cXmlDocumento := [<evento versao="1.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", iif( ::cUF == "AN", "91", Substr( cChave, 1, 2 ) ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( Len( cCnpj ) == 11, "CPF", "CNPJ" ), cCnpj )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       cXml
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NfeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "AN",    "4.00H",  "https://hom1.nfe.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "AM",    "4.00H",  "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4" }, ;
   { "BA",    "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "CE",    "4.00H",  "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeRecepcaoEvento4" }, ;
   { "GO",    "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4" }, ;
   { "MG",    "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4" }, ;
   { "MS",    "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" }, ;
   { "MT",    "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento4" }, ;
   { "PE",    "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento4" }, ;
   { "PR",    "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeRecepcaoEvento4" }, ;
   { "RS",    "4.00H",  "https://nfe-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SP",    "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx" }, ;
   { "SVAN",  "4.00H",  "https://hom.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "SVCAN", "4.00H",  "https://hom.svc.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "SVCRS", "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SVRS",  "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeRecepcaoEvento4" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeRecepcaoEvento4.asmx" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   ;
   { "AN",    "4.00P",  "https://www.nfe.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "AM",    "4.00P",  "https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4" }, ;
   { "BA",    "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "CE",    "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/NFeRecepcaoEvento4" }, ;
   { "GO",    "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4" }, ;
   { "MG",    "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4" }, ;
   { "MS",    "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" }, ;
   { "MT",    "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento4" }, ;
   { "PE",    "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeRecepcaoEvento4" }, ;
   { "PR",    "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/NFeRecepcaoEvento4" }, ;
   { "RS",    "4.00P",  "https://nfe.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SP",    "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx" }, ;
   { "SVAN",  "4.00P",  "https://www.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "SVCAN", "4.00P",  "https://www.svc.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "SVCRS", "4.00P",  "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SVRS",  "4.00P",  "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/RecepcaoEvento4" }, ;
   { "MS",    "4.00PC", "https://nfce.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" }, ;
   { "MT",    "4.00PC", "https://nfce.sefaz.mt.gov.br/nfcews/services/RecepcaoEvento4" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeRecepcaoEvento4" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeRecepcaoEvento4.asmx" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "MG",    "4.00PC", "https://nfce.fazenda.mg.gov.br/nfce/services/NFeRecepcaoEvento4" } }
