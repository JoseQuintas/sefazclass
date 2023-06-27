/*
/*
ZE_SEFAZCLASS - Rotinas pra comunicação com SEFAZ
José Quintas

2019.07 - Início de desativação 3.10
2019.09 - TODO: cMsg e xMsg no retorno da Fazenda com avisos da Sefaz
*/

#include "hbclass.ch"
#include "sefazclass.ch"
#include "hb2xhb.ch"

#ifdef __XHARBOUR__
#define ALL_PARAMETERS P1, P2, P3, P4, P5, P6, P7, P8, P9, P10
#else
#define ALL_PARAMETERS ...
#endif

FUNCTION SefazClassValidaXml( cXml, cXsd )

   LOCAL oSefaz := SefazClass():New()

   RETURN oSefaz:ValidaXml( cXml, cXsd )

FUNCTION SefazClassTipoXml( cXml )

   LOCAL oSefaz := SefazClass():New()

   RETURN oSefaz:TipoXml( cXml )

CREATE CLASS SefazClass INHERIT Sefazclass_BPE, SefazClass_CTE, SefazClass_MDFE, SefazClass_NFE

   /* configuração */
   VAR    cProjeto        INIT NIL
   VAR    cAmbiente       INIT WS_AMBIENTE_PRODUCAO
   VAR    cVersao         INIT NIL
   VAR    cUF             INIT "SP"                    // Modificada conforme método
   VAR    cCertificado    INIT ""                      // CN (NOME) do certificado
   /* contingência e sinc/assinc */
   VAR    cScan           INIT "N"                     // Indicar SCAN/SVAN/SVRS testes iniciais
   VAR    cIndSinc        INIT WS_RETORNA_RECIBO       // Poucas UFs opção de protocolo
   /* pra NFCe */
   VAR    cIdToken        INIT ""                      // Para NFCe obrigatorio identificador do CSC Código de Segurança do Contribuinte
   VAR    cCSC            INIT ""                      // Para NFCe obrigatorio CSC Código de Segurança do Contribuinte
   /* configuração não comum */
   VAR    cVersaoQrCode   INIT "2.00"                  // Versao do QRCode
   VAR    nTempoEspera    INIT 10                      // intervalo entre envia lote e consulta recibo
   VAR    nSoapTimeOut    INIT 15000                  // Limite de espera por resposta em segundos * 1000
   VAR    lEmitenteCPF    INIT .F.                     // Para o caso de CPF ao invés de CNPJ
   VAR    ValidFromDate   INIT ""                      // Validade do certificado
   VAR    ValidToDate     INIT ""                      // Validade do certificado
   VAR    cUFTimeZone     INIT ""                      // Para TimeZone diferente da UF de comunicação
   VAR    cUserTimeZone   INIT ""                      // Para TimeZone definido pelo usuário
   VAR    cPassword       INIT ""                      // Senha de arquivo PFX
   VAR    cProxyUrl       INIT ""
   VAR    cProxyUser      INIT ""
   VAR    cProxyPassword  INIT ""
   /* XMLs de cada etapa, se precisar conferir */
   VAR    cXmlDocumento   INIT ""                      // O documento oficial, com ou sem assinatura, depende do documento
   VAR    cXmlEnvio       INIT ""                      // usado pra criar/complementar XML do documento
   VAR    cXmlSoap        INIT ""                      // XML completo enviado pra Sefaz, incluindo informações do envelope
   VAR    cXmlRetorno     INIT [<erro text="*ERRO* Erro Desconhecido" />]    // Retorno do webservice e/ou rotina
   VAR    cXmlRecibo      INIT ""                      // XML recibo (obtido no envio do lote)
   VAR    cXmlProtocolo   INIT ""                      // XML protocolo (obtido no consulta recibo e/ou envio de outros docs)
   VAR    cXmlAutorizado  INIT ""                      // XML autorizado, caso tudo ocorra sem problemas
   VAR    cStatus         INIT Space(3)                // Status obtido da resposta final da Fazenda
   VAR    cRecibo         INIT ""                      // Número do recibo
   VAR    cMotivo         INIT ""                      // Motivo constante no Recibo
   /* uso interno */
   VAR    cSoapService    INIT ""                      // webservice Serviço
   VAR    cSoapAction     INIT ""                      // webservice Action
   VAR    cSoapURL        INIT ""                      // webservice Endereço
   VAR    cXmlNameSpace   INIT "xmlns="
   VAR    cNFCE           INIT "N"                     // Porque NFCE tem endereços diferentes
   VAR    aSoapUrlList    INIT {}

   /* Uso interno */
   METHOD XmlSoapEnvelope()
   METHOD XmlSoapPost()
   METHOD MicrosoftXmlSoapPost()

   /* Apenas redirecionamento */
   METHOD AssinaXml()
   METHOD TipoXml( cXml )                             INLINE TipoXml( cXml )
   METHOD UFCodigo( cSigla )                          INLINE UFCodigo( cSigla )
   METHOD UFSigla( cCodigo )                          INLINE UFSigla( cCodigo )
   METHOD DateTimeXml( dDate, cTime, lUTC )           INLINE DateTimeXml( dDate, cTime, iif( Empty( ::cUFTimeZone ), ::cUF, ::cUFTimeZone ), lUTC, ::cUserTimeZone )
   METHOD ValidaXml( cXml, cFileXsd, cIgnoreList )    INLINE ::cXmlRetorno := DomDocValidaXml( cXml, cFileXsd, cIgnoreList )
   METHOD Setup( cUF, cCertificado, cAmbiente )

   ENDCLASS

