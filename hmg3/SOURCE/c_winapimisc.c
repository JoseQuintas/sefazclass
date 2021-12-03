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




//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400


#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include <psapi.h>
#include <tchar.h>
#include <winreg.h>
#include <uxtheme.h>
#include <imagehlp.h>
//#include "hbvm.h"
//#include "hbstack.h"
#include "hbapiitm.h"
#include "hbapi.h"


#include "hbapifs.h"

#include "hbthread.h"
extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c


/*WaitRun function
Author Luiz Rafael Culik Guimaraes: culikr@uol.com.br
Parameters WaitRunPipe(cCommand,nShowWindow,cFile)
*/

HB_FUNC( WAITRUNPIPE )
{

      // STARTUPINFO StartupInfo = {0};
      STARTUPINFO StartupInfo = {0, NULL,NULL,NULL, 0,0,0,0,0,0,0,0,0,0, NULL,NULL,NULL,NULL};
      // PROCESS_INFORMATION ProcessInfo = {0};
      PROCESS_INFORMATION ProcessInfo = {NULL, NULL, 0, 0};
      // DWORD dwExitCode;
      HANDLE ReadPipeHandle;
      HANDLE WritePipeHandle;       // not used here
      TCHAR Data[1024];
      TCHAR *szFile=(TCHAR*) HMG_parc(3);
      SECURITY_ATTRIBUTES sa;
      ZeroMemory(&sa,sizeof(SECURITY_ATTRIBUTES));
      sa.nLength=sizeof(SECURITY_ATTRIBUTES);
      sa.bInheritHandle=1;
      sa.lpSecurityDescriptor=NULL;

      HB_FHANDLE nHandle;

      if (!hb_fsFile(HMG_WCHAR_TO_CHAR(szFile))) {
        nHandle  = hb_fsCreate(HMG_WCHAR_TO_CHAR(szFile),0);
        }
      else {
        nHandle = hb_fsOpen(HMG_WCHAR_TO_CHAR(szFile),2);
        hb_fsSeek (nHandle,0,2);
       }
      if(!CreatePipe(&ReadPipeHandle,&WritePipeHandle,&sa,0))
        hb_retnl(-1);

      ProcessInfo.hProcess=INVALID_HANDLE_VALUE;
      ProcessInfo.hThread=INVALID_HANDLE_VALUE;
      StartupInfo.dwFlags = STARTF_USESHOWWINDOW |STARTF_USESTDHANDLES;
      StartupInfo.wShowWindow = hb_parni( 2 );
      StartupInfo.hStdOutput=WritePipeHandle;
      StartupInfo.hStdError=WritePipeHandle;

      if( ! CreateProcess( 0, (TCHAR*)HMG_parc( 1 ), 0, 0, FALSE,
                           CREATE_NEW_CONSOLE | NORMAL_PRIORITY_CLASS,
                           0, 0, &StartupInfo, &ProcessInfo ) )
                hb_retnl( -1 );


      for (;;)
      {
        DWORD BytesRead;
        DWORD TotalBytes;
        DWORD BytesLeft;

        //Check for the presence of data in the pipe
        if(!PeekNamedPipe(ReadPipeHandle,Data,sizeof(Data),&BytesRead,
            &TotalBytes,&BytesLeft))hb_retnl(-1);
        //If there is bytes, read them
        if(BytesRead)
        {
          if(!ReadFile(ReadPipeHandle,Data,sizeof(Data)-1,&BytesRead,NULL))
            hb_retnl(-1);
          Data[BytesRead]=_TEXT('\0');
          hb_fsWriteLarge(nHandle,(BYTE*)Data,BytesRead);

        }
        else
        {
          //Is the console app terminated?
          if(WaitForSingleObject(ProcessInfo.hProcess,0)==WAIT_OBJECT_0)break;

        }
      }
      CloseHandle(ProcessInfo.hThread);
      CloseHandle(ProcessInfo.hProcess);
      CloseHandle(ReadPipeHandle);
      CloseHandle(WritePipeHandle);
      hb_fsClose(nHandle);
    }


HB_FUNC( ISVISTA )
{

	OSVERSIONINFO osvi;

	ZeroMemory(&osvi, sizeof(OSVERSIONINFO));
	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

	GetVersionEx(&osvi);

  /*
    Windows Vista, 7, 8, 8.1, and early releases of 10 set dwMajorVersion to 6.
    Later releases of Windows 10 set dwMajorVersion to 10.
  */
  if (osvi.dwMajorVersion >= 6)
	{
		hb_retl(TRUE);
	}
	else
	{
		hb_retl(FALSE);
	}

}



HB_FUNC( GETRED )
{
	hb_retnl( GetRValue( hb_parnl( 1 ) ) );
}

HB_FUNC( GETGREEN )
{
	hb_retnl( GetGValue( hb_parnl( 1 ) ) );
}

HB_FUNC( GETBLUE )
{
	hb_retnl( GetBValue( hb_parnl( 1 ) ) );
}


HB_FUNC( HIWORD )
{
	hb_retnl( HIWORD( hb_parnl( 1 ) ) );
}

HB_FUNC( LOWORD )
{
	hb_retnl( LOWORD( hb_parnl( 1 ) ) );
}



HB_FUNC( C_GETSPECIALFOLDER ) // Contributed By Ryszard Ryüko
{
   TCHAR *lpBuffer = (TCHAR*) hb_xgrab( (MAX_PATH+1) * sizeof(TCHAR));
   LPITEMIDLIST pidlBrowse;    // PIDL selected by user
   SHGetSpecialFolderLocation(GetActiveWindow(), hb_parni(1) , &pidlBrowse) ;
   SHGetPathFromIDList(pidlBrowse,lpBuffer);
   HMG_retc(lpBuffer);
   hb_xfree( lpBuffer);
}


HB_FUNC( MEMORYSTATUS )
{
   INT n = hb_parni (1);
   MEMORYSTATUSEX mst;
   mst.dwLength = sizeof (MEMORYSTATUSEX);
   GlobalMemoryStatusEx (&mst);   // reflects the state of memory at the time of the call

   switch( n )
   {
      case 1:  HMG_retnl ( mst.ullTotalPhys     / (1024*1024) ) ; break;
      case 2:  HMG_retnl ( mst.ullAvailPhys     / (1024*1024) ) ; break;
      case 3:  HMG_retnl ( mst.ullTotalPageFile / (1024*1024) ) ; break;
      case 4:  HMG_retnl ( mst.ullAvailPageFile / (1024*1024) ) ; break;
      case 5:  HMG_retnl ( mst.ullTotalVirtual  / (1024*1024) ) ; break;
      case 6:  HMG_retnl ( mst.ullAvailVirtual  / (1024*1024) ) ; break;
      default: HMG_retnl (0);
   }
}


HB_FUNC( SHELLABOUT )
{
   ShellAbout( 0, HMG_parc( 1 ), HMG_parc( 2 ), (HICON) HMG_parnl (3) );
}


