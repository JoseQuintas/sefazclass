#include "hbclass.ch"
#ifndef XML_UTF8
   #define XML_UTF8                     [<?xml version="1.0" encoding="UTF-8"?>]
#endif

PROCEDURE Main

   LOCAL cChave   := "1.2.201709.0000000000000225594"
   LOCAL oESocial := ESocialClass():New()

   oESocial:cCertificado := "XXXX"
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
   ::cXmlDocumento := [<eSocial xmlns="http://www.esocial.gov.br/schema/lote/eventos/envio/consulta/retornoProcessamento/v1_0_0">] + ;
      XmlTag( "consultaLoteEventos", XmlTag( "protocoloEnvio", cChave ) ) + ;
      [</eSocial>]
   ::cXmlEnvelope := XML_UTF8 + ;
      [<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.esocial.gov.br/servicos/empregador/lote/eventos/envio/v1_1_0">] + ;
      XmlTag( "soap:Body", ::cXmlDocumento ) + [</soap:Envelope>]
   ::MicrosoftXmlSoapPost()

   RETURN ::cXmlRetorno

METHOD MicrosoftXmlSoapPost() CLASS ESocialClass

   LOCAL oComunicacao

   oComunicacao = win_OleCreateObject( "MSXML2.ServerXMLHTTP" )
   oComunicacao:setOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
   oComunicacao:open( "GET", ::cUrl, .F. )
   oComunicacao:SetRequestHeader( "SOAPAction", ::cSOAPAction )
   oComunicacao:SetRequestHeader( "Content-Type", "application/soap+xml; charset=utf-8" )
   oComunicacao:send( ::cXmlEnvelope )
   oComunicacao:WaitForResponse( 500 )
   ::cXmlRetorno := oComunicacao:responseText

   RETURN NIL
