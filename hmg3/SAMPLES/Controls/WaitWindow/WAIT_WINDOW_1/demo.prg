/*
* HMG Hello World Demo
* (c) 2002-2004 Roberto Lopez <mail.box.hmg@gmail.com>
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'WAIT WINDOW DEMO 1' ;
		MAIN 

	@ 70,70 BUTTON Button_1 CAPTION 'WAIT WINDOW "Processing..." NOWAIT' ACTION Test1() WIDTH 250
	@ 100,70 BUTTON Button_2 CAPTION 'WAIT CLEAR' ACTION Test2() WIDTH 250

	END WINDOW

	CENTER WINDOW Win_1 

	ACTIVATE WINDOW Win_1 

Return

procedure test1()

	WAIT WINDOW "Processing..."  NOWAIT

return

procedure test2()

	WAIT CLEAR

return