/*
HB_FUNC( PAINTBKGND )
{
    HWND hwnd;
    HBRUSH brush;
    RECT recClie;
    HDC hdc;

    hwnd  = (HWND) HMG_parnl (1);
    hdc   = GetDC (hwnd);

    GetClientRect(hwnd, &recClie);

    if ((hb_pcount() > 1) && (!HB_ISNIL(2)))
    { brush = CreateSolidBrush( RGB(hb_parvni(2, 1),
                                    hb_parvni(2, 2),
                                    hb_parvni(2, 3)) );
      FillRect(hdc, &recClie, brush);
      DeleteObject(brush);
    }
    else
    { brush = (HBRUSH)( COLOR_BTNFACE + 1 );
      FillRect(hdc, &recClie, brush);
    }

    ReleaseDC(hwnd, hdc);
}
*/


HB_FUNC( GETWINDOWSDIR )
{
   TCHAR szBuffer[ MAX_PATH + 1 ] = {0} ;
   GetWindowsDirectory( szBuffer,MAX_PATH);
   HMG_retc(szBuffer);
}


HB_FUNC( GETSYSTEMDIR )
{
   TCHAR szBuffer[ MAX_PATH + 1 ] = {0} ;
   GetSystemDirectory( szBuffer,MAX_PATH);
   HMG_retc(szBuffer);
}

HB_FUNC( GETTEMPDIR )
{
   TCHAR szBuffer[ MAX_PATH + 1 ] = {0} ;
   GetTempPath(MAX_PATH, szBuffer);
   HMG_retc(szBuffer);
}


HB_FUNC( GETSYSTEMWOW64DIRECTORY )
{
   TCHAR szBuffer[ MAX_PATH + 1 ] = {0} ;
   GetSystemWow64Directory( szBuffer, MAX_PATH );
   HMG_retc( szBuffer );
}


HB_FUNC ( POSTMESSAGE )
{
    hb_retl( (BOOL) PostMessage (
                       (HWND)   HMG_parnl (1),
                       (UINT)   hb_parni  (2),
                       (WPARAM) HMG_parnl (3),
                       (LPARAM) HMG_parnl (4) ) );
}

HB_FUNC ( DEFWINDOWPROC )
{
    HMG_retnl( (LONG_PTR) DefWindowProc (
                       (HWND)   HMG_parnl (1),
                       (UINT)   hb_parni  (2),
                       (WPARAM) HMG_parnl (3),
                       (LPARAM) HMG_parnl (4) ) );
}

HB_FUNC( GETSTOCKOBJECT )
{
   HGDIOBJ hObj = GetStockObject( hb_parni (1) );
   HMG_retnl ((LONG_PTR) hObj ) ;
}

HB_FUNC( SETBKMODE )
{
   hb_retni( SetBkMode( (HDC) HMG_parnl (1), hb_parni( 2 ) ) ) ;
}

//       ShellExecute ( [hWnd], [cOperation], cFile, [cParameters], [cDirectory], nShowCmd ) --> return hInstance or nError
HB_FUNC( SHELLEXECUTE )
{
// Because ShellExecute can delegate execution to Shell extensions (data sources, context menu handlers, verb implementations)
// that are activated using Component Object Model (COM), COM should be initialized before ShellExecute is called.
   CoInitializeEx (NULL, COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE);

   HINSTANCE hInstance = ShellExecute( (HWND) HMG_parnl (1), HB_ISNIL(2) ? NULL : (LPCTSTR) HMG_parc(2),(LPCTSTR) HMG_parc(3),HB_ISNIL(4) ? NULL : (LPCTSTR) HMG_parc(4),HB_ISNIL(5) ? NULL : (LPCTSTR) HMG_parc(5),hb_parni(6) );
   HMG_retnl ((LONG_PTR) hInstance );
}

HB_FUNC( WAITRUN )
{

	DWORD dwExitCode;

	STARTUPINFO stInfo;
	PROCESS_INFORMATION prInfo;
	BOOL bResult;

	ZeroMemory( &stInfo, sizeof(stInfo) );

	stInfo.cb = sizeof(stInfo);

	stInfo.dwFlags=STARTF_USESHOWWINDOW;

	stInfo.wShowWindow=hb_parni(2);

	bResult = CreateProcess(
      NULL,
		(TCHAR*)HMG_parc(1) ,
		NULL,
		NULL,
		TRUE,
		CREATE_NEW_CONSOLE | NORMAL_PRIORITY_CLASS,
		NULL,
		NULL,
		&stInfo,
		&prInfo);

	if (!bResult)
	{
		hb_retl(-1);
      return;   // ADD september 2015
	}

	WaitForSingleObject(prInfo.hProcess,INFINITE);

	GetExitCodeProcess( prInfo.hProcess, &dwExitCode );

	hb_retnl( dwExitCode );

}


// Taken from MiniGUI Ex.
HB_FUNC( ISEXERUNNING ) // ( cExeNameCaseSensitive ) --> lResult
{
   HANDLE hMutex = CreateMutex ( NULL, FALSE, ( LPCTSTR ) HMG_parc( 1 ) );

   hb_retl( GetLastError() == ERROR_ALREADY_EXISTS );

   if( hMutex != NULL )
      ReleaseMutex( hMutex );
}



HB_FUNC( CREATEMUTEX )
{
   SECURITY_ATTRIBUTES *sa = NULL;

   if (HB_ISCHAR(1))
       sa = (SECURITY_ATTRIBUTES *) hb_parc(1);   // byte pointer to the data

   HANDLE h = CreateMutex (( HB_ISNIL(1) ? NULL : sa ), hb_parl(2), HMG_parc(3));
   HMG_retnl ((LONG_PTR) h );
}


HB_FUNC ( GETLASTERROR )
{
  hb_retnl( (LONG) GetLastError() ) ;
}

HB_FUNC( SETSCROLLPOS )
{
   hb_retni( SetScrollPos( (HWND) HMG_parnl (1),
                           hb_parni( 2 )       ,
                           hb_parni( 3 )       ,
                           hb_parl( 4 )
                         ) ) ;
}

HB_FUNC ( CREATEFOLDER )
{
	CreateDirectory( HMG_parc(1) , NULL ) ;
}

HB_FUNC ( SETCURRENTFOLDER )
{
	SetCurrentDirectory( HMG_parc(1) ) ;
}

HB_FUNC( REMOVEFOLDER )
{
   hb_retl( RemoveDirectory( HMG_parc( 1 ) ) ) ;
}

HB_FUNC( GETCURRENTFOLDER )
{
   TCHAR Path[ MAX_PATH + 1 ] = {0};
   GetCurrentDirectory( MAX_PATH ,  Path ) ;
   HMG_retc( Path );
}

HB_FUNC( CREATESOLIDBRUSH )
{
   HBRUSH hBrush = CreateSolidBrush( (COLORREF) RGB(hb_parni(1), hb_parni(2), hb_parni(3) ));
	HMG_retnl ((LONG_PTR) hBrush );
}

HB_FUNC( SETTEXTCOLOR )
{

  hb_retnl( (ULONG) SetTextColor( (HDC) HMG_parnl (1), (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4) ) ) ) ;

}

HB_FUNC( SETBKCOLOR )
{
   hb_retnl( (ULONG) SetBkColor( (HDC) HMG_parnl (1), (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4) ) ) ) ;
}

HB_FUNC ( GETSYSCOLOR )
{
  hb_retnl( GetSysColor( hb_parni(1) ) ) ;
}



