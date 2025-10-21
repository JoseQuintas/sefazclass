#include "sefazclass.ch"

FUNCTION ze_sefaz_BPeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
   ::cProjeto := WS_PROJETO_BPE
   ::aSoapUrlList := SoapList()
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlEnvio := [<consSitBPe> versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=   XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=   XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio +=   XmlTag( "chBPe", cChave )
   ::cXmlEnvio += [</conssitBPe>]
   IF DfeModFis( cChave ) != "63"
      ::cXmlRetorno := [<erro text="*ERRO* BpeProtocolo() Chave não se refere a BPE" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   IF ::nStatus != 999
      ::nStatus := Val( XmlNode( ::cXmlRetorno, "cStat" ) )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "MG", "1.00H", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
   { "MS", "1.00H", "https://homologacao.bpe.ms.gov.br/ws/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
   { "MT", "1.00H", "https://homologacao.sefaz.mt.gov.br/bpe-ws/services/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
   { "PR", "1.00H", "https://homologacao.bpe.fazenda.pr.gov.br/bpe/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsultaBP/bpeConsultaBP" }, ;
   { "RS/SVRS", "1.00H", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeConsulta/bpeConsulta.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
   { "SP", "1.00H", "https://homologacao.bpe.fazenda.sp.gov.br/BPeWeb/services/BPeConsulta.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
   ;
   { "MG", "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
   { "MS", "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP"}, ;
   { "MS", "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
   { "MT", "1.00P", "https://www.sefaz.mt.gov.br/bpe-ws/services/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
   { "PR", "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BPeConsulta", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsultaBP/bpeConsultaBP" }, ;
   { "RS/SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ws/bpeConsulta/bpeConsulta.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP"}, ;
   { "SP", "1.00P", "https://bpe.fazenda.sp.gov.br/BPeWeb/services/BPeConsulta.asmx", "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" } }
