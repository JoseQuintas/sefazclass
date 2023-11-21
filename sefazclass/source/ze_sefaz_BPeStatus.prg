#include "sefazclass.ch"

FUNCTION ze_sefaz_BPeStatus( Self, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
   ::cProjeto := WS_PROJETO_BPE
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/BpeStatusServicoBP"

   ::cXmlEnvio := [<consStatServBPe versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServBPe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/BPeStatusServico" }, ;
   { "MS",   "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeStatusServico" }, ;
   { "PR",   "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BPeStatusServico" }, ;
   { "SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ms/bpeStatusServico/bpeStatusServico.asmx" }, ;
   ;
   { "MS",   "1.00H", "https://homologacao.bpe.ms.gov.br/ws/BPeStatusServico" }, ;
   { "SVRS", "1.00H", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx" } }
