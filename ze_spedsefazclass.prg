*----------------------------------------------------------------
* ZE_SPEDSEFAZCLASS - ROTINAS PRA COMUNICACAO SEFAZ
*----------------------------------------------------------------

#include "hbclass.ch"

#define WSCTERECEPCAO              1
#define WSCTECONSULTA              2
#define WSCTESTATUSSERVICO         3
#define WSNFEAUTORIZACAO           4
#define WSNFERETAUTORIZACAO        5
#define WSNFECANCELAMENTO          6
#define WSNFECONSULTACADASTRO      7
#define WSNFECONSULTAPROTOCOLO     8
#define WSNFEINUTILIZACAO          9
#define WSNFERECEPCAO              10
#define WSNFERECEPCAOEVENTO        11
#define WSNFERETRECEPCAO           12
#define WSNFESTATUSSERVICO         13
#define WSNFEDOWNLOADNF            14
#define WSNFECONSULTADEST          15
#define WSMDFERECEPCAO             16
#define WSMDFERETRECEPCAO          17
#define WSMDFERECEPCAOEVENTO       18
#define WSMDFECONSULTA             19
#define WSMDFESTATUSSERVICO        20
#define WSMDFECONSNAOENC           21
#define WSNFEDISTRIBUICAODFE       22
#define WSMDFEDISTRIBUICAODFE      23

#define WSHOMOLOGACAO   "2"
#define WSPRODUCAO      "1"

#define WSPROJETONFE   "nfe"
#define WSPROJETOCTE   "cte"
#define WSPROJETOMDFE  "mdfe"

#define INDSINC_RETORNA_PROTOCOLO "0"
#define INDSINC_RETORNA_RECIBO    "1"

CREATE CLASS SefazClass

   VAR    cAmbiente     INIT WSPRODUCAO
   VAR    cVersao       INIT "3.10"    // Versão NFE
   VAR    cScan         INIT "N"
   VAR    cUF           INIT "SP"
   VAR    cCertificado  INIT ""
   VAR    cXmlDados     INIT ""
   VAR    cXmlRetorno   INIT "Erro Desconhecido"
   //---- Uso interno ----
   VAR    cVersaoXml    INIT ""
   VAR    cServico      INIT ""
   VAR    cSoapAction   INIT ""
   VAR    cWebService   INIT ""
   VAR    cXmlSoap      INIT ""
   VAR    lGravaTemp    INIT .F.
   // --- Uso em processo ---
   VAR    cProjeto      INIT WSPROJETONFE
   VAR    cXmlRecibo    INIT ""
   VAR    cXmlProtocolo INIT ""
   VAR    cXmlFinal     INIT ""

   METHOD CTeConsulta( cChave, cCertificado, cAmbiente )
   METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD CTeStatus( cUF, cCertificado, cAmbiente )
   METHOD MDFeConsulta( cChave, cCertificado, cAmbiente )
   METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD MDFeStatus( cUF, cCertificado, cAmbiente )
   METHOD NFeCancela( cXml, cUF, cCertificado, cAmbiente )
   METHOD NFeCadastro( cCnpj, cUF, cCertificado, cAmbiente )
   METHOD NFeConsultaDest( cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente )
   METHOD NFeEventoCCE( cChave, nSequencia, cTexto, cCertificado, cAmbiente )
   METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente )
   METHOD NFeEventoNaoRealizada( cChave, nSequencia, xJust, cCertificado, cAmbiente )
   METHOD NFeConsulta( cChave, cCertificado, cAmbiente )
   METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente )
   METHOD NFeEventoEnvia( cChave, cXml, cCertificado, cAmbiente )
   METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente )
   METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente )
   METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente )
   METHOD NFeStatus( cUF, cCertificado, cAmbiente )
   METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo )
   //----- Uso interno -----
   METHOD TipoXml( cXml )
   METHOD GetWebService( cUF, nWsServico, cAmbiente, cProjeto )
   METHOD XmlSoapEnvelope( cUF, cProjeto )
   METHOD XmlSoapPost( cUF, cCertificado, cProjeto )
   METHOD MicrosoftXmlSoapPost()
   ENDCLASS


// Apenas anotado

