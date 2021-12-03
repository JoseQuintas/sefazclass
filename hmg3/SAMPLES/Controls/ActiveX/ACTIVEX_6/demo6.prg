
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

		DEFINE LABEL label_1
			ROW		 5
			COL		250
			VALUE		"OSCAR THE BOXER"  
			FONTNAME	"Courier New"
			FONTSIZE	20
			WIDTH		300
			HEIGHT		30
		END LABEL

		DEFINE ACTIVEX Test
			ROW 		40
			COL 		50
			WIDTH 		700  
			HEIGHT 		380  
			PROGID 		"ShockwaveFlash.ShockwaveFlash.9"  
		END ACTIVEX

	END WINDOW

	Center Window Win1

	Activate Window Win1

RETURN NIL

Procedure Test()

	Win1.Test.Object:Movie := "http://www.youtube.com/v/58CZcCvwND4&hl=en&fs=1"

Return