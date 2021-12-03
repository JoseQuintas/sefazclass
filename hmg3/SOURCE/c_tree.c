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
//#define _WIN32_WINNT   0x0400


#define WM_TASKBAR     WM_USER+1043   // User define message

#include <shlobj.h>
#include <windows.h>
#include <commctrl.h>
#include <tchar.h>
#include "hbapi.h"


#define MAX_ITEM_TEXT   1024


HIMAGELIST HMG_ImageListLoadFirst (TCHAR *FileName, int cGrow, int Transparent, int *nWidth, int *nHeight);
void HMG_ImageListAdd (HIMAGELIST hImageList, TCHAR *FileName, int Transparent);


//        Notify_TreeView_ItemExpand ( lParam ) --> { nAction , ItemHandle }
HB_FUNC ( NOTIFY_TREEVIEW_ITEMEXPAND )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMTREEVIEW pnmtv = (LPNMTREEVIEW) lParam;
   hb_reta (2);
   hb_storvni  ((INT)      pnmtv->action,        -1, 1);
   HMG_storvnl ((LONG_PTR) pnmtv->itemNew.hItem, -1, 2);
}


//        TreeView_CustomDraw_GetItemHandle ( lParam ) --> ItemHandle
HB_FUNC ( TREEVIEW_CUSTOMDRAW_GETITEMHANDLE )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMTVCUSTOMDRAW lptvcd = (LPNMTVCUSTOMDRAW) lParam;
   HMG_retnl ((LONG_PTR) lptvcd->nmcd.dwItemSpec);
}


//        TreeView_CustomDraw_GetHDC ( lParam ) --> hDC
HB_FUNC ( TREEVIEW_CUSTOMDRAW_GETHDC )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMTVCUSTOMDRAW lptvcd = (LPNMTVCUSTOMDRAW) lParam;
   HMG_retnl ((LONG_PTR) lptvcd->nmcd.hdc);
}


HB_FUNC ( TREE_SETBCFC )   // Set DynamicBackColor and Set DynamicForeColor
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMTVCUSTOMDRAW lptvcd = (LPNMTVCUSTOMDRAW) lParam;

   lptvcd->clrTextBk = hb_parni(2);
   lptvcd->clrText   = hb_parni(3);

   HFONT hFont = (HFONT) HMG_parnl (4);
   if ( hFont != NULL )
       SelectObject (lptvcd->nmcd.hdc, hFont);

   hb_retni ( CDRF_NEWFONT );
}


 //       TreeView_CustomDraw_GetAction ( lParam )
HB_FUNC ( TREEVIEW_CUSTOMDRAW_GETACTION )
{
   LPARAM lParam = (LPARAM) HMG_parnl (1);
   LPNMTVCUSTOMDRAW lptvcd = (LPNMTVCUSTOMDRAW) lParam;

   if (lptvcd->nmcd.dwDrawStage == CDDS_PREPAINT )
       hb_retni ( CDRF_NOTIFYITEMDRAW ) ;

   else if (lptvcd->nmcd.dwDrawStage == CDDS_ITEMPREPAINT)
        hb_retni ( -1 ) ;   // Change font, forecolor , backcolor

   else
      hb_retni ( CDRF_DODEFAULT ) ;
}


HB_FUNC ( DOEVENTS );


HB_FUNC ( INITTREE )
{
   HWND hWndTV ;

   INITCOMMONCONTROLSEX icex;
   icex.dwSize = sizeof(INITCOMMONCONTROLSEX);
   icex.dwICC  = ICC_TREEVIEW_CLASSES;
   InitCommonControlsEx (&icex);

   int style = WS_VISIBLE | WS_TABSTOP | WS_CHILD | TVS_HASLINES | TVS_HASBUTTONS | TVS_SHOWSELALWAYS;

   if ( hb_parnl (9) == FALSE )   // NoRootButton
      style = style | TVS_LINESATROOT;

   hWndTV = CreateWindowEx( WS_EX_CLIENTEDGE , WC_TREEVIEW /*_TEXT("SysTreeView32")*/ ,
                            _TEXT(""),
                            style,
                            hb_parni(2),
                            hb_parni(3),
                            hb_parni(4),
                            hb_parni(5),
                            (HWND)  HMG_parnl (1),
                            (HMENU) HMG_parnl (6),
                            GetModuleHandle(NULL),
                            NULL);

   HMG_retnl ((LONG_PTR) hWndTV ) ;
}


