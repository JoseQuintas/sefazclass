
#define COMPILE_HMG_UNICODE
#include "HMG_UNICODE.h"

/*
 * QHTM wrappers for Harbour
 *
 * Copyright 2002 Alexander S.Kresin <alex@belacy.belgorod.su>
 * www - http://www.geocities.com/alkresin/
*/

#if !defined ( _WIN32_WINNT ) || ( _WIN32_WINNT < 0x0400 )
   #define _WIN32_WINNT 0x0400
#endif


#include <windows.h>

#ifdef __EXPORT__
  #define HB_NO_DEFAULT_API_MACROS
  #define HB_NO_DEFAULT_STACK_MACROS
#endif
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"

#include "qhtm.h"

typedef BOOL ( WINAPI *QHTM_INITIALIZE ) ( HINSTANCE hInst );
typedef int ( WINAPI *QHTM_MESSAGEBOX ) ( HWND hwnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType );
typedef QHTMCONTEXT ( WINAPI *QHTM_PRINTCREATECONTEXT ) ( UINT uZoomLevel );
typedef BOOL ( WINAPI *QHTM_ENABLECOOLTIPS ) ( void );
typedef BOOL ( WINAPI *QHTM_SETHTMLBUTTON ) ( HWND hwndButton );
typedef BOOL ( WINAPI *QHTM_PRINTSETTEXT ) ( QHTMCONTEXT ctx, LPCTSTR pcszText );
typedef BOOL ( WINAPI *QHTM_PRINTSETTEXTFILE ) ( QHTMCONTEXT ctx, LPCTSTR pcszText );
typedef BOOL ( WINAPI *QHTM_PRINTSETTEXTRESOURCE ) ( QHTMCONTEXT ctx, HINSTANCE hInst, LPCTSTR pcszName );
typedef BOOL ( WINAPI *QHTM_PRINTLAYOUT ) ( QHTMCONTEXT ctx, HDC dc, LPCRECT pRect, LPINT nPages );
typedef BOOL ( WINAPI *QHTM_PRINTPAGE ) ( QHTMCONTEXT ctx, HDC hDC, UINT nPage, LPCRECT prDest );
typedef void ( WINAPI *QHTM_PRINTDESTROYCONTEXT ) ( QHTMCONTEXT );

static HINSTANCE  hQhtmDll = NULL;

/*
   QHTM_Init( [cLibName] )
   
   Initialization of library
*/
HB_FUNC( QHTM_INIT )
{
   TCHAR  *cLibname = ( hb_pcount() < 1 ) ? NULL : ( TCHAR * ) HMG_parc( 1 );
   BOOL   bSuccess = FALSE;

   if( !hQhtmDll )
   {
      if( !cLibname )
      {
         #ifdef UNICODE
             cLibname = _TEXT("qhtmu.dll");
         #else
             cLibname = _TEXT("qhtm.dll");
         #endif
      }

      hQhtmDll = LoadLibrary( (LPCTSTR) cLibname );
      if( hQhtmDll )
      {
         QHTM_INITIALIZE   pFunc = ( QHTM_INITIALIZE ) GetProcAddress( hQhtmDll, "QHTM_Initialize" );
         if( pFunc )
         {
            bSuccess = pFunc( GetModuleHandle(NULL) );
         }
      }
   }

   hb_retl( bSuccess );
}

/*
   QHTM_End()
   
   Unload of library
*/
HB_FUNC( QHTM_END )
{
   if( hQhtmDll )
   {
      FreeLibrary( hQhtmDll );
      hQhtmDll = NULL;
   }
}

/*
   CreateQHTM( hParentWindow, nID, nStyle, x1, y1, nWidth, nHeight )
   
   Create QHTM comtrol
*/
HB_FUNC( CREATEQHTM )
{
   if( hQhtmDll )
   {
      HWND  handle = CreateWindow
         (
            _TEXT("QHTM_Window_Class_001"),  /* predefined class */
            NULL,                     /* no window title  */
            WS_CHILD | WS_VISIBLE | hb_parnl(3), /* style */
            hb_parni(4),
            hb_parni(5),                           /* x, y             */
            hb_parni(6),
            hb_parni(7),                           /* nWidth, nHeight  */
            (HWND)  HMG_parnl (1),                 /* parent window    */
            (HMENU) HMG_parnl (2),                 /* control ID       */
            GetModuleHandle(NULL),
            NULL
         );

      HMG_retnl ((LONG_PTR) handle );
   }
   else
   {
      hb_retnl( 0 );
   }
}

