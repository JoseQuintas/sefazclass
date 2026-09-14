/*
ZE_CIOT - Comunicacao com a ANTT - PEF (Pagamento Eletronico de Frete)

Nota: geracao, consulta, declaracao, retificacao, cancelamento e encerramento de CIOT.
      Padrao de comunicacao conforme ze_sefazclass.prg (metodo MicrosoftXmlSoapPost).
      Diferencas em relacao a SEFAZ: transporte REST/JSON (nao SOAP) e sem assinatura
      de mensagem - a autenticacao do PEF e feita apenas por TLS mutuo com o
      certificado cliente (setOption 3).

      Documentacao: DCS PEF
      https://www.gov.br/antt/pt-br/assuntos/cargas/ciot-para-todos-1/documentos-tecnicos
*/

#include "hbclass.ch"

#define CIOT_URL_PRODUCAO          "https://appservices.antt.gov.br/pefServices"
#define CIOT_URL_HOMOLOGACAO       "https://appservices-hml.antt.gov.br/pefServices"

#define CIOT_AMBIENTE_PRODUCAO     "1"
#define CIOT_AMBIENTE_HOMOLOGACAO  "2"

/* DCS - final do processamento da solicitacao */
#define CIOT_SUCESSO_INCLUSAO      110
#define CIOT_SUCESSO_CONSULTA      111

/* convencao da sefazclass: 999 = falha de comunicacao */
#define CIOT_ERRO_COMUNICACAO      999

/* nenhum fonte desta pasta inclui fivewin.ch; CRLF fica local para nao puxa-lo */
#define CIOT_CRLF                  Chr( 13 ) + Chr( 10 )

/*
Endpoints dos servicos do DCS PEF.

Decisao do projeto: a integracao com a ANTT e feita SEMPRE por webservice.
Nao utilizar a DLL/executavel de geracao distribuida pela ANTT em
pefServices/Downloads (GeradorCIOT_DLL.zip e GeradorCIOT.zip).

Paths CONFIRMADOS por sondagem da homologacao em 2026-09-09. Sem certificado,
401 = o path existe e exige certificado, 404 = o path nao existe. Resultado:

 - os 8 servicos do DCS respondem 401 sob o contexto /api/ ;
 - /gerar existe FORA do contexto /api e NAO exige certificado. Espera
   {"CpfCnpj":"..."} no corpo e devolve Sucesso/Mensagem/Dados/Erros.
   Corpo vazio devolve 411 Length Required;
 - ConsultarExcecao e POST, nao GET. O DCS v1.1 esta errado nesse ponto:
   GET devolve 404 em todas as grafias testadas, POST devolve 401.
*/
#define CIOT_WS_GERAR              "/gerar"
#define CIOT_WS_SITUACAO           "/api/ConsultarSituacaoTransportador"
#define CIOT_WS_FROTA              "/api/ConsultarFrotaTransportador"
#define CIOT_WS_DECLARACAO         "/api/DeclaracaoOperacaoTransporte"
#define CIOT_WS_CANCELAMENTO       "/api/CancelamentoOperacaoTransporte"
#define CIOT_WS_RETIFICACAO        "/api/RetificacaoOperacaoTransporte"
#define CIOT_WS_ENCERRAMENTO       "/api/EncerramentoOperacaoTransporte"
#define CIOT_WS_EXCECAO            "/api/ConsultarExcecao"
#define CIOT_WS_CIOTGERADO         "/api/ConsultarCIOTGerado"

CREATE CLASS CIOTClass

   /* configuracao */

   VAR    cAmbiente       INIT CIOT_AMBIENTE_HOMOLOGACAO  // 1=producao 2=homologacao
   VAR    cCertificado    INIT ""                         // CN (NOME) do certificado - DescricaoDoCertificado()
   VAR    nTimeOut        INIT 30000                      // limite de espera por resposta em segundos * 1000
   VAR    cProxyUrl       INIT ""
   VAR    cProxyUser      INIT ""
   VAR    cProxyPassword  INIT ""

   /* etapas de cada chamada, se precisar conferir */

   VAR    cUrl            INIT ""      // endereco completo da ultima chamada
   VAR    cVerbo          INIT ""      // POST ou GET
   VAR    cJsonEnvio      INIT ""      // JSON enviado
   VAR    cJsonRetorno    INIT ""      // JSON recebido, cru
   VAR    hRetorno        INIT NIL     // JSON recebido, decodificado em hash
   VAR    nHttpStatus     INIT 0       // status HTTP da resposta

   /* retorno tratado */

   VAR    nStatus         INIT 0       // Codigo devolvido pela ANTT (999 = erro de comunicacao)
   VAR    cMotivo         INIT ""      // Mensagem devolvida pela ANTT
   VAR    cProtocolo      INIT ""      // Protocolo devolvido pela ANTT
   VAR    cAviso          INIT ""      // AvisoTransportador - apresentacao e impressao obrigatorias

   /* uso interno */

   VAR    cBaseUrl        INIT ""

   METHOD New( xAmbiente, cCertificado )
   METHOD Setup( xAmbiente, cCertificado )
   METHOD Enviar( cEndpoint, cVerbo, hDados )

   /* servicos do DCS PEF */

   METHOD GerarId( cCpfCnpj )
   METHOD StatusServico( cCpfCnpj, nRNTRC )
   METHOD FrotaTransportador( cCpfCnpj, nRNTRC, aPlacas )
   METHOD FrotaResultado()
   METHOD Cancelar( cCIOT, cMotivo )
   METHOD Retificar( cCIOT, nValorFrete, hCarga, dFimViagem, aOrigemDestino )
   METHOD Encerrar( cCIOT, nPesoCarga, aOrigemDestino )
   METHOD ConsultarSituacaoTransportador( hData )  INLINE ::Enviar( CIOT_WS_SITUACAO, "POST", hData )
   METHOD ConsultarFrotaTransportador( hData )     INLINE ::Enviar( CIOT_WS_FROTA, "POST", hData )
   METHOD DeclaracaoOperacaoTransporte( hData )    INLINE ::Enviar( CIOT_WS_DECLARACAO, "POST", hData )
   METHOD CancelamentoOperacaoTransporte( hData )  INLINE ::Enviar( CIOT_WS_CANCELAMENTO, "POST", hData )
   METHOD RetificacaoOperacaoTransporte( hData )   INLINE ::Enviar( CIOT_WS_RETIFICACAO, "POST", hData )
   METHOD EncerramentoOperacaoTransporte( hData )  INLINE ::Enviar( CIOT_WS_ENCERRAMENTO, "POST", hData )
   METHOD ConsultarCIOTGerado( hData )             INLINE ::Enviar( CIOT_WS_CIOTGERADO, "POST", hData )
   METHOD ConsultarExcecao( hData )                INLINE ::Enviar( CIOT_WS_EXCECAO, "POST", hData )

   /* apoio ao chamador */

   METHOD Sucesso()
   METHOD IdGerado()
   METHOD Retorno( cChave )                        INLINE CIOT_Texto( ::hRetorno, cChave )
   METHOD cStatus                                  SETGET

   /* obsoleto / compatibilidade */

   METHOD HttpPost( cEndpoint, hData )             INLINE ::Enviar( cEndpoint, "POST", hData )

   ENDCLASS

