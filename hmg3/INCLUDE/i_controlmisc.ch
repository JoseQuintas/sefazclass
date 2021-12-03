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
	Copyright 1999-2003, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net> 

	"HWGUI"
  	Copyright 2001-2007 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

// System Cursor ID
#define IDC_ARROW  (32512)
#define IDC_IBEAM  (32513)
#define IDC_WAIT  (32514)
#define IDC_CROSS  (32515)
#define IDC_UPARROW  (32516)
#define IDC_SIZENWSE  (32642)
#define IDC_SIZENESW  (32643)
#define IDC_SIZEWE  (32644)
#define IDC_SIZENS  (32645)
#define IDC_SIZEALL  (32646)
#define IDC_NO  (32648)
#define IDC_HAND  (32649)
#define IDC_APPSTARTING  (32650)
#define IDC_HELP  (32651)
#define IDC_ICON  (32641)
#define IDC_SIZE  (32640)

#xcommand QUIT  => RELEASE WINDOW ALL

#xcommand SETFOCUS <n> OF <w>;
	=>;
	DoMethod ( <"w"> , <"n"> , 'SetFocus' )

#xcommand ADD ITEM <i> TO <n> OF <p> ;
	=>;
	DoMethod ( <"p"> , <"n"> , 'AddItem' , <i> )

#xcommand ADD COLUMN [ INDEX <index> ] [ CAPTION <caption> ] [ WIDTH <width> ] [ JUSTIFY <justify> ] TO <control> OF <parent> ;
	=>;
	DoMethod ( <"parent"> , <"control"> , 'AddColumn' , <index> , <caption> , <width> , <justify> )

#xcommand DELETE COLUMN [ INDEX ] <index> FROM <control> OF <parent> ;
	=>;
	DoMethod ( <"parent"> , <"control"> , 'DeleteColumn' , <index> )

#xcommand DELETE ITEM <i> FROM <n> OF <p>;
	=>;
	DoMethod ( <"p"> , <"n"> , 'DeleteItem' , <i> )

#xcommand DELETE ITEM ALL FROM <n> OF <p>;
	=>;
	DoMethod ( <"p"> , <"n"> , 'DeleteAllItems' )

#xcommand ENABLE CONTROL <control> OF <form>;
	=>;
	SetProperty ( <"form"> , <"control"> , 'Enabled' , .T. )

#xcommand SHOW CONTROL <control> OF <form>;
	=>;
	DoMethod ( <"form"> , <"control"> , 'Show' )

#xcommand HIDE CONTROL <control> OF <form>;
	=>;
	DoMethod ( <"form"> , <"control"> , 'Hide' )

#xcommand DISABLE CONTROL <control> OF <form>;
	=>;
	SetProperty ( <"form"> , <"control"> , 'Enabled' , .F. )

#xcommand RELEASE CONTROL <control> OF <form>;
	=>;
	DoMethod ( <"form"> , <"control"> , 'Release' ) 

#xcommand SET FONT TO <fontname> , <fontsize>;
	=>;
	_HMG_SYSDATA \[ 342 \] := <fontname> ; _HMG_SYSDATA \[ 343 \] := <fontsize>

#xtranslate MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> <Arg4> ;
=> ;
SetProperty ( <"Arg1"> , <"Arg2"> , <"Arg3"> , <Arg4> )

#xtranslate MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> ( <Arg4> ) <Arg5> ;
=> ;
SetProperty ( <"Arg1"> , <"Arg2"> , <"Arg3"> , <Arg4> , <Arg5> )

#xtranslate FETCH [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> TO <Arg4> ;
=> ;
<Arg4> := GetProperty ( <"Arg1"> , <"Arg2"> , <"Arg3"> )

#xtranslate FETCH [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> (<Arg4>) TO <Arg5> ;
=> ;
<Arg5> := GetProperty ( <"Arg1"> , <"Arg2"> , <"Arg3"> , <Arg4> )

#xtranslate MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> .T. ;
=> ;
SetProperty ( <"Arg1"> , <"Arg2"> , <"Arg3"> , .T. )

#xtranslate MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> .F. ;
=> ;
SetProperty ( <"Arg1"> , <"Arg2"> , <"Arg3"> , .F. )

