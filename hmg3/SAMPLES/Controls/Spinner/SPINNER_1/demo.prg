/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_Main ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'Main Window' ;
		MAIN 

		@ 100,250 SPINNER Spinner_1 ;
		RANGE 0,10 ;
		VALUE 5 ;
		WIDTH 100 ;
		TOOLTIP 'Range 0,10' ; 
		ON CHANGE PlayBeep() 

		@ 150,250 SPINNER Spinner_2 ;
		RANGE 0,10 ;
		VALUE 15 ;
		WIDTH 100 ;
		TOOLTIP 'Range 0,10' 

		@ 10,10 BUTTON Button_1 ;
		CAPTION 'Set value' ;
		ACTION ( Form_Main.Spinner_1.Value := 1 , Form_Main.Spinner_2.Value := 2 ) 

		@ 50,10 BUTTON Button_2 ;
		CAPTION 'Get value' ;
		ACTION MsgInfo( Str ( Form_Main.Spinner_1.Value)  + Str ( Form_Main.Spinner_2.Value ) )


	END WINDOW

	CENTER WINDOW Form_Main

	ACTIVATE WINDOW Form_Main

Return Nil

