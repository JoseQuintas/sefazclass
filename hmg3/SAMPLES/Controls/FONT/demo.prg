/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

#define EOF Chr(13)+Chr(10)

Function Main

   DEFINE WINDOW Form_1 ;
      AT 0,0 WIDTH 240 HEIGHT 480 ;
      TITLE "Demo" ;
      ICON "DEMO.ICO" ;
      MAIN

   @ 10,10 BUTTON Control_1 ;
      CAPTION "HMG" ;
      ACTION {||nil} ;
      FONT "ARIAL" SIZE 24 ;
      WIDTH 200 HEIGHT 80

   @ 100, 10 BUTTON Button_1 ;
      CAPTION "Get Values" ;
      ACTION GetValues()

   @ 150, 10 BUTTON Button_2 ;
      CAPTION "Arial" ;
      ACTION Form_1.Control_1.FontName := "Arial"

   @ 150,110 BUTTON Button_3 ;
      CAPTION "Courier New" ;
      ACTION Form_1.Control_1.FontName := "Courier New"

   @ 200, 10 BUTTON Button_4 ;
      CAPTION "Size 24" ;
      ACTION Form_1.Control_1.FontSize := 24

   @ 200,110 BUTTON Button_5 ;
      CAPTION "Size 36" ;
      ACTION Form_1.Control_1.FontSize := 36

   @ 250, 10 BUTTON Button_6 ;
      CAPTION "Bold ON" ;
      ACTION Form_1.Control_1.FontBold := .t.

   @ 250,110 BUTTON Button_7 ;
      CAPTION "Bold OFF" ;
      ACTION Form_1.Control_1.FontBold := .f.

   @ 300, 10 BUTTON Button_8 ;
      CAPTION "Italic ON" ;
      ACTION Form_1.Control_1.FontItalic := .t.

   @ 300,110 BUTTON Button_9 ;
      CAPTION "Italic OFF" ;
      ACTION Form_1.Control_1.FontItalic := .f.

   @ 350, 10 BUTTON Button_10 ;
      CAPTION "Underline ON" ;
      ACTION Form_1.Control_1.FontUnderline := .t.

   @ 350,110 BUTTON Button_11 ;
      CAPTION "Underline OFF" ;
      ACTION Form_1.Control_1.FontUnderline := .f.

   @ 400, 10 BUTTON Button_12 ;
      CAPTION "Strikeout ON" ;
      ACTION Form_1.Control_1.FontStrikeout := .t.

   @ 400,110 BUTTON Button_13 ;
      CAPTION "Strikeout OFF" ;
      ACTION Form_1.Control_1.FontStrikeout := .f.

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

Function GetValues

Local m := ""

   m += "Name: "      + Form_1.Control_1.FontName + EOF
   m += "Size: "      + StrZero(Form_1.Control_1.FontSize,2)+EOF
   m += "Bold: "      + if(Form_1.Control_1.FontBold,"True","False")+EOF
   m += "Italic: "    + if(Form_1.Control_1.FontItalic,"True","False")+EOF
   m += "Underline: " + if(Form_1.Control_1.FontUnderline,"True","False")+EOF
   m += "Strikeout: " + if(Form_1.Control_1.FontStrikeout,"True","False")+EOF
   MsgInfo(m)

Return Nil

