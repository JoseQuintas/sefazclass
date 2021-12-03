/*----------------------------------------------------------------------------
 HMG Source File --> c_GridEx.c

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


//#define _WIN32_IE      0x0500
//#define _WIN32_WINNT   0x0501

#include <windows.h>
#include <commctrl.h>
#include <tchar.h>
#include "hbapi.h"
#include "hbapiitm.h"

#include "hbthread.h"
extern HB_CRITICAL_T _HMG_Mutex;   // global Mutex variable defined into c_Thread.c


//        ListView_SetHeaderImageIndex (hWnd, nCol, nIndex)
HB_FUNC ( LISTVIEW_SETHEADERIMAGEINDEX )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   INT  nCol    = (INT)  hb_parni  (2);
   INT  nIndex  = (INT)  hb_parni  (3);
   LV_COLUMN LVC;
   LVC.mask   = LVCF_FMT | LVCF_IMAGE;
   LVC.iImage = nIndex;
   LVC.fmt    = LVCFMT_IMAGE /*| LVCFMT_COL_HAS_IMAGES*/;
   ListView_SetColumn (hWnd, nCol , &LVC);
}


//        ListView_GetHeaderImageIndex (hWnd, nCol) --> nIndex
HB_FUNC ( LISTVIEW_GETHEADERIMAGEINDEX )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   INT  nCol    = (INT)  hb_parni  (2);
   LV_COLUMN LVC;
   LVC.mask   = LVCF_FMT | LVCF_IMAGE;
   LVC.fmt    = LVCFMT_IMAGE /*| LVCFMT_COL_HAS_IMAGES*/;
   ListView_GetColumn (hWnd, nCol , &LVC);
   hb_retni ((INT) LVC.iImage );
}


//        ListView_GetWorkAreas ( hWnd ) --> aRect = { { left,top, right, bottom },...}
HB_FUNC ( LISTVIEW_GETWORKAREAS )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   UINT nCount = 0;
   ListView_GetNumberOfWorkAreas (hWnd, &nCount);
   if ( nCount > 0 )
   {  RECT aRect [nCount];
      ListView_GetWorkAreas (hWnd, nCount, &aRect);
      PHB_ITEM pArray = hb_itemArrayNew (0);
      PHB_ITEM pSubarray = hb_itemNew (NULL);
      UINT i;
      for (i=0; i < nCount; i++)
      {  hb_arrayNew   ( pSubarray, 4 );
         hb_arraySetNL ( pSubarray, 1, aRect[i].left   );
         hb_arraySetNL ( pSubarray, 2, aRect[i].top    );
         hb_arraySetNL ( pSubarray, 3, aRect[i].right  );
         hb_arraySetNL ( pSubarray, 4, aRect[i].bottom );
         hb_arrayAddForward ( pArray, pSubarray );
      }
      hb_itemReturnRelease (pArray);
      hb_itemRelease (pSubarray);
   }
}


