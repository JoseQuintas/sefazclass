/*
ZE_SPEDSEFAZCLASS - Rotinas pra comunicação com SEFAZ
José Quintas

Nota: CTE 2.00 vale até 10/2017, CTE 2.00 até 12/2017, NFE 3.10 até 04/2018
*/

#include "hbclass.ch"
#include "sefazclass.ch"

CREATE CLASS SefazClass

   /* configuração */
   VAR    cProjeto       INIT WS_PROJETO_NFE          // Modificada conforme método
   VAR    cAmbiente      INIT WS_AMBIENTE_PRODUCAO
   VAR    cVersao        INIT "*DEFAULT*"             // Default NFE 3.10, MDFE 3.00, CTE 2.00 (Próximas 4.00,----,3.00)
   VAR    cScan          INIT "N"                     // Indicar se for SCAN/SVAN, ainda não testado
   VAR    cUF            INIT "SP"                    // Modificada conforme método
   VAR    cCertificado   INIT ""                      // Nome do certificado
   VAR    ValidFromDate  INIT ""                      // Validade do certificado
   VAR    ValidToDate    INIT ""                      // Validade do certificado
   VAR    cIndSinc       INIT WS_RETORNA_RECIBO  // Poucas UFs opção de protocolo
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
   VAR    cXmlNameSpace  INIT "xmlns="
   VAR    cNFCE          INIT "N"                     // Porque NFCE tem endereços diferentes

   //METHOD CTeConsulta( ... )   INLINE  ::CTeConsultaProtocolo( ... )    // Não usar, apenas compatibilidade
   //METHOD NFeConsulta( ... )   INLINE  ::NFeConsultaProtocolo( ... )    // Não usar, apenas compatibilidade
   //METHOD MDFeConsulta( ... )  INLINE  ::MDFeConsultaProtocolo( ... )   // Não usar, apenas compatibilidade
   //METHOD CTeStatus( ... )     INLINE  ::CTeStatusServico( ... )        // Não usar, apenas compatibilidade
   //METHOD NFeStatus( ... )     INLINE  ::NFeStatusServico( ... )        // Não usar, apenas compatibilidade
   //METHOD MDFeStatus( ... )    INLINE  ::MDFeStatusServico( ... )       // Não usar, apenas compatibilidade
   //METHOD NFeCadastro( ... )   INLINE  ::NFeConsultaCadastro( ... )     // Não usar, apenas compatibilidade
   //METHOD NFeEventoCCE( ... )  INLINE  ::NFeEventoCarta( ... )          // Não usar, apenas compatibilidade
   //METHOD CTeEventoCCE( ... )  INLINE  ::CTeEventoCarta( ... )

   METHOD BpeConsulta( cChave, cCertificado, cAmbiente )
   METHOD BpeStatusServico( cUF, cCertificado, cAmbiente )

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

