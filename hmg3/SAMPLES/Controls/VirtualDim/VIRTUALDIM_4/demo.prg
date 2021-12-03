#include "hmg.ch"

* Toolbar's & SplitBox's parent window can't be a 'Virtual Dimensioned' window. 
* Use 'Virtual Dimensioned' splitchild's instead.

Function Main

	SET AUTOSCROLL ON

	DEFINE WINDOW Form_Main ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 200 ;
		VIRTUAL WIDTH 1700 ;
		VIRTUAL HEIGHT 300 ;
		TITLE 'Virtual Dimensioned Window Demo' ;
		MAIN 

		@ 100,100 BUTTON Button_1 ;
		CAPTION '1' ;
		ACTION MsgInfo('1') ;
		WIDTH 150 HEIGHT 25 

		@ 100,300 BUTTON Button_2 ;
		CAPTION '2' ;
		ACTION MsgInfo('2') ;
		WIDTH 150 HEIGHT 25 

		@ 100,500 BUTTON Button_3 ;
		CAPTION '3' ;
		ACTION MsgInfo('3') ;
		WIDTH 100 HEIGHT 25 

		@ 100,700 BUTTON Button_4 ;
		CAPTION '4' ;
		ACTION MsgInfo('4') ;
		WIDTH 100 HEIGHT 25 

		@ 100,900 BUTTON Button_5 ;
		CAPTION '5' ;
		ACTION MsgInfo('5') ;
		WIDTH 100 HEIGHT 25 

		@ 100,1100 BUTTON Button_6 ;
		CAPTION '6' ;
		ACTION MsgInfo('6') ;
		WIDTH 100 HEIGHT 25 

		@ 100,1300 BUTTON Button_7 ;
		CAPTION '7' ;
		ACTION MsgInfo('7') ;
		WIDTH 100 HEIGHT 25 

	END WINDOW

	CENTER WINDOW Form_Main
	ACTIVATE WINDOW Form_Main

Return Nil

