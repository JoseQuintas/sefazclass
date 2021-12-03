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


/*
#define CSIDL_DESKTOP                   0x0000    // ok    // <desktop>
#define CSIDL_INTERNET                  0x0001    // ok    // Internet Explorer (icon on desktop)
#define CSIDL_PROGRAMS                  0x0002    // ok    // Start Menu\Programs
#define CSIDL_CONTROLS                  0x0003    // ok    // My Computer\Control Panel
#define CSIDL_PRINTERS                  0x0004    // ok    // My Computer\Printers
#define CSIDL_PERSONAL                  0x0005    // ok    // My Documents
#define CSIDL_FAVORITES                 0x0006    // ok    // <user name>\Favorites
#define CSIDL_STARTUP                   0x0007    // ok    // Start Menu\Programs\Startup
#define CSIDL_RECENT                    0x0008    // ok    // <user name>\Recent
#define CSIDL_SENDTO                    0x0009    // ok    // <user name>\SendTo
#define CSIDL_BITBUCKET                 0x000a     // ok   // <desktop>\Recycle Bin
#define CSIDL_STARTMENU                 0x000b     // ok   // <user name>\Start Menu
#define CSIDL_MYMUSIC                  13         // ok
#define CSIDL_MYVIDEO                  14         // ok
#define CSIDL_DESKTOPDIRECTORY          0x0010      // ok  // <user name>\Desktop
#define CSIDL_DRIVES                    0x0011    // ok    // My Computer
#define CSIDL_NETWORK                   0x0012    // ok    // Network Neighborhood
#define CSIDL_NETHOOD                   0x0013    // ok    // <user name>\nethood
#define CSIDL_FONTS                     0x0014    // ok    // windows\fonts
#define CSIDL_TEMPLATES                 0x0015     // ok
#define CSIDL_COMMON_STARTMENU          0x0016      // ok  // All Users\Start Menu
#define CSIDL_COMMON_PROGRAMS           0X0017      // ok   // All Users\Programs
#define CSIDL_COMMON_STARTUP            0x0018      // ok  // All Users\Startup
#define CSIDL_COMMON_DESKTOPDIRECTORY   0x0019        // ok // All Users\Desktop
#define CSIDL_APPDATA                   0x001a    // ok      // <user name>\Application Data
#define CSIDL_PRINTHOOD                 0x001b    // ok    // <user name>\PrintHood
#define CSIDL_LOCAL_APPDATA             0x001c     // ok   // <user name>\Local Settings\Applicaiton Data (non roaming)
#define CSIDL_ALTSTARTUP                0x001d    // ok    // non localized startup
#define CSIDL_COMMON_ALTSTARTUP         0x001e     // ok   // non localized common startup
#define CSIDL_COMMON_FAVORITES          0x001f     // ok
#define CSIDL_INTERNET_CACHE            0x0020     // ok
#define CSIDL_COOKIES                   0x0021    // ok
#define CSIDL_HISTORY                   0x0022    // ok
#define CSIDL_COMMON_APPDATA            0x0023     // ok   // All Users\Application Data
#define CSIDL_WINDOWS                   0x0024    // ok    // GetWindowsDirectory()
#define CSIDL_SYSTEM                    0x0025   // ok     // GetSystemDirectory()
#define CSIDL_PROGRAM_FILES             0x0026     // ok   // C:\Program Files
#define CSIDL_MYPICTURES                0x0027    // ok    // C:\Program Files\My Pictures
#define CSIDL_PROFILE                   0x0028   // ok     // USERPROFILE
#define CSIDL_SYSTEMX86                 0x0029   // ok     // x86 system directory on RISC
#define CSIDL_PROGRAM_FILESX86          0x002a   // ok     // x86 C:\Program Files on RISC
#define CSIDL_PROGRAM_FILES_COMMON      0x002b   // ok     // C:\Program Files\Common
#define CSIDL_PROGRAM_FILES_COMMONX86   0x002c    // ok    // x86 Program Files\Common on RISC
#define CSIDL_COMMON_TEMPLATES          0x002d   // ok     // All Users\Templates
#define CSIDL_COMMON_DOCUMENTS          0x002e   // ok     // All Users\Documents
#define CSIDL_COMMON_ADMINTOOLS         0x002f   // ok     // All Users\Start Menu\Programs\Administrative Tools
#define CSIDL_ADMINTOOLS               0x0030  // ok      // <user name>\Start Menu\Programs\Administrative Tools
#define CSIDL_CONNECTIONS              0x0031  // ok      // Network and Dial-up Connections
#define CSIDL_COMMON_MUSIC             53     // ok
#define CSIDL_COMMON_PICTURES           54     // ok
#define CSIDL_COMMON_VIDEO              55    // ok
#define CSIDL_RESOURCES                56    // ok
#define CSIDL_RESOURCES_LOCALIZED        57    // ok
#define CSIDL_COMMON_OEM_LINKS          58    // ok
#define CSIDL_CDBURN_AREA              59    // ok
#define CSIDL_COMPUTERSNEARME           61    // ok
#define CSIDL_FLAG_CREATE               0x8000  // ok      // combine with CSIDL_ value to force folder creation in SHGetFolderPath()
#define CSIDL_FLAG_DONT_VERIFY          0x4000   // ok     // combine with CSIDL_ value to return an unverified folder path
#define CSIDL_FLAG_MASK                 0xFF00  // ok      // mask for all possible flag values
*/


