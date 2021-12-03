/*
* HMG On InteractiveClose Demo
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN ;
		ON INTERACTIVECLOSE MsgYesNo ('Are You Sure ?')

	END WINDOW

	ACTIVATE WINDOW Win_1

Return

