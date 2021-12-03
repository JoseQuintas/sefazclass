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




//#define _WIN32_IE      0x0500
//#define HB_OS_WIN_32_USED
//#define _WIN32_WINNT   0x0400

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
//#include "hbvm.h"
//#include "hbstack.h"
//#include "hbapiitm.h"
//#include "winreg.h"
#include <tchar.h>


#ifndef LVS_EX_DOUBLEBUFFER
   #define LVS_EX_DOUBLEBUFFER   0x10000
#endif


#include "hbthread.h"
extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c

HIMAGELIST HMG_ImageListLoadFirst (TCHAR *FileName, int cGrow, int Transparent, int *nWidth, int *nHeight);
void HMG_ImageListAdd (HIMAGELIST hImageList, TCHAR *FileName, int Transparent);


HB_FUNC (INITLISTVIEW)
{
   HWND hwnd;
   HWND hWndLV;
   int style = 0;

   INITCOMMONCONTROLSEX  i;

   i.dwSize = sizeof(INITCOMMONCONTROLSEX);
   i.dwICC = ICC_LISTVIEW_CLASSES;
   InitCommonControlsEx(&i);

   hwnd = (HWND) HMG_parnl (1);


   if ( hb_parl (12) )
      style = LVS_SHAREIMAGELISTS | LVS_SHOWSELALWAYS | WS_CHILD | WS_TABSTOP | WS_VISIBLE | LVS_REPORT;
   else
      style = LVS_SHAREIMAGELISTS | LVS_SHOWSELALWAYS | WS_CHILD | WS_TABSTOP | WS_VISIBLE | LVS_REPORT | LVS_SINGLESEL;


   if ( hb_parl (10) )
      style = style | LVS_OWNERDATA ;


   if ( ! hb_parl (13) )
      style = style | LVS_NOCOLUMNHEADER ;


   hWndLV = CreateWindowEx ( WS_EX_CLIENTEDGE , WC_LISTVIEW /*_TEXT("SysListView32")*/ ,
                             _TEXT(""),
                             style,
                             hb_parni(3), hb_parni(4) , hb_parni(5), hb_parni(6) ,
                             hwnd,
                             (HMENU) HMG_parnl (2),
                             GetModuleHandle(NULL),
                             NULL ) ;


   ListView_SetExtendedListViewStyle ( hWndLV, (hb_parl(9) ? 0 : LVS_EX_GRIDLINES) | LVS_EX_FULLROWSELECT /*| LVS_EX_DOUBLEBUFFER*/ | LVS_EX_SUBITEMIMAGES );


   if ( hb_parl (10) )
      ListView_SetItemCount ( hWndLV , hb_parni (11) ) ;

   HMG_retnl ((LONG_PTR) hWndLV );
}


HB_FUNC ( LISTVIEW_SETITEMCOUNT )
{
   HWND hWnd       = (HWND) HMG_parnl (1);
   INT  nItemCount = (INT) hb_parni (2);

   if ( (GetWindowLongPtr (hWnd, GWL_STYLE) & LVS_OWNERDATA) == LVS_OWNERDATA )   // ADD3, July 2015
      ListView_SetItemCountEx (hWnd, nItemCount, LVSICF_NOINVALIDATEALL);
   else
      ListView_SetItemCount (hWnd, nItemCount);
}


HB_FUNC (ADDLISTVIEWBITMAP)
{
   HWND hGrid = (HWND) HMG_parnl (1);
   HIMAGELIST hImageList = NULL;
   TCHAR *FileName;
   int nCount, i;
   int nWidth = 0;

   nCount = hb_parinfa (2, 0);

   if ( nCount > 0 )
   {
      int Transparent = hb_parl(3) ? 0 : 1;

      for (i=1; i <= nCount; i++)
      {
         FileName = (TCHAR*) HMG_parvc (2, i);
         if ( hImageList == NULL )
            hImageList = HMG_ImageListLoadFirst (FileName, nCount, Transparent, &nWidth, NULL);
         else
            HMG_ImageListAdd (hImageList, FileName, Transparent);
      }

      if ( hImageList != NULL )
         SendMessage (hGrid, LVM_SETIMAGELIST, (WPARAM) LVSIL_SMALL, (LPARAM) hImageList);
   }

   hb_retni ((INT) nWidth );
}


