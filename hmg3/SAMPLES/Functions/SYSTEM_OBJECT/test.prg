/*
* HMG Clipboard Test
* (c) 2009 Roberto Lopez <mail.box.hmg@gmail.com>
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Clipboard Test' ;
		MAIN 

		DEFINE BUTTON b1
			ROW	10
			COL	10
			WIDTH	140
			CAPTION	'Set Clipboard'
			ACTION	System.Clipboard := 'Hello Clipboard!!!'
		END BUTTON

		DEFINE BUTTON b2
			ROW	50
			COL	10
			WIDTH	140
			CAPTION	'Get Clipboard'
			ACTION	MsgInfo(System.Clipboard)
		END BUTTON

		DEFINE BUTTON b3
			ROW	90
			COL	10
			WIDTH	140
			CAPTION	'Get Desktop Width'
			ACTION	MsgInfo(Str(System.DesktopWidth))
		END BUTTON

		DEFINE BUTTON b4
			ROW	130
			COL	10
			WIDTH	140
			CAPTION	'Get Desktop Height'
			ACTION	MsgInfo(Str(System.DesktopHeight))
		END BUTTON

		DEFINE BUTTON b5
			ROW	170
			COL	10
			WIDTH	140
			CAPTION	'Get Default Printer'
			ACTION	MsgInfo(System.DefaultPrinter)
		END BUTTON

	END WINDOW

	ACTIVATE WINDOW Win_1 

Return

