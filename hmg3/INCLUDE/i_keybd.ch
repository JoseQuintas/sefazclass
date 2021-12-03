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




#xcommand SET INTERACTIVECLOSE OFF ;
=> ;
_HMG_SYSDATA \[ 339 \] := 0 

#xcommand SET INTERACTIVECLOSE ON ;
=> ;
_HMG_SYSDATA \[ 339 \] := 1

#xcommand SET INTERACTIVECLOSE QUERY;
=> ;
_HMG_SYSDATA \[ 339 \] := 2

#xcommand SET INTERACTIVECLOSE QUERY MAIN ;
=> ;
_HMG_SYSDATA \[ 339 \] := 3

#xtranslate SET NAVIGATION EXTENDED ;
=> ;
_HMG_SYSDATA \[ 255 \] := .T.

#xtranslate SET NAVIGATION STANDARD ;
=> ;
_HMG_SYSDATA \[ 255 \] := .F.

#xtranslate SET CELLNAVIGATIONMODE EXCEL ;
=> ;
_HMG_SYSDATA \[ 284 \] := .T.

#xtranslate SET CELLNAVIGATIONMODE STANDARD ;
=> ;
_HMG_SYSDATA \[ 284 \] := .F.


///////////////////////////////////////////////////////////////////////////////
// Virtual key Codes And Modifiers
///////////////////////////////////////////////////////////////////////////////

/*
#define VK_LBUTTON	1
#define VK_RBUTTON	2
#define VK_CANCEL	3
#define VK_MBUTTON	4
#define VK_BACK	8
#define VK_TAB	9
#define VK_CLEAR	12
#define VK_RETURN	13
#define VK_SHIFT	16
#define VK_CONTROL	17
#define VK_MENU	18
#define VK_PAUSE	19
#define VK_PRINT	42
#define VK_CAPITAL	20
#define VK_KANA	0x15
#define VK_HANGEUL	0x15
#define VK_HANGUL	0x15
#define VK_JUNJA	0x17
#define VK_FINAL	0x18
#define VK_HANJA	0x19
#define VK_KANJI	0x19
#define VK_CONVERT	0x1C
#define VK_NONCONVERT	0x1D
#define VK_ACCEPT	0x1E
#define VK_MODECHANGE	0x1F
#define VK_ESCAPE	27
#define VK_SPACE	32
#define VK_PRIOR	33
#define VK_NEXT	34
#define VK_END	35
#define VK_HOME	36
#define VK_LEFT	37
#define VK_UP	38
#define VK_RIGHT	39
#define VK_DOWN	40
#define VK_SELECT	41
#define VK_EXECUTE	43
#define VK_SNAPSHOT	44
#define VK_INSERT	45
#define VK_DELETE	46
#define VK_HELP	47
*/

// Virtual Key not defined in WinUser.h
#define VK_ALT VK_MENU

#define VK_0	48
#define VK_1	49
#define VK_2	50
#define VK_3	51
#define VK_4	52
#define VK_5	53
#define VK_6	54
#define VK_7	55
#define VK_8	56
#define VK_9	57
#define VK_A	65
#define VK_B	66
#define VK_C	67
#define VK_D	68
#define VK_E	69
#define VK_F	70
#define VK_G	71
#define VK_H	72
#define VK_I	73
#define VK_J	74
#define VK_K	75
#define VK_L	76
#define VK_M	77
#define VK_N	78
#define VK_O	79
#define VK_P	80
#define VK_Q	81
#define VK_R	82
#define VK_S	83
#define VK_T	84
#define VK_U	85
#define VK_V	86
#define VK_W	87
#define VK_X	88
#define VK_Y	89
#define VK_Z	90
/*
#define VK_LWIN	0x5B
#define VK_RWIN	0x5C
#define VK_APPS	0x5D
#define VK_NUMPAD0	96
#define VK_NUMPAD1	97
#define VK_NUMPAD2	98
#define VK_NUMPAD3	99
#define VK_NUMPAD4	100
#define VK_NUMPAD5	101
#define VK_NUMPAD6	102
#define VK_NUMPAD7	103
#define VK_NUMPAD8	104
#define VK_NUMPAD9	105
#define VK_MULTIPLY	106
#define VK_ADD	107
#define VK_SEPARATOR	108
#define VK_SUBTRACT	109
#define VK_DECIMAL	110
#define VK_DIVIDE	111
#define VK_F1	112
#define VK_F2	113
#define VK_F3	114
#define VK_F4	115
#define VK_F5	116
#define VK_F6	117
#define VK_F7	118
#define VK_F8	119
#define VK_F9	120
#define VK_F10	121
#define VK_F11	122
#define VK_F12	123
#define VK_F13	124
#define VK_F14	125
#define VK_F15	126
#define VK_F16	127
#define VK_F17	128
#define VK_F18	129
#define VK_F19	130
#define VK_F20	131
#define VK_F21	132
#define VK_F22	133
#define VK_F23	134
#define VK_F24	135
#define VK_NUMLOCK	144
#define VK_SCROLL	145
#define VK_LSHIFT	160
#define VK_LCONTROL	162
#define VK_LMENU	164
#define VK_RSHIFT	161
#define VK_RCONTROL	163
#define VK_RMENU	165
#define VK_PROCESSKEY	229

#define MOD_ALT	1
#define MOD_CONTROL	2
#define MOD_SHIFT	4
#define MOD_WIN	8

// End
*/


// Window Message Keyboard
#define WM_CHAR 258
#define WM_DEADCHAR 259
#define WM_KEYDOWN 256
#define WM_KEYUP 257
#define WM_SYSCHAR 262
#define WM_SYSDEADCHAR 263
#define WM_SYSKEYDOWN 260
#define WM_SYSKEYUP 261
#define WM_MENUCHAR 288
#define WM_KEYFIRST     256
#define WM_KEYLAST      265
#define WM_UNICHAR      265
#define UNICODE_NOCHAR  0xffff
#define WM_HOTKEY 0x0312

// Virtual Key
#define VK_LBUTTON	1
#define VK_RBUTTON	2
#define VK_CANCEL	3
#define VK_MBUTTON	4
#define VK_XBUTTON1	5
#define VK_XBUTTON2	6
#define VK_BACK	8
#define VK_TAB	9
#define VK_CLEAR	12
#define VK_RETURN	13
#define VK_SHIFT	16
#define VK_CONTROL	17
#define VK_MENU	18
#define VK_PAUSE	19
#define VK_CAPITAL	20
#define VK_KANA	0x15
#define VK_HANGEUL	0x15
#define VK_HANGUL	0x15
#define VK_JUNJA	0x17
#define VK_FINAL	0x18
#define VK_HANJA	0x19
#define VK_KANJI	0x19
#define VK_ESCAPE	0x1B
#define VK_CONVERT	0x1C
#define VK_NONCONVERT	0x1D
#define VK_ACCEPT	0x1E
#define VK_MODECHANGE	0x1F
#define VK_SPACE	32
#define VK_PRIOR	33
#define VK_NEXT	34
#define VK_END	35
#define VK_HOME	36
#define VK_LEFT	37
#define VK_UP	38
#define VK_RIGHT	39
#define VK_DOWN	40
#define VK_SELECT	41
#define VK_PRINT	42
#define VK_EXECUTE	43
#define VK_SNAPSHOT	44
#define VK_INSERT	45
#define VK_DELETE	46
#define VK_HELP	47
#define VK_LWIN	0x5B
#define VK_RWIN	0x5C
#define VK_APPS	0x5D
#define VK_SLEEP	0x5F
#define VK_NUMPAD0	0x60
#define VK_NUMPAD1	0x61
#define VK_NUMPAD2	0x62
#define VK_NUMPAD3	0x63
#define VK_NUMPAD4	0x64
#define VK_NUMPAD5	0x65
#define VK_NUMPAD6	0x66
#define VK_NUMPAD7	0x67
#define VK_NUMPAD8	0x68
#define VK_NUMPAD9	0x69
#define VK_MULTIPLY	0x6A
#define VK_ADD	0x6B
#define VK_SEPARATOR	0x6C
#define VK_SUBTRACT	0x6D
#define VK_DECIMAL	0x6E
#define VK_DIVIDE	0x6F
#define VK_F1	0x70
#define VK_F2	0x71
#define VK_F3	0x72
#define VK_F4	0x73
#define VK_F5	0x74
#define VK_F6	0x75
#define VK_F7	0x76
#define VK_F8	0x77
#define VK_F9	0x78
#define VK_F10	0x79
#define VK_F11	0x7A
#define VK_F12	0x7B
#define VK_F13	0x7C
#define VK_F14	0x7D
#define VK_F15	0x7E
#define VK_F16	0x7F
#define VK_F17	0x80
#define VK_F18	0x81
#define VK_F19	0x82
#define VK_F20	0x83
#define VK_F21	0x84
#define VK_F22	0x85
#define VK_F23	0x86
#define VK_F24	0x87
#define VK_NUMLOCK	0x90
#define VK_SCROLL	0x91
#define VK_LSHIFT	0xA0
#define VK_RSHIFT	0xA1
#define VK_LCONTROL	0xA2
#define VK_RCONTROL	0xA3
#define VK_LMENU	0xA4
#define VK_RMENU	0xA5
#define VK_BROWSER_BACK	0xA6
#define VK_BROWSER_FORWARD	0xA7
#define VK_BROWSER_REFRESH	0xA8
#define VK_BROWSER_STOP	0xA9
#define VK_BROWSER_SEARCH	0xAA
#define VK_BROWSER_FAVORITES	0xAB
#define VK_BROWSER_HOME	0xAC
#define VK_VOLUME_MUTE	0xAD
#define VK_VOLUME_DOWN	0xAE
#define VK_VOLUME_UP	0xAF
#define VK_MEDIA_NEXT_TRACK	0xB0
#define VK_MEDIA_PREV_TRACK	0xB1
#define VK_MEDIA_STOP	0xB2
#define VK_MEDIA_PLAY_PAUSE	0xB3
#define VK_LAUNCH_MAIL	0xB4
#define VK_LAUNCH_MEDIA_SELECT	0xB5
#define VK_LAUNCH_APP1	0xB6
#define VK_LAUNCH_APP2	0xB7
#define VK_OEM_1	0xBA
#define VK_OEM_PLUS	0xBB
#define VK_OEM_COMMA	0xBC
#define VK_OEM_MINUS	0xBD
#define VK_OEM_PERIOD	0xBE
#define VK_OEM_2	0xBF
#define VK_OEM_3	0xC0
#define VK_OEM_4	0xDB
#define VK_OEM_5	0xDC
#define VK_OEM_6	0xDD
#define VK_OEM_7	0xDE
#define VK_OEM_8	0xDF
#define VK_OEM_102	0xE2
#define VK_PROCESSKEY	0xE5
#define VK_PACKET	0xE7
#define VK_ATTN	0xF6
#define VK_CRSEL	0xF7
#define VK_EXSEL	0xF8
#define VK_EREOF	0xF9
#define VK_PLAY	0xFA
#define VK_ZOOM	0xFB
#define VK_NONAME	0xFC
#define VK_PA1	0xFD
#define VK_OEM_CLEAR	0xFE


