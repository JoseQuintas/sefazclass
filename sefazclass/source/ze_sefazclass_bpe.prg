/*
ZE_SEFAZCLASS_BPE - Rotinas pra BPE
*/

#include "hbclass.ch"
#include "sefazclass.ch"
#include "hb2xhb.ch"

CREATE CLASS SefazClass_BPE

   METHOD BPeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD BPeStatusServico( cUF, cCertificado, cAmbiente )
   METHOD SoapUrlBpe( aSoapList, cUF, cVersao )

   ENDCLASS

METHOD BPeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass_BPE

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
   ::cProjeto := WS_PROJETO_BPE
   ::aSoapUrlList := WS_BPE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cSoapAction  := "BpeConsulta"
   ::cSoapService := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP"

   ::cXmlEnvio := [<consSitBPe> versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=   XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=   XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio +=   XmlTag( "chBPe", cChave )
   ::cXmlEnvio += [</conssitBPe>]
   IF DfeModFis( cChave ) != "63"
      ::cXmlRetorno := [<erro text="*ERRO* BpeConsultaProtocolo() Chave não se refere a BPE" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD BPeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass_BPE

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
   ::cProjeto := WS_PROJETO_BPE
   ::aSoapUrlList := WS_BPE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "BpeStatusServicoBP"
   ::cSoapService := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico"

   ::cXmlEnvio := [<consStatServBPe versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServBPe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD SoapUrlBpe( aSoapList, cUF, cVersao ) CLASS SefazClass_bpe

   LOCAL nPos, cUrl

   nPos := hb_AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF

   RETURN cUrl