HB_FUNC ( LISTVIEW_GETFIRSTITEM )
{
	hb_retni ( ListView_GetNextItem( (HWND) HMG_parnl (1), -1 ,LVNI_ALL | LVNI_SELECTED) + 1);
}



// ADDLISTVIEWITEMS ( hWnd, aItem, iImage, [nRow] )
HB_FUNC ( ADDLISTVIEWITEMS )
{
   HWND hWnd;
   LV_ITEM LI;
   int nColumnCount, nCol, nRow;

   hWnd = (HWND) HMG_parnl (1);
   nColumnCount = hb_parinfa (2, 0);

   if ( HB_ISNIL(4) )
      nRow = ListView_GetItemCount (hWnd);
   else
      nRow = hb_parni (4);

   LI.mask       = LVIF_TEXT | LVIF_IMAGE;
   LI.state      = 0;
   LI.stateMask  = 0;
   LI.iImage     = hb_parni (3);
   LI.iSubItem   = 0;
   LI.iItem      = nRow;
   LI.pszText    = (TCHAR*) HMG_parvc (2, 1);

   ListView_InsertItem (hWnd, &LI);

   for (nCol = 1; nCol < nColumnCount; nCol++)
       ListView_SetItemText (hWnd, nRow, nCol, (TCHAR*) HMG_parvc (2, nCol+1));

}



HB_FUNC (LISTVIEW_SETCURSEL)
{
	ListView_SetItemState( (HWND) HMG_parnl (1), (int) (hb_parni(2)-1) , LVIS_FOCUSED | LVIS_SELECTED , LVIS_FOCUSED | LVIS_SELECTED );
}

HB_FUNC ( LISTVIEWDELETESTRING )
{
	SendMessage( (HWND) HMG_parnl (1), LVM_DELETEITEM , (WPARAM) (hb_parni(2)-1), 0);
}

HB_FUNC ( LISTVIEWRESET )
{
	SendMessage( (HWND) HMG_parnl (1), LVM_DELETEALLITEMS , 0, 0 );
}

HB_FUNC ( LISTVIEWGETMULTISEL )
{

	HWND hwnd = (HWND) HMG_parnl (1);
	int i ;
	int n ;
	int j ;

	n = SendMessage( hwnd, LVM_GETSELECTEDCOUNT , 0, 0);

	hb_reta( n );

	i = -1 ;
	j = 0 ;

	while (1)
	{

		i = ListView_GetNextItem( (HWND) HMG_parnl (1), i ,LVNI_ALL | LVNI_SELECTED) ;

		if ( i == -1 )
		{
			break ;
		}
		else
		{
			j++ ;
		}

		hb_storvni( i + 1 , -1 , j );

	}

}

HB_FUNC ( LISTVIEWSETMULTISEL )
{

   PHB_ITEM wArray;

   HWND hWnd = (HWND) HMG_parnl (1);

   int i;
   int l;
   int n;

   wArray = hb_param( 2, HB_IT_ARRAY );

   l = hb_parinfa( 2, 0 ) - 1;

   n = ListView_GetItemCount( hWnd );

   // CLEAR CURRENT SELECTIONS
   for( i = 0; i < n; i++ )
      ListView_SetItemState( hWnd, i, 0, LVIS_FOCUSED | LVIS_SELECTED );

   // SET NEW SELECTIONS
   for( i = 0; i <= l; i++ )
      ListView_SetItemState( hWnd, hb_arrayGetNI(wArray, i + 1) - 1, LVIS_FOCUSED | LVIS_SELECTED, LVIS_FOCUSED | LVIS_SELECTED );
}


//        ListViewSetItem (hWnd, aItem, nRow)
HB_FUNC ( LISTVIEWSETITEM )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   int  nLen = hb_parinfa (2, 0);
   int  nRow = hb_parni (3) - 1;
   TCHAR *cText;
   int nCol;

   for (nCol=0 ; nCol < nLen ; nCol++ )
   {
      cText = (TCHAR*) HMG_parvc (2 , nCol + 1);
      ListView_SetItemText (hWnd, nRow, nCol, cText);
   }
}


