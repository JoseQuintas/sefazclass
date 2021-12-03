/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	SET NAVIGATION EXTENDED
	SET EPOCH TO 2000

	SET CENTURY ON
	SET DATE FRENCH

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'HMG Demo' ;
		MAIN 

		DEFINE MAIN MENU
			DEFINE POPUP 'Test'
				MENUITEM 'Set Text_1 Value' ACTION Form_1.Text_1.Value := Date()
				MENUITEM 'Set Text_2 Value' ACTION Form_1.Text_2.Value := ctod ('  /  /  ')
				MENUITEM 'Set Text_3 Value' ACTION Form_1.Text_3.Value := ctod('01/01/2005')
				MENUITEM 'Set Text_1 ReadOnly' ACTION Form_1.Text_1.ReadOnly := .T.
				MENUITEM 'Clear Text_1 ReadOnly' ACTION Form_1.Text_1.ReadOnly := .F.
			SEPARATOR
				MENUITEM 'Get Text_1 Value' ACTION MsgInfo ( dtoc ( Form_1.Text_1.Value ) )
				MENUITEM 'Get Text_2 Value' ACTION MsgInfo ( dtoc ( Form_1.Text_2.Value ) ) 
				MENUITEM 'Get Text_3 Value' ACTION MsgInfo ( dtoc ( Form_1.Text_3.Value ) )
			END POPUP
		END MENU

		@ 10,10 TEXTBOX Text_1 ;
			VALUE ctod('01/01/2004') ;
			TOOLTIP 'Date TextBox 1' ;
			DATE

		@ 40,10 TEXTBOX Text_2 ;
			VALUE Date() ;
			TOOLTIP 'Date TextBox 2' ;
			DATE

		DEFINE TEXTBOX Text_3
			ROW 70
			COL 10
			DATE .T.
		END TEXTBOX

	END WINDOW

	Form_1.Center

	Form_1.Activate

Return Nil

