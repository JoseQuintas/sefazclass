/*
 * HMG - Harbour Win32 GUI library
 * Copyright 2002-2008 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main()

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 345 ;
		HEIGHT 450 ;
		MAIN;
		TITLE 'Button Test' ;
		NOSIZE ;
		NOMAXIMIZE

		DEFINE MAIN MENU
			POPUP 'Enabled Property Test'
				ITEM 'Disable Button 1' ACTION Form_1.Button_1.Enabled := .f.
				ITEM 'Enable Button 1'  ACTION Form_1.Button_1.Enabled := .t.
				SEPARATOR
				ITEM 'Disable Button 2' ACTION Form_1.Button_2.Enabled := .f.
				ITEM 'Enable Button 2'  ACTION Form_1.Button_2.Enabled := .t.
				SEPARATOR
				ITEM 'Disable Button 3' ACTION Form_1.Button_3.Enabled := .f.
				ITEM 'Enable Button 3'  ACTION Form_1.Button_3.Enabled := .t.
				SEPARATOR
				ITEM 'Disable Button 4' ACTION Form_1.Button_4.Enabled := .f.
				ITEM 'Enable Button 4'  ACTION Form_1.Button_4.Enabled := .t.
				SEPARATOR
				ITEM 'Disable Button 5' ACTION Form_1.Button_5.Enabled := .f.
				ITEM 'Enable Button 5'  ACTION Form_1.Button_5.Enabled := .t.
				SEPARATOR
				ITEM 'Disable Button 6' ACTION Form_1.Button_6.Enabled := .f.
				ITEM 'Enable Button 6'  ACTION Form_1.Button_6.Enabled := .t.
				SEPARATOR
				ITEM 'Disable Button 7' ACTION Form_1.Button_7.Enabled := .f.
				ITEM 'Enable Button 7'  ACTION Form_1.Button_7.Enabled := .t.
				SEPARATOR
				ITEM 'Disable Button 8' ACTION Form_1.Button_8.Enabled := .f.
				ITEM 'Enable Button 8'  ACTION Form_1.Button_8.Enabled := .t.
			END POPUP
			POPUP 'Picture Property Test'
				ITEM 'Set Button 1 Picture' ACTION Form_1.Button_1.Picture := 'button5.bmp'
				ITEM 'Get Button 1 Picture' ACTION MsgInfo( Form_1.Button_1.Picture )
				SEPARATOR
				ITEM 'Set Button 2 Picture' ACTION Form_1.Button_2.Picture := 'button5.bmp'
				ITEM 'Get Button 2 Picture' ACTION MsgInfo( Form_1.Button_2.Picture )
				SEPARATOR
				ITEM 'Set Button 3 Picture' ACTION Form_1.Button_3.Picture := 'button5.bmp'
				ITEM 'Get Button 3 Picture' ACTION MsgInfo( Form_1.Button_3.Picture )
				SEPARATOR
				ITEM 'Set Button 4 Picture' ACTION Form_1.Button_4.Picture := 'button5.bmp'
				ITEM 'Get Button 4 Picture' ACTION MsgInfo( Form_1.Button_4.Picture )
				SEPARATOR
				ITEM 'Set Button 5 Picture' ACTION Form_1.Button_5.Picture := 'button5.bmp'
				ITEM 'Get Button 5 Picture' ACTION MsgInfo( Form_1.Button_5.Picture )
				SEPARATOR
				ITEM 'Set Button 6 Picture' ACTION Form_1.Button_6.Picture := 'button5.bmp'
				ITEM 'Get Button 6 Picture' ACTION MsgInfo( Form_1.Button_6.Picture )
				SEPARATOR
				ITEM 'Set Button 7 Picture' ACTION Form_1.Button_7.Picture := 'button5.bmp'
				ITEM 'Get Button 7 Picture' ACTION MsgInfo( Form_1.Button_7.Picture )
				SEPARATOR
				ITEM 'Set Button 8 Picture' ACTION Form_1.Button_8.Picture := 'button5.bmp'
				ITEM 'Get Button 8 Picture' ACTION MsgInfo( Form_1.Button_8.Picture )
			END POPUP

		END MENU

	@ 10,10 BUTTON BUTTON_1 ;
			CAPTION "Please... Click Me!" ;
			PICTURE "button.bmp" ;
			ACTION MsgInfo('Thanks!') ;
			LEFT ;
			WIDTH 120 ;
			HEIGHT 60 MULTILINE

	@ 110,10 BUTTON BUTTON_2 ;
			CAPTION "Click Me!" ;
			PICTURE "button.bmp" ;
			ACTION MsgInfo('Thanks!') ;
			RIGHT ;
			WIDTH 120 ;
			HEIGHT 60

	@ 210,10 BUTTON BUTTON_3 ;
			CAPTION "Click Me!" ;
			PICTURE "button.bmp" ;
			ACTION MsgInfo('Thanks!') ;
			TOP ;
			WIDTH 120 ;
			HEIGHT 60

	@ 310,10 BUTTON BUTTON_4 ;
			CAPTION "Click Me!" ;
			PICTURE "button.bmp" ;
			ACTION MsgInfo('Thanks!') ;
			BOTTOM ;
			WIDTH 120 ;
			HEIGHT 60

	DEFINE BUTTON BUTTON_5		
		ROW			10
		COL			200
		CAPTION			"Please... Click This!"
		ACTION			MsgInfo('Thanks!')
		PICTURE			"button.BMP"
		WIDTH			120
		HEIGHT			60
		PICTALIGNMENT		LEFT
		MULTILINE		.T.
	END BUTTON

	DEFINE BUTTON BUTTON_6		
		ROW			110
		COL			200
		CAPTION			"Click This!"
		ACTION			MsgInfo('Thanks!')
		PICTURE			"button.BMP"
		WIDTH			120
		HEIGHT			60
		PICTALIGNMENT	RIGHT
	END BUTTON

	DEFINE BUTTON BUTTON_7
		ROW			210
		COL			200
		CAPTION			"Click This!"
		ACTION			MsgInfo('Thanks!')
		PICTURE			"button.BMP"
		WIDTH			120
		HEIGHT			60
		PICTALIGNMENT	TOP
	END BUTTON

	DEFINE BUTTON BUTTON_8
		ROW			310
		COL			200
		CAPTION			"Click This!"
		ACTION			MsgInfo('Thanks!')
		PICTURE			"button.BMP"
		WIDTH			120
		HEIGHT			60
		PICTALIGNMENT	BOTTOM
	END BUTTON

   END WINDOW

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return



