
/*----------------------------------------------------------------------------
 HMG Source File --> c_EventCB.c

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
#include <tchar.h>
#include <commctrl.h>

#include "hbvm.h"
#include "hbapiitm.h"
#include "hbapi.h"

#include "hbthread.h"
extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c


//-------------------------------------------------------------------------------------//
void HMG_GetWindowMessage (HWND, UINT, WPARAM, LPARAM, int, int);
BOOL HMG_EventReturn (LRESULT *ReturnValue);
BOOL HMG_ReadKey (HWND, UINT, WPARAM, LPARAM);
BOOL HMG_ReadMouse (HWND, UINT, WPARAM, LPARAM);

static __TLS__ BOOL New_Behavior_WndProc = FALSE;

static __TLS__ BOOL IsHMGWindowsMessage  = FALSE;
static __TLS__ BOOL IsHookWindowsMessage = FALSE;

static __TLS__ BOOL ProcessHMGWindowsMessage = TRUE;
static __TLS__ BOOL IsCreateEventProcess     = TRUE;
//-------------------------------------------------------------------------------------//


HB_FUNC ( SETCREATEEVENTPROCESS )
{
_THREAD_LOCK();
   hb_retl ((BOOL) IsCreateEventProcess );
   if ( HB_ISLOG (1) )
       IsCreateEventProcess = (BOOL) hb_parl (1);
_THREAD_UNLOCK();
}


HB_FUNC ( SETEVENTPROCESSHMGWINDOWSMESSAGE )
{
_THREAD_LOCK();
   hb_retl ((BOOL) ProcessHMGWindowsMessage );
   if ( HB_ISLOG (1) )
       ProcessHMGWindowsMessage = (BOOL) hb_parl (1);
_THREAD_UNLOCK();
}


#define _HMG_CREATE_EVENT_   1

//-------------------------------------------------------------------------------------//
LRESULT CALLBACK WndProc (HWND hWnd, UINT nMsg, WPARAM wParam, LPARAM lParam)
//-------------------------------------------------------------------------------------//
{

#if _HMG_CREATE_EVENT_
   // by Dr. Claudio Soto, December 2014
   if ( ProcessHMGWindowsMessage == TRUE && IsCreateEventProcess == TRUE )
   {   LRESULT RetValue;
_THREAD_LOCK();
       IsHMGWindowsMessage = TRUE;
       IsHookWindowsMessage = FALSE;
_THREAD_UNLOCK();
       HMG_GetWindowMessage (hWnd, nMsg, wParam, lParam, (WH_MIN -1), -1);
       if ( HMG_EventReturn (&RetValue) == TRUE )
       {    if ( RetValue == -1 )
               return DefWindowProc (hWnd, nMsg, wParam, lParam);
            else
               return RetValue;
       }
   }
#endif

_THREAD_LOCK();

   static __TLS__ PHB_DYNS pDynSym = NULL;

   if ( pDynSym == NULL)
        pDynSym = hb_dynsymFindName ( "EVENTS" );

_THREAD_UNLOCK();

   hb_vmPushSymbol (hb_dynsymSymbol ( pDynSym ));
   hb_vmPushNil ();   /* places NIL at Self */

   hb_vmPushNumInt ((LONG_PTR) hWnd   );  /* pushes a number on to the stack and decides if it is integer or HB_MAXINT */
   hb_vmPushLong   ((LONG)     nMsg   );
   hb_vmPushNumInt ((LONG_PTR) wParam );  /* pushes a number on to the stack and decides if it is integer or HB_MAXINT */
   hb_vmPushNumInt ((LONG_PTR) lParam );  /* pushes a number on to the stack and decides if it is integer or HB_MAXINT */

   hb_vmDo ( 4 );

   LRESULT r = HMG_parnl ( -1 );

   if (New_Behavior_WndProc == FALSE)
   {  if (r == 0)
         return DefWindowProc (hWnd, nMsg, wParam, lParam);
      else
         return r;
   }
   else
   {  if (r == -1)
         return DefWindowProc (hWnd, nMsg, wParam, lParam);
      else
         return r;
   }
}


// by Dr. Claudio Soto (June 2013)
//-------------------------------------------------------------------------------------//
HB_FUNC (SETNEWBEHAVIORWNDPROC)
//-------------------------------------------------------------------------------------//
{
_THREAD_LOCK();
   New_Behavior_WndProc = hb_parl(1);
_THREAD_UNLOCK();
}


// by Dr. Claudio Soto (June 2013)
//-------------------------------------------------------------------------------------//
HB_FUNC (GETNEWBEHAVIORWNDPROC)
//-------------------------------------------------------------------------------------//
{
_THREAD_LOCK();
   hb_retl (New_Behavior_WndProc);
_THREAD_UNLOCK();
}



