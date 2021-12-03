#pragma /w2
// #pragma /es2

/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://sites.google.com/site/hmgweb/
*/

#include "hmg.ch"
Function Main
        DEFINE WINDOW Win_1 ;
                AT 0,0 ;
                WIDTH 640 HEIGHT 480 ;
                TITLE 'Load Image From DISK' ;
                ICON 'WORLD' ;
                MAIN

                @ 200,140 IMAGE Image_1 PICTURE 'img.gif' WIDTH 200 HEIGHT 200

                @ 10 ,10  BUTTON Button_1 CAPTION "Set GIF" ACTION Win_1.Image_1.Picture := "img.gif" WIDTH 100  HEIGHT 30
                @ 10 ,110 BUTTON Button_2 CAPTION "Set JPG" ACTION Win_1.Image_1.Picture := "img.jpg" WIDTH 100  HEIGHT 30
                @ 10 ,210 BUTTON Button_3 CAPTION "Set ICO" ACTION Win_1.Image_1.Picture := "img.ico" WIDTH 100  HEIGHT 30
                @ 10 ,310 BUTTON Button_4 CAPTION "Set WMF" ACTION Win_1.Image_1.Picture := "img.wmf" WIDTH 100  HEIGHT 30
                @ 10 ,410 BUTTON Button_5 CAPTION "Set CUR" ACTION Win_1.Image_1.Picture := "img.cur" WIDTH 100  HEIGHT 30
                @ 10 ,510 BUTTON Button_6 CAPTION "Set BMP" ACTION Win_1.Image_1.Picture := "img.bmp" WIDTH 100  HEIGHT 30
                @ 50 ,10  BUTTON Button_7 CAPTION "Set PNG" ACTION Win_1.Image_1.Picture := "img.png" WIDTH 100  HEIGHT 30
                @ 50 ,110 BUTTON Button_8 CAPTION "Set TIF" ACTION Win_1.Image_1.Picture := "img.tif" WIDTH 100  HEIGHT 30                
        END WINDOW
        ACTIVATE WINDOW Win_1
Return Nil