HB_FUNC ( INITTREEVIEWBITMAP )
{
   HWND hTree = (HWND) HMG_parnl (1);
   HIMAGELIST hImageList = NULL;
   TCHAR *FileName;
   int nCount, i;
   int ic = 0;

   nCount = hb_parinfa (2, 0);

   if ( nCount > 0 )
   {
      int Transparent = hb_parl(3) ? 0 : 1;

      for (i=1; i <= nCount; i++)
      {
         FileName = (TCHAR*) HMG_parvc (2, i);
         if ( hImageList == NULL )
            hImageList = HMG_ImageListLoadFirst (FileName, nCount, Transparent, NULL, NULL);
         else
            HMG_ImageListAdd (hImageList, FileName, Transparent);
      }

         if ( hImageList != NULL )
            SendMessage (hTree, TVM_SETIMAGELIST, (WPARAM) TVSIL_NORMAL, (LPARAM) hImageList);

         ic = ImageList_GetImageCount (hImageList);
   }

   hb_retni ((INT) ic );
}


HB_FUNC ( ADDTREEVIEWBITMAP )
{
   HWND  hTree     = (HWND)   HMG_parnl (1);
   TCHAR *FileName = (TCHAR*) HMG_parc  (2);
   int Transparent = hb_parl(3) ? 0 : 1;
   HIMAGELIST hImageList = TreeView_GetImageList (hTree, TVSIL_NORMAL);
   int ic = 0;

   if (hImageList != NULL)
   {
      HMG_ImageListAdd (hImageList, FileName, Transparent);
      SendMessage (hTree, TVM_SETIMAGELIST, (WPARAM) TVSIL_NORMAL, (LPARAM) hImageList);
      ic = ImageList_GetImageCount (hImageList);
   }
   hb_retni ((INT) ic );
}



typedef struct {
   HTREEITEM ItemHandle;
   LONG      nID;
   BOOL      IsNodeFlag;
} HMG_StructTreeItemLPARAM;


void AddTreeItemLPARAM (HWND hWndTV, HTREEITEM ItemHandle, LONG nID, BOOL IsNodeFlag)
{  if ((hWndTV != NULL) && (ItemHandle != NULL))
   {
      HMG_StructTreeItemLPARAM * TreeItemLPARAM = (HMG_StructTreeItemLPARAM *) hb_xgrab (sizeof(HMG_StructTreeItemLPARAM));
      TreeItemLPARAM->ItemHandle = ItemHandle;
      TreeItemLPARAM->nID        = nID;
      TreeItemLPARAM->IsNodeFlag = IsNodeFlag;

      TV_ITEM TV_Item;
      TV_Item.mask   = TVIF_PARAM;
      TV_Item.hItem  = (HTREEITEM) ItemHandle;
      TV_Item.lParam = (LPARAM)    TreeItemLPARAM;
      TreeView_SetItem (hWndTV, &TV_Item);
   }
}



HB_FUNC (ADDTREEITEM)
{

	HWND hWndTV = (HWND) HMG_parnl (1);

	HTREEITEM PrevItemHandle = (HTREEITEM) HMG_parnl (2);
	HTREEITEM ItemHandle ;
   TCHAR     ItemText [ MAX_ITEM_TEXT ] ;
	TV_ITEM tvi;
	TV_INSERTSTRUCT is ;

   lstrcpy ( ItemText , HMG_parc(3) ) ;

   LONG nID        = (LONG) hb_parnl(6);
   BOOL IsNodeFlag = (BOOL) hb_parl (7);

	tvi.mask       = TVIF_TEXT | TVIF_IMAGE | TVIF_SELECTEDIMAGE | TVIF_PARAM ;
	tvi.pszText		= ItemText;
	tvi.cchTextMax		= sizeof (ItemText) / sizeof (TCHAR);
	tvi.iImage 	   	= hb_parni(4) ;
	tvi.iSelectedImage	= hb_parni(5) ;
	tvi.lParam		= nID;

	is.item   = tvi;

	if ( PrevItemHandle == 0 )
	{
		is.hInsertAfter = PrevItemHandle;
		is.hParent      = NULL;
	}
	else
	{
		is.hInsertAfter = TVI_LAST;
		is.hParent      = PrevItemHandle;
	}

	ItemHandle = TreeView_InsertItem(hWndTV, &is);

   AddTreeItemLPARAM (hWndTV, ItemHandle, nID, IsNodeFlag);

	HMG_retnl ((LONG_PTR) ItemHandle ) ;

}


//---------------------------------------------------------------------------------------------