//METHOD CTEEventoCCE( cChave, nSequencia, cTexto, cCertificado ) CLASS SefazClass
//
//   ::cVersaoXml   := "2.00"
//   cProjeto    := WSPROJETOCTE
//   cUF         := UFNome( Substr( cChave, 1, 2 ) )
//   ::cXmlDados := ""
//   ::cXmlDados += [<eventoCTe versao="] + ::cVersaoXml + [" xmlns="http://portalfiscal.inf.br/cte">]
//   ::cXmlDados += [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
//   ::cXmlDados += [<cOrgao>31</cOrgao><tpAmb>2</tpAmb><CNPJ>] + Substr( cChave, 7, 14 ) + [</CNPJ>]
//   ::cXmlDados += [<chCTe>] + cChave + [</chCTe>]
//   ::cXmlDados += [<dhEvento>] + Transform( Dtos( Date(), "@R 9999-99-99" ) + [T] + Time() + [</dhEvento><tpEvento>110110</tpEvento>]
//   ::cXmlDados += [<nSeqEvento>] + Ltrim( Str( nSequencia ) ) + [</nSeqEvento><detEvento versaoEvento="] + ::cVersaoXml + [">]
//   ::cXmlDados += [<evCCeCTe><descEvento>Carta de Correcao</descEvento>]
//   ::cXmlDados += [<infCorrecao><grupoAlterado>xobs</grupoAlterado>]
//   ::cXmlDados += [<campoAlterado>obs</campoAlterado>]
//   ::cXmlDados += [<valorAlterado>teste de correcao</valorAlterado></infCorrecao>]
//   Isto é se for igual NFE: cXml += [<xCorrecao>] + cTexto + [</xCorrecao>]
//   ::cXmlDados += [<xCondUso>A Carta de Correcao e disciplinada pelo Art. 58-B ]
//   ::cXmlDados += [do CONVENIO/SINIEF 06/89: Fica permitida a utilizacao de carta ]
//   ::cXmlDados += [de correcao, para regularizacao de erro ocorrido na emissao de ]
//   ::cXmlDados += [documentos fiscais relativos a prestacao de servico de transporte, ]
//   ::cXmlDados += [desde que o erro nao esteja relacionado com: I - as variaveis que ]
//   ::cXmlDados += [determinam o valor do imposto tais como: base de calculo, aliquota, ]
//   ::cXmlDados += [diferenca de preco, quantidade, valor da prestacao;II - a correcao ]
//   ::cXmlDados += [de dados cadastrais que implique mudanca do emitente, tomador, ]
//   ::cXmlDados += [remetente ou do destinatario;III - a data de emissao ou de saida.]
//   ::cXmlDados += [</xCondUso></evCCeCTe></detEvento></infEvento></eventoCTe>]
//   AssinaXml( cXmlDados )
//   ::XmlSoapPost( cUF, cCertificado, cProjeto )
//   RETURN NIL

