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
//teste git  2020
---------------------------------------------------------------------------*/
MEMVAR _HMG_SYSDATA
#include "hmg.ch"
#include "fileio.ch"

*-----------------------------------------------------------------------------*
Procedure _hmg_sethelp( cFile )
*-----------------------------------------------------------------------------*
local h

	if ! File( cFile )
		MsgInfo( "Help File "+ cFile + " Not Found" )
		Return 
	endif

	h := FOpen( cFile , FO_READ + FO_SHARED )

	If FError() != 0
		MsgInfo( "Error Opening Help File. Error: " + Str( FError(), 2, 0 ) )
		_HMG_SYSDATA [ 217 ] := ''
	else
		_HMG_SYSDATA [ 217 ] := cFile
	EndIf

	fclose (h)

Return 
*-----------------------------------------------------------------------------*
Procedure _hmg_DisplayHelpTopic ( xTopic , nMet)
*-----------------------------------------------------------------------------*
local cFile

	If Empty(_HMG_SYSDATA [ 217 ])
		Return		
	endif

  _HMG_SYSDATA [ 168 ] := xTopic
	_HMG_SYSDATA [ 170 ]   := nMet

  if HB_URIGHT ( ALLTRIM(HMG_UPPER(_HMG_SYSDATA [ 217 ])) , 4 ) == '.CHM'

    cFile := _HMG_SYSDATA [ 217 ]
    if ValType( xTopic ) == 'C'
      cFile += '::/' + xTopic
    endif
    if nMet == nil
      nMet := 0
    endif
    _Execute( _HMG_SYSDATA [ 181 ] , "open" , "hh.exe" , cFile , , SW_SHOW )

  else

    if xTopic == nil
      xTopic := 0
    endif
    if nMet == nil
      nMet := 0
    endif
    WinHelp( _HMG_SYSDATA [ 181 ] , _HMG_SYSDATA [ 217 ] , 1 , nMet , xTopic )

  endif

Return 