#xtranslate MODIFY [ PROPERTY ] [ CONTROL ] <Arg2> OF <Arg1> <Arg3> { <Arg4, ...> } ;
=> ;
SetProperty ( <"Arg1"> , <"Arg2"> , <"Arg3"> , \{<Arg4>\} )


#xcommand SET MULTIPLE ON  [<warning: WARNING>] => SetMultiple (.T., <.warning.>)
#xcommand SET MULTIPLE OFF [<warning: WARNING>] => SetMultiple (.F., <.warning.>)


#xtranslate SET CONTEXTMENUS OFF =>  _HMG_SYSDATA \[ 338 \] := .F.
#xtranslate SET CONTEXTMENUS ON  =>  _HMG_SYSDATA \[ 338 \] := .T.

#xtranslate SET CONTEXTMENU OFF =>  _HMG_SYSDATA \[ 338 \] := .F.
#xtranslate SET CONTEXTMENU ON  =>  _HMG_SYSDATA \[ 338 \] := .T.

#xtranslate SET CONTEXT MENU OFF =>  _HMG_SYSDATA \[ 338 \] := .F.
#xtranslate SET CONTEXT MENU ON  =>  _HMG_SYSDATA \[ 338 \] := .T.


#xcommand EXIT PROCEDURE <name> ;
=> ;
INIT PROCEDURE <name> ;;
	MsgStop ('EXIT PROCEDURE Statement is not Supported in HMG. Use Main Window ON RELEASE Event Procedure Instead. Program Terminated','HMG Error') ;;
	ExitProcess()

#xtranslate SET SCROLLSTEP TO <step> =>  _HMG_SYSDATA \[ 345 \] := <step>
#xtranslate SET SCROLLPAGE TO <step> =>  _HMG_SYSDATA \[ 501 \] := <step>


#xtranslate SET AUTOSCROLL ON =>  _HMG_SYSDATA \[ 346 \] := .T.
#xtranslate SET AUTOSCROLL OFF =>  _HMG_SYSDATA \[ 346 \] := .F.

#xtranslate System.EmptyClipboard => EmptyClipboard()
#xtranslate System.Clipboard => GetClipboard()
#xtranslate System.Clipboard := <arg> => SetClipboard(<arg>)
#xtranslate System.DesktopWidth => GetDesktopWidth()
#xtranslate System.DesktopHeight => GetDesktopHeight()
#xtranslate System.DefaultPrinter => GetDefaultPrinter()


#xtranslate System.DesktopFolder => GetDesktopFolder()
#xtranslate System.MyDocumentsFolder => GetMyDocumentsFolder()
#xtranslate System.ProgramFilesFolder => GetProgramFilesFolder()
#xtranslate System.SystemFolder => GetSystemFolder()
#xtranslate System.TempFolder => GetTempFolder()
#xtranslate System.WindowsFolder => GetWindowsFolder()



// by Dr. Claudio Soto ( May 2013 )

#xtranslate SET CONTROL CONTEXTMENUS OFF =>  _HMG_SetControlContextMenu := .F.
#xtranslate SET CONTROL CONTEXTMENUS ON  =>  _HMG_SetControlContextMenu := .T.

#xtranslate SET CONTROL CONTEXTMENU OFF  =>  _HMG_SetControlContextMenu := .F.
#xtranslate SET CONTROL CONTEXTMENU ON   =>  _HMG_SetControlContextMenu := .T.

#xtranslate SET CONTROL CONTEXT MENU OFF =>  _HMG_SetControlContextMenu := .F.
#xtranslate SET CONTROL CONTEXT MENU ON  =>  _HMG_SetControlContextMenu := .T.


// by Dr. Claudio Soto ( January 2014 )

// GetFontList ( [ hDC ] , [ cFontFamilyName ] , [ nCharSet ] , [ nPitch ] , [ nFontType ] , [ lSortCaseSensitive ] , [ @aFontName ] )
//
//             --> return array { { cFontName, nCharSet, nPitchAndFamily, nFontType } , ... }


