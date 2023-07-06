/*
ZE_PDFCLASS - PRINT CLASS
José Quintas
*/

// Calculate page: cm * 0.03937 * 72
// cm = centimeter
// 0.03937 = conversion to foot
// 72 = PDF default DPI resolution
// HPDF_Page_SetWidth( oPage, nResultad )
// HPDF_Page_SetHeight( oPage, nResultad )
// TODO: page metric is available only after a page exists
// TODO: Do not depend auto-rotate software

#require "hbhpdf.hbc"
#require "hbct.hbc"

#include "hbclass.ch"
#include "inkey.ch"

#ifndef WIN_SW_SHOWNORMAL
   #define WIN_SW_SHOWNORMAL       1  // Harbour 3.4
   #define WIN_SW_SHOWMINNOACTIVE  7  // Harbour 3.4
#endif
#ifndef WIN_SW_SHOWNORMAL
   #define WIN_SW_SHOWNORMAL       1  // Harbour 3.4
   #define WIN_SW_SHOWMINNOACTIVE  7  // Harbour 3.4
#endif
#define PDFCLASS_DRAWMODE_ROWCOL     1
#define PDFCLASS_DRAWMODE_CENTIMETER 2
#define PDFCLASS_DRAWMODE_PIXEL      3

#define PDFCLASS_PORTRAIT  1
#define PDFCLASS_LANDSCAPE 2
#define PDFCLASS_TXT       3

#define PDFCLASS_PENSIZE 0.5

CREATE CLASS PDFClass

   VAR    oPdf
   VAR    oPage
   VAR    nPageWidth        INIT 595.28  // A4
   VAR    nPageHeight       INIT 841.89  // A4
   VAR    cFileName         INIT ""
   VAR    nRow              INIT 999
   VAR    nCol              INIT 0
   VAR    nAngle            INIT 0
   VAR    cFontName         INIT "Courier"
   VAR    nFontSize         INIT 9
   VAR    nLineHeight       INIT 1.3
   VAR    nTopMargin        INIT 25
   VAR    nLeftMargin       INIT 25
   VAR    nBottomMargin     INIT 25
   VAR    nRightMargin      INIT 25
   VAR    nPrinterType      INIT PDFCLASS_PORTRAIT
   VAR    nPdfPage          INIT 0
   VAR    nPageNumber       INIT 0
   VAR    acHeader          INIT {}
   VAR    cCodePage         INIT "WinAnsiEncoding" // "CP1252"
   VAR    nDrawMode         INIT PDFCLASS_DRAWMODE_ROWCOL
   VAR    lDrawZebrado      INIT .F.
   VAR    cEmployerName     INIT ""
   METHOD AddPage()
   METHOD RowToPDFRow( nValue )
   METHOD ColToPDFCol( nValue )
   METHOD MaxRow()
   METHOD MaxCol()
   METHOD Row( nAddRows )
   METHOD Col( nAddCols )
   METHOD DrawBoxTitleText( nTop, nLeft, nBottom, nRight, cTitle, cText, cPicture, nAlign, nFontSizeText, cFontNameText, nFontSizeTitle, cFontNameTitle )
   METHOD DrawText( nTop, nLeft, xValue, cPicture, nFontSize, cFontName, nAngle, anRGB )
   METHOD DrawLine( nTop, nLeft, nBottom, nRight, nPenSize )
   METHOD DrawBox( nTop, nLeft, nBottom, nRight, nPenSize, nFillType, anRGB )
   METHOD DrawBoxSize( nTop, nLeft, nHeight, nWidth, nPenSize, nFillType, anRGB )
   METHOD DrawImageBox( nTop, nLeft, nBottom, nRight, cJPEGFile, lPNG )
   METHOD DrawImageSize( nRow, nCol, nHeight, nWidth, cJPEGFile, lPNG )
   METHOD DrawMemImageBox( nTop, nLeft, nBottom, nRight, cJPEGMem, lPNG )
   METHOD DrawMemImageSize( nRow, nCol, nHeight, nWidth, cJPEGMem, lPNG )
   METHOD Cancel()
   METHOD LstToPdf( cInputFile )
   METHOD SetType( nPrinterType )
   METHOD PageHeader()
   METHOD PageFooter()
   METHOD MaxRowTest( nRows )
   METHOD SetInfo( cAuthor, cCreator, cTitle, cSubject )
   METHOD Begin()
   METHOD End( lPreview )
   METHOD DrawZebrado( nNivel, lDraw )
   METHOD PDFRun( cFileName ) INLINE ShellExecuteOpen( cFileName )
   METHOD Preview( cFileName, lCompress ) INLINE cFileName, lCompress
   METHOD TempFile( cExtension ) INLINE "report." + cExtension
   METHOD DrawI25BarCode( nRow, nCol, nHeight, cCode, nOneBarWidth )
   METHOD DrawBarcodeQRCode( nRow, nCol, nHeight, cCode, nFlags )

   ENDCLASS

