/*
* HMG Demo
* (c) 2003 Roberto Lopez 
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		TITLE 'CaretPos Property Demo' ;
		MAIN 

		DEFINE MAIN MENU

			POPUP 'CaretPos'

				ITEM 'Set CaretPos Property'	ACTION Form_1.Text_1.CaretPos := 4 
				ITEM 'Get CaretPos Property'	ACTION MsgInfo ( Str ( Form_1.Text_1.CaretPos ) )

			END POPUP

		END MENU

		@ 10,10 TEXTBOX text_1 VALUE '1234567890'

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

