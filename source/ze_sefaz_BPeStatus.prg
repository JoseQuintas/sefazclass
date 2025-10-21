#include "sefazclass.ch"

FUNCTION ze_sefaz_BPeStatus( Self, cUF, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
   ::cProjeto := WS_PROJETO_BPE
   ::aSoapUrlList := SoapList()
   ::Setup( cUF, cCertificado, cAmbiente )

   ::cXmlEnvio := [<consStatServBPe versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServBPe>]
   ::XmlSoapPost()
   ::nStatus := Val( XmlNode( ::cXmlRetorno, "cStat" ) )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   { "MS", "1.00H", "https://homologacao.bpe.ms.gov.br/ws/BPeStatusServico", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "MT", "1.00H", "https://homologacao.sefaz.mt.gov.br/bpe-ws/services/BPeStatusServico", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "PR", "1.00H", "https://homologacao.bpe.fazenda.pr.gov.br/bpe/BPeStatusServico", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "RS/SVRS", "1.00H", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "SP", "1.00H", "https://homologacao.bpe.fazenda.sp.gov.br/BPeWeb/services/BPeStatusServico.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "SVRS", "1.00H", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   ;
   { "MG", "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeStatusServico", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "MS", "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeStatusServico", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "MT", "1.00P", "https://www.sefaz.mt.gov.br/bpe-ws/services/BPeStatusServico", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "PR", "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BPeStatusServico", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "RS/SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" }, ;
   { "SP", "1.00P", "https://bpe.fazenda.sp.gov.br/BPeWeb/services/BPeStatusServico.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico/bpeStatusServicoBP" } }

