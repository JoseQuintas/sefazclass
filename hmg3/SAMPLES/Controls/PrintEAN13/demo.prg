#include <minigui.ch>
#include 'common.ch'
#define SODIUM	"0123456789+"
#define NEON	"0123456789" 
#define EAN2	102
#define EAN5	105
#define EAN13Parity {"AAAAAA", "AABABB", "AABBAB", "AABBBA", "ABAABB", "ABBAAB", "ABBBAA", "ABABAB", "ABABBA", "ABBABA"}
#DEFINE EANsetA {"3211", "2221", "2122", "1411", "1132", "1231", "1114", "1312", "1213",	"3112"}
#DEFINE EANsetB {"1123", "1222", "2212", "1141", "2311", "1321", "4111", "2131", "3121","2113"}

/* Copyright (c) 2012.11.06 Marek Olszewski mol@pro.onet.pl
	based on original idea by Robin Stuart and libzint
*/

/*  upcean.c - Handles UPC, EAN and ISBN

    libzint - the open source barcode library
    Copyright (C) 2008 Robin Stuart <robin@zint.org.uk>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/


*-------------------------
Function Main()
	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'EAN13 Generator Sample' ;
		MAIN 

		DEFINE MAIN MENU 
			DEFINE POPUP 'File'
				MENUITEM 'Exit' ACTION DoMethod("Win_1","Release")
			END POPUP
			DEFINE POPUP 'Test'
				MENUITEM 'Test' ACTION PrintEAN13()
			END POPUP
		END MENU

	END WINDOW

	CENTER WINDOW Win_1
	ACTIVATE WINDOW Win_1
	
return

*--------------------------
function MOL_ean13( cSource )

	local i
	local cParity
	local cPrepared := ""

	cParity := ""
	cParity := MOL_lookup(SODIUM, EAN13Parity, substr(cSource,1,1))

	/* start character */
	cPrepared := "111"
	
	//left side
	for i = 2 to 7
		if substr(cParity, i-1,1) == 'B'
			cPrepared += MOL_lookup(NEON, EANsetB, substr(cSource,i,1))
		else
			cPrepared += MOL_lookup(NEON, EANsetA, substr(cSource,i,1))
		endif
	next i
	
	//middle control characters
	cPrepared += "11111"
	
	// right side
	for i:=8 to 13
		cPrepared += MOL_lookup(NEON, EANsetA, substr(cSource,i,1))
	next i

	/* stop character */
	cPrepared += "111"	
 return cPrepared
*--------------------------
function MOL_lookup
	param cSetString, aSearchedTable, cWhatToSearch
 /* Replaces huge switch statements for looking up in tables */
	local i
	
	i := at(cWhatToSearch, cSetString)
	if i > 0
		return aSearchedTable[i]
	endif

 return 'ERROR'
 
*--------------------------

function PrintEAN13
	
	local i, cPreparedEAN13
	local nOffset, nModuleWidth, nBeginRow, nEndRow
	local lWhiteStrip
	
	cKodEan13 := space(13)
	cKodEan13 := InputBox("Enter EAN13 BarCode","Enter EAN13 BarCode", cKodEan13)

	cPreparedEAN13 := MOL_ean13(cKodEAN13)
	
	SELECT PRINTER DEFAULT PREVIEW ;
			ORIENTATION	PRINTER_ORIENT_PORTRAIT ;
			PAPERSIZE	PRINTER_PAPER_A4 ;
			QUALITY		PRINTER_RES_MEDIUM
	
	START PRINTDOC name 	'TEST ' 
	START PRINTPAGE

	// left margin
	nOffset := 10
	nModuleWidth := 0.33
	nBeginRow := 20
	nEndRow := 40
	
	@ nEndRow+2, nOffset print cKodEAN13 ;
					FONT "ARIAL CE" ;
					SIZE 11 ;
					COLOR BLACK

	lWhiteStrip := .f.

	for i:=1 to len(cPreparedEAN13)
		nStripWidth := val( substr(cPreparedEAN13,i,1) )
		if lWhiteStrip
			//@ nBeginRow, nOffset print rectangle to nEndRow, nOffset + nModuleWidth*nStripWidth penwidth 0.1 color WHITE
		else
			//print black strip
			@ nBeginRow, nOffset print rectangle to nEndRow, nOffset + nModuleWidth*nStripWidth penwidth 0.01 color BLACK FILLED
		endif
		
		//switch colors		
		lWhiteStrip := !lWhiteStrip
		
		nOffset += nModuleWidth*nStripWidth
	next i

		
	END PRINTPAGE
	END PRINTDOC
return