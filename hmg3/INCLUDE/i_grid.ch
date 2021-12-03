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


// Style   -->   HMG_ChangeWindowStyle ( hWnd, [ nAddStyle ], [ nRemoveStyle ], [ lExStyle ] )
#define LVS_ICON	0
#define LVS_REPORT	1
#define LVS_SMALLICON	2
#define LVS_LIST	3
#define LVS_TYPEMASK	3
#define LVS_SINGLESEL	4
#define LVS_SHOWSELALWAYS	8
#define LVS_SORTASCENDING	16
#define LVS_SORTDESCENDING	32
#define LVS_SHAREIMAGELISTS	64
#define LVS_NOLABELWRAP	128
#define LVS_AUTOARRANGE	256
#define LVS_EDITLABELS	512
#define LVS_NOSCROLL	0x2000
#define LVS_TYPESTYLEMASK	0xfc00
#define LVS_ALIGNTOP	0
#define LVS_ALIGNLEFT	0x800
#define LVS_ALIGNMASK	0xc00
#define LVS_OWNERDRAWFIXED	0x400
#define LVS_NOCOLUMNHEADER	0x4000
#define LVS_NOSORTHEADER	0x8000


// Extended Style   -->   ListView_ChangeExtendedStyle ( hWnd, [ nAddStyle ], [ nRemoveStyle ] )
#define LVS_EX_CHECKBOXES 4
#define LVS_EX_FULLROWSELECT 32
#define LVS_EX_GRIDLINES 1
#define LVS_EX_HEADERDRAGDROP 16
#define LVS_EX_ONECLICKACTIVATE 64
#define LVS_EX_SUBITEMIMAGES 2
#define LVS_EX_TRACKSELECT 8
#define LVS_EX_TWOCLICKACTIVATE 128
#define LVSICF_NOINVALIDATEALL	0x00000001
#define LVSICF_NOSCROLL	0x00000002
#define LVS_EX_FLATSB	0x00000100
#define LVS_EX_REGIONAL	0x00000200
#define LVS_EX_INFOTIP	0x00000400
#define LVS_EX_UNDERLINEHOT	0x00000800
#define LVS_EX_UNDERLINECOLD	0x00001000
#define LVS_EX_MULTIWORKAREAS	0x00002000
#define LVS_EX_LABELTIP	0x00004000
#define LVS_EX_BORDERSELECT	0x00008000
#define LVS_EX_SNAPTOGRID 0x80000
#define LVS_EX_DOUBLEBUFFER 0x10000


// View Style   -->   ListView_ChangeView ( hWnd, [ nNewView ] ) --> nOldView
#define LV_VIEW_ICON       0x0
#define LV_VIEW_DETAILS    0x1
#define LV_VIEW_SMALLICON  0x2
#define LV_VIEW_LIST       0x3
#define LV_VIEW_TILE       0x4
#define LV_VIEW_MAX        0x4


// ImageList Icon   -->   ListView_SetImageList ( hWnd , hImageList , [iImageList] )   //   ListView_GetImageList ( hWnd , [iImageList] )
#define LVSIL_NORMAL   0
#define LVSIL_SMALL    1
#define LVSIL_STATE    2



#define GRID_JTFY_LEFT           0
#define GRID_JTFY_RIGHT          1
#define GRID_JTFY_CENTER         2
#define GRID_JTFY_JUSTIFYMASK    3
#define GRID_JTFY_HEADERIMAGERIGHT     4096


#define GRID_EDIT_DEFAULT       0
#define GRID_EDIT_SELECTALL     1
#define GRID_EDIT_INSERTBLANK   2
#define GRID_EDIT_INSERTCHAR    3
#define GRID_EDIT_REPLACEALL    4



#define GRID_GROUP_LEFT   0x01
#define GRID_GROUP_CENTER 0x02
#define GRID_GROUP_RIGHT  0x04

#define GRID_GROUP_NORMAL    0x01
#define GRID_GROUP_COLLAPSED 0x02
#define GRID_GROUP_HIDDEN    0x04