void TreeView_FreeMemoryLPARAMRecursive (HWND hWndTV, HTREEITEM ItemHandle)
{
   TV_ITEM TreeItem;
   TreeItem.mask   = TVIF_PARAM;
   TreeItem.hItem  = ItemHandle;
   TreeItem.lParam = (LPARAM) NULL;
   TreeView_GetItem ( hWndTV , &TreeItem );
   HMG_StructTreeItemLPARAM * TreeItemLPARAM = (HMG_StructTreeItemLPARAM *) TreeItem.lParam;
   if (TreeItemLPARAM != NULL)
   {  hb_xfree ( TreeItemLPARAM );
      TreeItem.lParam = (LPARAM) NULL;      // for security set lParam = NULL
      TreeView_SetItem ( hWndTV , &TreeItem );
   }

   HTREEITEM ChildItem = TreeView_GetChild ( hWndTV , ItemHandle );
   while ( ChildItem != NULL )
   {  TreeView_FreeMemoryLPARAMRecursive (hWndTV, ChildItem);
      HTREEITEM NextItem = TreeView_GetNextSibling (hWndTV, ChildItem);
      ChildItem = NextItem;
   }
}


HB_FUNC (DELETETREEITEM)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);

   TreeView_FreeMemoryLPARAMRecursive (hWndTV, ItemHandle);

   TreeView_DeleteItem ( hWndTV , ItemHandle ) ;
}

//---------------------------------------------------------------------------------------------


HB_FUNC (DELETEALLTREEITEMS)
{
   HWND hWndTV = (HWND) HMG_parnl (1);

   int  nCount = (int) hb_parinfa (2, 0);
   int  i;
   TV_ITEM TreeItem;
   for (i=1; i <= nCount; i++)
   {  TreeItem.mask   = TVIF_PARAM;
      TreeItem.hItem  = (HTREEITEM) HMG_parvnl (2, i);
      TreeItem.lParam = (LPARAM) 0;
      TreeView_GetItem ( hWndTV , &TreeItem );
      HMG_StructTreeItemLPARAM * TreeItemLPARAM = (HMG_StructTreeItemLPARAM *) TreeItem.lParam;
      if (TreeItemLPARAM != NULL)
         hb_xfree ( TreeItemLPARAM );
   }

   TreeView_DeleteAllItems ( hWndTV ) ;
}


HB_FUNC (TREEVIEW_GETSELECTIONID)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) TreeView_GetSelection ( hWndTV );

   if (ItemHandle == NULL)
       return;   // return NIL

   TV_ITEM TreeItem ;
   TreeItem.mask   = TVIF_PARAM;
   TreeItem.hItem  = ItemHandle;
   TreeItem.lParam = (LPARAM) 0;
   TreeView_GetItem ( hWndTV , &TreeItem );

   HMG_StructTreeItemLPARAM * TreeItemLPARAM = (HMG_StructTreeItemLPARAM *) TreeItem.lParam;
   hb_retnl ((LONG) TreeItemLPARAM->nID);
}


HB_FUNC (TREEVIEW_GETSELECTION)
{
   HWND      hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) TreeView_GetSelection( hWndTV );

   if (ItemHandle == NULL)
       return;   // return NIL

   HMG_retnl  ((LONG_PTR) ItemHandle );
}


HB_FUNC (TREEVIEW_SELECTITEM)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   TreeView_SelectItem ( hWndTV , ItemHandle ) ;
}




HB_FUNC (TREEVIEW_GETCOUNT)
{
   HWND  hWndTV = (HWND) HMG_parnl (1);
   HMG_retnl ((LONG_PTR) TreeView_GetCount (hWndTV) );
}



HB_FUNC (TREEVIEW_GETITEM)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   TV_ITEM     TreeItem ;
   TCHAR       ItemText [ MAX_ITEM_TEXT ] ;

   memset ( &TreeItem, 0, sizeof(TV_ITEM) );

   TreeItem.mask       = TVIF_TEXT ;
   TreeItem.hItem      = ItemHandle ;
   TreeItem.pszText    = ItemText ;
   TreeItem.cchTextMax = sizeof (ItemText) / sizeof (TCHAR);

   TreeView_GetItem ( hWndTV , &TreeItem );
   HMG_retc ( ItemText );
}


HB_FUNC (TREEVIEW_SETITEM)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   TV_ITEM     TreeItem;
   TCHAR       ItemText [ MAX_ITEM_TEXT ];

   memset(&TreeItem, 0, sizeof(TV_ITEM)) ;
   lstrcpy ( ItemText , HMG_parc(3) ) ;

   TreeItem.mask       = TVIF_TEXT ;
   TreeItem.hItem      = ItemHandle ;
   TreeItem.pszText    = ItemText ;
   TreeItem.cchTextMax = sizeof (ItemText) / sizeof (TCHAR);

   TreeView_SetItem ( hWndTV , &TreeItem ) ;
}


