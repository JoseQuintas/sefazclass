/*
* HMG Hello World Demo
*/

#include "hmg.ch"

Function Main
Local nTask

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN 

		DEFINE MAIN MENU
			POPUP 'Common &Dialog Functions'
				ITEM 'PutFile()'	ACTION MsgInfo ( Putfile ( { {'jpg Files','*.jpg'} , {'gif Files','*.gif'} } , 'Save Image' , 'C:\' ) )
			END POPUP
		END MENU

	END WINDOW

	ACTIVATE WINDOW Win_1

Return

