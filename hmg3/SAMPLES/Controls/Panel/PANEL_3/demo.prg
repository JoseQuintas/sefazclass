/*
* HMG Embedded Child Window Demo
* (c) 2002-2009 Roberto Lopez <mail.box.hmg@gmail.com>
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Win_0 ;
		ROW 0 ;
		COL 0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'HMG Panel Window Demo' ;
		WINDOWTYPE MAIN  

		DEFINE BUTTON BUTTON_1
			ROW		160
			COL		90
			WIDTH		200
			CAPTION		'Click Me!'
			ACTION		Test()
		END BUTTON

	END WINDOW

	Win_0.Center	

	Activate Window Win_0

Return

Procedure Test

	DEFINE WINDOW Win_1 ;
		ROW 0 ;
		COL 0 ;
		WIDTH 500 ;
		HEIGHT 300 ;
		TITLE 'HMG Panel Window Demo' ;
		WINDOWTYPE MODAL

		DEFINE WINDOW Win_2 ;
			ROW 30 ;
			COL 30 ;
			WIDTH 300 ;
			HEIGHT 200 ;
			VIRTUALWIDTH 400 ;
			VIRTUALHEIGHT 400 ;
			WINDOWTYPE PANEL

			DEFINE LABEL LABEL_1
				ROW		10
				COL		10
				VALUE		'Panel window...'
				WIDTH		300
			END LABEL

			DEFINE BUTTON BUTTON_1
				ROW		40
				COL		10
				CAPTION		'Click Me!'
				ACTION		MsgInfo('Clicked!')
			END BUTTON

			DEFINE LABEL LABEL_2
				ROW		90
				COL		10
				VALUE		"Can do this!"
				WIDTH		300
			END LABEL

			DEFINE TEXTBOX TEXT_1
				ROW		120
				COL		10
				VALUE		'Test'
			END TEXTBOX

			DEFINE TEXTBOX TEXT_2
				ROW		150
				COL		10
				VALUE		'Test'
			END TEXTBOX

			DEFINE TEXTBOX TEXT_3
				ROW		180
				COL		10
				VALUE		'Test'
			END TEXTBOX

			DEFINE TEXTBOX TEXT_4
				ROW		210
				COL		10
				VALUE		'Test'
			END TEXTBOX

			DEFINE TEXTBOX TEXT_5
				ROW		240
				COL		10
				VALUE		'Test'
			END TEXTBOX

		END WINDOW

		DEFINE TEXTBOX TEXT_1
			ROW		300
			COL		10
			VALUE		'Test'
		END TEXTBOX

	END WINDOW

	Win_1.Center	

	// Panel windows are automatically activated through its parent
	// so, only Win_1 must be activated.

	Activate Window Win_1


Return

