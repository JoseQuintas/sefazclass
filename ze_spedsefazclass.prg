/*
ZE_SPEDSEFAZCLASS - Rotinas pra comunicação com SEFAZ

2016.11.25.1600 - Se colocar XML version="1.00" o explorer não abre o XML
2016.11.25.2300 - ::AssinaXml() e CapicomAssinaXml() pra evitar confusão no uso
2016.11.25.2300 - ::ValidaXml() e DomDocValidaXml() pra evitar confusão no uso
2016.12.01.0230 - NFE 4.00 início
2017.01.13.1120 - Endereços RS CTE homologação
2017.05.05.1930 - Grava status e motivo, ref. recibo, pra erros de envio de lote
2017.05.24.2040 - Webservice de autorização de NFE do Acre
2017.05.31.0930 - Reduz ano com 2 dígitos na inutilização
2017.06.01.0230 - Configuração da versão de CTE, MDFE e NFE

Nota: CTE 2.00 vale até 10/2017, CTE 2.00 até 12/2017, NFE 3.10 até 04/2018
*/

#include "hbclass.ch"

#define WS_CTE_CONSULTACADASTRO      1
#define WS_CTE_CONSULTAPROTOCOLO     2
#define WS_CTE_INUTILIZACAO          3
#define WS_CTE_RECEPCAO              4
#define WS_CTE_RECEPCAOEVENTO        5
#define WS_CTE_RETRECEPCAO           6
#define WS_CTE_STATUSSERVICO         7

#define WS_NFE_AUTORIZACAO           8
#define WS_NFE_RETAUTORIZACAO        9
#define WS_NFE_CANCELAMENTO          10
#define WS_NFE_CONSULTACADASTRO      11
#define WS_NFE_CONSULTAPROTOCOLO     12
#define WS_NFE_INUTILIZACAO          13
#define WS_NFE_RECEPCAO              14
#define WS_NFE_RECEPCAOEVENTO        15
#define WS_NFE_RETRECEPCAO           16
#define WS_NFE_STATUSSERVICO         17

#define WS_MDFE_RECEPCAO             18
#define WS_MDFE_RETRECEPCAO          19
#define WS_MDFE_RECEPCAOEVENTO       20
#define WS_MDFE_CONSULTA             21
#define WS_MDFE_STATUSSERVICO        22
#define WS_MDFE_CONSNAOENC           23

#define WS_NFE_DISTRIBUICAODFE       24
#define WS_MDFE_DISTRIBUICAODFE      25
#define WS_NFE_DOWNLOADNF            26
#define WS_NFE_CONSULTADEST          27

#define WS_AMBIENTE_HOMOLOGACAO      "2"
#define WS_AMBIENTE_PRODUCAO         "1"

#define WS_PROJETO_NFE               "nfe"
#define WS_PROJETO_CTE               "cte"
#define WS_PROJETO_MDFE              "mdfe"

#define WS_VERSAO_CTE  "2.00"
#define WS_VERSAO_MDFE "1.00"
#define WS_VERSAO_NFE  "3.10"

#define INDSINC_RETORNA_PROTOCOLO    "1"
#define INDSINC_RETORNA_RECIBO       "0"

#define XML_UTF8                     [<?xml version="1.0" encoding="UTF-8"?>]

CREATE CLASS SefazClass

   /* configuração */
   VAR    cProjeto       INIT WS_PROJETO_NFE          // Modificada conforme método
   VAR    cAmbiente      INIT WS_AMBIENTE_PRODUCAO
   VAR    cVersao        INIT "*DEFAULT*"             // Default NFE 3.10, MDFE 1.00, CTE 2.00 (Próximas 4.00,3.00,3.00)
   VAR    cScan          INIT "N"                     // Indicar se for SCAN/SVAN, ainda não testado
   VAR    cUF            INIT "SP"                    // Modificada conforme método
   VAR    cCertificado   INIT ""                      // Nome do certificado
   VAR    ValidFromDate  INIT ""                      // Validade do certificado
   VAR    ValidToDate    INIT ""                      // Validade do certificado
   VAR    cIndSinc       INIT INDSINC_RETORNA_RECIBO  // Poucas UFs opção de protocolo
   VAR    nTempoEspera   INIT 7                       // intervalo entre envia lote e consulta recibo
   VAR    cUFTimeZone    INIT "SP"                    // Para DateTimeXml() Obrigatório definir UF default
   VAR    cIdToken       INIT ""                      // Para NFCe obrigatorio identificador do CSC Código de Segurança do Contribuinte
   VAR    cCSC           INIT ""                      // Para NFCe obrigatorio CSC Código de Segurança do Contribuinte
   /* XMLs de cada etapa */
   VAR    cXmlDocumento  INIT ""                      // O documento oficial, com ou sem assinatura, depende do documento
   VAR    cXmlEnvio      INIT ""                      // usado pra criar/complementar XML do documento
   VAR    cXmlSoap       INIT ""                      // XML completo enviado pra Sefaz, incluindo informações do envelope
   VAR    cXmlRetorno    INIT "Erro Desconhecido"     // Retorno do webservice e/ou rotina
   VAR    cXmlRecibo     INIT ""                      // XML recibo (obtido no envio do lote)
   VAR    cXmlProtocolo  INIT ""                      // XML protocolo (obtido no consulta recibo e/ou envio de outros docs)
   VAR    cXmlAutorizado INIT ""                      // XML autorizado, caso tudo ocorra sem problemas
   VAR    cStatus        INIT Space(3)                // Status obtido da resposta final da Fazenda
   VAR    cRecibo        INIT ""                      // Número do recibo
   VAR    cMotivo        INIT ""                      // Motivo constante no Recibo
   /* uso interno */
   VAR    cSoapVersion   INIT ""                      // webservice versão XML e comunicação
   VAR    cSoapService   INIT ""                      // webservice Serviço
   VAR    cSoapAction    INIT ""                      // webservice Action
   VAR    cSoapURL       INIT ""                      // webservice Endereço

   METHOD CTeConsulta( ... )   INLINE  ::CTeConsultaProtocolo( ... )    // Não usar, apenas compatibilidade
   METHOD NFeConsulta( ... )   INLINE  ::NFeConsultaProtocolo( ... )    // Não usar, apenas compatibilidade
   METHOD MDFeConsulta( ... )  INLINE  ::MDFeConsultaProtocolo( ... )   // Não usar, apenas compatibilidade
   METHOD CTeStatus( ... )     INLINE  ::CTeStatusServico( ... )        // Não usar, apenas compatibilidade
   METHOD NFeStatus( ... )     INLINE  ::NFeStatusServico( ... )        // Não usar, apenas compatibilidade
   METHOD MDFeStatus( ... )    INLINE  ::MDFeStatusServico( ... )       // Não usar, apenas compatibilidade
   METHOD NFeCadastro( ... )   INLINE  ::NFeConsultaCadastro( ... )     // Não usar, apenas compatibilidade
   METHOD NFeEventoCCE( ... )  INLINE  ::NFeEventoCarta( ... )          // Não usar, apenas compatibilidade
   METHOD CTeEventoCCE( ... )  INLINE  ::CTeEventoCarta( ... )

   METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente )
   METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD CTeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD MDFeConsNaoEnc( CUF, cCNPJ , cCertificado, cAmbiente )
   METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD MDFeEventoEncerramento( cChave, nSequencia, nProt, cUFFim, cMunCarrega, cCertificado, cAmbiente )
   METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente )

   METHOD NFeConsultaDest( cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente )
   METHOD NFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente )
   METHOD NFeEventoManifestacao( cChave, nSequencia, xJust, cCodigoEvento, cCertificado, cAmbiente )
   METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc )
   METHOD NFeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD CTeAddCancelamento( cXmlAssinado, cXmlCancelamento )
   METHOD NFeAddCancelamento( cXmlAssinado, cXmlCancelamento )

   /* Uso interno */
   METHOD SetSoapURL( nWsServico )
   METHOD XmlSoapEnvelope()
   METHOD XmlSoapPost()
   METHOD MicrosoftXmlSoapPost()

   /* Apenas redirecionamento */
   METHOD AssinaXml()                                 INLINE ::cXmlRetorno := CapicomAssinaXml( @::cXmlDocumento, ::cCertificado )
   METHOD TipoXml( cXml )                             INLINE TipoXml( cXml )
   METHOD UFCodigo( cSigla )                          INLINE UFCodigo( cSigla )
   METHOD UFSigla( cCodigo )                          INLINE UFSigla( cCodigo )
   METHOD DateTimeXml( dDate, cTime, lUTC )           INLINE DateTimeXml( dDate, cTime, iif( ::cUFTimeZone == NIL, ::cUF, ::cUFTimeZone ), lUTC )
   METHOD ValidaXml( cXml, cFileXsd )                 INLINE ::cXmlRetorno := DomDocValidaXml( cXml, cFileXsd )
   METHOD GeraQRCode( cXmlDocumento, cIdToken, cCSC ) //
   METHOD Setup( cUF, cCertificado, cAmbiente, nWsServico )

   ENDCLASS

