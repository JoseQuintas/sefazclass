/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

#xtranslate VALID <condition> [ MESSAGE <message> ] ;
=> ;
ON LOSTFOCUS _DoValid ( <condition> , <message> )

Function Main

	Public _HMG_IsValidInProgres := .F.

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'HMG Demo' ;
		MAIN 

		@ 10,10 TEXTBOX Text_1 ;
			VALUE 11 ;
			NUMERIC ;
			VALID This.Value < 10

		@ 40,10 TEXTBOX Text_2 ;
			VALUE 11 ;
			NUMERIC ;
			VALID This.Value < 10	;
			MESSAGE 'Only values < 10 !'

	END WINDOW

	Form_1.Activate

Return Nil

Function _DoValid ( Expression , Message )

	If ValType ( Message ) = "U"
		Message := "Invalid Entry"
	EndIf

	If _HMG_IsValidInProgres

		Return Nil

	Else

		_HMG_IsValidInProgres := .T.
		If ( Expression , Nil , ( MsgStop (Message,'') , This.SetFocus  ) ) 
		_HMG_IsValidInProgres := .F.

	EndIf

Return Nil

