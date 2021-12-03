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

		@ 10,10 TEXTBOX Text_1 ;
			VALUE 123 ;
			TOOLTIP 'Numeric TextBox' ;
			NUMERIC ;
			MAXLENGTH 5 ;
			RIGHTALIGN ;
			ON LOSTFOCUS if ( This.Value < 100 , This.SetFocus , Nil)


		@ 40,10 TEXTBOX Text_2 ;
			VALUE 'Hi All' ;
			TOOLTIP 'Character TextBox' ;
			DISABLEDBACKCOLOR { 0,255,0 } ;
			DISABLEDFONTCOLOR { 255,255,255 } 

		DEFINE BUTTON C
			ROW	250
			COL	100
			WIDTH	160
			CAPTION	'Set Text_2 ReadOnly .T.'
			ACTION	Form_1.Text_2.ReadOnly := .T.
		END BUTTON

		DEFINE BUTTON D
			ROW	250
			COL	290
			WIDTH	160
			CAPTION	'Set Text_2 ReadOnly .F.'
			ACTION	Form_1.Text_2.ReadOnly := .F.
		END BUTTON


	END WINDOW

	Form_1.Center

	Form_1.Activate

Return Nil