/**************************************************************************************/
/*                                                                                    */
/*  This function returns the Windows Version on which the app calling the function   */
/*  is running.                                                                       */
/*                                                                                    */
/*  The return value is an three dimensinal array containing the OS in the first,     */
/*  the servicepack or the system release number in the second and the build number   */
/*  in the third array element.                                                       */
/*                                                                                    */
/**************************************************************************************/

HB_FUNC( WINVERSION )
{

   OSVERSIONINFOEX osvi;
   BOOL            bOsVersionInfoEx;
   TCHAR            *szVersion = NULL;
   TCHAR            *szServicePack = NULL;
   TCHAR            *szBuild = NULL;
   TCHAR            buffer[5];

   TCHAR            *szVersionEx = NULL;


   ZeroMemory(&osvi,sizeof(OSVERSIONINFOEX));
   osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);

   bOsVersionInfoEx = GetVersionEx((OSVERSIONINFO*)&osvi);
   if ( !bOsVersionInfoEx )
   {
      osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
      if ( !GetVersionEx((OSVERSIONINFO*)&osvi))
         szVersion = _TEXT("Unknown Operating System");
   }


   if (szVersion == NULL)
   {
      switch (osvi.dwPlatformId)
      {
         case VER_PLATFORM_WIN32_NT:

            if (osvi.dwMajorVersion == 6 && osvi.dwMinorVersion >= 2)
               szVersion = _TEXT ("Windows 8 ");

            if (osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 1)
               szVersion = _TEXT("Windows 7 ");

            if (osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0)
               szVersion = _TEXT("Windows Vista ");

            if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2)
               szVersion = _TEXT("Windows Server 2003 family ");

            if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1)
               szVersion = _TEXT("Windows XP ");

            if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0)
               szVersion = _TEXT("Windows 2000 ");

            if (osvi.dwMajorVersion <= 4)
               szVersion = _TEXT("Windows NT ");

            if (bOsVersionInfoEx)
            {
               if (osvi.wProductType == VER_NT_WORKSTATION)
               {
                  if (osvi.dwMajorVersion == 4)
                     szVersionEx = _TEXT("Workstation 4.0 ") ;
                  else if (osvi.wSuiteMask & VER_SUITE_PERSONAL)
                     szVersionEx = _TEXT("Home Edition ") ;
                  else
                     szVersionEx = _TEXT("Professional ");
               }
               else if (osvi.wProductType == VER_NT_SERVER)
               {
                  if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2)
                  {

                     if (osvi.wSuiteMask & VER_SUITE_DATACENTER)
                        szVersionEx = _TEXT("Datacenter Edition ") ;
                     else if (osvi.wSuiteMask & VER_SUITE_ENTERPRISE)
                        szVersionEx = _TEXT("Enterprise Edition ") ;
                     else if (osvi.wSuiteMask & VER_SUITE_BLADE)
                        szVersionEx = _TEXT("Web Edition ") ;
                     else
                        szVersionEx = _TEXT("Standard Edition ") ;
                  }
                  else if (osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0)
                  {
                     if (osvi.wSuiteMask & VER_SUITE_DATACENTER)
                        szVersionEx = _TEXT("Datacenter Server ") ;
                     else if (osvi.wSuiteMask & VER_SUITE_ENTERPRISE)
                        szVersionEx = _TEXT("Advanced Server ") ;
                     else
                        szVersionEx = _TEXT("Server ");
                  }
                  else
                  {
                     if (osvi.wSuiteMask & VER_SUITE_ENTERPRISE)
                        szVersionEx = _TEXT("Server 4.0, Enterprise Edition ") ;
                     else
                        szVersionEx = _TEXT("Server 4.0 ") ;
                  }
               }
            }
            else
            {
               HKEY hKey;
               TCHAR szProductType[80];
               DWORD dwBufLen = 80;
               LONG lRetVal;

               lRetVal = RegOpenKeyEx(HKEY_LOCAL_MACHINE,
                                      _TEXT("SYSTEM\\CurrentControlSet\\Control\\ProductOptions"),0,
                                      KEY_QUERY_VALUE,&hKey);

               if (lRetVal != ERROR_SUCCESS)
                  szVersion = _TEXT("Unknown Operating System");
               else
               {
                  lRetVal = RegQueryValueEx(hKey,_TEXT("ProductType"),NULL,NULL,(LPBYTE)szProductType,&dwBufLen);
                  if ((lRetVal != ERROR_SUCCESS) || (dwBufLen > 80))
                     szVersion = _TEXT("Unknown Operating System");
               }
               RegCloseKey(hKey);

               // if (szVersion != "Unknown Operating System")
               if (lstrcmp (szVersion, _TEXT("Unknown Operating System")) != 0)
               {
                  if (lstrcmpi(_TEXT("WINNT"),szProductType) == 0)
                     szVersionEx = _TEXT("Workstation ") ;
                  if (lstrcmpi(_TEXT("LANMANNT"),szProductType) == 0)
                     szVersionEx = _TEXT("Server ") ;
                  if (lstrcmpi(_TEXT("SERVERNT"),szProductType) == 0)
                     szVersionEx = _TEXT("Advanced Server ") ;

                  szVersion = lstrcat(szVersion, _itot (osvi.dwMajorVersion, buffer, 10));
                  szVersion = lstrcat(szVersion,_TEXT("."));
                  szVersion = lstrcat(szVersion, _itot (osvi.dwMinorVersion, buffer, 10));

               }
            }
            if (osvi.dwMajorVersion == 4 && lstrcmpi(osvi.szCSDVersion,_TEXT("Service Pack 6")) == 0)
            {
               HKEY hKey;
               LONG lRetVal;

               lRetVal = RegOpenKeyEx(HKEY_LOCAL_MACHINE,
                                      _TEXT("SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Hotfix\\Q246009"),
                                      0,KEY_QUERY_VALUE,&hKey);
               if (lRetVal == ERROR_SUCCESS)
               {
                  szServicePack = _TEXT("Service Pack 6a");
                  szBuild = _itot(osvi.dwBuildNumber & 0xFFFF, buffer, 10);
               }
               else
               {
                  szServicePack = osvi.szCSDVersion;
                  szBuild = _itot(osvi.dwBuildNumber & 0xFFFF, buffer,10);
               }
               RegCloseKey(hKey);
            }
            else
            {
               szServicePack = osvi.szCSDVersion;
               szBuild = _itot (osvi.dwBuildNumber & 0xFFFF, buffer,10);
            }
            break;

         case VER_PLATFORM_WIN32_WINDOWS:
            if ((osvi.dwMajorVersion == 4) && (osvi.dwMinorVersion == 0))
            {
               if (osvi.szCSDVersion[1] == 'B')
               {
                  szVersion = _TEXT("Windows 95 B");
                  szServicePack = _TEXT("OSR2");
               }
               else
               {
                  if (osvi.szCSDVersion[1] == _TEXT('C'))
                  {
                     szVersion = _TEXT("Windows 95 C");
                     szServicePack = _TEXT("OSR2");
                  }
                  else
                  {
                     szVersion = _TEXT("Windows 95");
                     szServicePack = _TEXT("OSR1");
                  }
               }
               szBuild = _itot (osvi.dwBuildNumber & 0x0000FFFF, buffer, 10);
            }
            if ((osvi.dwMajorVersion == 4) && (osvi.dwMinorVersion == 10))
            {
               if (osvi.szCSDVersion[1] == 'A')
               {
                  szVersion = _TEXT("Windows 98 A");
                  szServicePack = _TEXT("Second Edition");
               }
               else
               {
                  szVersion = _TEXT("Windows 98");
                  szServicePack = _TEXT("First Edition");
               }

               szBuild = _itot (osvi.dwBuildNumber & 0x0000FFFF, buffer,10);
            }

            if ((osvi.dwMajorVersion == 4) && (osvi.dwMinorVersion == 90))
            {
               szVersion = _TEXT("Windows ME");
               szBuild = _itot (osvi.dwBuildNumber & 0x0000FFFF, buffer, 10);
            }
            break;
      }

   }

   hb_reta( 4 );
   HMG_storvc( szVersion , -1, 1 );
   HMG_storvc( szServicePack, -1, 2 );
   HMG_storvc( szBuild, -1, 3 );
   HMG_storvc( szVersionEx, -1, 4 );


}

