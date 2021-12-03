/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2009, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net>

	"HWGUI"
  	Copyright 2001-2009 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

MEMVAR _HMG_SYSDATA

#include "hmg.ch"
#include "Fileio.ch"


* Main ************************************************************************

Procedure _DefineReport ( cName )

	_HMG_SYSDATA [ 206 ] := Nil
	_HMG_SYSDATA [ 207 ] := Nil

	_HMG_SYSDATA [ 118 ] := 0
	_HMG_SYSDATA [ 119 ] := 0

	_HMG_SYSDATA [ 120 ] := 0

	_HMG_SYSDATA [ 121 ] := {}
	_HMG_SYSDATA [ 122 ] := {}

	_HMG_SYSDATA [ 123 ] := 0
	_HMG_SYSDATA [ 124 ] := 0

	_HMG_SYSDATA [ 155 ] := 0
	_HMG_SYSDATA [ 156 ] := 0

	_HMG_SYSDATA [ 157 ] := {}
	_HMG_SYSDATA [ 158 ] := {}
	_HMG_SYSDATA [ 159 ] := {}
	_HMG_SYSDATA [ 160 ] := {}
	_HMG_SYSDATA [ 126 ] := {}
	_HMG_SYSDATA [ 127 ] := 0
	_HMG_SYSDATA [161] := 'MAIN'

	If cName <> '_TEMPLATE_'

		_HMG_SYSDATA [162] := cName

	Else

		cName := _HMG_SYSDATA [162]

	EndIf

	Public &cName := {}

Return

Procedure _EndReport
Local cReportName
Local aMiscdata

	aMiscData := {}

	aadd ( aMiscData , _HMG_SYSDATA [ 120 ] ) // nGroupCount
	aadd ( aMiscData , _HMG_SYSDATA [ 152 ] ) // nHeadeHeight
	aadd ( aMiscData , _HMG_SYSDATA [ 153 ] ) // nDetailHeight
	aadd ( aMiscData , _HMG_SYSDATA [ 154 ] ) // nFooterHeight
	aadd ( aMiscData , _HMG_SYSDATA [ 127 ] ) // nSummaryHeight
	aadd ( aMiscData , _HMG_SYSDATA [ 124 ] ) // nGroupHeaderHeight
	aadd ( aMiscData , _HMG_SYSDATA [ 123 ] ) // nGroupFooterHeight
	aadd ( aMiscData , _HMG_SYSDATA [ 125 ] ) // xGroupExpression
	aadd ( aMiscData , _HMG_SYSDATA [ 206 ] ) // xSkipProcedure
	aadd ( aMiscData , _HMG_SYSDATA [ 207 ] ) // xEOF

	cReportName := _HMG_SYSDATA [162]

	&cReportName := { _HMG_SYSDATA [159] , _HMG_SYSDATA [160] , _HMG_SYSDATA [158] , _HMG_SYSDATA [157] , _HMG_SYSDATA [ 126 ] , _HMG_SYSDATA [ 121 ] , _HMG_SYSDATA [ 122 ] , aMiscData }

Return

* Layout **********************************************************************

Procedure _BeginLayout

	_HMG_SYSDATA [161] := 'LAYOUT'

Return

Procedure _EndLayout

	aadd ( _HMG_SYSDATA [159] , _HMG_SYSDATA [ 155 ] )
	aadd ( _HMG_SYSDATA [159] , _HMG_SYSDATA [ 156 ] )
	aadd ( _HMG_SYSDATA [159] , _HMG_SYSDATA [ 118 ] )
	aadd ( _HMG_SYSDATA [159] , _HMG_SYSDATA [ 119 ] )

Return

* Header **********************************************************************

Procedure _BeginHeader

	_HMG_SYSDATA [161] := 'HEADER'

	_HMG_SYSDATA [160] := {}

Return

Procedure _EndHeader


Return


* Detail **********************************************************************

Procedure _BeginDetail

	_HMG_SYSDATA [161] := 'DETAIL'

	_HMG_SYSDATA [158] := {}

Return

Procedure _EndDetail


Return

* Footer **********************************************************************

Procedure _BeginFooter

	_HMG_SYSDATA [161] := 'FOOTER'

	_HMG_SYSDATA [157] := {}

Return

Procedure _EndFooter


Return

* Summary **********************************************************************

Procedure _BeginSummary

	_HMG_SYSDATA [161] := 'SUMMARY'

Return

Procedure _EndSummary


Return


* Text **********************************************************************

Procedure _BeginText

	_HMG_SYSDATA[116] := ''			// Text
	_HMG_SYSDATA[431] := 0			// Row
	_HMG_SYSDATA[432] := 0			// Col
	_HMG_SYSDATA[420] := 0                  // Width
	_HMG_SYSDATA[421] := 0			// Height
	_HMG_SYSDATA[422] := 'Arial'		// FontName
	_HMG_SYSDATA[423] := 9			// FontSize
	_HMG_SYSDATA[412] := .F.		// FontBold
	_HMG_SYSDATA[413] := .F.		// FontItalic
	_HMG_SYSDATA[415] := .F.		// FontUnderLine
	_HMG_SYSDATA[414] := .F.		// FontStrikeout
	_HMG_SYSDATA[458] := { 0 , 0 , 0 }	// FontColor
	_HMG_SYSDATA[440] := .F.		// Alignment
	_HMG_SYSDATA[393] := .F.		// Alignment

Return

Procedure _EndText

