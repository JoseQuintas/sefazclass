/*
* HMG This Demo
* (c) 2003 Roberto Lopez
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		TITLE 'This Demo' ;
		MAIN ;
		ON INIT This.Title := 'New Title (From This)'

		@ 10,10 BUTTON Button_1 ;
			CAPTION 'Hi!!!' ;
			ACTION ThisTest() ;
			TOOLTIP 'Test Tip'

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

Procedure ThisTest()

	ThisWindow.Row := 10
	ThisWindow.Col := 10

	MsgInfo ( This.Name )

	MsgInfo ( This.Caption )

	This.Hide

	MsgInfo (This.Name)

	MsgInfo ( This.ToolTip )

	This.Show

Return