HB_FUNC (TREEVIEW_GETPARENT)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   HTREEITEM   ParentItemHandle = TreeView_GetParent ( hWndTV , ItemHandle );
   HMG_retnl ((LONG_PTR) ParentItemHandle ) ;
}


HB_FUNC (TREEVIEW_GETCHILD)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   HTREEITEM   ChildItemHandle = TreeView_GetChild ( hWndTV , ItemHandle );
   HMG_retnl ((LONG_PTR) ChildItemHandle );
}


HB_FUNC (TREEVIEW_GETPREVSIBLING)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   HTREEITEM   PrevItemHandle = TreeView_GetPrevSibling ( hWndTV , ItemHandle ) ;
   HMG_retnl ((LONG_PTR) PrevItemHandle ) ;
}


HB_FUNC (TREEVIEW_GETNEXTSIBLING)
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   HTREEITEM   NextItemHandle = TreeView_GetNextSibling ( hWndTV , ItemHandle ) ;
   HMG_retnl ((LONG_PTR) NextItemHandle ) ;
}


//-----------------------------------------------------------------------------------
// by Dr. Claudio Soto (October 2013)
//-----------------------------------------------------------------------------------

HB_FUNC (TREEVIEW_GETROOT)
{
   HWND hWndTV = (HWND) HMG_parnl (1);
   HTREEITEM RootItemHandle = TreeView_GetRoot ( hWndTV );
   HMG_retnl ((LONG_PTR) RootItemHandle ) ;
}


HB_FUNC (TREEVIEW_SORTCHILDREN)
{
   HWND      hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);
   BOOL      fRecurse   = (BOOL)      hb_parl  (3);
   hb_retl ((BOOL) TreeView_SortChildren (hWndTV, ItemHandle, fRecurse));
}


HB_FUNC (TREEVIEW_DELETECHILDREN)
{
   HWND      hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);

   HTREEITEM ChildItem = TreeView_GetChild (hWndTV, ItemHandle);
   while ( ChildItem != NULL )
   {
      HTREEITEM NextItem = TreeView_GetNextSibling (hWndTV, ChildItem);
      TreeView_DeleteItem (hWndTV, ChildItem);
      ChildItem = NextItem;
   }
}



//       TreeView_SetTextColor (hWndTV, {R,G,B} )
HB_FUNC (TREEVIEW_SETTEXTCOLOR)
{
   HWND      hWndTV  = (HWND) HMG_parnl (1);
   INT       nRed    = (INT)  hb_parvni (2,1);
   INT       nGreen  = (INT)  hb_parvni (2,2);
   INT       nBlue   = (INT)  hb_parvni (2,3);
   COLORREF  clrText = RGB ( nRed, nGreen, nBlue );

   TreeView_SetTextColor (hWndTV, clrText);
}


//       TreeView_SetBkColor (hWndTV, {R,G,B} )
HB_FUNC (TREEVIEW_SETBKCOLOR)
{
   HWND      hWndTV  = (HWND) HMG_parnl (1);
   INT       nRed    = (INT)  hb_parvni (2,1);
   INT       nGreen  = (INT)  hb_parvni (2,2);
   INT       nBlue   = (INT)  hb_parvni (2,3);
   COLORREF  clrBk   = RGB ( nRed, nGreen, nBlue );

   TreeView_SetBkColor (hWndTV, clrBk);
}


//       TreeView_SetLineColor (hWndTV, {R,G,B} )
HB_FUNC (TREEVIEW_SETLINECOLOR)
{
   HWND      hWndTV  = (HWND) HMG_parnl (1);
   INT       nRed    = (INT)  hb_parvni (2,1);
   INT       nGreen  = (INT)  hb_parvni (2,2);
   INT       nBlue   = (INT)  hb_parvni (2,3);
   COLORREF  clrLine = RGB ( nRed, nGreen, nBlue );

   #ifndef TreeView_SetLineColor
      #define TreeView_SetLineColor(w,c) (COLORREF)SNDMSG((w),TVM_SETLINECOLOR,0,(LPARAM)(c))
   #endif
   TreeView_SetLineColor (hWndTV, clrLine);
}


HB_FUNC (TREEVIEW_SETINSERTMARK)
{
   HWND      hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);
   BOOL      fAfter     = (BOOL)      hb_parl  (3);
   hb_retl ((BOOL) TreeView_SetInsertMark (hWndTV, ItemHandle, fAfter));
}