// Mouse Key
#define MK_LBUTTON	1
#define MK_RBUTTON	2
#define MK_SHIFT	4
#define MK_CONTROL	8
#define MK_MBUTTON	16
#define MK_XBUTTON1	32
#define MK_XBUTTON2	64


#define MOD_ALT 1
#define MOD_CONTROL 2
#define MOD_SHIFT 4
#define MOD_WIN 8
#define MOD_IGNORE_ALL_MODIFIER 1024
#define MOD_ON_KEYUP  2048
#define MOD_RIGHT 16384
#define MOD_LEFT 32768



///////////////////////////////////////////////////////////////////////////////
// HOOK used in HMG
///////////////////////////////////////////////////////////////////////////////

// Min and Max Hook ID
#define WH_MIN         (-1)
#define WH_MAX          14

// Hook ID
#define WH_MSGFILTER   (-1)
#define WH_CALLWNDPROC  4

// Hook Code (WH_MSGFILTER)
#define MSGF_DIALOGBOX 0
#define MSGF_MESSAGEBOX 1
#define MSGF_MENU 2
#define MSGF_MOVE 3
#define MSGF_SIZE 4
#define MSGF_SCROLLBAR 5
#define MSGF_NEXTWINDOW 6
#define MSGF_MAINLOOP 8
#define MSGF_USER 4096

///////////////////////////////////////////////////////////////////////////////
// ON KEY
///////////////////////////////////////////////////////////////////////////////

/*
  The following ON KEY, RELEASE KEY, and STORE KEY commands cover English 
  alphabetic, numeric, keypad, navigation, and some punctuation keys.  Other 
  keys are not covered because they are mapped to OEM virtual key codes, 
  whose interpretations vary from one keyboard to another.  For example, 
  unmodified VK_OEM_2 maps to the "/" key on the US keyboard, the "^" key on 
  the German keyboard, and the "é" key on the French keyboard.  In such 
  cases, the HMG_GETLAST* functions may be useful, in a timer, ON CHANGE 
  method, or other such location.
*/

// Plain Keys

#xcommand ON KEY UNSHIFT+A [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_A , <{action}> )

#xcommand ON KEY UNSHIFT+B [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_B , <{action}> )

#xcommand ON KEY UNSHIFT+C [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_C , <{action}> )

#xcommand ON KEY UNSHIFT+D [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_D , <{action}> )

#xcommand ON KEY UNSHIFT+E [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_E , <{action}> )

#xcommand ON KEY UNSHIFT+F [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F , <{action}> )

#xcommand ON KEY UNSHIFT+G [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_G , <{action}> )

#xcommand ON KEY UNSHIFT+H [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_H , <{action}> )

#xcommand ON KEY UNSHIFT+I [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_I , <{action}> )

#xcommand ON KEY UNSHIFT+J [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_J , <{action}> )

#xcommand ON KEY UNSHIFT+K [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_K , <{action}> )

#xcommand ON KEY UNSHIFT+L [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_L , <{action}> )

#xcommand ON KEY UNSHIFT+M [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_M , <{action}> )

#xcommand ON KEY UNSHIFT+N [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_N , <{action}> )

#xcommand ON KEY UNSHIFT+O [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_O , <{action}> )

#xcommand ON KEY UNSHIFT+P [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_P , <{action}> )

#xcommand ON KEY UNSHIFT+Q [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_Q , <{action}> )

#xcommand ON KEY UNSHIFT+R [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_R , <{action}> )

#xcommand ON KEY UNSHIFT+S [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_S , <{action}> )

#xcommand ON KEY UNSHIFT+T [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_T , <{action}> )

#xcommand ON KEY UNSHIFT+U [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_U , <{action}> )

#xcommand ON KEY UNSHIFT+V [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_V , <{action}> )

#xcommand ON KEY UNSHIFT+W [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_W , <{action}> )

#xcommand ON KEY UNSHIFT+X [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_X , <{action}> )

#xcommand ON KEY UNSHIFT+Y [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_Y , <{action}> )

#xcommand ON KEY UNSHIFT+Z [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_Z , <{action}> )

#xcommand ON KEY 0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_0 , <{action}> )

#xcommand ON KEY 1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_1 , <{action}> )

#xcommand ON KEY 2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_2 , <{action}> )

#xcommand ON KEY 3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_3 , <{action}> )

#xcommand ON KEY 4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_4 , <{action}> )

#xcommand ON KEY 5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_5 , <{action}> )

#xcommand ON KEY 6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_6 , <{action}> )

#xcommand ON KEY 7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_7 , <{action}> )

#xcommand ON KEY 8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_8 , <{action}> )

#xcommand ON KEY 9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_9 , <{action}> )

#xcommand ON KEY F1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F1 , <{action}> )

#xcommand ON KEY F2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F2 , <{action}> )

#xcommand ON KEY F3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F3 , <{action}> )

#xcommand ON KEY F4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F4 , <{action}> )

#xcommand ON KEY F5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F5 , <{action}> )

#xcommand ON KEY F6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F6 , <{action}> )

#xcommand ON KEY F7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F7 , <{action}> )

#xcommand ON KEY F8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F8 , <{action}> )

#xcommand ON KEY F9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F9 , <{action}> )

#xcommand ON KEY F10 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F10 , <{action}> )

#xcommand ON KEY F11 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F11 , <{action}> )

#xcommand ON KEY F12 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_F12 , <{action}> )

#xcommand ON KEY SPACE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_SPACE , <{action}> )

#xcommand ON KEY BACK [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_BACK , <{action}> )

#xcommand ON KEY TAB [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_TAB , <{action}> )

#xcommand ON KEY RETURN [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_RETURN , <{action}> )
 	
#xcommand ON KEY ESCAPE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_ESCAPE , <{action}> )

#xcommand ON KEY INSERT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_INSERT , <{action}> )
  
#xcommand ON KEY DELETE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_DELETE , <{action}> )

#xcommand ON KEY HOME [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_HOME , <{action}> )

#xcommand ON KEY END [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_END , <{action}> )
 
#xcommand ON KEY PRIOR [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_PRIOR , <{action}> )
  
#xcommand ON KEY NEXT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NEXT , <{action}> )

#xcommand ON KEY LEFT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_LEFT , <{action}> )
 	
#xcommand ON KEY UP [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_UP , <{action}> )

#xcommand ON KEY RIGHT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_RIGHT , <{action}> )

#xcommand ON KEY DOWN [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_DOWN , <{action}> )
 	
#xcommand ON KEY ADD [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_ADD , <{action}> )

#xcommand ON KEY SUBTRACT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_SUBTRACT , <{action}> )

#xcommand ON KEY MULTIPLY [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_MULTIPLY , <{action}> )

#xcommand ON KEY DIVIDE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_DIVIDE , <{action}> )

#xcommand ON KEY DECIMAL [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_DECIMAL , <{action}> )

#xcommand ON KEY NUMPAD0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD0 , <{action}> )

#xcommand ON KEY NUMPAD1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD1 , <{action}> )

#xcommand ON KEY NUMPAD2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD2 , <{action}> )

#xcommand ON KEY NUMPAD3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD3 , <{action}> )

#xcommand ON KEY NUMPAD4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD4 , <{action}> )

#xcommand ON KEY NUMPAD5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD5 , <{action}> )

#xcommand ON KEY NUMPAD6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD6 , <{action}> )

#xcommand ON KEY NUMPAD7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD7 , <{action}> )

#xcommand ON KEY NUMPAD8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD8 , <{action}> )

#xcommand ON KEY NUMPAD9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , 0 , VK_NUMPAD9 , <{action}> )


// Alt Mod Keys

#xcommand ON KEY ALT+A [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_A , <{action}> )

#xcommand ON KEY ALT+B [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_B , <{action}> )

#xcommand ON KEY ALT+C [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_C , <{action}> )

#xcommand ON KEY ALT+D [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_D , <{action}> )

#xcommand ON KEY ALT+E [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_E , <{action}> )

#xcommand ON KEY ALT+F [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F , <{action}> )

#xcommand ON KEY ALT+G [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_G , <{action}> )

#xcommand ON KEY ALT+H [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_H , <{action}> )

#xcommand ON KEY ALT+I [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_I , <{action}> )

#xcommand ON KEY ALT+J [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_J , <{action}> )

#xcommand ON KEY ALT+K [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_K , <{action}> )

#xcommand ON KEY ALT+L [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_L , <{action}> )

#xcommand ON KEY ALT+M [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_M , <{action}> )

#xcommand ON KEY ALT+N [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_N , <{action}> )

#xcommand ON KEY ALT+O [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_O , <{action}> )

#xcommand ON KEY ALT+P [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_P , <{action}> )

#xcommand ON KEY ALT+Q [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_Q , <{action}> )

#xcommand ON KEY ALT+R [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_R , <{action}> )

#xcommand ON KEY ALT+S [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_S , <{action}> )

#xcommand ON KEY ALT+T [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_T , <{action}> )

#xcommand ON KEY ALT+U [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_U , <{action}> )

#xcommand ON KEY ALT+V [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_V , <{action}> )

#xcommand ON KEY ALT+W [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_W , <{action}> )

#xcommand ON KEY ALT+X [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_X , <{action}> )