METHOD New( xAmbiente, cCertificado ) CLASS CIOTClass
/*
*/
   ::Setup( xAmbiente, cCertificado )

   RETURN Self

METHOD Setup( xAmbiente, cCertificado ) CLASS CIOTClass
/*
aceita ambiente como "1"/"2", numerico 1/2 ou logico (.T. = producao)
*/
   IF ! HB_IsNil( xAmbiente )
      DO CASE
      CASE ValType( xAmbiente ) == "C"
         ::cAmbiente := Left( AllTrim( xAmbiente ), 1 )
      CASE ValType( xAmbiente ) == "N"
         ::cAmbiente := IIf( xAmbiente == 1, CIOT_AMBIENTE_PRODUCAO, CIOT_AMBIENTE_HOMOLOGACAO )
      CASE ValType( xAmbiente ) == "L"
         ::cAmbiente := IIf( xAmbiente, CIOT_AMBIENTE_PRODUCAO, CIOT_AMBIENTE_HOMOLOGACAO )
      ENDCASE
   ENDIF

   IF ! HB_IsNil( cCertificado )
      ::cCertificado := cCertificado
   ENDIF

   IF ::cAmbiente == CIOT_AMBIENTE_PRODUCAO
      ::cBaseUrl := CIOT_URL_PRODUCAO
   ELSE
      ::cBaseUrl := CIOT_URL_HOMOLOGACAO
   ENDIF

   RETURN NIL