//*****************************************************************************************************************//
//*   HMG GET GLOBAL MESSAGES                                                                                     *//
//*****************************************************************************************************************//

static __TLS__ HWND   _HMG_hWnd      = NULL;
static __TLS__ UINT   _HMG_nMsg      = 0;
static __TLS__ WPARAM _HMG_wParam    = 0;
static __TLS__ LPARAM _HMG_lParam    = 0;
static __TLS__ int    _HMG_nHookID   = (WH_MIN - 1);
static __TLS__ int    _HMG_nHookCode = -1;

void HMG_GetWindowMessage (HWND hWnd, UINT nMsg, WPARAM wParam, LPARAM lParam, int nHookID, int nHookCode)
{

_THREAD_LOCK();

   static __TLS__ PHB_DYNS pDynSym = NULL;

   _HMG_hWnd      = hWnd;
   _HMG_nMsg      = nMsg;
   _HMG_wParam    = wParam;
   _HMG_lParam    = lParam;
   _HMG_nHookID   = nHookID;
   _HMG_nHookCode = nHookCode;

   BOOL IsKeyboardMessage = HMG_ReadKey   (hWnd, nMsg, wParam, lParam);
   BOOL IsMouseMessage    = HMG_ReadMouse (hWnd, nMsg, wParam, lParam);

   if ( pDynSym == NULL)
        pDynSym = hb_dynsymFindName ( "EventProcess" );

   if ( pDynSym && IsCreateEventProcess )
   {   hb_vmPushSymbol (hb_dynsymSymbol ( pDynSym ));
       hb_vmPushNil ();

       hb_vmPushNumInt ((LONG_PTR) hWnd   );  /* pushes a number on to the stack and decides if it is integer or HB_MAXINT */
       hb_vmPushLong   ((LONG)     nMsg   );
       hb_vmPushNumInt ((LONG_PTR) wParam );  /* pushes a number on to the stack and decides if it is integer or HB_MAXINT */
       hb_vmPushNumInt ((LONG_PTR) lParam );  /* pushes a number on to the stack and decides if it is integer or HB_MAXINT */

       hb_vmPushLogical ((BOOL) IsKeyboardMessage );
       hb_vmPushLogical ((BOOL) IsMouseMessage );
       hb_vmPushLogical ((BOOL) IsHMGWindowsMessage );
       hb_vmPushLong    ((LONG) nHookID );
       hb_vmPushLong    ((LONG) nHookCode );
       hb_vmDo (9);
   }

_THREAD_UNLOCK();

}


//       HMG_GetWindowMessageInfo (@hWnd, @nMsg, @wParam, @lParam, @nMsgTime, @idHook, @nCode)
HB_FUNC (HMG_GETWINDOWMESSAGEINFO)
{
_THREAD_LOCK();

   if (HB_ISBYREF(1))
       HMG_stornl ((LONG_PTR) _HMG_hWnd, 1);
   if (HB_ISBYREF(2))
       hb_stornl ((LONG)_HMG_nMsg, 2);
   if (HB_ISBYREF(3))
       HMG_stornl ((LONG_PTR)_HMG_wParam, 3);
   if (HB_ISBYREF(4))
       HMG_stornl ((LONG_PTR)_HMG_lParam, 4);
   if (HB_ISBYREF(5))
       hb_stornl ((LONG)_HMG_nHookID, 5);
   if (HB_ISBYREF(6))
       hb_stornl ((LONG)_HMG_nHookCode, 6);

   hb_reta (4);
   HMG_storvnl ((LONG_PTR) _HMG_hWnd,   -1, 1);
   hb_storvnl  ((LONG)     _HMG_nMsg,   -1, 2);
   HMG_storvnl ((LONG_PTR) _HMG_wParam, -1, 3);
   HMG_storvnl ((LONG_PTR) _HMG_lParam, -1, 4);

_THREAD_UNLOCK();
}



//*****************************************************************************************************************//
//*   HMG READ KEYBOARD                                                                                           *//
//*****************************************************************************************************************//

static __TLS__ INT      _HMG_KEYDOWN_Code       = 0;
static __TLS__ HWND     _HMG_KEYDOWN_hWnd       = NULL;
static __TLS__ UINT     _HMG_KEYDOWN_nMsg       = 0;
static __TLS__ WPARAM   _HMG_KEYDOWN_wParam     = 0;
static __TLS__ LPARAM   _HMG_KEYDOWN_lParam     = 0;