#ifndef TreeView_SetCheckState
   void TreeView_SetCheckState (HWND hTreeView, HTREEITEM hItem, BOOL fCheck)
   {
      TVITEM tvi;
      tvi.mask = TVIF_STATE;
      tvi.hItem = hItem;
      tvi.state = INDEXTOSTATEIMAGEMASK((fCheck ? 2 : 1));
      tvi.stateMask = TVIS_STATEIMAGEMASK;
      TreeView_SetItem (hTreeView, &tvi);
   }
#endif


HB_FUNC (TREEVIEW_SETCHECKSTATE)
{
   HWND      hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);
   BOOL      fCheck     = (BOOL)      hb_parl  (3);

   TreeView_SetCheckState (hWndTV, ItemHandle, fCheck);
}



HB_FUNC ( TREEVIEW_SETITEMSTATE )
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   UINT        State      = (UINT)   hb_parni (3);
   UINT        StateMask  = (UINT)   hb_parni (4);

   TreeView_SetItemState (hWndTV, ItemHandle, State, StateMask);
}


HB_FUNC ( TREEVIEW_GETITEMSTATE )
{
   HWND        hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   UINT        StateMask  = (UINT)   hb_parni (3);
   UINT        State      = TreeView_GetItemState (hWndTV, ItemHandle, StateMask);
   hb_retni ((INT) State);
}



//**************************************************
//    by  Dr. Claudio Soto  (November 2013)
//**************************************************


BOOL TreeView_IsNode (HWND hWndTV, HTREEITEM ItemHandle)
{   if ( TreeView_GetChild (hWndTV , ItemHandle) != NULL )
        return TRUE;
    else
        return FALSE;
}


//--------------------------------------------------------------------------------------------------------
//   TreeView_ExpandChildrenRecursive ( hWndTV, ItemHandle, nExpand, fRecurse )
//--------------------------------------------------------------------------------------------------------

void TreeView_ExpandChildrenRecursive (HWND hWndTV, HTREEITEM ItemHandle, UINT nExpand)
{
   if ( TreeView_IsNode ( hWndTV, ItemHandle ) )
   {
        TreeView_Expand ( hWndTV, ItemHandle, nExpand );
        HTREEITEM ChildItem = TreeView_GetChild ( hWndTV , ItemHandle );
        // HB_FUNC_EXEC ( DOEVENTS );
        while ( ChildItem != NULL )
        {
            TreeView_ExpandChildrenRecursive (hWndTV, ChildItem, nExpand);

            HTREEITEM NextItem = TreeView_GetNextSibling (hWndTV, ChildItem);
            ChildItem = NextItem;
        }
   }
}


HB_FUNC (TREEVIEW_EXPANDCHILDRENRECURSIVE)
{
   HWND      hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);
   UINT      nExpand    = (UINT)      hb_parnl (3);
   BOOL      fRecurse   = (BOOL)      hb_parl  (4);

   if ( fRecurse == FALSE )
      TreeView_Expand ( hWndTV, ItemHandle, nExpand );
   else
   {
      HWND hWndParent = GetParent (hWndTV);
      BOOL lEnabled   = IsWindowEnabled (hWndParent);

      EnableWindow (hWndParent, FALSE);

      TreeView_ExpandChildrenRecursive ( hWndTV, ItemHandle, nExpand );

      if (lEnabled == TRUE)
          EnableWindow (hWndParent, TRUE);
   }
}



//--------------------------------------------------------------------------------------------------------
//   TreeView_SortChildrenRecursive ( hWndTV, ItemHandle, fRecurse )
//--------------------------------------------------------------------------------------------------------

void TreeView_SortChildrenRecursive (HWND hWndTV, HTREEITEM ItemHandle)
{
   if ( TreeView_IsNode ( hWndTV, ItemHandle ) )
   {
      TreeView_SortChildren ( hWndTV, ItemHandle, FALSE );
      HTREEITEM ChildItem = TreeView_GetChild ( hWndTV , ItemHandle );
      // HB_FUNC_EXEC ( DOEVENTS );
      while ( ChildItem != NULL )
      {
         TreeView_SortChildrenRecursive (hWndTV, ChildItem);

         HTREEITEM NextItem = TreeView_GetNextSibling (hWndTV, ChildItem);
         ChildItem = NextItem;
      }
   }
}


HB_FUNC (TREEVIEW_SORTCHILDRENRECURSIVE)
{
   HWND      hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);
   BOOL      fRecurse   = (BOOL)      hb_parl  (3);

   if ( fRecurse == FALSE )
      TreeView_SortChildren ( hWndTV, ItemHandle, FALSE );
   else
      TreeView_SortChildrenRecursive (hWndTV, ItemHandle);
}


//---------------------------------------------------------------------------------------------------------------------
// TreeView_SortChildrenRecursiveCB ( hWndTV, ItemHandle, fRecurse, lCaseSensitive, lAscendingOrder, nNodePosition )
//---------------------------------------------------------------------------------------------------------------------