HB_FUNC( FREELIBRARY )
{
   FreeLibrary ( (HMODULE) HMG_parnl (1) ) ;
}

HB_FUNC( WINMAJORVERSIONNUMBER )
{

   OSVERSIONINFOEX osvi;

   ZeroMemory(&osvi,sizeof(OSVERSIONINFOEX));
   osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);

    GetVersionEx((OSVERSIONINFO*)&osvi);

   hb_retni( osvi.dwMajorVersion );

}

HB_FUNC( WINMINORVERSIONNUMBER )
{

   OSVERSIONINFOEX osvi;

   ZeroMemory(&osvi,sizeof(OSVERSIONINFOEX));
   osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);

   GetVersionEx((OSVERSIONINFO*)&osvi);

   hb_retni( osvi.dwMinorVersion ) ;

}


HB_FUNC( SETCLIPBOARD )
{
   HGLOBAL hGlobalAlloc;
   TCHAR * lpstr;
   TCHAR * cStr = (TCHAR*) HMG_parc( 1 );
   int nLen = lstrlen( cStr );

   if ( !OpenClipboard ( GetActiveWindow() ) )
      return;

   EmptyClipboard();

   hGlobalAlloc = GlobalAlloc( GHND, (nLen+1) * sizeof(TCHAR) );
   if (hGlobalAlloc == NULL)
   {
       CloseClipboard();
       return;
   }

   // Lock the handle and copy the text to the buffer.

   lpstr = (TCHAR*) GlobalLock( hGlobalAlloc );
   memcpy( lpstr, cStr, nLen * sizeof(TCHAR));
   lpstr[nLen] = (TCHAR) 0;    // null character
   GlobalUnlock(hGlobalAlloc);

   // Place the handle on the clipboard.
#ifdef UNICODE
   SetClipboardData (CF_UNICODETEXT, hGlobalAlloc );
#else
   SetClipboardData (CF_TEXT, hGlobalAlloc );
#endif

   CloseClipboard();
}


HB_FUNC( GETCLIPBOARD )
{
   HGLOBAL hMem ;

   if ( !OpenClipboard( GetActiveWindow() ) )
   {
      HMG_retc ( _TEXT("") );
      return;
   }

#ifdef UNICODE
    hMem = GetClipboardData (CF_UNICODETEXT);
#else
    hMem = GetClipboardData( CF_TEXT );
#endif

   if ( hMem )
   {
       TCHAR *Text = (TCHAR *) GlobalLock (hMem);
       HMG_retc (Text);
       GlobalUnlock( hMem );
   }
   else
      HMG_retc ( _TEXT("") );

   CloseClipboard();
}


// by Dr. Claudio Soto, January 2014

HB_FUNC ( EMPTYCLIPBOARD )
{
   HWND hWnd = HB_ISNIL (1) ? GetDesktopWindow() : (HWND) HMG_parnl (1);

   if ( IsWindow ( hWnd ) )
   {   if ( OpenClipboard ( hWnd ) )
       {   EmptyClipboard ();
           CloseClipboard();
           hb_retl ( TRUE );
       }
       else
          hb_retl ( FALSE );
   }
   else
      hb_retl ( FALSE );
}



//************************************************************************************************
//  by Dr. Claudio Soto (May 2014)
//************************************************************************************************



//        SetWindowLongPtr (hWnd, nIndex, dwNewLong) --> return dwRetLong
HB_FUNC ( SETWINDOWLONGPTR )
{
   HWND hWnd          = (HWND) HMG_parnl (1);
   int  nIndex        = (int)  hb_parnl (2);
   LONG_PTR dwNewLong = (LONG_PTR) HMG_parnl (3);
   LONG_PTR dwRetLong = SetWindowLongPtr (hWnd, nIndex, dwNewLong);
   HMG_retnl((LONG_PTR) dwRetLong);
}


//        GetWindowLongPtr (hWnd, nIndex) --> return dwRetLong
HB_FUNC ( GETWINDOWLONGPTR )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   int nIndex = (int)  hb_parnl (2);
   LONG_PTR dwRetLong = GetWindowLongPtr (hWnd, nIndex);
   HMG_retnl((LONG_PTR) dwRetLong);
}


//        SetClassLongPtr (hWnd, nIndex, dwNewLong) --> return dwRetLong
HB_FUNC ( SETCLASSLONGPTR )
{
   HWND hWnd           = (HWND) HMG_parnl (1);
   int  nIndex         = (int)  hb_parnl (2);
   LONG_PTR dwNewLong  = (LONG_PTR) HMG_parnl (3);
   ULONG_PTR dwRetLong = SetClassLongPtr (hWnd, nIndex, dwNewLong);
   HMG_retnl((LONG_PTR) dwRetLong);
}


//        GetClassLongPtr (hWnd, nIndex) --> return dwRetLong
HB_FUNC ( GETCLASSLONGPTR )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   int nIndex = (int)  hb_parnl (2);
   ULONG_PTR dwRetLong = GetClassLongPtr (hWnd, nIndex);
   HMG_retnl((LONG_PTR) dwRetLong);
}


//        RegCloseKey ( hKey ) --> return lBoolean
HB_FUNC ( REGCLOSEKEY )
{
   HKEY hKey = (HKEY) HMG_parnl (1);

   if ( RegCloseKey (hKey) == ERROR_SUCCESS )
       hb_retl ((BOOL) TRUE);
   else
       hb_retl ((BOOL) FALSE);
}


//        RegOpenKeyEx ( hKey, cSubKey, [ RegSAM ], @hResult ) --> return lBoolean
HB_FUNC ( REGOPENKEYEX )
{
   HKEY   hKey     = (HKEY)    HMG_parnl (1);
   TCHAR  *cSubKey = (TCHAR *) HMG_parc  (2);
   REGSAM RegSAM   = (HB_ISNUM(3) ? (REGSAM) hb_parni (3) : KEY_ALL_ACCESS);
   HKEY hResult;

   if ( RegOpenKeyEx (hKey, cSubKey, 0, RegSAM, &hResult) == ERROR_SUCCESS )
       hb_retl ((BOOL) TRUE);
   else
       hb_retl ((BOOL) FALSE);

   HMG_stornl ((LONG_PTR) hResult, 4);
}