//        ListView_GetWorkAreas ( hWnd, aRect )    aRect = { { left,top, right, bottom },...}
HB_FUNC ( LISTVIEW_SETWORKAREAS )
{
   HWND hWnd       = (HWND) HMG_parnl (1);
   PHB_ITEM pArray = hb_param (2, HB_IT_ARRAY);

   if ( pArray )
   {  UINT nCount = (UINT) hb_arrayLen (pArray);
      if ( nCount > 0 )
      {  RECT aRect [nCount];
         PHB_ITEM pSubarray = hb_itemNew ( NULL );
         UINT i, j = 0;
         for (i=0; i < nCount; i++)
         {  if (hb_arrayGetType (pArray, i+1 ) == HB_IT_ARRAY)
            {  hb_arrayGet (pArray, i+1, pSubarray);
               if (hb_arrayLen (pSubarray) == 4)
               {  aRect[j].left   = hb_arrayGetNL ( pSubarray, 1 );
                  aRect[j].top    = hb_arrayGetNL ( pSubarray, 2 );
                  aRect[j].right  = hb_arrayGetNL ( pSubarray, 3 );
                  aRect[j].bottom = hb_arrayGetNL ( pSubarray, 4 );
                  j++;
               }
            }
         }
         if (j > 0)
            ListView_SetWorkAreas (hWnd, j, aRect);
      }
   }
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_SETCOLUMNJUSTIFY (ControlHandle, nCol, nJustify)
//-----------------------------------------------------------------------------------------------
HB_FUNC ( LISTVIEW_SETCOLUMNJUSTIFY )
{
   LV_COLUMN   COL;
   COL.mask = LVCF_FMT;
   COL.fmt  = hb_parni(3);
   ListView_SetColumn ( (HWND) HMG_parnl(1), hb_parni(2), &COL);
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_GETCOLUMNORDERARRAY (ControlHandle, nColumnCount) --> Return Array: {Column Order}
//-----------------------------------------------------------------------------------------------
HB_FUNC ( LISTVIEW_GETCOLUMNORDERARRAY )
{
   int i, *p;
   p = (int*) hb_xgrab (sizeof(int)*hb_parni(2));
   ListView_GetColumnOrderArray ( (HWND) HMG_parnl(1), hb_parni(2), (int*) p);
   hb_reta (hb_parni(2));
   for( i= 0; i < hb_parni(2); i++ )
        hb_storvni( (int)(*(p+i))+1, -1, i+1);
   hb_xfree (p);
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_SETCOLUMNORDERARRAY (ControlHandle, nColumnCount, aArrayOrder)
//-----------------------------------------------------------------------------------------------
HB_FUNC ( LISTVIEW_SETCOLUMNORDERARRAY )
{
   int i, *p;
   PHB_ITEM aArray;
   aArray = hb_param (3, HB_IT_ARRAY);
   p = (int*) hb_xgrab ( sizeof(int) * hb_parni(2) );
   for( i= 0; i < hb_parni(2); i++ )
        *(p+i) = (int) hb_arrayGetNI (aArray, i+1)-1;
   ListView_SetColumnOrderArray ( (HWND) HMG_parnl(1), hb_parni(2), (int*) p);
   // hb_xfree (p);
}


HBITMAP HMG_LoadImage (TCHAR *FileName);

static __TLS__ BOOL _CoInitialize_Flag_ = FALSE;

//-----------------------------------------------------------------------------------------------
// LISTVIEW_SETBKIMAGE (ControlHandle, cPicture, yOffset, xOffset, nFlag)
//-----------------------------------------------------------------------------------------------
HB_FUNC ( LISTVIEW_SETBKIMAGE )
{
   LVBKIMAGE plBackImage;
   HBITMAP hBitmap = NULL;
   TCHAR *cPicture = (TCHAR*) HMG_parc(2);
   ULONG flag = hb_parnl(5);

_THREAD_LOCK();
   if (_CoInitialize_Flag_ == FALSE)
   {   _CoInitialize_Flag_ = TRUE;
       CoInitialize (NULL);
   }
_THREAD_UNLOCK();

   if (cPicture != NULL && flag != 0)
       hBitmap = HMG_LoadImage (cPicture);

   plBackImage.ulFlags = LVBKIF_SOURCE_NONE;

   if (flag == 1)
      plBackImage.ulFlags =  LVBKIF_SOURCE_HBITMAP | LVBKIF_STYLE_NORMAL;

   if (flag == 2)
       plBackImage.ulFlags =  LVBKIF_SOURCE_HBITMAP | LVBKIF_STYLE_TILE | LVBKIF_FLAG_TILEOFFSET;

   if (flag == 3)
       plBackImage.ulFlags = LVBKIF_TYPE_WATERMARK;

   plBackImage.hbm = hBitmap;
   plBackImage.pszImage = NULL;
   plBackImage.cchImageMax = 0;
   plBackImage.xOffsetPercent = hb_parni(3);
   plBackImage.yOffsetPercent = hb_parni(4);

   ListView_SetBkImage ( (HWND) HMG_parnl(1), &plBackImage);
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_GETBKIMAGE (ControlHandle)
//-----------------------------------------------------------------------------------------------
HB_FUNC ( LISTVIEW_GETBKIMAGE )
{
   LVBKIMAGE plBackImage;
   ListView_GetBkImage ( (HWND) HMG_parnl(1), &plBackImage);
   hb_reta (4);
   HMG_storvnl ((LONG_PTR) plBackImage.hbm,         -1, 1);
   hb_storvnl  ((LONG) plBackImage.ulFlags,         -1, 2);
   hb_storvnl  ((LONG) plBackImage.yOffsetPercent,  -1, 3);
   hb_storvnl  ((LONG) plBackImage.xOffsetPercent,  -1, 4);
}



//-----------------------------------------------------------------------------------------------
// LISTVIEW_GETITEMTEXT (ControlHandle, nRow, nCol)
//-----------------------------------------------------------------------------------------------
HB_FUNC ( LISTVIEW_GETITEMTEXT )
{
   TCHAR cItem [1024] = _TEXT("");

   HWND hWnd = (HWND) HMG_parnl (1);
   INT nRow  = (INT)  hb_parni (2);
   INT nCol  = (INT)  hb_parni (3);

   ListView_GetItemText (hWnd, nRow, nCol, cItem, sizeof(cItem) / sizeof(TCHAR));

   HMG_retc (cItem);
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_SETITEMTEXT (ControlHandle, nRow, nCol, cItem)
//-----------------------------------------------------------------------------------------------
HB_FUNC ( LISTVIEW_SETITEMTEXT )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   INT nRow     = (INT)  hb_parni (2);
   INT nCol     = (INT)  hb_parni (3);
   TCHAR *cItem = (TCHAR*) HMG_parc (4);

   ListView_SetItemText (hWnd, nRow, nCol, cItem);
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_INSERTITEM (ControlHandle, nRow, aItem, nColumnCount)
//-----------------------------------------------------------------------------------------------
HB_FUNC ( LISTVIEW_INSERTITEM )
{
   LV_ITEM LVI;
   HWND hWnd = (HWND) HMG_parnl (1);
   INT nRow  = (INT)  hb_parni (2);
   INT nColumnCount = (INT)  hb_parni (4);
   INT nCol;

   LVI.mask      = LVIF_TEXT;
   LVI.iItem     = nRow;
   LVI.iSubItem  = 0;
   LVI.state     = 0;
   LVI.stateMask = 0;
   LVI.pszText   = (TCHAR*) HMG_parvc (3, 1);
   LVI.iImage    = 0;

   ListView_InsertItem (hWnd, &LVI);

   for (nCol = 1 ; nCol < nColumnCount ; nCol++)
        ListView_SetItemText (hWnd, nRow, nCol, (TCHAR*) HMG_parvc (3, nCol+1));
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_SETCHECKSTATE (hWnd, nRow, lCheck)
//-----------------------------------------------------------------------------------------------
HB_FUNC (LISTVIEW_SETCHECKSTATE)
{
   HWND hWnd   = (HWND) HMG_parnl (1);
   UINT nRow   = (UINT) hb_parnl (2);
   BOOL lCheck = (BOOL) hb_parl  (3);

   ListView_SetCheckState (hWnd, nRow, lCheck);
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_GETCHECKSTATE (hWnd, nRow)
//-----------------------------------------------------------------------------------------------
HB_FUNC (LISTVIEW_GETCHECKSTATE)
{
   HWND hWnd   = (HWND) HMG_parnl (1);
   UINT nRow   = (UINT) hb_parnl (2);
   hb_retl ( ListView_GetCheckState(hWnd, nRow) );
}


//-----------------------------------------------------------------------------------------------
// LISTVIEW_SETINSERTMARKCOLOR (hWnd, Color)
//-----------------------------------------------------------------------------------------------
HB_FUNC (LISTVIEW_SETINSERTMARKCOLOR)
{
   HWND     hWnd  = (HWND) HMG_parnl (1);
   COLORREF Color = (COLORREF) hb_parnl (2);
   ListView_SetInsertMarkColor (hWnd, Color);
}


//-----------------------------------------------------------------------------------------------
// SHOWSCROLLBAR (hWnd, wBar, bShow)
//-----------------------------------------------------------------------------------------------
HB_FUNC ( SHOWSCROLLBAR )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   INT  wBar  = (INT)  hb_parni (2);
   BOOL bShow = (BOOL) hb_parl  (3);
   hb_retl (ShowScrollBar (hWnd, wBar, bShow));
}


HB_FUNC (SETSYSCOLORS)
{
   int ID         = (int)      hb_parni (1);
   COLORREF Color = (COLORREF) hb_parnl (2);
   hb_retl (SetSysColors (1, &ID, &Color));
}



//********************************************************************************************************
// ListView Custom Draw
//********************************************************************************************************


//        ListView_CustomDraw_GetRowCol ( lParam ) --> { nRow , nCol }
HB_FUNC ( LISTVIEW_CUSTOMDRAW_GETROWCOL )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMLVCUSTOMDRAW lplvcd = (LPNMLVCUSTOMDRAW) lParam;

   hb_reta( 2 );
   // nRow draw
   hb_storvnl( (LONG) lplvcd->nmcd.dwItemSpec + 1 , -1, 1 );   // The item number. What is contained in this member will depend on the type of control
                                                               // that is sending the notification. See the NM_CUSTOMDRAW notification reference for
                                                               // the specific control to determine what, if anything, is contained in this member.
   // nCol draw
   hb_storvnl( (LONG) lplvcd->iSubItem + 1 , -1, 2 );   // Index of the subitem that is being drawn.
                                                        // If the main item is being drawn, this member will be zero.
}


//        ListView_CustomDraw_GetAction ( lParam , [ CellNavigation , hWndLV , nIndex ] )
HB_FUNC ( LISTVIEW_CUSTOMDRAW_GETACTION )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMLVCUSTOMDRAW lplvcd = (LPNMLVCUSTOMDRAW) lParam;

   if (lplvcd->nmcd.dwDrawStage == CDDS_PREPAINT )
       hb_retni ( CDRF_NOTIFYITEMDRAW ) ;

   else if (lplvcd->nmcd.dwDrawStage == CDDS_ITEMPREPAINT )
   {
        if ( hb_parl (2) )   // if CellNavigation == .T.
        {
            HWND hWndLV = (HWND) HMG_parnl (3);
            INT  nIndex = (INT)  hb_parni  (4) - 1;
            if ( ListView_GetNextItem (hWndLV, - 1, (LVNI_ALL | LVNI_SELECTED)) == nIndex )
                ListView_SetItemState(hWndLV, nIndex, 0, LVIS_SELECTED );
        }

        hb_retni ( CDRF_NOTIFYSUBITEMDRAW ) ;
   }
   else if (lplvcd->nmcd.dwDrawStage == (CDDS_SUBITEM | CDDS_ITEMPREPAINT))
        hb_retni ( -1 ) ;   // Change font, forecolor , backcolor
   else
      hb_retni ( CDRF_DODEFAULT ) ;
}


//        GRID_SetBCFC ( lParam , nColorTextBk , nColorText , hFont )
HB_FUNC ( GRID_SETBCFC )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMLVCUSTOMDRAW lplvcd = (LPNMLVCUSTOMDRAW) lParam;

   lplvcd->clrTextBk = hb_parni (2);
   lplvcd->clrText   = hb_parni (3);

   HFONT hFont = (HFONT) HMG_parnl (4);
   if ( hFont != NULL )
      SelectObject (lplvcd->nmcd.hdc, hFont);

   hb_retni ( CDRF_NEWFONT );
}


//        ListView_CustomDraw_GetHDC ( lParam ) --> hDC
HB_FUNC ( LISTVIEW_CUSTOMDRAW_GETHDC )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMLVCUSTOMDRAW lplvcd = (LPNMLVCUSTOMDRAW) lParam;
   HMG_retnl ((LONG_PTR) lplvcd->nmcd.hdc);
}


//        ListView_GetHeader ( hWnd )
HB_FUNC ( LISTVIEW_GETHEADER )
{
   HWND hGrid   = (HWND) HMG_parnl (1);
   HWND hHeader = (HWND) ListView_GetHeader (hGrid);
   HMG_retnl ((LONG_PTR) hHeader);
}


//        ListView_GetColumnCount( hWnd )
HB_FUNC ( LISTVIEW_GETCOLUMNCOUNT )
{
   HWND hGrid   = (HWND) HMG_parnl (1);
   HWND hHeader = (HWND) ListView_GetHeader (hGrid);
   hb_retni( Header_GetItemCount( hHeader ) );
}


//        Header_CustomDraw_GetItem ( lParam ) --> nColumnHeader
HB_FUNC ( HEADER_CUSTOMDRAW_GETITEM )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMCUSTOMDRAW lpNMCustomDraw = (LPNMCUSTOMDRAW) lParam;
   HMG_retnl ((LONG_PTR) lpNMCustomDraw->dwItemSpec );
}


//        Header_CustomDraw_GetAction ( lParam )
HB_FUNC ( HEADER_CUSTOMDRAW_GETACTION )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMCUSTOMDRAW lpNMCustomDraw = (LPNMCUSTOMDRAW) lParam;

   if ( lpNMCustomDraw->dwDrawStage == CDDS_PREPAINT )
       hb_retni ( CDRF_NOTIFYITEMDRAW ) ;
   else if ( lpNMCustomDraw->dwDrawStage == CDDS_ITEMPREPAINT )   // not work in 64-bits, never dwDrawStage == CDDS_ITEMPREPAINT ???
        hb_retni ( -1 ) ;   // Change font, forecolor , backcolor
   else
      hb_retni ( CDRF_DODEFAULT ) ;
}


