#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeCadastro( Self, cCnpj, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cUF $ "AM,BA,MG,PE"
      ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2/CadConsultaCadastro2"
   ELSE
      ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro4/consultaCadastro"
   ENDIF

   ::cXmlEnvio    := [<ConsCad versao="2.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    [<infCons>]
   ::cXmlEnvio    +=       XmlTag( "xServ", "CONS-CAD" )
   ::cXmlEnvio    +=       XmlTag( "UF", ::cUF )
   ::cXmlEnvio    +=       XmlTag( "CNPJ", cCNPJ )
   ::cXmlEnvio    +=    [</infCons>]
   ::cXmlEnvio    += [</ConsCad>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "MG",   "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
   { "BA",   "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx" }, ;
   { "CE",   "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/CadConsultaCadastro4" }, ;
   { "GO",   "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4" }, ;
   { "MS",   "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4" }, ;
   { "MT",   "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro4" }, ;
   { "PE",   "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro4" }, ;
   { "PR",   "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/CadConsultaCadastro4" }, ;
   { "RS",   "4.00P",  "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx" }, ;
   { "SP",   "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro4.asmx" }, ;
   { "SVRS", "4.00P",  "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx" }, ;
   ;
   { "MS",   "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/CadConsultaCadastro4" }, ;
   { "PR",   "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/CadConsultaCadastro4" }, ;
   ;
   { "MS",   "4.00HC", "https://homologacao.nfce.fazenda.ms.gov.br/ws/CadConsultaCadastro4" }, ;
   { "PR",   "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/CadConsultaCadastro4" }, ;
   ;
   { "AM",   "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx" }, ;
   { "BA",   "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx" }, ;
   { "GO",   "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4" }, ;
   { "MG",   "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
   { "MS",   "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4" }, ;
   { "MT",   "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro4" }, ;
   { "PE",   "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro4" }, ;
   { "PR",   "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/CadConsultaCadastro4" }, ;
   { "SP",   "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/cadconsultacadastro4.asmx" } }
