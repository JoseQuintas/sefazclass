/*
* HMG Virtual Grid Demo
* (c) 2003 Roberto Lopez
*/

#include "hmg.ch"

* When using virtual Grids you must avoid to use Item property and additem 
* method. It can generate unexpected results.

Function Main

	Private bColor := { || if ( This.CellRowIndex/2 == int(This.CellRowIndex/2) , { 222,222,222 } , { 255,255,255 } ) }	

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
		HEADERS {'Column 1','Column 2','Column 3'} ;
		WIDTHS {140,140,140};
		VIRTUAL ;
		ITEMCOUNT 10000 ;
		ON QUERYDATA QueryTest() ;
		COLUMNWHEN 	{ ;
				{ || WhenTest() } , ;
				{ || WhenTest() } , ;
				{ || WhenTest() } ;
				} ;
		COLUMNVALID 	{ ;
				{ || ValidTest() } , ;
				{ || ValidTest() } , ;
				{ || ValidTest() } ;
				} ;
		CELLNAVIGATION ;
		EDIT ;
		DYNAMICBACKCOLOR { bColor , bColor , bColor } 

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

Procedure QueryTest()

	This.QueryData := Str ( This.QueryRowIndex ) + ',' + Str ( This.QueryColIndex )

Return

Function ValidTest
Local cString := ''
Local lRet

	msginfo( ThisWindow.Name )

	cString += 'Cell Edited!'					   + chr(13) + chr(10) 
	cString += 							   + chr(13) + chr(10) 
	cString += 'This.CellRowIndex: ' + alltrim(str(This.CellRowIndex)) + chr(13) + chr(10) 
	cString += 'This.CellColIndex: ' + alltrim(str(This.CellColIndex)) + chr(13) + chr(10) 
	cString += 'This.CellValue:    ' + alltrim( AutoConvert() ) 

	MsgInfo ( cString )

	if empty ( This.CellValue )
		lRet := .F.
	else
		lRet := .T.
	endif

Return lRet

Function WhenTest
Local lRet
Local cString := ''


	cString += 'Entering Cell!'					   + chr(13) + chr(10) 
	cString += 							   + chr(13) + chr(10) 
	cString += 'This.CellRowIndex: ' + alltrim(str(This.CellRowIndex)) + chr(13) + chr(10) 
	cString += 'This.CellColIndex: ' + alltrim(str(This.CellColIndex)) + chr(13) + chr(10) 
	cString += 'This.CellValue:    ' + alltrim( AutoConvert() ) 

	MsgInfo ( cString )


	If This.CellColIndex < 3
		lRet := .F.
	else
		lRet := .T.
	endif

Return lRet


Function AutoConvert()

	if	valtype ( This.CellValue ) == 'D'

		cTemp := dtoc ( This.CellValue )

	elseif	valtype ( This.CellValue ) == 'N'

		cTemp := str ( This.CellValue )

	elseif	valtype ( This.CellValue ) == 'C'

		cTemp := This.CellValue

	elseif	valtype ( This.CellValue ) == 'L'

		cTemp := if ( This.CellValue , '.T.' , '.F.' )

	endif

return cTemp