
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
				MENUITEM "Navigate" ACTION TestNavigate()
			END POPUP 			

		END MENU

		DEFINE ACTIVEX Test
			ROW 10
			COL 50
			WIDTH 700  
			HEIGHT 400  
			PROGID "shell.explorer.2"  
		END ACTIVEX

	END WINDOW

	Center Window Win1

	Activate Window Win1

RETURN NIL

*------------------------------------------------------------------------------*
Procedure TestNavigate()
*------------------------------------------------------------------------------*
Local oObject
Local cAddress := ''

	* Look at other samples for alternatives

	cAddress := InputBox ('Navigate:','Enter Address','http://www.hmgforum.com/')

	If .Not. Empty ( cAddress )

		oObject := Win1.Test.Object
		oObject:Navigate(cAddress)

	EndIf

Return


