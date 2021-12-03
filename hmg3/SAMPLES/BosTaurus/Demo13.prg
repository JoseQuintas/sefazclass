*******************************************************************************
* PROGRAMA: Demo ON PAINT event
* LENGUAJE: HMG
* FECHA:    May 2013
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
      AT 0,0 ;
      WIDTH 600 ;
      HEIGHT 650 ;
      TITLE "Demo13: Resize Image and Set Control Image";
      MAIN;
      NOMAXIMIZE;
      NOSIZE;
      ON INIT Proc_ON_INIT ()
      
      @   5, 50 IMAGE Image1 PICTURE "" ON CLICK Proc_Image ("Image1", "HMG Control Image 1", RED)
      @ 315, 50 IMAGE Image2 PICTURE "" ON CLICK Proc_Image ("Image2", "HMG Control Image 2", GREEN)
      
   END WINDOW

   CENTER WINDOW Win1
   ACTIVATE WINDOW Win1

RETURN NIL


PROCEDURE Proc_ON_INIT
LOCAL hBitmap1_aux := 0
LOCAL hBitmap2_aux := 0

  hBitmap1_aux := BT_BitmapLoadFile ("Giovanni.PNG")
  hBitmap2_aux := BT_BitmapLoadFile ("Giovanni.GIF")

  hBitmap1  := BT_BitmapCopyAndResize (hBitmap1_aux, 500, 300, NIL, BT_RESIZE_HALFTONE)
  hBitmap2  := BT_BitmapCopyAndResize (hBitmap2_aux, 500, 300, NIL, BT_RESIZE_HALFTONE)

  BT_BitmapRelease (hBitmap1_aux)
  BT_BitmapRelease (hBitmap2_aux)
  
  BT_HMGSetImage ("Win1", "Image1", hBitmap1)
  BT_HMGSetImage ("Win1", "Image2", hBitmap2)
  
  MsgInfo ("Click on images")

RETURN


PROCEDURE Proc_Image (cControlName, cText, aColor)
LOCAL hDC, BTstruct
LOCAL hBitmap

   hBitmap := BT_HMGGetImage ("Win1", cControlName)

   hDC := BT_CreateDC (hBitmap, BT_HDC_BITMAP, @BTstruct)
       nTypeText    := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD    
       nAlingText   := BT_TEXT_LEFT + BT_TEXT_BASELINE
       nOrientation := 30
       BT_DrawText (hDC, 285, 45, cText, "Times New Roman", 38, aColor, WHITE, nTypeText, nAlingText, nOrientation)  
   BT_DeleteDC (BTstruct)
   
   BT_ClientAreaInvalidateAll ("Win1")
RETURN