#xcommand ON KEY ALT+Y [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_Y , <{action}> )

#xcommand ON KEY ALT+Z [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_Z , <{action}> )

#xcommand ON KEY ALT+0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_0 , <{action}> )

#xcommand ON KEY ALT+1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_1 , <{action}> )

#xcommand ON KEY ALT+2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_2 , <{action}> )

#xcommand ON KEY ALT+3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_3 , <{action}> )

#xcommand ON KEY ALT+4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_4 , <{action}> )

#xcommand ON KEY ALT+5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_5 , <{action}> )

#xcommand ON KEY ALT+6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_6 , <{action}> )

#xcommand ON KEY ALT+7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_7 , <{action}> )

#xcommand ON KEY ALT+8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_8 , <{action}> )

#xcommand ON KEY ALT+9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_9 , <{action}> )

#xcommand ON KEY ALT+F1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F1 , <{action}> )

#xcommand ON KEY ALT+F2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F2 , <{action}> )

#xcommand ON KEY ALT+F3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F3 , <{action}> )

#xcommand ON KEY ALT+F4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F4 , <{action}> )

#xcommand ON KEY ALT+F5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F5 , <{action}> )

#xcommand ON KEY ALT+F6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F6 , <{action}> )

#xcommand ON KEY ALT+F7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F7 , <{action}> )

#xcommand ON KEY ALT+F8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F8 , <{action}> )

#xcommand ON KEY ALT+F9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F9 , <{action}> )

#xcommand ON KEY ALT+F10 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F10 , <{action}> )

#xcommand ON KEY ALT+F11 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F11 , <{action}> )

#xcommand ON KEY ALT+F12 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_F12 , <{action}> )

#xcommand ON KEY ALT+SPACE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_SPACE , <{action}> )

#xcommand ON KEY ALT+BACK [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_BACK , <{action}> )

#xcommand ON KEY ALT+TAB [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_TAB , <{action}> )

#xcommand ON KEY ALT+RETURN [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_RETURN , <{action}> )
 	
#xcommand ON KEY ALT+ESCAPE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_ESCAPE , <{action}> )
 	
#xcommand ON KEY ALT+INSERT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_INSERT , <{action}> )
  
#xcommand ON KEY ALT+DELETE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_DELETE , <{action}> )

#xcommand ON KEY ALT+HOME [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_HOME , <{action}> )

#xcommand ON KEY ALT+END [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_END , <{action}> )
 
#xcommand ON KEY ALT+PRIOR [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_PRIOR , <{action}> )
  
#xcommand ON KEY ALT+NEXT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NEXT , <{action}> )

#xcommand ON KEY ALT+LEFT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_LEFT , <{action}> )
 	
#xcommand ON KEY ALT+UP [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_UP , <{action}> )

#xcommand ON KEY ALT+RIGHT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_RIGHT , <{action}> )

#xcommand ON KEY ALT+DOWN [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_DOWN , <{action}> )
 	
#xcommand ON KEY ALT+ADD [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_ADD , <{action}> )

#xcommand ON KEY ALT+SUBTRACT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_SUBTRACT , <{action}> )

#xcommand ON KEY ALT+MULTIPLY [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_MULTIPLY , <{action}> )

#xcommand ON KEY ALT+DIVIDE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_DIVIDE , <{action}> )

#xcommand ON KEY ALT+DECIMAL [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_DECIMAL , <{action}> )

#xcommand ON KEY ALT+NUMPAD0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD0, <{action}> )

#xcommand ON KEY ALT+NUMPAD1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD1 , <{action}> )

#xcommand ON KEY ALT+NUMPAD2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD2 , <{action}> )

#xcommand ON KEY ALT+NUMPAD3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD3 , <{action}> )

#xcommand ON KEY ALT+NUMPAD4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD4 , <{action}> )

#xcommand ON KEY ALT+NUMPAD5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD5 , <{action}> )

#xcommand ON KEY ALT+NUMPAD6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD6 , <{action}> )

#xcommand ON KEY ALT+NUMPAD7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD7 , <{action}> )

#xcommand ON KEY ALT+NUMPAD8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD8 , <{action}> )

#xcommand ON KEY ALT+NUMPAD9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD9 , <{action}> )


// Shift Mod Keys

#xcommand ON KEY SHIFT+A [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_A , <{action}> )

#xcommand ON KEY SHIFT+B [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_B , <{action}> )

#xcommand ON KEY SHIFT+C [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_C , <{action}> )

#xcommand ON KEY SHIFT+D [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_D , <{action}> )

#xcommand ON KEY SHIFT+E [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_E , <{action}> )

#xcommand ON KEY SHIFT+F [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F , <{action}> )

#xcommand ON KEY SHIFT+G [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_G , <{action}> )

#xcommand ON KEY SHIFT+H [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_H , <{action}> )

#xcommand ON KEY SHIFT+I [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_I , <{action}> )

#xcommand ON KEY SHIFT+J [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_J , <{action}> )

#xcommand ON KEY SHIFT+K [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_K , <{action}> )

#xcommand ON KEY SHIFT+L [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_L , <{action}> )

#xcommand ON KEY SHIFT+M [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_M , <{action}> )

#xcommand ON KEY SHIFT+N [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_N , <{action}> )

#xcommand ON KEY SHIFT+O [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_O , <{action}> )

#xcommand ON KEY SHIFT+P [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_P , <{action}> )

#xcommand ON KEY SHIFT+Q [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_Q , <{action}> )

#xcommand ON KEY SHIFT+R [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_R , <{action}> )

#xcommand ON KEY SHIFT+S [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_S , <{action}> )

#xcommand ON KEY SHIFT+T [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_T , <{action}> )

#xcommand ON KEY SHIFT+U [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_U , <{action}> )

#xcommand ON KEY SHIFT+V [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_V , <{action}> )

#xcommand ON KEY SHIFT+W [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_W , <{action}> )

#xcommand ON KEY SHIFT+X [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_X , <{action}> )

#xcommand ON KEY SHIFT+Y [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_Y , <{action}> )

#xcommand ON KEY SHIFT+Z [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_Z , <{action}> )

#xcommand ON KEY SHIFT+0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_0 , <{action}> )

#xcommand ON KEY SHIFT+1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_1 , <{action}> )

#xcommand ON KEY SHIFT+2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_2 , <{action}> )

#xcommand ON KEY SHIFT+3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_3 , <{action}> )

#xcommand ON KEY SHIFT+4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_4 , <{action}> )

#xcommand ON KEY SHIFT+5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_5 , <{action}> )

#xcommand ON KEY SHIFT+6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_6 , <{action}> )

#xcommand ON KEY SHIFT+7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_7 , <{action}> )

#xcommand ON KEY SHIFT+8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_8 , <{action}> )

#xcommand ON KEY SHIFT+9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_9 , <{action}> )

#xcommand ON KEY SHIFT+F1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F1 , <{action}> )

#xcommand ON KEY SHIFT+F2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F2 , <{action}> )

#xcommand ON KEY SHIFT+F3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F3 , <{action}> )

#xcommand ON KEY SHIFT+F4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F4 , <{action}> )

#xcommand ON KEY SHIFT+F5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F5 , <{action}> )

#xcommand ON KEY SHIFT+F6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F6 , <{action}> )

#xcommand ON KEY SHIFT+F7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F7 , <{action}> )

#xcommand ON KEY SHIFT+F8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F8 , <{action}> )

#xcommand ON KEY SHIFT+F9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F9 , <{action}> )

#xcommand ON KEY SHIFT+F10 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F10 , <{action}> )

#xcommand ON KEY SHIFT+F11 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F11 , <{action}> )

#xcommand ON KEY SHIFT+F12 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_F12 , <{action}> )

#xcommand ON KEY SHIFT+SPACE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_SPACE , <{action}> )

#xcommand ON KEY SHIFT+BACK [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_BACK , <{action}> )

#xcommand ON KEY SHIFT+TAB [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_TAB , <{action}> )

#xcommand ON KEY SHIFT+RETURN [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_RETURN , <{action}> )
 	
#xcommand ON KEY SHIFT+ESCAPE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_ESCAPE , <{action}> )
 	
#xcommand ON KEY SHIFT+INSERT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_INSERT , <{action}> )
  
#xcommand ON KEY SHIFT+DELETE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_DELETE , <{action}> )

#xcommand ON KEY SHIFT+HOME [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_HOME , <{action}> )

#xcommand ON KEY SHIFT+END [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_END , <{action}> )
 
#xcommand ON KEY SHIFT+PRIOR [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_PRIOR , <{action}> )
  
#xcommand ON KEY SHIFT+NEXT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NEXT , <{action}> )

#xcommand ON KEY SHIFT+LEFT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_LEFT , <{action}> )
 	
#xcommand ON KEY SHIFT+UP [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_UP , <{action}> )

#xcommand ON KEY SHIFT+RIGHT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_RIGHT , <{action}> )

#xcommand ON KEY SHIFT+DOWN [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_DOWN , <{action}> )
 	
#xcommand ON KEY SHIFT+ADD [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_ADD , <{action}> )

#xcommand ON KEY SHIFT+SUBTRACT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_SUBTRACT , <{action}> )

#xcommand ON KEY SHIFT+MULTIPLY [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_MULTIPLY , <{action}> )

#xcommand ON KEY SHIFT+DIVIDE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_DIVIDE , <{action}> )

#xcommand ON KEY SHIFT+DECIMAL [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_DECIMAL , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD0, <{action}> )

#xcommand ON KEY SHIFT+NUMPAD1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD1 , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD2 , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD3 , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD4 , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD5 , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD6 , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD7 , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD8 , <{action}> )

#xcommand ON KEY SHIFT+NUMPAD9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD9 , <{action}> )


// Control Mod Keys

#xcommand ON KEY CONTROL+A [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_A , <{action}> )

#xcommand ON KEY CONTROL+B [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_B , <{action}> )

#xcommand ON KEY CONTROL+C [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_C , <{action}> )

#xcommand ON KEY CONTROL+D [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_D , <{action}> )

#xcommand ON KEY CONTROL+E [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_E , <{action}> )

#xcommand ON KEY CONTROL+F [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F , <{action}> )