/*
   QHTM_GetNotify()
   
   Receive QHTM notification
*/
HB_FUNC( QHTM_GETNOTIFY )
{
   if( hQhtmDll )
   {
      LPNMQHTM pnm = ( LPNMQHTM ) HMG_parnl (1);
      HMG_retc( ( TCHAR * ) pnm->pcszLinkText );
   }
   else
   {
      HMG_retc( _TEXT("") );
   }
}

/*
   QHTM_SetReturnValue()
*/
HB_FUNC( QHTM_SETRETURNVALUE )
{
   LPNMQHTM pnm = ( LPNMQHTM ) HMG_parnl (1);
   pnm->resReturnValue = hb_parl( 2 );
}

/*
   Processing of web-form filling
*/
void CALLBACK FormCallback( HWND hWndQHTM, LPQHTMFORMSubmit pFormSubmit, LPARAM lParam )
{
   PHB_DYNS pSymTest;
   PHB_ITEM aMetr = hb_itemArrayNew( pFormSubmit->uFieldCount );
   PHB_ITEM atemp, temp;
   int      i;

   for( i = 0; i < ( int ) pFormSubmit->uFieldCount; i++ )
   {
      atemp = hb_itemArrayNew( 2 );
      temp = hb_itemPutC( NULL, ( char * ) ((pFormSubmit->parrFields + i)->pcszName) );
      hb_itemArrayPut( atemp, 1, temp );
      hb_itemRelease( temp );
      temp = hb_itemPutC( NULL, ( char * ) ((pFormSubmit->parrFields + i)->pcszValue) );
      hb_itemArrayPut( atemp, 2, temp );
      hb_itemRelease( temp );

      hb_itemArrayPut( aMetr, i + 1, atemp );
      hb_itemRelease( atemp );
   }

   HB_SYMBOL_UNUSED( lParam );

   // Method Submit of HTML-form in application have required
   // procedure QHTMFormProc() (!!! with a such name !!!)
   if( (pSymTest = hb_dynsymFind("QHTMFORMPROC")) != NULL )
   {
      hb_vmPushSymbol( hb_dynsymSymbol(pSymTest) );
      hb_vmPushNil();
      #ifdef _WIN64
          hb_vmPushDouble ((LONG_PTR) hWndQHTM, 0);
      #else
          hb_vmPushLong ((LONG) hWndQHTM );
      #endif
      hb_vmPushString( ( char * ) pFormSubmit->pcszMethod, lstrlen(pFormSubmit->pcszMethod) );
      hb_vmPushString( ( char * ) pFormSubmit->pcszAction, lstrlen(pFormSubmit->pcszAction) );
      if( pFormSubmit->pcszName )
      {
         hb_vmPushString( ( char * ) pFormSubmit->pcszName, lstrlen(pFormSubmit->pcszName) );
      }
      else
      {
         hb_vmPushNil();
      }

      hb_vmPush( aMetr );
      hb_vmDo( 5 );
   }

   hb_itemRelease( aMetr );
}

// Wrappers to QHTM Functions

/*
   QHTM_MessageBox( ( cMessage [,cTitle ] [,nFlags ] ) )
   
   Messages window
*/
HB_FUNC( QHTM_MESSAGEBOX )
{
   if( hQhtmDll )
   {
      const TCHAR       *cTitle = ( hb_pcount() < 2 ) ? _TEXT("") : HMG_parc( 2 );
      UINT              uType = ( hb_pcount() < 3 ) ? MB_OK : ( UINT ) hb_parni( 3 );
      QHTM_MESSAGEBOX   pFunc = ( QHTM_MESSAGEBOX ) GetProcAddress( hQhtmDll, "QHTM_MessageBox" );

      if( pFunc )
      {
         hb_retnl( pFunc(GetActiveWindow(), HMG_parc(1), cTitle, uType) );
      }
   }
   else
   {
      hb_retnl( 1 );
   }
}

/*
   QHTM_LoadFile( handle, cFileName ) 
   
   Load web-page from file
*/
HB_FUNC( QHTM_LOADFILE )
{
   if( hQhtmDll )
   {
      hb_retl( SendMessage((HWND) HMG_parnl (1), QHTM_LOAD_FROM_FILE, 0, (LPARAM) HMG_parc(2)) );
   }
}

/*
   QHTM_LoadRes( handle, cResourceName ) 
   
   Load web-page from resource
*/
HB_FUNC( QHTM_LOADRES )
{
   if( hQhtmDll )
   {
      hb_retl( SendMessage((HWND) HMG_parnl (1), QHTM_LOAD_FROM_RESOURCE, (WPARAM) GetModuleHandle(NULL), (LPARAM) HMG_parc(2)) );
   }
}

