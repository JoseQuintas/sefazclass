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
MEMVAR _HMG_FindReplaceOnAction

#include 'hmg.ch'
#include "common.ch"

#define COLOR_BTNFACE   15    // ok

*-----------------------------------------------------------------------------*
Function GetColor ( aDefaultColor, aCustomColors, lFullOpenBox )
*-----------------------------------------------------------------------------*
Local i, aRetVal , nColor , nInitColor

   If ValType ( aDefaultColor ) == "A"
      nInitColor := RGB ( aDefaultColor [1] , aDefaultColor [2] , aDefaultColor [3] )
   EndIf

   If ValType ( aCustomColors ) == "A"
      ASIZE ( aCustomColors, 16 )
      FOR i = 1 TO 16
          IF ValType (aCustomColors [i]) == "A"
             aCustomColors [i] := RGB (aCustomColors [i][1], aCustomColors [i][2], aCustomColors [i][3])
          ELSEIF  ValType (aCustomColors [i]) <> "N"
             aCustomColors [i] := GetSysColor ( COLOR_BTNFACE )
          ENDIF
      NEXT
   EndIf

   IF ValType ( lFullOpenBox ) <> "L"
      lFullOpenBox := .T.
   EndIf

   nColor := ChooseColor( NIL, nInitColor, @aCustomColors, lFullOpenBox )

   If nColor == -1
      aRetVal := { NIL , NIL , NIL }
   Else
      aRetVal := { GetRed(nColor) , GetGreen(nColor), GetBlue (nColor) }
   EndIf

Return aRetVal