METHOD AssinaXml() CLASS SefazClass

   ::cXmlRetorno := CapicomAssinaXml( @::cXmlDocumento, ::cCertificado,,::cPassword )
   IF ::cXmlRetorno != "OK"
      ::cStatus := "999"
      ::cMotivo := ::cXmlRetorno
      ::cXmlRetorno := [<erro text="] + "*erro* " + ::cXmlRetorno + ["</erro>]
   ENDIF

   RETURN ::cXmlRetorno

METHOD Setup( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cProjeto, cNFCe, cScan, cVersao

   DO CASE
   CASE cUF == NIL
   CASE Len( SoNumeros( cUF ) ) != 0
      ::cUF := ::UFSigla( Left( cUF, 2 ) )
   OTHERWISE
      ::cUF := cUF
   ENDCASE
   ::cCertificado := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   ::cAmbiente    := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cSoapURL := ""
   cAmbiente  := ::cAmbiente
   cUF        := ::cUF
   cProjeto   := ::cProjeto
   cNFCE      := ::cNFCE
   cScan      := ::cScan
   cVersao    := ::cVersao + iif( cAmbiente == WS_AMBIENTE_PRODUCAO, "P", "H" )
   DO CASE
   CASE cProjeto == WS_PROJETO_BPE
      ::cSoapUrl := ::SoapUrlBpe( ::aSoapUrlList, cUF, cVersao )
   CASE cProjeto == WS_PROJETO_CTE
      IF cScan == "SVCAN"
         IF cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
            ::cSoapURL := ::SoapURLCTe( ::aSoapUrlList, "SVSP", cVersao ) // SVC_SP não existe
         ELSEIF cUF $ "MS,MT,SP," + "AP,PE,RR"
            ::cSoapURL := ::SoapUrlCTe( ::aSoapUrlList, "SVRS", cVersao ) // SVC_RS não existe
         ENDIF
      ELSE
         ::cSoapUrl := ::SoapUrlCTe( ::aSoapUrlList, cUF, cVersao )
      ENDIF
   CASE cProjeto == WS_PROJETO_MDFE
      ::cSoapURL := ::SoapURLMDFe( ::aSoapUrlList, "SVRS", cVersao )
   CASE cProjeto == WS_PROJETO_NFE
      DO CASE
      CASE cNFCe == "S"
         ::cSoapUrl := ::SoapUrlNFCe( ::aSoapUrlList, cUF, cVersao )
         IF Empty( ::cSoapUrl )
            ::cSoapUrl := ::SoapUrlNfe( ::aSoapUrlList, cUF, cVersao )
         ENDIF
      CASE cScan == "SCAN"
         ::cSoapURL := ::SoapUrlNFe( ::aSoapUrlList, "SCAN", cVersao )
      CASE cScan == "SVAN"
         ::cSoapUrl := ::SoapUrlNFe( ::aSoapUrlList, "SVAN", cVersao )
      CASE cScan == "SVCAN"
         IF cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
            ::cSoapURL := ::SoapURLNfe( ::aSoapUrlList, "SVCRS", cVersao )
         ELSE
            ::cSoapURL := ::SoapUrlNFe( ::aSoapUrlList, "SVCAN", cVersao )
         ENDIF
      OTHERWISE
         ::cSoapUrl := ::SoapUrlNfe( ::aSoapUrlList, cUF, cVersao )
      ENDCASE
   ENDCASE

   RETURN NIL

METHOD XmlSoapPost() CLASS SefazClass

   DO CASE
   CASE Empty( ::cSoapURL )
      ::cXmlRetorno := [<erro text="*ERRO* XmlSoapPost(): Não há endereço de webservice" />]
      ::cStatus     := "999"
      ::cMotivo     := "Erro de comunicação: sem endereço de internet"
      RETURN NIL
   CASE Empty( ::cSoapService )
      ::cXmlRetorno := [<erro text="*ERRO* XmlSoapPost(): Não há nome do serviço" />]
      ::cStatus     := "999"
      ::cMotivo     := "Erro de comunicação: sem nome de serviço"
      RETURN NIL
   CASE Empty( ::cSoapAction )
      ::cXmlRetorno := [<erro text="*ERRO* XmlSoapPost(): Não há endereço de SOAP Action" />]
      ::cStatus     := "999"
      ::cMotivo     := "Erro de comunicação: sem SOAP Action"
      RETURN NIL
   ENDCASE
   ::XmlSoapEnvelope()
   ::MicrosoftXmlSoapPost()

   RETURN NIL

METHOD XmlSoapEnvelope() CLASS SefazClass

   LOCAL cXmlns := ;
      [xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ] + ;
   [xmlns:xsd="http://www.w3.org/2001/XMLSchema" ] + ;
   [xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"]
   LOCAL cSoapVersion

   cSoapVersion := ::cVersao
   IF "CadConsultaCadastro" $ ::cSoapAction
      cSoapVersion := "2.00"
   ELSEIF "nfeRecepcaoEvento" $ ::cSoapAction
      cSoapVersion := "1.00"
   ENDIF
   ::cXmlSoap    := XML_UTF8
   ::cXmlSoap    += [<soap12:Envelope ] + cXmlns + [>]
   IF ::cSoapAction != "nfeDistDFeInteresse" .AND. ::cSoapAction != "ccgConsGTIN" ;
      .AND. ! ( ::cProjeto == WS_PROJETO_CTE .AND. ::cVersao == "4.00" )
      ::cXmlSoap +=    [<soap12:Header>]
      IF ::cVersao == "4.00" .AND. ::cProjeto != WS_PROJETO_CTE
         ::cXmlSoap +=       [<] + ::cProjeto + [CabecMsg xmlns="] + ::cSoapService + ["/>]
      ELSE
         ::cXmlSoap +=       [<] + ::cProjeto + [CabecMsg xmlns="] + ::cSoapService + [">]
         ::cXmlSoap +=          [<cUF>] + ::UFCodigo( ::cUF ) + [</cUF>]
         ::cXmlSoap +=          [<versaoDados>] + cSoapVersion + [</versaoDados>]
         ::cXmlSoap +=       [</] + ::cProjeto + [CabecMsg>]
      ENDIF
      ::cXmlSoap +=    [</soap12:Header>]
   ENDIF
   ::cXmlSoap    +=    [<soap12:Body>]
   IF ::cSoapAction == "ccgConsGTIN"
      ::cXmlSoap += [<ccgConsGTIN xmlns="] + ::cSoapService + [">]
   ENDIF
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [<nfeDistDFeInteresse xmlns="] + ::cSoapService + [">]
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg>]
   ELSEIF ::cSoapAction == "ccgConsGTIN"
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg>]
   ELSE
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg xmlns="] + ::cSoapService + [">]
   ENDIF
   ::cXmlSoap    += ::cXmlEnvio
   ::cXmlSoap    +=    [</] + ::cProjeto + [DadosMsg>]
   IF ::cSoapAction == "ccgConsGTIN"
      ::cXmlSoap += [</ccgConsGTIN>]
   ENDIF
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [</nfeDistDFeInteresse>]
   ENDIF
   ::cXmlSoap    +=    [</soap12:Body>]
   ::cXmlSoap    += [</soap12:Envelope>]

   RETURN NIL