//        Header_CustomDraw_GetHDC ( lParam ) --> hDC
HB_FUNC ( HEADER_CUSTOMDRAW_GETHDC )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMCUSTOMDRAW lpNMCustomDraw = (LPNMCUSTOMDRAW) lParam;
   HMG_retnl ((LONG_PTR) lpNMCustomDraw->hdc);
}


//        Header_SetFont
HB_FUNC ( HEADER_SETFONT )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMCUSTOMDRAW lpNMCustomDraw = (LPNMCUSTOMDRAW) lParam;

// SetBkMode    (lpNMCustomDraw->hdc, OPAQUE);
   SetBkColor   (lpNMCustomDraw->hdc, hb_parni(2));   // Not work
   SetTextColor (lpNMCustomDraw->hdc, hb_parni(3));

   HFONT hFont = (HFONT) HMG_parnl (4);
   if ( hFont != NULL )
       SelectObject (lpNMCustomDraw->hdc, hFont);

   hb_retni ( CDRF_NEWFONT );
}


//       ListView_ChangeView ( hWnd, [ nNewView ] ) --> nOldView
HB_FUNC( LISTVIEW_CHANGEVIEW )
{
   HWND  hWnd    = (HWND)  HMG_parnl (1);
   DWORD NewView = (DWORD) hb_parnl  (2);
   DWORD OldView = ListView_GetView (hWnd);
   if ( HB_ISNUM (2) )
      ListView_SetView ( hWnd, NewView );
   hb_retnl ((LONG) OldView);
}


