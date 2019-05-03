/*
ZE_SEFAZCLASS - Rotinas pra comunicação com SEFAZ
José Quintas

Nota: CTE 2.00 vale até 10/2017, CTE 2.00 até 12/2017, NFE 3.10 até 04/2018

2017.11.27 Aceita arquivo PFX pra assinatura somente
2018.03.13 SoapList de CTE e MDFE nos métodos
2018.05.13 Default NFE 4.0 exceto autorização/recibo/protocolo
*/

#include "hbclass.ch"
#include "sefazclass.ch"
#include "hb2xhb.ch"

#ifdef __XHARBOUR__
#define ALL_PARAMETERS P1, P2, P3, P4, P5, P6, P7, P8, P9, P10
#else
#define ALL_PARAMETERS ...
#endif

#define WS_NFE_DEFAULT "4.00"

CREATE CLASS SefazClass

   /* configuração */
   VAR    cProjeto        INIT NIL
   VAR    cAmbiente       INIT WS_AMBIENTE_PRODUCAO
   VAR    cVersao         INIT NIL
   VAR    cVersaoQrCode   INIT "2.00"                  // Versao do QRCode
   VAR    cScan           INIT "N"                     // Indicar se for SCAN/SVAN, ainda não testado
   VAR    cUF             INIT "SP"                    // Modificada conforme método
   VAR    cCertificado    INIT ""                      // Nome do certificado
   VAR    ValidFromDate   INIT ""                      // Validade do certificado
   VAR    ValidToDate     INIT ""                      // Validade do certificado
   VAR    cIndSinc        INIT WS_RETORNA_RECIBO       // Poucas UFs opção de protocolo
   VAR    nTempoEspera    INIT 7                       // intervalo entre envia lote e consulta recibo
   VAR    cUFTimeZone     INIT ""                      // Para TimeZone diferente da UF de comunicação
   VAR    cUserTimeZone   INIT ""                      // Para TimeZone definido pelo usuário
   VAR    cIdToken        INIT ""                      // Para NFCe obrigatorio identificador do CSC Código de Segurança do Contribuinte
   VAR    cCSC            INIT ""                      // Para NFCe obrigatorio CSC Código de Segurança do Contribuinte
   VAR    cPassword       INIT ""                      // Senha de arquivo PFX
   VAR    cProxyUrl       INIT ""
   VAR    cProxyUser      INIT ""
   VAR    cProxyPassword  INIT ""
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
   VAR    cSoapService    INIT ""                      // webservice Serviço
   VAR    cSoapAction     INIT ""                      // webservice Action
   VAR    cSoapURL        INIT ""                      // webservice Endereço
   VAR    cXmlNameSpace   INIT "xmlns="
   VAR    cNFCE           INIT "N"                     // Porque NFCE tem endereços diferentes
   VAR    aSoapUrlList    INIT {}

   METHOD BPeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD BPeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
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
   METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cChave, cUF, cCertificado, cAmbiente )
   METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD NFeEventoCancelaSubstituicao( cChave, cOrgaoAutor, cAutor, cVersaoAplicativo, cProtocolo, cJust, cNfRef, cCertificado, cAmbiente )
   METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente )
   METHOD NFeEventoManifestacao( cChave, cCnpj, cCodigoEvento, xJust, cCertificado, cAmbiente )
   METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc )
   METHOD NFeStatusServico( cUF, cCertificado, cAmbiente )
   METHOD NFeContingencia( cXml, cUF, cCertificado, cAmbiente )

   METHOD CTeAddCancelamento( cXmlAssinado, cXmlCancelamento )
   METHOD NFeAddCancelamento( cXmlAssinado, cXmlCancelamento )

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
   METHOD ValidaXml( cXml, cFileXsd )                 INLINE ::cXmlRetorno := DomDocValidaXml( cXml, cFileXsd )
   METHOD Setup( cUF, cCertificado, cAmbiente )

   ENDCLASS

METHOD AssinaXml()

   ::cXmlRetorno := CapicomAssinaXml( @::cXmlDocumento, ::cCertificado,,::cPassword )
   IF ::cXmlRetorno != "OK"
      ::cStatus := "999"
      ::cMotivo := ::cXmlRetorno
      ::cXmlRetorno := [<erro text="] + "*erro* " + ::cXmlRetorno + ["</erro>]
   ENDIF

   RETURN ::cXmlRetorno

