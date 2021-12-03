#include "hmg.ch"

PROCEDURE Main()

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 334 ;
		HEIGHT 276 ;
		TITLE 'Create Desktop Shortcut' ;
		MAIN 
		
		
		DEFINE MAIN MENU

			DEFINE POPUP "Test"
				MENUITEM 'Create Desktop Shortcut' ACTION MakeFDirShortCut( 'c:\hmg.3.1.3', 'HMG 3.1.3', 'Go to HMG 3.1.3 base directory',)
				MENUITEM 'Create Internet Shortcut' ACTION MakeInternetShortCut( 'http://www.hmgforum.com', 'HMG Forum' )
		  	SEPARATOR
         ITEM 'Exit' ACTION Form_1.Release()
			END POPUP

		END MENU

	END WINDOW 

	Form_1.Center()
	Form_1.Activate()

RETURN
