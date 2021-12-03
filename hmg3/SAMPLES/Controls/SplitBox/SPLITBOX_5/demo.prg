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

		DEFINE MAIN MENU 
			POPUP '&File'
				ITEM 'Get EditBox Value'	ACTION MsgInfo ( Form_1.SplitBox.Edit_1.Value ) 
				ITEM 'Get Grid Value'		ACTION MsgInfo ( Str ( Form_1.SplitBox.Grid_1.Value ) ) 
				ITEM 'Get List Value'		ACTION MsgInfo ( Str ( Form_1.SplitBox.List_1.Value ) ) 
				SEPARATOR	
				ITEM 'Set EditBox Value'	ACTION Form_1.SplitBox.Edit_1.Value := 'New Value'
				ITEM 'Set Grid Value'	ACTION Form_1.SplitBox.Grid_1.Value := 2
				ITEM 'Set List Value'	ACTION Form_1.SplitBox.List_1.Value := 5
				SEPARATOR	
				ITEM 'Disable EditBox'	ACTION Form_1.SplitBox.Edit_1.Enabled := .f.
				ITEM 'Disable Grid'	ACTION Form_1.SplitBox.Grid_1.Enabled := .f.
				ITEM 'Disable List'	ACTION Form_1.SplitBox.List_1.Enabled := .f.
				SEPARATOR	
				ITEM 'Enable EditBox'	ACTION Form_1.SplitBox.Edit_1.Enabled := .t.
				ITEM 'Enable Grid'	ACTION Form_1.SplitBox.Grid_1.Enabled := .t.
				ITEM 'Enable List'	ACTION Form_1.SplitBox.List_1.Enabled := .t.
				SEPARATOR	
				ITEM 'Exit'		ACTION Form_1.Release
			END POPUP
			POPUP '&Help'
				ITEM 'About'		ACTION MsgInfo ("HMG SplitBox Demo","A COOL Feature ;)") 
			END POPUP
		END MENU
	
		DEFINE SPLITBOX HORIZONTAL

			LISTBOX List_1 ;
			WIDTH 630 ;
			HEIGHT 100 ;
			ITEMS {'Item 1','Item 2','Item 3','Item 4','Item 5'} ;
			VALUE 3  ;
			TOOLTIP 'ListBox 1' 

			GRID Grid_1 ;
			WIDTH 630 ;
			HEIGHT 100 ;
			HEADERS {'Last Name','First Name'} ;
			WIDTHS {100,100};
			ITEMS { {'Simpson','Homer'} , {'Mulder','Fox'} } VALUE 1 ;
			TOOLTIP 'Grid Control'

			EDITBOX Edit_1 ;
			WIDTH 630 ;
			HEIGHT 100 ;
			VALUE 'EditBox!!' ;
			TOOLTIP 'EditBox' ;
			MAXLENGTH 255 

		END SPLITBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