METHOD MicrosoftXmlSoapPost() CLASS SefazClass

   LOCAL oServer, nCont, cRetorno
   LOCAL cSoapAction

   cSoapAction := ::cSoapAction
   BEGIN SEQUENCE WITH __BreakBlock()
      ::cXmlRetorno := [<erro text="*ERRO* Erro: Criando objeto MSXML2.ServerXMLHTTP" />]
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP.6.0" )
      ::cXmlRetorno := [erro text="*ERRO* Erro: No uso do objeto MSXML2.ServerXmlHTTP.6.0" />]
      IF ::cCertificado != NIL
         oServer:setOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
      ENDIF
      ::cXmlRetorno := [erro text="*ERRO* Erro: Na conexão com webservice ] + ::cSoapURL + [" />]
      //setTimeouts( long resolveTimeout, long connectTimeout, long sendTimeout, long receiveTimeout )
      oServer:SetTimeOuts( ::nSoapTimeOut, ::nSoapTimeOut, ::nSoapTimeOut, ::nSoapTimeOut )
      oServer:Open( "POST", ::cSoapURL, .F. )
      IF ! Empty( ::cProxyUrl )
         oServer:SetProxy( 2, ::cProxyUrl )
         IF ! Empty( ::ProxyUser ) .OR. ! Empty( ::cProxyPassword )
            oServer:SetProxyCredentials( ::ProxyUser, ::ProxyPassword )
         ENDIF
      ENDIF
      IF cSoapAction != NIL .AND. ! Empty( cSoapAction )
         oServer:SetRequestHeader( "SOAPAction", cSoapAction )
      ENDIF
      oServer:SetRequestHeader( "Content-Type", "application/soap+xml; charset=utf-8" )
      // webservice json: "Content-Type", "application/json"
      oServer:Send( ::cXmlSoap )
      oServer:WaitForResponse( ::nSoapTimeOut )
      cRetorno := oServer:ResponseBody()
      IF ValType( cRetorno ) == "C"
         ::cXmlRetorno := cRetorno
      ELSEIF cRetorno == NIL
         ::cXmlRetorno := "Sem retorno do webservice"
      ELSEIF ValType( cRetorno ) == "A" // xharbour e harbour antigo???
         ::cXmlRetorno := ""
         FOR nCont = 1 TO Len( cRetorno )
            ::cXmlRetorno += Chr( cRetorno[ nCont ] )
         NEXT
      ENDIF
   ENDSEQUENCE
   DO CASE
   CASE ! Empty( XmlNode( ::cXmlRetorno, "soap:Body" ) )
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soap:Body" )
   CASE ! Empty( XmlNode( ::cXmlRetorno, "soapenv:Body" ) )
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soapenv:Body" )
   CASE ! Empty( XmlNode( ::cXmlRetorno, "env:Body" ) )
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "env:Body" )
   CASE "not have permission to view" $ ::cXmlRetorno
      ::cStatus     := "999"
      ::cMotivo     := "problemas com Sefaz e/ou certificado"
      // ::CertificadoInfo()
      ::cXmlRetorno := [<erro xml="] + "*ERRO*" + ::cMotivo + [" />]
   OTHERWISE
      // teste usando procname(2)
      ::cXmlRetorno := [<erro text="*ERRO* Erro SOAP: ] + ProcName(2) + [ XML retorno não contém soapenv:Body" />] + ::cXmlRetorno
   ENDCASE

   RETURN NIL