static __TLS__ INT      _HMG_KEYUP_Code         = 0;
static __TLS__ HWND     _HMG_KEYUP_hWnd         = NULL;
static __TLS__ UINT     _HMG_KEYUP_nMsg         = 0;
static __TLS__ WPARAM   _HMG_KEYUP_wParam       = 0;
static __TLS__ LPARAM   _HMG_KEYUP_lParam       = 0;

static __TLS__ TCHAR    _HMG_TCHAR_Char []      = {0,0};
static __TLS__ HWND     _HMG_TCHAR_hWnd         = NULL;
static __TLS__ UINT     _HMG_TCHAR_nMsg         = 0;
static __TLS__ WPARAM   _HMG_TCHAR_wParam       = 0;
static __TLS__ LPARAM   _HMG_TCHAR_lParam       = 0;

static __TLS__ TCHAR    _HMG_TCHAR_Char_Ex []   = {0,0};
static __TLS__ HWND     _HMG_TCHAR_hWnd_Ex      = NULL;
static __TLS__ UINT     _HMG_TCHAR_nMsg_Ex      = 0;
static __TLS__ WPARAM   _HMG_TCHAR_wParam_Ex    = 0;
static __TLS__ LPARAM   _HMG_TCHAR_lParam_Ex    = 0;


BOOL HMG_ReadKey (HWND hWnd, UINT nMsg, WPARAM wParam, LPARAM lParam)
{
_THREAD_LOCK();
   BOOL ret;
   if (nMsg == WM_HOTKEY)
   {   _HMG_KEYDOWN_Code   = (INT) HIWORD ((DWORD) lParam);
       _HMG_KEYDOWN_hWnd   = hWnd;
       _HMG_KEYDOWN_nMsg   = nMsg;
       _HMG_KEYDOWN_wParam = wParam;
       _HMG_KEYDOWN_lParam = lParam;

       _HMG_KEYUP_Code     = (INT) HIWORD ((DWORD) lParam);
       _HMG_KEYUP_hWnd     = hWnd;
       _HMG_KEYUP_nMsg     = nMsg;
       _HMG_KEYUP_wParam   = wParam;
       _HMG_KEYUP_lParam   = lParam;
       ret = TRUE;
   }
   else if (nMsg == WM_KEYDOWN || nMsg == WM_SYSKEYDOWN)
   {   _HMG_KEYDOWN_Code   = (INT) wParam;
       _HMG_KEYDOWN_hWnd   = hWnd;
       _HMG_KEYDOWN_nMsg   = nMsg;
       _HMG_KEYDOWN_wParam = wParam;
       _HMG_KEYDOWN_lParam = lParam;
       ret = TRUE;
   }
   else if (nMsg == WM_KEYUP || nMsg == WM_SYSKEYUP)
   {   _HMG_KEYUP_Code   = (INT) wParam;
       _HMG_KEYUP_hWnd   = hWnd;
       _HMG_KEYUP_nMsg   = nMsg;
       _HMG_KEYUP_wParam = wParam;
       _HMG_KEYUP_lParam = lParam;
       ret = TRUE;
   }
   else if (nMsg == WM_CHAR || /*nMsg == WM_DEADCHAR ||*/ nMsg == WM_SYSCHAR || /*nMsg == WM_SYSDEADCHAR ||*/ nMsg == WM_MENUCHAR)
   {   _HMG_TCHAR_Char [0]    = (TCHAR) wParam;
       _HMG_TCHAR_hWnd        = hWnd;
       _HMG_TCHAR_nMsg        = nMsg;
       _HMG_TCHAR_wParam      = wParam;
       _HMG_TCHAR_lParam      = lParam;

       _HMG_TCHAR_Char_Ex [0] = (TCHAR) wParam;
       _HMG_TCHAR_hWnd_Ex     = hWnd;
       _HMG_TCHAR_nMsg_Ex     = nMsg;
       _HMG_TCHAR_wParam_Ex   = wParam;
       _HMG_TCHAR_lParam_Ex   = lParam;
       ret = TRUE;
   }
   else
       ret = FALSE;
_THREAD_UNLOCK();

   return ret;
}


//        HMG_GetLastVirtualKeyDown ( [ @hWnd ], [@nMsg], [@wParam], [@lParam] ) --> nVK_Code
HB_FUNC ( HMG_GETLASTVIRTUALKEYDOWN )
{
_THREAD_LOCK();
   if (HB_ISBYREF(1))
       HMG_stornl ((LONG_PTR) _HMG_KEYDOWN_hWnd,   1);
   if (HB_ISBYREF(2))
       hb_stornl  ((LONG)     _HMG_KEYDOWN_nMsg,   2);
   if (HB_ISBYREF(3))
       HMG_stornl ((LONG_PTR) _HMG_KEYDOWN_wParam, 3);
   if (HB_ISBYREF(4))
       HMG_stornl ((LONG_PTR) _HMG_KEYDOWN_lParam, 4);

   HMG_retnl ((LONG_PTR) _HMG_KEYDOWN_Code);
_THREAD_UNLOCK();
}


