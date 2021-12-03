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
	Copyright 1999-2008, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net>

	"HWGUI"
  	Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/
MEMVAR _HMG_SYSDATA
#include "hmg.ch"
#include "common.ch"
*-----------------------------------------------------------------------------*
Function _DefineMonthCal ( ControlName, ParentForm, x, y, w, h, value, ;
                           fontname, fontsize, tooltip, notoday, notodaycircle, ;
                           weeknumbers, change, HelpId, invisible, notabstop, ;
                           bold, italic, underline, strikeout, ;
                           fontcolor, outerfontcolor, backcolor, ;
                           bordercolor, titlefontcolor, titlebackcolor, ;
                           rangemin, rangemax, view, getbolddays )
*-----------------------------------------------------------------------------*
Local cParentForm , mVar , k
Local aControlHandle
Local cParentTabName

   DEFAULT w           TO 0
   DEFAULT h           TO 0
   DEFAULT value       TO Date()
   DEFAULT change      TO ""
   DEFAULT bold        TO FALSE
   DEFAULT italic      TO FALSE
   DEFAULT underline   TO FALSE
   DEFAULT strikeout   TO FALSE
   DEFAULT getbolddays TO ""

	if _HMG_SYSDATA [ 264 ] = .T.
		ParentForm := _HMG_SYSDATA [ 223 ]
		if .Not. Empty (_HMG_SYSDATA [ 224 ]) .And. ValType(FontName) == "U"
			FontName := _HMG_SYSDATA [ 224 ]
		EndIf
		if .Not. Empty (_HMG_SYSDATA [ 182 ]) .And. ValType(FontSize) == "U"
			FontSize := _HMG_SYSDATA [ 182 ]
		EndIf
	endif
	if _HMG_SYSDATA [ 183 ] > 0
		IF _HMG_SYSDATA [ 240 ] == .F.
		x 	:= x + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		y 	:= y + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		ParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
		cParentTabName := _HMG_SYSDATA [ 225 ]
		ENDIF
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program terminated")
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
    aControlHandle := InitMonthCal ( ParentForm, 0, x, y, w, h , fontname , fontsize , notoday , notodaycircle , weeknumbers, invisible, notabstop, bold, italic, underline, strikeout, !empty( getbolddays ) )
	Else
    aControlHandle := InitMonthCal ( ParentForm, 0, x, y, w, h , _HMG_SYSDATA [ 342 ] , _HMG_SYSDATA [ 343 ] , notoday , notodaycircle , weeknumbers, invisible, notabstop, bold, italic, underline, strikeout, !empty( getbolddays ) )
	endif

  if ISVISTA() .And. IsAppThemed()
    SetWindowTheme(aControlHandle[1], "", "")
  endif

  if w != 0 .and. h != 0
    SetWindowPos(aControlHandle[1], NIL, x, y, w, h, SWP_NOZORDER)
  endif

	If _HMG_SYSDATA [ 265 ] = .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , aControlhandle[1] )
	EndIf

	w := GetWindowWidth ( aControlHandle[1] )
	h := GetWindowHeight ( aControlHandle[1] )

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1] [k] := "MONTHCAL"
	_HMG_SYSDATA [2]  [k] :=  ControlName
	_HMG_SYSDATA [3]  [k] :=  aControlHandle[1]
	_HMG_SYSDATA [4] [k] :=   ParentForm
	_HMG_SYSDATA [  5 ]  [k] :=  0
	_HMG_SYSDATA [  6 ]  [k] :=  ""
	_HMG_SYSDATA [  7 ]  [k] :=  {}
	_HMG_SYSDATA [  8 ]  [k] :=  Nil
	_HMG_SYSDATA [  9 ]  [k] :=  ""
	_HMG_SYSDATA [ 10 ]  [k] :=  ""
	_HMG_SYSDATA [ 11 ]  [k] :=  ""
	_HMG_SYSDATA [ 12 ]  [k] :=  change
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]  [k] :=  Nil
	_HMG_SYSDATA [ 15 ]  [k] :=  Nil
	_HMG_SYSDATA [ 16 ]  [k] :=  ""
	_HMG_SYSDATA [ 17 ]  [k] :=  {}
	_HMG_SYSDATA [ 18 ]  [k] :=  y
	_HMG_SYSDATA [ 19 ]   [k] := x
	_HMG_SYSDATA [ 20 ]   [k] := w
	_HMG_SYSDATA [ 21 ]   [k] := h
  _HMG_SYSDATA [ 22 ]   [k] := iif ( view == NIL, 0, view )
	_HMG_SYSDATA [ 23 ]   [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]  [k] :=  ""
	_HMG_SYSDATA [ 26 ]  [k] :=  0
	_HMG_SYSDATA [ 27 ]  [k] :=  fontname
	_HMG_SYSDATA [ 28 ]  [k] :=  fontsize
	_HMG_SYSDATA [ 29 ]  [k] :=  {bold,italic,underline,strikeout}
	_HMG_SYSDATA [ 30 ]   [k] :=  tooltip
	_HMG_SYSDATA [ 31 ]  [k] :=   cParentTabName
  _HMG_SYSDATA [ 32 ]  [k] :=   iif ( HB_ISDATE( rangemax ), rangemax, d"0000-00-00" )
	_HMG_SYSDATA [ 33 ]   [k] :=  ''
	_HMG_SYSDATA [ 34 ]  [k] :=   if(invisible,FALSE,TRUE)
	_HMG_SYSDATA [ 35 ]  [k] :=   HelpId
	_HMG_SYSDATA [ 36 ]  [k] :=   aControlHandle[2]
  _HMG_SYSDATA [ 37 ]  [k] :=   iif ( HB_ISDATE( rangemin ), rangemin, d"0000-00-00" )
	_HMG_SYSDATA [ 38 ]  [k] :=   .T.
  _HMG_SYSDATA [ 39 ] [k] := getbolddays
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

  SetMonthCal( aControlHandle[1] ,year(value), month(value), day(value) )

  if valtype(tooltip) != "U"
    SetToolTip ( aControlHandle[1] , tooltip , GetFormToolTipHandle (cParentForm) )
  endif

  IF IsArrayRGB( fontcolor )
     SendMessage( aControlHandle[1], MCM_SETCOLOR, MCSC_TEXT, RGB( fontcolor[1], fontcolor[2], fontcolor[3] ) )
  ENDIF
  IF IsArrayRGB( outerfontcolor )
     SendMessage( aControlHandle[1], MCM_SETCOLOR, MCSC_TRAILINGTEXT, RGB (outerfontcolor[1], outerfontcolor[2], outerfontcolor[3] ) )
  ENDIF
  IF IsArrayRGB( backcolor )
     SendMessage( aControlHandle[1], MCM_SETCOLOR, MCSC_MONTHBK, RGB (backcolor[1], backcolor[2], backcolor[3] ) )
  ENDIF
  IF IsArrayRGB( bordercolor )
     SendMessage( aControlHandle[1], MCM_SETCOLOR, MCSC_BACKGROUND, RGB (bordercolor[1], bordercolor[2], bordercolor[3] ) )
  ENDIF
  IF IsArrayRGB( titlefontcolor )
     SendMessage( aControlHandle[1], MCM_SETCOLOR, MCSC_TITLETEXT, RGB (titlefontcolor[1], titlefontcolor[2], titlefontcolor[3] ) )
  ENDIF
  IF IsArrayRGB( titlebackcolor )
     SendMessage( aControlHandle[1], MCM_SETCOLOR, MCSC_TITLEBK, RGB (titlebackcolor[1], titlebackcolor[2], titlebackcolor[3] ) )
  ENDIF

  IF HB_ISDATE( rangemin )
    SetMonthCalMin( aControlHandle[1] , YEAR(rangemin), MONTH(rangemin), DAY(rangemin) )
    rangemax := NIL
  ENDIF
  IF HB_ISDATE( rangemax )
    SetMonthCalMax( aControlHandle[1] , YEAR(rangemax), MONTH(rangemax), DAY(rangemax) )
    rangemin := NIL
  ENDIF
  IF HB_ISNUMERIC( view ) .AND. view >= 0 .AND. view <= MCMV_MAX
     SendMessage( aControlHandle[1], MCM_SETCURRENTVIEW, 0, view )
  ENDIF

