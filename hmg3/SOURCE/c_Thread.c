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

#include <windows.h>
#include <tlhelp32.h>
#include "hbapiitm.h"
#include "hbapi.h"

#define _HB_API_INTERNAL_
#include "hbthread.h"


HB_FUNC( GETCURRENTTHREADID )
{
   hb_retnl( ( LONG ) GetCurrentThreadId() );
}


HB_FUNC( GETCURRENTTHREADHANDLE )
{
   HANDLE hThread = GetCurrentThread();
   HMG_retnl( ( LONG_PTR ) hThread );
}


HB_FUNC( ATTACHTHREADINPUT )
{
   DWORD idAttach   = hb_parnl( 1 );
   DWORD idAttachTo = hb_parnl( 2 );
   BOOL  fAttach    = hb_parl ( 3 );
   hb_retl( AttachThreadInput( idAttach, idAttachTo, fAttach ) );  // fAttach TRUE = attached, fAttach FALSE = detached
}


HB_FUNC( SUSPENDTHREAD )
{
   HANDLE hThread = ( HANDLE ) HMG_parnl( 1 );
   hb_retnl( SuspendThread( hThread ) );
}


HB_FUNC( RESUMETHREAD )
{
   HANDLE hThread = ( HANDLE ) HMG_parnl( 1 );
   hb_retnl( ResumeThread( hThread ) );
}


HB_FUNC( SWITCHTOTHREAD )
{
   hb_retl( SwitchToThread() );
}


HB_FUNC( SLEEP )
{
   DWORD dwMilliseconds = ( DWORD ) hb_parnl( 1 );
   Sleep( dwMilliseconds );
}


HB_FUNC( POSTTHREADMESSAGE )
{
   DWORD idThread = ( DWORD )  hb_parnl ( 1 );
   UINT Msg       = ( UINT )   hb_parnl ( 2 );
   WPARAM wParam  = ( WPARAM ) HMG_parnl( 3 );
   LPARAM lParam  = ( LPARAM ) HMG_parnl( 4 );
   hb_retl( PostThreadMessage( idThread, Msg, wParam, lParam ) );
}


HB_FUNC( SETTHREADPRIORITY )
{
   HANDLE hThread = ( HANDLE ) HMG_parnl( 1 );
   int nPriority  = hb_parni( 2 );
   hb_retl( SetThreadPriority( hThread, nPriority ) );
}


HB_FUNC( GETTHREADPRIORITY )
{
   HANDLE hThread = ( HANDLE ) HMG_parnl( 1 );
   hb_retni( GetThreadPriority( hThread ) );
}


//   EnumThreadID( [ nProcessID ] ) --> return array { nThreadID1, nThreadID2, ... }
HB_FUNC( ENUMTHREADID )
{
   HANDLE hThreadSnap = INVALID_HANDLE_VALUE;
   THREADENTRY32 te32;
   hThreadSnap = CreateToolhelp32Snapshot( TH32CS_SNAPTHREAD, 0 );
   if( hThreadSnap == INVALID_HANDLE_VALUE )
   {  hb_reta( 0 );
      return;
   }

   te32.dwSize = sizeof( THREADENTRY32 );
   if( !Thread32First( hThreadSnap, &te32 ) )
   {  hb_reta( 0 );
      CloseHandle( hThreadSnap );
      return;
   }

   DWORD ProcessID = HB_ISNUM( 1 ) ? ( DWORD ) hb_parnl( 1 ) : GetCurrentProcessId();

   PHB_ITEM pArray = hb_itemArrayNew( 0 );
   do
   {  if( te32.th32OwnerProcessID == ProcessID )
      {
         PHB_ITEM pItem = hb_itemPutNL( NULL, (LONG) te32.th32ThreadID );
         hb_arrayAddForward( pArray, pItem );
         hb_itemRelease( pItem );
      }
   } while( Thread32Next( hThreadSnap, &te32 ) );

   hb_itemReturnRelease( pArray );

   CloseHandle( hThreadSnap );
}


//   hb_threadStart( [ <nThreadAttrs>, ] <@sStart()> | <bStart> | <cStart> [, <params,...> ] ) -> <pThID>
//   hb_threadSelf() -> <pThID> | NIL

//       HMG_ThreadHBtoWinHandle( <pThID> ) --> Thread Win Handle
HB_FUNC( HMG_THREADHBTOWINHANDLE )
{
   PHB_THREADSTATE pThread = ( PHB_THREADSTATE ) hb_parptr( 1 );
   if( pThread && pThread->th_h )
      HMG_retnl( ( LONG_PTR ) pThread->th_h );
   else
      hb_retnl( -1 );
}


//       HMG_ThreadHBtoWinID( <pThID> ) --> Thread Win ID
HB_FUNC( HMG_THREADHBTOWINID )
{
   PHB_THREADSTATE pThread = ( PHB_THREADSTATE ) hb_parptr( 1 );
   if( pThread )
      HMG_retnl( ( LONG_PTR ) pThread->th_id );
   else
      hb_retnl( -1 );
}


HB_CRITICAL_NEW( _HMG_Mutex );   // create a global Mutex variable

// Macros defined in HMG_UNICODE.h
// #define _THREAD_LOCK()     hb_threadEnterCriticalSection( &_HMG_Mutex )
// #define _THREAD_UNLOCK()   hb_threadLeaveCriticalSection( &_HMG_Mutex )


#define _ARRAY_LEN_   100
static LONG_PTR aShareData [ _ARRAY_LEN_ ];

//       HMG_ThreadShareData( nPosArray, [ nData ] ) --> return old nData
HB_FUNC( HMG_THREADSHAREDATA )
{
   int nPos = hb_parni( 1 ) - 1;
   if( nPos >= 0 && nPos < _ARRAY_LEN_ )
   {  LONG_PTR nData = 0;
      hb_threadEnterCriticalSection( &_HMG_Mutex );   // Thread Lock
         nData = aShareData [ nPos ];
         if( HB_ISNUM( 2 ) )
            aShareData [ nPos ] = ( LONG_PTR ) HMG_parnl( 2 );
      hb_threadLeaveCriticalSection( &_HMG_Mutex );   // Thread Unlock
      HMG_retnl( ( LONG_PTR ) nData );
   }
   else
      hb_retni( -1 );
}

