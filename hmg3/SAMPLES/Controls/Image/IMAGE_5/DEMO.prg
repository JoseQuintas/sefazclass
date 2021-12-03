
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
               WIDTH 550 HEIGHT 670 ;
               TITLE 'Resize Image' ;
               BACKCOLOR GREEN;
               MAIN
               
               @  10, 10 IMAGE Image1 PICTURE "Giovanni.GIF" WIDTH 500 HEIGHT 300 ADJUSTIMAGE
               @ 320, 10 IMAGE Image2 PICTURE "Giovanni.PNG" WIDTH 500 HEIGHT 300 ADJUSTIMAGE
               
        END WINDOW
        Win_1.Center
        ACTIVATE WINDOW Win_1
Return Nil

