#include <hmg.ch>
#include "hfcl.ch"


Function Main()
   nZoom := 2
   
   cHTMLFile := "QHTM API Reference and User Guide.htm"

   cBKcolor := '<body bgcolor="#99EECC">'
   
   cHtml := cBKcolor + HB_MEMOREAD (cHtmlFile) 
   
   
   QHTM_Init()
   
   DEFINE WINDOW Form_1; 
        AT 0 , 0;
        WIDTH 800 HEIGHT 600;
        TITLE "QHTM Demo";
        MAIN; 
        NOSIZE;  
        NOMAXIMIZE;
        ON RELEASE  QHTM_end();
        
         @ 10,10 QHTM Html_1 OF Form_1  ;
         VALUE cHtml;
         WIDTH 780  ;
         HEIGHT 450 ;
         FONT "Courier New" ;
         SIZE 10;
         BORDER

         DEFINE BUTTON Button_1a
            ROW    500
            COL    50
            WIDTH  100
            HEIGHT 28
            ACTION  QHTM_Zoom ("Html_1", "Form_1", iif(--nZoom < 0, nZoom:=0, nZoom))
            CAPTION "Zoom (-)"
            FONTNAME "Arial"
            FONTSIZE 9
            FONTBOLD .T.
         END BUTTON

         DEFINE BUTTON Button_1b
            ROW    500
            COL    200
            WIDTH  100
            HEIGHT 28
            ACTION  QHTM_Zoom ("Html_1", "Form_1", iif(++nZoom > 4, nZoom:=4, nZoom))
            CAPTION "Zoom (+)"
            FONTNAME "Arial"
            FONTSIZE 9
            FONTBOLD .T.
         END BUTTON

         DEFINE BUTTON Button_2
            ROW    500
            COL    350
            WIDTH  100
            HEIGHT 28
            ACTION GetHTMLSize()
            CAPTION "Get Sizes"
            FONTNAME "Arial"
            FONTSIZE 9
            FONTBOLD .T.
         END BUTTON

         DEFINE BUTTON Button_3
            ROW    500
            COL    550
            WIDTH  100
            HEIGHT 28
            ACTION PrintHTML (NIL, cHtml)
            // ACTION PrintHTML (cHTMLFile, NIL)
            CAPTION "Print"
            FONTNAME "Arial"
            FONTSIZE 9
            FONTBOLD .T.
         END BUTTON

   END WINDOW
   Form_1.Center
   Form_1.Activate
Return Nil




Procedure GetHTMLSize()
Local aSize := QHTM_GetSize (GetControlHandle( 'Html_1', 'Form_1' ))
Local cMsg  := "" 
If !Empty (aSize)
   cMsg += '<p><b>QHTM_GetSize() for HTML</b></p><p>'
   cMsg += ( 'Height: ' + Str( aSize[ 2 ] )  + '<br>' )
   cMsg += ( 'Width :'  + Str( aSize[ 1 ] ) + '<br>' )
   cMsg += '</p><p><b>HMG control</b></p><p>'
   cMsg += ( 'Height:' + Str( Form_1.Html_1.Height ) + '<br>' )
   cMsg += ( 'Width :' + Str( Form_1.Html_1.Width ) + '</p>' )
   QHTM_MessageBox( cMsg, 'Get sizes' )
Endif
Return Nil



Procedure PrintHTML( cHtmlFile, cHtmlText )
Local hContext, nCountPages, Cycle, lPrintSet

   SELECT PRINTER DEFAULT ;
         ORIENTATION PRINTER_ORIENT_PORTRAIT ;
         PAPERSIZE   PRINTER_PAPER_A4 ;
         QUALITY     PRINTER_RES_MEDIUM  ;
         PREVIEW

   START PRINTDOC NAME "Print form - QHTM"
   _hmg_printer_hdc_bak := _HMG_SYSDATA [ 372 ]
   hContext := QHTM_PrintCreateContext()

   If cHtmlFile=Nil
      lPrintSet:=QHTM_PrintSetText( hContext, cHtmlText )
   Else
      lPrintSet:=QHTM_PrintSetTextFile( hContext, cHtmlFile )
   Endif
   If lPrintSet
      nCountPages := QHTM_PrintLayout( _hmg_printer_hdc_bak, hContext )
      For Cycle := 1 to nCountPages
         START PRINTPAGE
            _hmg_printer_hdc := _HMG_SYSDATA [ 374 ]
            QHTM_PrintPage( _hmg_printer_hdc, hContext, Cycle )
         END PRINTPAGE
      Next
   Endif   
   END PRINTDOC
   QHTM_PrintDestroyContext( hContext )
Return Nil