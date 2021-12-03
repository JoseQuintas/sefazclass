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

		DEFINE MAIN MENU 
			POPUP 'Common &Dialog Functions'
				ITEM 'GetFont()'	ACTION GetFont_Click()
			END POPUP
		END MENU

	END WINDOW

	Form_1.Center()

	Form_1.Activate()

Return Nil

*-----------------------------------------------------------------------------*
Procedure GetFont_Click
*-----------------------------------------------------------------------------*
Local a

	a := GetFont ( 'Arial' , 12 , .f. , .t. , {0,0,255} , .f. , .f. , 0 )

	if empty ( a [1] )

		MsgInfo ('Cancelled')

	Else

		MsgInfo( a [1] + Str( a [2] ) )

		if  a [3] == .t.
			MsgInfo ("Bold")
		else
			MsgInfo ("Non Bold")
		endif

		if  a [4] == .t.
			MsgInfo ("Italic")
		else
			MsgInfo ("Non Italic")
		endif

		MsgInfo ( str( a [5][1]) +str( a [5][2]) +str( a [5][3]), 'Color' )

		if  a [6] == .t.
			MsgInfo ("Underline")
		else
			MsgInfo ("Non Underline")
		endif

		if  a [7] == .t.
			MsgInfo ("StrikeOut")
		else
			MsgInfo ("Non StrikeOut")
		endif

		MsgInfo ( str ( a [8] ) , 'Charset' )

	EndIf

Return Nil