Local aText

	aText := {			  ;
		'TEXT'			, ;
		_HMG_SYSDATA[116]	, ;
		_HMG_SYSDATA[431]	, ;
		_HMG_SYSDATA[432]	, ;
		_HMG_SYSDATA[420]	, ;
		_HMG_SYSDATA[421]	, ;
		_HMG_SYSDATA[422]	, ;
		_HMG_SYSDATA[423]	, ;
		_HMG_SYSDATA[412]	, ;
		_HMG_SYSDATA[413]	, ;
		_HMG_SYSDATA[415]	, ;
		_HMG_SYSDATA[414]	, ;
		_HMG_SYSDATA[458]	, ;
		_HMG_SYSDATA[440]	, ;
		_HMG_SYSDATA[393]	  ;
		}

	If	_HMG_SYSDATA [161] == 'HEADER'

	        aadd ( 	_HMG_SYSDATA [160] , aText )

	ElseIf	_HMG_SYSDATA [161] == 'DETAIL'

	        aadd ( _HMG_SYSDATA [158] , aText )

	ElseIf	_HMG_SYSDATA [161] == 'FOOTER'

	        aadd ( _HMG_SYSDATA [157] , aText )

	ElseIf	_HMG_SYSDATA [161] == 'SUMMARY'

	        aadd ( _HMG_SYSDATA [126] , aText )

	ElseIf	_HMG_SYSDATA [161] == 'GROUPHEADER'

	        aadd ( _HMG_SYSDATA [ 121 ] , aText )

	ElseIf	_HMG_SYSDATA [161] == 'GROUPFOOTER'

	        aadd ( _HMG_SYSDATA [ 122 ] , aText )

	EndIf

Return

* Band Height *****************************************************************

Procedure _BandHeight ( nValue )

	IF	_HMG_SYSDATA [ 161 ] == 'HEADER'

		_HMG_SYSDATA [ 152 ] := nValue

	ELSEIF	_HMG_SYSDATA [ 161 ] == 'DETAIL'

		_HMG_SYSDATA [ 153 ] := nValue

	ELSEIF	_HMG_SYSDATA [ 161 ] == 'FOOTER'

		_HMG_SYSDATA [ 154 ] := nValue

	ELSEIF	_HMG_SYSDATA [ 161 ] == 'SUMMARY'

		_HMG_SYSDATA [ 127 ] := nValue

	ELSEIF	_HMG_SYSDATA [ 161 ] == 'GROUPHEADER'

		_HMG_SYSDATA [ 124 ] := nValue

	ELSEIF	_HMG_SYSDATA [ 161 ] == 'GROUPFOOTER'

		_HMG_SYSDATA [ 123 ] := nValue

	ENDIF

Return

* Execute *********************************************************************

Procedure ExecuteReport ( cReportName , lPreview , lSelect , cOutputFileName )

Local aLayout
Local aHeader
Local aDetail
Local aFooter
Local aSummary
Local aTemp
Local cPrinter
Local nPaperWidth
Local nPaperHeight
Local nOrientation
Local nPaperSize
Local nHeadeHeight
Local nDetailHeight
Local nFooterHeight

Local nCurrentOffset
Local nPreviousRecNo
Local nSummaryHeight
Local aGroupHeader
Local aGroupFooter
Local nGroupHeaderHeight
Local nGroupFooterHeight
Local xGroupExpression
Local nGroupCount
Local xPreviousGroupExpression
Local lGroupStarted
Local aMiscData
Local xTemp
Local aPaper [18] [2]
Local cPdfPaperSize := ''
Local cPdfOrientation := ''
Local nOutfile
Local xSkipProcedure
Local xEOF
Local aReport, lSuccess, lTempEof

	IF _HMG_SYSDATA [ 120 ] > 1
		MsgHMGError('Only One Group Level Allowed')
	ENDIF

	_HMG_SYSDATA [ 149 ] := ''
	_HMG_SYSDATA [ 151 ] := .F.
	_HMG_SYSDATA [ 163 ] := .F.

	If ValType ( cOutputFileName ) == 'C'

		If ALLTRIM ( HMG_UPPER ( HB_URIGHT ( cOutputFileName , 4 ) ) ) == '.PDF'

			_HMG_SYSDATA [ 151 ] := .T.

		ElseIf ALLTRIM ( HMG_UPPER ( HB_URIGHT ( cOutputFileName , 5 ) ) ) == '.HTML'

			_HMG_SYSDATA [ 163 ] := .T.

		EndIf

	EndIf

	IF _HMG_SYSDATA [ 163 ] == .T.

		_HMG_SYSDATA [ 149 ] += '<html>' + CHR(13) + CHR(10)

		_HMG_SYSDATA [ 149 ] += '<style>' + CHR(13) + CHR(10)
		_HMG_SYSDATA [ 149 ] += 'div {position:absolute}' + CHR(13) + CHR(10)
		_HMG_SYSDATA [ 149 ] += '.line { }' + CHR(13) + CHR(10)
		_HMG_SYSDATA [ 149 ] += '</style>' + CHR(13) + CHR(10)

		_HMG_SYSDATA [ 149 ] += '<body>' + CHR(13) + CHR(10)

	ENDIF

	IF _HMG_SYSDATA [ 151 ] == .T.
		aReport := PdfInit()  //  Variable 'AREPORT' is assigned but not used in function. to check PdfInit(). asistex
		pdfOpen( cOutputFileName , 200 , .t. )
	ENDIF

	If ValType ( xSkipProcedure ) = 'U'

		* If not workarea open, cancel report execution

		If Select() == 0
			Return
		EndIf

		nPreviousRecNo := RecNo()

	EndIf

	***********************************************************************
	* Determine Print Parameters
	***********************************************************************

	aTemp := __MVGET ( cReportName )

	aLayout		:= aTemp [1]
	aHeader		:= aTemp [2]
	aDetail		:= aTemp [3]
	aFooter		:= aTemp [4]
	aSummary	:= aTemp [5]
	aGroupHeader	:= aTemp [6]
	aGroupFooter	:= aTemp [7]
	aMiscData	:= aTemp [8]

	nGroupCount		:= aMiscData [1]
	nHeadeHeight		:= aMiscData [2]
	nDetailHeight		:= aMiscData [3]
	nFooterHeight		:= aMiscData [4]
	nSummaryHeight		:= aMiscData [5]
	nGroupHeaderHeight	:= aMiscData [6]
	nGroupFooterHeight	:= aMiscData [7]
	xTemp			:= aMiscData [8]
	xSkipProcedure		:= aMiscData [9]
	xEOF			:= aMiscData [10]

	nOrientation		:= aLayout [1]
	nPaperSize		:= aLayout [2]
	nPaperWidth		:= aLayout [3]
	nPaperHeight		:= aLayout [4]

	If ValType ( lPreview ) <> 'L'
		lPreview := .F.
	EndIf

	If ValType ( lSelect ) <> 'L'
		lSelect := .F.
	EndIf

	IF _HMG_SYSDATA [ 151 ] == .F. .AND. _HMG_SYSDATA [ 163 ] == .F.

		If lSelect == .T.
			cPrinter := GetPrinter()
		Else
			cPrinter := GetDefaultPrinter()
		EndIf

		If Empty (cPrinter)
			Return
		EndIf

	ENDIF

	***********************************************************************
	* Select Printer
	***********************************************************************

	IF _HMG_SYSDATA [ 151 ] == .F. .AND. _HMG_SYSDATA [ 163 ] == .F.

		IF lPreview == .T.

			If nPaperSize == PRINTER_PAPER_USER

				SELECT PRINTER cPrinter			;
					TO lSuccess			;
					ORIENTATION	nOrientation	;
					PAPERSIZE	nPaperSize	;
					PAPERWIDTH	nPaperWidth	;
					PAPERLENGTH	nPaperHeight	;
					PREVIEW

			Else

				SELECT PRINTER cPrinter			;
					TO lSuccess			;
					ORIENTATION	nOrientation	;
					PAPERSIZE	nPaperSize	;
					PREVIEW

			EndIf

		ELSE

			If nPaperSize == PRINTER_PAPER_USER

				SELECT PRINTER cPrinter			;
					TO lSuccess			;
					ORIENTATION	nOrientation	;
					PAPERSIZE	nPaperSize	;
					PAPERWIDTH	nPaperWidth	;
					PAPERLENGTH	nPaperHeight

			Else

				SELECT PRINTER cPrinter			;
					TO lSuccess			;
					ORIENTATION	nOrientation	;
					PAPERSIZE	nPaperSize

			EndIf

		ENDIF

	ENDIF

	***********************************************************************
	* Determine Paper Dimensions in mm.
	***********************************************************************

	If npaperSize >=1 .and. nPaperSize <= 18

