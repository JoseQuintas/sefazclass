#include "sefazclass.ch"

FUNCTION ze_sefaz_MDFeDistribuicao( Self, cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )
   ::cProjeto := WS_PROJETO_MDFE

   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/nfe/wsdl/MDFeDistribuicaoDFe/mdfeDistDFeInteresse"

   ::cXmlEnvio    := [<distDFeInt versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUFAutor", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "CNPJ", cCnpj )
   IF Empty( cNSU )
      ::cXmlEnvio +=   [<distNSU>]
      ::cXmlEnvio +=      XmlTag( "ultNSU", cUltNSU )
      ::cXmlEnvio +=   [</distNSU>]
   ELSE
      ::cXmlEnvio +=   [<consNSU>]
      ::cXmlEnvio +=      XmlTag( "NSU", cNSU )
      ::cXmlEnvio +=   [</consNSU>]
   ENDIF
   ::cXmlEnvio    += [</distDFeInt>]
   ::XmlSoapPost()
   // UltNSU = ultimo NSU pesquisado
   // maxUSU = número máximo existente
   // docZIP = Documento em formato ZIP
   // NSU    = NSU do documento fiscal
   // schema = schemma de validação do XML anexado ex. procMDFe_v1.00.xsd, procEventoMDFe_V1.00.xsd

   RETURN NIL

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/WS/MDFeDistribuicaoDFe/MDFeDistribuicaoDFe.asmx" } }