METHOD Row( nAddRows ) CLASS PDFCLass

   IF nAddRows != NIL
      ::nRow += nAddRows
      ::MaxRowTest()
   ENDIF

   RETURN ::nRow

METHOD Col( nAddCols ) CLASS PDFClass

   IF nAddCols != NIL
      ::nCol += nAddCols
   ENDIF

   RETURN ::nCol

METHOD Begin() CLASS PDFClass

   IF ::nPrinterType == PDFCLASS_TXT
      ::cFileName := ::TempFile( "lst" )
      SET PRINTER TO ( ::cFileName )
      SetPrc( 0, 0 )
      SET DEVICE TO PRINT
   ELSE
      ::cFileName := ::TempFile( "pdf" )
      ::oPdf := HPDF_New()
      HPDF_SetCompressionMode( ::oPDF, HPDF_COMP_ALL )
      HPDF_SetCurrentEncoder( ::oPDF, ::cCodePage )
      //HPDF_SetPassword( ::oPDF, "owner", "" )
      //HPDF_SetPermission( ::oPDF, HPDF_ENABLE_READ + HPDF_ENABLE_PRINT ) // + HPDF_ENABLE_EDIT_ALL + HPDF_ENABLE_COPY + HPDF_ENABLE_EDIT )
      ::SetInfo()
   ENDIF

   RETURN NIL

METHOD End( lPreview ) CLASS PDFClass

   hb_Default( @lPreview, .T. )
   ::PageFooter()
   //Mensagem()
   IF ::nPrinterType == PDFCLASS_TXT
      SET PRINTER TO
      SET DEVICE TO SCREEN
      SetPrc(0,0)
      IF lPreview
         ::Preview( ::cFileName, ::nPageWidth == 132 ) // compression
         fErase( ::cFileName )
      ELSE
         SET DEVICE TO PRINT
         SetPrc( 0, 0 )
         @ 0,0 SAY MemoRead( ::cFileName )
         SET DEVICE TO SCREEN
         SET PRINTER TO
         SetPrc( 0, 0 )
         fErase( ::cFileName )
      ENDIF
   ELSE
      IF ::nPdfPage == 0
         ::AddPage()
         ::DrawText( 10, 10, "NENHUM CONTEUDO (NO CONTENT)",, ::nFontSize * 2 )
      ENDIF
      IF File( ::cFileName )
         fErase( ::cFileName )
      ENDIF
      HPDF_SaveToFile( ::oPdf, ::cFileName )
      HPDF_Free( ::oPdf )
      ::PDFRun( ::cFileName )
   ENDIF

   RETURN NIL

METHOD SetInfo( cAuthor, cCreator, cTitle, cSubject ) CLASS PDFClass

   IF ::nPrinterType == PDFCLASS_TXT
      RETURN NIL
   ENDIF
   hb_Default( @cAuthor, "JPA Tecnologia" )
   hb_Default( @cCreator, "Harupdf" )
   hb_Default( @cTitle, "JPA" )
   hb_Default( @cSubject, cTitle )
   IF ! Empty( cAuthor )
      HPDF_SetInfoAttr( ::oPDF, HPDF_INFO_AUTHOR, cAuthor )
   ENDIF
   IF ! Empty( cCreator )
      HPDF_SetInfoAttr( ::oPDF, HPDF_INFO_CREATOR, cCreator )
   ENDIF
   IF ! Empty( cTitle )
      HPDF_SetInfoAttr( ::oPDF, HPDF_INFO_TITLE, cTitle )
   ENDIF
   IF ! Empty( cSubject )
      HPDF_SetInfoAttr( ::oPdf, HPDF_INFO_SUBJECT, cSubject )
   ENDIF
   HPDF_SetInfoDateAttr( ::oPDF, HPDF_INFO_CREATION_DATE, { Year( Date() ), Month( Date() ), Day( Date() ), Val( Substr( Time(), 1, 2 ) ), Val( Substr( Time(), 4, 2 ) ), Val( Substr( Time(), 7, 2 ) ), "+", 4, 0 } )

   RETURN NIL

