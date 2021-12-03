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
PRIVATE Alpha := 150

PRIVATE Flag_AlphaBlend_Effect := .T. 

   DEFINE WINDOW Win1;
       AT 0,0;
       WIDTH  800;
       HEIGHT 600;
       VIRTUAL WIDTH  BT_DesktopWidth  () + 100;
       VIRTUAL HEIGHT BT_DesktopHeight () + 150;
       TITLE "Demo5: CaptureDesktop, AlphaBlend, Grayness and Brightness";
       MAIN;
       ON RELEASE Proc_ON_RELEASE ();
       ON PAINT   Proc_ON_PAINT   ();

       DEFINE MAIN MENU
           DEFINE POPUP "Alpha Blend"
                  MENUITEM "Alpha   0 (min)" ACTION AlphaChange (0) 
                  MENUITEM "Alpha  50      " ACTION AlphaChange (50)
                  MENUITEM "Alpha 150      " ACTION AlphaChange (150)
                  MENUITEM "Alpha 200      " ACTION AlphaChange (200)
                  MENUITEM "Alpha 255 (max)" ACTION AlphaChange (255)
           END POPUP                 
       END MENU

       @  350, 250 BUTTON Button_1 CAPTION "Capture Desktop"  WIDTH 120 ACTION CaptureDesktop ()      
       @  350, 400 BUTTON Button_2 CAPTION "Erase Capture"    WIDTH 120 ACTION EraseCapture ()
       @  435, 320 BUTTON Button_3 CAPTION "Save Capture"     WIDTH 120 ACTION SaveDeskTop ()

      
   END WINDOW

   CENTER WINDOW Win1
   ACTIVATE WINDOW Win1

RETURN Nil



PROCEDURE Proc_ON_RELEASE
   BT_BitmapRelease (hBitmap)
RETURN



PROCEDURE Proc_ON_PAINT
LOCAL Width  := BT_ClientAreaWidth  ("Win1")
LOCAL Height := BT_ClientAreaHeight ("Win1")
LOCAL Col := -Win1.HscrollBar.value
LOCAL Row := -Win1.VscrollBar.value   
LOCAL hDC, BTstruct 

  hDC = BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)

    IF Flag_AlphaBlend_Effect = .T.  
       BT_DrawGradientFillVertical (hDC,  0,  0,  Width,  Height, RED, BLACK)                 
       
       // BT_DrawBitmapAlphaBlend (hDC, Row+10,  Col+10, BT_DesktopWidth (), BT_DesktopHeight (), Alpha, BT_COPY, hBitmap)  
       BT_DrawBitmapAlphaBlend (hDC, Row+10,  Col+10, NIL, NIL, Alpha, BT_COPY, hBitmap)  

       nTypeText  := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD + BT_TEXT_ITALIC + BT_TEXT_UNDERLINE    
       nAlingText := BT_TEXT_CENTER + BT_TEXT_BASELINE        
       BT_DrawText (hDC, Height/2, Width/2, "The Power of HMG", "Comic Sans MS", 42, YELLOW, BLACK, nTypeText, nAlingText)   
    ELSE       
       BT_DrawBitmap (hDC, 0,  0, Width,  Height, BT_COPY, hBitmap)              
    ENDIF

  BT_DeleteDC (BTstruct)
  
RETURN



PROCEDURE AlphaChange (new_value)
   IF hBitmap = 0
      BT_DELAY_EXECUTION (100)  // Delay execution of the program in 100 milliseconds, to allow the system time to repaint the window after hide popup menu
      Grayness_effect_start ()  // Capture and Grayness Client Area
         MsgInfo ("Error: No desktop capture")
      Grayness_effect_end ()  // Restore Client Area
   ELSE         
      Alpha :=  new_value
      BT_ClientAreaInvalidateAll ("Win1") 
   ENDIF
RETURN



PROCEDURE CaptureDesktop         
   Win1.Hide
   BT_DELAY_EXECUTION (300)  // Delay execution of the program in 300 milliseconds, to allow the system time to repaint the desktop after hide the window    
   BT_BitmapRelease (hBitmap)
   hBitmap := BT_BitmapCaptureDesktop ()
   Win1.Show     
   BT_ClientAreaInvalidateAll ("Win1")
RETURN 



PROCEDURE SaveDesktop
   IF hBitmap = 0
      Grayness_effect_start ()
         MsgInfo ("Error: No desktop capture")
      Grayness_effect_end ()
   ELSE         
      BT_BitmapSaveFile (hBitmap, "DESKTOP.bmp")
      MsgInfo ("Capture save as file DESKTOP.bmp")
      Alpha := 255
      BT_ClientAreaInvalidateAll ("Win1")
   ENDIF
RETURN



PROCEDURE EraseCapture
   IF hBitmap = 0
      Grayness_effect_start ()  // Capture, Grayness and Brightness Client Area
         MsgInfo ("Error: No desktop capture")
      Grayness_effect_end ()  // Restore Client Area 
   ELSE
      BT_BitmapRelease (hBitmap)
      hBitmap:= 0
      Alpha := 150
      BT_ClientAreaInvalidateAll ("Win1")
   ENDIF
RETURN



PROCEDURE Grayness_effect_start 
   BT_BitmapRelease (hBitmap)
   hBitmap := BT_BitmapCaptureClientArea ("Win1")
   BT_BitmapGrayness (hBitmap, 100)
   BT_BitmapBrightness (hBitmap, 50)
   Flag_AlphaBlend_Effect := .F.
   BT_ClientAreaInvalidateAll ("Win1")   
RETURN


PROCEDURE Grayness_effect_end
   BT_BitmapRelease (hBitmap)
   hBitmap := 0   
   Flag_AlphaBlend_Effect := .T.
   BT_ClientAreaInvalidateAll ("Win1")
RETURN
