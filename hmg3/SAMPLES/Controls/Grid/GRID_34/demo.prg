/*
* HMG Virtual Grid Demo
* (c) 2009 Roberto Lopez
*/

#include "hmg.ch"

Function Main

Local aValue := { 0 , 0 }

	* Grid Column Controls Definitions

	aCtrl_1 := {'TEXTBOX','NUMERIC','9999999999'}
	aCtrl_2 := {'TEXTBOX','CHARACTER'}
	aCtrl_3 := {'TEXTBOX','CHARACTER'}
	aCtrl_4 := {'DATEPICKER','UPDOWN'}
	aCtrl_5 := { 'CHECKBOX' , 'Yes' , 'No' }
	aCtrl_6 := { 'EDITBOX' }

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 800 ;
		HEIGHT 510 ;
		TITLE 'GRID ONSAVE TEST' ;
		MAIN 

		DEFINE MAIN MENU 
			POPUP 'File'
				ITEM 'Append (Alt+A)'				ACTION Form_1.Grid_1.Append
				ITEM 'Get RecNo'				ACTION MsgInfo( Str(Form_1.Grid_1.RecNo) )
				ITEM 'Set RecNo'				ACTION Form_1.Grid_1.RecNo := val(InputBox('','')) 
				ITEM 'Get Value'				ACTION ( aValue := Form_1.Grid_1.Value , MsgInfo( Str( aValue [1] ) + ' , ' + Str( aValue [2] ) ) )
				ITEM 'Set Value'				ACTION ( aValue [ 1 ] :=  val(InputBox('New Row','Selected Cell (Value)')) , aValue [ 2 ] :=  val(InputBox('New Col','Selected Cell (Value)')) , Form_1.Grid_1.Value := { aValue [ 1 ] , aValue [ 2 ] } )
				ITEM 'Delete (Alt+D)'				ACTION Form_1.Grid_1.Delete
				ITEM 'Recall (Alt+R)'				ACTION Form_1.Grid_1.Recall
				ITEM 'Save Pending Changes (Alt+S)'		ACTION Form_1.Grid_1.Save
				ITEM 'Clear Changes Buffer (Undo) (ALt+U)'	ACTION Form_1.Grid_1.ClearBuffer
			END POPUP
		END MENU

		USE TEST SHARED

		GO TOP

		@ 10,10 GRID Grid_1 ;
			WIDTH 770 ;
			HEIGHT 440 ;
			HEADERS {'Column 1','Column 2','Column 3','Column 4','Column 5','Column 6'} ;
			WIDTHS {140,140,140,100,100,100};
			VALUE { 1 , 1 } ;
			ROWSOURCE "Test" ;
			COLUMNFIELDS { 'Code' ,  'First' , 'Last' ,  'Birth' , 'Married' , 'Bio' } ;
			COLUMNCONTROLS { aCtrl_1 , aCtrl_2 , aCtrl_3 , aCtrl_4 , aCtrl_5 , aCtrl_6 } ;
			EDIT ;
			ALLOWAPPEND ;
			ALLOWDELETE ;
			ON SAVE OnSaveTest()
		
	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return
*******************************************************************************
Procedure OnSaveTest()
*******************************************************************************
Local i
Local s
Local cMark
Local j


	* Show Edited Cells ***************************************************

	For i := 1 To len( This.EditBuffer )

		s := ''

		nLogicalRow	:= This.EditBuffer [ i ] [ 1 ] 

		nLogicalCol	:= This.EditBuffer [ i ] [ 2 ] 

		xValue		:= This.EditBuffer [ i ] [ 3 ] 

		nPhysicalRow	:= This.EditBuffer [ i ] [ 4 ] 

		s += 'RecNo():' + Str( nPhysicalRow ) + chr(13) + chr(10)
		s += 'Logical Row: ' + Str( nLogicalRow )  + chr(13) + chr(10)
		s += 'Logical Col: ' + Str( nLogicalCol )  + chr(13) + chr(10)
		s += 'Value:       ' + xToC( xValue )      + chr(13) + chr(10)

		MsgInfo ( s , 'Edited Cell #' + str(i) )

	Next i


	* Show Deleted / Recalled Records *****************************************

	For i := 1 To len( This.MarkBuffer )

		s := ''

		nLogicalRow	:= This.MarkBuffer [ i ] [ 1 ] 

		nPhysicalRow	:= This.MarkBuffer [ i ] [ 2 ] 

		cMark		:= This.MarkBuffer [ i ] [ 3 ] 


		s += 'RecNo():' + Str( nPhysicalRow ) + chr(13) + chr(10)
		s += 'Logical Row: ' + Str( nLogicalRow )  + chr(13) + chr(10)
		s += 'Mark:       ' + if ( cMark == 'D' , 'Delete' , 'Recall' ) + chr(13) + chr(10)


		MsgInfo ( s , 'Marked Row #' + str(i) )

	Next i


	* Show Appended Records ************************************************

	For i := 1 To len( This.AppendBuffer )

		s := ''

		s+= xToC ( This.AppendBuffer [ i ] [ 1 ] ) + ' , ' 
		s+= xToC ( This.AppendBuffer [ i ] [ 2 ] ) + ' , ' 
		s+= xToC ( This.AppendBuffer [ i ] [ 3 ] ) + ' , ' 
		s+= xToC ( This.AppendBuffer [ i ] [ 4 ] ) + ' , ' 
		s+= xToC ( This.AppendBuffer [ i ] [ 5 ] ) + ' , ' 
		s+= xToC ( This.AppendBuffer [ i ] [ 6 ] ) 

		MsgInfo ( s , 'Appended Record #' + str(i) )

	Next i

Return

*******************
Function xToC ( x )
***
Local c

	If ValType ( x ) == 'C'

		c := x

		if empty(c) 

		        c := '"' + c + '"'

		endif			

	ElseIf ValType ( x ) == 'N'

		c := Str(x)

	ElseIf ValType ( x ) == 'D'

		c := dToC (x)

	ElseIf ValType ( x ) == 'L'

		c := if ( x , '.T.' , '.F.' )

	ElseIf ValType ( x ) == 'U'

		c := 'Nil'

	EndIf


Return c