//        HMG_GetLastVirtualKeyUp ( [ @hWnd ], [@nMsg], [@wParam], [@lParam] ) --> nVK_Code
HB_FUNC ( HMG_GETLASTVIRTUALKEYUP )
{
_THREAD_LOCK();
   if (HB_ISBYREF(1))
       HMG_stornl ((LONG_PTR) _HMG_KEYUP_hWnd,   1);
   if (HB_ISBYREF(2))
       hb_stornl  ((LONG)     _HMG_KEYUP_nMsg,   2);
   if (HB_ISBYREF(3))
       HMG_stornl ((LONG_PTR) _HMG_KEYUP_wParam, 3);
   if (HB_ISBYREF(4))
       HMG_stornl ((LONG_PTR) _HMG_KEYUP_lParam, 4);

   HMG_retnl ((LONG_PTR) _HMG_KEYUP_Code);
_THREAD_UNLOCK();
}


//        HMG_GetLastCharacter ( [ @hWnd ], [@nMsg], [@wParam], [@lParam] ) --> cCharacter
HB_FUNC ( HMG_GETLASTCHARACTER )
{
_THREAD_LOCK();
   if (HB_ISBYREF(1))
       HMG_stornl ((LONG_PTR) _HMG_TCHAR_hWnd,   1);
   if (HB_ISBYREF(2))
       hb_stornl  ((LONG)     _HMG_TCHAR_nMsg,   2);
   if (HB_ISBYREF(3))
       HMG_stornl ((LONG_PTR) _HMG_TCHAR_wParam, 3);
   if (HB_ISBYREF(4))
       HMG_stornl ((LONG_PTR) _HMG_TCHAR_lParam, 4);

   HMG_retc (_HMG_TCHAR_Char);
_THREAD_UNLOCK();
}


//        HMG_GetLastCharacterEx ( [ @hWnd ], [@nMsg], [@wParam], [@lParam] ) --> cCharacter
HB_FUNC ( HMG_GETLASTCHARACTEREX )
{
_THREAD_LOCK();
   if (HB_ISBYREF(1))
       HMG_stornl ((LONG_PTR) _HMG_TCHAR_hWnd_Ex,   1);
   if (HB_ISBYREF(2))
       hb_stornl  ((LONG)     _HMG_TCHAR_nMsg_Ex,   2);
   if (HB_ISBYREF(3))
       HMG_stornl ((LONG_PTR) _HMG_TCHAR_wParam_Ex, 3);
   if (HB_ISBYREF(4))
       HMG_stornl ((LONG_PTR) _HMG_TCHAR_lParam_Ex, 4);

   HMG_retc ( _HMG_TCHAR_Char_Ex );

   _HMG_TCHAR_Char_Ex [0] = 0;
   _HMG_TCHAR_hWnd_Ex     = NULL;
   _HMG_TCHAR_nMsg_Ex     = 0;
   _HMG_TCHAR_wParam_Ex   = 0;
   _HMG_TCHAR_lParam_Ex   = 0;
_THREAD_UNLOCK();
}


//        HMG_GetLastVirtualKeyName ( [ lParam ] ) --> cVK_Name
HB_FUNC ( HMG_GETLASTVIRTUALKEYNAME )
{
_THREAD_LOCK();
   TCHAR cBuffer [256] = {0};
   LONG lParam;
   if (HB_ISNUM(1))
      lParam = HMG_parnl (1);
   else
      lParam = _HMG_KEYDOWN_lParam;
   GetKeyNameText (lParam, cBuffer, 256);
   HMG_retc (cBuffer);
_THREAD_UNLOCK();
}


//        HMG_CleanLastVirtualKeyDown( [lCleanAll] )
HB_FUNC ( HMG_CLEANLASTVIRTUALKEYDOWN )
{
_THREAD_LOCK();
   BOOL lCleanAll = (BOOL) hb_parl (1);
   _HMG_KEYDOWN_Code     = 0;
   if ( lCleanAll == TRUE)
   {   _HMG_KEYDOWN_hWnd     = NULL;
       _HMG_KEYDOWN_nMsg     = 0;
       _HMG_KEYDOWN_wParam   = 0;
       _HMG_KEYDOWN_lParam   = 0;
   }
_THREAD_UNLOCK();
}