STATIC FUNCTION UFCodigo( cSigla )

   LOCAL cUFs, cCodigo, nPosicao

   IF Val( cSigla ) > 0
      RETURN cSigla
   ENDIF
   cUFs := "AN,91,AC,12,AL,27,AM,13,AP,16,BA,29,CE,23,DF,53,ES,32,GO,52,MG,31,MS,50,MT,51,MA,21,PA,15,PB,25,PE,26,PI,22,PR,41,RJ,33,RO,11,RN,24,RR,14,RS,43,SC,42,SE,28,SP,35,TO,17,"
   nPosicao := At( cSigla, cUfs )
   IF nPosicao < 1
      cCodigo := "99"
   ELSE
      cCodigo := Substr( cUFs, nPosicao + 3, 2 )
   ENDIF

   RETURN cCodigo

STATIC FUNCTION UFSigla( cCodigo )

   LOCAL cUFs, cSigla, nPosicao

   cCodigo := Left( cCodigo, 2 ) // pode ser chave NFE
   IF Val( cCodigo ) == 0 // não é número
      RETURN cCodigo
   ENDIF
   cUFs := "AN,91,AC,12,AL,27,AM,13,AP,16,BA,29,CE,23,DF,53,ES,32,GO,52,MG,31,MS,50,MT,51,MA,21,PA,15,PB,25,PE,26,PI,22,PR,41,RJ,33,RO,11,RN,24,RR,14,RS,43,SC,42,SE,28,SP,35,TO,17,"
   nPosicao := At( cCodigo, cUfs )
   IF nPosicao < 1
      cSigla := "XX"
   ELSE
      cSigla := Substr( cUFs, nPosicao - 3, 2 )
   ENDIF

   RETURN cSigla

