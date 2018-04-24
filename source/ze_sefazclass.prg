/*
ZE_SEFAZCLASS - Rotinas pra comunicação com SEFAZ
José Quintas

Nota: CTE 2.00 vale até 10/2017, CTE 2.00 até 12/2017, NFE 3.10 até 04/2018

2017.11.27 Aceita arquivo PFX pra assinatura somente
2018.03.13 SoapList de CTE e MDFE nos métodos
*/

#include "hbclass.ch"
#include "sefazclass.ch"
#include "hb2xhb.ch"

#ifdef __XHARBOUR__
   #define ALL_PARAMETERS P1, P2, P3, P4, P5, P6, P7, P8, P9, P10
#else
   #define ALL_PARAMETERS ...
#endif

CREATE CLASS SefazClass

   /* configuração */
   VAR    cProjeto        INIT NIL
   VAR    cAmbiente       INIT WS_AMBIENTE_PRODUCAO
   VAR    cVersao         INIT NIL
   VAR    cScan           INIT "N"                     // Indicar se for SCAN/SVAN, ainda não testado
   VAR    cUF             INIT "SP"                    // Modificada conforme método
   VAR    cCertificado    INIT ""                      // Nome do certificado
   VAR    ValidFromDate   INIT ""                      // Validade do certificado
   VAR    ValidToDate     INIT ""                      // Validade do certificado
   VAR    cIndSinc        INIT WS_RETORNA_RECIBO       // Poucas UFs opção de protocolo
   VAR    nTempoEspera    INIT 7                       // intervalo entre envia lote e consulta recibo
   VAR    cUFTimeZone     INIT "SP"                    // Para DateTimeXml() Obrigatório definir UF default
   VAR    cIdToken        INIT ""                      // Para NFCe obrigatorio identificador do CSC Código de Segurança do Contribuinte
   VAR    cCSC            INIT ""                      // Para NFCe obrigatorio CSC Código de Segurança do Contribuinte
   VAR    cPassword       INIT ""                      // Senha de arquivo PFX
   /* XMLs de cada etapa */
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
   VAR    cSoapVersion    INIT ""                      // webservice versão XML e comunicação
   VAR    cSoapService    INIT ""                      // webservice Serviço
   VAR    cSoapAction     INIT ""                      // webservice Action
   VAR    cSoapURL        INIT ""                      // webservice Endereço
   VAR    cXmlNameSpace   INIT "xmlns="
   VAR    cNFCE           INIT "N"                     // Porque NFCE tem endereços diferentes
   VAR    nWsServico      INIT 0
   VAR    aSoapUrlList    INIT {}
   VAR    aSoapActionList INIT {}

   METHOD BPeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD BPeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD CTeEventoSoapList()
   METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente )
   METHOD CTeEventoDesacordo( cChave, nSequencia, cObs, cCertificado, cAmbiente )
   METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD CTeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD MDFeConsNaoEnc( CUF, cCNPJ , cCertificado, cAmbiente )
   METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD MDFeEventoSoapList()
   METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD MDFeEventoEncerramento( cChave, nSequencia, nProt, cUFFim, cMunCarrega, cCertificado, cAmbiente )
   METHOD MDFeEventoInclusaoCondutor( cChave, nSequencia, cNome, cCpf, cCertificado, cAmbiente )
   METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente )

   METHOD NFeConsultaDest( cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente )
   METHOD NFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD NFeEventoSoapList()
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
   METHOD SetSoapURL()
   METHOD XmlSoapEnvelope()
   METHOD XmlSoapPost()
   METHOD MicrosoftXmlSoapPost()

   /* Apenas redirecionamento */
   METHOD AssinaXml()                                 INLINE ::cXmlRetorno := CapicomAssinaXml( @::cXmlDocumento, ::cCertificado,,::cPassword )
   METHOD TipoXml( cXml )                             INLINE TipoXml( cXml )
   METHOD UFCodigo( cSigla )                          INLINE UFCodigo( cSigla )
   METHOD UFSigla( cCodigo )                          INLINE UFSigla( cCodigo )
   METHOD DateTimeXml( dDate, cTime, lUTC )           INLINE DateTimeXml( dDate, cTime, iif( ::cUFTimeZone == NIL, ::cUF, ::cUFTimeZone ), lUTC )
   METHOD ValidaXml( cXml, cFileXsd )                 INLINE ::cXmlRetorno := DomDocValidaXml( cXml, cFileXsd )
   METHOD Setup( cUF, cCertificado, cAmbiente, nWsServico )

   ENDCLASS

