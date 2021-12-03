/*----------------------------------------------------------------------------
 HMG Source File --> c_TimePicker.c

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

//**********************************************
// I force this file compile in ANSI, because:
//**********************************************

// Date/Time Picker format present different behavior with Unicode and ANSI
// DateTime_SetFormat(hWnd, cTextFormat) NOT WORK IN UNICODE (is a Windows bug ???)
// Macro DateTime_SetFormat() returns TRUE (success) with ANSI and FALSE (failed) with Unicode, with same parameters. GetLastError() is always 0.
// SendMessage (DTM_SETFORMAT) fails too.

/*
#define DTM_SETFORMATA 0x1005 //(MinGW)  // ANSI
#define DTM_SETFORMATW 0x1050 //(MinGW)  // Unicode

#define DTM_FIRST        0x1000           (BCC)
#define DTM_SETFORMATA (DTM_FIRST + 5)    (BCC)  // ANSI
#define DTM_SETFORMATW (DTM_FIRST + 50)   (BCC)  // Unicode

#ifdef UNICODE
#define DTM_SETFORMAT       DTM_SETFORMATW
#else
#define DTM_SETFORMAT       DTM_SETFORMATA
#endif
*/


#include "HMG_UNICODE.h"


//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400


#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "tchar.h"


HB_FUNC ( INITTIMEPICK )
{
   HWND hWnd;
   HWND hWndControl;
   INT  Style = 0;

   INITCOMMONCONTROLSEX icex;
   icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
   icex.dwICC = ICC_DATE_CLASSES;
   InitCommonControlsEx(&icex);

   hWnd = (HWND) HMG_parnl (1);

   if (hb_parl (6) == TRUE)
       Style = Style | DTS_SHOWNONE;

   if (hb_parl (7) == FALSE)
       Style = Style | WS_VISIBLE ;

   if (hb_parl (8) == FALSE)
      Style = Style | WS_TABSTOP ;

   hWndControl = CreateWindowEx ( WS_EX_CLIENTEDGE , DATETIMEPICK_CLASS /*_TEXT("SysDateTimePick32")*/ ,
                                 TEXT(""), Style | WS_CHILD | DTS_TIMEFORMAT | DTS_UPDOWN,
                                 hb_parni(2), hb_parni(3), hb_parni(4), hb_parni(5), hWnd, NULL, GetModuleHandle(NULL), NULL);

   HMG_retnl ((LONG_PTR) hWndControl);
}


HB_FUNC ( SETTIMEPICK )
{
   SYSTEMTIME SystemTime;
   HWND hWnd    = (HWND) HMG_parnl (1);

   SystemTime.wYear  = 2012;   // Official date of birth of HMG-UNICODE (2012/11/25)
   SystemTime.wMonth = 11;
   SystemTime.wDay   = 25;
   SystemTime.wDayOfWeek = 0;

   SystemTime.wHour   = hb_parni (2);
   SystemTime.wMinute = hb_parni (3);
   SystemTime.wSecond = hb_parni (4);
   SystemTime.wMilliseconds = 0;

   hb_retl (DateTime_SetSystemtime (hWnd, GDT_VALID, (LPARAM) &SystemTime));
}


HB_FUNC ( GETTIMEPICK )
{
   SYSTEMTIME SystemTime;
   HWND hWnd = (HWND) HMG_parnl (1);
   hb_reta (3);
   if (DateTime_GetSystemtime(hWnd, &SystemTime) == GDT_VALID)
   {   hb_storvni (SystemTime.wHour,   -1, 1);
       hb_storvni (SystemTime.wMinute, -1, 2);
       hb_storvni (SystemTime.wSecond, -1, 3);
   }
   else   // Return --> {-1, -1, -1}
   {   hb_storvni (-1, -1, 1);
       hb_storvni (-1, -1, 2);
       hb_storvni (-1, -1, 3);
   }
}


HB_FUNC ( SETTIMEPICKNONE )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   hb_retl (DateTime_SetSystemtime (hWnd, GDT_NONE, NULL));
}


HB_FUNC ( DATETIME_SETFORMAT )
{
   HWND  hWnd     = (HWND) HMG_parnl (1);
   hb_retl (DateTime_SetFormat(hWnd, (LPCTSTR) HMG_parc (2)));
   // hb_retl (DateTime_SetFormat(hWnd, _TEXT("hh:mm:ss tt")));   // NOT WORK WITH UNICODE !!!
}

