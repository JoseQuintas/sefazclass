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
*-----------------------------------------------------------------------------*
Function _DefinePlayer(ControlName,ParentForm,file,col,row,w,h,noasw,noasm,noed,nom,noo,nop,sha,shm,shn,shp , HelpId )
*-----------------------------------------------------------------------------*
Local hh , mVar , k

	if _HMG_SYSDATA [ 264 ] = .T.
		ParentForm := _HMG_SYSDATA [ 223 ]
	endif

	if _HMG_SYSDATA [ 183 ] > 0
		IF _HMG_SYSDATA [ 240 ] == .F.
		col 	:= col + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		row 	:= row + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		ParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
		ENDIF
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	Hh :=InitPlayer ( GetFormHandle(ParentForm)	, ;
				file 				, ;
				col 				, ;
				row				, ;
				w				, ;
				h				, ;
				noasw				, ;
				noasm				, ;
				noed				, ;
				nom				, ;
				noo				, ;
				nop				, ;
				sha				, ;
				shm				, ;
				shn				, ;
				shp )

	If _HMG_SYSDATA [ 265 ] = .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , hh )
	EndIf

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1]  [k] := "PLAYER"
	_HMG_SYSDATA [2]  [k] :=  ControlName
	_HMG_SYSDATA [3]  [k] :=  hh
	_HMG_SYSDATA [4]  [k] :=  GetFormHandle(ParentForm)
	_HMG_SYSDATA [  5 ]  [k] :=  0
	_HMG_SYSDATA [  6 ]  [k] :=  ""
	_HMG_SYSDATA [  7 ]  [k] :=  {}
	_HMG_SYSDATA [  8 ]  [k] :=  Nil
	_HMG_SYSDATA [  9 ]  [k] :=  ""
	_HMG_SYSDATA [ 10 ]  [k] :=  ""
	_HMG_SYSDATA [ 11 ]  [k] :=  ""
	_HMG_SYSDATA [ 12 ]  [k] :=  ""
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]  [k] :=  Nil
	_HMG_SYSDATA [ 15 ]  [k] :=  Nil
	_HMG_SYSDATA [ 16 ]   [k] := ""
	_HMG_SYSDATA [ 17 ]  [k] :=  {}
	_HMG_SYSDATA [ 18 ]  [k] :=  row
	_HMG_SYSDATA [ 19 ]  [k] :=  col
	_HMG_SYSDATA [ 20 ]   [k] := w
	_HMG_SYSDATA [ 21 ]  [k] :=  h
	_HMG_SYSDATA [ 22 ]   [k] := 0
	_HMG_SYSDATA [ 23 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]  [k] :=  ""
	_HMG_SYSDATA [ 26 ]  [k] :=  0
	_HMG_SYSDATA [ 27 ]  [k] :=  ''
	_HMG_SYSDATA [ 28 ]  [k] :=  0
	_HMG_SYSDATA [ 29 ]  [k] :=  {.f.,.f.,.f.,.f.}
	_HMG_SYSDATA [ 30 ]   [k] :=  ''
	_HMG_SYSDATA [ 31 ]  [k] :=   0
	_HMG_SYSDATA [ 32 ]  [k] :=   0
	_HMG_SYSDATA [ 33 ]  [k] :=   ''
	_HMG_SYSDATA [ 34 ]  [k] :=   .t.
	_HMG_SYSDATA [ 35 ]  [k] :=   HelpId
	_HMG_SYSDATA [ 36 ]  [k] :=   0
	_HMG_SYSDATA [ 37 ]  [k] :=   0
	_HMG_SYSDATA [ 38 ]  [k] :=   .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

Return Nil
*-----------------------------------------------------------------------------*
Function PlayWave(wave,r,s,ns,l,nd)
*-----------------------------------------------------------------------------*
	if PCount() == 1
		r := .F.
		s := .F.
		ns := .F.
		l := .F.
		nd := .F.
	endif

	c_PlayWave(wave,r,s,ns,l,nd)
