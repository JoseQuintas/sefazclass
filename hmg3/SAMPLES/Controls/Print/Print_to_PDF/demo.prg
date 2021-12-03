#include "hmg.ch"

*------------------------------------------------------------------------------*
Function Main()
*------------------------------------------------------------------------------*

//	AVAILABLE LIBRARY INTERFACE LANGUAGES

//	SET LANGUAGE TO ENGLISH (DEFAULT)
//	SET LANGUAGE TO SPANISH
//	SET LANGUAGE TO PORTUGUESE
//	SET LANGUAGE TO ITALIAN
//	SET LANGUAGE TO GERMAN
//	SET LANGUAGE TO FRENCH

	Private aColor [10]

	aColor [1] := YELLOW	
	aColor [2] := PINK	
	aColor [3] := RED	
	aColor [4] := FUCHSIA	
	aColor [5] := BROWN	
	aColor [6] := ORANGE	
	aColor [7] := GREEN	
	aColor [8] := PURPLE	
	aColor [9] := BLACK	
	aColor [10] := BLUE

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'MiniPrint Library Test' ;
		MAIN 

		DEFINE MAIN MENU 
			DEFINE POPUP 'File'
				MENUITEM 'Default Printer' ACTION PrintTest1()
				MENUITEM 'User Selected Printer' ACTION PrintTest2()
				MENUITEM 'User Selected Printer And Settings' ACTION PrintTest3()
				MENUITEM 'User Selected Printer And Settings (Preview)' ACTION PrintTest4()
				MENUITEM 'PDF Print' ACTION PrintTest5()
			END POPUP
		END MENU

	END WINDOW

	MAXIMIZE WINDOW Win_1

	ACTIVATE WINDOW Win_1

Return
*------------------------------------------------------------------------------*
Procedure PrintTest1()
*------------------------------------------------------------------------------*
Local i 

	SELECT PRINTER DEFAULT ;
		ORIENTATION	PRINTER_ORIENT_PORTRAIT ;
		PAPERSIZE	PRINTER_PAPER_LETTER ;
		QUALITY		PRINTER_RES_MEDIUM 

	PrintDoc()

	MsgInfo('Print Finished')

Return
*------------------------------------------------------------------------------*
Procedure PrintTest2()
*------------------------------------------------------------------------------*
Local i 
Local cPrinter

	cPrinter := GetPrinter()

	If Empty (cPrinter)
		Return
	EndIf

	SELECT PRINTER cPrinter ;
		ORIENTATION	PRINTER_ORIENT_PORTRAIT ;
		PAPERSIZE	PRINTER_PAPER_LETTER ;
		QUALITY		PRINTER_RES_MEDIUM

	PrintDoc()

	MsgInfo('Print Finished')

Return
*------------------------------------------------------------------------------*
Procedure PrintTest3()
*------------------------------------------------------------------------------*
Local i 
Local lSuccess

	// Measure Units Are Millimeters

	SELECT PRINTER DIALOG TO lSuccess 

	If lSuccess == .T.
		PrintDoc()
		MsgInfo('Print Finished')
	EndIf

Return
*------------------------------------------------------------------------------*
Procedure PrintTest4()
*------------------------------------------------------------------------------*
Local i 
Local lSuccess

	SELECT PRINTER DIALOG TO lSuccess PREVIEW

	If lSuccess == .T.
		PrintDoc()
		MsgInfo('Print Finished')
	EndIf

Return
*------------------------------------------------------------------------------*
Procedure PrintTest5()
*------------------------------------------------------------------------------*
Local i 
Local lSuccess

	SELECT PRINTER PDF 'pdfprintdemo.pdf' TO lSuccess

	If lSuccess == .T.
		PrintDoc()
		MsgInfo('Print Finished')
      if file( 'pdfprintdemo.pdf')
         execute file 'pdfprintdemo.pdf'
      endif   
	EndIf

Return
*------------------------------------------------------------------------------*
Procedure PrintDoc
*------------------------------------------------------------------------------*
Local i

	// Measure Units Are Millimeters

	START PRINTDOC


			START PRINTPAGE

				@ 20,20 PRINT "Filled Rectangle Sample:" ;
					FONT "Arial" ;
					SIZE 20 

			
				@ 30,20 PRINT RECTANGLE ;
					TO 40,190 ;
					PENWIDTH 0.1;
					COLOR {255,255,0}
					
					
				@ 60,20 PRINT RECTANGLE ;
					TO 100,190 ;
					PENWIDTH 0.1;
					COLOR {255,255,0};
					FILLED
					
				@ 110,20 PRINT RECTANGLE ;
					TO 150,190 ;
					PENWIDTH 0.1;
					COLOR {255,255,0};
					ROUNDED
					
				@ 160,20 PRINT RECTANGLE ;
					TO 200,190 ;
					PENWIDTH 0.1;
					COLOR {255,255,0};
					FILLED;
					ROUNDED
										
			END PRINTPAGE
			START PRINTPAGE

				@ 20,20 PRINT "Filled Rectangle Sample:" ;
					FONT "Arial" ;
					SIZE 20 

			
				@ 30,20 PRINT RECTANGLE ;
					TO 40,190 ;
					PENWIDTH 0.1
					
				@ 60,20 PRINT RECTANGLE ;
					TO 100,190 ;
					PENWIDTH 0.1;
					FILLED
					
				@ 110,20 PRINT RECTANGLE ;
					TO 150,190 ;
					PENWIDTH 0.1;
					ROUNDED
					
				@ 160,20 PRINT RECTANGLE ;
					TO 200,190 ;
					PENWIDTH 0.1;
					FILLED;
					ROUNDED
										
			END PRINTPAGE

			
	END PRINTDOC

Return
