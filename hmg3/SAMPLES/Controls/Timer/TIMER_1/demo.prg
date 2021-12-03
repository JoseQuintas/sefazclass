
#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Timer Test' ;
		MAIN 

		@ 10,10 LABEL Label_1 

		DEFINE TIMER Timer_1 ;
		INTERVAL 1000 ;
		ACTION Form_1.Label_1.Value := Time() 

		DEFINE TIMER Timer_2 ;
		INTERVAL 2500 ;
		ACTION PlayBeep() 

	END WINDOW

	Form_1.Center 

	Form_1.Activate 

Return

