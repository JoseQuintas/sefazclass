/*
ZE_SPEDDAGERAL - Rotinas comuns de Documento Auxiliar
2016.11.15
*/

#include "hbzebra.ch"
#include "hbclass.ch"

CREATE CLASS hbNFeDaGeral

   METHOD LoadJPEGImage( oPDF, xValue )
   METHOD DrawBarcode( cBarCode, oPDFPage, nAreaX, nAreaY, nBarWidth, nAreaHeight )

   END CLASS

METHOD LoadJPEGImage( oPDF, xValue ) CLASS hbNFeDaGeral

   LOCAL oImage

   IF xValue != NIL
      IF Len( xValue ) < 100
         oImage := HPDF_LoadJpegImageFromFile( oPDF, xValue )
      ELSE
         oImage := HPDF_LoadJpegImageFromMem( oPDF, xValue, Len( xValue ) )
      ENDIF
   ENDIF

   RETURN oImage

METHOD DrawBarcode( cBarCode, oPDFPage, nAreaX, nAreaY, nBarWidth, nAreaHeight ) CLASS hbNFeDaGeral

   LOCAL hZebra

   hZebra := hb_zebra_create_code128( cBarcode, NIL )
   IF hb_zebra_geterror( hZebra ) != 0
      RETURN HB_ZEBRA_ERROR_INVALIDZEBRA
   ENDIF
   hb_zebra_draw( hZebra, { | x, y, w, h | HPDF_Page_Rectangle( oPDFPage, x, y, w, h ) }, nAreaX, nAreaY, nBarWidth, nAreaHeight )
   HPDF_Page_Fill( oPDFPage )

   RETURN 0