#xcommand ON KEY CONTROL+G [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_G , <{action}> )

#xcommand ON KEY CONTROL+H [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_H , <{action}> )

#xcommand ON KEY CONTROL+I [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_I , <{action}> )

#xcommand ON KEY CONTROL+J [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_J , <{action}> )

#xcommand ON KEY CONTROL+K [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_K , <{action}> )

#xcommand ON KEY CONTROL+L [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_L , <{action}> )

#xcommand ON KEY CONTROL+M [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_M , <{action}> )

#xcommand ON KEY CONTROL+N [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_N , <{action}> )

#xcommand ON KEY CONTROL+O [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_O , <{action}> )

#xcommand ON KEY CONTROL+P [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_P , <{action}> )

#xcommand ON KEY CONTROL+Q [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_Q , <{action}> )

#xcommand ON KEY CONTROL+R [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_R , <{action}> )

#xcommand ON KEY CONTROL+S [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_S , <{action}> )

#xcommand ON KEY CONTROL+T [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_T , <{action}> )

#xcommand ON KEY CONTROL+U [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_U , <{action}> )

#xcommand ON KEY CONTROL+V [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_V , <{action}> )

#xcommand ON KEY CONTROL+W [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_W , <{action}> )

#xcommand ON KEY CONTROL+X [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_X , <{action}> )

#xcommand ON KEY CONTROL+Y [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_Y , <{action}> )

#xcommand ON KEY CONTROL+Z [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_Z , <{action}> )

#xcommand ON KEY CONTROL+0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_0 , <{action}> )

#xcommand ON KEY CONTROL+1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_1 , <{action}> )

#xcommand ON KEY CONTROL+2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_2 , <{action}> )

#xcommand ON KEY CONTROL+3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_3 , <{action}> )

#xcommand ON KEY CONTROL+4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_4 , <{action}> )

#xcommand ON KEY CONTROL+5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_5 , <{action}> )

#xcommand ON KEY CONTROL+6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_6 , <{action}> )

#xcommand ON KEY CONTROL+7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_7 , <{action}> )

#xcommand ON KEY CONTROL+8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_8 , <{action}> )

#xcommand ON KEY CONTROL+9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_9 , <{action}> )

#xcommand ON KEY CONTROL+F1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F1 , <{action}> )

#xcommand ON KEY CONTROL+F2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F2 , <{action}> )

#xcommand ON KEY CONTROL+F3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F3 , <{action}> )

#xcommand ON KEY CONTROL+F4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F4 , <{action}> )

#xcommand ON KEY CONTROL+F5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F5 , <{action}> )

#xcommand ON KEY CONTROL+F6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F6 , <{action}> )

#xcommand ON KEY CONTROL+F7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F7 , <{action}> )

#xcommand ON KEY CONTROL+F8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F8 , <{action}> )

#xcommand ON KEY CONTROL+F9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F9 , <{action}> )

#xcommand ON KEY CONTROL+F10 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F10 , <{action}> )

#xcommand ON KEY CONTROL+F11 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F11 , <{action}> )

#xcommand ON KEY CONTROL+F12 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_F12 , <{action}> )

#xcommand ON KEY CONTROL+SPACE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_SPACE , <{action}> )

#xcommand ON KEY CONTROL+BACK [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_BACK , <{action}> )

#xcommand ON KEY CONTROL+TAB [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_TAB , <{action}> )

#xcommand ON KEY CONTROL+RETURN [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_RETURN , <{action}> )
 	
#xcommand ON KEY CONTROL+ESCAPE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_ESCAPE , <{action}> )
 	
#xcommand ON KEY CONTROL+INSERT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_INSERT , <{action}> )
  
#xcommand ON KEY CONTROL+DELETE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_DELETE , <{action}> )

#xcommand ON KEY CONTROL+HOME [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_HOME , <{action}> )

#xcommand ON KEY CONTROL+END [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_END , <{action}> )
 
#xcommand ON KEY CONTROL+PRIOR [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_PRIOR , <{action}> )
  
#xcommand ON KEY CONTROL+NEXT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NEXT , <{action}> )

#xcommand ON KEY CONTROL+LEFT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_LEFT , <{action}> )
 	
#xcommand ON KEY CONTROL+UP [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_UP , <{action}> )

#xcommand ON KEY CONTROL+RIGHT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_RIGHT , <{action}> )

#xcommand ON KEY CONTROL+DOWN [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_DOWN , <{action}> )
 	
#xcommand ON KEY CONTROL+ADD [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_ADD , <{action}> )

#xcommand ON KEY CONTROL+SUBTRACT [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_SUBTRACT , <{action}> )

#xcommand ON KEY CONTROL+MULTIPLY [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_MULTIPLY , <{action}> )

#xcommand ON KEY CONTROL+DIVIDE [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_DIVIDE , <{action}> )

#xcommand ON KEY CONTROL+DECIMAL [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_DECIMAL , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD0 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD0, <{action}> )

#xcommand ON KEY CONTROL+NUMPAD1 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD1 , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD2 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD2 , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD3 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD3 , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD4 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD4 , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD5 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD5 , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD6 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD6 , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD7 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD7 , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD8 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD8 , <{action}> )

#xcommand ON KEY CONTROL+NUMPAD9 [ OF <parent> ] ACTION <action> ;
=> ;
_DefineHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD9 , <{action}> )


///////////////////////////////////////////////////////////////////////////////
// RELEASE KEY
///////////////////////////////////////////////////////////////////////////////

// Plain Keys

#xcommand RELEASE KEY UNSHIFT+A OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_A   )

#xcommand RELEASE KEY UNSHIFT+B OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_B   )

#xcommand RELEASE KEY UNSHIFT+C OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_C   )

#xcommand RELEASE KEY UNSHIFT+D OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_D   )

#xcommand RELEASE KEY UNSHIFT+E OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_E   )

#xcommand RELEASE KEY UNSHIFT+F OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F   )

#xcommand RELEASE KEY UNSHIFT+G OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_G   )

#xcommand RELEASE KEY UNSHIFT+H OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_H   )

#xcommand RELEASE KEY UNSHIFT+I OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_I   )

#xcommand RELEASE KEY UNSHIFT+J OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_J   )

#xcommand RELEASE KEY UNSHIFT+K OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_K   )

#xcommand RELEASE KEY UNSHIFT+L OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_L   )

#xcommand RELEASE KEY UNSHIFT+M OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_M   )

#xcommand RELEASE KEY UNSHIFT+N OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_N   )

#xcommand RELEASE KEY UNSHIFT+O OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_O   )

#xcommand RELEASE KEY UNSHIFT+P OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_P   )

#xcommand RELEASE KEY UNSHIFT+Q OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_Q   )

#xcommand RELEASE KEY UNSHIFT+R OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_R   )

#xcommand RELEASE KEY UNSHIFT+S OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_S   )

#xcommand RELEASE KEY UNSHIFT+T OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_T   )

#xcommand RELEASE KEY UNSHIFT+U OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_U   )

#xcommand RELEASE KEY UNSHIFT+V OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_V   )

#xcommand RELEASE KEY UNSHIFT+W OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_W   )

#xcommand RELEASE KEY UNSHIFT+X OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_X   )

#xcommand RELEASE KEY UNSHIFT+Y OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_Y   )

#xcommand RELEASE KEY UNSHIFT+Z OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_Z   )

#xcommand RELEASE KEY 0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_0   )

#xcommand RELEASE KEY 1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_1   )

#xcommand RELEASE KEY 2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_2   )

#xcommand RELEASE KEY 3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_3   )

#xcommand RELEASE KEY 4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_4   )

#xcommand RELEASE KEY 5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_5   )

#xcommand RELEASE KEY 6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_6   )

#xcommand RELEASE KEY 7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_7   )

#xcommand RELEASE KEY 8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_8   )

#xcommand RELEASE KEY 9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_9   )

#xcommand RELEASE KEY F1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F1   )

#xcommand RELEASE KEY F2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F2   )

#xcommand RELEASE KEY F3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F3   )

#xcommand RELEASE KEY F4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F4   )

#xcommand RELEASE KEY F5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F5   )

#xcommand RELEASE KEY F6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F6   )

#xcommand RELEASE KEY F7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F7   )

#xcommand RELEASE KEY F8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F8   )

#xcommand RELEASE KEY F9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F9   )

#xcommand RELEASE KEY F10 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F10   )

#xcommand RELEASE KEY F11 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F11   )

#xcommand RELEASE KEY F12 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_F12   )

#xcommand RELEASE KEY SPACE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_SPACE   )

#xcommand RELEASE KEY BACK OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_BACK   )

#xcommand RELEASE KEY TAB OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_TAB   )

#xcommand RELEASE KEY RETURN OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_RETURN   )
 	
#xcommand RELEASE KEY ESCAPE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_ESCAPE   )
 	
#xcommand RELEASE KEY INSERT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_INSERT   )
  
#xcommand RELEASE KEY DELETE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_DELETE   )

#xcommand RELEASE KEY HOME OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_HOME   )

#xcommand RELEASE KEY END OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_END   )
 
#xcommand RELEASE KEY PRIOR OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_PRIOR   )
  
#xcommand RELEASE KEY NEXT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NEXT   )

#xcommand RELEASE KEY LEFT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_LEFT   )
 	
#xcommand RELEASE KEY UP OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_UP   )

#xcommand RELEASE KEY RIGHT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_RIGHT   )

#xcommand RELEASE KEY DOWN OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_DOWN   )
 	
#xcommand RELEASE KEY ADD OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_ADD   )

#xcommand RELEASE KEY SUBTRACT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_SUBTRACT   )

#xcommand RELEASE KEY MULTIPLY OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_MULTIPLY   )

#xcommand RELEASE KEY DIVIDE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_DIVIDE   )

#xcommand RELEASE KEY DECIMAL OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_DECIMAL   )

#xcommand RELEASE KEY NUMPAD0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD0   )

#xcommand RELEASE KEY NUMPAD1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD1   )

#xcommand RELEASE KEY NUMPAD2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD2   )

#xcommand RELEASE KEY NUMPAD3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD3   )

#xcommand RELEASE KEY NUMPAD4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD4   )

#xcommand RELEASE KEY NUMPAD5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD5   )