METHOD SetType( nPrinterType ) CLASS PDFClass

   IF nPrinterType != NIL
      ::nPrinterType := nPrinterType
   ENDIF
   DO CASE
   CASE ::nPrinterType == PDFCLASS_PORTRAIT
      ::nFontSize   := 9
      ::nPageWidth  := 841.89 // A4
      ::nPageHeight := 595.28 // A4
   CASE ::nPrinterType == PDFCLASS_LANDSCAPE
      ::nFontSize   := 6
      ::nPageWidth  := 595.28 // A4
      ::nPageHeight := 841.89 // A4
   CASE ::nPrinterType == PDFCLASS_TXT
      ::nPageWidth  := 132
      ::nPageHeight := 66
   ENDCASE

   RETURN NIL

   /*
   Note: rotate page is bad for screen, better to use automatic adjust when print
   */

METHOD AddPage() CLASS PDFClass

   IF ::nPrinterType != PDFCLASS_TXT
      ::oPage := HPDF_AddPage( ::oPdf )
      //      // HPDF_Page_SetSize( ::oPage, HPDF_PAGE_SIZE_A4, iif( ::nPrinterType == PDFCLASS_LANDSCAPE, HPDF_PAGE_PORTRAIT, HPDF_PAGE_LANDSCAPE ) )
      //      IF ::nPrinterType == PDFCLASS_PORTRAIT
      //         HPDF_Page_SetWidth( ::oPage, ::nPageHeight )
      //         HPDF_Page_SetHeight( ::oPage, ::nPageWidth )
      //         //HPDF_Page_SetRotate( ::oPage, iif( ::nPrinterType == PDFCLASS_LANDSCAPE, 0, 90 ) )
      //      ELSE
      HPDF_Page_SetWidth( ::oPage, ::nPageWidth )
      HPDF_Page_SetHeight( ::oPage, ::nPageHeight )
      //      ENDIF
      HPDF_Page_SetFontAndSize( ::oPage, HPDF_GetFont( ::oPdf, ::cFontName, ::cCodePage ), ::nFontSize )
   ENDIF
   ::nRow := 0

   RETURN NIL

METHOD Cancel() CLASS PDFClass

   IF ::nPrinterType != PDFCLASS_TXT
      HPDF_Free( ::oPdf )
   ENDIF

   RETURN NIL

METHOD DrawBoxTitleText( nTop, nLeft, nBottom, nRight, cTitle, cText, cPicture, nAlign, nFontSizeText, cFontNameText, nFontSizeTitle, cFontNameTitle ) CLASS PDFClass

   hb_Default( @nFontSizeTitle, 6 )
   hb_Default( @cFontNameTitle, ::cFontName )
   hb_Default( @nFontSizeText, ::nFontSize )
   hb_Default( @cFontNameText, ::cFontName )
   hb_Default( @cPicture, "" )
   hb_Default( @nAlign, HPDF_TALIGN_LEFT )

   ::DrawBox( nTop, nLeft, nBottom, nRight )
   cText   := Transform( cText, cPicture )
   ::nCol  := nRight
   nTop    := ::RowToPDFRow( nTop )
   nLeft   := ::ColToPDFCol( nLeft )
   nBottom := ::RowToPDFRow( nBottom )
   nRight  := ::ColToPDFCol( nRight )

   HPDF_Page_SetFontAndSize( ::oPage, HPDF_GetFont( ::oPDF, cFontNameTitle, ::cCodePage ), nFontSizeTitle )
   HPDF_Page_BeginText( ::oPage )
   HPDF_Page_TextRect( ::oPage, nLeft + 2, nTop, nRight - 2, nBottom, cTitle, nAlign, NIL )
   HPDF_Page_EndText( ::oPage )

   HPDF_Page_SetFontAndSize( ::oPage, HPDF_GetFont( ::oPDF, cFontNameText, ::cCodePage ), nFontSizeText )
   HPDF_Page_BeginText( ::oPage )
   HPDF_Page_TextRect( ::oPage, nLeft + 2, nTop - nFontSizeTitle - 1, nRight - 2, nBottom, cText, nAlign, NIL )
   HPDF_Page_EndText( ::oPage )

   RETURN NIL

