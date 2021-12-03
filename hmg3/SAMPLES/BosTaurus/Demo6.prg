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

PRIVATE hBitmap := 0 
PRIVATE Image_Width  := 0
PRIVATE Image_Height := 0

     DEFINE WINDOW Win1;
            AT 0,0;
            WIDTH  700;
            HEIGHT 600;
            TITLE "Demo6: Clipboard Monitor";
            MAIN;
            ON INIT     Proc_ON_INIT ();
            ON RELEASE  Proc_ON_RELEASE ();
            ON PAINT    Proc_ON_PAINT ()
        
            @ 200, 200 EDITBOX EditBox_1 WIDTH 250 HEIGHT 100; 
                       VALUE "Copy an image to the clipboard with Microsoft Paint or another graphic tool.";
                       BOLD BACKCOLOR ORANGE NOHSCROLL
                       
            @ 400, 280 BUTTON Button_1 CAPTION "Click" ACTION MsgInfo ("Hello HMG World !!!")
            
            DEFINE TIMER Timer1 INTERVAL 300 ACTION Proc_Get_Clipboard_Timer()
            
    END WINDOW

    CENTER WINDOW Win1
    ACTIVATE WINDOW Win1
RETURN Nil


PROCEDURE Proc_ON_INIT
   hBitmap := BT_BitmapLoadFile ("SAMI.jpg")
   Image_Width  := BT_BitmapWidth (hBitmap)
   Image_Height := BT_BitmapHeight (hBitmap)
   
   IF BT_BitmapClipboardPut ("Win1", hBitmap) = .T.
      MsgInfo ("Put Bitmap in the Clipboard: OK")
   ELSE
      MsgInfo ("Put Bitmap in the Clipboard: FAILED")
   ENDIF   
RETURN


PROCEDURE Proc_ON_RELEASE
   BT_BitmapRelease (hBitmap)
RETURN


PROCEDURE Proc_ON_PAINT
LOCAL Width  := BT_ClientAreaWidth("Win1")-40
LOCAL Height := BT_ClientAreaHeight("Win1")-40
LOCAL hDC, BTstruct

   hDC := BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
      BT_DrawGradientFillVertical (hDC, 0, 0, BT_ClientAreaWidth("Win1"), BT_ClientAreaHeight("Win1"), WHITE, BLACK)
      IF (Image_Width > Width) .OR. (Image_Height > Height) 
         BT_DrawBitmap (hDC, 20, 20, Width, Height, BT_SCALE, hBitmap)
      ELSE
         BT_DrawBitmap (hDC, 20, 20, Width, Height, BT_COPY, hBitmap)
      ENDIF  
   BT_DeleteDC (BTstruct)

RETURN


PROCEDURE Proc_Get_Clipboard_Timer
LOCAL hBitmap_aux
   IF .NOT. (BT_BitmapClipboardIsEmpty())
       hBitmap_aux := BT_BitmapClipboardGet("Win1")
       IF hBitmap_aux <> 0
          BT_BitmapClipboardClean ("Win1")
          BT_BitmapRelease (hBitmap)
          hBitmap := hBitmap_aux
          Image_Width  := BT_BitmapWidth (hBitmap)
          Image_Height := BT_BitmapHeight (hBitmap)
          BT_ClientAreaInvalidateAll ("Win1")
       ENDIF   
    ENDIF   
RETURN

