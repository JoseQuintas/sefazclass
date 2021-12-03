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
				ITEM '&About' ACTION MsgInfo ("HMG SplitBox Demo") 
			END POPUP
		END MENU

		DEFINE SPLITBOX 

			DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 100,30 FLAT RIGHTTEXT 
			
				BUTTON Button_1;
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

			DEFINE TOOLBAR ToolBar_2 BUTTONSIZE 100,30 FLAT RIGHTTEXT 

				BUTTON Button_4 ;
				CAPTION 'S&earch' ;
				PICTURE 'button7.bmp' ;
				ACTION MsgInfo('Search Click!') 

				BUTTON Button_5 ;
				CAPTION '&View' ;
				PICTURE 'button8.bmp' ;
				ACTION MsgInfo('View Click!') 
	
				BUTTON Button_6 ;
				CAPTION '&Help' ;
				PICTURE 'button9.bmp' ;
				ACTION MsgInfo('Help Click!') 

				BUTTON Button_7 ;
				CAPTION 'Ed&it' ;
				PICTURE 'button10.bmp' ;
				ACTION MsgInfo('Edit Click!') 

				BUTTON Button_8 ;
				CAPTION 'Sort &Asc' ;
				PICTURE 'button11.bmp' ;
				ACTION MsgInfo('Ascending Click!') 
	
				BUTTON Button_9 ;
				CAPTION 'Sort &Desc' ;
				PICTURE 'button12.bmp' ;
				ACTION MsgInfo('Descending Click!') 

			END TOOLBAR

			DEFINE GRID Grid_1 
				WIDTH 200 
				HEIGHT 295 
				HEADERS {'Last Name','First Name'} 
				WIDTHS {330,330}
				ITEMS { {'Simpson','Homer'} , {'Mulder','Fox'} } 
				VALUE 1 
				TOOLTIP 'Grid Control' 
                        END GRID

		END SPLITBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