Return Nil

FUNCTION GetMonthCalendarVisibleMin (cControlName, cParentName)
  LOCAL dMin, dMax
  GetMonthCalVisible ( GetControlHandle (cControlName, cParentName), @dMin, @dMax )
  RETURN dMin

FUNCTION GetMonthCalendarVisibleMax (cControlName, cParentName)
  LOCAL dMin, dMax
  GetMonthCalVisible ( GetControlHandle (cControlName, cParentName), @dMin, @dMax )
  RETURN dMax

FUNCTION GetMonthCalendarView (cControlName, cParentName)
  LOCAL nView := SendMessage( GetControlHandle (cControlName, cParentName), MCM_GETCURRENTVIEW, 0, 0 )
  RETURN nView

FUNCTION SetMonthCalendarView (cControlName, cParentName, nView)
  LOCAL nStatus := SendMessage( GetControlHandle (cControlName, cParentName), MCM_SETCURRENTVIEW, 0, nView )
  RETURN !EMPTY(nStatus)

FUNCTION GetMonthCalendarColor (cControlName, cParentName, nIndexColor)
  LOCAL nRGBcolor := SendMessage( GetControlHandle (cControlName, cParentName), MCM_GETCOLOR, nIndexColor )
  RETURN { GETRED (nRGBcolor), GETGREEN (nRGBcolor), GETBLUE (nRGBcolor) }

