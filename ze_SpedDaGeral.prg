/*
ZE_SPEDDAGERAL - Rotinas comuns de Documento Auxiliar
2016.11.15
*/

#include "hbzebra.ch"
#include "hbclass.ch"

CREATE CLASS hbNFeDaGeral

   VAR    oPDFPage

   METHOD DrawBarcode128( cBarCode, nAreaX, nAreaY, nBarWidth, nAreaHeight )
   METHOD DrawBarcodeQRCode( nX, nY, nLineWidth, cCode, nFlags )
   METHOD DrawJPEGImage( cJPEGImage, x1, y1, x2, y2 )
   METHOD DrawBox( x1, y1, x2, y2, nPen )                                          INLINE hbNFe_Box_Hpdf( ::oPDFPage, x1, y1, x2, y2, nPen )
   METHOD DrawLine( x1, y1, x2, y2, nPen, FLAG )                                   INLINE hbNFe_Line_Hpdf( ::oPDFPage, x1, y1, x2, y2, nPen, FLAG )
   METHOD DrawTexto( x1, y1, x2, y2, cText, align, oFontePDF, nTamFonte, nAngulo ) INLINE hbNFe_Texto_Hpdf( ::oPDFPage, x1, y1, x2, y2, cText, align, oFontePDF, nTamFonte, nAngulo )
   METHOD DefineDecimais( xValue, nDecimais )
   METHOD FormataMemo( cMemo, nLarguraPDF )
   METHOD LarguraTexto( cText )                                                    INLINE HPDF_Page_TextWidth( ::oPDFPage, cText )

   END CLASS

METHOD DrawJPEGImage( cJPEGImage, x1, y1, x2, y2 ) CLASS hbNFeDaGeral

   IF cJPEGImage == NIL .OR. Empty( cJPEGImage )
      RETURN NIL
   ENDIF
   IF Len( cJPEGImage ) < 100
      cJPEGImage := HPDF_LoadJpegImageFromFile( ::oPDF, cJPEGImage )
   ELSE
      cJPEGImage := HPDF_LoadJpegImageFromMem( ::oPDF, cJPEGImage, Len( cJPEGImage ) )
   ENDIF
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
   nLineHeight := nLineWidth
   IF hb_Zebra_GetError( hZebra ) == 0
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
      DO WHILE Right( xValue, 1 ) == "0"                 // Necessário porque o Harbour não é o Clipper
         xValue := Substr( xValue, 1, Len( xValue ) - 1 )
      ENDDO
      nDecimais := Max( nDecimais, Len( xValue ) )
   ENDIF

   RETURN nDecimais

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
      nRadiano := nAngulo / 180 * 3.141592 /* Calcurate the radian value. */
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

