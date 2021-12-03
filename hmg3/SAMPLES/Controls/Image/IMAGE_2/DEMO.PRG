/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

        DEFINE WINDOW Win_1 ;
                AT 0,0 ;
                WIDTH 640 HEIGHT 480 ;
                TITLE 'Main Window' ;
                ICON 'WORLD' ;
                MAIN

                @ 200,140 IMAGE Image_1 ;
                        PICTURE 'img.gif' ;
                        WIDTH 200 ;
                        HEIGHT 200

                @ 10 ,10  BUTTON Button_1 CAPTION "Set gif" ACTION Win_1.Image_1.Picture := "img.gif" WIDTH 100  HEIGHT 30
                @ 10 ,110 BUTTON Button_2 CAPTION "Set jpg" ACTION Win_1.Image_1.Picture := "img.jpg" WIDTH 100  HEIGHT 30
                @ 10 ,210 BUTTON Button_3 CAPTION "Set ico" ACTION Win_1.Image_1.Picture := "img.ico" WIDTH 100  HEIGHT 30
                @ 10 ,310 BUTTON Button_4 CAPTION "Set wmf" ACTION Win_1.Image_1.Picture := "img.wmf" WIDTH 100  HEIGHT 30
                @ 10 ,410 BUTTON Button_5 CAPTION "Set cur" ACTION Win_1.Image_1.Picture := "img.cur" WIDTH 100  HEIGHT 30
                @ 10 ,510 BUTTON Button_6 CAPTION "Set bmp" ACTION Win_1.Image_1.Picture := "demo.bmp" WIDTH 100  HEIGHT 30

        END WINDOW

        ACTIVATE WINDOW Win_1

Return Nil



