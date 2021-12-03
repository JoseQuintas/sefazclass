/*
* HMG Hello World Demo
*/


#include "hmg.ch"

Function Main
Public x := 1

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN 

		DEFINE MAIN MENU
			DEFINE POPUP 'File'
				MENUITEM 'Test 1' ACTION Test1()
				MENUITEM 'Test 2' ACTION Test2()
			END POPUP
		END MENU

	END WINDOW

	ACTIVATE WINDOW Win_1

Return

Procedure Test1()
Local x

	x := Getfile ( { {'All Files','*.*'} } , 'Open File' , 'c:\' , .f. , .t. )
	msginfo (x)

Return

Procedure Test2()
Local x , i

	x := Getfile ( { {'All Files','*.*'} } , 'Open File' , 'c:\' , .t. , .t. )

	For i := 1 To len (x)
		msginfo (x [i])
	Next x

Return