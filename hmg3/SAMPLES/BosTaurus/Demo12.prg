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

SET CODEPAGE TO UNICODE

PRIVATE hBitmap := 0

PRIVATE Claudio := "クラウディオ"
PRIVATE Soto:= "·ソト"

PRIVATE Shotokan := "松涛館"
PRIVATE KarateDo := "空手道"
PRIVATE Nihon_Karate_Kyokai := "日本空手協会"  //  JKA = Japan Karate Association

   DEFINE WINDOW Win1 ;
      AT 0,0 ;
      WIDTH 720 ;
      HEIGHT 600 ;
      TITLE "Demo12: Unicode Text (in japanese)";
      MAIN;
      NOMAXIMIZE;
      NOSIZE;
      BACKCOLOR WHITE;
      ON INIT     Proc_ON_INIT ();
      ON RELEASE  Proc_ON_RELEASE ();
      ON PAINT    Proc_ON_PAINT ()
            
    
   END WINDOW

   CENTER WINDOW Win1
   ACTIVATE WINDOW Win1

RETURN NIL


PROCEDURE Proc_ON_INIT
  // hBitmap := BT_BitmapLoadFile ("Shotokan.PNG")
  hBitmap := BT_BitmapLoadFile ("松涛館.PNG")
RETURN


PROCEDURE Proc_ON_RELEASE
   BT_BitmapRelease (hBitmap)
RETURN


PROCEDURE Proc_ON_PAINT
PRIVATE hDC, BTstruct
PRIVATE nTypeText, nAlingText 
   
   hDC := BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
      
      BT_DrawBitmapTransparent (hDC, 0, 105, 506, 500, BT_SCALE, hBitmap)
      
      nTypeText  := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD
      nAlingText := BT_TEXT_LEFT + BT_TEXT_TOP

      BT_DrawText (hDC, 480, 120, Nihon_Karate_Kyokai, "MS GOTHIC", 58, BLACK, WHITE, nTypeText, nAlingText)

      CHARACTER_VERTICAL (70,  25, 120, Shotokan)
      CHARACTER_VERTICAL (70, 575, 120, KarateDo)
      
   BT_DeleteDC (BTstruct)
RETURN



PROCEDURE CHARACTER_VERTICAL (nRow, nCol, nInc, cText)
LOCAL i, cChar
   FOR i = 1 TO HB_ULEN(cText)
       cChar := HB_USUBSTR(cText, i, 1)
       BT_DrawText (hDC, (nRow + nInc*(i-1)), nCol, cChar, "MS GOTHIC", 80, BLACK, WHITE, nTypeText, nAlingText)
   NEXT
RETURN

