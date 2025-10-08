/*
Baseado no projeto hbnfe em https://github.com/fernandoathayde/hbnfe
Contribui��o NFCE: LucianoConforto
*/

#include "hbclass.ch"
#include "harupdf.ch"
#include "sefazclass.ch"

CREATE CLASS hbNFeDaNFCe INHERIT hbNFeDaGeral

   METHOD ToPDF( cXmlNFCe, cFilePDF, cXmlCancel, oPDF, lEnd )
   METHOD BuscaDadosXML()
   METHOD Execute( cXmlNFCe, cFilePDF, ... ) INLINE ::ToPDF( cXmlNFce, cFilePDF, ... )
   METHOD CalculaPDF()
   METHOD GeraPDF( cFilePDF, oPDF, lEnd )
   METHOD NovaPagina()
   METHOD Desenvolvedor()

   METHOD Cabecalho()                     // DIVISAO I    - Informacoes do Cabecalho
   METHOD DetalheProdutosServicos()       // DIVISAO II   - Informacoes de detalhes de produtos/servicos
   METHOD TotaisDanfeNFCe()               // DIVISAO III  - Informacoes de Totais do DANFE NFC-e
   METHOD ConsultaChaveAcesso()           // DIVISAO IV   - Informacoes da consulta via chave de acesso
   METHOD ConsultaChaveQRCode()           // DIVISAO V    - Informacoes da consulta via QR Code
   METHOD Consumidor()                    // DIVISAO VI   - Informacoes sobre o Consumidor
   METHOD IdentificacaoNFCeProtocolo()    // DIVISAO VII  - Informacoes de Identificacao da NFC-e e do Protocolo de Autorizacao
   METHOD AreaMensagemFiscal()            // DIVISAO VIII - Area de Mensagem Fiscal
   METHOD MensagemInteresseContribuinte() // DIVISAO IX   - Mensagem de Interesse do Contribuinte
   METHOD MsgHomologacao()                // Mensagem ref emitida em homologacao
   METHOD MsgContingencia()               // Mensagem ref emitida em contingencia
   METHOD FormatMemoAsArray( cText, nLarguraCol )

   VAR aIde
   VAR aEmit
   VAR aDest
   VAR aItem              INIT {}
   VAR nItem              INIT 0
   VAR aICMSTotal
   VAR aFPags             INIT {}
   VAR cChave
   VAR cQRCode
   VAR aInfProt
   VAR aInfAdic
   VAR lBarcodeChave     INIT .F.

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
   VAR nLinhaAposQrCode INIT 0

   ENDCLASS