#xcommand RELEASE KEY NUMPAD6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD6   )

#xcommand RELEASE KEY NUMPAD7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD7   )

#xcommand RELEASE KEY NUMPAD8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD8   )

#xcommand RELEASE KEY NUMPAD9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , 0 , VK_NUMPAD9   )

// Alt Mod Keys

#xcommand RELEASE KEY ALT+A OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_A   )

#xcommand RELEASE KEY ALT+B OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_B   )

#xcommand RELEASE KEY ALT+C OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_C   )

#xcommand RELEASE KEY ALT+D OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_D   )

#xcommand RELEASE KEY ALT+E OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_E   )

#xcommand RELEASE KEY ALT+F OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F   )

#xcommand RELEASE KEY ALT+G OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_G   )

#xcommand RELEASE KEY ALT+H OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_H   )

#xcommand RELEASE KEY ALT+I OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_I   )

#xcommand RELEASE KEY ALT+J OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_J   )

#xcommand RELEASE KEY ALT+K OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_K   )

#xcommand RELEASE KEY ALT+L OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_L   )

#xcommand RELEASE KEY ALT+M OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_M   )

#xcommand RELEASE KEY ALT+N OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_N   )

#xcommand RELEASE KEY ALT+O OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_O   )

#xcommand RELEASE KEY ALT+P OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_P   )

#xcommand RELEASE KEY ALT+Q OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_Q   )

#xcommand RELEASE KEY ALT+R OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_R   )

#xcommand RELEASE KEY ALT+S OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_S   )

#xcommand RELEASE KEY ALT+T OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_T   )

#xcommand RELEASE KEY ALT+U OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_U   )

#xcommand RELEASE KEY ALT+V OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_V   )

#xcommand RELEASE KEY ALT+W OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_W   )

#xcommand RELEASE KEY ALT+X OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_X   )

#xcommand RELEASE KEY ALT+Y OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_Y   )

#xcommand RELEASE KEY ALT+Z OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_Z   )

#xcommand RELEASE KEY ALT+0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_0   )

#xcommand RELEASE KEY ALT+1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_1   )

#xcommand RELEASE KEY ALT+2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_2   )

#xcommand RELEASE KEY ALT+3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_3   )

#xcommand RELEASE KEY ALT+4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_4   )

#xcommand RELEASE KEY ALT+5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_5   )

#xcommand RELEASE KEY ALT+6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_6   )

#xcommand RELEASE KEY ALT+7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_7   )

#xcommand RELEASE KEY ALT+8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_8   )

#xcommand RELEASE KEY ALT+9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_9   )

#xcommand RELEASE KEY ALT+F1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F1   )

#xcommand RELEASE KEY ALT+F2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F2   )

#xcommand RELEASE KEY ALT+F3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F3   )

#xcommand RELEASE KEY ALT+F4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F4   )

#xcommand RELEASE KEY ALT+F5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F5   )

#xcommand RELEASE KEY ALT+F6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F6   )

#xcommand RELEASE KEY ALT+F7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F7   )

#xcommand RELEASE KEY ALT+F8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F8   )

#xcommand RELEASE KEY ALT+F9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F9   )

#xcommand RELEASE KEY ALT+F10 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F10   )

#xcommand RELEASE KEY ALT+F11 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F11   )

#xcommand RELEASE KEY ALT+F12 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_F12   )

#xcommand RELEASE KEY ALT+SPACE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_SPACE   )

#xcommand RELEASE KEY ALT+BACK OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_BACK   )

#xcommand RELEASE KEY ALT+TAB OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_TAB   )

#xcommand RELEASE KEY ALT+RETURN OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_RETURN   )
 	
#xcommand RELEASE KEY ALT+ESCAPE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_ESCAPE   )
 	
#xcommand RELEASE KEY ALT+INSERT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_INSERT   )
  
#xcommand RELEASE KEY ALT+DELETE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_DELETE   )

#xcommand RELEASE KEY ALT+HOME OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_HOME   )

#xcommand RELEASE KEY ALT+END OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_END   )
 
#xcommand RELEASE KEY ALT+PRIOR OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_PRIOR   )
  
#xcommand RELEASE KEY ALT+NEXT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NEXT   )

#xcommand RELEASE KEY ALT+LEFT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_LEFT   )
 	
#xcommand RELEASE KEY ALT+UP OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_UP   )

#xcommand RELEASE KEY ALT+RIGHT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_RIGHT   )

#xcommand RELEASE KEY ALT+DOWN OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_DOWN   )
 	
#xcommand RELEASE KEY ALT+ADD OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_ADD   )

#xcommand RELEASE KEY ALT+SUBTRACT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_SUBTRACT   )

#xcommand RELEASE KEY ALT+MULTIPLY OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_MULTIPLY   )

#xcommand RELEASE KEY ALT+DIVIDE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_DIVIDE   )

#xcommand RELEASE KEY ALT+DECIMAL OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_DECIMAL   )

#xcommand RELEASE KEY ALT+NUMPAD0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD0   )

#xcommand RELEASE KEY ALT+NUMPAD1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD1   )

#xcommand RELEASE KEY ALT+NUMPAD2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD2   )

#xcommand RELEASE KEY ALT+NUMPAD3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD3   )

#xcommand RELEASE KEY ALT+NUMPAD4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD4   )

#xcommand RELEASE KEY ALT+NUMPAD5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD5   )

#xcommand RELEASE KEY ALT+NUMPAD6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD6   )

#xcommand RELEASE KEY ALT+NUMPAD7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD7   )

#xcommand RELEASE KEY ALT+NUMPAD8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD8   )

#xcommand RELEASE KEY ALT+NUMPAD9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD9   )

// Shift Mod Keys

#xcommand RELEASE KEY SHIFT+A OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_A   )

#xcommand RELEASE KEY SHIFT+B OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_B   )

#xcommand RELEASE KEY SHIFT+C OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_C   )

#xcommand RELEASE KEY SHIFT+D OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_D   )

#xcommand RELEASE KEY SHIFT+E OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_E   )

#xcommand RELEASE KEY SHIFT+F OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F   )

#xcommand RELEASE KEY SHIFT+G OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_G   )

#xcommand RELEASE KEY SHIFT+H OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_H   )

#xcommand RELEASE KEY SHIFT+I OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_I   )

#xcommand RELEASE KEY SHIFT+J OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_J   )

#xcommand RELEASE KEY SHIFT+K OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_K   )

#xcommand RELEASE KEY SHIFT+L OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_L   )

#xcommand RELEASE KEY SHIFT+M OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_M   )

#xcommand RELEASE KEY SHIFT+N OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_N   )

#xcommand RELEASE KEY SHIFT+O OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_O   )

#xcommand RELEASE KEY SHIFT+P OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_P   )

#xcommand RELEASE KEY SHIFT+Q OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_Q   )

#xcommand RELEASE KEY SHIFT+R OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_R   )

#xcommand RELEASE KEY SHIFT+S OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_S   )

#xcommand RELEASE KEY SHIFT+T OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_T   )

#xcommand RELEASE KEY SHIFT+U OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_U   )

#xcommand RELEASE KEY SHIFT+V OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_V   )

#xcommand RELEASE KEY SHIFT+W OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_W   )

#xcommand RELEASE KEY SHIFT+X OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_X   )

#xcommand RELEASE KEY SHIFT+Y OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_Y   )

#xcommand RELEASE KEY SHIFT+Z OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_Z   )

#xcommand RELEASE KEY SHIFT+0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_0   )

#xcommand RELEASE KEY SHIFT+1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_1   )

#xcommand RELEASE KEY SHIFT+2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_2   )

#xcommand RELEASE KEY SHIFT+3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_3   )

#xcommand RELEASE KEY SHIFT+4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_4   )

#xcommand RELEASE KEY SHIFT+5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_5   )

#xcommand RELEASE KEY SHIFT+6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_6   )

#xcommand RELEASE KEY SHIFT+7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_7   )

#xcommand RELEASE KEY SHIFT+8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_8   )

#xcommand RELEASE KEY SHIFT+9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_9   )

#xcommand RELEASE KEY SHIFT+F1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F1   )

#xcommand RELEASE KEY SHIFT+F2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F2   )

#xcommand RELEASE KEY SHIFT+F3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F3   )

#xcommand RELEASE KEY SHIFT+F4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F4   )

#xcommand RELEASE KEY SHIFT+F5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F5   )

#xcommand RELEASE KEY SHIFT+F6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F6   )

#xcommand RELEASE KEY SHIFT+F7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F7   )

#xcommand RELEASE KEY SHIFT+F8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F8   )

#xcommand RELEASE KEY SHIFT+F9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F9   )

#xcommand RELEASE KEY SHIFT+F10 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F10   )

#xcommand RELEASE KEY SHIFT+F11 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F11   )

#xcommand RELEASE KEY SHIFT+F12 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_F12   )

#xcommand RELEASE KEY SHIFT+SPACE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_SPACE   )

#xcommand RELEASE KEY SHIFT+BACK OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_BACK   )

#xcommand RELEASE KEY SHIFT+TAB OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_TAB   )

#xcommand RELEASE KEY SHIFT+RETURN OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_RETURN   )
 	
#xcommand RELEASE KEY SHIFT+ESCAPE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_ESCAPE   )
 	
#xcommand RELEASE KEY SHIFT+INSERT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_INSERT   )
  
#xcommand RELEASE KEY SHIFT+DELETE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_DELETE   )

#xcommand RELEASE KEY SHIFT+HOME OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_HOME   )

#xcommand RELEASE KEY SHIFT+END OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_END   )
 
#xcommand RELEASE KEY SHIFT+PRIOR OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_PRIOR   )
  
#xcommand RELEASE KEY SHIFT+NEXT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NEXT   )

#xcommand RELEASE KEY SHIFT+LEFT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_LEFT   )
 	
#xcommand RELEASE KEY SHIFT+UP OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_UP   )

#xcommand RELEASE KEY SHIFT+RIGHT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_RIGHT   )

#xcommand RELEASE KEY SHIFT+DOWN OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_DOWN   )
 	
#xcommand RELEASE KEY SHIFT+ADD OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_ADD   )

