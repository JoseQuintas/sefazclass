/*
* HMG ComboBox Demo
* (c) 2002 Roberto Lopez
*/

#include "hmg.ch"
Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		TITLE 'ComboBox Demo' ;
		MAIN 

		DEFINE MAIN MENU
			DEFINE POPUP '&Test'
				MENUITEM 'Item Content' ACTION MsgInfo ( Form_1.Combo_1.Item (1) )
			END POPUP
		END MENU

		@ 10,10 COMBOBOX Combo_1 ;
			WIDTH 100 ;
			ITEMS { '1 | Uno' , '2 | Dos' , '3 | tres' } ;
			VALUE 1 ;
			ON ENTER MsgInfo ( Str(Form_1.Combo_1.value) ) ;
			FONT 'Courier' SIZE 12 

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return