METHOD Enviar( cEndpoint, cVerbo, hDados ) CLASS CIOTClass
/*
transporte unico de todos os servicos
*/
   LOCAL oServer, lOk, cResposta

   ::cUrl         := ::cBaseUrl + cEndpoint
   ::cVerbo       := IIf( HB_IsNil( cVerbo ), "POST", Upper( AllTrim( cVerbo ) ) )
   ::cJsonEnvio   := IIf( HB_IsNil( hDados ), "", HB_JsonEncode( hDados ) )
   ::cJsonRetorno := ""
   ::hRetorno     := NIL
   ::nHttpStatus  := 0
   ::nStatus      := 0
   ::cMotivo      := ""
   ::cProtocolo   := ""
   ::cAviso       := ""

   IF Empty( ::cBaseUrl )
      ::nStatus := CIOT_ERRO_COMUNICACAO
      ::cMotivo := "Erro de comunicacao: sem endereco de webservice"
      RETURN NIL
   ENDIF

   lOk := .F.
   BEGIN SEQUENCE WITH __BreakBlock()
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP.6.0" )
      lOk := .T.
   ENDSEQUENCE
   IF ! lOk
      ::nStatus := CIOT_ERRO_COMUNICACAO
      ::cMotivo := "Erro no uso do objeto MSXML2.ServerXMLHTTP.6.0"
      RETURN NIL
   ENDIF

   IF ! Empty( ::cCertificado )
      oServer:SetOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
   ENDIF
   oServer:SetTimeOuts( ::nTimeOut, ::nTimeOut, ::nTimeOut, ::nTimeOut )

   lOk := .F.
   BEGIN SEQUENCE WITH __BreakBlock()
      oServer:Open( ::cVerbo, ::cUrl, .F. )
      lOk := .T.
   ENDSEQUENCE
   IF ! lOk
      ::nStatus := CIOT_ERRO_COMUNICACAO
      ::cMotivo := "Erro no Open() do endereco " + ::cUrl
      RETURN NIL
   ENDIF

   IF ! Empty( ::cProxyUrl )
      oServer:SetProxy( 2, ::cProxyUrl )
      IF ! Empty( ::cProxyUser ) .OR. ! Empty( ::cProxyPassword )
         oServer:SetProxyCredentials( ::cProxyUser, ::cProxyPassword )
      ENDIF
   ENDIF

   oServer:SetRequestHeader( "Content-Type", "application/json; charset=utf-8" )
   oServer:SetRequestHeader( "Accept", "application/json" )

   lOk := .F.
   BEGIN SEQUENCE WITH __BreakBlock()
      IF ::cVerbo == "GET"
         oServer:Send()
      ELSE
         oServer:SetRequestHeader( "content-Length", LTrim( Str( Len( ::cJsonEnvio ) ) ) )
         oServer:Send( ::cJsonEnvio )
      ENDIF
      lOk := .T.
   ENDSEQUENCE
   IF ! lOk
      ::nStatus := CIOT_ERRO_COMUNICACAO
      ::cMotivo := "Erro no Send() do endereco " + ::cUrl
      RETURN NIL
   ENDIF

   BEGIN SEQUENCE WITH __BreakBlock()
      ::nHttpStatus := oServer:Status
   ENDSEQUENCE

   BEGIN SEQUENCE WITH __BreakBlock()
      cResposta := oServer:ResponseText
   ENDSEQUENCE
   IF ValType( cResposta ) != "C"
      cResposta := ""
   ENDIF
   ::cJsonRetorno := cResposta

   IF Empty( cResposta )
      ::nStatus := CIOT_ERRO_COMUNICACAO
      ::cMotivo := "Sem retorno do webservice (HTTP " + HB_NToS( ::nHttpStatus ) + ")"
      RETURN NIL
   ENDIF

   BEGIN SEQUENCE WITH __BreakBlock()
      ::hRetorno := HB_JsonDecode( cResposta )
   ENDSEQUENCE

   IF ! HB_ISHASH( ::hRetorno )
      ::nStatus := CIOT_ERRO_COMUNICACAO
      ::cMotivo := "Retorno nao e um JSON valido (HTTP " + HB_NToS( ::nHttpStatus ) + "): " + ;
                   Left( cResposta, 200 )
      RETURN ::hRetorno
   ENDIF

   ::nStatus    := Val( CIOT_Texto( ::hRetorno, "Codigo" ) )
   ::cProtocolo := CIOT_Texto( ::hRetorno, "Protocolo" )
   ::cAviso     := CIOT_Texto( ::hRetorno, "AvisoTransportador" )
   ::cMotivo    := CIOT_Mensagem( ::hRetorno )

   IF ::nStatus == 0 .AND. ::nHttpStatus != 200
      ::nStatus := CIOT_ERRO_COMUNICACAO
      IF Empty( ::cMotivo )
         ::cMotivo := "Retorno HTTP " + HB_NToS( ::nHttpStatus )
      ENDIF
   ENDIF

   RETURN ::hRetorno

METHOD GerarId( cCpfCnpj ) CLASS CIOTClass
/*
POST /pefServices/gerar - devolve o IdOperacaoTransporte de 12 digitos.
Fica FORA do contexto /api e nao exige certificado cliente.
Retorno no formato Sucesso / Mensagem / Dados / Erros; o identificador vem
em ::hRetorno[ "Dados" ].
*/
   LOCAL hData := HB_Hash()

   hData[ "CpfCnpj" ] := CIOT_SoDigitos( cCpfCnpj, .T. )

   RETURN ::Enviar( CIOT_WS_GERAR, "POST", hData )

METHOD StatusServico( cCpfCnpj, nRNTRC ) CLASS CIOTClass
/*
A ANTT nao tem servico de status como o NfeStatusServico da SEFAZ. Uma unica
chamada ao ConsultarSituacaoTransportador (servico 01 do DCS) faz esse papel:
nao grava nada, nao consome IdOperacaoTransporte e testa de uma vez a
comunicacao, o certificado (regra C1) e o RNTRC.

Leitura do resultado - o 401 nao traz Codigo e o Enviar() o converte em 999,
entao quem separa "fora do ar" de "no ar, mas recusado" e o ::nHttpStatus:
   ::nHttpStatus == 0    - sem resposta HTTP: servico fora do ar, rede ou TLS
   ::nHttpStatus == 401  - servico no ar; ::Retorno( "error" ) diz o motivo:
                           CERTIFICADO_NAO_FORNECIDO - certificado nao enviado
                           USUARIO_NAO_AUTORIZADO    - CNPJ do certificado fora do RNTRC
   ::nStatus     == 111  - servico no ar e transportador encontrado; conferir
                           ::Retorno( "RNTRCAtivo" ), ::Retorno( "TipoTransportador" )
                           e ::Retorno( "EquiparadoTAC" ) - "true"/"false" em texto

O transportador consultado e o proprio dono do certificado, por isso o CNPJ
vai nos dois campos. O RNTRC vem numerico da tabela e perde zero a esquerda:
o PadL ate 9 cobre isso e atende a regra B60.
*/
   LOCAL hData := HB_Hash(), cDocumento, cRNTRC

   cDocumento := CIOT_SoDigitos( cCpfCnpj, .T. )
   cRNTRC     := IIf( HB_ISNUMERIC( nRNTRC ), HB_NToS( nRNTRC ), CIOT_SoDigitos( nRNTRC ) )

   hData[ "CpfCnpjInteressado"   ] := cDocumento
   hData[ "CpfCnpjTransportador" ] := cDocumento
   hData[ "RNTRCTransportador"   ] := PadL( cRNTRC, 9, "0" )

   RETURN ::ConsultarSituacaoTransportador( hData )

