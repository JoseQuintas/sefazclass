#include "hmg.ch"

Function main()

	DEFINE WINDOW Frm_Sound ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		TITLE 'PLAYWAVE' ;
		MAIN ;
		TOPMOST 

		@ 50 ,100 BUTTON Button_1 ;
			CAPTION "Play Wave From File" ;
			ACTION Play_CLick() ;
	                WIDTH 200 ;
			HEIGHT 30

	END WINDOW

	CENTER WINDOW Frm_Sound

	ACTIVATE WINDOW Frm_Sound

Return

Procedure Play_Click

	PLAY WAVE "sample.wav" 

Return