METHOD DrawText( nTop, nLeft, xValue, cPicture, nFontSize, cFontName, nAngle, anRGB ) CLASS PDFClass

   LOCAL nRadian , cTexto

   hb_Default( @nFontSize, ::nFontSize )
   hb_Default( @cFontName, ::cFontName )
   hb_Default( @cPicture, "" )
   hb_Default( @nAngle, ::nAngle )

   cTexto  := Transform( xValue, cPicture )
   ::nCol  := nLeft + Len( cTexto )
   IF ::nPrinterType == PDFCLASS_TXT
      @ nTop, nLeft SAY cTexto
   ELSE
      nTop  := ::RowToPDFRow( nTop )
      nLeft := ::ColToPDFCol( nLeft )
      HPDF_Page_SetFontAndSize( ::oPage, HPDF_GetFont( ::oPdf, cFontName, ::cCodePage ), nFontSize )
      IF anRGB != NIL
         HPDF_Page_SetRGBFill( ::oPage, anRGB[ 1 ], anRGB[ 2 ], anRGB[ 3 ] )
         HPDF_Page_SetRGBStroke( ::oPage, anRGB[ 1 ], anRGB[ 2], anRGB[ 3] )
      ENDIF
      HPDF_Page_BeginText( ::oPage )
      nRadian := ( nAngle / 180 ) * 3.141592
      HPDF_Page_SetTextMatrix( ::oPage, Cos( nRadian ), Sin( nRadian ), -Sin( nRadian ), Cos( nRadian ), nLeft, nTop )
      HPDF_Page_ShowText( ::oPage, cTexto )
      HPDF_Page_EndText( ::oPage )
      IF anRGB != NIL
         HPDF_Page_SetRGBFill( ::oPage, 0, 0, 0 )
         HPDF_Page_SetRGBStroke( ::oPage, 0, 0, 0 )
      ENDIF
   ENDIF

   RETURN NIL

METHOD DrawLine( nTop, nLeft, nBottom, nRight, nPenSize ) CLASS PDFClass

   IF ::nPrinterType == PDFCLASS_TXT
      IF nTop == nBottom // Matrix can draw line in a single row
         nTop  := Round( nTop, 0 )
         nLeft := Round( nLeft, 0 )
         @ nTop, nLeft SAY Replicate( "-", nRight - nLeft )
         ::nCol := Col()
      ENDIF
   ELSE
      hb_Default( @nPenSize, PDFCLASS_PENSIZE )
      nTop     := ::RowToPDFRow( nTop )
      nLeft    := ::ColToPDFCol( nLeft )
      nBottom  := ::RowToPDFRow( nBottom )
      nRight   := ::ColToPDFCol( nRight )
      HPDF_Page_SetLineWidth( ::oPage, nPenSize )
      HPDF_Page_MoveTo( ::oPage, nLeft, nTop )
      HPDF_Page_LineTo( ::oPage, nRight, nBottom )
      HPDF_Page_Stroke( ::oPage )
   ENDIF

   RETURN NIL

METHOD DrawImageBox( nTop, nLeft, nBottom, nRight, cJPEGFile, lPNG ) CLASS PDFClass

   LOCAL oImage, nWidth, nHeight

   IF ::nPrinterType == PDFCLASS_TXT // .OR. ! File( cJPEGFile )
      RETURN NIL
   ENDIF
   hb_Default( @lPNG, .F. )
   nWidth  :=  ::ColToPdfCol( nRight - nLeft ) - ::ColToPdfCol( 0 )
   nHeight := ( ::RowToPdfRow( 0 ) - ::RowToPdfRow( nBottom - nTop ) )
   nBottom := ::RowToPDFRow( nBottom )
   nLeft   := ::ColToPdfCol( nLeft )
   IF lPNG
      oImage  := HPDF_LoadPNGImageFromFile( ::oPdf, cJPEGFile )
   ELSE
      oImage  := HPDF_LoadJPEGImageFromFile( ::oPdf, cJPEGFile )
   ENDIF
   HPDF_Page_DrawImage( ::oPage, oImage, nLeft, nBottom, nWidth, nHeight )

   RETURN NIL