/*
		aPaper [ PRINTER_PAPER_LETTER          ] := { 215.9   , 279.4  }
		aPaper [ PRINTER_PAPER_LETTERSMALL     ] := { 215.9   , 279.4  }
		aPaper [ PRINTER_PAPER_TABLOID         ] := { 279.4   , 431.8  }
		aPaper [ PRINTER_PAPER_LEDGER          ] := { 431.8   , 279.4  }
		aPaper [ PRINTER_PAPER_LEGAL           ] := { 215.9   , 355.6  }
		aPaper [ PRINTER_PAPER_STATEMENT       ] := { 139.7   , 215.9  }
		aPaper [ PRINTER_PAPER_EXECUTIVE       ] := { 184.15  , 266.7  }
		aPaper [ PRINTER_PAPER_A3              ] := { 297     , 420    }
		aPaper [ PRINTER_PAPER_A4              ] := { 210     , 297    }
		aPaper [ PRINTER_PAPER_A4SMALL         ] := { 210     , 297    }
		aPaper [ PRINTER_PAPER_A5              ] := { 148     , 210    }
		aPaper [ PRINTER_PAPER_B4              ] := { 250     , 354    }
		aPaper [ PRINTER_PAPER_B5              ] := { 182     , 257    }
		aPaper [ PRINTER_PAPER_FOLIO           ] := { 215.9   , 330.2  }
		aPaper [ PRINTER_PAPER_QUARTO          ] := { 215     , 275    }
		aPaper [ PRINTER_PAPER_10X14           ] := { 254     , 355.6  }
		aPaper [ PRINTER_PAPER_11X17           ] := { 279.4   , 431.8  }
		aPaper [ PRINTER_PAPER_NOTE            ] := { 215.9   , 279.4  }
*/

		aPaper [ 1 ] := { 215.9	, 279.4 }
		aPaper [ 2 ] := { 215.9	, 279.4 }
		aPaper [ 3 ] := { 279.4	, 431.8 }
		aPaper [ 4 ] := { 431.8	, 279.4 }
		aPaper [ 5 ] := { 215.9	, 355.6 }
		aPaper [ 6 ] := { 139.7	, 215.9 }
		aPaper [ 7 ] := { 184.15	, 266.7 }
		aPaper [ 8 ] := { 297	, 420	}
		aPaper [ 9 ] := { 210	, 297	}
		aPaper [ 10 ] := { 210	, 297	}
		aPaper [ 11 ] := { 148	, 210	}
		aPaper [ 12 ] := { 250	, 354	}
		aPaper [ 13 ] := { 182	, 257	}
		aPaper [ 14 ] := { 215.9	, 330.2	}
		aPaper [ 15 ] := { 215	, 275	}
		aPaper [ 16 ] := { 254	, 355.6	}
		aPaper [ 17 ] := { 279.4	, 431.8	}
		aPaper [ 18 ] := { 215.9	, 279.4 }


		If 	nOrientation == PRINTER_ORIENT_PORTRAIT

			// nPaperWidth	:= aPaper [ nPaperSize ] [ 1 ]  //   Variable 'NPAPERWIDTH' is assigned but not used in function
			npaperHeight	:= aPaper [ nPaperSize ] [ 2 ]

		ElseIf	nOrientation == PRINTER_ORIENT_LANDSCAPE

			// nPaperWidth	:= aPaper [ nPaperSize ] [ 2 ]   Variable 'NPAPERWIDTH' is assigned but not used in function
			npaperHeight	:= aPaper [ nPaperSize ] [ 1 ]

		Else

			MsgHMGError('Report: Orientation Not Supported')

		EndIf

	Else

		MsgHMGError('Report: Paper Size Not Supported')

	EndIf


	IF _HMG_SYSDATA [ 151 ] == .T.

		* PDF Paper Size

		If	nPaperSize == PRINTER_PAPER_LETTER

		        cPdfPaperSize := "LETTER"

		ElseIf	nPaperSize == PRINTER_PAPER_LEGAL

		        cPdfPaperSize := "LEGAL"

		ElseIf nPaperSize == PRINTER_PAPER_A4

			cPdfPaperSize := "A4"

		ElseIf nPaperSize == PRINTER_PAPER_TABLOID

			cPdfPaperSize := "LEDGER"

		ElseIf nPaperSize == PRINTER_PAPER_EXECUTIVE

			cPdfPaperSize := "EXECUTIVE"

		ElseIf nPaperSize == PRINTER_PAPER_A3

			cPdfPaperSize := "A3"

		ElseIf nPaperSize == PRINTER_PAPER_ENV_10

			cPdfPaperSize := "COM10"

		ElseIf nPaperSize == PRINTER_PAPER_B4

			cPdfPaperSize := "JIS B4"

		ElseIf nPaperSize == PRINTER_PAPER_B5

			cPdfPaperSize := "B5"

		ElseIf nPaperSize == PRINTER_PAPER_P32K

			cPdfPaperSize := "JPOST"

		ElseIf nPaperSize == PRINTER_PAPER_ENV_C5

			cPdfPaperSize := "C5"

		ElseIf nPaperSize == PRINTER_PAPER_ENV_DL

			cPdfPaperSize := "DL"

		ElseIf nPaperSize == PRINTER_PAPER_ENV_B5

			cPdfPaperSize := "B5"

		ElseIf nPaperSize == PRINTER_PAPER_ENV_MONARCH

			cPdfPaperSize := "MONARCH"

		Else

			MsgHMGError("Report: PDF Paper Size Not Supported")

		EndIf

		* PDF Orientation

		If 	nOrientation == PRINTER_ORIENT_PORTRAIT

			cPdfOrientation := 'P'

		ElseIf	nOrientation == PRINTER_ORIENT_LANDSCAPE

			cPdfOrientation := 'L'

		Else

			MsgHMGError('Report: Orientation Not Supported')

		EndIf

	ENDIF

	***********************************************************************
	* Calculate Bands
	***********************************************************************

	// nBandSpace		:= nPaperHeight - nHeadeHeight - nFooterHeight //   Variable 'NBANDSPACE' is assigned but not used in function

	// nDetailBandsPerPage	:= Int ( nBandSpace / nDetailHeight ) // 'NDETAILBANDSPERPAGE' is assigned but not used in function

	***********************************************************************
	* Print Document
	***********************************************************************

	If nGroupCount > 0

		xGroupExpression := &(xTemp)

	EndIf

	_HMG_SYSDATA [ 117 ] := 1

	IF _HMG_SYSDATA [ 151 ] == .F. .AND. _HMG_SYSDATA [ 163 ] == .F.

		START PRINTDOC

	ENDIF

	If ValType ( xSkipProcedure ) = 'U'
		Go Top
	EndIf

	xPreviousGroupExpression := ''
	lGroupStarted := .f.

	If ValType ( xSkipProcedure ) = 'U'
		lTempEof := Eof()
	Else
		lTempEof := Eval(xEof)
	EndIf

	Do While .Not. lTempEof

		IF _HMG_SYSDATA [ 163 ] == .F.

			IF _HMG_SYSDATA [ 151 ] == .T.

				pdfNewPage( cPdfPaperSize , cPdfOrientation, 6 )

			ELSE

				START PRINTPAGE

			ENDIF

			// nCurrentOffset := 0 // 'NCURRENTOFFSET' is assigned but not used in function

			_ProcessBand ( aHeader , 0 )

			nCurrentOffset := nHeadeHeight

			do while .t.

				If nGroupCount > 0

					If ( valtype (xPreviousGroupExpression) != valtype (xGroupExpression) ) .or. ( xPreviousGroupExpression <> xGroupExpression )

						If lGroupStarted

							_ProcessBand ( aGroupFooter , nCurrentOffset )
							nCurrentOffset += nGroupFooterHeight

						EndIf

						_ProcessBand ( aGroupHeader , nCurrentOffset )
						nCurrentOffset += nGroupHeaderHeight

						xPreviousGroupExpression := xGroupExpression

						lGroupStarted := .T.

					EndIf

				EndIf

				_ProcessBand ( aDetail , nCurrentOffset )

				nCurrentOffset += nDetailHeight

				If ValType ( xSkipProcedure ) = 'U'
					Skip
					lTempEof := Eof()
				Else
					Eval(xSkipProcedure)
					lTempEof := Eval(xEof)
				EndIf

				If lTempEof

					* If group footer defined, print it.

					If nGroupFooterHeight > 0

						* If group footer don't fit in the current page, print page footer,
						* start a new page and print header first

						If nCurrentOffset + nGroupFooterHeight > nPaperHeight - nFooterHeight

							nCurrentOffset := nPaperHeight - nFooterHeight
							_ProcessBand ( aFooter , nCurrentOffset )

							IF _HMG_SYSDATA [ 151 ] == .F.

								END PRINTPAGE
								START PRINTPAGE

							ELSE

								pdfNewPage( cPdfPaperSize , cPdfOrientation, 6 )

							ENDIF

							_HMG_SYSDATA [ 117 ]++

							// nCurrentOffset := 0  // 'NCURRENTOFFSET' is assigned but not used in function
							_ProcessBand ( aHeader , 0 )
							nCurrentOffset := nHeadeHeight

						EndIf

						_ProcessBand ( aGroupFooter , nCurrentOffset )
						nCurrentOffset += nGroupFooterHeight

					EndIf

					* If Summary defined, print it.

					If HMG_LEN ( aSummary ) > 0

						* If summary don't fit in the current page, print footer,
						* start a new page and print header first

						If nCurrentOffset + nSummaryHeight > nPaperHeight - nFooterHeight

							nCurrentOffset := nPaperHeight - nFooterHeight
							_ProcessBand ( aFooter , nCurrentOffset )

							IF _HMG_SYSDATA [ 151 ] == .F.

								END PRINTPAGE
								START PRINTPAGE

							ELSE

								pdfNewPage( cPdfPaperSize , cPdfOrientation, 6 )

							ENDIF

							_HMG_SYSDATA [ 117 ]++

							// nCurrentOffset := 0  //  // 'NCURRENTOFFSET' is assigned but not used in function
							_ProcessBand ( aHeader , 0 )
							nCurrentOffset := nHeadeHeight

						EndIf

						_ProcessBand ( aSummary , nCurrentOffset )

						Exit

					EndIf

					Exit

				EndIf

				If nGroupCount > 0

					xGroupExpression := &(xTemp)

				EndIf

				If nCurrentOffset + nDetailHeight > nPaperHeight - nFooterHeight

					Exit

				EndIf

			EndDo

			nCurrentOffset := nPaperHeight - nFooterHeight

			_ProcessBand ( aFooter , nCurrentOffset )

			IF _HMG_SYSDATA [ 151 ] == .F.

				END PRINTPAGE

			ENDIF

			_HMG_SYSDATA [ 117 ]++

		ELSE

			// nCurrentOffset := 0 // // 'NCURRENTOFFSET' is assigned but not used in function

			_ProcessBand ( aHeader , 0 )

			nCurrentOffset := nHeadeHeight

			do while .t.

				If nGroupCount > 0

					If xPreviousGroupExpression <> xGroupExpression

						If lGroupStarted

							_ProcessBand ( aGroupFooter , nCurrentOffset )
							nCurrentOffset += nGroupFooterHeight

						EndIf

               	_ProcessBand ( aGroupHeader , nCurrentOffset )
						nCurrentOffset += nGroupHeaderHeight

						xPreviousGroupExpression := xGroupExpression

						lGroupStarted := .T.

					EndIf

				EndIf

				_ProcessBand ( aDetail , nCurrentOffset )

				nCurrentOffset += nDetailHeight

				If ValType ( xSkipProcedure ) = 'U'
					Skip
					lTempEof := Eof()
				Else
					Eval(xSkipProcedure)
					lTempEof := Eval(xEof)
				EndIf

				If lTempEof

					* If group footer defined, print it.

					If nGroupFooterHeight > 0

						_ProcessBand ( aGroupFooter , nCurrentOffset )
						nCurrentOffset += nGroupFooterHeight

					EndIf

					* If Summary defined, print it.

					If HMG_LEN ( aSummary ) > 0
						_ProcessBand ( aSummary , nCurrentOffset )
						nCurrentOffset += nSummaryHeight
					EndIf

					Exit

				EndIf

				If nGroupCount > 0
					xGroupExpression := &(xTemp)
				EndIf

			EndDo

			_ProcessBand ( aFooter , nCurrentOffset )

		ENDIF

	EndDo

	IF _HMG_SYSDATA [ 151 ] == .F. .AND. _HMG_SYSDATA [ 163 ] == .F.

		END PRINTDOC

	ELSEIF _HMG_SYSDATA [ 151 ] == .T.

		pdfClose()

	ELSEIF _HMG_SYSDATA [ 163 ] == .T.

		_HMG_SYSDATA [ 149 ] += '</body>' + CHR(13) + CHR(10)
		_HMG_SYSDATA [ 149 ] += '</html>' + CHR(13) + CHR(10)

		nOutfile := FCreate( cOutputFileName , FC_NORMAL)

		FWrite( nOutfile , _HMG_SYSDATA [ 149 ] , HMG_LEN(_HMG_SYSDATA [ 149 ]) )

		FClose(nOutfile)

	ENDIF

	If ValType ( xSkipProcedure ) = 'U'
		Go nPreviousRecNo
	EndIf