STATIC FUNCTION TipoXml( cXml )

   LOCAL aTipos, cTipoXml, cTipoEvento, oElemento

   aTipos := { ;
      { [<infMDFe],   [MDFE] }, ;  // primeiro, pois tem nfe e cte
      { [<cancMDFe],  [MDFEC] }, ;
      { [<infCte],    [CTE]  }, ;  // segundo, pois tem nfe
      { [<cancCTe],   [CTEC] }, ;
      { [<infNFe],    [NFE]  }, ;
      { [<infCanc],   [NFEC] }, ;
      { [<infInut],   [INUT] }, ;
      { [<infEvento], [EVEN] } }

   cTipoXml := "XX"
   FOR EACH oElemento IN aTipos
      IF Upper( oElemento[ 1 ] ) $ Upper( cXml )
         cTipoXml := oElemento[ 2 ]
         IF cTipoXml == "EVEN"
            cTipoEvento := XmlTag( cXml, "tpEvento" )
            DO CASE
            CASE cTipoEvento == "110111"
               IF "<chNFe" $ cXml
                  cTipoXml := "NFEC"
               ENDIF
            CASE cTipoEvento == "110110"
               cTipoXml := "CCE"
            OTHERWISE
               cTipoXml := "OUTROEVENTO"
            ENDCASE
         ENDIF
         EXIT
      ENDIF
   NEXT

   RETURN cTipoXml

STATIC FUNCTION DomDocValidaXml( cXml, cFileXsd, cIgnoreList )

   LOCAL oXmlDomDoc, oXmlSchema, oXmlErro, cRetorno := "ERRO"

   hb_Default( @cFileXsd, "" )

   IF " <" $ cXml .OR. "> " $ cXml
      RETURN "Espaços inválidos no XML entre as tags"
   ENDIF

   IF Empty( cFileXsd )
      RETURN SingleXmlValidate( cXml, cIgnoreList )
   ENDIF
   IF ! File( cFileXSD )
      RETURN "Erro não encontrado arquivo " + cFileXSD
   ENDIF

   BEGIN SEQUENCE WITH __BreakBlock()

      cRetorno   := "Erro Carregando MSXML2.DomDocument.6.0"
      oXmlDomDoc := win_OleCreateObject( "MSXML2.DomDocument.6.0" )
      oXmlDomDoc:aSync            := .F.
      oXmlDomDoc:ResolveExternals := .F.
      oXmlDomDoc:ValidateOnParse  := .T.

      cRetorno   := iif( cRetorno == Nil, "", "Erro Carregando XML" )
      oXmlDomDoc:LoadXml( cXml )
      IF oXmlDomDoc:ParseError:ErrorCode <> 0
         cRetorno := "Erro XML inválido " + ;
            " Linha: "   + AllTrim( Transform( oXmlDomDoc:ParseError:Line, "" ) ) + ;
            " coluna: "  + AllTrim( Transform( oXmlDomDoc:ParseError:LinePos, "" ) ) + ;
            " motivo: "  + AllTrim( Transform( oXmlDomDoc:ParseError:Reason, "" ) ) + ;
            " errcode: " + AllTrim( Transform( oXmlDomDoc:ParseError:ErrorCode, "" ) )
         BREAK
      ENDIF

      cRetorno   := iif( cRetorno == Nil, "", "Erro Carregando MSXML2.XMLSchemaCache.6.0" )
      oXmlSchema := win_OleCreateObject( "MSXML2.XMLSchemaCache.6.0" )

      cRetorno   := iif( cRetorno == Nil, "", "Erro carregando " + cFileXSD )
      DO CASE
      CASE "mdfe" $ Lower( cFileXsd )
         oXmlSchema:Add( "http://www.portalfiscal.inf.br/mdfe", cFileXSD )
      CASE "cte"  $ Lower( cFileXsd )
         oXmlSchema:Add( "http://www.portalfiscal.inf.br/cte", cFileXSD )
      CASE "nfe"  $ Lower( cFileXsd )
         oXmlSchema:Add( "http://www.portalfiscal.inf.br/nfe", cFileXSD )
      ENDCASE

      oXmlDomDoc:Schemas := oXmlSchema
      oXmlErro := oXmlDomDoc:Validate()
      IF oXmlErro:ErrorCode <> 0
         cRetorno := "Erro: " + AllTrim( Transform( oXmlErro:ErrorCode, "" ) ) + " " + ConverteErroValidacao( oXmlErro:Reason, "" )
         BREAK
      ENDIF
      cRetorno := iif( cRetorno == Nil, "", "OK" )

   ENDSEQUENCE

   RETURN cRetorno