METHOD BPeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "1.00" )
   hb_Default( @::cProjeto, WS_PROJETO_BPE )
   ::cSoapAction  := "BpeConsulta"
   ::cSoapService := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP"
   ::aSoapUrlList := { ;
         { "MS",   "1.00", WS_AMBIENTE_PRODUCAO, "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO, "https://bpe.svrs.rs.gov.br/ms/bpeConsulta.asmx" }, ;
         ;
         { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://homologacao.bpe.ms.gov.br/ws/BPeConsulta" } }
   ::Setup( cChave, cCertificado, cAmbiente, WS_BPE_CONSULTAPROTOCOLO )
   ::cXmlEnvio := [<consSitBPe> versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=   XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=   XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio +=   XmlTag( "chBPe", cChave )
   ::cXmlEnvio += [</conssitBPe>]
   IF DfeModFis( cChave ) != "63"
      ::cXmlRetorno := [<erro text="*ERRO* BpeConsultaProtocolo() Chave não se refere a BPE" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

//      ::aSoapActionList := { ;
//      { "**", WS_BPE_RECEPCAO,          "1.00", "BpeRecepcao",          "http://www.portalfiscal.inf.br/bpe/wsdl/BPeRecepcao/bpeRecepcao" } }
//      ::aSoapActionList := { ;
//      { "**", WS_BPE_RECEPCAOEVENTO,    "1.00", "BpeRecepcaoEvento",    "http://www.portalfiscal.inf.br/bpe/wsdl/bpeRecepcaoEvento" } }

METHOD BPeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "1.00" )
   hb_Default( @::cProjeto, WS_PROJETO_BPE )
   ::cSoapAction  := "BpeStatusServicoBP"
   ::cSoapService := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico"
   ::aSoapUrlList := { ;
         { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.fazenda.ms.gov.br/ws/BPeStatusServico" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.svrs.rs.gov.br/ms/bpeStatusServico/bpeStatusServico.asmx" }, ;
         ;
         { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://homologacao.bpe.ms.gov.br/ws/BPeStatusServico" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_BPE_STATUSSERVICO )

   ::cXmlEnvio := [<consStatServBPe versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServBPe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   ::cSoapAction  := "cteConsultaCT"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta"
   ::aSoapUrlList := { ;
         { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteConsulta" }, ;
         { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteConsulta" }, ;
         { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteConsulta" }, ;
         { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
         { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteConsulta?wsdl" }, ;
         { "SVSP", "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteConsulta.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" }, ;
         ;
         { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" } }
   ::Setup( cChave, cCertificado, cAmbiente, WS_CTE_CONSULTAPROTOCOLO )

   ::cXmlEnvio    := [<consSitCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chCTe", cChave )
   ::cXmlEnvio    += [</consSitCTe>]
   IF ! DfeModFis( cChave ) $ "57,67"
      ::cXmlRetorno := [<erro text="*ERRO* CteConsultaProtocolo() Chave não se refere a CTE" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   ::cSoapAction  := "cteRetRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao"
   ::aSoapUrlList := { ;
      { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteRetRecepcao" }, ;
      { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteRetRecepcao" }, ;
      { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteRetRecepcao" }, ;
      { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteRetRecepcao?wsdl" }, ;
      { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
      { "SVSP", "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteRetRecepcao.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" }, ;
      ;
      { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" } }

   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_RETRECEPCAO )

   ::cXmlEnvio     := [<consReciCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec",  ::cRecibo )
   ::cXmlEnvio     += [</consReciCTe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno                                           // ? hb_Utf8ToStr()
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" ) // ? hb_Utf8ToStr()

   RETURN ::cXmlRetorno // ? hb_Utf8ToStr()

METHOD CTeEventoSoapList() CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   ::cSoapAction  := "cteRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento"
   ::aSoapUrlList := { ;
      { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/RecepcaoEvento" }, ;
      { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteRecepcaoEvento" }, ;
      { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento?wsdl" }, ;
      { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento?wsdl" }, ;
      { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" }, ;
      ;
      { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" } }

      RETURN NIL

METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @nSequencia, 1 )

   ::CTeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_CTE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
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

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @nSequencia, 1 )

   ::CTeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_CTE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
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

METHOD CTeEventoDesacordo( cChave, nSequencia, cObs, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @::cVersao, "3.00" )
   hb_Default( @nSequencia, 1 )

   ::CTeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_CTE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "610110" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + ::cVersao + [">]
   ::cXmlDocumento +=          [<evPrestDesacordo>]
   ::cXmlDocumento +=             XmlTag( "descEvento", "Prestacao do Servico em Desacordo" )
   ::cXmlDocumento +=             XmlTag( "indDesacordoOper", "" )
   ::cXmlDocumento +=             XmlTag( "xOBS", cObs )
   ::cXmlDocumento +=          [</evPrestDesacordo>]
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

   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @::cVersao, "3.00" )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protCTe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<erro text="*ERRO* CTEGeraAutorizado() Não autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<cteProc versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protCTe", .T. ) // ?hb_Utf8ToStr()
   ::cXmlAutorizado += [</cteProc>]

   RETURN NIL

METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @::cVersao, "3.00" )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "xMotivo" ) // runner
   IF ! ::cStatus $ "135,155"
      ::cXmlRetorno := [<erro text="*ERRO* CteGeraEventoAutorizado() Não autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoCTe versao="] + ::cVersao + [">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEventoCTe" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEventoCTe>]
   ::cXmlAutorizado += [</procEventoCTe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN NIL

METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @::cVersao, "3.00" )
   ::cSoapAction  := "cteInutilizacaoCT"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao"
   ::aSoapUrlList := { ;
      { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteInutilizacao" }, ;
      { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteInutilizacao" }, ;
      { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteInutilizacao" }, ;
      { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteInutilizacao?wsdl" }, ;
      { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" }, ;
      ;
      { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_INUTILIZACAO )

   IF Len( cAno ) != 2
      cAno := Right( cAno, 2 )
   ENDIF
   ::cXmlDocumento := [<inutCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infInut Id="ID] + ::UFCodigo( ::cUF ) + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDocumento +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDocumento +=       XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDocumento +=       XmlTag( "ano", cAno )
   ::cXmlDocumento +=       XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDocumento +=       XmlTag( "mod", cMod )
   ::cXmlDocumento +=       XmlTag( "serie", cSerie )
   ::cXmlDocumento +=       XmlTag( "nCTIni", Alltrim(Str(Val(cNumIni))) )
   ::cXmlDocumento +=       XmlTag( "nCTFin", Alltrim(Str(Val(cNumFim))) )
   ::cXmlDocumento +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDocumento +=    [</infInut>]
   ::cXmlDocumento += [</inutCTe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      IF ::cStatus == "102"
         ::cXmlAutorizado := XML_UTF8
         ::cXmlAutorizado += [<ProcInutCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
         ::cXmlAutorizado += ::cXmlDocumento
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno , "retInutCTe", .T. )
         ::cXmlAutorizado += [</ProcInutCTe>]
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @::cVersao, "3.00" )
   IF Empty( cLote )
      cLote := "1"
   ENDIF
   ::cSoapAction  := "cteRecepcaoLote"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao"
   ::aSoapUrlList := { ;
      { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteRecepcao" }, ;
      { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteRecepcao" }, ;
      { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteRecepcao" }, ;
      { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteRecepcao?wsdl" }, ;
      { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
      { "SVSP", "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" }, ;
      ;
      { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_RECEPCAO )

   IF cXml != NIL
      ::cXmlDocumento := cXml
   ENDIF
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlEnvio    := [<enviCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
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

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   ::cSoapAction  := "cteStatusServicoCT"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico"
   ::aSoapUrlList := { ;
      { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteStatusServico" }, ;
      { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteStatusServico" }, ;
      { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteStatusServico" }, ;
      { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteStatusServico?wsdl" }, ;
      { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
      { "SVSP", "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteStatusServico.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" }, ;
      ;
      { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
      { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_STATUSSERVICO )

   ::cXmlEnvio    := [<consStatServCte versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServCte>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD MDFeConsNaoEnc( cUF, cCNPJ , cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   ::cSoapAction  := "mdfeConsNaoEnc"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsNaoEnc"
   ::aSoapUrlList := { ;
         { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/mdfeConsNaoEnc/mdfeConsNaoenc.asmx" }, ;
         { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsNaoEnc/MDFeConsNaoEnc.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_CONSNAOENC )

   ::cXmlEnvio := [<consMDFeNaoEnc versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "CONSULTAR NÃO ENCERRADOS" )
   ::cXmlEnvio +=    XmlTag( "CNPJ", cCNPJ )
   ::cXmlEnvio += [</consMDFeNaoEnc>]
   ::XmlSoapPost()
   ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "xMotivo" )

   RETURN ::cXmlRetorno

METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   ::cSoapAction  := "mdfeConsultaMDF"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta"
   ::aSoapUrlList := { ;
      { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" }, ;
      { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" } }
   ::Setup( cChave, cCertificado, cAmbiente, WS_MDFE_CONSULTA )

   ::cXmlEnvio := [<consSitMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio +=    XmlTag( "chMDFe", cChave )
   ::cXmlEnvio += [</consSitMDFe>]
   IF DfeModFis( cChave ) != "58"
      ::cXmlRetorno := [<erro text="*ERRO* MDFEConsultaProtocolo() Chave não se refere a MDFE" />]
   ELSE
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
   ENDIF
   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::cSoapAction  := "mdfeRetRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao"
   ::aSoapUrlList := { ;
      { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" }, ;
      { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_RETRECEPCAO )

   ::cXmlEnvio := [<consReciMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio += [</consReciMDFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )

   RETURN ::cXmlRetorno

   // 2016.01.31.2200 Iniciado apenas
METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )

   ::cSoapAction  := "mdfeDistDFeInteresse"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/MDFeDistribuicaoDFe"
   ::aSoapUrlList := { ;
      { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/WS/MDFeDistribuicaoDFe/MDFeDistribuicaoDFe.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_DISTRIBUICAODFE )

   ::cXmlEnvio    := [<distDFeInt versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
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
   // UltNSU = ultimo NSU pesquisado
   // maxUSU = número máximo existente
   // docZIP = Documento em formato ZIP
   // NSU    = NSU do documento fiscal
   // schema = schemma de validação do XML anexado ex. procMDFe_v1.00.xsd, procEventoMDFe_V1.00.xsd

   RETURN NIL

METHOD MDFeEventoSoapList() CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   ::cSoapAction  := "mdfeRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento"
   ::aSoapUrlList := { ;
      { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" }, ;
      { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" } }

   RETURN NIL

METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   hb_Default( @nSequencia, 1 )

   ::MDFeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_MDFE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<eventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110111" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + ::cVersao + [">]
   ::cXmlDocumento +=            [<evCancMDFe>]
   ::cXmlDocumento +=                XmlTag( "descEvento", "Cancelamento" )
   ::cXmlDocumento +=                XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   ::cXmlDocumento +=                XmlTag( "xJust", xJust )
   ::cXmlDocumento +=            [</evCancMDFe>]
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

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   hb_Default( @nSequencia, 1 )

   ::MDFeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_MDFE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<eventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110112] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110112" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + ::cVersao + [">]
   ::cXmlDocumento +=            [<evEncMDFe>]
   ::cXmlDocumento +=                XmlTag( "descEvento", "Encerramento" )
   ::cXmlDocumento +=                  XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   ::cXmlDocumento +=                  XmlTag( "dtEnc", DateXml( Date() ) )
   ::cXmlDocumento +=                  XmlTag( "cUF", ::UFCodigo( cUFFim ) )
   ::cXmlDocumento +=                  XmlTag( "cMun", cMunCarrega )
   ::cXmlDocumento +=            [</evEncMDFe>]
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

METHOD MDFeEventoInclusaoCondutor( cChave, nSequencia, cNome, cCpf, cCertificado, cAmbiente )

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   hb_Default( @nSequencia, 1 )

   ::MDFeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_MDFE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<eventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110112] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110114" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + ::cVersao + [">]
   ::cXmlDocumento +=            [<evIncCondutorMDFe>]
   ::cXmlDocumento +=                XmlTag( "descEvento", "Inclusao Condutor" )
   ::cXmlDocumento +=               [<Condutor>]
   ::cXmlDocumento +=                  XmlTag( "xNome", cNome )
   ::cXmlDocumento +=                  XmlTag( "CPF", cCPF)
   ::cXmlDocumento +=               [</Condutor>]
   ::cXmlDocumento +=            [</evIncCondutorMDFe>]
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

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protMDFe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<erro text="*ERRO* MDFEGeraAutorizado() Não autorizado" />] + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<mdfeProc versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlAUtorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protMDFe", .T. )
   ::cXmlAutorizado += [</mdfeProc>]

   RETURN NIL

METHOD MDFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEventoMDFe" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEventoMDFe" ), "xMotivo" ) // hb_utf8tostr()
   IF ! ::cStatus $ "135,136"
      ::cXmlRetorno := [<erro Text="*ERRO* MDFeGeraEventoAutorizado() Status inválido" />] + ::cXmlRetorno
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoMDFe versao="] + ::cVersao + [">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEventoMDFe" ) // hb_Utf8ToStr(
   ::cXmlAutorizado += [</retEventoMDFe>]
   ::cXmlAutorizado += [</procEventoMDFe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_Utf8ToStr

   RETURN NIL

METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   ::cSoapAction  := "MDFeRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao"
   ::aSoapUrlList := { ;
      { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" }, ;
      { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_RECEPCAO )

   IF cXml != NIL
      ::cXmlDocumento := cXml
   ENDIF
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlEnvio  := [<enviMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio  +=    XmlTag( "idLote", cLote )
   ::cXmlEnvio  +=    ::cXmlDocumento
   ::cXmlEnvio  += [</enviMDFe>]
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

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   ::cSoapAction  := "MDFeStatusServico"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico/mdfeStatusServicoMDF"
   ::aSoapUrlList := { ;
      { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" }, ;
      ;
      { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_STATUSSERVICO )

   ::cXmlEnvio := [<consStatServMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServMDFe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   IF ::cVersao == "3.10"
   ::aSoapActionList := { ;
      { "**", "2.00", "CadConsultaCadastro2", "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2" } }
   ELSE
   ::aSoapActionList := { ;
      { "**", "4.00", "CadConsultaCadastro4", "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro" } }
   ENDIF
   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_CONSULTACADASTRO )

   ::cSoapVersion := "2.00"
   ::cXmlEnvio    := [<ConsCad versao="2.00" ] + WS_XMLNS_NFE + [>]
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

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cIndNFe, "0" )
   hb_Default( @cIndEmi, "0" )

   ::aSoapActionList := { ;
      { "**", "3.10", "nfeConsultaNFDest", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_CONSULTADEST )

   ::cXmlEnvio    := [<consNFeDest versao="] + ::cVersao + [">]
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

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   IF ::cVersao == "3.10"
      ::aSoapActionList := { ;
         { "BA", "3.10", "nfeConsultaNF", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta" }, ;
         { "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO", ;
                 "3.10", "nfeConsultaNF2",       "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2" }, ;
         { "**", "3.10", "NfeConsulta2",         "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2" } }
   ELSE
   ::aSoapActionList := { ;
      { "**", "4.00", "NfeConsulta4",         "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta" } }
   ENDIF
   ::Setup( cChave, cCertificado, cAmbiente, WS_NFE_CONSULTAPROTOCOLO )

   ::cXmlEnvio    := [<consSitNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chNFe", cChave )
   ::cXmlEnvio    += [</consSitNFe>]
   IF ! DfeModFis( cChave ) $ "55,65"
      ::cXmlRetorno := [<erro text="*ERRO* NfeConsultaProtocolo() Chave não se refere a NFE" />]
   ELSE
      ::XmlSoapPost()
   ENDIF
   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

   /* 2015.07.31.1400 Iniciado apenas */

METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )

   ::aSoapActionList := { ;
      { "**", "???",  "nfeDistDFeInteresse", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe" } }
   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_DISTRIBUICAODFE )

   ::cXmlEnvio    := [<distDFeInt versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
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

METHOD NFeEventoSoapList() CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   IF ::cVersao == "3.10"
      ::aSoapActionList := { ;
         { "**", "3.10", "nfeRecepcaoEvento",  "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento" } }
   ELSE
      ::aSoapActionList := { ;
         { "**", "4.00", "NfeRecepcaoEvento4", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcaoEvento" } }
   ENDIF

   RETURN NIL

METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   hb_Default( @nSequencia, 1 )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::NFeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_NFE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<evento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110110" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", WS_VERSAO_NFEEVENTO )
   ::cXmlDocumento +=       [<detEvento versao="] + WS_VERSAO_NFEEVENTO + [">]
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
      ::cXmlEnvio := [<envEvento versao="] + WS_VERSAO_NFEEVENTO + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NfeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   hb_Default( @nSequencia, 1 )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::NFeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_NFE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<evento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110111" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", WS_VERSAO_NFEEVENTO )
   ::cXmlDocumento +=       [<detEvento versao="] + WS_VERSAO_NFEEVENTO + [">]
   ::cXmlDocumento +=          XmlTag( "descEvento", "Cancelamento" )
   ::cXmlDocumento +=          XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   ::cXmlDocumento +=          XmlTag( "xJust", xJust )
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoManifestacao( cChave, nSequencia, xJust, cCodigoEvento, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cDescEvento

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   hb_Default( @nSequencia, 1 )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::NFeEventoSoapList()
   ::Setup( cChave, cCertificado, cAmbiente, WS_NFE_RECEPCAOEVENTO )

   DO CASE
   CASE cCodigoEvento == "210200" ; cDescEvento := "Confirmacao da Operacao"
   CASE cCodigoEvento == "210210" ; cDescEvento := "Ciencia da Operacao"
   CASE cCodigoEvento == "210220" ; cDescEvento := "Desconhecimento da Operacao"
   CASE cCodigoEvento == "210240" ; cDescEvento := "Operacao Nao Realizada"
   ENDCASE

   ::cXmlDocumento := [<evento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cCodigoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cCodigoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", StrZero( 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", WS_VERSAO_NFEEVENTO )
   ::cXmlDocumento +=       [<detEvento versao="] + WS_VERSAO_NFEEVENTO + [">]
   ::cXmlDocumento +=          XmlTag( "descEvento", cDescEvento )
   IF cCodigoEvento == "210240"
      ::cXmlDocumento +=          XmlTag( "xJust", xJust )
   ENDIF
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   IF ::cVersao == "3.10"
      ::aSoapActionList := { ;
         { "**", "3.10", "NfeInutilizacaoNF2", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2" } }
   ELSE
      ::aSoapActionList := { ;
         { "**", "4.00", "Nfeinutilizacao4",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao" } }
   ENDIF
   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_INUTILIZACAO )

   ::cXmlDocumento := [<inutNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infInut Id="ID] + ::UFCodigo( ::cUF ) + Right( cAno, 2 ) + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDocumento +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDocumento +=       XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDocumento +=       XmlTag( "ano", Right( cAno, 2 ) )
   ::cXmlDocumento +=       XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDocumento +=       XmlTag( "mod", cMod )
   ::cXmlDocumento +=       XmlTag( "serie", cSerie )
   ::cXmlDocumento +=       XmlTag( "nNFIni", cNumIni )
   ::cXmlDocumento +=       XmlTag( "nNFFin", cNumFim )
   ::cXmlDocumento +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDocumento +=    [</infInut>]
   ::cXmlDocumento += [</inutNFe>]

   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      IF ::cStatus == "102"
         ::cXmlAutorizado := XML_UTF8
         ::cXmlAutorizado += [<ProcInutNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
         ::cXmlAutorizado += ::cXmlDocumento
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno, "retInutNFe", .T. )
         ::cXmlAutorizado += [</ProcInutNFe>]
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   hb_Default( @cIndSinc, ::cIndSinc )

   IF ::cVersao == "3.10"
      ::aSoapActionList := { ;
         { "AC,AL,AP,DF,ES,PB,PR,RJ,RN,RO,RR,SC,SE,TO", ;
                 "3.10", "nfeAutorizacaoLote", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao" }, ;
         { "**", "3.10", "NfeAutorizacao",     "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao" } }
   ELSE
      ::aSoapActionList := { ;
         { "**", "4.00", "NfeAutorizacao4",    "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao" } }
   ENDIF
   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_AUTORIZACAO )

   IF Empty( cLote )
      cLote := "1"
   ENDIF
   IF cXml != NIL
      ::cXmlDocumento := cXml
   ENDIF
   IF ::AssinaXml() != "OK"
      RETURN ::cXmlRetorno
   ENDIF
   IF ::cNFCe == "S"
      GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC, ::cVersao )
   ENDIF

   ::cXmlEnvio    := [<enviNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   // FOR EACH cXmlNota IN aXmlNotas
   ::cXmlEnvio    += XmlTag( "idLote", cLote )
   ::cXmlEnvio    += XmlTag( "indSinc", cIndSinc )
   ::cXmlEnvio    += ::cXmlDocumento
   // NEXT
   ::cXmlEnvio    += [</enviNFe>]
   ::XmlSoapPost()
   IF cIndSinc == WS_RETORNA_RECIBO
      ::cXmlRecibo := ::cXmlRetorno
      ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
      ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStat" ), 3 )
      ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
      IF ! Empty( ::cRecibo )
         Inkey( ::nTempoEspera )
         ::NfeConsultaRecibo()
         ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ELSE
      ::cXmlRecibo := ::cXmlRetorno
      ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
      ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStat" ), 3 )
      ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
      IF ! Empty( ::cRecibo )
         ::cXmlProtocolo := ::cXmlRetorno
         ::cXmlRetorno   := ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   IF ::cVersao == "3.10"
      ::aSoapActionList := { ;
         { "PR", "3.10", "NfeRetAutorizacaoLote","http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao3" }, ;
         { "**", "3.10", "NfeRetAutorizacao",    "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao" } }
   ELSE
      ::aSoapActionList := { ;
         { "**", "4.00", "NfeRetAutorizacao4",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao" } }
   ENDIF
   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_RETAUTORIZACAO )

   ::cXmlEnvio     := [<consReciNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio     += [</consReciNFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )

   RETURN ::cXmlRetorno

METHOD NFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   IF ::cVersao == "3.10"
      ::aSoapActionList := { ;
         { "**", "3.10", "nfeStatusServicoNF2", "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2" }, ;
         { "BA", "3.10", "nfeStatusServicoNF",  "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico" } }
   ELSE
      ::aSoapActionList := { ;
         { "**", "4.00", "nfeStatusServicoNF", "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4" } }
   ENDIF
   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_STATUSSERVICO )

   ::cXmlEnvio    := [<consStatServ versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protNFe" ), "cStat" ), 3 ) // Pad() garante 3 caracteres
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<erro text="*ERRO* NFeGeraAutorizado() Não autorizado" />] + ::cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<nfeProc versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protNFe", .T. ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</nfeProc>]

   RETURN NIL

METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass // runner

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, "3.10" )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "cStat" ), 3 )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "xMotivo" ) // runner
   IF ! ::cStatus $ "135,155"
      ::cXmlRetorno := [<erro text="*ERRO* NFEGeraEventoAutorizado() Status inválido pra autorização" />] + ::cXmlRetorno
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoNFe versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEvento versao="] + WS_VERSAO_NFEEVENTO + [">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEvento" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEvento>] // runner
   ::cXmlAutorizado += [</procEventoNFe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN NIL

METHOD Setup( cUF, cCertificado, cAmbiente, nWsServico ) CLASS SefazClass

   LOCAL nPos

   DO CASE
   CASE cUF == NIL
   CASE Len( SoNumeros( cUF ) ) != 0
      ::cUF := ::UFSigla( Left( cUF, 2 ) )
   OTHERWISE
      ::cUF    := cUF
   ENDCASE
   ::cCertificado := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   ::cAmbiente    := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )

   ::nWsServico := nWsServico

   // define o restante
   IF ::cNFCE != "S" .AND. ; // NFCE é igual pra todas as UFs?
        ( nPos := AScan( ::aSoapActionList, { | oElement | ;
        ::cUF $ oElement[ WS_SOAP_UF ] .AND. ;
        oElement[ WS_SOAP_VERSAO ] == ::cVersao } ) ) != 0
      ::cSoapAction  := ::aSoapActionList[ nPos, WS_SOAP_SOAPACTION ]
      ::cSoapService := ::aSoapActionList[ nPos, WS_SOAP_SOAPSERVICE ]
   ELSEIF ( nPos := AScan( ::aSoapActionList, { | oElement | ;
         oElement[ WS_SOAP_UF ] == "**" .AND. ;
         oElement[ WS_SOAP_VERSAO ] == ::cVersao } ) ) != 0
      ::cSoapAction  := ::aSoapActionList[ nPos, WS_SOAP_SOAPACTION ]
      ::cSoapService := ::aSoapActionList[ nPos, WS_SOAP_SOAPSERVICE ]
   ENDIF
   ::SetSoapURL()

   RETURN NIL

METHOD SetSoapURL() CLASS SefazClass

   LOCAL nWsServico, cAmbiente, cUF, cProjeto, cNFCe, cScan, cVersao

   ::cSoapURL := ""
   nWsServico := ::nWsServico
   cAmbiente  := ::cAmbiente
   cUF        := ::cUF
   cProjeto   := ::cProjeto
   cNFCE      := ::cNFCE
   cScan      := ::cScan
   cVersao    := ::cVersao
   DO CASE
   CASE cProjeto == WS_PROJETO_BPE
      ::cSoapUrl := SoapUrlBpe( ::aSoapUrlList, cUF, cAmbiente, nWsServico, cVersao, @::cSoapVersion )
   CASE cProjeto == WS_PROJETO_CTE
      IF cScan == "SVCAN"
         IF cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
            ::cSoapURL := SoapURLCTe( ::aSoapUrlList, "SVSP", cAmbiente, nWsServico, cVersao, @::cSoapVersion ) // SVC_SP não existe
         ELSEIF cUF $ "MS,MT,SP," + "AP,PE,RR"
            ::cSoapURL := SoapUrlCTe( ::aSoapUrlList, "SVRS", cAmbiente, nWsServico, cVersao, @::CSoapVersion ) // SVC_RS não existe
         ENDIF
      ELSE
         ::cSoapUrl := SoapUrlCTe( ::aSoapUrlList, cUF, cAmbiente, nWsServico, cVersao, @::cSoapVersion )
      ENDIF
   CASE cProjeto == WS_PROJETO_MDFE
      ::cSoapURL := SoapURLMDFe( ::aSoapUrlList, "SVRS", cAmbiente, nWsServico, cVersao, @::cSoapVersion )
   CASE cProjeto == WS_PROJETO_NFE
      DO CASE
      CASE cNFCe == "S"
         ::cSoapUrl := SoapUrlNFCe( cUF, cAmbiente, nWsServico, cVersao, @::cSoapVersion )
         IF Empty( ::cSoapUrl )
            ::cSoapUrl := SoapUrlNfe( cUF, cAmbiente, nWsServico, cVersao, @::cSoapVersion )
         ENDIF
      CASE cScan == "SCAN"
         ::cSoapURL := SoapUrlNFe( "SCAN", cAmbiente, nWsServico, cVersao, @::cSoapVersion )
      CASE cScan == "SVAN"
         ::cSoapUrl := SoapUrlNFe( "SVAN", cAmbiente, nWsServico, cVersao, @::cSoapVersion )
      CASE cScan == "SVCAN"
         IF cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
            ::cSoapURL := SoapURLNfe( "SVRS", cAmbiente, nWsServico, cVersao, @::cSoapVersion ) // svc-rs não existe
         ELSE
            ::cSoapURL := SoapUrlNFe( "SVAN", cAmbiente, nWsServico, cVersao, @::cSoapVersion ) // svc-an não existe
         ENDIF
      OTHERWISE
         ::cSoapUrl := SoapUrlNfe( cUF, cAmbiente, nWsServico, cVersao, @::cSoapVersion )
      ENDCASE
   ENDCASE

   RETURN NIL

METHOD XmlSoapPost() CLASS SefazClass

   DO CASE
   CASE Empty( ::cSoapURL )
      ::cXmlRetorno := [<erro text="*ERRO* XmlSoapPost(): Não há endereço de webservice" />]
      RETURN NIL
   CASE Empty( ::cSoapService )
      ::cXmlRetorno := [<erro text="*ERRO* XmlSoapPost(): Não há nome do serviço" />]
      RETURN NIL
   CASE Empty( ::cSoapAction )
      ::cXmlRetorno := [<erro text="*ERRO* XmlSoapPost(): Não há endereço de SOAP Action" />]
      RETURN NIL
   ENDCASE
   ::XmlSoapEnvelope()
   ::MicrosoftXmlSoapPost()
   IF "*ERRO*" $ Upper( ::cXmlRetorno )
      RETURN NIL
   ENDIF

   RETURN NIL

METHOD XmlSoapEnvelope() CLASS SefazClass

   LOCAL cXmlns := ;
      [xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ] + ;
      [xmlns:xsd="http://www.w3.org/2001/XMLSchema" ] + ;
      [xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"]

   ::cXmlSoap    := XML_UTF8
   ::cXmlSoap    += [<soap12:Envelope ] + cXmlns + [>]
   IF ::nWsServico != WS_MDFE_DISTRIBUICAODFE // ! ( ::cProjeto == WS_PROJETO_NFE .AND. ::cVersao == "4.00" )
      ::cXmlSoap +=    [<soap12:Header>]
      ::cXmlSoap +=       [<] + ::cProjeto + [CabecMsg xmlns="] + ::cSoapService + [">]
      ::cXmlSoap +=          [<cUF>] + ::UFCodigo( ::cUF ) + [</cUF>]
      ::cXmlSoap +=          [<versaoDados>] + ::cSoapVersion + [</versaoDados>]
      ::cXmlSoap +=       [</] + ::cProjeto + [CabecMsg>]
      ::cXmlSoap +=    [</soap12:Header>]
   ENDIF
   ::cXmlSoap    +=    [<soap12:Body>]
   IF ::nWsServico == WS_MDFE_DISTRIBUICAODFE
      ::cXmlSoap += [<nfeDistDFeInteresse xmlns="] + ::cSoapService + [">]
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg>]
   ELSE
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg xmlns="] + ::cSoapService + [">]
   ENDIF
   ::cXmlSoap    += ::cXmlEnvio
   ::cXmlSoap    +=    [</] + ::cProjeto + [DadosMsg>]
   IF ::nWsServico == WS_MDFE_DISTRIBUICAODFE
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
      ::cXmlRetorno := [<erro text="*ERRO* Erro: Criando objeto MSXML2.ServerXMLHTTP" />]
#ifdef __XHARBOUR__
      //IF ::cUF == "GO" .AND. ::cAmbiente == "2"
      ::cXmlRetorno := [<erro text="*ERRO* Erro: Criando objeto MSXML2.ServerXMLHTTP.5.0" /?]
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP.5.0" )
      //ELSE
      //   ::cXmlRetorno := "Erro: Criando objeto MSXML2.ServerXMLHTTP.6.0"
      //   oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP.6.0" )
      //ENDIF
#else
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP" )
#endif
      ::cXmlRetorno := [erro text="*ERRO* Erro: No uso do objeto MSXML2.ServerXmlHTTP" />]
      IF ::cCertificado != NIL
         oServer:setOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
      ENDIF
      ::cXmlRetorno := [erro text="*ERRO* Erro: Na conexão com webservice ] + ::cSoapURL + [" />]
      oServer:Open( "POST", ::cSoapURL, .F. )
      IF cSoapAction != NIL .AND. ! Empty( cSoapAction )
         oServer:SetRequestHeader( "SOAPAction", cSoapAction )
      ENDIF
      oServer:SetRequestHeader( "Content-Type", "application/soap+xml; charset=utf-8" )
      oServer:Send( ::cXmlSoap )
      oServer:WaitForResponse( 500 )
      cRetorno := oServer:ResponseBody()
      IF ValType( cRetorno ) == "C"
         ::cXmlRetorno := cRetorno
      ELSEIF cRetorno == NIL
         ::cXmlRetorno := "Sem retorno do webservice"
      ELSE
         ::cXmlRetorno := ""
         FOR nCont = 1 TO Len( cRetorno )
            ::cXmlRetorno += Chr( cRetorno[ nCont ] )
         NEXT
      ENDIF
   END SEQUENCE
   IF "<soap:Body>" $ ::cXmlRetorno .AND. "</soap:Body>" $ ::cXmlRetorno
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soap:Body" ) // hb_UTF8ToStr()
   ELSEIF "<soapenv:Body>" $ ::cXmlRetorno .AND. "</soapenv:Body>" $ ::cXmlRetorno
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soapenv:Body" ) // hb_UTF8ToStr()
   ELSE
      // teste usando procname(2)
      ::cXmlRetorno := [<erro text="*ERRO* Erro SOAP: ] + ProcName(2) + [ XML retorno não contém soapenv:Body" />] + ::cXmlRetorno
   ENDIF

   RETURN NIL

METHOD CTeAddCancelamento( cXmlAssinado, cXmlCancelamento ) CLASS SefazClass

   LOCAL cDigVal, cXmlAutorizado

   cDigVal := XmlNode( cXmlAssinado , "Signature" )
   cDigVal := XmlNode( cDigVal , "SignedInfo" )
   cDigVal := XmlNode( cDigVal , "Reference" )
   cDigVal := XmlNode( cDigVal , "DigestValue" )

   cXmlAutorizado := XML_UTF8
   cXmlAutorizado += [<cteProc versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
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
   cXmlAutorizado += [<nfeProc versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   cXmlAutorizado +=    cXmlAssinado
   cXmlAutorizado +=    [<protNFe versao="] = ::cVersao + [">]
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
      cRetorno := "OK"

   END SEQUENCE

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

STATIC FUNCTION SoapUrlBpe( aSoapList, cUF, cAmbiente, nWsServico, cVersao, cSoapVersion )

   LOCAL nPos, cUrl

   nPos := AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cAmbiente == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aSoapList[ nPos, 4 ]
      cSoapVersion := aSoapList[ nPos, 2 ]
   ENDIF
   HB_SYMBOL_UNUSED( nWsServico + cVersao )
   RETURN cUrl

STATIC FUNCTION SoapUrlNfe( cUF, cAmbiente, nWsServico, cVersao, cSoapVersion )

   LOCAL nPos,cUrl, aList

   aList :=  SefazSoapList( nWsServico, "N", cVersao )

   nPos := AScan( aList, { | e | cUF == e[ 1 ] .AND. cAmbiente == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aList[ nPos, 4 ]
      cSoapVersion := aList[ nPos, 2 ]
   ENDIF
   IF nWsServico == WS_NFE_CONSULTACADASTRO .AND. cUF $ "AC,RN,PB,SC"
      cUrl := SoapUrlNfe( "SVRS", cAmbiente, nWsServico, cVersao, @cSoapVersion )
   ENDIF
   DO CASE
   CASE ! Empty( cUrl )
   CASE cUf $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO"
      cURL := SoapURLNFe( "SVRS", cAmbiente, nWsServico, cVersao, @cSoapVersion )
   CASE cUf $ "MA,PA,PI"
      cURL := SoapUrlNFe( "SVAN", cAmbiente, nWsServico, cVersao, @cSoapVersion )
   ENDCASE

   RETURN cUrl

STATIC FUNCTION SoapUrlCte( aSoapList, cUF, cAmbiente, nWsServico, cVersao, cSoapVersion )

   LOCAL nPos, cUrl

   nPos := AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cAmbiente == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aSoapList[ nPos, 4 ]
      cSoapVersion := aSoapList[ nPos, 2 ]
   ENDIF
   IF Empty( cUrl )
      IF cUF $ "AP,PE,RR"
         cUrl := SoapUrlCTe( aSoapList, "SVSP", cAmbiente, nWsServico, cVersao, @cSoapVersion )
      ELSEIF cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
         cUrl := SoapUrlCTe( aSoapList, "SVRS", cAmbiente, nWsServico, cVersao, @cSoapVersion )
      ENDIF
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlMdfe( aSoapList, cUF, cAmbiente, nWsServico, cVersao, cSoapVersion )

   LOCAL cUrl, nPos

   nPos := AScan( aSoapList, { | e | cAmbiente == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aSoapList[ nPos, 4 ]
      cSoapVersion := aSoapList[ nPos, 2 ]
   ENDIF

   HB_SYMBOL_UNUSED( cUF + nWsServico + cVersao )

   RETURN cUrl

STATIC FUNCTION SoapUrlNFCe( cUf, cAmbiente, nWsServico, cVersao, cSoapVersion )

   LOCAL cUrl, nPos, aList

   aList := SefazSoapList( nWsServico, "S", cVersao )

   IF cUF $ "AC,RR"
      cUrl := SoapUrlNFCe( "SVRS", cAmbiente, nWsServico, cVersao, @cSoapVersion )
   ELSE
      nPos := AScan( aList, { | e | cUF == e[ 1 ] .AND. cAmbiente == e[ 3 ] } )
      IF nPos != 0
         cUrl         := aList[ nPos, 4 ]
         cSoapVersion := aList[ nPos, 2 ]
      ENDIF
   ENDIF
   IF Empty( cUrl )
      cUrl := SoapUrlNFe( cUF, cAmbiente, nWsServico, cVersao, @cSoapVersion )
   ENDIF

   RETURN cUrl

STATIC FUNCTION GeraQRCode( cXmlAssinado, cIdToken, cCSC, cVersao )

   LOCAL QRCODE_cTag, QRCODE_Url, QRCODE_chNFe, QRCODE_nVersao, QRCODE_tpAmb
   LOCAL QRCODE_cDest, QRCODE_dhEmi, QRCODE_vNF, QRCODE_vICMS, QRCODE_digVal
   LOCAL QRCODE_cIdToken, QRCODE_cCSC, QRCODE_cHash
   LOCAL cInfNFe, cSignature, cAmbiente, cUF, nPos
   LOCAL aList

   hb_Default( @cIdToken, StrZero( 0, 6 ) )
   hb_Default( @cCsc, StrZero( 0, 36 ) )

   aList := SefazSoapList( WS_NFE_QRCODE, "S", cVersao )

   cInfNFe    := XmlNode( cXmlAssinado, "infNFe", .T. )
   cSignature := XmlNode( cXmlAssinado, "Signature", .T. )

   cAmbiente  := XmlNode( XmlNode( cInfNFe, "ide" ), "tpAmb" )
   cUF        := UFSigla( XmlNode( XmlNode( cInfNFe, "ide" ), "cUF" ) )

   // 1¦ Parte ( Endereco da Consulta - Fonte: http://nfce.encat.org/desenvolvedor/qrcode/ )
   nPos       := AScan( aList, { | e | e[ 1 ] == cUF .AND. e[ 3 ] == cAmbiente } )
   QRCode_Url := iif( nPos == 0, "", aList[ nPos, 4 ] )

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
   QRCODE_cCSC     := cCsc

   IF ! Empty( QRCODE_chNFe ) .AND. ! Empty( QRCODE_nVersao ) .AND. ! Empty( QRCODE_tpAmb ) .AND. ! Empty( QRCODE_dhEmi ) .AND. !Empty( QRCODE_vNF ) .AND.;
         ! Empty( QRCODE_vICMS ) .AND. ! Empty( QRCODE_digVal  ) .AND. ! Empty( QRCODE_cIdToken ) .AND. ! Empty( QRCODE_cCSC  )

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
      QRCODE_cTag  := "<![CDATA[" + QRCODE_Url + QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + ;
         QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cHash + "]]>"
      // XML com a Tag do QRCode
      cXmlAssinado := [<NFe xmlns="http://www.portalfiscal.inf.br/nfe">]
      cXmlAssinado += cInfNFe
      cXmlAssinado += [<] + "infNFeSupl"+[>]
      cXmlAssinado += [<] + "qrCode"+[>] + QRCODE_cTag + [</] + "qrCode" + [>]
      cXmlAssinado += [</] + "infNFeSupl"+[>]
      cXmlAssinado += cSignature
      cXmlAssinado += [</NFe>]
   ELSE
      RETURN "Erro na geracao do QRCode"
   ENDIF

   RETURN "OK"
