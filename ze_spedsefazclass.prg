/*
ze_spedsefazclass - rotinas pra comunicação com SEFAZ

2016.09.16.1750 - ok Autorização MDFe
2016.09.23.1640 - ok Inutilização NFe

Lembrete: CTE 2.00 vale até 06/2017 e CTE 3.00 começa em 12/2016
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
   VAR    cScan          INIT "N"                     /* Indicar se for SCAN/SVAN, ainda não testado */
   VAR    cUF            INIT "SP"                    /* Modificada conforme método */
   VAR    cCertificado   INIT ""                      /* Nome do certificado */
   VAR    cIndSinc       INIT INDSINC_RETORNA_RECIBO  /* Poucas UFs opção de protocolo */
   VAR    nTempoEspera   INIT 7                       /* intervalo entre envia lote e consulta recibo */
   VAR    cUFTimeZone    INIT "SP"                    /* Para DateTimeXml() Obrigatório definir UF default */
   VAR    cVersaoXml     INIT ""                      /* Uso do XML de comunicação */
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
   VAR    cVersao        INIT "3.10"                  /* Usado em fase intermediária, exemplo, CTE 2.00 e CTE 3.00 ao mesmo tempo
   VAR    cVersaoXml     INIT ""                      /* Modificada conforme webservice e UF */
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
   METHOD NFeEventoCCE( ... )  INLINE  ::NfeEventoCarta( ... )          // Não usar, apenas compatibilidade

   METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD CTeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD CTeStatusServico( cUF, cCertificado, cAmbiente )
   METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente )

   METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD MDFeStatusServico( cUF, cCertificado, cAmbiente )
   METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )

   METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc )
   METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeStatusServico( cUF, cCertificado, cAmbiente )
   METHOD NFeConsultaProtocolo( cChave, cCertificado, cAmbiente )
   METHOD NFeEventoEnvia( cChave, cXml, cCertificado, cAmbiente )
   METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo )
   METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente )
   METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD NFeEventoNaoRealizada( cChave, nSequencia, xJust, cCertificado, cAmbiente )
   METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente )
   METHOD NFeConsultaDest( cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente )
   METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   /* Uso interno */
   METHOD TipoXml( cXml )
   METHOD GetWebService( cUF, nWsServico, cAmbiente, cProjeto )
   METHOD XmlSoapEnvelope( cUF, cProjeto )
   METHOD XmlSoapPost( cUF, cCertificado, cProjeto )
   METHOD MicrosoftXmlSoapPost()
   METHOD UFCodigo( cSigla )
   METHOD UFSigla( cCodigo )
   METHOD DateTimeXml( dDate, cTime ) INLINE DateTimeXml( dDate, cTime, iif( ::cUFTimeZone == NIL, ::cUF, ::cUFTimeZone ) )

   ENDCLASS