//        HMG_CleanLastVirtualKeyUp( [lCleanAll] )
HB_FUNC ( HMG_CLEANLASTVIRTUALKEYUP )
{
_THREAD_LOCK();
   BOOL lCleanAll = (BOOL) hb_parl (1);
   _HMG_KEYUP_Code     = 0;
   if ( lCleanAll == TRUE)
   {   _HMG_KEYUP_hWnd     = NULL;
       _HMG_KEYUP_nMsg     = 0;
       _HMG_KEYUP_wParam   = 0;
       _HMG_KEYUP_lParam   = 0;
   }
_THREAD_UNLOCK();
}


//        HMG_CleanLastCharacter( [lCleanAll] )
HB_FUNC ( HMG_CLEANLASTCHARACTER )
{
_THREAD_LOCK();
   BOOL lCleanAll = (BOOL) hb_parl (1);
   _HMG_TCHAR_Char [0] = 0;
   if ( lCleanAll == TRUE)
   {   _HMG_TCHAR_hWnd    = NULL;
       _HMG_TCHAR_nMsg    = 0;
       _HMG_TCHAR_wParam  = 0;
       _HMG_TCHAR_lParam  = 0;
   }
_THREAD_UNLOCK();
}


//        HMG_VirtualKeyIsPressed (VK_Code)
HB_FUNC ( HMG_VIRTUALKEYISPRESSED )
{
   INT VK_Code = hb_parni(1);
   if (GetKeyState(VK_Code) < 0)
     hb_retl (TRUE);
   else
     hb_retl (FALSE);
}


//        GetKeyState (VK_Code)   --> return nKeyState
HB_FUNC ( GETKEYSTATE )
{
   INT VK_Code = hb_parni(1);
   hb_retni ((INT) GetKeyState (VK_Code));
}


//        HMG_SendCharacter ( [ hWnd ], cText)
HB_FUNC ( HMG_SENDCHARACTER )
{  INT i;
   HWND  hWnd;
   if (HB_ISNUM(1))
       hWnd = (HWND) HMG_parnl (1);
   else
       hWnd = GetFocus ();
   if ( hWnd )
   {   TCHAR *cText = (TCHAR*) HMG_parc (2);
       for (i=0; i < lstrlen(cText); i++)
            PostMessage (hWnd, WM_CHAR, (WPARAM) cText[i], (LPARAM) 0);
   }
}


//        HMG_SendCharacterEx ( [ hWnd ], cText)
HB_FUNC ( HMG_SENDCHARACTEREX )
{  INT i;
   HWND  hWnd;
   if (HB_ISNUM(1))
       hWnd = (HWND) HMG_parnl (1);
   else
       hWnd = GetFocus ();
   if ( hWnd )
   {   TCHAR *cText = (TCHAR*) HMG_parc (2);
       for (i=0; i < lstrlen(cText); i++)
            SendMessage (hWnd, WM_CHAR, (WPARAM) cText[i], (LPARAM) 0);
   }
}


//        HMG_KeyboardClearBuffer()
HB_FUNC ( HMG_KEYBOARDCLEARBUFFER )
{
   MSG Msg;
   while( PeekMessage( &Msg, NULL, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE ) );
}



//*****************************************************************************************************************//
//*   HMG READ MOUSE                                                                                              *//
//*****************************************************************************************************************//

static __TLS__ HWND     _HMG_MOUSE_hWnd     = NULL;
static __TLS__ UINT     _HMG_MOUSE_nMsg     = 0;
static __TLS__ WPARAM   _HMG_MOUSE_wParam   = 0;
static __TLS__ LPARAM   _HMG_MOUSE_lParam   = 0;


BOOL HMG_ReadMouse (HWND hWnd, UINT nMsg, WPARAM wParam, LPARAM lParam)
{
   if ( nMsg >= WM_MOUSEFIRST && nMsg <= WM_MOUSELAST )
   {
_THREAD_LOCK();
      _HMG_MOUSE_hWnd   = hWnd;
      _HMG_MOUSE_nMsg   = nMsg;
      _HMG_MOUSE_wParam = wParam;
      _HMG_MOUSE_lParam = lParam;
_THREAD_UNLOCK();
      return TRUE;
   }
   else
      return FALSE;
}


//        HMG_GetLastMouseMessage ( [ @hWnd ], [@nMsg], [@wParam], [@lParam] ) --> nMsg
HB_FUNC ( HMG_GETLASTMOUSEMESSAGE )
{
_THREAD_LOCK();
   if (HB_ISBYREF(1))
       HMG_stornl ((LONG_PTR) _HMG_MOUSE_hWnd,   1);
   if (HB_ISBYREF(2))
       hb_stornl  ((LONG)     _HMG_MOUSE_nMsg,   2);
   if (HB_ISBYREF(3))
       HMG_stornl ((LONG_PTR) _HMG_MOUSE_wParam, 3);
   if (HB_ISBYREF(4))
       HMG_stornl ((LONG_PTR) _HMG_MOUSE_lParam, 4);

   hb_retnl ((LONG) _HMG_MOUSE_nMsg);
_THREAD_UNLOCK();
}