#xcommand RELEASE KEY SHIFT+SUBTRACT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_SUBTRACT   )

#xcommand RELEASE KEY SHIFT+MULTIPLY OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_MULTIPLY   )

#xcommand RELEASE KEY SHIFT+DIVIDE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_DIVIDE   )

#xcommand RELEASE KEY SHIFT+DECIMAL OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_DECIMAL   )

#xcommand RELEASE KEY SHIFT+NUMPAD0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD0   )

#xcommand RELEASE KEY SHIFT+NUMPAD1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD1   )

#xcommand RELEASE KEY SHIFT+NUMPAD2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD2   )

#xcommand RELEASE KEY SHIFT+NUMPAD3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD3   )

#xcommand RELEASE KEY SHIFT+NUMPAD4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD4   )

#xcommand RELEASE KEY SHIFT+NUMPAD5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD5   )

#xcommand RELEASE KEY SHIFT+NUMPAD6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD6   )

#xcommand RELEASE KEY SHIFT+NUMPAD7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD7   )

#xcommand RELEASE KEY SHIFT+NUMPAD8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD8   )

#xcommand RELEASE KEY SHIFT+NUMPAD9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD9   )

// Control Mod Keys

#xcommand RELEASE KEY CONTROL+A OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_A   )

#xcommand RELEASE KEY CONTROL+B OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_B   )

#xcommand RELEASE KEY CONTROL+C OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_C   )

#xcommand RELEASE KEY CONTROL+D OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_D   )

#xcommand RELEASE KEY CONTROL+E OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_E   )

#xcommand RELEASE KEY CONTROL+F OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F   )

#xcommand RELEASE KEY CONTROL+G OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_G   )

#xcommand RELEASE KEY CONTROL+H OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_H   )

#xcommand RELEASE KEY CONTROL+I OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_I   )

#xcommand RELEASE KEY CONTROL+J OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_J   )

#xcommand RELEASE KEY CONTROL+K OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_K   )

#xcommand RELEASE KEY CONTROL+L OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_L   )

#xcommand RELEASE KEY CONTROL+M OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_M   )

#xcommand RELEASE KEY CONTROL+N OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_N   )

#xcommand RELEASE KEY CONTROL+O OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_O   )

#xcommand RELEASE KEY CONTROL+P OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_P   )

#xcommand RELEASE KEY CONTROL+Q OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_Q   )

#xcommand RELEASE KEY CONTROL+R OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_R   )

#xcommand RELEASE KEY CONTROL+S OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_S   )

#xcommand RELEASE KEY CONTROL+T OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_T   )

#xcommand RELEASE KEY CONTROL+U OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_U   )

#xcommand RELEASE KEY CONTROL+V OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_V   )

#xcommand RELEASE KEY CONTROL+W OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_W   )

#xcommand RELEASE KEY CONTROL+X OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_X   )

#xcommand RELEASE KEY CONTROL+Y OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_Y   )

#xcommand RELEASE KEY CONTROL+Z OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_Z   )

#xcommand RELEASE KEY CONTROL+0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_0   )

#xcommand RELEASE KEY CONTROL+1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_1   )

#xcommand RELEASE KEY CONTROL+2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_2   )

#xcommand RELEASE KEY CONTROL+3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_3   )

#xcommand RELEASE KEY CONTROL+4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_4   )

#xcommand RELEASE KEY CONTROL+5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_5   )

#xcommand RELEASE KEY CONTROL+6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_6   )

#xcommand RELEASE KEY CONTROL+7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_7   )

#xcommand RELEASE KEY CONTROL+8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_8   )

#xcommand RELEASE KEY CONTROL+9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_9   )

#xcommand RELEASE KEY CONTROL+F1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F1   )

#xcommand RELEASE KEY CONTROL+F2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F2   )

#xcommand RELEASE KEY CONTROL+F3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F3   )

#xcommand RELEASE KEY CONTROL+F4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F4   )

#xcommand RELEASE KEY CONTROL+F5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F5   )

#xcommand RELEASE KEY CONTROL+F6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F6   )

#xcommand RELEASE KEY CONTROL+F7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F7   )

#xcommand RELEASE KEY CONTROL+F8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F8   )

#xcommand RELEASE KEY CONTROL+F9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F9   )

#xcommand RELEASE KEY CONTROL+F10 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F10   )

#xcommand RELEASE KEY CONTROL+F11 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F11   )

#xcommand RELEASE KEY CONTROL+F12 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_F12   )

#xcommand RELEASE KEY CONTROL+SPACE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_SPACE   )

#xcommand RELEASE KEY CONTROL+BACK OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_BACK   )

#xcommand RELEASE KEY CONTROL+TAB OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_TAB   )

#xcommand RELEASE KEY CONTROL+RETURN OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_RETURN   )
 	
#xcommand RELEASE KEY CONTROL+ESCAPE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_ESCAPE   )
 	
#xcommand RELEASE KEY CONTROL+INSERT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_INSERT   )
  
#xcommand RELEASE KEY CONTROL+DELETE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_DELETE   )

#xcommand RELEASE KEY CONTROL+HOME OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_HOME   )

#xcommand RELEASE KEY CONTROL+END OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_END   )
 
#xcommand RELEASE KEY CONTROL+PRIOR OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_PRIOR   )
  
#xcommand RELEASE KEY CONTROL+NEXT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NEXT   )

#xcommand RELEASE KEY CONTROL+LEFT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_LEFT   )
 	
#xcommand RELEASE KEY CONTROL+UP OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_UP   )

#xcommand RELEASE KEY CONTROL+RIGHT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_RIGHT   )

#xcommand RELEASE KEY CONTROL+DOWN OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_DOWN   )
 	
#xcommand RELEASE KEY CONTROL+ADD OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_ADD   )

#xcommand RELEASE KEY CONTROL+SUBTRACT OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_SUBTRACT   )

#xcommand RELEASE KEY CONTROL+MULTIPLY OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_MULTIPLY   )

#xcommand RELEASE KEY CONTROL+DIVIDE OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_DIVIDE   )

#xcommand RELEASE KEY CONTROL+DECIMAL OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_DECIMAL   )

#xcommand RELEASE KEY CONTROL+NUMPAD0 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD0   )

#xcommand RELEASE KEY CONTROL+NUMPAD1 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD1   )

#xcommand RELEASE KEY CONTROL+NUMPAD2 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD2   )

#xcommand RELEASE KEY CONTROL+NUMPAD3 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD3   )

#xcommand RELEASE KEY CONTROL+NUMPAD4 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD4   )

#xcommand RELEASE KEY CONTROL+NUMPAD5 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD5   )

#xcommand RELEASE KEY CONTROL+NUMPAD6 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD6   )

#xcommand RELEASE KEY CONTROL+NUMPAD7 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD7   )

#xcommand RELEASE KEY CONTROL+NUMPAD8 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD8   )

#xcommand RELEASE KEY CONTROL+NUMPAD9 OF <parent> ;
=> ;
_ReleaseHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD9   )

///////////////////////////////////////////////////////////////////////////////
// STORE KEY
///////////////////////////////////////////////////////////////////////////////

// Plain Keys

#xcommand STORE KEY UNSHIFT+A OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_A   )

#xcommand STORE KEY UNSHIFT+B OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_B   )

#xcommand STORE KEY UNSHIFT+C OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_C   )

#xcommand STORE KEY UNSHIFT+D OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_D   )

#xcommand STORE KEY UNSHIFT+E OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_E   )

#xcommand STORE KEY UNSHIFT+F OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F   )

#xcommand STORE KEY UNSHIFT+G OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_G   )

#xcommand STORE KEY UNSHIFT+H OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_H   )

#xcommand STORE KEY UNSHIFT+I OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_I   )

#xcommand STORE KEY UNSHIFT+J OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_J   )

#xcommand STORE KEY UNSHIFT+K OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_K   )

#xcommand STORE KEY UNSHIFT+L OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_L   )

#xcommand STORE KEY UNSHIFT+M OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_M   )

#xcommand STORE KEY UNSHIFT+N OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_N   )

#xcommand STORE KEY UNSHIFT+O OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_O   )

#xcommand STORE KEY UNSHIFT+P OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_P   )

#xcommand STORE KEY UNSHIFT+Q OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_Q   )

#xcommand STORE KEY UNSHIFT+R OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_R   )

#xcommand STORE KEY UNSHIFT+S OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_S   )

#xcommand STORE KEY UNSHIFT+T OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_T   )

#xcommand STORE KEY UNSHIFT+U OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_U   )

#xcommand STORE KEY UNSHIFT+V OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_V   )

#xcommand STORE KEY UNSHIFT+W OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_W   )

#xcommand STORE KEY UNSHIFT+X OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_X   )

#xcommand STORE KEY UNSHIFT+Y OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_Y   )

#xcommand STORE KEY UNSHIFT+Z OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_Z   )

#xcommand STORE KEY 0 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_0   )

#xcommand STORE KEY 1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_1   )

#xcommand STORE KEY 2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_2   )

#xcommand STORE KEY 3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_3   )

#xcommand STORE KEY 4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_4   )

#xcommand STORE KEY 5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_5   )

#xcommand STORE KEY 6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_6   )

#xcommand STORE KEY 7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_7   )

#xcommand STORE KEY 8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_8   )

#xcommand STORE KEY 9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_9   )

#xcommand STORE KEY F1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F1   )

#xcommand STORE KEY F2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F2   )

#xcommand STORE KEY F3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F3   )

#xcommand STORE KEY F4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F4   )

#xcommand STORE KEY F5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F5   )

#xcommand STORE KEY F6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F6   )

#xcommand STORE KEY F7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F7   )

#xcommand STORE KEY F8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F8   )

#xcommand STORE KEY F9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F9   )

#xcommand STORE KEY F10 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F10   )

#xcommand STORE KEY F11 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F11   )

#xcommand STORE KEY F12 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_F12   )

#xcommand STORE KEY SPACE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_SPACE   )

#xcommand STORE KEY BACK OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_BACK   )

#xcommand STORE KEY TAB OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_TAB   )

#xcommand STORE KEY RETURN OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_RETURN   )
 	
#xcommand STORE KEY ESCAPE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_ESCAPE   )
 	
#xcommand STORE KEY INSERT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_INSERT   )
  