METHOD GeraQRCode( cXmlDocumento, cIdToken, cCsc )

   IF cXmlDocumento != NIL
      ::cXmlDocumento := cXmlDocumento
   ENDIF
   IF cIdToken != NIL
      ::cIdToken := cIdToken
   ENDIF
   IF cCsc != NIL
      ::cCsc := cCsc
   ENDIF
   ::cXmlRetorno := GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC )

   RETURN ::cXmlRetorno

METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_CTE_CONSULTAPROTOCOLO )

   ::cSoapVersion := ::cVersao
   ::cXmlEnvio    := [<consSitCTe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chCTe", cChave )
   ::cXmlEnvio    += [</consSitCTe>]
   IF ! Substr( cChave, 21, 2 ) $ "57,67"
      ::cXmlRetorno := "*ERRO* Chave não se refere a CTE"
   ELSE
      ::XmlSoapPost()
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_RETRECEPCAO )

   ::cSoapVersion  := ::cVersao
   ::cXmlEnvio     := [<consReciCTe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec",  ::cRecibo )
   ::cXmlEnvio     += [</consReciCTe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno                                           // ? hb_Utf8ToStr()
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" ) // ? hb_Utf8ToStr()

   RETURN ::cXmlRetorno // ? hb_Utf8ToStr()

METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @nSequencia, 1 )

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_CTE_RECEPCAOEVENTO )

   ::cSoapVersion  := ::cVersao
   ::cXmlDocumento := [<eventoCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="] + ::cVersao + [">]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110111" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + ::cVersao + [">]
   ::cXmlDocumento +=            [<evCancCTe>]
   ::cXmlDocumento +=                XmlTag( "descEvento", "Cancelamento" )
   ::cXmlDocumento +=                XmlTag( "nProt", Ltrim( Str( nProt, 16 ) ) )
   ::cXmlDocumento +=                XmlTag( "xJust", xJust )
   ::cXmlDocumento +=            [</evCancCTe>]
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoCTe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::CTeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL oElement

   hb_Default( @nSequencia, 1 )

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_CTE_RECEPCAOEVENTO )

   ::cSoapVersion  := ::cVersao
   ::cXmlDocumento := [<eventoCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="] + ::cVersao + [">]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110110" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + ::cVersao + [">]
   ::cXmlDocumento +=            [<evCCeCTe>]
   ::cXmlDocumento +=                XmlTag( "descEvento", "Carta de Correcao" )
                        FOR EACH oElement IN aAlteracoes
   ::cXmlDocumento +=                     [<infCorrecao>]
   ::cXmlDocumento +=                      XmlTag( "grupoAlterado", oElement[ 1 ] )
   ::cXmlDocumento +=                      XmlTag( "campoAlterado", oElement[ 2 ] )
   ::cXmlDocumento +=                      XmlTag( "valorAlterado", oElement[ 3 ] )
   ::cXmlDocumento +=                     [</infCorrecao>]
                        NEXT
   ::cXmlDocumento +=                [<xCondUso>]
   ::cXmlDocumento +=                   "A Carta de Correcao e disciplinada pelo Art. 58-B "
   ::cXmlDocumento +=                   "do CONVENIO/SINIEF 06/89: Fica permitida a utilizacao de carta "
   ::cXmlDocumento +=                   "de correcao, para regularizacao de erro ocorrido na emissao de "
   ::cXmlDocumento +=                   "documentos fiscais relativos a prestacao de servico de transporte, "
   ::cXmlDocumento +=                   "desde que o erro nao esteja relacionado com: I - as variaveis que "
   ::cXmlDocumento +=                   "determinam o valor do imposto tais como: base de calculo, aliquota, "
   ::cXmlDocumento +=                   "diferenca de preco, quantidade, valor da prestacao;II - a correcao "
   ::cXmlDocumento +=                   "de dados cadastrais que implique mudanca do emitente, tomador, "
   ::cXmlDocumento +=                   "remetente ou do destinatario;III - a data de emissao ou de saida."
   ::cXmlDocumento +=                [</xCondUso>]
   ::cXmlDocumento +=          [</evCCeCTe>]
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoCTe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::CTeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protCTe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<Erro text="Não autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<cteProc versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protCTe", .T. ) // ?hb_Utf8ToStr()
   ::cXmlAutorizado += [</cteProc>]

   RETURN NIL

METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "xMotivo" ) // runner
   IF ! ::cStatus $ "135,155"
      ::cXmlRetorno := [<Erro text="Não autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoCTe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoCTe versao="] + ::cVersao + [">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEventoCTe" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEventoCTe>]
   ::cXmlAutorizado += [</procEventoCTe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN NIL

METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_INUTILIZACAO )

   IF Len( cAno ) != 2
      cAno := Right( cAno, 2 )
   ENDIF
   ::cSoapVersion    := ::cVersao
   ::cXmlDocumento   := [<inutCTe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDocumento   +=    [<infInut Id="ID] + ::UFCodigo( ::cUF ) + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDocumento   +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDocumento   +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento   +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDocumento   +=       XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDocumento   +=       XmlTag( "ano", cAno )
   ::cXmlDocumento   +=       XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDocumento   +=       XmlTag( "mod", cMod )
   ::cXmlDocumento   +=       XmlTag( "serie", cSerie )
   ::cXmlDocumento   +=       XmlTag( "nCTIni", Alltrim(Str(Val(cNumIni))) )
   ::cXmlDocumento   +=       XmlTag( "nCTFin", Alltrim(Str(Val(cNumFim))) )
   ::cXmlDocumento   +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDocumento   +=    [</infInut>]
   ::cXmlDocumento   += [</inutCTe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      IF ::cStatus == "102"
         ::cXmlAutorizado := XML_UTF8
         ::cXmlAutorizado += [<ProcInutCTe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
         ::cXmlAutorizado += ::cXmlDocumento
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno , "retInutCTe", .T. )
         ::cXmlAutorizado += [</ProcInutCTe>]
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF Empty( cLote )
      cLote := "1"
   ENDIF

   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_RECEPCAO )

   ::cXmlDocumento := cXml
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   ::cSoapVersion := ::cVersao
   ::cXmlEnvio    := [<enviCTe versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlEnvio    +=    XmlTag( "idLote", cLote )
   ::cXmlEnvio    +=    ::cXmlDocumento
   ::cXmlEnvio    += [</enviCTe>]
   ::XmlSoapPost()
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStatus" ), 3 )
   ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
   IF ! Empty( ::cRecibo )
      Inkey( ::nTempoEspera )
      ::CteConsultaRecibo()
      ::CteGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo ) // runner
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_STATUSSERVICO )

   ::cSoapVersion := ::cVersao
   ::cXmlEnvio    := [<consStatServCte versao="]  + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServCte>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD MDFeConsNaoEnc( cUF, cCNPJ , cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_CONSNAOENC )

   ::cSoapVersion := "1.00"
   ::cXmlEnvio    := [<consMDFeNaoEnc versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR NÃO ENCERRADOS" )
   ::cXmlEnvio    +=    XmlTag( "CNPJ", cCNPJ )
   ::cXmlEnvio    += [</consMDFeNaoEnc>]
   ::XmlSoapPost()
   ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "xMotivo" )

   RETURN ::cXmlRetorno

METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_MDFE_CONSULTA )

   ::cSoapVersion := "1.00"
   ::cXmlEnvio    := [<consSitMDFe versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chMDFe", cChave )
   ::cXmlEnvio    += [</consSitMDFe>]
   IF Substr( cChave, 21, 2 ) != "58"
      ::cXmlRetorno := "*ERRO* Chave não se refere a MDFE"
   ELSE
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_RETRECEPCAO )

   ::cSoapVersion := "1.00"
   ::cXmlEnvio    := [<consReciMDFe versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio    += [</consReciMDFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )

   RETURN ::cXmlRetorno

// 2016.01.31.2200 Iniciado apenas
METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )

   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_DISTRIBUICAODFE )

   ::cSoapVersion := "1.00"
   ::cXmlEnvio    := [<distDFeInt versao="] + ::cSoapVersion + ["xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUFAutor", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "CNPJ", cCnpj )
   IF Empty( cNSU )
      ::cXmlEnvio +=   [<distNSU>]
      ::cXmlEnvio +=      XmlTag( "ultNSU", cUltNSU )
      ::cXmlEnvio +=   [</distNSU>]
   ELSE
      ::cXmlEnvio +=   [<consNSU>]
      ::cXmlEnvio +=      XmlTag( "NSU", cNSU )
      ::cXmlEnvio +=   [</consNSU>]
   ENDIF
   ::cXmlEnvio    += [</distDFeInt>]
   ::XmlSoapPost()

   RETURN NIL

METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @nSequencia, 1 )

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_MDFE_RECEPCAOEVENTO )

	::cSoapVersion  := "1.00"
   ::cXmlDocumento := [<eventoMDFe xmlns="http://www.portalfiscal.inf.br/mdfe" versao="1.00">]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110111" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="1.00">]
   ::cXmlDocumento +=       	  [<evCancMDFe>]
   ::cXmlDocumento +=          		XmlTag( "descEvento", "Cancelamento" )
   ::cXmlDocumento +=          		XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   ::cXmlDocumento +=          		XmlTag( "xJust", xJust )
   ::cXmlDocumento +=       	  [</evCancMDFe>]
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoMDFe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::MDFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeEventoEncerramento( cChave, nSequencia , nProt, cUFFim , cMunCarrega , cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @nSequencia, 1 )

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_MDFE_RECEPCAOEVENTO )

	::cSoapVersion  := "1.00"
   ::cXmlDocumento := [<eventoMDFe xmlns="http://www.portalfiscal.inf.br/mdfe" versao="1.00">]
   ::cXmlDocumento +=    [<infEvento Id="ID110112] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110112" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="1.00">]
   ::cXmlDocumento +=       	  [<evEncMDFe>]
   ::cXmlDocumento +=          		XmlTag( "descEvento", "Encerramento" )
   ::cXmlDocumento +=          		XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   ::cXmlDocumento +=          		XmlTag( "dtEnc", DateXml( Date() ) )
   ::cXmlDocumento +=          		XmlTag( "cUF", ::UFCodigo( cUFFim ) )
   ::cXmlDocumento +=          		XmlTag( "cMun", cMunCarrega )
   ::cXmlDocumento +=       	  [</evEncMDFe>]
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoMDFe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::MDFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo ) // hb_Utf8ToStr(
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protMDFe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<Erro text="Não autorizado" />] + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<mdfeProc versao="1.00" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlAUtorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protMDFe", .T. )
   ::cXmlAutorizado += [</mdfeProc>]

   RETURN NIL