METHOD FrotaTransportador( cCpfCnpj, nRNTRC, aPlacas ) CLASS CIOTClass
/*
ConsultarFrotaTransportador (servico 02 do DCS): diz, para cada placa informada,
se ela pertence a frota do transportador. NAO informa o tipo do veiculo
(automotor/implemento). Mesma montagem do StatusServico: o transportador
consultado e o dono do certificado. Nao grava nada e nao consome Id.
O resultado, placa a placa, sai em ::FrotaResultado().
*/
   LOCAL hData := HB_Hash(), cDocumento, cRNTRC

   cDocumento := CIOT_SoDigitos( cCpfCnpj, .T. )
   cRNTRC     := IIf( HB_ISNUMERIC( nRNTRC ), HB_NToS( nRNTRC ), CIOT_SoDigitos( nRNTRC ) )

   hData[ "CpfCnpjInteressado"   ] := cDocumento
   hData[ "CpfCnpjTransportador" ] := cDocumento
   hData[ "RNTRCTransportador"   ] := PadL( cRNTRC, 9, "0" )
   hData[ "Placas"               ] := aPlacas

   RETURN ::ConsultarFrotaTransportador( hData )

METHOD FrotaResultado() CLASS CIOTClass
/*
lista { { cPlaca, lPertence }, ... } a partir do "Frota" do retorno. O DCS descreve
SituacaoVeiculoFrotaTransportador como true/false, mas o exemplo traz 0: aceita
logico, numero ou texto. As chaves sao procuradas sem diferenciar maiusculas - a
ANTT real ja divergiu do DCS na grafia dos campos.
*/
   LOCAL aLista := {}, xFrota, xItem

   xFrota := CIOT_Valor( ::hRetorno, "Frota" )

   IF ! HB_ISARRAY( xFrota )
      RETURN aLista
   ENDIF

   FOR EACH xItem IN xFrota
      IF HB_ISHASH( xItem )
         AAdd( aLista, { CIOT_Escalar( CIOT_Valor( xItem, "PlacaVeiculo" ) ), ;
                         CIOT_Verdadeiro( CIOT_Valor( xItem, "SituacaoVeiculoFrotaTransportador" ) ) } )
      ENDIF
   NEXT

   RETURN aLista

METHOD Cancelar( cCIOT, cMotivo ) CLASS CIOTClass
/*
CancelamentoOperacaoTransporte (servico 04 do DCS). cCIOT com os 16 digitos
(identificador + verificador); cMotivo obrigatorio, ate 500 caracteres, enviado
como recebido (mesmo padrao da sefazclass: o MSXML converte o corpo para UTF-8).
Regras do DCS: B34 (220 - CIOT inexistente), B35 (221 - ate 24 horas apos a data
de inicio da viagem), B36 (235 - ja consultado pela fiscalizacao), B37/B38
(222/251 - ja cancelado/encerrado), B113 (312 - CIOT de outro CPF/CNPJ).
Saida: CodigoIdentificacaoOperacao, DataCancelamento, Protocolo, Codigo, Mensagem.
*/
   LOCAL hData := HB_Hash()

   hData[ "CodigoIdentificacaoOperacao" ] := CIOT_SoDigitos( cCIOT )
   hData[ "MotivoCancelamento"          ] := IIf( HB_ISCHAR( cMotivo ), Left( AllTrim( cMotivo ), 500 ), "" )

   RETURN ::CancelamentoOperacaoTransporte( hData )

METHOD Retificar( cCIOT, nValorFrete, hCarga, dFimViagem, aOrigemDestino ) CLASS CIOTClass
/*
RetificacaoOperacaoTransporte (servico 05 do DCS). cCIOT com os 16 digitos
(identificador + verificador). So vai no JSON o que vier preenchido, entao o
chamador passa apenas os campos que o tipo da operacao aceita:
   tipo 1 - carga lotacao: NAO pode ser retificada (B121 - 320)
   tipo 2 - carga fracionada: nValorFrete e/ou hCarga, com as mesmas chaves da
            declaracao (CodigoNaturezaCarga, PesoCarga, CodigoTipoCarga).
            dFimViagem e aOrigemDestino sao proibidos (B57 - 274).
            Prazo: ate o encerramento da operacao (B39 - 236)
   tipo 3 - TAC-Agregado: dFimViagem e aOrigemDestino obrigatorios (B58 - 280).
            Prazo: ate 30 dias apos a data de fim da viagem (B39 - 236)
aOrigemDestino: array de hashes { "Origem" => {...}, "Destino" => {...} } montado
pelo chamador - a classe nao le tabela do ERP.
Demais regras: B34 (220 - CIOT inexistente), B37/B38 (222/251 - ja cancelada ou
encerrada), B40 (237 - ja consultada pela fiscalizacao), B113 (312 - CIOT de outro
CPF/CNPJ), B120 (319 - frete maior que zero).
Saida: CodigoIdentificacaoOperacao, DataRetificacao, Protocolo, Codigo, Mensagem.
*/
   LOCAL hData := HB_Hash()

   hData[ "CodigoIdentificacaoOperacao" ] := CIOT_SoDigitos( cCIOT )

   IF HB_ISNUMERIC( nValorFrete ) .AND. nValorFrete > 0
      hData[ "ValorFrete" ] := nValorFrete
   ENDIF

   IF HB_ISDATE( dFimViagem ) .AND. ! Empty( dFimViagem )
      hData[ "DataFimViagem" ] := Transform( DToS( dFimViagem ), "@R 9999-99-99" )
   ENDIF

   IF HB_ISARRAY( aOrigemDestino ) .AND. ! Empty( aOrigemDestino )
      hData[ "OrigemDestino" ] := aOrigemDestino
   ENDIF

   IF HB_ISHASH( hCarga ) .AND. ! Empty( hCarga )
      hData[ "DadosCarga" ] := hCarga
   ENDIF

   RETURN ::RetificacaoOperacaoTransporte( hData )

