/*
ZE_SPEDDAGERAL - Rotinas comuns de Documento Auxiliar
Baseado no projeto hbnfe em https://github.com/fernandoathayde/hbnfe
2016.11.15

2017.01.13 - Aceita arquivo como par�metro
*/

#include "hbzebra.ch"
#include "hbclass.ch"
#include "harupdf.ch"

CREATE CLASS hbNFeDaGeral

   VAR    oPDFPage
   VAR    cXml                INIT ""
   VAR    cXmlCancel          INIT ""
   VAR    cDesenvolvedor      INIT ""
   VAR    cLogoFile           INIT ""
   VAR    cRetorno            INIT ""
   VAR    lQuadroEntrega      INIT .T.
   VAR    nLinhaDesenvolvedor INIT 7

   METHOD ToPDF( cXmlDocumento, cFilePDF, cXmlAuxiliar, oPDF, lEnd )
   METHOD DrawBarcode128( cBarCode, nAreaX, nAreaY, nBarWidth, nAreaHeight )
   METHOD DrawBarcodeQRCode( nX, nY, nLineWidth, cCode, nFlags )
   METHOD DrawJPEGImage( cJPEGImage, x1, y1, x2, y2 )
   METHOD DrawBox( x1, y1, x2, y2, nPen )            INLINE hbNFe_Box_Hpdf( ::oPDFPage, x1, y1, x2, y2, nPen )
   METHOD DrawLine( x1, y1, x2, y2, nPen, FLAG )     INLINE hbNFe_Line_Hpdf( ::oPDFPage, x1, y1, x2, y2, nPen, FLAG )
   METHOD DrawTexto( x1, y1, x2, y2, cText, align, oFontePDF, nTamFonte, nAngulo )  INLINE hbNFe_Texto_Hpdf( ::oPDFPage, x1, y1, x2, y2, cText, align, oFontePDF, nTamFonte, nAngulo )
   METHOD DefineDecimais( xValue, nDecimais )
   METHOD FormataString( cTexto, nLarguraPDF, nFontSize )                           INLINE ;
                                                HPDF_Page_SetFontAndSize( ::oPDFPage, ::oPDFFontNormal, nFontSize ), ;
                                                MemoLine( ::FormataMemo( cTexto, nLarguraPDF ), 1000, 1 )
   METHOD FormataMemo( cMemo, nLarguraPDF )
   METHOD LarguraTexto( cText )                      INLINE HPDF_Page_TextWidth( ::oPDFPage, cText + "." ) // 1 caractere pra espa�o
   METHOD FormataTelefone( cText )                   INLINE hbNFe_FormataTelefone( cText )
   METHOD FormataIE( cText )                         INLINE hbNFe_FormataIE( cText )
   METHOD Desenvolvedor( nLinhaPDF )
   METHOD DrawBoxTituloTexto( x, y, w, h, cTitle, cText, nAlign, oPDFFont, nFontSize, nAngle )
   METHOD DrawAviso( cTexto )
   METHOD DrawHomologacao( cTexto )
   METHOD DrawContingencia( cTexto1, cTexto2, cTexto3 )

   ENDCLASS

METHOD DrawJPEGImage( cJPEGImage, x1, y1, x2, y2 ) CLASS hbNFeDaGeral

   IF cJPEGImage == NIL .OR. Empty( cJPEGImage )
      RETURN Nil
   ENDIF
   IF Len( cJPEGImage ) < 100
      IF ! File( cJPEGImage )
         RETURN Nil
      ENDIF
      cJPEGImage := MemoRead( cJPEGImage )
      //cJPEGImage := HPDF_LoadJpegImageFromFile( ::oPDF, cJPEGImage )
   ENDIF
   cJPEGImage := HPDF_LoadJpegImageFromMem( ::oPDF, cJPEGImage, Len( cJPEGImage ) )
   HPDF_Page_DrawImage( ::oPDFPage, cJPEGImage, x1, y1, x2, y2 )

   RETURN NIL

