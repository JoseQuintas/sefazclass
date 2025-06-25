/*
ZE_SEFAZDAMDFE - Documento Auxiliar de Manifesto Eletr�nico de Documentos Fiscais
Baseado no projeto hbnfe em https://github.com/fernandoathayde/hbnfe
Contrbui��o DaMdfe:MSouzaRunner
*/

#include "common.ch"
#include "hbclass.ch"
#include "harupdf.ch"
#include "sefazclass.ch"

#define LAYOUT_LOGO_ESQUERDA        1      /* apenas anotado, mas n�o usado */
#define LAYOUT_LOGO_DIREITA         2
#define LAYOUT_LOGO_EXPANDIDO       3

CREATE CLASS hbnfeDaMDFe INHERIT hbNFeDaGeral

   METHOD ToPDF( cXmlMDFE, cFilePDF, cXmlCancel, oPDF, lEnd )
   METHOD buscaDadosXML()
   METHOD geraPDF( cFilePDF, oPDF, lEnd )
   METHOD novaPagina()
   METHOD cabecalho( nQtFolhas )

   VAR cTelefoneEmitente INIT ""
   VAR cSiteEmitente     INIT ""
   VAR cEmailEmitente    INIT ""
   VAR cXml
   VAR cXmlCancel        INIT ""
   VAR cChave
   VAR aIde
   VAR aCompl
   VAR aEmit
   VAR aMunCarreg
   VAR aModal
   VAR aMunDescarga
   VAR aRem
   VAR aTot
   VAR cLacre
   VAR cInfCpl
   VAR cRntrcEmit
   VAR cRntrcProp
   VAR cCiot
   VAR aCondutor INIT {}
   VAR aInfDoc
   VAR ainfOutros
   VAR aValePed
   VAR aDest
   VAR aLocEnt
   VAR aPrest
   VAR aComp
   VAR cAdfisco
   VAR aInfCarga
   VAR aProp
   VAR aVeiculo
   VAR aProtocolo
   VAR aExped
   VAR aReceb
   VAR aToma

   VAR aReboque
   VAR aInfAdic
   VAR aInfProt
   VAR aInfCanc

   VAR cFonteNFe        INIT "Times"
   VAR cFonteCode128            // Inserido por Anderson Camilo em 04/04/2012
   VAR cFonteCode128F           // Inserido por Anderson Camilo em 04/04/2012
   VAR oPdf
   VAR oPdfPage
   VAR oPDFFontNormal
   VAR oPDFFontBold
   VAR nLinhaPDF
   VAR nLarguraBox INIT 0.5
   VAR lLaser INIT .T.
   VAR lPaisagem
   VAR cLogoFile  INIT ""
   VAR nLogoStyle INIT LAYOUT_LOGO_ESQUERDA

   VAR nLinhaFolha
   VAR nFolhas
   VAR nFolha
   VAR aPageList  INIT {}
   VAR aPageRow   INIT { 0, 0, 0 }

   VAR cRetorno
   VAR PastaPdf

   ENDCLASS

METHOD ToPDF( cXmlMDFE, cFilePDF, cXmlCancel, oPDF, lEnd ) CLASS hbnfeDaMdfe

   hb_Default( @lEnd, .T. )
   IF cXmlMDFE == NIL .OR. Empty( cXmlMDFE )
      ::cRetorno := "Sem conte�do XML pra gerar PDF"
      RETURN ::cRetorno
   ENDIF

   ::cXML       := cXmlMDFE
   IF ! Empty( ::cXmlCancel )
      ::cXmlCancel := cXmlCancel
   ENDIF

   IF Len( ::cXml ) < 100
      ::cXml := Memoread( ::cXml )
   ENDIF
   IF ! Empty( ::cXmlCancel ) .AND. Len( ::cXmlCancel ) < 100
      ::cXmlCancel := MemoRead( ::cXmlCancel )
   ENDIF

   ::cChave     := Substr( ::cXml, At( 'Id=', ::cXml ) + 8, 44 )

   IF !::buscaDadosXML()
      RETURN ::cRetorno
   ENDIF

   ::lPaisagem := .F.

   IF oPDF != Nil
      ::GeraPDF( cFilePDF, oPDF, lEnd )
      oPDF := ::oPDF
      RETURN oPDF
   ENDIF
   IF ! ::GeraPdf( cFilePDF )
      ::cRetorno := "Problema ao gerar o PDF !"
      RETURN ::cRetorno
   ENDIF

   ::cRetorno := "OK"

   RETURN ::cRetorno

