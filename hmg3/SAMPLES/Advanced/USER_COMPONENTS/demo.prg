/*
* HMG User Components Demo
* (c) 2006 Roberto Lopez
*/

#include "hmg.ch"

Set Procedure To MyButton.Prg

Function Main

	DEFINE WINDOW Win1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		TITLE 'Custom Component Demo' ;
		MAIN 

		DEFINE MAIN MENU
			DEFINE POPUP 'Test'
				MENUITEM 'Custom Method: SetFocus' ACTION Win1.Test.SetFocus
				MENUITEM 'Custom Method: Disable' ACTION Win1.Test.Disable
				MENUITEM 'Custom Method: Enable' ACTION Win1.Test.Enable
				MENUITEM 'Custom Property: Handle (Get)' ACTION MsgInfo ( Str ( Win1.Test.Handle ) )
				MENUITEM 'Custom Property: Handle (Set)' ACTION Win1.Test.Handle := 1
				MENUITEM 'Custom Property: Caption (Get)' ACTION MsgInfo ( Win1.Test.Caption )
				MENUITEM 'Custom Property: Caption (Set)' ACTION Win1.Test.Caption := 'New Caption'
			END POPUP
		END MENU

		@ 10 , 10 MYBUTTON test ;
			OF Win1 ;
			CAPTION 'Custom Button' ;
			ACTION MsgInfo('Click!') 

	END WINDOW

	CENTER WINDOW Win1

	ACTIVATE WINDOW Win1

Return