METHOD DrawBarcode128( cBarCode, nAreaX, nAreaY, nBarWidth, nAreaHeight ) CLASS hbNFeDaGeral

   LOCAL hZebra

   hZebra := hb_zebra_create_code128( cBarcode, NIL )
   IF hb_zebra_geterror( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF
   hb_zebra_draw( hZebra, { | x, y, w, h | HPDF_Page_Rectangle( ::oPDFPage, x, y, w, h ) }, nAreaX, nAreaY, nBarWidth, nAreaHeight )
   HPDF_Page_Fill( ::oPDFPage )

   RETURN NIL

METHOD DrawBarcodeQRCode( nX, nY, nLineWidth, cCode, nFlags )

   LOCAL nLineHeight, hZebra

   hZebra := hb_Zebra_Create_QRCode( cCode, nFlags )
   IF hb_Zebra_GetError( hZebra ) == 0
      nLineHeight := nLineWidth
      hb_Zebra_Draw( hZebra, { | x, y, w, h | HPDF_Page_Rectangle( ::oPDFPage, x, y, w, h ) }, nX, nY, nLineWidth, -nLineHeight )
      HPDF_Page_Fill( ::oPDFPage )
      hb_Zebra_Destroy( hZebra )
   ENDIF

   RETURN NIL

METHOD FormataMemo( cMemo, nLarguraPDF ) CLASS hbNFeDaGeral

   LOCAL cNovoTexto := "", cTexto, nPos, nCont

   FOR nCont = 1 TO MLCount( cMemo, 10000 )
      cTexto  := MemoLine( cMemo, 10000, nCont )
      DO WHILE .T.
         nPos := HPDF_Page_MeasureText( ::oPDFPage, cTexto, nLarguraPDF, .T. )
         IF nPos == 0
            nPos := HPDF_Page_MeasureText( ::oPDFPage, cTexto, nLarguraPDF, .F. )
            nPos := Max( nPos, 2 )
         ENDIF
         cNovoTexto += Substr( cTexto, 1, nPos ) + Chr(13) + Chr(10)
         cTexto     := AllTrim( Substr( cTexto, nPos + 1 ) )
         IF Len( cTexto ) == 0
            EXIT
         ENDIF
      ENDDO
   NEXT
   IF Right( cNovoTexto, 2 ) == Chr(13) + Chr(10)
      cNovoTexto := Substr( cNovoTexto, 1, Len( cNovoTexto ) - 2 )
   ENDIF

   RETURN cNovoTexto

METHOD DefineDecimais( xValue, nDecimais ) CLASS hbNFeDaGeral

   xValue := Ltrim( Str( Val( xValue ) ) )
   IF "." $ xValue
      xValue := Substr( xValue, At( ".", xValue ) + 1 )
      DO WHILE Right( xValue, 1 ) == "0"                 // Necess�rio porque o Harbour n�o � o Clipper
         xValue := Substr( xValue, 1, Len( xValue ) - 1 )
      ENDDO
      nDecimais := Max( nDecimais, Len( xValue ) )
   ENDIF

   RETURN nDecimais

METHOD Desenvolvedor( nLinhaPDF ) CLASS hbNFeDaGeral

   hb_Default( @nLinhaPDF, ::nLinhaDesenvolvedor )
   ::DrawTexto( 1, nLinhaPDF, 590, NIL, ::cDesenvolvedor, HPDF_TALIGN_RIGHT, ::oPdfFontBold, 6 )
   IF .F.
      ::DrawTexto( 20, nLinhaPDF, 300, NIL, "DATA DA IMPRESS�O: " + Dtoc( Date() ), HPDF_TALIGN_LEFT, ::oPDFFontBold, 6 )
   ENDIF

   RETURN NIL

METHOD DrawBoxTituloTexto( x, y, w, h, cTitle, cText, nAlign, oPDFFont, nFontSize, nAngle ) CLASS hbNFeDaGeral

   ::DrawBox( x, y - h, w, h, ::nLarguraBox )
   IF ! Empty( cTitle )
      ::DrawTexto( x + 1, y - 1,  x + w - 1, NIL, cTitle, HPDF_TALIGN_LEFT, oPDFFont, 5 )
      ::DrawTexto( x + 1, y - 6,  x + w - 1, NIL, cText, nAlign, oPDFFont, nFontSize, nAngle )
   ELSE
      ::DrawTexto( x + 1, y - 1, x + w - 1, NIL, cText, nAlign, oPDFFont, nFontSize, nAngle )
   ENDIF

   RETURN NIL

METHOD ToPDF( cXmlDocumento, cFilePDF, cXmlAuxiliar, oPDF, lEnd ) CLASS hbNFeDaGeral

   LOCAL oDanfe

   hb_Default( @lEnd, .T. )
   IF cXmlDocumento == NIL .OR. Empty( cXmlDocumento )
      RETURN "XML inv�lido"
   ENDIF
   IF Len( cXmlDocumento ) < 100
      IF File( cXmlDocumento )
         cXmlDocumento := MemoRead( cXmlDocumento )
      ENDIF
   ENDIF
   IF cXmlAuxiliar != NIL .AND. ! Empty( cXmlAuxiliar ) .AND. Len( cXmlAuxiliar ) < 100
      cXmlAuxiliar := MemoRead( cXmlAuxiliar )
   ENDIF
   DO CASE
   CASE "<infMDFe "   $ cXmlDocumento .AND. "<MDFe " $ cXmlDocumento                                                                 ; oDanfe := hbNFeDaMDFe():New()
   CASE "<infCte "    $ cXmlDocumento .AND. "<CTe "  $ cXmlDocumento                                                                 ; oDanfe := hbNFeDaCte():New()
   CASE "<infNFe "    $ cXmlDocumento .AND. "<NFe "  $ cXmlDocumento .AND. XmlNode( XmlNode( cXmlDocumento, "ide" ), "mod" ) == "55" ; oDanfe := hbNFeDaNFe():New()
   CASE "<infNFe "    $ cXmlDocumento .AND. "<NFe "  $ cXmlDocumento .AND. XmlNode( XmlNode( cXmlDocumento, "ide" ), "mod" ) == "65" ; oDanfe := hbNFeDaNFCe():New()
   CASE "<infNFe "    $ cXmlDocumento .AND. "<NFe>"  $ cXmlDocumento .AND. XmlNode( XmlNode( cXmlDocumento, "ide" ), "mod" ) == "55" ; oDanfe := hbNFeDaNFe():New()
   CASE "<infNFe "    $ cXmlDocumento .AND. "<NFe>"  $ cXmlDocumento .AND. XmlNode( XmlNode( cXmlDocumento, "ide" ), "mod" ) == "65" ; oDanfe := hbNFeDaNFCe():New()
   CASE "<infEvento " $ cXmlDocumento                                                                                                ; oDanfe := hbNFeDaEvento():New()
   OTHERWISE
      RETURN "XML inv�lido"
   ENDCASE
   oDanfe:lQuadroEntrega := ::lQuadroEntrega
   oDanfe:cLogoFile      := ::cLogoFile
   oDanfe:cDesenvolvedor := ::cDesenvolvedor

   IF ! lEnd
      oDanfe:ToPDF( cXmlDocumento, cFilePDF, cXmlAuxiliar, oPDF, lEnd )
      oPDF := oDanfe:oPDF
      RETURN oPDF
   ENDIF

   RETURN oDanfe:ToPDF( cXmlDocumento, cFilePDF, cXmlAuxiliar, oPDF, lEnd )

METHOD DrawHomologacao( cTexto ) CLASS hbNFeDaGeral

   LOCAL nRadiano := 45 / 180 * 3.141592 // rotation 45 degrees

   HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPDFFontBold, 30 )
   HPDF_Page_BeginText( ::oPdfPage )
   HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 100 )
   HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
   HPDF_Page_ShowText( ::oPdfPage, iif( cTexto == Nil, "AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL", cTexto ) )
   HPDF_Page_EndText( ::oPdfPage )
   HPDF_Page_SetRGBStroke( ::oPdfPage, 0.75, 0.75, 0.75 )
   ::DrawLine( 15, 100, 550, 630, 2.0 )
   HPDF_Page_SetRGBStroke( ::oPdfPage, 0, 0, 0 ) // reseta cor linhas
   HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes

   RETURN NIL

