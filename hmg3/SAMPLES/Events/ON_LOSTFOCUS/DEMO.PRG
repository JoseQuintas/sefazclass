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
			NUMERIC ;
			ON LOSTFOCUS if ( This.Value < 10 , ( PlayAsterisk() , This.SetFocus ) , Nil ) 

		@ 40,10 TEXTBOX Text_2 ;
			VALUE 1 ;
			NUMERIC ;
			ON LOSTFOCUS if ( This.Value > 1000 , ( PlayAsterisk() , This.SetFocus ) , Nil )

	END WINDOW

	Form_1.Center

	Form_1.Activate

Return Nil