//       ListView_ChangeExtendedStyle ( hWnd, [ nAddStyle ], [ nRemoveStyle ] )
HB_FUNC( LISTVIEW_CHANGEEXTENDEDSTYLE )
{
   HWND  hWnd    = (HWND)  HMG_parnl (1);
   DWORD Add     = (DWORD) hb_parnl  (2);
   DWORD Remove  = (DWORD) hb_parnl  (3);
   DWORD OldStyle, NewStyle, Style;

   OldStyle = ListView_GetExtendedListViewStyle (hWnd);
   NewStyle = (OldStyle | Add) & ( ~Remove );
   Style = ListView_SetExtendedListViewStyle ( hWnd, NewStyle );
   hb_retnl ((LONG) Style);
}


//       ListView_GetExtendedStyle ( hWnd, [ nExStyle ] )
HB_FUNC( LISTVIEW_GETEXTENDEDSTYLE )
{
   HWND  hWnd     = (HWND)  HMG_parnl (1);
   DWORD ExStyle  = (DWORD) hb_parnl  (2);
   DWORD OldStyle = ListView_GetExtendedListViewStyle (hWnd);
   if ( HB_ISNUM(2) )
      hb_retl ((BOOL) ((OldStyle & ExStyle) == ExStyle));
   else
      hb_retnl ((LONG) OldStyle);
}


