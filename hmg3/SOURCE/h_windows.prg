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


// #define ALLOW_ONLY_ONE_MESSAGE_LOOP


/*
  The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made
  by Dr. Claudio Soto, November 2012 and June 2014 respectively.
  mail: <srvet@adinet.com.uy>
  blog: http://srvet.blogspot.com
*/

#include "SETCompileBrowse.ch"

#include "hmg.ch"
#include "common.ch"
#include "error.ch"

MEMVAR _HMG_SYSDATA
MEMVAR _HMG_MainWindowFirst
MEMVAR _HMG_MainFormIndex
MEMVAR _HMG_LastActiveFormIndex
MEMVAR _HMG_LastActiveControlIndex
MEMVAR _HMG_LastFormIndexWithCursor
MEMVAR _HMG_StopWindowEventProcedure
MEMVAR _HMG_StopControlEventProcedure
MEMVAR _HMG_AvoidReentryEventProcedure
MEMVAR _HMG_GRID_SELECTEDROW_DISPLAYCOLOR
MEMVAR _HMG_GRID_SELECTEDCELL_DISPLAYCOLOR
MEMVAR _HMG_SetControlContextMenu
MEMVAR _HMG_MsgIDFindDlg
MEMVAR _HMG_FindReplaceOnAction

/*
MEMVAR _HMG_EventData
MEMVAR _HMG_EventIsInProgress
MEMVAR _HMG_EventIsKeyboardMessage
MEMVAR _HMG_EventIsMouseMessage
MEMVAR _HMG_EventIsHMGWindowsMessage
MEMVAR _HMG_EventHookID
MEMVAR _HMG_EventHookCode
MEMVAR _HMG_EventINDEX
MEMVAR _HMG_EventHWND
MEMVAR _HMG_EventMSG
MEMVAR _HMG_EventWPARAM
MEMVAR _HMG_EventLPARAM
MEMVAR _HMG_EventPROCNAME
*/

MEMVAR _HMG_CharRange_Min
MEMVAR _HMG_CharRange_Max

MEMVAR _HMG_DefaultIconName

MEMVAR _HMG_This_TreeItem_Value

//#define WM_GETFONT 49   // ok

//#define WM_MENUCOMMAND    0x0126   // ok
//#define WM_MENUSELECT     287     // ok
//#define WM_MENURBUTTONUP  290     // ok
//#define WM_MENUGETOBJECT  0x0124   // ok

#define WM_NCCALCSIZE      131    // ok
#define EM_SETREADONLY     207    // ok
#define COLOR_MENU      4      // ok
#define WM_NCACTIVATE      134    // ok
//#define GWL_EXSTYLE       (-20)   // ok
#define CBN_CLOSEUP       8      // ok
#define CBN_DROPDOWN      7      // ok
#define WM_MOVE          3      // ok
#define WM_MOVING        534    // ok



//#define NM_FIRST         0      // ok
#define CDRF_DODEFAULT    0x00    // ok
#define CDDS_ITEMPOSTPAINT 65538  // ok
#define DL_BEGINDRAG	     1157   // ok
#define DL_CANCELDRAG    1160    // ok
#define DL_DRAGGING      1158    // ok
#define DL_DROPPED       1159    // ok
#define DL_CURSORSET     0       // ok
#define DL_STOPCURSOR    1       // ok
#define DL_COPYCURSOR    2       // ok
#define DL_MOVECURSOR    3       // ok


#define DTM_FIRST      0x1000          //  ok
#define DTM_GETMONTHCAL (DTM_FIRST+8)     // ok
// #define DTM_GETMONTHCAL   0x1008  // ok  (MinGW)




// #define TTN_NEEDTEXT	(-520)  // only ANSI
#define TTN_FIRST          (-520)
#define TTN_GETDISPINFOA    (TTN_FIRST - 0)
#define TTN_GETDISPINFOW    (TTN_FIRST - 10)
#define TTN_NEEDTEXTA       TTN_GETDISPINFOA
#define TTN_NEEDTEXTW       TTN_GETDISPINFOW
#ifdef COMPILE_HMG_UNICODE
   #define TTN_NEEDTEXT TTN_NEEDTEXTW   // UNICODE ok
#else
   #define TTN_NEEDTEXT TTN_NEEDTEXTA   // ANSI ok
#endif



#define HOLLOW_BRUSH   5           // ok
#define DC_BRUSH      18          // ok
//#define NM_CUSTOMDRAW (NM_FIRST-12)  // ok



#define LVN_FIRST      (-100)        // ok
// #define LVN_BEGINDRAG   (LVN_FIRST-9)   // ok  (MinGW)
#define LVN_BEGINDRAG   (-109)    // ok

// #define WS_EX_TRANSPARENT   32    // ok
// #define WS_VISIBLE   0x10000000   // ok
// #define WS_GROUP     0x20000      // ok
// #define WS_CHILD   0x40000000     // ok

#define BS_AUTORADIOBUTTON   9    // ok
#define BS_NOTIFY   0x4000       // ok
//#define GWL_STYLE   (-16)       // ok
#define CBN_EDITCHANGE   5       // ok
#define SIZE_MAXHIDE   4         // ok
#define SIZE_MAXIMIZED   2        // ok
#define SIZEFULLSCREEN   2        // ok
#define SIZE_MAXSHOW     3       // ok
#define SIZE_MINIMIZED    1      // ok
#define SIZEICONIC       1      // ok
#define SIZE_RESTORED    0       // ok
#define SIZENORMAL      0       // ok
#define TBN_FIRST     (-700)    // ok
#define TBN_DROPDOWN	 (TBN_FIRST-10)   // ok
#define WM_CTLCOLORLISTBOX  308     // ok
#define WM_CTLCOLORBTN   309       // ok
#define COLOR_WINDOW   5        // ok
#define COLOR_3DFACE   15       // ok
#define COLOR_BTNFACE  15       // ok
#define OPAQUE   2               // ok
#define DKGRAY_BRUSH   3          // ok


#define LVN_GETDISPINFOA   (LVN_FIRST-50)
#define LVN_GETDISPINFOW   (LVN_FIRST-77)
#ifdef COMPILE_HMG_UNICODE
   #define LVN_GETDISPINFO   LVN_GETDISPINFOW    // Unicode  ok
#else
   #define LVN_GETDISPINFO   LVN_GETDISPINFOA    // ANSI ok
#endif

#define LVN_BEGINSCROLL   (LVN_FIRST-80)
#define LVN_ENDSCROLL     (LVN_FIRST-81)


// #define WM_HOTKEY    786       // ok
#define WM_CTLCOLOREDIT   307   // ok
// #define WM_MOUSEWHEEL   522     // ok
// #define WM_MOUSEHOVER   0x2a1    // ok
#define EN_MSGFILTER    1792    // ok
#define DLGC_WANTCHARS   128    // ok
#define DLGC_WANTMESSAGE  4     // ok

#define WM_HELP            83   // ok
#define STN_CLICKED         0    // ok
#define STN_DBLCLK          1    // ok
#define STN_ENABLE          2    // ok
#define STN_DISABLE         3    // ok

#define SB_HORZ            0    // ok
#define NM_CLICK           (-2)   // ok
// #define NM_CLICK      (NM_FIRST-2)   // ok (MinGW)
#define BS_DEFPUSHBUTTON     1    // ok
#define BM_SETSTYLE         244   // ok
#define SB_CTL             2     // ok
#define SB_VERT            1     // ok
#define SB_LINEUP           0    // ok
#define SB_LINEDOWN         1    // ok
#define SB_LINELEFT         0    // ok
#define SB_LINERIGHT        1    // ok
#define SB_PAGEUP          2    // ok
#define SB_PAGEDOWN         3   // ok
#define SB_PAGELEFT         2   // ok
#define SB_PAGERIGHT        3   // ok
#define SB_THUMBPOSITION     4   // ok
#define SB_THUMBTRACK       5   // ok
#define SB_ENDSCROLL        8   // ok
#define SB_LEFT            6   // ok
#define SB_RIGHT           7   // ok
#define SB_BOTTOM          7   // ok
#define SB_TOP            6   // ok

#define WM_VSCROLL             0x0115  // ok
// #define WM_VSCROLL    277   // ok (MinGW)


// TreeView Notify
#define TVN_FIRST             (-400)
#define TVN_SELCHANGEDA       (TVN_FIRST-2)
#define TVN_SELCHANGEDW       (TVN_FIRST-51)
#define TVN_ITEMEXPANDINGA    (TVN_FIRST-5)
#define TVN_ITEMEXPANDINGW    (TVN_FIRST-54)
#define TVN_ITEMEXPANDEDA     (TVN_FIRST-6)
#define TVN_ITEMEXPANDEDW     (TVN_FIRST-55)
#define TVN_GETDISPINFOA      (TVN_FIRST-3)
#define TVN_GETDISPINFOW      (TVN_FIRST-52)

#ifdef COMPILE_HMG_UNICODE
      #define TVN_SELCHANGED        TVN_SELCHANGEDW        // Unicode ok
      #define TVN_ITEMEXPANDING     TVN_ITEMEXPANDINGW
      #define TVN_ITEMEXPANDED      TVN_ITEMEXPANDEDW
      #define TVN_GETDISPINFO       TVN_GETDISPINFOW
#else
      #define TVN_SELCHANGED        TVN_SELCHANGEDA        // ANSI ok
      #define TVN_ITEMEXPANDING     TVN_ITEMEXPANDINGA
      #define TVN_ITEMEXPANDED      TVN_ITEMEXPANDEDA
      #define TVN_GETDISPINFO       TVN_GETDISPINFOA
#endif

#define TVE_COLLAPSE   1
#define TVE_EXPAND     2


//New define for TaskBar
#define WM_USER         0x0400    // ok
// #define WM_USER         1024  // ok (MinGW)


#define WM_TASKBAR      WM_USER+1043   // User define Message
#define ID_TASKBAR      0            // User define Message


// #define WM_NCMOUSEMOVE    160    // ok
// #define WM_MOUSEMOVE      512    // 0x0200      // ok
// #define WM_LBUTTONDOWN    513    // 0x0201      // ok
// #define WM_LBUTTONUP      514    // 0x0202      // ok
// #define WM_LBUTTONDBLCLK  515    // 0x203      // ok
// #define WM_RBUTTONDOWN    516    // 0x0204      // ok
// #define WM_RBUTTONUP      517    // 0x0205      // ok



#define WM_INITDIALOG     272   // ok
#define WM_ACTIVATEAPP    28    // ok
// #define TB_AUTOSIZE      (WM_USER+33)   // ok (MinGW)
#define TB_AUTOSIZE      1057   // ok
#define WM_EXITSIZEMOVE   562    // ok
#define WM_ENTERSIZEMOVE  561    // ok
#define WM_NEXTDLGCTL    40      // ok
#define WM_GETDLGCODE    135     // ok
#define TRANSPARENT   1       // ok
#define GRAY_BRUSH      2       // ok
#define NULL_BRUSH      5       // ok
#define WM_CTLCOLORSTATIC   312  // ok
#define WM_CTLCOLORDLG     310   // ok
#define BN_CLICKED        0     // ok
#define WM_VKEYTOITEM     46    // ok
#define LBN_KILLFOCUS     5     // ok
#define LBN_SETFOCUS      4     // ok
#define CBN_KILLFOCUS     4     // ok
#define CBN_SETFOCUS      3     // ok
#define BN_KILLFOCUS      7     // ok
#define BN_SETFOCUS       6     // ok

// #define NM_SETFOCUS  (NM_FIRST-7)   // ok (MinGW)
// #define NM_KILLFOCUS (NM_FIRST-8)   // ok (MinGW)
#define NM_SETFOCUS     (-7)   // ok
#define NM_KILLFOCUS	    (-8)   // ok


// #define LVN_KEYDOWN       (LVN_FIRST-55)   // ok  (MinGW)
// #define LVN_COLUMNCLICK   (LVN_FIRST-8)    // ok  (MinGW)
#define LVN_KEYDOWN     (-155)  // ok
#define LVN_COLUMNCLICK  (-108)  // ok

// #define NM_DBLCLK (NM_FIRST-3)   // ok  (MinGW)
#define NM_DBLCLK       (-3)    // ok

#define LBN_DBLCLK       2     // ok

 #define TCN_FIRST   (-550)
// #define TCN_SELCHANGE    (TCN_FIRST-1)   // ok (MinGW)
// #define TCN_SELCHANGING  (TCN_FIRST-2)   // ok (MinGW)
#define TCN_SELCHANGE    (-551)  // ok
#define TCN_SELCHANGING  (-552)  // ok


#define DTN_FIRST       (-760)  // ok
#define DTN_DATETIMECHANGE (DTN_FIRST+1)  // ok
#define DTN_CLOSEUP    (DTN_FIRST+7)
// #define DTN_DATETIMECHANGE (-759)   //  ok (MinGW)
// #define DTN_CLOSEUP        (-753)   //  ok (MinGW)



#define TB_ENDTRACK      8    //  ok
#define WM_HSCROLL       276  //  ok
#define CBN_SELCHANGE    1     //  ok

// #define LVN_ITEMCHANGED   (LVN_FIRST-1)   // ok (MinGW)
#define LVN_ITEMCHANGED  (-101)  //  ok

#define LBN_SELCHANGE    1     // ok
//#define WM_PAINT        15    // ok
//#define WM_ERASEBKGND    20    // ok
//#define WM_DRAWITEM      43    // ok
#define WM_SHOWWINDOW    24    // ok
#define EN_SETFOCUS     256    // ok
#define EN_KILLFOCUS    512    // ok
#define WM_SETFOCUS     7     //  ok
#define WM_KILLFOCUS    8     //  ok
#define WM_UNDO        772   //  ok
#define EM_SETMODIFY    185   //  ok
#define WM_PASTE       770   //  ok
#define EM_GETLINE     196    //  ok
#define EM_SETSEL      177    //  ok
#define WM_CLEAR       771   //  ok
#define EM_GETSEL      176   //  ok
#define EM_UNDO       199    //  ok
#define EN_CHANGE      768   //  ok
#define EN_UPDATE      1024  //  ok
#define WM_ACTIVATE    6     //   ok
#define WM_SIZING     532    //  ok
// #define MK_LBUTTON    1     // ok (i_keybd.ch)
#define WM_CONTEXTMENU 123   // ok
#define WM_TIMER      275   // ok
#define WM_SIZE       5     // ok

// #define TBM_SETPOS   (WM_USER+5)   //  ok  (MinGW)
// #define TBM_GETPOS   (WM_USER)     //  ok  (MinGW)
// #define PBM_SETPOS   (WM_USER+2)   //  ok  (MinGW)
#define TBM_SETPOS    1029  // ok
#define TBM_GETPOS    1024  // ok
#define PBM_SETPOS    1026  // ok


//#define WM_SYSCOMMAND  274     //  ok

// #define SC_CLOSE 0xF060    // ok  (MinGW)
//#define SC_CLOSE      61536     // ok


#define WM_CLOSE      16    //  ok  (MinGW)
// #define WM_COMMAND    273   //  ok  (MinGW)
// #define WM_DESTROY    2     //  ok  (MinGW)

// #define WM_CLOSE        0x0010    //  ok
#define WM_COMMAND      0x0111    //  ok
#define WM_DESTROY      0x0002    //  ok

//#define WM_NOTIFY      78   //  ok
#define WM_CREATE      1    //  ok
#define WM_QUIT        18   //  ok

#define TTM_SETTIPBKCOLOR    (WM_USER + 19)   // ok
#define TTM_SETTIPTEXTCOLOR  (WM_USER + 20)   // ok


#define LVM_FIRST           0x1000         // ok
#define LVM_GETTOPINDEX      (LVM_FIRST+39)   // ok
#define LVM_GETCOUNTPERPAGE   (LVM_FIRST+40)   // ok
#define NM_RCLICK           (NM_FIRST-5)     // ok


#define EN_SELCHANGE   1794   // ok
#define EN_LINK        1803   // ok
#define EN_VSCROLL     1538   // ok

#define CBN_SELENDCANCEL 10   // ok

//#include "hmg.ch"
//#include "common.ch"
//#include "error.ch"
memvar mVar


*------------------------------------------------------------------------------*
function Events ( hWnd, nMsg, wParam, lParam )
*------------------------------------------------------------------------------*
Local i,j,z,x,FormCount,lvc, aPos , maskstart , xs , xd , ts , nr
Local k
Local ControlCount , RecordCount , SkipCount , BackRec , BackArea , BrowseArea , NextControlHandle , NewPos , NewHPos , NewVPos , _ThisQueryTemp , r
Local hwm
Local hws
Local mVar
Local DeltaSelect
Local TmpStr
Local Tmp
Local xRetVal
Local aCellData
Local aTemp
Local a
Local MaxBrowseRows
Local MaxBrowseCols
Local aTemp2
Local aSize
// Local MaxGridRows
// Local MaxGridCols
Local cProc
Local dlnc
Local _GridInitValue
// Local _GridInitValue2
Local cTemp
Local xTemp

Local nDestinationColumn
Local nFrozenColumnCount
Local anOriginalColumnWidths
// Local anCurrentColumnWidths


// ADD
LOCAL _HMG_ControlHandle, _HMG_MouseRow, _HMG_MouseCol, _HMG_ControlContextMenu
LOCAL aux_hWnd, nIndex, _HMG_ret
LOCAL hFont

/*
   // Dr. Claudio Soto (June 2013)

   SetNewBehaviorWndProc (.T.)
   r := EventProcess (hWnd, nMsg, wParam, lParam, .F., .F., .T., (WH_MIN -1), -1)

   IF ValType (r) == "N"
      Return r
   ENDIF
   SetNewBehaviorWndProc (.F.)
   // ret <> Num   --> execution continues normally in the function EVENTS(), not returns to CALLBACK WndProc()
   // ret == -1    --> returns to CALLBACK WndProc() and executes DefWindowProc(Default Window Procedure)
   // ret <> -1    --> returns to CALLBACK WndProc() and NOT executes DefWindowProc(), the application is responsible for fully process the event

*/


   SetNewBehaviorWndProc (.F.)   // ADD2, December 2014

   For i := 1 To HMG_LEN ( _HMG_SYSDATA [60] )
      cProc := _HMG_SYSDATA [60] [ i ]  // Custom Event Procedures Array
      r := &cProc ( hWnd , nMsg , wParam , lParam )
      if ValType ( r ) == 'N'
         Return r
      Endif
   Next i
   // ret <> Num   --> execution continues normally in the function EVENTS(), not returns to CALLBACK WndProc()
   // ret == 0     --> returns to CALLBACK WndProc() and executes DefWindowProc(Default Window Procedure)
   // ret <> 0     --> returns to CALLBACK WndProc() and NOT executes DefWindowProc(), the application is responsible for fully process the event


	do case

        **********************************************************************************************************
   case nMsg == _HMG_MsgIDFindDlg   // FindReplace Dialog Notification   ( by Dr. Claudio Soto, January 2014 )
        **********************************************************************************************************
         _HMG_FindReplaceOptions := FindReplaceDlgGetOptions (lParam)

         EVAL ( _HMG_FindReplaceOnAction )

         IF _HMG_FindReplaceOptions [1] == 0   // User CANCEL or CLOSE Dialog
            FindReplaceDlgRelease ( .T. )      // Destroy Dialog Window and Set NULL Dialog Handle
         ENDIF

         AFILL ( _HMG_FindReplaceOptions, NIL )


        ***********************************************************************
	case nMsg == _HMG_SYSDATA [54] //Drag ListBox Notification
        ***********************************************************************

		dlnc := GET_DRAG_LIST_NOTIFICATION_CODE(lParam)

		if dlnc == DL_BEGINDRAG

			* Original Item
			_HMG_SYSDATA [53] := GET_DRAG_LIST_DRAGITEM(lParam)
			RETURN 1

		elseif dlnc == DL_DRAGGING

			* Current Item
			_HMG_SYSDATA [52] := GET_DRAG_LIST_DRAGITEM(lParam)


			IF _HMG_SYSDATA [52] > _HMG_SYSDATA [53]

				DRAG_LIST_DRAWINSERT(hWnd,lParam,_HMG_SYSDATA [52] + 1 )

			ELSE

				DRAG_LIST_DRAWINSERT(hWnd,lParam,_HMG_SYSDATA [52] )

			ENDIF


			IF _HMG_SYSDATA [52] <> -1


				IF _HMG_SYSDATA [52] > _HMG_SYSDATA [53]
					DRAG_LIST_SETCURSOR_DOWN()
				ELSE
					DRAG_LIST_SETCURSOR_UP()
				ENDIF

				RETURN 0

			ENDIF

			RETURN DL_STOPCURSOR

		elseif dlnc == DL_CANCELDRAG
			_HMG_SYSDATA [53] := -1

		elseif dlnc == DL_DROPPED

			_HMG_SYSDATA [52] := GET_DRAG_LIST_DRAGITEM(lParam)

			IF _HMG_SYSDATA [52] <> -1

				DRAG_LIST_MOVE_ITEMS(lParam,_HMG_SYSDATA [53],_HMG_SYSDATA [52])

			ENDIF

			DRAG_LIST_DRAWINSERT(hWnd,lParam, -1 )

			_HMG_SYSDATA [53] := -1

		endif

        ***********************************************************************
	case nMsg == WM_CTLCOLORSTATIC
        ***********************************************************************

		i := ascan ( _HMG_SYSDATA [3] , lParam )

		if i > 0

			If _HMG_SYSDATA [1] [i] ==  'EDIT' .OR. _HMG_SYSDATA [1] [i] == 'TEXT' .OR. _HMG_SYSDATA [1] [i] ==  'NUMTEXT' .OR. _HMG_SYSDATA [1] [i] ==  'MASKEDTEXT' .OR. _HMG_SYSDATA [1] [i] ==  'CHARMASKTEXT'


				If _HMG_SYSDATA [ 40 ] [ i ] [ 10 ] != Nil
					SetTextColor( wParam,_HMG_SYSDATA [ 40 ] [ i ] [ 10 ] [1], _HMG_SYSDATA [ 40 ] [ i ] [ 10 ] [2] , _HMG_SYSDATA [ 40 ] [ i ] [ 10 ] [3] )
				EndIf

				If _HMG_SYSDATA [ 40 ] [ i ] [ 9 ] != Nil
					SetBkColor( wParam,_HMG_SYSDATA [ 40 ] [ i ] [ 9 ] [1] ,_HMG_SYSDATA [ 40 ] [ i ] [ 9 ] [2] ,_HMG_SYSDATA [ 40 ] [ i ] [ 9 ] [3] )
					DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
					_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( _HMG_SYSDATA [ 40 ] [ i ] [ 9 ] [1] ,_HMG_SYSDATA [ 40 ] [ i ] [ 9 ] [2] ,_HMG_SYSDATA [ 40 ] [ i ] [ 9 ] [3] )
					return ( _HMG_SYSDATA [ 37 ] [i] )
				Else

					DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
					_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_MENU ) ) , GetGreen ( GetSysColor ( COLOR_MENU ) ) , GetBlue ( GetSysColor ( COLOR_MENU ) ) )
					SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_MENU ) ) , GetGreen ( GetSysColor ( COLOR_MENU) ) , GetBlue ( GetSysColor ( COLOR_MENU ) ) )
					return ( _HMG_SYSDATA [ 37 ] [i] )

				EndIf

			EndIf


         If _HMG_SYSDATA [1] [i] ==  "LABEL"  .Or. _HMG_SYSDATA [1] [i] == "CHECKBOX" .Or. _HMG_SYSDATA [1] [i] == "FRAME" .Or. _HMG_SYSDATA [1] [i] == "SLIDER"

           if ( IsAppThemed() ) .AND. _HMG_SYSDATA [1] [i] == "SLIDER" .and. _hmg_sysdata [23] [i] <> -1 .and. _hmg_sysdata [24] [i] <> -1 .AND. _HMG_SYSDATA [ 14 ] [i] == Nil
					if _hmg_sysdata [16] [i] == .F.
						DeleteObject ( _HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [36] [i],_hmg_sysdata [37] [i])] )
						_HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [36] [i],_hmg_sysdata [37] [i])] := _GetTabBrush( GetControlHandle(_hmg_sysdata [36] [i],_hmg_sysdata [37] [i]) )
						Return _GetTabbedControlBrush ( wParam , lParam , GetControlHandle (_hmg_sysdata [36] [i],_hmg_sysdata [37] [i]) , _HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [36] [i],_hmg_sysdata [37] [i])] )
					ENDIF
				endif

           if ( IsAppThemed() ) .AND. _HMG_SYSDATA [1] [i] == "FRAME" .and. _hmg_sysdata [23] [i] <> -1 .and. _hmg_sysdata [24] [i] <> -1  .AND. _HMG_SYSDATA [ 14 ] [i] == Nil
					if _hmg_sysdata [16] [i] == .F.
						DeleteObject ( _HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] )
						_HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] := _GetTabBrush( GetControlHandle(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i]) )
						Return _GetTabbedControlBrush ( wParam , lParam , GetControlHandle (_hmg_sysdata [31] [i],_hmg_sysdata [32] [i]) , _HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] )
					endif
				endif

            if ( IsAppThemed() ) .and. _HMG_SYSDATA [1] [i] == "CHECKBOX" .and. _hmg_sysdata [23] [i] <> -1 .and. _hmg_sysdata [24] [i] <> -1  .AND. _HMG_SYSDATA [ 14 ] [i] == Nil
					if _hmg_sysdata [16] [i] == .F.
						DeleteObject ( _HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] )
						_HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] := _GetTabBrush( GetControlHandle(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i]) )
						Return _GetTabbedControlBrush ( wParam , lParam , GetControlHandle (_hmg_sysdata [31] [i],_hmg_sysdata [32] [i]) , _HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] )
					endif
				endif

				If _HMG_SYSDATA [ 15 ] [i] != Nil
               SetTextColor( wParam,_HMG_SYSDATA [ 15 ] [i] [1], _HMG_SYSDATA [ 15 ] [i] [2] , _HMG_SYSDATA [ 15 ] [i] [3] )
				EndIf

				If ValType ( _HMG_SYSDATA [  9 ] [i] ) == 'L'
					If _HMG_SYSDATA [  9 ] [i] == .T.
                  SetBkMode( wParam , TRANSPARENT )
                  Return ( GetStockObject (NULL_BRUSH) )
					EndIf
				EndIf

				If _HMG_SYSDATA [ 14 ] [i] != Nil

					SetBkColor( wParam,_HMG_SYSDATA [ 14 ] [i] [1] ,_HMG_SYSDATA [ 14 ] [i] [2] ,_HMG_SYSDATA [ 14 ] [i] [3] )
					DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
					_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( _HMG_SYSDATA [ 14 ] [i] [1] ,_HMG_SYSDATA [ 14 ] [i] [2] ,_HMG_SYSDATA [ 14 ] [i] [3] )
					return ( _HMG_SYSDATA [ 37 ] [i] )

				Else

					DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
					_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) )
					SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) )
					return ( _HMG_SYSDATA [ 37 ] [i] )

				EndIf

			EndIf

		Else

			For i := 1 To HMG_LEN ( _HMG_SYSDATA [3] )

				If ValType ( _HMG_SYSDATA [3] [i] ) == 'A'

					If _HMG_SYSDATA [1] [i] == 'RADIOGROUP'

						For x := 1 To HMG_LEN ( _HMG_SYSDATA [3] [i] )

						        If _HMG_SYSDATA [3] [i] [x] == lParam

								If _HMG_SYSDATA [ 15 ] [i] != Nil
									SetTextColor( wParam,_HMG_SYSDATA [ 15 ] [i] [1], _HMG_SYSDATA [ 15 ] [i] [2] , _HMG_SYSDATA [ 15 ] [i] [3] )
								EndIf

                     // if ( IsAppThemed() ) .and. _hmg_sysdata [23] [i] <> -1 .and. _hmg_sysdata [24] [i] <> -1   // Bug: set background color in RADIOGROUP when defined in the TAB control
                        if ( IsAppThemed() ) .and. _hmg_sysdata [23] [i] <> -1 .and. _hmg_sysdata [24] [i] <> -1  .AND. _HMG_SYSDATA [ 14 ] [i] == Nil
									if _hmg_sysdata [16] [i] == .F.
										DeleteObject ( _HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] )
										_HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] := _GetTabBrush( GetControlHandle(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i]) )
										Return _GetTabbedControlBrush ( wParam , lParam , GetControlHandle (_hmg_sysdata [31] [i],_hmg_sysdata [32] [i]) , _HMG_SYSDATA [ 39 ] [GetControlIndex(_hmg_sysdata [31] [i],_hmg_sysdata [32] [i])] )
									endif
                        endif

								If ValType ( _HMG_SYSDATA [  9 ] [i] ) == 'L'
									If _HMG_SYSDATA [  9 ] [i] == .T.
                              SetBkMode( wParam , TRANSPARENT )
										Return(GetStockObject( NULL_BRUSH ) )
                           EndIf
								EndIf

								If _HMG_SYSDATA [ 14 ] [i] != Nil
									SetBkColor( wParam,_HMG_SYSDATA [ 14 ] [i] [1] ,_HMG_SYSDATA [ 14 ] [i] [2] ,_HMG_SYSDATA [ 14 ] [i] [3] )
									if x == 1
										DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
										_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( _HMG_SYSDATA [ 14 ] [i] [1] ,_HMG_SYSDATA [ 14 ] [i] [2] ,_HMG_SYSDATA [ 14 ] [i] [3] )
									EndIf
									return ( _HMG_SYSDATA [ 37 ] [i] )
								Else
								   if x == 1
										DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
										_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) )
									EndIf
									SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_3DFACE) ) , GetGreen ( GetSysColor ( COLOR_3DFACE) ) , GetBlue ( GetSysColor ( COLOR_3DFACE) ) )
									return ( _HMG_SYSDATA [ 37 ] [i] )
								EndIf

							EndIf

						Next x

					EndIf

				EndIf

			Next i

		EndIf

        ***********************************************************************
	case nMsg == WM_CTLCOLOREDIT .Or. nMsg == WM_CTLCOLORLISTBOX
        ***********************************************************************

		i := ascan ( _HMG_SYSDATA [3] , lParam )

		if i > 0

			If _HMG_SYSDATA [1] [i] ==  "NUMTEXT" .or. _HMG_SYSDATA [1] [i] == "TEXT" .or. _HMG_SYSDATA [1] [i] == "MASKEDTEXT" .or. _HMG_SYSDATA [1] [i] == "CHARMASKTEXT"  .or. _HMG_SYSDATA [1] [i] == "EDIT" .or. _HMG_SYSDATA [1] [i] == "LIST"  .or. _HMG_SYSDATA [1] [i] == "MULTILIST"

				If _HMG_SYSDATA [ 15 ] [i] != Nil
					SetTextColor( wParam,_HMG_SYSDATA [ 15 ] [i] [1], _HMG_SYSDATA [ 15 ] [i] [2] , _HMG_SYSDATA [ 15 ] [i] [3] )
				EndIf

				If _HMG_SYSDATA [ 14 ] [i] != Nil
					SetBkColor( wParam,_HMG_SYSDATA [ 14 ] [i] [1] ,_HMG_SYSDATA [ 14 ] [i] [2] ,_HMG_SYSDATA [ 14 ] [i] [3] )
					DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
					_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( _HMG_SYSDATA [ 14 ] [i] [1] ,_HMG_SYSDATA [ 14 ] [i] [2] ,_HMG_SYSDATA [ 14 ] [i] [3] )
					return ( _HMG_SYSDATA [ 37 ] [i] )
				Else

					DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
					_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_WINDOW) ) , GetGreen ( GetSysColor ( COLOR_WINDOW) ) , GetBlue ( GetSysColor ( COLOR_WINDOW) ) )
					SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_WINDOW) ) , GetGreen ( GetSysColor ( COLOR_WINDOW) ) , GetBlue ( GetSysColor ( COLOR_WINDOW) ) )
					return ( _HMG_SYSDATA [ 37 ] [i] )

				EndIf

			EndIf

		Else

			For i := 1 To HMG_LEN ( _HMG_SYSDATA [3] )

				If ValType ( _HMG_SYSDATA [3] [i] ) == 'A'

					If _HMG_SYSDATA [1] [i] == 'SPINNER'

					        If _HMG_SYSDATA [3] [i] [1] == lParam

							If _HMG_SYSDATA [ 15 ] [i] != Nil
								SetTextColor( wParam,_HMG_SYSDATA [ 15 ] [i] [1], _HMG_SYSDATA [ 15 ] [i] [2] , _HMG_SYSDATA [ 15 ] [i] [3] )
							EndIf

							If _HMG_SYSDATA [ 14 ] [i] != Nil
								SetBkColor( wParam,_HMG_SYSDATA [ 14 ] [i] [1] ,_HMG_SYSDATA [ 14 ] [i] [2] ,_HMG_SYSDATA [ 14 ] [i] [3] )
								DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
								_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( _HMG_SYSDATA [ 14 ] [i] [1] ,_HMG_SYSDATA [ 14 ] [i] [2] ,_HMG_SYSDATA [ 14 ] [i] [3] )
								return ( _HMG_SYSDATA [ 37 ] [i] )
							Else
                                                       		DeleteObject ( _HMG_SYSDATA [ 37 ] [i] )
								_HMG_SYSDATA [ 37 ] [i] := CreateSolidBrush( GetRed ( GetSysColor ( COLOR_WINDOW) ) , GetGreen ( GetSysColor ( COLOR_WINDOW) ) , GetBlue ( GetSysColor ( COLOR_WINDOW) ) )
								SetBkColor( wParam, GetRed ( GetSysColor ( COLOR_WINDOW) ) , GetGreen ( GetSysColor ( COLOR_WINDOW) ) , GetBlue ( GetSysColor ( COLOR_WINDOW) ) )
								return ( _HMG_SYSDATA [ 37 ] [i] )
                                                       	EndIf

						EndIf

					EndIf

				EndIf

			Next i

		EndIf

        ***********************************************************************
	case nMsg == WM_HOTKEY
        ***********************************************************************

		* Process HotKeys

		i := Ascan ( _HMG_SYSDATA [  5 ] , wParam )

		If i > 0

			If _HMG_SYSDATA [1] [i] = "HOTKEY" .And. _HMG_SYSDATA [4][i] == GetActiveWindow()

				if hiword(lParam) == 27 .and. loword(lParam) == 0

					_HMG_CLOSEMENU( _HMG_SYSDATA [4][i] )

					DO EVENTS

				endif

				If _DoControlEventProcedure ( _HMG_SYSDATA [ 6 ] [i] , i )

					Return 0

				EndIf

			EndIf

		EndIf


        ***********************************************************************
	case nMsg == WM_MOUSEWHEEL
        ***********************************************************************

		hwnd := 0

		i := ascan ( _HMG_SYSDATA [ 67  ] , GetFocus() )

		if i > 0

			If _HMG_SYSDATA [ 91 ] [i] > 0
				hwnd := _HMG_SYSDATA [ 67  ] [i]
			EndIf

		Else

			i := ascan ( _HMG_SYSDATA [3] , GetFocus() )
			If i > 0

				x := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4] [i] )

				if x > 0
					If _HMG_SYSDATA [ 91 ] [x] > 0
						hwnd := _HMG_SYSDATA [ 67  ] [x]
						// i := x // Variable 'I' is assigned but not used in function
					EndIf
				EndIf
			Else
				ControlCount := HMG_LEN ( _HMG_SYSDATA [3] )
				For i := 1 To ControlCount
					if _HMG_SYSDATA [1] [i] == 'RADIOGROUP'
						x := ascan ( _HMG_SYSDATA [3] [i] , GetFocus() )
						If x > 0
							z := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4] [i] )
							if z > 0
								If _HMG_SYSDATA [ 91 ] [z] > 0
									hwnd := _HMG_SYSDATA [ 67  ] [z]
									// i := z  // Variable 'I' is assigned but not used in function
									Exit
								EndIf
							EndIf
						EndIf
					Endif
				Next i
			EndIf

		EndIf


		If hwnd != 0

			If HIWORD(wParam) == 120
				if GetScrollPos(hwnd,SB_VERT) < 25
					SendMessage ( hwnd , WM_VSCROLL , SB_TOP , 0 )
				Else
					SendMessage ( hwnd , WM_VSCROLL , SB_PAGEUP , 0 )
				endif
			Else
				if GetScrollPos(hwnd,SB_VERT) >= GetScrollRangeMax ( hwnd , SB_VERT ) - 10
					SendMessage ( hwnd , WM_VSCROLL , SB_BOTTOM , 0 )
				else
					SendMessage ( hwnd , WM_VSCROLL , SB_PAGEDOWN , 0 )
				endif
			EndIf

		EndIf

        ***********************************************************************
	case nMsg == WM_ACTIVATE
        ***********************************************************************

		if LoWord(wparam) == 0
			i := Ascan ( _HMG_SYSDATA [ 67  ] , hWnd )
			if i > 0

				ControlCount := HMG_LEN ( _HMG_SYSDATA [3] )

				For x := 1 To ControlCount
					if _HMG_SYSDATA [1] [x] == 'HOTKEY'
						ReleaseHotKey ( _HMG_SYSDATA [4] [x] , _HMG_SYSDATA [  5 ] [x] )
					EndIf
				Next x

			        _HMG_SYSDATA [ 101 ] [i] := GetFocus()

				_DoWindowEventProcedure ( _HMG_SYSDATA [ 86 ] [i] , i , 'WINDOW_LOSTFOCUS' )

			Endif

		Else

			i := Ascan ( _HMG_SYSDATA [ 67  ] , hWnd )
			if i > 0
				UpdateWIndow ( hWnd )
			EndIf

		EndIf

        ***********************************************************************
	case nMsg == WM_SETFOCUS
        ***********************************************************************

		i := Ascan ( _HMG_SYSDATA [ 67  ] , hWnd )

		if i > 0

			If _HMG_SYSDATA [ 68  ] [i] == .T. .and. _HMG_SYSDATA [ 69  ] [i] != 'X'
				_HMG_SYSDATA [ 166 ] := hWnd
			EndIf

			ControlCount := HMG_LEN ( _HMG_SYSDATA [3] )

			For x := 1 To ControlCount
				if _HMG_SYSDATA [1] [x] == 'HOTKEY'
					ReleaseHotKey ( _HMG_SYSDATA [4] [x] , _HMG_SYSDATA [  5 ] [x] )
				EndIf
			Next x

			For x := 1 To ControlCount
				if _HMG_SYSDATA [1] [x] == 'HOTKEY'
					If _HMG_SYSDATA [4][x] == hWnd
						InitHotKey ( hWnd , _HMG_SYSDATA [  7 ] [x] , _HMG_SYSDATA [  8 ] [x] , _HMG_SYSDATA [  5 ] [x] )
					EndIf
				EndIf
			Next x

			_DoWindowEventProcedure ( _HMG_SYSDATA [ 85 ] [i] , i , 'WINDOW_GOTFOCUS' )

			if ( _HMG_SYSDATA [ 101 ] [i] != 0 , setfocus (_HMG_SYSDATA [ 101 ] [i]) , Nil )

		Endif

        ***********************************************************************
	case nMsg == WM_HELP
        ***********************************************************************