#define SORTTREENODE_FIRST  0
#define SORTTREENODE_LAST   1
#define SORTTREENODE_MIX    2

typedef struct {
   HWND   hWndTV;
   BOOL   CaseSensitive;
   BOOL   AscendingOrder;
   int    NodePosition;
} HMG_StructTreeViewCompareInfo;


int CALLBACK TreeViewCompareFunc (LPARAM lParam1, LPARAM lParam2, LPARAM lParamSort)
{
   // lParam1 = HMG_StructTreeItemLPARAM1
   // lParam2 = HMG_StructTreeItemLPARAM2
   // lParamSort = HMG_StructTreeViewCompareInfo

   HMG_StructTreeItemLPARAM * TreeItemLPARAM1 = (HMG_StructTreeItemLPARAM *) lParam1;
   HMG_StructTreeItemLPARAM * TreeItemLPARAM2 = (HMG_StructTreeItemLPARAM *) lParam2;

   HMG_StructTreeViewCompareInfo *TreeViewCompareInfo = (HMG_StructTreeViewCompareInfo*) lParamSort;

   HWND hWndTV = TreeViewCompareInfo->hWndTV;

   HTREEITEM ItemHandle1 = (HTREEITEM) TreeItemLPARAM1->ItemHandle;
   HTREEITEM ItemHandle2 = (HTREEITEM) TreeItemLPARAM2->ItemHandle;

   TCHAR ItemText1 [ MAX_ITEM_TEXT ];
   TV_ITEM TV_Item1;
   TV_Item1.mask        = TVIF_TEXT;
   TV_Item1.pszText     = ItemText1;
   TV_Item1.cchTextMax  = sizeof (ItemText1) / sizeof (TCHAR);
   TV_Item1.hItem       = (HTREEITEM) ItemHandle1;
   TreeView_GetItem (hWndTV, &TV_Item1);

   TCHAR ItemText2 [ MAX_ITEM_TEXT ];
   TV_ITEM TV_Item2;
   TV_Item2.mask        = TVIF_TEXT;
   TV_Item2.pszText     = ItemText2;
   TV_Item2.cchTextMax  = sizeof (ItemText2) / sizeof (TCHAR);
   TV_Item2.hItem       = (HTREEITEM) ItemHandle2;
   TreeView_GetItem (hWndTV, &TV_Item2);

   BOOL IsTreeNode1 = (TreeItemLPARAM1->IsNodeFlag == TRUE || TreeView_GetChild (hWndTV, ItemHandle1) != NULL)? TRUE : FALSE;
   BOOL IsTreeNode2 = (TreeItemLPARAM2->IsNodeFlag == TRUE || TreeView_GetChild (hWndTV, ItemHandle2) != NULL)? TRUE : FALSE;

   int CmpValue;

   if (TreeViewCompareInfo->CaseSensitive == FALSE)
      CmpValue = lstrcmpi (ItemText1, ItemText2);
   else
      CmpValue = lstrcmp  (ItemText1, ItemText2);


   if (TreeViewCompareInfo->AscendingOrder == FALSE)
      CmpValue = CmpValue * (-1);

   if (TreeViewCompareInfo->NodePosition == SORTTREENODE_FIRST)
   {  if (IsTreeNode1 == TRUE  && IsTreeNode2 == FALSE)
         return -1;
      if (IsTreeNode1 == FALSE && IsTreeNode2 == TRUE)
         return +1;
   }

   if (TreeViewCompareInfo->NodePosition == SORTTREENODE_LAST)
   {  if (IsTreeNode1 == TRUE  && IsTreeNode2 == FALSE)
         return +1;
      if (IsTreeNode1 == FALSE && IsTreeNode2 == TRUE)
         return -1;
   }

   return CmpValue;
}



void TreeView_SortChildrenRecursiveCB (HWND hWndTV, TVSORTCB TVSortCB)
{
   if ( TreeView_IsNode ( hWndTV, TVSortCB.hParent ) )
   {
      TreeView_SortChildrenCB (hWndTV, &TVSortCB, 0);
      HTREEITEM ChildItem = TreeView_GetChild ( hWndTV , TVSortCB.hParent );
      // HB_FUNC_EXEC ( DOEVENTS );
      while ( ChildItem != NULL )
      {
         TVSortCB.hParent = (HTREEITEM) ChildItem;
         TreeView_SortChildrenRecursiveCB (hWndTV, TVSortCB);

         HTREEITEM NextItem = TreeView_GetNextSibling (hWndTV, ChildItem);
         ChildItem = NextItem;
      }
   }
}


