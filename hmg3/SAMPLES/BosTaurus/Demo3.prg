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

PRIVATE hBitmap1 := 0 
PRIVATE hBitmap2 := 0 

     DEFINE WINDOW Win1;
            AT 0,0;
            WIDTH  800;
            HEIGHT 600;
            TITLE "Demo3: BITMAP Manipulation";
            MAIN;
            ON INIT     Proc_ON_INIT ();
            ON RELEASE  Proc_ON_RELEASE ();
            ON PAINT    Proc_ON_PAINT ()

            @   30, 333 LABEL  Label_1  VALUE " " AUTOSIZE 
            @   80, 333 LABEL  Label_2  VALUE " " AUTOSIZE TRANSPARENT FONTCOLOR BLUE       

            @  435, 410 BUTTON Button_1 CAPTION "Maximize" ACTION Win1.Maximize      
            @  435, 280 BUTTON Button_2 CAPTION "Click"    ACTION MsgInfo ("Hello")

    END WINDOW

    CENTER WINDOW Win1
    ACTIVATE WINDOW Win1
RETURN Nil


PROCEDURE Proc_ON_INIT
   hBitmap1 := BT_BitmapLoadFile ("hmg.bmp")   
   hBitmap2 := BT_BitmapTransform (hBitmap1, BT_BITMAP_ROTATE + BT_BITMAP_REFLECT_HORIZONTAL + BT_BITMAP_REFLECT_VERTICAL, 135, NIL)
   
   BT_BitmapRelease (hBitmap1)
   hBitmap1 := Proc_Paint_on_the_Bitmap()
RETURN


PROCEDURE Proc_ON_RELEASE
   BT_BitmapRelease (hBitmap1)
   BT_BitmapRelease (hBitmap2)
RETURN


PROCEDURE Proc_ON_PAINT
LOCAL Width  := BT_ClientAreaWidth  ("Win1")
LOCAL Height := BT_ClientAreaHeight ("Win1") 
LOCAL hDC, BTstruct

  Win1.Label_1.Value := "Client Area WIDTH "+str(Width)
  Win1.Label_2.Value := "Client Area HEIGHT"+str(Height)
     
  hDC := BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
  
     BT_DrawGradientFillVertical (hDC,  0,  0,  Width,  Height, WHITE, BLACK)                 

     BT_DrawBitmap (hDC,  10,  10, 300, 200, BT_COPY,  hBitmap1)
  
     BT_DrawBitmapTransparent (hDC,  10, 500, 250, 150, BT_COPY,  hBitmap1, NIL)

     BT_DrawBitmapTransparent (hDC, 350, 100, 250, 150, BT_SCALE, hBitmap2, NIL)
     
     BT_DrawBitmap (hDC, 350, 600, 250, 150, BT_SCALE, hBitmap2)

     nTypeText    := BT_TEXT_OPAQUE + BT_TEXT_BOLD + BT_TEXT_ITALIC + BT_TEXT_UNDERLINE    
     nAlingText   := BT_TEXT_CENTER + BT_TEXT_BASELINE 
     nOrientation := 10 
     BT_DrawText (hDC, 300, 400, " The Power of HMG ", "Comic Sans MS", 42, WHITE, BLACK, nTypeText, nAlingText, nOrientation)

  BT_DeleteDC (BTstruct)
  
RETURN



FUNCTION Proc_Paint_on_the_Bitmap
LOCAL hDC, BTstruct
LOCAL hBitmap, aRGBcolor := {153,217,234}

   hBitmap := BT_BitmapCreateNew (300, 200, aRGBcolor)

   hDC := BT_CreateDC (hBitmap, BT_HDC_BITMAP, @BTstruct)     
     
     BT_DrawGradientFillVertical (hDC,  50,  50,  200,  100, aRGBcolor, BLACK)                 
     
     nTypeText    := BT_TEXT_OPAQUE + BT_TEXT_BOLD    
     nAlingText   := BT_TEXT_LEFT + BT_TEXT_TOP
     nOrientation := BT_TEXT_NORMAL_ORIENTATION
     BT_DrawText (hDC, 90, 80, " The Power of HMG ", "Times New Roman", 12, BLACK, WHITE, nTypeText, nAlingText, nOrientation)
     
  BT_DeleteDC (BTstruct)   

Return hBitmap

