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

		@ 200,250 LABEL Label_1 ;
		WIDTH 150 HEIGHT 40 ;
		VALUE 'Click Me !' ;
		ACTION MsgInfo('Label Clicked!!!') ;
		FONT 'Arial' SIZE 24  CENTERALIGN

		@ 10,10 LABEL Label_2 ;
		AUTOSIZE ;
		VALUE '...' ;
		ACTION msginfo('test')

	END WINDOW

	Form_Main.Label_2.Value := 'Hello All, This Is An AutoSIzable Label!!!'

	CENTER WINDOW Form_Main

	ACTIVATE WINDOW Form_Main

Return 