/*
		i := ascan ( _HMG_SYSDATA [3] , GetHelpData ( lParam ) )

		if i > 0
			WinHelp ( hwnd , _HMG_SYSDATA [ 217 ] , 1  , 2 , _HMG_SYSDATA [ 35 ][i] )
		EndIf
*/

		i := ascan ( _HMG_SYSDATA [3] , GetHelpData ( lParam ) )

		if i > 0

      cTemp := _HMG_SYSDATA [ 217 ]
      xTemp := _HMG_SYSDATA [ 35 ][i]
      if HB_URIGHT ( ALLTRIM(HMG_UPPER(cTemp)) , 4 ) == '.CHM'
        _Execute( hwnd , "open" , "hh.exe" , cTemp + if( ValType( xTemp ) == 'C', '::/' + xTemp, '' ) , , SW_SHOW )   // ADD, Kevin march 2017
      else
        WinHelp ( hwnd , cTemp , 1  , 2 , xTemp )
      Endif

		EndIf

        ***********************************************************************
	case nMsg == WM_VSCROLL
        ***********************************************************************

		i := aScan ( _HMG_SYSDATA [ 67  ] , hWnd )

		if i > 0

			* Vertical ScrollBar Processing

			if _HMG_SYSDATA [ 91 ] [i] > 0 .And. lParam == 0

				If _HMG_SYSDATA [ 87 ] [i] > 0
					MsgHMGError("SplitBox's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )
				EndIf

				If LoWord(wParam) == SB_LINEDOWN

				        NewPos := GetScrollPos(hwnd,SB_VERT) + _HMG_SYSDATA [ 345 ]
					SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

				ElseIf LoWord(wParam) == SB_LINEUP

				        NewPos := GetScrollPos(hwnd,SB_VERT) - _HMG_SYSDATA [ 345 ]
					SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

				ElseIf LoWord(wParam) == SB_TOP

				        NewPos := 0
					SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

				ElseIf LoWord(wParam) == SB_BOTTOM

				        NewPos := GetScrollRangeMax(hwnd,SB_VERT)
					SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

				ElseIf LoWord(wParam) == SB_PAGEUP

				        NewPos := GetScrollPos(hwnd,SB_VERT) - _HMG_SYSDATA [ 501 ]
					SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

				ElseIf LoWord(wParam) == SB_PAGEDOWN

				        NewPos := GetScrollPos(hwnd,SB_VERT) + _HMG_SYSDATA [ 501 ]
					SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

				ElseIf LoWord(wParam) == SB_THUMBPOSITION

					NewPos := HIWORD(wParam)
					SetScrollPos ( hwnd , SB_VERT , NewPos , .T. )

				EndIf

				If _HMG_SYSDATA [ 92 ] [i] > 0
				        NewHPos := GetScrollPos ( hwnd , SB_HORZ )
				Else
				        NewHPos := 0
				EndIf



* Panel Window Repositioning ( by Dr. Claudio Soto, April 2014 )

If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINEDOWN .Or. LoWord(wParam) == SB_LINEUP .or. LoWord(wParam) == SB_PAGEUP .or. LoWord(wParam) == SB_PAGEDOWN  .or. LoWord(wParam) == SB_BOTTOM  .or. LoWord(wParam) == SB_TOP
   FOR x := 1 To HMG_LEN ( _HMG_SYSDATA [ 67 ] )
      IF _HMG_SYSDATA [ 65 ] [x] == .F.
         IF _HMG_SYSDATA [ 69 ] [x] == 'P' .AND. _HMG_SYSDATA [ 70 ] [x] == hWnd
            MoveWindow ( _HMG_SYSDATA [67] [x] , _HMG_SYSDATA [504] [x] [1] - NewHPos , _HMG_SYSDATA [504] [x] [2] - NewPos , _HMG_SYSDATA [504] [x] [3], _HMG_SYSDATA [504] [x] [4], .T. )
            // RedrawWindow ( hWnd )
         ENDIF
      ENDIF
   NEXT
EndIf


				* Control Repositioning

				If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINEDOWN .Or. LoWord(wParam) == SB_LINEUP .or. LoWord(wParam) == SB_PAGEUP .or. LoWord(wParam) == SB_PAGEDOWN  .or. LoWord(wParam) == SB_BOTTOM  .or. LoWord(wParam) == SB_TOP

					For x := 1 To HMG_LEN ( _HMG_SYSDATA [3] )

						If _HMG_SYSDATA [4] [x] == hwnd

							If _HMG_SYSDATA [1] [x] == 'SPINNER'

								MoveWindow ( _HMG_SYSDATA [3] [x] [1]	, _HMG_SYSDATA [ 19 ] [x] - NewHPos				, _HMG_SYSDATA [ 18 ] [x] - NewPos , _HMG_SYSDATA [ 20 ] [x] - GetWindowWidth(_HMG_SYSDATA [3] [x] [2] )+1	, _HMG_SYSDATA [ 21 ] [x] , .t. )
								MoveWindow ( _HMG_SYSDATA [3] [x] [2]	, _HMG_SYSDATA [ 19 ] [x] + _HMG_SYSDATA [ 20 ] [x] - GetWindowWidth(_HMG_SYSDATA [3] [x] [2] ) - NewHPos , _HMG_SYSDATA [ 18 ] [x] - NewPos , GetWindowWidth(_HMG_SYSDATA [3] [x] [2] )			, _HMG_SYSDATA [ 21 ] [x] , .t. )

							#ifdef COMPILEBROWSE

							ElseIf _HMG_SYSDATA [1] [x] == 'BROWSE'

								MoveWindow ( _HMG_SYSDATA [3] [x] 	, _HMG_SYSDATA [ 19 ] [x] - NewHPos			, _HMG_SYSDATA [ 18 ] [x] - NewPos , _HMG_SYSDATA [ 20 ] [x] - GETVSCROLLBARWIDTH() , _HMG_SYSDATA [ 21 ] [x] , .t. )
								MoveWindow ( _HMG_SYSDATA [  5 ] [x] 	, _HMG_SYSDATA [ 19 ] [x] + _HMG_SYSDATA [ 20 ] [x] - GETVSCROLLBARWIDTH()  - NewHPos	, _HMG_SYSDATA [ 18 ] [x] - NewPos , GETVSCROLLBARWIDTH() 			, GetWIndowHeight(_HMG_SYSDATA [  5 ] [x]) , .t. )
								MoveWindow ( _HMG_SYSDATA [ 39 ] [x] [1]	, _HMG_SYSDATA [ 19 ] [x] + _HMG_SYSDATA [ 20 ] [x] - GETVSCROLLBARWIDTH()  - NewHPos	, _HMG_SYSDATA [ 18 ] [x] +_HMG_SYSDATA [ 21 ] [x] - GetHScrollBarHeight () - NewPos ,GetWindowWidth(_HMG_SYSDATA [ 39 ] [x][1])	, GetWindowHeight(_HMG_SYSDATA [ 39 ] [x][1])  , .t. )
								ReDrawWindow ( _HMG_SYSDATA [3] [x] )

							#endif

							ElseIf _HMG_SYSDATA [1] [x] == 'RADIOGROUP'


								If _HMG_SYSDATA [8] [x] == .F.

									For z := 1 To HMG_LEN (_HMG_SYSDATA [3] [x])
										MoveWindow ( _HMG_SYSDATA [3] [x] [z]	, _HMG_SYSDATA [ 19 ] [x] - NewHPos , _HMG_SYSDATA [ 18 ] [x] - NewPos + ( (z-1) * _HMG_SYSDATA [ 22 ][x] ), _HMG_SYSDATA [ 20 ] [x] 	, _HMG_SYSDATA [ 21 ] [x] / HMG_LEN (_HMG_SYSDATA [3] [x]) , .t. )
									Next z

								Else

									For z := 1 To HMG_LEN (_HMG_SYSDATA [3] [x])
										MoveWindow ( _HMG_SYSDATA [3] [x] [z] , _HMG_SYSDATA [ 19 ] [x] - NewHPos + (z-1) * _HMG_SYSDATA [ 22 ] [x] , _HMG_SYSDATA [ 18 ] [x] - NewPos , _HMG_SYSDATA [ 20 ] [x] / HMG_LEN (_HMG_SYSDATA [3] [x])  , _HMG_SYSDATA [ 21 ] [x] , .t. )
									Next z

								EndIf

							ElseIf _HMG_SYSDATA [1] [x] == 'TOOLBAR'

								MsgHMGError("ToolBar's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )

                     ElseIf _HMG_SYSDATA [1] [x] == 'STATUSBAR'   // Dr. Claudio Soto (November 2013)
                        // No change

							Else

								MoveWindow ( _HMG_SYSDATA [3] [x] , _HMG_SYSDATA [ 19 ] [x] - NewHPos , _HMG_SYSDATA [ 18 ] [x] - NewPos , _HMG_SYSDATA [ 20 ] [x] 	, _HMG_SYSDATA [ 21 ] [x] , .t. )

							EndIf

						EndIf
					Next x

					ReDrawWindow ( hwnd )

				EndIf

			EndIf

			If LoWord(wParam) == SB_LINEDOWN
				_DoWindowEventProcedure ( _HMG_SYSDATA [ 95 ] [i] , i , '' )
			ElseIf LoWord(wParam) == SB_LINEUP
				_DoWindowEventProcedure ( _HMG_SYSDATA [ 94 ] [i] , i , '' )
			ElseIf LoWord(wParam) == SB_THUMBPOSITION ;
				.or. ;
				LoWord(wParam) == SB_PAGEUP ;
				.or. ;
				LoWord(wParam) == SB_PAGEDOWN ;
				.or. ;
				LoWord(wParam) == SB_TOP ;
				.or. ;
				LoWord(wParam) == SB_BOTTOM

				_DoWindowEventProcedure ( _HMG_SYSDATA [ 99 ] [i] , i , '' )

			EndIf

		EndIf

		i := aScan ( _HMG_SYSDATA [  5 ] , lParam )

		if i > 0

			#ifdef COMPILEBROWSE

			if _HMG_SYSDATA [1] [i] == 'BROWSE'

				If LoWord(wParam) == SB_LINEDOWN

					setfocus( _HMG_SYSDATA [3] [i] )
					InsertDown()

				EndIf

				If LoWord(wParam) == SB_LINEUP

					setfocus( _HMG_SYSDATA [3] [i] )
					InsertUp()

				EndIf

				If LoWord(wParam) == SB_PAGEUP
					setfocus( _HMG_SYSDATA [3] [i] )
					InsertPrior()
				EndIf

				If LoWord(wParam) == SB_PAGEDOWN
					setfocus( _HMG_SYSDATA [3] [i] )
					InsertNext()
				EndIf

				If LoWord(wParam) == SB_THUMBPOSITION

					BackArea := Alias()
					BrowseArea := _HMG_SYSDATA [ 22 ] [i]

					If Select (BrowseArea) != 0

						Select &BrowseArea
						BackRec := RecNo()

						If ordKeyCount() > 0
							RecordCount := ordKeyCount()
						Else
							RecordCount := RecCount()
						EndIf

						SkipCount := Int ( HIWORD(wParam) * RecordCount / GetScrollRangeMax ( _HMG_SYSDATA [  5 ] [ i ] , 2 ) )

						If SkipCount > ( RecordCount / 2 )
					                Go Bottom
        						Skip - ( RecordCount - SkipCount )
						Else
							Go Top
	        					Skip SkipCount
						EndIf

						If Eof()
							Skip -1
						EndIf

						nr := RecNo()

						SetScrollPos ( _HMG_SYSDATA [  5 ] [i] , 2 , HIWORD(wParam) , .t. )

						Go BackRec

						If Select (BackArea) != 0
							Select &BackArea
						Else
							Select 0
						EndIf

						_BrowseSetValue ( '' , '' , nr , i )

					EndIf

				EndIf

			EndIf

			#endif

		EndIf

		i := Ascan ( _HMG_SYSDATA [3] , lParam )
		if ( i > 0 )
			If LoWord (wParam) == TB_ENDTRACK
				_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
			EndIf
		EndIf


        ***********************************************************************
	case nMsg == WM_TASKBAR
        ***********************************************************************

		If wParam == ID_TASKBAR .and. lParam # WM_MOUSEMOVE
			aPos := GETCURSORPOS()

			do case

				case lParam == WM_LBUTTONDOWN

					i := Ascan ( _HMG_SYSDATA [ 67  ] , hWnd )
					if i > 0
						_DoWindowEventProcedure ( _HMG_SYSDATA [ 84 ] [i] , i , "TASKBAR" )   //  ADD, November 2016
					Endif

				case lParam == WM_RBUTTONDOWN

					if _HMG_SYSDATA [ 338 ] == .t.

						I := Ascan ( _HMG_SYSDATA [ 67  ] , hWnd )
						if i > 0
							if _HMG_SYSDATA [ 88 ] [i] != 0
								TrackPopupMenu ( _HMG_SYSDATA [ 88 ] [i]  , aPos[2] , aPos[1] , hWnd )
							Endif
						Endif

					EndIf

			endcase
		EndIf

        ***********************************************************************
	case nMsg == WM_NEXTDLGCTL
        ***********************************************************************
#if 0

		If Wparam == 0
			NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .F. )
		else
			NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .T. )
		endif

#else   // by Dr. Claudio Soto, march 2017

   IF LOWORD( lParam ) <> 0   // if LOWORD( lParam ) == .T.

      NextControlHandle = wParam   // wParam identifies the handle of the control that receives the focus

   ELSE                       // if LOWORD( lParam ) == .F.

      If wParam == 0
         NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .F. )   // next control with the WS_TABSTOP style receives the focus
      else
         NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .T. )   // previous control with the WS_TABSTOP style receives the focus
      endif

   ENDIF

#endif

		setfocus( NextControlHandle )

		i := ascan ( _HMG_SYSDATA [3] , NextControlHandle )

		if i > 0
			If _HMG_SYSDATA [1] [i] == 'BUTTON'
				SendMessage ( NextControlHandle , BM_SETSTYLE , LOWORD ( BS_DEFPUSHBUTTON ) , 1 )
			ElseIf _HMG_SYSDATA [1] [i] == 'EDIT' .OR. _HMG_SYSDATA [1] [i] == 'TEXT'
			      	SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , 0 , -1 )
			endif
		EndIf

		Return 0

        ***********************************************************************
	case nMsg == WM_HSCROLL
        ***********************************************************************

		i := aScan ( _HMG_SYSDATA [ 67  ] , hWnd )

		if i > 0

			* Horizontal ScrollBar Processing

			if _HMG_SYSDATA [ 92 ] [i] > 0 .And. lParam == 0

				If _HMG_SYSDATA [ 87 ] [i] > 0
					MsgHMGError("SplitBox's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )
				EndIf

				If LoWord(wParam) == SB_LINERIGHT

				        NewHPos := GetScrollPos(hwnd,SB_HORZ) + _HMG_SYSDATA [ 345 ]
					SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

				ElseIf LoWord(wParam) == SB_LINELEFT

				        NewHPos := GetScrollPos(hwnd,SB_HORZ) - _HMG_SYSDATA [ 345 ]
					SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

				ElseIf LoWord(wParam) == SB_PAGELEFT

				        NewHPos := GetScrollPos(hwnd,SB_HORZ) - _HMG_SYSDATA [ 501 ]
					SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

				ElseIf LoWord(wParam) == SB_PAGERIGHT

				        NewHPos := GetScrollPos(hwnd,SB_HORZ) + _HMG_SYSDATA [ 501 ]
					SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

				ElseIf LoWord(wParam) == SB_THUMBPOSITION

					NewHPos := HIWORD(wParam)
					SetScrollPos ( hwnd , SB_HORZ , NewHPos , .T. )

				EndIf

				If _HMG_SYSDATA [ 91 ] [i] > 0
				        NewVPos := GetScrollPos ( hwnd , SB_VERT )
				Else
				        NewVPos := 0
				EndIf


* Panel Window Repositioning ( by Dr. Claudio Soto, April 2014 )

If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINELEFT .Or. LoWord(wParam) == SB_LINERIGHT .OR. LoWord(wParam) == SB_PAGELEFT	.OR. LoWord(wParam) == SB_PAGERIGHT
   FOR x := 1 To HMG_LEN ( _HMG_SYSDATA [ 67 ] )
      IF _HMG_SYSDATA [ 65 ] [x] == .F.
         IF _HMG_SYSDATA [ 69 ] [x] == 'P' .AND. _HMG_SYSDATA [ 70 ] [x] == hWnd
            MoveWindow ( _HMG_SYSDATA [67] [x] , _HMG_SYSDATA [504] [x] [1] - NewHPos , _HMG_SYSDATA [504] [x] [2] - NewVPos , _HMG_SYSDATA [504] [x] [3], _HMG_SYSDATA [504] [x] [4], .T. )
            // RedrawWindow ( hWnd )
         ENDIF
      ENDIF
   NEXT
EndIf


				* Control Repositioning

				If LoWord(wParam) == SB_THUMBPOSITION .Or. LoWord(wParam) == SB_LINELEFT .Or. LoWord(wParam) == SB_LINERIGHT .OR. LoWord(wParam) == SB_PAGELEFT	.OR. LoWord(wParam) == SB_PAGERIGHT

					For x := 1 To HMG_LEN ( _HMG_SYSDATA [3] )

						If _HMG_SYSDATA [4] [x] == hwnd

							If _HMG_SYSDATA [1] [x] == 'SPINNER'

								MoveWindow ( _HMG_SYSDATA [3] [x] [1]	, _HMG_SYSDATA [ 19 ] [x] - NewHPos				, _HMG_SYSDATA [ 18 ] [x] - NewVPos , _HMG_SYSDATA [ 20 ] [x] - GetWindowWidth(_HMG_SYSDATA [3] [x] [2] )+1	, _HMG_SYSDATA [ 21 ] [x] , .t. )
								MoveWindow ( _HMG_SYSDATA [3] [x] [2]	, _HMG_SYSDATA [ 19 ] [x] + _HMG_SYSDATA [ 20 ] [x] - GetWindowWidth(_HMG_SYSDATA [3] [x] [2] ) - NewHPos	, _HMG_SYSDATA [ 18 ] [x] - NewVPos , GetWindowWidth(_HMG_SYSDATA [3] [x] [2] ) , _HMG_SYSDATA [ 21 ] [x] , .t. )

							#ifdef COMPILEBROWSE

							ElseIf _HMG_SYSDATA [1] [x] == 'BROWSE'

								MoveWindow ( _HMG_SYSDATA [3] [x] 	, _HMG_SYSDATA [ 19 ] [x] - NewHPos				, _HMG_SYSDATA [ 18 ] [x] - NewVPos , _HMG_SYSDATA [ 20 ] [x] - GETVSCROLLBARWIDTH()	, _HMG_SYSDATA [ 21 ] [x] , .t. )
								MoveWindow ( _HMG_SYSDATA [  5 ] [x] 	, _HMG_SYSDATA [ 19 ] [x] + _HMG_SYSDATA [ 20 ] [x] - GETVSCROLLBARWIDTH() - NewHPos	, _HMG_SYSDATA [ 18 ] [x] - NewVPos , GetWindowWidth(_HMG_SYSDATA [  5 ] [x])			, GetWindowHeight(_HMG_SYSDATA [  5 ] [x]) , .t. )
								MoveWindow ( _HMG_SYSDATA [ 39 ] [x] [1]	, _HMG_SYSDATA [ 19 ] [x] + _HMG_SYSDATA [ 20 ] [x] - GETVSCROLLBARWIDTH() - NewHPos	, _HMG_SYSDATA [ 18 ] [x] +_HMG_SYSDATA [ 21 ][x] - GethScrollBarHeight() - NewVPos , GetWindowWidth(_HMG_SYSDATA [ 39 ] [x] [1])			, GetWindowHeight (_HMG_SYSDATA [ 39 ] [x][1]) , .t. )
								ReDrawWindow ( _HMG_SYSDATA [3] [x] )

							#endif

							ElseIf _HMG_SYSDATA [1] [x] == 'RADIOGROUP'

								If _HMG_SYSDATA [8] [x] == .F.

									For z := 1 To HMG_LEN (_HMG_SYSDATA [3] [x])
										MoveWindow ( _HMG_SYSDATA [3] [x] [z]	, _HMG_SYSDATA [ 19 ] [x] - NewHPos , _HMG_SYSDATA [ 18 ] [x] - NewVPos + ( (z-1) * _HMG_SYSDATA [ 22 ][x] ), _HMG_SYSDATA [ 20 ] [x] 	, _HMG_SYSDATA [ 21 ] [x] / HMG_LEN (_HMG_SYSDATA [3] [x]) , .t. )
									Next z

								Else

									For z := 1 To HMG_LEN (_HMG_SYSDATA [3] [x])
										MoveWindow ( _HMG_SYSDATA [3] [x] [z] , _HMG_SYSDATA [ 19 ] [x] - NewHPos + (z-1) * _HMG_SYSDATA [ 22 ] [x] , _HMG_SYSDATA [ 18 ] [x] - NewVPos , _HMG_SYSDATA [ 20 ] [x] / HMG_LEN (_HMG_SYSDATA [3] [x]), _HMG_SYSDATA [ 21 ] [x] , .t. )
									Next z

								EndIf

							ElseIf _HMG_SYSDATA [1] [x] == 'TOOLBAR'

								MsgHMGError("ToolBar's Parent Window Can't Be a 'Virtual Dimensioned' Window (Use 'Virtual Dimensioned' SplitChild Instead). Program terminated" )


                     ElseIf _HMG_SYSDATA [1] [x] == 'STATUSBAR'   // Dr. Claudio Soto (November 2013)
                           // No change

							Else

								MoveWindow ( _HMG_SYSDATA [3] [x] , _HMG_SYSDATA [ 19 ] [x] - NewHPos , _HMG_SYSDATA [ 18 ] [x] - NewVPos , _HMG_SYSDATA [ 20 ] [x] , _HMG_SYSDATA [ 21 ] [x] , .t. )

							EndIf

						EndIf
					Next x

					RedrawWindow ( hwnd )

				EndIf

			EndIf

			If LoWord(wParam) == SB_LINERIGHT

				_DoWindowEventProcedure ( _HMG_SYSDATA [ 97 ] [i] , i , '' )

			ElseIf LoWord(wParam) == SB_LINELEFT

				_DoWindowEventProcedure ( _HMG_SYSDATA [ 96 ] [i] , i , '' )

			ElseIf	LoWord(wParam) == SB_THUMBPOSITION ;
				.or. ;
				LoWord(wParam) == SB_PAGELEFT ;
				.or. ;
				LoWord(wParam) == SB_PAGERIGHT

				_DoWindowEventProcedure ( _HMG_SYSDATA [ 98 ] [i] , i , '' )

			EndIf

		EndIf

		i := Ascan ( _HMG_SYSDATA [3] , lParam )
		if ( i > 0 )
			If LoWord (wParam) == TB_ENDTRACK
				_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
			EndIf
		EndIf

        ***********************************************************************
	case nMsg == WM_PAINT
        ***********************************************************************

        i := Ascan ( _HMG_SYSDATA [ 67 ] , hWnd )
         if i > 0
            _DoWindowEventProcedure ( _HMG_SYSDATA [ 80 ][i] , i , '' ) // _HMG_aFormPaintProcedure
            For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 102 ] [i] )
               Eval ( _HMG_SYSDATA [ 102 ] [i] [x] )                    // _HMG_aFormGraphTasks
            Next x
         Endif

         FormCount := HMG_LEN ( _HMG_SYSDATA [ 67  ] )
         For z := 1 To FormCount
            // _HMG_aFormDeleted_                       _HMG_aFormType ---> X = SplitChildWindow
            If _HMG_SYSDATA [ 65 ] [z] == .F.   .AND.   _HMG_SYSDATA [ 69 ] [z] == 'X'
               _DoWindowEventProcedure ( _HMG_SYSDATA [ 80 ][z] , z , '' ) // _HMG_aFormPaintProcedure
               IF ValType ( _HMG_SYSDATA [ 102 ] [z] ) == 'A'
                  For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 102 ] [z] )
                     Eval ( _HMG_SYSDATA [ 102 ] [z] [x] )  // _HMG_aFormGraphTasks
                  Next x
               ENDIF
            EndIf
         Next z

         RepositionToolBar(i)

         Return 0 //call DefWindowProc( hWnd, nMsg, wParam, lParam )


         ***********************************************************************
	case nMsg == WM_LBUTTONDOWN
        ***********************************************************************

		_HMG_SYSDATA [ 191 ] := HIWORD(lParam)
		_HMG_SYSDATA [ 192 ] := LOWORD(lParam)
		_HMG_SYSDATA [ 193 ] := 1

		i := Ascan ( _HMG_SYSDATA [ 67  ] , hWnd )

		if i > 0

			if _HMG_SYSDATA [ 91 ] [i] > 0
				_HMG_SYSDATA [ 191 ] := _HMG_SYSDATA [ 191 ] + GetScrollPos(hwnd,SB_VERT)
			endif

			if _HMG_SYSDATA [ 92 ] [i] > 0
				_HMG_SYSDATA [ 192 ] := _HMG_SYSDATA [ 192 ] + GetScrollPos(hwnd,SB_HORZ)
			endif

			_DoWindowEventProcedure ( _HMG_SYSDATA [ 77 ]  [i] , i , '' )

		Endif

        ***********************************************************************
	case nMsg == WM_LBUTTONUP
        ***********************************************************************

		_HMG_SYSDATA [ 193 ] := 0

        ***********************************************************************
	case nMsg == WM_NCMOUSEMOVE
        ***********************************************************************
      // Dr. Claudio Soto (June 2013)
      i := ASCAN ( _HMG_SYSDATA [ 67  ] , hWnd )
      IF i > 0
          _HMG_LastFormIndexWithCursor := i
      ENDIF

        ***********************************************************************
	case nMsg == WM_MOUSEMOVE
        ***********************************************************************

		_HMG_SYSDATA [ 191 ] := HIWORD(lParam)
		_HMG_SYSDATA [ 192 ] := LOWORD(lParam)

		I := Ascan ( _HMG_SYSDATA [ 67  ] , hWnd )
		if i > 0

         _HMG_LastFormIndexWithCursor := i

			if _HMG_SYSDATA [ 91 ] [i] > 0
				_HMG_SYSDATA [ 191 ] := _HMG_SYSDATA [ 191 ] + GetScrollPos(hwnd,SB_VERT)
			endif

			if _HMG_SYSDATA [ 92 ] [i] > 0
				_HMG_SYSDATA [ 192 ] := _HMG_SYSDATA [ 192 ] + GetScrollPos(hwnd,SB_HORZ)
			endif

			if wParam == MK_LBUTTON
				_DoWindowEventProcedure ( _HMG_SYSDATA [ 75  ]  [i] , i , "MOUSEMOVE" )
			Else
				_DoWindowEventProcedure ( _HMG_SYSDATA [ 78 ]  [i] , i , "MOUSEMOVE" )
			Endif

		endif

        ***********************************************************************
	case nMsg == WM_CONTEXTMENU
        ***********************************************************************