METHOD BPeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "1.00" )
   hb_Default( @::cProjeto, WS_PROJETO_BPE )
   ::aSoapUrlList := WS_BPE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cSoapAction  := "BpeConsulta"
   ::cSoapService := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP"

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
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD BPeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "1.00" )
   hb_Default( @::cProjeto, WS_PROJETO_BPE )
   ::aSoapUrlList := WS_BPE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "BpeStatusServicoBP"
   ::cSoapService := "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico"

   ::cXmlEnvio := [<consStatServBPe versao="] + ::cVersao + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServBPe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   ::aSoapUrlList := WS_CTE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cSoapAction  := "cteConsultaCT"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta"

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
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   ::aSoapUrlList := WS_CTE_RETAUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "cteRetRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao"

   ::cXmlEnvio     := [<consReciCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec",  ::cRecibo )
   ::cXmlEnvio     += [</consReciCTe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno  // ? hb_Utf8ToStr()
   IF ::cStatus != "999"
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno // ? hb_Utf8ToStr()

METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @nSequencia, 1 )
   ::aSoapUrlList := WS_CTE_ENVIAEVENTO
   ::cSoapAction  := "cteRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

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
      IF ::cStatus != "999"
         ::CTeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL oElement

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @nSequencia, 1 )

   ::aSoapUrlList := WS_CTE_ENVIAEVENTO
   ::cSoapAction  := "cteRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
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

   ::aSoapUrlList := WS_CTE_ENVIAEVENTO
   ::cSoapAction  := "cteRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID610110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "610110" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + ::cVersao + [">]
   ::cXmlDocumento +=          [<evPrestDesacordo>]
   ::cXmlDocumento +=             XmlTag( "descEvento", "Prestacao do Servico em Desacordo" )
   ::cXmlDocumento +=             XmlTag( "indDesacordoOper", "1" )
   ::cXmlDocumento +=             XmlTag( "xObs", cObs )
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

   ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   //::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protCTe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<erro text="*ERRO* CTEGeraAutorizado() Não autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<cteProc versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protCTe", .T. ) // ?hb_Utf8ToStr()
   ::cXmlAutorizado += [</cteProc>]

   RETURN ::cXmlAutorizado

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
   ::aSoapUrlList := WS_CTE_INUTILIZA
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "cteInutilizacaoCT"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao"

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
   ::cXmlDocumento +=       XmlTag( "nCTIni", LTrim( Str( Val( cNumIni ), 9, 0 ) ) )
   ::cXmlDocumento +=       XmlTag( "nCTFin", LTrim( Str( Val( cNumFim ), 9, 0 ) ) )
   ::cXmlDocumento +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDocumento +=    [</infInut>]
   ::cXmlDocumento += [</inutCTe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      IF ::cStatus != "999"
         ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
         ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      ENDIF
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
   ::aSoapUrlList := WS_CTE_AUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "cteRecepcaoLote"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao"

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
   IF ! Empty( ::cRecibo ) .AND. ::cStatus != "999"
      Inkey( ::nTempoEspera )
      ::CteConsultaRecibo()
      ::CteGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo ) // runner
   ENDIF

   RETURN ::cXmlRetorno

