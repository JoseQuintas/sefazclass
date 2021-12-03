#include "hmg.ch"

* Toolbar's & SplitBox's parent window can't be a 'Virtual Dimensioned' window. 
* Use 'Virtual Dimensioned' splitchild's instead.

Function Main

	SET AUTOSCROLL ON

	DEFINE WINDOW Form_Main ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 480 ;
		VIRTUAL WIDTH 1300 ;
		VIRTUAL HEIGHT 800 ;
		TITLE 'Virtual Dimensioned Window Demo' ;
		MAIN 

		@ 100,10 BUTTON Button_1 ;
		CAPTION 'Vert. ScrollBar Value' ;
		ACTION MsgInfo( Str ( Form_Main.VScrollBar.Value ) ) ;
		WIDTH 150 HEIGHT 25 

		@ 200,10 BUTTON Button_2 ;
		CAPTION 'Horiz. ScrollBar Value' ;
		ACTION MsgInfo( Str ( Form_Main.HScrollBar.Value ) ) ;
		WIDTH 150 HEIGHT 25 

		@ 300,10 BUTTON Button_3 ;
		CAPTION '3' ;
		ACTION MsgInfo('3') ;
		WIDTH 100 HEIGHT 25 

		@ 400,10 BUTTON Button_4 ;
		CAPTION '4' ;
		ACTION MsgInfo('4') ;
		WIDTH 100 HEIGHT 25 

		@ 500,10 BUTTON Button_5 ;
		CAPTION '5' ;
		ACTION MsgInfo('5') ;
		WIDTH 100 HEIGHT 25 

		@ 600,10 BUTTON Button_6 ;
		CAPTION '6' ;
		ACTION MsgInfo('6') ;
		WIDTH 100 HEIGHT 25 

		@ 700,10 BUTTON Button_7 ;
		CAPTION '7' ;
		ACTION MsgInfo('7') ;
		WIDTH 100 HEIGHT 25 

	END WINDOW

	CENTER WINDOW Form_Main
	ACTIVATE WINDOW Form_Main

Return Nil