Return

*.............................................................................*
Procedure _ProcessBand ( aBand  , nOffset )
*.............................................................................*
Local i

	For i := 1 To HMG_LEN ( aBand )

		_PrintObject ( aBand [i] , nOffset )

	Next i

Return

*.............................................................................*
Procedure _PrintObject ( aObject , nOffset )
*.............................................................................*


	If	aObject [1] == 'TEXT'

		_PrintText( aObject , nOffset )

	ElseIf aObject [1] == 'IMAGE'

		_PrintImage( aObject , nOffset )

	ElseIf aObject [1] == 'LINE'

		_PrintLine( aObject , nOffset )

	ElseIf aObject [1] == 'RECTANGLE'

		_PrintRectangle( aObject , nOffset )

	EndIf


Return

*-----------------------------------------------------------------------------*
Procedure _PrintText( aObject , nOffset )
*-----------------------------------------------------------------------------*

Local cValue		:= aObject [ 2]
Local nRow		:= aObject [ 3]
Local nCol		:= aObject [ 4]
Local nWidth		:= aObject [ 5]
Local nHeight		:= aObject [ 6]
Local cFontname		:= aObject [ 7]
Local nFontSize		:= aObject [ 8]
Local lFontBold		:= aObject [ 9]
Local lFontItalic	:= aObject [10]
Local lFontUnderLine	:= aObject [11]
Local lFOntStrikeout	:= aObject [12]
Local aFontColor	:= aObject [13]
Local lAlignment_1 	:= aObject [14]
Local lAlignment_2 	:= aObject [15]
Local cAlignment	:= ''
Local nFontStyle	:= 0
Local nTextRowFix	:= 5
Local cHtmlAlignment


	cValue := &cValue


	IF _HMG_SYSDATA [ 151 ] == .F. .AND. _HMG_SYSDATA [ 163 ] == .F.

		If	lAlignment_1 == .F. .and.  lAlignment_2 == .T.

			cAlignment	:= 'CENTER'

		ElseIf	lAlignment_1 == .T. .and.  lAlignment_2 == .F.

			cAlignment	:= 'RIGHT'

		ElseIf	lAlignment_1 == .F. .and.  lAlignment_2 == .F.

			cAlignment	:= ''

		EndIf

		_HMG_PRINTER_H_MULTILINE_PRINT ( _HMG_SYSDATA [ 374 ] , nRow  + nOffset , nCol , nRow + nHeight  + nOffset , nCol + nWidth , cFontName , nFontSize , aFontColor[1] , aFontColor[2] , aFontColor[3] , cValue , lFontBold , lFontItalic , lFontUnderline , lFontStrikeout , .T. , .T. , .T. , cAlignment )

	ELSEIF _HMG_SYSDATA [ 163 ] == .T.

		if	ValType (cValue) == "N"

			cValue := ALLTRIM(Str(cValue))

		Elseif	ValType (cValue) == "D"

			cValue := dtoc (cValue)

		Elseif	ValType (cValue) == "L"

			cValue := if ( cValue == .T. , _HMG_SYSDATA [ 371 ] [24] , _HMG_SYSDATA [ 371 ] [25] )

		EndIf

		If	lAlignment_1 == .F. .and.  lAlignment_2 == .T.

			cHtmlAlignment	:= 'center'

		ElseIf	lAlignment_1 == .T. .and.  lAlignment_2 == .F.

			cHtmlAlignment	:= 'RIGHT'

		ElseIf	lAlignment_1 == .F. .and.  lAlignment_2 == .F.

			cHtmlAlignment	:= 'LEFT'

		EndIf

		_HMG_SYSDATA [ 149 ] += '<div style=position:absolute;LEFT:' + ALLTRIM(Str(nCol)) +  'mm;top:' +  ALLTRIM(Str(nRow+nOffset)) + 'mm;width:' +  ALLTRIM(Str(nWidth)) + 'mm;font-size:' + ALLTRIM(Str(nFontSize)) + 'pt;font-family:"' +  cFontname + '";text-align:' + cHtmlAlignment + ';font-weight:' + if(lFontBold,'bold','normal') + ';font-style:' + if(lFontItalic,'italic','normal') + ';text-decoration:' + if(lFontUnderLine,'underline','none') + ';color:rgb(' + ALLTRIM(Str(aFontColor[1])) + ',' + ALLTRIM(Str(aFontColor[2])) + ',' +  ALLTRIM(Str(aFontColor[3])) + ');>' + cValue + '</div>' + CHR(13) + CHR(10)

	ELSEIF _HMG_SYSDATA [ 151 ] == .T.

		if	ValType (cValue) == "N"

			cValue := ALLTRIM(Str(cValue))

		Elseif	ValType (cValue) == "D"

			cValue := dtoc (cValue)

		Elseif	ValType (cValue) == "L"

			cValue := if ( cValue == .T. , _HMG_SYSDATA [ 371 ] [24] , _HMG_SYSDATA [ 371 ] [25] )

		EndIf

		If	lFontBold == .f. .and. lFontItalic == .f.

			nFontStyle := 0

		ElseIf	lFontBold == .t. .and. lFontItalic == .f.

			nFontStyle := 1

		ElseIf	lFontBold == .f. .and. lFontItalic == .t.

			nFontStyle := 2

		ElseIf	lFontBold == .t. .and. lFontItalic == .t.

			nFontStyle := 3

		EndIf

		pdfSetFont( cFontname , nFontStyle , nFontSize )

		If	lAlignment_1 == .F. .and.  lAlignment_2 == .T. // Center

			If lFontUnderLine

				pdfAtSay ( cValue + CHR(254) , nRow + nOffset + nTextRowFix , nCol + ( nWidth - ( pdfTextWidth( cValue ) * 25.4 ) ) / 2  , 'M' )

			Else

				pdfAtSay ( CHR(253) + CHR(aFontColor[1]) + CHR(aFontColor[2]) + CHR(aFontColor[3]) + cValue , nRow + nOffset + nTextRowFix , nCol + ( nWidth - ( pdfTextWidth( cValue ) * 25.4 ) ) / 2  , 'M' )

			EndIf

		ElseIf	lAlignment_1 == .T. .and.  lAlignment_2 == .F. // RIGHT

			If lFontUnderLine

				pdfAtSay ( cValue + CHR(254) , nRow + nOffset + nTextRowFix , nCol + nWidth - pdfTextWidth( cValue ) * 25.4 , 'M' )

			Else

				pdfAtSay ( CHR(253) + CHR(aFontColor[1]) + CHR(aFontColor[2]) + CHR(aFontColor[3]) + cValue , nRow + nOffset + nTextRowFix , nCol + nWidth - pdfTextWidth( cValue ) * 25.4 , 'M' )

			EndIf

		ElseIf	lAlignment_1 == .F. .and.  lAlignment_2 == .F. // LEFT

			If lFontUnderLine

				pdfAtSay ( cValue + CHR(254) , nRow + nOffset + nTextRowFix , nCol , 'M' )

			Else

				pdfAtSay ( CHR(253) + CHR(aFontColor[1]) + CHR(aFontColor[2]) + CHR(aFontColor[3]) + cValue , nRow + nOffset + nTextRowFix , nCol , 'M' )

			EndIf

		EndIf

	ENDIF

