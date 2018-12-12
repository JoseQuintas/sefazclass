/*
http://www.pctoledo.com.br/forum/viewtopic.php?f=39&t=17470&start=75#p118783
*/

REQUEST HB_CODEPAGE_PTISO

FUNCTION Main()

   LOCAL cCep, cBairro, cCidade, cEndereco, cUF, cID

   Set( _SET_CODEPAGE, "PTISO" )
   cCep := "03676080"
   ConsultaCep( cCep, @cBairro, @cCidade, @cEndereco, @cUF, @cId )

   ? cCep
   ? cBairro
   ? cCidade
   ? cEndereco
   ? cUF
   ? cId
   Inkey(0)

   RETURN NIL

STATIC FUNCTION ConsultaCep( cCep, cBairro, cCidade, cEndereco, cUF, cId )

   LOCAL cUrlWs := [https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente]
   LOCAL oSefaz

   WITH OBJECT oSefaz := SefazClass():New()
      :cSoapUrl := cUrlWs
      :cXmlSoap := SoapEnvelope( cCep )
      :MicrosoftXmlSoapPost()
      :cXmlRetorno := XmlTransform( :cXmlRetorno )
      cCep      := XmlNode( :cXmlRetorno, "cep" )
      cBairro   := XmlNode( :cXmlRetorno, "bairro" )
      cCidade   := XmlNode( :cXmlRetorno, "cidade" )
      cEndereco := XmlNode( :cXmlRetorno, "end" )
      cUF       := XmlNode( :cXmlRetorno, "uf" )
      cID       := XmlNode( :cXmlRetorno, "id" )
   END WITH
   ? oSefaz:cXmlRetorno

   RETURN NIL

STATIC FUNCTION SoapEnvelope( cCEP )

   LOCAL cxMLSoap

   cxMLSoap := [<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/">]
   cxMLSoap +=    [<soapenv:Header/>]
   cxMLSoap +=    [<soapenv:Body>]
   cxMLSoap +=       [<cli:consultaCEP>]
   //cxMLSoap +=          [<!--Optional:-->]
   cxMLSoap +=          [<cep>] + cCEP + [</cep>]
   cxMLSoap +=       [</cli:consultaCEP>]
   cxMLSoap +=    [</soapenv:Body>]
   cxMLSoap += [</soapenv:Envelope>]

   RETURN cxMLSoap

   //cXml    := SoapEnvelope( cCep )
   //oMSXML  := win_OleCreateObject( "MSXML2.ServerXMLHTTP" )
   //oDOMDoc := win_OleCreateObject( "MSXML2.DOMDocument" )
   //WITH OBJECT oMSXML
   //:Open( "POST", cUrlWs, .F. )
   //:SetRequestHeader( "Content-Type", 'text/xml; charset="utf-8"' )
   //:SetRequestHeader( "Content-Length", hb_NtoS( hb_BLen( cXML ) ) )
   //:Send( cXML )
   //:WaitForResponse( 500 )
   //END WITH
   //hb_MemoWrit( "cep.htm", oMSXML:Responsebody )
   //WITH OBJECT oDOMDoc
   //   :aSync := .F.
   //   :Load( oMSXML:responseXML )
   //   cCEP      := :getElementsByTagName( "cep" ):item(0):Text
   //   cBairro   := :getElementsByTagName( "bairro" ):item(0):Text
   //   cCidade   := :getElementsByTagName( "cidade" ):item(0):Text
   //   cEndereco := :getElementsByTagName( "end" ):item(0):Text
   //   cUF       := :getElementsByTagName( "uf" ):item(0):Text
   //   cID       := :getElementsByTagName( "id" ):item(0):Text
   //END WITH