//        RegEnumKeyEx ( hKey, nIndex, @cBuffer, @cClass ) --> return lBoolean
HB_FUNC ( REGENUMKEYEX )
{
   FILETIME ft;
   HKEY  hKey   = (HKEY)  HMG_parnl (1);
   DWORD nIndex = (DWORD) hb_parni  (2);
   TCHAR cBuffer [ 0x7FFF ];
   TCHAR cClass  [ 0x7FFF ];
   DWORD dwBuffSize = (sizeof(cBuffer) / sizeof(TCHAR));
   DWORD dwClass    = (sizeof(cClass)  / sizeof(TCHAR));

   if ( RegEnumKeyEx (hKey, nIndex, cBuffer, &dwBuffSize, NULL, cClass, &dwClass, &ft) == ERROR_SUCCESS )
       hb_retl ((BOOL) TRUE);
   else
       hb_retl ((BOOL) FALSE);

   HMG_storc (cBuffer, 3);
   HMG_storc (cClass,  4);
}



/*
NOTE about 32/64 bit processes:
   - with apps of 32-bit is possible only get information about of 32-bit processes
   - with apps of 32-bit is not possible get information about of 64-bit processes
   - with apps of 64-bit is possible get information about of 32 and 64-bit processes
*/



/*
HMG_DEFINE_DLL_FUNC ( win_IsWow64Process,                       // user function name
                      "kernel32",                               // dll name
                      BOOL,                                     // function return type
                      WINAPI,                                   // function type
                      "IsWow64Process",                         // dll function name
                      (HANDLE hProcess, BOOL *pWow64Process),   // dll function parameters (types and names)
                      (hProcess, pWow64Process),                // function parameters (only names)
                      FALSE                                     // return value if fail call function of dll
                    )
*/


//        IsWow64Process ( [ nProcessID ] ) --> return lBoolean
HB_FUNC ( ISWOW64PROCESS )
{
   // IsWow64Process()
   //    - return TRUE  if a 32-bit application is running under 64-bit Windows (WOW64)
   //    - return FALSE if a 32-bit application is running under 32-bit Windows
   //    - return FALSE if a 64-bit application is running under 64-bit Windows
   // WOW64 is the x86 emulator that allows 32-bit Windows-based applications to running on 64-bit Windows

_THREAD_LOCK();
   typedef BOOL (WINAPI *Func_IsWow64Process) (HANDLE, BOOL*);   // minimun: Windows XP with SP2
   static Func_IsWow64Process pIsWow64Process = NULL;

   if (pIsWow64Process == NULL)
       pIsWow64Process = (Func_IsWow64Process) GetProcAddress (GetModuleHandle (_TEXT("kernel32")), "IsWow64Process");
_THREAD_UNLOCK();

   BOOL IsWow64 = FALSE;

   if (pIsWow64Process != NULL)
   {
      if (HB_ISNUM (1) == FALSE)
         pIsWow64Process (GetCurrentProcess(), &IsWow64);
      else
      {
         DWORD ProcessID = (DWORD) hb_parnl (1);
         HANDLE hProcess = OpenProcess ( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, ProcessID );
         if ( hProcess != NULL )
         {
             pIsWow64Process (hProcess, &IsWow64);
             CloseHandle (hProcess);
         }
      }
   }
   hb_retl ((BOOL) IsWow64 );
}


HB_FUNC ( GETMODULEHANDLE )
{
   TCHAR *ModuleName = (TCHAR *) HMG_parc (1);
   HMODULE hModule = GetModuleHandle ( HB_ISNIL(1) ? NULL : ModuleName );
   HMG_retnl ((LONG_PTR) hModule );
}


//        GetCurrentProcessId() --> return nProcessID
HB_FUNC ( GETCURRENTPROCESSID )
{
   hb_retni ((INT) GetCurrentProcessId());
}


//        EnumProcessesID () ---> return array { nProcessID1, nProcessID2, ... }
HB_FUNC ( ENUMPROCESSESID )
{
_THREAD_LOCK();
   typedef BOOL (WINAPI *Func_EnumProcesses) (DWORD*, DWORD, DWORD*);
   static Func_EnumProcesses pEnumProcesses = NULL;

   if (pEnumProcesses == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Psapi.dll"));
       pEnumProcesses = (Func_EnumProcesses) GetProcAddress(hLib, "EnumProcesses");
   }
_THREAD_UNLOCK();

   if (pEnumProcesses == NULL)
       return;   // return NIL

   DWORD i, aProcessesID [1024*5], cbNeeded, nProcesses;

   if (pEnumProcesses ( aProcessesID, sizeof(aProcessesID), &cbNeeded ) == FALSE)
        return;   // return NIL

   nProcesses = cbNeeded / sizeof(DWORD);

   PHB_ITEM pArray = hb_itemArrayNew (0);

   for (i = 0; i < nProcesses; i++ )
   {   if (aProcessesID [i] != 0)
      {
         PHB_ITEM pItem = hb_itemPutNL (NULL, (LONG) aProcessesID [i]);
         hb_arrayAddForward (pArray, pItem);
         hb_itemRelease ( pItem );
         // hb_arrayAdd (pArray, hb_itemPutNL (NULL, (LONG) aProcessesID [i]));   // with this way occur leak memory
      }
   }

   hb_itemReturnRelease (pArray);
}


//        GetWindowThreadProcessId (hWnd, @nThread, @nProcessID)
HB_FUNC ( GETWINDOWTHREADPROCESSID )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   DWORD nThread, nProcessID;

   nThread = GetWindowThreadProcessId (hWnd, &nProcessID);

   if ( HB_ISBYREF(2) )
        hb_storni (nThread, 2);
   if ( HB_ISBYREF(3) )
        hb_storni (nProcessID, 3);
}


//        GetProcessName ( [ nProcessID ] ) --> return cProcessName
HB_FUNC ( GETPROCESSNAME )
{
_THREAD_LOCK();
   typedef BOOL (WINAPI *Func_EnumProcessModules) (HANDLE, HMODULE*, DWORD, LPDWORD);
   static Func_EnumProcessModules pEnumProcessModules = NULL;
   if (pEnumProcessModules == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Psapi.dll"));
       pEnumProcessModules = (Func_EnumProcessModules) GetProcAddress(hLib, "EnumProcessModules");
   }
_THREAD_UNLOCK();

   if (pEnumProcessModules == NULL)
       return;   // return NIL

_THREAD_LOCK();
   typedef DWORD (WINAPI *Func_GetModuleBaseName) (HANDLE, HMODULE, LPTSTR, DWORD);
   static Func_GetModuleBaseName pGetModuleBaseName = NULL;
   if (pGetModuleBaseName == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Psapi.dll"));
       #ifdef UNICODE
          pGetModuleBaseName = (Func_GetModuleBaseName) GetProcAddress(hLib, "GetModuleBaseNameW");
       #else
          pGetModuleBaseName = (Func_GetModuleBaseName) GetProcAddress(hLib, "GetModuleBaseNameA");
       #endif
   }
_THREAD_UNLOCK();

   if (pGetModuleBaseName == NULL)
       return;   // return NIL


   DWORD ProcessID = HB_ISNUM (1) ? (DWORD) hb_parnl(1) : GetCurrentProcessId();
   TCHAR cProcessName [ MAX_PATH ] = _TEXT ("");

   HANDLE hProcess = OpenProcess ( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, ProcessID );
   if ( hProcess != NULL )
   {   HMODULE hMod;
       DWORD cbNeeded;
       if ( pEnumProcessModules (hProcess, &hMod, sizeof(hMod), &cbNeeded) )
            pGetModuleBaseName (hProcess, hMod, cProcessName, sizeof(cProcessName)/sizeof(TCHAR));

       CloseHandle (hProcess);
       HMG_retc (cProcessName);
   }
   return;   // return NIL
}


