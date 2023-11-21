#include "sefazclass.ch"

FUNCTION ze_sefaz_BPeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
   ::cProjeto := WS_PROJETO_BPE
   ::aSoapUrlList := SoapList()
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cSoapAction  := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP/BpeConsulta"

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
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

   RETURN { ;
   ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeConsulta" }, ;
   { "MS",   "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta" }, ;
   { "PR",   "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BpeConsulta" }, ;
   { "SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ms/bpeConsulta.asmx" }, ;
   ;
   { "MS",   "1.00H", "https://homologacao.bpe.ms.gov.br/ws/BPeConsulta" } }

