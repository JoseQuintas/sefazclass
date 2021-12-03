
#include "hmg.ch"

Function Main

	SET DATE GERMAN

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 400 ;
		TITLE 'Statusbar Keyboard Demo' ;
		MAIN 


		DEFINE STATUSBAR FONT 'Arial' SIZE 9

			STATUSITEM "Statusbar Demo" 

			KEYBOARD

			DATE 

			CLOCK 

		END STATUSBAR
 
	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return


