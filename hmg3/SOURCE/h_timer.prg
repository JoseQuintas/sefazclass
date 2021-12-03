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
Function _DefineTimer ( ControlName ,ParentForm , Interval , ProcedureName )
*-----------------------------------------------------------------------------*
Local mVar , k
Local id

	if _HMG_SYSDATA [ 264 ] = .T.
		ParentForm := _HMG_SYSDATA [ 223 ]
	endif

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
	Endif

	If _IsControlDefined (ControlName,ParentForm)
		MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program Terminated" )
	endif

	mVar := '_' + ParentForm + '_' + ControlName

	Id := _GetId()
	InitTimer ( GetFormhandle(ParentForm) , id , Interval )

	k := _GetControlFree()

	Public &mVar. := k

	_HMG_SYSDATA [1] [k] := "TIMER"
	_HMG_SYSDATA [2] [k] :=   ControlName
	_HMG_SYSDATA [3] [k] :=   0
	_HMG_SYSDATA [4] [k] :=   GetFormhandle(HMG_UPPER(ParentForm))
	_HMG_SYSDATA [  5 ] [k] :=   id
	_HMG_SYSDATA [  6 ]  [k] :=  ProcedureName
	_HMG_SYSDATA [  7 ]  [k] :=  {}
	_HMG_SYSDATA [  8 ]  [k] :=  Interval
	_HMG_SYSDATA [  9 ]  [k] :=  ""
	_HMG_SYSDATA [ 10 ]  [k] :=  ""
	_HMG_SYSDATA [ 11 ]  [k] :=  ""
	_HMG_SYSDATA [ 12 ]  [k] :=  ""
	_HMG_SYSDATA [ 13 ]  [k] :=  .F.
	_HMG_SYSDATA [ 14 ]   [k] := Nil
	_HMG_SYSDATA [ 15 ]   [k] := Nil
	_HMG_SYSDATA [ 16 ]   [k] := ""
	_HMG_SYSDATA [ 17 ]   [k] := {}
	_HMG_SYSDATA [ 18 ]  [k] :=  0
	_HMG_SYSDATA [ 19 ]  [k] :=  0
	_HMG_SYSDATA [ 20 ]   [k] := 0
	_HMG_SYSDATA [ 21 ]  [k] :=  0
	_HMG_SYSDATA [ 22 ]  [k] :=  0
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
	_HMG_SYSDATA [ 35 ]  [k] :=   0
	_HMG_SYSDATA [ 36 ]  [k] :=   NIL
	_HMG_SYSDATA [ 37 ]  [k] :=  0
	_HMG_SYSDATA [ 38 ]  [k] :=   .T.
	_HMG_SYSDATA [ 39 ] [k] := 0
	_HMG_SYSDATA [ 40 ] [k] := { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

Return Nil

