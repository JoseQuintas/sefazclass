/*
* HMG Virtual Grid Demo
* (c) 2003 Roberto lopez
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 450 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN 

		DEFINE MAIN MENU
			DEFINE POPUP 'File'
				MENUITEM 'Change ItemCount' ACTION Form_1.Grid_1.ItemCount := Val(InputBox('New Value','Change ItemCount'))
			END POPUP
		END MENU

		@ 10,10 GRID Grid_1 ;
		WIDTH 400 ;
		HEIGHT 330 ;
		HEADERS {'','Column 2','Column 3'} ;
		WIDTHS {0,140,140};
		VIRTUAL ;
		ITEMCOUNT 100000000 ;
		ON QUERYDATA QueryTest() MULTISELECT ;
		IMAGE {"br_no","br_ok"} 

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

Procedure QueryTest()

	If This.QueryColIndex == 1
		If Int ( This.QueryRowIndex / 2 ) == This.QueryRowIndex / 2
			This.QueryData := 0
		Else
			This.QueryData := 1
		EndIf
	Else
		This.QueryData := Str ( This.QueryRowIndex ) + ',' + Str ( This.QueryColIndex )
	EndIf

Return