*-----------------------------------------------------------------------------*
Function GetWindowsFolder()
*-----------------------------------------------------------------------------*
local lfolder
    lFolder := GETWINDOWSDIR()
return lfolder


*-----------------------------------------------------------------------------*
Function GetSystemFolder()
*-----------------------------------------------------------------------------*
local lfolder
  lfolder:=GETSYSTEMDIR()
return lfolder


*-----------------------------------------------------------------------------*
Function GetTempFolder()
*-----------------------------------------------------------------------------*
local lfolder
  lfolder:=GETTEMPDIR()
return lfolder


*-----------------------------------------------------------------------------*
Function GetMyDocumentsFolder()
*-----------------------------------------------------------------------------*
local lfolder
  lfolder:=getspecialfolder(CSIDL_PERSONAL)
return lfolder


*-----------------------------------------------------------------------------*
Function GetDesktopFolder()
*-----------------------------------------------------------------------------*
local lfolder
  lfolder:=getspecialfolder(CSIDL_DESKTOPDIRECTORY)
return lfolder


*-----------------------------------------------------------------------------*
Function GetProgramFilesFolder()
*-----------------------------------------------------------------------------*
local lfolder
  lfolder:=getspecialfolder(CSIDL_PROGRAM_FILES)
return lfolder
*-----------------------------------------------------------------------------*


*-----------------------------------------------------------------------------*
Function GETSPECIALFOLDER(nCSIDL) // Contributed By Ryszard Rylko
*-----------------------------------------------------------------------------*
Local   RetVal
	RetVal:=C_getspecialfolder(nCSIDL)
return RetVal


*-----------------------------------------------------------------------------*
Function WindowsVersion()
*-----------------------------------------------------------------------------*
LOCAL   aRetVal
aRetVal := WinVersion()
RETURN { aRetVal [1] + aRetVal [4] , aRetVal [2] , 'Build ' + aRetVal [3] }


*-----------------------------------------------------------------------------*
Function _Execute( nActiveWindowhandle , cOperation , cFile , cParaMeters , cDefault , nState )
*-----------------------------------------------------------------------------*

	If ValType ( nActiveWindowhandle ) == 'U'
		nActiveWindowhandle := 0
	EndIf

	If ValType ( cOperation ) == 'U'
		cOperation := Nil
	EndIf

	If ValType ( cFile ) == 'U'
		cFile := ""
	EndIf

	If ValType ( cParaMeters ) == 'U'
		cParaMeters := Nil
	EndIf

	If ValType ( cDefault ) == 'U'
		 cDefault := Nil
	EndIf

	If ValType ( nState ) == 'U'
		 nState := 10 // SW_SHOWDEFAULT
	EndIf

	ShellExecute ( nActiveWindowhandle , cOperation , cFile , cParaMeters , cDefault , nState )

