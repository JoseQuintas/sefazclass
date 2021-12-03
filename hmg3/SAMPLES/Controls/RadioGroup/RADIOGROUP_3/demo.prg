/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-2008 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'HMG Demo' ;
		ICON 'DEMO.ICO' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE MAIN MENU 
			POPUP 'M&isc'
				ITEM 'Set RadioGroup 1 ReadOnly Property To {.T.,.T.,.T.,.T.}'	ACTION Form_1.Radio_1.ReadOnly := { .T. , .T. , .T. , .T. }
				ITEM 'Set RadioGroup 1 ReadOnly Property To {.F.,.F.,.F.,.F.}'	ACTION Form_1.Radio_1.ReadOnly := { .F. , .F. , .F. , .F. }
				ITEM 'Set RadioGroup 1 ReadOnly Property To {.F.,.T.,.F.,.T.}'	ACTION Form_1.Radio_1.ReadOnly := { .F. , .T. , .F. , .T. }
				SEPARATOR
				ITEM 'Set RadioGroup 2 ReadOnly Property To {.T.,.T.,.T.,.T.}'	ACTION Form_1.Radio_2.ReadOnly := { .T. , .T. , .T. , .T. }
				ITEM 'Set RadioGroup 2 ReadOnly Property To {.F.,.F.,.F.,.F.}'	ACTION Form_1.Radio_2.ReadOnly := { .F. , .F. , .F. , .F. }
				ITEM 'Set RadioGroup 2 ReadOnly Property To {.F.,.T.,.F.,.T.}'	ACTION Form_1.Radio_2.ReadOnly := { .F. , .T. , .F. , .T. }
				SEPARATOR
				ITEM 'Get RadioGroup 1 ReadOnly Property'	ACTION MsgInfo ( LogicalArrayToString ( Form_1.Radio_1.ReadOnly ) )
				ITEM 'Get RadioGroup 2 ReadOnly Property'	ACTION MsgInfo ( LogicalArrayToString ( Form_1.Radio_2.ReadOnly ) )
			END POPUP
		END MENU

		DEFINE RADIOGROUP Radio_1 
			OPTIONS	{ 'One' , 'Two' , 'Three', 'Four' } 
			VALUE	1 
			WIDTH	100 
			TOOLTIP	'RadioGroup' 
			READONLY { .F. , .T. , .F. , .T. }
			ROW	10
			COL	10
		END RADIOGROUP
			
		DEFINE RADIOGROUP Radio_2 
			ROW 10
			COL 150
			OPTIONS { 'One' , 'Two' , 'Three', 'Four' } 
			VALUE 1 
			WIDTH 100 
			TOOLTIP 'RadioGroup' 
			READONLY { .F. , .T. , .F. , .T. }
		END RADIOGROUP

		@ 150,10 DATEPICKER Date_1 ;
		VALUE CTOD('  / /  ') ;
		TOOLTIP 'DatePicker Control' 

	END WINDOW

	Form_1.date_1.SetFocus

	Form_1.Center

	Form_1.Activate

Return Nil

Function LogicalArrayToString ( lArray )
Local RetVal := '{ ' , I

	For I := 1 To Len ( lArray )

		If lArray [I]
			RetVal := RetVal + ' ".T." '
		Else
			RetVal := RetVal + ' ".F." '
		EndIf

	Next I

Return RetVal + ' }'
