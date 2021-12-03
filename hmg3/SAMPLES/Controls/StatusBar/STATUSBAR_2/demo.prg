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
		WIDTH 600 HEIGHT 400 ;
		TITLE 'HMG StatusBar Demo' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE MAIN MENU 
			POPUP '&StatusBar Test'
				ITEM 'Set StatusBar Item 1'	ACTION Form_1.StatusBar.Item(1) := "New value 1"
				ITEM 'Set StatusBar Item 2'	ACTION Form_1.StatusBar.Item(2) := "New value 2"
				ITEM 'Open Other Window...'	ACTION Modal_Click()
                        END POPUP
			POPUP '&Help'
				ITEM '&About'		ACTION MsgInfo ("HMG StatusBar Demo") 
			END POPUP
		END MENU

		DEFINE STATUSBAR FONT 'Verdana' SIZE 7

			STATUSITEM "Item 1" 	WIDTH 100 FLAT 
			STATUSITEM "Item 2" 	WIDTH 100 ACTION MsgInfo('Click! 2') RAISED 
			STATUSITEM 'A Car !'	WIDTH 100 ICON 'Car.Ico' 
			CLOCK 
			DATE 
			STATUSITEM "Item 4" 	WIDTH 100 ACTION MsgInfo('Click! 4') RAISED

		END STATUSBAR

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

*-----------------------------------------------------------------------------*
Procedure Modal_CLick
*-----------------------------------------------------------------------------*

	DEFINE WINDOW Form_2 ;
		AT 0,0 ;
		WIDTH 400 HEIGHT 300 ;
		TITLE 'StatusBar Test'  ;
		MODAL NOSIZE

		DEFINE STATUSBAR 

			STATUSITEM "Modal 1" 	WIDTH 100 ACTION MsgInfo('Click! 1') 
			STATUSITEM "Modal 2" 	WIDTH 100 ACTION MsgInfo('Click! 2')

		END STATUSBAR

	END WINDOW

	Form_2.Center

	Form_2.Activate

Return Nil