FUNCTION SetMonthCalendarColor (cControlName, cParentName, nIndexColor, aRGBcolor)
  LOCAL nRGBcolor := SendMessage( GetControlHandle (cControlName, cParentName), MCM_SETCOLOR, nIndexColor, RGB( aRGBcolor[1], aRGBcolor[2], aRGBcolor[3] ) )
  RETURN { GETRED (nRGBcolor), GETGREEN (nRGBcolor), GETBLUE (nRGBcolor) }

PROCEDURE SetMonthCalendarBoldDays(i, lParam)
  LOCAL dStart, dEnd, nMonths, adBold, anBold
  IF HB_ISBLOCK( _HMG_SYSDATA [ 39 ] [i] )
    GetMonthCalVisible(GetHwndFrom(lParam), @dStart, @dEnd)
    InitBoldDays(lParam, @dStart, @nMonths)
    adBold := EVAL( _HMG_SYSDATA [ 39 ] [i], dStart, dEnd )
    anBold := BoldDaysNumericArray(dStart, dEnd, nMonths, adBold)
    SetBoldDays(lParam, anBold)
  ENDIF
  RETURN

FUNCTION BoldDaysNumericArray(dStart, dEnd, nMonths, adBold)
  LOCAL nStartMonths := YEAR(dStart) * 12 + MONTH(dStart) - 1
  LOCAL anBold       := AFILL(ARRAY(nMonths), 0)
  LOCAL dBold, nBoldMonths, nMonth
  IF HB_ISARRAY(adBold)
    FOR EACH dBold IN adBold
      BEGIN SEQUENCE
        IF !HB_ISDATE(dBold) .OR. dBold < dStart .OR. dBold > dEnd
          BREAK
        END
        nBoldMonths := YEAR(dBold) * 12 + MONTH(dBold) - 1
        nMonth      := nBoldMonths - nStartMonths + 1
        IF nMonth < 1 .OR. nMonth > nMonths
          BREAK
        END
        anBold[nMonth] := HB_BITSET(anBold[nMonth], DAY(dBold) - 1)
      END SEQUENCE
    NEXT
  END
  RETURN anBold