STATIC FUNCTION ConverteErroValidacao( cTexto )

   LOCAL nPosIni, nPosFim

   cTexto := AllTrim( Transform( cTexto, "" ) )
   DO WHILE .T.
      IF ! "{" $ cTexto .OR. ! "}" $ cTexto
         EXIT
      ENDIF
      nPosIni := At( "{", cTexto ) - 1
      nPosFim := At( "}", cTexto ) + 1
      IF nPosIni > nPosFim
         EXIT
      ENDIF
      cTexto := Substr( cTexto, 1, nPosIni ) + Substr( cTexto, nPosFim )
   ENDDO

   RETURN cTexto

#ifdef LIBCURL // pra nao compilar, apenas anotado
   // Pode ser usada a LibCurl pra comunicação

METHOD CurlSoapPost() CLASS SefazClass

   LOCAL aHeader := Array(3)

   aHeader[ 1 ] := [Content-Type: application/soap+xml;charset=utf-8;action="] + ::cSoapService + ["]
   aHeader[ 2 ] := [SOAPAction: "] + ::cSoapAction + ["]
   aHeader[ 3 ] := [Content-length: ] + AllTrim( Str( Len( ::cXml ) ) )
   curl_global_init()
   oCurl := curl_easy_init()
   curl_easy_setopt( oCurl, HB_CURLOPT_URL, ::cSoapURL )
   curl_easy_setopt( oCurl, HB_CURLOPT_PORT , 443 )
   curl_easy_setopt( oCurl, HB_CURLOPT_VERBOSE, .F. ) // 1
   curl_easy_setopt( oCurl, HB_CURLOPT_HEADER, 1 ) //retorna o cabecalho de resposta
   curl_easy_setopt( oCurl, HB_CURLOPT_SSLVERSION, 3 ) // Algumas UFs começaram a usar versão 4
   curl_easy_setopt( oCurl, HB_CURLOPT_SSL_VERIFYHOST, 0 )
   curl_easy_setopt( oCurl, HB_CURLOPT_SSL_VERIFYPEER, 0 )
   curl_easy_setopt( oCurl, HB_CURLOPT_SSLCERT, ::cCertificadoPublicKeyFile ) // Falta na classe
   curl_easy_setopt( oCurl, HB_CURLOPT_KEYPASSWD, ::cCertificadoPassword )    // Falta na classe
   curl_easy_setopt( oCurl, HB_CURLOPT_SSLKEY, ::cCertificadoPrivateKeyFile ) // Falta na classe
   curl_easy_setopt( oCurl, HB_CURLOPT_POST, 1 )
   curl_easy_setopt( oCurl, HB_CURLOPT_POSTFIELDS, ::cXml )
   curl_easy_setopt( oCurl, HB_CURLOPT_WRITEFUNCTION, 1 )
   curl_easy_setopt( oCurl, HB_CURLOPT_DL_BUFF_SETUP )
   curl_easy_setopt( oCurl, HB_CURLOPT_HTTPHEADER, aHeader )
   curl_easy_perform( oCurl )
   retHTTP := curl_easy_getinfo( oCurl, HB_CURLINFO_RESPONSE_CODE )
   ::cXmlRetorno := ""
   IF retHTTP == 200 // OK
      curl_easy_setopt( ocurl, HB_CURLOPT_DL_BUFF_GET, @::cXmlRetorno )
      cXMLResp := Substr( cXMLResp, AT( '<?xml', ::cXmlRetorno ) )
   ENDIF
   curl_easy_cleanup( oCurl )
   curl_global_cleanup()

   RETURN NIL