// Dr. Claudio Soto (May 2013)

   _HMG_ControlHandle := wParam
   _HMG_MouseRow  := HIWORD(lParam)
   _HMG_MouseCol  := LOWORD(lParam)
   _HMG_ControlContextMenu := 0
   i := 0

   IF _HMG_SetControlContextMenu == .T.
        FOR k = 1 TO HMG_LEN (_HMG_SYSDATA [ 1 ])
            IF (_HMG_SYSDATA [ 1 ] [k] == "MENU") .AND. (_HMG_SYSDATA [ 12 ] [k] == "CONTROL_MENU_ITEM") .AND. _TestControlHandle_ContextMenu (_HMG_SYSDATA [ 18 ] [k], _HMG_ControlHandle)
              _HMG_ControlContextMenu := _HMG_SYSDATA [ 7 ] [k]
              i := k
              EXIT
            ENDIF
        NEXT

        IF i > 0
            SetFocus (_HMG_ControlHandle)
            TrackPopupMenu ( _HMG_ControlContextMenu , _HMG_MouseCol , _HMG_MouseRow , hWnd )
        ENDIF
   ENDIF

		if _HMG_SYSDATA [ 338 ] == .t.

			_HMG_SYSDATA [ 191 ] := HIWORD(lParam)
			_HMG_SYSDATA [ 192 ] := LOWORD(lParam)

			setfocus(wParam)

			I := Ascan ( _HMG_SYSDATA [ 67  ] , hWnd )
			if i > 0
				if _HMG_SYSDATA [ 74  ] [i] != 0
					if _HMG_SYSDATA [ 91 ] [i] > 0
						_HMG_SYSDATA [ 191 ] := _HMG_SYSDATA [ 191 ] + GetScrollPos(hwnd,SB_VERT)
					endif
					if _HMG_SYSDATA [ 92 ] [i] > 0
						_HMG_SYSDATA [ 192 ] := _HMG_SYSDATA [ 192 ] + GetScrollPos(hwnd,SB_HORZ)
					endif
					TrackPopupMenu ( _HMG_SYSDATA [ 74  ] [i]  , LOWORD(lparam) , HIWORD(lparam) , hWnd )
				Endif
			EndIf

		EndIf


        ***********************************************************************
	case nMsg == WM_TIMER
        ***********************************************************************

		i := Ascan ( _HMG_SYSDATA [  5 ] , wParam )

		if i > 0
			_DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] , i )
		EndIf


        ***********************************************************************
	case nMsg == WM_SIZE
        ***********************************************************************

#if 0

// REMOVE3
/*
		i := aScan ( _HMG_SYSDATA [ 67  ] , hWnd )

		if i > 0

			If _HMG_SYSDATA [ 263 ] == .T.   // _HMG_MainActive

				If wParam == SIZE_MAXIMIZED

					_DoWindowEventProcedure ( _HMG_SYSDATA [ 103  ]  [i] , i , '' )

				ElseIf wParam == SIZE_MINIMIZED

					_DoWindowEventProcedure ( _HMG_SYSDATA [ 104  ]  [i] , i , '' )

				Else

					_DoWindowEventProcedure ( _HMG_SYSDATA [ 76  ]  [i] , i , '' )

				EndIf

			EndIf

			If _HMG_SYSDATA [ 87 ] [i] > 0
				SizeRebar ( _HMG_SYSDATA [ 87 ] [i] )
				RedrawWindow  ( _HMG_SYSDATA [ 87 ] [i] )
			EndIf

		EndIf

      ControlCount := HMG_LEN (_HMG_SYSDATA [3])

      For i = 1 to ControlCount
         if _HMG_SYSDATA [4] [i] == hWnd   // ParentHandle
            if _HMG_SYSDATA [1] [i] == "STATUSBAR"
               MoveWindow( _HMG_SYSDATA [3] [i] , 0 , 0 , 0 , 0 , .T. )
               SetStatusBarSize ( hWnd , _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [ 20 ] [i] )
               EXIT
            endif
        EndIf
      Next

      For i = 1 to ControlCount
         if _HMG_SYSDATA [4] [i] == hWnd   // ParentHandle
            if _HMG_SYSDATA [1] [i] == "TOOLBAR"
               SendMessage( _HMG_SYSDATA [3] [i] , TB_AUTOSIZE , 0 , 0 )
            EndIf
         EndIf
      Next
*/
#else

      ControlCount := HMG_LEN ( _HMG_SYSDATA [ 3 ] )

      For i = 1 to ControlCount
         If _HMG_SYSDATA [ 4 ] [i] == hWnd   // ParentHandle

            If _HMG_SYSDATA [ 1 ] [i] == "TOOLBAR"
               SendMessage( _HMG_SYSDATA [ 3 ] [i] , TB_AUTOSIZE , 0 , 0 )

            ElseIf _HMG_SYSDATA [ 1 ] [i] == "STATUSBAR"
               MoveWindow( _HMG_SYSDATA [ 3 ] [i] , 0 , 0 , 0 , 0 , .T. )
               SetStatusBarSize ( hWnd , _HMG_SYSDATA [ 3 ] [i] , _HMG_SYSDATA [ 20 ] [i] )
            EndIf

         EndIf
      Next

      i := aScan ( _HMG_SYSDATA [ 67 ] , hWnd )

      if i > 0   // ADD3

         If _HMG_SYSDATA [ 87 ] [i] > 0
            SizeRebar ( _HMG_SYSDATA [ 87 ] [i] )   // resize SplitBox
            RedrawWindow  ( _HMG_SYSDATA [ 87 ] [i] )
         EndIf

         If _HMG_SYSDATA [ 263 ] == .T.  .OR. ;   // _HMG_MainActive
            _HMG_SYSDATA [ 68 ] [ i ] == .T.      // _HMG_aFormActive

            If wParam == SIZE_MAXIMIZED
               _DoWindowEventProcedure ( _HMG_SYSDATA [ 103 ]  [i] , i , '' )   // On Maximize

            ElseIf wParam == SIZE_MINIMIZED
               _DoWindowEventProcedure ( _HMG_SYSDATA [ 104 ]  [i] , i , '' )   // On Minimize

            Else
               _DoWindowEventProcedure ( _HMG_SYSDATA [  76 ]  [i] , i , '' )   // On Size

            EndIf

         EndIf

      EndIf

#endif

        ***********************************************************************
	case nMsg == WM_COMMAND
        ***********************************************************************

		ControlCount := HMG_LEN (_HMG_SYSDATA [3])

		*...............................................
		* Search Control From Received Id LoWord(wParam)
		*...............................................

		i := Ascan ( _HMG_SYSDATA [  5 ] , LoWord(wParam) )

		If i > 0

			* Process Menus .......................................

			IF HiWord(wParam) == 0 .And. _HMG_SYSDATA [1] [i] = "MENU"
				_DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] , i )
				Return 0
			EndIf

			* Process ToolBar Buttons ............................

			If _HMG_SYSDATA [1] [i] = "TOOLBUTTON"
				_DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] , i )
				Return 0
			EndIf

		EndIf

		*..............................................
		* Search Control From Received Handle (lparam)
		*..............................................

		i := Ascan ( _HMG_SYSDATA [3] , lParam )

		* If Handle Not Found, Look For Spinner

		if i == 0
			For x := 1 To ControlCount
			        If ValType (_HMG_SYSDATA [3][x]) == 'A'
					If _HMG_SYSDATA [3] [x] [1] == lParam .and. _HMG_SYSDATA [1][x] == 'SPINNER'
						i := x
						Exit
					EndIf
				EndIf
			Next x
		EndIf

		*................................
		* Process Command (Handle based)
		*................................

		if ( i > 0 )

			* Button Click ........................................

			If HIWORD(wParam) == BN_CLICKED .And. _HMG_SYSDATA [1] [i] = "BUTTON"

				SetFocus(_HMG_SYSDATA [3] [i])
				SendMessage ( _HMG_SYSDATA [3] [i] , 244 , LOWORD ( 1 ) , 1 )

				_DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] , i )

				Return 0
			EndIf

			* CheckBox Click ......................................

			If HIWORD(wParam) == BN_CLICKED .And. _HMG_SYSDATA [1] [i] = "CHECKBOX"
				_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
				Return 0
			EndIf

			* Label / HyperLink / Image Click .....................

			if HiWord ( wParam ) == STN_CLICKED .And. ( _HMG_SYSDATA [1] [i] = "LABEL"  .Or. _HMG_SYSDATA [1] [i] = "IMAGE" )
				_DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] , i )
				Return 0
			endif

         * Process Richedit Area Change ........................ ( Dr. Claudio Soto, January 2014 )

         IF HiWord ( wParam ) == EN_VSCROLL .AND. ( _HMG_SYSDATA [1] [i] == "RICHEDIT" )
            _DoControlEventProcedure ( _HMG_SYSDATA [ 32 ] [i] , i )
            Return 0
         ENDIF


			* TextBox Change ......................................

			if HiWord ( wParam ) == EN_CHANGE

				If _HMG_SYSDATA [ 253 ] == .T.
					_HMG_SYSDATA [ 253 ] := .F.
				Else

					if HMG_LEN (_HMG_SYSDATA [  9 ] [i] ) > 0

						If _HMG_SYSDATA [1] [i] == 'MASKEDTEXT'


							If _HMG_SYSDATA [ 22 ] [i] == .T.
								ProcessCharmask ( i , .t. )
							EndIf

							_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

						ElseIf _HMG_SYSDATA [1] [i] == 'CHARMASKTEXT'

							ProcessCharMask (i)

							_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

						EndIf

					else

						If _HMG_SYSDATA [1][i] == 'NUMTEXT'
							ProcessNumText ( i )
						EndIf

						_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

					endif

				EndIf

				Return 0

			EndIf

			* TextBox LostFocus ...................................

			If  HiWord(wParam) == EN_KILLFOCUS

				_HMG_SYSDATA [243] := .T.

				If _HMG_SYSDATA [1] [i] == 'MASKEDTEXT'

					_HMG_SYSDATA [ 22 ] [i] := .F.

					IF "E" $ _HMG_SYSDATA [  7 ] [i]

						Ts := GetWindowText ( _HMG_SYSDATA [3][i] )

						If "." $ _HMG_SYSDATA [  7 ] [i]
							Do Case
								Case HB_UAT ( '.' , Ts ) >  HB_UAT ( ',' , Ts )
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3][i] )  , i )  , _HMG_SYSDATA [  7 ][i] ) )
								Case HB_UAT ( ',' , Ts ) > HB_UAT ( '.' , Ts )
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromTextSp ( GetWindowText ( _HMG_SYSDATA [3][i] )  , i )  , _HMG_SYSDATA [  7 ][i] ) )
							EndCase
						Else
							Do Case
								Case HB_UAT ( '.' , Ts ) !=  0
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromTextSp ( GetWindowText ( _HMG_SYSDATA [3][i] )  , i )  , _HMG_SYSDATA [  7 ][i] ) )
								Case HB_UAT ( ',' , Ts )  != 0
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3][i] )  , i )  , _HMG_SYSDATA [  7 ][i] ) )
								OtherWise
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3][i] )  , i )  , _HMG_SYSDATA [  7 ][i] ) )
							EndCase
						EndIf
					ELSE
						SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i ) , _HMG_SYSDATA [  7 ][i] ) )
					ENDIF

				Endif

				If _HMG_SYSDATA [1] [i] == 'CHARMASKTEXT'
					if valtype ( _HMG_SYSDATA [ 17 ] [i] ) == 'L'
						if _HMG_SYSDATA [ 17 ] [i] == .T.
							_HMG_SYSDATA [ 253 ] := .T.
							SetWindowText ( _HMG_SYSDATA [3][i] , dtoc ( ctod ( GetWindowText ( _HMG_SYSDATA [3] [i] ) ) ) )
						EndIf
					EndIf
				EndIf

				If _HMG_SYSDATA [ 252 ] != .T.
					_DoControlEventProcedure ( _HMG_SYSDATA [ 10 ] [i], i )
 				EndIf

				_HMG_SYSDATA [243] := .F.

				Return 0

			EndIf

			* TextBox GotFocus ....................................

			If  HIWORD(wParam) == EN_SETFOCUS

				_HMG_SYSDATA [242] := .T.

				VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )

				If _HMG_SYSDATA [1] [i] == 'MASKEDTEXT'


					IF "E" $ _HMG_SYSDATA [  7 ] [i]

						Ts := GetWindowText ( _HMG_SYSDATA [3][i] )

						If "." $ _HMG_SYSDATA [  7 ] [i]
							Do Case
								Case HB_UAT ( '.' , Ts ) >  HB_UAT ( ',' , Ts )
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i ) , _HMG_SYSDATA [  9 ] [i] ) )
								Case HB_UAT ( ',' , Ts ) > HB_UAT ( '.' , Ts )
									TmpStr := Transform ( GetNumFromTextSP ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i )  , _HMG_SYSDATA [  9 ] [i] )
									If Val ( TmpStr ) == 0
										TmpStr := HB_UTF8STRTRAN ( TmpStr , '0.' , ' .' )
									EndIf
									SetWindowText ( _HMG_SYSDATA [3] [i] , TmpStr )
							EndCase
						Else
							Do Case
								Case HB_UAT ( '.' , Ts ) !=  0
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromTextSP ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i ) , _HMG_SYSDATA [  9 ] [i] ) )
								Case HB_UAT ( ',' , Ts )  != 0
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i ) , _HMG_SYSDATA [  9 ] [i] ) )
								OtherWise
									SetWindowText ( _HMG_SYSDATA [3] [i] , Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i ) , _HMG_SYSDATA [  9 ] [i] ) )
							EndCase
						EndIf
					ELSE
						TmpStr := Transform ( GetNumFromText ( GetWindowText ( _HMG_SYSDATA [3] [i] ) , i ) , _HMG_SYSDATA [  9 ] [i] )

						If Val ( TmpStr ) == 0
							TmpStr := HB_UTF8STRTRAN ( TmpStr , '0.' , ' .' )
						EndIf

						SetWindowText ( _HMG_SYSDATA [3] [i] , TmpStr )
					ENDIF

				      	SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , 0 , -1 )

					_HMG_SYSDATA [ 22 ] [i] := .T.

				EndIf

				If _HMG_SYSDATA [1] [i] == 'CHARMASKTEXT'

					For x := 1 To HMG_LEN (_HMG_SYSDATA [  9 ] [i])
                                                If HMG_ISDIGIT(HB_USUBSTR ( _HMG_SYSDATA [  9 ] [i] , x , 1 )) .Or. HMG_ISALPHA(HB_USUBSTR ( _HMG_SYSDATA [  9 ] [i] , x , 1 )) .Or. HB_USUBSTR ( _HMG_SYSDATA [  9 ] [i] , x , 1 ) == '!'
							MaskStart := x
							Exit
						EndIf
					Next x

					If MaskStart == 1
					      	SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , 0 , -1 )
					Else
					      	SendMessage( _HMG_SYSDATA [3] [i] , EM_SETSEL , MaskStart - 1 , -1 )
					EndIf

				EndIf

				_DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )

				_HMG_SYSDATA [242] := .F.

				Return 0

			EndIf


			* ListBox OnChange ....................................

			If  HIWORD(wParam) == LBN_SELCHANGE .And. (_HMG_SYSDATA [1][i] == 'LIST' .Or. _HMG_SYSDATA [1][i] == 'MULTILIST' )
				_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
				Return 0
			EndIf

			* ListBox Double Click ................................

			If  HIWORD(wParam) == LBN_DBLCLK
				_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
				Return 0
			EndIf

			* ComboBox Change .....................................

			If HiWord (wParam) == CBN_SELCHANGE .And. _HMG_SYSDATA [1][i] == 'COMBO'
				_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
				Return 0
			endif

			* ComboBox OnCancel .....................................

			If HiWord (wParam) == CBN_SELENDCANCEL .And. _HMG_SYSDATA [1][i] == 'COMBO'
				_DoControlEventProcedure ( _HMG_SYSDATA [ 32 ] [i] , i )
				Return 0
			endif

			* ComboBox OnDropDown .....................................

			If HiWord (wParam) == CBN_DROPDOWN .And. _HMG_SYSDATA [1][i] == 'COMBO'
				_DoControlEventProcedure ( _HMG_SYSDATA [ 39 ] [i] , i )
				Return 0
			endif

			* ComboBox OnCloseUp .....................................

			If HiWord (wParam) == CBN_CLOSEUP .And. _HMG_SYSDATA [1][i] == 'COMBO'
				_DoControlEventProcedure ( _HMG_SYSDATA [ 37 ] [i] , i )
				Return 0
			endif

			* ComboBox LostFocus ..................................

			If HiWord (wParam) == CBN_KILLFOCUS .And. _HMG_SYSDATA [1] [i] == 'COMBO'
				_DoControlEventProcedure ( _HMG_SYSDATA [10] [i] , i )
				Return 0
			EndIf

			* ComboBox GotFocus ...................................

			If HiWord (wParam) == CBN_SETFOCUS  .And. _HMG_SYSDATA [1] [i] == 'COMBO'
				VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )
				_DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )
				Return 0
			EndIf

         * Process Combo Display Area Change ...................

         IF HiWord (wParam) == CBN_EDITCHANGE .And. _HMG_SYSDATA [1] [i] == 'COMBO'
            _DoControlEventProcedure ( _HMG_SYSDATA [ 6 ] [i] , i )
            RETURN 0
         ENDIF

			* Button LostFocus ....................................

			If HIWORD(wParam) == BN_KILLFOCUS .And. _HMG_SYSDATA [1][i] <> 'COMBO'
				_DoControlEventProcedure ( _HMG_SYSDATA [10] [i] , i )
				Return 0
			EndIf

			* Button GotFocus .....................................

			If HIWORD(wParam) == BN_SETFOCUS
				VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )
				_DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )
				Return 0
			EndIf


			* ListBox LostFocus ...................................

			If HIWORD(wParam) == LBN_KILLFOCUS .And. ( _HMG_SYSDATA [1] [i] = "LIST" .or. _HMG_SYSDATA [1] [i] = "MULTILIST")
				_DoControlEventProcedure ( _HMG_SYSDATA [10] [i] , i )
				Return 0
			EndIf

			* ListBox GotFocus ....................................

			If HIWORD(wParam) == LBN_SETFOCUS .And. ( _HMG_SYSDATA [1] [i] = "LIST" .or. _HMG_SYSDATA [1] [i] = "MULTILIST")
				VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )
				_DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )
				Return 0
			EndIf

			* Process Combo Display Area Change ...................

			If HIWORD(wParam) == CBN_EDITCHANGE .And. _HMG_SYSDATA [1] [i] == 'COMBO'
				_DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] , i )
				Return 0
			EndIf

		Else

			* Process RadioGrop ...................................

			If HIWORD(wParam) == BN_CLICKED
				For i := 1 to ControlCount
					if ValType (_HMG_SYSDATA [3] [i] ) == "A" .And._HMG_SYSDATA [4] [i] == hWnd
						For x := 1 To HMG_LEN ( _HMG_SYSDATA [3] [i] )
							If _HMG_SYSDATA [3] [i] [x] == lParam
								_DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
								If _HMG_SYSDATA [ 25 ] [i] == .F. // No TabStop
									if IsTabStop(_HMG_SYSDATA [3] [i] [x])
										SetTabStop(_HMG_SYSDATA [3] [i] [x],.f.)
									endif
								EndIf
								Return 0
							EndIf
						Next x
					Endif
				Next i

			ElseIf HIWORD(wParam) == BN_SETFOCUS

				For i := 1 to ControlCount
					if ValType (_HMG_SYSDATA [3] [i] ) == "A" .And._HMG_SYSDATA [4] [i] == hWnd
						For x := 1 To HMG_LEN ( _HMG_SYSDATA [3] [i] )
							If _HMG_SYSDATA [3] [i] [x] == lParam
								VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] [x] , _HMG_SYSDATA [4] [i] )
								If _HMG_SYSDATA [ 25 ] [i] == .F. // No TabStop
									if IsTabStop(_HMG_SYSDATA [3] [i] [x])
										SetTabStop(_HMG_SYSDATA [3] [i] [x],.f.)
									endif
								EndIf
								Return 0
							EndIf
						Next x
					Endif
				Next i

			EndIf

		EndIf

      *...................
      * Process Enter Key
      *...................

      i := Ascan ( _HMG_SYSDATA [3] , GetFocus() )

      if  i > 0


         * CheckBox Enter ( Pablo Cesar, December 2014 ) .......................................

         if _HMG_SYSDATA [1] [i] = "CHECKBOX" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
             _DoControlEventProcedure ( _HMG_SYSDATA [ 6 ] [i] , i )
          If _HMG_SYSDATA [ 255 ] == .T.   // If Set ExtendedNavigation
                _SetNextFocus()
             EndIf
             Return 0
         EndIf


         * DatePicker Enter ......................................

         if _HMG_SYSDATA [1] [i] = "DATEPICK" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
            _DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] , i )
            If _HMG_SYSDATA [ 255 ] == .T.   // If Set ExtendedNavigation
               _SetNextFocus()
            EndIf
            Return 0
         EndIf


         * TimePicker Enter ( Dr. Claudio Soto, April 2013 ) ......................................

         if _HMG_SYSDATA [1] [i] = "TIMEPICK" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
            _DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] , i )
            If _HMG_SYSDATA [ 255 ] == .T.   // If Set ExtendedNavigation
               _SetNextFocus()
            EndIf
            Return 0
         EndIf

			* Browse Enter ..........................................

			#ifdef COMPILEBROWSE

			if _HMG_SYSDATA [1] [i] = "BROWSE" .and. lparam == 0 .and. wparam == 1

				if _HMG_SYSDATA [ 39 ] [i] [6] == .T.
					ProcessInPlaceKbdEdit(i)
				Else
					_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
				Endif

				Return 0

			EndIf

			#endif

			* Grid Enter ..........................................

			if ( _HMG_SYSDATA [1] [i] = "GRID" .or. _HMG_SYSDATA [1] [i] = "MULTIGRID") .and. lparam == 0 .and. wparam == 1
				IF _HMG_SYSDATA [ 40 ] [ I ]  [ 1 ] == .T.

					IF _HMG_SYSDATA [32] [i] == .T.   // cellnavigation

						_HMG_GRIDINPLACEKBDEDIT_2(I)

					ELSE

						_HMG_GRIDINPLACEKBDEDIT(I)

					ENDIF

				Else
					_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
				EndIf
				Return 0
			EndIf

			* ComboBox Enter ......................................

         if _HMG_SYSDATA [1] [i] = "COMBO" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
				_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
				If _HMG_SYSDATA [ 255 ] == .T.   // If Set ExtendedNavigation
					_SetNextFocus()
				EndIf
				Return 0
			EndIf

			* ListBox Enter .......................................

			if ( _HMG_SYSDATA [1] [i] = "LIST" .or. _HMG_SYSDATA [1] [i] = "MULTILIST") .And. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
				_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
				Return 0
			EndIf

			* TextBox Enter .......................................

			if ( _HMG_SYSDATA [1] [i] == "TEXT" .Or. _HMG_SYSDATA [1] [i] == "MASKEDTEXT" .Or. _HMG_SYSDATA [1] [i] == "CHARMASKTEXT" .Or. _HMG_SYSDATA [1] [i] == "NUMTEXT" ) .And. HiWord(wParam) == 0  .And. LoWord(wParam) == 1
				_HMG_SYSDATA [ 251 ] := .F.
				_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
				If _HMG_SYSDATA [ 251 ] == .F.
					If _HMG_SYSDATA [ 255 ] == .T.   // If Set ExtendedNavigation
						_SetNextFocus()
					EndIf
				Else
					_HMG_SYSDATA [ 251 ] := .F.
				EndIf
				Return 0
			EndIf

			* Tree Enter ..........................................

			if _HMG_SYSDATA [1] [i] == "TREE" .And. HiWord(wParam) == 0  .And. LoWord(wParam) == 1
				_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
				Return 0
			EndIf

		Else

			* ComboBox (DisplayEdit) ..............................

			For i := 1 To ControlCount

	                       if _HMG_SYSDATA [1] [i] = "COMBO" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
					if _HMG_SYSDATA [ 31 ] [i] == GetFocus()
						_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
						If _HMG_SYSDATA [ 255 ] == .T.   // If Set ExtendedNavigation
							_SetNextFocus()
						EndIf
						Exit
					EndIf
				EndIf
			Next i

			* ComboBox (Image) ..............................

			i := Ascan ( _HMG_SYSDATA [32] , GetFocus() )

			If  i > 0
            If _HMG_SYSDATA [1] [i] = "COMBO" .and. ( HiWord(wParam) == 0  .And. LoWord(wParam) == 1 )
					_DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
					If _HMG_SYSDATA [ 255 ] == .T.   // If Set ExtendedNavigation
						_SetNextFocus()
					EndIf
				EndIf
			EndIf

			Return 0

		EndIf


        ***********************************************************************
   case nMsg == WM_MENUSELECT
        ***********************************************************************

        ToolTipMenuDisplayEvent (wParam, lParam)   // ToolTip Menu Custom Draw, by Dr. Claudio Soto (December 2014)
        Return 0


        ***********************************************************************
   case nMsg == WM_NOTIFY
        ***********************************************************************

    * Process ToolTip Custom Draw, by Dr. Claudio Soto (December 2014)

    xRetVal := ToolTipCustomDrawEvent (lParam)
    IF ValType (xRetVal) == "N"
      SetNewBehaviorWndProc (.T.)
      Return xRetVal
    ENDIF

    * Process ToolBar ToolTip .....................................

    If GetNotifyCode ( lParam ) == TTN_NEEDTEXT
      i := aScan ( _HMG_SYSDATA [  5 ] , GetToolButtonId(lParam) )
      if i > 0
        if ValType ( _HMG_SYSDATA [ 30 ] [i] ) == 'C'
          ShowToolButtonTip ( lParam , _HMG_SYSDATA [ 30 ] [i] )
        endif
      endif
    EndIf

    ********************************************************************
    * GRID HEAD Custom Draw   // by Dr. Claudio Soto, September 2014
    ********************************************************************

    IF GetNotifyCode (lParam) == NM_CUSTOMDRAW
      i := Ascan ( _HMG_SYSDATA [5] , GetHwndFrom (lParam) )
      if i > 0
        if (_HMG_SYSDATA [1] [i] == "GRID" .OR. _HMG_SYSDATA [1] [i] == "MULTIGRID")
          SetNewBehaviorWndProc (.T.)   // ADD2, December 2014
          r := HEADER_CUSTOMDRAW_GetAction ( lParam )
          if r <> -1
            Return r   // return CDRF_NOTIFYITEMDRAW or CDRF_DODEFAULT
          endif
          Return _GridEx_DoHeaderCustomDraw ( i , lParam , Header_CustomDraw_GetItem (lParam) + 1 )   // return CDRF_NEWFONT
        endif
      endif
    ENDIF

    * MonthCalendar Bold Days Change ......................

    If GetNotifyCode ( lParam ) = MCN_GETDAYSTATE
      i := Ascan ( _HMG_SYSDATA [3] , GetHwndFrom (lParam) )
      if i > 0
        SetMonthCalendarBoldDays ( i, lParam )
      endif
    EndIf

    i := Ascan ( _HMG_SYSDATA [3] , GetHwndFrom (lParam) )

    if i > 0

      * Process StatusBar Single Click ...................

      if _HMG_SYSDATA [1] [i] = "STATUSBAR"

        * StatusBar Single Click

        If GetNotifyCode ( lParam ) == NM_CLICK

          x := GetStatusBarItemPos( lParam) + 1

          if x > 0
            if valtype ( _HMG_SYSDATA ) = 'A'
              if HMG_LEN ( _HMG_SYSDATA ) >= 6
                if valtype ( _HMG_SYSDATA [  6 ] ) = 'A'
                  if HMG_LEN ( _HMG_SYSDATA [  6 ] ) >= i
                    if valtype ( _HMG_SYSDATA [  6 ] [i] ) = 'A'
                      if HMG_LEN ( _HMG_SYSDATA [  6 ] [i] ) >= x
                        if valtype ( _HMG_SYSDATA [  6 ] [i] [x] ) = 'B'
                          if _DoControlEventProcedure ( _HMG_SYSDATA [  6 ] [i] [x] , i  )
                            Return 0
                          EndIf
                        endif
                      endif
                    endif
                  endif
                endif
              endif
            endif
          endif

        EndIf

      EndIf

      * Process Browse .....................................

      #ifdef COMPILEBROWSE

      if (_HMG_SYSDATA [1] [i] = "BROWSE")

        If  GetNotifyCode ( lParam ) == NM_RCLICK

          If LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) > 0
            DeltaSelect := LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) - ascan ( _HMG_SYSDATA [ 32 ] [i] , _HMG_SYSDATA [  8 ] [i] )
            _HMG_SYSDATA [  8 ] [i] :=  _HMG_SYSDATA [ 32 ] [i] [ LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) ]
            _BrowseVscrollFastUpdate ( i , DeltaSelect )
            _BrowseOnChange (i)
          EndIf

          Return 0

        EndIf

        * Browse Refresh On Column Size ..............

        If  GetNotifyCode ( lParam ) == -12

          hws := 0
          hwm := .F.
          For x := 1 To HMG_LEN ( _HMG_SYSDATA [  6 ] [i] )
            hws := hws + ListView_GetColumnWidth ( _HMG_SYSDATA [3] [i] , x - 1 )
            If _HMG_SYSDATA [  6 ] [i] [x] != ListView_GetColumnWidth ( _HMG_SYSDATA [3] [i] , x - 1 )
              hwm := .T.
              _HMG_SYSDATA [  6 ] [i] [x] := ListView_GetColumnWidth ( _HMG_SYSDATA [3] [i] , x - 1 )
              _BrowseRefresh('','',i)
            EndIf
          Next x

          * Browse ReDraw Vertical ScrollBar If Needed ...

          If _HMG_SYSDATA [  5 ] [i] != 0 .and. hwm == .T.
            if hws > _HMG_SYSDATA [ 20 ][i] - GETVSCROLLBARWIDTH() - 4
              MoveWindow ( _HMG_SYSDATA [  5 ] [i] , _HMG_SYSDATA [ 19 ][i]+_HMG_SYSDATA [ 20 ][i] - GETVSCROLLBARWIDTH() , _HMG_SYSDATA [ 18 ][i] , GETVSCROLLBARWIDTH() , _HMG_SYSDATA [ 21 ][i] - GETHSCROLLBARHEIGHT() , .t. )
              MoveWindow ( _HMG_SYSDATA [ 39 ] [i] [1], _HMG_SYSDATA [ 19 ][i]+_HMG_SYSDATA [ 20 ][i] - GETVSCROLLBARWIDTH() , _HMG_SYSDATA [ 18 ][i] + _HMG_SYSDATA [ 21 ][i] - GETHSCROLLBARHEIGHT() , GETVSCROLLBARWIDTH() , GETHSCROLLBARHEIGHT() , .t. )
            Else
              MoveWindow ( _HMG_SYSDATA [  5 ] [i] , _HMG_SYSDATA [ 19 ][i]+_HMG_SYSDATA [ 20 ][i] - GETVSCROLLBARWIDTH() , _HMG_SYSDATA [ 18 ][i] , GETVSCROLLBARWIDTH() , _HMG_SYSDATA [ 21 ][i] , .t. )
              MoveWindow ( _HMG_SYSDATA [ 39 ] [i] [1], _HMG_SYSDATA [ 19 ][i]+_HMG_SYSDATA [ 20 ][i] - GETVSCROLLBARWIDTH() , _HMG_SYSDATA [ 18 ][i] + _HMG_SYSDATA [ 21 ][i] - GETHSCROLLBARHEIGHT() , 0 , 0 , .t. )
            EndIf
          EndIf

        EndIf

        If GetNotifyCode ( lParam ) = NM_CUSTOMDRAW

          // r := GetDs ( lParam )
          r := LISTVIEW_CUSTOMDRAW_GetAction ( lParam )
          if r <> -1
            Return r
          else
            a := LISTVIEW_CUSTOMDRAW_GetRowCol (lParam)

            MaxBrowseRows := HMG_LEN ( _HMG_SYSDATA [ 32 ] [i] )
            MaxBrowseCols := HMG_LEN ( _HMG_SYSDATA [ 31 ] [i] )

            if a[1] >= 1 .and. a[1] <= MaxBrowseRows .and. a[2] >= 1 .and. a[2] <= MaxBrowseCols
              aTemp := _HMG_SYSDATA [40] [I] [6]
              aTemp2 := _HMG_SYSDATA [40] [I] [7]

              if valtype ( aTemp ) = 'A' .and. valtype ( aTemp2 ) <> 'A'
                if HMG_LEN ( aTemp ) >= a[1]
                  if aTemp [a[1]] [a[2]] <> -1
                    Return SetBCFC ( lParam , aTemp [a[1]] [a[2]] , RGB(0,0,0) )
                  else
                    Return SetBCFC_Default(LpARAM)
                  endif
                else
                  Return SetBCFC_Default(LpARAM)
                endif
              elseif valtype ( aTemp ) <> 'A' .and. valtype ( aTemp2 ) = 'A'
                if HMG_LEN ( aTemp2 ) >= a[1]
                  if aTemp2 [a[1]] [a[2]] <> -1
                    Return SetBCFC ( lParam , RGB(255,255,255) , aTemp2 [a[1]] [a[2]] )
                  else
                    Return SetBCFC_Default(LpARAM)
                  endif
                else
                  Return SetBCFC_Default(LpARAM)
                endif
              elseif valtype ( aTemp ) = 'A' .and. valtype ( aTemp2 ) = 'A'
                if HMG_LEN ( aTemp ) >= a[1] .and. HMG_LEN ( aTemp2 ) >= a[1]
                  if aTemp [a[1]] [a[2]] <> -1
                    Return SetBCFC ( lParam , aTemp [a[1]] [a[2]] , aTemp2 [a[1]] [a[2]] )
                  else
                    Return SetBCFC_Default(LpARAM)
                  endif
                else
                  Return SetBCFC_Default(LpARAM)
                endif
              endif

            else
              Return SetBCFC_Default(LpARAM)
            endif

          endif

        EndIf

        * Browse Click ................................

        If  GetNotifyCode ( lParam ) == NM_CLICK  .or. ;
          GetNotifyCode ( lParam ) == LVN_BEGINDRAG

          If LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) > 0
            DeltaSelect := LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) - ascan ( _HMG_SYSDATA [ 32 ] [i] , _HMG_SYSDATA [  8 ] [i] )
            _HMG_SYSDATA [  8 ] [i] :=  _HMG_SYSDATA [ 32 ] [i] [ LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [3] [i] ) ]
            _BrowseVscrollFastUpdate ( i , DeltaSelect )
            _BrowseOnChange (i)
          EndIf

          Return 0

        EndIf

        * Browse Key Handling .........................

        If GetNotifyCode ( lParam ) = LVN_KEYDOWN

          Do Case

          Case GetGridvKey(lParam) == 65 // A

            if  GetAltState() == -127 ;
              .or.;
              GetAltState() == -128 // ALT

              if _HMG_SYSDATA [ 39 ] [i] [2] == .T.
                _BrowseEdit ( _HMG_SYSDATA [3][i] , _HMG_SYSDATA [ 39 ] [i] [4] , _HMG_SYSDATA [ 39 ] [i] [5] , _HMG_SYSDATA [ 39 ] [i] [3] , _HMG_SYSDATA [  9 ] [i] , .t. , _HMG_SYSDATA [ 15 ] [i] , _HMG_SYSDATA [ 39 ] [i] [7] )
              EndIf

            EndIf

          Case GetGridvKey(lParam) == 46 // DEL

            If _HMG_SYSDATA [ 25 ] [i] == .t.
              If MsgYesNo (_HMG_SYSDATA [ 137 ] [1] , _HMG_SYSDATA [ 137 ] [2] ) == .t.
                _BrowseDelete('','',i)
              EndIf
            EndIf

          Case GetGridvKey(lParam) == 36 // HOME

            _BrowseHome('','',i)
            Return 1

          Case GetGridvKey(lParam) == 35 // END

            _BrowseEnd('','',i)
            Return 1

          Case GetGridvKey(lParam) == 33 // PGUP

            _BrowsePrior('','',i)
            Return 1

          Case GetGridvKey(lParam) == 34 // PGDN

            _BrowseNext('','',i)
            Return 1

          Case GetGridvKey(lParam) == 38 // UP

            _BrowseUp('','',i)
            Return 1

          Case GetGridvKey(lParam) == 40 // DOWN

            _BrowseDown('','',i)
            Return 1

          EndCase

          Return 0

        EndIf

        * Browse Double Click .........................

        If GetNotifyCode ( lParam ) == NM_DBLCLK

          _PushEventInfo()
          _HMG_SYSDATA [ 194 ] := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4][i] )
          _HMG_SYSDATA [ 231 ] := 'C'
          _HMG_SYSDATA [ 203 ] := i
          _HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]
          _HMG_SYSDATA [ 317 ] :=  _HMG_SYSDATA [2] [_HMG_SYSDATA [ 203 ]]

          r := ListView_HitTest ( _HMG_SYSDATA [3] [i] , GetCursorRow() - GetWindowRow ( _HMG_SYSDATA [3] [i] )  , GetCursorCol() - GetWindowCol ( _HMG_SYSDATA [3] [i] ) )
          If r [2] == 1
            ListView_Scroll( _HMG_SYSDATA [3] [i] , -10000  , 0 )
            r := ListView_HitTest ( _HMG_SYSDATA [3] [i] , GetCursorRow() - GetWindowRow ( _HMG_SYSDATA [3] [i] )  , GetCursorCol() - GetWindowCol ( _HMG_SYSDATA [3] [i] ) )
          Else
            r := LISTVIEW_GETSUBITEMRECT ( _HMG_SYSDATA [3] [i]  , r[1] - 1 , r[2] - 1 )

                                                      * CellCol       CellWidth
            xs := ( ( _HMG_SYSDATA [ 19 ] [i] + r [2] ) +( r[3] ))  -  ( _HMG_SYSDATA [ 19 ] [i] + _HMG_SYSDATA [ 20 ] [i] )
            xd := 20
            If xs > -xd
              ListView_Scroll( _HMG_SYSDATA [3] [i] , xs + xd , 0 )
            Else
              If r [2] < 0
                ListView_Scroll( _HMG_SYSDATA [3] [i] , r[2]  , 0 )
              EndIf
            EndIf

            r := ListView_HitTest ( _HMG_SYSDATA [3] [i] , GetCursorRow() - GetWindowRow ( _HMG_SYSDATA [3] [i] )  , GetCursorCol() - GetWindowCol ( _HMG_SYSDATA [3] [i] ) )

          EndIf

          _HMG_SYSDATA [ 195 ] := r[1]
          _HMG_SYSDATA [ 196 ] := r[2]
          If r [2] == 1
            r := LISTVIEW_GETITEMRECT ( _HMG_SYSDATA [3] [i]  , r[1] - 1 )
          Else
            r := LISTVIEW_GETSUBITEMRECT ( _HMG_SYSDATA [3] [i]  , r[1] - 1 , r[2] - 1 )
          EndIf
          _HMG_SYSDATA [ 197 ] := _HMG_SYSDATA [ 18 ] [i] + r [1]
          _HMG_SYSDATA [ 198 ] := _HMG_SYSDATA [ 19 ] [i] + r [2]
          _HMG_SYSDATA [ 199 ] := r[3]
          _HMG_SYSDATA [ 200 ] := r[4]

          if _HMG_SYSDATA [ 39 ] [i] [6] == .T.
            _BrowseEdit ( _HMG_SYSDATA [3][i] , _HMG_SYSDATA [ 39 ] [i] [4] , _HMG_SYSDATA [ 39 ] [i] [5] , _HMG_SYSDATA [ 39 ] [i] [3] , _HMG_SYSDATA [  9 ] [i] , .f. , _HMG_SYSDATA [ 15 ] [i] , _HMG_SYSDATA [ 39 ] [i] [7] )
          Else
            if valtype(_HMG_SYSDATA [ 16 ] [i]  )=='B'
              Eval( _HMG_SYSDATA [ 16 ] [i]  )
            EndIf

          Endif

          _PopEventInfo()
          _HMG_SYSDATA [ 195 ] := 0
          _HMG_SYSDATA [ 196 ] := 0
          _HMG_SYSDATA [ 197 ] := 0
          _HMG_SYSDATA [ 198 ] := 0
          _HMG_SYSDATA [ 199 ] := 0
          _HMG_SYSDATA [ 200 ] := 0

        EndIf

        * Browse LostFocus ............................

        If GetNotifyCode ( lParam ) = NM_KILLFOCUS

          // by Dr. Claudio Soto, December 2014
          IF IsGridCustomDrawNewBehavior() == .T.
            SetEventProcessHMGWindowsMessage (.T.)
          ENDIF

          _DoControlEventProcedure ( _HMG_SYSDATA [10] [i] , i )
          Return 0
        EndIf

        * Browse GotFocus ..............................

        If GetNotifyCode ( lParam ) = NM_SETFOCUS

          // by Dr. Claudio Soto, December 2014
          IF IsGridCustomDrawNewBehavior() == .T.
             SetEventProcessHMGWindowsMessage (.F.)
          ENDIF

          VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )
          _DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )
          Return 0
        EndIf

        * Browse Header Click .........................

        If GetNotifyCode ( lParam ) =  LVN_COLUMNCLICK
          if ValType ( _HMG_SYSDATA [ 17 ] [i] ) == 'A'
            lvc := GetGridColumn(lParam) + 1
            if HMG_LEN (_HMG_SYSDATA [ 17 ] [i]) >= lvc
              _DoControlEventProcedure ( _HMG_SYSDATA [ 17 ] [i] [lvc] , i )
            EndIf
          EndIf
          Return 0
        EndIf

      EndIf

      #endif

      * ToolBar DropDown Button Click .......................

      If GetNotifyCode ( lParam ) == TBN_DROPDOWN

        x  := Ascan ( _HMG_SYSDATA [  5 ] , GetToolButtonDDId( lParam) )

        if x > 0 .And. _HMG_SYSDATA [1] [x] = "TOOLBUTTON"
          aPos:= {0,0,0,0}
          GetWindowRect(_HMG_SYSDATA [3] [i],aPos)
          aSize := GetToolButtonSize ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [  8 ] [ x ] - 1 )
          TrackPopupMenu ( _HMG_SYSDATA [ 32 ] [x] , aPos[1] + aSize [1] , aPos[2] + aSize [2] + ( aPos[4] - aPos[2] - aSize [2] ) / 2 , hWnd )
        EndIf

      EndIf

      * MonthCalendar Selection Change ......................

      if _HMG_SYSDATA [1] [i] = "MONTHCAL"

        If GetNotifyCode ( lParam ) = MCN_SELECT

          _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
          Return 0

        EndIf

      EndIf

      * Grid Processing .....................................

      if (_HMG_SYSDATA [1] [i] = "GRID") .Or. (_HMG_SYSDATA [1] [i] = "MULTIGRID")

        IF _HMG_SYSDATA [32] [i] == .T.

            * Grid Key Handling .........................

          If GetNotifyCode ( lParam ) = LVN_KEYDOWN

              Do Case

              Case GetGridvKey (lParam) == 37 // LEFT

                IF _HMG_SYSDATA [ 15 ] [i]  > 1

                  _HMG_SYSDATA [ 15 ] [i]  --

