#include "hmg.ch"
Function main()

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 480 ;
		TITLE 'InputBox Demo' ;
		MAIN ;
		TOPMOST 

		@ 50 ,100 BUTTON Button_1 ;
			CAPTION "InputBox Test" ;
			ACTION CLick() ;
	                WIDTH 200 ;
			HEIGHT 30

		@ 100 ,100 BUTTON Button_2 ;
			CAPTION "InputBox (Timeout) Test" ;
			ACTION TCLick() ;
	                WIDTH 200 ;
			HEIGHT 30

		@ 150 ,100 BUTTON Button_3 ;
			CAPTION "InputBox (Timeout) Test 2" ;
			ACTION TCLick2() ;
	                WIDTH 200 ;
			HEIGHT 30

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

Procedure Click

	MsgInfo ( InputBox ( 'Enter text' , 'InputBox Demo' , 'Default Value' )	)

Return

Procedure TClick

	MsgInfo ( InputBox ( 'Enter text' , 'InputBox Demo' , 'Default Value' , 5000 ) )

Return

Procedure TClick2

	MsgInfo ( InputBox ( 'Enter text' , 'InputBox Demo' , 'Default Value' , 5000 , 'Timeout Value' ) )

Return

