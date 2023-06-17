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

CREATE CLASS SefazClass_nfe

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
   METHOD NFeAddCancelamento( cXmlAssinado, cXmlCancelamento )

   METHOD SoapUrlNfe( aSoapList, cUF, cVersao )
   METHOD SoapUrlNFCe( aSoapList, cUf, cVersao )

   ENDCLASS

METHOD NFeConsultaCadastro( cCnpj, cUF, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeConsultaGTIN( cGTIN, cCertificado ) CLASS SefazClass_nfe

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

METHOD NFeConsultaProtocolo( cChave, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeDistribuicaoDFe( cCnpj, cUltNSU, cNSU, cChave, cUF, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeEvento( cChave, nSequencia, cTipoEvento, cXml, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeEventoAutor( cChave, cCnpj, cOrgaoAutor, ctpAutor, cverAplic, cAutorCnpj, ctpAutorizacao, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   LOCAL cDescEvento

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeEventoCarta( cChave, nSequencia, cTexto, cCertificado, cAmbiente ) CLASS SefazClass_nfe

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

METHOD NFeEventoCancela( cChave, nSequencia, nProt, xJust, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   LOCAL cXml := ""

   cXml += [<detEvento versao="1.00">]
   cXml +=    XmlTag( "descEvento", "Cancelamento" )
   cXml +=    XmlTag( "nProt", Ltrim( Str( nProt ) ) )
   cXml +=    XmlTag( "xJust", xJust )
   cXml += [</detEvento>]

   ::NFeEvento( cChave, nSequencia, "110111", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

METHOD NFeEventoCancelaSubstituicao( cChave, cOrgaoAutor, cAutor, cVersaoAplicativo, cProtocolo, cJust, cNFRef, cCertificado, cAmbiente ) CLASS SefazClass_nfe

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

METHOD NFeEventoManifestacao( cChave, cCnpj, cCodigoEvento, xJust, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   LOCAL cDescEvento

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cCnpj, "00000000000000" )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeInutiliza( cAno, cCnpj, cMod, cSerie, cNumIni, cNumFim, cJustificativa, cUF, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeContingencia( cXml, cUF, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
   ::cUF           := iif( cUF == NIL, ::cUF, cUF )
   ::cCertificado  := iif( cCertificado == NIL, ::cCertificado, cCertificado )
   ::cAmbiente     := iif( cAmbiente == NIL, ::cAmbiente, cAmbiente )
   ::cXmlDocumento := iif( cXml == NIL, ::cXmlDocumento, cXml )
   ::AssinaXml()
   IF ::cNFCe == "S"
      GeraQRCode( @::cXmlDocumento, ::cIdToken, ::cCSC, ::cVersao, ::cVersaoQrCode )
   ENDIF

   RETURN ::cXmlDocumento

METHOD NFeLoteEnvia( cXml, cLote, cUF, cCertificado, cAmbiente, cIndSinc ) CLASS SefazClass_nfe

   LOCAL oDoc, cChave

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   hb_Default( @cIndSinc, ::cIndSinc )
   ::cProjeto := WS_PROJETO_NFE

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

METHOD NFeConsultaRecibo( cRecibo, cUF, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeStatusServico( cUF, cCertificado, cAmbiente ) CLASS SefazClass_nfe

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeStatusServicoSVC( cUF, cCertificado, cAmbiente, lSVCAN ) CLASS SefazClass_nfe

   LOCAL cVersao

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE

   cVersao := ::cVersao + iif( ::cAmbiente == WS_AMBIENTE_PRODUCAO, "P", "H" )

   ::aSoapUrlList := WS_NFE_STATUSSERVICO
   ::Setup( cUF, cCertificado, cAmbiente )
   ::cSoapAction  := "NfeStatusServico"
   ::cSoapService := "http://www.portalfiscal.inf.br/nfe/wsdl/NFeStatusServico4"

   IF lSVCAN
      ::cSoapURL  := ::SoapUrlNFe( ::aSoapUrlList, "SVCAN", cVersao )
   ELSE
      ::cSoapURL  := ::SoapURLNfe( ::aSoapUrlList, "SVCRS", cVersao )
   ENDIF

   ::cXmlEnvio    := [<consStatServ versao="] + ::cVersao + [" ] + WS_XMLNS_NFE + [>]
   ::cXmlEnvio    +=    XmlTag( "tpAmb", ::cAmbiente )
   ::cXmlEnvio    +=    XmlTag( "cUF", ::UFCodigo( ::cUF ) )
   ::cXmlEnvio    +=    XmlTag( "xServ", "STATUS" )
   ::cXmlEnvio    += [</consStatServ>]
   ::XmlSoapPost()

   RETURN ::cXmlRetorno

METHOD NFeGeraAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass_nfe

   LOCAL cValue

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE
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

METHOD NFeGeraEventoAutorizado( cXmlAssinado, cXmlProtocolo ) CLASS SefazClass_nfe // runner

   hb_Default( @::cVersao, WS_NFE_DEFAULT )
   ::cProjeto := WS_PROJETO_NFE

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

METHOD NFeAddCancelamento( cXmlAssinado, cXmlCancelamento ) CLASS SefazClass_nfe

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
   cUF        := Sefazclass():UFSigla( XmlNode( XmlNode( cInfNFe, "ide" ), "cUF" ) )

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

METHOD SoapUrlNfe( aSoapList, cUF, cVersao ) CLASS Sefazclass_nfe

   LOCAL nPos, cUrl

   nPos := hb_AScan( aSoapList, { | e | ( cUF == e[ 1 ] .OR. e[ 1 ] == "**" ) .AND. cVersao == e[ 2 ] } )
   IF nPos != 0
      cUrl := aSoapList[ nPos, 3 ]
   ENDIF
   DO CASE
   CASE ! Empty( cUrl )
   CASE cUf $ "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO"
      cURL := ::SoapURLNFe( aSoapList, "SVRS", cVersao )
   CASE cUf $ "MA,PA,PI"
      cURL := ::SoapUrlNFe( aSoapList, "SVAN", cVersao )
   ENDCASE

   RETURN cUrl

METHOD SoapUrlNFCe( aSoapList, cUf, cVersao ) CLASS Sefazclass_nfe

   LOCAL cUrl, nPos

   IF cUF $ "AC,ES,RO,RR"
      cUrl := ::SoapUrlNFCe( aSoapList, "SVRS", cVersao  )
   ELSE
      nPos := hb_AScan( aSoapList, { | e | cUF == e[ 1 ] .AND. cVersao + "C" == e[ 2 ] } )
      IF nPos != 0
         cUrl := aSoapList[ nPos, 3 ]
      ENDIF
   ENDIF
   IF Empty( cUrl )
      cUrl := ::SoapUrlNFe( aSoapList, cUF, cVersao )
   ENDIF

   RETURN cUrl