**************************************************************************************************************************************

                  nDestinationColumn  := _HMG_SYSDATA [ 15 ] [i]
                  nFrozenColumnCount  := _HMG_SYSDATA [ 40 ] [ i ] [ 32 ]
                  anOriginalColumnWidths  := _HMG_SYSDATA [ 40 ] [ i ] [ 31 ]

                  If nFrozenColumnCount > 0

                    If nDestinationColumn >= nFrozenColumnCount + 1

                      * Set Destination Column Width To Original

                      LISTVIEW_SETCOLUMNWIDTH ( _HMG_SYSDATA [ 3 ] [i] , nDestinationColumn - 1 , anOriginalColumnWidths [ nDestinationColumn ] )

                    EndIf

                  EndIf

**************************************************************************************************************************************

                  _HMG_GRID_KBDSCROLL(I)

                  LISTVIEW_REDRAWITEMS ( _HMG_SYSDATA [ 3 ] [i] , _HMG_SYSDATA [ 39 ] [i] - 1 , _HMG_SYSDATA [ 39 ] [i] - 1 )

                  _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

                ENDIF

              Case GetGridvKey (lParam) == 39 // RIGHT

                IF _HMG_SYSDATA [ 15 ] [i]  < HMG_LEN ( _HMG_SYSDATA [ 33 ] [i] )

                  _HMG_SYSDATA [ 15 ] [i]  ++

                  nDestinationColumn  := _HMG_SYSDATA [ 15 ] [i]
                  nFrozenColumnCount  := _HMG_SYSDATA [ 40 ] [ i ] [ 32 ]

                  FOR J := nDestinationColumn TO HMG_LEN( _HMG_SYSDATA [ 33 ] [ i ] ) - 1

                    IF LISTVIEW_GETCOLUMNWIDTH ( _HMG_SYSDATA [ 3 ] [i] , J - 1 ) == 0
                      _HMG_SYSDATA [ 15 ] [i] ++
                    ENDIF

                  NEXT J

                  If nFrozenColumnCount > 0

                    If nDestinationColumn > nFrozenColumnCount + 1

                      * Set Current Column Width To 0

                      LISTVIEW_SETCOLUMNWIDTH ( _HMG_SYSDATA [ 3 ] [i] , nDestinationColumn - 2 , 0 )

                    EndIf

                  EndIf

**************************************************************************************************************************************
                  _HMG_GRID_KBDSCROLL(I)

                  LISTVIEW_REDRAWITEMS ( _HMG_SYSDATA [ 3 ] [i] , _HMG_SYSDATA [ 39 ] [i] - 1 , _HMG_SYSDATA [ 39 ] [i] - 1 )

                  _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

                ENDIF

              Case GetGridvKey (lParam) == 38 // UP

                IF _HMG_SYSDATA [ 15 ] [i]  == 0
                  _HMG_SYSDATA [ 15 ] [i]  := 1
                ENDIF

                IF _HMG_SYSDATA [ 39 ] [i] > 1

                  _HMG_SYSDATA [ 39 ] [i]--

                  _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

                ENDIF

              Case GetGridvKey (lParam) == 40 // DOWN

                IF _HMG_SYSDATA [ 15 ] [i]  == 0
                  _HMG_SYSDATA [ 15 ] [i]  := 1
                ENDIF

                IF _HMG_SYSDATA [ 39 ] [i] < ListView_GetItemCount( _HMG_SYSDATA [ 3 ] [i] )

                  _HMG_SYSDATA [ 39 ] [i]++

                  _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

                ENDIF

              Case GetGridvKey (lParam) == 33 // PGUP

                _GridInitValue := _HMG_SYSDATA [ 39 ] [i]

                IF _HMG_SYSDATA [ 39 ] [i] == SendMessage ( _HMG_SYSDATA [ 3 ] [i] , LVM_GETTOPINDEX , 0 , 0 ) + 1

                  _HMG_SYSDATA [ 39 ] [i] -= SendMessage ( _HMG_SYSDATA [ 3 ] [i] , LVM_GETCOUNTPERPAGE , 0 , 0 ) - 1

                ELSE

                  _HMG_SYSDATA [ 39 ] [i] := SendMessage ( _HMG_SYSDATA [ 3 ] [i] , LVM_GETTOPINDEX , 0 , 0 ) + 1

                ENDIF

                IF _HMG_SYSDATA [ 39 ] [i] < 1

                  _HMG_SYSDATA [ 39 ] [i]  := 1

                ENDIF

                IF _GridInitValue <> _HMG_SYSDATA [ 39 ] [i]

                  _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

                ENDIF

              Case GetGridvKey (lParam) == 34 // PGDOWN

                _GridInitValue := _HMG_SYSDATA [ 39 ] [i]

                IF _HMG_SYSDATA [ 39 ] [i] == SendMessage ( _HMG_SYSDATA [ 3 ] [i] , LVM_GETTOPINDEX , 0 , 0 ) + SendMessage ( _HMG_SYSDATA [ 3 ] [i] , LVM_GETCOUNTPERPAGE , 0 , 0 )

                  _HMG_SYSDATA [ 39 ] [i] += SendMessage ( _HMG_SYSDATA [ 3 ] [i] , LVM_GETCOUNTPERPAGE , 0 , 0 ) - 1

                ELSE

                  _HMG_SYSDATA [ 39 ] [i]  := SendMessage ( _HMG_SYSDATA [ 3 ] [i] , LVM_GETTOPINDEX , 0 , 0 ) + SendMessage ( _HMG_SYSDATA [ 3 ] [i] , LVM_GETCOUNTPERPAGE , 0 , 0 )

                ENDIF

                IF _HMG_SYSDATA [ 39 ] [i] > ListView_GetItemCount( _HMG_SYSDATA [ 3 ] [i] )

                  _HMG_SYSDATA [ 39 ] [i]  := ListView_GetItemCount( _HMG_SYSDATA [ 3 ] [i] )

                ENDIF

                IF _GridInitValue <> _HMG_SYSDATA [ 39 ] [i]
                  _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
                ENDIF

//ListView_Scroll ( _HMG_SYSDATA [ 3 ] [i] , 0, (_HMG_SYSDATA [ 39 ] [i] - _GridInitValue) * LISTVIEW_GETITEMRECT ( _HMG_SYSDATA [3] [i]  , _HMG_SYSDATA [ 39 ] [i] ) [4])
//return 0

              Case GetGridvKey (lParam) == 35 // END

                _GridInitValue := _HMG_SYSDATA [ 39 ] [i]

                _HMG_SYSDATA [ 39 ] [i]  := ListView_GetItemCount( _HMG_SYSDATA [ 3 ] [i] )

                IF _GridInitValue <> _HMG_SYSDATA [ 39 ] [i]

                  _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

                ENDIF

              Case GetGridvKey (lParam) == 36 // HOME

                _GridInitValue := _HMG_SYSDATA [ 39 ] [i]

                _HMG_SYSDATA [ 39 ] [i]  := 1

                IF _GridInitValue <> _HMG_SYSDATA [ 39 ] [i]

                  _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

                ENDIF

              Case GetGridvKey (lParam) == 65  // A
                if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                  IF _HMG_SYSDATA [ 40 ] [ i ] [ 12 ] == .T. .AND. VALTYPE(_HMG_SYSDATA [ 40 ] [ i ] [ 10 ] ) == 'C'
                    DataGridAppend(i)
                  ENDIF
                Else
                  // Return 1
                EndIf

              Case GetGridvKey (lParam) == 68 // D
                if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                  IF _HMG_SYSDATA [ 40 ] [ i ] [ 17 ] == .T. .AND. VALTYPE(_HMG_SYSDATA [ 40 ] [ i ] [ 10 ] ) == 'C'
                    DataGridDelete(i)
                  ENDIF
                Else
                  // Return 1
                EndIf

              Case GetGridvKey (lParam) == 82 // R
                if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                  IF _HMG_SYSDATA [ 40 ] [ i ] [ 17 ] == .T. .AND. VALTYPE(_HMG_SYSDATA [ 40 ] [ i ] [ 10 ] ) == 'C'
                    DataGridReCall(i)
                  ENDIF
                Else
                  // Return 1
                EndIf

              Case GetGridvKey (lParam) == 83 // S
                if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                  IF ( _HMG_SYSDATA [ 40 ] [ i ] [ 12 ] == .T. .OR. ;      // allowAppend
                       _HMG_SYSDATA [ 40 ] [ i ] [ 17 ] == .T. .OR. ;      // allowDelete
                       _HMG_SYSDATA [ 40 ] [ i ] [ 1 ] == .T. ) .AND. ;    // allowEdit inplace
                       ( VALTYPE(_HMG_SYSDATA [ 40 ] [ i ] [ 10 ] ) == 'C' )
                    DataGridSave(i)
                  ENDIF
                Else
                  // Return 1
                EndIf

              Case GetGridvKey (lParam) == 85 // U
                if GetAltState() == -127 .or. GetAltState() == -128   // ALT
                  IF ( _HMG_SYSDATA [ 40 ] [ i ] [ 12 ] == .T. .OR. ;      // allowAppend
                       _HMG_SYSDATA [ 40 ] [ i ] [ 17 ] == .T. .OR. ;      // allowDelete
                       _HMG_SYSDATA [ 40 ] [ i ] [ 1 ] == .T. ) .AND. ;    // allowEdit inplace
                       ( VALTYPE(_HMG_SYSDATA [ 40 ] [ i ] [ 10 ] ) == 'C' )
                    DataGridClearBuffer(i)
                  ENDIF
                Else
                  // Return 1
                EndIf

              OtherWise

                // Return 1   // Remove, december 2014

              EndCase

              Return 0   // ADD, december 2014

          EndIf

        EndIf

/*
        // by Dr. Claudio Soto, December 2014
        If GetNotifyCode (lParam) = LVN_BEGINSCROLL
           Return 0
        ENDIF

        If GetNotifyCode (lParam) = LVN_ENDSCROLL
           Return 0
        ENDIF
*/

        If GetNotifyCode (lParam) = NM_CUSTOMDRAW

          SetNewBehaviorWndProc (.T.)   // ADD2, December 2014

          IF _HMG_SYSDATA [32] [i] == .T.   // CellNavigation == .T.
            // r := GetDsx ( lParam , _HMG_SYSDATA [ 3 ] [i] , _HMG_SYSDATA [ 39 ] [i] )
            r := LISTVIEW_CUSTOMDRAW_GetAction ( lParam, .T., _HMG_SYSDATA [ 3 ] [i] , _HMG_SYSDATA [ 39 ] [i] )
          ELSE
            // r := GetDs ( lParam )   // CellNavigation == .F.
            r := LISTVIEW_CUSTOMDRAW_GetAction ( lParam )
          ENDIF

          if r <> -1
            Return r   // return CDRF_NOTIFYITEMDRAW, CDRF_NOTIFYSUBITEMDRAW or CDRF_DODEFAULT
          else

            a := LISTVIEW_CUSTOMDRAW_GetRowCol (lParam)   //  get nROW and nCOL of the cell draw

            *  a [1] --> nRow draw
            *  a [2] --> nCow draw
            *  _HMG_SYSDATA [ 39 ] [i] --> nRow of the selected cell
            *  _HMG_SYSDATA [ 15 ] [i] --> nCol of the selected cell

            IF _HMG_SYSDATA [32] [i] == .T.  // CellNavigation == .T.

              if a [1] == _HMG_SYSDATA [ 39 ] [i]  .and. a [2] == _HMG_SYSDATA [ 15 ] [i] .AND. _HMG_GRID_SELECTEDCELL_DISPLAYCOLOR == .T.   // ADD
                hFont := _GridEx_DoGridCustomDrawFont ( i, a, lParam, .F. )
                r := GRID_SetBCFC ( lParam , RGB( _HMG_SYSDATA[351][1] ,_HMG_SYSDATA[351][2],_HMG_SYSDATA[351][3] ) , RGB( _HMG_SYSDATA[350][1] , _HMG_SYSDATA[350][2] , _HMG_SYSDATA[350][3] ) , hFont )

              elseif a [1] == _HMG_SYSDATA [ 39 ] [i]  .and. a [2] <> _HMG_SYSDATA [ 15 ] [i] .AND. _HMG_GRID_SELECTEDROW_DISPLAYCOLOR == .T.   // ADD
                hFont := _GridEx_DoGridCustomDrawFont ( i, a, lParam, .F. )
                r := GRID_SetBCFC ( lParam , RGB( _HMG_SYSDATA[349][1] ,_HMG_SYSDATA[349][2],_HMG_SYSDATA[349][3] ) , RGB( _HMG_SYSDATA[348][1] , _HMG_SYSDATA[348][2] , _HMG_SYSDATA[348][3] ) , hFont )

              else
                r := _GridEx_DoGridCustomDraw ( i , a , lParam )   // ADD2
              endif

            ELSE
               r := _GridEx_DoGridCustomDraw ( i , a , lParam )   // ADD2
            ENDIF

            Return r   // return CDRF_NEWFONT

          endif

        EndIf

*******************************************************************************
        If GetNotifyCode ( lParam ) = -181
          redrawwindow (_HMG_SYSDATA [3] [i])
        endif
*******************************************************************************

        * Grid OnQueryData ............................

        If GetNotifyCode ( lParam ) = LVN_GETDISPINFO

          _PushEventInfo()
          _HMG_SYSDATA [ 194 ] := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4][i] )
          _HMG_SYSDATA [ 231 ] := 'C'
          _HMG_SYSDATA [ 203 ] := i
          _HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]
          _HMG_SYSDATA [ 317 ] :=  _HMG_SYSDATA [2] [_HMG_SYSDATA [ 203 ]]
          _ThisQueryTemp  := GETGRIDDISPINFOINDEX ( lParam )
          _HMG_SYSDATA [ 201 ]  := _ThisQueryTemp [1]   // This.QueryRowIndex
          _HMG_SYSDATA [ 202 ]  := _ThisQueryTemp [2]   // This.QueryColIndex

          IF valtype ( _HMG_SYSDATA [ 40 ] [ i ] [ 10 ] ) == 'C'
            IF USED ()                                           // ADD
              GetDataGridCellData ( i , .F. )
            ENDIF
          ELSE
            IF ValType (_HMG_SYSDATA [ 6 ] [i]) == "B"          // ADD
              Eval( _HMG_SYSDATA [ 6 ] [i]  )   // OnQueryData Event
            ENDIF
          ENDIF

          if HMG_LEN ( _HMG_SYSDATA [ 14 ] [i] ) > 0 .And. _HMG_SYSDATA [ 202 ] == 1
            SetGridQueryImage ( lParam , _HMG_SYSDATA [ 230 ] )
          Else
            xTemp := _HMG_SYSDATA [ 230 ]   // This.QueryData

            if valtype ( xTemp ) == 'C'
              cTemp := RTRIM(xTemp)
            elseif valtype ( xTemp ) == 'N'
              cTemp := STR(xTemp)
            elseif valtype ( xTemp ) == 'D'
              cTemp := dtoc(xTemp)
            elseif valtype ( xTemp ) == 'L'
              cTemp := if ( xTemp , '.T.' , '.F.' )
            else
              cTemp := ''
            endif

            SetGridQueryData ( lParam , cTemp )
          EndIf

          _HMG_SYSDATA [ 201 ]  := 0   // This.QueryRowIndex
          _HMG_SYSDATA [ 202 ]  := 0   // This.QueryColIndex
          _HMG_SYSDATA [ 230 ] := ""   // This.QueryData
          _PopEventInfo()
          Return 0   // ADD

        EndIf

        * Grid LostFocus ..............................

        If GetNotifyCode ( lParam ) = NM_KILLFOCUS

          // by Dr. Claudio Soto, December 2014
          IF IsGridCustomDrawNewBehavior() == .T.
            SetEventProcessHMGWindowsMessage (.T.)
          ENDIF

          _DoControlEventProcedure ( _HMG_SYSDATA [10] [i] , i )
          Return 0

        EndIf

        * Grid GotFocus ...............................

        If GetNotifyCode ( lParam ) = NM_SETFOCUS

          // by Dr. Claudio Soto, December 2014
          IF IsGridCustomDrawNewBehavior() == .T.
            SetEventProcessHMGWindowsMessage (.F.)
          ENDIF

          VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )
          _DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )
          Return 0

        EndIf

        * Grid Change .................................

        If GetNotifyCode ( lParam ) = LVN_ITEMCHANGED

          //   OnCheckBoxClicked   (by Dr. Claudio Soto, December 2014)
          #define LVIS_UNCHECKED 0x1000
          #define LVIS_CHECKED   0x2000
          IF GetGridNewState(lParam) == LVIS_UNCHECKED .OR. GetGridNewState(lParam) == LVIS_CHECKED
            xTemp := { NIL, NIL }
            xTemp[1] := _HMG_SYSDATA [ 40 ] [ i ] [ 37 ] [ 1 ]   // This.CellRowClicked
            IF ( xTemp[1] > 0 .AND. xTemp[1] <=  ListView_GetItemCount (_HMG_SYSDATA [ 3 ] [ i ]) ) .OR. ;
               ( HMG_GetLastVirtualKeyDown( @xTemp[2] ) == VK_SPACE .AND. xTemp[2] == _HMG_SYSDATA [ 3 ] [ i ] ) .OR. ;
               ( HMG_GetLastMouseMessage( @xTemp[2] ) == WM_LBUTTONDOWN .AND. xTemp[2] == _HMG_SYSDATA [ 3 ] [ i ] )   // ADD, March 2016
              IF HMG_GetLastVirtualKeyDown() == VK_SPACE .OR. HMG_GetLastMouseMessage() == WM_LBUTTONDOWN
                _HMG_SYSDATA [ 40 ] [ i ] [ 37 ] [ 1 ] := GETGRIDROW ( lParam ) + 1  // CellRowClicked
                _HMG_SYSDATA [ 40 ] [ i ] [ 37 ] [ 2 ] := 0                          // CellColClicked
              ENDIF
              _DoControlEventProcedure ( _HMG_SYSDATA [ 40 ] [ i ] [ 46 ] , i )   // OnCheckBoxClicked
              Return 0
            ENDIF
          ENDIF

          If GetGridOldState(lParam) == 0 .and. GetGridNewState(lParam) <> 0
            IF _HMG_SYSDATA [32] [i] == .T.
              _HMG_SYSDATA [ 39 ] [i] := LISTVIEW_GETFIRSTITEM ( _HMG_SYSDATA [ 3 ] [i] )
            ELSE
              _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
            ENDIF
            Return 0
          EndIf

        EndIf

        * Grid Header Click ..........................

        If GetNotifyCode ( lParam ) =  LVN_COLUMNCLICK
          if ValType ( _HMG_SYSDATA [ 17 ] [i] ) == 'A'
            lvc := GetGridColumn(lParam) + 1
            if HMG_LEN (_HMG_SYSDATA [ 17 ] [i]) >= lvc
              _DoControlEventProcedure ( _HMG_SYSDATA [ 17 ] [i] [lvc] , i )
              Return 0
            EndIf
          EndIf
        EndIf

        * Grid Click ...........................

        If GetNotifyCode ( lParam ) == NM_CLICK
          IF _HMG_SYSDATA [32] [i] == .T.

            aCellData := _GetGridCellData(i)

            IF aCellData [2] > 0

              _HMG_SYSDATA [ 15 ] [i]  := aCellData [2]

            ENDIF

            LISTVIEW_REDRAWITEMS ( _HMG_SYSDATA [ 3 ] [i] , _HMG_SYSDATA [ 39 ] [i] - 1 , _HMG_SYSDATA [ 39 ] [i] - 1 )

            _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )

          ENDIF
          Return 0   // ADD2
        EndIf

        * Grid Double Click ...........................

        If GetNotifyCode ( lParam ) == NM_DBLCLK

          IF _HMG_SYSDATA [ 40 ] [ I ] [ 1 ]  == .T.

              _PushEventInfo()
              _HMG_SYSDATA [ 194 ] := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4][i] )   // Parent Index
              _HMG_SYSDATA [ 231 ] := 'C'
              _HMG_SYSDATA [ 203 ] := i                                                      // Control Index
              _HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]         // Parent Name
              _HMG_SYSDATA [ 317 ] :=  _HMG_SYSDATA [2] [_HMG_SYSDATA [ 203 ]]               // Control Name
              aCellData := _GetGridCellData(i)
              _HMG_SYSDATA [ 195 ] := aCellData [1]
              _HMG_SYSDATA [ 196 ] := aCellData [2]
              _HMG_SYSDATA [ 197 ] := aCellData [3]
              _HMG_SYSDATA [ 198 ] := aCellData [4]
              _HMG_SYSDATA [ 199 ] := aCellData [5]
              _HMG_SYSDATA [ 200 ] := aCellData [6]

              _HMG_GRIDINPLACEEDIT(i)

              _PopEventInfo()
              _HMG_SYSDATA [ 195 ] := 0
              _HMG_SYSDATA [ 196 ] := 0
              _HMG_SYSDATA [ 197 ] := 0
              _HMG_SYSDATA [ 198 ] := 0
              _HMG_SYSDATA [ 199 ] := 0
              _HMG_SYSDATA [ 200 ] := 0

              // Return 0

          Else

            if valtype(_HMG_SYSDATA [ 16 ] [i]  )=='B'

                _PushEventInfo()
                _HMG_SYSDATA [ 194 ] := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4][i] )
                _HMG_SYSDATA [ 231 ] := 'C'
                _HMG_SYSDATA [ 203 ] := i
                _HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]
                _HMG_SYSDATA [ 317 ] :=  _HMG_SYSDATA [2] [_HMG_SYSDATA [ 203 ]]

                aCellData := _GetGridCellData(i)

                _HMG_SYSDATA [ 195 ] := aCellData [1]
                _HMG_SYSDATA [ 196 ] := aCellData [2]
                _HMG_SYSDATA [ 197 ] := aCellData [3]
                _HMG_SYSDATA [ 198 ] := aCellData [4]
                _HMG_SYSDATA [ 199 ] := aCellData [5]
                _HMG_SYSDATA [ 200 ] := aCellData [6]

                Eval( _HMG_SYSDATA [ 16 ] [i]  )
                _PopEventInfo()

                _HMG_SYSDATA [ 195 ] := 0
                _HMG_SYSDATA [ 196 ] := 0
                _HMG_SYSDATA [ 197 ] := 0
                _HMG_SYSDATA [ 198 ] := 0
                _HMG_SYSDATA [ 199 ] := 0
                _HMG_SYSDATA [ 200 ] := 0

                // Return 0

            EndIf

          EndIf

          Return 0

        EndIf

      EndIf

      * DatePicker Process ..................................

      if _HMG_SYSDATA [1] [i] = "DATEPICK"

        * DatePicker Change ............................

        If ( GetNotifyCode ( lParam ) == DTN_DATETIMECHANGE .and. SendMessage( _HMG_SYSDATA [ 3 ] [i] ,DTM_GETMONTHCAL,0,0 ) == 0 ) .OR. ( GetNotifyCode ( lParam ) == DTN_CLOSEUP )
           _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
          Return 0
        EndIf

        * DatePicker LostFocus ........................

        If GetNotifyCode ( lParam ) = NM_KILLFOCUS
          _DoControlEventProcedure ( _HMG_SYSDATA [10] [i] , i )
          Return 0
        EndIf

        * DatePicker GotFocus .........................

        If GetNotifyCode ( lParam ) = NM_SETFOCUS
          VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )
          _DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )
          Return 0
        EndIf

      EndIf



      * TimePicker Process ( Dr. Claudio Soto, April 2013 ) ..................................

      if _HMG_SYSDATA [1] [i] = "TIMEPICK"

        * TimePicker Change ............................

        If ( GetNotifyCode ( lParam ) == DTN_DATETIMECHANGE )
          _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
          Return 0
        EndIf

        * TimePicker LostFocus ........................

        If GetNotifyCode ( lParam ) = NM_KILLFOCUS
          _DoControlEventProcedure ( _HMG_SYSDATA [10] [i] , i )
          Return 0
        EndIf

        * TimePicker GotFocus .........................

        If GetNotifyCode ( lParam ) = NM_SETFOCUS
          VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )
          _DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )
          Return 0
        EndIf

      EndIf

      // by Dr. Claudio Soto, January 2014
      * RichEditBox Processing ......................................

      if _HMG_SYSDATA [1] [i] = "RICHEDIT"

        * RichEditBox Selelection Change ..................................

        If GetNotifyCode ( lParam ) = EN_SELCHANGE
          _DoControlEventProcedure ( _HMG_SYSDATA [ 22 ] [i] , i )
          Return 0
        EndIf

        If GetNotifyCode ( lParam ) = EN_LINK
          // GetNotifyLink ( lParam , @Link_wParam , @Link_lParam , @Link_cpMin         , @Link_cpMax         )   -> return Link_nMsg

          If GetNotifyLink ( lParam , NIL          , NIL          , @_HMG_CharRange_Min , @_HMG_CharRange_Max ) = WM_LBUTTONDOWN
            _DoControlEventProcedure ( _HMG_SYSDATA [ 31 ] [i] , i )
            _HMG_CharRange_Min := 0
            _HMG_CharRange_Max := 0
            Return 0
          EndIf

        EndIf

      EndIf

      * Tab Processing ......................................

      if _HMG_SYSDATA [1] [i] = "TAB"

        * Tab Change ..................................

        If GetNotifyCode ( lParam ) = TCN_SELCHANGE
          if HMG_LEN (_HMG_SYSDATA [  7 ] [i]) > 0
            UpdateTab (i)
          EndIf
          _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
          Return 0
        EndIf

      EndIf

      * Tree Processing .....................................

      if _HMG_SYSDATA [1] [i] = "TREE"

        * Tree LostFocus .............................

        If GetNotifyCode ( lParam ) = NM_KILLFOCUS
          _DoControlEventProcedure ( _HMG_SYSDATA [10] [i] , i )
          Return 0
        EndIf

        * Tree GotFocus ..............................

        If GetNotifyCode ( lParam ) = NM_SETFOCUS
          VirtualChildControlFocusProcess ( _HMG_SYSDATA [3] [i] , _HMG_SYSDATA [4] [i] )
          _DoControlEventProcedure ( _HMG_SYSDATA [ 11 ] [i] , i )
          Return 0
        EndIf

        * Tree Change ................................

        If GetNotifyCode ( lParam ) = TVN_SELCHANGED
          _DoControlEventProcedure ( _HMG_SYSDATA [ 12 ] [i] , i )
          Return 0
        EndIf

        * Tree Double Click .........................

        If GetNotifyCode ( lParam ) == NM_DBLCLK
          _DoControlEventProcedure ( _HMG_SYSDATA [ 16 ] [i] , i )
          Return 0
        EndIf

        * Tree OnExpand and OnCollapse ......................... (Dr. Claudio Soto, July 2014)

        IF GetNotifyCode ( lParam ) == TVN_ITEMEXPANDING   /*TVN_ITEMEXPANDED*/

          _HMG_ret := NOTIFY_TREEVIEW_ITEMEXPAND ( lParam )
          _HMG_This_TreeItem_Value := NIL

          If _HMG_SYSDATA [9] [i] == .F.
            _HMG_This_TreeItem_Value := ASCAN ( _HMG_SYSDATA [7] [i], _HMG_ret [2] )
          Else
            _HMG_This_TreeItem_Value := TREEITEM_GETID ( _HMG_SYSDATA [3] [i], _HMG_ret [2] )
          EndIf

          IF _HMG_ret [1] == TVE_EXPAND
            _DoControlEventProcedure ( _HMG_SYSDATA [ 17 ] [i] [1], i )
            _HMG_This_TreeItem_Value := NIL
            Return 0
          ENDIF

          IF _HMG_ret [1] == TVE_COLLAPSE
            _DoControlEventProcedure ( _HMG_SYSDATA [ 17 ] [i] [2], i )
            _HMG_This_TreeItem_Value := NIL
            Return 0
          ENDIF

        ENDIF

        * Tree Dynamic ForeColor, BackColor and Font   ......................... (Dr. Claudio Soto, July 2014)

        IF GetNotifyCode (lParam) == NM_CUSTOMDRAW

          IF ValType (_HMG_SYSDATA [40] [i] [1]) == "B" .OR. ;   // DynamicBackColor
             ValType (_HMG_SYSDATA [40] [i] [2]) == "B" .OR. ;   // DynamicForeColor
             ValType (_HMG_SYSDATA [40] [i] [3]) == "B"          // DynamicFont

            SetNewBehaviorWndProc (.T.)   // ADD2, December 2014

            r := TREEVIEW_CUSTOMDRAW_GetAction ( lParam )

            if r <> -1
              Return R   // return CDRF_NOTIFYITEMDRAW or CDRF_DODEFAULT
            endif

            _HMG_This_TreeItem_Value := NIL

            _HMG_ret := ASCAN ( _HMG_SYSDATA [7] [i], TREEVIEW_CUSTOMDRAW_GETITEMHANDLE (lParam) )

            IF _HMG_ret > 0

              If _HMG_SYSDATA [9] [i] == .F.
                _HMG_This_TreeItem_Value := _HMG_ret
              ELSE
                _HMG_This_TreeItem_Value := _HMG_SYSDATA [25] [i] [ _HMG_ret ]
              EndIf

              Return _DoTreeCustomDraw ( i , lParam )   // return CDRF_NEWFONT

            ENDIF

          ENDIF

        ENDIF

      EndIf

    EndIf


        ***********************************************************************
	case nMsg == WM_CLOSE
        ***********************************************************************

      If GetEscapeState() < 0   // GetKeyState( VK_ESCAPE )
         If GetFocusedControlType() == 'EDIT'
            Return (1)   // Not Closes Window
         EndIf
      EndIf

      i := Ascan ( _HMG_SYSDATA [ 67 ] , hWnd )
      if i > 0

         * Process Interactive Close Event / Setting

			If ValType ( _HMG_SYSDATA [ 106 ] [i] ) == 'B'
				xRetVal := _DoWindowEventProcedure ( _HMG_SYSDATA [ 106 ] [i] , i , 'WINDOW_ONINTERACTIVECLOSE' )
				If ValType (xRetVal) = 'L'
					If !xRetVal
						Return (1)   // Not Closes Window
					EndIf
				EndIf
			EndIf

			Do Case
			Case _HMG_SYSDATA [ 339 ] == 0   // _HMG_InteractiveClose
				MsgStop ( _HMG_SYSDATA [ 331 ] [3] )
				Return (1)   // Not Closes Window
			Case _HMG_SYSDATA [ 339 ] == 2
				If ! MsgYesNo ( _HMG_SYSDATA [ 331 ] [1] , _HMG_SYSDATA [ 331 ] [2] )
					Return (1)   // Not Closes Window
				EndIf
			Case _HMG_SYSDATA [ 339 ] == 3
				if _HMG_SYSDATA [ 69 ] [i] == 'A'
					If ! MsgYesNo ( _HMG_SYSDATA [ 331 ] [1] , _HMG_SYSDATA [ 331 ] [2] )
						Return (1)   // Not Closes Window
					EndIf
				EndIf
			EndCase

			* Process AutoRelease Property

			if _HMG_SYSDATA [ 105 ] [i] == .F.
				_HideWindow ( _HMG_SYSDATA [  66 ] [i] )
				Return (1)   // Not Closes Window
			EndIf

			* If Not AutoRelease Destroy Window

			if _HMG_SYSDATA [ 69  ] [i] == 'A'   // Main Window
				ReleaseAllWindows()   // call ExitProcess(0) and ends the application
			Else
				if ValType( _HMG_SYSDATA [  71 ] [i] )=='B'
					_HMG_SYSDATA [ 252 ] := .T.
					_DoWindowEventProcedure ( _HMG_SYSDATA [  71 ] [i] , i , 'WINDOW_RELEASE')
				EndIf
				_hmg_OnHideFocusManagement(i)

