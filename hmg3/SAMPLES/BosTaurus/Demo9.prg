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
PRIVATE flag := .F.

    DEFINE WINDOW Win1;
        AT 200,600;
        WIDTH  500;
        HEIGHT 400;
        TITLE  "Demo9: Draw DC to DC";
        NOMINIMIZE;
        ON SIZE      {|| flag := .F., BT_ClientAreaInvalidateAll ("Win2", .T.)};
        ON MAXIMIZE  {|| flag := .F., BT_ClientAreaInvalidateAll ("Win2", .T.)};
        MAIN;
        ON PAINT Proc_ON_PAINT ()

        DEFINE TAB Tab_1;
           ROW 50;
           COL 50;
           WIDTH  400;
           HEIGHT 200
           
           DEFINE PAGE "EditBox"
              @ 50, 50 EDITBOX EditBox_1 WIDTH 300 HEIGHT 120  VALUE "Write your memories here."+CRLF+CRLF BOLD BACKCOLOR ORANGE
           END PAGE 
           
           DEFINE PAGE "Image"
              @ 40, 120 IMAGE Image_1 PICTURE "COWBOOK.bmp" WIDTH 128 HEIGHT 128 
           END PAGE
           
        END TAB
       
        @ 300, 180 BUTTON Button_1 CAPTION "Click" ACTION MsgInfo ("Hello")

        DEFINE TIMER Timer1 INTERVAL 200 ACTION Proc_Mirror()

   END WINDOW

   DEFINE WINDOW Win2;
        AT 0,0;
        WIDTH  500;
        HEIGHT 400;
        TITLE  "Mirror of the Client Area of the Win1";
        NOSYSMENU;
        CHILD
   END WINDOW


   ACTIVATE WINDOW Win1, Win2

RETURN Nil


PROCEDURE Proc_ON_PAINT    
LOCAL Width  := BT_ClientAreaWidth  ("Win1")
LOCAL Height := BT_ClientAreaHeight ("Win1")
LOCAL hDC, BTstruct
   hDC = BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
         BT_DrawGradientFillVertical (hDC, 0, 0, Width, Height, WHITE, BLACK)
   BT_DeleteDC (BTstruct)
RETURN


PROCEDURE Proc_Mirror
LOCAL Width1, Height1
LOCAL Width2, Height2
LOCAL hDC1, BTstruct1
LOCAL hDC2, BTstruct2
LOCAL Alpha := 50

   IF flag == .T.
      RETURN
   ENDIF
   
   flag = .T.

   Width1  := BT_ClientAreaWidth  ("Win1")
   Height1 := BT_ClientAreaHeight ("Win1")
   Width2  := BT_ClientAreaWidth  ("Win2")
   Height2 := BT_ClientAreaHeight ("Win2")

   hDC1 = BT_CreateDC ("Win1", BT_HDC_ALLCLIENTAREA, @BTstruct1)
   hDC2 = BT_CreateDC ("Win2", BT_HDC_ALLCLIENTAREA, @BTstruct2)

          BT_DrawDCtoDC (hDC2, 0, 0, Width2, Height2, BT_SCALE, hDC1, 0, 0, Width1, Height1)
          // BT_DrawDCtoDCAlphaBlend (hDC2, 0, 0, Width2, Height2, Alpha, BT_SCALE, hDC1, 0, 0, Width1, Height1)
                    
          nTypeText    := BT_TEXT_TRANSPARENT    
          nAlingText   := BT_TEXT_LEFT + BT_TEXT_TOP 
          nOrientation := BT_TEXT_DIAGONAL_ASCENDANT
          BT_DrawText (hDC2, 300, 50, "Mirror of the Win1", "Times", 42, YELLOW, BLACK, nTypeText, nAlingText, nOrientation)

   BT_DeleteDC (BTstruct1)
   BT_DeleteDC (BTstruct2)
   BT_ClientAreaInvalidateAll ("Win2")

   flag = .F.   
RETURN