// nCharSet
#define DEFAULT_CHARSET       1
#define ANSI_CHARSET          0
#define SYMBOL_CHARSET        2
#define SHIFTJIS_CHARSET      128
#define HANGEUL_CHARSET       129
#define HANGUL_CHARSET        129
#define GB2312_CHARSET        134
#define CHINESEBIG5_CHARSET   136
#define GREEK_CHARSET         161
#define TURKISH_CHARSET       162
#define HEBREW_CHARSET        177
#define ARABIC_CHARSET        178
#define BALTIC_CHARSET        186
#define RUSSIAN_CHARSET       204
#define THAI_CHARSET          222
#define EASTEUROPE_CHARSET    238
#define OEM_CHARSET           255
#define JOHAB_CHARSET         130
#define VIETNAMESE_CHARSET    163
#define MAC_CHARSET           77


// nPitch
#define FONT_DEFAULT_PITCH      0
#define FONT_FIXED_PITCH        1
#define FONT_VARIABLE_PITCH     2


// nFontType
#define FONT_VECTOR_TYPE     1
#define FONT_RASTER_TYPE     2
#define FONT_TRUE_TYPE       3



//*************************************************************************
// HMG_LoadResourceRawFile ( cFileName, cTypeResource | nTypeResourceID )
//*************************************************************************

// Standard resource types ID
#define RT_CURSOR       (1)
#define RT_FONT         (8)
#define RT_BITMAP       (2)
#define RT_ICON         (3)
#define RT_MENU         (4)
#define RT_DIALOG       (5)
#define RT_STRING       (6)
#define RT_FONTDIR      (7)
#define RT_ACCELERATOR  (9)
#define RT_RCDATA       (10)
#define RT_MESSAGETABLE (11)
#define RT_DIFFERENCE   (11)
#define RT_GROUP_CURSOR ( RT_CURSOR + RT_DIFFERENCE )
#define RT_GROUP_ICON   ( RT_ICON   + RT_DIFFERENCE )
#define RT_VERSION      (16)
#define RT_DLGINCLUDE   (17)
#define RT_PLUGPLAY     (19)
#define RT_VXD          (20)
#define RT_ANICURSOR    (21)
#define RT_ANIICON      (22)
#define RT_HTML         (23)
#define RT_MANIFEST     (24)



// by Dr. Claudio Soto (June 2014)

#xtranslate SET CONTROL <ControlName> OF <FormName> ONKEYEVENT   <ProcName> => _HMG_SetControlData (<"ControlName">, <"FormName">, 41, 1, <{ProcName}>)
#xtranslate SET CONTROL <ControlName> OF <FormName> ONMOUSEEVENT <ProcName> => _HMG_SetControlData (<"ControlName">, <"FormName">, 41, 2, <{ProcName}>)

#define WM_MOUSEACTIVATE 33
#define WM_MOUSEMOVE 512
#define WM_LBUTTONDOWN 513
#define WM_LBUTTONUP 514
#define WM_LBUTTONDBLCLK 515
#define WM_RBUTTONDOWN 516
#define WM_RBUTTONUP 517
#define WM_RBUTTONDBLCLK 518
#define WM_MBUTTONDOWN 519
#define WM_MBUTTONUP 520
#define WM_MBUTTONDBLCLK 521
#define WM_MOUSEWHEEL 522
#define WM_MOUSEFIRST 512
#define WM_XBUTTONDOWN 523
#define WM_XBUTTONUP 524
#define WM_XBUTTONDBLCLK 525
#define WM_MOUSEHOVER	0x2A1
#define WM_MOUSELEAVE	0x2A3

#define WM_NCHITTEST 132
#define WM_NCLBUTTONDBLCLK 163
#define WM_NCLBUTTONDOWN 161
#define WM_NCLBUTTONUP 162
#define WM_NCMBUTTONDBLCLK 169
#define WM_NCMBUTTONDOWN 167
#define WM_NCMBUTTONUP 168
#define WM_NCXBUTTONDOWN 171
#define WM_NCXBUTTONUP 172
#define WM_NCXBUTTONDBLCLK 173
#define WM_NCMOUSEHOVER 0x02A0
#define WM_NCMOUSELEAVE 0x02A2
#define WM_NCMOUSEMOVE 160
#define WM_NCRBUTTONDBLCLK 166
#define WM_NCRBUTTONDOWN 164
#define WM_NCRBUTTONUP 165