#ifdef ALLOW_ONLY_ONE_MESSAGE_LOOP
// DestroyWindow(hWnd): Destroys the specified window.
// The function sends WM_DESTROY and WM_NCDESTROY messages to the window to deactivate it and remove the keyboard focus from it.
// The function also destroys the window's MENU, flushes the thread MESSAGE QUEUE, destroys TIMERS, removes CLIPBOARD ownership,
// and breaks the clipboard viewer chain (if the window is at the top of the viewer chain).
// If the specified window is a parent or owner window, DestroyWindow automatically destroys the associated CHILD or OWNED windows
// when it destroys the parent or owner window. The function first destroys child or owned windows, and then it destroys the parent or owner window.
// DestroyWindow also destroys MODELESS DIALOG BOXES created by the CreateDialog function.

   DestroyWindow ( _HMG_SYSDATA [ 67 ] [i] )   // _HMG_aFormHandles
#endif
			EndIf

		EndIf

        ***********************************************************************
	case nMsg == WM_DESTROY
        ***********************************************************************

      ControlCount  := HMG_LEN (_HMG_SYSDATA [3])
      i := Ascan ( _HMG_SYSDATA [ 67 ] , hWnd )

      if i > 0

      * Remove Child Controls
         For x:=1 To ControlCount
            if _HMG_SYSDATA [4] [x] == hWnd              // _HMG_aParentHandle
               if _HMG_SYSDATA [1] [x] == 'ACTIVEX'      // _HMG_aControlType
                  releasecontrol(_HMG_SYSDATA [3] [x])   // _HMG_aControlHandle
               ENDIF
               if _HMG_SYSDATA [1] [x] == 'BUTTON'
                  IMAGELIST_DESTROY ( _HMG_SYSDATA [ 37 ] [x] )   // avoid the increase of GDI handles when subwindow with buttons is released
               ENDIF
               _EraseControl(x,i)   // This function call: DeleteObject(), IMAGELIST_DESTROY(), ReleaseHotKey() and clean the content of _HMG_SYSDATA of control
            EndIf
         Next x

         // Delete Brush
         DeleteObject ( _HMG_SYSDATA [ 100 ] [i] )   // _HMG_aFormBrushHandle

         // Update Form Index Variable
         mVar := '_' + _HMG_SYSDATA [ 66 ] [i]       // _HMG_aFormNames
         if type ( mVar ) != 'U'
            __MVPUT ( mVar , 0 )
         EndIf

         Tmp := NIL   // avoid warning message: defined variable but not used (need only ALLOW_ONLY_ONE_MESSAGE_LOOP is defined)

#ifndef ALLOW_ONLY_ONE_MESSAGE_LOOP

         * If Window Was Multi-Activated, Determine If It Is The Last One.
         * If Yes, Post Quit Message To Finish The Message Loop
         * Quit Message, will be posted always for single activated windows.

         if _HMG_SYSDATA [ 107 ] [i] > 0   // _HMG_aFormActivateId
            TmpStr := '_HMG_ACTIVATE_' + ALLTRIM(Str(_HMG_SYSDATA [ 107 ] [i]))
            if __MVEXIST ( TmpStr )
               Tmp := __MVGET ( TmpStr )
               If ValType(Tmp) == 'N'
                  __MVPUT ( TmpStr , Tmp - 1 )
                  if Tmp - 1 == 0
                     PostQuitMessage(0)
                     __MVXRELEASE(TmpStr)
                  Endif
               Endif
            Endif
         else
            PostQuitMessage(0)
         Endif

#endif


#ifdef ALLOW_ONLY_ONE_MESSAGE_LOOP
   if _HMG_SYSDATA [ 69 ] [i] == "A"   // Main Window
     PostQuitMessage(0)
   endif
#endif


			_HMG_SYSDATA [ 65 ] [i]	:= .T.
			_HMG_SYSDATA [ 67 ] [i]	:= 0
			_HMG_SYSDATA [ 66 ] [i]	:= ""
			_HMG_SYSDATA [ 68 ] [i]	:= .f.
			_HMG_SYSDATA [ 69 ] [i]	:= ""
			_HMG_SYSDATA [ 70 ] [i]	:= 0
			_HMG_SYSDATA [ 72 ] [i]	:= ""
			_HMG_SYSDATA [ 71 ] [i]	:= ""
			_HMG_SYSDATA [ 73 ] [i]	:= 0
			_HMG_SYSDATA [ 74 ] [i]	:= 0
			_HMG_SYSDATA [ 75 ] [i]	:= ""
			_HMG_SYSDATA [ 76 ] [i]	:= ""
			_HMG_SYSDATA [ 77 ] [i]	:= ""
			_HMG_SYSDATA [ 78 ] [i]	:= ""
         _HMG_SYSDATA [ 79 ] [I]	:= Nil
			_HMG_SYSDATA [ 80 ] [i]	:= ""
			_HMG_SYSDATA [ 81 ] [i]	:= .F.
			_HMG_SYSDATA [ 82 ] [i] := ''
			_HMG_SYSDATA [ 83 ] [i] := ''
			_HMG_SYSDATA [ 84 ] [i] := ''
			_HMG_SYSDATA [ 87 ] [i] := 0
			_HMG_SYSDATA [ 88 ] [I] := 0
			_HMG_SYSDATA [ 89 ] [i] := {}
			_HMG_SYSDATA [ 90 ] [i] := {}
			_HMG_SYSDATA [ 91 ] [i] := 0
			_HMG_SYSDATA [ 85 ] [i] := ""
			_HMG_SYSDATA [ 86 ] [i] := ""
			_HMG_SYSDATA [ 92 ] [i] := 0
			_HMG_SYSDATA [ 93 ] [i] := .f.
			_HMG_SYSDATA [ 94 ] [i] := ""
			_HMG_SYSDATA [ 95 ] [i] := ""
			_HMG_SYSDATA [ 96 ] [i] := ""
			_HMG_SYSDATA [ 97 ] [i] := ""
			_HMG_SYSDATA [ 98 ] [i] := ""
			_HMG_SYSDATA [ 99 ] [i] := ""
			_HMG_SYSDATA [ 100 ] [i] := 0
			_HMG_SYSDATA [ 101 ] [i] := 0
			_HMG_SYSDATA [ 102 ] [i] := {}
			_HMG_SYSDATA [ 103 ] [i] := Nil
			_HMG_SYSDATA [ 104 ] [i] := Nil
			_HMG_SYSDATA [ 105 ] [i] := .F.
			_HMG_SYSDATA [ 106 ] [i] := ""
			_HMG_SYSDATA [ 107 ] [i] := 0
			_HMG_SYSDATA [ 108 ] [i] := NIL
         _HMG_SYSDATA [ 504 ] [i] := { NIL, NIL, NIL, NIL}
         _HMG_SYSDATA [ 511 ] [i] := 0
         _HMG_SYSDATA [ 512 ] [i] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }

			_HMG_SYSDATA [ 252 ] := .F.

		Endif

// Dr. Claudio Soto (July 2013)

   IF _HMG_LastActiveControlIndex > 0 .AND. IsControlDeletedByIndex (_HMG_LastActiveControlIndex) == .T.
      aux_hWnd := GetFocus ()
      IF aux_hWnd == 0
         aux_hWnd := GetActiveWindow ()
      ENDIF
      nIndex := 0
      IF aux_hWnd <> 0
         nIndex := GetControlIndexByHandle (aux_hWnd)
      ENDIF
      _HMG_LastActiveControlIndex := nIndex
   ENDIF


        ***********************************************************************
	case nMsg == WM_NCACTIVATE
        ***********************************************************************

      if wParam == 0
         if lParam == 0
            if _isWindowDefined('_HMG_GRID_InplaceEdit')
               _HMG_SYSDATA [ 256 ] := .F.
               EXITGRIDCELL()
            endif
            if valtype ( _HMG_SYSDATA [ 296 ] ) == 'B'
               Eval ( _HMG_SYSDATA [ 296 ] )
            endif
         endif
      endif

	endcase

return (0)
*-----------------------------------------------------------------------------*
Function GetWindowType ( FormName )
*-----------------------------------------------------------------------------*
Local mVar , i

	mVar := '_' + FormName

	i:=&mVar
	if i == 0
		Return ''
	endif

Return ( _HMG_SYSDATA [ 69  ] [ &mVar ] )
*-----------------------------------------------------------------------------*
Function _IsWindowActive ( FormName )
*-----------------------------------------------------------------------------*
Local mVar , i

FormName := CharRem ( CHR(34)+CHR(39), FormName )

mVar := '_' + FormName

if type ( mVar ) = 'U'
	Return (.F.)
Else
	i := &mVar
	If i == 0
		Return .f.
	EndIf
	Return ( _HMG_SYSDATA [ 68  ]  [ &mVar ] )
EndIf

Return .F.

*-----------------------------------------------------------------------------*
Function _IsWindowDefined ( FormName )
*-----------------------------------------------------------------------------*
Local mVar , i

FormName := CharRem ( CHR(34)+CHR(39), FormName )

mVar := '_' + FormName

if type ( mVar ) = 'U'
	Return (.F.)
Else
	i := &mVar
	If i == 0
		Return .f.
	EndIf
	Return ( .Not. ( _HMG_SYSDATA [  65 ]  [ &mVar ] ) )
EndIf

Return .F.


*-----------------------------------------------------------------------------*
Function GetFormName (FormName)
*-----------------------------------------------------------------------------*
Local mVar , i

	mVar := '_' + FormName

	i:=&mVar
	if i == 0
		Return ''
	endif

Return ( _HMG_SYSDATA [  66 ] [ &mVar ] )
*-----------------------------------------------------------------------------*
Function GetFormToolTipHandle (FormName)
*-----------------------------------------------------------------------------*
Local mVar , i

	mVar := '_' + FormName

	i:=&mVar
	if i == 0
		Return 0
	endif

Return ( _HMG_SYSDATA [ 73  ] [ &mVar ] )

*-----------------------------------------------------------------------------*
Function GetMenuToolTipHandle (FormName)
*-----------------------------------------------------------------------------*
Local mVar , i

	mVar := '_' + FormName

	i:=&mVar
	if i == 0
		Return 0
	endif

Return ( _HMG_SYSDATA [ 511  ] [ &mVar ] )

*-----------------------------------------------------------------------------*
Function GetFormHandle (FormName)
*-----------------------------------------------------------------------------*
Local mVar , i

	mVar := '_' + FormName

	i:=&mVar
	if i == 0
		Return 0
	endif

Return ( _HMG_SYSDATA [ 67  ] [ &mVar ] )

*-----------------------------------------------------------------------------*
Function ReleaseAllWindows ()
*-----------------------------------------------------------------------------*
Local i, FormCount , x , ControlCount

	If _HMG_SYSDATA [ 232 ] == 'WINDOW_RELEASE'
		MsgHMGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
	EndIf

	* _HMG_SYSDATA [  65 ] -> _HMG_aFormDeleted
	* _HMG_SYSDATA [  66 ] -> _HMG_aFormNames
	* _HMG_SYSDATA [  67 ] -> _HMG_aFormHandles
	* _HMG_SYSDATA [  68 ] -> _HMG_aFormActive
	* _HMG_SYSDATA [  69 ] -> _HMG_aFormType
	* _HMG_SYSDATA [  70 ] -> _HMG_aFormParentHandle
	* _HMG_SYSDATA [  71 ] -> _HMG_aFormReleaseProcedure

	FormCount := HMG_LEN (_HMG_SYSDATA [ 67  ])

	For i = 1 to FormCount
		if  _HMG_SYSDATA [ 68 ] [i]  == .t.   // _HMG_aFormActive

			_DoWindowEventProcedure ( _HMG_SYSDATA [ 71 ] [i] , i , 'WINDOW_RELEASE' )

			if .Not. Empty ( _HMG_SYSDATA [ 82 ] [i] )
				_HMG_SYSDATA [ 82 ] [i] := ''
				ShowNotifyIcon( _HMG_SYSDATA [ 67 ] [i] , .F., NIL, NIL )
			EndIf

		Endif

// if set mixedmode
//      _HMG_SYSDATA [ 65 ] [i]  = .T.              // _HMG_aFormDeleted
//      DestroyWindow ( _HMG_SYSDATA [ 67 ] [i] )   // _HMG_aFormHandles

	Next i

	ControlCount := HMG_LEN ( _HMG_SYSDATA [3] )

	For x := 1 To ControlCount

		if _HMG_SYSDATA [1] [x] == 'HOTKEY'
			ReleaseHotKey ( _HMG_SYSDATA [4] [x] , _HMG_SYSDATA [  5 ] [x] )   // This is not necessary here !!!
		EndIf

	Next x

   // Dr. Claudio Soto (July 2013)
   HMG_HOOK_UNINSTALL ()

	UnloadAllDll()

	dbCloseAll()

   ExitProcess(0)

// if Set MixedMode --> call PostQuitMessage(0) and not ExitProcess(0), dbCloseAll(), UnloadAllDll() ???

Return Nil

*-----------------------------------------------------------------------------*
Function _ReleaseWindow (FormName)
*-----------------------------------------------------------------------------*
Local FormCount , b , i , x


	b := _HMG_SYSDATA [ 339 ]
	_HMG_SYSDATA [ 339 ] := 1

	FormCount := HMG_LEN (_HMG_SYSDATA [ 67 ])

	If .Not. _IsWindowDefined (Formname)
		MsgHMGError("Window: "+ FormName + " is not defined. Program terminated" )
	Endif

	If .Not. _IsWindowActive (Formname)
		MsgHMGError("Window: "+ FormName + " is not active. Program terminated" )
	Endif

	If _HMG_SYSDATA [ 232 ] == 'WINDOW_RELEASE'
		If GetFormIndex (FormName) == _HMG_SYSDATA [ 203 ]
			MsgHMGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
		EndIf
	EndIf


   // If the window to release is the main application window, release all windows command will be executed
   If GetWindowType (FormName) == 'A'   // Release MainWindow

		If _HMG_SYSDATA [ 232 ] == 'WINDOW_RELEASE'
			MsgHMGError("Release a window in its own 'on release' procedure or release the main window in any 'on release' procedure is not allowed. Program terminated" )
		Else
			ReleaseAllWindows()   // in ReleaseAllWindows() is called HMG_HOOK_UNINSTALL()
		EndIf

   EndIf


   If GetWindowType (FormName) == 'P'
      MsgHMGError("Release a 'Panel' window is not allowed (It is released via its parent). Program terminated" )
   EndIf


   i := GetFormIndex ( Formname )

	* Release Window

	* _HMG_SYSDATA [  67 ] -> _HMG_aFormHandles
	* _HMG_SYSDATA [  69 ] -> _HMG_aFormType
	* _HMG_SYSDATA [  70 ] -> _HMG_aFormParentHandle
	* _HMG_SYSDATA [ 167 ] -> _hmg_activemodalhandle
	* _HMG_SYSDATA [ 181 ] -> _HMG_MainHandle

   if _HMG_SYSDATA [ 69 ] [i] == 'M' .and. _HMG_SYSDATA [ 167 ] <> _HMG_SYSDATA [ 67 ] [i]

         If IsWindowVisible ( _HMG_SYSDATA [ 67 ] [i] )
            MsgHMGError("Non top modal windows can't be released. Program terminated" )
         Else
            EnableWindow ( _HMG_SYSDATA [ 67 ] [i] )
            SendMessage  ( _HMG_SYSDATA [ 67 ] [i] , WM_SYSCOMMAND, SC_CLOSE, 0 )
            // SendMessage( _HMG_SYSDATA [ 67 ] [i], WM_CLOSE, 0, 0 )   // ADD October 2015, REMOVE January 2016
         EndIf

   Else

		For x := 1 To FormCount
			if _HMG_SYSDATA [ 70 ] [x] == _HMG_SYSDATA [ 67 ] [i]   // if _HMG_aFormParentHandle == FormHandle to Release
				_HMG_SYSDATA [ 70 ] [x] := _HMG_SYSDATA [ 181 ]      // _HMG_aFormParentHandle := _HMG_MainHandle  -->  WHY THIS ???
			EndIf
		Next x

      EnableWindow ( _HMG_SYSDATA [ 67 ] [i] )
      SendMessage( _HMG_SYSDATA [ 67 ] [i] , WM_SYSCOMMAND, SC_CLOSE, 0 )
      // SendMessage( _HMG_SYSDATA [ 67 ] [i], WM_CLOSE, 0, 0 )   // ADD October 2015, REMOVE January 2016
   EndIf

   _HMG_SYSDATA [ 339 ] := b

Return Nil

*-----------------------------------------------------------------------------*
Function _ShowWindow (FormName)
*-----------------------------------------------------------------------------*
Local i , FormCount , x
Local ActiveWindowHandle

	i := GetFormIndex ( FormName )

	if _HMG_SYSDATA [ 69  ] [i] == "M"

		// Find Parent

		* _HMG_SYSDATA [  69 ] -> _HMG_aFormType
		* _HMG_SYSDATA [  70 ] -> _HMG_aFormParentHandle
		* _HMG_SYSDATA [ 167 ] -> _hmg_activemodalhandle
		* _HMG_SYSDATA [ 271 ] -> _HMG_IsModalActive

		If _HMG_SYSDATA [ 271 ]
			_HMG_SYSDATA [ 70  ] [i] := _HMG_SYSDATA [ 167 ]
		Else

			ActiveWindowhandle := _HMG_SYSDATA [ 166 ]
			x := ascan ( _HMG_SYSDATA [ 67  ] , ActiveWindowhandle )
			if x > 0
				_HMG_SYSDATA [ 70  ] [i] := ActiveWindowhandle
			else
				_HMG_SYSDATA [ 70  ] [i] := _HMG_SYSDATA [ 181 ]
			endif

		endif

		FormCount := HMG_LEN ( _HMG_SYSDATA [ 67  ] )

		for x := 1 to FormCount

		        if x <> i .and. _HMG_SYSDATA [ 69 ] [x] != 'X' .and. _HMG_SYSDATA [ 69 ] [ x ] != 'P'  .and. _HMG_SYSDATA [ 70 ] [ x ] != _HMG_SYSDATA [ 67 ] [ i ]
				DisableWindow ( _HMG_SYSDATA [ 67 ] [ x ] )
			endif

		next x

		if HMG_LEN ( _HMG_SYSDATA [ 90 ] [ i ] )  > 0
			For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 90 ] [ i ] )
				EnableWindow ( _HMG_SYSDATA [ 67  ] [ _HMG_SYSDATA [ 90 ] [i] [x] ] )
			Next x
		EndIf

	        _HMG_SYSDATA [ 271 ] := .T.
		_HMG_SYSDATA [ 167 ] := _HMG_SYSDATA [ 67  ][i]
		EnableWindow ( _HMG_SYSDATA [ 67  ][i] )

		If _SetFocusedSplitChild(i) == .f.
			_SetActivationFocus(i)
		endif

	EndIf

	ShowWindow ( _HMG_SYSDATA [ 67  ] [i] )

   DO EVENTS   // ProcessMessages()

Return Nil

*-----------------------------------------------------------------------------*
Function _HideWindow (FormName)
*-----------------------------------------------------------------------------*
Local i

	i := GetFormIndex (FormName)

	if i > 0

		If IsWindowVisible ( _HMG_SYSDATA [ 67  ] [i] )

			if _HMG_SYSDATA [ 69  ] [ i ] == 'M'
				if	_HMG_SYSDATA [ 167 ] <> _HMG_SYSDATA [ 67  ] [i]
					MsgHMGError("Non top modal windows can't be hide. Program terminated" )
				EndIf
			EndIf

			HideWindow ( _HMG_SYSDATA [ 67  ][i] )
			_hmg_OnHideFocusManagement(i)

		EndIf

	EndIf

Return Nil
*-----------------------------------------------------------------------------*
Function _CenterWindow ( FormName , Parent )
*-----------------------------------------------------------------------------*
   C_Center( GetFormHandle(FormName) , IIF (ValType(Parent)=="C", GetFormHandle(Parent), Parent) )
Return Nil
*-----------------------------------------------------------------------------*
Function _RestoreWindow ( FormName )
*-----------------------------------------------------------------------------*
local h
	_ShowWindow (FormName)
	H = GetFormHandle(FormName)
	Restore(H)
Return Nil
*-----------------------------------------------------------------------------*
Function _MaximizeWindow ( FormName )
*-----------------------------------------------------------------------------*
local h
	H = GetFormHandle(FormName)
	Maximize(H)
Return Nil
*-----------------------------------------------------------------------------*
Function _MinimizeWindow ( FormName )
*-----------------------------------------------------------------------------*
local h
	H = GetFormHandle(FormName)
	Minimize(H)
Return Nil


*-----------------------------------------------------------------------------*
Function HMG_MakeWindowsClassName ( cForm )
LOCAL ClassName := "_HMG_" + cForm  + "_" + hb_ntos( GetCurrentThreadID() )
Return ClassName
*-----------------------------------------------------------------------------*


*-----------------------------------------------------------------------------*
Function _DefineWindow ( FormName, Caption, x, y, w, h ,nominimize ,nomaximize ,nosize ,nosysmenu, nocaption , StatusBar , StatusText ,initprocedure ,ReleaseProcedure , MouseDragProcedure ,SizeProcedure , ClickProcedure , MouseMoveProcedure, aRGB , PaintProcedure , noshow , topmost , main , icon , child , fontname , fontsize , NotifyIconName , NotifyIconTooltip , NotifyIconLeftClick , GotFocus , LostFocus , virtualheight , VirtualWidth , scrollleft , scrollright , scrollup , scrolldown , hscrollbox , vscrollbox , helpbutton , maximizeprocedure , minimizeprocedure , cursor , NoAutoRelease , InteractiveCloseProcedure , visible , autorelease , minbutton , maxbutton , sizable , sysmenu , titlebar , cPanelParent , panel )
*-----------------------------------------------------------------------------*
Local i , htooltip , mVar , vscroll , hscroll , BrushHandle , k, FormHandle, ParentHandle
Local cType
LOCAL hWnd_ToolTip

* Unused Parameters

StatusBar := Nil
StatusText := Nil

DEFAULT x := GetDesktopRealLeft()
DEFAULT y := GetDesktopRealTop()
DEFAULT w := GetDeskTopRealWidth()
DEFAULT h := GetDeskTopRealHeight()

	If ValType( cPanelParent ) == 'C' .and. panel == .f.

		MsgHMGError("Parent can be specified only for Panel windows. Program Terminated" )

	endif

	If .not. Empty( _HMG_SYSDATA [ 223 ] ) .and. panel == .f.
		MsgHMGError("Only Panel windows can be defined inside a DEFINE WINDOW...END WINDOW structure. Program Terminated" )
	EndIf

	if ValType(sizable) == "L"
		nosize	:= .Not. sizable
	endif

	if ValType(sysmenu) == "L"
		nosysmenu	:= .Not. sysmenu
	endif

	if ValType(titlebar) == "L"
		nocaption	:= .Not. titlebar
	endif

	if ValType(minbutton) == "L"
		nominimize	:= .Not. minbutton
	endif

	if ValType(maxbutton) == "L"
		nomaximize	:= .Not. maxbutton
	endif

	if ValType(autorelease) == "L"
		NoAutoRelease	:= .Not. AutoRelease
	endif

	if ValType(visible) == "L"
		NoShow	:= .Not. Visible
	endif

	if ValType(FormName) == "U"
		FormName := _HMG_SYSDATA [ 214 ]

		if _HMG_SYSDATA [ 235 ] <> -1

			y := _HMG_SYSDATA [ 235 ]
			x := _HMG_SYSDATA [ 236 ]
			w := _HMG_SYSDATA [ 237 ]
			h := _HMG_SYSDATA [ 238 ]

			_HMG_SYSDATA [ 235 ] := -1
			_HMG_SYSDATA [ 236 ] := -1
			_HMG_SYSDATA [ 237 ] := -1
			_HMG_SYSDATA [ 238 ] := -1

		endif

	endif


	if _HMG_SYSDATA [ 183 ] > 0
		x 	:= x + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
		y 	:= y + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
	EndIf


	FormName := ALLTRIM(FormName)

	if Main

		i := ascan ( _HMG_SYSDATA [ 69  ] , 'A' )

		if i > 0
			MsgHMGError("Main Window Already Defined. Program Terminated" )
		Endif

		if Child == .T.
			MsgHMGError("Child and Main Clauses Can't Be Used Simultaneously. Program Terminated" )
		Endif

		if NoAutoRelease == .T.
			MsgHMGError("NOAUTORELEASE and MAIN Clauses Can't Be Used Simultaneously. Program Terminated" )
		Endif

//		_HMG_SYSDATA [54] := _GETDDLMESSAGE()

	Else

IF _HMG_MainWindowFirst == .T.
		i := ascan ( _HMG_SYSDATA [ 69  ] , 'A' )
		if i <= 0
			MsgHMGError("Main Window Not Defined. Program Terminated" )
		Endif
