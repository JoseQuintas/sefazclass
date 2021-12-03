/*
*
* HMG DLL Demo
*
*/

#include "hmg.ch"

Function Main

	Local Buffer := Space (128)

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN 
	
		DEFINE MAIN MENU
			DEFINE POPUP 'Test'
				MENUITEM 'Test' ACTION ( ;
					CallDll32 ( "GetWindowText" , "USER32.DLL" , GetFormHandle ('Win_1') , @Buffer , 128 ) , ;
					MsgInfo (Buffer) ;
							)
			END POPUP
		END MENU

	END WINDOW

	ACTIVATE WINDOW Win_1

Return

