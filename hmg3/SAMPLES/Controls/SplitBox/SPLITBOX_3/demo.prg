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
		TITLE 'HMG SplitBox Demo' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE STATUSBAR
			STATUSITEM 'HMG Power Ready - Click / Drag Grippers And Enjoy !' 
		END STATUSBAR

		DEFINE MAIN MENU 
			POPUP '&Help'
				ITEM 'About'		ACTION MsgInfo ("HMG SplitBox Demo","A COOL Feature ;)") 
			END POPUP
		END MENU
	
		DEFINE SPLITBOX 

			DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 90,25 FLAT RIGHTTEXT 

				BUTTON Button_1 ;
				CAPTION '&Undo' ;
				PICTURE 'button4.bmp' ;
				ACTION MsgInfo('UnDo Click!') 

				BUTTON Button_2 ;
				CAPTION '&Save' ;
				PICTURE 'button5.bmp' ;
				ACTION MsgInfo('Save Click!') 
	
				BUTTON Button_3 ;
				CAPTION '&Close' ;
				PICTURE 'button6.bmp' ;
				ACTION MsgInfo('Close Click!') 

				BUTTON Button_10 ;
				CAPTION '&Login' ;
				PICTURE 'button14.bmp' ;
				ACTION MsgInfo('Login Click!') 

			END TOOLBAR

			DEFINE LISTBOX List_1
				WIDTH 200 
				HEIGHT 300 
				ITEMS {'Item 1','Item 2','Item 3','Item 4','Item 5'} 
				VALUE 3  
				TOOLTIP 'ListBox 1' 
                        END LISTBOX

			DEFINE GRID Grid_1
				WIDTH 200 
				HEIGHT 300 
				HEADERS {'Last Name','First Name'} 
				WIDTHS {100,100}
				ITEMS { {'Simpson','Homer'} , {'Mulder','Fox'} } 
				VALUE 1 
				TOOLTIP 'Grid Control'
                        END GRID

			DEFINE EDITBOX Edit_1
				WIDTH 200 
				HEIGHT 300 
				VALUE 'EditBox!!' 
				TOOLTIP 'EditBox' 
				MAXLENGTH 255 
                        END EDITBOX

			DEFINE LISTBOX List_2
				WIDTH 200
				HEIGHT 50
				ITEMS {'Item 1','Item 2','Item 3','Item 4','Item 5'} 
				VALUE 1  
				TOOLTIP 'ListBox 1' 
				BREAK .T.
                        END LISTBOX

		END SPLITBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

