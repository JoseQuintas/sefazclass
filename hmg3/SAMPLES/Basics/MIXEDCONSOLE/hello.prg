/*
   New C:\hmg.3.4.0\SAMPLES\Basics\MIXEDCONSOLE demo2
   By Pablo César Arrascaeta
   February 23rd, 2015
*/

#include "hmg.ch"

REQUEST HB_GT_WIN_DEFAULT

Function Main()

Public hWnd1, hWnd2

DEFINE WINDOW form_1 AT 100 , 700 WIDTH 200 HEIGHT 200 TITLE "Mixed Mode Demo" MAIN

    DEFINE BUTTON Button_1
       ROW    10
       COL    10
       CAPTION "Test Console"
       ACTION   TestConsole()
    END BUTTON
 
    DEFINE TEXTBOX Text_1
       ROW    110
       COL    30
       WIDTH  120
       HEIGHT 24
       FONTNAME "Arial"
       FONTSIZE 9
       TOOLTIP "Type your name"
       ONENTER TestConsole()
       VALUE ""
    END TEXTBOX

END WINDOW
hWnd1:=GetFormHandle("Form_1")
Form_1.Text_1.SetFocus
ACTIVATE WINDOW form_1
Return Nil

Function TestConsole()
Local cName:=PadR(GetProperty("Form_1","Text_1","Value"),30)

If !ValType(hWnd2)="N"
   hWnd2:=GetConsoleWindowHandle()
Endif
SetForeGroundWindow( hWnd2 )
SetMode(25,80)
CLS
@ 12,00 SAY "Name:" GET cName
READ
If LastKey()=27
   TerminateProcess()
Endif
SetForeGroundWindow( hWnd1 )

Form_1.Text_1.SetFocus
Form_1.Text_1.Value:=cName
Return nil

#pragma BEGINDUMP
#define WINVER 0x0600 // for Vista
#define _WIN32_WINNT 0x0600 // for Vista

#include "windows.h"
#include "hbapi.h"

HB_FUNC( GETCONSOLEWINDOWHANDLE )
{
    HWND hwnd;
    AllocConsole();
    hwnd = FindWindowA("ConsoleWindowClass",NULL);
    hb_retnl( (LONG) hwnd );
}

/* Enable when need to compile with 3.1.14 older versions
HB_FUNC ( SETWINDOWPOS )
{
    HWND hwnd           = (HWND) hb_parnl(1);    // handle to window or control
    HWND hWndInsertAfter= (HWND) hb_parnl(2);    // placement-order handle
    int X               =        hb_parni(3);    // horizontal position
    int Y               =        hb_parni(4);    // vertical position
    int cx              =        hb_parni(5);    // width
    int cy              =        hb_parni(6);    // height
    UINT uFlags         = (UINT) hb_parni(7);    // window-positioning options

    hb_retl( (BOOL) SetWindowPos( hwnd, hWndInsertAfter, X, Y, cx, cy, uFlags ) );
}

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
*/
#pragma ENDDUMP