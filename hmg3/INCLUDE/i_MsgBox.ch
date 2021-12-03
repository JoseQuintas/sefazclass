/*----------------------------------------------------------------------------
 HMG Header File --> i_MsgBox.ch  

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

// MessageBox Type Icon/Button

#define MB_USERICON 128
#define MB_ICONASTERISK 64
#define MB_ICONEXCLAMATION 0x30
#define MB_ICONWARNING 0x30
#define MB_ICONERROR 16
#define MB_ICONHAND 16
#define MB_ICONQUESTION 32
#define MB_OK 0
#define MB_ABORTRETRYIGNORE 2
#define MB_APPLMODAL 0
#define MB_DEFAULT_DESKTOP_ONLY 0x20000
#define MB_HELP 0x4000
#define MB_RIGHT 0x80000
#define MB_RTLREADING 0x100000
#define MB_DEFBUTTON1 0
#define MB_DEFBUTTON2 256
#define MB_DEFBUTTON3 512
#define MB_DEFBUTTON4 0x300
#define MB_ICONINFORMATION 64
#define MB_ICONSTOP 16
#define MB_OKCANCEL 1
#define MB_RETRYCANCEL 5
#define MB_SETFOREGROUND 0x10000
#define MB_SYSTEMMODAL 4096
#define MB_TASKMODAL 0x2000
#define MB_YESNO 4
#define MB_YESNOCANCEL 3
#define MB_ICONMASK 240
#define MB_DEFMASK 3840
#define MB_MODEMASK 0x00003000
#define MB_MISCMASK 0x0000C000
#define MB_NOFOCUS 0x00008000
#define MB_TYPEMASK 15
#define MB_TOPMOST 0x40000
#define MB_CANCELTRYCONTINUE 6


// MessageBox Return Value

#define IDOK 1
#define IDCANCEL 2
#define IDABORT 3
#define IDRETRY 4
#define IDIGNORE 5
#define IDYES 6
#define IDNO 7
#define IDCLOSE 8
#define IDHELP 9
#define IDTRYAGAIN 10
#define IDCONTINUE 11

#define IDTIMEDOUT 32000   // HMG_MessageBoxTimeout()


#xtranslate DEBUGINFO [TITLE <xTitle>] [TYPE <nTypeIconButton>] [TIMEOUT <nMilliseconds>] [PARAMETERS] <xData1,...>  => ;
            MsgDebugTitle(<xTitle>); MsgDebugType(<nTypeIconButton>); MsgDebugTimeOut(<nMilliseconds>); MsgDebug (<xData1>)

#xtranslate DEBUGINFO STOREIN <cVar> [TITLE <xTitle>] [TYPE <nTypeIconButton>] [TIMEOUT <nMilliseconds>] [PARAMETERS] <xData1,...>  => ;
            MsgDebugTitle(<xTitle>); MsgDebugType(<nTypeIconButton>); MsgDebugTimeOut(<nMilliseconds>); <cVar> := MsgDebug (<xData1>)