//        ListView_SetImageList ( hWnd , hImageList , [iImageList] )
HB_FUNC ( LISTVIEW_SETIMAGELIST )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   HIMAGELIST hImageList = (HIMAGELIST) HMG_parnl (2);
   int iImageList = HB_ISNIL(3) ? LVSIL_SMALL : hb_parni (3);
   HIMAGELIST hImageListPrevious = ListView_SetImageList (hWnd, hImageList, iImageList);
   HMG_retnl ((LONG_PTR) hImageListPrevious);
}


//        ListView_GetImageList ( hWnd , [iImageList] ) --> hImageList
HB_FUNC ( LISTVIEW_GETIMAGELIST )
{
   HWND hWnd      = (HWND) HMG_parnl (1);
   int iImageList = HB_ISNIL(2) ? LVSIL_SMALL : hb_parni (2);
   HIMAGELIST hImageList = ListView_GetImageList (hWnd, iImageList);
   HMG_retnl ((LONG_PTR) hImageList);
}



//        ListView_SetItemImageIndex ( hWnd , nRow , nCol, [ nImageIndex ] )
HB_FUNC ( LISTVIEW_SETITEMIMAGEINDEX )
{
   HWND hWnd  = (HWND) HMG_parnl (1);
   int nRow   = (int)  hb_parni  (2);
   int nCol   = (int)  hb_parni  (3);   // LVM_SETEXTENDEDLISTVIEWSTYLE with LVS_EX_SUBITEMIMAGES
   int iImage = HB_ISNIL(4) ? -1 : hb_parni (4);

   LV_ITEM LV;
   LV.mask      = LVIF_IMAGE;
   LV.state     = 0;
   LV.stateMask = 0;
   LV.iImage    = iImage;
   LV.iSubItem  = nCol;
   LV.iItem     = nRow;

   ListView_SetItem (hWnd, &LV);
}


