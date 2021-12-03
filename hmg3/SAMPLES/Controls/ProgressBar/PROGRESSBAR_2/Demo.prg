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
		WIDTH 365 HEIGHT 350 ;
		TITLE "HMG ProgressBar Demo" ;
		MAIN

		@ 70,31 PROGRESSBAR Progress_1 ;
			RANGE 0,100 ;
			WIDTH 300 HEIGHT 26 ;
			TOOLTIP "ProgressBar"

		@ 120,155 TEXTBOX TextBox_1 ;
			VALUE " 50 %" WIDTH 60 MAXLENGTH 5

		@ 150,80 SLIDER Slider_1 ;
			RANGE 0,100 VALUE 50 ;
			WIDTH 200 HEIGHT 50 ;
			ON CHANGE {||Slider_Change()}

	END WINDOW

	Form_1.Progress_1.Value := 50

	Form_1.Progress_1.BackColor := RED
	Form_1.Progress_1.ForeColor := YELLOW

	Form_1.TextBox_1.Enabled := .f.

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

Function Slider_Change

	Local nValue := Form_1.Slider_1.Value

	Form_1.TextBox_1.Value := Str(nValue,3)+" %"

	Form_1.Progress_1.Value := nValue

Return Nil

