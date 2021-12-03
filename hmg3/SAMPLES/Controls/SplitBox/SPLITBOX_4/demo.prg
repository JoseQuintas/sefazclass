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

			DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 95,30 FLAT RIGHTTEXT CAPTION 'ToolBar 1' 

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

			DEFINE TOOLBAR ToolBar_2 BUTTONSIZE 95,30 FLAT RIGHTTEXT  CAPTION 'ToolBar 2'

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
				WIDTH 300 
				HEIGHT 200
				HEADERS {'Last Name','First Name'} 
				WIDTHS {180,180}
				ITEMS { {'Simpson','Homer'} , {'Mulder','Fox'} } 
				VALUE 1 
				TOOLTIP 'Grid Control'
                        END GRID

			DEFINE WINDOW SplitChild_1 ; 
				WIDTH 200 ;
				HEIGHT 200 ;
				VIRTUAL WIDTH 400 ;
				VIRTUAL HEIGHT 400 ;
				SPLITCHILD NOCAPTION ;

				DEFINE LABEL Label_1
					ROW	55
					COL	30
					VALUE 'Label !!!' 
					WIDTH 100 
					HEIGHT 27 
				END LABEL

				DEFINE CHECKBOX Check_1
					ROW	80
					COL	30
					CAPTION 'Check 1' 
					VALUE .T. 
					TOOLTIP 'CheckBox' 
				END CHECKBOX
			
				DEFINE SLIDER Slider_1
					ROW 115
					COL 30
					RANGEMIN 1
					RANGEMAX 10 
					VALUE 5 
					TOOLTIP 'Slider' 
				END SLIDER
				
				DEFINE FRAME Frame_1
					ROW	45
					COL	170
					WIDTH 85
					HEIGHT 110
				END FRAME

				DEFINE RADIOGROUP Radio_1
					ROW	50
					COL	180
					OPTIONS { 'One' , 'Two' , 'Three', 'Four' } 
					VALUE 1 
					WIDTH 70 
					TOOLTIP 'RadioGroup' 
				END RADIOGROUP

			END WINDOW 

			DEFINE LISTBOX List_1
				WIDTH 200 
				HEIGHT 100 
				ITEMS {'Item 1','Item 2','Item 3','Item 4','Item 5'} 
				VALUE 3  
				TOOLTIP 'ListBox 1' 
				BREAK .T.
				MULTISELECT .F.
                       END LISTBOX

			DEFINE EDITBOX Edit_1
				WIDTH 200 
				HEIGHT 100
				VALUE 'EditBox!!' 
				TOOLTIP 'EditBox' 
				MAXLENGTH 255 
                        END EDITBOX

		END SPLITBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

