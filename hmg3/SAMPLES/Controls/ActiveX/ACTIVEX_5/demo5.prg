
/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-2008 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
 * Activex Sample: Inspired by Freewin Activex inplementation by 
 * Oscar Joel Lira Lira (http://sourceforge.net/projects/freewin).
*/

#include "hmg.ch"

FUNCTION Main()

	DEFINE WINDOW Win1 ;
		AT 0,0 ;
		WIDTH 800 ;
		HEIGHT 500 ;
		TITLE 'HMG ActiveX Support Demo' ;
		MAIN 

		DEFINE MAIN MENU
			POPUP "Test"
				MENUITEM "Play File" ACTION Test()
			END POPUP 			
		END MENU

		DEFINE ACTIVEX Test
			ROW 10
			COL 50
			WIDTH 700  
			HEIGHT 400  
			PROGID "WMPlayer.OCX.7"  
		END ACTIVEX

	END WINDOW

	Center Window Win1

	Activate Window Win1

RETURN NIL

Procedure Test()
Local cLocation
Local i
Local cChar
Local cOut

	cLocation := cLocation := GetCurrentFolder() + '\' 

	cOut := ''

	For i := 1 To Len ( cLocation )

		cChar := SubStr ( cLocation , i , 1 )

		If cChar == '\'

			cOut := cOut + '\\'

		Else

			cOut := cOut + cChar

		EndIf

	Next i


	Win1.Test.Object:url := cOut + 'sample.wav'

Return