HB_FUNC ( LISTVIEWGETITEM )
{
	TCHAR string [1024];
	HWND hWnd;
	int nCol;
	int nRow;
	int nColumnCount;

	hWnd = (HWND) HMG_parnl (1);

	nRow = hb_parni(2) - 1 ;

	nColumnCount =  hb_parni(3) ;

    hb_reta ( nColumnCount ) ;

	for (nCol = 0 ; nCol <= nColumnCount-1 ; nCol++ )
	{
		ListView_GetItemText (hWnd, nRow, nCol, string, 1024);
		HMG_storvc( string , -1 , nCol+1) ;
	}
}


HB_FUNC ( LISTVIEWGETITEMROW )
{
	POINT point;

	ListView_GetItemPosition ( (HWND) HMG_parnl (1), hb_parni (2) , &point ) ;

	hb_retnl ( point.y ) ;
}

HB_FUNC ( LISTVIEW_GETITEMCOUNT )
{
	hb_retnl ( ListView_GetItemCount ( (HWND) HMG_parnl (1) ) ) ;
}

HB_FUNC ( SETGRIDCOLOMNHEADER )
{

	LV_COLUMN COL;

	COL.mask = LVCF_TEXT ;
	COL.pszText= (TCHAR*)HMG_parc(3) ;

	ListView_SetColumn ( (HWND) HMG_parnl (1), hb_parni ( 2 ) - 1 , &COL );

}

HB_FUNC ( LISTVIEWGETCOUNTPERPAGE )
{
	hb_retnl ( ListView_GetCountPerPage ( (HWND) HMG_parnl (1) ) ) ;
}

HB_FUNC (LISTVIEW_ENSUREVISIBLE)
{
   BOOL lEnablePartialView = HB_ISLOG (3) ? hb_parl (3) : TRUE;
	ListView_EnsureVisible( (HWND) HMG_parnl (1), hb_parni(2)-1 , lEnablePartialView ) ;
}

HB_FUNC ( SETIMAGELISTVIEWITEMS )
{
	LV_ITEM LI;
	HWND h;

	h = (HWND) HMG_parnl (1);

	LI.mask= LVIF_IMAGE ;
	LI.state=0;
	LI.stateMask=0;
        LI.iImage= hb_parni( 3 );
        LI.iSubItem=0;
	LI.iItem=hb_parni(2) - 1 ;

    ListView_SetItem(h,&LI);
}

HB_FUNC ( GETIMAGELISTVIEWITEMS )
{
	LV_ITEM LI;
	HWND h;
        int i;

	h = (HWND) HMG_parnl (1);

	LI.mask= LVIF_IMAGE ;
	LI.state=0;
	LI.stateMask=0;
        LI.iSubItem=0;
	LI.iItem=hb_parni(2) - 1 ;

        ListView_GetItem(h,&LI);
        i =  LI.iImage;

	hb_retni (i);
}

HB_FUNC ( LISTVIEW_GETTOPINDEX )
{
	hb_retnl ( ListView_GetTopIndex ( (HWND) HMG_parnl (1) ) ) ;
}

HB_FUNC ( LISTVIEW_REDRAWITEMS )
{
	hb_retnl ( ListView_RedrawItems ( (HWND) HMG_parnl (1), hb_parni(2) , hb_parni(3) ) ) ;
}

HB_FUNC ( LISTVIEW_HITTEST )
{

	POINT point ;
	LVHITTESTINFO lvhti;

	point.y = hb_parni(2) ;
	point.x = hb_parni(3) ;

	lvhti.pt = point;

	ListView_SubItemHitTest ( (HWND) HMG_parnl (1), &lvhti ) ;

	if(lvhti.flags & LVHT_ONITEM)
	{
		hb_reta( 2 );
		hb_storvni( lvhti.iItem + 1 , -1, 1 );
		hb_storvni( lvhti.iSubItem + 1 , -1, 2 );
	}
	else
	{
		hb_reta( 2 );
		hb_storvni( 0 , -1, 1 );
		hb_storvni( 0 , -1, 2 );
	}
}


#define AVOID_COMPILER_WARNING   // by Dr. Claudio Soto (November 2013)