METHOD DrawImageSize( nRow, nCol, nHeight, nWidth, cJPEGFile, lPNG ) CLASS PDFClass

   ::DrawImageBox( nRow, nCol, nRow + nHeight, nCol + nWidth, cJPEGFile, lPNG )

   RETURN NIL

METHOD DrawMemImageBox( nTop, nLeft, nBottom, nRight, cJPEGMem, lPNG ) CLASS PDFClass

   LOCAL oImage, nWidth, nHeight

   IF ::nPrinterType == PDFCLASS_TXT
      RETURN NIL
   ENDIF
   IF cJPEGMem == NIL
      RETURN NIL
   ENDIF
   hb_Default( @lPNG, .F. )
   nWidth  :=  ::ColToPdfCol( nRight - nLeft ) - ::ColToPdfCol( 0 )
   nHeight := ( ::RowToPdfRow( 0 ) - ::RowToPdfRow( nBottom - nTop ) )
   nBottom := ::RowToPDFRow( nBottom )
   nLeft   := ::ColToPdfCol( nLeft )
   IF lPNG
      oImage  := HPDF_LoadPNGImageFromMem( ::oPDF, cJPEGMem, Len( cJPEGMem ) )
   ELSE
      oImage  := HPDF_LoadJPEGImageFromMem( ::oPDF, cJPEGMem, Len( cJPEGMem ) )
   ENDIF
   HPDF_Page_DrawImage( ::oPage, oImage, nLeft, nBottom, nWidth, nHeight )

   RETURN NIL

METHOD DrawMemImageSize( nRow, nCol, nHeight, nWidth, cJPEGMem, lPNG ) CLASS PDFClass

   ::DrawMemImageBox( nRow, nCol, nRow + nHeight, nCol + nWidth, cJPEGMem, lPNG )

   RETURN NIL

METHOD DrawBox( nTop, nLeft, nBottom, nRight, nPenSize, nFillType, anRGB ) CLASS PDFClass

   LOCAL nWidth, nHeight

   IF ::nPrinterType == PDFCLASS_TXT
      RETURN NIL
   ENDIF
   hb_Default( @nFillType, 1 )
   hb_Default( @nPenSize, PDFCLASS_PENSIZE )
   nWidth    := nRight - nLeft
   nHeight   := nBottom - nTop
   nTop      := ::RowToPDFRow( nTop )
   nLeft     := ::ColToPDFCol( nLeft )
   nWidth    := ::ColToPdfCol( nWidth ) - ::ColToPdfCol( 0 )
   nHeight   := -( ::RowToPdfRow( 0 ) - ::RowToPdfRow( nHeight ) )
   HPDF_Page_SetLineWidth( ::oPage, nPenSize )
   IF anRGB != NIL
      HPDF_Page_SetRGBFill( ::oPage, anRGB[ 1 ], anRGB[ 2 ], anRGB[ 3 ] )
      HPDF_Page_SetRGBStroke( ::oPage, anRGB[ 1 ], anRGB[ 2 ], anRGB[ 3 ] )
   ENDIF
   HPDF_Page_Rectangle( ::oPage, nLeft, nTop, nWidth, nHeight )
   IF nFillType == 1
      HPDF_Page_Stroke( ::oPage )     // borders only
   ELSEIF nFillType == 2
      HPDF_Page_Fill( ::oPage )       // inside only
   ELSE
      HPDF_Page_FillStroke( ::oPage ) // all
   ENDIF
   IF anRGB != NIL
      HPDF_Page_SetRGBStroke( ::oPage, 0, 0, 0 )
      HPDF_Page_SetRGBFill( ::oPage, 0, 0, 0 )
   ENDIF

   RETURN NIL

METHOD DrawBoxSize( nTop, nLeft, nHeight, nWidth, nPenSize, nFillType, anRGB ) CLASS PDFClass

   ::DrawBox( nTop, nLeft, nTop + nHeight, nLeft + nWidth, nPenSize, nFillType, anRGB )

   RETURN NIL

METHOD RowToPDFRow( nValue ) CLASS PDFClass

   DO CASE
   CASE ::nDrawMode == PDFCLASS_DRAWMODE_ROWCOL
      nValue := ::nPageHeight - ::nBottomMargin - ( nValue * ::nFontSize * ::nLineHeight )
   CASE ::nDrawMode == PDFCLASS_DRAWMODE_CENTIMETER
      nValue := ::nPageHeight - ( nValue * 2.83464 )
   CASE ::nDrawMode == PDFCLASS_DRAWMODE_PIXEL
      nValue := ::nPageHeight - nValue
   ENDCASE

   RETURN nValue

