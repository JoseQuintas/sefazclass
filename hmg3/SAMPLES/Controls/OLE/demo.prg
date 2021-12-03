
#define CRLF Chr( 13 ) + Chr( 10 )

#include "hmg.ch"

PROCEDURE MAIN()

	DEFINE WINDOW main_form ;
		AT 114,218 ;
		WIDTH 334 ;
		HEIGHT 276 ;
		TITLE 'OLE TEST' ;
		MAIN

		DEFINE MAIN MENU

			DEFINE POPUP "Test"
				MENUITEM 'Word Test' ACTION MSWORD()
				MENUITEM 'IE Test' ACTION IEXPLORER()
				MENUITEM 'OutLook Test' ACTION OUTLOOK()
				MENUITEM 'Excel Test' ACTION EXCEL()
			END POPUP

		END MENU

	END WINDOW 

	Main_form.center
	Main_form.activate

Return NIL

RETURN

//--------------------------------------------------------------------

STATIC PROCEDURE Excel()
LOCAL oExcel, oHoja

   oExcel := CreateObject( "Excel.Application" )

   oExcel:WorkBooks:Add()

   oHoja := oExcel:ActiveSheet()

   oHoja:Cells:Font:Name := "Arial"
   oHoja:Cells:Font:Size := 12

   oHoja:Cells( 3, 1 ):Value := "Texto:"
   oHoja:Cells( 3, 2 ):Value := "Esto es un texto"
   oHoja:Cells( 4, 1 ):Value := "Número:"
   oHoja:Cells( 4, 2 ):NumberFormat := "#.##0,00"
   oHoja:Cells( 4, 2 ):Value := 1234.50
   oHoja:Cells( 5, 1 ):Value := "Lógico:"
   oHoja:Cells( 5, 2 ):Value := .T.
   oHoja:Cells( 6, 1 ):Value := "Fecha:"
   oHoja:Cells( 6, 2 ):Value := DATE()

   oHoja:Columns( 1 ):Font:Bold := .T.
   oHoja:Columns( 2 ):HorizontalAlignment := -4152  // xlRight

   oHoja:Columns( 1 ):AutoFit()
   oHoja:Columns( 2 ):AutoFit()

   oHoja:Cells( 1, 1 ):Value := "OLE from HMG"
   oHoja:Cells( 1, 1 ):Font:Size := 16
   oHoja:Range( "A1:B1" ):HorizontalAlignment := 7

   oHoja:Cells( 1, 1 ):Select()

   oExcel:Visible := .T.


RETURN

//--------------------------------------------------------------------

STATIC PROCEDURE MsWord()

	LOCAL oWord, oText

	oWord := CreateObject( "Word.Application" )

	oWord:Documents:Add()

	oTexto := oWord:Selection()

	oTexto:Text := "OLE desde HMG" + CRLF
	oTexto:Font:Name := "Arial"
	oTexto:Font:Size := 48
	oTexto:Font:Bold := .T.

	oWord:Visible := .T.
	oWord:WindowState := 1 

RETURN

//--------------------------------------------------------------------

STATIC PROCEDURE IEXPLORER()

	LOCAL oIE

	oIE := CreateObject( "InternetExplorer.Application" )

	oIE:Visible := .T.

	oIE:Navigate( "http://www.hmgforum.com/" )

RETURN

//--------------------------------------------------------------------

STATIC PROCEDURE OUTLOOK()

	LOCAL oOL, oList, oMail, i

	oOL := CreateObject( "Outlook.Application" )

	oList := oOL:CreateItem( 7 )
	oList:DLName := "Distribution List"
	oList:Display(.F.)

RETURN

//--------------------------------------------------------------------