HB_FUNC ( LISTVIEW_GETSUBITEMRECT )
{
   RECT Rect;
   HWND hWnd     = (HWND) HMG_parnl (1);
   int  iItem    = (int)  hb_parni (2);   // Index of the subitem's parent item
   int  iSubItem = (int)  hb_parni (3);   // The one-based index of the subitem
   int  code     = (int)  LVIR_BOUNDS;    // A portion of the list-view subitem for which to retrieve the bounding rectangle information

   #ifdef AVOID_COMPILER_WARNING
      Rect.top  = iSubItem;
      Rect.left = code;
      SendMessage ( hWnd, LVM_GETSUBITEMRECT, (WPARAM) iItem, (LPARAM) &Rect );
   #else
      ListView_GetSubItemRect ( hWnd, iItem, iSubItem, code, &Rect ) ;
   #endif

   hb_reta( 4 );
   hb_storvni( Rect.top  , -1, 1 );
   hb_storvni( Rect.left  , -1, 2 );
   hb_storvni( Rect.right - Rect.left , -1, 3 );
   hb_storvni( Rect.bottom - Rect.top  , -1, 4 );
}


HB_FUNC ( LISTVIEW_GETITEMRECT )
{
   RECT Rect ;
   HWND hWnd = (HWND) HMG_parnl (1);
   int  i    = (int)  hb_parni (2);   // The index of the list-view item
   int  code = (int)  LVIR_LABEL;     // The portion of the list-view item from which to retrieve the bounding rectangle

   #ifdef AVOID_COMPILER_WARNING
      Rect.left = code;
      SendMessage ( hWnd, LVM_GETITEMRECT, (WPARAM) i, (LPARAM) &Rect );
   #else
      ListView_GetItemRect ( hWnd, i, &Rect, code );
   #endif

   hb_reta( 4 );
   hb_storvni( Rect.top  , -1, 1 );
   hb_storvni( Rect.left  , -1, 2 );
   hb_storvni( Rect.right - Rect.left , -1, 3 );
   hb_storvni( Rect.bottom - Rect.top  , -1, 4 );
}


HB_FUNC ( LISTVIEW_UPDATE )
{
	ListView_Update ( (HWND) HMG_parnl (1), hb_parni(2) - 1 );

}


//        ListView_Scroll ( hWnd, nDx, nDy )
HB_FUNC ( LISTVIEW_SCROLL )
{
   ListView_Scroll( (HWND) HMG_parnl (1), hb_parni(2), hb_parni(3) ) ;
}