//        GetProcessFullName ( [ nProcessID ] ) --> return cProcessFullName
HB_FUNC ( GETPROCESSFULLNAME )
{
_THREAD_LOCK();
   typedef BOOL (WINAPI *Func_EnumProcessModules) (HANDLE, HMODULE*, DWORD, LPDWORD);
   static Func_EnumProcessModules pEnumProcessModules = NULL;
   if (pEnumProcessModules == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Psapi.dll"));
       pEnumProcessModules = (Func_EnumProcessModules) GetProcAddress(hLib, "EnumProcessModules");
   }
_THREAD_UNLOCK();

   if (pEnumProcessModules == NULL)
       return;   // return NIL

_THREAD_LOCK();
   typedef DWORD (WINAPI *Func_GetModuleFileNameEx) (HANDLE, HMODULE, LPTSTR, DWORD);
   static Func_GetModuleFileNameEx pGetModuleFileNameEx = NULL;
   if (pGetModuleFileNameEx == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Psapi.dll"));
       #ifdef UNICODE
          pGetModuleFileNameEx = (Func_GetModuleFileNameEx) GetProcAddress(hLib, "GetModuleFileNameExW");
       #else
          pGetModuleFileNameEx = (Func_GetModuleFileNameEx) GetProcAddress(hLib, "GetModuleFileNameExA");
       #endif
   }
_THREAD_UNLOCK();

   if (pGetModuleFileNameEx == NULL)
       return;   // return NIL


   DWORD ProcessID = HB_ISNUM (1) ? (DWORD) hb_parnl(1) : GetCurrentProcessId();
   TCHAR cProcessFullName [ MAX_PATH ] = _TEXT ("");

   HANDLE hProcess = OpenProcess ( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, ProcessID );
   if ( hProcess != NULL )
   {   HMODULE hMod;
       DWORD cbNeeded;
       if ( pEnumProcessModules (hProcess, &hMod, sizeof(hMod), &cbNeeded) )
            pGetModuleFileNameEx (hProcess, hMod, cProcessFullName, sizeof(cProcessFullName)/sizeof(TCHAR));

       CloseHandle (hProcess);
       HMG_retc (cProcessFullName);
   }
   return;   // return NIL
}


//        GetProcessImageFileName ( [ nProcessID ] ) --> return cProcessImageFileName
HB_FUNC ( GETPROCESSIMAGEFILENAME )
{
_THREAD_LOCK();
   typedef DWORD (WINAPI *Func_GetProcessImageFileName) (HANDLE, LPTSTR, DWORD);
   static Func_GetProcessImageFileName pGetProcessImageFileName = NULL;
   if (pGetProcessImageFileName == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Psapi.dll"));
       #ifdef UNICODE
          pGetProcessImageFileName = (Func_GetProcessImageFileName) GetProcAddress(hLib, "GetProcessImageFileNameW");
       #else
          pGetProcessImageFileName = (Func_GetProcessImageFileName) GetProcAddress(hLib, "GetProcessImageFileNameA");
       #endif
   }
_THREAD_UNLOCK();

   if (pGetProcessImageFileName == NULL)
       return;   // return NIL

   DWORD ProcessID = HB_ISNUM (1) ? (DWORD) hb_parnl(1) : GetCurrentProcessId();
   TCHAR cProcessFullName [ MAX_PATH ] = _TEXT ("");

   HANDLE hProcess = OpenProcess ( PROCESS_QUERY_INFORMATION, FALSE, ProcessID );
   if ( hProcess != NULL )
   {   pGetProcessImageFileName (hProcess, cProcessFullName, sizeof(cProcessFullName)/sizeof(TCHAR));
       CloseHandle (hProcess);
       HMG_retc (cProcessFullName);
   }
   return;   // return NIL
}


//        TerminateProcess ( [ nProcessID ] , [ nExitCode ] )
HB_FUNC ( TERMINATEPROCESS )
{
   DWORD ProcessID = HB_ISNUM (1) ? (DWORD) hb_parnl(1) : GetCurrentProcessId();
   UINT  uExitCode = (UINT) hb_parnl (2);
   HANDLE hProcess = OpenProcess ( PROCESS_TERMINATE, FALSE, ProcessID );
   if ( hProcess != NULL )
   {   if ( TerminateProcess (hProcess, uExitCode) == FALSE )
           CloseHandle (hProcess);
   }
}


static __TLS__ PHB_ITEM pArray;

BOOL CALLBACK EnumWindowsProc (HWND hWnd, LPARAM lParam)
{
   UNREFERENCED_PARAMETER (lParam);

   PHB_ITEM pItem = hb_itemPutNLL (NULL, (LONG_PTR) hWnd);
   hb_arrayAddForward (pArray, pItem);
   hb_itemRelease ( pItem );

   // hb_arrayAddForward (pArray, hb_itemPutNLL (NULL, (LONG_PTR) hWnd));   // with this way occur leak memory
   return TRUE;
}


HB_FUNC ( ENUMWINDOWS )
{
_THREAD_LOCK();

   pArray = hb_itemArrayNew ( 0 );
   EnumWindows ((WNDENUMPROC) EnumWindowsProc, (LPARAM) 0);
   hb_itemReturnRelease ( pArray );
   pArray = NULL;

_THREAD_UNLOCK();
}


HB_FUNC ( ENUMCHILDWINDOWS )
{
_THREAD_LOCK();

   HWND hWnd = (HWND) HMG_parnl (1);
   pArray = hb_itemArrayNew ( 0 );
   EnumChildWindows (hWnd, (WNDENUMPROC) EnumWindowsProc, (LPARAM) 0);
   hb_itemReturnRelease ( pArray );
   pArray = NULL;

_THREAD_UNLOCK();
}


