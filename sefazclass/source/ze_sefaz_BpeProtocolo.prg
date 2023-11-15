#include "sefazclass.ch"

FUNCTION ze_sefaz_BPeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
   ::cProjeto := WS_PROJETO_BPE
   ::aSoapUrlList := WS_BPE_CONSULTAPROTOCOLO
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