METHOD DrawContingencia( cTexto1, cTexto2, cTexto3 ) CLASS hbNFeDaGeral

   LOCAL nRadiano := 45 / 180 * 3.141592 // rotation 45 degrees

   IF ! Empty( cTexto1  )
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPDFFontBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 190 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, cTexto1 )
      HPDF_Page_EndText( ::oPdfPage )
   ENDIF
   IF ! Empty( cTexto2 )
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPDFFontBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 160 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, cTexto2 )
      HPDF_Page_EndText( ::oPdfPage )
   ENDIF
   IF ! Empty( cTexto3 )
      HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPDFFontBold, 30 )
      HPDF_Page_BeginText( ::oPdfPage )
      HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 130 )
      HPDF_Page_SetRGBFill( ::oPdfPage, 0.75, 0.75, 0.75 )
      HPDF_Page_ShowText( ::oPdfPage, cTexto3 )
      HPDF_Page_EndText( ::oPdfPage )
   ENDIF
   HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0 ) // reseta cor fontes

   RETURN NIL

METHOD DrawAviso( cTexto ) CLASS hbNFeDaGeral

   LOCAL nRadiano, nAngulo

   nAngulo     := 45                             // A rotation of 45 degrees
   nRadiano    := nAngulo / 180 * 3.141592       // Calcurate the radian value

   HPDF_Page_SetFontAndSize( ::oPdfPage, ::oPDFFontBold, 30 )
   HPDF_Page_BeginText( ::oPdfPage )
   HPDF_Page_SetTextMatrix( ::oPdfPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), 15, 100)
   HPDF_Page_SetRGBFill(::oPdfPage, 1, 0, 0)
   HPDF_Page_ShowText( ::oPdfPage, iif( Empty( cTexto ), "FALTOU TEXTO", cTexto ) )
   HPDF_Page_EndText( ::oPdfPage )
   HPDF_Page_SetRGBStroke( ::oPdfPage, 0.75, 0.75, 0.75 )
   //::DrawLine( 15, 95, 550, 630, 2.0 )
   HPDF_Page_SetRGBStroke( ::oPdfPage, 0, 0, 0 ) // reseta cor linhas
   HPDF_Page_SetRGBFill( ::oPdfPage, 0, 0, 0) // reseta cor fontes

   RETURN NIL