RETURN Nil



*****************************************************************
* by Dr. Claudio Soto (June 2014)
*****************************************************************


//       HMG_GetOnKeyControlIndex ( [ @nSubIndex ] ) --> nIndex
FUNCTION HMG_GetOnKeyControlIndex (VarRef, i, k)
__THREAD STATIC nIndex := 0, nSubIndex := 0
   IF ValType (i) == "N"
      nIndex := i
   ENDIF
   IF ValType (k) == "N"
      nSubIndex := k
   ENDIF
   VarRef := nSubIndex
RETURN nIndex


//       HMG_GetOnMouseControlIndex ( [ @nSubIndex ] ) --> nIndex
FUNCTION HMG_GetOnMouseControlIndex (VarRef, i, k)
__THREAD STATIC nIndex := 0, nSubIndex := 0
   IF ValType (i) == "N"
      nIndex := i
   ENDIF
   IF ValType (k) == "N"
      nSubIndex := k
   ENDIF
   VarRef := nSubIndex
RETURN nIndex


FUNCTION _HMG_OnKey_OnMouse_Controls
LOCAL i:=0, k, nSubIndex1:=0, ret := NIL

   IF ( EventIsKeyboardMessage() == .T. .OR. EventIsMouseMessage() == .T. ) .AND.  EventIsHMGWindowsMessage() == .F.

      FOR k = 1 TO HMG_LEN (_HMG_SYSDATA [3])
         IF HMG_CompareHandle (_HMG_SYSDATA [3] [k],  EventHWND(), @nSubIndex1) == .T.
            i := k
            EXIT
         ENDIF
      NEXT

      IF i > 0 .AND. EventIsKeyboardMessage() == .T.
         IF ValType ( _HMG_SYSDATA [41] [i] [1]) == "B"
            HMG_GetOnKeyControlIndex (NIL, i, nSubIndex1)
            ret := EVAL ( _HMG_SYSDATA [41] [i] [1])   // OnKey Event
         ENDIF
      ENDIF

      IF i > 0 .AND. EventIsMouseMessage() == .T.
         IF ValType ( _HMG_SYSDATA [41] [i] [2]) == "B"
            HMG_GetOnMouseControlIndex (NIL, i, nSubIndex1)
            ret := EVAL ( _HMG_SYSDATA [41] [i] [2])   // OnMouse Event
         ENDIF
      ENDIF

      HMG_GetOnKeyControlIndex   (NIL, 0, 0)
      HMG_GetOnMouseControlIndex (NIL, 0, 0)

   ENDIF
RETURN ret


FUNCTION _HMG_SetControlData (cControlName, cFormName, nIndex, nSubIndex, xData)
LOCAL i := GetControlIndex (cControlName, cFormName)
   IF i > 0
      IF ValType (nSubIndex) == "N" .AND. nSubIndex > 0
         _HMG_SYSDATA [nIndex] [i] [nSubIndex] := xData
      ELSE
         _HMG_SYSDATA [nIndex] [i] := xData
      ENDIF
   ELSE
      RETURN .F.
   ENDIF
RETURN .T.


FUNCTION _HMG_GetControlData (cControlName, cFormName, nIndex, nSubIndex, xData)
LOCAL i := GetControlIndex (cControlName, cFormName)
   IF i > 0
      IF ValType (nSubIndex) == "N" .AND. nSubIndex > 0
         _HMG_SYSDATA [nIndex] [i] [nSubIndex] := xData
      ELSE
         _HMG_SYSDATA [nIndex] [i] := xData
      ENDIF
   ELSE
      RETURN .F.
   ENDIF
RETURN .T.


PROCEDURE HMG_GarbageCall( lAll )
   DEFAULT lAll TO .T.
   IF lAll == .T.
      hb_gcAll()    // Check all memory blocks if they can be released
   ELSE
      hb_gcStep()   // Check a single memory block if it can be released
   ENDIF
RETURN