/*
  QHTM_AddHtml( handle, cText ) 
   
  Adding web-page text to display text
*/
HB_FUNC( QHTM_ADDHTML )
{
   if( hQhtmDll )
   {
      SendMessage( (HWND) HMG_parnl (1), QHTM_ADD_HTML, 0, (LPARAM) HMG_parc(2) );
   }
}

/*
  QHTM_AddHtml2( handle, cText, bScrollToEnd ) 
   
  Adding web-page text to display text (autoscroll/no scroll)
*/
HB_FUNC( QHTM_ADDHTML2 )
{
   if( hQhtmDll )
   {
      SendMessage( (HWND) HMG_parnl (1), QHTM_ADD_HTML, (WPARAM) hb_parnl(3), (LPARAM) HMG_parc(2) );
   }
}

/*
   QHTM_GetTitle( handle ) 
   
   Receive web-page title (<TITLE></TITLE>)
*/
HB_FUNC( QHTM_GETTITLE )
{
   if( hQhtmDll )
   {
      TCHAR  szBuffer[1024];
      SendMessage( (HWND) HMG_parnl (1), QHTM_GET_HTML_TITLE, sizeof(szBuffer)/sizeof(TCHAR), (LPARAM) szBuffer );
      HMG_retc( szBuffer );
   }
   else
   {
      HMG_retc( _TEXT("") );
   }
}

/*
   QHTM_GetSize( handle ) 
   
   Receive size of loaded web-page
*/
HB_FUNC( QHTM_GETSIZE )
{
   if( hQhtmDll )
   {
      SIZE  size;

      if( SendMessage((HWND) HMG_parnl (1), QHTM_GET_DRAWN_SIZE, 0, (LPARAM) & size) )
      {
         PHB_ITEM aMetr = hb_itemArrayNew( 2 );
         PHB_ITEM temp;

         temp = hb_itemPutNL( NULL, size.cx );
         hb_itemArrayPut( aMetr, 1, temp );
         hb_itemRelease( temp );

         temp = hb_itemPutNL( NULL, size.cy );
         hb_itemArrayPut( aMetr, 2, temp );
         hb_itemRelease( temp );

         hb_itemReturn( aMetr );
         hb_itemRelease( aMetr );
      }
      else
      {
         hb_ret();
      }
   }
}

/*
   QHTM_FormCallback()
   
   Service procedure of QHTM control (for processing of web-form)
*/
HB_FUNC( QHTM_FORMCALLBACK )
{
   if( hQhtmDll )
   {
      hb_retl( SendMessage((HWND) HMG_parnl (1), QHTM_SET_OPTION, (WPARAM) QHTM_OPT_SET_FORM_SUBMIT_CALLBACK, (LPARAM) FormCallback) );
   }
   else
   {
      hb_retl( 0 );
   }
}

/*
   QHTM_EnableCooltips()
   
   Enable web-support in Tooltip
*/
HB_FUNC( QHTM_ENABLECOOLTIPS )
{
   if( hQhtmDll )
   {
      QHTM_ENABLECOOLTIPS  pFunc = ( QHTM_ENABLECOOLTIPS ) GetProcAddress( hQhtmDll, "QHTM_EnableCooltips" );
      if( pFunc )
      {
         hb_retl( pFunc() );
      }
      else
      {
         hb_retl( 0 );
      }
   }
   else
   {
      hb_retl( 0 );
   }
}

/*
   QHTM_SetHTMLButton( handle )
   
   Enable web-support in button
*/
HB_FUNC( QHTM_SETHTMLBUTTON )
{
   if( hQhtmDll )
   {
      QHTM_SETHTMLBUTTON   pFunc = ( QHTM_SETHTMLBUTTON ) GetProcAddress( hQhtmDll, "QHTM_SetHTMLButton" );
      if( pFunc )
      {
         hb_retl( pFunc((HWND) HMG_parnl (1)) );
      }
      else
      {
         hb_retl( 0 );
      }
   }
   else
   {
      hb_retl( 0 );
   }
}

/*
   QHTM_PrintCreateContext() --> hContext 
   
   Create print context
*/
HB_FUNC( QHTM_PRINTCREATECONTEXT )
{
   if( hQhtmDll )
   {
      QHTM_PRINTCREATECONTEXT pFunc = ( QHTM_PRINTCREATECONTEXT ) GetProcAddress( hQhtmDll, "QHTM_PrintCreateContext" );
      hb_retnl( (LONG) pFunc((hb_pcount() == 0) ? 1 : (UINT) hb_parni(1)) );
   }
   else
   {
      hb_retnl( 0 );
   }
}