Return Nil
*-----------------------------------------------------------------------------*
Function PlayWaveFromResource(wave)
*-----------------------------------------------------------------------------*
	c_PlayWave(wave,.t.,.f.,.f.,.f.,.f.)
Return Nil
*-----------------------------------------------------------------------------*
function _PlayPlayer ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 1 )
Return Nil
*-----------------------------------------------------------------------------*
function _StopPlayer ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 2 )
Return Nil
*-----------------------------------------------------------------------------*
function _PausePlayer ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 3 )
Return Nil
*-----------------------------------------------------------------------------*
function _ClosePlayer ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 4 )
Return Nil
*-----------------------------------------------------------------------------*
function _DestroyPlayer ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 5 )
Return Nil
*-----------------------------------------------------------------------------*
function _EjectPlayer ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 6 )
Return Nil
*-----------------------------------------------------------------------------*
function _SetPlayerPositionEnd ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 7 )
Return Nil
*-----------------------------------------------------------------------------*
function _SetPlayerPositionHome ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 8 )
Return Nil
*-----------------------------------------------------------------------------*
function _OpenPlayer ( ControlName , ParentForm, file )
*-----------------------------------------------------------------------------*
Local h , mVar
 mVar := '_' + ParentForm + '_' + ControlName
 h := _HMG_SYSDATA [3] [&mVar]
 mcifunc ( h , 9, file )
Return Nil
*-----------------------------------------------------------------------------*
function _OpenPlayerDialog ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 10 )
Return Nil
*-----------------------------------------------------------------------------*
function _PlayPlayerReverse ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 11 )
Return Nil
*-----------------------------------------------------------------------------*
function _ResumePlayer ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 12 )
Return Nil
*-----------------------------------------------------------------------------*
function _SetPlayerRepeatOn ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 13 , .T. )
Return Nil
*-----------------------------------------------------------------------------*
function _SetPlayerRepeatOff ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 13 , .F. )
Return Nil
*-----------------------------------------------------------------------------*
function _SetPlayerSpeed ( ControlName , ParentForm , speed )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , , 14 , speed )
Return Nil
*-----------------------------------------------------------------------------*
function _SetPlayerVolume ( ControlName , ParentForm , volume )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 15 , volume )
Return Nil
*-----------------------------------------------------------------------------*
function _SetPlayerZoom ( ControlName , ParentForm , zoom )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 16 , zoom )
Return Nil


*-----------------------------------------------------------------------------*
function _SetPlayerSeek ( ControlName , ParentForm , seek )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	mcifunc ( h , 20 , seek )
Return Nil


*-----------------------------------------------------------------------------*
function _GetPlayerLength ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar, nMCILength
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	nMCILength := mcifunc ( h , 17 )
Return( nMCILength )
*-----------------------------------------------------------------------------*
function _GetPlayerPosition ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar, nMCIPosition
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	nMCIPosition := mcifunc ( h , 18 )
Return( nMCIPosition )

*-----------------------------------------------------------------------------*
function _GetPlayerVolume ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar, nMCIVolume
   mVar := '_' + ParentForm + '_' + ControlName
   h := _HMG_SYSDATA [3] [&mVar]
   nMCIVolume := mcifunc ( h , 19 )
Return( nMCIVolume )