METHOD ColToPDFCol( nValue ) CLASS PDFClass

   DO CASE
   CASE ::nDrawMode == PDFCLASS_DRAWMODE_ROWCOL
      nValue := nValue * ::nFontSize / 1.666 + ::nLeftMargin
   CASE ::nDrawMode == PDFCLASS_DRAWMODE_CENTIMETER
      nValue := nValue * 2.83464 // 72 * 0.03937
   CASE ::nDrawMode == PDFCLASS_DRAWMODE_PIXEL
      // Nothing to do
   ENDCASE

   RETURN nValue

METHOD MaxRow() CLASS PDFClass

   LOCAL nPageHeight, nMaxRow

   IF ::nPrinterType == PDFCLASS_TXT
      RETURN 63
   ENDIF
   nPageHeight := ::nPageHeight - ::nTopMargin - ::nBottomMargin
   nMaxRow     := Int( nPageHeight / ( ::nFontSize * ::nLineHeight )  )

   RETURN nMaxRow

METHOD MaxCol() CLASS PDFClass

   LOCAL nPageWidth, nMaxCol

   IF ::nPrinterType == PDFCLASS_TXT
      RETURN ::nPageWidth
   ENDIF
   nPageWidth := ::nPageWidth - ::nRightMargin - ::nLeftMargin
   nMaxCol    := Int( nPageWidth / ::nFontSize * 1.666 )

   RETURN nMaxCol

METHOD LstToPdf( cInputFile ) CLASS PDFClass

   LOCAL cTxtReport, cTxtPage, cTxtLine, nRow

   cTxtReport := MemoRead( cInputFile ) + Chr(12)
   TokenInit( @cTxtReport, Chr(12) )
   DO WHILE ! TokenEnd()
      cTxtPage := TokenNEXT( cTxtReport ) + hb_eol()
      IF Len( cTxtPage ) > 5
         IF Substr( cTxtPage, 1, 1 ) == Chr(13)
            cTxtPage := Substr( cTxtPage, 2 )
         ENDIF
         ::AddPage()
         nRow := 0
         DO WHILE At( hb_eol(), cTxtPage ) != 0
            cTxtLine := Substr( cTxtPage, 1, At( hb_eol(), cTxtPage ) - 1 )
            cTxtPage := Substr( cTxtPage, At( hb_eol(), cTxtPage ) + 2 )
            ::DrawText( nRow++, 0, cTxtLine )
         ENDDO
      ENDIF
   ENDDO

   RETURN NIL

METHOD PageHeader() CLASS PDFClass

   LOCAL nCont

   IF Len( ::acHeader ) > 0
      IF ::nPageNumber != 0 .AND. ::nRow != 0 .AND. ::nPdfPage != 0
         ::PageFooter()
      ENDIF
   ENDIF
   ::nPdfPage    += 1
   ::nPageNumber += 1
   ::nRow        := 0
   //Mensagem( "Printing, page " + StrZero( ::nPageNumber, 7 ) )
   ::AddPage()
   IF Len( ::acHeader ) > 0
      ::DrawText( 0, 0, ::cEmployerName )
      ::DrawText( 0, ( ::MaxCol() - Len( ::acHeader[ 1 ] ) ) / 2, ::acHeader[ 1 ] )
      ::DrawText( 0, ::MaxCol() - 11, "Page " + StrZero( ::nPageNumber, 6 ) )
      ::DrawLine( 0.5, 0, 0.5, ::MaxCol() )
      ::nRow := 2
      IF Len( ::acHeader ) > 1
         FOR nCont = 2 TO Len( ::acHeader )
            IF ! Empty( ::acHeader[ nCont ] )
               IF nCont == 2
                  ::DrawText( ::nRow++, 0, Padc( AllTrim( ::acHeader[ 2 ] ), ::MaxCol() ) )
               ELSE
                  ::DrawText( ::nRow++, 0, ::acHeader[ nCont ] )
               ENDIF
            ENDIF
         NEXT
         ::DrawLine( ::nRow - 0.5, 0, ::nRow++ - 0.5, ::MaxCol() )
         ::nRow++
      ENDIF
   ENDIF
   ::nCol := 0

   RETURN NIL

