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
		ON INIT ThisWindow.Title := 'New Title'

		@ 10,10 BUTTON Button_1 ;
			CAPTION 'Hi!!!' ;
			ACTION ThisTest() ;
			TOOLTIP 'Test Tip'

		@ 40,10 BUTTON Button_2 ;
			CAPTION 'Release' ;
			ACTION ThisWindow.Release 

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

Procedure ThisTest()

	This.Caption  := 'New Caption'

	ThisWindow.Row := 10
	ThisWindow.Col := 10
	ThisWindow.Width := 200
	ThisWindow.Height := 100

Return
