#include "hbclass.ch"
#include "sefazclass.ch"

PROCEDURE Main

   LOCAL cChave   := "1.2.201709.0000000000000225594"
   LOCAL oESocial := ESocialClass():New()

   oESocial:cCertificado := "XXX"
   ? oESocial:ConsultaRetornoLote(  cChave )

   RETURN

CREATE CLASS ESocialClass

   VAR    cCertificado   INIT ""
   VAR    cUrl           INIT ""
   VAR    cSoapAction    INIT ""
   VAR    cXmlDocumento  INIT ""
   VAR    cXmlEnvelope   INIT ""
   VAR    cXmlRetorno    INIT ""
   METHOD ConsultaRetornoLote( cChave, cCertificado )
   METHOD MicrosoftXmlSoapPost()

   ENDCLASS

METHOD ConsultaRetornoLote( cChave, cCertificado ) CLASS ESocialClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   ::cUrl          := "https://webservices.producaorestrita.esocial.gov.br/servicos/empregador/consultarloteeventos/WsConsultarLoteEventos.svc"
   ::cSOAPAction   := "http://www.esocial.gov.br/servicos/empregador/lote/eventos/envio/consulta/retornoProcessamento/v1_1_0/ServicoConsultarLoteEventos/ConsultarLoteEventos"
   ::cXmlDocumento := ;
      [<eSocial xmlns="http://www.esocial.gov.br/schema/lote/eventos/envio/consulta/retornoProcessamento/v1_0_0">] + ;
         [<consultaLoteEventos>] + ;
            [<protocoloEnvio>] + cChave + [</protocoloEnvio>] + ;
         [</consultaLoteEventos>] + ;
      [</eSocial>]
   ::cXmlEnvelope := XML_UTF8 + ;
      [<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ] + ;
         [xmlns:v1="http://www.esocial.gov.br/servicos/empregador/lote/eventos/envio/consulta/retornoProcessamento/v1_1_0">] + ;
         [<soapenv:Header/>] + ;
         [<soapenv:Body>] + ;
            [<consultaLoteEventos>] + ;
               [<consulta>] + ::cXmlDocumento + [</consulta>] + ;
            [</consultaLoteEentos>] + ;
         [</soapenv:Body>] + ;
      [</soapenv:Envelope>]
   ::MicrosoftXmlSoapPost()

   RETURN ::cXmlRetorno

METHOD MicrosoftXmlSoapPost() CLASS ESocialClass

   LOCAL oComunicacao

   oComunicacao = win_OleCreateObject( "MSXML2.ServerXMLHTTP" )
   oComunicacao:setOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
   oComunicacao:open( "POST", ::cUrl, .F. )
   oComunicacao:SetRequestHeader( "SOAPAction", ::cSOAPAction )
   oComunicacao:SetRequestHeader( "Content-Type", "text/xml; charset=utf-8" )
   oComunicacao:send( ::cXmlEnvelope )
   Inkey(0.5)
   ::cXmlRetorno := oComunicacao:responseText

   RETURN NIL