//        GetProcessMemoryInfo ( [ ProcessID ] )  --> return array with 9 numbers
HB_FUNC ( GETPROCESSMEMORYINFO )
{
_THREAD_LOCK();
   typedef BOOL (WINAPI *Func_GetProcessMemoryInfo) (HANDLE,PPROCESS_MEMORY_COUNTERS,DWORD);
   static Func_GetProcessMemoryInfo pGetProcessMemoryInfo = NULL;

   if (pGetProcessMemoryInfo == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Kernel32.dll"));
       pGetProcessMemoryInfo = (Func_GetProcessMemoryInfo) GetProcAddress(hLib, "K32GetProcessMemoryInfo");
   }

   if (pGetProcessMemoryInfo == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Psapi.dll"));
       pGetProcessMemoryInfo = (Func_GetProcessMemoryInfo) GetProcAddress(hLib, "GetProcessMemoryInfo");
   }
_THREAD_UNLOCK();

   if (pGetProcessMemoryInfo == NULL)
       return;   // return NIL

   PROCESS_MEMORY_COUNTERS pmc;

   DWORD ProcessID = HB_ISNUM (1) ? (DWORD) hb_parnl(1) : GetCurrentProcessId();

   HANDLE hProcess = OpenProcess (PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, ProcessID);
   if (NULL == hProcess)
       return;   // return NIL

   pmc.cb = sizeof(pmc);
   if (pGetProcessMemoryInfo (hProcess, &pmc, sizeof(pmc)))
   {
       hb_reta (9);
       hb_storvnll ( pmc.PageFaultCount             , -1, 1 );   // The number of page faults (Numero de fallos de pagina)
       hb_storvnll ( pmc.PeakWorkingSetSize         , -1, 2 );
       hb_storvnll ( pmc.WorkingSetSize             , -1, 3 );   // The current working set size, in bytes (Cantidad de memoria fisica usada actualmente por el proceso)
       hb_storvnll ( pmc.QuotaPeakPagedPoolUsage    , -1, 4 );
       hb_storvnll ( pmc.QuotaPagedPoolUsage        , -1, 5 );   // The current paged pool usage, in bytes (Uso actual del bloque de memoria paginado)
       hb_storvnll ( pmc.QuotaPeakNonPagedPoolUsage , -1, 6 );
       hb_storvnll ( pmc.QuotaNonPagedPoolUsage     , -1, 7 );   // The current nonpaged pool usage, in bytes (Uso actual del bloque de memoria no paginado)
       hb_storvnll ( pmc.PagefileUsage              , -1, 8 );   // Total amount of memory that the memory manager has committed for the running this process, in bytes (Cantidad de memoria virtual reservada por el sistema para el proceso)
       hb_storvnll ( pmc.PeakPagefileUsage          , -1, 9 );
   }

   CloseHandle( hProcess );
}


//        EmptyWorkingSet( [ ProcessID ] ) ---> lBoolean
HB_FUNC ( EMPTYWORKINGSET )
{
   // It removes as many pages as possible from the process working set (clean the working set memory).
   // This operation is useful primarily for testing and tuning.

_THREAD_LOCK();
   typedef BOOL (WINAPI *Func_EmptyWorkingSet) (HANDLE);
   static Func_EmptyWorkingSet pEmptyWorkingSet = NULL;

   if (pEmptyWorkingSet == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Kernel32.dll"));
       pEmptyWorkingSet = (Func_EmptyWorkingSet) GetProcAddress(hLib, "K32EmptyWorkingSet");
   }

   if (pEmptyWorkingSet == NULL)
   {   HMODULE hLib = LoadLibrary (_TEXT("Psapi.dll"));
       pEmptyWorkingSet = (Func_EmptyWorkingSet) GetProcAddress(hLib, "K32EmptyWorkingSet");
   }
_THREAD_UNLOCK();

   if (pEmptyWorkingSet == NULL)
   {   hb_retl ( FALSE );
       return;
   }

   DWORD ProcessID = HB_ISNUM (1) ? (DWORD) hb_parnl(1) : GetCurrentProcessId();

   HANDLE hProcess = OpenProcess (PROCESS_QUERY_LIMITED_INFORMATION | PROCESS_SET_QUOTA, FALSE, ProcessID);
   if (NULL == hProcess)
       return;   // return NIL

   hb_retl ((BOOL) pEmptyWorkingSet (hProcess));

   CloseHandle( hProcess );
}


//        GlobalMemoryStatusEx () --> return array with 7 numbers
HB_FUNC ( GLOBALMEMORYSTATUSEX )
{
   MEMORYSTATUSEX statex;
   statex.dwLength = sizeof (MEMORYSTATUSEX);
   GlobalMemoryStatusEx (&statex);   // reflects the state of memory at the time of the call
   hb_reta (7);
   hb_storvnll ( statex.dwMemoryLoad     , -1, 1 );   // approximate percentage of physical memory that is in use (0 indicates no memory use and 100 indicates full memory use)
   hb_storvnll ( statex.ullTotalPhys     , -1, 2 );   // amount of actual physical memory, in bytes
   hb_storvnll ( statex.ullAvailPhys     , -1, 3 );   // amount of physical memory currently available, in bytes
   hb_storvnll ( statex.ullTotalPageFile , -1, 4 );   // current committed memory limit for the system or the current process, whichever is smaller, in bytes
   hb_storvnll ( statex.ullAvailPageFile , -1, 5 );   // maximum amount of memory the current process can commit, in bytes
   hb_storvnll ( statex.ullTotalVirtual  , -1, 6 );   // size of the user-mode portion of the virtual address space of the calling process, in bytes
   hb_storvnll ( statex.ullAvailVirtual  , -1, 7 );   // amount of unreserved and uncommitted memory currently in the user-mode portion of the virtual address space of the calling process, in bytes
}


/************************************************************************************************/

/*
GDI Objects: https://msdn.microsoft.com/en-us/library/ms724291(v=vs.85).aspx
   Bitmap
   Brush
   DC
   Enhanced metafile
   Enhanced-metafile DC
   Font
   Memory DC
   Metafile
   Metafile DC
   Palette
   Pen and extended pen
   Region

User Objects: https://msdn.microsoft.com/en-us/library/ms725486(v=vs.85).aspx
   Accelerator table
   Caret
   Cursor
   DDE conversation
   Hook
   Icon
   Menu
   Window
   Window position

Kernel Objects: https://msdn.microsoft.com/en-us/library/windows/desktop/ms724485(v=vs.85).aspx
   Access token
   Change notification
   Communications device
   Console input
   Console screen buffer
   Desktop
   Event
   Event log
   File
   File mapping
   Find file
   Heap
   I/O completion port
   Job
   Mailslot
   Memory resource notification
   Module
   Mutex
   Pipe
   Process
   Semaphore
   Socket
   Thread
   Timer
   Update resource
   Window station
*/


//       HMG_GetObjectCount( [ nProcessId ] ) --> returns an array of 3 items with information about
//                                                the number of system objects used for a process { nGDIObjects, nUserObjects, nKernelObjects }
HB_FUNC( HMG_GETOBJECTCOUNT )
{
   DWORD ProcessId = HB_ISNUM (1) ? (DWORD) hb_parnl(1) : GetCurrentProcessId();
   HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, ProcessId);
   if(hProcess != NULL)
   {
      DWORD nGDIObjects = 0, nUserObjects = 0, nKernelObjects = 0;
      nGDIObjects = GetGuiResources(hProcess, GR_GDIOBJECTS);
      nUserObjects = GetGuiResources(hProcess, GR_USEROBJECTS);
      GetProcessHandleCount(hProcess, &nKernelObjects);
      CloseHandle(hProcess);
      hb_reta(3);
      hb_storvni   ((INT) nGDIObjects,    -1, 1);
      hb_storvni   ((INT) nUserObjects,   -1, 2);
      hb_storvni   ((INT) nKernelObjects, -1, 3);
   }
}



