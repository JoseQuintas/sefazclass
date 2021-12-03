/*
   HMG Graph Bitmap Demo
   by S. Rathinagiri and Claudio Soto, May 2016
*/

#pragma -w2
MEMVAR _HMG_SYSDATA
#include "hmg.ch"

FUNCTION MAIN

   DEFINE WINDOW Form_1; 
      AT 0,0; 
      WIDTH 1000; 
      HEIGHT 700;
      MAIN

      DEFINE LABEL Label_1
         ROW   10
         COL   10
         WIDTH 150
         VALUE 'Select Graph Type'
      END LABEL
      
      DEFINE COMBOBOX GraphType
         ROW   10
         COL   160
         WIDTH 100
         ITEMS { 'Bar', 'Lines', 'Points', 'Pie' }
         ONCHANGE ProcDrawGraph()
      END COMBOBOX
      
      DEFINE CHECKBOX Enable3D
         ROW   10
         COL   280
         WIDTH 100
         CAPTION 'Enable 3D'
         ONCHANGE ProcDrawGraph()
      END CHECKBOX
      
      DEFINE BUTTON Button_1
         ROW   10
         COL   400
         CAPTION 'Save as PNG'
         ACTION ProcSaveGraph()
      END BUTTON

      DEFINE IMAGE Image_1
         ROW 50
         COL 50
      END IMAGE

   END WINDOW
   
   Form_1.GraphType.VALUE := 1
   
   CENTER WINDOW Form_1
   ACTIVATE WINDOW Form_1
   
RETURN NIL


PROCEDURE ProcDrawGraph()
LOCAL aSerieValues, aSerieYNames
LOCAL nImageWidth  := 600
LOCAL nImageHeight := 600
LOCAL hBitmap      := 0

   IF Form_1.GraphType.VALUE > 0

      IF Form_1.GraphType.VALUE == 4   // PIE Graph
         
         GRAPH BITMAP PIE ; 
               SIZE        nImageWidth, nImageHeight ;
               SERIEVALUES { 1500,        1800,        200,         500,         800 } ;
               SERIENAMES  { "Product 1", "Product 2", "Product 3", "Product 4", "Product 5" } ;
               SERIECOLORS { RED,         BLUE,        YELLOW,      GREEN,       ORANGE } ;
               TITLE       "Sales" ;
               TITLECOLOR  BLACK ;
               DEPTH       25 ;
               3DVIEW      Form_1.Enable3D.VALUE ;
               SHOWXVALUES .T. ; 
               SHOWLEGENDS .T. ; 
               NOBORDER    .F. ;
               STOREIN     hBitmap

      ELSE

         #define COLOR1   { 128, 128, 255 }
         #define COLOR2   { 255, 102,  10 }
         #define COLOR3   {  55, 201,  48 }

         aSerieValues := { { 14280,  20420,  12870,  25347,   7640 },;
                           {  8350,  10315,  15870,   5347,  12340 },;
                           { 12345,  -8945,  10560,  15600,  17610 } }

         aSerieYNames :=   { "Jan",  "Feb",  "Mar",  "Apr",  "May" } 

         GRAPH BITMAP      Form_1.GraphType.VALUE ;  // constants: BARS = 1, LINES = 2, POINTS = 3 are defined in i_graph.ch 
               SIZE        nImageWidth, nImageHeight ;
               SERIEVALUES aSerieValues ;
               SERIENAMES  { "Serie 1", "Serie 2", "Serie 3"} ;
               SERIECOLORS { COLOR1,    COLOR2,    COLOR3   } ;
               SERIEYNAMES aSerieYNames ;
               PICTURE     "99,999.99" ;
               TITLE       "Sample Graph" ;
               TITLECOLOR  BLACK ;
               HVALUES     5 ;
               BARDEPTH    15 ; 
               BARWIDTH    15 ;
               SEPARATION  0 ;
               LEGENDWIDTH 50 ;
               3DVIEW      Form_1.Enable3D.VALUE ;
               SHOWGRID    .T. ;
               SHOWXGRID   .T. ;
               SHOWYGRID   .T. ;
               SHOWVALUES  .T. ;
               SHOWXVALUES .T. ;
               SHOWYVALUES .T. ;               
               SHOWLEGENDS .T. ; 
               NOBORDER    .F. ;
               STOREIN     hBitmap 

      ENDIF

//    BT_BitmapSaveFile( hBitmap, "Graph.PNG", BT_FILEFORMAT_PNG )

      Form_1.Image_1.HBITMAP := hBitmap   // Assign hBitmap to the IMAGE control

   ENDIF

RETURN


PROCEDURE ProcSaveGraph()
LOCAL cFileName
LOCAL hBitmap := Form_1.Image_1.HBITMAP   // Gets the value of hBitmap from the IMAGE control
   IF hBitmap <> 0 .AND. Form_1.GraphType.VALUE > 0
      cFileName := "Graph_" + Form_1.GraphType.ITEM( Form_1.GraphType.VALUE ) + IIF( Form_1.Enable3D.VALUE, "3D", "2D") + ".PNG"
      BT_BitmapSaveFile( hBitmap, cFileName, BT_FILEFORMAT_PNG )
      MsgInfo( "Save as: " + cFileName )
   ENDIF
RETURN
