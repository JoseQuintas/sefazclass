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
		MAIN ;
		FONT "Arial" SIZE 10 

      @ 000,031 PROGRESSBAR Progress_1 ;
		RANGE 0 , 100 		;
		WIDTH 300 			;
		HEIGHT 26 			;
		TOOLTIP "ProgressBar Horizontal"

      
      @ 274,031 PROGRESSBAR Progress_2 ;
		RANGE 0 , 100 		;
		WIDTH 300 			;
		HEIGHT 26 			;
		TOOLTIP "ProgressBar Horizontal Smooth" ;
		SMOOTH

      @ 000,000 PROGRESSBAR Progress_3 ;
		RANGE 0 , 100 		;
		WIDTH 30 			;
		HEIGHT 300 			;
		TOOLTIP "ProgressBar Vertical" ;
		VERTICAL

      @ 000,332 PROGRESSBAR Progress_4 ;
		RANGE 0 , 100 		;
		WIDTH 30 			;
		HEIGHT 300 			;
		TOOLTIP "ProgressBar Vertical Smooth" ;
		VERTICAL ;
	   SMOOTH

      @ 50 , 100 BUTTON Button_1 CAPTION "MARQUEE On/Off" WIDTH 150 HEIGHT 35 ACTION  SetMarquee() 

		@ 120,155 TEXTBOX TextBox_1 ;
		VALUE " 50 %" ;
		WIDTH 60 ;
		MAXLENGTH 5

      @ 150,80 SLIDER Slider_1 ;
      RANGE 0 , 100 ;
      VALUE 50 ;
      WIDTH 200 ;
      HEIGHT 50 ;
      ON CHANGE {||Slider_Change()}

	END WINDOW

	Form_1.Progress_1.Value := 50
	Form_1.Progress_2.Value := 50
	Form_1.Progress_3.Value := 50
	Form_1.Progress_4.Value := 50
	
	Form_1.TextBox_1.Enabled := .f.

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

Function Slider_Change

	Local nValue := Form_1.Slider_1.Value

	Form_1.TextBox_1.Value := Str(nValue,3)+" %"

	Form_1.Progress_1.Value := nValue
	Form_1.Progress_2.Value := nValue
	Form_1.Progress_3.Value := nValue
	Form_1.Progress_4.Value := nValue

Return Nil


Procedure SetMarquee
STATIC Flag := .F.
   IF Flag == .F.
      Flag := .T.
      // Use this command when you do not know the amount of progress toward completion but wish to indicate that progress is being made.
      SET PROGRESSBAR Progress_1 OF Form_1 ENABLE MARQUEE 
      SET PROGRESSBAR Progress_2 OF Form_1 ENABLE MARQUEE UPDATED 10
      SET PROGRESSBAR Progress_3 OF Form_1 ENABLE MARQUEE UPDATED 10
      SET PROGRESSBAR Progress_4 OF Form_1 ENABLE MARQUEE UPDATED 50
   ELSE
      Flag := .F.
      SET PROGRESSBAR Progress_1 OF Form_1 DISABLE MARQUEE
      SET PROGRESSBAR Progress_2 OF Form_1 DISABLE MARQUEE
      SET PROGRESSBAR Progress_3 OF Form_1 DISABLE MARQUEE
      SET PROGRESSBAR Progress_4 OF Form_1 DISABLE MARQUEE
      Slider_Change ()
   ENDIF
Return