METHOD CTeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, "3.00" )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   ::aSoapUrlList := WS_CTE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "cteStatusServicoCT"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico"

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
   ::aSoapUrlList := WS_MDFE_CONSULTANAOENCERRADOS
   ::Setup( cUF, cCertificado, cAmbiente )

   ::cXmlEnvio := [<consMDFeNaoEnc versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "CONSULTAR NÃO ENCERRADOS" )
   ::cXmlEnvio +=    XmlTag( "CNPJ", cCNPJ )
   ::cXmlEnvio += [</consMDFeNaoEnc>]
   ::XmlSoapPost()
   IF ::cStatus != "999"
      ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "cStat" ), 3 )
      ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   ::aSoapUrlList := WS_MDFE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cSoapAction  := "mdfeConsultaMDF"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta"

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
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF
   ::aSoapUrlList := WS_MDFE_RETAUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "mdfeRetRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao"

   ::cXmlEnvio := [<consReciMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio += [</consReciMDFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   IF ::cStatus != "999"
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

   // 2016.01.31.2200 Iniciado apenas

METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )

   ::aSoapUrlList := WS_MDFE_DISTRIBUICAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "mdfeDistDFeInteresse" // verificar na comunicação
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/MDFeDistribuicaoDFe"

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

METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   hb_Default( @nSequencia, 1 )

   ::aSoapUrlList := WS_MDFE_EVENTO
   ::cSoapAction  := "mdfeRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

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

   ::aSoapUrlList := WS_MDFE_EVENTO
   ::cSoapAction  := "mdfeRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

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

   ::aSoapUrlList := WS_MDFE_EVENTO
   ::cSoapAction  := "mdfeRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlDocumento := [<eventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110114] + cChave + StrZero( nSequencia, 2 ) + [">]
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
   ::cXmlDocumento +=               [<condutor>]
   ::cXmlDocumento +=                  XmlTag( "xNome", cNome )
   ::cXmlDocumento +=                  XmlTag( "CPF", cCPF)
   ::cXmlDocumento +=               [</condutor>]
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

   ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   //::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protMDFe" ), "cStat" ), 3 )
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
   ::aSoapUrlList := WS_MDFE_AUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "MDFeRecepcao"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao"

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
   IF ::cStatus != "999"
      ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStatus" ), 3 )
      ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
   ENDIF
   IF ! Empty( ::cRecibo ) .AND. ::cStatus != "999"
      Inkey( ::nTempoEspera )
      ::MDFeConsultaRecibo()
      ::MDFeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, "3.00" )
   ::aSoapUrlList := WS_MDFE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "MDFeStatusServico"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico/mdfeStatusServicoMDF"

   ::cXmlEnvio := [<consStatServMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServMDFe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::aSoapUrlList := WS_NFE_CONSULTACADASTRO
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.10" .OR. ::cUF $ "AM,BA,MG,PE"
      ::cSoapAction  := "CadConsultaCadastro2"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2"
   ELSE
      ::cSoapAction := "consultaCadastro"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro4"
   ENDIF

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
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cIndNFe, "0" )
   hb_Default( @cIndEmi, "0" )

   ::aSoapUrlList := WS_NFE_CONSULTADEST
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction := "nfeConsultaNFDest"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest"

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
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   IF ::cVersao == "3.10"
      DO CASE
      CASE ::cUF == "BA"
         ::cSoapAction  := "nfeConsultaNF"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta"
      CASE ::cUF $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO"
         ::cSoapAction  := "nfeConsultaNF2"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2"
      OTHERWISE
         ::cSoapAction  := "NfeConsulta2"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2"
      ENDCASE
   ELSE
      DO CASE
      CASE ::cUF $ "AC,AL,AP,DF,ES,PB,PI,RJ,RN,RO,RR,SC,SE,TO" // TODOS que usam SVRS
         ::cSoapAction := "nfeConsultaNF"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4"
      OTHERWISE
         ::cSoapAction := "nfeConsultaNF"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaProtocolo4"
      ENDCASE
   ENDIF

   ::cXmlEnvio    := [<consSitNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chNFe", cChave )
   ::cXmlEnvio    += [</consSitNFe>]
   IF ! DfeModFis( cChave ) $ "55,65"
      ::cStatus     := "999"
      ::cMotivo     := "Chave não se refere a NFE/NFCE"
      ::cXmlRetorno := [<erro text="*ERRO* NfeConsultaProtocolo() ] + ::cMotivo + [" />]

   ELSE
      ::XmlSoapPost()
   ENDIF
   IF ::cStatus != "999"
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cChave, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )
   hb_Default( @cChave, "" )

   ::aSoapUrlList := WS_NFE_DISTRIBUICAO
   ::Setup( "AN", cCertificado, cAmbiente )
   ::cSoapAction  := "nfeDistDFeInteresse"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe"

   ::cXmlEnvio    := [<distDFeInt versao="1.01" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUFAutor", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "CNPJ", cCnpj ) // ou CPF
   IF ! Empty( cChave )
      ::cXmlEnvio += [<consChNFe>]
      ::cXmlEnvio +=    XmlTag( "chNFe", cChave )
      ::cXmlEnvio += [</consChNFe>]
   ELSEIF ! Empty( cNSU )
      ::cXmlEnvio +=   [<consNSU>]
      ::cXmlEnvio +=      XmlTag( "NSU", cNSU )
      ::cXmlEnvio +=   [</consNSU>]
   ELSE
      ::cXmlEnvio +=   [<distNSU>]
      ::cXmlEnvio +=      XmlTag( "ultNSU", cUltNSU )
      ::cXmlEnvio +=   [</distNSU>]
   ENDIF
   ::cXmlEnvio   += [</distDFeInt>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cVersaoEvento

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   IF ::cVersao == "3.10"
      ::cSoapAction  := "nfeRecepcaoEvento"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento"
   ELSE
      ::cSoapAction  := "nfeRecepcaoEvento"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4"
   ENDIF
   ::Setup( cChave, cCertificado, cAmbiente )
   cVersaoEvento := "1.00"
   ::cXmlDocumento := [<evento versao="] + cVersaoEvento + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110110" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", cVersaoEvento )
   ::cXmlDocumento +=       [<detEvento versao="] + cVersaoEvento + [">]
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
      ::cXmlEnvio := [<envEvento versao="] + cVersaoEvento + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NfeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cVersaoEvento

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   IF ::cVersao == "3.10"
      ::cSoapAction  := "nfeRecepcaoEvento"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento"
   ELSE
      ::cSoapAction  := "nfeRecepcaoEvento"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4"
   ENDIF
   ::Setup( cChave, cCertificado, cAmbiente )
   cVersaoEvento := "1.00"

   ::cXmlDocumento := [<evento versao="] + cVersaoEvento + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110111" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", cVersaoEvento )
   ::cXmlDocumento +=       [<detEvento versao="] + cVersaoEvento + [">]
   ::cXmlDocumento +=          XmlTag( "descEvento", "Cancelamento" )
   ::cXmlDocumento +=          XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   ::cXmlDocumento +=          XmlTag( "xJust", xJust )
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="] + cVersaoEvento + [" ] + WS_XMLNS_NFE + [>]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoCancelaSubstituicao( cChave, cOrgaoAutor, cAutor, cVersaoAplicativo, cProtocolo, cJust, cNFRef, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cVersaoEvento

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   ::cSoapAction  := "nfeRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4"
   ::Setup( cChave, cCertificado, cAmbiente )
   cVersaoEvento := "1.00"

   ::cXmlDocumento := [<evento versao="] + cVersaoEvento + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + "01" + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110112" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", "1" )
   ::cXmlDocumento +=       XmlTag( "verEvento", cVersaoEvento )
   ::cXmlDocumento +=       [<detEvento versao="] + cVersaoEvento + [">]
   ::cXmlDocumento +=          XmlTag( "descEvento", "Cancelamento por substituicao" ) // acentos?
   ::cXmlDocumento +=          XmlTag( "cOrgaoAutor", cOrgaoAutor )
   ::cXmlDocumento +=          XmlTag( "tpAutor", cAutor )
   ::cXmlDocumento +=          XmlTag( "verAplic", cVersaoAplicativo )
   ::cXmlDocumento +=          XmlTag( "nProt", cProtocolo )
   ::cXmlDocumento +=          XmlTag( "xJust", cJust )
   ::cXmlDocumento +=          XmlTag( "chNFeRef", cNfRef )
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="] + cVersaoEvento + [" ] + WS_XMLNS_NFE + [>]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoManifestacao( cChave, cCnpj, cCodigoEvento, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cDescEvento, cVersaoEvento

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cCnpj, "00000000000000" )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   ::cUF          := "AN"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4"
   ::cSoapAction  := "nfeRecepcaoEventoNF"
   ::Setup( "AN", cCertificado, cAmbiente )

   cVersaoEvento := "1.00"
   DO CASE
   CASE cCodigoEvento == "210200" ; cDescEvento := "Confirmacao da Operacao"
   CASE cCodigoEvento == "210210" ; cDescEvento := "Ciencia da Operacao"
   CASE cCodigoEvento == "210220" ; cDescEvento := "Desconhecimento da Operacao"
   CASE cCodigoEvento == "210240" ; cDescEvento := "Operacao Nao Realizada"
   ENDCASE

   ::cXmlDocumento := [<evento versao="] + cVersaoEvento + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cCodigoEvento + cChave + "01" + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", "91" )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", cCnpj )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cCodigoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", "1" ) // obrigatoriamente 1
   ::cXmlDocumento +=       XmlTag( "verEvento", cVersaoEvento )
   ::cXmlDocumento +=       [<detEvento versao="] + cVersaoEvento + [">]
   ::cXmlDocumento +=          XmlTag( "descEvento", cDescEvento )
   IF cCodigoEvento == "210240"
      ::cXmlDocumento +=          XmlTag( "xJust", xJust )
      //ELSE
      //::cXmlDocumento += XmlTag( "xJust", cDescEvento ) // ----teste-----
   ENDIF
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="] + cVersaoEvento + [" ] + WS_XMLNS_NFE + [>]
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
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::aSoapUrlList := WS_NFE_INUTILIZA
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.10"
      ::cSoapAction  := "NfeInutilizacaoNF2"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2"
   ELSE
      ::cSoapAction  := "nfeInutilizacaoNF"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4"
   ENDIF

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
      IF ::cStatus != "999"
         ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
         ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      ENDIF
      IF ::cStatus == "102"
         ::cXmlAutorizado := XML_UTF8
         ::cXmlAutorizado += [<ProcInutNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
         ::cXmlAutorizado += ::cXmlDocumento
         ::cXmlAutorizado += XmlNode( ::cXmlRetorno, "retInutNFe", .T. )
         ::cXmlAutorizado += [</ProcInutNFe>]
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

   // em teste

METHOD NFeContingencia( cXml, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cUF           := iif( cUF == NIL, ::cUF, cUF )
   ::cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   ::cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cXmlDocumento := iif( cXml == NIL, ::cXmlDocumento, cXml )
   ::AssinaXml()
   IF ::cNFCe == "S"
      GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC, ::cVersao, ::cVersaoQrCode )
   ENDIF

   RETURN ::cXmlDocumento

METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cIndSinc, ::cIndSinc )

   ::aSoapUrlList := WS_NFE_AUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.10"
      IF ::cUF $ "AC,AL,AP,DF,ES,PB,PR,RJ,RN,RO,RR,SC,SE,TO"
         ::cSoapAction := "nfeAutorizacaoLote"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao"
      ELSE
         ::cSoapAction := "NfeAutorizacao"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao"
      ENDIF
   ELSE
      ::cSoapAction  := "nfeAutorizacaoLote"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4"
   ENDIF

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
      GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC, ::cVersao, ::cVersaoQrCode )
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
      IF ::cStatus != "999"
         ::cStatus    := Pad( XmlNode( ::cXmlRecibo, "cStat" ), 3 )
         ::cMotivo    := XmlNode( ::cXmlRecibo, "xMotivo" )
         IF ! Empty( ::cRecibo )
            ::cXmlProtocolo := ::cXmlRetorno
            ::cXmlRetorno   := ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
         ENDIF
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::aSoapUrlList := WS_NFE_RETAUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.10"
      DO CASE
      CASE ::cUF == "PR"
         ::cSoapAction  := "NfeRetAutorizacaoLote"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao3"
      OTHERWISE
         ::cSoapAction  := "NfeRetAutorizacao"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao"
      ENDCASE
   ELSE
      ::cSoapAction  := "nfeRetAutorizacaoLote"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4"
   ENDIF

   ::cXmlEnvio     := [<consReciNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio     += [</consReciNFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   IF "<infProt" $ ::cXmlRetorno // 23/05/2018
      ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSEIF ::cStatus != "999"
      ::cMotivo       := XmlNode( ::cXmlRetorno, "xMotivo" )
      ::cStatus       := XmlNode( ::cXmlRetorno, "cStat" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::aSoapUrlList := WS_NFE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cVersao == "3.10"
      DO CASE
      CASE ::cUF == "BA"
         ::cSoapAction  := "nfeStatusServicoNF"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico"
      OTHERWISE
         ::cSoapAction  := "nfeStatusServicoNF2"
         ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
      ENDCASE
   ELSE
      ::cSoapAction  := "nfeStatusServicoNF"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4"
   ENDIF

   ::cXmlEnvio    := [<consStatServ versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   //::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protNFe" ), "cStat" ), 3 ) // Pad() garante 3 caracteres
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

   LOCAL cVersaoEvento

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   cVersaoEvento := "1.00"

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   IF ::cStatus != "999"
      ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "cStat" ), 3 )
      ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "xMotivo" ) // runner
   ENDIF
   IF ! ::cStatus $ "135,155"
      ::cXmlRetorno := [<erro text="*ERRO* NFEGeraEventoAutorizado() Status inválido pra autorização" />] + ::cXmlRetorno
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoNFe versao="] + cVersaoEvento + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEvento versao="] + cVersaoEvento + [">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEvento" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEvento>] // runner
   ::cXmlAutorizado += [</procEventoNFe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN NIL

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
      ::cSoapUrl := SoapUrlBpe( ::aSoapUrlList, cUF, cVersao )
   CASE cProjeto == WS_PROJETO_CTE
      IF cScan == "SVCAN"
         IF cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
            ::cSoapURL := SoapURLCTe( ::aSoapUrlList, "SVSP", cVersao ) // SVC_SP não existe
         ELSEIF cUF $ "MS,MT,SP," + "AP,PE,RR"
            ::cSoapURL := SoapUrlCTe( ::aSoapUrlList, "SVRS", cVersao ) // SVC_RS não existe
         ENDIF
      ELSE
         ::cSoapUrl := SoapUrlCTe( ::aSoapUrlList, cUF, cVersao )
      ENDIF
   CASE cProjeto == WS_PROJETO_MDFE
      ::cSoapURL := SoapURLMDFe( ::aSoapUrlList, "SVRS", cVersao )
   CASE cProjeto == WS_PROJETO_NFE
      DO CASE
      CASE cNFCe == "S"
         ::cSoapUrl := SoapUrlNFCe( ::aSoapUrlList, cUF, cVersao )
         IF Empty( ::cSoapUrl )
            ::cSoapUrl := SoapUrlNfe( ::aSoapUrlList, cUF, cVersao )
         ENDIF
      CASE cScan == "SCAN"
         ::cSoapURL := SoapUrlNFe( ::aSoapUrlList, "SCAN", cVersao )
      CASE cScan == "SVAN"
         ::cSoapUrl := SoapUrlNFe( ::aSoapUrlList, "SVAN", cVersao )
      CASE cScan == "SVCAN"
         IF cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
            ::cSoapURL := SoapURLNfe( ::aSoapUrlList, "SVRS", cVersao ) // svc-rs não existe
         ELSE
            ::cSoapURL := SoapUrlNFe( ::aSoapUrlList, "SVAN", cVersao ) // svc-an não existe
         ENDIF
      OTHERWISE
         ::cSoapUrl := SoapUrlNfe( ::aSoapUrlList, cUF, cVersao )
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
   IF ::cSoapAction != "nfeDistDFeInteresse"
      ::cXmlSoap +=    [<soap12:Header>]
      IF ::cVersao == "4.00"
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
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP.6.0" )
      //oServer:SetOption( 2, 13056 ) // uma das tentativas de TLS 1.2 mas não fez diferença
#endif
      ::cXmlRetorno := [erro text="*ERRO* Erro: No uso do objeto MSXML2.ServerXmlHTTP.6.0" />]
      IF ::cCertificado != NIL
         oServer:setOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
      ENDIF
      ::cXmlRetorno := [erro text="*ERRO* Erro: Na conexão com webservice ] + ::cSoapURL + [" />]
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
      oServer:Send( ::cXmlSoap )
      oServer:WaitForResponse( 1000 )
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
   END SEQUENCE
   DO CASE
   CASE ! Empty( XmlNode( ::cXmlRetorno, "soap:Body" ) )
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soap:Body" )
   CASE ! Empty( XmlNode( ::cXmlRetorno, "soapenv:Body" ) )
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soapenv:Body" )
   CASE ! Empty( XmlNode( ::cXmlRetorno, "env:Body" ) )
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "env:Body" )
   CASE "not have permission to view" $ ::cXmlRetorno
      ::cStatus     := "999"
      ::cMotivo     := "Certificado inválido, vencido, ou problemas na Sefaz"
      ::cXmlRetorno := [<erro xml="] + "*ERRO*" + ::cMotivo + [" />]
   OTHERWISE
      // teste usando procname(2)
      ::cXmlRetorno := [<erro text="*ERRO* Erro SOAP: ] + ProcName(2) + [ XML retorno não contém soapenv:Body" />] + ::cXmlRetorno
   ENDCASE

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

STATIC FUNCTION DomDocValidaXml( cXml, cFileXsd )

   LOCAL oXmlDomDoc, oXmlSchema, oXmlErro, cRetorno := "ERRO"

   hb_Default( @cFileXsd, "" )

   IF " <" $ cXml .OR. "> " $ cXml
      RETURN "Espaços inválidos no XML entre as tags"
   ENDIF

   IF Empty( cFileXsd )
      RETURN SmallValidate( cXml )
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

STATIC FUNCTION SoapUrlBpe( aSoapList, cUF, cVersao )

   LOCAL nPos, cUrl

   nPos := AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlNfe( aSoapList, cUF, cVersao )

   LOCAL nPos, cUrl

   nPos := AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF
   DO CASE
   CASE ! Empty( cUrl )
   CASE cUf $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO"
      cURL := SoapURLNFe( aSoapList, "SVRS", cVersao )
   CASE cUf $ "MA,PA,PI"
      cURL := SoapUrlNFe( aSoapList, "SVAN", cVersao )
   ENDCASE

   RETURN cUrl

STATIC FUNCTION SoapUrlCte( aSoapList, cUF, cVersao )

   LOCAL nPos, cUrl

   nPos := AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF
   IF Empty( cUrl )
      IF cUF $ "AP,PE,RR"
         cUrl := SoapUrlCTe( aSoapList, "SVSP", cVersao )
      ELSEIF cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
         cUrl := SoapUrlCTe( aSoapList, "SVRS", cVersao )
      ENDIF
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlMdfe( aSoapList, cUF, cVersao )

   LOCAL cUrl, nPos

   nPos := AScan( aSoapList, { | e | cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF
   HB_SYMBOL_UNUSED( cUF )

   RETURN cUrl

STATIC FUNCTION SoapUrlNFCe( aSoapList, cUf, cVersao )

   LOCAL cUrl, nPos

   IF cUF $ "AC,ES,RO,RR"
      cUrl := SoapUrlNFCe( aSoapList, "SVRS", cVersao  )
   ELSE
      nPos := AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao + "C" == e[ 2 ] } )
      IF nPos != 0
         cUrl := aSoapList[ nPos, 3 ]
      ENDIF
   ENDIF
   IF Empty( cUrl )
      cUrl := SoapUrlNFe( aSoapList, cUF, cVersao )
   ENDIF

   RETURN cUrl

STATIC FUNCTION GeraQRCode( cXmlAssinado, cIdToken, cCSC, cVersao, cVersaoQrCode )

   LOCAL QRCODE_cTag, QRCODE_Url, QRCODE_chNFe, QRCODE_nVersao, QRCODE_tpAmb
   LOCAL QRCODE_cDest, QRCODE_dhEmi, QRCODE_vNF, QRCODE_vICMS, QRCODE_digVal
   LOCAL QRCODE_cIdToken, QRCODE_cCSC, QRCODE_cHash, QRCODE_UrlChave, QRCODE_tpEmis
   LOCAL cInfNFe, cSignature, cAmbiente, cUF, nPos
   LOCAL aUrlList := WS_NFE_QRCODE

   hb_Default( @cIdToken, StrZero( 0, 6 ) )
   hb_Default( @cCsc, StrZero( 0, 36 ) )
   hb_Default( @cVersaoQRCode, "2.00" )

   cInfNFe    := XmlNode( cXmlAssinado, "infNFe", .T. )
   cSignature := XmlNode( cXmlAssinado, "Signature", .T. )

   cAmbiente  := XmlNode( XmlNode( cInfNFe, "ide" ), "tpAmb" )
   cUF        := UFSigla( XmlNode( XmlNode( cInfNFe, "ide" ), "cUF" ) )

   // 1¦ Parte ( Endereco da Consulta - Fonte: http://nfce.encat.org/desenvolvedor/qrcode/ )
   nPos       := AScan( aUrlList, { | e | e[ 1 ] == cUF .AND. ;
      ( e[ 2 ] == cVersao + iif( cAmbiente == WS_AMBIENTE_HOMOLOGACAO, "H", "P" ) .OR. ;
      e[ 2 ] == "4.00"  + iif( cAmbiente == WS_AMBIENTE_HOMOLOGACAO, "H", "P" ) ) } )
   QRCode_Url := iif( nPos == 0, "", aUrlList[ nPos, 3 ] )

   // 2¦ Parte (Parametros)
   QRCODE_chNFe    := AllTrim( Substr( XmlElement( cInfNFe, "Id" ), 4 ) )
   QRCODE_nVersao  := SoNumeros( cVersaoQRCode )
   QRCODE_tpAmb    := cAmbiente
   QRCODE_cDest    := XmlNode( XmlNode( cInfNFe, "dest" ), "CPF" )
   IF Empty( QRCODE_cDest )
      QRCODE_cDest := XmlNode( XmlNode( cInfNFe, "dest" ), "CNPJ" )
   ENDIF

   QRCODE_dhEmi    := XmlNode( XmlNode( cInfNFe, "ide" ), "dhEmi" )
   QRCODE_vNF      := XmlNode( XmlNode( XmlNode( cInfNFe, "total" ), "ICMSTot" ), "vNF" )
   QRCODE_vICMS    := XmlNode( XmlNode( XmlNode( cInfNFe, "total" ), "ICMSTot" ), "vICMS" )
   QRCODE_digVal   := hb_StrToHex( XmlNode( XmlNode( XmlNode( cSignature, "SignedInfo" ), "Reference" ), "DigestValue" ) )
   QRCODE_cIdToken := cIdToken
   QRCODE_cCSC     := cCsc
   QRCODE_tpEmis   := XmlNode( XmlNode( cInfNFe, "ide" ), "tpEmis" )

   IF ! Empty( QRCODE_chNFe ) .AND. ! Empty( QRCODE_nVersao ) .AND. ! Empty( QRCODE_tpAmb ) .AND. ! Empty( QRCODE_dhEmi ) .AND. !Empty( QRCODE_vNF ) .AND. ;
         ! Empty( QRCODE_vICMS ) .AND. ! Empty( QRCODE_digVal  ) .AND. ! Empty( QRCODE_cIdToken ) .AND. ! Empty( QRCODE_cCSC  )

      IF cVersaoQRCode == "2.00"
         IF QRCODE_tpEmis != "9"
            QRCODE_chNFe    := QRCODE_chNFe    + "|"
            QRCODE_nVersao  := "2"             + "|"
            QRCODE_tpAmb    := QRCODE_tpAmb    + "|"
            QRCODE_cIdToken := Ltrim( Str( Val( QRCODE_cIdToken ), 16, 0 ) )

            // 3¦ Parte (cHashQRCode)
            QRCODE_cHash := ( "|" + Upper( hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cIdToken + QRCODE_cCSC ) ) )

            // Resultado da URL formada a ser incluida na imagem QR Code
            QRCODE_cTag  := "<![CDATA[" + QRCODE_Url + "p=" + QRCODE_chNFe + QRCODE_nVersao + ;
               QRCODE_tpAmb + QRCODE_cIdToken  + QRCODE_cHash + "]]>"
         ELSE
            QRCODE_chNFe    := QRCODE_chNFe                  + "|"
            QRCODE_nVersao  := "2"                            + "|"
            QRCODE_tpAmb    := QRCODE_tpAmb                   + "|"
            QRCODE_dhEmi    := Substr( QRCODE_dhEmi, 9, 2 ) + "|"
            QRCODE_vNF      := QRCODE_vNF                     + "|"
            QRCODE_digVal   := QRCODE_digVal                  + "|"
            QRCODE_cIdToken := LTrim( Str( Val( QRCODE_cIdToken ), 16, 0 ) )
            QRCODE_cCSC     := QRCODE_cCSC

            // 3¦ Parte (cHashQRCode)
            //QRCODE_cHash := ( "|" + Upper(hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_dhEmi + QRCODE_vNF + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cCSC ) ) )

            QRCODE_cHash := Upper( hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_dhEmi + QRCODE_vNF + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cCSC ) )

            // Resultado da URL formada a ser incluida na imagem QR Code
            QRCODE_cTag  := "<![CDATA[" + QRCODE_Url + "p=" + QRCODE_chNFe + QRCODE_nVersao + ;
               QRCODE_tpAmb + QRCODE_dhEmi + QRCODE_vNF + QRCODE_digVal + QRCODE_cIdToken + "|" + ;
               QRCODE_cHash + "]]>"
         ENDIF
      ELSE
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
         QRCODE_cHash := ( "&cHashQRCode=" + ;
            hb_SHA1( QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cCSC ) )

         // Resultado da URL formada a ser incluida na imagem QR Code
         QRCODE_cTag  := "<![CDATA[" + QRCODE_Url + QRCODE_chNFe + QRCODE_nVersao + ;
            QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + ;
            QRCODE_digVal + QRCODE_cIdToken + QRCODE_cHash + "]]>"

      ENDIF

      // XML com a Tag do QRCode
      cXmlAssinado := [<NFe xmlns="http://www.portalfiscal.inf.br/nfe">]
      cXmlAssinado += cInfNFe
      cXmlAssinado += [<] + "infNFeSupl"+[>]
      cXmlAssinado += [<] + "qrCode"+[>] + QRCODE_cTag + [</] + "qrCode" + [>]

      IF cVersao == "4.00"
         aUrlList := WS_NFE_CHAVE
         nPos     := AScan( aUrlList, { | e | e[ 1 ] == cUF .AND. ;
            e[ 2 ] == cVersaoQrCode + iif( cAmbiente == WS_AMBIENTE_HOMOLOGACAO, "H", "P" ) } )
         QRCode_UrlChave := iif( nPos == 0, "", aUrlList[ nPos, 3 ] )
         cXmlAssinado += XmlTag( "urlChave", QRCode_UrlChave )
      ENDIF

      cXmlAssinado += [</] + "infNFeSupl"+[>]
      cXmlAssinado += cSignature
      cXmlAssinado += [</NFe>]
   ELSE
      RETURN "Erro na geracao do QRCode"
   ENDIF

   RETURN "OK"

STATIC FUNCTION SmallValidate( cXml )

   LOCAL nPos, aTagsAbre := {}, cTmp, oElement
   MEMVAR cTxtErro
   PRIVATE cTxtErro := ""

   DO WHILE .T.
      nPos := hb_At( "<", cXml, nPos )
      IF nPos < 1
         EXIT
      ENDIF
      IF Substr( cXml, nPos + 1, 1 ) == "/"
         IF ! ProcFecha( Substr( cXml, nPos, hb_At( ">", cXml, nPos ) - nPos ), aTagsAbre )
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
      cTxtErro += "Em aberto" + Space(3)
      FOR EACH oElement IN aTagsAbre
         cTxtErro += oElement + Space(3)
      NEXT
      RETURN "*ERRO* " + cTxtErro
   ENDIF

   RETURN "OK"

FUNCTION ProcFecha( cTag, aTagsAbre )

   LOCAL oElement
   MEMVAR cTxtErro

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
         cTxtErro += "erro fechada " + cTag + " esperada " + Atail( aTagsAbre ) + Space(3)
      ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.
