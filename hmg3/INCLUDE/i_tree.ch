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

* Standard Syntax

#xcommand DEFINE TREE <name> ;
	[ <dummy1: OF, PARENT> <parent> ] ;
	AT <row> , <col> ;
	[ WIDTH <width> ] ;
	[ HEIGHT <height> ] ;
	[ VALUE <value> ] ;
	[ FONT <fontname> ] ;
	[ SIZE <fontsize> ] ;
	[ <bold : BOLD> ] ;
	[ <italic : ITALIC> ] ;
	[ <underline : UNDERLINE> ] ;
	[ <strikeout : STRIKEOUT> ] ;
	[ TOOLTIP <tooltip> ] ;
	[ ON GOTFOCUS <gotfocus> ] ;
	[ ON CHANGE <change> ] ;
	[ ON LOSTFOCUS <lostfocus> ] ;
	[ ON DBLCLICK <dblclick> ] ;
	[ NODEIMAGES <aImgNode> [ ITEMIMAGES <aImgItem> ] [ <noBut: NOROOTBUTTON> ]];
	[ <itemids : ITEMIDS> ] ;
	[ HELPID <helpid> ] 		;
   [ <NoTrans : NOTRANSPARENT> ] ;
   [ ON EXPAND <OnExpand> ] ;
   [ ON COLLAPSE <OnCollapse> ] ;
   [ BACKCOLOR <aBackColor> ] ;
   [ FONTCOLOR <aFontColor> ] ;
   [ DYNAMICBACKCOLOR <DynamicBackColor> ] ;
   [ DYNAMICFORECOLOR <DynamicForeColor> ] ;
   [ DYNAMICFONT <DynamicFont> ] ;
=>;
_DefineTree ( <"name"> , <"parent"> , <row> , <col> , <width> , <height> , <{change}> , <tooltip> , <fontname> , <fontsize> , <{gotfocus}> , <{lostfocus}> , <{dblclick}> , .f. , <value>  , <helpid>, <aImgNode>, <aImgItem>, <.noBut.> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <.itemids.> , Nil , <.NoTrans.> , <{OnExpand}> , <{OnCollapse}> , <aBackColor> , <aFontColor> , <DynamicBackColor> , <DynamicForeColor> , <DynamicFont> )


* Alternate Syntax

#xcommand DEFINE TREE <name> ;
	[ PARENT <parent> ] ;
	ROW <row> ;
	COL <col> ;
	[ WIDTH <width> ] ;
	[ HEIGHT <height> ] ;
	[ VALUE <value> ] ;
	[ FONTNAME <fontname> ] ;
	[ FONTSIZE <fontsize> ] ;
	[ FONTBOLD <bold> ] ;
	[ FONTITALIC <italic> ] ;
	[ FONTUNDERLINE <underline> ] ;
	[ FONTSTRIKEOUT <strikeout> ] ;
	[ TOOLTIP <tooltip> ] ;
	[ ONGOTFOCUS <gotfocus> ] ;
	[ ONCHANGE <change> ] ;
	[ ONLOSTFOCUS <lostfocus> ] ;
	[ ONDBLCLICK <dblclick> ] ;
	[ NODEIMAGES <aImgNode> ] ;
	[ ITEMIMAGES <aImgItem> ] ;
	[ ROOTBUTTON <rootbutton> ] ;
	[ ITEMIDS <itemids> ] ;
	[ HELPID <helpid> ] ;
   [ TRANSPARENT <Trans> ] ;
   [ ONEXPAND <OnExpand> ] ;
   [ ONCOLLAPSE <OnCollapse> ] ;
   [ BACKCOLOR <aBackColor> ] ;
   [ FONTCOLOR <aFontColor> ] ;
   [ DYNAMICBACKCOLOR <DynamicBackColor> ] ;
   [ DYNAMICFORECOLOR <DynamicForeColor> ] ;
   [ DYNAMICFONT <DynamicFont> ] ;
