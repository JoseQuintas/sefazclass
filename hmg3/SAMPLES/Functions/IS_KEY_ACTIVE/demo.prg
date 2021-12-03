
#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 400 ;
		TITLE 'Is<Key>Active() Demo' ;
		MAIN 

		DEFINE BUTTON Button_1 
			ROW 10
			COL 10	
			CAPTION 'Test'
			ACTION  ( ;
				MsgInfo( if ( IsInsertActive() , '.T.','.F.' ) , 'Insert' ) , ;
				MsgInfo( if ( IsCapsLockActive() , '.T.','.F.' ) , 'Caps Lock' ) , ;
				MsgInfo( if ( IsScrollLockActive() , '.T.','.F.' ) , 'Scroll Lock' ) , ;
				MsgInfo( if ( IsNumLockActive() , '.T.','.F.' ) , 'Num Lock' ) ;
				)
		END BUTTON

		@ 100,10 TEXTBOX Text_1 

	END WINDOW

	ACTIVATE WINDOW Form_1

Return

