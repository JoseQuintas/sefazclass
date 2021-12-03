/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
 *
 * Revised by Pablo César on January 30th, 2015
*/

#include "hmg.ch"

#include "demo1.ch"
#include "demo2.ch"

Function Main()
DEFINE WINDOW Form_1 ;
	AT 0,0 ;
	WIDTH 640 HEIGHT 480 ;
	TITLE 'HMG Demo' ;
	MAIN BACKCOLOR BLUE
		
	DEFINE LABEL Label_1
        ROW    04
        COL    80
        WIDTH  300
        HEIGHT 24
        VALUE "Look at window TITLE"
        FONTNAME "Arial"
		FONTSIZE 12
		FONTBOLD .T.
		FONTCOLOR YELLOW
		TRANSPARENT .T.
    END LABEL
	
	DEFINE LABEL Label_2
        ROW    380
        COL    10
        WIDTH  630
        HEIGHT 48
        VALUE "Give a look at files: Compile.bat, MultiPrg.hbp and MultiPrg.hbc"
        FONTNAME "Arial"
		FONTSIZE 14
		FONTBOLD .T.
		FONTCOLOR BLACK
		ALIGNMENT Center
		TRANSPARENT .T.
    END LABEL

    DEFINE BUTTON Button_1
        ROW    220
        COL    210
        WIDTH  160
        HEIGHT 40
        ACTION {|| BT_ClientAreaInvalidateAll("Form_1"),InOtherPrg() }
        CAPTION "Call OTHER module"
    END BUTTON

END WINDOW
Form_1.Center
Form_1.Activate
Return Nil