STATIC FUNCTION hbNFe_Texto_Hpdf( oPage, x1, y1, x2, y2, cText, align, oFontePDF, nTamFonte, nAngulo )

   LOCAL nRadiano

   IF oFontePDF <> NIL
      HPDF_Page_SetFontAndSize( oPage, oFontePDF, nTamFonte )
   ENDIF
   IF x2 == NIL
      x2 := x1 - nTamFonte
   ENDIF
   HPDF_Page_BeginText( oPage )
   IF nAngulo == NIL // horizontal normal
      HPDF_Page_TextRect ( oPage,  x1, y1, x2, y2, cText, align, NIL )
   ELSE
      nRadiano := nAngulo / 180 * 3.141592 /* Calculate the radian value. */
      HPDF_Page_SetTextMatrix( oPage, Cos( nRadiano ), Sin( nRadiano ), -Sin( nRadiano ), Cos( nRadiano ), x1, y1 )
      HPDF_Page_ShowText( oPage, cText )
   ENDIF
   HPDF_Page_EndText( oPage )

   RETURN NIL

STATIC FUNCTION hbNFe_Line_Hpdf( oPage, x1, y1, x2, y2, nPen, FLAG )

   HPDF_Page_SetLineWidth( oPage, nPen )
   IF FLAG <> NIL
      HPDF_Page_SetLineCap( oPage, FLAG )
   ENDIF
   HPDF_Page_MoveTo( oPage, x1, y1 )
   HPDF_Page_LineTo( oPage, x2, y2 )
   HPDF_Page_Stroke( oPage )
   IF FLAG <> NIL
      HPDF_Page_SetLineCap( oPage, HPDF_BUTT_END )
   ENDIF

   RETURN NIL

STATIC FUNCTION hbNFe_Box_Hpdf( oPage, x1, y1, x2, y2, nPen )

   HPDF_Page_SetLineWidth( oPage, nPen )
   HPDF_Page_Rectangle( oPage, x1, y1, x2, y2 )
   HPDF_Page_Stroke( oPage )

   RETURN NIL

STATIC FUNCTION hbNFe_FormataTelefone( cText )

   LOCAL cPicture := ""

   cText := iif( ValType( cText ) == "N", Ltrim( Str( cText ) ), cText )
   cText := SoNumero( cText )
   DO CASE
   CASE Len( cText ) == 8  ; cPicture := "@R 9999-9999"
   CASE Len( cText ) == 9  ; cPicture := "@R 99999-9999"
   CASE Len( cText ) == 10 ; cPicture := "@R (99) 9999-9999"
   CASE Len( cText ) == 11 ; cPicture := "@R (99) 99999-9999"
   CASE Len( cText ) == 12 ; cPicture := "@R +99 (99) 9999-9999"
   CASE Len( cText ) == 13 ; cPicture := "@R +99 (99) 99999-9999"
   ENDCASE

   RETURN Transform( cText, cPicture )

STATIC FUNCTION hbNFe_FormataIE( cIE, cUF )

   cIE := AllTrim( cIE )
   IF cIE == "ISENTO" .OR. Empty( cIE )
      RETURN cIE
   ENDIF
   cIE := SoNumero( cIE )

   HB_SYMBOL_UNUSED( cUF )

   RETURN cIE
