#include "hbclass.ch"

PROCEDURE TesteDanfe

   LOCAL oDanfe

   Inkey(0)
   SetMode( 40, 100 )
   CLS
   oDanfe := hbnfeDaNfe():New()
   oDanfe:Execute( MemoRead( "xmlnota.xml" ), "pdfnfe.pdf" )
   ? oDanfe:cRetorno
   PDFOpen( "pdfnfe.pdf" )

   oDanfe := hbnfeDaCte():New()
   oDanfe:Execute( MemoRead( "xmlcte.xml" ),  "pdfcte.pdf" )
   ? oDanfe:cRetorno
   PDFOpen( "pdfcte.pdf" )

   oDanfe := hbnfeDaMdfe():New()
   oDanfe:Execute( MemoRead( "xmlmdfe.xml" ), "pdfmdfe.pdf" )
   ? oDanfe:cRetorno
   PDFOpen( "pdfmdfe.pdf" )

   oDanfe := hbnfeDaEvento():New()
   oDanfe:Execute( MemoRead( "xmleventonfe.xml" ), MemoRead( "xmlnota.xml" ), "pdfeventonfe.pdf" )
   ? oDanfe:cRetorno
   PDFOpen( "pdfeventonfe.pdf" )

   oDanfe := hbnfeDaEvento():New()
   oDanfe:Execute( MemoRead( "xmleventocte.xml" ), "", "pdfeventocte.pdf" )
   ? oDanfe:cRetorno
   PDFOpen( "pdfeventocte.pdf" )

   RETURN

FUNCTION PDFOpen( cFile )

   IF File( cFile )
      RUN ( "cmd /c start " + cFile )
   ENDIF

   RETURN NIL
