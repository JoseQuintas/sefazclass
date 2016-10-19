/*
ZE_SPEDSEFAZCLASS - Rotinas pra comunicação com SEFAZ

2016.09.14.1400 - Correção SOAP Action de consultar recibo MDFe
2016.09.15.1230 - Motivo correto, do protocolo e não da consulta
2016.09.16.1750 - Correção mdfeProc, estava MDFeProc

Nota: CTE 2.00 vale até 06/2017 e CTE 3.00 começa em 12/2016
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

#define INDSINC_RETORNA_PROTOCOLO    "1"
#define INDSINC_RETORNA_RECIBO       "0"

CREATE CLASS SefazClass

   /* configuração */
   VAR    cProjeto       INIT WS_PROJETO_NFE          /* Modificada conforme método */
   VAR    cAmbiente      INIT WS_AMBIENTE_PRODUCAO
   VAR    cVersao        INIT "3.10"                  /* Modificada conforme método */
   VAR    cScan          INIT "N"                     /* Indicar se for SCAN/SVAN, ainda não testado */
   VAR    cUF            INIT "SP"                    /* Modificada conforme método */
   VAR    cCertificado   INIT ""                      /* Nome do certificado */
   VAR    ValidFromDate  INIT ""                      /* Validade do certificado */ // runner
   VAR    ValidToDate    INIT ""                      /* Validade do certificado */ // runner
   VAR    cPastaSchemas  INIT ""                      /* Pasta dos Schemas, caso não esteja na pasta padrão do executavel  */ // runner
   VAR    cIndSinc       INIT INDSINC_RETORNA_RECIBO  /* Poucas UFs opção de protocolo */
   VAR    nTempoEspera   INIT 7                       /* intervalo entre envia lote e consulta recibo */
   VAR    cUFTimeZone    INIT "SP"                    /* Para DateTimeXml() Obrigatório definir UF default */
   /* XMLs de cada etapa */
   VAR    cXmlDados      INIT ""                      /* usado pra criar/complementar XML do documento */
   VAR    cXmlRetorno    INIT "Erro Desconhecido"     /* Retorno do webservice e/ou rotina */
   VAR    cXmlRecibo     INIT ""                      /* XML recibo (obtido no envio do lote) */
   VAR    cXmlProtocolo  INIT ""                      /* XML protocolo (obtido no consulta recibo e/ou envio de outros docs) */
   VAR    cXmlAutorizado INIT ""                      /* XML autorizado, caso tudo ocorra sem problemas */
   VAR    cStatus        INIT ""                      /* Status obtido da resposta final da Fazenda */
   VAR    cRecibo        INIT ""                      /* Número do recibo */
   VAR    cMotivo        INIT ""                      /* Motivo constante no Recibo */
   /* uso interno */
   VAR    cVersaoXml     INIT ""                      /* Apenas versão usada no XML */
   VAR    cServico       INIT ""                      /* Operação existente no webservice */
   VAR    cSoapAction    INIT ""                      /* Ação solicitada ao webservice */
   VAR    cWebService    INIT ""                      /* Endereço de webservice */
   VAR    cXmlSoap       INIT ""                      /* XML completo enviado pra Sefaz, incluindo informações do envelope */

   METHOD CTeConsulta( ... )   INLINE  ::CTeConsultaProtocolo( ... )    // Não usar, apenas compatibilidade
   METHOD NFeConsulta( ... )   INLINE  ::NFeConsultaProtocolo( ... )    // Não usar, apenas compatibilidade
   METHOD MDFeConsulta( ... )  INLINE  ::MDFeConsultaProtocolo( ... )   // Não usar, apenas compatibilidade
   METHOD CTeStatus( ... )     INLINE  ::CTeStatusServico( ... )        // Não usar, apenas compatibilidade
   METHOD NFeStatus( ... )     INLINE  ::NFeStatusServico( ... )        // Não usar, apenas compatibilidade
   METHOD MDFeStatus( ... )    INLINE  ::MDFeStatusServico( ... )       // Não usar, apenas compatibilidade
   METHOD NFeCadastro( ... )   INLINE  ::NFeConsultaCadastro( ... )     // Não usar, apenas compatibilidade
   METHOD NFeEventoCCE( ... )  INLINE  ::NFeEventoCarta( ... )          // Não usar, apenas compatibilidade
   METHOD CTeEventoCCE( ... )  INLINE  ::CteEventoCarta( ... )

   METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente )
   METHOD CTeEventoEnvia( cChave, cXml, cCertificado, cAmbiente )
   METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD CTeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD MDFeConsNaoEnc( cCNPJ , cCertificado, cAmbiente )
   METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD MDFeEventoEncerramento( cChave, nSequencia , nProt, cUFFim , cMunCarrega , cCertificado, cAmbiente )
   METHOD MDFeEventoEnvia( cChave, cXml, cCertificado, cAmbiente )
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
   METHOD NFeEventoEnvia( cChave, cXml, cCertificado, cAmbiente )
   METHOD NFeEventoNaoRealizada( cChave, nSequencia, xJust, cCertificado, cAmbiente )
   METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc )
   METHOD NFeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD CTeAddCancelamento( cXmlAssinado, cXmlRetorno ) INLINE CTeAddCancelamento( cXmlAssinado, cXmlRetorno )
   METHOD NFeAddCancelamento( cXmlAssinado, cXmlRetorno ) INLINE NFeAddCancelamento( cXmlAssinado, cXmlRetorno )

   /* Uso interno */
   METHOD GetWebService( nWsServico )
   METHOD XmlSoapEnvelope()
   METHOD XmlSoapPost()
   METHOD MicrosoftXmlSoapPost()

   /* Apenas redirecionamento */
   METHOD AssinaXml( cXml )                 INLINE AssinaXml( @cXml, ::cCertificado )
   METHOD TipoXml( cXml )                   INLINE TipoXml( cXml )
   METHOD UFCodigo( cSigla )                INLINE UFCodigo( cSigla )
   METHOD UFSigla( cCodigo )                INLINE UFSigla( cCodigo )
   METHOD DateTimeXml( dDate, cTime, lUTC ) INLINE DateTimeXml( dDate, cTime, iif( ::cUFTimeZone == NIL, ::cUF, ::cUFTimeZone ), lUTC )
   METHOD ValidaXml( cXml, cFileXsd )       INLINE ValidaXml( cXml, cFileXsd )

   ENDCLASS

METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto     := WS_PROJETO_CTE
   ::cUF          := ::UFSigla( Substr( cChave, 1, 2 ) )
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta"
   ::cSoapAction  := "cteConsultaCT"
   ::cWebService  := ::GetWebService( WS_CTE_CONSULTAPROTOCOLO )
   ::cXmlDados    := [<consSitCTe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados    +=    XmlTag( "chCTe", cChave )
   ::cXmlDados    += [</consSitCTe>]
   IF Substr( cChave, 21, 2 ) != "57"
      ::cXmlRetorno := "*ERRO* Chave não se refere a CTE"
   ELSE
      ::XmlSoapPost()
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto    := WS_PROJETO_CTE
   ::cVersaoXml  := "2.00"
   ::cServico    := "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao"
   ::cSoapAction := "cteRetRecepcao"
   ::cWebService := ::GetWebService( WS_CTE_RETRECEPCAO )
   ::cXmlDados   := [<consReciCTe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "nRec",  ::cRecibo )
   ::cXmlDados   += [</consReciCTe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno                                           // ? hb_Utf8ToStr()
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" ) // ? hb_Utf8ToStr()

   RETURN ::cXmlRetorno // ? hb_Utf8ToStr()

METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @nSequencia, 1 )

   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )

   cXml := [<eventoCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="2.00">]
   cXml +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   cXml +=       XmlTag( "tpAmb", ::cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chCTe", cChave )
   cXml +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   cXml +=       XmlTag( "tpEvento", "110111" )
   cXml +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia ) ) )
   cXml +=       [<detEvento versaoEvento="2.00">]
   cXml +=            [<evCancCTe>]
   cXml +=                XmlTag( "descEvento", "Cancelamento" )
   cXml +=                XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=                XmlTag( "xJust", xJust )
   cXml +=            [</evCancCTe>]
   cXml +=       [</detEvento>]
   cXml +=    [</infEvento>]
   cXml += [</eventoCTe>]
   ::cXmlRetorno := ::AssinaXml( @cXml )
   IF ::cXmlRetorno == "OK"
      ::CTeEventoEnvia( cChave, cXml )
      ::CTeGeraEventoAutorizado( @cXml, ::cXmlRetorno )
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml
   LOCAL oElement

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF

   hb_Default( @nSequencia, 1 )

   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )

   cXml := [<eventoCTe xmlns="http://www.portalfiscal.inf.br/cte" versao="2.00">]
   cXml +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   cXml +=       XmlTag( "tpAmb", ::cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chCTe", cChave )
   cXml +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   cXml +=       XmlTag( "tpEvento", "110110" )
   cXml +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia ) ) )
   cXml +=       [<detEvento versaoEvento="2.00">]
   cXml +=            [<evCCeCTe>]
   cXml +=                XmlTag( "descEvento", "Carta de Correcao" )
                        FOR EACH oElement IN aAlteracoes
   cXml +=                     [<infCorrecao>]
   cXml +=                      XmlTag( "grupoAlterado", oElement[ 1 ] )
   cXml +=                      XmlTag( "campoAlterado", oElement[ 2 ] )
   cXml +=                      XmlTag( "valorAlterado", oElement[ 3 ] )
   cXml +=                     [</infCorrecao>]
                        NEXT
   cXml +=                [<xCondUso>]
   cXml +=                   "A Carta de Correcao e disciplinada pelo Art. 58-B "
   cXml +=                   "do CONVENIO/SINIEF 06/89: Fica permitida a utilizacao de carta "
   cXml +=                   "de correcao, para regularizacao de erro ocorrido na emissao de "
   cXml +=                   "documentos fiscais relativos a prestacao de servico de transporte, "
   cXml +=                   "desde que o erro nao esteja relacionado com: I - as variaveis que "
   cXml +=                   "determinam o valor do imposto tais como: base de calculo, aliquota, "
   cXml +=                   "diferenca de preco, quantidade, valor da prestacao;II - a correcao "
   cXml +=                   "de dados cadastrais que implique mudanca do emitente, tomador, "
   cXml +=                   "remetente ou do destinatario;III - a data de emissao ou de saida."
   cXml +=                [</xCondUso>]
   cXml +=          [</evCCeCTe>]
   cXml +=       [</detEvento>]
   cXml +=    [</infEvento>]
   cXml += [</eventoCTe>]
   ::cXmlRetorno := ::AssinaXml( @cXml )
   IF ::cXmlRetorno == "OK"
      ::CTeEventoEnvia( cChave, cXml )
      ::CTeGeraEventoAutorizado( cXml, ::cXmlRetorno )
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeEventoEnvia( cChave, cXml, cCertificado, cAmbiente ) CLASS SefazClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto     := WS_PROJETO_CTE
   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento"
   ::cSoapAction  := "cteRecepcaoEvento"
   ::cWebService  := ::GetWebService( WS_CTE_RECEPCAOEVENTO )
   ::cXmlDados    :=    cXml
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protCTe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<Erro text="Não autorizado" />] + cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := [<?xml version="1.00"?>]
   ::cXmlAutorizado += [<cteProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protCTe", .T. ) // ?hb_Utf8ToStr()
   ::cXmlAutorizado += [</cteProc>]
   ::cXmlRetorno    := ::cXmlAutorizado

   RETURN ::cXmlAutorizado

METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "xMotivo" ) // runner
   IF ! ::cStatus $ "135,155"
      ::cXmlRetorno := [<Erro text="Não autorizado" />] + cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := [<?xml version="1.00"?>]
   ::cXmlAutorizado += [<procEventoCTe versao="2.00" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoCTe versao="2.00">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEventoCTe" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEventoCTe>]
   ::cXmlAutorizado += [</procEventoCTe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()
   ::cXmlRetorno := ::cXmlAutorizado

   RETURN ::cXmlAutorizado

METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto    := WS_PROJETO_CTE
   ::cVersaoXml  := "2.00"
   ::cServico    := "http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao"
   ::cSoapAction := "cteInutilizacaoCT"
   ::cWebService := ::GetWebService( ::cUF, WS_CTE_INUTILIZACAO, ::cAmbiente, WS_PROJETO_CTE )
   ::cXmlDados   := [<inutCTe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados   +=    [<infInut Id="ID] + ::UFCodigo( ::cUF ) + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDados   +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDados   +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDados   +=       XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDados   +=       XmlTag( "ano", cAno )
   ::cXmlDados   +=       XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDados   +=       XmlTag( "mod", cMod )
   ::cXmlDados   +=       XmlTag( "serie", cSerie )
   ::cXmlDados   +=       XmlTag( "nCTIni", Alltrim(Str(Val(cNumIni))) )
   ::cXmlDados   +=       XmlTag( "nCTFin", Alltrim(Str(Val(cNumFim))) )
   ::cXmlDados   +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDados   +=    [</infInut>]
   ::cXmlDados   += [</inutCTe>]
   ::cXmlRetorno := ::AssinaXml( @::cXmlDados )
   IF ::cXmlRetorno == "OK"
      ::XmlSoapPost()
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      IF ::cStatus == "102"
         ::cXmlAutorizado := [<ProcInutCTe versao="2.00" xmlns="http://www.portalfiscal.inf.br/cte">]
         ::cXmlAutorizado += ::cXmlDados
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno , "retInutCTe", .T. )
         ::cXmlAutorizado += [</ProcInutCTe>]
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   IF Empty( cLote )
      cLote := "1"
   ENDIF
   ::cProjeto     := WS_PROJETO_CTE
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao"
   ::cSoapAction  := "cteRecepcaoLote"
   ::cWebService  := ::GetWebService( WS_CTE_RECEPCAO )
   ::cXmlDados    := [<enviCTe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados    +=    XmlTag( "idLote", cLote )
   ::cXmlDados    +=    cXml
   ::cXmlDados    += [</enviCTe>]
   ::XmlSoapPost()
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   IF ! Empty( ::cRecibo )
      Inkey( ::nTempoEspera )
      ::CteConsultaRecibo()
      ::CteGeraAutorizado( cXml, ::cXmlProtocolo ) // runner
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto     := WS_PROJETO_CTE
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico"
   ::cSoapAction  := "cteStatusServicoCT"
   ::cWebService  := ::GetWebService( WS_CTE_STATUSSERVICO )
   ::cXmlDados    := [<consStatServCte versao="]  + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados    += [</consStatServCte>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD MDFeConsNaoEnc( cCNPJ , cCertificado, cAmbiente ) CLASS SefazClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto     := WS_PROJETO_MDFE
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsNaoEnc"
   ::cSoapAction  := "mdfeConsNaoEnc"
   ::cWebService  := ::GetWebService( ::cUF, WS_MDFE_CONSNAOENC , ::cAmbiente, WS_PROJETO_MDFE )
   ::cXmlDados    := [<consMDFeNaoEnc versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "xServ", "CONSULTAR NÃO ENCERRADOS" )
   ::cXmlDados    +=    XmlTag( "CNPJ", cCNPJ )
   ::cXmlDados    += [</consMDFeNaoEnc>]
   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_MDFE )
   ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "xMotivo" )

   RETURN ::cXmlRetorno

METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto    := WS_PROJETO_MDFE
   ::cUF         := ::UFSigla( Substr( cChave, 1, 2 ) )
   ::cVersaoXml  := "1.00"
   ::cServico    := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta"
   ::cSoapAction := "mdfeConsultaMDF"
   ::cWebService := ::GetWebService( WS_MDFE_CONSULTA )
   ::cXmlDados   := [<consSitMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados   +=    XmlTag( "chMDFe", cChave )
   ::cXmlDados   += [</consSitMDFe>]
   IF Substr( cChave, 21, 2 ) != "58"
      ::cXmlRetorno := "*ERRO* Chave não se refere a MDFE"
   ELSE
      ::XmlSoapPost()
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto     := WS_PROJETO_MDFE
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao"
   ::cSoapAction  := "mdfeRetRecepcao"
   ::cWebService  := ::GetWebService( WS_MDFE_RETRECEPCAO )
   ::cXmlDados    := [<consReciMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlDados    += [</consReciMDFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )

   RETURN ::cXmlRetorno

// 2016.01.31.2200 Iniciado apenas
METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )
   ::cProjeto    := "??????"
   ::cVersaoXml  := "1.00"
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/MDFeDistribuicaoDFe"
   ::cSoapAction := "mdfeDistDFeInteresse"
   ::cXmlDados   := [<distDFeInt versao="] + ::cVersaoXml + ["xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "cUFAutor", ::UFCodigo( ::cUF ) )
   ::cXmlDados   +=    XmlTag( "CNPJ", cCnpj )
   IF Empty( cNSU )
      ::cXmlDados +=   [<distNSU>]
      ::cXmlDados +=      XmlTag( "ultNSU", cUltNSU )
      ::cXmlDados +=   [</distNSU>]
   ELSE
      ::cXmlDados +=   [<consNSU>]
      ::cXmlDados +=      XmlTag( "NSU", cNSU )
      ::cXmlDados +=   [</consNSU>]
   ENDIF
   ::cXmlDados   += [</distDFeInt>]
   ::cWebService := ::GetWebService( WS_MDFE_DISTRIBUICAODFE )
   ::XmlSoapPost()

   RETURN NIL

METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @nSequencia, 1 )

   ::cProjeto     := WS_PROJETO_MDFE
   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )
   cXml := [<eventoMDFe xmlns="http://www.portalfiscal.inf.br/mdfe" versao="1.00">]
   cXml +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   cXml +=       XmlTag( "tpAmb", ::cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chMDFe", cChave )
   cXml +=       XmlTag( "dhEvento", ::DateTimeXml( , , ,.F.) )
   cXml +=       XmlTag( "tpEvento", "110111" )
   cXml +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia ) ) )
   cXml +=       [<detEvento versaoEvento="1.00">]
   cXml +=       	  [<evCancMDFe>]
   cXml +=          		XmlTag( "descEvento", "Cancelamento" )
   cXml +=          		XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=          		XmlTag( "xJust", xJust )
   cXml +=       	  [</evCancMDFe>]
   cXml +=       [</detEvento>]
   cXml +=    [</infEvento>]
   cXml += [</eventoMDFe>]
   ::cXmlRetorno := AssinaXml( @cXml, ::cCertificado )
   IF ::cXmlRetorno == "OK"
      ::MDFeEventoEnvia( cChave, cXml, ::cCertificado, ::cAmbiente )
      ::MDFeGeraEventoAutorizado( @cXml, hb_Utf8ToStr(::cXmlRetorno) )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeEventoEncerramento( cChave, nSequencia , nProt, cUFFim , cMunCarrega , cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @nSequencia, 1 )

   ::cProjeto     := WS_PROJETO_MDFE
   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )
   cXml := [<eventoMDFe xmlns="http://www.portalfiscal.inf.br/mdfe" versao="1.00">]
   cXml +=    [<infEvento Id="ID110112] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   cXml +=       XmlTag( "tpAmb", ::cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chMDFe", cChave )
   cXml +=       XmlTag( "dhEvento", ::DateTimeXml( , , ,.F.) )
   cXml +=       XmlTag( "tpEvento", "110112" )
   cXml +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia ) ) )
   cXml +=       [<detEvento versaoEvento="1.00">]
   cXml +=       	  [<evEncMDFe>]
   cXml +=          		XmlTag( "descEvento", "Encerramento" )
   cXml +=          		XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=          		XmlTag( "dtEnc", DateXml( Date() ) )
   cXml +=          		XmlTag( "cUF", ::UFCodigo( cUFFim ) )
   cXml +=          		XmlTag( "cMun", cMunCarrega )
   cXml +=       	  [</evEncMDFe>]
   cXml +=       [</detEvento>]
   cXml +=    [</infEvento>]
   cXml += [</eventoMDFe>]
   ::cXmlRetorno := AssinaXml( @cXml, ::cCertificado )
   IF ::cXmlRetorno == "OK"
      ::MDFeEventoEnvia( cChave, cXml, ::cCertificado, ::cAmbiente )
      ::MDFeGeraEventoAutorizado( @cXml, hb_Utf8ToStr(::cXmlRetorno) )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeEventoEnvia( cChave, cXml, cCertificado, cAmbiente ) CLASS SefazClass

	IF cCertificado != NIL
	   ::cCertificado := cCertificado
	ENDIF
	IF cAmbiente != NIL
	   ::cAmbiente := cAmbiente
	ENDIF
   ::cProjeto     := WS_PROJETO_MDFE
	::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )
	::cVersaoXml   := "1.00"
	::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento"
	::cSoapAction  := "mdfeRecepcaoEvento"
	::cWebService  := ::GetWebService( ::cUF, WS_MDFE_RECEPCAOEVENTO, ::cAmbiente, WS_PROJETO_MDFE )
	::cXmlDados    :=    cXml
	::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_MDFE )

	RETURN ::cXmlRetorno

METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protMDFe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<Erro text="Não autorizado" />] + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   // ::cXmlAutorizado := [<?xml version="1.00"?>] // colocando isto, emissor gratuito e explorer rejeitam
   ::cXmlAutorizado += [<mdfeProc versao="1.00" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlAUtorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protMDFe", .T. )
   ::cXmlAutorizado += [</mdfeProc>]
   ::cXmlRetorno    := ::cXmlAutorizado

   RETURN ::cXmlAutorizado

METHOD MDFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEventoMDFe" ), "cStat" ), 3 )
   ::cMotivo := hb_Utf8ToStr( XmlNode( XmlNode( cXmlProtocolo, "retEventoMDFe" ), "xMotivo" ) )
   IF ! ::cStatus $ "135,136"
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := [<?xml version="1.00"?>]
   ::cXmlAutorizado += [<procEvento versao="1.00" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoMDFe versao="1.00">]
   ::cXmlAutorizado +=    hb_Utf8ToStr(XmlNode( cXmlProtocolo, "retEventoMDFe" ))
   ::cXmlAutorizado += [</retEventoMDFe>]
   ::cXmlAutorizado += [</procEvento>]
   ::cXmlDados := cXmlAssinado
   ::cMotivo := hb_Utf8ToStr(XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ))

   RETURN ::cXmlAutorizado

METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto     := WS_PROJETO_MDFE
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao"
   ::cSoapAction  := "MDFeRecepcao"
   ::cWebService  := ::GetWebService( WS_MDFE_RECEPCAO )
   ::cXmlDados    := [<enviMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "idLote", cLote )
   ::cXmlDados    +=    cXml
   ::cXmlDados    += [</enviMDFe>]
   ::XmlSoapPost()
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   IF ! Empty( ::cRecibo )
      Inkey( ::nTempoEspera )
      ::MDFeConsultaRecibo()
      ::cXmlRetorno := ::MDFeGeraAutorizado( cXml, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto     := WS_PROJETO_MDFE
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico/mdfeStatusServicoMDF"
   ::cSoapAction  := "MDFeStatusServico"
   ::cWebService  := ::GetWebService( WS_MDFE_STATUSSERVICO )
   ::cXmlDados    := [<consStatServMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDados    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados    += [</consStatServMDFe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cProjeto     := WS_PROJETO_NFE
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2"
   ::cSoapAction  := "CadConsultaCadastro2"
   ::cWebService  := ::GetWebService( WS_NFE_CONSULTACADASTRO )
   ::cXmlDados    := [<ConsCad versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    +=    [<infCons>]
   ::cXmlDados    +=       XmlTag( "xServ", "CONS-CAD" )
   ::cXmlDados    +=       XmlTag( "UF", ::cUF )
   ::cXmlDados    +=       XmlTag( "CNPJ", cCNPJ )
   ::cXmlDados    +=    [</infCons>]
   ::cXmlDados    += [</ConsCad>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

/* Iniciado apenas 2015.07.31.1400 */
METHOD NFeConsultaDest( cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cIndNFe, "0" )
   hb_Default( @cIndEmi, "0" )
   ::cVersaoXml  := "3.10"
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest"
   ::cSoapAction := "nfeConsultaNFDest"
   ::cWebService := ::GetWebService( WS_NFE_CONSULTADEST )
   ::cXmlDados   := [<consNFeDest versao="] + ::cVersaoXml + [">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "xServ", "CONSULTAR NFE DEST" )
   ::cXmlDados   +=    XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDados   +=    XmlTag( "indNFe", "0" ) // 0=todas,1=sem manif,2=sem nada
   ::cXmlDados   +=    XmlTag( "indEmi", "0" ) // 0=todas, 1=sem cnpj raiz(sem matriz/filial)
   ::cXmlDados   +=    XmlTag( "ultNSU", cUltNsu )
   ::cXmlDados   += [</consNFeDest>]

   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cUF         := ::UFSigla( Substr( cChave, 1, 2 ) )
   ::cVersaoXml  := "3.10"
   DO CASE
   CASE ::cUF $ "BA"
      ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta"
      ::cSoapAction := "nfeConsultaNF"
   CASE ::cUF $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO"
      ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2"
      ::cSoapAction := "nfeConsultaNF2"
   OTHERWISE
      ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2"
      ::cSoapAction := "NfeConsulta2"
   ENDCASE
   ::cWebService := ::GetWebService( WS_NFE_CONSULTAPROTOCOLO )
   ::cXmlDados   := [<consSitNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados   +=    XmlTag( "chNFe", cChave )
   ::cXmlDados   += [</consSitNFe>]
   IF ! Substr( cChave, 21, 2 ) $ "55,65"
      ::cXmlRetorno := "*ERRO* Chave não se refere a NFE"
   ELSE
      ::XmlSoapPost()
   ENDIF

   RETURN ::cXmlRetorno

/* 2015.07.31.1400 Iniciado apenas */
METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )
   ::cProjeto    := "????????"
   ::cVersaoXml  := "1.00"
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe"
   ::cSoapAction := "nfeDistDFeInteresse"
   ::cXmlDados   := [<distDFeInt versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "cUFAutor", ::UFCodigo( ::cUF ) )
   ::cXmlDados   +=    XmlTag( "CNPJ", cCnpj )
   IF Empty( cNSU )
      ::cXmlDados +=   [<distNSU>]
      ::cXmlDados +=      XmlTag( "ultNSU", cUltNSU )
      ::cXmlDados +=   [</distNSU>]
   ELSE
      ::cXmlDados +=   [<consNSU>]
      ::cXmlDados +=      XmlTag( "NSU", cNSU )
      ::cXmlDados +=   [</consNSU>]
   ENDIF
   ::cXmlDados   += [</distDFeInt>]
   ::cWebService := ::GetWebService( WS_NFE_DISTRIBUICAODFE )
   ::XmlSoapPost()

   RETURN NIL

METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF

   hb_Default( @nSequencia, 1 )

   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )

   cXml := [<evento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">]
   cXml +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   cXml +=       XmlTag( "tpAmb", ::cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chNFe", cChave )
   cXml +=       XmlTag( "dhEvento", ::DateTimeXml() )
   cXml +=       XmlTag( "tpEvento", "110110" )
   cXml +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia ) ) )
   cXml +=       XmlTag( "verEvento", "1.00" )
   cXml +=       [<detEvento versao="1.00">]
   cXml +=          XmlTag( "descEvento", "Carta de Correcao" )
   cXml +=          XmlTag( "xCorrecao", cTexto )
   cXml +=          [<xCondUso>]
   cXml +=          "A Carta de Correcao e disciplinada pelo paragrafo 1o-A do art. 7o do Convenio S/N, "
   cXml +=          "de 15 de dezembro de 1970 e pode ser utilizada para regularizacao de erro ocorrido na "
   cXml +=          "emissao de documento fiscal, desde que o erro nao esteja relacionado com: "
   cXml +=          "I - as variaveis que determinam o valor do imposto tais como: base de calculo, aliquota, "
   cXml +=          "diferenca de preco, quantidade, valor da operacao ou da prestacao; "
   cXml +=          "II - a correcao de dados cadastrais que implique mudanca do remetente ou do destinatario; "
   cXml +=          "III - a data de emissao ou de saida."
   cXml +=         [</xCondUso>]
   cXml +=       [</detEvento>]
   cXml +=    [</infEvento>]
   cXml += [</evento>]
   ::cXmlRetorno := ::AssinaXml( @cXml )
   IF ::cXmlRetorno == "OK"
      ::NFeEventoEnvia( cChave, cXml )
      ::NfeGeraEventoAutorizado( @cXml, ::cXmlRetorno )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @nSequencia, 1 )

   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )

   cXml := [<evento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   cXml +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   cXml +=       XmlTag( "tpAmb", ::cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chNFe", cChave )
   cXml +=       XmlTag( "dhEvento", ::DateTimeXml() )
   cXml +=       XmlTag( "tpEvento", "110111" )
   cXml +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia ) ) )
   cXml +=       XmlTag( "verEvento", "1.00" )
   cXml +=       [<detEvento versao="1.00">]
   cXml +=          XmlTag( "descEvento", "Cancelamento" )
   cXml +=          XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=          XmlTag( "xJust", xJust )
   cXml +=       [</detEvento>]
   cXml +=    [</infEvento>]
   cXml += [</evento>]
   ::cXmlRetorno := ::AssinaXml( @cXml )
   IF ::cXmlRetorno == "OK"
      ::NFEEventoEnvia( cChave, cXml )
      ::NfeGeraEventoAutorizado( @cXml, ::cXmlRetorno )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoNaoRealizada( cChave, nSequencia, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @nSequencia, 1 )

   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )

   cXml := [<evento versao="1.00" xmlns="http://www.portal.inf.br/nfe" >]
   cXml +=    [<infEvento Id="ID210240] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   cXml +=       XmlTag( "tpAmb", ::cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chNFe", cChave )
   cXml +=       XmlTag( "dhEvento", ::DateTimeXml() )
   cXml +=       XmlTag( "tpEvento", "210240" )
   cXml +=       XmlTag( "nSeqEvento", StrZero( 1, 2 ) )
   cXml +=       XmlTag( "verEvento", "1.00" )
   cXml +=       [<detEvento versao="1.00">]
   cXml +=          XmlTag( "xJust", xJust )
   cXml +=       [</detEvento>]
   cXml +=    [</infEvento>]
   cXml += [</evento>]
   ::cXmlRetorno := ::AssinaXml( @cXml )
   IF ::cXmlRetorno == "OK"
      ::NFEEventoEnvia( cChave, cXml )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoEnvia( cChave, cXml, cCertificado, cAmbiente ) CLASS SefazClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cUf := ::UFSigla( Substr( cChave, 1, 2 ) )

   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento"
   ::cSoapAction  := "nfeRecepcaoEvento"
   ::cWebService  := ::GetWebService( WS_NFE_RECEPCAOEVENTO )
   ::cXmlDados    := [<envEvento versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    +=    XmlTag( "idLote", Substr( cChave, 26, 9 ) ) // usado numero da nota
   ::cXmlDados    +=    cXml
   ::cXmlDados    += [</envEvento>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cVersaoXml  := "3.10"
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2"
   ::cSoapAction := "NfeInutilizacaoNF2"
   ::cWebService := ::GetWebService( WS_NFE_INUTILIZACAO )
   ::cXmlDados   := [<inutNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados   +=    [<infInut Id="ID] + ::UFCodigo( ::cUF ) + Right( cAno, 2 ) + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDados   +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDados   +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDados   +=       XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDados   +=       XmlTag( "ano", cAno )
   ::cXmlDados   +=       XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDados   +=       XmlTag( "mod", cMod )
   ::cXmlDados   +=       XmlTag( "serie", cSerie )
   ::cXmlDados   +=       XmlTag( "nNFIni", cNumIni )
   ::cXmlDados   +=       XmlTag( "nNFFin", cNumFim )
   ::cXmlDados   +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDados   +=    [</infInut>]
   ::cXmlDados   += [</inutNFe>]

   ::cXmlRetorno := ::AssinaXml( @::cXmlDados )
   IF ::cXmlRetorno == "OK"
      ::XmlSoapPost()
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      IF ::cStatus == "102"
         ::cXmlAutorizado := [<ProcInutNFe versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">]
         ::cXmlAutorizado += ::cXmlDados
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno, "retInutNFe", .T. )
         ::cXmlAutorizado += [</ProcInutNFe>]
      ENDIF
   ENDIF
   RETURN ::cXmlRetorno

METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @cIndSinc, ::cIndSinc )
   IF Empty( cLote )
      cLote := "1"
   ENDIF

   ::cVersaoXml   := "3.10"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao"
   ::cSoapAction  := "NfeAutorizacao"
   ::cWebService  := ::GetWebService( WS_NFE_AUTORIZACAO )
   ::cXmlDados    := [<enviNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   // FOR EACH cXmlNota IN aXmlNotas
   ::cXmlDados    += XmlTag( "idLote", cLote )
   ::cXmlDados    += XmlTag( "indSinc", cIndSinc )
   ::cXmlDados    += cXml
   // NEXT
   ::cXmlDados    += [</enviNFe>]
   ::XmlSoapPost()
   IF cIndSinc == INDSINC_RETORNA_RECIBO
      ::cXmlRecibo := ::cXmlRetorno
      ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
      IF ! Empty( ::cRecibo )
         Inkey( ::nTempoEspera )
         ::NfeConsultaRecibo()
         ::cXmlRetorno := ::NfeGeraAutorizado( cXml, ::cXmlProtocolo )
      ENDIF
   ELSE
      ::cXmlRecibo    := ::cXmlRetorno
      ::cRecibo       := XmlNode( ::cXmlRecibo, "nRec" )
      IF ! Empty( ::cRecibo )
         ::cXmlProtocolo := ::cXmlRetorno
         ::cXmlRetorno   := ::NfeGeraAutorizado( cXml, ::cXmlProtocolo )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cVersaoXml    := "3.10"
   ::cServico      := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao"
   ::cSoapAction   := "NfeRetAutorizacao"
   ::cWebService   := ::GetWebService( WS_NFE_RETAUTORIZACAO )
   ::cXmlDados     := [<consReciNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlDados     += [</consReciNFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )

   RETURN ::cXmlRetorno

METHOD NFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cVersaoXml   := "3.10"
   IF ::cUF == "BA"
      ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico"
      ::cSoapAction  := "nfeStatusServicoNF"
   ELSE
      ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
      ::cSoapAction  := "nfeStatusServicoNF2"
   ENDIF
   ::cWebService     := ::GetWebService( WS_NFE_STATUSSERVICO )
   ::cXmlDados       := [<consStatServ versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados       +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados       +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDados       +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados       += [</consStatServ>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protNFe" ), "cStat" ), 3 ) // Pad() garante 3 caracteres
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<Erro text="Não autorizado" />] + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := [<?xml version="1.0"?>]
   ::cXmlAutorizado += [<nfeProc versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protNFe", .T. ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</nfeProc>]

   RETURN ::cXmlAutorizado

METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass // runner

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "xMotivo" ) // runner
   IF ! ::cStatus $ "135,155"
      //::cXmlRetorno := "Erro: Status do protocolo não serve como autorização" // runner
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := [<?xml version="1.00"?>]
   ::cXmlAutorizado += [<procEventoNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEvento versao="1.00">] // runner
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEvento" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEvento>] // runner
   ::cXmlAutorizado += [</procEventoNFe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN ::cXmlAutorizado

METHOD GetWebService( nWsServico ) CLASS SefazClass
   // NFE SVAN: MA,PA,PI
   // NFE SVRS: AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO
   // NFE Autorizadores: AM,BA,CE,GO,MA,MG,MS,MT,PE,PR,RS,SP,SVCAN,SVCRS,AN

   LOCAL cTexto

   IF ::cProjeto == WS_PROJETO_MDFE
      cTexto := UrlWebService( "RS", ::cAmbiente, nWsServico, ::cVersao )
   ELSEIF ::cScan == "SCAN"
      cTexto := UrlWebService( "SCAN", ::cAmbiente, nWsServico, ::cVersao )
   ELSEIF ::cScan == "SVCAN"
      IF ::cProjeto == WS_PROJETO_NFE
         IF ::cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
            cTexto := UrlWebService( "SVCRS", ::cAmbiente, nWsServico, ::cVersao )
         ELSE
            cTexto := UrlWebService( "SVCAN", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ELSEIF ::cProjeto == WS_PROJETO_CTE
         IF ::cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,SC,SE,TO"
            cTexto := UrlWebService( "SVCSP", ::cAmbiente, nWsServico, ::cVersao )
         ELSEIF ::cUF $ "MS,MT,SP," + "AP,PE,RR"
            cTexto := UrlWebService( "SVCRS", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ENDIF
   ELSE
      cTexto := UrlWebService( ::cUf, ::cAmbiente, nWsServico, ::cVersao )
   ENDIF
   IF Empty( cTexto ) // UFs sem Webservice próprio
      IF ::cProjeto == WS_PROJETO_NFE
         IF ::cUf $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO" // Sefaz Virtual RS
            cTexto := UrlWebService( "SVRS", ::cAmbiente, nWsServico, ::cVersao )
         ELSEIF ::cUf $ "MA,PA,PI" // Sefaz Virtual
            cTexto := UrlWebService( "SVAN", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
         IF Empty( cTexto ) // Não tem específico
            cTexto := UrlWebService( "AN", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ELSEIF ::cProjeto == WS_PROJETO_CTE
         IF ::cUF $ "AP,PE,RR"
            cTexto := UrlWebService( "SVSP", ::cAmbiente, nWsServico, ::cVersao )
         ELSEIF ::cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,SC,SE,TO"
            cTexto := UrlWebService( "SVRS", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ENDIF
   ENDIF

   RETURN cTexto

METHOD XmlSoapPost() CLASS SefazClass

   DO CASE
   CASE Empty( ::cWebService )
      ::cXmlRetorno := "Erro SOAP: Não há endereço de webservice"
      RETURN NIL
   CASE Empty( ::cServico )
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
   IF "<soap:Body>" $ ::cXmlRetorno .AND. "</soap:Body>" $ ::cXmlRetorno
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soap:Body" ) // hb_UTF8ToStr()
   ELSEIF "<soapenv:Body>" $ ::cXmlRetorno .AND. "</soapenv:Body>" $ ::cXmlRetorno
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soapenv:Body" ) // hb_UTF8ToStr()
   ELSE
      ::cXmlRetorno := "Erro SOAP: XML retorno não está no padrão " + ::cXmlRetorno
   ENDIF

   RETURN NIL

METHOD XmlSoapEnvelope() CLASS SefazClass

   ::cXmlSoap    := ""
   ::cXmlSoap    += [<?xml version="1.0" encoding="UTF-8"?>] //  encoding="utf-8"?>]
   ::cXmlSoap    += [<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ]
   ::cXmlSoap    +=    [xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">]
   IF ::cSoapAction != "nfeDistDFeInteresse"
      ::cXmlSoap +=    [<soap12:Header>]
      ::cXmlSoap +=       [<] + ::cProjeto + [CabecMsg xmlns="] + ::cServico + [">]
      ::cXmlSoap +=          [<cUF>] + ::UFCodigo( ::cUF ) + [</cUF>]
      ::cXmlSoap +=          [<versaoDados>] + ::cVersaoXml + [</versaoDados>]
      ::cXmlSoap +=       [</] + ::cProjeto + [CabecMsg>]
      ::cXmlSoap +=    [</soap12:Header>]
   ENDIF
   ::cXmlSoap    +=    [<soap12:Body>]
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [<nfeDistDFeInteresse xmlns="] + ::cServico + [">]
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg>]
   ELSE
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg xmlns="] + ::cServico + [">]
   ENDIF
   ::cXmlSoap    += ::cXmlDados
   ::cXmlSoap    +=    [</] + ::cProjeto + [DadosMsg>]
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [</nfeDistDFeInteresse>]
   ENDIF
   ::cXmlSoap    +=    [</soap12:Body>]
   ::cXmlSoap    += [</soap12:Envelope>]

   RETURN ::cXmlSoap

METHOD MicrosoftXmlSoapPost() CLASS SefazClass

   LOCAL oServer, nCont, cRetorno
   LOCAL cSoapAction

   //IF ::cSoapAction == "nfeDistDFeInteresse" .OR. ::cSoapAction == "nfeConsultaNFDest"
      //cSoapAction := ::cServico + "/" + ::cSoapAction
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
      ::cXmlRetorno := "Erro: Na conexão com webservice " + ::cWebService
      oServer:Open( "POST", ::cWebService, .F. )
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
   END SEQUENCE
   // IF ! "<cStat>" $ cRetorno
   //   cRetorno := "<cStat>ERRO NO RETORNO</cStat>" + cRetorno
   // ENDIF

   RETURN NIL

STATIC FUNCTION UFCodigo( cSigla )

   LOCAL cUFs, cCodigo, nPosicao

   IF Val( cSigla ) > 0
      RETURN cSigla
   ENDIF
   cUFs = "AC,12,AL,27,AM,13,AP,16,BA,29,CE,23,DF,53,ES,32,GO,52,MG,31,MS,50,MT,51,MA,21,PA,15,PB,25,PE,26,PI,22,PR,41,RJ,33,RO,11,RN,24,RR,14,RS,43,SC,42,SE,28,SP,35,TO,17,"
   nPosicao = At( cSigla, cUfs )
   IF nPosicao < 1
      cCodigo = "99"
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
   cUFs = "AC,12,AL,27,AM,13,AP,16,BA,29,CE,23,DF,53,ES,32,GO,52,MG,31,MS,50,MT,51,MA,21,PA,15,PB,25,PE,26,PI,22,PR,41,RJ,33,RO,11,RN,24,RR,14,RS,43,SC,42,SE,28,SP,35,TO,17,"
   nPosicao = At( cCodigo, cUfs )
   IF nPosicao < 1
      cSigla = "XX"
   ELSE
      cSigla:= Substr( cUFs, nPosicao - 3, 2 )
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

STATIC FUNCTION CTeAddCancelamento( cXmlAssinado, cXmlRetorno )

   LOCAL cDigVal, cXmlAutorizado

   cDigVal := XmlNode( cXmlAssinado , "Signature" )
   cDigVal := XmlNode( cDigVal , "SignedInfo" )
   cDigVal := XmlNode( cDigVal , "Reference" )
   cDigVal := XmlNode( cDigVal , "DigestValue" )

   cXmlAutorizado := [<?xml version="1.0"?>]
   cXmlAutorizado += [<cteProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/cte">]
   cXmlAutorizado +=    cXmlAssinado
   cXmlAutorizado +=    [<protCTe versao="2.00">]
   cXmlAutorizado +=       [<infProt>]
   cXmlAutorizado +=          XmlTag( "tpAmb" , XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEventoCTe" ) , "infEvento" ), "tpAmb" ) ) // runner
   cXmlAutorizado +=          XmlTag( "verAplic", XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEventoCTe" ) , "infEvento" ), "verAplic" ) )
   cXmlAutorizado +=          XmlTag( "chCTe" , XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEventoCTe" ) , "infEvento" ), "chCTe" ) ) // runner
   cXmlAutorizado +=          XmlTag( "dhRecbto" , XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEventoCTe" ) , "infEvento" ), "dhRegEvento" ) ) // runner
   cXmlAutorizado +=          XmlTag( "nProt" , XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEventoCTe" ) , "infEvento" ), "nProt" ) ) // runner
   cXmlAutorizado +=          XmlTag( "digVal", cDigVal)
   cXmlAutorizado +=          XmlTag( "cStat", XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEventoCTe" ) , "infEvento" ), "cStat" ) )
   cXmlAutorizado +=          XmlTag( "xMotivo", 'Cancelamento do CTe homologado')
   cXmlAutorizado +=       [</infProt>]
   cXmlAutorizado +=    [</protNFe>]
   cXmlAutorizado += [</cteProc>]

   RETURN cXmlAutorizado

STATIC FUNCTION NFeAddCancelamento( cXmlAssinado, cXmlRetorno )

   LOCAL cDigVal, cXmlAutorizado

   cDigVal := XmlNode( cXmlAssinado , "Signature" )
   cDigVal := XmlNode( cDigVal , "SignedInfo" )
   cDigVal := XmlNode( cDigVal , "Reference" )
   cDigVal := XmlNode( cDigVal , "DigestValue" )

   cXmlAutorizado := [<?xml version="1.0"?>]
   cXmlAutorizado += [<nfeProc versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">]
   cXmlAutorizado +=    cXmlAssinado
   cXmlAutorizado +=    [<protNFe versao="3.10">]
   cXmlAutorizado +=       [<infProt>]
   cXmlAutorizado +=          XmlTag( "tpAmb" , XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEvento" ) , "infEvento" ), "tpAmb" ) ) // runner
   cXmlAutorizado +=          XmlTag( "verAplic", 'SP_NFE_PL_008i2')
   cXmlAutorizado +=          XmlTag( "chNFe" , XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEvento" ) , "infEvento" ), "chNFe" ) ) // runner
   cXmlAutorizado +=          XmlTag( "dhRecbto" , XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEvento" ) , "infEvento" ), "dhRegEvento" ) ) // runner
   cXmlAutorizado +=          XmlTag( "nProt" , XmlNode( XmlNode( XmlNode( cXmlRetorno , "retEvento" ) , "infEvento" ), "nProt" ) ) // runner
   cXmlAutorizado +=          XmlTag( "digVal", cDigVal)
   cXmlAutorizado +=          XmlTag( "cStat", '101')
   cXmlAutorizado +=          XmlTag( "xMotivo", 'Cancelamento da NFe homologado')
   cXmlAutorizado +=       [</infProt>]
   cXmlAutorizado +=    [</protNFe>]
   cXmlAutorizado += [</nfeProc>]

   RETURN cXmlAutorizado

STATIC FUNCTION UrlWebService( cUF, cAmbiente, nWsServico, cVersao )

   LOCAL cUrlWs := ""
   hb_Default( @cVersao, "3.10" )

   DO CASE
   CASE cUF == "AC"
      cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )

   CASE cUF == "AL"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "AM"
      IF cAmbiente == WS_AMBIENTE_PRODUCAO
         DO CASE
         CASE nWsServico == WS_NFE_AUTORIZACAO;          cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao"
         CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeCancelamento2"
         CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := UrlWebService( "AM", WS_AMBIENTE_HOMOLOGACAO, nWsServico )
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

   CASE cUF == "AP"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "BA"
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

   CASE cUF == "CE"
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
         CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeCancelamento2"
         CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2"
         CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2"
         CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2"
         CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2"
         CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento"
         CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2"
         CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2"
         ENDCASE
      ENDIF

   CASE cUF == "DF"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "ES"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;       cUrlWs := "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx"
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "GO"
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

   CASE cUF == "MA"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO ;       cUrlWs := "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl"
      OTHERWISE
         cUrlWs := UrlWebService( "SVAN", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "MG"
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

   CASE cUF == "MS"
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

   CASE cUF == "MT"
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

   CASE cUF == "PA"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVAN", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "PB"
      cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )

   CASE cUF == "PE"
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
         CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := UrlWebService( "PE", WS_AMBIENTE_PRODUCAO, nWsServico )
         CASE nWsServico == WS_NFE_CANCELAMENTO ;        cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento2"
         CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2"
         CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2"
         CASE nWsServico == WS_NFE_RECEPCAO ;            cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2"
         CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento"
         CASE nWsServico == WS_NFE_RETRECEPCAO ;         cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2"
         CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2"
         ENDCASE
      ENDIF

   CASE cUF == "PI"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVAN", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "PR"
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

   CASE cUF == "RJ"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "RN" .AND. cAmbiente == WS_AMBIENTE_PRODUCAO
      //DO CASE
      //CASE nWsServico == WS_NFE_CONSULTACADASTRO ;     cUrlWs := "https://webservice.set.rn.gov.br/projetonfeprod/set_nfe/servicos/CadConsultaCadastroWS.asmx"
      //OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      //ENDCASE

   CASE cUF == "RN" .AND. cAmbiente == WS_AMBIENTE_HOMOLOGACAO
      //DO CASE
      //CASE nWsServico == WS_NFE_CONSULTACADASTRO ;     cUrlWs := "https://webservice.set.rn.gov.br/projetonfehomolog/set_nfe/servicos/CadConsultaCadastroWS.asmx"
      //OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      //ENDCASE

   CASE cUF == "RO"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "RR"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "RS"
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
         CASE nWsServico == WS_MDFE_CONSNAOENC ;         cUrlWs := "https://mdfe.svrs.rs.gov.br/ws/mdfeconsnaoenc/mdfeconsnaoenc.asmx"
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
         CASE nWsServico == WS_MDFE_CONSULTA ;           cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx"
         CASE nWsServico == WS_MDFE_CONSNAOENC ;         cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/mdfeconsnaoenc/mdfeconsnaoenc.asmx"
         CASE nWsServico == WS_MDFE_RECEPCAO ;           cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx"
         CASE nWsServico == WS_MDFE_RECEPCAOEVENTO ;     cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx"
         CASE nWsServico == WS_MDFE_RETRECEPCAO ;        cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx"
         CASE nWsServico == WS_MDFE_STATUSSERVICO ;      cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx"
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

   CASE cUF == "SC"
      cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )

   CASE cUF == "SE"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "SP"
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
         CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/recepcaoEvento.asmx"
         CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx"
         ENDCASE
      ENDIF

   CASE cUF == "TO"
      DO CASE
      CASE nWsServico == WS_NFE_CONSULTACADASTRO
      OTHERWISE
         cUrlWs := UrlWebService( "SVRS", cAmbiente, nWsServico, cVersao )
      ENDCASE

   CASE cUF == "SVAN"
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

   CASE cUF == "SVRS"
      IF cAmbiente == WS_AMBIENTE_PRODUCAO
         DO CASE
         CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://cte.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx"
         CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://cte.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx"
         CASE nWsServico == WS_CTE_INUTILIZACAO ;        cUrlWs := "https://cte.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx"
         CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx"
         CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx"
         CASE nWsServico == WS_CTE_RECEPCAOEVENTO ;      cUrlWs := "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx"
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
         CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
         CASE nWsServico == WS_NFE_CONSULTACADASTRO ;    cUrlWs := "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
         CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
         CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
         CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
         CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
         CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
         ENDCASE
      ENDIF

   CASE cUF == "SVSP"
      IF cAmbiente == WS_AMBIENTE_PRODUCAO
         DO CASE
         CASE nWsServico == WS_CTE_RECEPCAO ;            cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx"
         CASE nWsServico == WS_CTE_RETRECEPCAO ;         cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteRetRecepcao.asmx"
         CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteConsulta.asmx"
         CASE nWsServico == WS_CTE_STATUSSERVICO ;       cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteStatusServico.asmx"
         ENDCASE
      ENDIF

   CASE cUF == "SCAN"
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

   CASE cUF == "SVCAN"
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

   CASE cUF == "SVCRS"
      IF cAmbiente == WS_AMBIENTE_PRODUCAO
         DO CASE
         CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
         CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
         CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
         CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
         CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
         CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
         ENDCASE
      ELSE
         DO CASE
         CASE nWsServico == WS_NFE_AUTORIZACAO ;         cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
         CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
         CASE nWsServico == WS_NFE_INUTILIZACAO ;        cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
         CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
         CASE nWsServico == WS_NFE_RETAUTORIZACAO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
         CASE nWsServico == WS_NFE_STATUSSERVICO ;       cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
         ENDCASE
      ENDIF

   CASE cUF == "AN"
      IF cAmbiente == WS_AMBIENTE_PRODUCAO
         DO CASE
         CASE nWsServico == WS_NFE_CONSULTADEST ;        cUrlWs := "https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx"
         CASE nWsServico == WS_NFE_DISTRIBUICAODFE;      cUrlWs := "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx"
         CASE nWsServico == WS_NFE_DOWNLOADNF ;          cUrlWs := "https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx"
         CASE nWsServico == WS_NFE_RECEPCAOEVENTO ;      cUrlWs := "https://www.nfe.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
         ENDCASE
      ENDIF

   ENDCASE

   RETURN cUrlWs

STATIC FUNCTION ValidaXml( cXml, cFileXsd )

   LOCAL oXmlDomDoc, oXmlSchema, oXmlErro, cRetorno := "ERRO"

   hb_Default( @cFileXsd, "" )

   IF " <" $ cXml .OR. "> " $ cXml
      cRetorno := "Espaços inválidos no XML entre as tags"
      RETURN cRetorno
   ENDIF

   IF Empty( cFileXsd )
      cRetorno := "OK"
      BREAK
   ENDIF
   IF ! File( cFileXSD )
      cRetorno := "Erro não encontrado arquivo " + cFileXSD
      BREAK
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
         cRetorno := "Erro: " + AllTrim( Transform( oXmlErro:ErrorCode, "" ) ) + " " + AllTrim( Transform( oXmlErro:Reason, "" ) )
         BREAK
      ENDIF
      cRetorno := "OK"

   END SEQUENCE

   RETURN cRetorno


#ifdef LIBCURL // pra nao compilar, apenas anotado
//
// Pode ser usada a LibCurl pra comunicação

METHOD CurlSoapPost() CLASS SefazClass

   LOCAL aHeader := Array(3)

   aHeader[ 1 ] := [Content-Type: application/soap+xml;charset=utf-8;action="] + ::cServico + ["]
   aHeader[ 2 ] := [SOAPAction: "] + ::cSoapAction + ["]
   aHeader[ 3 ] := [Content-length: ] + AllTrim( Str( Len( ::cXml ) ) )
   curl_global_init()
   oCurl = curl_easy_init()
   curl_easy_setopt( oCurl, HB_CURLOPT_URL, ::cWebService )
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
   IF retHTTP = 200 // OK
      curl_easy_setopt( ocurl, HB_CURLOPT_DL_BUFF_GET, @::cXmlRetorno )
      cXMLResp := Substr( cXMLResp, AT( '<?xml', ::cXmlRetorno ) )
   ENDIF
   curl_easy_cleanup( oCurl )
   curl_global_cleanup()

   RETURN NIL
#endif