*-----------------------------------------------------------------------------*
Function _DefineAnimateBox(ControlName,ParentForm,col,row,w,h,autoplay,center,transparent,file , HelpId )
*-----------------------------------------------------------------------------*
Local hh , mVar , k

	if _HMG_SYSDATA [ 264 ] = .T.
		ParentForm := _HMG_SYSDATA [ 223 ]
	endif

	if _HMG_SYSDATA [ 183 ] > 0
		IF _HMG_SYSDATA [ 240 ] == .F.
		col 	:= col + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		row 	:= row + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
		ParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
		ENDIF
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated")
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated")
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	hh:=InitAnimate(GetFormHandle(ParentForm),col,row,w,h,autoplay,center,transparent)

	If _HMG_SYSDATA [ 265 ] = .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , hh )
	EndIf

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1] [k] := "ANIMATEBOX"
	_HMG_SYSDATA [2]  [k] :=  ControlName
	_HMG_SYSDATA [3]  [k] :=  hh
	_HMG_SYSDATA [4]   [k] := GetFormHandle(ParentForm)
	_HMG_SYSDATA [  5 ]   [k] := 0
	_HMG_SYSDATA [  6 ]  [k] :=  ""
	_HMG_SYSDATA [  7 ]  [k] :=  {}
	_HMG_SYSDATA [  8 ]  [k] :=  Nil
	_HMG_SYSDATA [  9 ]  [k] :=  ""
	_HMG_SYSDATA [ 10 ]  [k] :=  ""
	_HMG_SYSDATA [ 11 ]  [k] :=  ""
	_HMG_SYSDATA [ 12 ]  [k] :=  ""
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]  [k] :=  Nil
	_HMG_SYSDATA [ 15 ]  [k] :=  Nil
	_HMG_SYSDATA [ 16 ]  [k] :=  ""
	_HMG_SYSDATA [ 17 ]  [k] :=  {}
	_HMG_SYSDATA [ 18 ]  [k] :=  row
	_HMG_SYSDATA [ 19 ]  [k] :=  col
	_HMG_SYSDATA [ 20 ]   [k] := w
	_HMG_SYSDATA [ 21 ]   [k] := h
	_HMG_SYSDATA [ 22 ]   [k] := 0
	_HMG_SYSDATA [ 23 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
	_HMG_SYSDATA [ 25 ]  [k] :=  ""
	_HMG_SYSDATA [ 26 ]   [k] := 0
	_HMG_SYSDATA [ 27 ]  [k] :=  ''
	_HMG_SYSDATA [ 28 ]  [k] :=  0
	_HMG_SYSDATA [ 29 ]  [k] :=  {.f.,.f.,.f.,.f.}
	_HMG_SYSDATA [ 30 ]   [k] :=  ''
	_HMG_SYSDATA [ 31 ]  [k] :=   0
	_HMG_SYSDATA [ 32 ]  [k] :=   0
	_HMG_SYSDATA [ 33 ]  [k] :=   ''
	_HMG_SYSDATA [ 34 ]  [k] :=   .t.
	_HMG_SYSDATA [ 35 ]  [k] :=   HelpId
	_HMG_SYSDATA [ 36 ]   [k] :=  0
	_HMG_SYSDATA [ 37 ]  [k] :=   0
	_HMG_SYSDATA [ 38 ]  [k] :=  .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

	if ValType(file) <> 'U'
		_OpenAnimateBox ( ControlName , ParentForm , File )
	EndIf

Return Nil

*-----------------------------------------------------------------------------*
function _OpenAnimateBox ( ControlName , ParentForm , FileName )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	openanimate ( h , FileName )
Return Nil

*-----------------------------------------------------------------------------*
function _PlayAnimateBox ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	playanimate ( h )
Return Nil

*-----------------------------------------------------------------------------*
function _SeekAnimateBox ( ControlName , ParentForm , Frame )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	seekanimate ( h , Frame )
Return Nil

*-----------------------------------------------------------------------------*
function _StopAnimateBox ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	stopanimate ( h )
Return Nil

*-----------------------------------------------------------------------------*
function _CloseAnimateBox ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	closeanimate ( h )
Return Nil

*-----------------------------------------------------------------------------*
function _DestroyAnimateBox ( ControlName , ParentForm )
*-----------------------------------------------------------------------------*
Local h , mVar
	mVar := '_' + ParentForm + '_' + ControlName
	h := _HMG_SYSDATA [3] [&mVar]
	destroyanimate ( h )
Return Nil