HB_FUNC (TREEVIEW_SORTCHILDRENRECURSIVECB)
{
   HWND      hWndTV          = (HWND)      HMG_parnl (1);
   HTREEITEM ItemHandle      = (HTREEITEM) HMG_parnl (2);
   BOOL      fRecurse        = (BOOL)      hb_parl  (3);
   BOOL      lCaseSensitive  = (BOOL)      hb_parl  (4);
   BOOL      lAscendingOrder = (BOOL)      hb_parl  (5);
   INT       nNodePosition   = (INT)       hb_parnl (6);

   HMG_StructTreeViewCompareInfo TreeViewCompareInfo;

   TreeViewCompareInfo.hWndTV          = hWndTV;
   TreeViewCompareInfo.CaseSensitive   = lCaseSensitive;
   TreeViewCompareInfo.AscendingOrder  = lAscendingOrder;
   TreeViewCompareInfo.NodePosition    = nNodePosition;

   TVSORTCB  TVSortCB;
   TVSortCB.hParent     = (HTREEITEM)    ItemHandle;
   TVSortCB.lpfnCompare = (PFNTVCOMPARE) TreeViewCompareFunc;
   TVSortCB.lParam      = (LPARAM)      &TreeViewCompareInfo;

   if (fRecurse == FALSE)
      TreeView_SortChildrenCB (hWndTV, &TVSortCB, 0);
   else
   {
      HWND hWndParent = GetParent (hWndTV);
      BOOL lEnabled   = IsWindowEnabled (hWndParent);

      EnableWindow (hWndParent, FALSE);

      TreeView_SortChildrenRecursiveCB (hWndTV, TVSortCB);

      if (lEnabled == TRUE)
          EnableWindow (hWndParent, TRUE);
   }
}


//--------------------------------------------------------------------------------------------------------



HB_FUNC (TREEITEM_ISTRUENODE)
{
   HWND      hWndTV     = (HWND) HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);
   if ( TreeView_GetChild (hWndTV , ItemHandle) != NULL )
      return hb_retl (TRUE);
   else
      return hb_retl (FALSE);
}



HB_FUNC (TREEITEM_SETNODEFLAG)
{
   HWND      hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);
   BOOL      IsNodeFlag = (BOOL)      hb_parl  (3);

   TV_ITEM TreeItem;
   TreeItem.mask   = TVIF_PARAM;
   TreeItem.hItem  = ItemHandle;
   TreeItem.lParam = (LPARAM) 0;
   TreeView_GetItem ( hWndTV , &TreeItem );

   HMG_StructTreeItemLPARAM * TreeItemLPARAM = (HMG_StructTreeItemLPARAM *) TreeItem.lParam;
   TreeItemLPARAM->IsNodeFlag = IsNodeFlag;
   TreeItem.lParam = (LPARAM) TreeItemLPARAM;
   TreeView_SetItem ( hWndTV , &TreeItem );
}


HB_FUNC (TREEITEM_GETNODEFLAG)
{
   HWND      hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM ItemHandle = (HTREEITEM) HMG_parnl (2);

   TV_ITEM TreeItem;
   TreeItem.mask   = TVIF_PARAM;
   TreeItem.hItem  = ItemHandle;
   TreeItem.lParam = (LPARAM) 0;
   TreeView_GetItem ( hWndTV , &TreeItem );

   HMG_StructTreeItemLPARAM * TreeItemLPARAM = (HMG_StructTreeItemLPARAM *) TreeItem.lParam;
   hb_retl ((BOOL) TreeItemLPARAM->IsNodeFlag);
}


HB_FUNC (TREEITEM_GETID)
{
   HWND        hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);

   TV_ITEM TreeItem ;
   TreeItem.mask   = TVIF_PARAM;
   TreeItem.hItem  = ItemHandle;
   TreeItem.lParam = (LPARAM) 0;
   if ( TreeView_GetItem ( hWndTV , &TreeItem ) == TRUE)
   {
      HMG_StructTreeItemLPARAM * TreeItemLPARAM = (HMG_StructTreeItemLPARAM *) TreeItem.lParam;
      hb_retnl ((LONG) TreeItemLPARAM->nID);
   }
}


//        TreeView_SetImageList ( hWnd , hImageList , [iImageList] )
HB_FUNC ( TREEVIEW_SETIMAGELIST )
{
   HWND hWnd = (HWND) HMG_parnl (1);
   HIMAGELIST hImageList = (HIMAGELIST) HMG_parnl (2);
   int iImageList = HB_ISNIL(3) ? TVSIL_NORMAL : hb_parni (3);
   HIMAGELIST hImageListPrevious = TreeView_SetImageList (hWnd, hImageList, iImageList);
   HMG_retnl ((LONG_PTR) hImageListPrevious);
}


