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
		TITLE 'HMG ToolBar Demo' ;
		ICON 'DEMO.ICO' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE STATUSBAR
			STATUSITEM 'HMG Power Ready!' 
		END STATUSBAR

		DEFINE MAIN MENU 
			POPUP '&File'
				ITEM 'Get ToolBar_3 Button_1'	    ACTION MsgInfo ( if ( Form_1.Button_1c.Value , '.T.' , '.F.' ) , 'Button_1c' )
				ITEM 'Get ToolBar_3 Button_2'	    ACTION MsgInfo ( if ( Form_1.Button_2c.Value , '.T.' , '.F.' ) , 'Button_2c' )
				ITEM 'Get ToolBar_3 Button_3'	    ACTION MsgInfo ( if ( Form_1.Button_3c.Value , '.T.' , '.F.' ) , 'Button_3c' )
				ITEM 'Get ToolBar_3 Button_4'	    ACTION MsgInfo ( if ( Form_1.Button_4c.Value , '.T.' , '.F.' ) , 'Button_4c' )
	    			SEPARATOR	
				ITEM 'Set ToolBar_3 Button_1'	    ACTION Form_1.Button_1c.Value := .T. 
				ITEM 'Set ToolBar_3 Button_2'	    ACTION Form_1.Button_2c.Value := .T. 
				ITEM 'Set ToolBar_3 Button_3'	    ACTION Form_1.Button_3c.Value := .T. 
				ITEM 'Set ToolBar_3 Button_4'	    ACTION Form_1.Button_4c.Value := .T. 
			    	SEPARATOR	
				ITEM '&Exit'			ACTION Form_1.Release
			END POPUP
			POPUP '&Help'
				ITEM '&About'		ACTION MsgInfo ("HMG ToolBar demo") 
			END POPUP
		END MENU

		DEFINE SPLITBOX 

			DEFINE TOOLBAR ToolBar_a BUTTONSIZE 45,40 IMAGESIZE 22,22 FONT 'Arial' SIZE 8  FLAT

				BUTTON Button_1a ;
					CAPTION 'Undo' ;
					PICTURE 'button4.bmp' ;
					ACTION MsgInfo('Click! 1')

				BUTTON Button_2a ;
					CAPTION 'Save' ;
					PICTURE 'button5.bmp' ;
					WHOLEDROPDOWN 

					DEFINE DROPDOWN MENU BUTTON Button_2a 
						ITEM 'Exit'	ACTION Form_1.Release
						ITEM 'About'	ACTION MsgInfo ("HMG ToolBar Demo") 
					END MENU

				BUTTON Button_3a ;
					CAPTION 'Close' ;
					PICTURE 'button6.bmp' ;
					ACTION MsgInfo('Click! 3') ;
					DROPDOWN

					DEFINE DROPDOWN MENU BUTTON Button_3a 
						ITEM 'Disable ToolBar 1 Button 1'	ACTION Form_1.Button_1a.Enabled := .F.
						ITEM 'Enable ToolBar 1 Button 1'	ACTION Form_1.Button_1a.Enabled := .T.
					END MENU

			END TOOLBAR

			DEFINE TOOLBAR ToolBar_b BUTTONSIZE 45,40 IMAGESIZE 24,23 FONT 'ARIAL' SIZE 8 FLAT 

				BUTTON Button_1b ;
					CAPTION 'More ToolBars...' ;
					PICTURE 'button7.bmp' ;
					ACTION MsgInfo('Click! 2'); 

				BUTTON Button_2b ;
					CAPTION 'Button 2' ;
					PICTURE 'button7.bmp' ;
					ACTION MsgInfo('Click! 2'); 
					SEPARATOR

				BUTTON Button_3b ;
					CAPTION 'Button 3' ;
					PICTURE 'button7.bmp' ;
					ACTION MsgInfo('Click! 3')

			END TOOLBAR

			DEFINE TOOLBAR ToolBar_c BUTTONSIZE 45,40 IMAGESIZE 22,22 FONT 'Arial' SIZE 8 CAPTION 'ToolBar 3' FLAT

				BUTTON Button_1c ;
					CAPTION 'Check 1' ;
					PICTURE 'button4.bmp' ;
					ACTION MsgInfo('Hey!');
					CHECK GROUP

				BUTTON Button_2c ;
					CAPTION 'Check 2' ;
					PICTURE 'button5.bmp' ;
					ACTION MsgInfo('Hey!') ; 
					CHECK GROUP

				BUTTON Button_3c ;
					CAPTION 'Check 3' ;
					PICTURE 'button6.bmp' ;
					ACTION MsgInfo('Hey!') ;
					SEPARATOR;
					CHECK GROUP

				BUTTON Button_4c ;
					CAPTION 'Help Check' ;
					PICTURE 'button9.bmp' ;
					ACTION MsgInfo('Hey!') ;
					CHECK 

			END TOOLBAR

		END SPLITBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil


