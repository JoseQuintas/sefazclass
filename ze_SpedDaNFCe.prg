/*
Fontes originais do projeto hbnfe em https://github.com/fernandoathayde/hbnfe
Contribuição NFCE: LucianoConforto
*/

#include "hbclass.ch"
#include "harupdf.ch"

#define WS_AMBIENTE_HOMOLOGACAO      "2"
#define WS_AMBIENTE_PRODUCAO         "1"

CREATE CLASS hbNFeDaNFCe INHERIT hbNFeDaGeral

   METHOD ToPDF( cXmlNFCe, cFilePDF, ... )
   METHOD BuscaDadosXML()
   METHOD Execute( cXmlNFCe, cFilePDF, ... ) INLINE ::ToPDF( cXmlNFce, cFilePDF, ... )
   METHOD CalculaPDF()
   METHOD GeraPDF( cFilePDF )
   METHOD NovaPagina()

   METHOD Cabecalho()                     // DIVISAO I    - Informacoes do Cabecalho
   METHOD DetalheProdutosServicos()       // DIVISAO II   - Informacoes de detalhes de produtos/servicos
   METHOD TotaisDanfeNFCe()               // DIVISAO III  - Informacoes de Totais do DANFE NFC-e
   METHOD ConsultaChaveAcesso()           // DIVISAO IV   - Informacoes da consulta via chave de acesso
   METHOD ConsultaChaveQRCode()           // DIVISAO V    - Informacoes da consulta via QR Code
   METHOD Consumidor()                    // DIVISAO VI   - Informacoes sobre o Consumidor
   METHOD IdentificacaoNFCeProtocolo()    // DIVISAO VII  - Informacoes de Identificacao da NFC-e e do Protocolo de Autorizacao
   METHOD AreaMensagemFiscal()            // DIVISAO VIII - Area de Mensagem Fiscal
   METHOD MensagemInteresseContribuinte() // DIVISAO IX   - Mensagem de Interesse do Contribuinte

   VAR aIde
   VAR aEmit
   VAR aDest
   VAR aItem              INIT {}
   VAR nItem              INIT 0
   VAR aICMSTotal
   VAR aFPags             INIT {}
   VAR cChaveAcesso
   VAR cQRCode
   VAR aInfProt
   VAR aInfAdic

   VAR oPDF
   VAR oPDFPage
   VAR oPDFPageLargura    INIT 226.77 //  80mm - 1 millimeter = 2.834645669291 point (computer)
   VAR oPDFPageAltura     INIT 836.22 // 295mm - 1 millimeter = 2.834645669291 point (computer)
   VAR oPDFFontNormal
   VAR oPDFFontBold
   VAR nLinhaPDF
   VAR cLogoFile          INIT ""
   VAR cXml
   VAR cRetorno

   END CLASS