//        TreeView_GetImageList ( hWnd , [iImageList] ) --> hImageList
HB_FUNC ( TREEVIEW_GETIMAGELIST )
{
   HWND hWnd      = (HWND) HMG_parnl (1);
   int iImageList = HB_ISNIL(2) ? TVSIL_NORMAL : hb_parni (2);
   HIMAGELIST hImageList = TreeView_GetImageList (hWnd, iImageList);
   HMG_retnl ((LONG_PTR) hImageList);
}



//       TreeItem_GetImageIndex ( hWndTV, ItemHandle , @iUnSel , @iSelectedImage ) --> Return { iUnSel , iSelectedImage }
HB_FUNC (TREEITEM_GETIMAGEINDEX)
{
   HWND        hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);

   TV_ITEM TreeItem ;
   TreeItem.mask           = TVIF_IMAGE | TVIF_SELECTEDIMAGE ;
   TreeItem.hItem          = ItemHandle;
   TreeItem.iImage         = 0;
   TreeItem.iSelectedImage = 0;
   TreeView_GetItem ( hWndTV , &TreeItem );

   INT iUnSel         = TreeItem.iImage;
   INT iSelectedImage = TreeItem.iSelectedImage;

   if (HB_ISBYREF(3))
       hb_storni ((INT) iUnSel, 3);

   if (HB_ISBYREF(4))
       hb_storni ((INT) iSelectedImage, 4);

   hb_reta( 2 );
   hb_storvni((INT) iUnSel,          -1, 1 );
   hb_storvni((INT) iSelectedImage , -1, 2 );
}


//       TreeItem_SetImageIndex ( hWndTV, ItemHandle , iUnSel , iSelectedImage )
HB_FUNC (TREEITEM_SETIMAGEINDEX)
{
   HWND        hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   INT iUnSel             = (INT)       hb_parni (3);
   INT iSelectedImage     = (INT)       hb_parni (4);

   TV_ITEM TreeItem ;
   TreeItem.mask           = TVIF_IMAGE | TVIF_SELECTEDIMAGE;
   TreeItem.hItem          = ItemHandle;
   TreeItem.iImage         = iUnSel;
   TreeItem.iSelectedImage = iSelectedImage;
   TreeView_SetItem ( hWndTV , &TreeItem );
}



HB_FUNC (TREEVIEW_GETIMAGECOUNT)
{
   HWND       hWndTV     = (HWND) HMG_parnl (1);
   HIMAGELIST hImageList = TreeView_GetImageList ( hWndTV, TVSIL_NORMAL );
   INT        ic         = ImageList_GetImageCount ( hImageList );
   hb_retni ((INT) ic);
}


HB_FUNC ( TREEVIEW_SETHASBUTTON )
{
   HWND        hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);
   BOOL        lHasButton = (BOOL)      hb_parl   (3);

   TV_ITEM TreeItem;
   TreeItem.mask      = TVIF_CHILDREN;
   TreeItem.hItem     = ItemHandle;
   TreeItem.cChildren = lHasButton ? 1 : 0;
   TreeView_SetItem ( hWndTV , &TreeItem );
}


HB_FUNC ( TREEVIEW_GETHASBUTTON )
{
   HWND        hWndTV     = (HWND)      HMG_parnl (1);
   HTREEITEM   ItemHandle = (HTREEITEM) HMG_parnl (2);

   TV_ITEM TreeItem;
   TreeItem.mask  = TVIF_CHILDREN;
   TreeItem.hItem = ItemHandle;
   TreeView_GetItem ( hWndTV , &TreeItem );
   hb_retl ((BOOL) (TreeItem.cChildren == 0 ? FALSE : TRUE));
}



// HWND TreeView_EditLabel (HWND hwndTV, HTREEITEM hitem);
// BOOL TreeView_EndEditLabelNow (HWND hwndTV, BOOL fCancel);
// HWND TreeView_GetEditControl (HWND hwndTV);


// BOOL TreeView_EnsureVisible (HWND hwndTV, HTREEITEM hitem);
// HTREEITEM TreeView_GetFirstVisible (HWND hwndTV);
// HTREEITEM TreeView_GetLastVisible (HWND hwndTV);
// UINT TreeView_GetVisibleCount (HWND hwndTV);
// HTREEITEM TreeView_HitTest (HWND hwndTV, LPTVHITTESTINFO lpht);


// COLORREF TreeView_SetInsertMarkColor (HWND hwndTV, COLORREF clrInsertMark);