METHOD ToPDF( cXmlNFCe, cFilePDF, cXmlCancel, oPDF, lEnd ) CLASS hbNFeDaNFCe

   hb_Default( @lEnd, .T. )
   ::cXml       := cXmlNFCe
   ::cXmlCancel := cXmlCancel
   ::cRetorno := "OK"

   IF Empty( ::cXml )
      ::cRetorno := "XML sem conte�do"
      RETURN ::cRetorno
   ENDIF

   IF Len( ::cXml ) < 100
      ::cXml := Memoread( ::cXml )
   ENDIF
   IF ! Empty( ::cXmlCancel ) .AND. Len( ::cXmlCancel ) < 100
      ::cXmlCancel := MemoRead( ::cXmlCancel )
   ENDIF

   IF ! ::BuscaDadosXML()
      ::cRetorno := "Problema ao buscar dados do XML"
      RETURN ::cRetorno
   ENDIF

   IF ! ::CalculaPDF()
      ::cRetorno := "Problema ao calcular tamanho do PDF"
      RETURN ::cRetorno
   ENDIF
   IF ! lEnd
      ::GeraPDF( cFilePDF, oPDF, lEnd )
      oPDF := ::oPDF
      RETURN oPDF
   ENDIF

   IF ! ::GeraPDF( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF"
      RETURN ::cRetorno
   ENDIF

   (cXmlCancel)

   RETURN ::cRetorno

METHOD BuscaDadosXML() CLASS hbNFeDaNFCe

   LOCAL aFPagsList, cItem, aItem, aFPags, cCodigo, cDescricao, cValor, nPosX

   ::cXml := XmlToString( ::cXml )
   ::aIde         := XmlToHash( XmlNode( ::cXml, "ide" ), { "tpAmb", "cUF", "serie", "nNF", "dhEmi", "tpEmis" } )
   ::aEmit        := XmlToHash( XmlNode( ::cXml, "emit" ), { "CNPJ", "CPF", "IE", "xNome", "xLgr", "nro", "xBairro", "xMun", "UF" } )
   IF Empty( ::aEmit[ "CNPJ" ] )
      ::aEmit[ "CNPJ" ] := ::aEmit[ "CPF" ]
   ENDIF
   ::aDest        := XmlToHash( XmlNode( ::cXml, "dest" ), { "CNPJ", "CPF", "xNome", "xLgr", "nro", "xBairro", "xMun", "UF" } )
   IF Empty( ::aDest[ "CNPJ" ] )
      ::aDest[ "CNPJ" ] := ::aDest[ "CPF" ]
   ENDIF
   ::aICMSTotal   := XmlToHash( XmlNode( ::cXml, "ICMSTot" ), { "vProd", "vFrete", "vSeg", "vOutro", "vDesc", "vNF", "vTotTrib" } )
   ::aInfProt     := XmlToHash( XmlNode( ::cXml, "infProt" ), { "nProt", "dhRecbto" } )
   ::aInfAdic     := XmlToHash( XmlNode( ::cXml, "infAdic" ), { "infAdFisco", "infCpl" } )
   ::cChave       := AllTrim( Substr( XmlElement( ::cXml, "Id" ), 4 ) )
   ::cQRCode      := XmlNode( XmlNode( ::cXml, "infNFeSupl" ), "qrCode" )

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
   aFPagsList := hb_jsonDecode( Loadjson( "tpag.json" ) )

   aFPags := MultipleNodeToArray( ::cXml, "detPag" )
   FOR EACH cItem IN aFPags
      cCodigo := XmlNode( cItem, "tPag" )
      cValor  := XmlNode( cItem, "vPag" )
      IF Empty( cCodigo )
         EXIT
      ENDIF
      IF ( nPosX := hb_AScan( aFPagsList, { | oElement | oElement[ 1 ] == cCodigo } ) ) != 0
         cDescricao := aFPagsList[ nPosX, 2 ]
      ELSE
         cDescricao := "99"
      ENDIF
      AAdd( ::aFPags, { cDescricao, cValor } )
   NEXT
   cValor := XmlNode( ::cXml, "vTroco" )
   IF Len( ::aFPags ) != 0 .AND. Val( cValor ) != 0
      AAdd( ::aFPags, { "Troco R$", cValor } )
   ENDIF

   RETURN .T.

METHOD CalculaPDF() CLASS hbNFeDaNFCe

   LOCAL oPDFPageAltura

   // Funcao para calcular a altura maxima utilizada na impressao da NFCe devido ao
   // fato da nota consumidor se utilizar basicamente de impressoras termicas de papel
   // continuo, nao sendo recomendavel salto de pagina pois acarreta espacos em branco
   // entre as paginas.

   ::oPDF := HPDF_New()

   IF ::oPDF == NIL
      ::cRetorno := "Falha da cria��o do objeto PDF"
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
   ::Desenvolvedor()

   oPDFPageAltura   := ::oPDFPageAltura
   ::oPDFPageAltura := ( oPDFPageAltura - ( ::nLinhaPDF - 10 ) )

   HPDF_Free( ::oPDF )

   RETURN .T.

METHOD GeraPDF( cFilePDF, oPDF, lEnd ) CLASS hbNFeDaNFCe

   hb_Default( @lEnd, .T. )

   IF oPDF != Nil
      ::oPDF := oPDF
   ELSE
      ::oPDF := HPDF_New()
   ENDIF

   IF ::oPDF == NIL
      ::cRetorno := "Falha da cria��o do objeto PDF"
      RETURN .F.
   ENDIF

   IF oPDF != Nil
      HPDF_SetCompressionMode( ::oPDF, HPDF_COMP_ALL )
   ENDIF

   ::oPDFFontNormal := HPDF_GetFont( ::oPDF, "Times-Roman", "CP1252" )
   ::oPDFFontBold   := HPDF_GetFont( ::oPDF, "Times-Bold" , "CP1252" )

   ::NovaPagina()
   ::Cabecalho()
   ::DetalheProdutosServicos()
   ::TotaisDanfeNFCe()
   ::ConsultaChaveAcesso()
   ::ConsultaChaveQRCode()
   ::Consumidor()
   ::IdentificacaoNFCeProtocolo()
   ::AreaMensagemFiscal()
   ::MensagemInteresseContribuinte()
   ::Desenvolvedor()

   IF ! lEnd
      oPDF := ::oPDF
      RETURN oPDF
   ENDIF
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

   LOCAL nPosIni, nTamMax, oElement

   // DIVISAO I - Informacoes do Cabecalho---------------------------------------------------------------------------------------
   IF ::cLogoFile == NIL .OR. Empty( ::cLogoFile )
      nPosIni := 6
      nTamMax := 55
   ELSE
      ::DrawJPEGImage( ::cLogoFile, 3, ::nLinhaPDF - 35, 50, 40 )
      nPosIni := 55
      nTamMax := 45
   ENDIF

   FOR EACH oElement IN ::FormatMemoAsArray( ::aEmit[ "xNome" ], nTamMax )
      ::DrawTexto( nPosIni, ::nLinhaPDF, 220, NIL, oElement, HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
   NEXT
   FOR EACH oElement IN ::FormatMemoAsArray( "CNPJ: " + Trim( FormatCnpj( ::aEmit[ "CNPJ" ] ) ) + " - IE: " + ::aEmit[ "IE" ], nTamMax )
      ::DrawTexto( nPosIni, ::nLinhaPDF, 220, NIL, oElement, HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
   NEXT
   FOR EACH oElement IN ::FormatMemoAsArray( ::aEmit[ "xLgr" ] + ", " + ::aEmit[ "nro" ] + ", " + ::aEmit[ "xBairro" ] + ", " + ::aEmit[ "xMun" ] + ", " + ::aEmit[ "UF" ], nTamMax )
      ::DrawTexto( nPosIni, ::nLinhaPDF, 220, NIL, oElement, HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
   NEXT

   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "DANFE NFC-e - Documento Auxiliar" , HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "da Nota Fiscal de Consumidor Eletr�nica" , HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "N�o permite aproveitamento de cr�dito do ICMS" , HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 10

   ::MsgHomologacao()
   ::MsgContingencia()


   RETURN NIL

METHOD DetalheProdutosServicos() CLASS hbNFeDaNFCe

   LOCAL nContX, nCont, cTexto

   // DIVISAO II - Informacoes de detalhes de produtos/servicos------------------------------------------------------------------
   ::DrawTexto(   6, ::nLinhaPDF, 220, NIL, "C�DIGO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::DrawTexto(  40, ::nLinhaPDF, 220, NIL, "DESCRI��O", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto(  30, ::nLinhaPDF, 220, NIL, "QTD", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::DrawTexto(  50, ::nLinhaPDF, 220, NIL, "UN", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::DrawTexto( 120, ::nLinhaPDF, 220, NIL, "VL.UNIT", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::DrawTexto( 180, ::nLinhaPDF, 220, NIL, "VL.TOTAL", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto(   6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 10

   // "cProd", "xProd", "qCom", "uCom", "vUnCom", "vProd"
   FOR nContX := 1 TO Len( ::aItem )
      //::DrawTexto(  6, ::nLinhaPDF - 10, 220, NIL, ::aItem[ nContX, 1 ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      //FOR EACH oElement IN ::FormatMemoAsArray( ::aItem[ nContx, 2 ], 45 )
      HPDF_Page_SetFontAndSize( ::oPDFPage, ::oPDFFontBold, 7 )
      cTexto := ::FormataMemo( ::aItem[ nContX, 1 ] + "  " + ::aItem[ nContx, 2 ], 200 )
      FOR nCont = 1 TO MLCount( cTexto, 1000 )
         ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, MemoLine( cTexto, 1000, nCont ), HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
         ::nLinhaPDF -= 10
      NEXT

      ::DrawTexto(  6, ::nLinhaPDF,  44, NIL, FormatNumber( Val( ::aItem[ nContX, 3 ] ), 7, 3 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
      ::DrawTexto( 50, ::nLinhaPDF, 220, NIL, ::aItem[ nContX, 4 ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
      ::DrawTexto(  6, ::nLinhaPDF, 146, NIL, FormatNumber( Val( ::aItem[ nContX, 5 ] ), 15, 4 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
      ::DrawTexto(  6, ::nLinhaPDF, 220, NIL, FormatNumber( Val( ::aItem[ nContX, 6 ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
   NEXT

   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 10

   RETURN NIL

METHOD TotaisDanfeNFCe() CLASS hbNFeDaNFCe

   LOCAL nValorAcrescimoDesconto, aItem

   // DIVISAO III - Informacoes de Totais do DANFE NFC-e-------------------------------------------------------------------------
   nValorAcrescimoDesconto := ( Val( ::aICMSTotal[ "vFrete" ] ) + Val( ::aICMSTotal[ "vSeg" ] ) + Val( ::aICMSTotal[ "vOutro" ] ) - Val( ::aICMSTotal[ "vDesc" ] ) )

   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "QTD. TOTAL DE ITENS", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, FormatNumber( ::nItem, 3, 0 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "VALOR TOTAL R$", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, FormatNumber( Val( ::aICMSTotal[ "vProd" ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10

   IF ! Empty( nValorAcrescimoDesconto )
      IF Round( nValorAcrescimoDesconto, 2 ) > 0
         ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "Acr�scimos", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
         ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, FormatNumber( nValorAcrescimoDesconto, 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
      ELSE
         ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "Descontos", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
         ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, FormatNumber( Abs( nValorAcrescimoDesconto ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
      ENDIF
      ::nLinhaPDF -= 10
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "VALOR A PAGAR R$", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, FormatNumber( Val( ::aICMSTotal[ "vNF" ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
   ENDIF
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "FORMA DE PAGAMENTO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "VALOR PAGO R$", HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10

   // Forma Pagamento / Valor Pago
   FOR EACH aItem IN ::aFPags
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, aItem[ 1 ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, FormatNumber( Val( aItem[ 2 ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
   NEXT

   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "Informa��o dos Tributos Totais Incidentes (Fonte: IBPT)", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, FormatNumber( Val( ::aICMSTotal[ "vTotTrib" ] ), 15, 2 ), HPDF_TALIGN_RIGHT, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "(Lei Federal 12.741 / 2012)", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 10

   RETURN NIL

METHOD ConsultaChaveQRCode() CLASS hbNFeDaNFCe

   // DIVISAO V - Informacoes da consulta via QR Code----------------------------------------------------------------------------
   IF Left( ::cQRCode, 9 ) == "<![CDATA["
      ::cQRCode := Substr( ::cQRCode, 10, Len( ::cQRCode ) - 12 )
   ENDIF

   ::nLinhaPDF -= 10
   //::DrawTexto( 6, ::nLinhaPDF - 10, 220, NIL, "Consulta via leitor de QR Code", HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
   ::DrawBarcodeQRCode( 6, ::nLinhaPDF, 1.2, ::cQRCode )
   //::DrawTexto( 6, ::nLinhaPDF - 110, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaAposQrCode := ::nLinhaPDF - 60

   RETURN NIL

METHOD ConsultaChaveAcesso() CLASS hbNFeDaNFCe

   LOCAL cUF, cUrl, cVersao, aUrlList, nPos

   // DIVISAO IV - Informacoes da consulta via chave de acesso -------------------------------------------------------------------
   // ATEN��O: Depende dos endere�os em sefazclass.ch

   cUF      := SefazClass():UFSigla( ::aIde[ "cUF" ] )
   aUrlList := WS_NFE_CHAVE
   cVersao  := "2.00" + iif( ::aIde[ "tpAmb" ] == WS_AMBIENTE_PRODUCAO, "P", "H" )
   nPos     := hb_AScan( aUrlList, { | e | e[ 1 ] == cUF .AND. e[ 2 ] == cVersao } )
   cUrl     := iif( nPos == 0, "", aUrlList[ nPos, 3 ] )

   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "Consulte pela Chave de Acesso em:", HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
   ::nLinhaPDF -= 10

   DO WHILE ! Empty( cUrl )
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Left( cUrl, 65 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
      cUrl := Substr( cUrl, 66 )
   ENDDO

   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "CHAVE DE ACESSO", HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
   ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Transform( ::cChave, "@R 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   //::DrawTexto( 6, ::nLinhaPDF - 25, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 10
   IF ::lBarcodeChave
      ::DrawBarcode128( ::cChave, 6, ::nLinhaPdf - 32, 0.7, 30 )
      ::nLinhaPDF -= 37
   ENDIF

   RETURN NIL

METHOD Consumidor() CLASS hbNFeDaNFCe

   LOCAL cItem


   // DIVISAO VI - Informacoes sobre o Consumidor--------------------------------------------------------------------------------
   IF ! Empty( ::aDest[ "CNPJ" ] )
      ::DrawTexto( 70, ::nLinhaPDF, 220, NIL, "CONSUMIDOR " + ;
         iif( Len( ::aDest[ "CNPJ" ] ) == 11, "CPF", "CNPJ" ) + ": " + ;
         FormatCnpj( ::aDest[ "CNPJ" ] ), HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ELSE
      ::DrawTexto( 70, ::nLinhaPDF, 220, NIL, "CONSUMIDOR N�O IDENTIFICADO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 7 )
   ENDIF
   ::nLinhaPDF -= 10

   IF ! Empty( ::aDest[ "xNome" ] )
      FOR EACH cItem IN ::FormatMemoAsArray( ::aDest[ "xNome" ], 44 )
         ::DrawTexto( 70, ::nLinhaPDF, 220, NIL, cItem, HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
         ::nLinhaPDF -= 10
      NEXT
   ENDIF
   IF ! Empty( ::aDest[ "xLgr" ] )
      //::DrawTexto(  6, ::nLinhaPDF - 10, 220, NIL, "Endereco: ", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
      FOR EACH cItem IN ::FormatMemoAsArray( ::aDest[ "xLgr" ] + ", " + ::aDest[ "nro" ] + ", " + ::aDest[ "xBairro" ] + ", " + ::aDest[ "xMun" ] + ", " + ::aDest[ "UF" ], 44 )
         ::DrawTexto( 70, ::nLinhaPDF, 220, NIL, cItem, HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
         ::nLinhaPDF -= 10
      NEXT
   ENDIF

   //::DrawTexto( 6, ::nLinhaPDF - 5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   //::nLinhaPDF -= 5

   RETURN NIL

METHOD IdentificacaoNFCeProtocolo() CLASS hbNFeDaNFCe

   // DIVISAO VII - Informacoes de Identificacao da NFC-e e do Protocolo de Autorizacao------------------------------------------
   ::DrawTexto( 70, ::nLinhaPDF, 220, NIL, "N�mero: "  + Transform( StrZero( Val( ::aIde[ "nNF" ] ), 9 ), "@R 999999999" ) + " - Serie: " + Transform( StrZero( Val( ::aIde[ "serie" ] ), 3 ), "@R 999" ), HPDF_TALIGN_LEFT, ::oPDFFontBold, 8 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 70, ::nLinhaPDF, 220, NIL, "Emiss�o: " + Substr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 1, 4 ) + "  " + Substr( ::aIde[ "dhEmi" ], 12, 8 ), HPDF_TALIGN_LEFT, ::oPDFFontBold, 8 )
   ::nLinhaPDF -= 10
   //::DrawTexto( 65, ::nLinhaPDF, 220, NIL, "Via Consumidor", HPDF_TALIGN_CENTER, ::oPDFFontBold, 8 )
   //::nLinhaPDF -= 10
   ::DrawTexto( 70, ::nLinhaPDF, 220, NIL, "Protocolo de autoriza��o: " + ::aInfProt[ "nProt" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::nLinhaPDF -= 10
   ::DrawTexto( 70, ::nLinhaPDF, 220, NIL, "Data de autoriza��o: " + Substr( ::aInfProt[ "dhRecbto" ], 9, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 6, 2 ) + "/" + Substr( ::aInfProt[ "dhRecbto" ], 1, 4 ) + " " + Substr( ::aInfProt[ "dhRecbto" ], 12, 8 ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
   ::nLinhaPDF -= 10

   ::nLinhaPDF := Min( ::nLinhaAposQrCode, ::nLinhaPDF )

   ::DrawTexto( 6,  ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
   ::nLinhaPDF -= 10

   RETURN NIL

METHOD AreaMensagemFiscal() CLASS hbNFeDaNFCe

   LOCAL aInfAdFisco, nContX, cText, oElement

   // DIVISAO VIII - Area de Mensagem Fiscal-------------------------------------------------------------------------------------
   FOR EACH cText IN { ";;", ";", "|" }
      ::aInfAdic[ "infAdFisco" ] := StrTran( ::aInfAdic[ "infAdFisco" ], cText, hb_Eol() )
   NEXT

   aInfAdFisco := hb_ATokens( ::aInfAdic[ "infAdFisco" ], hb_eol() )

   IF ::aIde[ "tpAmb" ] == WS_AMBIENTE_HOMOLOGACAO
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "EMITIDA EM AMBIENTE DE HOMOLOGA��O", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::nLinhaPDF -= 10
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "SEM VALOR FISCAL", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::nLinhaPDF -= 10
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPDF -= 10
   ENDIF

   //::MsgContingencia()

   FOR nContX := 1 TO Len( aInfAdFisco )
      FOR EACH oElement IN ::FormatMemoAsArray( aInfAdFisco[ nContX ], 55 )
         ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, oElement, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::nLinhaPDF -= 10
      NEXT
   NEXT

   IF ! Empty( ::aInfAdic[ "infAdFisco" ] )
      ::DrawTexto( 6, ::nLinhaPDF - 5, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPDF -= 10
   ENDIF

   RETURN NIL

METHOD MensagemInteresseContribuinte() CLASS hbNFeDaNFCe

   LOCAL aInfCpl, nContX, oElement, cText

   // DIVISAO IX - Mensagem de Interesse do Contribuinte-------------------------------------------------------------------------
   FOR EACH cText IN { ";;", ";", "|" }
      ::aInfAdic[ "infCpl" ] := StrTran( ::aInfAdic[ "infCpl" ], cText, hb_Eol() )
   NEXT

   aInfCpl := hb_ATokens( ::aInfAdic[ "infCpl" ], hb_eol() )

   FOR nContX := 1 TO Len( aInfCpl )
      FOR EACH oElement IN ::FormatMemoAsArray( aInfCpl[ nContX ], 55 )
         ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, oElement, HPDF_TALIGN_LEFT, ::oPDFFontNormal, 7 )
         ::nLinhaPDF -= 10
      NEXT
   NEXT

   IF ! Empty( ::aInfAdic[ "infCpl" ] )
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPDF -= 10
   ENDIF

   RETURN NIL

METHOD Desenvolvedor() CLASS hbNFeDaNFCe

   IF ! Empty( ::cDesenvolvedor )
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, ::oPDFFontBold, 6 )
      ::nLinhaPDF -= 10
   ENDIF

   RETURN NIL

METHOD FormatMemoAsArray( cText, nLarguraCol ) CLASS hbNFeDaNFCe

   LOCAL aText := {}, nCont, cLinha

   HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPDFFontBold, 7 )
   cText := ::FormataMemo( cText, Int( 220 / 60 * nLarguraCol ) )
   FOR nCont = 1 TO 100
      cLinha := MemoLine( cText, 100, nCont )
      IF Empty( cLinha )
         EXIT
      ENDIF
      AAdd( aText, cLinha )
   NEXT

   RETURN aText

METHOD MsgContingencia() CLASS hbNFeDaNFCe

   IF ::aIde[ "tpEmis" ] == "9"
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "EMITIDA EM CONTING�NCIA", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::nLinhaPDF -= 10
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "PENDENTE DE AUTORIZA��O", HPDF_TALIGN_CENTER, ::oPDFFontBold, 7 )
      ::nLinhaPDF -= 10
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPDF -= 10
   ENDIF

   RETURN NIL

METHOD MsgHomologacao() CLASS hbNFeDaNFCe

   IF ::aIde[ "tpAmb" ] == WS_AMBIENTE_HOMOLOGACAO
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "EMITIDA EM AMBIENTE DE HOMOLOGA��O", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::nLinhaPDF -= 10
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, "SEM VALOR FISCAL", HPDF_TALIGN_CENTER, ::oPDFFontBold, 9 )
      ::nLinhaPDF -= 10
      ::DrawTexto( 6, ::nLinhaPDF, 220, NIL, Replicate( "-", 80 ), HPDF_TALIGN_CENTER, ::oPDFFontNormal, 8 )
      ::nLinhaPDF -= 10
   ENDIF

   RETURN NIL

STATIC FUNCTION LoadJson( cTipo )

   DO CASE
   CASE cTipo == "tpag.json"; #pragma __binarystreaminclude "..\json\sefaztpag.json" | RETURN %s
   ENDCASE

   RETURN Nil