ENDIF

		If _IsWindowDefined (FormName)
			MsgHMGError("Window: "+ FormName + " already defined. Program Terminated" )
		endif

		If .Not. Empty (NotifyIconName)
			MsgHMGError("Notification Icon Allowed Only in Main Window. Program Terminated" )
		endif

	EndIf

	mVar := '_' + FormName

	if child == .T.
		ParentHandle := _HMG_SYSDATA [ 181 ]
	Else
		ParentHandle := 0
	endif


	if panel == .T.

		If ValType ( cPanelParent ) == 'C'

			if GetWindowType ( cPanelParent ) == 'X'
				MsgHMGError("Panel Windows Can't Have SplitChild Parents. Program Terminated" )
			endif

			ParentHandle := GetFormHandle(cPanelParent)
			_HMG_SYSDATA [ 240 ] := .F.

		ElseIf	.Not. Empty(_HMG_SYSDATA [ 223 ])

			if GetWindowType ( _HMG_SYSDATA [ 223 ] ) == 'X'
				MsgHMGError("panel Windows Can't Have SplitChild Parents. Program Terminated" )
			endif

			ParentHandle := GetFormHandle( _HMG_SYSDATA [ 223 ] )
			_HMG_SYSDATA [ 240 ] := .t.
			_HMG_SYSDATA [ 215 ] := _HMG_SYSDATA [ 223 ]

		Else

			MsgHMGError("Panel Windows Must Have a Parent. Program Terminated" )

		EndIf

	endif



	if ValType(FontName) == "U"
		_HMG_SYSDATA [ 224 ] := ""
	Else
		_HMG_SYSDATA [ 224 ] := FontName
	Endif

	if ValType(FontSize) == "U"
		_HMG_SYSDATA [ 182 ] := 0
	Else
		_HMG_SYSDATA [ 182 ] := FontSize
	Endif

	if ValType(Caption) == "U"
		Caption := ""
	endif

	if ValType(scrollup) == "U"
		scrollup := ""
	endif
	if ValType(scrolldown) == "U"
		scrolldown := ""
	endif
	if ValType(scrollleft) == "U"
		scrollleft := ""
	endif
	if ValType(scrollright) == "U"
		scrollright := ""
	endif

	if ValType(hscrollbox) == "U"
		hscrollbox := ""
	endif
	if ValType(vscrollbox) == "U"
		vscrollbox := ""
	endif

	if ValType(InitProcedure) == "U"
		InitProcedure := ""
	endif

	if ValType(ReleaseProcedure) == "U"
		ReleaseProcedure := ""
	endif

	if ValType(MouseDragProcedure) == "U"
		MouseDragProcedure := ""
	endif

	if ValType(SizeProcedure) == "U"
		SizeProcedure := ""
	endif

	if ValType(ClickProcedure) == "U"
		ClickProcedure := ""
	endif

	if ValType(MouseMoveProcedure) == "U"
		MouseMoveProcedure := ""
	endif

	if ValType(PaintProcedure) == "U"
		PaintProcedure := ""
	endif

	if ValType(GotFocus) == "U"
		GotFocus := ""
	endif

	if ValType(LostFocus) == "U"
		LostFocus := ""
	endif

	if ValType(VirtualHeight) == "U"
		VirtualHeight	:= 0
		vscroll		:= .f.
	Else
		If VirtualHeight <= h
			MsgHMGError("DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )
		EndIf

		vscroll		:= .t.

	endif

	if ValType(VirtualWidth) == "U"
		VirtualWidth	:= 0
		hscroll		:= .f.
	Else
		If VirtualWidth <= w
			MsgHMGError("DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )
		EndIf

		hscroll		:= .t.

	endif

	if Valtype ( aRGB ) == 'U'
		aRGB := { -1 , -1 , -1 }
	EndIf

	_HMG_SYSDATA [ 223 ] := FormName
	_HMG_SYSDATA [ 264 ] := .T.

	UnRegisterWindow( HMG_MakeWindowsClassName ( FormName ) )

   IF ValType ( icon ) == 'U' .AND. ValType ( _HMG_DefaultIconName ) != 'U'
      icon := _HMG_DefaultIconName
   ENDIF

	BrushHandle := RegisterWindow( icon, HMG_MakeWindowsClassName ( FormName ) , aRGB )

	Formhandle = InitWindow( Caption , x, y, w, h, nominimize, nomaximize, nosize, nosysmenu, nocaption , topmost , HMG_MakeWindowsClassName ( FormName ) , ParentHandle , vscroll , hscroll , helpbutton , panel  )

	If _HMG_SYSDATA [ 265 ] = TRUE  .and. Panel == .T.
		aAdd ( _HMG_SYSDATA [ 142 ] , Formhandle )
	EndIf

	if Valtype ( cursor ) != "U"
		SetWindowCursor( Formhandle , cursor )
	EndIf

	if Main
		_HMG_SYSDATA [ 181 ] := Formhandle
	EndIf

	if ValType(NotifyIconName) == "U"
		NotifyIconName := ""
	Else
		ShowNotifyIcon( FormHandle , .T. , LoadTrayIcon(GETINSTANCE(), NotifyIconName ), NotifyIconTooltip )
	endif

	htooltip := InitToolTip ( FormHandle , _HMG_SYSDATA [55] )

   hWnd_ToolTip := TOOLTIP_INITMENU ( FormHandle , _HMG_SYSDATA [55] )

	If Main

		cType := 'A'

	Else

		If	Child == .T.

		        cType := 'C'

		ElseIf	Panel == .T.

			cType := 'P'

		Else

		        cType := 'S'

		EndIf

	EndIf




	k := ascan ( _HMG_SYSDATA [  65 ] , .T. )

	if k > 0

		_HMG_SYSDATA [ 164 ] := k

		Public &mVar. := k

      IF Main
         _HMG_MainFormIndex := k
      ENDIF

		_HMG_SYSDATA [ 66 ]  [k] := FormName
		_HMG_SYSDATA [ 67 ]  [k] := FormHandle
		_HMG_SYSDATA [ 68 ]  [k] := .f.
		_HMG_SYSDATA [ 69 ]  [k] := cType
		_HMG_SYSDATA [ 70 ]  [k] := If ( panel , Parenthandle , 0 )
		_HMG_SYSDATA [ 71 ]  [k] := ReleaseProcedure
		_HMG_SYSDATA [ 72 ]  [k] := InitProcedure
		_HMG_SYSDATA [ 73 ]  [k] := htooltip
		_HMG_SYSDATA [ 74 ]  [k] := 0
		_HMG_SYSDATA [ 75 ]  [k] := MouseDragProcedure
		_HMG_SYSDATA [ 76 ]  [k] := SizeProcedure
		_HMG_SYSDATA [ 77 ]  [k] := ClickProcedure
		_HMG_SYSDATA [ 78 ]  [k] := MouseMoveProcedure
		_HMG_SYSDATA [ 65 ]  [k] := .f.
		_HMG_SYSDATA [ 79 ]  [k] := aRGB
		_HMG_SYSDATA [ 80 ]  [k] := PaintProcedure
		_HMG_SYSDATA [ 81 ]  [k] := noshow
		_HMG_SYSDATA [ 82 ]  [k] := NotifyIconName
		_HMG_SYSDATA [ 83 ]  [k] := NotifyIconToolTip
		_HMG_SYSDATA [ 84 ]  [k] := NotifyIconLeftClick
		_HMG_SYSDATA [ 85 ]  [k] := GotFocus
		_HMG_SYSDATA [ 86 ]  [k] := LostFocus
		_HMG_SYSDATA [ 87 ]  [k] := 0
		_HMG_SYSDATA [ 88 ]  [k] := 0
		_HMG_SYSDATA [ 89 ]  [k] := {}
		_HMG_SYSDATA [ 90 ]  [k] := {}
		_HMG_SYSDATA [ 91 ]  [k] := VirtualHeight
		_HMG_SYSDATA [ 92 ]  [k] := VirtualWidth
		_HMG_SYSDATA [ 93 ]  [k] := .f.
		_HMG_SYSDATA [ 94 ]  [k] := ScrollUp
		_HMG_SYSDATA [ 95 ]  [k] := ScrollDown
		_HMG_SYSDATA [ 96 ]  [k] := ScrollLeft
		_HMG_SYSDATA [ 97 ]  [k] := ScrollRight
		_HMG_SYSDATA [ 98 ]  [k] := HScrollBox
		_HMG_SYSDATA [ 99 ]  [k] := VScrollBox
		_HMG_SYSDATA [ 100 ] [k] := BrushHandle
		_HMG_SYSDATA [ 101 ] [k] := 0
		_HMG_SYSDATA [ 102 ] [k] := {}
		_HMG_SYSDATA [ 103 ] [k] := MaximizeProcedure
		_HMG_SYSDATA [ 104 ] [k] := MinimizeProcedure
		_HMG_SYSDATA [ 105 ] [k] := .Not. NoAutoRelease
		_HMG_SYSDATA [ 106 ] [k] := InteractiveCloseProcedure
		_HMG_SYSDATA [ 107 ] [k] := 0
		_HMG_SYSDATA [ 108 ] [k] := NIL
      _HMG_SYSDATA [ 504 ] [k] := {x, y, w, h}
      _HMG_SYSDATA [ 511 ] [k] := hWnd_ToolTip
      _HMG_SYSDATA [ 512 ] [k] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }

      _HMG_StopWindowEventProcedure  [k] := .F.

	Else

		_HMG_SYSDATA [ 164 ] := HMG_LEN(_HMG_SYSDATA [  66 ]) + 1

      IF Main
         _HMG_MainFormIndex := HMG_LEN(_HMG_SYSDATA [  66 ]) + 1
      ENDIF

		Public &mVar. := HMG_LEN(_HMG_SYSDATA [  66 ]) + 1

		aAdd ( _HMG_SYSDATA [ 66 ]	, FormName )
		aAdd ( _HMG_SYSDATA [ 67 ]	, FormHandle )
		aAdd ( _HMG_SYSDATA [ 68 ]	, .f. )
		aAdd ( _HMG_SYSDATA [ 69 ]	, cType )
		aAdd ( _HMG_SYSDATA [ 70 ]	, If ( panel , Parenthandle , 0 ) )
		aAdd ( _HMG_SYSDATA [ 71 ]	, ReleaseProcedure )
		aAdd ( _HMG_SYSDATA [ 72 ]	, InitProcedure )
		aAdd ( _HMG_SYSDATA [ 73 ]	, htooltip )
		aAdd ( _HMG_SYSDATA [ 74 ]	, 0 )
		aAdd ( _HMG_SYSDATA [ 75 ]	, MouseDragProcedure )
		aAdd ( _HMG_SYSDATA [ 76 ]	, SizeProcedure )
		aAdd ( _HMG_SYSDATA [ 77 ]	, ClickProcedure )
		aAdd ( _HMG_SYSDATA [ 78 ]	, MouseMoveProcedure )
		aAdd ( _HMG_SYSDATA [ 65 ]	, .f. )
		aAdd ( _HMG_SYSDATA [ 79 ]	, aRGB )
		aAdd ( _HMG_SYSDATA [ 80 ]	, PaintProcedure )
		aAdd ( _HMG_SYSDATA [ 81 ]	, noshow )
		aAdd ( _HMG_SYSDATA [ 82 ]	, NotifyIconName 	)
		aAdd ( _HMG_SYSDATA [ 83 ]	, NotifyIconToolTip 	)
		aAdd ( _HMG_SYSDATA [ 84 ]	, NotifyIconLeftClick 	)
		aAdd ( _HMG_SYSDATA [ 85 ]	, GotFocus )
		aAdd ( _HMG_SYSDATA [ 86 ]	, LostFocus )
		aAdd ( _HMG_SYSDATA [ 87 ]	, 0 )
		aAdd ( _HMG_SYSDATA [ 88 ]	, 0 )
		aAdd ( _HMG_SYSDATA [ 89 ]	, {} )
		aAdd ( _HMG_SYSDATA [ 90 ]	, {} )
		aAdd ( _HMG_SYSDATA [ 91 ]	, VirtualHeight )
		aAdd ( _HMG_SYSDATA [ 92 ]	, VirtualWidth )
		aAdd ( _HMG_SYSDATA [ 93 ]	, .f. )
		aAdd ( _HMG_SYSDATA [ 94 ]	, ScrollUp )
		aAdd ( _HMG_SYSDATA [ 95 ]	, ScrollDown )
		aAdd ( _HMG_SYSDATA [ 96 ]	, ScrollLeft )
		aAdd ( _HMG_SYSDATA [ 97 ]	, ScrollRight )
		aAdd ( _HMG_SYSDATA [ 98 ]	, HScrollBox )
		aAdd ( _HMG_SYSDATA [ 99 ]	, VScrollBox )
		aAdd ( _HMG_SYSDATA [ 100 ]	, BrushHandle )
		aAdd ( _HMG_SYSDATA [ 101 ]	, 0 )
		aAdd ( _HMG_SYSDATA [ 102 ]	, {} )
		aAdd ( _HMG_SYSDATA [ 103 ]	, MaximizeProcedure )
		aAdd ( _HMG_SYSDATA [ 104 ]	, MinimizeProcedure )
		aAdd ( _HMG_SYSDATA [ 105 ]	, .Not. NoAutoRelease )
		aAdd ( _HMG_SYSDATA [ 106 ]	, InteractiveCloseProcedure )
		aAdd ( _HMG_SYSDATA [ 107 ]	, 0 )
		aAdd ( _HMG_SYSDATA [ 108 ]	, NIL )
      aAdd ( _HMG_SYSDATA [ 504 ]   , {x, y, w, h})
      aAdd ( _HMG_SYSDATA [ 511 ] , hWnd_ToolTip )
      aAdd ( _HMG_SYSDATA [ 512 ] , { NIL, NIL, NIL, NIL, NIL, NIL, NIL } )

      aAdd (_HMG_StopWindowEventProcedure,  .F.)

	EndIf


	InitDummy(FormHandle)

	If VirtualHeight > 0
		SetScrollRange ( Formhandle , SB_VERT , 0 , VirtualHeight - h , .T. )
	EndIf
	If VirtualWidth > 0
		SetScrollRange ( Formhandle , SB_HORZ , 0 , VirtualWidth - w , .T. )
	EndIf

	if valtype ( _HMG_SYSDATA [56] ) = 'A'
		if HMG_LEN ( _HMG_SYSDATA [56] ) = 3
			SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( _HMG_SYSDATA [56] [1] , _HMG_SYSDATA [56] [2] , _HMG_SYSDATA [56] [3] ), 0)
		endif
	endif

	if valtype ( _HMG_SYSDATA [57] ) = 'A'
		if HMG_LEN ( _HMG_SYSDATA [57] ) = 3
			SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( _HMG_SYSDATA [57] [1] , _HMG_SYSDATA [57] [2] , _HMG_SYSDATA [57] [3] ), 0)
		endif
	endif

   _HMG_SYSDATA [ 512 ] [ GetFormIndex (FormName) ] [ 7 ] := _HMG_SYSDATA [ 55 ]
   SetToolTipCustomDrawForm ( FormName )

Return (FormHandle)
*-----------------------------------------------------------------------------*
Function _DefineModalWindow ( FormName, Caption, x, y, w, h, Parent ,nosize ,nosysmenu, nocaption , StatusBar , StatusText ,InitProcedure, ReleaseProcedure , MouseDragProcedure , SizeProcedure , ClickProcedure , MouseMoveProcedure, aRGB , PaintProcedure , icon , FontName , FontSize , GotFocus , LostFocus , virtualheight , VirtualWidth , scrollleft , scrollright , scrollup , scrolldown  , hscrollbox , vscrollbox , helpbutton , cursor , noshow  , NoAutoRelease  , InteractiveCloseProcedure , visible , autorelease , sizable , sysmenu , titlebar , lLittleTitle )
*-----------------------------------------------------------------------------*
Local i , htooltip , mVar , vscroll , hscroll , BrushHandle , k
Local FormHandle
LOCAL hWnd_ToolTip

* Unused Parameters

StatusBar := Nil
StatusText := Nil


DEFAULT x := GetDesktopRealLeft()
DEFAULT y := GetDesktopRealTop()
DEFAULT w := GetDeskTopRealWidth()
DEFAULT h := GetDeskTopRealHeight()



	if ValType(titlebar) == "L"
		NoCaption := .Not. TitleBar
	endif

	if ValType(sysmenu) == "L"
		NoSysMenu := .Not. sysmenu
	endif



	if ValType(sizable) == "L"
		NoSize := .Not. Sizable
	endif


	if ValType(visible) == "L"
		NoShow := .Not. Visible
	endif


	if ValType(autorelease) == "L"
		NoAutoRelease := .Not. autorelease
	endif


	if ValType(FormName) == "U"
		FormName := _HMG_SYSDATA [ 214 ]
	endif

IF _HMG_MainWindowFirst == .T.
	i := ascan ( _HMG_SYSDATA [ 69  ] , 'A' )
	if i <= 0
		MsgHMGError("Main Window Not Defined. Program Terminated" )
	Endif
ENDIF

	If _IsWindowDefined (FormName)
		MsgHMGError("Window: "+ FormName + " already defined. Program Terminated" )
	endif

	mVar := '_' + FormName

	if ValType(FontName) == "U"
		_HMG_SYSDATA [ 224 ] := ""
	Else
		_HMG_SYSDATA [ 224 ] := FontName
	Endif

	if ValType(FontSize) == "U"
		_HMG_SYSDATA [ 182 ] := 0
	Else
		_HMG_SYSDATA [ 182 ] := FontSize
	Endif

	if ValType(Caption) == "U"
		Caption := ""
	endif

	if ValType(InitProcedure) == "U"
		InitProcedure := ""
	endif

	if ValType(PaintProcedure) == "U"
		PaintProcedure := ""
	endif

	if ValType(ReleaseProcedure) == "U"
		ReleaseProcedure := ""
	endif

	if ValType(MouseDragProcedure) == "U"
		MouseDragProcedure := ""
	endif

	if ValType(SizeProcedure) == "U"
		SizeProcedure := ""
	endif

	if ValType(ClickProcedure) == "U"
		ClickProcedure := ""
	endif

	if ValType(MouseMoveProcedure) == "U"
		MouseMoveProcedure := ""
	endif

	if ValType(GotFocus) == "U"
		GotFocus := ""
	endif

	if ValType(LostFocus) == "U"
		LostFocus := ""
	endif

	if ValType(scrollup) == "U"
		scrollup := ""
	endif
	if ValType(scrolldown) == "U"
		scrolldown := ""
	endif
	if ValType(scrollleft) == "U"
		scrollleft := ""
	endif
	if ValType(scrollright) == "U"
		scrollright := ""
	endif

	if ValType(hscrollbox) == "U"
		hscrollbox := ""
	endif
	if ValType(vscrollbox) == "U"
		vscrollbox := ""
	endif

	if ValType(VirtualHeight) == "U"
		VirtualHeight	:= 0
		vscroll		:= .f.
	Else
		If VirtualHeight <= h
			MsgHMGError("DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )
		EndIf

		vscroll		:= .t.

	endif

	if ValType(VirtualWidth) == "U"
		VirtualWidth	:= 0
		hscroll		:= .f.
	Else
		If VirtualWidth <= w
			MsgHMGError("DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )

		EndIf

		hscroll		:= .t.

	endif

	if Valtype ( aRGB ) == 'U'
		aRGB := { -1 , -1 , -1 }
	EndIf

	If _HMG_SYSDATA [ 109 ] <> 0
		Parent := _HMG_SYSDATA [ 109 ]
	Else
		Parent = _HMG_SYSDATA [ 181 ]
	EndIf

	_HMG_SYSDATA [ 223 ] := FormName
	_HMG_SYSDATA [ 264 ] := .T.

	UnRegisterWindow( HMG_MakeWindowsClassName ( FormName ) )

   IF ValType ( icon ) == 'U' .AND. ValType ( _HMG_DefaultIconName ) != 'U'
      icon := _HMG_DefaultIconName
   ENDIF

   BrushHandle := RegisterWindow( icon, HMG_MakeWindowsClassName ( FormName ) , aRGB )

	Formhandle = InitModalWindow ( Caption , x, y, w, h , Parent ,nosize ,nosysmenu, nocaption , HMG_MakeWindowsClassName ( FormName ) , vscroll , hscroll , helpbutton , lLittleTitle )

	if Valtype ( cursor ) != "U"
		SetWindowCursor( Formhandle , cursor )
	EndIf

	htooltip := InitToolTip ( NIL , _HMG_SYSDATA [55] )

   hWnd_ToolTip := TOOLTIP_INITMENU ( NIL , _HMG_SYSDATA [55] )

	k := ascan ( _HMG_SYSDATA [  65 ] , .T. )

	if k > 0

		Public &mVar. := k

		_HMG_SYSDATA [  66 ]  [k] := FormName
		_HMG_SYSDATA [ 67  ]   [k] :=  FormHandle
		_HMG_SYSDATA [ 68  ]   [k] :=  .f.
		_HMG_SYSDATA [ 69  ]  [k] :=   "M"
		_HMG_SYSDATA [ 70  ]   [k] :=  Parent
		_HMG_SYSDATA [  71 ]   [k] :=  ReleaseProcedure
		_HMG_SYSDATA [ 72  ]   [k] :=  InitProcedure
		_HMG_SYSDATA [ 73  ]   [k] :=  htooltip
		_HMG_SYSDATA [ 74  ]   [k] := 0
		_HMG_SYSDATA [ 75  ]   [k] :=  MouseDragProcedure
		_HMG_SYSDATA [ 76  ]   [k] :=  SizeProcedure
		_HMG_SYSDATA [ 77 ]   [k] :=  ClickProcedure
		_HMG_SYSDATA [ 78 ]   [k] :=  MouseMoveProcedure
		_HMG_SYSDATA [  65 ]   [k] :=  .f.
		_HMG_SYSDATA [ 79 ]  [k] :=  aRGB
		_HMG_SYSDATA [ 80 ]   [k] :=  PaintProcedure
		_HMG_SYSDATA [ 81 ]   [k] :=  noshow
		_HMG_SYSDATA [ 82 ]   [k] :=  ''
		_HMG_SYSDATA [ 83  ]   [k] :=  ''
		_HMG_SYSDATA [ 84 ]   [k] :=  ''
		_HMG_SYSDATA [ 85 ]   [k] :=  GotFocus
		_HMG_SYSDATA [ 86 ]   [k] :=  LostFocus
		_HMG_SYSDATA [ 87 ]   [k] :=  0
		_HMG_SYSDATA [ 88 ]   [k] :=  0
		_HMG_SYSDATA [ 89 ]	  [k] :=  {}
		_HMG_SYSDATA [ 90 ]	  [k] :=  {}
		_HMG_SYSDATA [ 91 ]	  [k] :=  VirtualHeight
		_HMG_SYSDATA [ 92 ]  [k] := 	 VirtualWidth
		_HMG_SYSDATA [ 93 ]  [k] := 	 .f.
		_HMG_SYSDATA [ 94 ]  [k] := 	 ScrollUp
		_HMG_SYSDATA [ 95 ]	  [k] :=  ScrollDown
		_HMG_SYSDATA [ 96 ]	  [k] :=  ScrollLeft
		_HMG_SYSDATA [ 97 ]  [k] := 	ScrollRight
		_HMG_SYSDATA [ 98 ]  [k] := 	 HScrollBox
		_HMG_SYSDATA [ 99 ]	  [k] :=  VScrollBox
		_HMG_SYSDATA [ 100 ]	  [k] :=  BrushHandle
		_HMG_SYSDATA [ 101 ]   [k] := 0
		_HMG_SYSDATA [ 102 ]	  [k] :=  {}
		_HMG_SYSDATA [ 103  ]  [k] := 	 Nil
		_HMG_SYSDATA [ 104  ]  [k] := 	 Nil
		_HMG_SYSDATA [ 105 ] [k] :=  .Not. NoAutoRelease
		_HMG_SYSDATA [ 106 ] [k] :=  InteractiveCloseProcedure
		_HMG_SYSDATA [ 107 ] [k] := 0
		_HMG_SYSDATA [ 108 ] [k] := NIL
      _HMG_SYSDATA [ 504 ] [k] := {x, y, w, h}
      _HMG_SYSDATA [ 511 ] [k] := hWnd_ToolTip
      _HMG_SYSDATA [ 512 ] [k] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }

      _HMG_StopWindowEventProcedure  [k] := .F.

	Else

		Public &mVar. := HMG_LEN(_HMG_SYSDATA [  66 ]) + 1

		aAdd ( _HMG_SYSDATA [  66 ] , FormName )
		aAdd ( _HMG_SYSDATA [ 67  ] , FormHandle )
		aAdd ( _HMG_SYSDATA [ 68  ] , .f. )
		aAdd ( _HMG_SYSDATA [ 69  ] , "M" )
		aAdd ( _HMG_SYSDATA [ 70  ] , Parent )
		aAdd ( _HMG_SYSDATA [  71 ] , ReleaseProcedure )
		aAdd ( _HMG_SYSDATA [ 72  ] , InitProcedure )
		aAdd ( _HMG_SYSDATA [ 73  ] , htooltip )
		aAdd ( _HMG_SYSDATA [ 74  ] , 0 )
		aAdd ( _HMG_SYSDATA [ 75  ] , MouseDragProcedure )
		aAdd ( _HMG_SYSDATA [ 76  ] , SizeProcedure )
		aAdd ( _HMG_SYSDATA [ 77 ] , ClickProcedure )
		aAdd ( _HMG_SYSDATA [ 78 ] , MouseMoveProcedure )
		aAdd ( _HMG_SYSDATA [  65 ], .f. )
		aAdd ( _HMG_SYSDATA [ 79 ], aRGB )
		aAdd ( _HMG_SYSDATA [ 80 ] , PaintProcedure )
		aAdd ( _HMG_SYSDATA [ 81 ] , noshow )
		aAdd ( _HMG_SYSDATA [ 82 ] 		, '' 	)
		aAdd ( _HMG_SYSDATA [ 83  ]		, ''	)
		aAdd ( _HMG_SYSDATA [ 84 ]	, ''	)
		aAdd ( _HMG_SYSDATA [ 85 ]		, GotFocus )
		aAdd ( _HMG_SYSDATA [ 86 ]		, LostFocus )
		aAdd ( _HMG_SYSDATA [ 87 ]		, 0 )
		aAdd ( _HMG_SYSDATA [ 88 ]		, 0 )
		aAdd ( _HMG_SYSDATA [ 89 ]			, {} )
		aAdd ( _HMG_SYSDATA [ 90 ]		, {} )
		aAdd ( _HMG_SYSDATA [ 91 ]		, VirtualHeight )
		aAdd ( _HMG_SYSDATA [ 92 ]		, VirtualWidth )
		aAdd ( _HMG_SYSDATA [ 93 ]			, .f. )
		aAdd ( _HMG_SYSDATA [ 94 ]			, ScrollUp )
		aAdd ( _HMG_SYSDATA [ 95 ]			, ScrollDown )
		aAdd ( _HMG_SYSDATA [ 96 ]			, ScrollLeft )
		aAdd ( _HMG_SYSDATA [ 97 ]		, ScrollRight )
		aAdd ( _HMG_SYSDATA [ 98 ]			, HScrollBox )
		aAdd ( _HMG_SYSDATA [ 99 ]			, VScrollBox )
		aAdd ( _HMG_SYSDATA [ 100 ]		, BrushHandle )
		aAdd ( _HMG_SYSDATA [ 101 ]		, 0 )
		aAdd ( _HMG_SYSDATA [ 102 ]			, {} )
		aAdd ( _HMG_SYSDATA [ 103  ]		, Nil )
		aAdd ( _HMG_SYSDATA [ 104  ]		, Nil )
		aAdd ( _HMG_SYSDATA [ 105 ]		, .Not. NoAutoRelease )
		aAdd ( _HMG_SYSDATA [ 106 ] , InteractiveCloseProcedure )
		aAdd ( _HMG_SYSDATA [ 107 ] , 0 )
		aAdd ( _HMG_SYSDATA [ 108 ] , NIL )
      aAdd ( _HMG_SYSDATA [ 504 ] , {x, y, w, h} )
      aAdd ( _HMG_SYSDATA [ 511 ] , hWnd_ToolTip )
      aAdd ( _HMG_SYSDATA [ 512 ] , { NIL, NIL, NIL, NIL, NIL, NIL, NIL } )

      aAdd (_HMG_StopWindowEventProcedure, .F.)

	EndIf

	InitDummy(FormHandle)

	If VirtualHeight > 0
		SetScrollRange ( Formhandle , SB_VERT , 0 , VirtualHeight - h , .T. )
	EndIf
	If VirtualWidth > 0
		SetScrollRange ( Formhandle , SB_HORZ , 0 , VirtualWidth - w , .T. )
	EndIf

	if valtype ( _HMG_SYSDATA [56] ) = 'A'
		if HMG_LEN ( _HMG_SYSDATA [56] ) = 3
			SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( _HMG_SYSDATA [56] [1] , _HMG_SYSDATA [56] [2] , _HMG_SYSDATA [56] [3] ), 0)
		endif
	endif

	if valtype ( _HMG_SYSDATA [57] ) = 'A'
		if HMG_LEN ( _HMG_SYSDATA [57] ) = 3
			SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( _HMG_SYSDATA [57] [1] , _HMG_SYSDATA [57] [2] , _HMG_SYSDATA [57] [3] ), 0)
		endif
	endif

   _HMG_SYSDATA [ 512 ] [ GetFormIndex (FormName) ] [ 7 ] := _HMG_SYSDATA [ 55 ]
   SetToolTipCustomDrawForm ( FormName )

Return (FormHandle)

*-----------------------------------------------------------------------------*
Function _DefineSplitChildWindow ( FormName , w , h , break , grippertext  , nocaption , title , fontname , fontsize , gotfocus , lostfocus , virtualheight , VirtualWidth , Focused , scrollleft , scrollright , scrollup , scrolldown  , hscrollbox , vscrollbox , cursor , titlebar , PaintProcedure )
*-----------------------------------------------------------------------------*
Local i , htooltip , mVar , ParentForm , hscroll , BrushHandle , k
Local FormHandle , vscroll
LOCAL hWnd_ToolTip

DEFAULT w := GetDeskTopRealWidth()
DEFAULT h := GetDeskTopRealHeight()

	if ValType(titlebar) == "L"
		NoCaption := .Not. TitleBar
	endif

	if ValType(FormName) == "U"
		FormName := _HMG_SYSDATA [ 214 ]
	endif

IF _HMG_MainWindowFirst == .T.
	i := ascan ( _HMG_SYSDATA [ 69  ] , 'A' )
	if i <= 0
		MsgHMGError("Main Window Not Defined. Program Terminated" )
	Endif