/*
   QHTM_PrintSetText( hContext, cHtmlText ) 
   
   Print of text
*/
HB_FUNC( QHTM_PRINTSETTEXT )
{
   if( hQhtmDll )
   {
      QHTM_PRINTSETTEXT pFunc = ( QHTM_PRINTSETTEXT ) GetProcAddress( hQhtmDll, "QHTM_PrintSetText" );
      hb_retl( pFunc((QHTMCONTEXT) hb_parnl(1), HMG_parc(2)) );
   }
   else
   {
      hb_retl( 0 );
   }
}

/*
   QHTM_PrintSetTextFile( hContext,cFileName ) 
   
   Print of text file
*/
HB_FUNC( QHTM_PRINTSETTEXTFILE )
{
   if( hQhtmDll )
   {
      QHTM_PRINTSETTEXTFILE   pFunc = ( QHTM_PRINTSETTEXTFILE ) GetProcAddress( hQhtmDll, "QHTM_PrintSetTextFile" );
      hb_retl( pFunc((QHTMCONTEXT) hb_parnl(1), HMG_parc(2)) );
   }
   else
   {
      hb_retl( 0 );
   }
}

/*
   QHTM_PrintSetTextResource( hContext,cResourceName )
   
   Print of resource
*/
HB_FUNC( QHTM_PRINTSETTEXTRESOURCE )
{
   if( hQhtmDll )
   {
      QHTM_PRINTSETTEXTRESOURCE  pFunc = ( QHTM_PRINTSETTEXTRESOURCE ) GetProcAddress( hQhtmDll, "QHTM_PrintSetTextResource" );
      hb_retl( pFunc((QHTMCONTEXT) hb_parnl(1), GetModuleHandle(NULL), HMG_parc(2)) );
   }
   else
   {
      hb_retl( 0 );
   }
}

/*
   QHTM_PrintLayOut( hDC, hContext ) --> nNumberOfPages
   
   Receive print page count
*/
HB_FUNC( QHTM_PRINTLAYOUT )
{
   if( hQhtmDll )
   {
      HDC               hDC = (HDC) HMG_parnl (1);
      QHTMCONTEXT       qhtmCtx = ( QHTMCONTEXT ) hb_parnl( 2 );
      RECT              rcPage;
      int               nNumberOfPages;
      QHTM_PRINTLAYOUT  pFunc = ( QHTM_PRINTLAYOUT ) GetProcAddress( hQhtmDll, "QHTM_PrintLayout" );

      rcPage.left = rcPage.top = 0;
      rcPage.right = GetDeviceCaps( hDC, HORZRES );
      rcPage.bottom = GetDeviceCaps( hDC, VERTRES );

      pFunc( qhtmCtx, hDC, &rcPage, &nNumberOfPages );
      hb_retni( nNumberOfPages );
   }
   else
   {
      hb_retnl( 0 );
   }
}

/*
   QHTM_PrintPage( hDC,hContext,nPage )
   
   Print page
*/
HB_FUNC( QHTM_PRINTPAGE )
{
   if( hQhtmDll )
   {
      HDC            hDC = (HDC) HMG_parnl (1);
      QHTMCONTEXT    qhtmCtx = ( QHTMCONTEXT ) hb_parnl( 2 );
      RECT           rcPage;
      QHTM_PRINTPAGE pFunc = ( QHTM_PRINTPAGE ) GetProcAddress( hQhtmDll, "QHTM_PrintPage" );

      rcPage.left = rcPage.top = 0;
      rcPage.right = GetDeviceCaps( hDC, HORZRES );
      rcPage.bottom = GetDeviceCaps( hDC, VERTRES );

      hb_retl( pFunc(qhtmCtx, hDC, hb_parni(3) - 1, &rcPage) );
   }
   else
   {
      hb_retl( 0 );
   }
}

/*
   QHTM_PrintDestroyContext( hContext )
   
   Clear print context
*/
HB_FUNC( QHTM_PRINTDESTROYCONTEXT )
{
   if( hQhtmDll )
   {
      QHTM_PRINTDESTROYCONTEXT   pFunc = ( QHTM_PRINTDESTROYCONTEXT ) GetProcAddress( hQhtmDll, "QHTM_PrintDestroyContext" );
      pFunc( (QHTMCONTEXT) hb_parnl(1) );
   }
}