#xcommand STORE KEY DELETE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_DELETE   )

#xcommand STORE KEY HOME OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_HOME   )

#xcommand STORE KEY END OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_END   )
 
#xcommand STORE KEY PRIOR OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_PRIOR   )
  
#xcommand STORE KEY NEXT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NEXT   )

#xcommand STORE KEY LEFT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_LEFT   )
 	
#xcommand STORE KEY UP OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_UP   )

#xcommand STORE KEY RIGHT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_RIGHT   )

#xcommand STORE KEY DOWN OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_DOWN   )
 	
#xcommand STORE KEY ADD OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_ADD   )

#xcommand STORE KEY SUBTRACT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_SUBTRACT   )

#xcommand STORE KEY MULTIPLY OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_MULTIPLY   )

#xcommand STORE KEY DIVIDE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_DIVIDE   )

#xcommand STORE KEY DECIMAL OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_DECIMAL   )

#xcommand STORE KEY NUMPAD0 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD0   )

#xcommand STORE KEY NUMPAD1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD1   )

#xcommand STORE KEY NUMPAD2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD2   )

#xcommand STORE KEY NUMPAD3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD3   )

#xcommand STORE KEY NUMPAD4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD4   )

#xcommand STORE KEY NUMPAD5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD5   )

#xcommand STORE KEY NUMPAD6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD6   )

#xcommand STORE KEY NUMPAD7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD7   )

#xcommand STORE KEY NUMPAD8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD8   )

#xcommand STORE KEY NUMPAD9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , 0 , VK_NUMPAD9   )

// Alt Mod Keys

#xcommand STORE KEY ALT+A OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_A   )

#xcommand STORE KEY ALT+B OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_B   )

#xcommand STORE KEY ALT+C OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_C   )

#xcommand STORE KEY ALT+D OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_D   )

#xcommand STORE KEY ALT+E OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_E   )

#xcommand STORE KEY ALT+F OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F   )

#xcommand STORE KEY ALT+G OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_G   )

#xcommand STORE KEY ALT+H OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_H   )

#xcommand STORE KEY ALT+I OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_I   )

#xcommand STORE KEY ALT+J OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_J   )

#xcommand STORE KEY ALT+K OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_K   )

#xcommand STORE KEY ALT+L OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_L   )

#xcommand STORE KEY ALT+M OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_M   )

#xcommand STORE KEY ALT+N OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_N   )

#xcommand STORE KEY ALT+O OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_O   )

#xcommand STORE KEY ALT+P OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_P   )

#xcommand STORE KEY ALT+Q OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_Q   )

#xcommand STORE KEY ALT+R OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_R   )

#xcommand STORE KEY ALT+S OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_S   )

#xcommand STORE KEY ALT+T OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_T   )

#xcommand STORE KEY ALT+U OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_U   )

#xcommand STORE KEY ALT+V OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_V   )

#xcommand STORE KEY ALT+W OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_W   )

#xcommand STORE KEY ALT+X OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_X   )

#xcommand STORE KEY ALT+Y OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_Y   )

#xcommand STORE KEY ALT+Z OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_Z   )

#xcommand STORE KEY ALT+0 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_0   )

#xcommand STORE KEY ALT+1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_1   )

#xcommand STORE KEY ALT+2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_2   )

#xcommand STORE KEY ALT+3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_3   )

#xcommand STORE KEY ALT+4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_4   )

#xcommand STORE KEY ALT+5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_5   )

#xcommand STORE KEY ALT+6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_6   )

#xcommand STORE KEY ALT+7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_7   )

#xcommand STORE KEY ALT+8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_8   )

#xcommand STORE KEY ALT+9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_9   )

#xcommand STORE KEY ALT+F1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F1   )

#xcommand STORE KEY ALT+F2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F2   )

#xcommand STORE KEY ALT+F3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F3   )

#xcommand STORE KEY ALT+F4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F4   )

#xcommand STORE KEY ALT+F5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F5   )

#xcommand STORE KEY ALT+F6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F6   )

#xcommand STORE KEY ALT+F7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F7   )

#xcommand STORE KEY ALT+F8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F8   )

#xcommand STORE KEY ALT+F9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F9   )

#xcommand STORE KEY ALT+F10 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F10   )

#xcommand STORE KEY ALT+F11 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F11   )

#xcommand STORE KEY ALT+F12 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_F12   )

#xcommand STORE KEY ALT+SPACE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_SPACE   )

#xcommand STORE KEY ALT+BACK OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_BACK   )

#xcommand STORE KEY ALT+TAB OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_TAB   )

#xcommand STORE KEY ALT+RETURN OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_RETURN   )
 	
#xcommand STORE KEY ALT+ESCAPE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_ESCAPE   )
 	
#xcommand STORE KEY ALT+INSERT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_INSERT   )
  
#xcommand STORE KEY ALT+DELETE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_DELETE   )

#xcommand STORE KEY ALT+HOME OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_HOME   )

#xcommand STORE KEY ALT+END OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_END   )
 
#xcommand STORE KEY ALT+PRIOR OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_PRIOR   )
  
#xcommand STORE KEY ALT+NEXT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NEXT   )

#xcommand STORE KEY ALT+LEFT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_LEFT   )
 	
#xcommand STORE KEY ALT+UP OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_UP   )

#xcommand STORE KEY ALT+RIGHT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_RIGHT   )

#xcommand STORE KEY ALT+DOWN OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_DOWN   )
 	
#xcommand STORE KEY ALT+ADD OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_ADD   )

#xcommand STORE KEY ALT+SUBTRACT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_SUBTRACT   )

#xcommand STORE KEY ALT+MULTIPLY OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_MULTIPLY   )

#xcommand STORE KEY ALT+DIVIDE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_DIVIDE   )

#xcommand STORE KEY ALT+DECIMAL OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_DECIMAL   )

#xcommand STORE KEY ALT+NUMPAD0 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD0   )

#xcommand STORE KEY ALT+NUMPAD1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD1   )

#xcommand STORE KEY ALT+NUMPAD2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD2   )

#xcommand STORE KEY ALT+NUMPAD3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD3   )

#xcommand STORE KEY ALT+NUMPAD4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD4   )

#xcommand STORE KEY ALT+NUMPAD5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD5   )

#xcommand STORE KEY ALT+NUMPAD6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD6   )

#xcommand STORE KEY ALT+NUMPAD7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD7   )

#xcommand STORE KEY ALT+NUMPAD8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD8   )

#xcommand STORE KEY ALT+NUMPAD9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_ALT , VK_NUMPAD9   )

// Shift Mod Keys

#xcommand STORE KEY SHIFT+A OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_A   )

#xcommand STORE KEY SHIFT+B OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_B   )

#xcommand STORE KEY SHIFT+C OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_C   )

#xcommand STORE KEY SHIFT+D OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_D   )

#xcommand STORE KEY SHIFT+E OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_E   )

#xcommand STORE KEY SHIFT+F OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F   )

#xcommand STORE KEY SHIFT+G OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_G   )

#xcommand STORE KEY SHIFT+H OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_H   )

#xcommand STORE KEY SHIFT+I OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_I   )

#xcommand STORE KEY SHIFT+J OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_J   )

#xcommand STORE KEY SHIFT+K OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_K   )

#xcommand STORE KEY SHIFT+L OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_L   )

#xcommand STORE KEY SHIFT+M OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_M   )

#xcommand STORE KEY SHIFT+N OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_N   )

#xcommand STORE KEY SHIFT+O OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_O   )

#xcommand STORE KEY SHIFT+P OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_P   )

#xcommand STORE KEY SHIFT+Q OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_Q   )

#xcommand STORE KEY SHIFT+R OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_R   )

#xcommand STORE KEY SHIFT+S OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_S   )

#xcommand STORE KEY SHIFT+T OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_T   )

#xcommand STORE KEY SHIFT+U OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_U   )

#xcommand STORE KEY SHIFT+V OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_V   )

#xcommand STORE KEY SHIFT+W OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_W   )

#xcommand STORE KEY SHIFT+X OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_X   )

#xcommand STORE KEY SHIFT+Y OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_Y   )

#xcommand STORE KEY SHIFT+Z OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_Z   )

#xcommand STORE KEY SHIFT+0 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_0   )

#xcommand STORE KEY SHIFT+1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_1   )

#xcommand STORE KEY SHIFT+2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_2   )

#xcommand STORE KEY SHIFT+3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_3   )

#xcommand STORE KEY SHIFT+4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_4   )

#xcommand STORE KEY SHIFT+5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_5   )

#xcommand STORE KEY SHIFT+6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_6   )

#xcommand STORE KEY SHIFT+7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_7   )

#xcommand STORE KEY SHIFT+8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_8   )

#xcommand STORE KEY SHIFT+9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_9   )

#xcommand STORE KEY SHIFT+F1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F1   )

#xcommand STORE KEY SHIFT+F2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F2   )

#xcommand STORE KEY SHIFT+F3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F3   )

#xcommand STORE KEY SHIFT+F4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F4   )

#xcommand STORE KEY SHIFT+F5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F5   )

#xcommand STORE KEY SHIFT+F6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F6   )

#xcommand STORE KEY SHIFT+F7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F7   )

#xcommand STORE KEY SHIFT+F8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F8   )

#xcommand STORE KEY SHIFT+F9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F9   )

#xcommand STORE KEY SHIFT+F10 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F10   )

#xcommand STORE KEY SHIFT+F11 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F11   )

#xcommand STORE KEY SHIFT+F12 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_F12   )

#xcommand STORE KEY SHIFT+SPACE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_SPACE   )

#xcommand STORE KEY SHIFT+BACK OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_BACK   )

#xcommand STORE KEY SHIFT+TAB OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_TAB   )

#xcommand STORE KEY SHIFT+RETURN OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_RETURN   )
 	
#xcommand STORE KEY SHIFT+ESCAPE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_ESCAPE   )
 	
#xcommand STORE KEY SHIFT+INSERT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_INSERT   )
  
#xcommand STORE KEY SHIFT+DELETE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_DELETE   )

#xcommand STORE KEY SHIFT+HOME OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_HOME   )

#xcommand STORE KEY SHIFT+END OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_END   )
 