//        ListView_GetItemImageIndex ( hWnd, nRow , nCol ) --> nImageIndex
HB_FUNC ( LISTVIEW_GETITEMIMAGEINDEX )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   int nRow  = (int)  hb_parni  (2);
   int nCol  = (int)  hb_parni  (3);   // LVM_SETEXTENDEDLISTVIEWSTYLE with LVS_EX_SUBITEMIMAGES

   LV_ITEM LV;
   LV.mask      = LVIF_IMAGE;
   LV.state     = 0;
   LV.stateMask = 0;
   LV.iImage    = 0;
   LV.iSubItem  = nCol;
   LV.iItem     = nRow;

   ListView_GetItem (hWnd, &LV);

   hb_retni ((int) LV.iImage);
}



#define MAX_GROUP_BUFFER   2048

//        ListView_GroupItemSetID ( hWnd, nRow, nGroupID )
HB_FUNC ( LISTVIEW_GROUPITEMSETID )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   INT  nRow    = (INT)  hb_parni  (2);
   INT  GroupID = (INT)  hb_parni  (3);

   LVITEM LVI;
   LVI.mask     = LVIF_GROUPID;
   LVI.iItem    = nRow;
   LVI.iSubItem = 0;
   LVI.iGroupId = GroupID;
   hb_retl ((BOOL) ListView_SetItem ( hWnd, &LVI ));
}