//        HMG_CleanLastMouseMessage ()
HB_FUNC ( HMG_CLEANLASTMOUSEMESSAGE )
{
_THREAD_LOCK();
   _HMG_MOUSE_hWnd     = NULL;
   _HMG_MOUSE_nMsg     = 0;
   _HMG_MOUSE_wParam   = 0;
   _HMG_MOUSE_lParam   = 0;
_THREAD_UNLOCK();
}


//        HMG_GetCursorPos ( [ hWnd ], @nRow, @nCol ) --> return { nRow, nCol }
HB_FUNC ( HMG_GETCURSORPOS )
{
   HWND  hWnd = (HWND) HMG_parnl (1);
   POINT Point;

   GetCursorPos (&Point);
   if ( IsWindow (hWnd) )
       ScreenToClient (hWnd, &Point);

   if (HB_ISBYREF(2))
       hb_stornl ((LONG) Point.y, 2);

   if (HB_ISBYREF(3))
       hb_stornl ((LONG) Point.x, 3);

   hb_reta (2);
   hb_storvnl ((LONG) Point.y, -1, 1);
   hb_storvnl ((LONG) Point.x, -1, 2);
}


//        HMG_SetCursorPos ( [ hWnd ], nRow, nCol )
HB_FUNC ( HMG_SETCURSORPOS )
{
   HWND  hWnd;
   POINT Point;

   hWnd    = (HWND) HMG_parnl (1);
   Point.y = (LONG) hb_parnl (2);
   Point.x = (LONG) hb_parnl (3);

   if ( IsWindow (hWnd) )
        ClientToScreen (hWnd, &Point);

   SetCursorPos ((int)Point.x, (int)Point.y);
}


//        HMG_MouseClearBuffer()
HB_FUNC ( HMG_MOUSECLEARBUFFER )
{
   MSG Msg;
   while( PeekMessage( &Msg, NULL, WM_MOUSEFIRST, WM_MOUSELAST, PM_REMOVE ) );
}



//*****************************************************************************************************************//
//*   HMG  HOOKS                                                                                                  *//
//*****************************************************************************************************************//

static __TLS__ HHOOK hHook_CallWndProc = NULL;
static __TLS__ HHOOK hHook_MessageProc = NULL;

//   HMG_EventReturn (&ReturnValue) --> Return TRUE if function return a Number, FALSE if return NIL or other value
BOOL HMG_EventReturn (LRESULT *ReturnValue)
{
   if (IsCreateEventProcess == FALSE)
       return FALSE;

   if (hb_parinfo ( -1 ) & HB_IT_NUMERIC)
   {  *ReturnValue = (LRESULT) HMG_parnl ( -1 );
      return TRUE;
   }
   else
   {  *ReturnValue = 0;
      return FALSE;
   }
}


// The system calls this function before calling the window procedure to process a message sent to the thread.
LRESULT CALLBACK CallWndProc (int nCode, WPARAM wParam, LPARAM lParam)
{  LRESULT ReturnValue;
   CWPSTRUCT *Msg;
   if (nCode >= 0  &&  wParam != 0 && IsCreateEventProcess)
   {   Msg = (CWPSTRUCT *) lParam;
_THREAD_LOCK();
       IsHMGWindowsMessage  = FALSE;
       IsHookWindowsMessage = TRUE;
_THREAD_UNLOCK();
       HMG_GetWindowMessage (Msg->hwnd, Msg->message, Msg->wParam, Msg->lParam, WH_CALLWNDPROC, nCode);
       if (HMG_EventReturn (&ReturnValue) == TRUE)
           return 0;   // ReturnValue;   // If the hook procedure does not call CallNextHookEx, the return value should be zero
   }
   return CallNextHookEx(hHook_CallWndProc, nCode, wParam, lParam);
}


// The system calls after an input event occurs in a dialog box, message box, menu, or scroll bar,
// but before the message generated by the input event is processed
LRESULT CALLBACK MessageProc (int nCode, WPARAM wParam, LPARAM lParam)
{  LRESULT ReturnValue;
   MSG *Msg;
   if (nCode >= 0 && IsCreateEventProcess)
   {   Msg = (MSG *) lParam;
_THREAD_LOCK();
       IsHMGWindowsMessage  = FALSE;
       IsHookWindowsMessage = TRUE;
_THREAD_UNLOCK();
       HMG_GetWindowMessage (Msg->hwnd, Msg->message, Msg->wParam, Msg->lParam, WH_MSGFILTER, nCode);
       if (HMG_EventReturn (&ReturnValue) == TRUE)
           return (ReturnValue != 0 ? ReturnValue : 1);   // If the hook procedure processed the message, it may return a nonzero value
   }
   return CallNextHookEx (hHook_MessageProc, nCode, wParam, lParam);
}