#xcommand STORE KEY SHIFT+PRIOR OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_PRIOR   )
  
#xcommand STORE KEY SHIFT+NEXT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NEXT   )

#xcommand STORE KEY SHIFT+LEFT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_LEFT   )
 	
#xcommand STORE KEY SHIFT+UP OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_UP   )

#xcommand STORE KEY SHIFT+RIGHT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_RIGHT   )

#xcommand STORE KEY SHIFT+DOWN OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_DOWN   )
 	
#xcommand STORE KEY SHIFT+ADD OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_ADD   )

#xcommand STORE KEY SHIFT+SUBTRACT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_SUBTRACT   )

#xcommand STORE KEY SHIFT+MULTIPLY OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_MULTIPLY   )

#xcommand STORE KEY SHIFT+DIVIDE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_DIVIDE   )

#xcommand STORE KEY SHIFT+DECIMAL OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_DECIMAL   )

#xcommand STORE KEY SHIFT+NUMPAD0 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD0   )

#xcommand STORE KEY SHIFT+NUMPAD1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD1   )

#xcommand STORE KEY SHIFT+NUMPAD2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD2   )

#xcommand STORE KEY SHIFT+NUMPAD3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD3   )

#xcommand STORE KEY SHIFT+NUMPAD4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD4   )

#xcommand STORE KEY SHIFT+NUMPAD5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD5   )

#xcommand STORE KEY SHIFT+NUMPAD6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD6   )

#xcommand STORE KEY SHIFT+NUMPAD7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD7   )

#xcommand STORE KEY SHIFT+NUMPAD8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD8   )

#xcommand STORE KEY SHIFT+NUMPAD9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_SHIFT , VK_NUMPAD9   )

// Control Mod Keys

#xcommand STORE KEY CONTROL+A OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_A   )

#xcommand STORE KEY CONTROL+B OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_B   )

#xcommand STORE KEY CONTROL+C OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_C   )

#xcommand STORE KEY CONTROL+D OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_D   )

#xcommand STORE KEY CONTROL+E OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_E   )

#xcommand STORE KEY CONTROL+F OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F   )

#xcommand STORE KEY CONTROL+G OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_G   )

#xcommand STORE KEY CONTROL+H OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_H   )

#xcommand STORE KEY CONTROL+I OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_I   )

#xcommand STORE KEY CONTROL+J OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_J   )

#xcommand STORE KEY CONTROL+K OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_K   )

#xcommand STORE KEY CONTROL+L OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_L   )

#xcommand STORE KEY CONTROL+M OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_M   )

#xcommand STORE KEY CONTROL+N OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_N   )

#xcommand STORE KEY CONTROL+O OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_O   )

#xcommand STORE KEY CONTROL+P OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_P   )

#xcommand STORE KEY CONTROL+Q OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_Q   )

#xcommand STORE KEY CONTROL+R OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_R   )

#xcommand STORE KEY CONTROL+S OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_S   )

#xcommand STORE KEY CONTROL+T OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_T   )

#xcommand STORE KEY CONTROL+U OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_U   )

#xcommand STORE KEY CONTROL+V OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_V   )

#xcommand STORE KEY CONTROL+W OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_W   )

#xcommand STORE KEY CONTROL+X OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_X   )

#xcommand STORE KEY CONTROL+Y OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_Y   )

#xcommand STORE KEY CONTROL+Z OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_Z   )

#xcommand STORE KEY CONTROL+0 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_0   )

#xcommand STORE KEY CONTROL+1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_1   )

#xcommand STORE KEY CONTROL+2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_2   )

#xcommand STORE KEY CONTROL+3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_3   )

#xcommand STORE KEY CONTROL+4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_4   )

#xcommand STORE KEY CONTROL+5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_5   )

#xcommand STORE KEY CONTROL+6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_6   )

#xcommand STORE KEY CONTROL+7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_7   )

#xcommand STORE KEY CONTROL+8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_8   )

#xcommand STORE KEY CONTROL+9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_9   )

#xcommand STORE KEY CONTROL+F1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F1   )

#xcommand STORE KEY CONTROL+F2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F2   )

#xcommand STORE KEY CONTROL+F3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F3   )

#xcommand STORE KEY CONTROL+F4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F4   )

#xcommand STORE KEY CONTROL+F5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F5   )

#xcommand STORE KEY CONTROL+F6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F6   )

#xcommand STORE KEY CONTROL+F7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F7   )

#xcommand STORE KEY CONTROL+F8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F8   )

#xcommand STORE KEY CONTROL+F9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F9   )

#xcommand STORE KEY CONTROL+F10 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F10   )

#xcommand STORE KEY CONTROL+F11 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F11   )

#xcommand STORE KEY CONTROL+F12 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_F12   )

#xcommand STORE KEY CONTROL+SPACE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_SPACE   )

#xcommand STORE KEY CONTROL+BACK OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_BACK   )

#xcommand STORE KEY CONTROL+TAB OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_TAB   )

#xcommand STORE KEY CONTROL+RETURN OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_RETURN   )
 	
#xcommand STORE KEY CONTROL+ESCAPE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_ESCAPE   )
 	
#xcommand STORE KEY CONTROL+INSERT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_INSERT   )
  
#xcommand STORE KEY CONTROL+DELETE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_DELETE   )

#xcommand STORE KEY CONTROL+HOME OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_HOME   )

#xcommand STORE KEY CONTROL+END OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_END   )
 
#xcommand STORE KEY CONTROL+PRIOR OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_PRIOR   )
  
#xcommand STORE KEY CONTROL+NEXT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NEXT   )

#xcommand STORE KEY CONTROL+LEFT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_LEFT   )
 	
#xcommand STORE KEY CONTROL+UP OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_UP   )

#xcommand STORE KEY CONTROL+RIGHT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_RIGHT   )

#xcommand STORE KEY CONTROL+DOWN OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_DOWN   )
 	
#xcommand STORE KEY CONTROL+ADD OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_ADD   )

#xcommand STORE KEY CONTROL+SUBTRACT OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_SUBTRACT   )

#xcommand STORE KEY CONTROL+MULTIPLY OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_MULTIPLY   )

#xcommand STORE KEY CONTROL+DIVIDE OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_DIVIDE   )

#xcommand STORE KEY CONTROL+DECIMAL OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_DECIMAL   )

#xcommand STORE KEY CONTROL+NUMPAD0 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD0   )

#xcommand STORE KEY CONTROL+NUMPAD1 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD1   )

#xcommand STORE KEY CONTROL+NUMPAD2 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD2   )

#xcommand STORE KEY CONTROL+NUMPAD3 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD3   )

#xcommand STORE KEY CONTROL+NUMPAD4 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD4   )

#xcommand STORE KEY CONTROL+NUMPAD5 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD5   )

#xcommand STORE KEY CONTROL+NUMPAD6 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD6   )

#xcommand STORE KEY CONTROL+NUMPAD7 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD7   )

#xcommand STORE KEY CONTROL+NUMPAD8 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD8   )

#xcommand STORE KEY CONTROL+NUMPAD9 OF <parent> TO <baction> ;
=> ;
<baction> := _GetHotKey ( <"parent"> , MOD_CONTROL , VK_NUMPAD9   )

///////////////////////////////////////////////////////////////////////////////
// PUSH KEY COMMAND
///////////////////////////////////////////////////////////////////////////////
/*
#xcommand PUSH KEY F1 ;
=> ;
_PushKey ( VK_F1 )

#xcommand PUSH KEY F2  ;
=> ;
_PushKey ( VK_F2 )

#xcommand PUSH KEY F3  ;
=> ;
_PushKey ( VK_F3 )

#xcommand PUSH KEY F4 ;
=> ;
_PushKey ( VK_F4 )

#xcommand PUSH KEY F5 ;
=> ;
_PushKey ( VK_F5 )

#xcommand PUSH KEY F6 ;
=> ;
_PushKey ( VK_F6 )

#xcommand PUSH KEY F7 ;
=> ;
_PushKey ( VK_F7 )

#xcommand PUSH KEY F8 ;
=> ;
_PushKey ( VK_F8 )

#xcommand PUSH KEY F9 ;
=> ;
_PushKey ( VK_F9 )

#xcommand PUSH KEY F10  ;
=> ;
_PushKey ( VK_F10 )

#xcommand PUSH KEY F11  ;
=> ;
_PushKey ( VK_F11 )

#xcommand PUSH KEY F12 ;
=> ;
_PushKey ( VK_F12 )

#xcommand PUSH KEY BACK ;
=> ;
_PushKey ( VK_BACK )

#xcommand PUSH KEY TAB ;
=> ;
_PushKey ( VK_TAB )

#xcommand PUSH KEY RETURN ;
=> ;
_PushKey ( VK_RETURN )
 	
#xcommand PUSH KEY ESCAPE ;
=> ;
_PushKey ( VK_ESCAPE )
 	
#xcommand PUSH KEY INSERT ;
=> ;
_PushKey ( VK_INSERT )
  
#xcommand PUSH KEY DELETE ;
=> ;
_PushKey ( VK_DELETE )

#xcommand PUSH KEY HOME ;
=> ;
_PushKey ( VK_HOME )

#xcommand PUSH KEY END ;
=> ;
_PushKey ( VK_END )
 
#xcommand PUSH KEY PRIOR ;
=> ;
_PushKey ( VK_PRIOR )
  
#xcommand PUSH KEY NEXT ;
=> ;
_PushKey ( VK_NEXT )

#xcommand PUSH KEY LEFT ;
=> ;
_PushKey ( VK_LEFT )
 	
#xcommand PUSH KEY UP ;
=> ;
_PushKey ( VK_UP  )

#xcommand PUSH KEY RIGHT ;
=> ;
_PushKey ( VK_RIGHT )

#xcommand PUSH KEY DOWN ;
=> ;
_PushKey ( VK_DOWN )
 	
#xcommand PUSH KEY CAPSLOCK ;
=> ;
_PushKey ( VK_CAPITAL )

#xcommand PUSH KEY SCROLLLOCK ;
=> ;
_PushKey ( VK_SCROLL )

#xcommand PUSH KEY NUMLOCK ;
=> ;
_PushKey ( VK_NUMLOCK )
*/

