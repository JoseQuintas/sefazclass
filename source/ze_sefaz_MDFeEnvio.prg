#include "sefazclass.ch"

FUNCTION ze_Sefaz_MDFeEnvio( Self, cXml, cUF, cCertificado, cAmbiente )

   LOCAL oDoc, cBlocoXml, aList, nPos, cURLConsulta := "http:"

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::cProjeto := WS_PROJETO_MDFE
   // ---default s�ncrono 2024.07.01
   ::lEnvioSinc := .T.
   ::lEnvioZip  := .T.
   // ---fim default
   IF ::lEnvioSinc
      ::aSoapUrlList := SoapListSinc()
   ELSE
      ::aSoapUrlList := SoapList()
   ENDIF
   ::Setup( cUF, cCertificado, cAmbiente )

   IF cXml != NIL
      ::cXmlDocumento := cXml
   ENDIF
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   oDoc := XmlToDoc( cXml, .F. )
   aList := WS_MDFE_QRCODE
   nPos := hb_ASCan( aList, { | e | e[ 2 ] == ::cVersao + iif( oDoc:cAmbiente == "1", "P", "H" ) } )
   IF nPos != 0
      cURLConsulta := aList[ nPos, 3 ]
   ENDIF
   IF ! "<infMDFeSupl>" $ ::cXmlDocumento
      cBlocoXml := "<infMDFeSupl>"
      cBlocoXml += "<qrCodMDFe>"
      cBlocoXml += "<![CDATA["
      cBlocoXml += cURLConsulta + "?chMDFe=" + oDoc:cChave + "&" + "tpAmb=" + ::cAmbiente
      cBlocoXml += "]]>"
      cBlocoXml += "</qrCodMDFe>"
      cBlocoXml += "</infMDFeSupl>"
      ::cXmlDocumento := StrTran( ::cXmlDocumento, "</infMDFe>", "</infMDFe>" + cBlocoXml )
   ENDIF
   IF ::lEnvioSinc
      ::cXmlEnvio := ::cXmlDocumento
   ELSE
      ::cXmlEnvio  := [<enviMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
      ::cXmlEnvio  +=    XmlTag( "idLote", "1" )
      ::cXmlEnvio  +=    ::cXmlDocumento
      ::cXmlEnvio  += [</enviMDFe>]
   ENDIF
   ::XmlSoapPost()
   ::cXmlRecibo := ::cXmlRetorno
   IF ::lEnvioSinc
      ::cXmlProtocolo := ::cXmlRecibo
      ::MDFeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ELSE
      ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
      IF ::cStatus != "999"
         ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStatus" ), 3 )
         ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
      ENDIF
      IF ! Empty( ::cRecibo ) .AND. ::cStatus != "999"
         Inkey( ::nTempoEspera )
         ::MDFeRetEnvio()
         ::MDFeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

STATIC FUNCTION SoapList()

RETURN { ;
   ;
   { "**", "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx", "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao/mdfeRecepcaoLote" }, ;
   { "**", "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx", "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao/mdfeRecepcaoLote" } }

STATIC FUNCTION SoapListSinc()

RETURN { ;
   ;
   { "**", "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoSinc/MDFeRecepcaoSinc.asmx", "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoSinc/mdfeRecepcao" }, ;
   ;
   { "**", "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoSinc/MDFeRecepcaoSinc.asmx", "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoSinc/mdfeRecepcao" } }