HB_FUNC (HMG_HOOK_INSTALL)
{
#if _HMG_CREATE_EVENT_

#ifdef __with__TLS__
   if (hHook_CallWndProc == NULL && hHook_MessageProc == NULL)   // this line is not need for HMG multi-thread without __TLS__
#endif
   {
_THREAD_LOCK();
       hHook_CallWndProc = SetWindowsHookEx (WH_CALLWNDPROC, CallWndProc, (HINSTANCE) NULL, GetCurrentThreadId());
       hHook_MessageProc = SetWindowsHookEx (WH_MSGFILTER,   MessageProc, (HINSTANCE) NULL, GetCurrentThreadId());

       if (hHook_CallWndProc && hHook_MessageProc)
           hb_retl(TRUE);
       else
           hb_retl(FALSE);
_THREAD_UNLOCK();
   }
#ifdef __with__TLS__
   else
      hb_retl(FALSE);
#endif

#endif
}


HB_FUNC (HMG_HOOK_UNINSTALL)
{
_THREAD_LOCK();
   if (hHook_CallWndProc != NULL)
       UnhookWindowsHookEx (hHook_CallWndProc);

   if (hHook_MessageProc != NULL)
       UnhookWindowsHookEx (hHook_MessageProc);
_THREAD_UNLOCK();
}



/**************************************************************/
/*   EventCodeBlock,   by Dr. Claudio Soto,   February 2015   */
/**************************************************************/

static __TLS__ PHB_ITEM  pArrayEventCodeBlock  = NULL;
static __TLS__ HWND      EventCodeBlock_hWnd   = NULL;
static __TLS__ UINT      EventCodeBlock_uMsg   = 0;
static __TLS__ WPARAM    EventCodeBlock_wParam = 0;
static __TLS__ LPARAM    EventCodeBlock_lParam = 0;
static __TLS__ DWORD_PTR EventCodeBlock_nIndex = 0;


typedef struct
{
   HWND hWnd;
   PHB_ITEM  pCodeBlock;
   PHB_ITEM  pArrayMSG;
} EventCBData;


//        GetEventCodeBlockInfo () --> array { hWnd, uMsg, wParam, lParam, nIndex }
HB_FUNC ( GETEVENTCODEBLOCKINFO )
{
_THREAD_LOCK();
   hb_reta (5);
   HMG_storvnl ((LONG_PTR) EventCodeBlock_hWnd,    -1, 1);
   HMG_storvnl ((LONG_PTR) EventCodeBlock_uMsg,    -1, 2);
   HMG_storvnl ((LONG_PTR) EventCodeBlock_wParam,  -1, 3);
   HMG_storvnl ((LONG_PTR) EventCodeBlock_lParam,  -1, 4);
   HMG_storvnl ((LONG_PTR) EventCodeBlock_nIndex,  -1, 5);
_THREAD_UNLOCK();
}


// Process CodeBlocks of SubClassWindow Event
LRESULT CALLBACK SubClassProc (HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam, UINT_PTR uIdSubclass, DWORD_PTR dwRefData)
{
_THREAD_LOCK();

   UNREFERENCED_PARAMETER (uIdSubclass);

   LRESULT nRet;
   BOOL flag = FALSE;

   EventCBData * pEventCBData = (EventCBData *) hb_arrayGetPtr ( pArrayEventCodeBlock, (HB_SIZE) dwRefData );

   if ( pEventCBData )
   {
      HB_SIZE nPos = 0;
      if (pEventCBData->pArrayMSG)
      {
         PHB_ITEM pValue = hb_itemNew ( NULL );
         hb_itemPutNI (pValue, (int) uMsg);
         nPos = hb_arrayScan (pEventCBData->pArrayMSG, pValue, NULL, NULL, HB_FALSE);
         hb_itemRelease (pValue);
      }
      else
         nPos = 1;

      if (pEventCBData->pCodeBlock && nPos > 0)
      {
         EventCodeBlock_hWnd   = hWnd;
         EventCodeBlock_uMsg   = uMsg;
         EventCodeBlock_wParam = wParam;
         EventCodeBlock_lParam = lParam;
         EventCodeBlock_nIndex = dwRefData;

         PHB_ITEM pItem = hb_vmEvalBlock ( pEventCBData->pCodeBlock );

         EventCodeBlock_hWnd   = NULL;
         EventCodeBlock_uMsg   = 0;
         EventCodeBlock_wParam = 0;
         EventCodeBlock_lParam = 0;
         EventCodeBlock_nIndex = 0;

         if ( pItem && ( hb_itemType (pItem) & HB_IT_NUMERIC ))
         {
            #ifdef _WIN64
               nRet = (LRESULT) hb_itemGetNLL (pItem);
            #else
               nRet = (LRESULT) hb_itemGetNL  (pItem);
            #endif
            hb_itemRelease( pItem );
            flag = TRUE;
//          return nRet;
         }
         else
            hb_itemRelease( pItem );
      }
   }
_THREAD_UNLOCK();

   if( flag == TRUE )
      return nRet;

   return DefSubclassProc(hWnd, uMsg, wParam, lParam);
}