METHOD PageFooter() CLASS PDFClass

   //LOCAL cTxt
   //MEMVAR m_Prog

   //IF Len( ::acHeader ) != 0 .AND. ::nPdfPage != 0
   //   cTxt := "JPA/" + m_Prog + "/" + Right( Dtos( Date() ), 6 ) + ;
   //      Subsr( Time(), 1, 2 ) + Substr( Time(), 4, 2 ) + Substr( Time(), 7, 2 )
   //   ::DrawLine( ::MaxRow(), 0, ::MaxRow(), ::MaxCol() - Len( cTxt ) )
   //   ::DrawText( ::MaxRow(), ::MaxCol() - Len( cTxt ), cTxt )
   //ENDIF

   RETURN NIL

METHOD MaxRowTest( nRows ) CLASS PDFClass

   hb_Default( @nRows, 0 )
   IF ::nRow > ::MaxRow() - 2 - nRows
      ::PageHeader()
   ENDIF

   RETURN NIL

METHOD DrawZebrado( nNivel, lDraw ) CLASS PDFClass

   LOCAL nColor

   hb_Default( @nNivel, 1 )
   hb_Default( @lDraw, .F. )
   nNivel := iif( nNivel < 1, 1, iif( nNivel > 5, 5, nNivel ) )
   nColor := ( 10 - nNivel ) / 10   // 0.9, 0.8, 0.7, 0.6
   IF nNivel != 1 .OR. ::lDrawZebrado .OR. lDraw
      ::DrawBox( ::nRow - 1 + 0.3, 0, ::nRow + 0.3, ::MaxCol(), 0.2, 2, { nColor, nColor, nColor } )
   ENDIF
   IF ! lDraw
      ::lDrawZebrado := ! ::lDrawZebrado
   ENDIF

   RETURN NIL

METHOD DrawI25BarCode( nRow, nCol, nHeight, cCode, nOneBarWidth ) CLASS PDFClass

   LOCAL oZebraBarCode

   nCol         := ::ColToPdfCol( nCol )
   nRow         := ::RowToPdfRow( nRow + nHeight )
   nHeight      := ::RowToPdfRow( 0 ) - ::RowToPdfRow( nHeight )
   hb_default( @nOneBarWidth, 0.4 )

   // HPDF_Page_GSave( ::oPage )
   // HPDF_Page_Concat( ::oPage, 0.1, 0, 0, 0.1, 0, 0)

   oZebraBarCode := hb_zebra_create_itf( cCode, HB_ZEBRA_FLAG_WIDE2_5 )
   IF ( oZebraBarCode != NIL )
      IF hb_zebra_geterror( oZebraBarCode ) == 0
         hb_zebra_draw( oZebraBarCode, {| a, b, c, d | HPDF_Page_Rectangle( ::oPage, a, b, c, d ) }, nCol, nRow, nOneBarWidth, nHeight )
         HPDF_Page_Fill( ::oPage )
      ENDIF
   ENDIF
   hb_zebra_destroy( oZebraBarCode )
   // HPDF_Page_GRestore( ::oPage )

   RETURN Nil

METHOD DrawBarcodeQRCode( nRow, nCol, nHeight, cCode, nFlags ) CLASS PDFClass

   LOCAL hZebra, nWidth

   nCol         := ::ColToPdfCol( nCol )
   nRow         := ::RowToPdfRow( nRow + nHeight )
   nHeight      := ::RowToPdfRow( 0 ) - ::RowToPdfRow( nHeight )
   nWidth       := nHeight

   hZebra := hb_Zebra_Create_QRCode( cCode, nFlags )
   IF hb_Zebra_GetError( hZebra ) == 0
      hb_Zebra_Draw( hZebra, { | x, y, w, h | HPDF_Page_Rectangle( ::oPage, x, y, w, h ) }, nCol, nRow, nWidth, -nHeight )
      HPDF_Page_Fill( ::oPage )
      hb_Zebra_Destroy( hZebra )
   ENDIF

   RETURN NIL

STATIC FUNCTION ShellExecuteOpen( cFileName, cParameters, cPath, nShow )

   wapi_ShellExecute( Nil, "open", cFileName, cParameters, cPath, hb_DefaultValue( nShow, WIN_SW_SHOWNORMAL ) )

   RETURN Nil