Return

*-----------------------------------------------------------------------------*
Procedure _PrintImage( aObject , nOffset )
*-----------------------------------------------------------------------------*
Local cValue		:= aObject [ 2]
Local nRow		:= aObject [ 3]
Local nCol		:= aObject [ 4]
Local nWidth		:= aObject [ 5]
Local nHeight		:= aObject [ 6]
// Local lStretch		:= aObject [ 7]  Variable 'LSTRETCH' is assigned but not used in function

	IF _HMG_SYSDATA [ 151 ] == .F. .AND. _HMG_SYSDATA [ 163 ] == .F.

		_HMG_PRINTER_H_IMAGE ( _HMG_SYSDATA [ 374 ] , cValue , nRow + nOffset , nCol , nHeight , nWidth , .T. )

	ELSEIF _HMG_SYSDATA [ 151 ] == .T.

		IF HMG_UPPER ( hb_URight( cValue , 4 ) ) == '.JPG'

			pdfImage( cValue , nRow + nOffset , nCol , "M" , nHeight , nWidth )

		ELSE

			MsgHMGError("Report: Only JPG images allowed" )

		ENDIF

	ELSEIF _HMG_SYSDATA [ 163 ] == .T.

		_HMG_SYSDATA [ 149 ] += '<div style=position:absolute;LEFT:' + ALLTRIM(Str(nCol)) + 'mm;top:' + ALLTRIM(Str(nRow+nOffset))  + 'mm;> <img src="' + cValue + '" ' + 'width=' + ALLTRIM(Str(nWidth*3.85)) + 'mm height=' + ALLTRIM(Str(nHeight*3.85)) + 'mm/> </div>' + CHR(13) + CHR(10)

	ENDIF