METHOD Encerrar( cCIOT, nPesoCarga, aOrigemDestino ) CLASS CIOTClass
/*
EncerramentoOperacaoTransporte (servico 06 do DCS): declara que a operacao foi
executada e chegou ao fim. cCIOT com os 16 digitos. So vai no JSON o que vier
preenchido:
   tipo 1 - carga lotacao: nPesoCarga obrigatorio e maior que zero (B65 - 239,
            B18 - 226)
   tipo 2 - carga fracionada: somente o CIOT - peso e OrigemDestino sao proibidos
            (B57 - 274)
   tipo 3 - TAC-Agregado: aOrigemDestino obrigatorio, cada item com Origem, Destino,
            DistanciaPercorrida (km) e QtdViagens (B58 - 280). Prazo: ate 10 dias
            apos a data de inicio da viagem (B116 - 315)
Demais regras: B34 (220), B37/B38 (222/251 - ja cancelada ou encerrada), B46 (263 -
nao encerra antes da data de inicio), B113 (312).
Saida: CodigoIdentificacaoOperacao, DataEncerramento, Protocolo, Codigo, Mensagem.

ATENCAO - o DCS v1.1 se contradiz no peso: a tabela chama o campo de PesoCarga e o
exemplo JSON usa DadosCarga.PesoTotalCarga. A ANTT real ja seguiu o exemplo contra a
tabela (IdOperacaoTransporte). Ate o primeiro encerramento real mostrar qual vale, as
duas chaves vao dentro de DadosCarga; conferir no teste e remover a que sobrar.
*/
   LOCAL hData := HB_Hash(), hCarga

   hData[ "CodigoIdentificacaoOperacao" ] := CIOT_SoDigitos( cCIOT )

   IF HB_ISARRAY( aOrigemDestino ) .AND. ! Empty( aOrigemDestino )
      hData[ "OrigemDestino" ] := aOrigemDestino
   ENDIF

   IF HB_ISNUMERIC( nPesoCarga ) .AND. nPesoCarga > 0
      hCarga := HB_Hash()
      hCarga[ "PesoCarga"      ] := nPesoCarga
      hCarga[ "PesoTotalCarga" ] := nPesoCarga
      hData[ "DadosCarga" ] := hCarga
   ENDIF

   RETURN ::EncerramentoOperacaoTransporte( hData )

METHOD Sucesso() CLASS CIOTClass
/*
cobre os tres formatos de retorno da ANTT
*/
   LOCAL lOk

   DO CASE
   CASE ::nStatus == CIOT_ERRO_COMUNICACAO
      lOk := .F.
   CASE ::nStatus == CIOT_SUCESSO_INCLUSAO .OR. ::nStatus == CIOT_SUCESSO_CONSULTA
      lOk := .T.
   CASE HB_ISHASH( ::hRetorno ) .AND. HB_HHasKey( ::hRetorno, "Codigo" ) .AND. ;
        Empty( CIOT_Texto( ::hRetorno, "Codigo" ) ) .AND. CIOT_TemConfirmacao( ::hRetorno )
      // a ANTT real manda Codigo nulo (a rejeicao veio assim); o campo de confirmacao
      // de cada servico so vem preenchido quando a ANTT aceitou
      lOk := .T.
   CASE HB_ISHASH( ::hRetorno ) .AND. HB_HHasKey( ::hRetorno, "Codigo" )
      // formato do DCS: so 110 e 111 sao sucesso ("Final do Processamento da
      // Solicitacao"); qualquer outro Codigo e rejeicao, mesmo que venha com HTTP 200
      lOk := .F.
   CASE HB_ISHASH( ::hRetorno ) .AND. HB_HHasKey( ::hRetorno, "Sucesso" )
      lOk := ( CIOT_Texto( ::hRetorno, "Sucesso" ) == "true" )
   OTHERWISE
      lOk := ( ::nHttpStatus == 200 )
   ENDCASE

   RETURN lOk

STATIC FUNCTION CIOT_TemConfirmacao( hRetorno )
/*
campo que so vem preenchido quando o servico foi aceito:
   declaracao    - CodigoVerificador
   cancelamento  - DataCancelamento
   retificacao   - DataRetificacao
   encerramento  - DataEncerramento
*/
   LOCAL cChave

   FOR EACH cChave IN { "CodigoVerificador", "DataCancelamento", "DataRetificacao", "DataEncerramento" }
      IF ! Empty( CIOT_Texto( hRetorno, cChave ) )
         RETURN .T.
      ENDIF
   NEXT

   RETURN .F.