#endif

STATIC FUNCTION SingleXmlValidate( cXml, cIgnoreList )

   LOCAL nPos, aTagsAbre := {}, cTmp, oElement, cLetra, cTxt := ""

   hb_Default( @cIgnoreList, "" )
   DO WHILE .T.
      nPos := hb_At( "<", cXml, nPos )
      IF nPos < 1
         EXIT
      ENDIF
      IF Substr( cXml, nPos + 1, 1 ) == "/"
         IF ! ProcFecha( Substr( cXml, nPos, hb_At( ">", cXml, nPos ) - nPos ), aTagsAbre, @cTxt )
            EXIT
         ENDIF
      ELSE
         cTmp := Substr( cXml, nPos, hb_At( ">", cXml, nPos ) - nPos + 1 )
         IF ! "/>" $ cTmp .AND. ! "/ >" $ cTmp
            AAdd( aTagsAbre, cTmp )
            //? "Abriu " + Atail( aTagsAbre )
         ENDIF
      ENDIF
      nPos := nPos + 3
   ENDDO
   IF Len( aTagsAbre ) != 0
      cTxt += "Em aberto" + Space(3)
      FOR EACH oElement IN aTagsAbre
         cTxt += oElement + Space(3)
      NEXT
      RETURN "*ERRO* " + cTxt
   ENDIF
   FOR EACH cLetra IN cXml
      DO CASE
      CASE cLetra $ "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      CASE cLetra $ "abcdefghijklmnopqrstuvwxyz"
      CASE cLetra $ "0123456789"
      CASE cLetra $ " <>=:/.,-+#$()_@;%"
      CASE cLetra == ["]
      CASE cLetra $ cIgnoreList
      OTHERWISE
         cTxt += "Caractere " + cLetra + " posição " + Ltrim( Str( cLetra:__EnumIndex ) ) + ;
            " aproximadamente aqui " + Substr( cXml, Max( 0, cLetra:__EnumIndex - 10 ), 20 ) + ", "
      ENDCASE
   NEXT
   IF " <" $ cXml .OR. "> " $ cXml
      cTxt += "espaços em branco antes de < ou depois de >"
   ENDIF
   IF Len( cTxt ) > 0
      RETURN "*ERRO* " + cTxt
   ENDIF
   RETURN "OK"

STATIC FUNCTION ProcFecha( cTag, aTagsAbre, cTxt )

   LOCAL oElement

   FOR EACH oElement IN aTagsAbre
      IF " " $ oElement
         oElement := Substr( oElement, 1, At( " ", oElement ) - 1 )
      ENDIF
      IF ">" $ oElement
         oElement := Substr( oElement, 1, At( ">", oElement ) - 1 )
      ENDIF
      IF "<" $ oElement
         oElement := Trim( Substr( oElement, 2 ) )
      ENDIF
   NEXT
   cTag := Substr( cTag, 3 )
   IF ">" $ cTag
      cTag := Substr( cTag, 1, At( ">", cTag ) - 1 )
   ENDIF
   IF cTag == Atail( aTagsAbre )
      //? "fechou " + cTag
      hb_ADel( aTagsAbre, Len( aTagsAbre ), .T. )
   ELSE
      IF Len( aTagsAbre ) != 0
         cTxt += "erro fechada " + cTag + " esperada " + Atail( aTagsAbre ) + Space(3)
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.
