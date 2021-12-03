/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-2008 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'HMG Demo' ;
		ICON 'DEMO.ICO' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE MAIN MENU 
			POPUP 'M&isc'
				ITEM 'Set RadioGroup Caption Property'	ACTION Form_1.Radio_1.Caption(1) := 'New Caption'
				ITEM 'Get RadioGroup Caption Property'	ACTION MsgInfo ( Form_1.Radio_1.Caption (1) ,'Radio_1')
				ITEM 'Set RadioGroup Value Property'	ACTION Form_1.Radio_1.Value := Val(InputBox('Radio Value',''))
				ITEM 'Get RadioGroup Value Property'	ACTION MsgInfo ( Str(Form_1.Radio_1.Value) ,'Radio_1')
				ITEM 'Set RadioGroup Row Property'	ACTION Form_1.Radio_1.Row := Val(InputBox('Enter Row',''))
				ITEM 'Set RadioGroup Col Property'	ACTION Form_1.Radio_1.Col := Val(InputBox('Enter Col',''))
			END POPUP
		END MENU


		@ 10,10 RADIOGROUP Radio_1 ;
			OPTIONS { 'One' , 'Two' , 'Three', 'Four' } ;
			VALUE 1 ;
			WIDTH 100 ;
			TOOLTIP 'RadioGroup' 

		@ 10,150 RADIOGROUP Radio_2 ;
			OPTIONS { 'One' , 'Two' , 'Three', 'Four' } ;
			VALUE 1 ;
			WIDTH 100 ;
			TOOLTIP 'RadioGroup' 

		@ 150,10 DATEPICKER Date_1 ;
		VALUE CTOD('  / /  ') ;
		TOOLTIP 'DatePicker Control' 

	END WINDOW

	Form_1.date_1.SetFocus

	Form_1.Center

	Form_1.Activate

Return Nil

