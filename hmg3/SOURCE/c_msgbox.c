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



/*
  The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made
  by Dr. Claudio Soto, November 2012 and June 2014 respectively.
  mail: <srvet@adinet.com.uy>
  blog: http://srvet.blogspot.com
*/

#include "HMG_UNICODE.h"


#include <shlobj.h>
#include <windows.h>
#include "hbapi.h"

#include "hbthread.h"
extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c


HB_FUNC( C_MSGBOX )
{
   MessageBox( GetActiveWindow(), HMG_parc( 1 ), HMG_parc( 2 ), MB_OK | MB_SYSTEMMODAL ) ;
}

HB_FUNC( C_MSGINFO )
{
   MessageBox( GetActiveWindow(), HMG_parc(1) , HMG_parc(2) , MB_OK | MB_ICONINFORMATION | MB_SYSTEMMODAL );
}

HB_FUNC( C_MSGSTOP )
{
   MessageBox( GetActiveWindow(), HMG_parc(1) , HMG_parc(2) , MB_OK | MB_ICONSTOP | MB_SYSTEMMODAL );
}

HB_FUNC( C_MSGEXCLAMATION )
{
   MessageBox( GetActiveWindow(), HMG_parc(1), HMG_parc(2), MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
}

HB_FUNC( C_MSGRETRYCANCEL )
{
   int r = MessageBox( GetActiveWindow(), HMG_parc(1), HMG_parc(2) , MB_RETRYCANCEL | MB_ICONQUESTION | MB_SYSTEMMODAL ) ;
   hb_retni ( r ) ;
}

HB_FUNC( C_MSGOKCANCEL )
{
   int r = MessageBox( GetActiveWindow(), HMG_parc(1),HMG_parc(2) , MB_OKCANCEL | MB_ICONQUESTION | MB_SYSTEMMODAL ) ;
   hb_retni ( r ) ;
}

HB_FUNC( C_MSGYESNO )
{
   int r = MessageBox( GetActiveWindow(), HMG_parc(1),HMG_parc(2) , MB_YESNO | MB_ICONQUESTION | MB_SYSTEMMODAL ) ;
   hb_retni ( r ) ;
}

HB_FUNC( C_MSGYESNO_ID )
{
   int r = MessageBox( GetActiveWindow(), HMG_parc(1),HMG_parc(2) , MB_YESNO | MB_ICONQUESTION | MB_SYSTEMMODAL | MB_DEFBUTTON2 ) ;
   hb_retni ( r ) ;
}



// by Dr. Claudio Soto (October 2013)

#define ID_TIMEDOUT 32000

int WINAPI MessageBoxTimeout (HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType, WORD wLanguageId, DWORD dwMilliseconds)
{
   typedef BOOL (WINAPI *PMessageBoxTimeout)(HWND,LPCTSTR,LPCTSTR,UINT,WORD,DWORD);
_THREAD_LOCK();
   static PMessageBoxTimeout pMessageBoxTimeout = NULL;
   if (pMessageBoxTimeout == NULL)
   {
      HMODULE hLib = LoadLibrary (_TEXT("User32.dll"));
      #ifdef UNICODE
         pMessageBoxTimeout = (PMessageBoxTimeout)GetProcAddress(hLib, "MessageBoxTimeoutW");
      #else
         pMessageBoxTimeout = (PMessageBoxTimeout)GetProcAddress(hLib, "MessageBoxTimeoutA");
      #endif
   }
_THREAD_UNLOCK();
   if(pMessageBoxTimeout == NULL)
      return FALSE;
   return pMessageBoxTimeout(hWnd, lpText, lpCaption, uType, wLanguageId, dwMilliseconds);
}


//       HMG_MessageBoxTimeout (cText, cCaption, nTypeIconButton, nMilliseconds) ---> Return nRetValue
HB_FUNC (HMG_MESSAGEBOXTIMEOUT)
{
   HWND  hWnd           = GetActiveWindow();
   TCHAR *lpText        = (TCHAR *) HMG_parc (1);
   TCHAR *lpCaption     = (TCHAR *) HMG_parc (2);
   UINT  uType          = HB_ISNIL(3) ? MB_OK : (UINT) hb_parnl (3);
   WORD  wLanguageId    = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL);
   DWORD dwMilliseconds = HB_ISNIL(4) ? (DWORD)0xFFFFFFFF  : (DWORD) hb_parnl (4);
   int iRet = MessageBoxTimeout (hWnd, lpText, lpCaption, uType, wLanguageId, dwMilliseconds);
   hb_retni ((int) iRet);
}


//       MessageBoxIndirect ( [hWnd], cText, [cCaption], [nStyle], [cResourceIcon] )
HB_FUNC( MESSAGEBOXINDIRECT )
{
   MSGBOXPARAMS mbp;

   mbp.cbSize             = sizeof (MSGBOXPARAMS);
   mbp.hwndOwner          = HB_ISNIL (1) ? GetActiveWindow() : (HWND) HMG_parnl (1);
   mbp.hInstance          = GetModuleHandle (NULL);
   mbp.lpszText           = HMG_parc (2);
   mbp.lpszCaption        = HB_ISCHAR (3) ? HMG_parc (3) : _TEXT("");
   mbp.dwStyle            = (DWORD) (hb_parni (4) | (HB_ISCHAR (5) ? MB_USERICON : 0));
   mbp.lpszIcon           = HMG_parc (5);
   mbp.dwContextHelpId    = 0;
   mbp.lpfnMsgBoxCallback = NULL;
   mbp.dwLanguageId       = MAKELANGID (LANG_NEUTRAL, SUBLANG_NEUTRAL);

   hb_retni ((INT) MessageBoxIndirect (&mbp));
}