//        ListView_GroupItemGetID ( hWnd, nRow )
HB_FUNC ( LISTVIEW_GROUPITEMGETID )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   INT  nRow    = (INT)  hb_parni  (2);

   LVITEM LVI;
   LVI.mask     = LVIF_GROUPID;
   LVI.iItem    = nRow;
   LVI.iSubItem = 0;
   ListView_GetItem ( hWnd, &LVI );
   hb_retni ((INT) LVI.iGroupId );
}


//        ListView_IsGroupViewEnabled ( hWnd )
HB_FUNC ( LISTVIEW_ISGROUPVIEWENABLED )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   hb_retl ((BOOL) ListView_IsGroupViewEnabled ( hWnd ));
}


//        ListView_EnableGroupView ( hWnd, lEnable )
HB_FUNC ( LISTVIEW_ENABLEGROUPVIEW )
{
   HWND hWnd   = (HWND) HMG_parnl (1);
   BOOL Enable = (BOOL) hb_parl   (2);
   ListView_EnableGroupView (hWnd, Enable);
}


//        ListView_GroupDeleteAll ( hWnd )
HB_FUNC ( LISTVIEW_GROUPDELETEALL )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   ListView_RemoveAllGroups ( hWnd );
}


//        ListView_GroupDelete ( hWnd, nGroupID )
HB_FUNC ( LISTVIEW_GROUPDELETE )
{
   HWND hWnd    = (HWND) HMG_parnl (1);
   INT  GroupID = (INT)  hb_parni  (2);
   hb_retni ((INT) ListView_RemoveGroup ( hWnd, GroupID ));
}


//        ListView_GroupAdd ( hWnd, nGroupID, [ nIndex ] )
HB_FUNC ( LISTVIEW_GROUPADD )
{
   HWND hWnd     = (HWND)  HMG_parnl (1);
   INT  GroupID  = (INT)   hb_parni  (2);
   INT  nIndex   = (INT) ( HB_ISNUM  (3) ? hb_parni (3) : -1 );

   LVGROUP LVG;
   LVG.cbSize    = sizeof (LVGROUP);
   LVG.stateMask = LVM_SETGROUPINFO;
   LVG.mask      = LVGF_GROUPID | LVGF_HEADER | LVGF_FOOTER | LVGF_ALIGN | LVGF_STATE;
   LVG.iGroupId  = GroupID;
   LVG.pszHeader = L"";
   LVG.pszFooter = L"";
   LVG.uAlign    = LVGA_HEADER_LEFT | LVGA_FOOTER_LEFT;
   LVG.state     = LVGS_NORMAL;
   hb_retni ((INT) ListView_InsertGroup (hWnd, nIndex, &LVG));
}


//        ListView_GroupSetInfo ( hWnd, nGroupID, cHeader, nAlignHeader, cFooter, nAlingFooter, nState )
HB_FUNC ( LISTVIEW_GROUPSETINFO )
{
   HWND  hWnd         = (HWND)    HMG_parnl (1);
   INT   GroupID      = (INT)     hb_parni  (2);
   WCHAR *cHeader     = (WCHAR *) HMG_ToUnicode (HMG_parc (3));
   UINT  nAlignHeader = (UINT)    hb_parni  (4);
   WCHAR *cFooter     = (WCHAR *) HMG_ToUnicode (HMG_parc (5));
   UINT  nAlignFooter = (UINT)    hb_parni  (6);
   UINT  nState       = (UINT)    hb_parni  (7);

   WCHAR cHeaderBuffer [ MAX_GROUP_BUFFER ];
   WCHAR cFooterBuffer [ MAX_GROUP_BUFFER ];

   LVGROUP LVG;
   LVG.cbSize    = sizeof (LVGROUP);
   LVG.stateMask = LVM_GETGROUPINFO;
   LVG.mask      = LVGF_HEADER | LVGF_FOOTER | LVGF_ALIGN | LVGF_STATE;
   LVG.pszHeader = cHeaderBuffer;
   LVG.cchHeader = sizeof (cHeaderBuffer) / sizeof (WCHAR);
   LVG.pszFooter = cFooterBuffer;
   LVG.cchFooter = sizeof (cFooterBuffer) / sizeof (WCHAR);

   if ( ListView_GetGroupInfo ( hWnd, GroupID, &LVG ) != -1)
   {
      UINT nAlign = 0;
      LVG.stateMask = LVM_SETGROUPINFO;
      LVG.pszHeader = ( cHeader != NULL ) ? cHeader : cHeaderBuffer;
      LVG.pszFooter = ( cFooter != NULL ) ? cFooter : cFooterBuffer;
      nAlign        = nAlign | (( nAlignHeader != 0 ) ?  nAlignHeader       : ( LVG.uAlign & 0x07));
      nAlign        = nAlign | (( nAlignFooter != 0 ) ? (nAlignFooter << 3) : ( LVG.uAlign & 0x38));
      LVG.uAlign    = nAlign;
      LVG.state     = (( nState != 0 ) ? (nState >> 1) : LVG.state);
      hb_retni ((INT) ListView_SetGroupInfo ( hWnd, GroupID, &LVG ));
   }
   else
      hb_retni ( -1 );
}


