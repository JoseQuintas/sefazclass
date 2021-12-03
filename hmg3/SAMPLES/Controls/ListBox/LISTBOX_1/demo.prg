/*
* HMG Hello World Demo
* (c) 2002-2004 Roberto Lopez <mail.box.hmg@gmail.com>
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Win1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN 

		DEFINE LISTBOX LIST1
			ROW	10
			COL	10
			WIDTH	100
			HEIGHT	110
			ITEMS	{ '01','02','03','04','05','06','07','08','09','10' }
		END LISTBOX

		DEFINE BUTTON BUTTON1
			ROW	10
			COL	150
			CAPTION	'Delete Items 8,9,10'
			ACTION	DeleteTest()
			WIDTH	150
		END BUTTON

	END WINDOW

	ACTIVATE WINDOW Win1 

Return

Procedure DeleteTest
	Win1.List1.DeleteItem(10)
	Win1.List1.DeleteItem(9)
	Win1.List1.DeleteItem(8)
Return
