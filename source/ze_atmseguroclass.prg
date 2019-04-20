/*
ZE_ATMSEGURO - Comunicacao com Seguradora ATM

Nota: XML emissao, cancelamento, e eventos
*/

#include "hbclass.ch"

CREATE CLASS ATMSeguroClass

   VAR    lTeste       INIT .F.
   VAR    cRetorno     INIT ""
   METHOD CTE( cXml, cUsuario, cSenha, cCodigo )
   METHOD MDFE( cXml, cUsuario, cSenha, cCodigo )
   METHOD NFE( cXml, cUsuario, cSenha, cCodigo )
   METHOD EnviaXML( cXml, cSoapAction )

   END CLASS

METHOD CTE( cXml, cUsuario, cSenha, cCodigo ) CLASS ATMSeguroClass

   LOCAL cBloco

   cBloco := XmlTag( "usuario", cUsuario )
   cBloco += XmlTag( "senha", cSenha )
   cBloco += XmlTag( "codatm", cCodigo )
   cBloco += XmlTag( "xmlCTe", "<![CDATA[" + cXml + "]]>" )
   cXml   := XmlTag( "urn:averbaCTe", cBloco )

   ::cRetorno := ::EnviaXml( cXml, "urn:ATMWebSvr#averbaCTe" )

   RETURN ::cRetorno

METHOD MDFE( cXml, cUsuario, cSenha, cCodigo ) CLASS ATMSeguroClass

   LOCAL cBloco

   cBloco := XmlTag( "usuario", cUsuario )
   cBloco += XmlTag( "senha", cSenha )
   cBloco += XmlTag( "codatm", cCodigo )
   cBloco += XmlTag( "xmlMDFe", "<![CDATA[" + cXml + "]]>" )
   cXml   := XmlTag( "urn:declaraMDFe", cBloco )

   ::cRetorno := ::EnviaXml( cXml, "urn:ATMWebSvr#declaraMDFe" )

   RETURN ::cRetorno

METHOD NFE( cXml, cUsuario, cSenha, cCodigo ) CLASS ATMSeguroClass

   LOCAL cBloco

   cBloco := XmlTag( "usuario", cUsuario )
   cBloco += XmlTag( "senha", cSenha )
   cBloco += XmlTag( "codatm", cCodigo )
   cBloco += XmlTag( "xmlNFe", "<![CDATA[" + cXml + "]]>" )
   cXml   := XmlTag( "urn:averbaNFe", cBloco )

   ::cRetorno := ::EnviaXml( cXml, "urn:ATMWebSvr#averbaNFe" )

   RETURN ::cRetorno

METHOD EnviaXml( cXml, cSoapAction ) CLASS ATMSeguroClass

   LOCAL oServer, cXmlEnvio, cRetorno, cUrl, cHost

   IF ::lTeste
      cUrl  := "http://homologaws.averba.com.br/20/index.soap"
      cHost := "homologaws.averba.com.br"
   ELSE
      cUrl  := "http://webserver.averba.com.br/20/index.soap"
      cHost := "webserver.averba.com.br"
   ENDIF
   cXmlEnvio := [<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:ATMWebSvr">]
   cXmlEnvio += XmlTag( "soapenv:Header", "" )
   cXmlEnvio += XmlTag( "soapenv:Body", cXml )
   cXmlEnvio += [</soapenv:Envelope>]

   BEGIN SEQUENCE WITH __BreakBlock()
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP" )
      oServer:Open( "POST", cUrl, .F. )
      oServer:SetRequestHeader( "SOAPAction", cSoapAction )
      oServer:SetRequestHeader( "Content-Type", "text/xml;charset=UTF-8" )
      oServer:SetRequestHeader( "Host", cHost )
      oServer:send( cXmlEnvio )
      oServer:WaitForResponse( 1000 )
      cRetorno := oServer:responseText
   END SEQUENCE

   IF ValType( cRetorno ) != "C"
      cRetorno := ""
   ENDIF

   RETURN cRetorno