Return

*-----------------------------------------------------------------------------*
Procedure _PrintLine( aObject , nOffset )
*-----------------------------------------------------------------------------*
Local nFromRow		:= aObject [ 2]
Local nFromCol		:= aObject [ 3]
Local nToRow		:= aObject [ 4]
Local nToCol		:= aObject [ 5]
Local nPenWidth		:= aObject [ 6]
Local aPenColor		:= aObject [ 7]

	IF _HMG_SYSDATA [ 151 ] == .F. .AND. _HMG_SYSDATA [ 163 ] == .F.

		_HMG_PRINTER_H_LINE ( _HMG_SYSDATA [ 374 ] , nFromRow + nOffset , nFromCol , nToRow  + nOffset , nToCol , nPenWidth , aPenColor[1] , aPenColor[2] , aPenColor[3]  , .T. , .T. )

	ELSEIF _HMG_SYSDATA [ 151 ] == .T.

		If nFromRow <> nToRow .and. nFromCol <> nToCol
			MsgHMGError('Report: Only horizontal and vertical lines are supported with PDF output')
		EndIf

		pdfBox( nFromRow + nOffset , nFromCol, nToRow + nOffset + nPenWidth , nToCol , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )

	ELSEIF _HMG_SYSDATA [ 163 ] == .T.

		_HMG_SYSDATA [ 149 ] += '<div style="LEFT:' + ALLTRIM(Str(nFromCol)) + 'mm;top:' +  ALLTRIM(Str(nFromRow+nOffset)) +  'mm;width:' +  ALLTRIM(Str(nToCol-nFromCol)) +  'mm;height:0mm;BORDER-STYLE:SOLID;BORDER-COLOR:' + 'rgb(' + ALLTRIM(Str(aPenColor[1])) + ',' + ALLTRIM(Str(aPenColor[2])) + ',' +  ALLTRIM(Str(aPenColor[3])) + ')' + ';BORDER-WIDTH:' + ALLTRIM(Str(nPenWidth)) + 'mm;BACKGROUND-COLOR:#FFFFFF;"><span class="line"></span></DIV>' + CHR(13) + CHR(10)

	ENDIF

