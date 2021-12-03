*******************************************************************************
* PROGRAMA: Demo ON PAINT event
* LENGUAJE: HMG
* FECHA:    Setiembre 2012
* AUTOR:    Dr. CLAUDIO SOTO
* PAIS:     URUGUAY
* E-MAIL:   srvet@adinet.com.uy
* BLOG:     http://srvet.blogspot.com
*******************************************************************************

/*
Resource definition.
The Resources File (.RC) has a format:
<cResourceName> <cResourseType> <cResourceFullFileName>

Example: MyApplication.RC 
BosTaurus_Logo1 BITMAP BosTaurus_Logo.BMP
BosTaurus_Logo2 JPG    BosTaurus_Logo.JPG
BosTaurus_Logo3 GIF    BosTaurus_Logo.GIF
BosTaurus_Logo4 PNG    BosTaurus_Logo.PNG
BosTaurus_Logo5 TIF    BosTaurus_Logo.TIF
*/


#include "hmg.ch"


FUNCTION MAIN

PRIVATE hBitmap := 0 

     DEFINE WINDOW Win1;
            AT 0,0;
            WIDTH  700;
            HEIGHT 600;
            TITLE "Bos Taurus: Prototype Demo";
            MAIN;
            ON INIT     Proc_ON_INIT ();
            ON RELEASE  Proc_ON_RELEASE ();
            ON PAINT    Proc_ON_PAINT ()
        
            @  500, 280 BUTTON Button_1 CAPTION "Click" ACTION MsgInfo (BT_InfoName() + Space(3) + BT_InfoVersion() + CRLF + BT_InfoAuthor (), "Info")

    END WINDOW

    CENTER WINDOW Win1
    ACTIVATE WINDOW Win1
RETURN Nil


PROCEDURE Proc_ON_INIT
  hBitmap := BT_BitmapLoadFile ("BosTaurus_logo.JPG")
  // hBitmap := BT_BitmapLoadFile ("BosTaurus_logo.PNG")
  // hBitmap := BT_BitmapLoadFile ("BosTaurus_Logo.TIF")
  // hBitmap := BT_BitmapLoadFile ("BosTaurus_logo.BMP")
RETURN


PROCEDURE Proc_ON_RELEASE
   BT_BitmapRelease (hBitmap)
RETURN


PROCEDURE Proc_ON_PAINT
LOCAL hDC, BTstruct
   hDC := BT_CreateDC ("Win1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)
      BT_DrawGradientFillVertical (hDC, 0, 0, BT_ClientAreaWidth("Win1"), BT_ClientAreaHeight("Win1"), WHITE, BLACK)
      BT_DrawBitmap (hDC, 30, 150, 400, 400, BT_COPY, hBitmap)
   BT_DeleteDC (BTstruct)
RETURN