METHOD IdGerado() CLASS CIOTClass
/*
O /gerar devolve o IdOperacaoTransporte de 12 digitos aninhado em Dados.CIOT.
Atencao: apesar do nome usado pela ANTT na resposta, esse valor NAO e o CIOT
definitivo - e o IdOperacaoTransporte que se envia em DeclaracaoOperacaoTransporte.
O CIOT final (16) vem de la, em CodigoIdentificacaoOperacao + CodigoVerificador.

Cada chamada de GerarId() consome um Id novo (a ANTT usa contador sequencial),
entao gravar o retorno antes de declarar e reaproveita-lo em caso de retentativa.
*/
   LOCAL xDados

   IF ! HB_ISHASH( ::hRetorno ) .OR. ! HB_HHasKey( ::hRetorno, "Dados" )
      RETURN ""
   ENDIF

   xDados := ::hRetorno[ "Dados" ]

   IF ! HB_ISHASH( xDados )
      RETURN ""
   ENDIF

   RETURN CIOT_Texto( xDados, "CIOT" )

METHOD cStatus( xValue ) CLASS CIOTClass
/*
mesma convencao da sefazclass: status como texto para gravar/exibir
*/
   xValue := StrZero( ::nStatus, 3 )

   RETURN xValue

STATIC FUNCTION CIOT_Mensagem( hRetorno )
/*
a ANTT devolve a mensagem em tres formatos diferentes:
   DCS          - Codigo / Mensagem / Protocolo
   erro de auth - error / message / timestamp
   /gerar       - Sucesso / Mensagem / Dados / Erros
e o IIS/WebAPI usa Message nos 400/404 de roteamento.
*/
   LOCAL cTexto := "", cChave, cErros

   FOR EACH cChave IN { "Mensagem", "message", "Message", "error" }
      cTexto := CIOT_Texto( hRetorno, cChave )
      IF ! Empty( cTexto )
         EXIT
      ENDIF
   NEXT

   cErros := CIOT_Texto( hRetorno, "Erros" )
   IF ! Empty( cErros )
      cTexto += IIf( Empty( cTexto ), "", " - " ) + cErros
   ENDIF

   RETURN cTexto

STATIC FUNCTION CIOT_Texto( hRetorno, cChave )
/*
o DCS declara Codigo e Mensagem como array; aqui vira texto unico
*/
   LOCAL xValor, xDecod, cTexto := "", nCont

   IF ! HB_ISHASH( hRetorno ) .OR. ! HB_HHasKey( hRetorno, cChave )
      RETURN ""
   ENDIF

   xValor := hRetorno[ cChave ]

   // a ANTT real devolve a Mensagem como TEXTO contendo um array JSON:
   // "[\"Rejeicao: ...\"]" - decodifica para juntar os itens sem colchetes
   IF HB_ISCHAR( xValor ) .AND. Left( AllTrim( xValor ), 1 ) == "[" .AND. Right( AllTrim( xValor ), 1 ) == "]"
      BEGIN SEQUENCE WITH __BreakBlock()
         xDecod := HB_JsonDecode( AllTrim( xValor ) )
         IF HB_ISARRAY( xDecod )
            xValor := xDecod
         ENDIF
      ENDSEQUENCE
   ENDIF

   IF HB_ISARRAY( xValor )
      FOR nCont := 1 TO Len( xValor )
         cTexto += IIf( Empty( cTexto ), "", " - " ) + CIOT_Escalar( xValor[ nCont ] )
      NEXT
   ELSE
      cTexto := CIOT_Escalar( xValor )
   ENDIF

   RETURN cTexto

STATIC FUNCTION CIOT_Escalar( xValor )
/*
*/
   LOCAL cTexto := ""

   DO CASE
   CASE HB_IsNil( xValor )
   CASE HB_ISCHAR( xValor )
      cTexto := AllTrim( xValor )
   CASE HB_ISNUMERIC( xValor )
      cTexto := HB_NToS( xValor )
   CASE HB_ISLOGICAL( xValor )
      cTexto := IIf( xValor, "true", "false" )
   ENDCASE

   RETURN cTexto

STATIC FUNCTION CIOT_Valor( hDados, cChave )
/*
valor da chave sem diferenciar maiusculas/minusculas; NIL se nao existir
*/
   LOCAL cItem

   IF ! HB_ISHASH( hDados )
      RETURN NIL
   ENDIF

   IF HB_HHasKey( hDados, cChave )
      RETURN hDados[ cChave ]
   ENDIF

   FOR EACH cItem IN HB_HKeys( hDados )
      IF Upper( cItem ) == Upper( cChave )
         RETURN hDados[ cItem ]
      ENDIF
   NEXT

   RETURN NIL

STATIC FUNCTION CIOT_Verdadeiro( xValor )
/*
.T. para true, numero diferente de zero ou texto "true"/"1"/"s"/"sim"
*/
   LOCAL cTexto

   DO CASE
   CASE HB_ISLOGICAL( xValor )
      RETURN xValor
   CASE HB_ISNUMERIC( xValor )
      RETURN xValor != 0
   CASE HB_ISCHAR( xValor )
      cTexto := Lower( AllTrim( xValor ) )
      RETURN cTexto == "true" .OR. cTexto == "1" .OR. cTexto == "s" .OR. cTexto == "sim"
   ENDCASE

   RETURN .F.

STATIC FUNCTION CIOT_SoDigitos( cValor, lLetras )
/*
mesma semantica do SoNumeros() do projeto: com lLetras = .T. mantem tambem as
letras (CPF/CNPJ - CNPJ alfanumerico em vigor); sem ele, so digitos
*/
   LOCAL cTexto := "", nCont, cChr

   IF ! HB_ISCHAR( cValor )
      RETURN ""
   ENDIF

   HB_Default( @lLetras, .F. )

   FOR nCont := 1 TO Len( cValor )
      cChr := SubStr( cValor, nCont, 1 )
      IF IsDigit( cChr ) .OR. ( lLetras .AND. IsAlpha( cChr ) )
         cTexto += cChr
      ENDIF
   NEXT

   RETURN cTexto

