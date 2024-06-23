#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeDestinadas( Self, cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente )

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cIndNFe, "0" )
   hb_Default( @cIndEmi, "0" )

   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )

   ::cXmlEnvio    := [<consNFeDest versao="] + ::cVersao + [">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR NFE DEST" )
   ::cXmlEnvio    +=    XmlTag( "CNPJ", SoNumero( cCnpj ) )
   ::cXmlEnvio    +=    XmlTag( "indNFe", "0" ) // 0=todas,1=sem manif,2=sem nada
   ::cXmlEnvio    +=    XmlTag( "indEmi", "0" ) // 0=todas, 1=sem cnpj raiz(sem matriz/filial)
   ::cXmlEnvio    +=    XmlTag( "ultNSU", cUltNsu )
   ::cXmlEnvio    += [</consNFeDest>]

   ::XmlSoapPost()

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "RS",   "3.10P", "https://nfe.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest/nfeConsultaNFDest" }, ;
   { "AN",   "3.10P", "https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest/nfeConsultaNFDest" }, ;
   ;
   { "RS",   "3.10H", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest/nfeConsultaNFDest" } }
