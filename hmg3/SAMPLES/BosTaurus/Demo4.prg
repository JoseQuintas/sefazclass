*******************************************************************************
* PROGRAMA: Demo ON PAINT event
* LENGUAJE: HMG
* FECHA:    Setiembre 2012
* AUTOR:    Dr. CLAUDIO SOTO
* PAIS:     URUGUAY
* E-MAIL:   srvet@adinet.com.uy
* BLOG:     http://srvet.blogspot.com
*******************************************************************************


#include "hmg.ch" 


FUNCTION MAIN

PRIVATE Flag_Erase := .F.
PRIVATE hBitmap    := 0
PRIVATE hBitmap1   := 0
PRIVATE hBitmap2   := 0
PRIVATE nMode      := 0

    DEFINE WINDOW Win1;
        AT 0,0;
        WIDTH 800;
        HEIGHT 630;
        TITLE "Demo4: Wallpaper";
        MAIN;
        ON INIT    Proc_ON_INIT ();
        ON RELEASE Proc_ON_RELEASE ();
        ON PAINT   Proc_ON_PAINT ();
        VIRTUAL WIDTH  1100;
        VIRTUAL HEIGHT 1100;

        
        DEFINE MAIN MENU
            DEFINE POPUP "Automatic" 
                  MENUITEM "Automatic background change" ACTION {||Win1.Flag_Automatic.Checked:=.NOT.(Win1.Flag_Automatic.Checked)} NAME Flag_Automatic CHECKED
            END POPUP
        END MENU 
        Win1.Flag_Automatic.Checked := .F.


        DEFINE TAB Tab_1;
               AT 30,10;
               WIDTH 400;
               HEIGHT 300;
               VALUE 1 FONT "ARIAL" SIZE 10
 
               PAGE "Page1"      
                    @ 55,90 LABEL Label_1 VALUE "This is Page 1" WIDTH 100 HEIGHT 27
                    @ 100 , 10 EDITBOX ED_ctrl WIDTH 200 HEIGHT 100 VALUE "Hello HMG World" BACKCOLOR YELLOW FONTCOLOR BLUE
               END PAGE

               DEFINE PAGE "Page2"
                   @ 55,90 LABEL Label_2 VALUE "This is Page 2" WIDTH 100 HEIGHT 27
               END PAGE
        END TAB 


         @ 10, 450 GRID Grid_1 WIDTH 300 HEIGHT 330;
           HEADERS {"Column 1","Column 2","Column 3"};
           WIDTHS {140,140,140};
           VIRTUAL;
           ITEMCOUNT 30;
           ON QUERYDATA {||This.QueryData := Str ( This.QueryRowIndex ) + "," + Str ( This.QueryColIndex )}


         @ 350,100 IMAGE Image_1 PICTURE "Img1.bmp" WIDTH 160 HEIGHT 120 STRETCH 
                  
         @ 500,  50 BUTTON button_1 CAPTION "On/Off Image" ACTION  (IF (Win1.image_1.visible = .T., Win1.image_1.visible := .F., Win1.image_1.visible := .T.))
         @ 500, 200 BUTTON button_2 CAPTION "On/Off TAB"   ACTION  (IF (Win1.Tab_1.visible = .T., Win1.Tab_1.visible := .F., Win1.Tab_1.visible := .T.))
         @ 500, 350 BUTTON button_3 CAPTION "On/Off GRID"  ACTION  (IF (Win1.Grid_1.visible = .T., Win1.Grid_1.visible := .F., Win1.Grid_1.visible := .T.))


         @ 500, 500 BUTTON button_4 CAPTION "CHANGE" ACTION Background_Change ()
         @ 500, 650 BUTTON button_5 CAPTION "ERASE"  ACTION Background_Erase ()

         DRAW LINE IN WINDOW Win1 AT 0,400 TO 600,400 PENCOLOR RED PENWIDTH 2
         DRAW LINE IN WINDOW Win1 AT 300,0 TO 300,800 PENCOLOR RED PENWIDTH 3
                                 
                 
         DEFINE TIMER Timer_1 INTERVAL 2000 ACTION {||IF(Win1.Flag_Automatic.Checked=.T., Background_Change (), NIL)}

    END WINDOW
    
    CENTER WINDOW Win1

    ACTIVATE WINDOW Win1
   
RETURN Nil


PROCEDURE Proc_ON_INIT
   hBitmap1 := BT_BitmapLoadFile ("CowBook.bmp") 
   hBitmap2 := BT_BitmapLoadFile ("Sami.jpg")

   hBitmap  := hBitmap1
   nMode    := BT_STRETCH
RETURN


PROCEDURE Proc_ON_RELEASE
   BT_BitmapRelease (hBitmap1)
   BT_BitmapRelease (hBitmap2)
RETURN


PROCEDURE Proc_ON_PAINT
LOCAL Width  := BT_ClientAreaWidth  ("Win1")
LOCAL Height := BT_ClientAreaHeight ("Win1")
LOCAL Row, Col, Width1, Height1
LOCAL hDC, BTstruct

   hDC := BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
  
       IF nMode = BT_COPY
          Row := -Win1.VscrollBar.value
          Col := -Win1.HscrollBar.value
          Width1 := 1000
          Height1 := 1000
       ELSE
         Row := 0
         Col := 0
         Width1 := Width
         Height1 := Height
       ENDIF

       IF Flag_Erase = .F.
          BT_DrawGradientFillHorizontal (hDC,   0,  0,  Width,  Height, RED, BLACK)
          BT_DrawBitmap (hDC, Row, Col, Width1, Height1, nMode, hBitmap)
       ENDIF
   
   BTstruct [1] := BT_HDC_ALLCLIENTAREA   
   BT_DeleteDC (BTstruct)
   
RETURN


PROCEDURE Background_Change
STATIC Flag_Image := .T.
   
   IF Flag_Image = .F.
      Flag_Image := .T.
      hBitmap    := hBitmap1  
      nMode      := BT_STRETCH
   ELSE
      Flag_Image := .F.
      hBitmap    := hBitmap2
      nMode      := BT_COPY
   ENDIF 

   Flag_Erase := .F.
   BT_ClientAreaInvalidateAll ("Win1", .T.)
RETURN


PROCEDURE Background_Erase
   Flag_Erase := .T.
   BT_ClientAreaInvalidateAll ("Win1", .T.)
RETURN
