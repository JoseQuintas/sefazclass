// By Claudio Soto (2013)

#include "hmg.ch"

FUNCTION Main()

LOCAL cFileName       := "ScreenSplash.PNG"
LOCAL nDelaySeconds   := 7
LOCAL nAnimateSeconds := 2


   SET WINDOW MAIN OFF
      CreateScreenSplash (cFileName, nDelaySeconds, nAnimateSeconds)
   SET WINDOW MAIN ON


   DEFINE WINDOW Form1 ;
       AT 0,0 ;
       WIDTH 400 HEIGHT 400 ;
       TITLE 'Main Window' ;
       MAIN
       @ 150,150  BUTTON Button_1 CAPTION "Hello" ACTION MsgInfo ("Hello") 
    END WINDOW

    CENTER WINDOW Form1
    ACTIVATE WINDOW Form1

RETURN NIL



*-------------------------------------------------------------------------------------------*
PROCEDURE CreateScreenSplash (cFileName, nDelaySeconds, nAnimateSeconds)
*-------------------------------------------------------------------------------------------*
LOCAL hBitmap, Image_Width, Image_Height, Image_BackColor

   IF HMG_GetImageInfo (cFileName, @Image_Width, @Image_Height, @Image_BackColor) == .F.
      MsgHMGError ("File Opening Error. Program Terminated" )
   ENDIF

   DEFINE WINDOW FormSplash;
         AT 0,0;  
         WIDTH Image_Width;
         HEIGHT Image_Height;
         BACKCOLOR Image_BackColor; 
         NOSYSMENU;
         NOSIZE;
         NOMINIMIZE;
         NOMAXIMIZE; 
         NOCAPTION;
         TOPMOST;
         CHILD
         
         SET WINDOW FormSplash TRANSPARENT TO COLOR Image_BackColor
         
         ON KEY ESCAPE ACTION FormSplash.Release
         
         @ 0, 0 IMAGE Image_1 PICTURE cFileName ON CLICK MsgInfo ("Splash Image")
         
         @   0,   0 LABEL Label_1 VALUE "THE POWER OF HMG" AUTOSIZE TRANSPARENT FONT "Times New Roman" SIZE 36 FONTCOLOR NAVY
         @ 252, 410 LABEL Label_2 VALUE "Loading ..." TRANSPARENT FONT "Arial" SIZE 14 FONTCOLOR SILVER
         
         @ 276, 360 PROGRESSBAR ProgressBar_1 RANGE 0, 1  WIDTH 200 HEIGHT 20
         SET PROGRESSBAR ProgressBar_1 OF FormSplash ENABLE MARQUEE
         
         DEFINE TIMER Timer_1 INTERVAL (nDelaySeconds * 1000) ACTION {|| FormSplash.Timer_1.Release, FormSplash.Release }
         
   END WINDOW
   
   CENTER WINDOW FormSplash
   ANIMATE WINDOW FormSplash INTERVAL (nAnimateSeconds * 1000) MODE AW_HOR_POSITIVE
   ACTIVATE WINDOW FormSplash
RETURN