METHOD CTeConsulta( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cUF

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cUF            := UFSigla( Substr( cChave, 1, 2 ) )
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta"
   ::cSoapAction  := "cteConsultaCT"
   ::cWebService  := ::GetWebService( cUF, WSCTECONSULTA, cAmbiente, WSPROJETOCTE )
   ::cXmlDados    := ""
   ::cXmlDados    += [<consSitCTe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados    +=    XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados    +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados    +=    XmlTag( "chCTe", cChave )
   ::cXmlDados    += [</consSitCTe>]
   IF Substr( cChave, 21, 2 ) != "57"
      ::cXmlRetorno := "*ERRO* Chave não se refere a CTE"
   ELSE
      ::XmlSoapPost( cUF, cCertificado, WSPROJETOCTE )
   ENDIF
   RETURN ::cXmlRetorno


METHOD CTeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF            := iif( cUF == NIL, ::cUF, cUF )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/cteRecepcao"
   ::cSoapAction  := "cteRecepcao"
   ::cWebService  := ::GetWebService( cUF, WSCTERECEPCAO, cAmbiente, WSPROJETOCTE )
   ::cXmlDados    := ""
   ::cXmlDados    += [<envicte versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   // FOR nCont = 1 TO Len( Lotes )
   ::cXmlDados += XmlTag( "idLote", cLote )
   ::cXmlDados += cXml
   // NEXT
   ::cXmlDados += [</envicte>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETOCTE )
   RETURN ::cXmlRetorno


METHOD CTeStatus( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF            := iif( cUF == NIL, ::cUF, cUF )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml   := "1.04"
   ::cServico     := "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico"
   ::cSoapAction  := "cteStatusServicoCT"
   ::cWebService  := ::GetWebService( cUF, WSCTESTATUSSERVICO, cAmbiente, WSPROJETOCTE )
   ::cXmlDados    := ""
   ::cXmlDados    += [<consStatServCte versao="]  + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/cte">]
   ::cXmlDados    +=    XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados    += [</consStatServCte>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETOCTE )
   RETURN ::cXmlRetorno


METHOD MDFeConsulta( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cUF

   cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF           := UFSigla( Substr( cChave, 1, 2 ) )
   cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml  := "1.00"
   ::cServico    := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta"
   ::cSoapAction := "MDFeConsultaMDF"
   ::cWebService := ::GetWebService( cUF, WSMDFECONSULTA, cAmbiente, WSPROJETOMDFE )
   ::cXmlDados   := ""
   ::cXmlDados   += [<consSitMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados   +=    XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados   +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados   +=    XmlTag( "chMDFe", cChave )
   ::cXmlDados   += [</consSitMDFe>]
   IF Substr( cChave, 21, 2 ) != "58"
      ::cXmlRetorno := "*ERRO* Chave não se refere a MDFE"
   ELSE
      ::XmlSoapPost( cUF, cCertificado, WSPROJETOMDFE )
   ENDIF
   RETURN ::cXmlRetorno


METHOD MDFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF            := iif( cUF == NIL, ::cUF, cUF )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cXmlDados    := ""
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao"
   ::cSoapAction  := "MDFeRecepcao"
   ::cWebService  := ::GetWebService( cUF, WSMDFERECEPCAO, cAmbiente, WSPROJETOMDFE )
   ::cXmlDados    += [<enviMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   // FOR nCont = 1 TO Len( Lotes )
   ::cXmlDados += XmlTag( "idLote", cLote )
   ::cXmlDados += cXml
   // NEXT
   ::cXmlDados += [</enviMDFe>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETOMDFE )
   RETURN ::cXmlRetorno


METHOD MDFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF          := iif( cUF == NIL, ::cUF, cUF )
   cAmbiente    := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao"
   ::cSoapAction  := "MDFeRetRecepcao"
   ::cWebService  := ::GetWebService( cUF, WSMDFERETRECEPCAO, cAmbiente, WSPROJETOMDFE )
   ::cXmlDados    := ""
   ::cXmlDados    += [<consReciMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados    +=    XmlTag( "nRec", cRecibo )
   ::cXmlDados    += [</consReciMDFe>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETOMDFE )
   RETURN ::cXmlRetorno


// Iniciado apenas 2016.01.31.2200
METHOD MDFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cUF           := iif( cUF == NIL, ::cUF, cUF )
   cUltNSU       := iif( cUltNSU == NIL, "0", cUltNSU )
   cNSU          := iif( cNSU == NIL, "", cNSU )
   cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml  := "1.00"
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/MDFeDistribuicaoDFe"
   ::cSoapAction := "mdfeDistDFeInteresse"
   ::cXmlDados := ""
   ::cXmlDados += [<distDFeInt versao "] + ::cVersaoXml + ["xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados += XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados += XmlTag( "cUFAutor", UFCodigo( cUF ) )
   ::cXmlDados += XmlTag( "CNPJ", cCnpj )
   IF Empty( cNSU )
      ::cXmlDados += [<distNSU>]
      ::cXmlDados += XmlTag( "ultNSU", cUltNSU )
      ::cXmlDados += [</distNSU>]
   ELSE
      ::cXmlDados += [<consNSU>]
      ::cXmlDados += XmlTag( "NSU", cNSU )
      ::cXmlDados += [</consNSU>]
   ENDIF
   ::cXmlDados += [</distDFeInt>]
   ::cWebService := ::GetWebService( cUF, WSMDFEDISTRIBUICAODFE, cAmbiente, WSPROJETOMDFE )
   ::XmlSoapPost( cUF, cCertificado, WSPROJETOMDFE )
   RETURN NIL


METHOD MDFeStatus( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF            := iif( cUF == NIL, ::cUF, cUF )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico/mdfeStatusServicoMDF"
   ::cSoapAction  := "MDFeStatusServico"
   ::cWebService  := ::GetWebService( cUF, WSMDFESTATUSSERVICO, cAmbiente, WSPROJETOMDFE )
   ::cXmlDados    := ""
   ::cXmlDados    += [<consStatServMDFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/mdfe">]
   ::cXmlDados    +=    XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados    +=    XmlTag( "cUF", UFCodigo( cUF ) )
   ::cXmlDados    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados    += [</consStatServMDFe>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETOMDFE )
   RETURN ::cXmlRetorno


//
// Este serviço foi desativado e substituído pelo evento
//
METHOD NFeCancela( cXml, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF            := iif( cUF == NIL, ::cUF, cUF )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeCancelamento2"
   ::cSoapAction  := "nfeCancelamentoNF2"
   ::cWebService  := ::GetWebService( cUF, WSNFECANCELAMENTO, cAmbiente, WSPROJETONFE )
   ::cXmlDados    := cXml
   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   RETURN ::cXmlRetorno


METHOD NFeCadastro( cCnpj, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF            := iif( cUF == NIL, ::cUF, cUF )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml   := "2.00"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2"
   ::cSoapAction  := "CadConsultaCadastro2"
   ::cWebService  := ::GetWebService( cUF, WSNFECONSULTACADASTRO, cAmbiente, WSPROJETONFE )
   ::cXmlDados    := ""
   ::cXmlDados    += [<ConsCad versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    +=    [<infCons>]
   ::cXmlDados    +=       XmlTag( "xServ", "CONS-CAD" )
   ::cXmlDados    +=       XmlTag( "UF", cUF )
   ::cXmlDados    +=       XmlTag( "CNPJ", cCNPJ )
   ::cXmlDados    +=    [</infCons>]
   ::cXmlDados    += [</ConsCad>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   RETURN ::cXmlRetorno


METHOD NFeConsulta( cChave, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cUF

   ::cVersaoXml  := "3.10"
   cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cUF           := UFSigla( Substr( cChave, 1, 2 ) )
   DO CASE
   CASE cUF $ "BA"
      ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta"
      ::cSoapAction := "nfeConsultaNF"
   CASE cUF $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO"
      ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2"
      ::cSoapAction := "nfeConsultaNF2"
   OTHERWISE
      ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2"
      ::cSoapAction := "NfeConsulta2"
   ENDCASE
   ::cWebService := ::GetWebService( cUF, WSNFECONSULTAPROTOCOLO, cAmbiente, WSPROJETONFE )
   ::cXmlDados   := ""
   ::cXmlDados   += [<consSitNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados   +=    XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados   +=    XmlTag( "xServ", "CONSULTAR" )
   ::cXmlDados   +=    XmlTag( "chNFe", cChave )
   ::cXmlDados   += [</consSitNFe>]
   IF .NOT. Substr( cChave, 21, 2 ) $ "55,65"
      ::cXmlRetorno := "*ERRO* Chave não se refere a NFE"
   ELSE
      ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   ENDIF
   RETURN ::cXmlRetorno


// Iniciado apenas 2015.07.31.1400
METHOD NFeConsultaDest( cCnpj, cUltNsu, cIndNFe, cIndEmi, cUf, cCertificado, cAmbiente ) CLASS SefazClass

   cUltNSU       := iif( cUltNsu == NIL, "0", cUltNSU )
   cIndNFe       := iif( cIndNFE == NIL, "0", cIndNFe )
   cIndEmi       := iif( cIndEmi == NIL, "0", cIndEmi )
   cUF           := iif( cUF == NIL, ::cUF, cUF )
   cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml  := "3.10"
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest"
   ::cSoapAction := "nfeConsultaNFDest"
   ::cWebService := ::GetWebService( cUF, WSNFECONSULTADEST, cAmbiente, WSPROJETONFE )
   ::cXmlDados   := [<consNFeDest versao="] + ::cVersaoXml + [">]
   ::cXmlDados   += XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados   += XmlTag( "xServ", "CONSULTAR NFE DEST" )
   ::cXmlDados   += XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDados   += XmlTag( "indNFe", "0" ) // 0=todas,1=sem manif,2=sem nada
   ::cXmlDados   += XmlTag( "indEmi", "0" ) // 0=todas, 1=sem cnpj raiz(sem matriz/filial)
   ::cXmlDados   += XmlTag( "ultNSU", cUltNsu )
   ::cXmlDados   += [</consNFeDest>]

   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   RETURN ::cXmlRetorno


// Iniciado apenas 2015.07.31.1400
METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cUF           := iif( cUF == NIL, ::cUF, cUF )
   cUltNSU       := iif( cUltNSU == NIL, "0", cUltNSU )
   cNSU          := iif( cNSU == NIL, "", cNSU )
   cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cVersaoXml  := "1.00"
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe"
   ::cSoapAction := "nfeDistDFeInteresse"
   ::cXmlDados := ""
   ::cXmlDados += [<distDFeInt versao "] + ::cVersaoXml + ["xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados += XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados += XmlTag( "cUFAutor", UFCodigo( cUF ) )
   ::cXmlDados += XmlTag( "CNPJ", cCnpj )
   IF Empty( cNSU )
      ::cXmlDados += [<distNSU>]
      ::cXmlDados += XmlTag( "ultNSU", cUltNSU )
      ::cXmlDados += [</distNSU>]
   ELSE
      ::cXmlDados += [<consNSU>]
      ::cXmlDados += XmlTag( "NSU", cNSU )
      ::cXmlDados += [</consNSU>]
   ENDIF
   ::cXmlDados += [</distDFeInt>]
   ::cWebService := ::GetWebService( cUF, WSNFEDISTRIBUICAODFE, cAmbiente, WSPROJETONFE )
   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   RETURN NIL


METHOD NFeEventoCCE( cChave, nSequencia, cTexto, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   cAmbiente := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   nSequencia := iif( nSequencia == NIL, 1, nSequencia )

   cXml += [<evento xmlns="http://www.portal.inf.br/nfe" versao "1.00">]
   cXml +=    [<infEvento Id="ID110110] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", UFSigla( Substr( cChave, 1, 2 ) ) )
   cXml +=       XmlTag( "tpAmb", cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chNFe", cChave )
   cXml +=       XmlTag( "dhEvento", DateTimeXml() )
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
   ::cXmlRetorno := AssinaXml( @cXml, cCertificado )
   IF ::cXmlRetorno == "OK"
      ::NFEEventoEnvia( cChave, cXml, cCertificado, cAmbiente )
   ENDIF
   RETURN ::cXmlRetorno


METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   cAmbiente := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cCertificado := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   nSequencia := iif( nSequencia == NIL, 1, nSequencia )

   cXml += [<evento versao "1.00" xmlns="http://www.portal.inf.br/nfe">]
   cXml +=    [<infEvento Id="ID110111" + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", UFSigla( Substr( cChave, 1, 2 ) ) )
   cXml +=       XmlTag( "tpAmb", cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chNFe", cChave )
   cXml +=       XmlTag( "dhEvento", DateTimeXml() )
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
   ::cXmlRetorno := AssinaXml( @cXml, cCertificado )
   IF ::cXmlRetorno == "OK"
      ::NFEEventoEnvia( cChave, cXml, cCertificado, cAmbiente )
   ENDIF
   RETURN ::cXmlRetorno


METHOD NFeEventoNaoRealizada( cChave, nSequencia, xJust, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cXml := ""

   cAmbiente := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   nSequencia := iif( nSequencia == NIL, 1, nSequencia )

   cXml += [<evento versao "1.00" xmlns="http://www.portal.inf.br/nfe" >]
   cXml +=    [<infEvento Id="ID210240] + cChave + StrZero( nSequencia, 2 ) + [">]
   cXml +=       XmlTag( "cOrgao", UFSigla( Substr( cChave, 1, 2 ) ) )
   cXml +=       XmlTag( "tpAmb", cAmbiente )
   cXml +=       XmlTag( "CNPJ", Substr( cChave, 7, 14 ) )
   cXml +=       XmlTag( "chNFe", cChave )
   cXml +=       XmlTag( "dhEvento", DateTimeXml() )
   cXml +=       XmlTag( "tpEvento", "210240" )
   cXml +=       XmlTag( "nSeqEvento", StrZero( 1, 2 ) )
   cXml +=       XmlTag( "verEvento", "1.00" )
   cXml +=       [<detEvento versao="1.00">]
   cXml +=          XmlTag( "xJust", xJust )
   cXml +=       [</detEvento>]
   cXml +=    [</infEvento>]
   cXml += [</evento>]
   ::cXmlRetorno := AssinaXml( @cXml, cCertificado )
   IF ::cXmlRetorno == "OK"
      ::NFEEventoEnvia( cChave, cXml, cCertificado, cAmbiente )
   ENDIF
   RETURN ::cXmlRetorno


METHOD NFeEventoEnvia( cChave, cXml, cCertificado, cAmbiente ) CLASS SefazClass

   LOCAL cUF

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cUF            := UFSigla( Substr( cChave, 1, 2 ) )
   ::cVersaoXml   := "1.00"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento"
   ::cSoapAction  := "nfeRecepcaoEvento"
   ::cWebService  := ::GetWebService( cUF, WSNFERECEPCAOEVENTO, cAmbiente, WSPROJETONFE )
   ::cXmlDados    := ""
   ::cXmlDados    += [<envEvento versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    +=    XmlTag( "idLote", Substr( cChave, 26, 9 ) ) // usado numero da nota
   ::cXmlDados    +=    cXml
   ::cXmlDados    += [</envEvento>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   RETURN ::cXmlRetorno


METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cUF           := iif( cUF == NIL, ::cUF, cUF )
   ::cVersaoXml  := "2.00"
   ::cServico    := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2"
   ::cSoapAction := "NfeInutilizacao2"
   ::cWebService := ::GetWebService( cUF, WSNFEINUTILIZACAO, cAmbiente, WSPROJETONFE )
   ::cXmlDados   := ""
   ::cXmlDados   += [<inutNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados   +=    [<infInut Id="ID] + cUF + cAno + cCnpj + cMod + StrZero( Val( cSerie ), 3 )
   ::cXmlDados   +=    StrZero( Val( cNumIni ), 9 ) + StrZero( Val( cNumFim ), 9 ) + [">]
   ::cXmlDados   +=       XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados   +=       XmlTag( "xServ", "INUTILIZAR" )
   ::cXmlDados   +=       XmlTag( "cUF", cUF )
   ::cXmlDados   +=       XmlTag( "ano", cAno )
   ::cXmlDados   +=       XmlTag( "CNPJ", SoNumeros( cCnpj ) )
   ::cXmlDados   +=       XmlTag( "mod", cMod )
   ::cXmlDados   +=       XmlTag( "serie", cSerie )
   ::cXmlDados   +=       XmlTag( "nNFIni", cNumIni )
   ::cXmlDados   +=       XmlTag( "nNFFin", cNumFim )
   ::cXmlDados   +=       XmlTag( "xJust", cJustificativa )
   ::cXmlDados   +=    [</infInut>]
   ::cXmlDados   += [</inutNFe>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   RETURN ::cXmlRetorno


METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cUF            := iif( cUF == NIL, ::cUF, cUF )
   ::cXmlDados    := ""
   IF ::cVersao == "2.00"
      ::cVersaoXml   := "2.00"
      ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRecepcao2"
      ::cSoapAction  := "nfeRecepcaoLote2"
      ::cWebService  := ::GetWebService( cUF, WSNFERECEPCAO, cAmbiente, WSPROJETONFE )
   ELSE
      ::cVersaoXml   := "3.10"
      ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao"
      ::cSoapAction  := "NfeAutorizacao"
      ::cWebService  := ::GetWebService( cUF, WSNFEAUTORIZACAO, cAmbiente, WSPROJETONFE )
   ENDIF
   ::cXmlDados    += [<enviNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   // FOR nCont = 1 TO Len( Lotes )
   ::cXmlDados += XmlTag( "idLote", cLote )
   ::cXmlDados += XmlTag( "indSinc", INDSINC_RETORNA_PROTOCOLO )
   ::cXmlDados += cXml
   // NEXT
   ::cXmlDados += [</enviNFe>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   ::cXmlRecibo := ::cXmlRetorno
   RETURN ::cXmlRetorno


METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente    := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cUF          := iif( cUF == NIL, ::cUF, cUF )
   IF ::cVersao == "2.00"
      ::cVersaoXml   := "2.00"
      ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetRecepcao2"
      ::cSoapAction  := "nfeRetRecepcao2"
      ::cWebService  := ::GetWebService( cUF, WSNFERETRECEPCAO, cAmbiente, WSPROJETONFE )
   ELSE // 3.10
      ::cVersaoXml := "3.10"
      ::cServico := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao"
      ::cSoapAction := "NfeRetAutorizacao"
      ::cWebService := ::GetWebService( cUf, WSNFERETAUTORIZACAO, cAmbiente, WSPROJETONFE )
   ENDIF
   ::cXmlDados    := ""
   ::cXmlDados    += [<consReciNFe versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlDados    +=    XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados    +=    XmlTag( "nRec", cRecibo )
   ::cXmlDados    += [</consReciNFe>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   ::cXmlProtocolo := ::cXmlRetorno
   RETURN ::cXmlRetorno


METHOD NFeStatus( cUF, cCertificado, cAmbiente ) CLASS SefazClass

   cCertificado   := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cAmbiente      := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cUF            := iif( cUF == NIL, ::cUF, cUF )
   ::cVersaoXml   := "3.10"
   ::cServico     := "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2"
   ::cSoapAction  := "nfeStatusServicoNF2"
   ::cWebService  := ::GetWebService( cUF, WSNFESTATUSSERVICO, cAmbiente, WSPROJETONFE )
   ::cXmlDados    := ""
   ::cXmlDados    += [<consStatServ versao="] + ::cVersaoXml + [" xmlns="http://www.portalfiscal.inf.br/nfe">]
   // precisava disto antes, de repente alguma UF ainda precisa
   ::cXmlDados    +=    XmlTag( "tpAmb", cAmbiente )
   ::cXmlDados    +=    XmlTag( "cUF", UFCodigo( cUF ) )
   ::cXmlDados    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlDados    += [</consStatServ>]
   ::XmlSoapPost( cUF, cCertificado, WSPROJETONFE )
   RETURN ::cXmlRetorno


// Apenas anotado, falta checar validade dos XMLs, muitíssimo importante

METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass

   LOCAL cStatus

   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDados, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )
   cStatus := XmlNode( XmlNode( ::XmlProtocolo, "infProt" ), "cStat" )
   IF .NOT. ( cStatus == "100" .OR. cStatus == "101" .OR. cStatus == "302" )
      ::cXmlRetorno := "Erro: Status do protocolo não serve como autorização"
      RETURN ::cXmlRetorno
   ENDIF
   ::cXmlAutorizado := [<?xml version="1.0" encoding="UTF-8"?>]
   ::cXmlAutorizado += [<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe">]
   ::cXmlAutorizado +=    ::cXmlDados
   ::cXmlAutorizado +=    ::cXmlProtocolo
   ::cXmlAutorizado += [</nfeProc>]
   RETURN ::cXmlAutorizado


METHOD TipoXml( cXml ) CLASS SefazClass

   LOCAL aTipos, cTipoXml, nCont, cTipoEvento

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
   FOR nCont = 1 TO Len( aTipos )
      IF Upper( aTipos[ nCont, 1 ] ) $ Upper( cXml )
         cTipoXml := aTipos[ nCont, 2 ]
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
   // SVAN: MA,PA,PI
   // SVRS: AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO
   // Autorizadores: AM,BA,CE,GO,MA,MG,MS,MT,PE,PR,RS,SP,SVCAN,SVCRS,AN

   LOCAL cTexto

   cAmbiente := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   cProjeto  := iif( cProjeto == NIL, ::cProjeto, cProjeto )
   IF ::cScan == "SCAN"
      cTexto := UrlWebService( "SCAN", cAmbiente, nWsServico, ::cVersao )
   ELSEIF ::cScan == "SVCAN"
      IF cUF $ "AM,BA,CE,GO,MA,MS,MT,PA,PE,PI,PR"
         cTexto := UrlWebService( "SVCRS", cAmbiente, nWsServico, ::cVersao )
      ELSE
         cTexto := UrlWebService( "SVCAN", cAmbiente, nWsServico, ::cVersao )
      ENDIF
   ELSE
      cTexto := UrlWebService( cUf, cAmbiente, nWsServico, ::cVersao )
   ENDIF
   IF Empty( cTexto ) // UFs sem Webservice próprio
      IF cUf $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO" // Sefaz Virtual RS
         cTexto := UrlWebService( "SVRS", cAmbiente, nWsServico, ::cVersao )
      ELSEIF cUf $ "MA,PA,PI" // Sefaz Virtual
         cTexto := UrlWebService( "SVAN", cAmbiente, nWsServico, ::cVersao )
      ENDIF
      IF Empty( cTexto ) // Não tem específico
         cTexto := UrlWebService( "AN", cAmbiente, nWsServico, ::cVersao )
      ENDIF
   ENDIF
   RETURN cTexto


METHOD XmlSoapPost( cUF, cCertificado, cProjeto ) CLASS SefazClass

   cCertificado := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   cUF          := iif( cUF == NIL, ::cUF, cUF )
   cProjeto     := iif( cProjeto == NIL, ::cProjeto, cProjeto )
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
   //CASE Empty( ::cVersaoXml )
   //   ::cXmlRetorno := "Erro SOAP: Não há número de versão"
   //   RETURN NIL
   ENDCASE
   //IF Empty( cUF )
   //   ::cXmlRetorno := "Erro SOAP: Não há sigla de UF"
   //   RETURN NIL
   //ENDIF
   ::XmlSoapEnvelope( cUF, cProjeto )
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

   cUF        := iif( cUF == NIL, ::cUF, cUF )
   cProjeto   := iif( cProjeto == NIL, ::cProjeto, cProjeto )
   ::cXmlSoap := ""
   ::cXmlSoap += [<?xml version="1.0" encoding="utf-8"?>] // UTF-8
   ::cXmlSoap += [<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ]
   ::cXmlSoap +=    [xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">]
   IF ::cSoapAction != "nfeDistDFeInteresse"
      ::cXmlSoap +=    [<soap12:Header>]
      ::cXmlSoap +=       [<] + cProjeto + [CabecMsg xmlns="] + ::cServico + [">]
      ::cXmlSoap +=          [<cUF>] + UFCodigo( cUF ) + [</cUF>]
      ::cXmlSoap +=          [<versaoDados>] + ::cVersaoXml + [</versaoDados>]
      ::cXmlSoap +=       [</] + cProjeto + [CabecMsg>]
      ::cXmlSoap +=    [</soap12:Header>]
   ENDIF
   ::cXmlSoap +=    [<soap12:Body>]
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [<nfeDistDFeInteresse xmlns="] + ::cServico + [">]
      ::cXmlSoap +=       [<] + cProjeto + [DadosMsg>]
   ELSE
      ::cXmlSoap +=       [<] + cProjeto + [DadosMsg xmlns="] + ::cServico + [">]
   ENDIF
   ::cXmlSoap += ::cXmlDados
   ::cXmlSoap +=    [</] + cProjeto + [DadosMsg>]
   IF ::cSoapAction == "nfeDistDFeInteresse"
      ::cXmlSoap += [</nfeDistDFeInteresse>]
   ENDIF
   ::cXmlSoap +=    [</soap12:Body>]
   ::cXmlSoap += [</soap12:Envelope>]
   RETURN ::cXmlSoap


METHOD MicrosoftXmlSoapPost() CLASS SefazClass

   LOCAL oServer, nCont, cRetorno := "Erro: No componente para SOAP"
   LOCAL cSoapAction

   //IF ::cSoapAction == "nfeDistDFeInteresse" .OR. ::cSoapAction == "nfeConsultaNFDest"
      //cSoapAction := ::cServico + "/" + ::cSoapAction
   //ELSE
      cSoapAction := ::cSoapAction
   //ENDIF
#ifdef __XHARBOUR__
   TRY
#else
   BEGIN SEQUENCE WITH __BreakBlock()
#endif
      oServer := win_OleCreateObject( "MSXML2.ServerXMLHTTP.6.0" )
      IF ::cCertificado != NIL
         oServer:setOption( 3, "CURRENT_USER\MY\" + ::cCertificado )
      ENDIF
      oServer:Open( "POST", ::cWebService, .F. )
      oServer:SetRequestHeader( "SOAPAction", cSoapAction )
      oServer:SetRequestHeader( "Content-Type", "application/soap+xml; charset=utf-8" )
      oServer:Send( ::cXmlSoap )
      oServer:WaitForResponse( 500 )
      cRetorno := oServer:ResponseBody
#ifdef __XHARBOUR__
   END
#else
   ENDSEQUENCE
#endif
   IF ::lGravaTemp
      hb_MemoWrit( "xml1-soap.xml", ::cXmlSoap )
      hb_MemoWrit( "xml2-action.xml", cSoapAction )
      hb_MemoWrit( "xml3-url.xml", ::cWebService )
      hb_MemoWrit( "xml4-retorno.xml", cRetorno )
   ENDIF
   IF ValType( cRetorno ) == "C"
      ::cXmlRetorno := cRetorno
   ELSEIF cRetorno == NIL
      ::cXmlRetorno := "Erro SOAP: na comunicação"
   ELSE
      ::cXmlRetorno := ""
      FOR nCont = 1 TO Len( cRetorno )
         ::cXmlRetorno += Chr( cRetorno[ nCont ] )
      NEXT
   ENDIF
   // IF .NOT. "<cStat>" $ cRetorno
   //   cRetorno := "<cStat>ERRO NO RETORNO</cStat>" + cRetorno
   // ENDIF
   RETURN NIL


#ifdef LIBCURL // pra nao compilar
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
*----------------------------------------------------------------


FUNCTION UFCodigo( cSigla )

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


FUNCTION UFSigla( cCodigo )

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

   cVersao := iif( cVersao == NIL, "3.10", cVersao )

   DO CASE
   CASE cUF == "AM" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFEAUTORIZACAO;             cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao"
      CASE nWsServico == WSNFERETAUTORIZACAO;          cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao"
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/cadconsultacadastro2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeRecepcao2"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico2"
      ENDCASE

   CASE cUF == "AM" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/cadconsultacadastro2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeRecepcao2"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico2"
      ENDCASE

   CASE cUF == "BA" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeCancelamento2.asmx"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeInutilizacao/NfeInutilizacao.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx"
      ENDCASE

   CASE cUF == "BA" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeCancelamento2.asmx"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeConsulta2.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeInutilizacao2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUF == "CE" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl"
      CASE nWsServico == WSNFEDOWNLOADNF ;             cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl"
      ENDCASE

   CASE cUF == "CE" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2"
      ENDCASE

   CASE cUF == "ES"
      DO CASE
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx"
      ENDCASE

   CASE cUF == "GO" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeCancelamento2?wsdl"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeAutorizacao?wsdl"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetAutorizacao?wsdl"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.go.gov.br/nfe/services/v2/RecepcaoEvento?wsdl"
      ENDCASE

   CASE cUF == "GO" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeCancelamento2?wsdl"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcaoEvento?wsdl"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl"
      ENDCASE

   CASE cUF == "MA" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl"
      ENDCASE

   CASE cUF == "MG" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeStatus2"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeAutorizacao"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetAutorizacao"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento"
      ENDCASE

   CASE cUF == "MG" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeStatusServico2"
      ENDCASE

   CASE cUF == "MS" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/CadConsultaCadastro2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRecepcao2"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeStatusServico2"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeAutorizacao"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetAutorizacao"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.fazenda.ms.gov.br/producao/services2/RecepcaoEvento"
      ENDCASE

   CASE cUF == "MS" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/CadConsultaCadastro2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRecepcao2"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/RecepcaoEvento"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeStatusServico2"
      ENDCASE

   CASE cUF == "MT" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeCancelamento2?wsdl"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl"
      ENDCASE

   CASE cUF == "MT" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeCancelamento2?wsdl"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl"
      ENDCASE

   CASE cUF == "PE" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeAutorizacao?wsdl"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetAutorizacao?wsdl"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento"
      ENDCASE

   CASE cUF == "PE" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeCancelamento2"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2"
      ENDCASE

   CASE cUF == "PR" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeCancelamento2?wsdl"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe-evento/NFeRecepcaoEvento?wsdl"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl"
      ENDCASE

   CASE cUF == "PR" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeCancelamento2?wsdl"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeConsulta2?wsdl"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeInutilizacao2?wsdl"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe-evento/NFeRecepcaoEvento?wsdl"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeStatusServico2?wsdl"
      ENDCASE

   CASE cUF == "RN" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://webservice.set.rn.gov.br/projetonfeprod/set_nfe/servicos/CadConsultaCadastroWS.asmx"
      ENDCASE

   CASE cUF == "RN" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://webservice.set.rn.gov.br/projetonfehomolog/set_nfe/servicos/CadConsultaCadastroWS.asmx"
      ENDCASE

   CASE cUF == "RS" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeCancelamento/NfeCancelamento2.asmx"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://sef.sefaz.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/NfeCancelamento/NfeCancelamento2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/Nferecepcao/NFeRecepcao2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/NfeRetRecepcao/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.nfe.sefaz.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      CASE nWsServico == WSNFECONSULTADEST ;           cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx"
      CASE nWsServico == WSNFEDOWNLOADNF ;             cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.sefaz.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      CASE nWsServico == WSMDFEDISTRIBUICAODFE ;       cUrlWs := "https://mdfe.svrs.rs.gov.br/WS/MDFeDistribuicaoDFe/MDFeDistribuicaoDFe.asmx"
      ENDCASE

   CASE cUF == "RS" .AND. cAmbiente == WSHOMOLOGACAO

   CASE cUF == "SP" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSCTECONSULTA ;               cUrlWs := "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx"
      CASE nWsServico == WSCTESTATUSSERVICO ;          cUrlWs := "http://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx"
      // não teve novo
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nfecancelamento2.asmx"
      //CASE nWsServico == WSNFERECEPCAO ;             cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nferecepcao2.asmx"
      //CASE nWsServico == WSNFERETRECEPCAO ;          cUrlWs := "https://nfe.fazenda.sp.gov.br/nfeweb/services/nferetrecepcao2.asmx"
      ENDCASE

   CASE cUF == "SP" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/recepcaoEvento.asmx"
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx"
      // não teve novo
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeCancelamento2.asmx"
      //CASE nWsServico == WSNFERECEPCAO ;             cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeRecepcao2.asmx"
      //CASE nWsServico == WSNFERETRECEPCAO ;          cUrlWs := "https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeRetRecepcao2.asmx"
      ENDCASE

   CASE cUF == "SVAN" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      CASE nWsServico == WSNFEDOWNLOADNF ;             cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      ENDCASE

   CASE cUF == "SVAN" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WSNFEDOWNLOADNF ;             cUrlWs := "https://hom.nfe.fazenda.gov.br/nfedownloadnf/nfedownloadnf.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUF == "SVRS" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECONSULTACADASTRO ;       cUrlWs := "https://nfe.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      ENDCASE

   CASE cUF == "SVRS" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;   cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WSNFECONSULTACADASTRO ;    cUrlWs := "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;        cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;         cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;       cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUF == "SCAN" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://www.scan.fazenda.gov.br/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://www.scan.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://www.scan.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://www.scan.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://www.scan.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://www.scan.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://www.scan.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://www.scan.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://www.scan.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      ENDCASE

   CASE cUF == "SCAN" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECANCELAMENTO ;           cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeCancelamento2/NfeCancelamento2.asmx"
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;      cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;           cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeInutilizacao2/NfeInutilizacao2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://hom.nfe.fazenda.gov.br/SCAN/NfeStatusServico2/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUF == "SVCAN" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECONSULTAPROTOCOLO;       cUrlWs := "https://www.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx"
      CASE nWsServico == WSNFERECEPCAO ;               cUrlWs := "https://www.svc.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx"
      CASE nWsServico == WSNFERETRECEPCAO ;            cUrlWs := "https://www.svc.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;          cUrlWs := "https://www.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;            cUrlWs := "https://www.svc.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;         cUrlWs := "https://www.svc.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://www.svc.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      ENDCASE

   CASE cUF == "SVCRS" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;   cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;        cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;         cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;      cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;       cUrlWs := "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUF == "SVCRS" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSNFECONSULTAPROTOCOLO ;   cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;      cUrlWs := "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx"
      CASE nWsServico == WSNFEINUTILIZACAO ;        cUrlWs := "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx"
      CASE nWsServico == WSNFEAUTORIZACAO ;         cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx"
      CASE nWsServico == WSNFERETAUTORIZACAO ;      cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx"
      CASE nWsServico == WSNFESTATUSSERVICO ;       cUrlWs := "https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx"
      ENDCASE

   CASE cUF == "AN" .AND. cAmbiente == WSPRODUCAO
      DO CASE
      CASE nWsServico == WSMDFECONSULTA ;              cUrlWs := "https://mdfe.sefaz.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx"
      CASE nWsServico == WSMDFERECEPCAO ;              cUrlWs := "https://mdfe.sefaz.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx"
      CASE nWsServico == WSMDFERECEPCAOEVENTO ;        cUrlWs := "https://mdfe.sefaz.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx"
      CASE nWsServico == WSMDFERETRECEPCAO ;           cUrlWs := "https://mdfe.sefaz.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx"
      CASE nWsServico == WSMDFESTATUSSERVICO ;         cUrlWs := "https://mdfe.sefaz.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx"
      CASE nWsServico == WSMDFECONSNAOENC ;            cUrlWs := "https://mdfe.sefaz.rs.gov.br/ws/mdfeconsnaoenc/mdfeconsnaoenc.asmx"
      CASE nWsServico == WSNFECONSULTADEST ;           cUrlWs := "https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx"
      CASE nWsServico == WSNFEDISTRIBUICAODFE;         cUrlWs := "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx"
      CASE nWsServico == WSNFEDOWNLOADNF ;             cUrlWs := "https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx"
      CASE nWsServico == WSNFERECEPCAOEVENTO ;         cUrlWs := "https://www.nfe.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx"
      ENDCASE

   CASE cUF == "AN" .AND. cAmbiente == WSHOMOLOGACAO
      DO CASE
      CASE nWsServico == WSMDFECONSULTA ;              cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx"
      CASE nWsServico == WSMDFERECEPCAO ;              cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx"
      CASE nWsServico == WSMDFERECEPCAOEVENTO ;        cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx"
      CASE nWsServico == WSMDFERETRECEPCAO ;           cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx"
      CASE nWsServico == WSMDFESTATUSSERVICO ;         cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx"
      CASE nWsServico == WSMDFECONSNAOENC ;            cUrlWs := "https://mdfe-hml.sefaz.rs.gov.br/ws/mdfeconsnaoenc/mdfeconsnaoenc.asmx"
      ENDCASE

   ENDCASE
   RETURN cUrlWs
