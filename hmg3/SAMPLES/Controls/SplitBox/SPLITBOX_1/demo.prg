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
		WIDTH 800 HEIGHT 600 ;
		TITLE 'HMG SplitBox Demo' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE STATUSBAR
			STATUSITEM 'HMG Power Ready - Click / Drag Grippers And Enjoy !' 
		END STATUSBAR

		DEFINE MAIN MENU 
			POPUP '&File'
				ITEM '&Disable ToolBar Button'		ACTION Form_1.SplitBox.ToolBar_1.Button_1.Enabled := .F.
				ITEM '&Enable ToolBar Button'		ACTION Form_1.SplitBox.ToolBar_1.Button_1.Enabled := .T.
				ITEM 'Get ToolBar Button Caption'	ACTION MsgInfo ( Form_1.SplitBox.ToolBar_1.Button_1.Caption )
				SEPARATOR
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
				ITEM 'Hide EditBox'	ACTION Form_1.SplitBox.Edit_1.Hide()
				ITEM 'Show EditBox'	ACTION Form_1.SplitBox.Edit_1.Show()
				SEPARATOR	
				ITEM 'Exit'		ACTION Form_1.Release
			END POPUP
			POPUP '&Help'
				ITEM 'About'		ACTION MsgInfo ("HMG SplitBox Demo","A COOL Feature ;)") 
			END POPUP
		END MENU
	
		DEFINE SPLITBOX 

			DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 85,85 FLAT

				BUTTON Button_1 CAPTION '&More ToolBars...' PICTURE 'button1.bmp' ACTION MsgInfo('Click! 1')  TOOLTIP 'ONE'

				BUTTON Button_2 CAPTION '&Button 2' PICTURE 'button2.bmp' ACTION MsgInfo('Click! 2')  TOOLTIP 'TWO'

				BUTTON Button_3 CAPTION 'Button &3' PICTURE 'button3.bmp' ACTION MsgInfo('Click! 3')  TOOLTIP 'THREE'

			END TOOLBAR

			LISTBOX List_1 ;
				WIDTH 200 ;
				HEIGHT 400 ;
				ITEMS {'Item 1','Item 2','Item 3','Item 4','Item 5'} ;
				VALUE 3  ;
				TOOLTIP 'ListBox 1' 

			GRID Grid_1 ;
				WIDTH 200 ;
				HEIGHT 400 ;
				HEADERS {'Last Name','First Name'} ;
				WIDTHS {100,100};
				ITEMS { {'Simpson','Homer'} , {'Mulder','Fox'} } VALUE 1 ;
				TOOLTIP 'Grid Control'

			EDITBOX Edit_1 ;
				WIDTH 200 ;
				HEIGHT 400 ;
				VALUE 'EditBox!!' ;
				TOOLTIP 'EditBox' ;
				MAXLENGTH 255 

		END SPLITBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

