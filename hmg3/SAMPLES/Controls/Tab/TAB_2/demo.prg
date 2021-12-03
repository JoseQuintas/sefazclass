/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2008 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main
Local aRows [20] [3]

	aRows [1]	:= {'Simpson','Homer','555-5555'}
	aRows [2]	:= {'Mulder','Fox','324-6432'} 
	aRows [3]	:= {'Smart','Max','432-5892'} 
	aRows [4]	:= {'Grillo','Pepe','894-2332'} 
	aRows [5]	:= {'Kirk','James','346-9873'} 

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'HMG Demo' ;
		MAIN 

		DEFINE MAIN MENU
			DEFINE POPUP 'Test'
				MENUITEM 'Get Button Caption' ACTION MsgInfo ( Form_1.Tab_1(1).Button_1.Caption ) 
				MENUITEM 'Set Button Caption' ACTION Form_1.Tab_1(1).Button_1.Caption := 'New'
				SEPARATOR
				MENUITEM 'Get Grid Header' ACTION MsgInfo ( Form_1.Tab_1(4).Grid_1.Header(1) ) 
				MENUITEM 'Set Grid Header' ACTION Form_1.Tab_1(4).Grid_1.Header(1) := 'New'
				SEPARATOR
				MENUITEM 'Set Grid Cell' ACTION Form_1.Tab_1(4).Grid_1.Cell(1,1) := 'New'
				MENUITEM 'Get Grid Cell' ACTION MsgInfo ( Form_1.Tab_1(4).Grid_1.Cell(1,1) )
				SEPARATOR
				MENUITEM 'Show Button' ACTION Form_1.Tab_1(1).Button_1.Show()
				MENUITEM 'Hide Button' ACTION Form_1.Tab_1(1).Button_1.Hide()
			END POPUP
		END MENU

		DEFINE TAB Tab_1 ;
			AT 10,10 ;
			WIDTH 600 ;
			HEIGHT 400 ;
			VALUE 1 ;
			TOOLTIP 'Tab Control' 

			PAGE 'Page 1' IMAGE "exit.bmp"

			      @ 100,250 BUTTON Button_1 CAPTION "Test" WIDTH 50 HEIGHT 50 ACTION MsgInfo('Test!')

			END PAGE

			PAGE 'Page &2' IMAGE "info.bmp"

				DEFINE RADIOGROUP R1
					ROW	100
					COL	100
					OPTIONS	{ '1','2','3' }
					VALUE	1
				END RADIOGROUP

			END PAGE

			PAGE 'Page 3' IMAGE "check.bmp"

				@ 100,250 SPINNER Spinner_1 ;
				RANGE 0,10 ;
				VALUE 5 ;
				WIDTH 100 ;
				TOOLTIP 'Range 0,10' ; 
				ON CHANGE PlayBeep() 

			END PAGE

			PAGE 'Page 4' IMAGE "button.bmp"

				@ 50,50 GRID Grid_1 ;
					WIDTH 200 ;
					HEIGHT 330 ;
					HEADERS {'Last Name','First Name','Phone'} ;
					WIDTHS {140,140,140};
					ITEMS aRows ;
					VALUE 1 

			END PAGE

		END TAB

	END WINDOW

	Form_1.Center

	Form_1.Activate

Return Nil

