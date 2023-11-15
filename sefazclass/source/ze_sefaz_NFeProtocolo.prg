#include "sefazclass.ch"

FUNCTION ze_Sefaz_NFeProtocolo( Self, cChave, cCertificado, cAmbiente )

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_CONSULTAPROTOCOLO
   ::aSoapUrlList := WS_NFE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   DO CASE
   CASE ::cUF $ "AC,AL,AP,DF,ES,GO,MA,MG,MS,MT,PB,PE,PI,RJ,RN,RO,RR,SC,SE,TO"
      IF ::cUF == "MS" .AND. DfeModFis( cChave ) == "65"
         ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/NfeConsultaProtocolo"
      ELSE
         ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4/nfeConsultaNF"
      ENDIF
   OTHERWISE
      ::cSoapAction := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaProtocolo4/nfeConsultaNF"
   ENDCASE
   ::cXmlEnvio    := [<consSitNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chNFe", cChave )
   ::cXmlEnvio    += [</consSitNFe>]
   IF ! DfeModFis( cChave ) $ "55,65"
      ::cStatus     := "999"
      ::cMotivo     := "Chave não se refere a NFE/NFCE"
      ::cXmlRetorno := [<erro text="*ERRO* NfeConsultaProtocolo() ] + ::cMotivo + [" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

