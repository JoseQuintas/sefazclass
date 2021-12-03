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
			DEFINE POPUP 'Test'
				MENUITEM 'Get Value' ACTION MsgInfo(Str(Form_1.Combo_1.Value))
				MENUITEM 'Set Value' ACTION Form_1.Combo_1.Value := 1
				MENUITEM 'Get DisplayValue' ACTION MsgInfo( Form_1.Combo_1.DisplayValue )
				MENUITEM 'Set DisplayValue' ACTION Form_1.Combo_1.DisplayValue := 'New Text' 
				MENUITEM 'Set Item' ACTION Form_1.Combo_1.Item (3) := 'New Text' 
				MENUITEM 'Get Item' ACTION MsgInfo ( Form_1.Combo_1.Item (3) )
			END POPUP
		END MENU


		@ 10,10 COMBOBOX Combo_1 ;
			ITEMS { 'A' , 'B' , 'C' } ;
			VALUE 1 ;
			DISPLAYEDIT ;
			ON DISPLAYCHANGE PlayBeep() 

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return