Return

*-----------------------------------------------------------------------------*
Procedure _PrintRectangle( aObject , nOffset )
*-----------------------------------------------------------------------------*
Local nFromRow		:= aObject [ 2]
Local nFromCol		:= aObject [ 3]
Local nToRow		:= aObject [ 4]
Local nToCol		:= aObject [ 5]
Local nPenWidth		:= aObject [ 6]
Local aPenColor		:= aObject [ 7]


	IF _HMG_SYSDATA [ 151 ] == .F. .AND. _HMG_SYSDATA [ 163 ] == .F.

		_HMG_PRINTER_H_RECTANGLE ( _HMG_SYSDATA [ 374 ] , nFromRow + nOffset , nFromCol , nToRow  + nOffset , nToCol , nPenWidth , aPenColor[1] , aPenColor[2] , aPenColor[3] , .T. , .T. )

	ELSEIF _HMG_SYSDATA [ 151 ] == .T.

		pdfBox( nFromRow + nOffset , nFromCol, nFromRow + nOffset + nPenWidth , nToCol , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )
		pdfBox( nToRow + nOffset , nFromCol, nToRow + nOffset + nPenWidth , nToCol , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )
		pdfBox( nFromRow + nOffset , nFromCol, nToRow + nOffset , nFromCol + nPenWidth , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )
		pdfBox( nFromRow + nOffset , nToCol, nToRow + nOffset , nToCol + nPenWidth , 0 , 1 , "M" , CHR(253) + CHR(aPenColor[1]) + CHR(aPenColor[2]) + CHR(aPenColor[3]) )

	ELSEIF _HMG_SYSDATA [ 163 ] == .T.

		_HMG_SYSDATA [ 149 ] += '<div style="LEFT:' + ALLTRIM(Str(nFromCol)) + 'mm;top:' +  ALLTRIM(Str(nFromRow+nOffset)) +  'mm;width:' +  ALLTRIM(Str(nToCol-nFromCol)) +  'mm;height:' + ALLTRIM(Str(nToRow-nFromRow)) + 'mm;BORDER-STYLE:SOLID;BORDER-COLOR:' + 'rgb(' + ALLTRIM(Str(aPenColor[1])) + ',' + ALLTRIM(Str(aPenColor[2])) + ',' +  ALLTRIM(Str(aPenColor[3])) + ')' + ';BORDER-WIDTH:' + ALLTRIM(Str(nPenWidth)) + 'mm;BACKGROUND-COLOR:#FFFFFF;"><span class="line"></span></DIV>' + CHR(13) + CHR(10)

	ENDIF

Return

* Line **********************************************************************

Procedure _BeginLine

	_HMG_SYSDATA [ 110 ] := 0		// FromRow
	_HMG_SYSDATA [ 111 ] := 0		// FromCol
	_HMG_SYSDATA [ 112 ] := 0		// ToRow
	_HMG_SYSDATA [ 113 ] := 0		// ToCol
	_HMG_SYSDATA [ 114 ] := 1		// PenWidth
	_HMG_SYSDATA [ 115 ] := { 0 , 0 , 0 }	// PenColor

Return

Procedure _EndLine