METHOD MDFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEventoMDFe" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEventoMDFe" ), "xMotivo" ) // hb_utf8tostr()
   IF ! ::cStatus $ "135,136"
      ::cXmlRetorno := [<Erro Text="Status inválido" />] + ::cXmlRetorno
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoMDFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoMDFe versao="1.00">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEventoMDFe" ) // hb_Utf8ToStr(
   ::cXmlAutorizado += [</retEventoMDFe>]
   ::cXmlAutorizado += [</procEventoMDFe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_Utf8ToStr

   RETURN NIL

METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_RECEPCAO )

   ::cXmlDocumento := cXml
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   ::cSoapVersion := "1.00"
   ::cXmlEnvio    := [<enviMDFe versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlEnvio    +=    XmlTag( "idLote", cLote )
   ::cXmlEnvio    +=    ::cXmlDocumento
   ::cXmlEnvio    += [</enviMDFe>]
   ::XmlSoapPost()
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStatus" ), 3 )
   ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
   IF ! Empty( ::cRecibo )
      Inkey( ::nTempoEspera )
      ::MDFeConsultaRecibo()
      ::MDFeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_STATUSSERVICO )

   ::cSoapVersion := "1.00"
   ::cXmlEnvio    := [<consStatServMDFe versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServMDFe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_CONSULTACADASTRO )

   ::cSoapVersion := "2.00"
   ::cXmlEnvio    := [<ConsCad versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio    +=    [<infCons>]
   ::cXmlEnvio    +=       XmlTag( "xServ", "CONS-CAD" )
   ::cXmlEnvio    +=       XmlTag( "UF", ::cUF )
   ::cXmlEnvio    +=       XmlTag( "CNPJ", cCNPJ )
   ::cXmlEnvio    +=    [</infCons>]
   ::cXmlEnvio    += [</ConsCad>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

/* Iniciado apenas 2015.07.31.1400 */
METHOD NFeConsultaDest( cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @cUltNSU, "0" )
   hb_Default( @cIndNFe, "0" )
   hb_Default( @cIndEmi, "0" )

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_CONSULTADEST )

   ::cSoapVersion := "3.10"
   ::cXmlEnvio    := [<consNFeDest versao="] + ::cSoapVersion + [">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR NFE DEST" )
   ::cXmlEnvio    +=    XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlEnvio    +=    XmlTag( "indNFe", "0" ) // 0=todas,1=sem manif,2=sem nada
   ::cXmlEnvio    +=    XmlTag( "indEmi", "0" ) // 0=todas, 1=sem cnpj raiz(sem matriz/filial)
   ::cXmlEnvio    +=    XmlTag( "ultNSU", cUltNsu )
   ::cXmlEnvio    += [</consNFeDest>]

   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_NFE_CONSULTAPROTOCOLO )

   ::cSoapVersion := "3.10"
   ::cXmlEnvio    := [<consSitNFe versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chNFe", cChave )
   ::cXmlEnvio    += [</consSitNFe>]
   IF ! Substr( cChave, 21, 2 ) $ "55,65"
      ::cXmlRetorno := "*ERRO* Chave não se refere a NFE"
   ELSE
      ::XmlSoapPost()
   ENDIF

   RETURN ::cXmlRetorno

/* 2015.07.31.1400 Iniciado apenas */
METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_DISTRIBUICAODFE )

   ::cSoapVersion := "1.00"
   ::cXmlEnvio    := [<distDFeInt versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUFAutor", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "CNPJ", cCnpj ) // ou CPF
   IF Empty( cNSU )
      ::cXmlEnvio +=   [<distNSU>]
      ::cXmlEnvio +=      XmlTag( "ultNSU", cUltNSU )
      ::cXmlEnvio +=   [</distNSU>]
   ELSE
      ::cXmlEnvio +=   [<consNSU>]
      ::cXmlEnvio +=      XmlTag( "NSU", cNSU )
      ::cXmlEnvio +=   [</consNSU>]
   ENDIF
   ::cXmlEnvio   += [</distDFeInt>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @nSequencia, 1 )

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_NFE_RECEPCAOEVENTO )

   ::cSoapVersion  := "1.00"
   ::cXmlDocumento := [<evento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110110" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       [<detEvento versao="1.00">]
   ::cXmlDocumento +=          XmlTag( "descEvento", "Carta de Correcao" )
   ::cXmlDocumento +=          XmlTag( "xCorrecao", cTexto )
   ::cXmlDocumento +=          [<xCondUso>]
   ::cXmlDocumento +=          "A Carta de Correcao e disciplinada pelo paragrafo 1o-A do art. 7o do Convenio S/N, "
   ::cXmlDocumento +=          "de 15 de dezembro de 1970 e pode ser utilizada para regularizacao de erro ocorrido na "
   ::cXmlDocumento +=          "emissao de documento fiscal, desde que o erro nao esteja relacionado com: "
   ::cXmlDocumento +=          "I - as variaveis que determinam o valor do imposto tais como: base de calculo, aliquota, "
   ::cXmlDocumento +=          "diferenca de preco, quantidade, valor da operacao ou da prestacao; "
   ::cXmlDocumento +=          "II - a correcao de dados cadastrais que implique mudanca do remetente ou do destinatario; "
   ::cXmlDocumento +=          "III - a data de emissao ou de saida."
   ::cXmlDocumento +=         [</xCondUso>]
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio    := [<envEvento versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlEnvio    +=    XmlTag( "idLote", Substr( cChave, 26, 9 ) ) // usado numero da nota
      ::cXmlEnvio    +=    ::cXmlDocumento
      ::cXmlEnvio    += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NfeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @nSequencia, 1 )

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_NFE_RECEPCAOEVENTO )

   ::cSoapVersion  := "1.00"
   ::cXmlDocumento := [<evento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110111" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       [<detEvento versao="1.00">]
   ::cXmlDocumento +=          XmlTag( "descEvento", "Cancelamento" )
   ::cXmlDocumento +=          XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   ::cXmlDocumento +=          XmlTag( "xJust", xJust )
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio    := [<envEvento versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlEnvio    +=    XmlTag( "idLote", Substr( cChave, 26, 9 ) ) // usado numero da nota
      ::cXmlEnvio    +=    ::cXmlDocumento
      ::cXmlEnvio    += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoManifestacao( cChave, nSequencia, xJust, cCodigoEvento, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cDescEvento

   hb_Default( @nSequencia, 1 )

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_NFE_RECEPCAOEVENTO )

   DO CASE
   CASE cCodigoEvento == "210200" ; cDescEvento := "Confirmacao da Operacao"
   CASE cCodigoEvento == "210210" ; cDescEvento := "Ciencia da Operacao"
   CASE cCodigoEvento == "210220" ; cDescEvento := "Desconhecimento da Operacao"
   CASE cCodigoEvento == "210240" ; cDescEvento := "Operacao Nao Realizada"
   ENDCASE

   ::cSoapVersion  := "1.00"
   ::cXmlDocumento := [<evento versao="1.00" xmlns="http://www.portal.inf.br/nfe" >]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cCodigoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cCodigoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", StrZero( 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       [<detEvento versao="1.00">]
   ::cXmlDocumento +=          XmlTag( "descEvento", cDescEvento )
   IF cCodigoEvento == "210240"
      ::cXmlDocumento +=          XmlTag( "xJust", xJust )
   ENDIF
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio    := [<envEvento versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlEnvio    +=    XmlTag( "idLote", Substr( cChave, 26, 9 ) ) // usado numero da nota
      ::cXmlEnvio    +=    ::cXmlDocumento
      ::cXmlEnvio    += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_INUTILIZACAO )

   ::cSoapVersion  := "3.10"
   ::cXmlDocumento := [<inutNFe versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDocumento   +=    [<infInut Id="ID] + ::UFCodigo( ::cUF ) + Right( cAno, 2 ) + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDocumento   +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDocumento   +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento   +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDocumento   +=       XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDocumento   +=       XmlTag( "ano", Right( cAno, 2 ) )
   ::cXmlDocumento   +=       XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDocumento   +=       XmlTag( "mod", cMod )
   ::cXmlDocumento   +=       XmlTag( "serie", cSerie )
   ::cXmlDocumento   +=       XmlTag( "nNFIni", cNumIni )
   ::cXmlDocumento   +=       XmlTag( "nNFFin", cNumFim )
   ::cXmlDocumento   +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDocumento   +=    [</infInut>]
   ::cXmlDocumento   += [</inutNFe>]

   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      IF ::cStatus == "102"
         ::cXmlAutorizado := XML_UTF8
         ::cXmlAutorizado += [<ProcInutNFe versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">]
         ::cXmlAutorizado += ::cXmlDocumento
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno, "retInutNFe", .T. )
         ::cXmlAutorizado += [</ProcInutNFe>]
      ENDIF
   ENDIF
   RETURN ::cXmlRetorno

METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc ) CLASS SefazClass

   hb_Default( @cIndSinc, ::cIndSinc )

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_AUTORIZACAO )

   IF Empty( cLote )
      cLote := "1"
   ENDIF

   ::cXmlDocumento := cXml
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   ::cSoapVersion := "3.10"
   ::cXmlEnvio    := [<enviNFe versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   // FOR EACH cXmlNota IN aXmlNotas
   ::cXmlEnvio    += XmlTag( "idLote", cLote )
   ::cXmlEnvio    += XmlTag( "indSinc", cIndSinc )
   ::cXmlEnvio    += ::cXmlDocumento
   // NEXT
   ::cXmlEnvio    += [</enviNFe>]
   ::XmlSoapPost()
   IF cIndSinc == INDSINC_RETORNA_RECIBO
      ::cXmlRecibo    := ::cXmlRetorno
      ::cRecibo       := XmlNode( ::cXmlRecibo, "nRec" )
      ::cStatus       := Pad( XmlNode( ::cXmlRecibo, "cStat" ), 3 )
      ::cMotivo       := XmlNode( ::cXmlRecibo, "xMotivo" )
      IF ! Empty( ::cRecibo )
         Inkey( ::nTempoEspera )
         ::NfeConsultaRecibo()
         ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ELSE
      ::cXmlRecibo    := ::cXmlRetorno
      ::cRecibo       := XmlNode( ::cXmlRecibo, "nRec" )
      ::cStatus       := Pad( XmlNode( ::cXmlRecibo, "cStat" ), 3 )
      ::cMotivo       := XmlNode( ::cXmlRecibo, "xMotivo" )
      IF ! Empty( ::cRecibo )
         ::cXmlProtocolo := ::cXmlRetorno
         ::cXmlRetorno   := ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_RETAUTORIZACAO )

   ::cSoapVersion  := "3.10"
   ::cXmlEnvio     := [<consReciNFe versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio     += [</consReciNFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )

   RETURN ::cXmlRetorno

METHOD NFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_STATUSSERVICO )

   ::cSoapVersion    := "3.10"
   ::cXmlEnvio       := [<consStatServ versao="] + ::cSoapVersion + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio       +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio       +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio       +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio       += [</consStatServ>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protNFe" ), "cStat" ), 3 ) // Pad() garante 3 caracteres
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<Erro text="Não autorizado" />] + ::cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<nfeProc versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protNFe", .T. ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</nfeProc>]

   RETURN NIL

METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass // runner

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "xMotivo" ) // runner
   IF ! ::cStatus $ "135,155"
      ::cXmlRetorno := [<Erro text="Status inválido pra autorização" />] + ::cXmlRetorno
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEvento versao="1.00">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEvento" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEvento>] // runner
   ::cXmlAutorizado += [</procEventoNFe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN NIL

METHOD Setup( cUF, cCertificado, cAmbiente, nWsServico ) CLASS SefazClass

   LOCAL nPos, aSoapList := { ;
      { "**", WS_CTE_CONSULTAPROTOCOLO, WS_PROJETO_CTE,  "cteConsultaCT",        "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta" }, ;
      { "**", WS_CTE_RETRECEPCAO,       WS_PROJETO_CTE,  "cteRetRecepcao",       "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao" }, ;
      { "**", WS_CTE_RECEPCAOEVENTO,    WS_PROJETO_CTE,  "cteRecepcaoEvento",    "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento" }, ;
      { "**", WS_CTE_INUTILIZACAO,      WS_PROJETO_CTE,  "cteInutilizacaoCT",    "http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao" }, ;
      { "**", WS_CTE_RECEPCAO,          WS_PROJETO_CTE,  "cteRecepcaoLote",      "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao" }, ;
      { "**", WS_CTE_STATUSSERVICO,     WS_PROJETO_CTE,  "cteStatusServicoCT",   "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico" }, ;
      { "**", WS_MDFE_CONSNAOENC,       WS_PROJETO_MDFE, "mdfeConsNaoEnc",       "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsNaoEnc" }, ;
      { "**", WS_MDFE_CONSULTA,         WS_PROJETO_MDFE, "mdfeConsultaMDF",      "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta" }, ;
      { "**", WS_MDFE_RETRECEPCAO,      WS_PROJETO_MDFE, "mdfeRetRecepcao",      "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao" }, ;
      { "**", WS_MDFE_DISTRIBUICAODFE,  "??????",        "mdfeDistDFeInteresse", "http://www.portalfiscal.inf.br/nfe/wsdl/MDFeDistribuicaoDFe" }, ;
      { "**", WS_MDFE_RECEPCAOEVENTO,   WS_PROJETO_MDFE, "mdfeRecepcaoEvento",   "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento" }, ;
      { "**", WS_MDFE_RECEPCAO,         WS_PROJETO_MDFE, "MDFeRecepcao",         "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao" }, ;
      { "**", WS_MDFE_STATUSSERVICO,    WS_PROJETO_MDFE, "MDFeStatusServico",    "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico/mdfeStatusServicoMDF" }, ;
      { "**", WS_NFE_CONSULTACADASTRO,  WS_PROJETO_NFE,  "CadConsultaCadastro2", "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2" }, ;
      { "**", WS_NFE_CONSULTADEST,      WS_PROJETO_NFE,  "nfeConsultaNFDest",    "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest" }, ;
      { "**", WS_NFE_DISTRIBUICAODFE,   "???",           "nfeDistDFeInteresse",  "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe" }, ;
      { "**", WS_NFE_RECEPCAOEVENTO,    WS_PROJETO_NFE,  "nfeRecepcaoEvento",    "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento" }, ;
      { "**", WS_NFE_INUTILIZACAO,      WS_PROJETO_NFE,  "NfeInutilizacaoNF2",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2" }, ;
      { "**", WS_NFE_AUTORIZACAO,       WS_PROJETO_NFE,  "NfeAutorizacao",       "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao" }, ;
      { "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO", ;
	          WS_NFE_AUTORIZACAO,        WS_PROJETO_NFE,  "nfeAutorizacaoLote",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao" }, ;
      { "**", WS_NFE_RETAUTORIZACAO,    WS_PROJETO_NFE,  "NfeRetAutorizacao",    "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao" }, ;
      { "**", WS_NFE_STATUSSERVICO,     WS_PROJETO_NFE,  "nfeStatusServicoNF2",  "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2" }, ;
      { "BA", WS_NFE_STATUSSERVICO,     WS_PROJETO_NFE,  "nfeStatusServicoNF",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico" }, ;
      { "**", WS_NFE_CONSULTAPROTOCOLO, WS_PROJETO_NFE,  "NfeConsulta2",         "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2" }, ;
      { "BA", WS_NFE_CONSULTAPROTOCOLO, WS_PROJETO_NFE,  "nfeConsultaNF",        "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta" }, ;
      { "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO", ;
              WS_NFE_CONSULTAPROTOCOLO, WS_PROJETO_NFE,  "nfeConsultaNF2",       "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2" } }

   ::cUF          := iif( cUF == NIL, ::cUF, cUF )
   ::cCertificado := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   ::cAmbiente    := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )

   IF nWsServico == NIL
      RETURN NIL
   ENDIF
   IF ( nPos := AScan( aSoapList, { | oElement | oElement[ 1 ] $ ::cUF .AND. oElement[ 2 ] == nWsServico } ) ) != 0
      ::cProjeto     := aSoapList[ nPos, 3 ]
      ::cSoapAction  := aSoapList[ nPos, 4 ]
      ::cSoapService := aSoapList[ nPos, 5 ]
   ELSEIF ( nPos := AScan( aSoapList, { | oElement | oElement[ 1 ] == "**" .AND. oElement[ 2 ] == nWsServico } ) ) != 0
      ::cProjeto     := aSoapList[ nPos, 3 ]
      ::cSoapAction  := aSoapList[ nPos, 4 ]
      ::cSoapService := aSoapList[ nPos, 5 ]
   ENDIF
   DO CASE
   CASE ::cVersao != "*DEFAULT*"
   CASE ::cProjeto == WS_PROJETO_NFE ;  ::cVersao := WS_VERSAO_NFE
   CASE ::cProjeto == WS_PROJETO_CTE ;  ::cVersao := WS_VERSAO_CTE
   CASE ::cProjeto == WS_PROJETO_MDFE ; ::cVersao := WS_VERSAO_MDFE
   ENDCASE
   ::SetSoapURL( nWsServico )

   RETURN NIL

METHOD SetSoapURL( nWsServico ) CLASS SefazClass

   ::cSoapURL := ""
   DO CASE
   CASE .F.
      SoapURL_SCVAN() // pra evitar erro de função não utilizada
   CASE ::cProjeto == WS_PROJETO_CTE
      IF ::cScan == "SVCAN"
         IF ::cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
            ::cSoapURL := SoapURL_SVSP( ::cAmbiente, nWsServico, ::cVersao ) // SVC_SP não existe
         ELSEIF ::cUF $ "MS,MT,SP," + "AP,PE,RR"
            ::cSoapURL := SoapURL_SVRS( ::cAmbiente, nWsServico, ::cVersao ) // SVC_RS não existe
         ENDIF
      ELSE
         IF ::cUF $ "AP,PE,RR"
            ::cSoapURL := SoapURL_SVSP( ::cAmbiente, nWsServico, ::cVersao )
         ELSEIF ::cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
            ::cSoapURL := SoapURL_SVRS( ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ENDIF
   CASE ::cProjeto == WS_PROJETO_MDFE
      ::cSoapURL := SoapURL_SVRS( ::cAmbiente, nWsServico, ::cVersao )
   CASE ::cProjeto == WS_PROJETO_NFE
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO .AND. ::cUF $ "AC,RN,PB,SC" ;  ::cSoapUrl := SoapURL_SVRS( ::cAmbiente, nWsServico, ::cVersao )
      CASE nWsServico == WS_NFE_CONSULTACADASTRO .AND. ::cUF == "ES" ; ::cSoapURL := "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO .AND. ::cUF == "MA" ; ::cSoapURL := "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl"
      CASE ::cScan == "SCAN"
         ::cSoapURL := SoapURL_SCAN( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cScan == "SVAN"
         ::cSoapUrl := SoapURL_SVAN( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cScan == "SVCAN"
         IF ::cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
            ::cSoapURL := SoapURL_SVRS( ::cAmbiente, nWsServico, ::cVersao ) // svc-rs não existe
         ELSE
            ::cSoapURL := SoapURL_SVAN( ::cAmbiente, nWsServico, ::cVersao ) // svc-an não existe
         ENDIF
      OTHERWISE
         IF ::cUf $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO"
            ::cSoapURL := SoapURL_SVRS( ::cAmbiente, nWsServico, ::cVersao )
         ELSEIF ::cUf $ "MA,PA,PI"
            ::cSoapURL := SoapURL_SVAN( ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ENDCASE
   ENDCASE
   IF Empty( ::cSoapURL )
      DO CASE
      CASE ::cUF == "AM" ;  ::cSoapURL := SoapURL_AM( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "BA" ;  ::cSoapURL := SoapURL_BA( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "CE" ;  ::cSoapURL := SoapURL_CE( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "GO" ;  ::cSoapURL := SOAPURL_GO( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "MG" ;  ::cSoapURL := SoapURL_MG( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "MS" ;  ::cSoapURL := SoapURL_MS( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "MT" ;  ::cSoapURL := SoapURL_MT( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "PE" ;  ::cSoapURL := SoapURL_PE( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "PR" ;  ::cSoapURL := SoapURL_PR( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "RS" ;  ::cSoapURL := SoapURL_RS( ::cAmbiente, nWsServico, ::cVersao )
      CASE ::cUF == "SP" ;  ::cSoapURL := SoapURL_SP( ::cAmbiente, nWsServico, ::cVersao )
      ENDCASE
   ENDIF

   IF ::cProjeto == WS_PROJETO_NFE .AND. Empty( ::cSoapURL ) // Não tem específico
      ::cSoapURL := SoapURL_AN( ::cAmbiente, nWsServico, ::cVersao )
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
   ::cXmlSoap    +=    [xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">]
   IF ::cSoapAction != "nfeDistDFeInteresse" .AND. ! ( ::cProjeto == WS_PROJETO_NFE .AND. ::cVersao == "4.00" )
      ::cXmlSoap +=    [<soap12:Header>]
      ::cXmlSoap +=       [<] + ::cProjeto + [CabecMsg xmlns="] + ::cSoapService + [">]
      ::cXmlSoap +=          [<cUF>] + ::UFCodigo( ::cUF ) + [</cUF>]
      ::cXmlSoap +=          [<versaoDados>] + ::cSoapVersion + [</versaoDados>]
      ::cXmlSoap +=       [</] + ::cProjeto + [CabecMsg>]
      ::cXmlSoap +=    [</soap12:Header>]
   ENDIF
   ::cXmlSoap    +=    [<soap12:Body>]
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [<nfeDistDFeInteresse xmlns="] + ::cSoapService + [">]
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg>]
   ELSE
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg xmlns="] + ::cSoapService + [">]
   ENDIF
   ::cXmlSoap    += ::cXmlEnvio
   ::cXmlSoap    +=    [</] + ::cProjeto + [DadosMsg>]
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [</nfeDistDFeInteresse>]
   ENDIF
   ::cXmlSoap    +=    [</soap12:Body>]
   ::cXmlSoap    += [</soap12:Envelope>]

   RETURN NIL

METHOD MicrosoftXmlSoapPost() CLASS SefazClass

   LOCAL oServer, nCont, cRetorno
   LOCAL cSoapAction

   //IF ::cSoapAction == "nfeDistDFeInteresse" .OR. ::cSoapAction == "nfeConsultaNFDest"
      //cSoapAction := ::cSoapService + "/" + ::cSoapAction
   //ELSE
      cSoapAction := ::cSoapAction
   //ENDIF
   BEGIN SEQUENCE WITH __BreakBlock()
      ::cXmlRetorno := "Erro: Criando objeto MSXML2.ServerXMLHTTP"
#ifdef __XHARBOUR__
      //IF ::cUF == "GO" .AND. ::cAmbiente == "2"
         ::cXmlRetorno := "Erro: Criando objeto MSXML2.ServerXMLHTTP.5.0"
         oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP.5.0" )
      //ELSE
      //   ::cXmlRetorno := "Erro: Criando objeto MSXML2.ServerXMLHTTP.6.0"
      //   oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP.6.0" )
      //ENDIF
#else
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP" )
#endif
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

METHOD CTeAddCancelamento( cXmlAssinado, cXmlCancelamento ) CLASS SefazClass

   LOCAL cDigVal, cXmlAutorizado

   cDigVal := XmlNode( cXmlAssinado , "Signature" )
   cDigVal := XmlNode( cDigVal , "SignedInfo" )
   cDigVal := XmlNode( cDigVal , "Reference" )
   cDigVal := XmlNode( cDigVal , "DigestValue" )

   cXmlAutorizado := XML_UTF8
   cXmlAutorizado += [<cteProc versao="] + ::cVersao + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   cXmlAutorizado +=    cXmlAssinado
   cXmlAutorizado +=    [<protCTe versao="] + ::cVersao + [">]
   cXmlAutorizado +=       [<infProt>]
   cXmlAutorizado +=          XmlTag( "tpAmb" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "tpAmb" ) ) // runner
   cXmlAutorizado +=          XmlTag( "verAplic", XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "verAplic" ) )
   cXmlAutorizado +=          XmlTag( "chCTe" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "chCTe" ) ) // runner
   cXmlAutorizado +=          XmlTag( "dhRecbto" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "dhRegEvento" ) ) // runner
   cXmlAutorizado +=          XmlTag( "nProt" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "nProt" ) ) // runner
   cXmlAutorizado +=          XmlTag( "digVal", cDigVal)
   cXmlAutorizado +=          XmlTag( "cStat", XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEventoCTe" ) , "infEvento" ), "cStat" ) )
   cXmlAutorizado +=          XmlTag( "xMotivo", 'Cancelamento do CTe homologado')
   cXmlAutorizado +=       [</infProt>]
   cXmlAutorizado +=    [</protNFe>]
   cXmlAutorizado += [</cteProc>]

   RETURN cXmlAutorizado

METHOD NFeAddCancelamento( cXmlAssinado, cXmlCancelamento ) CLASS SefazClass

   LOCAL cDigVal, cXmlAutorizado

   cDigVal := XmlNode( cXmlAssinado , "Signature" )
   cDigVal := XmlNode( cDigVal , "SignedInfo" )
   cDigVal := XmlNode( cDigVal , "Reference" )
   cDigVal := XmlNode( cDigVal , "DigestValue" )

   cXmlAutorizado := XML_UTF8
   cXmlAutorizado += [<nfeProc versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">]
   cXmlAutorizado +=    cXmlAssinado
   cXmlAutorizado +=    [<protNFe versao="3.10">]
   cXmlAutorizado +=       [<infProt>]
   cXmlAutorizado +=          XmlTag( "tpAmb" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEvento" ) , "infEvento" ), "tpAmb" ) ) // runner
   cXmlAutorizado +=          XmlTag( "verAplic", 'SP_NFE_PL_008i2')
   cXmlAutorizado +=          XmlTag( "chNFe" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEvento" ) , "infEvento" ), "chNFe" ) ) // runner
   cXmlAutorizado +=          XmlTag( "dhRecbto" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEvento" ) , "infEvento" ), "dhRegEvento" ) ) // runner
   cXmlAutorizado +=          XmlTag( "nProt" , XmlNode( XmlNode( XmlNode( cXmlCancelamento, "retEvento" ) , "infEvento" ), "nProt" ) ) // runner
   cXmlAutorizado +=          XmlTag( "digVal", cDigVal)
   cXmlAutorizado +=          XmlTag( "cStat", '101')
   cXmlAutorizado +=          XmlTag( "xMotivo", 'Cancelamento da NFe homologado')
   cXmlAutorizado +=       [</infProt>]
   cXmlAutorizado +=    [</protNFe>]
   cXmlAutorizado += [</nfeProc>]

   RETURN cXmlAutorizado

STATIC FUNCTION UFCodigo( cSigla )

   LOCAL cUFs, cCodigo, nPosicao

   IF Val( cSigla ) > 0
      RETURN cSigla
   ENDIF
   cUFs := "AC,12,AL,27,AM,13,AP,16,BA,29,CE,23,DF,53,ES,32,GO,52,MG,31,MS,50,MT,51,MA,21,PA,15,PB,25,PE,26,PI,22,PR,41,RJ,33,RO,11,RN,24,RR,14,RS,43,SC,42,SE,28,SP,35,TO,17,"
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
   cUFs := "AC,12,AL,27,AM,13,AP,16,BA,29,CE,23,DF,53,ES,32,GO,52,MG,31,MS,50,MT,51,MA,21,PA,15,PB,25,PE,26,PI,22,PR,41,RJ,33,RO,11,RN,24,RR,14,RS,43,SC,42,SE,28,SP,35,TO,17,"
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

STATIC FUNCTION DomDocValidaXml( cXml, cFileXsd )

   LOCAL oXmlDomDoc, oXmlSchema, oXmlErro, cRetorno := "ERRO"

   hb_Default( @cFileXsd, "" )

   IF " <" $ cXml .OR. "> " $ cXml
      RETURN "Espaços inválidos no XML entre as tags"
   ENDIF

   IF Empty( cFileXsd )
      RETURN "OK"
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

      cRetorno   := "Erro Carregando XML"
      oXmlDomDoc:LoadXml( cXml )
      IF oXmlDomDoc:ParseError:ErrorCode <> 0
         cRetorno := "Erro XML inválido " + ;
                     " Linha: "   + AllTrim( Transform( oXmlDomDoc:ParseError:Line, "" ) ) + ;
                     " coluna: "  + AllTrim( Transform( oXmlDomDoc:ParseError:LinePos, "" ) ) + ;
                     " motivo: "  + AllTrim( Transform( oXmlDomDoc:ParseError:Reason, "" ) ) + ;
                     " errcode: " + AllTrim( Transform( oXmlDomDoc:ParseError:ErrorCode, "" ) )
          BREAK
      ENDIF

      cRetorno   := "Erro Carregando MSXML2.XMLSchemaCache.6.0"
      oXmlSchema := win_OleCreateObject( "MSXML2.XMLSchemaCache.6.0" )

      cRetorno   := "Erro carregando " + cFileXSD
      oXmlSchema:Add( "http://www.portalfiscal.inf.br/nfe", cFileXSD )

      oXmlDomDoc:Schemas := oXmlSchema
      oXmlErro := oXmlDomDoc:Validate()
      IF oXmlErro:ErrorCode <> 0
         cRetorno := "Erro: " + AllTrim( Transform( oXmlErro:ErrorCode, "" ) ) + " " + ConverteErroValidacao( oXmlErro:Reason, "" )
         BREAK
      ENDIF
      cRetorno := "OK"

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
//
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

STATIC FUNCTION SoapURL_AM( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO;          cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := SoapURL_AM( WS_AMBIENTE_HOMOLOGACAO, nWsServico, ... )
            // restrito a contribuintes // cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/CadConsultaCadastro2"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta2"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeRecepcao2"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO;       cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico2"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/CadConsultaCadastro2"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta2"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeRecepcao2"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico2"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_BA( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeCancelamento2.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeInutilizacao/NfeInutilizacao.asmx"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeCancelamento2.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeInutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_CE( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl"
      CASE nWsServico == WS_NFE_DOWNLOADNF ;          cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl"
      CASE nWsServico == WS_NFE_CANCELAMENTO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl"
      CASE nWsServico == WS_NFE_DOWNLOADNF ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl"
      CASE nWsServico == WS_NFE_INUTILIZACAO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_STATUSSERVICO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ; cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_GO( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeAutorizacao?wsdl"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeCancelamento2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/RecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetAutorizacao?wsdl"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeCancelamento2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_MG( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://cte.fazenda.mg.gov.br/cte/services/CteRecepcao"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://cte.fazenda.mg.gov.br/cte/services/CteRetRecepcao"
      CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://cte.fazenda.mg.gov.br/cte/services/CteInutilizacao"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://cte.fazenda.mg.gov.br/cte/services/CteConsulta"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://cte.fazenda.mg.gov.br/cte/services/CteStatusServico"
      CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://cte.fazenda.mg.gov.br/cte/services/RecepcaoEvento"
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeAutorizacao"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetAutorizacao"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeStatus2"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeStatusServico2"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_MS( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://producao.cte.ms.gov.br/ws/CteRecepcao"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://producao.cte.ms.gov.br/ws/CteRetRecepcao"
      CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://producao.cte.ms.gov.br/ws/CteInutilizacao"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://producao.cte.ms.gov.br/ws/CteConsulta"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://producao.cte.ms.gov.br/ws/CteStatusServico"
      CASE nWsServico == WS_CTE_CONSULTACADASTRO ;    cUrlWs := "https://producao.cte.ms.gov.br/ws/CadConsultaCadastro"
      CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://producao.cte.ms.gov.br/ws/CteRecepcaoEvento"
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeAutorizacao"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/CadConsultaCadastro2"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeConsulta2"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeInutilizacao2"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRecepcao2"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/RecepcaoEvento"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetAutorizacao"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetRecepcao2"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeStatusServico2"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/CadConsultaCadastro2"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeConsulta2"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeInutilizacao2"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRecepcao2"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/RecepcaoEvento"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRetRecepcao2"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeStatusServico2"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_MT( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://cte.sefaz.mt.gov.br/ctews/services/CteRecepcao"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://cte.sefaz.mt.gov.br/ctews/services/CteRetRecepcao"
      CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://cte.sefaz.mt.gov.br/ctews/services/CteInutilizacao"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://cte.sefaz.mt.gov.br/ctews/services/CteConsulta"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://cte.sefaz.mt.gov.br/ctews/services/CteStatusServico"
      CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://cte.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeCancelamento2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeCancelamento2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_PE( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeAutorizacao?wsdl"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro2"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetAutorizacao?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := SoapURL_PE( WS_AMBIENTE_PRODUCAO, nWsServico, ... )
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento2"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_PR( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://cte.fazenda.pr.gov.br/cte/CteRecepcao?wsdl"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://cte.fazenda.pr.gov.br/cte/CteRetRecepcao?wsdl"
      CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://cte.fazenda.pr.gov.br/cte/CteInutilizacao?wsdl"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://cte.fazenda.pr.gov.br/cte/CteConsulta?wsdl"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://cte.fazenda.pr.gov.br/cte/CteStatusServico?wsdl"
      CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeCancelamento2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe-evento/NFeRecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://homologacao.nfe.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRecepcaoEvento?wsdl"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_RS( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTADEST ;        cUrlWs := "https://nfe.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_DOWNLOADNF ;          cUrlWs := "https://nfe.sefazrs.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTADEST ;        cUrlWs := "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_DOWNLOADNF ;          cUrlWs := "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_SP( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx"
      CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx"
      CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "http://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx"
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nfecancelamento2.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx"
      CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx"
      CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx"
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeCancelamento2.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_SVRS( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://cte.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://cte.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx"
      CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://cte.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx"
      CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx"
      CASE nWsServico == WS_MDFE_DISTRIBUICAODFE ;    cUrlWs := "https://mdfe.svrs.rs.gov.br/WS/MDFeDistribuicaoDFe/MDFeDistribuicaoDFe.asmx"
      CASE nWsServico == WS_MDFE_CONSULTA ;           cUrlWs := "https://mdfe.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx"
      CASE nWsServico == WS_MDFE_RECEPCAO ;           cUrlWs := "https://mdfe.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx"
      CASE nWsServico == WS_MDFE_RECEPCAOEVENTO ;     cUrlWs := "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx"
      CASE nWsServico == WS_MDFE_RETRECEPCAO ;        cUrlWs := "https://mdfe.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx"
      CASE nWsServico == WS_MDFE_STATUSSERVICO ;      cUrlWs := "https://mdfe.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx"
      CASE nWsServico == WS_MDFE_CONSNAOENC ;         cUrlWs := "https://mdfe.svrs.rs.gov.br/ws/mdfeConsNaoEnc/mdfeConsNaoenc.asmx"
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.svrs.rs.gov.br/ws/nfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://cte-homologacao.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx"
      CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://cte-homologacao.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://cte-homologacao.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://cte-homologacao.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx"
      CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx"
      CASE nWsServico == WS_MDFE_CONSULTA ;           cUrlWs := "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx"
      CASE nWsServico == WS_MDFE_CONSNAOENC ;         cUrlWs := "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsNaoEnc/MDFeConsNaoEnc.asmx"
      CASE nWsServico == WS_MDFE_RECEPCAO ;           cUrlWs := "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx"
      CASE nWsServico == WS_MDFE_RECEPCAOEVENTO ;     cUrlWs := "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx"
      CASE nWsServico == WS_MDFE_RETRECEPCAO ;        cUrlWs := "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx"
      CASE nWsServico == WS_MDFE_STATUSSERVICO ;      cUrlWs := "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx"
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_SVSP( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx"
      CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteRetRecepcao.asmx"
      CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteConsulta.asmx"
      CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteStatusServico.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_SCAN( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://www.scan.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://www.scan.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://www.scan.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://www.scan.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://www.scan.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://www.scan.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://www.scan.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://www.scan.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://www.scan.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_SCVAN( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://www.svc.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO;    cUrlWs := "https://www.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://www.svc.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://www.svc.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://www.svc.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://www.svc.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://www.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_SVAN( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx"
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsServico == WS_NFE_DOWNLOADNF ;          cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE
   ELSE
      DO CASE
      CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WS_NFE_DOWNLOADNF ;          cUrlWs := "https://hom.nfe.fazenda.gov.br/nfedownloadnf/nfedownloadnf.asmx"
      CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION SoapURL_AN( cAmbiente, nWsServico, ... )

   LOCAL cUrlWs := ""

   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTADEST ;        cUrlWs := "https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx"
      CASE nWsServico == WS_NFE_DISTRIBUICAODFE;      cUrlWs := "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx"
      CASE nWsServico == WS_NFE_DOWNLOADNF ;          cUrlWs := "https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx"
      CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://www.nfe.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      ENDCASE
   ENDIF

   RETURN cUrlWs

STATIC FUNCTION GeraQRCode( cXmlAssinado, cIdToken, cCSC )

   LOCAL QRCODE_cTag, QRCODE_Url,   QRCODE_chNFe,  QRCODE_nVersao,  QRCODE_tpAmb, QRCODE_cDest, QRCODE_dhEmi,;
         QRCODE_vNF,  QRCODE_vICMS, QRCODE_digVal, QRCODE_cIdToken, QRCODE_cCSC,  QRCODE_cHash,;
         cInfNFe, cSignature, cAmbiente, cUF

   cInfNFe    := XmlNode( cXmlAssinado, "infNFe", .T. )
   cSignature := XmlNode( cXmlAssinado, "Signature", .T. )

   cAmbiente  := XmlNode( XmlNode( cInfNFe, "ide" ), "tpAmb" )
   cUF        := UFSigla( XmlNode( XmlNode( cInfNFe, "ide" ), "cUF" ) )

   // 1¦ Parte ( Endereco da Consulta - Fonte: http://nfce.encat.org/desenvolvedor/qrcode/ )
   IF cAmbiente == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE cUF == "AC" ; QRCODE_Url := "http://www.sefaznet.ac.gov.br/nfce/qrcode?"
      CASE cUF == "AL" ; QRCODE_Url := "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?"
      CASE cUF == "AP" ; QRCODE_Url := "https://www.sefaz.ap.gov.br/nfce/nfcep.php?"
      CASE cUF == "AM" ; QRCODE_Url := "http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?"
      CASE cUF == "BA" ; QRCODE_Url := "http://nfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx"
      CASE cUF == "CE" ; QRCODE_Url := "http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html"
      CASE cUF == "DF" ; QRCODE_Url := "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx"
      CASE cUF == "ES" ; QRCODE_Url := "http://app.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?"
      CASE cUF == "GO" ; QRCODE_Url := "http://nfe.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe"
      CASE cUF == "MA" ; QRCODE_Url := "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?"
      CASE cUF == "MT" ; QRCODE_Url := "http://www.sefaz.mt.gov.br/nfce/consultanfce?"
      CASE cUF == "MS" ; QRCODE_Url := "http://www.dfe.ms.gov.br/nfce/qrcode?"
      CASE cUF == "MG" ; QRCODE_Url := ""
      CASE cUF == "PA" ; QRCODE_Url := "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/nfceForm.seam?"
      CASE cUF == "PB" ; QRCODE_Url := "http://www.receita.pb.gov.br/nfce?"
      CASE cUF == "PR" ; QRCODE_Url := "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?"
      CASE cUF == "PE" ; QRCODE_Url := "http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe?"
      CASE cUF == "PI" ; QRCODE_Url := "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf?"
      CASE cUF == "RJ" ; QRCODE_Url := "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?"
      CASE cUF == "RN" ; QRCODE_Url := "http://nfce.set.rn.gov.br/consultarNFCe.aspx?"
      CASE cUF == "RS" ; QRCODE_Url := "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?"
      CASE cUF == "RO" ; QRCODE_Url := "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp?"
      CASE cUF == "RR" ; QRCODE_Url := "https://www.sefaz.rr.gov.br/nfce/servlet/qrcode?"
      CASE cUF == "SC" ; QRCODE_Url := ""
      CASE cUF == "SP" ; QRCODE_Url := "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx?"
      CASE cUF == "SE" ; QRCODE_Url := "http://www.nfce.se.gov.br/portal/consultarNFCe.jsp?"
      CASE cUF == "TO" ; QRCODE_Url := ""
      ENDCASE
   ELSE
      DO CASE
      CASE cUF == "AC" ; QRCODE_Url := "http://hml.sefaznet.ac.gov.br/nfce/qrcode?"
      CASE cUF == "AL" ; QRCODE_Url := "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?"
      CASE cUF == "AP" ; QRCODE_Url := "https://www.sefaz.ap.gov.br/nfcehml/nfce.php?"
      CASE cUF == "AM" ; QRCODE_Url := "http://homnfce.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?"
      CASE cUF == "BA" ; QRCODE_Url := "http://hnfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx"
      CASE cUF == "CE" ; QRCODE_Url := "http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html"
      CASE cUF == "DF" ; QRCODE_Url := "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx"
      CASE cUF == "ES" ; QRCODE_Url := "http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?"
      CASE cUF == "GO" ; QRCODE_Url := ""
      CASE cUF == "MA" ; QRCODE_Url := "http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?"
      CASE cUF == "MT" ; QRCODE_Url := "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce?"
      CASE cUF == "MS" ; QRCODE_Url := "http://www.dfe.ms.gov.br/nfce/qrcode?"
      CASE cUF == "MG" ; QRCODE_Url := ""
      CASE cUF == "PA" ; QRCODE_Url := "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/nfceForm.seam"
      CASE cUF == "PB" ; QRCODE_Url := "http://www.receita.pb.gov.br/nfcehom"
      CASE cUF == "PR" ; QRCODE_Url := "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?"
      CASE cUF == "PE" ; QRCODE_Url := "http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe?"
      CASE cUF == "PI" ; QRCODE_Url := "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf?"
      CASE cUF == "RJ" ; QRCODE_Url := "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?"
      CASE cUF == "RN" ; QRCODE_Url := "http://hom.nfce.set.rn.gov.br/consultarNFCe.aspx?"
      CASE cUF == "RS" ; QRCODE_Url := "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?"
      CASE cUF == "RO" ; QRCODE_Url := "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp"
      CASE cUF == "RR" ; QRCODE_Url := "http://200.174.88.103:8080/nfce/servlet/qrcode?"
      CASE cUF == "SC" ; QRCODE_Url := ""
      CASE cUF == "SP" ; QRCODE_Url := "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx"
      CASE cUF == "SE" ; QRCODE_Url := "http://www.hom.nfe.se.gov.br/portal/consultarNFCe.jsp?"
      CASE cUF == "TO" ; QRCODE_Url := ""
      ENDCASE
   ENDIF

   // 2¦ Parte (Parametros)
   QRCODE_chNFe    := AllTrim( Substr( XmlElement( cInfNFe, "Id" ), 4 ) )
   QRCODE_nVersao  := "100"
   QRCODE_tpAmb    := cAmbiente
   QRCODE_cDest    := XmlNode( XmlNode( cInfNFe, "dest" ), "CPF" )
   IF Empty( QRCODE_cDest )
      QRCODE_cDest := XmlNode( XmlNode( cInfNFe, "dest" ), "CNPJ" )
   ENDIF
   QRCODE_dhEmi    := hb_StrToHex( XmlNode( XmlNode( cInfNFe, "ide" ), "dhEmi" ) )
   QRCODE_vNF      := XmlNode( XmlNode( XmlNode( cInfNFe, "total" ), "ICMSTot" ), "vNF" )
   QRCODE_vICMS    := XmlNode( XmlNode( XmlNode( cInfNFe, "total" ), "ICMSTot" ), "vICMS" )
   QRCODE_digVal   := hb_StrToHex( XmlNode( XmlNode( XmlNode( cSignature, "SignedInfo" ), "Reference" ), "DigestValue" ) )
   QRCODE_cIdToken := cIdToken
   QRCODE_cCSC     := cCSC

   IF !Empty( QRCODE_chNFe ) .AND. !Empty( QRCODE_nVersao ) .AND. !Empty( QRCODE_tpAmb    ) .AND. !Empty( QRCODE_dhEmi ) .AND. !Empty( QRCODE_vNF ) .AND.;
      !Empty( QRCODE_vICMS ) .AND. !Empty( QRCODE_digVal  ) .AND. !Empty( QRCODE_cIdToken ) .AND. !Empty( QRCODE_cCSC  )

      QRCODE_chNFe    := "chNFe="    + QRCODE_chNFe    + "&"
      QRCODE_nVersao  := "nVersao="  + QRCODE_nVersao  + "&"
      QRCODE_tpAmb    := "tpAmb="    + QRCODE_tpAmb    + "&"
      // Na hipotese do consumidor nao se identificar na NFC-e, nao existira o parametro cDest no QR Code
      // e tambem nao devera ser incluido o parametro cDest na sequencia sobre a qual sera aplicado o hash do QR Code
      IF !Empty( QRCODE_cDest )
         QRCODE_cDest := "cDest="    + QRCODE_cDest    + "&"
      ENDIF
      QRCODE_dhEmi    := "dhEmi="    + QRCODE_dhEmi    + "&"
      QRCODE_vNF      := "vNF="      + QRCODE_vNF      + "&"
      QRCODE_vICMS    := "vICMS="    + QRCODE_vICMS    + "&"
      QRCODE_digVal   := "digVal="   + QRCODE_digVal   + "&"
      QRCODE_cIdToken := "cIdToken=" + QRCODE_cIdToken

      // 3¦ Parte (cHashQRCode)
      QRCODE_cHash := ( "&cHashQRCode=" +;
                        hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cCSC ) )

      // Resultado da URL formada a ser incluida na imagem QR Code
      QRCODE_cTag  := ( "<![CDATA[" +;
                        QRCODE_Url + QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cHash +;
                        "]]>" )

      // XML com a Tag do QRCode
      cXmlAssinado := [<NFe xmlns="http://www.portalfiscal.inf.br/nfe">]
      cXmlAssinado += cInfNFe
      cXmlAssinado += [<]+"infNFeSupl"+[>]
      cXmlAssinado += [<]+"qrCode"+[>] + QRCODE_cTag + [</]+"qrCode"+[>]
      cXmlAssinado += [</]+"infNFeSupl"+[>]
      cXmlAssinado += cSignature
      cXmlAssinado += [</NFe>]
   ELSE
      RETURN "Erro na geracao do QRCode"
   ENDIF

   RETURN "OK"