#define WM_CAPTURECHANGED 533
#define WM_MOUSEHWHEEL   0x020E

#define WM_TOUCHMOVE 576
#define WM_TOUCHDOWN 577
#define WM_TOUCHUP 578


#define NM_FIRST        0
#define NM_CUSTOMDRAW (NM_FIRST-12)
#define WM_NOTIFY       78


#define WM_PAINT            15
#define WM_NCPAINT          133
#define WM_PAINTICON        38
#define WM_PRINT            791
#define WM_PRINTCLIENT      792
#define WM_DRAWITEM         43
#define WM_ERASEBKGND       20
#define WM_ICONERASEBKGND   39
#define WM_SYNCPAINT        136


#define GCL_HBRBACKGROUND (-10)

#define WM_SETFONT 48
#define WM_GETFONT 49

#define MAKELONG(a,b)  (hb_bitOR (a, hb_bitSHIFT (b,16)))   // (a | b << 16)
#define MAKELPARAM(a,b) MAKELONG(a,b)
#define MAKEWPARAM(a,b) MAKELONG(a,b)


#xtranslate SET CONTROL <ControlName> OF <FormName> CLIENTEDGE => HMG_ChangeWindowStyle (GetControlHandle (<"ControlName">, <"FormName">), WS_EX_CLIENTEDGE, NIL, .T.)
#xtranslate SET CONTROL <ControlName> OF <FormName> STATICEDGE => HMG_ChangeWindowStyle (GetControlHandle (<"ControlName">, <"FormName">), WS_EX_STATICEDGE, NIL, .T.)
#xtranslate SET CONTROL <ControlName> OF <FormName> WINDOWEDGE => HMG_ChangeWindowStyle (GetControlHandle (<"ControlName">, <"FormName">), WS_EX_WINDOWEDGE, NIL, .T.)
#xtranslate SET CONTROL <ControlName> OF <FormName> NOTEDGE    => HMG_ChangeWindowStyle (GetControlHandle (<"ControlName">, <"FormName">), NIL, HB_bitOR (WS_EX_CLIENTEDGE, WS_EX_STATICEDGE, WS_EX_WINDOWEDGE), .T.)


//   Change Notification Functions

#define WAIT_OBJECT_0   0

#define FILE_NOTIFY_CHANGE_FILE_NAME	0x00000001
#define FILE_NOTIFY_CHANGE_DIR_NAME	0x00000002
#define FILE_NOTIFY_CHANGE_NAME		0x00000003
#define FILE_NOTIFY_CHANGE_ATTRIBUTES	0x00000004
#define FILE_NOTIFY_CHANGE_SIZE		0x00000008
#define FILE_NOTIFY_CHANGE_LAST_WRITE	0x00000010
#define FILE_NOTIFY_CHANGE_LAST_ACCESS	0x00000020
#define FILE_NOTIFY_CHANGE_CREATION	0x00000040
#define FILE_NOTIFY_CHANGE_EA		0x00000080
#define FILE_NOTIFY_CHANGE_SECURITY	0x00000100
#define FILE_NOTIFY_CHANGE_STREAM_NAME	0x00000200
#define FILE_NOTIFY_CHANGE_STREAM_SIZE	0x00000400
#define FILE_NOTIFY_CHANGE_STREAM_WRITE	0x00000800
#define FILE_NOTIFY_VALID_MASK		0x00000fff



// ToolTip Style
#define TTS_BALLOON 0x40


// GetBinaryType ( cApplicationName ) --> nBinaryType
#define SCS_32BIT_BINARY   0 // A 32-bit Windows-based application
#define SCS_64BIT_BINARY   6 // A 64-bit Windows-based application.
#define SCS_DOS_BINARY     1 // An MS-DOS – based application
#define SCS_OS216_BINARY   5 // A 16-bit OS/2-based application
#define SCS_PIF_BINARY     3 // A PIF file that executes an MS-DOS – based application
#define SCS_POSIX_BINARY   4 // A POSIX – based application
#define SCS_WOW_BINARY     2 // A 16-bit Windows-based application

