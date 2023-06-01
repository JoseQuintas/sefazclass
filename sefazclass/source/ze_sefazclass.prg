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

#define WS_BPE_DEFAULT  "1.00"
#define WS_NFE_DEFAULT  "4.00"
#define WS_CTE_DEFAULT  "3.00"
#define WS_MDFE_DEFAULT "3.00"

FUNCTION SefazClassValidaXml( cXml, cXsd )

   LOCAL oSefaz := SefazClass():New()

   RETURN oSefaz:ValidaXml( cXml, cXsd )

FUNCTION SefazClassTipoXml( cXml )

   LOCAL oSefaz := SefazClass():New()

   RETURN oSefaz:TipoXml( cXml )

CREATE CLASS SefazClass

   /* configuração */
   VAR    cProjeto        INIT NIL
   VAR    cAmbiente       INIT WS_AMBIENTE_PRODUCAO
   VAR    cVersao         INIT NIL
   VAR    cVersaoQrCode   INIT "2.00"                  // Versao do QRCode
   VAR    cScan           INIT "N"                     // Indicar SCAN/SVAN/SVRS testes iniciais
   VAR    cUF             INIT "SP"                    // Modificada conforme método
   VAR    cCertificado    INIT ""                      // CN (NOME) do certificado
   VAR    lEmitenteCPF    INIT .F.                     // Para o caso de CPF ao invés de CNPJ
   VAR    ValidFromDate   INIT ""                      // Validade do certificado
   VAR    ValidToDate     INIT ""                      // Validade do certificado
   VAR    cIndSinc        INIT WS_RETORNA_RECIBO       // Poucas UFs opção de protocolo
   VAR    nTempoEspera    INIT 10                      // intervalo entre envia lote e consulta recibo
   VAR    nSoapTimeOut    INIT 15000                  // Limite de espera por resposta em segundos * 1000
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
   METHOD CTeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )
   METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente )
   METHOD CTeEventoDesacordo( cChave, nSequencia, cObs, cCertificado, cAmbiente )
   METHOD CTeEventoEntrega( cChave, nSequencia, nProt, dDataEntrega, cHoraEntrega, cDoc, cNome, aNfeList, nLatitude, nLongitude, cStrImagem, cCertificado, cAmbiente )
   METHOD CTeEventoCancEntrega( cChave, nSequencia, nProt, nProtEntrega, cCertificado, cAmbiente )
   METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD CTeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD MDFeConsNaoEnc( CUF, cCNPJ , cCertificado, cAmbiente )
   METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD MDFeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )
   METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD MDFeEventoEncerramento( cChave, nSequencia, nProt, cUFFim, cMunCarrega, cCertificado, cAmbiente )
   METHOD MDFeEventoInclusaoCondutor( cChave, nSequencia, cNome, cCpf, cCertificado, cAmbiente )
   METHOD MDFeEventoPagamento( cChave, nSequencia, cXmlPagamento, cCertificado, cAmbiente )
   METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   //METHOD MDFeRecepcaoSinc( cXml, cUF, cCertificado, cAmbiente )
   METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente )

   METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente )

   // hb_MemoWrit( "arquivo.zip", XmlNode( ::cXmlRetorno, "docZip" ) )
   METHOD NFeDownload( cCnpj, cChave, cCertificado, cAmbiente ) INLINE ::NfeDistribuicaoDfe( cCnpj, "", "", cChave, ::UFCodigo( Left( cChave, 2 ) ), cCertificado, cAmbiente )

   //METHOD NFeConsultaDest( cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente )
   METHOD NFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cChave, cUF, cCertificado, cAmbiente )
   METHOD NFeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente )
   METHOD NFeEventoAutor( cChave, cCnpj, cOrgaoAutor, ctpAutor, cverAplic, cAutorCnpj, ctpAutorizacao, cCertificado, cAmbiente )
   METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD NFeEventoCancelaSubstituicao( cChave, cOrgaoAutor, cAutor, cVersaoAplicativo, cProtocolo, cJust, cNfRef, cCertificado, cAmbiente )
   METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente )
   METHOD NFeEventoManifestacao( cChave, cCnpj, cCodigoEvento, xJust, cCertificado, cAmbiente )
   METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc )
   METHOD NFeStatusServico( cUF, cCertificado, cAmbiente )
   METHOD NFeStatusServicoSVC( cUF, cCertificado, cAmbiente, lSVCAN )
   METHOD NFeContingencia( cXml, cUF, cCertificado, cAmbiente )
   METHOD NFeConsultaGTIN( cGTIN, cCertificado )

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

