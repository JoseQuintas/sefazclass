/*----------------------------------------------------------------------------
 HMG Source File --> c_Init.c

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

 ----------------------------------------------------------------------------*/


#include "HMG_UNICODE.h"


#include <windows.h>
#include <commctrl.h>
#include <tchar.h>
#include "hbthread.h"
#include "hbapi.h"

extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c


HB_FUNC ( HMG_ISUNICODE )
{
   hb_retl ((BOOL) _HMG_SupportUnicode_ );
}


HB_FUNC ( HMG_CHARSETNAME )
{
   if ( _HMG_SupportUnicode_ )
      HMG_retc ( _TEXT ("UNICODE") );
   else
      HMG_retc ( _TEXT ("ANSI") );
}


HB_FUNC ( HMG_IS64BITS )
{
   hb_retl ((BOOL) _HMG_Win64_ );
}


BOOL HMG_InitCommonControl (DWORD dwICC)
{
   INITCOMMONCONTROLSEX icex;
   icex.dwSize = sizeof (INITCOMMONCONTROLSEX);
   icex.dwICC  = dwICC;
   return InitCommonControlsEx (&icex);
}


static __TLS__ BOOL  RichEditBoxVer30 = TRUE;

BOOL HMG_IsRichEditBoxVer30()
{
_THREAD_LOCK();
   BOOL lVer30 = RichEditBoxVer30;
_THREAD_UNLOCK();
   return ( lVer30 );
}


#define ICC_CLASSES_NUMBER   16

//       HMG_InitAllCommonControls()
HB_FUNC (HMG_INITALLCOMMONCONTROLS)   // Loaded, registers and initializes all common control DLL (Comctl32.dll) window classes
{
   DWORD dwICC [ ICC_CLASSES_NUMBER ] = { ICC_LISTVIEW_CLASSES,
                                          ICC_TREEVIEW_CLASSES,
                                          ICC_BAR_CLASSES,
                                          ICC_TAB_CLASSES,
                                          ICC_UPDOWN_CLASS,
                                          ICC_PROGRESS_CLASS,
                                          ICC_HOTKEY_CLASS,
                                          ICC_ANIMATE_CLASS,
                                          ICC_DATE_CLASSES,
                                          ICC_USEREX_CLASSES,
                                          ICC_COOL_CLASSES,
                                          ICC_INTERNET_CLASSES,
                                          ICC_PAGESCROLLER_CLASS,
                                          ICC_NATIVEFNTCTL_CLASS,
                                          ICC_STANDARD_CLASSES,
                                          ICC_LINK_CLASS };

   int i;

   for ( i=0; i < ICC_CLASSES_NUMBER; i++ )
        HMG_InitCommonControl ( dwICC [i] );

   // It is necessary to call the LoadLibrary function to load Riched20.dll or Msftedit.dll before the RichEditBox control is created
   HMODULE hLibRichEditBox = LoadLibrary (_TEXT("Msftedit.dll"));
   BOOL lVer30 = FALSE;
   if ( hLibRichEditBox == NULL )
   {    hLibRichEditBox = LoadLibrary (_TEXT("Riched20.dll"));
           lVer30 = TRUE;
   }
   _THREAD_LOCK();
      RichEditBoxVer30 = lVer30;
   _THREAD_UNLOCK();

   hb_retni (i);
}


HB_FUNC ( OLEINITIALIZE )
{  // Applications that use the following functionality must call OleInitialize before calling
   // any other function in the COM library: Clipboard, Drag and Drop, Object linking and embedding (OLE), In-place activation
   OleInitialize (NULL);
}


HB_FUNC ( OLEUNINITIALIZE )
{
   OleUninitialize ();
}


HB_FUNC ( HMG_GETINSTANCE )
{
   HMODULE hInstance = GetModuleHandle (NULL);
   HMG_retnl ( (LONG_PTR) hInstance );
}

/*
WCHAR * hmg_MBtoWC ( CHAR * srcA )
{
   int length;
   WCHAR *dstW = NULL;
   if ( srcA )
   {   length = MultiByteToWideChar( CP_ACP, 0, srcA, -1, NULL, 0 );
       dstW = (WCHAR *) hb_xgrab ( length * sizeof( WCHAR ) );
       MultiByteToWideChar( CP_ACP, 0, srcA, -1, dstW, length );
   }
   return dstW;
}


CHAR * hmg_WCtoMB ( WCHAR * srcW )
{
   int length;
   CHAR *dstA = NULL;
   if ( srcW )
   {   length = WideCharToMultiByte( CP_ACP, 0, srcW, -1, NULL, 0, NULL, NULL );
       dstA = (CHAR *) hb_xgrab ( length * sizeof( CHAR ) );
       WideCharToMultiByte( CP_ACP, 0, srcW, -1, dstA, length, NULL, NULL );
   }
   return dstA;
}
*/


// e.g.   HMG_Trace( __FILE__, __LINE__, __FUNCTION__, _TEXT("%s %p"), cText, hWnd );

#include <stdio.h>
void HMG_Trace( const char * file, int line, const char * function, TCHAR * fmt, ... )
{
_THREAD_LOCK();

   if( file )
   {
      while( *file == '.' || *file == '/' || *file == '\\' )
         file++;
   }
   else
      file = "";

   static BOOL bCreate = TRUE;
   FILE * fp = NULL;

   if( bCreate )
   {
      fp = _tfopen( _TEXT("hmg_trace.txt"), _TEXT("w") );
      bCreate = FALSE;
   }
   else
      fp = _tfopen( _TEXT("hmg_trace.txt"), _TEXT("a") );

   if( fp )
   {
      va_list ap;
      va_start( ap, fmt );

      fprintf( fp, "%s:%d:%s() ", file, line, function );   // Print file, line and function
      _vftprintf( fp, fmt, ap );      // Print the name and arguments for the function
      _ftprintf( fp, _TEXT("\n") );   // Print a new-line

      va_end( ap );
   }

   if( fp )
      fclose( fp );

_THREAD_UNLOCK();
}