///////////////////////////////////////////////////////////////////////////////
// GRID (STANDARD VERSION)
///////////////////////////////////////////////////////////////////////////////
#xcommand @ <row>,<col> GRID <name> 			;
		[ <dummy1: OF, PARENT> <parent> ]	;
		[ WIDTH <w> ] 				;
		[ HEIGHT <h> ] 				;
		[ HEADERS <headers> ] 			;
		[ WIDTHS <widths> ] 			;
		[ ITEMS <rows> ] 			;
		[ VALUE <value> ] 			;
		[ FONT <fontname> ] 			;
		[ SIZE <fontsize> ] 			;
		[ <bold : BOLD> ]			;
		[ <italic : ITALIC> ]			;
		[ <underline : UNDERLINE> ]		;
		[ <strikeout : STRIKEOUT> ]		;
		[ TOOLTIP <tooltip> ]  			;
		[ BACKCOLOR <backcolor> ]		;
		[ FONTCOLOR <fontcolor> ]		;
		[ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
		[ ON GOTFOCUS <gotfocus> ] 		;
		[ ON CHANGE <change> ]  		;
		[ ON LOSTFOCUS <lostfocus> ] 		;
		[ ON DBLCLICK <dblclick> ]  		;
		[ ON HEADCLICK <aHeadClick> ] 		;
		[ <edit : EDIT> ]			;
		[ COLUMNCONTROLS <editcontrols> ]	;
		[ COLUMNVALID <columnvalid> ]		;
		[ COLUMNWHEN <columnwhen> ]		;
		[ <ownerdata: VIRTUAL> ] 		;
		[ ITEMCOUNT <itemcount> ]		;
		[ ON QUERYDATA <dispinfo> ] 		;
		[ <multiselect: MULTISELECT> ]		;
		[ <style: NOLINES> ] 			;
		[ <noshowheaders: NOHEADERS> ]		;
		[ IMAGE <aImage> ] 			;
		[ JUSTIFY <aJust> ] 			;
		[ HELPID <helpid> ] 			;
		[ <break: BREAK> ] 			;                             
		[ HEADERIMAGES <headerimages> ]		;
		[ <cellnavigation: CELLNAVIGATION> ]	;                             
		[ ROWSOURCE <recordsource> ]		;
		[ COLUMNFIELDS <columnfields> ]		;
		[ <append : ALLOWAPPEND> ]		;
		[ <buffered : BUFFERED> ]		;
		[ <allowdelete : ALLOWDELETE> ]		;
		[ DYNAMICDISPLAY <dynamicdisplay> ] ;
		[ ON SAVE <onsave> ]  		;
		[ LOCKCOLUMNS <lockcolumns> ]		;
      [ ON CLICK <onclick> ]  ;
      [ ON KEY <onkey> ]  ;
      [ EDITOPTION <EditOption>]  ;
      [ <notrans : NOTRANSPARENT> ] ;
      [ <notransheader : NOTRANSPARENTHEADER> ] ;
      [ DYNAMICFONT <aDynamicFont> ] ;
      [ ON CHECKBOXCLICKED <OnCheckBoxClicked> ] ;
      [ ON INPLACEEDITEVENT <OnInplaceEditEvent> ];
	=>;
_DefineGrid ( <"name"> , 		;
		<"parent"> , 		;
		<col> ,			;
		<row> ,			;
		<w> , 			;
		<h> , 			;
		<headers> , 		;
		<widths> , 		;
		<rows> , 		;
		<value> ,		;
		<fontname> , 		;
		<fontsize> , 		;
		<tooltip> , 		;
		<{change}> ,		;
		<{dblclick}> ,  	;
		<aHeadClick> ,		;
		<{gotfocus}> ,		;
		<{lostfocus}>,  	; 
		<.style.>,		;
		<aImage>,		;
		<aJust>  , 		;
		<.break.> , 		;
		<helpid> ,		;
		<.bold.>, 		;
		<.italic.>, 		;
		<.underline.>, 		;
		<.strikeout.> , 	;
		<.ownerdata.> , 	;
		<{dispinfo}> ,  	;
		<itemcount> , 		;
		 ,  			;
		Nil , 			;
		Nil ,			;
		<.multiselect.> , 	;
		Nil , 			;
		<backcolor> ,		;
		<fontcolor> ,		;
		<.edit.> ,		;
		<editcontrols> ,	;
		<dynamicbackcolor> ,	;
		<dynamicforecolor> ,	;
		<columnvalid> , 	;
		<columnwhen> ,		;
		!<.noshowheaders.> ,	;
		<headerimages> ,	;
		<.cellnavigation.> ,	;
		<recordsource>	,	;
		<columnfields>	,	;
		<.append.>    ,   	;
		<.buffered.>  ,     	;
		<.allowdelete.> ,	;
		<dynamicdisplay> ,	;
		<{onsave}>	,	;
		<lockcolumns>	,	;
      <{onclick}> ,;
      <{onkey}> ,;
      <EditOption>, ;
      <.notrans.> , <.notransheader.> , <aDynamicFont> , <{OnCheckBoxClicked}> , <{OnInplaceEditEvent}> ) 


///////////////////////////////////////////////////////////////////////////////
// GRID (SPLITBOX VERSION)
///////////////////////////////////////////////////////////////////////////////
#xcommand GRID <name> 		;
		[ <dummy1: OF, PARENT> <parent> ] ;
		[ WIDTH <w> ] 			;
		[ HEIGHT <h> ] 			;
		[ HEADERS <headers> ] 		;
		[ WIDTHS <widths> ] 		;
		[ ITEMS <rows> ] 		;
		[ VALUE <value> ] 		;
		[ FONT <fontname> ] 		;
		[ SIZE <fontsize> ] 		;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ]  		;
		[ BACKCOLOR <backcolor> ] ;
		[ FONTCOLOR <fontcolor> ] ;
		[ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
		[ ON GOTFOCUS <gotfocus> ] 	;
		[ ON CHANGE <change> ]  	;
		[ ON LOSTFOCUS <lostfocus> ] 	;
		[ ON DBLCLICK <dblclick> ]  	;
		[ ON HEADCLICK <aHeadClick> ] 	;
		[ <edit : EDIT> ]		;
		[ COLUMNCONTROLS <editcontrols> ]	;
		[ COLUMNVALID <columnvalid> ]	;
		[ COLUMNWHEN <columnwhen> ]	;
		[ <ownerdata: VIRTUAL> ] 	;
		[ ITEMCOUNT <itemcount> ]	;
		[ ON QUERYDATA <dispinfo> ] 	;
		[ <multiselect: MULTISELECT> ]	;
		[ <style: NOLINES> ] 		;
		[ <noshowheaders: NOHEADERS> ]	;
		[ IMAGE <aImage> ] 		;
		[ JUSTIFY <aJust> ] 		;
		[ HELPID <helpid> ] 		;
		[ <break: BREAK> ] 		;                             
		[ HEADERIMAGES <headerimages> ] ;
		[ <cellnavigation: CELLNAVIGATION> ] 		;                             
		[ ROWSOURCE <recordsource> ]		;
		[ COLUMNFIELDS <columnfields> ]		;
		[ <append : APPEND> ]			;
		[ <buffered : BUFFERED> ]		;
		[ <allowdelete : ALLOWDELETE> ]		;
		[ DYNAMICDISPLAY <dynamicdisplay> ]     ;
		[ ON SAVE <onsave> ]  		;
		[ LOCKCOLUMNS <lockcolumns> ]		;
      [ ON CLICK <onclick> ]  ;
      [ ON KEY <onkey> ]  ;
      [ EDITOPTION <EditOption>]  ;
      [ <notrans : NOTRANSPARENT> ] ;
      [ <notransheader : NOTRANSPARENTHEADER> ] ;
      [ DYNAMICFONT <aDynamicFont> ] ;
      [ ON CHECKBOXCLICKED <OnCheckBoxClicked> ] ;
      [ ON INPLACEEDITEVENT <OnInplaceEditEvent> ];
	=>;
_DefineGrid ( <"name"> , 	;
		<"parent"> , 	;
		,		;
		,		;
		<w> , 		;
		<h> , 		;
		<headers> , 	;
		<widths> , 	;
		<rows> , 	;
		<value> ,	;
		<fontname> , 	;
		<fontsize> , 	;
		<tooltip> , 	;
		<{change}> ,	;
		<{dblclick}> ,  ;
		<aHeadClick> ,	;
		<{gotfocus}> ,	;
		<{lostfocus}>,  ; 
		<.style.>,	;
		<aImage>,	;
		<aJust>  , 	;
		<.break.> , 	;
		<helpid> ,	;
		<.bold.>, 	;
		<.italic.>, 	;
		<.underline.>, 	;
		<.strikeout.> , ;
		<.ownerdata.> , ;
		<{dispinfo}> ,  ;
		<itemcount> , 	;
		 ,  ;
		Nil , 	;
		Nil ,	;
		<.multiselect.> , ;
		Nil , ;
		<backcolor> , ;
		<fontcolor> , ;
		<.edit.> , ;
		<editcontrols> , ; 
		<dynamicbackcolor> , ;
		<dynamicforecolor> , ;
		<columnvalid> , ;
		<columnwhen>  , ;
		!<.noshowheaders.> , ;
		<headerimages> , ;
		<.cellnavigation.> , ;
		<recordsource> , ;	
		<columnfields> , ;
		<.append.>     , ;		
		<.buffered.>   ,    	;
		<.allowdelete.>	,	;
		<dynamicdisplay> ,	;
		<{onsave}> 	,	;
		<lockcolumns>	,	;
      <{onclick}> ,;
      <{onkey}> ,;
      <EditOption> ,;
      <.notrans.> , <.notransheader.> , <aDynamicFont> , <{OnCheckBoxClicked}> , <{OnInplaceEditEvent}> ) 



///////////////////////////////////////////////////////////////////////////////



// GridEx ( by Dr. Claudio Soto )

// CONSTANTS (nControl)
********************************************************************************** 
// _HMG_SYSDATA [ nControl ] [i]

#define _GRID_COLUMN_HEADER_             7
#define _GRID_COLUMN_ONHEADCLICK_        17
#define _GRID_COLUMN_HEADERIMAGE_        22
#define _GRID_COLUMN_HEADER2_            33
#define _GRID_COLUMN_JUSTIFY_            37

// _HMG_SYSDATA [ 40 ] [ i ] [ nControl ]

#define _GRID_COLUMN_CONTROL_            2
#define _GRID_COLUMN_DYNAMICBACKCOLOR_   3
#define _GRID_COLUMN_DYNAMICFORECOLOR_   4
#define _GRID_COLUMN_VALID_              5
#define _GRID_COLUMN_WHEN_               6
#define _GRID_COLUMN_WIDTH_              31
#define _GRID_COLUMN_DYNAMICFONT_        41
#define _GRID_COLUMN_HEADERFONT_         43
#define _GRID_COLUMN_HEADERBACKCOLOR_    44
#define _GRID_COLUMN_HEADERFORECOLOR_    45

**********************************************************************************


// CONSTANTS -->  _GridEx_SetBkImage (nAction)
**********************************************************************************
#define GRID_SETBKIMAGE_NONE        0
#define GRID_SETBKIMAGE_NORMAL      1
#define GRID_SETBKIMAGE_TILE        2
#define GRID_SETBKIMAGE_WATERMARK   3
**********************************************************************************


// CONSTANTS -->  LISTVIEW_SETCOLUMNWIDTH (nWidth)
**********************************************************************************
#define GRID_WIDTH_AUTOSIZE         (-1)
#define GRID_WIDTH_AUTOSIZEHEADER   (-2)
**********************************************************************************


**********************************************************************************
#xcommand  SET GridDeleteAllItems TRUE    =>   SET_GRID_DELETEALLITEMS (.T.)
#xcommand  SET GridDeleteAllItems ON      =>   SET_GRID_DELETEALLITEMS (.T.)
#xcommand  SET GridDeleteAllItems FALSE   =>   SET_GRID_DELETEALLITEMS (.F.)
#xcommand  SET GridDeleteAllItems OFF     =>   SET_GRID_DELETEALLITEMS (.F.)
#xtranslate   IsGridDeleteAllItems ()    =>   SET_GRID_DELETEALLITEMS ()
**********************************************************************************


// CONSTANTS --> GridCellNavigationColor (nIndex) // only for cell navigation = .T.
**********************************************************************************
#define _SELECTEDROW_DISPLAYCOLOR   1
#define _SELECTEDCELL_DISPLAYCOLOR  2
#define _SELECTEDROW_FORECOLOR      348
#define _SELECTEDROW_BACKCOLOR      349
#define _SELECTEDCELL_FORECOLOR     350 
#define _SELECTEDCELL_BACKCOLOR     351
**********************************************************************************


// Dynamic Font
#xtranslate ARRAY ;
         FONT <fontname>;
         SIZE <fontsize>;
         [ <bold : BOLD> ] ;
         [ <italic : ITALIC> ] ;
         [ <underline : UNDERLINE> ] ;
         [ <strikeout : STRIKEOUT> ] ;
         => { <fontname>, <fontsize>, <.bold.>, <.italic.>, <.underline.>, <.strikeout.> }

// Dynamic Font
#xtranslate CREATE ARRAY ;
         FONT <fontname>;
         SIZE <fontsize>;
         [ BOLD <bold> ] ;
         [ ITALIC <italic>] ;
         [ UNDERLINE <underline> ] ;
         [ STRIKEOUT <strikeout> ] ;
         => { <fontname>, <fontsize>, <bold>, <italic>, <underline>, <strikeout> }


#xtranslate IsGridCustomDrawNewBehavior() => _HMG_SYSDATA \[ 514 \]


