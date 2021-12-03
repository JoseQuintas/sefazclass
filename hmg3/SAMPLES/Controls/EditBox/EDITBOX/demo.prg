/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2010 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'HMG Demo' ;
		ICON 'DEMO.ICO' ;
		MAIN 

		DEFINE STATUSBAR
			STATUSITEM 'HMG Power Ready!' 
		END STATUSBAR

		@ 30,10 EDITBOX Edit_1 ;
			WIDTH 410 ;
			HEIGHT 140 ;
			VALUE 'EditBox!!' ;
			TOOLTIP 'EditBox' ;
			MAXLENGTH 255 ;
			ON CHANGE ShowRowCol() ;
			DISABLEDBACKCOLOR { 0,0,255} ;
         nohscroll;
			DISABLEDFONTCOLOR { 0,255,0 } 


		DEFINE BUTTON B
			ROW	250
			COL	10
			WIDTH	130
			CAPTION 'Set CaretPos'
			ACTION	( Form_1.Edit_1.CaretPos := Val(InputBox('Set Caret Position','')) , Form_1.Edit_1.SetFocus )
		END BUTTON

		DEFINE BUTTON C
			ROW	250
			COL	150
			WIDTH	130
			CAPTION	'Set ReadOnly .T.'
			ACTION	Form_1.Edit_1.ReadOnly := .T.
		END BUTTON

		DEFINE BUTTON D
			ROW	250
			COL	290
			WIDTH	130
			CAPTION	'Set ReadOnly .F.'
			ACTION	Form_1.Edit_1.ReadOnly := .F.
		END BUTTON

	END WINDOW

	Form_1.Center()

	Form_1.Activate()

Return Nil

Procedure ShowRowCol
Local s , c , i , e , q 
	
	s := Form_1.Edit_1.Value
	c := Form_1.Edit_1.CaretPos
	e := 0
	q := 0

	for i := 1 to c
		if substr ( s , i , 1 ) == chr(13)
			e++
			q := 0
		Else
			q++
		EndIf
	Next i

	Form_1.StatusBar.Item(1) := 'Row: ' + alltrim(Str(e+1)) + ' Col: ' + alltrim(Str(q))

Return
