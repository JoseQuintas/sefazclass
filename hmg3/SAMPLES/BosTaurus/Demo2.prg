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

PRIVATE cont := 1 

   DEFINE WINDOW Win1;
       AT 0,0;
       WIDTH  600;
       HEIGHT 600;
       TITLE "Demo2: DrawGradientFill and DrawText";
       MAIN;
       ON PAINT Proc_ON_PAINT ();
       VIRTUAL WIDTH  700;
       VIRTUAL HEIGHT 700;

       DEFINE MAIN MENU
           DEFINE POPUP "File"
                  MENUITEM "Exit" ACTION Win1.Release
           END POPUP
       END MENU


        @   50, 100 LABEL  Label_1  VALUE   " Label_1 ON PAINT Event Demo " AUTOSIZE 
        @  100, 100 LABEL  Label_2  VALUE   " Label_2 ON PAINT Event Demo " AUTOSIZE TRANSPARENT FONTCOLOR YELLOW 

        @  330, 300 BUTTON Button_1 CAPTION "Maximize" ACTION Win1.Maximize      
        @  330, 100 BUTTON Button_2 CAPTION "Click"    ACTION MsgInfo ("Hello")
        @  400, 200 BUTTON Button_3 CAPTION "Change"   ACTION {|| cont++, BT_ClientAreaInvalidateAll ("Win1")}
      
   END WINDOW

   CENTER WINDOW Win1
   ACTIVATE WINDOW Win1

RETURN Nil



PROCEDURE Proc_ON_PAINT
LOCAL Width  := BT_ClientAreaWidth  ("Win1")
LOCAL Height := BT_ClientAreaHeight ("Win1")  
LOCAL hDC, BTstruct

  hDC = BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
  
    IF cont > 6
       cont = 1
    ENDIF

    DO CASE
       CASE cont = 1
            BT_DrawGradientFillHorizontal (hDC, 0,       0, Width/2, Height, BLACK, BLUE)
            BT_DrawGradientFillHorizontal (hDC, 0, Width/2, Width/2, Height, BLUE,  BLACK)

       CASE cont = 2
            BT_DrawGradientFillVertical (hDC,        0,   0, Width, Height/2, BLACK, RED)
            BT_DrawGradientFillVertical (hDC, Height/2,   0, Width, Height/2, RED,   BLACK)

       CASE cont = 3
            BT_DrawGradientFillVertical (hDC,        0,   0, Width, Height/2, RED,   GREEN)
            BT_DrawGradientFillVertical (hDC, Height/2,   0, Width, Height/2, GREEN, BLUE)
       
       CASE cont = 4
            BT_DrawGradientFillHorizontal (hDC, 0,       0, Width/2, Height, GREEN, BLUE)
            BT_DrawGradientFillHorizontal (hDC, 0, Width/2, Width/2, Height, BLUE,  RED)
           
      CASE cont = 5 
           BT_DrawGradientFillVertical   (hDC,   0,       0,  Width,  Height, WHITE, BLACK)                 

      CASE cont = 6            
           BT_DrawGradientFillHorizontal (hDC,   0,       0,  Width,  Height, {100,0,123}, BLACK)      
     
    END CASE
    
    nTypeText  := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD + BT_TEXT_ITALIC + BT_TEXT_UNDERLINE    
    nAlingText := BT_TEXT_CENTER + BT_TEXT_BASELINE  
    BT_DrawText (hDC, Height/2-3, Width/2+3, "The Power of HMG", "Comic Sans MS", 42, GRAY, BLACK, nTypeText, nAlingText) // Shadow Effect
    BT_DrawText (hDC, Height/2, Width/2, "The Power of HMG", "Comic Sans MS", 42, YELLOW, BLACK, nTypeText, nAlingText)   
   
  BT_DeleteDC (BTstruct) 

RETURN 