METHOD BPeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
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

   hb_Default( @::cVersao, WS_BPE_DEFAULT )
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

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
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

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
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

METHOD CTeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @nSequencia, 1 )
   ::aSoapUrlList := WS_CTE_ENVIAEVENTO
   ::cSoapAction  := "cteRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlDocumento := [<eventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       cXml
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

METHOD CTeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancCTe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt, 16 ) ) )
   cXml +=       XmlTag( "xJust", xJust )
   cXml +=    [</evCancCTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL oElement, cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=      [<evCCeCTe>]
   cXml +=          XmlTag( "descEvento", "Carta de Correcao" )
   FOR EACH oElement IN aAlteracoes
      cXml +=       [<infCorrecao>]
      cXml +=          XmlTag( "grupoAlterado", oElement[ 1 ] )
      cXml +=          XmlTag( "campoAlterado", oElement[ 2 ] )
      cXml +=          XmlTag( "valorAlterado", oElement[ 3 ] )
      cXml +=       [</infCorrecao>]
   NEXT
   cXml +=       [<xCondUso>]
   cXml +=          "A Carta de Correcao e disciplinada pelo Art. 58-B "
   cXml +=          "do CONVENIO/SINIEF 06/89: Fica permitida a utilizacao de carta "
   cXml +=          "de correcao, para regularizacao de erro ocorrido na emissao de "
   cXml +=          "documentos fiscais relativos a prestacao de servico de transporte, "
   cXml +=          "desde que o erro nao esteja relacionado com: I - as variaveis que "
   cXml +=          "determinam o valor do imposto tais como: base de calculo, aliquota, "
   cXml +=          "diferenca de preco, quantidade, valor da prestacao;II - a correcao "
   cXml +=          "de dados cadastrais que implique mudanca do emitente, tomador, "
   cXml +=          "remetente ou do destinatario;III - a data de emissao ou de saida."
   cXml +=       [</xCondUso>]
   cXml +=    [</evCCeCTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110110", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeEventoDesacordo( cChave, nSequencia, cObs, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evPrestDesacordo>]
   cXml +=       XmlTag( "descEvento", "Prestacao do Servico em Desacordo" )
   cXml +=       XmlTag( "indDesacordoOper", "1" )
   cXml +=       XmlTag( "xObs", cObs )
   cXml +=    [</evPrestDesacordo>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "610110", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeEventoEntrega( cChave, nSequencia, nProt, dDataEntrega, cHoraEntrega, cDoc, cNome, aNfeList, nLatitude, nLongitude, cStrImagem, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL oElement, cXml := "", cHash

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cHash := hb_Sha1( cChave + hb_Base64Encode( cStrImagem ), .T. )
   cHash := hb_Base64Encode( cHash )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCECTe>]
   cXml +=       XmlTag( "descEvento", "Comprovante de Entrega do CT-e" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "dhEntrega", DateTimeXml( dDataEntrega, cHoraEntrega, ::cUF ) )
   cXml +=       XmlTag( "nDoc", cDoc )
   cXml +=       XmlTag( "xNome", cNome )
   IF nLatitude != 0 .AND. nLongitude != 0
      cXml +=    XmlTag( "latitude", NumberXml( nLatitude, 16, 6 ) )
      cXml +=    XmlTag( "longitude", NumberXml( nLongitude, 16, 6 ) )
   ENDIF
   IF .F. // hash da imagem que não existe no xml ?????
      cXml +=    XmlTag( "hashEntrega", cHash )
      cXml +=    XmlTag( "dhHashEntrega", DateTimeXml( Date(), Time(), ::cUF ) )
   ENDIF
   IF Len( aNfeList ) > 0
      cXml +=    "<InfEntrega>"
      FOR EACH oElement IN aNfeList
         cXml +=    XmlTag( "chNFe", oElement )
      NEXT
      cXml +=    "</InfEntrega>"
   ENDIF
   cXml +=    [</evCECTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110180", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeEventoCancEntrega( cChave, nSequencia, nProt, nProtEntrega, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancCECTe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento do Comprovante de Entrega do CT-e" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "nProtCE", LTrim( Str( nProtEntrega ) ) )
   cXml +=    [</evCancCECTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110181", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSE
      ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF
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
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
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
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
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

   LOCAL oDoc, cBlocoXml, aList, cURLConsulta := "http:", nPos

   hb_Default( @::cProjeto, WS_PROJETO_CTE )
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
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

   oDoc := XmlToDoc( cXml, .F. )
   aList := WS_CTE_QRCODE
   nPos := hb_ASCan( aList, { | e | e[ 1 ] == DfeUF( oDoc:cChave ) .AND. e[ 2 ] == ::cVersao + iif( oDoc:cAmbiente == "1", "P", "H" ) } )
   IF nPos != 0
      cURLConsulta := aList[ nPos, 3 ]
   ENDIF
	cBlocoXml := "<infCTeSupl>"
	cBlocoXml += "<qrCodCTe>"
	cBlocoXml += "<![CDATA["
	cBlocoXml += cURLConsulta + "?chCTe=" + oDoc:cChave + "&" + "tpAmb=" + oDoc:cAmbiente
	cBlocoXml += "]]>"
	cBlocoXml += "</qrCodCTe>"
	cBlocoXml += "</infCTeSupl>"
	::cXmlDocumento := StrTran( ::cXmlDocumento, "</infCte>", "</infCte>" + cBlocoXml )

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

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
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

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   ::cSoapAction  := "mdfeConsNaoEnc"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsNaoEnc"
   ::aSoapUrlList := WS_MDFE_CONSULTANAOENCERRADOS
   ::Setup( cUF, cCertificado, cAmbiente )

   ::cXmlEnvio := [<consMDFeNaoEnc versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "CONSULTAR NÃO ENCERRADOS" )
   ::cXmlEnvio +=    XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), cCNPJ )
   ::cXmlEnvio += [</consMDFeNaoEnc>]
   ::XmlSoapPost()
   IF ::cStatus != "999"
      ::cStatus := Pad( XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "cStat" ), 3 )
      ::cMotivo := XmlNode( XmlNode( ::cXmlRetorno , "retConsMDFeNaoEnc" ) , "xMotivo" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
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
   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
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
      IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
         ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
         ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
      ELSE
         ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )
         ::cMotivo  := XmlNode( ::cXmlRetorno, "xMotivo" )
      ENDIF
   ENDIF

   RETURN ::cXmlRetorno

   // 2016.01.31.2200 Iniciado apenas

METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
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

METHOD MDFeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   hb_Default( @nSequencia, 1 )

   ::aSoapUrlList := WS_MDFE_EVENTO
   ::cSoapAction  := "mdfeRecepcaoEvento"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento"
   ::Setup( cChave, cCertificado, cAmbiente )

   ::cXmlDocumento := [<eventoMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       cXml
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</eventoMDFe>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := ::cXmlDocumento
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::MDFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD MDFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evCancMDFe>]
   cXml +=       XmlTag( "descEvento", "Cancelamento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "xJust", xJust )
   cXml +=    [</evCancMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD MDFeEventoEncerramento( cChave, nSequencia, nProt, cUFFim , cMunCarrega , cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evEncMDFe>]
   cXml +=       XmlTag( "descEvento", "Encerramento" )
   cXml +=       XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=       XmlTag( "dtEnc", DateXml( Date() ) )
   cXml +=       XmlTag( "cUF", ::UFCodigo( cUFFim ) )
   cXml +=       XmlTag( "cMun", cMunCarrega )
   cXml +=    [</evEncMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110112", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD MDFeEventoInclusaoCondutor( cChave, nSequencia, cNome, cCpf, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=    [<evIncCondutorMDFe>]
   cXml +=       XmlTag( "descEvento", "Inclusao Condutor" )
   cXml +=       [<condutor>]
   cXml +=          XmlTag( "xNome", cNome )
   cXml +=          XmlTag( "CPF", cCPF)
   cXml +=       [</condutor>]
   cXml +=    [</evIncCondutorMDFe>]
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110114", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD MDFeEventoPagamento( cChave, nSequencia, cXmlPagamento, cCertificado, cAmbiente )

   LOCAL cXml := ""

   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml += cXmlPagamento
   cXml += [</detEvento>]

   ::MDFeEvento( cChave, nSequencia, "110116", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
      ::cStatus       := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
   ELSE
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
   ENDIF
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
   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
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

   LOCAL oDoc, cBlocoXml, aList, nPos, cURLConsulta := "http:"

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   hb_Default( @cLote, "1" )
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
   oDoc := XmlToDoc( cXml, .F. )
   aList := WS_MDFE_QRCODE
   nPos := hb_ASCan( aList, { | e | e[ 2 ] == ::cVersao + iif( oDoc:cAmbiente == "1", "P", "H" ) } )
   IF nPos != 0
      cURLConsulta := aList[ nPos, 3 ]
   ENDIF
   IF ! "<infMDFeSupl>" $ ::cXmlDocumento
      cBlocoXml := "<infMDFeSupl>"
      cBlocoXml += "<qrCodMDFe>"
      cBlocoXml += "<![CDATA["
      cBlocoXml += cURLConsulta + "?chMDFe=" + oDoc:cChave + "&" + "tpAmb=" + ::cAmbiente
      cBlocoXml += "]]>"
      cBlocoXml += "</qrCodMDFe>"
      cBlocoXml += "</infMDFeSupl>"
      ::cXmlDocumento := StrTran( ::cXmlDocumento, "</infMDFe>", "</infMDFe>" + cBlocoXml )
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

// METHOD MDFeRecepcaoSinc( cXml, cUF, cCertificado, cAmbiente ) CLASS SefazClass
//
//   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
//   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
//   ::aSoapUrlList := WS_MDFE_RECEPCAOSINC
//   ::Setup( cUF, cCertificado, cAmbiente )
//   ::cSoapAction := ""
//   ::cSoapService := ""
//
//   IF cXml != NIL
//      ::cXmlDocumento := cXml
//   ENDIF
//   IF ::AssinaXml() != "OK"
//      RETURN ::cXmlRetorno
///   ENDIF
//   ::cXmlEnvio := "falta definir aqui"
//   ::XmlSoapPost()
//   IF ::cXmlStatus != "999"
//      ::cStatus := XmlNode( ::cXmlRetorno, "cStatus" )
//      ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
//      ::MDFeGeraAutorizado( ::cXmlDocumento, ::cXmlRetorno )
//   ENDIF

//   RETURN ::cXmlRetorno

METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_MDFE )
   hb_Default( @::cVersao, WS_MDFE_DEFAULT )
   ::aSoapUrlList := WS_MDFE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "mdfeStatusServicoMDF"
   ::cSoapService := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico"

   ::cXmlEnvio := [<consStatServMDFe versao="] + ::cVersao + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   //::cXmlEnvio += XmlTag( "cUF", ::UFCodigo( ::cUF ) ) // MDFE não importa UF
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServMDFe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::aSoapUrlList := WS_NFE_CONSULTACADASTRO
   ::Setup( cUF, cCertificado, cAmbiente )
   IF ::cUF $ "AM,BA,MG,PE"
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

METHOD NFeConsultaGTIN( cGTIN, cCertificado ) CLASS SefazClass

   ::cProjeto     := WS_PROJETO_NFE
   ::aSoapUrlList := WS_NFE_CONSULTAGTIN
   ::cVersao      := "1.00"
   ::Setup( ::cUF, cCertificado )
   ::cSoapAction := "ccgConsGTIN"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/ccgConsGtin"

   ::cXmlEnvio := [<consGTIN versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlEnvio += [<GTIN>] + AllTrim( cGTIN ) + [</GTIN>]
   ::cXmlEnvio += [</consGTIN>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_CONSULTAPROTOCOLO
   ::Setup( cChave, cCertificado, cAmbiente )
   DO CASE
   CASE ::cUF $ "AC,AL,AP,DF,ES,MS,PB,PE,PI,RJ,RN,RO,RR,SC,SE,TO" // TODOS que usam SVRS
      IF ::cUF == "MS" .AND. DfeModFis( cChave ) == "65"
         ::cSoapAction := "NfeConsultaProtocolo"
      ELSE
         ::cSoapAction := "nfeConsultaNF"
      ENDIF
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeConsultaProtocolo4"
   OTHERWISE
      ::cSoapAction := "nfeConsultaNF"
      ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaProtocolo4"
   ENDCASE
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
   hb_Default( @cUF, "" )

   ::aSoapUrlList := WS_NFE_DISTRIBUICAO
   ::Setup( "AN", cCertificado, cAmbiente )
   ::cSoapAction  := "nfeDistDFeInteresse"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe"
   ::cXmlEnvio    := [<distDFeInt ] + WS_XMLNS_NFE + [ versao="1.01">]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   IF ! Empty( cUF )
      ::cXmlEnvio    +=    XmlTag( "cUFAutor", ::UFCodigo( cUF ) )
   ENDIF
   ::cXmlEnvio    +=    XmlTag( "CNPJ", StrZero( Val( cCnpj ), 14 ) ) // ou CPF
   IF ! Empty( cChave )
      ::cXmlEnvio += [<consChNFe>]
      ::cXmlEnvio +=    XmlTag( "chNFe", cChave )
      ::cXmlEnvio += [</consChNFe>]
   ELSEIF ! Empty( cNSU )
      ::cXmlEnvio +=   [<consNSU>]
      ::cXmlEnvio +=      XmlTag( "NSU", StrZero( Val( cNSU ), 15 ) )
      ::cXmlEnvio +=   [</consNSU>]
   ELSE
      ::cXmlEnvio +=   [<distNSU>]
      ::cXmlEnvio +=      XmlTag( "ultNSU", StrZero( Val( cUltNSU ), 15 ) )
      ::cXmlEnvio +=   [</distNSU>]
   ENDIF
   ::cXmlEnvio   += [</distDFeInt>]
   ::XmlSoapPost()
   IF ! Empty( XmlNode( ::cXmlRetorno, "cStat" ) )
      ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente ) CLASS Sefazclass

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @nSequencia, 1 )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   IF ::cUF $ "MS"
      ::cSoapAction  := "RecepcaoEvento"
   ELSE
      ::cSoapAction  := "nfeRecepcaoEvento"
   ENDIF
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4"
   ::Setup( cChave, cCertificado, cAmbiente )
   ::cXmlDocumento := [<evento versao="1.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cTipoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), DfeEmitente( cChave ) )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cTipoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       cXml
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NfeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoAutor( cChave, cCnpj, cOrgaoAutor, ctpAutor, cverAplic, cAutorCnpj, ctpAutorizacao, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cDescEvento

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cCnpj, "00000000000000" )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   ::cUF          := "AN"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4"
   ::cSoapAction  := "nfeRecepcaoEventoNF"
   ::Setup( "AN", cCertificado, cAmbiente )

   cDescEvento := "Ator interessado na NF-e"

   ::cXmlDocumento := [<evento versao="1.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110150] + cChave + "01" + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", "91" )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), cCnpj )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110150" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", "1" ) // obrigatoriamente 1
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       [<detEvento versao="1.00">]
   ::cXmlDocumento +=          XmlTag( "descEvento", cDescEvento )
   ::cXmlDocumento +=          XmlTag( "cOrgaoAutor", cOrgaoAutor )
   ::cXmlDocumento +=          XmlTag( "tpAutor", ctpAutor ) // 1-Emitente, 2=Destinat, 3=Transp
   ::cXmlDocumento +=          XmlTag( "verAplic", cverAplic ) // versao aplicativo
   ::cXmlDocumento +=          [<autXML>]
   ::cXmlDocumento +=          XmlTag( iif( Len( cAutorCnpj ) == 14, "CNPJ", "CPF" ), cAutorCnpj )
   ::cXmlDocumento +=          XmlTag( "tpAutorizacao", ctpAutorizacao ) // 0=direto, 1=permite autorizar outros
   IF ctpAutorizacao == "1"
      ::cXmlDocumento +=       XmlTag( "xCondUso", "O emitente ou destinatario" + ;
         " da NF-e, declara que permite o transportador declarado no campo CNPJ/CPF" + ;
         " deste evento a autorizar os transportes subcontratados ou redespachados" + ;
         " a terem acesso ao download da NF-e" )
   ENDIF
   ::cXmlDocumento +=          [</autXML>]
   ::cXmlDocumento +=       [</detEvento>]
   ::cXmlDocumento +=    [</infEvento>]
   ::cXmlDocumento += [</evento>]
   IF ::AssinaXml() == "OK"
      ::cXmlEnvio := [<envEvento versao="1.00" ] + WS_XMLNS_NFE + [>]
      ::cXmlEnvio +=    XmlTag( "idLote", DfeNumero( cChave ) ) // usado numero da nota
      ::cXmlEnvio +=    ::cXmlDocumento
      ::cXmlEnvio += [</envEvento>]
      ::XmlSoapPost()
      ::cXmlProtocolo := ::cXmlRetorno
      ::NFeGeraEventoAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
   ENDIF

   RETURN ::cXmlRetorno

METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   cXml += [<detEvento versao="1.00">]
   cXml +=    XmlTag( "descEvento", "Carta de Correcao" )
   cXml +=    XmlTag( "xCorrecao", cTexto )
   cXml +=    [<xCondUso>]
   cXml +=    "A Carta de Correcao e disciplinada pelo paragrafo 1o-A do art. 7o do Convenio S/N, "
   cXml +=    "de 15 de dezembro de 1970 e pode ser utilizada para regularizacao de erro ocorrido na "
   cXml +=    "emissao de documento fiscal, desde que o erro nao esteja relacionado com: "
   cXml +=    "I - as variaveis que determinam o valor do imposto tais como: base de calculo, aliquota, "
   cXml +=    "diferenca de preco, quantidade, valor da operacao ou da prestacao; "
   cXml +=    "II - a correcao de dados cadastrais que implique mudanca do remetente ou do destinatario; "
   cXml +=    "III - a data de emissao ou de saida."
   cXml +=    [</xCondUso>]
   cXml += [</detEvento>]

   ::NFeEvento( cChave, nSequencia, "110110", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   cXml += [<detEvento versao="1.00">]
   cXml +=    XmlTag( "descEvento", "Cancelamento" )
   cXml +=    XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=    XmlTag( "xJust", xJust )
   cXml += [</detEvento>]

   ::NFeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD NFeEventoCancelaSubstituicao( cChave, cOrgaoAutor, cAutor, cVersaoAplicativo, cProtocolo, cJust, cNFRef, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := "", nSequencia := 1

   cXml += [<detEvento versao="1.00">]
   cXml +=    XmlTag( "descEvento", "Cancelamento por substituicao" ) // acentos?
   cXml +=    XmlTag( "cOrgaoAutor", cOrgaoAutor )
   cXml +=    XmlTag( "tpAutor", cAutor )
   cXml +=    XmlTag( "verAplic", cVersaoAplicativo )
   cXml +=    XmlTag( "nProt", cProtocolo )
   cXml +=    XmlTag( "xJust", cJust )
   cXml +=    XmlTag( "chNFeRef", cNfRef )
   cXml += [</detEvento>]

   ::NFeEvento( cChave, nSequencia, "110112", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD NFeEventoManifestacao( cChave, cCnpj, cCodigoEvento, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cDescEvento

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cCnpj, "00000000000000" )
   ::cNFCe := iif( DfeModFis( cChave ) == "65", "S", "N" )
   ::aSoapUrlList := WS_NFE_EVENTO
   ::cUF          := "AN"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRecepcaoEvento4"
   ::cSoapAction  := "nfeRecepcaoEventoNF"
   ::Setup( "AN", cCertificado, cAmbiente )

   DO CASE
   CASE cCodigoEvento == "210200" ; cDescEvento := "Confirmacao da Operacao"
   CASE cCodigoEvento == "210210" ; cDescEvento := "Ciencia da Operacao"
   CASE cCodigoEvento == "210220" ; cDescEvento := "Desconhecimento da Operacao"
   CASE cCodigoEvento == "210240" ; cDescEvento := "Operacao nao Realizada"
   ENDCASE

   ::cXmlDocumento := [<evento versao="1.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cCodigoEvento + cChave + "01" + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", "91" )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( iif( ::lEmitenteCPF, "CPF", "CNPJ" ), cCnpj )
   ::cXmlDocumento +=       XmlTag( "chNFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", cCodigoEvento )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", "1" ) // obrigatoriamente 1
   ::cXmlDocumento +=       XmlTag( "verEvento", "1.00" )
   ::cXmlDocumento +=       [<detEvento versao="1.00">]
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
      ::cXmlEnvio := [<envEvento versao="1.00" ] + WS_XMLNS_NFE + [>]
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
   IF ::cUF == "MS"
      ::cSoapAction := "NfeInutilizacao"
   ELSE
      ::cSoapAction := "nfeInutilizacaoNF"
   ENDIF
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeInutilizacao4"

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

   LOCAL oDoc, cChave

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cIndSinc, ::cIndSinc )

   ::aSoapUrlList := WS_NFE_AUTORIZACAO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "nfeAutorizacaoLote"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4"

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
         IF hb_ASCan( { "104", "105" }, ::cStatus,,, .T. ) != 0
            oDoc   := XmlToDoc( ::cXmlDocumento, .F. )
            cChave := oDoc:cChave
            Inkey( ::nTempoEspera )
            ::NfeConsultaProtocolo( cChave, ::cUF, ::cCertificado, ::cAmbiente )
            IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
               ::cXmlProtocolo := ::cXmlRetorno
            ENDIF
         ENDIF
         ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
      ENDIF
   ELSE
      ::cXmlRecibo := ::cXmlRetorno
      ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
      ::cStatus    := Pad( XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "cStat" ), 3 )
      ::cMotivo    := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )
      IF Empty( ::cStatus )
         ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStatus" ), 3 )
         ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )
      ENDIF
      IF ::cStatus != "999"
         //IF ! Empty( ::cRecibo )
            ::cXmlProtocolo := ::cXmlRetorno
            ::cXmlRetorno   := ::NfeGeraAutorizado( ::cXmlDocumento, ::cXmlProtocolo )
         //ENDIF
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
   ::cSoapAction  := "nfeRetAutorizacaoLote"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4"

   ::cXmlEnvio     := [<consReciNFe versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio     += [</consReciNFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   IF ! Empty( XmlNode( ::cXmlRetorno, "infProt" ) )
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
   IF ::cUF $ 'MS' .AND. ::cNFCE == "S" //a MS status NFC e NFE é diferente o cSoapAction, tive que controlar
      ::cSoapAction  := "NfeStatusServico"
   ELSE
      ::cSoapAction  := "nfeStatusServicoNF"
   ENDIF
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4"

   ::cXmlEnvio    := [<consStatServ versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
   ::XmlSoapPost()
   ::cStatus := Pad( XmlNode( ::cXmlRetorno, "cStat" ), 3 )

   RETURN ::cXmlRetorno

METHOD NFeStatusServicoSVC( cUF, cCertificado, cAmbiente, lSVCAN ) CLASS SefazClass

   LOCAL cVersao

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )

   cVersao := ::cVersao + iif( ::cAmbiente == WS_AMBIENTE_PRODUCAO, "P", "H" )

   ::aSoapUrlList := WS_NFE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "NfeStatusServico"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4"

   IF lSVCAN
      ::cSoapURL  := SoapUrlNFe( ::aSoapUrlList, "SVCAN", cVersao )
   ELSE
      ::cSoapURL  := SoapURLNfe( ::aSoapUrlList, "SVCRS", cVersao )
   ENDIF

   ::cXmlEnvio    := [<consStatServ versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   LOCAL cValue

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlRetorno, cXmlProtocolo )

   IF [<infProt>] $ cXmlProtocolo
      cValue := XmlNode( XmlNode( cXmlProtocolo, "infProt" ), "nProt" )
      IF ! Empty( cValue )
         cXmlProtocolo := StrTran( cXmlProtocolo, [<infProt>], [<infProt Id="ID] + cValue + [">] )
      ENDIF
   ENDIF

   IF ! Empty( XmlNode( cXmlProtocolo, "infProt" ) )
      ::cStatus       := Pad( XmlNode( XmlNode( cXmlProtocolo, "infProt" ), "cStat" ), 3 )
      ::cMotivo       := XmlNode( XmlNode( cXmlProtocolo, "infProt" ), "xMotivo" )
   ELSE
      ::cStatus := Pad( XmlNode( cXmlProtocolo, "cStat" ), 3 )
      ::cMotivo := XmlNode( cXmlProtocolo, "xMotivo" )
   ENDIF
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := [<erro text="*ERRO* NFeGeraAutorizado() Não autorizado" />] + cXmlProtocolo
      RETURN Nil
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<nfeProc versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protNFe", .T. )
   ::cXmlAutorizado += [</nfeProc>]

   RETURN NIL

METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass // runner

   hb_Default( @::cProjeto, WS_PROJETO_NFE )
   hb_Default( @::cVersao, WS_NFE_DEFAULT )

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
   ::cXmlAutorizado += [<procEventoNFe versao="1.00" ] + WS_XMLNS_NFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEvento versao="1.00">]
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
   IF ::cSoapAction != "nfeDistDFeInteresse" .AND. ::cSoapAction != "ccgConsGTIN"
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

STATIC FUNCTION SoapUrlBpe( aSoapList, cUF, cVersao )

   LOCAL nPos, cUrl

   nPos := hb_AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlNfe( aSoapList, cUF, cVersao )

   LOCAL nPos, cUrl

   nPos := hb_AScan( aSoapList, { | e | ( cUF == e[ 1 ] .OR. e[ 1 ] == "**" ) .AND. cVersao == e[ 2 ] } )
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

   nPos := hb_AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao == e[ 2 ] } )
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

   nPos := hb_AScan( aSoapList, { | e | cVersao == e[ 2 ] } )
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
      nPos := hb_AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao + "C" == e[ 2 ] } )
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
   nPos       := hb_AScan( aUrlList, { | e | e[ 1 ] == cUF .AND. ;
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
         nPos     := hb_AScan( aUrlList, { | e | e[ 1 ] == cUF .AND. ;
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