//********************************
// by Dr. Claudio Soto, June 2015
//********************************


HMG_DEFINE_DLL_FUNC ( win_MapAndLoad,   // user function name
                      "Imagehlp.dll",   // dll name
                      WINBOOL,          // function return type
                      WINAPI,           // function type
                      "MapAndLoad",     // dll function name
                      (PCSTR ImageName, PCSTR DllPath, PLOADED_IMAGE LoadedImage, WINBOOL DotDll, WINBOOL ReadOnly),   // dll function parameters (types and names)
                      (ImageName, DllPath, LoadedImage, DotDll, ReadOnly),   // function parameters (only names)
                      FALSE                                                  // return value if fail call function of dll
                    )

HMG_DEFINE_DLL_FUNC ( win_UnMapAndLoad,   // user function name
                      "Imagehlp.dll",     // dll name
                      WINBOOL,            // function return type
                      WINAPI,             // function type
                      "UnMapAndLoad",     // dll function name
                      (PLOADED_IMAGE LoadedImage),   // dll function parameters (types and names)
                      (LoadedImage),                 // function parameters (only names)
                      FALSE                          // return value if fail call function of dll
                    )

HMG_DEFINE_DLL_FUNC ( win_ImageDirectoryEntryToData,   // user function name
                      "Dbghelp.dll",                   // dll name
                      PVOID,                           // function return type
                      WINAPI,                          // function type
                      "ImageDirectoryEntryToData",     // dll function name
                      (PVOID Base, BOOLEAN MappedAsImage, USHORT DirectoryEntry, PULONG Size),   // dll function parameters (types and names)
                      (Base, MappedAsImage, DirectoryEntry, Size),   // function parameters (only names)
                      NULL                                           // return value if fail call function of dll
                    )

HMG_DEFINE_DLL_FUNC ( win_ImageRvaToVa,   // user function name
                      "Dbghelp.dll",      // dll name
                      PVOID,              // function return type
                      WINAPI,             // function type
                      "ImageRvaToVa",     // dll function name
                      (PIMAGE_NT_HEADERS NtHeaders,PVOID Base,ULONG Rva,PIMAGE_SECTION_HEADER *LastRvaSection),   // dll function parameters (types and names)
                      (NtHeaders, Base, Rva, LastRvaSection),   // function parameters (only names)
                      NULL                                      // return value if fail call function of dll
                    )


//        HMG_GetDLLFunctions( cDllName ) --> return array { cFuncName1, cFuncName2, ... }
HB_FUNC ( HMG_GETDLLFUNCTIONS )
{
    CHAR *cDllName = (CHAR *) hb_parc (1);
    DWORD *dNameRVAs = NULL;
    LOADED_IMAGE LI;
    IMAGE_EXPORT_DIRECTORY *IED;
    ULONG DirSize;
    CHAR *cFuncName;

    if ( win_MapAndLoad (cDllName, NULL, &LI, TRUE, TRUE) )
    {
        IED = (IMAGE_EXPORT_DIRECTORY *) win_ImageDirectoryEntryToData (LI.MappedAddress, FALSE, IMAGE_DIRECTORY_ENTRY_EXPORT, &DirSize);
        if (IED != NULL)
        {
            dNameRVAs = (DWORD *) win_ImageRvaToVa (LI.FileHeader, LI.MappedAddress, IED->AddressOfNames, NULL);
            ULONG i;
            hb_reta ( IED->NumberOfNames );
            for(i = 0; i < IED->NumberOfNames; i++)
            {
                cFuncName = (CHAR *) win_ImageRvaToVa (LI.FileHeader, LI.MappedAddress, dNameRVAs[i], NULL);
                hb_storvc ( cFuncName, -1, i + 1 );
            }
        }
        win_UnMapAndLoad (&LI);
    }
}


/*
HB_FUNC ( ISAPPTHEMED )
{
   hb_retl ((BOOL) IsAppThemed ());
}


HB_FUNC ( ISTHEMEACTIVE )
{
   hb_retl ((BOOL) IsThemeActive ());
}


HB_FUNC ( OPENTHEMEDATA )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   #ifdef UNICODE
      LPCWSTR cClassList = (LPCWSTR) HMG_parc (2);
   #else
      LPCWSTR cClassList = (LPCWSTR) HMG_MBtoWC (HMG_parc(2)); // --> MultiByteToWideChar()
   #endif
   HTHEME hTheme = OpenThemeData (hWnd, cClassList);
   HMG_retnl ((LONG_PTR) hTheme);
}


HB_FUNC ( CLOSETHEMEDATA )
{
   HTHEME hTheme = (HTHEME) HMG_parnl (1);
   HRESULT hRet  = CloseThemeData (hTheme);
   HMG_retnl ((LONG_PTR) hRet);
}


HB_FUNC ( DRAWTHEMEBACKGROUND )
{
   HTHEME hTheme  = (HTHEME) HMG_parnl (1);
   HDC hDC        = (HDC)    HMG_parnl (2);
   int iPartId    = (INT)    hb_parni  (3);
   int iStateId   = (INT)    hb_parni  (4);
   RECT Rect      = { hb_parvni(5,1), hb_parvni(5,2), hb_parvni(5,3), hb_parvni(5,4) };
   RECT ClipRect  = { hb_parvni(6,1), hb_parvni(6,2), hb_parvni(6,3), hb_parvni(6,4) };
   HRESULT hRet = DrawThemeBackground (hTheme, hDC, iPartId, iStateId, &Rect, (HB_ISNIL(6) ? NULL : &ClipRect));
   HMG_retnl ((LONG_PTR) hRet);
}
*/


HMG_DEFINE_DLL_FUNC ( win_SetWindowTheme,                                   // user function name
                      "uxtheme.dll",                                        // dll name
                      HRESULT,                                              // function return type
                      WINAPI,                                               // function type
                      "SetWindowTheme",                                     // dll function name
                      (HWND hWnd, LPCWSTR SubAppName, LPCWSTR SubIdList),   // dll function parameters (types and names)
                      (hWnd, SubAppName, SubIdList),                        // function parameters (only names)
                      -1                                                    // return value if fail call function of dll
                    )


//        SetWindowTheme (hWnd, cSubAppName, cSubIdList)
HB_FUNC ( SETWINDOWTHEME )
{
   HWND    hWnd = (HWND) HMG_parnl (1);
   HRESULT hRet;
   #ifdef UNICODE
      LPCWSTR SubAppName  = (LPCWSTR) HMG_parc (2);
      LPCWSTR SubIdList   = (LPCWSTR) HMG_parc (3);
   #else
      LPCWSTR SubAppName  = (LPCWSTR) HMG_MBtoWC ( HMG_parc(2) ); // --> MultiByteToWideChar()
      LPCWSTR SubIdList   = (LPCWSTR) HMG_MBtoWC ( HMG_parc(3) ); // --> MultiByteToWideChar()
   #endif
   hRet = win_SetWindowTheme (hWnd, SubAppName, SubIdList);
   HMG_retnl ((LONG_PTR) hRet);
}