METHOD ToPDF( cXmlNFCe, cFilePDF, ... ) CLASS hbNFeDaNFCe

   ::cXml     := cXmlNFCe
   ::cRetorno := "OK"

   IF Empty( ::cXml )
      ::cRetorno := "XML sem conteúdo"
      RETURN ::cRetorno
   ENDIF

   IF ! ::BuscaDadosXML()
      ::cRetorno := "Problema ao buscar dados do XML"
      RETURN ::cRetorno
   ENDIF

   IF ! ::CalculaPDF()
      ::cRetorno := "Problema ao calcular tamanho do PDF"
      RETURN ::cRetorno
   ENDIF

   IF ! ::GeraPDF( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF"
      RETURN ::cRetorno
   ENDIF

   RETURN ::cRetorno


METHOD BuscaDadosXML() CLASS hbNFeDaNFCe

   LOCAL aFPagsList, cItem, aItem, aFPags, cFPags, cTipoPgto, cDescPgto, cValorPgto, nPosX

   ::aIde         := XmlToHash( XmlNode( ::cXml, "ide" ), { "tpAmb", "cUF", "serie", "nNF", "dhEmi" } )
   ::aEmit        := XmlToHash( XmlNode( ::cXml, "emit" ), { "CNPJ", "CPF", "IE", "xNome", "xLgr", "nro", "xBairro", "xMun", "UF" } )
   ::aDest        := XmlToHash( XmlNode( ::cXml, "dest" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xBairro", "xMun", "UF" } )
   ::aICMSTotal   := XmlToHash( XmlNode( ::cXml, "ICMSTot" ), { "vProd", "vFrete", "vSeg", "vOutro", "vDesc", "vNF", "vTotTrib" } )
   ::aInfProt     := XmlToHash( XmlNode( ::cXml, "infProt" ), { "nProt", "dhRecbto" } )
   ::aInfAdic     := XmlToHash( XmlNode( ::cXml, "infAdic" ), { "infAdFisco", "infCpl" } )
   ::cChaveAcesso := AllTrim( Substr( XmlElement( ::cXml, "Id" ), 4 ) )
   ::cQRCode      := XmlToString( XmlNode( XmlNode( ::cXml, "infNFeSupl" ), "qrCode" ) )

   // Produtos / Servicos
   DO WHILE .T.
      cItem := XmlNode( ::cXml, [det nItem="]  + AllTrim( Str( ::nItem + 1 ) ) + ["] )
      IF Empty( cItem )
         EXIT
      ENDIF
      aItem := XmlToHash( cItem, { "cProd", "xProd", "qCom", "uCom", "vUnCom", "vProd" } )
      AAdd( ::aItem, { aItem[ "cProd" ], aItem[ "xProd" ], aItem[ "qCom" ], aItem[ "uCom" ], aItem[ "vUnCom" ], aItem[ "vProd" ] } )
      ::nItem++
   ENDDO

   // Formas de Pagamento
   aFPagsList := { { "01", "Dinheiro" }, ;
                   { "02", "Cheque" }, ;
                   { "03", "Cartao de Credito" }, ;
                   { "04", "Cartao de Debito" }, ;
                   { "05", "Credito Loja" }, ;
                   { "10", "Vale Alimentacao" }, ;
                   { "11", "Vale Refeicao" }, ;
                   { "12", "Vale Presente" }, ;
                   { "13", "Vale Combustivel" }, ;
                   { "99", "Outros" } }

   aFPags := MultipleNodeToArray( ::cXml, "pag" )

   FOR EACH cFPags IN aFPags
      cTipoPgto := XmlNode( cFPags, "tPag" )
      IF Empty( cTipoPgto )
         EXIT
      ENDIF
      cValorPgto := XmlNode( cFPags, "vPag" )
      IF ( nPosX := AScan( aFPagsList, { | oElement | oElement[ 1 ] $ cTipoPgto } ) ) != 0
         cDescPgto := aFPagsList[ nPosX, 2 ]
      ELSE
         cDescPgto := "99"
      ENDIF
      AAdd( ::aFPags, { cDescPgto, cValorPgto } )
   NEXT

   RETURN .T.


METHOD CalculaPDF() CLASS hbNFeDaNFCe

   LOCAL oPDFPageAltura

   // Funcao utilizada para calcular a altura maxima utilizada na impressao da NFCe
   // devido ao fato da nota consumidor se utilizar basicamente de impressoras termicas
   // de papel continuo, nao sendo recomendavel salto de pagina pois acarreta espacos
   // em branco entre as paginas.

   ::oPDF := HPDF_New()

   IF ::oPDF == NIL
      ::cRetorno := "Falha da criação do objeto PDF"
      RETURN .F.
   ENDIF

   HPDF_SetCompressionMode( ::oPDF, HPDF_COMP_ALL )

   ::oPDFFontNormal := HPDF_GetFont( ::oPDF, "Times-Roman", "CP1252" )
   ::oPDFFontBold   := HPDF_GetFont( ::oPDF, "Times-Bold" , "CP1252" )

   ::NovaPagina()
   ::Cabecalho()
   ::DetalheProdutosServicos()
   ::TotaisDanfeNFCe()
   ::ConsultaChaveAcesso()
   ::Consumidor()
   ::IdentificacaoNFCeProtocolo()
   ::AreaMensagemFiscal()
   ::ConsultaChaveQRCode()
   ::MensagemInteresseContribuinte()

   oPDFPageAltura   := ::oPDFPageAltura
   ::oPDFPageAltura := ( oPDFPageAltura - ( ::nLinhaPDF - 10 ) )

   HPDF_Free( ::oPDF )

   RETURN .T.


METHOD GeraPDF( cFilePDF ) CLASS hbNFeDaNFCe

   ::oPDF := HPDF_New()

   IF ::oPDF == NIL
      ::cRetorno := "Falha da criação do objeto PDF"
      RETURN .F.
   ENDIF

   HPDF_SetCompressionMode( ::oPDF, HPDF_COMP_ALL )

   ::oPDFFontNormal := HPDF_GetFont( ::oPDF, "Times-Roman", "CP1252" )
   ::oPDFFontBold   := HPDF_GetFont( ::oPDF, "Times-Bold" , "CP1252" )

   ::NovaPagina()
   ::Cabecalho()
   ::DetalheProdutosServicos()
   ::TotaisDanfeNFCe()
   ::ConsultaChaveAcesso()
   ::Consumidor()
   ::IdentificacaoNFCeProtocolo()
   ::AreaMensagemFiscal()
   ::ConsultaChaveQRCode()
   ::MensagemInteresseContribuinte()

   HPDF_SaveToFile( ::oPDF, cFilePDF )
   HPDF_Free( ::oPDF )

   RETURN .T.


METHOD NovaPagina() CLASS hbNFeDaNFCe

   LOCAL nAltura

   ::oPDFPage := HPDF_AddPage( ::oPDF )
   HPDF_Page_SetWidth( ::oPDFPage, ::oPDFPageLargura )
   HPDF_Page_SetHeight( ::oPDFPage, ::oPDFPageAltura )

   nAltura := HPDF_Page_GetHeight( ::oPDFPage )

   ::nLinhaPDF := nAltura - 8 // Margem Superior

   RETURN NIL


METHOD Cabecalho() CLASS hbNFeDaNFCe

   LOCAL nPosIni, nTamMax, nLinha, cLinha

   // DIVISAO I - Informacoes do Cabecalho---------------------------------------------------------------------------------------
   IF ::cLogoFile == NIL .OR. Empty( ::cLogoFile )
      nPosIni := 6
      nTamMax := 60
   ELSE
      ::DrawJPEGImage( ::cLogoFile, 3, ::nLinhaPDF - 35, 50, 40 )
      nPosIni := 55
      nTamMax := 45
   ENDIF

   nLinha := 1
   DO WHILE .T.
      cLinha := Trim( MemoLine( ::aEmit[ "xNome" ], nTamMax, nLinha ) )
      IF Empty( cLinha )
         EXIT
      ENDIF
      ::DrawTexto( nPosIni, ::nLinhaPDF, 220, NIL, cLinha, HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
      nLinha++
   ENDDO

   ::DrawTexto( nPosIni, ::nLinhaPDF, 220, NIL, "CNPJ: " + Transform( ::aEmit[ "CNPJ" ], "@R 99.999.999/9999-99" ) + " - IE: " + ::aEmit[ "IE" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::nLinhaPDF -= 10

   nLinha := 1
   DO WHILE .T.
      cLinha := Trim( MemoLine( ::aEmit[ "xLgr" ] + ", " + ::aEmit[ "nro" ] + ", " + ::aEmit[ "xBairro" ] + ", " + ::aEmit[ "xMun" ] + ", " + ::aEmit[ "UF" ], nTamMax, nLinha ) )
      IF Empty( cLinha )
         EXIT
      ENDIF
      ::DrawTexto( nPosIni, ::nLinhaPDF, 220, NIL, cLinha, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      ::nLinhaPDF -= 10
      nLinha++
   ENDDO

   ::DrawTexto( 6, ::nLinhaPDF     , 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "DANFE NFC-e - Documento Auxiliar" , HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, "da Nota Fiscal de Consumidor Eletronica" , HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 6, ::nLinhaPDF - 30, 220, NIL, "Nao permite aproveitamento de credito do ICMS" , HPDF_TALIGN_CENTER, ::oPDFFontNormal, 7 )
   ::nLinhaPDF -= 30

   IF ::aIde[ "tpAmb" ] == WS_AMBIENTE_HOMOLOGACAO
      ::DrawTexto( 6, ::nLinhaPDF -  5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::DrawTexto( 6, ::nLinhaPDF - 15, 220, NIL, "EMITIDA EM AMBIENTE DE HOMOLOGACAO", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::DrawTexto( 6, ::nLinhaPDF - 25, 220, NIL, "SEM VALOR FISCAL", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::nLinhaPDF -= 25
   ENDIF

   ::DrawTexto( 6, ::nLinhaPDF - 5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 5

   RETURN NIL


METHOD DetalheProdutosServicos() CLASS hbNFeDaNFCe

   LOCAL nContX, nLinha, cLinha

   // DIVISAO II - Informacoes de detalhes de produtos/servicos------------------------------------------------------------------
   ::DrawTexto(   6, ::nLinhaPDF - 10, 220, NIL, "CODIGO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto(  40, ::nLinhaPDF - 10, 220, NIL, "DESCRICAO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto(  30, ::nLinhaPDF - 20, 220, NIL, "QTD", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto(  50, ::nLinhaPDF - 20, 220, NIL, "UN", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 120, ::nLinhaPDF - 20, 220, NIL, "VL.UNIT", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 185, ::nLinhaPDF - 20, 220, NIL, "VL.TOTAL", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto(   6, ::nLinhaPDF - 25, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 25

   // "cProd", "xProd", "qCom", "uCom", "vUnCom", "vProd"
   FOR nContX := 1 TO Len( ::aItem )
      ::DrawTexto(  6, ::nLinhaPDF - 10, 220, NIL, ::aItem[ nContX, 1 ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )

      nLinha := 1
      DO WHILE .T.
         cLinha := Trim( MemoLine( ::aItem[ nContX, 2 ], 45, nLinha ) )
         IF Empty( cLinha )
            EXIT
         ENDIF
         ::DrawTexto( 40, ::nLinhaPDF - 10, 220, NIL, cLinha, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::nLinhaPDF -= 10
         nLinha++
      ENDDO

      ::DrawTexto(  6, ::nLinhaPDF - 10,  44, NIL, FormatNumber( Val( ::aItem[ nContX, 3 ] ), 6, 3 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
      ::DrawTexto( 50, ::nLinhaPDF - 10, 220, NIL, ::aItem[ nContX, 4 ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      ::DrawTexto(  6, ::nLinhaPDF - 10, 146, NIL, FormatNumber( Val( ::aItem[ nContX, 5 ] ), 15, 4 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
      ::DrawTexto(  6, ::nLinhaPDF - 10, 220, NIL, FormatNumber( Val( ::aItem[ nContX, 6 ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
      ::nLinhaPDF -= 10
   NEXT

   ::DrawTexto( 6, ::nLinhaPDF - 5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 5

   RETURN NIL


METHOD TotaisDanfeNFCe() CLASS hbNFeDaNFCe

   LOCAL nValorAcrescimoDesconto, nContX

   // DIVISAO III - Informacoes de Totais do DANFE NFC-e-------------------------------------------------------------------------
   nValorAcrescimoDesconto := ( Val( ::aICMSTotal[ "vFrete" ] ) + Val( ::aICMSTotal[ "vSeg" ] ) + Val( ::aICMSTotal[ "vOutro" ] ) - Val( ::aICMSTotal[ "vDesc" ] ) )

   ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "QTD. TOTAL DE ITENS", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, FormatNumber( ::nItem, 3, 0 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, "VALOR TOTAL R$", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, FormatNumber( Val( ::aICMSTotal[ "vProd" ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
   ::nLinhaPDF -= 20

   IF !Empty( nValorAcrescimoDesconto )
      IF Round( nValorAcrescimoDesconto, 2 ) > 0
         ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "Acrescimos", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, FormatNumber( nValorAcrescimoDesconto, 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
      ELSE
         ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "Descontos", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, FormatNumber( Abs( nValorAcrescimoDesconto ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
      ENDIF
      ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, "VALOR A PAGAR R$", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
      ::nLinhaPDF -= 20
   ENDIF

   ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, "FORMA DE PAGAMENTO", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, "VALOR PAGO R$", HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
   ::nLinhaPDF -= 20

   // Forma Pagamento / Valor Pago
   FOR nContX := 1 TO Len( ::aFPags )
      ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, ::aFPags[ nContX, 1 ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, FormatNumber( Val( ::aFPags[ nContX, 2 ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
      ::nLinhaPDF -= 10
   NEXT

   ::DrawTexto( 6, ::nLinhaPDF -  5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 6, ::nLinhaPDF - 15, 220, NIL, "Informacao dos Tributos Totais Incidentes (Fonte: IBPT)", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 15, 220, NIL, FormatNumber( Val( ::aICMSTotal[ "vTotTrib" ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 25, 220, NIL, "(Lei Federal 12.741 / 2012)", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 30, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 30

   RETURN NIL


METHOD ConsultaChaveAcesso() CLASS hbNFeDaNFCe

   LOCAL cUF, cUFList, cUrl

   // DIVISAO IV - Informacoes da consulta via chave de acesso -------------------------------------------------------------------
   cUFList := "AC,12,AL,27,AM,13,AP,16,BA,29,CE,23,DF,53,ES,32,GO,52,MG,31,MS,50,MT,51,MA,21,PA,15,PB,25,PE,26,PI,22,PR,41,RJ,33,RO,11,RN,24,RR,14,RS,43,SC,42,SE,28,SP,35,TO,17,"
   cUF     := Substr( cUFList, At( ::aIde[ "cUF" ], cUFList ) - 3, 2 )

   // Fonte: http://nfce.encat.org/consumidor/consulte-sua-nota/
   IF ::aIde[ "tpAmb" ] == WS_AMBIENTE_PRODUCAO
      DO CASE
      CASE cUF == "AC" ; cUrl := "www.sefaznet.ac.gov.br/nfce/consulta"
      CASE cUF == "AL" ; cUrl := "http://nfce.sefaz.al.gov.br/consultaNFCe.htm"
      CASE cUF == "AP" ; cUrl := "https://www.sefaz.ap.gov.br/sate/seg/SEGf_AcessarFuncao.jsp?cdFuncao=FIS_1261"
      CASE cUF == "AM" ; cUrl := "sistemas.sefaz.am.gov.br/nfceweb/formConsulta.do"
      CASE cUF == "BA" ; cUrl := "nfe.sefaz.ba.gov.br/servicos/nfce/default.aspx"
      CASE cUF == "CE" ; cUrl := ""
      CASE cUF == "DF" ; cUrl := "http://dec.fazenda.df.gov.br/NFCE/"
      CASE cUF == "ES" ; cUrl := "http://app.sefaz.es.gov.br/ConsultaNFCe"
      CASE cUF == "GO" ; cUrl := ""
      CASE cUF == "MA" ; cUrl := "http://www.nfce.sefaz.ma.gov.br/portal/consultaNFe.do?method=preFilterCupom&"
      CASE cUF == "MT" ; cUrl := "http://www.sefaz.mt.gov.br/nfce/consultanfce"
      CASE cUF == "MS" ; cUrl := "http://www.dfe.ms.gov.br/nfce"
      CASE cUF == "MG" ; cUrl := ""
      CASE cUF == "PA" ; cUrl := "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/consultanfce.seam"
      CASE cUF == "PB" ; cUrl := "www.receita.pb.gov.br/nfce"
      CASE cUF == "PR" ; cUrl := "http://www.fazenda.pr.gov.br"
      CASE cUF == "PE" ; cUrl := ""
      CASE cUF == "PI" ; cUrl := "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf"
      CASE cUF == "RJ" ; cUrl := "www.nfce.fazenda.rj.gov.br/consulta"
      CASE cUF == "RN" ; cUrl := "http://nfce.set.rn.gov.br/consultarNFCe.aspx"
      CASE cUF == "RS" ; cUrl := "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx"
      CASE cUF == "RO" ; cUrl := "http://www.nfce.sefin.ro.gov.br"
      CASE cUF == "RR" ; cUrl := "https://www.sefaz.rr.gov.br/nfce/servlet/wp_consulta_nfce"
      CASE cUF == "SC" ; cUrl := ""
      CASE cUF == "SP" ; cUrl := "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaPublica.aspx"
      CASE cUF == "SE" ; cUrl := "http://www.nfce.se.gov.br/portal/portalNoticias.jsp"
      CASE cUF == "TO" ; cUrl := ""
      ENDCASE
   ELSE
      DO CASE
      CASE cUF == "AC" ; cUrl := "http://hml.sefaznet.ac.gov.br/nfce/consulta"
      CASE cUF == "AL" ; cUrl := "http://nfce.sefaz.al.gov.br/consultaNFCe.htm"
      CASE cUF == "AP" ; cUrl := "https://www.sefaz.ap.gov.br/sate1/seg/SEGf_AcessarFuncao.jsp?cdFuncao=FIS_1261"
      CASE cUF == "AM" ; cUrl := "homnfce.sefaz.am.gov.br/nfceweb/formConsulta.do"
      CASE cUF == "BA" ; cUrl := "http://hnfe.sefaz.ba.gov.br/servicos/nfce/default.aspx"
      CASE cUF == "CE" ; cUrl := "http://nfceh.sefaz.ce.gov.br/pages/consultaNota.jsf"
      CASE cUF == "DF" ; cUrl := "http://dec.fazenda.df.gov.br/NFCE/"
      CASE cUF == "ES" ; cUrl := "http://homologacao.sefaz.es.gov.br/ConsultaNFCe"
      CASE cUF == "GO" ; cUrl := ""
      CASE cUF == "MA" ; cUrl := "http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp"
      CASE cUF == "MT" ; cUrl := "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce"
      CASE cUF == "MS" ; cUrl := "http://www.dfe.ms.gov.br/nfce"
      CASE cUF == "MG" ; cUrl := ""
      CASE cUF == "PA" ; cUrl := "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/consultanfce.seam"
      CASE cUF == "PB" ; cUrl := ""
      CASE cUF == "PR" ; cUrl := "http://www.fazenda.pr.gov.br"
      CASE cUF == "PE" ; cUrl := ""
      CASE cUF == "PI" ; cUrl := "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf"
      CASE cUF == "RJ" ; cUrl := "www.nfce.fazenda.rj.gov.br/consulta"
      CASE cUF == "RN" ; cUrl := "http://nfce.set.rn.gov.br/consultarNFCe.aspx"
      CASE cUF == "RS" ; cUrl := "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx"
      CASE cUF == "RO" ; cUrl := "http://www.nfce.sefin.ro.gov.br"
      CASE cUF == "RR" ; cUrl := "http://200.174.88.103:8080/nfce/servlet/wp_consulta_nfce"
      CASE cUF == "SC" ; cUrl := ""
      CASE cUF == "SP" ; cUrl := "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaPublica.aspx"
      CASE cUF == "SE" ; cUrl := "http://www.hom.nfe.se.gov.br/portal/portalNoticias.jsp"
      CASE cUF == "TO" ; cUrl := ""
      ENDCASE
   ENDIF

   ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "Consulte pela Chave de Acesso em:", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 7 )

   IF Len( cUrl ) <= 69
      ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, cUrl, HPDF_TALIGN_CENTER, ::oPDFFontNormal, 7 )
      ::nLinhaPDF -= 20
   ELSE
      ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, Trim( MemoLine( cUrl, 69, 1 ) ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 7 )
      ::DrawTexto( 6, ::nLinhaPDF - 30, 220, NIL, Trim( MemoLine( cUrl, 69, 2 ) ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 7 )
      ::nLinhaPDF -= 30
   ENDIF

   ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "CHAVE DE ACESSO", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, Transform( ::cChaveAcesso, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::DrawTexto( 6, ::nLinhaPDF - 25, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 25

   RETURN NIL


METHOD ConsultaChaveQRCode() CLASS hbNFeDaNFCe

   // DIVISAO V - Informacoes da consulta via QR Code----------------------------------------------------------------------------
   IF Left( ::cQRCode, 9 ) == "<![CDATA["
      ::cQRCode := SubStr( ::cQRCode, 10, Len( ::cQRCode ) - 12 )
   ENDIF

   ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "Consulta via leitor de QR Code", HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
   ::DrawBarcodeQRCode( 73, ::nLinhaPDF - 25, 1.2, ::cQRCode )
   ::DrawTexto( 6, ::nLinhaPDF - 110, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 110

   RETURN NIL


METHOD Consumidor() CLASS hbNFeDaNFCe

   LOCAL nLinha, cLinha

   // DIVISAO VI - Informacoes sobre o Consumidor--------------------------------------------------------------------------------
   ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "CONSUMIDOR", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )

   IF !Empty( ::aDest[ "CNPJ" ] )
      ::DrawTexto(  6, ::nLinhaPDF - 20, 220, NIL, "CNPJ: ", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      ::DrawTexto( 37, ::nLinhaPDF - 20, 220, NIL, Transform( ::aDest[ "CNPJ" ], "@R 99.999.999/9999-99" ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ELSEIF !Empty( ::aDest[ "CPF" ] )
      ::DrawTexto(  6, ::nLinhaPDF - 20, 220, NIL, "CPF: ", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      ::DrawTexto( 37, ::nLinhaPDF - 20, 220, NIL, Transform( ::aDest[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ELSE
      ::DrawTexto(  6, ::nLinhaPDF - 20, 220, NIL, "CONSUMIDOR NAO IDENTIFICADO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 7 )
   ENDIF
   ::nLinhaPDF -= 20

   IF !Empty( ::aDest[ "CNPJ" ] ) .OR. !Empty( ::aDest[ "CPF" ] )

      ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "Nome: ", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      nLinha := 1
      DO WHILE .T.
         cLinha := Trim( MemoLine( ::aDest[ "xNome" ], 44, nLinha ) )
         IF Empty( cLinha )
            EXIT
         ENDIF
         ::DrawTexto( 37, ::nLinhaPDF - 10, 220, NIL, cLinha, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::nLinhaPDF -= 10
         nLinha++
      ENDDO

      ::DrawTexto(  6, ::nLinhaPDF - 10, 220, NIL, "Endereco: ", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      nLinha := 1
      DO WHILE .T.
         cLinha := Trim( MemoLine( ::aDest[ "xLgr" ] + ", " + ::aDest[ "nro" ] + ", " + ::aDest[ "xBairro" ] + ", " + ::aDest[ "xMun" ] + ", " + ::aDest[ "UF" ], 44, nLinha ) )
         IF Empty( cLinha )
            EXIT
         ENDIF
         ::DrawTexto( 37, ::nLinhaPDF - 10, 220, NIL, cLinha, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::nLinhaPDF -= 10
         nLinha++
      ENDDO
   ENDIF

   ::DrawTexto( 6, ::nLinhaPDF - 5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 5

   RETURN NIL


METHOD IdentificacaoNFCeProtocolo() CLASS hbNFeDaNFCe

   // DIVISAO VII - Informacoes de Identificacao da NFC-e e do Protocolo de Autorizacao------------------------------------------
   ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "Numero: "  + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999999999" ) + " - Serie: " + Transform( StrZero( Val( ::aIde[ "serie" ] ), 3 ), "@R 999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, "Emissao: " + SubStr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + SubStr( ::aIde[ "dhEmi" ], 1, 4 ) + "  " + SubStr( ::aIde[ "dhEmi" ], 12, 8 ) + " - Via Consumidor", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   ::DrawTexto( 6, ::nLinhaPDF - 30, 220, NIL, "Protocolo de autorizacao: " + ::aInfProt[ "nProt" ], HPDF_TALIGN_CENTER, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 40, 220, NIL, "Data de autorizacao: " + SubStr( ::aInfProt[ "dhRecbto" ], 9, 2 ) + "/" + SubStr( ::aInfProt[ "dhRecbto" ], 6, 2 ) + "/" + SubStr( ::aInfProt[ "dhRecbto" ], 1, 4 ) + " " + SubStr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 7 )
   ::DrawTexto( 6, ::nLinhaPDF - 45, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 45

   RETURN NIL


METHOD AreaMensagemFiscal() CLASS hbNFeDaNFCe

   LOCAL aInfAdFisco, nContX, nLinha, cLinha

   // DIVISAO VIII - Area de Mensagem Fiscal-------------------------------------------------------------------------------------
   ::aInfAdic[ "infAdFisco" ] := StrTran( ::aInfAdic[ "infAdFisco" ], ";;", "|" )
   ::aInfAdic[ "infAdFisco" ] := StrTran( ::aInfAdic[ "infAdFisco" ], "|", hb_eol() )

   aInfAdFisco := hb_ATokens( ::aInfAdic[ "infAdFisco" ], hb_eol() )

   IF ::aIde[ "tpAmb" ] == WS_AMBIENTE_HOMOLOGACAO
      ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "EMITIDA EM AMBIENTE DE HOMOLOGACAO", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::DrawTexto( 6, ::nLinhaPDF - 20, 220, NIL, "SEM VALOR FISCAL", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::DrawTexto( 6, ::nLinhaPDF - 25, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPDF -= 25
   ENDIF

   FOR nContX := 1 TO Len( aInfAdFisco )
      nLinha := 1
      DO WHILE .T.
         cLinha := Trim( MemoLine( aInfAdFisco[ nContX ], 55, nLinha ) )
         IF Empty( cLinha )
            EXIT
         ENDIF
         ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, cLinha, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::nLinhaPDF -= 10
         nLinha++
      ENDDO
   NEXT

   IF !Empty( ::aInfAdic[ "infAdFisco" ] )
      ::DrawTexto( 6, ::nLinhaPDF - 5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPDF -= 5
   ENDIF

   RETURN NIL


METHOD MensagemInteresseContribuinte() CLASS hbNFeDaNFCe

   LOCAL aInfCpl, nContX, nLinha, cLinha

   // DIVISAO IX - Mensagem de Interesse do Contribuinte-------------------------------------------------------------------------
   ::aInfAdic[ "infCpl" ] := StrTran( ::aInfAdic[ "infCpl" ], ";;", "|" )
   ::aInfAdic[ "infCpl" ] := StrTran( ::aInfAdic[ "infCpl" ], "|", hb_eol() )

   aInfCpl := hb_ATokens( ::aInfAdic[ "infCpl" ], hb_eol() )

   FOR nContX := 1 TO Len( aInfCpl )
      nLinha := 1
      DO WHILE .T.
         cLinha := Trim( MemoLine( aInfCpl[ nContX ], 55, nLinha ) )
         IF Empty( cLinha )
            EXIT
         ENDIF
         ::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, cLinha, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::nLinhaPDF -= 10
         nLinha++
      ENDDO
   NEXT

   IF !Empty( ::aInfAdic[ "infCpl" ] )
      ::DrawTexto( 6, ::nLinhaPDF - 5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPDF -= 5
   ENDIF

   RETURN NIL