METHOD buscaDadosXML() CLASS hbnfeDaMdfe

   LOCAL cText, aList, xItem

   ::aIde         := XmlToHash( XmlNode( ::cXml, "ide" ), { "cUF", "tpAmb", "tpEmis", "mod", "serie", "nMDF", "cMDF", "cDV", "modal", ;
      "dhEmi", "tpEmis", "procEmi", "verProc", "UFIni", "UFFim" } )
   ::aMunCarreg   := XmlToHash( XmlNode( ::cXml, "infMunCarrega" ), { "cMunCarrega" } )
   ::aEmit        := XmlToHash( XmlNode( ::cXml, "emit" ), { "CNPJ", "IE", "xNome", "xFant", "fone" } )
   ::aEmit        := XmlToHash( XmlNode( XmlNode( ::cXml, "emit" ), "enderEmit" ), { "xLgr", "nro", "xCpl", "xBairro", "cMun", "xMun", "CEP", "UF" }, ::aEmit )
   ::aModal       := XmlNode( XmlNode( ::cXml, "rem" ), "versaoModal" )
   ::aMunDescarga := XmlToHash( XmlNode( ::cXml, "infMunDescarga" ), { "cMunDescarga", "xMunDescarga" } )

   ::aInfDoc := {}
   cText     := XmlNode( ::cXml, "infDoc" )
   aList := MultipleNodeToArray( cText, "infCTe" )
   FOR EACH xItem IN aList
      AAdd( ::aInfDoc, { "CTe", XmlNode( xItem, "chCTe" ), "", "" } )
   NEXT

   aList := MultipleNodeToArray( cText, "infNF" )
   FOR EACH xItem IN aList
      AAdd( ::aInfDoc, { "NF", ;
         XmlNode( xItem, "nNF" ) + " " + ;
         XmlNode( xItem, "CNPJ" ) + " " + ;
         XmlNode( xItem, "UF" ) + " " + ;
         XmlNode( xItem, "serie" ) +  " " + ;
         XmlNode( xItem, "dEmi" ) + " " + ;
         XmlNode( xItem, "vNF" ) + " " + ;
         XmlNode( xItem, "PIN" ), "", "" } )
   NEXT

   aList := MultipleNodeToArray( cText, "infNFe" )
   FOR EACH xItem IN aList
      AAdd( ::aInfDoc, { "NFe", ;
         XmlNode( xItem, "chNFe" ), ;
         XmlNode( xItem, "tpUnidTransp" ), ;
         XmlNode( xItem, "idUnidTransp" ) } )
   NEXT
   ::aTot       := XmlToHash( XmlNode( ::cXml, "tot" ), { "qCTe", "qCT", "qNFe", "qNF", "vCarga", "cUnid", "qCarga" } )
   ::cLacre     := XmlNode( ::cXml, "nLacre" )
   ::cInfCpl    := XmlNode( ::cXml, "infCpl" )
   ::cRntrcEmit := XmlNode( XmlNode( ::cXml, "rodo" ), "RNTRC" )
   ::cCiot      := XmlNode( XmlNode( ::cXml, "rodo" ), "CIOT" )
   ::aVeiculo   := XmlToHash( XmlNode( ::cXml, "veicTracao" ), { "placa", "tara" } )
   ::aProp      := XmlToHash( XmlNode( ::cXml, "prop" ), { "RNTRC" } )
   aList := MultipleNodeToArray( ::cXml, "condutor" )
   FOR EACH xItem IN aList
      AAdd( ::aCondutor, XmlToHash( xItem, { "xNome", "CPF" } ) )
   NEXT
   //::aCondutor  := XmlToHash( XmlNode( ::cXml, "condutor" ), { "xNome", "CPF" } )
   ::aReboque   := XmlToHash( XmlNode( ::cXml, "veicReboque" ), { "placa", "tara", "capKG", "RNTRC" } )
   ::aValePed   := XmlToHash( XmlNode( ::cXml, "valePed" ), { "CNPJForn", "CNPJPg", "nCompra" } )
   ::aProtocolo := XmlToHash( XmlNode( ::cXml, "infProt" ), { "nProt", "dhRecbto" } )

   RETURN .T.