*--------------------------------------------------------------------------------------*
Function GetFile( aFilter, title, cIniFolder, multiselect, nochangedir, nFilterIndex )
*--------------------------------------------------------------------------------------*
local c := ''
local cfiles
local fileslist := {}
local n
Local i

	IF aFilter == Nil
		aFilter := {}
	EndIf

   IF title == NIL
      title := ""
   ENDIF

   IF cIniFolder == NIL
      cIniFolder := ""
   ENDIF

	FOR n:=1 TO HMG_LEN(aFilter)
	    c :=  c + aFilter[n][1] + CHR(0) + aFilter[n][2] + CHR(0)
	NEXT
   c :=  c + CHR(0)

	if ValType(multiselect) == 'U'
		multiselect := .f.
	endif

	if .not. multiselect
		Return ( C_GetFile ( c , title, cIniFolder, multiselect ,nochangedir, nFilterIndex ) )
	else
		cfiles := C_GetFile ( c , title, cIniFolder, multiselect ,nochangedir, nFilterIndex )

		if HMG_LEN( cfiles ) > 0
			if ValType( cfiles ) == "A"
				fileslist := aclone( cfiles )
			else
				aadd( fileslist, cfiles )
			endif
		endif

		For i := 1 To HMG_LEN ( FilesList)
			FilesList [i] := HB_UTF8STRTRAN ( FilesList [i] , "\\" , "\" )
		Next i

		Return ( FilesList )

	endif

Return Nil

*-------------------------------------------------------------------------------------------------------*
Function Putfile ( aFilter, cTitle, cIniFolder, lNoChangeDir, cDefaultFileName, cExtFile, nFilterIndex )
*-------------------------------------------------------------------------------------------------------*
LOCAL cFilter:='' , n, cFileName

   IF aFilter == Nil
      aFilter:={}
   EndIf

   IF cTitle == NIL
      cTitle := ""
   ENDIF

   IF cIniFolder == NIL
      cIniFolder := ""
   ENDIF

   IF cDefaultFileName == NIL
      cDefaultFileName := ""
   ENDIF

   FOR n := 1 TO HMG_LEN ( aFilter )
      cFilter = cFilter + aFilter [n] [1] + CHR(0) + aFilter [n] [2] + CHR(0)
   NEXT
   cFilter :=  cFilter + CHR(0)

   cFileName := C_PutFile ( cFilter, cTitle, cIniFolder, lNoChangeDir, cDefaultFileName, @cExtFile, @nFilterIndex )

Return cFileName


*------------------------------------------------------------------------------*
Function GetFont ( cFontName , nFontSize , lBold , lItalic , aFontColor , lUnderLine , lStrikeOut , nCharSet )
*------------------------------------------------------------------------------*
Local RetArray , Tmp , nColor

   If ValType ( cFontName ) == 'U'
      cFontName := ""
   EndIf

   If ValType ( nFontSize ) == 'U'
      nFontSize := 0
   EndIf

   If ValType ( lBold ) == 'U'
      lBold := .F.
   EndIf

   If ValType ( lItalic ) == 'U'
      lItalic := .F.
   EndIf

   If ValType ( aFontColor ) <> 'A'
      nColor := 0
   Else
      nColor := RGB( aFontColor[1] , aFontColor[2] , aFontColor[3] )
   EndIf

   If ValType ( lUnderLine ) == 'U'
      lUnderLine := .F.
   EndIf

   If ValType ( lStrikeOut ) == 'U'
      lStrikeOut := .F.
   EndIf


   RetArray := ChooseFont ( NIL, cFontName , nFontSize , lBold , lItalic , nColor , lUnderLine , lStrikeOut , nCharSet )

   If ! Empty ( RetArray [1] )
      Tmp := RetArray [5]
      RetArray [5] := { GetRed (Tmp) , GetGreen (Tmp) , GetBlue (Tmp) }
   Else
      RetArray [5] := { Nil , Nil , Nil }
   EndIf

Return RetArray



// Dr. Claudio Soto (September 2013)


*-----------------------------------------------------------------------------------------------------------------------------------------------*
Function GetFolder ( cTitle, cInitPath, cInvalidDataMsg, lNewFolderButton, lIncludeFiles, nCSIDL_FolderType, nBIF_Flags )
*-----------------------------------------------------------------------------------------------------------------------------------------------*
LOCAL nFlags, RetVal


//-----------------------------------------
// nCSIDL_FolderType (defined in i_misc.ch)
//-----------------------------------------
// CSIDL (constant special item ID list) values provide a unique system-independent way to identify special
// folders used frequently by applications, but which may not have the same name or location on any given system.

DEFAULT nBIF_Flags            TO  0
DEFAULT lNewFolderButton      TO .T.
DEFAULT lIncludeFiles         TO .F.

IF lNewFolderButton == .F.
   lNewFolderButton := BIF_NONEWFOLDERBUTTON
ELSE
   lNewFolderButton := 0
ENDIF

IF lIncludeFiles == .T.
   lIncludeFiles := BIF_BROWSEINCLUDEFILES
ELSE
   lIncludeFiles := 0
ENDIF


nFlags := HB_BITOR (BIF_NEWDIALOGSTYLE, BIF_EDITBOX, BIF_VALIDATE, lNewFolderButton, lIncludeFiles, nBIF_Flags)

//------------------------------
// nFlags (defined in i_misc.ch)
// -----------------------------
*  Flags set for default

*  BIF_EDITBOX            : Include an edit control in the browse dialog box that allows the user to type the name of an item.
*  BIF_VALIDATE           : If the user types an invalid name into the edit box, the browse dialog box calls the application's BrowseCallbackProc
*                           with the BFFM_VALIDATEFAILED message ( ignored if BIF_EDITBOX is not specified)
*  BIF_NEWDIALOGSTYLE     : Use the new user interface. Setting this flag provides the user with a larger dialog box that can be resized.
*                           The dialog box has several new capabilities, including: drag-and-drop capability within the dialog box,
*                           reordering, shortcut menus, new folders, delete, and other shortcut menu commands.

// BIF_USENEWUI           : equivalent to BIF_EDITBOX + BIF_NEWDIALOGSTYLE.

// BIF_RETURNONLYFSDIRS   : Only return file system directories.
// BIF_DONTGOBELOWDOMAIN  : Do not include network folders below the domain level in the dialog box's tree view control.
// BIF_STATUSTEXT         : Include a status area in the dialog box ( not supported when BIF_NEWDIALOGSTYLE )
// BIF_RETURNFSANCESTORS  : Only return file system ancestors. An ancestor is a subfolder that is beneath the root folder in the namespace hierarchy.
// BIF_BROWSEINCLUDEURLS  : The browse dialog box can display URLs. The BIF_USENEWUI and BIF_BROWSEINCLUDEFILES flags must also be set.
// BIF_UAHINT             : When combined with BIF_NEWDIALOGSTYLE, adds a usage hint to the dialog box, in place of the edit box (BIF_EDITBOX overrides this flag)
// BIF_NONEWFOLDERBUTTON  : Do not include the New Folder button in the browse dialog box.
// BIF_NOTRANSLATETARGETS : When the selected item is a shortcut, return the PIDL of the shortcut itself rather than its target.
// BIF_BROWSEFORCOMPUTER  : Only return computers
// BIF_BROWSEFORPRINTER   : Only allow the selection of printers. In Windows XP and later systems, the best practice is to use a Windows XP-style dialog,
//                          setting the root of the dialog to the Printers and Faxes folder (CSIDL_PRINTERS).
// BIF_BROWSEINCLUDEFILES : The browse dialog box displays files as well as folders.
// BIF_SHAREABLE          : The browse dialog box can display sharable resources on remote systems. The BIF_NEWDIALOGSTYLE flag must also be set.
// BIF_BROWSEFILEJUNCTIONS: Windows 7 and later. Allow folder junctions such as a library or a compressed file with a .zip file name extension to be browsed.

   RetVal := C_GetFolder ( cTitle, nFlags, nCSIDL_FolderType, cInvalidDataMsg, cInitPath )

return RetVal




//********************************************************************
// by Dr. Claudio Soto (January 2014)
//********************************************************************


Procedure FindTextDlg ( OnActionCodeBlock, cFind, lNoUpDown, lNoMatchCase, lNoWholeWord, lCheckDown, lCheckMatchCase, lCheckWholeWord, cTitle )
LOCAL cReplace := NIL

   IF ValType (OnActionCodeBlock) <> "B"
      OnActionCodeBlock := {|| NIL}
   ENDIF

   IF ValType (lCheckDown) <> "L"
      lCheckDown := .T.
   ENDIF

   IF ValType (lCheckMatchCase) <> "L"
      lCheckMatchCase := .F.
   ENDIF

   IF ValType (lCheckWholeWord) <> "L"
      lCheckWholeWord := .F.
   ENDIF

   IF FINDREPLACEDLGISRELEASE () == .F.
      FINDREPLACEDLGRELEASE (.T.)
   ENDIF

   _HMG_FindReplaceOnAction   := OnActionCodeBlock
   FINDREPLACEDLG ( NIL, lNoUpDown, lNoMatchCase, lNoWholeWord, lCheckDown, lCheckMatchCase, lCheckWholeWord, cFind, cReplace, .F., cTitle )
Return



Procedure ReplaceTextDlg ( OnActionCodeBlock, cFind, cReplace, lNoMatchCase, lNoWholeWord, lCheckMatchCase, lCheckWholeWord, cTitle )
LOCAL lNoUpDown  := NIL
LOCAL lCheckDown := NIL

   IF ValType (OnActionCodeBlock) <> "B"
      OnActionCodeBlock := {|| NIL}
   ENDIF

   IF ValType (lCheckMatchCase) <> "L"
      lCheckMatchCase := .F.
   ENDIF

   IF ValType (lCheckWholeWord) <> "L"
      lCheckWholeWord := .F.
   ENDIF

   IF FINDREPLACEDLGISRELEASE () == .F.
      FINDREPLACEDLGRELEASE (.T.)
   ENDIF

   _HMG_FindReplaceOnAction   := OnActionCodeBlock
   FINDREPLACEDLG ( NIL, lNoUpDown, lNoMatchCase, lNoWholeWord, lCheckDown, lCheckMatchCase, lCheckWholeWord, cFind, cReplace, .T., cTitle )
Return



//********************************************************************
// by Dr. Claudio Soto (June 2014)
//********************************************************************

FUNCTION _HMG_VirtualKeyboardGetHandle
__THREAD STATIC hWnd := 0
LOCAL i, nProcessID, aWin
//   IF IsValidWindowHandle (hWnd) == .F.
      hWnd := 0
      aWin := EnumWindows ()
      FOR i = 1 TO HMG_LEN (aWin)
         GetWindowThreadProcessId (aWin[i], NIL, @nProcessID)
         IF HMG_UPPER (VirtualKeyboard.FILENAME) $ HMG_UPPER (GetProcessImageFileName(nProcessID))
            hWnd := aWin[i]
            EXIT
         ENDIF
      NEXT
//   ENDIF
RETURN hWnd