METHOD BpeConsulta( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( ::UfSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_BPE_CONSULTA )
   ::cXmlEnvio    := [<consSitBPe> versao="] + WS_VERSAO_BPE + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio    +=   XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=   XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=   XmlTag( "chBPe", cChave )
   ::cXmlEnvio    += [</conssitBPe>]
   IF Substr( cChave, 21, 2 ) != "63"
      ::cXmlRetorno := "*ERRO* Chave não se refere a BPE"
   ELSE
      ::XmlSoapPost()
   ENDIF
   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

METHOD BpeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_BPE_STATUSSERVICO )

   ::cXmlEnvio := [<consStatServBPe versao="] + WS_VERSAO_BPE + [" ] + WS_XMLNS_BPE + [>]
   ::cXmlEnvio +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio += [</consStatServBPe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_CTE_CONSULTAPROTOCOLO )

   ::cSoapVersion := ::cVersao
   ::cXmlEnvio    := [<consSitCTe versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chCTe", cChave )
   ::cXmlEnvio    += [</consSitCTe>]
   IF ! Substr( cChave, 21, 2 ) $ "57,67"
      ::cXmlRetorno := "*ERRO* Chave não se refere a CTE"
   ELSE
      ::XmlSoapPost()
   ENDIF
   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::Setup( cUF, cCertificado, cAmbiente, WS_CTE_RETRECEPCAO )

   ::cSoapVersion  := ::cVersao
   ::cXmlEnvio     := [<consReciCTe versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
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
   ::cXmlDocumento := [<eventoCTe versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110111" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + WS_VERSAO_CTE + [">]
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
   ::cXmlDocumento := [<eventoCTe versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chCTe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml( , ,.F.) )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110110" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", LTrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + WS_VERSAO_CTE + [">]
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
   ::cXmlAutorizado += [<cteProc versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
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
   ::cXmlAutorizado += [<procEventoCTe versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoCTe versao="] + WS_VERSAO_CTE + [">]
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
   ::cXmlDocumento   := [<inutCTe versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
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
         ::cXmlAutorizado += [<ProcInutCTe versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
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
   ::cXmlEnvio    := [<enviCTe versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
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
   ::cXmlEnvio    := [<consStatServCte versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServCte>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD MDFeConsNaoEnc( cUF, cCNPJ , cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_CONSNAOENC )

   ::cXmlEnvio    := [<consMDFeNaoEnc versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
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

   ::cXmlEnvio    := [<consSitMDFe versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
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
   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::Setup( cUF, cCertificado, cAmbiente, WS_MDFE_RETRECEPCAO )

   ::cXmlEnvio    := [<consReciMDFe versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
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

   ::cXmlEnvio    := [<distDFeInt versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
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

   ::cXmlDocumento := [<eventoMDFe versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110111" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + WS_VERSAO_MDFE + [">]
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

   ::cXmlDocumento := [<eventoMDFe versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110112] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   ::cXmlDocumento +=       XmlTag( "chMDFe", cChave )
   ::cXmlDocumento +=       XmlTag( "dhEvento", ::DateTimeXml() )
   ::cXmlDocumento +=       XmlTag( "tpEvento", "110112" )
   ::cXmlDocumento +=       XmlTag( "nSeqEvento", Ltrim( Str( nSequencia, 4 ) ) )
   ::cXmlDocumento +=       [<detEvento versaoEvento="] + WS_VERSAO_MDFE + [">]
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
   ::cXmlAutorizado += [<mdfeProc versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
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
   ::cXmlAutorizado += [<procEventoMDFe versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoMDFe versao="] + WS_VERSAO_MDFE + [">]
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
   ::cXmlEnvio    := [<enviMDFe versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
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

   ::cXmlEnvio    := [<consStatServMDFe versao="] + WS_VERSAO_MDFE + [" ] + WS_XMLNS_MDFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServMDFe>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_CONSULTACADASTRO )

   ::cSoapVersion := "2.00"
   ::cXmlEnvio    := [<ConsCad versao="] + WS_VERSAO_NFE + [" ] + WS_XMLNS_NFE + [>]
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
   ::cXmlEnvio    := [<consNFeDest versao="] + WS_VERSAO_NFE + [">]
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
   ::cXmlEnvio    := [<consSitNFe versao="] + WS_VERSAO_NFE + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlEnvio    +=    XmlTag( "chNFe", cChave )
   ::cXmlEnvio    += [</consSitNFe>]
   IF ! Substr( cChave, 21, 2 ) $ "55,65"
      ::cXmlRetorno := "*ERRO* Chave não se refere a NFE"
   ELSE
      ::XmlSoapPost()
   ENDIF
   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   RETURN ::cXmlRetorno

/* 2015.07.31.1400 Iniciado apenas */
METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @cUltNSU, "0" )
   hb_Default( @cNSU, "" )

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

METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente ) CLASS SefazClass

   hb_Default( @nSequencia, 1 )

   ::Setup( ::UFSigla( Substr( cChave, 1, 2 ) ), cCertificado, cAmbiente, WS_NFE_RECEPCAOEVENTO )

   ::cXmlDocumento := [<evento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
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
      ::cXmlEnvio    := [<envEvento versao="] + WS_VERSAO_NFEEVENTO + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
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

   ::cXmlDocumento := [<evento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID110111] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
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
      ::cXmlEnvio    := [<envEvento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
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

   ::cXmlDocumento := [<evento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlDocumento +=    [<infEvento Id="ID] + cCodigoEvento + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDocumento +=       XmlTag( "cOrgao", Substr( cChave, 1, 2 ) )
   ::cXmlDocumento +=       XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDocumento +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
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
      ::cXmlEnvio    := [<envEvento versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
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
   ::cXmlDocumento := [<inutNFe versao="] + WS_VERSAO_NFE + [" ] + WS_XMLNS_NFE + [>]
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
         ::cXmlAutorizado += [<ProcInutNFe versao="] + WS_VERSAO_NFE + [" ] + WS_XMLNS_NFE + [>]
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
   ::cXmlEnvio    := [<enviNFe versao="] + WS_VERSAO_NFE + [" ] + WS_XMLNS_NFE + [>]
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

   IF cRecibo != NIL
      ::cRecibo := cRecibo
   ENDIF

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_RETAUTORIZACAO )

   ::cSoapVersion  := "3.10"
   ::cXmlEnvio     := [<consReciNFe versao="] + WS_VERSAO_NFE + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlEnvio     += [</consReciNFe>]
   ::XmlSoapPost()
   ::cXmlProtocolo := ::cXmlRetorno
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )

   RETURN ::cXmlRetorno

METHOD NFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   ::Setup( cUF, cCertificado, cAmbiente, WS_NFE_STATUSSERVICO )

   ::cSoapVersion := "3.10"
   ::cXmlEnvio    := [<consStatServ versao="] + WS_VERSAO_NFE + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
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
   ::cXmlAutorizado += [<nfeProc versao="] + WS_VERSAO_NFE + [" ] + WS_XMLNS_NFE + [>]
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
   ::cXmlAutorizado += [<procEventoNFe versao="] + WS_VERSAO_NFEEVENTO + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEvento versao="] + WS_VERSAO_NFEEVENTO + [">]
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
      { "**", WS_BPE_RECEPCAO,          WS_PROJETO_BPE,  "BpeRecepcao",          "http://www.portalfiscal.inf.br/bpe/wsdl/BPeRecepcao/bpeRecepcao" }, ;
      { "**", WS_BPE_RECEPCAOEVENTO,    WS_PROJETO_BPE,  "BpeRecepcaoEvento",    "http://www.portalfiscal.inf.br/bpe/wsdl/bpeRecepcaoEvento" }, ;
      { "**", WS_BPE_CONSULTA,          WS_PROJETO_BPE,  "BpeConsulta",          "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
      { "**", WS_BPE_STATUSSERVICO,     WS_PROJETO_BPE,  "BpeStatusServicoBP",   "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico" }, ;
      { "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO", ;
	           WS_NFE_AUTORIZACAO,       WS_PROJETO_NFE,  "nfeAutorizacaoLote",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao" }, ;
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
   IF ::cNFCE != "S" .AND. ::cVersao != "4.00" .AND. ( nPos := AScan( aSoapList, { | oElement | oElement[ 1 ] $ ::cUF .AND. oElement[ 2 ] == nWsServico } ) ) != 0
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
   CASE ::cProjeto == WS_PROJETO_NFE;  ::cVersao := WS_VERSAO_NFE
   CASE ::cProjeto == WS_PROJETO_CTE;  ::cVersao := WS_VERSAO_CTE
   CASE ::cProjeto == WS_PROJETO_MDFE; ::cVersao := WS_VERSAO_MDFE
   CASE ::cProjeto == WS_PROJETO_BPE;  ::cVersao := WS_VERSAO_BPE
   ENDCASE
   ::SetSoapURL( nWsServico )

   RETURN NIL

METHOD SetSoapURL( nWsServico ) CLASS SefazClass

   ::cSoapURL := ""
   DO CASE
   CASE ::cProjeto == WS_PROJETO_CTE
      IF ::cScan == "SVCAN"
         IF ::cUF $ "MG,PR,RS," + "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
            ::cSoapURL := SoapURLCTe( "SVSP", ::cAmbiente, nWsServico, @::cSoapVersion ) // SVC_SP não existe
         ELSEIF ::cUF $ "MS,MT,SP," + "AP,PE,RR"
            ::cSoapURL := SoapUrlCTe( "SVRS", ::cAmbiente, nWsServico, @::CSoapVersion ) // SVC_RS não existe
         ENDIF
      ELSE
         ::cSoapUrl := SoapUrlCTe( ::cUF, ::cAmbiente, nWsServico, @::cSoapVersion )
      ENDIF
   CASE ::cProjeto == WS_PROJETO_MDFE
      ::cSoapURL := SoapURLMDFe( "SVRS", ::cAmbiente, nWsServico, @::cSoapVersion )
   CASE ::cProjeto == WS_PROJETO_NFE .AND. ::cVersao == "4.00"
      ::cSoapUrl := SoapUrlNFe4( ::cUF, ::cAmbiente, nWsServico, @::cSoapVersion )
   CASE ::cProjeto == WS_PROJETO_NFE
      DO CASE
      CASE ::cNFCe == "S"
         ::cSoapUrl := SoapUrlNFCe( ::cUF, ::cAmbiente, nWsServico, @::cSoapVersion )
      CASE ::cVersao == "4.00"
         ::cSoapUrl := SoapUrlNfe( ::cUf, ::cAmbiente, nWsServico, @::cSoapVersion )
      CASE ::cScan == "SCAN"
         ::cSoapURL := SoapUrlNFe( "SCAN", ::cAmbiente, nWsServico, @::cSoapVersion )
      CASE ::cScan == "SVAN"
         ::cSoapUrl := SoapUrlNFe( "SVAN", ::cAmbiente, nWsServico, @::cSoapVersion )
      CASE ::cScan == "SVCAN"
         IF ::cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
            ::cSoapURL := SoapURLNfe( "SVRS", ::cAmbiente, nWsServico, @::cSoapVersion ) // svc-rs não existe
         ELSE
            ::cSoapURL := SoapUrlNFe( "SVAN", ::cAmbiente, nWsServico, @::cSoapVersion ) // svc-an não existe
         ENDIF
      ENDCASE
      IF Empty( ::cSoapUrl )
         ::cSoapUrl := SoapUrlNFe( ::cUF, ::cAmbiente, nWsServico, @::cSoapVersion )
      ENDIF
   CASE ::cProjeto == WS_PROJETO_BPE
      ::cSoapUrl := SoapUrlBpe( ::cUF, ::cAmbiente, nWsServico, @::cSoapVersion )
   ENDCASE

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

   LOCAL cXmlns := ;
      [xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ] + ;
      [xmlns:xsd="http://www.w3.org/2001/XMLSchema" ] + ;
      [xmlns:soap12="http://www.w3.org/2003/05/soap-envelope"]

   ::cXmlSoap    := XML_UTF8
   ::cXmlSoap    += [<soap12:Envelope ] + cXmlns + [>]
   //IF ::cSoapAction != "nfeDistDFeInteresse" .AND. ! ( ::cProjeto == WS_PROJETO_NFE .AND. ::cVersao == "4.00" )
      ::cXmlSoap +=    [<soap12:Header>]
      ::cXmlSoap +=       [<] + ::cProjeto + [CabecMsg xmlns="] + ::cSoapService + [">]
      ::cXmlSoap +=          [<cUF>] + ::UFCodigo( ::cUF ) + [</cUF>]
      ::cXmlSoap +=          [<versaoDados>] + ::cSoapVersion + [</versaoDados>]
      ::cXmlSoap +=       [</] + ::cProjeto + [CabecMsg>]
      ::cXmlSoap +=    [</soap12:Header>]
   //ENDIF
   ::cXmlSoap    +=    [<soap12:Body>]
   //IF ::cSoapAction == "nfeDistDFeInteresse"
      //::cXmlSoap += [<nfeDistDFeInteresse xmlns="] + ::cSoapService + [">]
      //::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg>]
   //ELSE
      ::cXmlSoap +=       [<] + ::cProjeto + [DadosMsg xmlns="] + ::cSoapService + [">]
   //ENDIF
   ::cXmlSoap    += ::cXmlEnvio
   ::cXmlSoap    +=    [</] + ::cProjeto + [DadosMsg>]
   //IF ::cSoapAction == "nfeDistDFeInteresse"
      //::cXmlSoap += [</nfeDistDFeInteresse>]
   //ENDIF
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
      IF cSoapAction != NIL .AND. ! Empty( cSoapAction )
         oServer:SetRequestHeader( "SOAPAction", cSoapAction )
      ENDIF
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
   cXmlAutorizado += [<cteProc versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_CTE + [>]
   cXmlAutorizado +=    cXmlAssinado
   cXmlAutorizado +=    [<protCTe versao="] + WS_VERSAO_CTE + [">]
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
   cXmlAutorizado += [<nfeProc versao="] + WS_VERSAO_CTE + [" ] + WS_XMLNS_NFE + [>]
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

STATIC FUNCTION SoapUrlBpe( cUF, cAmbiente, nWsServico, cSoapVersion )

   LOCAL nPos, cUrl, aList := SEFAZ_BPE_URL_LIST

   nPos := AScan( aList, { | e | cUF == e[ 1 ] .AND. cAmbiente == e[ 2 ] .AND. nWsServico == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aList[ nPos, 5 ]
      cSoapVersion := aList[ nPos, 4 ]
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlNfe( cUF, cAmbiente, nWsServico, cSoapVersion )

   LOCAL nPos,cUrl, aList := SEFAZ_NFE_URL_LIST

   nPos := AScan( aList, { | e | cUF == e[ 1 ] .AND. cAmbiente == e[ 2 ] .AND. nWsServico == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aList[ nPos, 5 ]
      cSoapVersion := aList[ nPos, 4 ]
   ENDIF
   IF nWsServico == WS_NFE_CONSULTACADASTRO .AND. cUF $ "AC,RN,PB,SC"
      cUrl := SoapUrlNfe( "SVRS", cAmbiente, nWsServico, @cSoapVersion )
   ENDIF
   DO CASE
   CASE ! Empty( cUrl )
   CASE cUf $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO"
      cURL := SoapURLNFe( "SVRS", cAmbiente, nWsServico, @cSoapVersion )
   CASE cUf $ "MA,PA,PI"
      cURL := SoapUrlNFe( "SVAN", cAmbiente, nWsServico, @cSoapVersion )
   ENDCASE

   RETURN cUrl

STATIC FUNCTION SoapUrlCte(  cUF, cAmbiente, nWsServico, cSoapVersion )

   LOCAL nPos, cUrl, aList := SEFAZ_CTE_URL_LIST


   nPos := AScan( aList, { | e | cUF == e[ 1 ] .AND. cAmbiente == e[ 2 ] .AND. nWsServico == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aList[ nPos, 5 ]
      cSoapVersion := aList[ nPos, 4 ]
   ENDIF
   IF Empty( cUrl )
      IF cUF $ "AP,PE,RR"
         cUrl := SoapUrlCTe( "SVSP", cAmbiente, nWsServico, @cSoapVersion )
      ELSEIF cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,RS,SC,SE,TO"
         cUrl := SoapURLCTe( "SVRS", cAmbiente, nWsServico, @cSoapVersion )
      ENDIF
   ENDIF

   RETURN cUrl

STATIC FUNCTION SoapUrlMdfe( cUF, cAmbiente, nWsServico, cSoapVersion )

   LOCAL cUrl, nPos, aList := SEFAZ_MDFE_URL_LIST

   nPos := AScan( aList, { | e | cAmbiente == e[ 2 ] .AND. nWsServico == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aList[ nPos, 5 ]
      cSoapVersion := aList[ nPos, 4 ]
   ENDIF

   HB_SYMBOL_UNUSED( cUF )

   RETURN cUrl

STATIC FUNCTION SoapUrlNFCe( cUf, cAmbiente, nWsServico, cSoapVersion )

   LOCAL cUrl, nPos, aList := SEFAZ_NFCE_URL_LIST


   nPos := AScan( aList, { | e | cUF == e[ 1 ] .AND. cAmbiente == e[ 2 ] .AND. nWsServico == e[ 3 ] } )
   IF nPos != 0
      cUrl         := aList[ nPos, 5 ]
      cSoapVersion := aList[ nPos, 4 ]
   ENDIF
   IF Empty( cUrl )
      cUrl := SoapUrlNFe( cUF, cAmbiente, nWsServico, cSoapVersion )
   ENDIF

  RETURN cUrl

STATIC FUNCTION SoapUrlNfe4( cUF, cAmbiente, nWsServico, cSoapVersion )

   LOCAL cUrl := ""

   IF cAmbiente == WS_AMBIENTE_HOMOLOGACAO
      DO CASE
      CASE cUF == "AM"
      CASE cUF == "BA"
      CASE cUF == "CE" ;   cUrl := "https://nfeh.sefaz.ce.gov.br/nfe2/services/xxxxx/?WSDL"
      CASE cUF == "GO" ;   cUrl := "https://homolog.sefaz.go.gov.br/nfe/services/V2/xxxxx?wsdl"
      CASE cUF == "MG" ;   cUrl := "https://hnfe.fazenda.mg.gov.br/nfe2/xxxxx"
      CASE cUF == "MS" ;   cUrl := "https://homologacao.nfe.ms.gov.br/ws/xxxxx"
      CASE cUF == "MT"
      CASE cUF == "PE"
      CASE cUF == "PR" ;   cUrl := "https://homologacao.sefaz.pr/nfe/xxxxx"
      CASE cUF == "RS" ;   cUrl := "https://nfe-homologacao.serfazrs.rs.gov/br/ws/xxxxx.asmx"
      CASE cUF == "SP" ;   cUrl := "https://homologacao.nfe.fazenda.sp.gov.br/ws/xxxxx.asmx"
      CASE cUF == "SVAN" ;
         .OR. cUF $ "MA,PA"
      CASE cUF == "SVRS" ;
         .OR. cUF $ "AC,AL,AP,DF,ES,PB,PI,RJ,RN,RO,RR,SC,SE,TO" ;
         .OR. ( cUF $ "AC,RN,PB,SC" .AND. nWsServico == WS_NFE_CONSULTACADASTRO )
            cUrl := "https:nfe-homologacao.svrs.rs.gov.br/ws/xxxxx.asmx"
      CASE cUF == "SVCAN"
      CASE cUF == "SVCRS"
      CASE cUF == "AN" ;   cUrl := "https://hom.nfe.fazenda.gov.br/xxxxx.asmx"
      ENDCASE
      IF ! Empty( cUrl )
         DO CASE
         CASE nWsServico == WS_NFE_AUTORIZACAO       ; cUrl := StrTran( cUrl, "xxxxx", "NFeAutorizacao4" )
         CASE nWsServico == WS_NFE_RETAUTORIZACAO    ; cUrl := StrTran( cUrl, "xxxxx", "NFeRetAutorizacao4" )
         CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ; cUrl := StrTran( cUrl, "xxxxx", "NfeConsulta4" )
         CASE nWsServico == WS_NFE_INUTILIZACAO      ; cUrl := StrTran( cUrl, "xxxxx", "Nfeinutilizacao4" )
         CASE nWsServico == WS_NFE_RECEPCAOEVENTO    ; cUrl := StrTran( cUrl, "xxxxx", "NFeRecepcaoEvento4" )
         CASE nWsServico == WS_NFE_STATUSSERVICO     ; cUrl := StrTran( cUrl, "xxxxx", "NFeStatusServico4" )
         CASE nWsServico == WS_NFE_CONSULTACADASTRO  ; cUrl := StrTran( cUrl, "xxxxx", "CadConsultaCadastro4" )
         ENDCASE
      ENDIF
      cSoapVersion := "4.00"
      IF cUF == "SP" // tinha que ter uma diferente
         cUrl := Lower( cUrl )
      ENDIF
   ENDIF

   RETURN cUrl

STATIC FUNCTION GeraQRCode( cXmlAssinado, cIdToken, cCSC )

   LOCAL QRCODE_cTag, QRCODE_Url,   QRCODE_chNFe,  QRCODE_nVersao,  QRCODE_tpAmb, QRCODE_cDest, QRCODE_dhEmi,;
         QRCODE_vNF,  QRCODE_vICMS, QRCODE_digVal, QRCODE_cIdToken, QRCODE_cCSC,  QRCODE_cHash,;
         cInfNFe, cSignature, cAmbiente, cUF, nPos, aList := SEFAZ_QRCODE_URL_LIST

   cInfNFe    := XmlNode( cXmlAssinado, "infNFe", .T. )
   cSignature := XmlNode( cXmlAssinado, "Signature", .T. )

   cAmbiente  := XmlNode( XmlNode( cInfNFe, "ide" ), "tpAmb" )
   cUF        := UFSigla( XmlNode( XmlNode( cInfNFe, "ide" ), "cUF" ) )

// 1¦ Parte ( Endereco da Consulta - Fonte: http://nfce.encat.org/desenvolvedor/qrcode/ )
   nPos       := AScan( aList, { | e | e[ 1 ] == cUF .AND. e[ 2 ] == cAmbiente } )
   QRCode_Url := iif( nPos == 0, "", aList[ nPos, 3 ] )

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

   IF ! Empty( QRCODE_chNFe ) .AND. ! Empty( QRCODE_nVersao ) .AND. ! Empty( QRCODE_tpAmb    ) .AND. ! Empty( QRCODE_dhEmi ) .AND. !Empty( QRCODE_vNF ) .AND.;
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
      QRCODE_cTag  := ( "<![CDATA[" +;
                        QRCODE_Url + QRCODE_chNFe + QRCODE_nVersao + QRCODE_tpAmb + QRCODE_cDest + QRCODE_dhEmi + QRCODE_vNF + QRCODE_vICMS + QRCODE_digVal + QRCODE_cIdToken + QRCODE_cHash +;
                        "]]>" )

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
