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
		WIDTH 600 HEIGHT 400 ;
		TITLE "HMG DatePicker Demo" ;
		MAIN ;
		FONT "Arial" SIZE 10

		@ 10,10 DATEPICKER Date_1 ; 
      VALUE CTOD("01/01/2001") ;
		TOOLTIP "DatePicker Control" format " "

		@ 10,310 DATEPICKER Date_2 ;
		VALUE CTOD("01/01/2001") ;
		TOOLTIP "DatePicker Control ShowNone RightAlign" ;
		SHOWNONE ;
		RIGHTALIGN

		@ 230,10 DATEPICKER Date_3 ;
		VALUE CTOD("01/01/2001") ;
		TOOLTIP "DatePicker Control UpDown" ;
		UPDOWN

		@ 230,310 DATEPICKER Date_4 ;
		VALUE CTOD("01/01/2001") ;
		TOOLTIP "DatePicker Control ShowNone UpDown" ;
		SHOWNONE ;
		UPDOWN

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