//        ListView_GroupGetInfo ( hWnd, nGroupID, @cHeader, @nAlignHeader, @cFooter, @nAlingFooter, @nState )
HB_FUNC ( LISTVIEW_GROUPGETINFO )
{
   HWND  hWnd     = (HWND)    HMG_parnl (1);
   INT   GroupID  = (INT)     hb_parni  (2);

   INT nRet;
   WCHAR cHeaderBuffer [ MAX_GROUP_BUFFER ];
   WCHAR cFooterBuffer [ MAX_GROUP_BUFFER ];

   LVGROUP LVG;
   LVG.cbSize    = sizeof (LVGROUP);
   LVG.stateMask = LVM_GETGROUPINFO;
   LVG.mask      = LVGF_HEADER | LVGF_FOOTER | LVGF_ALIGN | LVGF_STATE;
   LVG.pszHeader = cHeaderBuffer;
   LVG.cchHeader = sizeof (cHeaderBuffer) / sizeof (WCHAR);
   LVG.pszFooter = cFooterBuffer;
   LVG.cchFooter = sizeof (cFooterBuffer) / sizeof (WCHAR);

   if (( nRet = ListView_GetGroupInfo ( hWnd, GroupID, &LVG )) != -1)
   {
      HMG_storc  (   HMG_IsAnsi_UnicodeToAnsi (cHeaderBuffer), 3);
      hb_storni  ((  LVG.uAlign & 0x07),                       4);
      HMG_storc  (   HMG_IsAnsi_UnicodeToAnsi (cFooterBuffer), 5);
      hb_storni  ((( LVG.uAlign & 0x38) >> 3),                 6);
      hb_storni  ((( LVG.state != 0 ) ? (LVG.state << 1) : 1), 7);
   }
   hb_retni ( nRet );
}


//        ListView_HasGroup ( hWnd, nGroupID )
HB_FUNC ( LISTVIEW_HASGROUP )
{
   HWND  hWnd     = (HWND)    HMG_parnl (1);
   INT   GroupID  = (INT)     hb_parni  (2);
   hb_retl ((BOOL) ListView_HasGroup ( hWnd, GroupID ));
}


HB_FUNC ( LISTVIEW_SETITEMSTATE )
{
   HWND hWnd   = (HWND) HMG_parnl (1);
   INT  nRow   = (INT)  hb_parni  (2);
   UINT uState = (UINT) hb_parni  (3);
   UINT uMask  = (UINT) hb_parni  (4);

   ListView_SetItemState ( hWnd, (nRow - 1), uState, uMask );
}


HB_FUNC ( LISTVIEW_GETITEMSTATE )
{
   HWND hWnd   = (HWND) HMG_parnl (1);
   INT  nRow   = (INT)  hb_parni  (2);
   UINT uMask  = (UINT) hb_parni  (3);

   hb_retni ((INT) ListView_GetItemState ( hWnd, (nRow - 1), uMask ) );
}