METHOD geraPDF( cFilePDF, oPDF, lEnd ) CLASS hbnfeDaMdfe

   LOCAL nQtFolhas, nCont, oPage

   hb_Default( @lEnd, .T. )
   nQtFolhas := 1
   IF Len( ::aInfDoc ) > 11
      nQtFolhas := Int( ( Len( ::aInfDoc ) + 10 ) / 11 )
   ENDIF
   IF oPDF != Nil
      ::oPDF := oPDF
   ELSE
      // criacao objeto pdf
      ::oPDF := HPDF_New()
      IF ::oPDF == NIL
         ::cRetorno := "Falha da cria��o do objeto PDF !"
         RETURN .F.
      ENDIF
      /* set compression mode */
      HPDF_SetCompressionMode( ::oPDF, HPDF_COMP_ALL )
   ENDIF
   /* setando fonte */
   ::oPDFFontNormal     := HPDF_GetFont( ::oPDF, "Times-Roman", "CP1252" )
   ::oPDFFontBold := HPDF_GetFont( ::oPDF, "Times-Bold", "CP1252" )

   // final da criacao e definicao do objeto pdf
   FOR nCont = 1 TO nQtFolhas
      ::nFolha := nCont
      ::novaPagina()
      ::cabecalho( nQtFolhas )
   NEXT
   IF Len( ::aPageList ) != 0
      FOR EACH oPage IN ::aPageList
         ::oPDFPage := oPage
         ::DrawTexto( ::aPageRow[ 1 ], ::aPageRow[ 2 ], ::aPageRow[ 3 ], Nil, ;
            LTrim( Str( oPage:__EnumIndex(), 3 ) ) + "/" + ;
            Ltrim( Str( Len( ::aPageList ), 3 ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
      NEXT
   ENDIF
   IF ! lEnd
      oPDF := ::oPDF
      RETURN oPDF
   ENDIF
   HPDF_SaveToFile( ::oPDF, cFilePDF )
   HPDF_Free( ::oPdf )

   RETURN .T.

METHOD NovaPagina() CLASS hbnfeDaMdfe

   ::oPdfPage := HPDF_AddPage( ::oPdf )
   AAdd( ::aPageList, ::oPdfPage )
   HPDF_Page_SetSize( ::oPdfPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )
   ::nLinhaPdf := HPDF_Page_GetHeight( ::oPDFPage ) - 20    // Margem Superior

   IF ::aIde[ "tpAmb" ] = "2" .OR. ::aProtocolo[ "nProt" ] = Nil
      ::DrawHomologacao()
   ENDIF

   IF ::aIde[ "tpAmb" ] = "1"
      /*
      IF ::aInfCanc[ "nProt" ] <> Nil

      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPDFFontBold, 30 )
      HPDF_Page_BeginText(::oPdfPage)
      HPDF_Page_SetTextMatrix(::oPdfPage, cos(nRadiano), sin(nRadiano), -sin(nRadiano), cos(nRadiano), 15, 100)
      HPDF_Page_SetRGBFill(::oPdfPage, 1, 0, 0)
      HPDF_Page_ShowText(::oPdfPage, ::aInfCanc[ "xEvento" ])
      HPDF_Page_EndText(::oPdfPage)

      HPDF_Page_SetRGBStroke(::oPdfPage, 0.75, 0.75, 0.75)
      IF ::lPaisagem
      ::DrawLine( 15, 95, 675, 475, 2.0)
      ELSE
      ::DrawLine( 15, 95, 550, 630, 2.0)
      ENDIF

      HPDF_Page_SetRGBStroke(::oPdfPage, 0, 0, 0) // reseta cor linhas

      HPDF_Page_SetRGBFill(::oPdfPage, 0, 0, 0) // reseta cor fontes

      ENDIF
      */
   ENDIF

   RETURN NIL

METHOD cabecalho( nQtFolhas ) CLASS hbnfeDaMdfe

   LOCAL nCont, aList, nPos, cURLConsulta := "http:", nItem, xItem

   (nQtFolhas)
   // box do logotipo e dados do emitente

   ::DrawBox( 020, ::nLinhaPdf - 150, 555, 150, ::nLarguraBox )
   IF ::cLogoFile != NIL .AND. ! Empty( ::cLogoFile )
      ::DrawJPEGImage( ::cLogoFile, 025, ::nLinhaPdf - ( 142 + 1 ), 200, 132 )
   ENDIF
   ::DrawTexto( 240, ::nLinhaPdf -005, 560, Nil, ::aEmit[ "xNome" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 14 )
   ::DrawTexto( 240, ::nLinhaPdf -060, 560, Nil, 'CNPJ: ' + TRANSF( ::aEmit[ "CNPJ" ], "@R !!.!!!.!!!/!!!!-!!" ) + '       Inscri��o Estadual: ' + ::FormataIE( ::aEmit[ "IE" ], ::aEmit[ "UF" ] ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawTexto( 240, ::nLinhaPdf -072, 560, Nil, 'Logradouro: ' + ::aEmit[ "xLgr" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawTexto( 240, ::nLinhaPdf -084, 560, Nil, "No.: " + ::aEmit[ "nro" ] + " " + ::aEmit[ "xCpl" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawTexto( 240, ::nLinhaPdf -096, 560, Nil, 'Bairro: ' + ::aEmit[ "xBairro" ] + " - CEP: " + TRANSF( ::aEmit[ "CEP" ], "@R 99999-999" ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawTexto( 240, ::nLinhaPdf -108, 560, Nil, 'Munic�pio: ' + ::aEmit[ "xMun" ] + " - Estado: " + ::aEmit[ "UF" ], HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawTexto( 240, ::nLinhaPdf -120, 560, Nil, 'Fone/Fax:' + ::FormataTelefone( ::aEmit[ "fone" ] ), HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )

   // box do nome do documento
   ::DrawBox( 020, ::nLinhaPdf - 180, 555, 025, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 158, 100, Nil, "DAMDFE", HPDF_TALIGN_LEFT, ::oPDFFontBold, 16 )
   ::DrawTexto( 100, ::nLinhaPdf - 161, 560, Nil, "Documento Auxiliar de Manifesto Eletr�nico de Documentos Fiscais", HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )

   // box do controle do fisco + chave + protocolo
   ::DrawBox( 020, ::nLinhaPdf - 315, 555, 160, ::nLarguraBox )
   ::DrawTexto( 020, ::nLinhaPdf - 185, 560, Nil, "CONTROLE DO FISCO", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 09 )
   ::DrawBarcode128( ::cChave, 150, ::nLinhaPDF - 242, 0.9, 40 )
   aList := WS_MDFE_QRCODE
   nPos := hb_ASCan( aList, { | e | e[ 2 ] == "3.00P" } )
   IF nPos != 0
      cURLConsulta := aList[ nPos, 3 ]
   ENDIF
   ::DrawBarcodeQrcode( 450, ::nLinhaPDF - 185, 1.6, cURLConsulta + "?chMDFe=" + ::cChave + "&" + "tpAmb=" + ::aIde[ "tpAmb" ] )
   ::DrawLine( 020, ::nLinhaPdf - 247, 575, ::nLinhaPdf - 247, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 248, 575, Nil, "Chave de acesso para consulta de autenticidade no site www.mdfe.fazenda.gov.br", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 12 )
   ::DrawTexto( 040, ::nLinhaPdf - 263, 575, Nil, TRANSF( ::cChave, "@R 99.9999.99.999.999/9999-99-99-999-999.999.999-999.999.999-9" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawLine( 020, ::nLinhaPdf - 280, 575, ::nLinhaPdf - 280, ::nLarguraBox )
   // box do No. do Protocolo
   ::DrawTexto( 025, ::nLinhaPdf - 281, 575, Nil, "Protocolo de autoriza��o de uso", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 12 )
   IF ! Empty( ::aProtocolo[ "nProt" ] )
      ::DrawTexto( 025, ::nLinhaPdf - 296, 575, Nil, ::aProtocolo[ "nProt" ] + ' - ' + Substr( ::aProtocolo[ "dhRecbto" ], 9, 2 ) + "/" + Substr( ::aProtocolo[ "dhRecbto" ], 6, 2 ) + "/" + Substr( ::aProtocolo[ "dhRecbto" ], 1, 4 ) + ' ' + Substr( ::aProtocolo[ "dhRecbto" ], 12 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ELSE
      ::DrawTexto( 025, ::nLinhaPdf - 296, 575, Nil, 'MDFe sem Autoriza��o de Uso da SEFAZ', HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ENDIF

   // box do modelo
   ::DrawBox( 020, ::nLinhaPdf - 355, 555, 035, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 320, 85, Nil, "Modelo", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 025, ::nLinhaPdf - 335, 85, Nil, ::aIde[ "mod" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   // box da serie
   ::DrawLine( 85, ::nLinhaPdf - 355, 85, ::nLinhaPdf - 320, ::nLarguraBox )
   ::DrawTexto( 90, ::nLinhaPdf - 320, 150, Nil, "S�rie", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 90, ::nLinhaPdf - 335, 150, Nil, ::aIde[ "serie" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   // box do numero
   ::DrawLine( 150, ::nLinhaPdf - 355, 150, ::nLinhaPdf - 320, ::nLarguraBox )
   ::DrawTexto( 155, ::nLinhaPdf - 320, 245, Nil, "N�mero", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 155, ::nLinhaPdf - 335, 245, Nil, StrZero( Val( ::aIde[ "nMDF" ] ), 6 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   // box do fl
   ::DrawLine( 240, ::nLinhaPdf - 355, 240, ::nLinhaPdf - 320, ::nLarguraBox )
   ::DrawTexto( 245, ::nLinhaPdf - 320, 285, Nil, "FL", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::aPageRow := { 245, ::nLinhaPDF - 335, 285 }
   //::DrawTexto( 245, ::nLinhaPdf - 335, 285, Nil, Str( ::nFolha, 1 ) + "/" + Str( nQtFolhas, 1 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   // box do data e hora
   ::DrawLine( 285, ::nLinhaPdf - 355, 285, ::nLinhaPdf - 320, ::nLarguraBox )
   ::DrawTexto( 290, ::nLinhaPdf - 320, 440, Nil, "Data e Hora de Emiss�o", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 290, ::nLinhaPdf - 335, 440, Nil, Substr( ::aIde[ "dhEmi" ], 9, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 6, 2 ) + "/" + Substr( ::aIde[ "dhEmi" ], 1, 4 ) + ' ' + Substr( ::aIde[ "dhEmi" ], 12 ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   // UF de carregamento
   ::DrawLine( 440, ::nLinhaPdf - 355, 440, ::nLinhaPdf - 320, ::nLarguraBox )
   ::DrawTexto( 445, ::nLinhaPdf - 320, 500, Nil, "UF Carreg.", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 445, ::nLinhaPdf - 335, 500, Nil, ::aIde[ "UFIni" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   // UF de descarregamento
   ::DrawLine( 500, ::nLinhaPDF - 355, 500, ::nLinhaPDF - 320, ::nLarguraBox )
   ::DrawTexto( 505, ::nLinhaPDF - 320, 560, NIL, "UF Descar.", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 505, ::nLinhaPDF - 335, 560, NIL, ::aIde[ "UFFim" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   // box do modal
   ::DrawBox( 020, ::nLinhaPdf - 380, 555, 020, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 363, 560, Nil, "Modal Rodovi�rio de Carga", HPDF_TALIGN_CENTER, ::oPDFFontBold, 12 )
   ::DrawBox( 020, ::nLinhaPdf - 415, 555, 035, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 380, 140, Nil, "CIOT", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 025, ::nLinhaPdf - 295, 140, Nil, ::cCiot, HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   ::DrawLine( 140, ::nLinhaPdf - 415, 140, ::nLinhaPdf - 380, ::nLarguraBox )
   ::DrawTexto( 145, ::nLinhaPdf - 380, 210, Nil, "Qtd. CTe", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 145, ::nLinhaPdf - 395, 210, Nil, ::aTot[ "qCTe" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   ::DrawLine( 210, ::nLinhaPdf - 415, 210, ::nLinhaPdf - 380, ::nLarguraBox )
   ::DrawTexto( 215, ::nLinhaPdf - 380, 280, Nil, "Qtd. CTRC", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 215, ::nLinhaPdf - 395, 280, Nil, ::aTot[ "qCT" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   ::DrawLine( 280, ::nLinhaPdf - 415, 280, ::nLinhaPdf - 380, ::nLarguraBox )
   ::DrawTexto( 285, ::nLinhaPdf - 380, 350, Nil, "Qtd. NFe", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 285, ::nLinhaPdf - 395, 350, Nil, ::aTot[ "qNFe" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   ::DrawLine( 350, ::nLinhaPdf - 415, 350, ::nLinhaPdf - 380, ::nLarguraBox )
   ::DrawTexto( 355, ::nLinhaPdf - 380, 420, Nil, "Qtd. NF", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 355, ::nLinhaPdf - 395, 420, Nil, ::aTot[ "qNF" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   ::DrawLine( 425, ::nLinhaPdf - 415, 425, ::nLinhaPdf - 380, ::nLarguraBox )
   ::DrawTexto( 430, ::nLinhaPdf - 380, 560, Nil, "Peso Total (KG)", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 12 )
   ::DrawTexto( 430, ::nLinhaPdf - 395, 560, Nil, AllTrim( Tran( Val( ::aTot[ "qCarga" ] ), '@E 9,999,999.9999' ) ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )

   ::DrawBox( 020, ::nLinhaPdf - 590, 555, 175, ::nLarguraBox )
   ::DrawLine( 240, ::nLinhaPdf - 430, 240, ::nLinhaPdf - 415, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 415, 240, Nil, "Veiculo", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 12 )
   ::DrawTexto( 245, ::nLinhaPdf - 415, 560, Nil, "Condutor", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 12 )

   ::DrawBox( 020, ::nLinhaPdf - 445, 555, 015, ::nLarguraBox )
   ::DrawLine( 110, ::nLinhaPdf - 520, 110, ::nLinhaPdf - 430, ::nLarguraBox )
   ::DrawLine( 240, ::nLinhaPdf - 590, 240, ::nLinhaPdf - 430, ::nLarguraBox )
   ::DrawLine( 320, ::nLinhaPdf - 590, 320, ::nLinhaPdf - 430, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 430, 110, Nil, "Placa", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawTexto( 115, ::nLinhaPdf - 430, 240, Nil, "RNTRC", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawTexto( 245, ::nLinhaPdf - 430, 320, Nil, "CPF", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawTexto( 325, ::nLinhaPdf - 430, 560, Nil, "Nome", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 10 )
   ::DrawBox( 020, ::nLinhaPdf - 520, 220, 075, ::nLarguraBox )

   ::DrawTexto( 025, ::nLinhaPdf - 445, 110, Nil, ::aVeiculo[ "placa" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )
   IF !Empty( ::aProp[ "RNTRC" ] )
      ::DrawTexto( 115, ::nLinhaPdf - 445, 240, Nil, ::aProp[ "RNTRC" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )
   ELSE
      ::DrawTexto( 115, ::nLinhaPdf - 445, 240, Nil, ::cRntrcEmit, HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )
   ENDIF

   FOR EACH xItem IN ::aCondutor
      ::DrawTexto( 245, ::nLinhaPdf - 445 - ( ( xItem:__EnumIndex - 1 ) * 13 ), 320, Nil, TRANSF( xItem[ "CPF" ], "@R 999.999.999-99" ), HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )
      ::DrawTexto( 325, ::nLinhaPdf - 445 - ( ( xItem:__EnumIndex - 1 ) * 13 ), 560, Nil, xItem[ "xNome" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )
   NEXT

   ::DrawTexto( 025, ::nLinhaPdf - 460, 110, Nil, ::aReboque[ "placa" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )
   ::DrawTexto( 115, ::nLinhaPdf - 460, 240, Nil, ::aReboque[ "RNTRC" ], HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )

   ::DrawBox( 020, ::nLinhaPdf - 535, 220, 015, ::nLarguraBox )
   ::DrawLine( 100, ::nLinhaPdf - 590, 100, ::nLinhaPdf - 535, ::nLarguraBox )
   ::DrawLine( 170, ::nLinhaPdf - 590, 170, ::nLinhaPdf - 535, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 522, 110, Nil, "Vale Ped�gio", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 12 )
   ::DrawTexto( 025, ::nLinhaPdf - 535, 095, Nil, "Respons�vel CNPJ", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 08 )
   ::DrawTexto( 100, ::nLinhaPdf - 535, 170, Nil, "Fornecedor CNPJ", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 08 )
   ::DrawTexto( 175, ::nLinhaPdf - 535, 240, Nil, "No.Comprovante", HPDF_TALIGN_CENTER, ::oPDFFontNormal, 08 )
   IF ! Empty( ::aValePed[ "CNPJPg" ] )
      ::DrawTexto( 025, ::nLinhaPdf - 550, 095, Nil, TRANSF( ::aValePed[ "CNPJPg" ], "@R !!.!!!.!!!/!!!!-!!" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 08 )
   ENDIF
   IF ! Empty( ::aValePed[ "CNPJForn" ] )
      ::DrawTexto( 100, ::nLinhaPdf - 550, 170, Nil, TRANSF( ::aValePed[ "CNPJForn" ], "@R !!.!!!.!!!/!!!!-!!" ), HPDF_TALIGN_CENTER, ::oPDFFontBold, 08 )
   ENDIF
   IF ! Empty( ::aValePed[ "nCompra" ] )
      ::DrawTexto( 175, ::nLinhaPdf - 550, 240, Nil, ::aValePed[ "nCompra" ], HPDF_TALIGN_CENTER, ::oPDFFontBold, 08 )
   ENDIF

   // ::aInfDoc
   ::DrawBox( 020, ::nLinhaPDF - 720, 555, 125, ::nLarguraBox )
   ::DrawTexto( 22, ::nLinhaPDF - 600, 550, NIL, "Informa��o da Composi��o da Carga", HPDF_TALIGN_CENTER, ::oPDFFontBold, 10 )
   ::DrawLine( 20, ::nLinhaPDF - 611, 575, ::nLinhaPDF - 611, ::nLarguraBox )

   ::DrawTexto( 22, ::nLinhaPDF - 612, 550, NIL, "Informa��es dos Documentos Fiscais Vinculados ao Manifesto", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ::DrawTexto( 322, ::nLinhaPDF - 612, 550, NIL, "Identifica��o de Unidade de Transporte", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ::DrawTexto( 432, ::nLinhaPDF - 612, 550, NIL, "Identifica��o de Unidade de Carga", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )

   ::DrawTexto( 22, ::nLinhaPDF - 618, 550, NIL, "TIPO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ::DrawTexto( 42, ::nLinhaPDF - 618, 550, NIL, "CHAVE DE ACESSO", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ::DrawTexto( 322, ::nLinhaPDF - 618, 550, NIL, "TIPO IDENTIFICA��O", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ::DrawTexto( 432, ::nLinhaPDF - 618, 550, NIL, "TIPO IDENTIFICA��O", HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )

   FOR nCont = 1 TO 11
      nItem := ( ::nFolha - 1 ) * 11 + nCont
      IF nItem > Len( ::aInfDoc )
         EXIT
      ENDIF
      ::DrawTexto( 22, ::nLinhaPDF - 622 - ( nCont * 8 ), 550, NIL, ::aInfDoc[nCont,1], HPDF_TALIGN_LEFT, ::oPDFFontBold, 8 )
      ::DrawTexto( 42, ::nLinhaPDF - 622 - ( nCont * 8 ), 550, NIL, ::aInfDoc[nCont,2], HPDF_TALIGN_LEFT, ::oPDFFontBold, 8 )
      ::DrawTexto( 322, ::nLinhaPDF - 622 - ( nCont * 8 ), 550, NIL, ::aInfDoc[nCont,3], HPDF_TALIGN_LEFT, ::oPDFFontBold, 8 )
      ::DrawTexto( 332, ::nLinhaPDF - 622 - ( nCont * 8 ), 550, NIL, ::aInfDoc[nCont,4], HPDF_TALIGN_LEFT, ::oPDFFontBold, 8 )
   NEXT

   ::DrawBox( 020, ::nLinhaPdf - 775, 555, 50, ::nLarguraBox )
   ::DrawTexto( 025, ::nLinhaPdf - 725, 210, Nil, "Observa��es", HPDF_TALIGN_LEFT, ::oPDFFontNormal, 12 )
   ::DrawTexto( 025, ::nLinhaPdf - 740, 560, Nil, ::cInfCpl, HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )
   IF ! Empty( ::cLacre )
      ::DrawTexto( 025, ::nLinhaPdf - 755, 560, Nil, 'No. do Lacre: ' + ::cLacre, HPDF_TALIGN_LEFT, ::oPDFFontBold, 10 )
   ENDIF

   ::Desenvolvedor()

   RETURN NIL