ENDIF

	If _IsWindowDefined (FormName)
		MsgHMGError("Window: "+ FormName + " already defined. Program Terminated" )
	endif

	If _HMG_SYSDATA [ 262 ] == .F.
		MsgHMGError("SplitChild Windows Can be Defined Only Inside SplitBox. Program terminated" )
	EndIf

	if ValType(FontName) == "U"
		_HMG_SYSDATA [ 224 ] := ""
	Else
		_HMG_SYSDATA [ 224 ] := FontName
	Endif

	if ValType(FontSize) == "U"
		_HMG_SYSDATA [ 182 ] := 0
	Else
		_HMG_SYSDATA [ 182 ] := FontSize
	Endif

	if ValType(VirtualHeight) == "U"
		VirtualHeight	:= 0
		vscroll		:= .f.
	Else
		If VirtualHeight <= h
			MsgHMGError("DEFINE WINDOW: Virtual Height Must Be Greater Than Height. Program Terminated" )

		EndIf

		vscroll		:= .t.

	endif

	if ValType(VirtualWidth) == "U"
		VirtualWidth	:= 0
		hscroll		:= .f.
	Else
		If VirtualWidth <= w
			MsgHMGError("DEFINE WINDOW: Virtual Width Must Be Greater Than Width. Program Terminated" )

		EndIf

		hscroll		:= .t.

	endif

	_HMG_SYSDATA [ 260 ] := .t.

	ParentForm := _HMG_SYSDATA [ 223 ]

	mVar := '_' + FormName

	_HMG_SYSDATA [ 215 ] := _HMG_SYSDATA [ 223 ]

	_HMG_SYSDATA [ 223 ] := FormName
	_HMG_SYSDATA [ 264 ] := .T.

	UnRegisterWindow( HMG_MakeWindowsClassName ( FormName ) )
	BrushHandle := RegisterSplitChildWindow( "", HMG_MakeWindowsClassName ( FormName ) , {-1,-1,-1} )

	i := GetFormIndex ( ParentForm )

	if i > 0

		Formhandle := InitSplitChildWindow ( w , h , HMG_MakeWindowsClassName ( FormName ) , nocaption , title , 0 , vscroll , hscroll )

		if Valtype ( cursor ) != "U"
			SetWindowCursor( Formhandle , cursor )
		EndIf

		If _HMG_SYSDATA [ 216 ] == 'TOOLBAR' .And. _HMG_SYSDATA [ 258 ] == .F.
			Break := .T.
		EndIf

		AddSplitBoxItem ( FormHandle , _HMG_SYSDATA [ 87 ] [i] , w , break , grippertext ,  ,  , _HMG_SYSDATA [ 258 ] )

		_HMG_SYSDATA [ 216 ]	:= 'SPLITCHILD'

	EndIf

	if ValType(scrollup) == "U"
		scrollup := ""
	endif
	if ValType(scrolldown) == "U"
		scrolldown := ""
	endif
	if ValType(scrollleft) == "U"
		scrollleft := ""
	endif
	if ValType(scrollright) == "U"
		scrollright := ""
	endif

	if ValType(hscrollbox) == "U"
		hscrollbox := ""
	endif
	if ValType(vscrollbox) == "U"
		vscrollbox := ""
	endif

	htooltip := InitToolTip (FormHandle , _HMG_SYSDATA [55]  )

   hWnd_ToolTip := TOOLTIP_INITMENU ( FormHandle , _HMG_SYSDATA [55] )

	k := ascan ( _HMG_SYSDATA [  65 ] , .T. )

	if k > 0

		Public &mVar. := k
		_HMG_SYSDATA [ 171 ] := k

		_HMG_SYSDATA [  66 ]  [k] := FormName
		_HMG_SYSDATA [ 67  ]  [k] :=  FormHandle
		_HMG_SYSDATA [ 68  ]  [k] :=  .f.
		_HMG_SYSDATA [ 69  ]  [k] :=  'X'
		_HMG_SYSDATA [ 70  ]  [k] :=  GetFormHandle(ParentForm)
		_HMG_SYSDATA [  71 ]  [k] :=  ""
		_HMG_SYSDATA [ 72  ]  [k] :=  ""
		_HMG_SYSDATA [ 73  ]  [k] :=  hToolTip
		_HMG_SYSDATA [ 74  ]  [k] :=  0
		_HMG_SYSDATA [ 75  ]  [k] :=  ""
		_HMG_SYSDATA [ 76  ]  [k] :=  ""
		_HMG_SYSDATA [ 77 ]  [k] :=  ""
		_HMG_SYSDATA [ 78 ]  [k] :=  ""
		_HMG_SYSDATA [  65 ]  [k] := .f.
		_HMG_SYSDATA [ 79 ]  [k] := Nil
		_HMG_SYSDATA [ 80 ]  [k] :=  PaintProcedure
		_HMG_SYSDATA [ 81 ]   [k] := .f.
		_HMG_SYSDATA [ 82 ]  [k] :=  ""
		_HMG_SYSDATA [ 83  ]	 [k] :=  ""
		_HMG_SYSDATA [ 84 ]	 [k] :=  ""
		_HMG_SYSDATA [ 85 ]  [k] := gotfocus
		_HMG_SYSDATA [ 86 ] [k] := 	 lostfocus
		_HMG_SYSDATA [ 87 ]	 [k] :=  0
		_HMG_SYSDATA [ 88 ] [k] := 	 0
		_HMG_SYSDATA [ 89 ]	 [k] := 	 {}
		_HMG_SYSDATA [ 90 ] [k] := 	 {}
		_HMG_SYSDATA [ 91 ]	 [k] := 	 VirtualHeight
		_HMG_SYSDATA [ 92 ]	 [k] := 	 VirtualWidth
		_HMG_SYSDATA [ 93 ]	 [k] := 	 Focused
		_HMG_SYSDATA [ 94 ]	 [k] := 	 ScrollUp
		_HMG_SYSDATA [ 95 ]	 [k] := 	 ScrollDown
		_HMG_SYSDATA [ 96 ]	 [k] := 	 ScrollLeft
		_HMG_SYSDATA [ 97 ]	 [k] := 	 ScrollRight
		_HMG_SYSDATA [ 98 ]	 [k] := 	 HScrollBox
		_HMG_SYSDATA [ 99 ]	 [k] := 	 VScrollBox
		_HMG_SYSDATA [ 100 ]	 [k] := 	 BrushHandle
		_HMG_SYSDATA [ 101 ] [k] := 	 0
		_HMG_SYSDATA [ 102 ]	 [k] := 	 {}
		_HMG_SYSDATA [ 103  ] [k] := 	 Nil
		_HMG_SYSDATA [ 104  ] [k] := 	 Nil
		_HMG_SYSDATA [ 105 ] [k] :=  .T.
		_HMG_SYSDATA [ 106 ] [k] :=  ""
		_HMG_SYSDATA [ 107 ] [k] := 0
		_HMG_SYSDATA [ 108 ] [k] := NIL
      _HMG_SYSDATA [ 504 ] [k] := {NIL, NIL, NIL, NIL}
      _HMG_SYSDATA [ 511 ] [k] := hWnd_ToolTip
      _HMG_SYSDATA [ 512 ] [k] := { NIL, NIL, NIL, NIL, NIL, NIL, NIL }

      _HMG_StopWindowEventProcedure  [k] := .F.

	Else

		Public &mVar. := HMG_LEN(_HMG_SYSDATA [  66 ]) + 1
		_HMG_SYSDATA [ 171 ] := HMG_LEN(_HMG_SYSDATA [  66 ]) + 1

		aAdd ( _HMG_SYSDATA [  66 ] , FormName )
		aAdd ( _HMG_SYSDATA [ 67  ] , FormHandle )
		aAdd ( _HMG_SYSDATA [ 68  ] , .f. )
		aAdd ( _HMG_SYSDATA [ 69  ] , 'X' )
		aAdd ( _HMG_SYSDATA [ 70  ] , GetFormHandle(ParentForm) )
		aAdd ( _HMG_SYSDATA [  71 ] , "" )
		aAdd ( _HMG_SYSDATA [ 72  ] , "" )
		aAdd ( _HMG_SYSDATA [ 73  ] , hToolTip )
		aAdd ( _HMG_SYSDATA [ 74  ] , 0 )
		aAdd ( _HMG_SYSDATA [ 75  ] , "" )
		aAdd ( _HMG_SYSDATA [ 76  ] , "" )
		aAdd ( _HMG_SYSDATA [ 77 ] , "" )
		aAdd ( _HMG_SYSDATA [ 78 ] , "" )
		aAdd ( _HMG_SYSDATA [  65 ], .f. )
		aAdd ( _HMG_SYSDATA [ 79 ], Nil )
		aAdd ( _HMG_SYSDATA [ 80 ] , PaintProcedure )
		aAdd ( _HMG_SYSDATA [ 81 ] , .f. )
		aAdd ( _HMG_SYSDATA [ 82 ] 		, "" )
		aAdd ( _HMG_SYSDATA [ 83  ]		, "" )
		aAdd ( _HMG_SYSDATA [ 84 ]	, "" 	)
		aAdd ( _HMG_SYSDATA [ 85 ]		, gotfocus )
		aAdd ( _HMG_SYSDATA [ 86 ]		, lostfocus )
		aAdd ( _HMG_SYSDATA [ 87 ]		, 0 )
		aAdd ( _HMG_SYSDATA [ 88 ]		, 0 )
		aAdd ( _HMG_SYSDATA [ 89 ]			, {} )
		aAdd ( _HMG_SYSDATA [ 90 ]		, {} )
		aAdd ( _HMG_SYSDATA [ 91 ]		, VirtualHeight )
		aAdd ( _HMG_SYSDATA [ 92 ]		, VirtualWidth )
		aAdd ( _HMG_SYSDATA [ 93 ]			, Focused )
		aAdd ( _HMG_SYSDATA [ 94 ]			, ScrollUp )
		aAdd ( _HMG_SYSDATA [ 95 ]			, ScrollDown )
		aAdd ( _HMG_SYSDATA [ 96 ]			, ScrollLeft )
		aAdd ( _HMG_SYSDATA [ 97 ]		, ScrollRight )
		aAdd ( _HMG_SYSDATA [ 98 ]			, HScrollBox )
		aAdd ( _HMG_SYSDATA [ 99 ]			, VScrollBox )
		aAdd ( _HMG_SYSDATA [ 100 ]		, BrushHandle )
		aAdd ( _HMG_SYSDATA [ 101 ]		, 0 )
		aAdd ( _HMG_SYSDATA [ 102 ]			, {} )
		aAdd ( _HMG_SYSDATA [ 103  ]		, Nil )
		aAdd ( _HMG_SYSDATA [ 104  ]		, Nil )
		aAdd ( _HMG_SYSDATA [ 105 ]		, .T. )
		aAdd ( _HMG_SYSDATA [ 106 ] , "" )
		aAdd ( _HMG_SYSDATA [ 107 ] , 0 )
		aAdd ( _HMG_SYSDATA [ 108 ] , NIL )
      aAdd ( _HMG_SYSDATA [ 504 ] , {NIL, NIL, NIL, NIL} )
      aAdd ( _HMG_SYSDATA [ 511 ] , hWnd_ToolTip )
      aAdd ( _HMG_SYSDATA [ 512 ] , { NIL, NIL, NIL, NIL, NIL, NIL, NIL } )

      aAdd (_HMG_StopWindowEventProcedure, .F.)

	EndIf

	InitDummy(FormHandle)

	aAdd ( _HMG_SYSDATA [ 90 ] [ i ] , _HMG_SYSDATA [ 171 ] )

	If VirtualHeight > 0
		SetScrollRange ( Formhandle , SB_VERT , 0 , VirtualHeight - h , .T. )
	EndIf
	If VirtualWidth > 0
		SetScrollRange ( Formhandle , SB_HORZ , 0 , VirtualWidth - w , .T. )
	EndIf

	if valtype ( _HMG_SYSDATA [56] ) = 'A'
		if HMG_LEN ( _HMG_SYSDATA [56] ) = 3
			SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPBKCOLOR, RGB( _HMG_SYSDATA [56] [1] , _HMG_SYSDATA [56] [2] , _HMG_SYSDATA [56] [3] ), 0)
		endif
	endif

	if valtype ( _HMG_SYSDATA [57] ) = 'A'
		if HMG_LEN ( _HMG_SYSDATA [57] ) = 3
			SendMessage( GetFormToolTipHandle( FormName ), TTM_SETTIPTEXTCOLOR, RGB( _HMG_SYSDATA [57] [1] , _HMG_SYSDATA [57] [2] , _HMG_SYSDATA [57] [3] ), 0)
		endif
	endif

   _HMG_SYSDATA [ 512 ] [ GetFormIndex (FormName) ] [ 7 ] := _HMG_SYSDATA [ 55 ]
   SetToolTipCustomDrawForm ( FormName )

Return (FormHandle)



*-----------------------------------------------------------------------------*
Function _SetWindowSizePos ( FormName , row , col , width , height )
*-----------------------------------------------------------------------------*
local hWnd, hParent, nIndex, actpos:={0,0,0,0}

   IF ValType (FormName) == "N"
      hWnd := FormName
   ELSE
      hWnd := GetFormHandle(FormName)
   ENDIF

   GetWindowRect (hWnd, actpos)
   col    := if ( col    == NIL, actpos[1],           col    )
   row    := if ( row    == NIL, actpos[2],           row    )
   width  := if ( width  == NIL, actpos[3]-actpos[1], width  )
   height := if ( height == NIL, actpos[4]-actpos[2], height )

   nIndex := GetFormIndexByHandle (hWnd)
   IF nIndex > 0 .AND. GetFormTypeByIndex ( nIndex ) == "P"   // Panel Window,   ADD (May 2015, Fixed January 2016)
      hParent := _HMG_SYSDATA [ 70 ] [ nIndex ]
      ScreenToClient (hParent, @col, @row)
   ENDIF

   MoveWindow (hWnd, col, row, width, height, .T.)
Return Nil


*-----------------------------------------------------------------------------*
Function _GetWindowSizePos ( FormName )   //   ADD   May 2015
*-----------------------------------------------------------------------------*
local hWnd, hParent, nIndex, actpos:={0,0,0,0}
local row, col, width, height

   IF ValType (FormName) == "N"
      hWnd := FormName
   ELSE
      hWnd := GetFormHandle(FormName)
   ENDIF

   GetWindowRect (hWnd, actpos)
   col    := actpos[1]
   row    := actpos[2]
   width  := actpos[3]-actpos[1]
   height := actpos[4]-actpos[2]

   nIndex := GetFormIndexByHandle (hWnd)
   IF GetFormTypeByIndex ( nIndex ) == "P"   // Panel Window
      hParent := _HMG_SYSDATA [ 70 ] [ nIndex ]
      ScreenToClient (hParent, @col, @row)
   ENDIF

Return {row, col, width, height}



*-----------------------------------------------------------------------------*
Function GetFormIndex (FormName)
*-----------------------------------------------------------------------------*
Local mVar

	mVar := '_' + FormName

Return ( &mVar )
*-----------------------------------------------------------------------------*
Function _SetNotifyIconName ( FormName , IconName )
*-----------------------------------------------------------------------------*
Local i

	i := GetFormIndex ( FormName )

	ChangeNotifyIcon(  _HMG_SYSDATA [ 67  ] [i] , LoadTrayIcon(GETINSTANCE(), IconName ) , _HMG_SYSDATA [ 83  ] [i] )

	_HMG_SYSDATA [ 82 ] [i] := IconName

Return Nil
*-----------------------------------------------------------------------------*
Function _SetNotifyIconTooltip ( FormName , TooltipText )
*-----------------------------------------------------------------------------*
Local i

	i := GetFormIndex ( FormName )

	ChangeNotifyIcon(  _HMG_SYSDATA [ 67  ] [i] , LoadTrayIcon(GETINSTANCE(), _HMG_SYSDATA [ 82 ] [i] ) , TooltipText )

	_HMG_SYSDATA [ 83  ] [i] := TooltipText

Return Nil
*-----------------------------------------------------------------------------*
Function _GetNotifyIconName ( FormName )
*-----------------------------------------------------------------------------*
Local i

	i := GetFormIndex ( FormName )

Return ( _HMG_SYSDATA [ 82 ] [i] )
*-----------------------------------------------------------------------------*
Function _GetNotifyIconTooltip ( FormName )
*-----------------------------------------------------------------------------*
Local i

	i := GetFormIndex ( FormName )

Return ( _HMG_SYSDATA [ 83  ] [i] )

*-----------------------------------------------------------------------------*
Function _DefineSplitBox ( ParentForm, bottom , inverted )
*-----------------------------------------------------------------------------*
Local i,cParentForm,Controlhandle

	if _HMG_SYSDATA [ 264 ] = .T.
		ParentForm := _HMG_SYSDATA [ 223 ]
	endif

	if _HMG_SYSDATA [ 183 ] > 0
		MsgHMGError("SPLITBOX can't be defined inside Tab control. Program terminated" )
	EndIf

	If .Not. _IsWindowDefined (ParentForm)
		MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
	Endif

	If _HMG_SYSDATA [ 260 ] == .T.
		MsgHMGError("SplitBox Can't Be Defined inside SplitChild Windows. Program terminated" )
	EndIf

	If _HMG_SYSDATA [ 262 ] == .T.
		MsgHMGError("SplitBox Controls Can't Be Nested. Program terminated" )
	EndIf

	_HMG_SYSDATA [ 258 ] := Inverted

	_HMG_SYSDATA [ 262 ] := .T.

	_HMG_SYSDATA [ 222 ] := ParentForm

	cParentForm := ParentForm

	ParentForm = GetFormHandle (ParentForm)

	ControlHandle := InitSplitBox ( ParentForm, bottom , inverted )

	i := GetFormIndex ( cParentForm )

	if i > 0
		_HMG_SYSDATA [ 87 ] [i] := ControlHandle
	EndIf

Return Nil
*-----------------------------------------------------------------------------*
Function _EndSplitBox ()
*-----------------------------------------------------------------------------*

	_HMG_SYSDATA [ 216 ]	:= 'TOOLBAR'

	_HMG_SYSDATA [ 262 ] := .F.

Return Nil

*-----------------------------------------------------------------------------*
Function _EndSplitChildWindow ()
*-----------------------------------------------------------------------------*

	_HMG_SYSDATA [ 223 ] := _HMG_SYSDATA [ 215 ]
	_HMG_SYSDATA [ 260 ] := .f.
	_HMG_SYSDATA [ 68  ] [ _HMG_SYSDATA [ 171 ] ] := .t.

Return Nil

*-----------------------------------------------------------------------------*
Function _EndPanelWindow ()
*-----------------------------------------------------------------------------*

	_HMG_SYSDATA [ 223 ] := _HMG_SYSDATA [ 215 ]
	_HMG_SYSDATA [ 240 ] := .f.

Return Nil

*-----------------------------------------------------------------------------*
Function _EndWindow ()
*-----------------------------------------------------------------------------*

	_HMG_SYSDATA [ 344 ] := _HMG_SYSDATA [ 223 ]

	If _HMG_SYSDATA [ 260 ] == .t.
		_EndSplitChildWindow ()

	ElseIf	_HMG_SYSDATA [ 240 ] == .T.
		_EndPanelWindow ()

	Else
		_HMG_SYSDATA [ 264 ] := .F.
		_HMG_SYSDATA [ 223 ] := ""
	EndIf

Return Nil


// Pablo César (January 2015)
*-----------------------------------------------------------------------------*
Function InputBox ( cInputPrompt , cWindowTitle , cDefaultValue , nTimeout , cTimeoutValue , lMultiLine , nWidth )
*-----------------------------------------------------------------------------*
Local RetVal , mo

DEFAULT cInputPrompt   := ""
DEFAULT cWindowTitle   := ""
DEFAULT cDefaultValue  := ""

If !(nWidth=Nil)
   If nWidth<350
      nWidth:=350
   Endif
Endif

RetVal := ''

If ValType (lMultiLine) != 'U'
    If lMultiLine == .T.
        mo := 150
    Else
        mo := 0
    EndIf
Else
    mo := 0
EndIf

DEFINE WINDOW _InputBox                ;
    AT 0,0                             ;
    WIDTH If(nWidth=Nil, 350, nWidth)  ;
    HEIGHT 115 + mo + GetTitleHeight() ;
    TITLE cWindowTitle                 ;
    MODAL                              ;
    NOSIZE                             ;
    FONT 'Arial'                       ;
    SIZE 10

    ON KEY CONTROL+W ACTION ( _HMG_SYSDATA [ 257 ] := .F. , RetVal := _InputBox._TextBox.Value , _InputBox.Release )
    ON KEY ESCAPE ACTION ( _HMG_SYSDATA [ 257 ] := .T. , _InputBox.Release )

    @ 07,10 LABEL _Label    ;
        VALUE cInputPrompt  ;
        WIDTH 280

    If ValType (lMultiLine) != 'U' .and. lMultiLine == .T.
       @ 30,10 EDITBOX _TextBox ;
            VALUE cDefaultValue ;
            HEIGHT 26 + mo      ;
            WIDTH If(nWidth=Nil, 320, nWidth-30)
    else
        @ 30,10 TEXTBOX _TextBox                 ;
            VALUE cDefaultValue                  ;
            HEIGHT 26 + mo                       ;
            WIDTH If(nWidth=Nil, 320, nWidth-30) ;
            ON ENTER ( _HMG_SYSDATA [ 257 ] := .F. , RetVal := _InputBox._TextBox.Value , _InputBox.Release )
    endif

    @ 67+mo,If(nWidth=Nil, 120, (nWidth/2)-10-100) BUTTON _Ok        ;
        CAPTION _hMG_SYSDATA [ 128 ] [8]                             ;
        ACTION ( _HMG_SYSDATA [ 257 ] := .F. , RetVal := _InputBox._TextBox.Value , _InputBox.Release )

    @ 67+mo,If(nWidth=Nil, 230, (nWidth/2)+10) BUTTON _Cancel        ;
        CAPTION _hMG_SYSDATA [ 128 ] [7]                             ;
        ACTION   ( _HMG_SYSDATA [ 257 ] := .T. , _InputBox.Release )

    If ValType (nTimeout) != 'U'
        If ValType (cTimeoutValue) != 'U'
            DEFINE TIMER _InputBox ;
            INTERVAL nTimeout ;
            ACTION  ( RetVal := cTimeoutValue , _InputBox.Release )
        Else
            DEFINE TIMER _InputBox ;
            INTERVAL nTimeout ;
            ACTION _InputBox.Release
        EndIf
    EndIf
END WINDOW
_InputBox._TextBox.SetFocus
CENTER WINDOW _InputBox
ACTIVATE WINDOW _InputBox
Return ( RetVal )


*-----------------------------------------------------------------------------*
Function _SetWindowRgn(name,col,row,w,h,lx)
*-----------------------------------------------------------------------------*
local lhand

      lhand := GetFormHandle ( name )

      c_SetWindowRgn(lhand,col,row,w,h,lx)

Return Nil
*-----------------------------------------------------------------------------*
Function _SetPolyWindowRgn(name,apoints,lx)
*-----------------------------------------------------------------------------*
local lhand, apx:={},apy:={}

      lhand := GetFormHandle ( name )

      aeval(apoints,{|x| aadd(apx,x[1]), aadd(apy,x[2])})

      c_SetPolyWindowRgn(lhand,apx,apy,lx)

Return Nil
*-----------------------------------------------------------------------------*
Procedure _SetNextFocus()
*-----------------------------------------------------------------------------*
Local i , NextControlHandle

	NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , .F. )
	i := ascan ( _HMG_SYSDATA [3] , NextControlHandle )

	if i > 0
		If _HMG_SYSDATA [1] [i] == 'BUTTON'
			setfocus( NextControlHandle )
			SendMessage ( NextControlHandle , BM_SETSTYLE , LOWORD ( BS_DEFPUSHBUTTON ) , 1 )
		Else
			InsertTab()
		EndIf
	Else
		InsertTab()
	EndIf

Return


**********************************************************

Function HMG_ActivateMainWindowFirst ( lOn )
LOCAL lOldMainFirst := _HMG_MainWindowFirst
   IF ValType ( lOn ) == "L"
      _HMG_MainWindowFirst := lOn
   ENDIF
RETURN lOldMainFirst


*-----------------------------------------------------------------------------------------------------*
Function _ActivateWindow ( aForm, lActivateMsgLoop, lNotExitAppAtCloseForm )
*-----------------------------------------------------------------------------------------------------*
__THREAD STATIC IsInstallHook := .F., IsLoopMessageActive := .F.
Local I , z , MainFound := .F.
local nForm := HMG_LEN( aForm )
Local FormName
Local VisibleModalCount := 0
Local VisibleModalName := ''
Local TmpId
Local FormCount := HMG_LEN(_HMG_SYSDATA [  66 ])
Local nLastWindowIndex
Local x

   DEFAULT lActivateMsgLoop            TO .T.
   DEFAULT lNotExitAppAtCloseForm      TO .F.

	If _HMG_SYSDATA [ 232 ] == 'WINDOW_RELEASE'
		MsgHMGError("ACTIVATE WINDOW: activate windows within an 'on release' window procedure is not allowed. Program terminated" )
	EndIf

	If _HMG_SYSDATA [ 264 ] = .T.
		MsgHMGError("ACTIVATE WINDOW: DEFINE WINDOW Structure is not closed. Program terminated" )
	Endif

	If _HMG_SYSDATA [ 232 ] == 'WINDOW_GOTFOCUS'
		MsgHMGError("ACTIVATE WINDOW / Activate(): Not allowed in window's GOTFOCUS event procedure. Program terminated" )
	Endif

	If _HMG_SYSDATA [ 232 ] == 'WINDOW_LOSTFOCUS'
		MsgHMGError("ACTIVATE WINDOW / Activate(): Not allowed in window's LOSTFOCUS event procedure. Program terminated" )
	Endif

	* Look For Main Window

	For z := 1 to nForm
		FormName := aForm [ z ]
		i := GetFormIndex (FormName)
		if _HMG_SYSDATA [ 69  ] [i] == 'A'
			MainFound := .T.
			Exit
		EndIf
	Next z

	// Main Check

   // Dr. Claudio Soto (August 2013)
   IF _HMG_MainWindowFirst == .T.
      If _HMG_SYSDATA [ 263 ] == .F.   // _HMG_IsMainFormActive
         If MainFound == .F.
            MsgHMGError("ACTIVATE WINDOW: Main Window Must be Activated In First ACTIVATE WINDOW Command. Program terminated" )
         EndIf
      Else
         If MainFound == .T.
            MsgHMGError("ACTIVATE WINDOW: Main Window Already Active. Program terminated" )
         EndIf
      EndIf
   ENDIF

   // Dr. Claudio Soto (July 2013)
   IF IsInstallHook == .F.
      IF HMG_HOOK_INSTALL() == .F.
         MsgHMGError("Error in the Installation of the Hooks that process the Keyboard Events")
      ENDIF
      IsInstallHook := .T.
   ENDIF


   nLastWindowIndex := GetFormIndex( aForm [nForm] )

	// Set Main Active Public Flag

	If MainFound == .T.
		_HMG_SYSDATA [ 263 ] := .T.

		* Create Wait Window, add to form array and increment form counter

		InitWaitWindow()

		aadd ( aForm , '_HMG_CHILDWAITWINDOW'   )

		nForm+= 1

	EndIf

	If nForm > 1

		If _HMG_SYSDATA [ 271 ]
			MsgHMGError("Multiple Activation can be used when a modal window is active. Program Terminated" )
		Endif

		TmpId := _GenActivateId(nForm)

		For z := 1 to nForm

			FormName := aForm[ z ]

			If .Not. _IsWindowDefined (Formname)
				MsgHMGError("Window: "+ FormName + " is not defined. Program terminated" )
			Endif

			If _IsWindowActive (FormName)
				MsgHMGError("Window: "+ FormName + " already active. Program terminated" )
			Endif

			If GetWindowType ( FormName ) == 'P'
				MsgHMGError("Panel Windows can't be explicity activated (They are activated via its parent). Program terminated" )
			EndIf

			i := GetFormIndex ( FormName )

			for x := 1 to FormCount

			        if _HMG_SYSDATA [ 69 ] [ x ] == 'P' .and. _HMG_SYSDATA [ 70 ] [ x ] == _HMG_SYSDATA [ 67 ] [ i ]

					_ShowWindow ( _HMG_SYSDATA [  66 ] [x] )

					_SetActivationFlag(x)
					_ProcessInitProcedure(x)
					_RefreshDataControls(x)

					If _SetFocusedSplitChild(x) == .f.
						_SetActivationFocus(x)
					endif

				endif

			next x


			* Only One Visible Modal is Allowed

			if _HMG_SYSDATA [ 69  ] [i] == "M" .and. _HMG_SYSDATA [ 81 ] [i] == .F.
				VisibleModalCount++
				VisibleModalName := _HMG_SYSDATA [  66 ] [i]
				if VisibleModalCount > 1
					MsgHMGError("ACTIVATE WINDOW: Only one initially visible modal window allowed. Program terminated" )
				EndIf
			Endif

			* Set Activate Id

			_HMG_SYSDATA [ 107 ] [i] := TmpId

			* If NOSHOW Is Not Specified, Show The Window.

			If _HMG_SYSDATA [ 81 ] [i] == .F.
        	        	ShowWindow( _HMG_SYSDATA [ 67  ] [i] )
			EndIf

			_SetActivationFlag(i)
			_ProcessInitProcedure(i)
			_RefreshDataControls(i)

		Next z

		* If Specified, Execute Show Method For Visible Modal
		* If Not, Process Focus For Last Window In The List

		If VisibleModalCount == 1
			_ShowWindow ( VisibleModalName )
		Else
			If _SetFocusedSplitChild(nLastWindowIndex) == .f.
				_SetActivationFocus(nLastWindowIndex)
			Endif

		EndIf

	Else

		FormName := aForm[ 1 ]

		If .Not. _IsWindowDefined (Formname)
			MsgHMGError("Window: "+ FormName + " is not defined. Program terminated" )
		Endif

		If _IsWindowActive (FormName)
			MsgHMGError("Window: "+ FormName + " already active. Program terminated" )
		Endif

		If GetWindowType ( FormName ) == 'P'
			MsgHMGError("Panel Windows can't be explicity activated (They are activated via its parent). Program terminated" )
		EndIf

		i := GetFormIndex ( FormName )

		FormCount := HMG_LEN ( _HMG_SYSDATA [ 67 ] )



		for x := 1 to FormCount

		        if _HMG_SYSDATA [ 69 ] [ x ] == 'P' .and. _HMG_SYSDATA [ 70 ] [ x ] == _HMG_SYSDATA [ 67 ] [ i ]

				_ShowWindow ( _HMG_SYSDATA [  66 ] [x] )

				_SetActivationFlag(x)
				_ProcessInitProcedure(x)
				_RefreshDataControls(x)

				If _SetFocusedSplitChild(x) == .f.
					_SetActivationFocus(x)
				endif

			endif

		next x



		if _HMG_SYSDATA [ 69  ] [i] == "M"

			_ShowWindow ( _HMG_SYSDATA [  66 ] [i] )

			_SetActivationFlag(i)
			_ProcessInitProcedure(i)
			_RefreshDataControls(i)

		Else
			If _HMG_SYSDATA [ 271 ] .AND. lActivateMsgLoop == .T.   // for HMG Debugger (by Dr. Claudio Soto, May 2016)
				MsgHMGError("Non Modal Windows can't be activated when a modal window is active. " + Formname +" Program Terminated" )
			endif

			If _HMG_SYSDATA [ 81 ] [i] == .F.
				ShowWindow( GetFormHandle(FormName) )
			EndIf

			_SetActivationFlag(i)
			_ProcessInitProcedure(i)
			_RefreshDataControls(i)

			If _SetFocusedSplitChild(i) == .f.
				_SetActivationFocus(i)
			endif

		Endif

	Endif


   IF lActivateMsgLoop == .T.                         // for HMG Debugger (by Dr. Claudio Soto, June 2015)
      DoMessageLoop()   // Start The Message Loop
   ENDIF

   IF nForm == 1 .AND. lNotExitAppAtCloseForm == .T.  // for HMG Debugger (by Dr. Claudio Soto, June 2015)
      i := GetFormIndex( FormName )
      _HMG_SYSDATA [ 107 ] [ i ] := _GenActivateId( nForm + 1 )
   ENDIF


Return Nil


*-----------------------------------------------------------------------------*
Function _ActivateAllWindows
*-----------------------------------------------------------------------------*
Local i
Local FormCount := HMG_LEN(_HMG_SYSDATA [  66 ])
Local aForm := {}
Local MainName := ''

	* If Already Active Windows Abort Command

	If ascan ( _HMG_SYSDATA [ 68  ] , .t. ) > 0
		MsgHMGError("ACTIVATE WINDOW ALL: This Command Should Be Used At Application Startup Only. Program terminated" )
	EndIf

	* Force NoShow And NoAutoRelease Styles For Non Main Windows
	* Excepting SplitChild and Panel
	* ( Force AutoRelease And Visible For Main )

	For i := 1 To FormCount

		If _HMG_SYSDATA [  65 ] [i] == .F.

			If	_HMG_SYSDATA [ 69  ] [i] != 'X' ;
				.AND. ;
				_HMG_SYSDATA [ 69  ] [i] != 'P'

				if _HMG_SYSDATA [ 69  ] [i] == 'A'
					_HMG_SYSDATA [ 81 ] [i] := .F.
					_HMG_SYSDATA [ 105 ] [i] := .T.
					MainName := _HMG_SYSDATA [  66 ] [i]
				ELse
					_HMG_SYSDATA [ 81 ] [i] := .T.
					_HMG_SYSDATA [ 105 ] [i] := .F.
					aadd ( aForm , _HMG_SYSDATA [  66 ] [i] )
				EndIf

			EndIf

		EndIf

	Next i

	aadd ( aForm , MainName )

	* Check For Error And Call Activate Window Command

	if HMG_LEN ( aForm ) > 0
		If Empty ( MainName )
			MsgHMGError("ACTIVATE WINDOW ALL: Main Window Not Defined. Program terminated" )
		EndIf
		_ActivateWindow ( aForm )
	Else
		MsgHMGError("ACTIVATE WINDOW ALL: No Windows Defined. Program terminated" )
	EndIf

Return Nil
*------------------------------------------------------------------------------*
Procedure _PushEventInfo
*------------------------------------------------------------------------------*

	aadd ( _HMG_SYSDATA [ 330 ] , { _HMG_SYSDATA [ 194 ] , _HMG_SYSDATA [ 232 ] , _HMG_SYSDATA [ 231 ] , _HMG_SYSDATA [ 203 ] , _HMG_SYSDATA [ 316 ] , _HMG_SYSDATA [ 317 ] } )

Return

*------------------------------------------------------------------------------*
Procedure _PopEventInfo
*------------------------------------------------------------------------------*
Local l

	l := HMG_LEN (_HMG_SYSDATA [ 330 ])

	if l > 0

		_HMG_SYSDATA [ 194 ] 	:= _HMG_SYSDATA [ 330 ] [l] [1]
		_HMG_SYSDATA [ 232 ] 	:= _HMG_SYSDATA [ 330 ] [l] [2]
		_HMG_SYSDATA [ 231 ] 	:= _HMG_SYSDATA [ 330 ] [l] [3]
		_HMG_SYSDATA [ 203 ] 	:= _HMG_SYSDATA [ 330 ] [l] [4]
		_HMG_SYSDATA [ 316 ] 	:= _HMG_SYSDATA [ 330 ] [l] [5]
		_HMG_SYSDATA [ 317 ] 	:= _HMG_SYSDATA [ 330 ] [l] [6]

		asize ( _HMG_SYSDATA [ 330 ] , l-1 )

	Else

		_HMG_SYSDATA [ 203 ] := 0    // _HMG_SYSDATA [ 203 ] -> _HMG_ThisIndex
		_HMG_SYSDATA [ 194 ] := 0    // _HMG_SYSDATA [ 194 ] -> _HMG_ThisFormIndex
		_HMG_SYSDATA [ 231 ] := ''   // _HMG_SYSDATA [ 231 ] -> _HMG_ThisType
		_HMG_SYSDATA [ 232 ] := ''   // _HMG_SYSDATA [ 232 ] -> _HMG_ThisEventType
		_HMG_SYSDATA [ 316 ] := ''   // _HMG_SYSDATA [ 316 ] -> _HMG_ThisFormName
		_HMG_SYSDATA [ 317 ] := ''   // _HMG_SYSDATA [ 317 ] -> _HMG_ThisControlName

	EndIf