HB_FUNC ( LISTVIEW_SETBKCOLOR )
{
	ListView_SetBkColor ( (HWND) HMG_parnl (1), (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

HB_FUNC ( LISTVIEW_SETTEXTBKCOLOR )
{
	ListView_SetTextBkColor ( (HWND) HMG_parnl (1), (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

HB_FUNC ( LISTVIEW_SETTEXTCOLOR )
{
	ListView_SetTextColor ( (HWND) HMG_parnl (1), (COLORREF) RGB(hb_parni(2), hb_parni(3), hb_parni(4)) ) ;
}

HB_FUNC ( LISTVIEW_GETTEXTCOLOR )
{
	hb_retnl ( ListView_GetTextColor ( (HWND) HMG_parnl (1) ) ) ;
}

HB_FUNC ( LISTVIEW_GETBKCOLOR )
{
	hb_retnl ( ListView_GetBkColor ( (HWND) HMG_parnl (1) ) ) ;
}

// by Dr. Claudio Soto (April 2013)

static __TLS__ BOOL _SET_LISTVIEW_DELETEALLITEMS_ = FALSE;   // for compatibility with old behavior of LISTVIEW_ADDCOLUMN and LISTVIEW_DELETECOLUMN

HB_FUNC ( SET_GRID_DELETEALLITEMS )
{
_THREAD_LOCK();
   if (hb_pcount() == 0)
       hb_retl ( _SET_LISTVIEW_DELETEALLITEMS_ );
   else
      _SET_LISTVIEW_DELETEALLITEMS_ = hb_parl (1);
_THREAD_UNLOCK();
}


HB_FUNC ( LISTVIEW_ADDCOLUMN )
{
   LV_COLUMN COL;

   COL.mask= LVCF_WIDTH | LVCF_TEXT | LVCF_FMT | LVCF_SUBITEM ;
   COL.cx= hb_parni(3);
   COL.pszText = (TCHAR*) HMG_parc(4);
   COL.iSubItem=hb_parni(2)-1;
   COL.fmt = hb_parni(5) ;

   ListView_InsertColumn ( (HWND) HMG_parnl (1), hb_parni(2)-1, &COL );
_THREAD_LOCK();
   if (_SET_LISTVIEW_DELETEALLITEMS_ == TRUE)   // for compatibility with old behavior
   {   ListView_DeleteAllItems ( (HWND) HMG_parnl (1) );
       RedrawWindow ( (HWND) HMG_parnl (1), NULL , NULL , RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }
_THREAD_UNLOCK();
}


HB_FUNC ( LISTVIEW_DELETECOLUMN )
{
   ListView_DeleteColumn ( (HWND) HMG_parnl (1), hb_parni(2)-1 );
_THREAD_LOCK();
   if (_SET_LISTVIEW_DELETEALLITEMS_ == TRUE)   // for compatibility with old behavior
   {   ListView_DeleteAllItems ( (HWND) HMG_parnl (1) );
       RedrawWindow ( (HWND) HMG_parnl (1), NULL , NULL , RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
   }
_THREAD_UNLOCK();
}


//        SetListViewHeaderImages ( ControlHandle , aHeaderImages , aJust, lNoTransHeader ) ---> hImageList
HB_FUNC ( SETLISTVIEWHEADERIMAGES )
{
   HIMAGELIST hImageList = NULL;
   LV_COLUMN LVC;
   TCHAR *FileName;
   int nCount, i;

   nCount = hb_parinfa (2, 0);

   if ( nCount > 0 )
   {
      int Transparent = hb_parl(4) ? 0 : 1;

      for (i=1; i <= nCount; i++)
      {
         FileName = (TCHAR*) HMG_parvc (2, i);
         if ( hImageList == NULL )
            hImageList = HMG_ImageListLoadFirst (FileName, nCount, Transparent, NULL, NULL);
         else
            HMG_ImageListAdd (hImageList, FileName, Transparent);
      }

      if ( hImageList != NULL )
           SendMessage (ListView_GetHeader ((HWND) HMG_parnl (1)), HDM_SETIMAGELIST, (WPARAM) 0, (LPARAM) hImageList);

      for (i=0; i < nCount; i++)
      {
         LVC.mask   = LVCF_IMAGE | LVCF_FMT;
         LVC.iImage = i;
         LVC.fmt    = LVCFMT_IMAGE | /*LVCFMT_COL_HAS_IMAGES |*/ hb_parvni (3, i+1);   // ADD2
         ListView_SetColumn ((HWND) HMG_parnl (1), i , &LVC);
      }
   }

   HMG_retnl ((LONG_PTR) hImageList );
}


HB_FUNC ( LISTVIEW_GETFOCUSEDITEM )
{
	hb_retni ( ListView_GetNextItem( (HWND) HMG_parnl (1), -1 ,LVNI_ALL | LVNI_FOCUSED) + 1);
}

/*
HB_FUNC ( LISTVIEW_GETSELECTEDITEM )
{
	hb_retni ( ListView_GetNextItem( (HWND) HMG_parnl (1), -1 ,LVNI_ALL | LVIS_SELECTED) + 1);
}
*/

HB_FUNC ( LISTVIEW_SETCOLUMNWIDTH )
{
	ListView_SetColumnWidth ( (HWND) HMG_parnl (1), hb_parni(2) , hb_parni(3) ) ;
}

HB_FUNC ( LISTVIEW_GETCOLUMNWIDTH )
{
	hb_retni ( ListView_GetColumnWidth ( (HWND) HMG_parnl (1), hb_parni(2) ) ) ;
}



HB_FUNC( INITLISTVIEWCOLUMNS )
{
   PHB_ITEM    wArray;
   PHB_ITEM    hArray;
   PHB_ITEM    jArray;

   HWND        hc;
   LV_COLUMN   COL;
   int         iLen;
   int         s;
   int         iColumn = 0;

   hc = (HWND) HMG_parnl (1);

   iLen = hb_parinfa( 2, 0 ) - 1;
   hArray = hb_param( 2, HB_IT_ARRAY );
   wArray = hb_param( 3, HB_IT_ARRAY );
   jArray = hb_param( 4, HB_IT_ARRAY );

   COL.mask = LVCF_FMT | LVCF_WIDTH | LVCF_TEXT | LVCF_SUBITEM;

   for( s = 0; s <= iLen; s++ )
   {
      COL.fmt = hb_arrayGetNI( jArray, s + 1 );
      COL.cx = hb_arrayGetNI( wArray, s + 1 );
      COL.pszText = (TCHAR *) HMG_arrayGetCPtr( hArray, s + 1 );
      COL.iSubItem = iColumn;
      ListView_InsertColumn( hc, iColumn, &COL );
      if( iColumn == 0 && COL.fmt != LVCFMT_LEFT )
      {
         iColumn++;
         COL.iSubItem = iColumn;
         ListView_InsertColumn( hc, iColumn, &COL );
      }

      iColumn++;
   }

   if( iColumn != s )
   {
      ListView_DeleteColumn( hc, 0 );       // <-- this hack
   }
}


/**************************************************************************************************/


HB_FUNC ( GETGRIDVKEY )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LV_KEYDOWN * LVK = (LV_KEYDOWN *) lParam;
   hb_retni ( LVK->wVKey );
}


HB_FUNC ( GETGRIDCOLUMN )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   NM_LISTVIEW * NMLV = (NM_LISTVIEW *) lParam;
   hb_retni ( NMLV->iSubItem );
}

HB_FUNC ( GETGRIDROW )   // ADD, December 2014
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   NM_LISTVIEW * NMLV = (NM_LISTVIEW *) lParam;
   hb_retni ( NMLV->iItem );
}


HB_FUNC ( GETGRIDOLDSTATE )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   NM_LISTVIEW * NMLV = (NM_LISTVIEW *) lParam;
   hb_retni ( NMLV->uOldState );
}


HB_FUNC ( GETGRIDNEWSTATE )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   NM_LISTVIEW * NMLV = (NM_LISTVIEW *) lParam;
   hb_retni ( NMLV->uNewState );
}


HB_FUNC ( GETGRIDDISPINFOINDEX )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LV_DISPINFO* pDispInfo = (LV_DISPINFO*) lParam;
   int iItem = pDispInfo->item.iItem;
   int iSubItem = pDispInfo->item.iSubItem;

   hb_reta( 2 );
   hb_storvni( iItem    + 1, -1, 1 );
   hb_storvni( iSubItem + 1, -1, 2 );
}


HB_FUNC ( SETGRIDQUERYDATA )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LV_DISPINFO* pDispInfo = (LV_DISPINFO*) lParam;

   // HMG_Trace( __FILE__, __LINE__, __FUNCTION__, _TEXT(" %p |- %s -| %d "), pDispInfo->item.pszText, (TCHAR*) HMG_parc (2), pDispInfo->item.cchTextMax, NULL );

#ifdef COMPILE_HMG_UNICODE
   if( hb_iswinvista() )   // Is Win Vista or newer   // ADD3, September 2015
      lstrcpyn(pDispInfo->item.pszText, (TCHAR*) HMG_parc (2), pDispInfo->item.cchTextMax);   // ADD3, July 2015
   else
      pDispInfo->item.pszText = (TCHAR*) HMG_parc (2); // Is Win XP
#else   // ANSI mode
   lstrcpyn(pDispInfo->item.pszText, (TCHAR*) HMG_parc (2), pDispInfo->item.cchTextMax); // ADD, March 2017, contrib by huiyi_ch
#endif
}


HB_FUNC ( SETGRIDQUERYIMAGE )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LV_DISPINFO* pDispInfo = (LV_DISPINFO*) lParam;
   pDispInfo->item.iImage = hb_parni (2);
}


HB_FUNC ( SETBCFC )   // Set DynamicBackColor and Set DynamicForeColor
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMLVCUSTOMDRAW lplvcd = (LPNMLVCUSTOMDRAW) lParam;

   lplvcd->clrText   = hb_parni(3);
   lplvcd->clrTextBk = hb_parni(2);
   hb_retni ( CDRF_NEWFONT );
}


HB_FUNC ( SETBCFC_DEFAULT )   // Set DefaultDynamicBackColor and  Set DefaultDynamicForeColor
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMLVCUSTOMDRAW lplvcd = (LPNMLVCUSTOMDRAW) lParam;

   lplvcd->clrText   = RGB (0,0,0);         // BLACK
   lplvcd->clrTextBk = RGB (255,255,255);   // WHITE
   hb_retni ( CDRF_NEWFONT );
}