=>;
_DefineTree ( <"name"> , <"parent"> , <row> , <col> , <width> , <height> , <{change}> , <tooltip> , <fontname> , <fontsize> , <{gotfocus}> , <{lostfocus}> , <{dblclick}> , .f. , <value>  , <helpid>, <aImgNode>, <aImgItem>, .f. ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <.itemids.> , <rootbutton> , <.Trans.> , <{OnExpand}> , <{OnCollapse}> , <aBackColor> , <aFontColor> , <DynamicBackColor> , <DynamicForeColor> , <DynamicFont> )


#xcommand NODE <text> [ IMAGES <aImage> ] [ ID <id> ];
=>;
_DefineTreeNode (<text>, <aImage> , <id> )

#xcommand DEFINE NODE <text> [ IMAGES <aImage> ] [ ID <id> ] ;
=>;
_DefineTreeNode (<text>, <aImage> , <id> )

#xcommand END NODE ;
=>;
_EndTreeNode()

#xcommand TREEITEM <text> [ IMAGES <aImage> ]  [ ID <id> ] ;
=> ;
_DefineTreeItem (<text>, <aImage> , <id> )

#xcommand END TREE ;
=> ;
_EndTree()

///////////////////////////////////////////////////////////////////////////////
// SPLITBOX VERSION
///////////////////////////////////////////////////////////////////////////////

* Standard

#xcommand DEFINE TREE <name> ;
	[ <dummy1: OF, PARENT> <parent> ] ;
	[ WIDTH <width> ] ;
	[ HEIGHT <height> ] ;
	[ VALUE <value> ] ;
	[ FONT <fontname> ] ;
	[ SIZE <fontsize> ] ;
	[ <bold : BOLD> ] ;
	[ <italic : ITALIC> ] ;
	[ <underline : UNDERLINE> ] ;
	[ <strikeout : STRIKEOUT> ] ;
	[ TOOLTIP <tooltip> ] ;
	[ ON GOTFOCUS <gotfocus> ] ;
	[ ON CHANGE <change> ] ;
	[ ON LOSTFOCUS <lostfocus> ] ;
	[ ON DBLCLICK <dblclick> ] ;
	[ <itemids : ITEMIDS> ] ;
	[ HELPID <helpid> ] 		;
	[ NODEIMAGES <aImgNode> [ ITEMIMAGES <aImgItem> ] [ <noBut: NOROOTBUTTON> ]];
	[ <break: BREAK> ] ;
   [ <NoTrans : NOTRANSPARENT> ];
   [ ON EXPAND <OnExpand> ] ;
   [ ON COLLAPSE <OnCollapse> ] ;
   [ BACKCOLOR <aBackColor> ] ;
   [ FONTCOLOR <aFontColor> ] ;
   [ DYNAMICBACKCOLOR <DynamicBackColor> ] ;
   [ DYNAMICFORECOLOR <DynamicForeColor> ] ;
   [ DYNAMICFONT <DynamicFont> ] ;
=>;
_DefineTree ( <"name"> , <"parent"> ,  ,  , <width> , <height> , <{change}> , <tooltip> , <fontname> , <fontsize> , <{gotfocus}> , <{lostfocus}> , <{dblclick}> , <.break.> , <value>  , <helpid>, <aImgNode>, <aImgItem>, <.noBut.> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.>  , <.itemids.> , Nil , <.NoTrans.> , <{OnExpand}> , <{OnCollapse}> , <aBackColor> , <aFontColor> , <DynamicBackColor> , <DynamicForeColor> , <DynamicFont> )


* Extended