METHOD CTeEventoCarta( cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL oElement

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cVersaoXml  := "2.00"
   ::cProjeto    := WS_PROJETO_CTE
   ::cUF         := ::UFSigla( Substr( cChave, 1, 2 ) )
   ::cServico    := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento"
   ::cSoapAction := "cteRecepcaoEvento"
   ::cXmlDados   := ""
   ::cXmlDados   += [<eventoCTe versao="] + ::cVersaoXml + [" xmlns="http://portalfiscal.inf.br/cte">]
   ::cXmlDados   +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   ::cXmlDados   +=       [<cOrgao>] + ::UFSigla( ::cUF ) + [</cOrgao><tpAmb>] + ::cAmbiente + [</tpAmb><CNPJ>] + Substr( cChave, 7, 14 ) + [</CNPJ>]
   ::cXmlDados   +=       [<chCTe>] + cChave + [</chCTe>]
   ::cXmlDados   +=       [<dhEvento>] + ::DateTimeXml( , , , .F. ) + [</dhEvento><tpEvento>110110</tpEvento>]
   ::cXmlDados   +=       [<nSeqEvento>] + Ltrim( Str( nSequencia ) ) + [</nSeqEvento><detEvento versaoEvento="] + ::cVersaoXml + [">]
   ::cXmlDados   +=       [<detEvento versaoEvento="] + ::cVersaoXml + [">]
   FOR EACH oElement IN aAlteracoes
   //
   // Falta parte das alterações, não é igual NFe
   //
   NEXT
   ::cXmlDados  +=       [</detEvento>]
   ::cXmlDados  +=       [<xCondUso>]
   ::cXmlDados  +=          [A Carta de Correcao e disciplinada pelo Art. 58-B do CONVENIO/SINIEF 06/89: ]
   ::cXmlDados  +=          [Fica permitida a utilizacao de carta de correcao, para regularizacao de erro ]
   ::cXmlDados  +=          [ocorrido na emissao de documentos fiscais relativos a prestacao de servico ]
   ::cXmlDados  +=          [de transporte, desde que o erro nao esteja relacionado com: I - as variaveis ]
   ::cXmlDados  +=          [que determinam o valor do imposto tais como: base de calculo, aliquota, ]
   ::cXmlDados  +=          [diferenca de preco, quantidade, valor da prestacao;II - a correcao de dados ]
   ::cXmlDados  +=          [cadastrais que implique mudanca do emitente, tomador, remetente ou do ]
   ::cXmlDados  +=          [destinatario;III - a data de emissao ou de saida.]
   ::cXmlDados  +=    [</infEvento>]
   ::cXmlDados  += [</eventoCTe>]

   ::cXmlRetorno := AssinaXml( @::cXmlDados, ::cCertificado )
//   ::XmlSoapPost( ::cUF, ::cCertificado, cProjeto )
   RETURN NIL

METHOD CTeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cUF          := ::UFSigla( Substr( cChave, 1, 2 ) )
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta"
   ::cSoapAction  := "cteConsultaCT"
   ::cWebService  := ::GetWebService( ::cUF, WS_CTE_CONSULTAPROTOCOLO, ::cAmbiente, WS_PROJETO_CTE )
   ::cXmlDados    := [<consSitCTe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados    +=    XmlTag( "chCTe", cChave )
   ::cXmlDados    += [</consSitCTe>]

   IF Substr( cChave, 21, 2 ) != "57"
      ::cXmlRetorno := "*ERRO* Chave não se refere a CTE"
   ELSE
      ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_CTE )
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
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao"
   ::cSoapAction  := "cteRecepcaoLote"
   ::cWebService  := ::GetWebService( ::cUF, WS_CTE_RECEPCAO, ::cAmbiente, WS_PROJETO_CTE )
   ::cXmlDados    := [<enviCTe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados    +=    XmlTag( "idLote", cLote )
   ::cXmlDados    +=    cXml
   ::cXmlDados    += [</enviCTe>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_CTE )
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   IF ! Empty( ::cRecibo )
      Inkey( ::nTempoEspera )
      ::CteConsultaRecibo()
      ::cXmlRetorno := ::CteGeraAutorizado( cXml, ::cXmlProtocolo )
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
   ::cVersaoXml  := "2.00"
   ::cServico    := "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao"
   ::cSoapAction := "cteRetRecepcao"
   ::cWebService := ::GetWebService( ::cUF, WS_CTE_RETRECEPCAO, ::cAmbiente, WS_PROJETO_CTE )
   ::cXmlDados   := [<consReciCTe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "nRec",  ::cRecibo )
   ::cXmlDados   += [</consReciCTe>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_CTE )
   ::cXmlProtocolo := ::cXmlRetorno
   ::cMotivo       := XmlNode( XmlNode( ::cXmlRetorno, "infProt" ), "xMotivo" )

   RETURN ::cXmlRetorno

METHOD CTeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protCTe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := "Não autorizado: " + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   //::cXmlAutorizado := [<?xml version="1.00"?>]
   ::cXmlAutorizado += [<cteProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protCTe", .T. )
   ::cXmlAutorizado += [</cteProc>]
   ::cXmlRetorno := ::cXmlAutorizado

   RETURN ::cXmlAutorizado

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
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico"
   ::cSoapAction  := "cteStatusServicoCT"
   ::cWebService  := ::GetWebService( ::cUF, WS_CTE_STATUSSERVICO, ::cAmbiente, WS_PROJETO_CTE )
   ::cXmlDados    := [<consStatServCte versao="]  + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados    += [</consStatServCte>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_CTE )

   RETURN ::cXmlRetorno

METHOD MDFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   ::cUF         := ::UFSigla( Substr( cChave, 1, 2 ) )
   ::cVersaoXml  := "1.00"
   ::cServico    := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta"
   ::cSoapAction := "mdfeConsultaMDF"
   ::cWebService := ::GetWebService( ::cUF, WS_MDFE_CONSULTA, ::cAmbiente, WS_PROJETO_MDFE )
   ::cXmlDados   := [<consSitMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados   +=    XmlTag( "chMDFe", cChave )
   ::cXmlDados   += [</consSitMDFe>]

   IF Substr( cChave, 21, 2 ) != "58"
      ::cXmlRetorno := "*ERRO* Chave não se refere a MDFE"
   ELSE
      ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_MDFE )
   ENDIF

   RETURN ::cXmlRetorno

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
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao"
   ::cSoapAction  := "MDFeRecepcao"
   ::cWebService  := ::GetWebService( ::cUF, WS_MDFE_RECEPCAO, ::cAmbiente, WS_PROJETO_MDFE )
   ::cXmlDados    := [<enviMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "idLote", cLote )
   ::cXmlDados    +=    cXml
   ::cXmlDados    += [</enviMDFe>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_MDFE )
   ::cXmlRecibo := ::cXmlRetorno
   ::cRecibo    := XmlNode( ::cXmlRecibo, "nRec" )
   IF ! Empty( ::cRecibo )
      Inkey( ::nTempoEspera )
      ::MDFeConsultaRecibo()
      ::cXmlRetorno := ::MDFeGeraAutorizado( cXml, ::cXmlProtocolo )
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
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao"
   ::cSoapAction  := "mdfeRetRecepcao"
   ::cWebService  := ::GetWebService( ::cUF, WS_MDFE_RETRECEPCAO, ::cAmbiente, WS_PROJETO_MDFE )
   ::cXmlDados    := [<consReciMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlDados    += [</consReciMDFe>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_MDFE )
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
   ::cWebService := ::GetWebService( ::cUF, WS_MDFE_DISTRIBUICAODFE, ::cAmbiente, WS_PROJETO_MDFE )

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_MDFE )

   RETURN NIL

METHOD MDFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protMDFe" ), "cStat" ), 3 )
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := "Não autorizado: " + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   // ::cXmlAutorizado := [<?xml version="1.00"?>] // colocando isto, emissor gratuito e explorer rejeitam o XML
   ::cXmlAutorizado += [<mdfeProc versao="1.00" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlAUtorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protMDFe", .T. )
   ::cXmlAutorizado += [</mdfeProc>]

   RETURN ::cXmlAutorizado

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
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico/mdfeStatusServicoMDF"
   ::cSoapAction  := "MDFeStatusServico"
   ::cWebService  := ::GetWebService( ::cUF, WS_MDFE_STATUSSERVICO, ::cAmbiente, WS_PROJETO_MDFE )
   ::cXmlDados    := [<consStatServMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDados    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados    += [</consStatServMDFe>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_MDFE )

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
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2"
   ::cSoapAction  := "CadConsultaCadastro2"
   ::cWebService  := ::GetWebService( ::cUF, WS_NFE_CONSULTACADASTRO, ::cAmbiente, WS_PROJETO_NFE )
   ::cXmlDados    := [<ConsCad versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    +=    [<infCons>]
   ::cXmlDados    +=       XmlTag( "xServ", "CONS-CAD" )
   ::cXmlDados    +=       XmlTag( "UF", ::cUF )
   ::cXmlDados    +=       XmlTag( "CNPJ", cCNPJ )
   ::cXmlDados    +=    [</infCons>]
   ::cXmlDados    += [</ConsCad>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )

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
   ::cWebService := ::GetWebService( ::cUF, WS_NFE_CONSULTAPROTOCOLO, ::cAmbiente, WS_PROJETO_NFE )
   ::cXmlDados   := [<consSitNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados   +=    XmlTag( "chNFe", cChave )
   ::cXmlDados   += [</consSitNFe>]

   IF ! Substr( cChave, 21, 2 ) $ "55,65"
      ::cXmlRetorno := "*ERRO* Chave não se refere a NFE"
   ELSE
      ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )
   ENDIF

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
   ::cWebService := ::GetWebService( ::cUF, WS_NFE_CONSULTADEST, ::cAmbiente, WS_PROJETO_NFE )
   ::cXmlDados   := [<consNFeDest versao="] + ::cVersaoXml + [">]
   ::cXmlDados   +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados   +=    XmlTag( "xServ", "CONSULTAR NFE DEST" )
   ::cXmlDados   +=    XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDados   +=    XmlTag( "indNFe", "0" ) // 0=todas,1=sem manif,2=sem nada
   ::cXmlDados   +=    XmlTag( "indEmi", "0" ) // 0=todas, 1=sem cnpj raiz(sem matriz/filial)
   ::cXmlDados   +=    XmlTag( "ultNSU", cUltNsu )
   ::cXmlDados   += [</consNFeDest>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )

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
   ::cWebService := ::GetWebService( ::cUF, WS_NFE_DISTRIBUICAODFE, ::cAmbiente, WS_PROJETO_NFE )

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )

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
   ::cXmlRetorno := AssinaXml( @cXml, ::cCertificado )

   IF ::cXmlRetorno == "OK"
      ::NFEEventoEnvia( cChave, cXml, ::cCertificado, ::cAmbiente )
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
   ::cXmlRetorno := AssinaXml( @cXml, ::cCertificado )

   IF ::cXmlRetorno == "OK"
      ::NFEEventoEnvia( cChave, cXml, ::cCertificado, ::cAmbiente )
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
   ::cXmlRetorno := AssinaXml( @cXml, ::cCertificado )

   IF ::cXmlRetorno == "OK"
      ::NFEEventoEnvia( cChave, cXml, ::cCertificado, ::cAmbiente )
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
   ::cWebService  := ::GetWebService( ::cUF, WS_NFE_RECEPCAOEVENTO, ::cAmbiente, WS_PROJETO_NFE )
   ::cXmlDados    := [<envEvento versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    +=    XmlTag( "idLote", Substr( cChave, 26, 9 ) ) // usado numero da nota
   ::cXmlDados    +=    cXml
   ::cXmlDados    += [</envEvento>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )

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
   ::cWebService := ::GetWebService( ::cUF, WS_NFE_INUTILIZACAO, ::cAmbiente, WS_PROJETO_NFE )
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

   AssinaXml( @::cXmlDados, ::cCertificado )
   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )

   ::cStatus := XmlNode( ::cXmlRetorno, "cStat" )
   ::cMotivo := XmlNode( ::cXmlRetorno, "xMotivo" )

   IF ::cStatus == "102"
      ::cXmlAutorizado := [<ProcInutNFe versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">]
      ::cXmlAutorizado += ::cXmlDados
      ::cXmlAutorizado += XmlNode( ::cXmlRetorno, "retInutNFe", .T. )
      ::cXmlAutorizado += [</ProcInutNFe>]
      ::cXmlRetorno := ::cXmlAutorizado
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
   ::cWebService  := ::GetWebService( ::cUF, WS_NFE_AUTORIZACAO, ::cAmbiente, WS_PROJETO_NFE )
   ::cXmlDados    := [<enviNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   // FOR EACH cXmlNota IN aXmlNotas
   ::cXmlDados    += XmlTag( "idLote", cLote )
   ::cXmlDados    += XmlTag( "indSinc", cIndSinc )
   ::cXmlDados    += cXml
   // NEXT
   ::cXmlDados    += [</enviNFe>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )
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
   ::cWebService   := ::GetWebService( ::cUf, WS_NFE_RETAUTORIZACAO, ::cAmbiente, WS_PROJETO_NFE )
   ::cXmlDados     := [<consReciNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados     +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados     +=    XmlTag( "nRec", ::cRecibo )
   ::cXmlDados     += [</consReciNFe>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )
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
   ::cWebService     := ::GetWebService( ::cUF, WS_NFE_STATUSSERVICO, ::cAmbiente, WS_PROJETO_NFE )
   ::cXmlDados       := [<consStatServ versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados       +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlDados       +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlDados       +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados       += [</consStatServ>]

   ::XmlSoapPost( ::cUF, ::cCertificado, WS_PROJETO_NFE )

   RETURN ::cXmlRetorno

METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "protNFe" ), "cStat" ), 3 ) // Pad() garante 3 caracteres
   IF ! ::cStatus $ "100,101,150,301,302"
      ::cXmlRetorno := "Não autorizado: " + ::cXmlProtocolo
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := [<?xml version="1.0"?>]
   ::cXmlAutorizado += [<nfeProc versao="3.10" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "protNFe", .T. )
   ::cXmlAutorizado += [</nfeProc>]

   RETURN ::cXmlAutorizado

METHOD NfeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   hb_Default( @cXmlAssinado, "" )
   hb_Default( @cXmlProtocolo, "" )
   ::cStatus := Pad( XmlNode( XmlNode( cXmlProtocolo, "retEvento" ), "cStat" ), 3 )
   IF ! ::cStatus $ "135,155" // 155=cancelamento fora do prazo
      ::cXmlRetorno := "Erro: Status do protocolo não serve como autorização"
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := [<?xml version="1.00"?>]
   ::cXmlAutorizado += [<procEventoNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEvento", .T. ) // não conteúdo, mas completo
   ::cXmlAutorizado += [</procEventoNFe>]

   RETURN ::cXmlAutorizado

METHOD TipoXml( cXml ) CLASS SefazClass

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

METHOD GetWebService( cUF, nWsServico, cAmbiente, cProjeto ) CLASS SefazClass
   // NFE SVAN: MA,PA,PI
   // NFE SVRS: AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO
   // NFE Autorizadores: AM,BA,CE,GO,MA,MG,MS,MT,PE,PR,RS,SP,SVCAN,SVCRS,AN

   LOCAL cTexto

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   IF cAmbiente != NIL
      ::cAmbiente := cAmbiente
   ENDIF
   hb_Default( @cProjeto, ::cProjeto )
   IF cProjeto == WS_PROJETO_MDFE
      cTexto := UrlWebService( "RS", ::cAmbiente, nWsServico, ::cVersao )
   ELSEIF ::cScan == "SCAN"
      cTexto := UrlWebService( "SCAN", ::cAmbiente, nWsServico, ::cVersao )
   ELSEIF ::cScan == "SVCAN"
      IF cProjeto == WS_PROJETO_NFE
         IF ::cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
            cTexto := UrlWebService( "SVCRS", ::cAmbiente, nWsServico, ::cVersao )
         ELSE
            cTexto := UrlWebService( "SVCAN", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ELSEIF cProjeto == WS_PROJETO_CTE
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
      IF cProjeto == WS_PROJETO_NFE
         IF ::cUf $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO" // Sefaz Virtual RS
            cTexto := UrlWebService( "SVRS", ::cAmbiente, nWsServico, ::cVersao )
         ELSEIF ::cUf $ "MA,PA,PI" // Sefaz Virtual
            cTexto := UrlWebService( "SVAN", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
         IF Empty( cTexto ) // Não tem específico
            cTexto := UrlWebService( "AN", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ELSEIF cProjeto == WS_PROJETO_CTE
         IF ::cUF $ "AP,PE,RR"
            cTexto := UrlWebService( "SVSP", ::cAmbiente, nWsServico, ::cVersao )
         ELSEIF ::cUF $ "AC,AL,AM,BA,CE,DF,ES,GO,MA,PA,PB,PI,RJ,RN,RO,SC,SE,TO"
            cTexto := UrlWebService( "SVRS", ::cAmbiente, nWsServico, ::cVersao )
         ENDIF
      ENDIF
   ENDIF

   RETURN cTexto

METHOD XmlSoapPost( cUF, cCertificado, cProjeto ) CLASS SefazClass

   IF cUF == NIL
      ::cUF := cUF
   ENDIF
   IF cCertificado != NIL
      ::cCertificado := cCertificado
   ENDIF
   hb_Default( @cProjeto, ::cProjeto )
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
   ::XmlSoapEnvelope( ::cUF, cProjeto )
   ::MicrosoftXmlSoapPost()
   IF Upper( Left( ::cXmlRetorno, 4 ) )  == "ERRO"
      RETURN NIL
   ENDIF
   IF "<soap:Body>" $ ::cXmlRetorno .AND. "</soap:Body>" $ ::cXmlRetorno
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soap:Body" )
   ELSEIF "<soapenv:Body>" $ ::cXmlRetorno .AND. "</soapenv:Body>" $ ::cXmlRetorno
      ::cXmlRetorno := XmlNode( ::cXmlRetorno, "soapenv:Body" )
   ELSE
      ::cXmlRetorno := "Erro SOAP: XML retorno não está no padrão " + ::cXmlRetorno
   ENDIF

   RETURN NIL

METHOD XmlSoapEnvelope( cUF, cProjeto ) CLASS SefazClass

   IF cUF != NIL
      ::cUF := cUF
   ENDIF
   hb_Default( @cProjeto, ::cProjeto )
   ::cXmlSoap    := ""
   ::cXmlSoap    += [<?xml version="1.0"?>] //  encoding="utf-8"?>]
   ::cXmlSoap    += [<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ]
   ::cXmlSoap    +=    [xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">]
   IF ::cSoapAction != "nfeDistDFeInteresse"
      ::cXmlSoap +=    [<soap12:Header>]
      ::cXmlSoap +=       [<] + cProjeto + [CabecMsg xmlns="] + ::cServico + [">]
      ::cXmlSoap +=          [<cUF>] + ::UFCodigo( ::cUF ) + [</cUF>]
      ::cXmlSoap +=          [<versaoDados>] + ::cVersaoXml + [</versaoDados>]
      ::cXmlSoap +=       [</] + cProjeto + [CabecMsg>]
      ::cXmlSoap +=    [</soap12:Header>]
   ENDIF
   ::cXmlSoap    +=    [<soap12:Body>]
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [<nfeDistDFeInteresse xmlns="] + ::cServico + [">]
      ::cXmlSoap +=       [<] + cProjeto + [DadosMsg>]
   ELSE
      ::cXmlSoap +=       [<] + cProjeto + [DadosMsg xmlns="] + ::cServico + [">]
   ENDIF
   ::cXmlSoap    += ::cXmlDados
   ::cXmlSoap    +=    [</] + cProjeto + [DadosMsg>]
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

METHOD UFCodigo( cSigla ) CLASS SefazClass

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

METHOD UFSigla( cCodigo ) CLASS SefazClass

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
         CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta2"
            // restrito a contribuintes // cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/CadConsultaCadastro2"
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
   curl_easy_setopt( oCurl, HB_CURLOPT_SSLVERSION, 3 )
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