//        SetSubClassEvent ( hWnd, CodeBlock [, nMsg | aMsg ] ) --> nIndex
HB_FUNC ( SETSUBCLASSEVENT )
{
_THREAD_LOCK();

   static UINT_PTR uIdSubclass = 0;
   static DWORD_PTR dwRefData  = 0;

   HWND     hWnd       = (HWND) HMG_parnl (1);
   PHB_ITEM pCodeBlock = (HB_ISBLOCK (2) ? hb_itemClone (hb_param (2, HB_IT_BLOCK)) : NULL);

   if (IsWindow(hWnd) && pCodeBlock)
   {
      if (pArrayEventCodeBlock == NULL)
         pArrayEventCodeBlock = hb_itemArrayNew (0);

      EventCBData * pEventCBData = (EventCBData *) hb_xgrab (sizeof (EventCBData));

      PHB_ITEM pArrayMSG  = NULL;

      if (HB_ISNUM (3))
      {
         pArrayMSG = hb_itemArrayNew (0);
         PHB_ITEM pItem = hb_itemPutNI (NULL, hb_parni(3));
         hb_arrayAddForward (pArrayMSG, pItem);
         hb_itemRelease ( pItem );
        // hb_arrayAddForward (pArrayMSG, hb_itemPutNI (NULL, hb_parni(3)));   // with this way occur leak memory
      }
      else if (HB_ISARRAY (3) && (hb_parinfa (3,0) > 0))
         pArrayMSG = hb_itemClone (hb_param (3, HB_IT_ARRAY));

      pEventCBData->hWnd       = hWnd;
      pEventCBData->pCodeBlock = pCodeBlock;
      pEventCBData->pArrayMSG  = pArrayMSG;

      PHB_ITEM pItem = hb_itemPutPtr (NULL, (void *) pEventCBData);
      hb_arrayAddForward (pArrayEventCodeBlock, pItem);
      hb_itemRelease ( pItem );
      // hb_arrayAddForward (pArrayEventCodeBlock, hb_itemPutPtr (NULL, (void *) pEventCBData));   // with this way occur leak memory

      SetWindowSubclass (hWnd, (SUBCLASSPROC) SubClassProc, ++uIdSubclass, ++dwRefData);

      HMG_retnl ((LONG_PTR) uIdSubclass);
   }
   else
      HMG_retnl ((LONG_PTR) 0);

_THREAD_UNLOCK();
}


//        RemoveSubClassEvent ( nIndex ) --> lBoolean
HB_FUNC ( REMOVESUBCLASSEVENT )
{
_THREAD_LOCK();
   UINT_PTR uIdSubclass = (UINT_PTR) HMG_parnl (1);
   BOOL lRet = FALSE;

   if (pArrayEventCodeBlock && (uIdSubclass > 0) && (uIdSubclass <= (UINT_PTR) hb_arrayLen (pArrayEventCodeBlock)))
   {
      EventCBData * pEventCBData = (EventCBData *) hb_arrayGetPtr (pArrayEventCodeBlock, (HB_SIZE) uIdSubclass);

      if (pEventCBData && RemoveWindowSubclass (pEventCBData->hWnd, (SUBCLASSPROC) SubClassProc, uIdSubclass))
      {
         if (pEventCBData->pCodeBlock)
            hb_itemRelease (pEventCBData->pCodeBlock);

         if (pEventCBData->pArrayMSG)
            hb_itemRelease (pEventCBData->pArrayMSG);

         hb_xfree ((void *) pEventCBData);

         hb_arraySetPtr (pArrayEventCodeBlock, (HB_SIZE) uIdSubclass, NULL);
         lRet = TRUE;
      }
   }
   hb_retl (lRet);
_THREAD_UNLOCK();
}


