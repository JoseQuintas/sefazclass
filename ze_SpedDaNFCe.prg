#include "hbclass.ch"
#include "harupdf.ch"

CREATE CLASS hbNFeDaNFCe INHERIT hbNFeDaGeral

   METHOD ToPDF( cXmlNFCe, cFilePDF, ... )
   METHOD Execute( cXmlNFCe, cFilePDF, ... ) INLINE ::ToPDF( cXmlNFce, cFilePDF, ... )
   METHOD GeraPDF()
   METHOD NovaPagina()

   VAR oPDF
   VAR oPDFPage
   VAR cFilePDF
   VAR cXml

   END CLASS

METHOD ToPDF( cXmlNFCe, cFilePDF, ... ) CLASS hbNFeDaNFCe

   ::cFilePDF := cFilePDF
   ::cXml     := cXmlNFCe
   ::GeraPDF()

   RETURN NIL

METHOD GeraPDF() CLASS hbNFeDaNFCe

   ::oPDF := HPDF_New()
   HPDF_SetCompressionMode( ::oPDF, HPDF_COMP_ALL )
   HPDF_GetFont( ::oPDF, "Times-Roman", "CP1252" )
   HPDF_GetFont( ::oPDF, "Times-Bold",  "CP1252" )
   ::NovaPagina()
   ::DrawBarcodeQRCode( 100, 500, 5, ::cXml )
   HPDF_SaveToFile( ::oPDF, ::cFilePDF )

   RETURN NIL

METHOD NovaPagina() CLASS hbNFeDaNFCe

   ::oPDFPage := HPDF_AddPage( ::oPDF )
   HPDF_Page_SetSize( ::oPDFPage, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT )

   RETURN NIL
