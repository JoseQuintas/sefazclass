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
		TITLE "HMG Slider Demo" ;
		MAIN ;
		FONT "Arial" SIZE 10

      // Horizontal

      @ 20,20 SLIDER Slider_1 ;
      RANGE 1,10 ;
      VALUE 5 ;
      TOOLTIP "Slider Horizontal" ;
      ON CHANGE {||Slider1_Change()}

		@ 70,20 TEXTBOX TextBox_1 VALUE " 5" WIDTH 60 MAXLENGTH 5

      @ 20,160 SLIDER Slider_2 ;
      RANGE 1,10 ;
      VALUE 5 ;
      TOOLTIP "Slider Horizontal Top" ;
      ON CHANGE {||Slider2_Change()} ;
      TOP

		@ 70,160 TEXTBOX TextBox_2 VALUE " 5" WIDTH 60 MAXLENGTH 5

      @ 20,300 SLIDER Slider_3 ;
      RANGE 1,10 ;
      VALUE 5 ;
      TOOLTIP "Slider Horizontal Both" ;
      ON CHANGE {||Slider3_Change()} ;
      BOTH

		@ 70,300 TEXTBOX TextBox_3 VALUE " 5" WIDTH 60 MAXLENGTH 5

      @ 20,440 SLIDER Slider_4 ;
      RANGE 1,10 ;
      VALUE 5 ;
      TOOLTIP "Slider Horizontal NoTicks" ;
      ON CHANGE {||Slider4_Change()} ;
      NOTICKS

		@ 70,440 TEXTBOX TextBox_4 VALUE " 5" WIDTH 60 MAXLENGTH 5

      // Vertical

      @ 150,20 SLIDER Slider_5 ;
      RANGE 1,10 ;
      VALUE 5 ;
      TOOLTIP "Slider Vertical" ;
      VERTICAL ;
      ON CHANGE {||Slider5_Change()}

		@ 280,20 TEXTBOX TextBox_5 VALUE " 5" WIDTH 60 MAXLENGTH 5

      @ 150,160 SLIDER Slider_6 ;
      RANGE 1,10 ;
      VALUE 5 ;
      TOOLTIP "Slider Vertical Left" ;
      VERTICAL ;
      ON CHANGE {||Slider6_Change()} ;
      LEFT

		@ 280,160 TEXTBOX TextBox_6 VALUE " 5" WIDTH 60 MAXLENGTH 5

      @ 150,300 SLIDER Slider_7 ;
      RANGE 1,10 ;
      VALUE 5 ;
      TOOLTIP "Slider Vertical Both" ;
      VERTICAL ;
      ON CHANGE {||Slider7_Change()} ;
      BOTH

		@ 280,300 TEXTBOX TextBox_7 VALUE " 5" WIDTH 60 MAXLENGTH 5

      @ 150,440 SLIDER Slider_8 ;
      RANGE 1,10 ;
      VALUE 5 ;
      TOOLTIP "Slider Vertical NoTicks" ;
      VERTICAL ;
      ON CHANGE {||Slider8_Change()} ;
      NOTICKS

		@ 280,440 TEXTBOX TextBox_8 VALUE " 5" WIDTH 60 MAXLENGTH 5

	END WINDOW

	Form_1.TextBox_1.Enabled := .f.
	Form_1.TextBox_2.Enabled := .f.
	Form_1.TextBox_3.Enabled := .f.
	Form_1.TextBox_4.Enabled := .f.
	Form_1.TextBox_5.Enabled := .f.
	Form_1.TextBox_6.Enabled := .f.
	Form_1.TextBox_7.Enabled := .f.
	Form_1.TextBox_8.Enabled := .f.

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

Function Slider1_Change

   Local nValue := Form_1.Slider_1.Value

   Form_1.TextBox_1.Value := Str(nValue,2)

Return Nil

Function Slider2_Change

   Local nValue := Form_1.Slider_2.Value

   Form_1.TextBox_2.Value := Str(nValue,2)

Return Nil

Function Slider3_Change

   Local nValue := Form_1.Slider_3.Value

   Form_1.TextBox_3.Value := Str(nValue,2)

Return Nil

Function Slider4_Change

   Local nValue := Form_1.Slider_4.Value

   Form_1.TextBox_4.Value := Str(nValue,2)

Return Nil

Function Slider5_Change

   Local nValue := Form_1.Slider_5.Value

   Form_1.TextBox_5.Value := Str(nValue,2)

Return Nil

Function Slider6_Change

   Local nValue := Form_1.Slider_6.Value

   Form_1.TextBox_6.Value := Str(nValue,2)

Return Nil

Function Slider7_Change

   Local nValue := Form_1.Slider_7.Value

   Form_1.TextBox_7.Value := Str(nValue,2)

Return Nil

Function Slider8_Change

   Local nValue := Form_1.Slider_8.Value

   Form_1.TextBox_8.Value := Str(nValue,2)

Return Nil


