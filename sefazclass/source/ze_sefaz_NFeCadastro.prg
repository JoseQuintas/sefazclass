#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeCadastro( Self, cCnpj, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   ::aSoapUrlList := WS_NFE_CONSULTACADASTRO
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