Return
*------------------------------------------------------------------------------*
Procedure _RefreshDataControls (i)
*------------------------------------------------------------------------------*
Local SplitIndex
Local x
Local w

	For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 89 ] [i] )

		_Refresh( _HMG_SYSDATA [ 89 ] [i] [x] )

		if _HMG_SYSDATA [1] [ _HMG_SYSDATA [ 89 ] [i] [x] ] == 'COMBO' .Or. _HMG_SYSDATA [1] [ _HMG_SYSDATA [ 89 ] [i] [x] ] == 'BROWSE'
			_SetValue ( '','', _HMG_SYSDATA [  8 ] [ _HMG_SYSDATA [ 89 ] [i] [x] ] , _HMG_SYSDATA [ 89 ] [i] [x] )
		EndIf

	Next x

	if HMG_LEN ( _HMG_SYSDATA [ 90 ] [ i ] ) > 0

		For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 90 ] [ i ] )
			SplitIndex := _HMG_SYSDATA [ 90 ] [i] [x]
			For w := 1 To HMG_LEN ( _HMG_SYSDATA [ 89 ] [SplitIndex] )
				_Refresh( _HMG_SYSDATA [ 89 ] [SplitIndex] [w] )
				if _HMG_SYSDATA [1] [ _HMG_SYSDATA [ 89 ] [SplitIndex] [w] ] == 'COMBO' .Or. _HMG_SYSDATA [1] [ _HMG_SYSDATA [ 89 ] [SplitIndex] [w] ] == 'BROWSE'
					_SetValue ( '','', _HMG_SYSDATA [  8 ] [ _HMG_SYSDATA [ 89 ] [SplitIndex] [w] ] , _HMG_SYSDATA [ 89 ] [SplitIndex] [w] )
				EndIf
			Next w
		next x

	endif

Return
*------------------------------------------------------------------------------*
Procedure _SetActivationFlag(i)
*------------------------------------------------------------------------------*
Local x
   _HMG_SYSDATA [ 68  ] [i] = .t.
   For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 90 ] [ i ] )
      _HMG_SYSDATA [ 68  ] [ _HMG_SYSDATA [ 90 ] [i] [x] ] := .t.
   Next x
Return
*------------------------------------------------------------------------------*
Procedure _ProcessInitProcedure(i)
*------------------------------------------------------------------------------*
	if ValType(_HMG_SYSDATA [ 72  ] [i])=='B'
		DO EVENTS   // ProcessMessages()
		_PushEventInfo()
		_HMG_SYSDATA [ 232 ] := 'WINDOW_INIT'
		_HMG_SYSDATA [ 194 ] := i
		_HMG_SYSDATA [ 231 ] := 'W'
		_HMG_SYSDATA [ 203 ] := i
		_HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]
		_HMG_SYSDATA [ 317 ] :=  ""
		Eval( _HMG_SYSDATA [ 72  ] [i] )
		_PopEventInfo()
	EndIf
   // added in hmg 3.0.43 - start
   if ValType(_HMG_SYSDATA [ 80 ] [i])=='B' .OR.  HMG_LEN (_HMG_SYSDATA [ 102 ] [i]) > 0
      InvalidateRect (_HMG_SYSDATA [ 67 ] [i], NIL, .F.)
   endif
   // end


Return
*------------------------------------------------------------------------------*
Function _SetFocusedSplitChild(i)
*------------------------------------------------------------------------------*
Local x
Local SplitFocusFlag

	SplitFocusFlag := .f.

	if HMG_LEN ( _HMG_SYSDATA [ 90 ] [ i ] ) > 0

		For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 90 ] [ i ] )
			If _HMG_SYSDATA [ 93 ] [ _HMG_SYSDATA [ 90 ] [i] [x] ] == .t.
				setfocus ( _HMG_SYSDATA [ 67  ] [ _HMG_SYSDATA [ 90 ] [i] [x] ] )
				SplitFocusFlag := .T.
			EndIf
		Next x

	EndIf

Return SplitFocusFlag
*------------------------------------------------------------------------------*
Procedure _SetActivationFocus(i)
*------------------------------------------------------------------------------*
Local Sp
Local x
Local FocusDefined := .f.
local nFocusHandle
Local nControlIndex

		Sp := GetFocus()
		For x := 1 To HMG_LEN (_HMG_SYSDATA [3])
	        	If _HMG_SYSDATA [4] [x] == _HMG_SYSDATA [ 67  ] [i]
				If ValType ( _HMG_SYSDATA [3] [x] ) == 'N'
					If _HMG_SYSDATA [3] [x]	== Sp
						FocusDefined := .T.
						Exit
					EndIf
				ElseIf ValType ( _HMG_SYSDATA [3] [x] ) == 'A'
					If _HMG_SYSDATA [3] [x]	[1] == Sp
						FocusDefined := .T.
						Exit
					EndIf
				EndIf
			EndIf
		Next x

		If FocusDefined == .F.

			nFocusHandle := GetNextDlgTabItem ( _HMG_SYSDATA [ 67  ] [i] , 0 , .F. )

			nControlIndex := ascan (  _HMG_SYSDATA [ 3 ] , nFocusHandle )

			if nControlIndex <> 0

				_SetFocus ( , , nControlIndex )

			else
				SetFocus ( nFocusHandle )

			endif

		EndIf

Return
*------------------------------------------------------------------------------*
Function _GenActivateId(nForm)
*------------------------------------------------------------------------------*
Local TmpStr
Local TmpId

	Do While .t.
		TmpId := Int ( Seconds() * 100 )
		TmpStr := '_HMG_ACTIVATE_' + ALLTRIM( STR ( TmpId ) )
		If ! __MVEXIST ( TmpStr )
			exit
		End If
	EndDo

	__MVPUBLIC ( TmpStr )
	__MVPUT ( TmpStr , nForm )

Return TmpId


*------------------------------------------------------------------------------*
Procedure _hmg_OnHideFocusManagement(i)
*------------------------------------------------------------------------------*
Local FormCount
Local z
Local x

   FormCount := HMG_LEN (_HMG_SYSDATA [ 67 ])

   If _HMG_SYSDATA [ 70 ] [i] == 0   // _HMG_aFormParentHandle
      * Non Modal

      if _HMG_SYSDATA [ 271 ] == .F.   // _HMG_IsModalActive
         For z := 1 to FormCount
            if _HMG_SYSDATA [ 65 ] [z] == .F.   // _HMG_aFormDeleted
               EnableWindow ( _HMG_SYSDATA [ 67 ] [z] )
            EndIf
         Next z
      EndIf

   Else

      * Modal

      x := Ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [ 70  ] [i] )   // if exist FormParentHandle
      if x > 0

         if _HMG_SYSDATA [ 69  ] [x] == "M"   // Modal Window
            * Modal Parent
            _HMG_SYSDATA [ 271 ] := .T.                       // _HMG_IsModalActive
            _HMG_SYSDATA [ 167 ] := _HMG_SYSDATA [ 70 ] [i]   // _HMG_ActiveModalHandle = _HMG_aFormParentHandle
            EnableWindow ( _HMG_SYSDATA [ 70 ] [i] )          // _HMG_aFormParentHandle
            SetFocus( _HMG_SYSDATA [ 70 ] [i])                // _HMG_aFormParentHandle
         Else
            * Non Modal Parent
            _HMG_SYSDATA [ 271 ] := .F.   // _HMG_IsModalActive
            _HMG_SYSDATA [ 167 ] := 0     // _HMG_ActiveModalHandle

            For z := 1 to FormCount
               if _HMG_SYSDATA [ 65 ] [z] == .F.             // _HMG_aFormDeleted
                  EnableWindow ( _HMG_SYSDATA [ 67 ] [z] )   // _HMG_aFormHandles
               EndIf
            Next z
            SetFocus( _HMG_SYSDATA [ 70 ] [i])               // _HMG_aFormParentHandle
         Endif

      Else

         * Missing Parent

         _HMG_SYSDATA [ 271 ] := .F.   // _HMG_IsModalActive
         _HMG_SYSDATA [ 167 ] := 0     // _HMG_ActiveModalHandle
         For z := 1 to FormCount
            if _HMG_SYSDATA [  65 ] [z] == .F.            // _HMG_aFormDeleted
               EnableWindow ( _HMG_SYSDATA [ 67 ] [z] )   // _HMG_aFormHandles
            EndIf
         Next z
         SetFocus( _HMG_SYSDATA [ 181 ] )                 // _HMG_MainHandle

      EndIf

   EndIf

Return


*------------------------------------------------------------------------------*
Function _DoControlEventProcedure ( bBlock , i )
*------------------------------------------------------------------------------*
   IF _HMG_StopControlEventProcedure [i] == .T.   //   ( Dr. Claudio Soto, April 2013 )
      RETURN .F.
   ENDIF

   IF _HMG_SYSDATA [1] [i] <> "HOTKEY"   //  ADD, November 2016
      _HMG_LastActiveControlIndex := i
   ENDIF

   if ValType( bBlock )=='B'
      _PushEventInfo()
      _HMG_SYSDATA [ 194 ] := ascan ( _HMG_SYSDATA [ 67  ] , _HMG_SYSDATA [4][i] )   // FormParentIndex
      _HMG_SYSDATA [ 231 ] := 'C'
      _HMG_SYSDATA [ 203 ] := i                                                      // ControlIndex
      _HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]         // FormParentName
      _HMG_SYSDATA [ 317 ] :=  _HMG_SYSDATA [2] [ _HMG_SYSDATA [ 203 ] ]             // ControlName

      _HMG_SYSDATA [ 293 ] := Eval( bBlock )

      _PopEventInfo()
      RETURN .T.
   EndIf

RETURN .F.


*------------------------------------------------------------------------------*
Function _DoWindowEventProcedure ( bBlock , i , cEventType )
*------------------------------------------------------------------------------*
Local lRetVal := .F.

   IF cEventType == "MOUSEMOVE" .AND. ValType (bBlock) <> "B"
      RETURN .F.
   ENDIF

   IF cEventType <> "TASKBAR"   //  ADD, November 2016
      _HMG_LastActiveFormIndex := i
   ENDIF

   IF _HMG_StopWindowEventProcedure [i] == .T.   //   ( Dr. Claudio Soto, April 2013 )
      RETURN .F.
   ENDIF

	if ValType( bBlock )=='B'

		_PushEventInfo()
		_HMG_SYSDATA [ 194 ] := i
		_HMG_SYSDATA [ 232 ] := cEventType
		_HMG_SYSDATA [ 231 ] := 'W'
		_HMG_SYSDATA [ 203 ] := i
		_HMG_SYSDATA [ 316 ] :=  _HMG_SYSDATA [  66 ] [ _HMG_SYSDATA [ 194 ] ]
		_HMG_SYSDATA [ 317 ] :=  ""
		lRetVal := Eval( bBlock )
		_PopEventInfo()

	EndIf

Return lRetVal


//  by Dr. Claudio Soto, April 2013
*------------------------------------------------------------------------------*
FUNCTION StopWindowEventProcedure (cFormName, lStop)
*------------------------------------------------------------------------------*
LOCAL i
   i := GetFormIndex (cFormName)
   _HMG_StopWindowEventProcedure [i] := IIF (ValType(lStop) <> "L", .F., lStop )
RETURN NIL


//  by Dr. Claudio Soto, April 2013
*------------------------------------------------------------------------------*
FUNCTION StopControlEventProcedure (cControlName, cFormName, lStop)
*------------------------------------------------------------------------------*
LOCAL i
   i := GetControlIndex (cControlName, cFormName)
   _HMG_StopControlEventProcedure [i] := IIF (ValType(lStop) <> "L", .F., lStop )
RETURN NIL



*------------------------------------------------------------------------------*
Function _GetGridCellData (i)
*------------------------------------------------------------------------------*
Local ThisItemRowIndex
Local ThisItemColIndex
Local ThisItemCellRow
Local ThisItemCellCol
Local ThisItemCellWidth
Local ThisItemCellHeight
Local r
Local xs
Local xd
Local aCellData

LOCAL ControlHandle := _HMG_SYSDATA [3] [i]

LOCAL nRowControl := IF (ValType(_HMG_SYSDATA [ 18 ] [i]) == "N", _HMG_SYSDATA [ 18 ] [i], 0)   // check if number --> SplitBox
LOCAL nColControl := IF (ValType(_HMG_SYSDATA [ 19 ] [i]) == "N", _HMG_SYSDATA [ 19 ] [i], 0)   // check if number --> SplitBox

LOCAL nWidthControl := _HMG_SYSDATA [ 20 ] [i]

   r := ListView_HitTest ( ControlHandle , GetCursorRow() - GetWindowRow (ControlHandle)  , GetCursorCol() - GetWindowCol(ControlHandle) )
   If r [2] == 1
      ListView_Scroll ( ControlHandle , -10000  , 0 )
      r := ListView_HitTest ( ControlHandle, GetCursorRow() - GetWindowRow (ControlHandle), GetCursorCol() - GetWindowCol (ControlHandle) )
   Else
      r := LISTVIEW_GETSUBITEMRECT ( ControlHandle , r[1] - 1 , r[2] - 1 )
      xs := ( ( nColControl + r [2] ) + r[3] )  -  ( nColControl + nWidthControl )
      If ListView_GetItemCount (ControlHandle) >  ListViewGetCountPerPage (ControlHandle)
         xd := 20
      Else
         xd := 0
      EndIf

      If xs > -xd
         ListView_Scroll ( ControlHandle , xs + xd , 0 )
      Else
         If r [2] < 0
            ListView_Scroll ( ControlHandle , r[2] , 0 )
         EndIf
      EndIf

      r := ListView_HitTest ( ControlHandle , GetCursorRow() - GetWindowRow (ControlHandle)  , GetCursorCol() - GetWindowCol (ControlHandle) )

   EndIf

   ThisItemRowIndex := r[1]
   ThisItemColIndex := r[2]

   If r [2] == 1
      r := LISTVIEW_GETITEMRECT ( ControlHandle, r[1] - 1 )
   Else
      r := LISTVIEW_GETSUBITEMRECT ( ControlHandle, r[1] - 1 , r[2] - 1 )
   EndIf

   ThisItemCellRow    := nRowControl + r [1]
   ThisItemCellCol    := nColControl + r [2]
   ThisItemCellWidth  := r[3]
   ThisItemCellHeight := r[4]

   aCellData := { ThisItemRowIndex , ThisItemColIndex , ThisItemCellRow , ThisItemCellCol , ThisItemCellWidth , ThisItemCellHeight }

Return aCellData
*------------------------------------------------------------------------------*
Function IsXPThemeActive()
*------------------------------------------------------------------------------*
local uResult

	If _HMG_SYSDATA [ 250 ]

		uResult := CallDll32 ( "IsThemeActive" , "UXTHEME.DLL" , 0 )

		if uResult != 0
			uResult := .T.
		Else
			uResult := .F.
		EndIf

	Else

		uResult := .F.

	EndIf

return uResult

*------------------------------------------------------------------------------*
Procedure InstallEventHandler ( cProcedure )
*------------------------------------------------------------------------------*

	aadd ( _HMG_SYSDATA [ 60 ] , ALLTRIM ( HMG_UPPER ( cProcedure ) ) )

Return

*------------------------------------------------------------------------------*
Procedure InstallPropertyHandler ( cPropertyName , cSetProcedure , cGetProcedure )
*------------------------------------------------------------------------------*

	aadd ( _HMG_SYSDATA [ 61 ] , { ALLTRIM ( HMG_UPPER ( cPropertyName ) ) , ALLTRIM ( HMG_UPPER ( cSetProcedure ) ) , ALLTRIM ( HMG_UPPER ( cGetProcedure ) ) } )

Return

*------------------------------------------------------------------------------*
Procedure InstallMethodHandler ( cEventName , cMethodProcedure )
*------------------------------------------------------------------------------*

	aadd ( _HMG_SYSDATA [ 62 ] , { ALLTRIM ( HMG_UPPER ( cEventName ) ) , ALLTRIM ( HMG_UPPER ( cMethodProcedure ) ) } )

Return


*------------------------------------------------------------------------------*
FUNCTION SAVEWINDOW ( cWindowName , cFileName , nRow , nCol , nWidth , nHeight )
*------------------------------------------------------------------------------*
LOCAL hBitmap
   hBitmap := BT_BitmapCaptureClientArea (cWindowName, nRow, nCol, nWidth, nHeight)
   IF hBitmap <> 0
      DEFAULT cFileName TO cWindowName + '.BMP'
      BT_BitmapSaveFile (hBitmap, cFileName)
      BT_BitmapRelease (hBitmap)
   ENDIF
RETURN NIL


*------------------------------------------------------------------------------*
FUNCTION PRINTWINDOW ( cWindowName , lPreview , ldialog , nRow , nCol , nWidth , nHeight )
*------------------------------------------------------------------------------*
LOCAL lSuccess
LOCAL TempName
LOCAL W
LOCAL H
LOCAL HO
LOCAL VO
local bw , bh , r , tw , th
Local ntop , nleft , nbottom , nright

	if	valtype ( nRow ) = 'U' ;
		.or. ;
		valtype ( nCol ) = 'U' ;
		.or. ;
		valtype ( nWidth ) = 'U' ;
		.or. ;
		valtype ( nHeight ) = 'U'

		ntop	:= -1
		nleft	:= -1
		nbottom	:= -1
		nright	:= -1

	else

		ntop	:= nRow
		nleft	:= nCol
		nbottom	:= nHeight + nRow
		nright	:= nWidth + nCol

	endif

	if ValType ( lDialog ) = 'U'
		lDialog	:= .F.
	endif

	if ValType ( lPreview ) = 'U'
		lPreview := .F.
	endif

	if lDialog

		IF lPreview
			SELECT PRINTER DIALOG TO lSuccess PREVIEW
		ELSE
			SELECT PRINTER DIALOG TO lSuccess
		ENDIF

		IF ! lSuccess
			RETURN NIL
		ENDIF

	else

		IF lPreview
			SELECT PRINTER DEFAULT TO lSuccess PREVIEW
		ELSE
			SELECT PRINTER DEFAULT TO lSuccess
		ENDIF

		IF ! lSuccess
			MSGHMGERROR ( "Can't Init Printer" )
			RETURN NIL
		ENDIF

	endif

	IF ! _IsWIndowDefined ( cWindowName )
		MSGHMGERROR ( 'Window Not Defined' )
		RETURN NIL
	ENDIF

	TempName := GetTempFolder() + '_hmg_printwindow_' + ALLTRIM(Str(int(Seconds()*100))) + '.BMP'

   SAVEWINDOW ( cWindowName , TempName , nRow , nCol , nWidth , nHeight )

	HO := GETPRINTABLEAREAHORIZONTALOFFSET()
	VO := GETPRINTABLEAREAVERTICALOFFSET()

	W := GETPRINTABLEAREAWIDTH() - 10 - ( HO * 2 )
	H := GETPRINTABLEAREAHEIGHT() - 10 - ( VO * 2 )

	if ntop = -1

		bw := GetProperty ( cWindowName , 'Width' )
		bh := GetProperty ( cWindowName , 'Height' ) - GetTitleHeight ( GetFormHandle (cWindowName) )

	else

		bw := nright - nleft
		bh := nbottom - ntop

	endif


	r := bw / bh

	tw := 0
	th := 0

	do while .t.

		tw ++
		th := tw / r

		if tw > w .or. th > h
			exit
		endif

	enddo
/*
	wdif := w - tw    //  Variable 'WDIF' is assigned but not used in function

	if wdif > 0
		dc := wdif / 2  //  'DC' is assigned but not used in function
	else
		dc := 0         //  'DC' is assigned but not used in function
	endif

	hdif := h - th    // Variable 'HDIF' is assigned but not used in function

	if hdif > 0
		dr := hdif / 2  // 'DR' is assigned but not used in function
	else
		dr := 0         // 'DR' is assigned but not used in function
	endif
*/

	START PRINTDOC

		START PRINTPAGE

			@ VO + 10 + ( ( h - th ) / 2 ) , HO + 10 + ( ( w - tw ) / 2 ) PRINT IMAGE TempName WIDTH tW HEIGHT tH

		END PRINTPAGE

	END PRINTDOC

   DO EVENTS

   FErase( TempName )

RETURN NIL



*------------------------------------------------------------------------------*
Function IsAppThemed()
*------------------------------------------------------------------------------*
local uResult
Local nVersion

	nVersion := WINMAJORVERSIONNUMBER() + ( WINMINORVERSIONNUMBER() / 10 )

	If nVersion >= 5.1

//		uResult := CallDll32 ( "IsAppThemed" , "UXTHEME.DLL", 0  )
		uResult := CallDll32 ( "IsAppThemed" , "UXTHEME.DLL"  )

		if uResult != 0
			uResult := .T.
		Else
			uResult := .F.
		EndIf

	Else

		uResult := .F.

	EndIf

return uResult


*------------------------------------------------------------------------------*
Function OpenThemeData( hwnd , pszClassList )
*------------------------------------------------------------------------------*
local uResult := CallDll32 ( "OpenThemeData" , "UXTHEME.DLL" , hwnd , pszClassList )
return uResult

*------------------------------------------------------------------------------*
Function CloseThemeData( hTheme )
*------------------------------------------------------------------------------*
local uResult := CallDll32 ( "CloseThemeData" , "UXTHEME.DLL" , hTheme )
return uResult

*------------------------------------------------------------------------------*
Function DrawThemeBackground( hTheme , hdc , iPartId , iStateId , pRect , pClipRect )
*------------------------------------------------------------------------------*
local uResult := CallDll32 ( "DrawThemeBackground" , "UXTHEME.DLL" , hTheme , hdc , iPartId , iStateId , pRect , pClipRect )
return uResult



*----------------------------------------------------------------*
Procedure VirtualChildControlFocusProcess( nControlHandle , nWindowHandle )
*----------------------------------------------------------------*
Local x
Local nWindowVirtualWidth
Local nWindowVirtualHeight
Local nWindowHeight			:= 0
Local nWindowWidth			:= 0
Local nControlHeight			:= 0
Local nControlWidth			:= 0
Local nControlRow			:= 0
Local nControlCol			:= 0
Local nHorizontalScrollBoxPos
Local nVerticalScrollBoxPos
Local nHorizontalScrollBarRangeMax
Local nVerticalScrollBarRangeMax
Local nVisibleAreaFromRow
Local nVisibleAreaFromCol
Local nVisibleAreaToRow
Local nVisibleAreaToCol
Local nNewScrollBarPos

	IF _HMG_SYSDATA [ 346 ] == .F.
		Return
	ENDIF

	* Get Window Width / Height / Virtual Width / Virtual Height

        For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 67 ] )

		If _HMG_SYSDATA [ 67 ] [X] == nWindowHandle

			nWindowVirtualHeight	:= _HMG_SYSDATA [ 91 ] [x]
			nWindowVirtualWidth	:= _HMG_SYSDATA [ 92 ] [x]

			If 	nWindowVirtualHeight == 0	;
				.And. 				;
				nWindowVirtualWidth == 0

				// Return .T.   // REMOVE
             Return
			Else

				nWindowHeight	:= GetWindowHeight ( nWindowHandle )
				nWindowWidth	:= GetWindowWidth ( nWindowHandle )

				Exit

			EndIf

		EndIf

	Next x

	* Get Control Row / Col / Width / Height

        For x := 1 To HMG_LEN ( _HMG_SYSDATA [ 3 ] )

		If VALTYPE ( _HMG_SYSDATA [ 3 ] [x] ) == 'N' ;
			.And. ;
			VALTYPE ( nControlHandle ) == 'N'

			If _HMG_SYSDATA [ 3 ] [x] == nControlHandle

				nControlHeight	:= _HMG_SYSDATA [ 21 ] [ x ]
				nControlWidth	:= _HMG_SYSDATA [ 20 ] [ x ]
				nControlRow	:= _HMG_SYSDATA [ 18 ] [ x ]
				nControlCol	:= _HMG_SYSDATA [ 19 ] [ x ]

				Exit

			EndIf


		ElseIf	VALTYPE ( _HMG_SYSDATA [ 3 ] [x] ) == 'A' ;
			.And. ;
			VALTYPE ( nControlHandle ) == 'N'

			If aScan ( _HMG_SYSDATA [ 3 ] [x] , nControlHandle ) > 0

				nControlHeight	:= _HMG_SYSDATA [ 21 ] [ x ]
				nControlWidth	:= _HMG_SYSDATA [ 20 ] [ x ]
				nControlRow	:= _HMG_SYSDATA [ 18 ] [ x ]
				nControlCol	:= _HMG_SYSDATA [ 19 ] [ x ]

				Exit

			EndIf

		EndIf

	Next x

	* Get hScrollBox Position / vScrollBox Position

        nHorizontalScrollBoxPos	:= GetScrollPos ( nWindowHandle , SB_HORZ )
        nVerticalScrollBoxPos	:= GetScrollPos ( nWindowHandle , SB_VERT )

	* Get hScrollBar Maximun Range / vScrollBar Maximun Range

        nHorizontalScrollBarRangeMax	:= GetScrollRangeMax( nWindowHandle , SB_HORZ )
        nVerticalScrollBarRangeMax	:= GetScrollRangeMax( nWindowHandle , SB_VERT )

        * Calculate Current Visible Area

	nVisibleAreaFromRow	:= nVerticalScrollBoxPos
	nVisibleAreaFromCol	:= nHorizontalScrollBoxPos

	nVisibleAreaToRow	:= nVisibleAreaFromRow + nWindowHeight - 50
	nVisibleAreaToCol	:= nVisibleAreaFromCol + nWindowWidth - 10

	* Determine if Control Getting the Focus is out of Visible
	* Area. If So, scroll The Window.

	* Control is too LoW To be Visible

	If nControlRow + nControlHeight > nVisibleAreaToRow

		nNewScrollBarPos := nControlRow + nControlHeight - nWindowHeight + 100

		If nNewScrollBarPos > nVerticalScrollBarRangeMax
			nNewScrollBarPos := nVerticalScrollBarRangeMax
		EndIf

		_HMG_PRINTER_SETVSCROLLVALUE( nWindowHandle , nNewScrollBarPos )

	Else

		* Control is too high To be Visible

		If nControlRow + nControlHeight < nVisibleAreaFromRow

			nNewScrollBarPos := nControlRow - nWindowHeight - 100

			If nNewScrollBarPos < 0
				nNewScrollBarPos := 0
			EndIf

			_HMG_PRINTER_SETVSCROLLVALUE( nWindowHandle , nNewScrollBarPos )

		EndIf

	EndIf

	* Control Is Too RIGHT To Be Visible

	If nControlCol + nControlWidth > nVisibleAreaToCol

		nNewScrollBarPos := nControlCol + nControlWidth - nWindowWidth + 100

		If nNewScrollBarPos > nHorizontalScrollBarRangeMax
			nNewScrollBarPos := nHorizontalScrollBarRangeMax
		EndIf

		_HMG_PRINTER_SETHSCROLLVALUE( nWindowHandle , nNewScrollBarPos )

	Else

		* Control Is Too LEFT To Be Visible

		If nControlCol + nControlWidth < nVisibleAreaFromCol

			nNewScrollBarPos := nControlCol - nWindowWidth - 100

			If nNewScrollBarPos < 0
				nNewScrollBarPos := 0
			EndIf

			_HMG_PRINTER_SETHSCROLLVALUE( nWindowHandle , nNewScrollBarPos )


		EndIf

	EndIf

Return

*------------------------------------------------------------------------------*
Function InitWaitWindow()
*------------------------------------------------------------------------------*

	DEFINE WINDOW _HMG_CHILDWAITWINDOW ;
		AT	0,0	;
		WIDTH	500	;
		HEIGHT	40	;
		TITLE	''	;
		CHILD		;
		NOSHOW		;
		NOSYSMENU	;
		NOCAPTION

		DEFINE LABEL Message
			ROW		5
			COL		10
			WIDTH		480
			HEIGHT		25
			VALUE		''
			CENTERALIGN	.T.
		END LABEL

	END WINDOW

	_HMG_CHILDWAITWINDOW.CENTER

Return Nil

*------------------------------------------------------------------------------*
Function ShowWaitWindow( cMessage )
*------------------------------------------------------------------------------*

	_HMG_CHILDWAITWINDOW.MESSAGE.VALUE := cMessage

	_HMG_CHILDWAITWINDOW.SHOW

Return Nil

*------------------------------------------------------------------------------*
Function ShowWaitWindowModal( cMessage )
*------------------------------------------------------------------------------*
Local lExit, i

	lExit := .F.

	_HMG_CHILDWAITWINDOW.MESSAGE.VALUE := cMessage

	_HMG_CHILDWAITWINDOW.SHOW

	For i := 1 To 255
		GetAsyncKeyState(i)
	Next i

	Do While .Not. lExit
		For i := 1 To 255
			If GetAsyncKeyState(i) <> 0
				lExit := .T.
				Exit
			EndIf
		Next i
	EndDo

	_HMG_CHILDWAITWINDOW.HIDE

Return Nil

*------------------------------------------------------------------------------*
Function HideWaitWindow()
*------------------------------------------------------------------------------*

	_HMG_CHILDWAITWINDOW.HIDE

Return Nil

*------------------------------------------------------------------------------*
Function WaitWindow ( cMessage , lNoWait )
*------------------------------------------------------------------------------*

	if PCount() > 0

		If ValType ( lNoWait ) == 'L'

			If	lNoWait == .T.

				ShowWaitWindow( cMessage )

			Else

				ShowWaitWindowModal( cMessage )

			EndIf

		Else

			ShowWaitWindowModal( cMessage )

		EndIf

	Else

		HideWaitWindow()

	EndIf

Return Nil



*-----------------------------------------------------------------------------*
Function GetWindowDataByIndex (k)
*-----------------------------------------------------------------------------*
LOCAL aWinData := {}
      AADD ( aWinData, _HMG_SYSDATA [ 66 ]  [k] )   // FormName
      AADD ( aWinData, _HMG_SYSDATA [ 67 ]  [k] )   // FormHandle
      AADD ( aWinData, _HMG_SYSDATA [ 68 ]  [k] )   // .f.
      AADD ( aWinData, _HMG_SYSDATA [ 69 ]  [k] )   // cType
      AADD ( aWinData, _HMG_SYSDATA [ 70 ]  [k] )   // If ( panel , Parenthandle , 0 )
      AADD ( aWinData, _HMG_SYSDATA [ 71 ]  [k] )   // ReleaseProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 72 ]  [k] )   // InitProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 73 ]  [k] )   // htooltip
      AADD ( aWinData, _HMG_SYSDATA [ 74 ]  [k] )   // 0
      AADD ( aWinData, _HMG_SYSDATA [ 75 ]  [k] )   // MouseDragProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 76 ]  [k] )   // SizeProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 77 ]  [k] )   // ClickProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 78 ]  [k] )   // MouseMoveProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 65 ]  [k] )   // .f.
      AADD ( aWinData, _HMG_SYSDATA [ 79 ]  [k] )   // aRGB
      AADD ( aWinData, _HMG_SYSDATA [ 80 ]  [k] )   // PaintProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 81 ]  [k] )   // noshow
      AADD ( aWinData, _HMG_SYSDATA [ 82 ]  [k] )   // NotifyIconName
      AADD ( aWinData, _HMG_SYSDATA [ 83 ]  [k] )   // NotifyIconToolTip
      AADD ( aWinData, _HMG_SYSDATA [ 84 ]  [k] )   // NotifyIconLeftClick
      AADD ( aWinData, _HMG_SYSDATA [ 85 ]  [k] )   // GotFocus
      AADD ( aWinData, _HMG_SYSDATA [ 86 ]  [k] )   // LostFocus
      AADD ( aWinData, _HMG_SYSDATA [ 87 ]  [k] )   // 0
      AADD ( aWinData, _HMG_SYSDATA [ 88 ]  [k] )   // 0
      AADD ( aWinData, _HMG_SYSDATA [ 89 ]  [k] )   // {}
      AADD ( aWinData, _HMG_SYSDATA [ 90 ]  [k] )   // {}
      AADD ( aWinData, _HMG_SYSDATA [ 91 ]  [k] )   // VirtualHeight
      AADD ( aWinData, _HMG_SYSDATA [ 92 ]  [k] )   // VirtualWidth
      AADD ( aWinData, _HMG_SYSDATA [ 93 ]  [k] )   // .f.
      AADD ( aWinData, _HMG_SYSDATA [ 94 ]  [k] )   // ScrollUp
      AADD ( aWinData, _HMG_SYSDATA [ 95 ]  [k] )   // ScrollDown
      AADD ( aWinData, _HMG_SYSDATA [ 96 ]  [k] )   // ScrollLeft
      AADD ( aWinData, _HMG_SYSDATA [ 97 ]  [k] )   // ScrollRight
      AADD ( aWinData, _HMG_SYSDATA [ 98 ]  [k] )   // HScrollBox
      AADD ( aWinData, _HMG_SYSDATA [ 99 ]  [k] )   // VScrollBox
      AADD ( aWinData, _HMG_SYSDATA [ 100 ] [k] )   // BrushHandle
      AADD ( aWinData, _HMG_SYSDATA [ 101 ] [k] )   // 0
      AADD ( aWinData, _HMG_SYSDATA [ 102 ] [k] )   // {}
      AADD ( aWinData, _HMG_SYSDATA [ 103 ] [k] )   // MaximizeProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 104 ] [k] )   // MinimizeProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 105 ] [k] )   // .Not. NoAutoRelease
      AADD ( aWinData, _HMG_SYSDATA [ 106 ] [k] )   // InteractiveCloseProcedure
      AADD ( aWinData, _HMG_SYSDATA [ 107 ] [k] )   // 0
      AADD ( aWinData, _HMG_SYSDATA [ 108 ] [k] )   // NIL
      AADD ( aWinData, _HMG_SYSDATA [ 504 ] [k] )   // {x, y, w, h}
      AADD ( aWinData, _HMG_SYSDATA [ 511 ] [k] )   // hToolTipMenu
      AADD ( aWinData, _HMG_SYSDATA [ 512 ] [k] )   // ToolTip Form Data

      AADD ( aWinData, _HMG_StopWindowEventProcedure  [k] )   // .F.
Return aWinData
