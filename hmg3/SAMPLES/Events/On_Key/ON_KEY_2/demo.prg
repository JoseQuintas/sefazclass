/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'HMG Demo' ;
		MAIN 

		ON KEY F2 ACTION MsgInfo ( ThisWindow.FocusedControl )

		@ 10,10 TEXTBOX Text_1 
		@ 50,10 TEXTBOX Text_2 
		@ 90,10 TEXTBOX Text_3 

      Define statusbar
          statusitem "Select Texbox and press F2"
      end statusbar
	END WINDOW

	Form_1.Center

	Form_1.Activate

Return Nil