#xcommand DEFINE TREE <name> ;
	[ PARENT <parent> ] ;
	[ WIDTH <width> ] ;
	[ HEIGHT <height> ] ;
	[ VALUE <value> ] ;
	[ FONTNAME <fontname> ] ;
	[ FONTSIZE <fontsize> ] ;
	[ FONTBOLD <bold> ] ;
	[ FONTITALIC <italic> ] ;
	[ FONTUNDERLINE <underline> ] ;
	[ FONTSTRIKEOUT <strikeout> ] ;
	[ TOOLTIP <tooltip> ] ;
	[ ONGOTFOCUS <gotfocus> ] ;
	[ ONCHANGE <change> ] ;
	[ ONLOSTFOCUS <lostfocus> ] ;
	[ ONDBLCLICK <dblclick> ] ;
	[ ITEMIDS <itemids> ] ;
	[ HELPID <helpid> ] 	;
	[ NODEIMAGES <aImgNode> ] ;
	[ ITEMIMAGES <aImgItem> ] ;
	[ ROOTBUTTON <rootbutton> ] ;
	[ BREAK <break> ] ;
   [ TRANSPARENT <Trans> ] ;   
   [ ONEXPAND <OnExpand> ] ;
   [ ONCOLLAPSE <OnCollapse> ] ;
   [ BACKCOLOR <aBackColor> ] ;
   [ FONTCOLOR <aFontColor> ] ;
   [ DYNAMICBACKCOLOR <DynamicBackColor> ] ;
   [ DYNAMICFORECOLOR <DynamicForeColor> ] ;
   [ DYNAMICFONT <DynamicFont> ] ;
=>;
_DefineTree ( <"name"> , <"parent"> ,  ,  , <width> , <height> , <{change}> , <tooltip> , <fontname> , <fontsize> , <{gotfocus}> , <{lostfocus}> , <{dblclick}> , <.break.> , <value>  , <helpid>, <aImgNode>, <aImgItem>, .f. ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.>  , <.itemids.> , <rootbutton> , <.Trans.> , <{OnExpand}> , <{OnCollapse}> , <aBackColor> , <aFontColor> , <DynamicBackColor> , <DynamicForeColor> , <DynamicFont>  )



// by Dr. Claudio Soto (November 2013)

#define _IS_TREE_NODE_   .T.
#define _IS_TREE_ITEM_   .F.


#define TREEIMAGEINDEX_NODE   {0,1}   // Index to defalut NODE Bitmaps
#define TREEIMAGEINDEX_ITEM   {2,3}   // Index to defalut ITEM Bitmaps


#define TREESORTNODE_FIRST  0
#define TREESORTNODE_LAST   1
#define TREESORTNODE_MIX    2

#xtranslate TREESORT <control> OF <parent>; 
          [ ITEM <nItem> ] [ RECURSIVE <lRecursive> ] [ CASESENSITIVE <lCaseSensitive> ] [ ASCENDINGORDER <lAscendingOrder> ] [ NODEPOSITION <nNodePosition> ] =>;
   TreeItemSort (<"control">, <"parent">, <nItem>, <lRecursive>, <lCaseSensitive>, <lAscendingOrder>, <nNodePosition>)


#xtranslate This.TreeItemValue => _HMG_This_TreeItem_Value


//   iImageList --> TreeView_SetImageList() / TreeView_GetImageList()
#define TVSIL_NORMAL   0
#define TVSIL_STATE    2


// Style
#define TVS_HASBUTTONS 0x1
#define TVS_HASLINES 0x2
#define TVS_LINESATROOT 0x4
#define TVS_EDITLABELS 0x8
#define TVS_DISABLEDRAGDROP 0x10
#define TVS_SHOWSELALWAYS 0x20
#define TVS_RTLREADING 0x40
#define TVS_NOTOOLTIPS 0x80
#define TVS_CHECKBOXES 0x100
#define TVS_TRACKSELECT 0x200
#define TVS_SINGLEEXPAND 0x400
#define TVS_INFOTIP 0x800
#define TVS_FULLROWSELECT 0x1000
#define TVS_NOSCROLL 0x2000
#define TVS_NONEVENHEIGHT 0x4000
#define TVS_NOHSCROLL 0x8000


