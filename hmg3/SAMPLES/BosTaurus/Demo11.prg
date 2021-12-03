*******************************************************************************
* PROGRAMA: Demo ON PAINT event
* LENGUAJE: HMG
* FECHA:    Noviembre 2012
* AUTOR:    Dr. CLAUDIO SOTO
* PAIS:     URUGUAY
* E-MAIL:   srvet@adinet.com.uy
* BLOG:     http://srvet.blogspot.com
*******************************************************************************


#include "hmg.ch"


FUNCTION MAIN

PRIVATE hBitmap := 0 

     DEFINE WINDOW Win1;
            AT 0,0;
            WIDTH  500;
            HEIGHT 400;
            TITLE "Demo11: Create Logo";
            MAIN;
            ON INIT     Proc_ON_INIT ();
            ON RELEASE  Proc_ON_RELEASE ();
            ON PAINT    Proc_ON_PAINT ()

            @  200, 190 LABEL Label1 Value "Save Image as ..." FONT "Times New Roman" SIZE 14 BOLD AUTOSIZE
            
            @  250, 100 BUTTON Button1 CAPTION "BMP"  ACTION Proc_Save_Image (1)
            @  250, 210 BUTTON Button2 CAPTION "JPG"  ACTION Proc_Save_Image (2)
            @  250, 320 BUTTON Button3 CAPTION "GIF"  ACTION Proc_Save_Image (3)
            @  300, 150 BUTTON Button4 CAPTION "TIF"  ACTION Proc_Save_Image (4)
            @  300, 260 BUTTON Button5 CAPTION "PNG"  ACTION Proc_Save_Image (5)

    END WINDOW

    CENTER WINDOW Win1
    ACTIVATE WINDOW Win1
RETURN Nil


PROCEDURE Proc_ON_INIT
   hBitmap := Proc_Create_Logo ()
RETURN


PROCEDURE Proc_ON_RELEASE
   BT_BitmapRelease (hBitmap)
RETURN


PROCEDURE Proc_ON_PAINT
LOCAL hDC, BTstruct     
  hDC := BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
     BT_DrawBitmap (hDC,  30,  180, 300, 200, BT_COPY,  hBitmap)
  BT_DeleteDC (BTstruct)
RETURN



PROCEDURE Proc_Save_Image (nAction)
LOCAL Ret, Button
   DO CASE       
      CASE nAction == 1
           Ret:= BT_BitmapSaveFile (hBitmap, "LOGO_BMP.bmp") // or BT_BitmapSaveFile (hBitmap, "LOGO_BMP.bmp", BT_FILEFORMAT_BMP)
      CASE nAction == 2
           Ret:= BT_BitmapSaveFile (hBitmap, "LOGO_JPG.jpg", BT_FILEFORMAT_JPG)
      CASE nAction == 3
           Ret:= BT_BitmapSaveFile (hBitmap, "LOGO_GIF.gif", BT_FILEFORMAT_GIF)
      CASE nAction == 4
           Ret:= BT_BitmapSaveFile (hBitmap, "LOGO_TIF.tif", BT_FILEFORMAT_TIF)
      CASE nAction == 5
           Ret:= BT_BitmapSaveFile (hBitmap, "LOGO_PNG.png", BT_FILEFORMAT_PNG)
   ENDCASE
   
   IF Ret == .T.
      Button := "Button"+ALLTRIM(STR(nAction))
      SetProperty ("Win1", Button, "Enabled", .F.) 
   ENDIF
   MsgInfo ("Save Image: "+IF(Ret,"OK","Fail"))
RETURN



FUNCTION Proc_Create_Logo
LOCAL hDC, BTstruct
LOCAL hBitmap, hBitmap_aux 
LOCAL aRGBcolor := {153,217,234}

   // Create bitmap in memory
   hBitmap := BT_BitmapCreateNew (150, 100, aRGBcolor)

   // Create hDC to a bitmap
   hDC := BT_CreateDC (hBitmap, BT_HDC_BITMAP, @BTstruct)     
     
     // Paint Gradient
     BT_DrawGradientFillVertical (hDC,  0,  0,  150,  100, aRGBcolor, BLACK)                 
     
     // Draw Text
     nTypeText    := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD    
     nAlingText   := BT_TEXT_LEFT + BT_TEXT_TOP
     nOrientation := BT_TEXT_NORMAL_ORIENTATION
     BT_DrawText (hDC, 10, 20, "HMG Casino", "Times New Roman", 14, BLACK, WHITE, nTypeText, nAlingText, nOrientation)
      
     // Draw Rectangle
     BT_DrawRectangle (hDC, 5, 5, 140, 90, BLUE, 2)

     // Paste image
     // hBitmap_aux := BT_BitmapLoadFile ("img.png") // load from disk
     hBitmap_aux := BT_BitmapLoadFile ("imgPNG")  // load from resource
        BT_DrawBitmapTransparent (hDC, 30, 30, 100, 100, BT_SCALE, hBitmap_aux, NIL)
     BT_BitmapRelease (hBitmap_aux)
  
  // Release hDC bitmap  
  BT_DeleteDC (BTstruct)   

Return hBitmap
