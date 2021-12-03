
/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://sites.google.com/site/hmgweb/
*/

#include "hmg.ch"
Function Main

PRIVATE nWidth            := 200
PRIVATE nHeight           := 100
PRIVATE lStretch          := .F.
PRIVATE lTransparent      := .F. 
PRIVATE aBackgroundColor  := NIL
PRIVATE lAdjustImage      := .F.
PRIVATE aPicture          := {"img.gif", "img.jpg", "img.wmf", "img.cur", "img.bmp", "img.png", "img.tif"}
PRIVATE i:= 1
PRIVATE lColor := .F.

        DEFINE WINDOW Win_1 ;
               AT 0,0 ;
               WIDTH 640 HEIGHT 480 ;
               TITLE 'Load Image From DISK' ;
               MAIN;
               VIRTUAL WIDTH  800;
               VIRTUAL HEIGHT 700
 
               DEFINE MAINMENU 
                        DEFINE POPUP "Options"
                           MENUITEM "Stretch"             ONCLICK {lStretch     := .NOT. (lStretch),     Define_Image()} CHECKED lStretch     NAME Menu_Stretch
                           MENUITEM "Transparent"         ONCLICK {lTransparent := .NOT. (lTransparent), Define_Image()} CHECKED lTransparent NAME Menu_Transparent
                           MENUITEM "BackgroundColor RED" ONCLICK {lColor       := .NOT. (lColor),       Define_Image()} CHECKED lColor       NAME Menu_Color
                           MENUITEM "AdjustImage"         ONCLICK {lAdjustImage := .NOT. (lAdjustImage), Define_Image()} CHECKED lAdjustImage NAME Menu_AdjustImage
                           SEPARATOR                           
                           MENUITEM "Width=200 and Height=100" ONCLICK {|| nWidth:=200, nHeight:=100, Define_Image(1)} CHECKED .F.  NAME Menu_Size1
                           MENUITEM "Width=0   and Height=0"   ONCLICK {|| nWidth:=0,   nHeight:=0,   Define_Image(2)} CHECKED .F.  NAME Menu_Size2
                           MENUITEM "Width=200 and Height=0"   ONCLICK {|| nWidth:=200, nHeight:=0,   Define_Image(3)} CHECKED .F.  NAME Menu_Size3
                           MENUITEM "Width=0   and Height=100" ONCLICK {|| nWidth:=0,   nHeight:=100, Define_Image(4)} CHECKED .F.  NAME Menu_Size4
                        END POPUP
               END MENU
 
               // @ 200,140 IMAGE Image_1 PICTURE 'img.gif' HEIGHT 100 TRANSPARENT BACKGROUNDCOLOR RED TRANSPARENTCOLOR BLACK
               // @ 200,140 IMAGE Image_1 PICTURE 'img.gif' WIDTH 200 HEIGHT 100 /*TRANSPARENT*/ BACKGROUNDCOLOR RED ADJUSTIMAGE

                
                @ 10 ,10  BUTTON Button_1 CAPTION "Set GIF" ACTION {|| Win_1.Image_1.Picture := "img.gif", ImgSize(1)} WIDTH 100  HEIGHT 30
                @ 10 ,110 BUTTON Button_2 CAPTION "Set JPG" ACTION {|| Win_1.Image_1.Picture := "img.jpg", ImgSize(2)} WIDTH 100  HEIGHT 30
                @ 10 ,210 BUTTON Button_4 CAPTION "Set WMF" ACTION {|| Win_1.Image_1.Picture := "img.wmf", ImgSize(3)} WIDTH 100  HEIGHT 30
                @ 10 ,310 BUTTON Button_5 CAPTION "Set CUR" ACTION {|| Win_1.Image_1.Picture := "img.cur", ImgSize(4)} WIDTH 100  HEIGHT 30
                @ 10 ,410 BUTTON Button_6 CAPTION "Set BMP" ACTION {|| Win_1.Image_1.Picture := "img.bmp", ImgSize(5)} WIDTH 100  HEIGHT 30
                @ 50 ,10  BUTTON Button_7 CAPTION "Set PNG" ACTION {|| Win_1.Image_1.Picture := "img.png", ImgSize(6)} WIDTH 100  HEIGHT 30 
                @ 50 ,110 BUTTON Button_8 CAPTION "Set TIF" ACTION {|| Win_1.Image_1.Picture := "img.tif", ImgSize(7)} WIDTH 100  HEIGHT 30
                
                @ 150, 10 LABEL Label_1 Value "" AUTOSIZE

                Define_Image (1)
 
        END WINDOW

        Win_1.Maximize
        ACTIVATE WINDOW Win_1
Return Nil


Procedure ImgSize (Index)
   i := Index
   Win_1.Label_1.Value := "Width: "+str(Win_1.Image_1.WIDTH)+"    Height:"+str(Win_1.Image_1.HEIGHT)

   IF IsControlDefined (Frame_1, Win_1) == .T.
      Win_1.Frame_1.Release
   ENDIF
   n:= 2
   @ (Win_1.Image_1.ROW -n), (Win_1.Image_1.COL -n) FRAME Frame_1 OF Win_1;
    WIDTH  (Win_1.Image_1.WIDTH  +n+n);
    HEIGHT (Win_1.Image_1.HEIGHT +n+n);
    TRANSPARENT 
Return


Procedure Define_Image (nSize)

   Win_1.Menu_Stretch.Checked     := lStretch
   Win_1.Menu_Transparent.Checked := lTransparent
   Win_1.Menu_AdjustImage.Checked := lAdjustImage
   Win_1.Menu_Color.Checked       := lColor
   
   aBackgroundColor := IF (lColor == .T., RED, NIL)

   IF VALTYPE (nSize) == "N"
      Win_1.Menu_Size1.Checked := .F.
      Win_1.Menu_Size2.Checked := .F.
      Win_1.Menu_Size3.Checked := .F.
      Win_1.Menu_Size4.Checked := .F.
       SetProperty ( "Win_1", "Menu_Size"+ALLTRIM(STR(nSize)), "Checked", .T. )
   ENDIF
   
   IF IsControlDefined (Image_1, Win_1) == .T.
      Win_1.Image_1.Release
   ENDIF
   
   DEFINE IMAGE Image_1
      PARENT            Win_1
      ROW               200
      COL               140
      WIDTH             nWidth
      HEIGHT            nHeight
      PICTURE           aPicture [ i ]
      STRETCH           lStretch
      TRANSPARENT       lTransparent 
      BACKGROUNDCOLOR   aBackgroundColor
      ADJUSTIMAGE       lAdjustImage
      // TRANSPARENTCOLOR  BLACK
   END IMAGE
    
   IF IsControlDefined (Label_1, Win_1) == .T.
      ImgSize (i)
   ENDIF

Return


