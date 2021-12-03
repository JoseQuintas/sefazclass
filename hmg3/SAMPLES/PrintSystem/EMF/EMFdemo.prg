
#include "hmg.ch"
#include "Directry.ch"

Function Main()
   DEFINE WINDOW Win_1 ;
      AT 0,0 ;
      WIDTH 400 ;
      HEIGHT 400 ;
      TITLE 'MiniPrint Library Test: Insert Page Number' ;
      MAIN 

      @ 50, 50 BUTTON Button_1 CAPTION "Test" ACTION PrintTest()

   END WINDOW
   CENTER WINDOW Win_1
   ACTIVATE WINDOW Win_1
Return


*------------------------------------------------------------------------------*
Procedure PrintTest
*------------------------------------------------------------------------------*
LOCAL lSuccess, IsPreview

   SELECT PRINTER DIALOG TO lSuccess PREVIEW

   If lSuccess == .F.
      MsgInfo('Print Error')
      Return
   EndIf

   START PRINTDOC

         START PRINTPAGE

            @ 20,20 PRINT "Filled Rectangle Sample:" ;
               FONT "Arial" ;
               SIZE 20 

            @ 30,20 PRINT RECTANGLE ;
               TO 40,190 ;
               PENWIDTH 0.1;
               COLOR {255,255,0}

            @ 60,20 PRINT RECTANGLE ;
               TO 100,190 ;
               PENWIDTH 0.1;
               COLOR {255,255,0};
               FILLED

            @ 110,20 PRINT RECTANGLE ;
               TO 150,190 ;
               PENWIDTH 0.1;
               COLOR {255,255,0};
               ROUNDED

            @ 160,20 PRINT RECTANGLE ;
               TO 200,190 ;
               PENWIDTH 0.1;
               COLOR {255,255,0};
               FILLED;
               ROUNDED

         END PRINTPAGE


         START PRINTPAGE

            @ 20,20 PRINT "Filled Rectangle Sample:" ;
               FONT "Arial" ;
               SIZE 20 

            @ 30,20 PRINT RECTANGLE ;
               TO 40,190 ;
               PENWIDTH 0.1

            @ 60,20 PRINT RECTANGLE ;
               TO 100,190 ;
               PENWIDTH 0.1;
               FILLED

            @ 110,20 PRINT RECTANGLE ;
               TO 150,190 ;
               PENWIDTH 0.1;
               ROUNDED

            @ 160,20 PRINT RECTANGLE ;
               TO 200,190 ;
               PENWIDTH 0.1;
               FILLED;
               ROUNDED

         END PRINTPAGE

         // call this function after last END PRINTPAGE and before END PRINTDOC 
         ProcInsertPageNumber( OpenPrinterGetDC() )

      END PRINTDOC


Return


************************************************************************************************************

PROCEDURE ProcInsertPageNumber( hDC )
LOCAL cFuncNameCallBack := "ProcDrawEMFCallBack"
LOCAL cNamePrefix := GetTempFolder() + _HMG_SYSDATA [ 379 ] + "_hmg_print_preview_"
LOCAL aFiles :=  DIRECTORY( cNamePrefix + "*.EMF" )
LOCAL cFileNameOld, cFileNameNew, i
PRIVATE nPageNumber := 1

   FOR i := 1 TO HMG_LEN( aFiles ) 
      cFileNameOld := GetTempFolder() + aFiles [ i ] [ F_NAME ]
      cFileNameNew := GetTempFolder() + "New_" + aFiles [ i ] [ F_NAME ]
      nError := BT_DrawEMF( hDC, cFileNameOld, cFileNameNew, cFuncNameCallBack )
      IF nError == 0
         FERASE( cFileNameOld ) 
         FRENAME( cFileNameNew, cFileNameOld )
      ELSE
         MsgStop("Error ("+ hb_NtoS( nError ) +") in write into EMF: " + cFileNameOld )
      ENDIF
   NEXT

RETURN


*************************************************************************************************************

FUNCTION ProcDrawEMFCallBack( hDC, leftMM, topMM, rightMM, bottomMM, leftPx, topPx, rightPx, bottomPx, IsParamHDC )   // rectangle that bounded the area to draw, in milimeters and pixels
LOCAL Old_PageDC := OpenPrinterGetPageDC()

   OpenPrinterGetPageDC() := hDC
   @ 180, 100 PRINT " Page Number: " + hb_NtoS( nPageNumber++ ) + " of " + hb_NtoS( _HMG_SYSDATA [ 380 ] ) FONT "Arial" SIZE 12 
   OpenPrinterGetPageDC() := Old_PageDC

   // MsgDebug( hDC, leftMM, topMM, rightMM, bottomMM, leftPx, topPx, rightPx, bottomPx, IsParamHDC )
RETURN NIL