Local aLine

	aLine := {			  ;
		'LINE'			, ;
		_HMG_SYSDATA [ 110 ]	, ;
		_HMG_SYSDATA [ 111 ]	, ;
		_HMG_SYSDATA [ 112 ]	, ;
		_HMG_SYSDATA [ 113 ]	, ;
		_HMG_SYSDATA [ 114 ]	, ;
		_HMG_SYSDATA [ 115 ]	  ;
		}

	If	_HMG_SYSDATA [161] == 'HEADER'

	        aadd ( 	_HMG_SYSDATA [160] , aLine )

	ElseIf	_HMG_SYSDATA [161] == 'DETAIL'

	        aadd ( _HMG_SYSDATA [158] , aLine )

	ElseIf	_HMG_SYSDATA [161] == 'FOOTER'

	        aadd ( _HMG_SYSDATA [157] , aLine )

	ElseIf	_HMG_SYSDATA [161] == 'SUMMARY'

	        aadd ( _HMG_SYSDATA [126] , aLine )

	ElseIf	_HMG_SYSDATA [161] == 'GROUPHEADER'

	        aadd ( _HMG_SYSDATA [ 121 ] , aLine )

	ElseIf	_HMG_SYSDATA [161] == 'GROUPFOOTER'

	        aadd ( _HMG_SYSDATA [ 122 ] , aLine )

	EndIf

Return

* Image **********************************************************************

Procedure _BeginImage

	_HMG_SYSDATA[434] := ''   // Value
	_HMG_SYSDATA[431] := 0    // Row
	_HMG_SYSDATA[432] := 0    // Col
	_HMG_SYSDATA[420] := 0    // Width
	_HMG_SYSDATA[421] := 0    // Height
	_HMG_SYSDATA[411] := .F.  // Stretch

Return

Procedure _EndImage

Local aImage

	aImage := {			  ;
		'IMAGE'			, ;
		_HMG_SYSDATA[434]	, ;
		_HMG_SYSDATA[431]	, ;
		_HMG_SYSDATA[432]	, ;
		_HMG_SYSDATA[420]	, ;
		_HMG_SYSDATA[421]	, ;
		_HMG_SYSDATA[411]	  ;
		}

	If	_HMG_SYSDATA [161] == 'HEADER'

	        aadd ( 	_HMG_SYSDATA [160] , aImage )

	ElseIf	_HMG_SYSDATA [161] == 'DETAIL'

	        aadd ( _HMG_SYSDATA [158] , aImage )

	ElseIf	_HMG_SYSDATA [161] == 'FOOTER'

	        aadd ( _HMG_SYSDATA [157] , aImage )

	ElseIf	_HMG_SYSDATA [161] == 'SUMMARY'

	        aadd ( _HMG_SYSDATA [126] , aImage )

	ElseIf	_HMG_SYSDATA [161] == 'GROUPHEADER'

	       // aadd ( _HMG_SYSDATA [ 121 ] , aLine )    // REMOVE
           aadd ( _HMG_SYSDATA [ 121 ] , aImage )      // ADD

	ElseIf	_HMG_SYSDATA [161] == 'GROUPFOOTER'

	      // aadd ( _HMG_SYSDATA [ 122 ] , aLine )    // REMOVE
          aadd ( _HMG_SYSDATA [ 122 ] , aImage )      // ADD

	EndIf

Return

* Rectangle **********************************************************************

Procedure _BeginRectangle

	_HMG_SYSDATA [ 110 ] := 0		// FromRow
	_HMG_SYSDATA [ 111 ] := 0		// FromCol
	_HMG_SYSDATA [ 112 ] := 0		// ToRow
	_HMG_SYSDATA [ 113 ] := 0		// ToCol
	_HMG_SYSDATA [ 114 ] := 1		// PenWidth
	_HMG_SYSDATA [ 115 ] := { 0 , 0 , 0 }	// PenColor

Return

Procedure _EndRectangle

Local aRectangle

	aRectangle := {			  ;
		'RECTANGLE'		, ;
		_HMG_SYSDATA [ 110 ]	, ;
		_HMG_SYSDATA [ 111 ]	, ;
		_HMG_SYSDATA [ 112 ]	, ;
		_HMG_SYSDATA [ 113 ]	, ;
		_HMG_SYSDATA [ 114 ]	, ;
		_HMG_SYSDATA [ 115 ]	  ;
		}

	If	_HMG_SYSDATA [161] == 'HEADER'

	        aadd ( 	_HMG_SYSDATA [160] , aRectangle )

	ElseIf	_HMG_SYSDATA [161] == 'DETAIL'

	        aadd ( _HMG_SYSDATA [158] , aRectangle )

	ElseIf	_HMG_SYSDATA [161] == 'FOOTER'

	        aadd ( _HMG_SYSDATA [157] , aRectangle )

	ElseIf	_HMG_SYSDATA [161] == 'SUMMARY'

	        aadd ( _HMG_SYSDATA [126] , aRectangle )

	ElseIf	_HMG_SYSDATA [161] == 'GROUPHEADER'

	       // aadd ( _HMG_SYSDATA [ 121 ] , aLine )      // REMOVE
           aadd ( _HMG_SYSDATA [ 121 ] , aRectangle )    // ADD

	ElseIf	_HMG_SYSDATA [161] == 'GROUPFOOTER'

	      // aadd ( _HMG_SYSDATA [ 122 ] , aLine )      // REMOVE
          aadd ( _HMG_SYSDATA [ 122 ] , aRectangle )    // ADD

	EndIf

Return

*..............................................................................
Procedure _BeginGroup()
*..............................................................................

	_HMG_SYSDATA [161] := 'GROUP'

	_HMG_SYSDATA [ 120 ]++

Return

*..............................................................................
Procedure _EndGroup()
*..............................................................................

Return

*..............................................................................
Procedure _BeginGroupHeader()
*..............................................................................

	_HMG_SYSDATA [161] := 'GROUPHEADER'

Return

*..............................................................................
Procedure _EndGroupHeader()
*..............................................................................

Return

*..............................................................................
Procedure _BeginGroupFooter()
*..............................................................................

	_HMG_SYSDATA [161] := 'GROUPFOOTER'

Return

*..............................................................................
Procedure _EndGroupFooter()
*..............................................................................

Return

*..............................................................................
Function _dbSum( cField )
*..............................................................................
Local nVar

	if type ( cField ) == 'N'

		SUM &(cField) TO nVar

	Else

		nVar := 0

	EndIf

Return nVar


Procedure _BeginData()
Return

Procedure _EndData()
Return
