/*
ZE_SPEDSEFAZCLASS - Rotinas pra comunicação com SEFAZ
José Quintas
*/

#include "hbclass.ch"

#define WS_NFE_STATUSSERVICO         17

#define WS_CANCELAMENTONFE           1
#define WS_ENVIOLOTERPS              2

#define WS_AMBIENTE_HOMOLOGACAO      "2"
#define WS_AMBIENTE_PRODUCAO         "1"

#ifndef XML_UTF8
   #define XML_UTF8                     [<?xml version="1.0" encoding="UTF-8"?>]
#endif

CREATE CLASS SefazClass

   /* configuração */
   VAR    cAmbiente      INIT WS_AMBIENTE_PRODUCAO
   VAR    cUF            INIT "SP"                    // Modificada conforme método
   VAR    cCertificado   INIT ""                      // Nome do certificado
   VAR    nTempoEspera   INIT 7                       // intervalo entre envia lote e consulta recibo
   /* XMLs de cada etapa */
   VAR    cXmlDocumento  INIT ""                      // O documento oficial, com ou sem assinatura, depende do documento
   VAR    cXmlEnvio      INIT ""                      // usado pra criar/complementar XML do documento
   VAR    cXmlSoap       INIT ""                      // XML completo enviado pra Sefaz, incluindo informações do envelope
   VAR    cXmlRetorno    INIT "Erro Desconhecido"     // Retorno do webservice e/ou rotina
   VAR    cXmlProtocolo  INIT ""                      // XML protocolo (obtido no consulta recibo e/ou envio de outros docs)
   VAR    cXmlAutorizado INIT ""                      // XML autorizado, caso tudo ocorra sem problemas
   VAR    cStatus        INIT Space(3)                // Status obtido da resposta final da Fazenda
   /* uso interno */
   VAR    cSoapService   INIT ""                      // webservice Serviço
   VAR    cSoapAction    INIT ""                      // webservice Action
   VAR    cSoapURL       INIT ""                      // webservice Endereço

   METHOD EnvioLoteRPS( cXml, cCertificado, cAmbiente )

   /* Uso interno */
   METHOD Setup( cCertificado, cAmbiente, nWsServico )
   METHOD XmlSoapEnvelope()
   METHOD XmlSoapPost()
   METHOD MicrosoftXmlSoapPost()

   ENDCLASS

METHOD EnvioLoteRPS( cXml, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cCertificado, cAmbiente, WS_ENVIOLOTERPS )
   ::cXmlEnvio := ::AssinaXml( cXml )
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD Setup( cCertificado, cAmbiente, nWsServico ) CLASS SefazClass

   LOCAL nPos, aSoapList := { ;
      { WS_CANCELAMENTONFE,  "CancelamentoNFe", "http://www.prefeitura.sp.gov.br/nfe/ws/cancelamentoNFe", "https://naosei" }, ;
      { WS_ENVIOLOTERPS,     "EnvioLoteRPS",    "http://www.prefeitura.sp.gov.br/nfe/ws/envioLoteRPS", "https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx" } }

   ::cCertificado := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   ::cAmbiente    := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )

   IF nWsServico == NIL
      RETURN NIL
   ENDIF
   IF ( nPos := AScan( aSoapList, { | oElement | oElement[ 1 ] == nWsServico } ) ) != 0
      ::cSoapService := aSoapList[ nPos, 2 ]
      ::cSoapAction  := aSoapList[ nPos, 3 ]
      ::cSoapURL     := aSoapList[ nPos, 4 ]
   ENDIF

   RETURN NIL

METHOD XmlSoapPost() CLASS SefazClass

   DO CASE
   CASE Empty( ::cSoapURL )
      ::cXmlRetorno := "Erro SOAP: Não há endereço de webservice"
      RETURN NIL
   CASE Empty( ::cSoapService )
      ::cXmlRetorno := "Erro SOAP: Não há nome do serviço"
      RETURN NIL
   CASE Empty( ::cSoapAction )
      ::cXmlRetorno := "Erro SOAP: Não há endereço de SOAP Action"
      RETURN NIL
   ENDCASE
   ::XmlSoapEnvelope()
   ::MicrosoftXmlSoapPost()
   IF Upper( Left( ::cXmlRetorno, 4 ) )  == "ERRO"
      RETURN NIL
   ENDIF

   RETURN NIL

METHOD XmlSoapEnvelope() CLASS SefazClass

   ::cXmlSoap    := XML_UTF8
   ::cXmlSoap    += [<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ]
   ::cXmlSoap    +=       [xmlns:xsd="http://www.w3.org/2001/XMLSchema" ]
   ::cXmlSoap    +=       [xmlns:soap12="http://schemas.xmlsoap.org/soap/envelope/">]
   ::cXmlSoap    +=    [<soap12:Body>]
   ::cXmlSoap    +=       [<] + ::cSoapService + [Request xmlns="http://www.prefeitura.sp.gov.br/nfe">]
   ::cXmlSoap    +=          [<VersaoSchema>1</VersaoSchema>]
   ::cXmlSoap    +=          [<MensagemXML>]
   ::cXmlSoap    +=             "<![CDATA[ " + ::cXmlEnvio + " ]]>"
   ::cXmlSoap    +=          [</MensagemXML>]
   ::cXmlSoap    +=       [</] + ::cSoapService + [Request>]
   ::cXmlSoap    +=   [</soap12:Body>]
   ::cXmlSoap    += [</soap12:Envelope>]

   RETURN NIL

METHOD MicrosoftXmlSoapPost() CLASS SefazClass

   LOCAL oServer, nCont, cRetorno
   LOCAL cSoapAction

   cSoapAction := ::cSoapAction
   BEGIN SEQUENCE WITH __BreakBlock()
      ::cXmlRetorno := "Erro: Criando objeto MSXML2.ServerXMLHTTP"
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP" )
      ::cXmlRetorno := "Erro: No uso do objeto MSXML2.ServerXmlHTTP"
      IF ::cCertificado != NIL
         oServer:setOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
      ENDIF
      ::cXmlRetorno := "Erro: Na conexão com webservice " + ::cSoapURL
      oServer:Open( "POST", ::cSoapURL, .F. )
      oServer:SetRequestHeader( "SOAPAction", cSoapAction )
      oServer:SetRequestHeader( "Content-Type", "application/soap+xml; charset=utf-8" )
      oServer:Send( ::cXmlSoap )
      oServer:WaitForResponse( 500 )
      cRetorno := oServer:ResponseBody
      IF ValType( cRetorno ) == "C"
         ::cXmlRetorno := cRetorno
      ELSEIF cRetorno == NIL
         ::cXmlRetorno := "Erro: Sem retorno do webservice"
      ELSE
         ::cXmlRetorno := ""
         FOR nCont = 1 TO Len( cRetorno )
            ::cXmlRetorno += Chr( cRetorno[ nCont ] )
         NEXT
      ENDIF
   ENDSEQUENCE
   IF "<soap:Body>" $ ::cXmlRetorno .AND. "</soap:Body>" $ ::cXmlRetorno
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soap:Body" ) // hb_UTF8ToStr()
   ELSEIF "<soapenv:Body>" $ ::cXmlRetorno .AND. "</soapenv:Body>" $ ::cXmlRetorno
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soapenv:Body" ) // hb_UTF8ToStr()
   ELSE
      ::cXmlRetorno := "Erro SOAP: XML retorno não contém soapenv:Body " + ::cXmlRetorno
   ENDIF

   RETURN NIL