/*
================================================================================
CIOT_Teste() - diagnostico da comunicacao com a ANTT/PEF

Roda as etapas em sequencia e isola onde falhou:
   etapa 1 - GerarId ......................... NAO exige certificado
   etapa 2 - ConsultarSituacaoTransportador .. exige certificado
   etapa 3 - ConsultarExcecao ................ exige certificado

Se a 1 passa e a 2 devolve 401, o problema e o certificado: ou nao chegou
(setOption 3 / friendly name), ou o CNPJ nao esta habilitado na ANTT.
O tramite cru de cada etapa fica gravado na tabela NFEAuxiliar.
================================================================================
*/

//FUNCTION CIOT_Teste()
///*
//*/
//   LOCAL oCIOT, oWait, cCNPJ, cRNTRC, cAmbiente, cLog := "", cTitulo
//
//   cCNPJ  := PadR( RetornaCNPJDaFilialBase(), 18 )
//   cRNTRC := Space( 9 )
//
//   IF ! MsgGet( "CIOT - Teste ANTT", "CPF/CNPJ do transportador", @cCNPJ )
//      RETURN NIL
//   ENDIF
//
//   cCNPJ := CIOT_SoDigitos( cCNPJ, .T. )
//
//   IF Empty( cCNPJ )
//      MsgStop( "Informe o CPF/CNPJ!", "Atenção!" )
//      RETURN NIL
//   ENDIF
//
//   IF ! MsgGet( "CIOT - Teste ANTT", "RNTRC (vazio pula as etapas 2 e 3)", @cRNTRC )
//      RETURN NIL
//   ENDIF
//
//   cRNTRC    := CIOT_SoDigitos( cRNTRC )
//   cAmbiente := IIf( YesNo( "Testar em HOMOLOGAÇÃO?" + CIOT_CRLF + ;
//                            "(Não = PRODUÇÃO)" ), "2", "1" )
//   cTitulo   := "CIOT - " + IIf( cAmbiente == "2", "Homologação", "Produção" )
//
//   oCIOT := CIOTClass():New( cAmbiente, DescricaoDoCertificado() )
//
//   WaitOn( @oWait, { "Aguarde...", "Testando ANTT/PEF..." } )
//
//   cLog += "Base URL...: " + oCIOT:cBaseUrl + CIOT_CRLF
//   cLog += "Certificado: " + IIf( Empty( oCIOT:cCertificado ), "(NENHUM CONFIGURADO)", ;
//                                  AllTrim( oCIOT:cCertificado ) ) + CIOT_CRLF
//   cLog += "CPF/CNPJ...: " + cCNPJ + CIOT_CRLF
//   cLog += "RNTRC......: " + IIf( Empty( cRNTRC ), "(nao informado)", cRNTRC ) + CIOT_CRLF
//   cLog += Replicate( "-", 64 ) + CIOT_CRLF + CIOT_CRLF
//
//   // etapa 1 - nao exige certificado
//   oCIOT:GerarId( cCNPJ )
//   cLog += CIOT_TesteBloco( oCIOT, "1) GerarId .................. NAO exige certificado" )
//   cLog += "   Id gerado.: " + IIf( Empty( oCIOT:IdGerado() ), "(vazio)", oCIOT:IdGerado() ) + ;
//           CIOT_CRLF + CIOT_CRLF
//   CIOT_TesteGrava( "CIOT_Teste_1_GerarId", oCIOT )
//
//   // etapa 2 - exige certificado e so precisa do CPF/CNPJ, por isso roda sempre.
//   // e o teste mais limpo do certificado: erro de negocio aqui ja significa
//   // que a autenticacao passou.
//   oCIOT:ConsultarExcecao( CIOT_TesteHashExcecao( cCNPJ ) )
//   cLog += CIOT_TesteBloco( oCIOT, "2) ConsultarExcecao ......... exige certificado" )
//   cLog += "   " + CIOT_TesteLaudo( oCIOT ) + CIOT_CRLF + CIOT_CRLF
//   CIOT_TesteGrava( "CIOT_Teste_2_Excecao", oCIOT )
//
//   // etapa 3 - exige certificado e RNTRC
//   IF ! Empty( cRNTRC )
//      oCIOT:ConsultarSituacaoTransportador( CIOT_TesteHashSituacao( cCNPJ, cRNTRC ) )
//      cLog += CIOT_TesteBloco( oCIOT, "3) ConsultarSituacaoTransportador ... exige certificado" )
//      cLog += "   " + CIOT_TesteLaudo( oCIOT ) + CIOT_CRLF
//      CIOT_TesteGrava( "CIOT_Teste_3_Situacao", oCIOT )
//   ELSE
//      cLog += "3) ConsultarSituacaoTransportador - pulada, RNTRC nao informado." + CIOT_CRLF
//   ENDIF
//
//   WaitOff( oWait )
//
//   MsgInfo( cLog, cTitulo )
//
//   RETURN NIL
//
//STATIC FUNCTION CIOT_TesteBloco( oCIOT, cTitulo )
///*
//*/
//   LOCAL cTexto := ""
//
//   cTexto += cTitulo + CIOT_CRLF
//   cTexto += "   URL.......: " + AllTrim( oCIOT:cUrl ) + CIOT_CRLF
//   cTexto += "   HTTP......: " + HB_NToS( oCIOT:nHttpStatus ) + CIOT_CRLF
//   cTexto += "   Sucesso...: " + IIf( oCIOT:Sucesso(), "SIM", "NAO" ) + CIOT_CRLF
//   cTexto += "   Status....: " + oCIOT:cStatus + CIOT_CRLF
//   cTexto += "   Motivo....: " + AllTrim( oCIOT:cMotivo ) + CIOT_CRLF
//
//   IF ! Empty( oCIOT:cProtocolo )
//      cTexto += "   Protocolo.: " + AllTrim( oCIOT:cProtocolo ) + CIOT_CRLF
//   ENDIF
//
//   IF ! Empty( oCIOT:cAviso )
//      cTexto += "   Aviso.....: " + AllTrim( oCIOT:cAviso ) + CIOT_CRLF
//   ENDIF
//
//   cTexto += "   JSON......: " + Left( AllTrim( oCIOT:cJsonRetorno ), 220 ) + CIOT_CRLF
//
//   RETURN cTexto
//
//STATIC FUNCTION CIOT_TesteLaudo( oCIOT )
///*
//traduz o retorno de uma etapa que exige certificado.
//o importante: erro de NEGOCIO significa que a autenticacao passou.
//*/
//   LOCAL cLaudo
//
//   DO CASE
//   CASE oCIOT:nStatus == CIOT_ERRO_COMUNICACAO .AND. oCIOT:nHttpStatus == 0
//      cLaudo := ">> Nao chegou na ANTT. Falha de rede/TLS no MSXML."
//   CASE oCIOT:nHttpStatus == 401 .AND. "CERTIFICADO_NAO_FORNECIDO" $ Upper( oCIOT:cJsonRetorno )
//      cLaudo := ">> O certificado NAO foi enviado. Rever setOption(3) e o nome do certificado."
//   CASE oCIOT:nHttpStatus == 401 .AND. "USUARIO_NAO_AUTORIZADO" $ Upper( oCIOT:cJsonRetorno )
//      cLaudo := ">> Certificado ENVIADO e LIDO pela ANTT (regra C1 do DCS). O CNPJ do " + ;
//                "certificado nao e transportador ativo no RNTRC: use o certificado da " + ;
//                "propria transportadora. Nao existe cadastro a pedir, o RNTRC e a porta."
//   CASE oCIOT:nHttpStatus == 401 .OR. oCIOT:nHttpStatus == 403
//      cLaudo := ">> Certificado enviado, mas sem autorizacao para esta operacao."
//   CASE oCIOT:nHttpStatus == 200
//      cLaudo := ">> CERTIFICADO OK e CNPJ HABILITADO."
//   OTHERWISE
//      cLaudo := ">> Certificado ACEITO. O erro acima e de negocio, nao de autenticacao."
//   ENDCASE
//
//   RETURN cLaudo
//
//STATIC FUNCTION CIOT_TesteGrava( cNomeArquivo, oCIOT )
///*
//grava o tramite cru na NFEAuxiliar, mesmo idioma do MDFe_GerarXML.prg
//*/
//   LOCAL cTexto := ""
//
//   cTexto += "URL....: " + AllTrim( oCIOT:cUrl ) + CIOT_CRLF
//   cTexto += "VERBO..: " + AllTrim( oCIOT:cVerbo ) + CIOT_CRLF
//   cTexto += "HTTP...: " + HB_NToS( oCIOT:nHttpStatus ) + CIOT_CRLF
//   cTexto += "STATUS.: " + oCIOT:cStatus + CIOT_CRLF
//   cTexto += "MOTIVO.: " + AllTrim( oCIOT:cMotivo ) + CIOT_CRLF + CIOT_CRLF
//   cTexto += "ENVIO..: " + CIOT_CRLF + oCIOT:cJsonEnvio + CIOT_CRLF + CIOT_CRLF
//   cTexto += "RETORNO: " + CIOT_CRLF + oCIOT:cJsonRetorno
//
//   Grava_Campos_Tabela_NFEAuxiliar_Arquivo( cNomeArquivo, cTexto, .F. )
//
//   RETURN NIL
//
//STATIC FUNCTION CIOT_TesteHashSituacao( cCNPJ, cRNTRC )
///*
//leiaute do DCS PEF v1.1 - servico 01 ConsultarSituacaoTransportador.
//RNTRC com 8 digitos deve ser completado com zero a esquerda ate 9 (regra B60).
//*/
//   LOCAL hData := HB_Hash()
//
//   hData[ "CpfCnpjInteressado"   ] := cCNPJ
//   hData[ "CpfCnpjTransportador" ] := cCNPJ
//   hData[ "RNTRCTransportador"   ] := PadL( cRNTRC, 9, "0" )
//
//   RETURN hData
//
//STATIC FUNCTION CIOT_TesteHashExcecao( cCNPJ )
///*
//o DCS documenta ConsultarExcecao como GET com o parametro CPFCNPJTransportador,
//mas a homologacao so responde a POST (GET devolve 404). O nome do campo dentro
//do corpo ainda NAO foi confirmado - se voltar erro de campo, ajustar aqui.
//*/
//   LOCAL hData := HB_Hash()
//
//   hData[ "CPFCNPJTransportador" ] := cCNPJ
//
//   RETURN hData
