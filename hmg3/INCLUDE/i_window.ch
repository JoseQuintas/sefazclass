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

// DECLARE WINDOW Translate Map (Semi-OOP Properties/Methods Access)

// 01-01 -> Window Property Get
// 02-02 -> Window Property Set
// 03-03 -> Window Methods
// 04-18 -> Standard Controls
// 19-20 -> ToolBar Child Buttons
// 21-33 -> Tab Child Controls
// 34-48 -> SplitBox Child Controls
// 49-50 -> SplitBox Child ToolBar Buttons

   #xcommand DECLARE WINDOW <w> ;
   =>;
   #xtranslate <w> . \<p:Name,Title,Height,Width,Col,Row,NotifyIcon,NotifyToolTip,FocusedControl> => GetProperty ( <"w">, \<"p"\> )  ;;
   #xtranslate <w> . \<p:Name,Title,Height,Width,Col,Row,NotifyIcon,NotifyToolTip,FocusedControl,Cursor> := \<n\> => SetProperty ( <"w">, \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . \<p:Activate,Center,Redraw, CenterDesktop,Release,Maximize,Minimize,Restore,Show,Hide,SetFocus,Print,Capture> \[()\] => DoMethod ( <"w">, \<"p"\> ) ;;
   #xtranslate <w> . \<p:CenterIn> (\<arg\>) => DoMethod ( <"w">, \<"p"\>, \<"arg"\> ) ;;
   #xtranslate <w> . \<p:Capture> ( \<f\> , \<r\> , \<k\> , \<a\> , \<h\> ) => DoMethod ( <"w">, \<"p"\> , \<f\>  , \<r\> , \<k\> , \<a\> , \<h\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,hBitmap,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor,AllowEdit,Object,InputItems,DisplayItems,RecNo,GetTextLength\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,hBitmap,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor,AllowEdit,InputItems,DisplayItems,RecNo\> := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . \<c\> . \<p:AllowAppend,AllowDelete,ReadOnly> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . \<c\> . \<p:AllowAppend,AllowDelete,ReadOnly> := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Caption,Header,Item,Icon,HeaderImages> (\<arg\>) => GetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Caption,Header,Item,Icon,HeaderImages,IconHandle> (\<arg\>) := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg\> , \<n\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Cell> (\<arg1\>,\<arg2\>) => GetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Cell> (\<arg1\>,\<arg2\>) := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> , \<n\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Redraw,Refresh,SetFocus,DeleteAllItems,Release,Show,Save,Hide,Play,Stop,Close,Pause,Eject,OpenDialog,Resume,Action,OnClick,Append,Delete,Recall,ClearBuffer,DisableUpdate,EnableUpdate> \[()\] => Domethod ( <"w">, \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Refresh,AddItem,DeleteItem,Open,DeletePage,DeleteColumn,Expand,Collapse,Seek> (\<a\>) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a\> ) ;;
   #xtranslate <w> . \<c\> . \<p:AddItem,AddPage,Expand,Collapse> (\<a1\> , \<a2\>) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\> , \<a2\> ) ;;
   #xtranslate <w> . \<c\> . \<p:AddItem,AddPage> (\<a1\> , \<a2\> , \<a3\> ) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> ) ;;
   #xtranslate <w> . \<c\> . \<p:AddItem,AddColumn,AddControl\> (\<a1\> , \<a2\> , \<a3\> , \<a4\> ) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> , \<a4\> ) ;;
   #xtranslate <w> . \<c\> . \<p:Name,Length,Volume\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . \<c\> . \<p:ReadOnly,Speed,Volume,Zoom,Seek\> := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . \<x\> . \<c\> . \<p:Caption,Enabled,Value> => GetProperty ( <"w"> , \<"x"\> , \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . \<x\> . \<c\> . \<p:Caption,Enabled,Value> := \<n\> => SetProperty ( <"w"> , \<"x"\> , \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor\> => GetProperty ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor\> := \<n\> => SetProperty ( <"w"> , \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Caption,Header,Item,Icon> (\<arg\>) => GetProperty ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<arg\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Caption,Header,Item,Icon> (\<arg\>) := \<n\> => SetProperty ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<arg\> , \<n\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Refresh,SetFocus,DeleteAllItems,Release,Show,Save,Hide,Play,Stop,Close,Pause,Eject,OpenDialog,Resume,Action,OnClick\> \[()\] => Domethod ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:AddItem,DeleteItem,Open,DeletePage,DeleteColumn,Expand,Collapse,Seek\> (\<a\>) => Domethod ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<a\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:AddItem,AddPage> (\<a1\> , \<a2\>) => Domethod ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<a1\> , \<a2\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:AddItem,AddPage> (\<a1\> , \<a2\> , \<a3\> ) => Domethod ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:AddItem,AddColumn,AddControl> (\<a1\> , \<a2\> , \<a3\> , \<a4\> ) => Domethod ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> , \<a4\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Name,Length> => GetProperty ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:ReadOnly,Speed,Volume,Zoom> := \<n\> => SetProperty ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Cell> (\<arg1\>,\<arg2\>) =>          GetProperty ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> ) ;;
   #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Cell> (\<arg1\>,\<arg2\>) := \<n\> => SetProperty ( <"w">, \<"x"\> , \<k\> , \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> , \<n\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor,AllowEdit,Object,InputItems,DisplayItems\> => GetProperty ( <"w">, "SplitBox" , \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor,AllowEdit,InputItems,DisplayItems\> := \<n\> => SetProperty ( <"w">, "SplitBox" , \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:AllowAppend,AllowDelete,ReadOnly> => GetProperty ( <"w">, "SplitBox", \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:AllowAppend,AllowDelete,ReadOnly> := \<n\> => SetProperty ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:Caption,Header,Item,Icon,HeaderImages> (\<arg\>) => GetProperty ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<arg\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:Caption,Header,Item,Icon,HeaderImages> (\<arg\>) := \<n\> => SetProperty ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<arg\> , \<n\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:Cell> (\<arg1\>,\<arg2\>) => GetProperty ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:Cell> (\<arg1\>,\<arg2\>) := \<n\> => SetProperty ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> , \<n\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:Refresh,SetFocus,DeleteAllItems,Release,Show,Save,Hide,Play,Stop,Close,Pause,Eject,OpenDialog,Resume,Action,OnClick> \[()\] => Domethod ( <"w">, "SplitBox", \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:AddItem,DeleteItem,Open,DeletePage,DeleteColumn,Expand,Collapse,Seek> (\<a\>) => Domethod ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<a\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:AddItem,AddPage> (\<a1\> , \<a2\>) => Domethod ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<a1\> , \<a2\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:AddItem,AddPage> (\<a1\> , \<a2\> , \<a3\> ) => Domethod ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:AddItem,AddColumn,AddControl\> (\<a1\> , \<a2\> , \<a3\> , \<a4\> ) => Domethod ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> , \<a4\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:Name,Length\> => GetProperty ( <"w">, "SplitBox", \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . SplitBox . \<c\> . \<p:ReadOnly,Speed,Volume,Zoom\> := \<n\> => SetProperty ( <"w">, "SplitBox", \<"c"\> , \<"p"\> , \<n\> ) ;;
   #xtranslate <w> . SplitBox . \<x\> . \<c\> . \<p:Caption,Enabled,Value> => GetProperty ( <"w"> , "SplitBox" , \<"x"\> , \<"c"\> , \<"p"\> ) ;;
   #xtranslate <w> . SplitBox . \<x\> . \<c\> . \<p:Caption,Enabled,Value> := \<n\> => SetProperty ( <"w"> , "SplitBox", \<"x"\> , \<"c"\> , \<"p"\> , \<n\> ) ;;
;;
;;   // Forms
#xtranslate <w> . \<p:NoClose, NoCaption,NoMaximize,NoMinimize,NoSize,NoSysMenu,HScroll,VScroll,Enabled> => GetProperty ( <"w"> , \<"p"\> ) ;;
#xtranslate <w> . \<p:NoClose, NoCaption,NoMaximize,NoMinimize,NoSize,NoSysMenu,HScroll,VScroll,Enabled> := \<n\> => SetProperty ( <"w">, \<"p"\> , \<n\> ) ;;
#xtranslate <w>.  \<p:HANDLE,INDEX,IsMinimized,IsMaximized,ClientAreaWidth,ClientAreaHeight\> => GetProperty ( <"w"> , \<"p"\> ) ;;
#xtranslate <w> . \<p:AlphaBlendTransparent,BackColorTransparent> := \<n\> => SetProperty ( <"w">, \<"p"\> , \<n\> ) ;;
;;
;;   // Controls
#xtranslate <w>. \<c\> . \<p:HANDLE,INDEX,TYPE\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:ChangeFontSize\> := \<arg\> =>  SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg\> ) ;;
;;
;;   // Grid
#xtranslate <w>. \<c\> . \<p:ColumnCOUNT, CellRowFocused, CellColFocused, CellNavigation, CellRowClicked, CellColClicked, EditOption, ImageList, RowsPerPage\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:ColumnHEADER, ColumnWIDTH, ColumnJUSTIFY, ColumnCONTROL, ColumnDYNAMICBACKCOLOR, ColumnDYNAMICFORECOLOR,;
                             ColumnVALID, ColumnWHEN, ColumnONHEADCLICK, ColumnDISPLAYPOSITION, ColumnDYNAMICFONT, HeaderDYNAMICFONT, HeaderDYNAMICBACKCOLOR, HeaderDYNAMICFORECOLOR, HeaderImageIndex,;
                             CheckBoxItem\> (\<n\>) => GetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\> );;
#xtranslate <w>. \<c\> . \<p:ColumnHEADER, ColumnWIDTH, ColumnJUSTIFY, ColumnCONTROL, ColumnDYNAMICBACKCOLOR, ColumnDYNAMICFORECOLOR,;
                             ColumnVALID, ColumnWHEN, ColumnONHEADCLICK, ColumnDISPLAYPOSITION, ColumnDYNAMICFONT, HeaderDYNAMICFONT, HeaderDYNAMICBACKCOLOR, HeaderDYNAMICFORECOLOR, HeaderImageIndex, Image,;
                             CheckBoxItem\> (\<n\>) := \<arg\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\>, \<arg\> );;
#xtranslate <w>. \<c\> . \<p:CellEx, ImageIndex\> (\<n1\>, \<n2\>) => GetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n1\>, \<n2\>);;
#xtranslate <w>. \<c\> . \<p:CellEx, ImageIndex\> (\<n1\>, \<n2\>) := \<arg\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n1\>, \<n2\>, \<arg\>);;
#xtranslate <w>. \<c\> . \<p:AddColumnEx\> (\<a1\> , \<a2\> , \<a3\> , \<a4\> , \<a5\> ) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> , \<a4\> , \<a5\> ) ;;
#xtranslate <w>. \<c\> . \<p:AddItemEx> (\<a1\> , \<a2\>) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\> , \<a2\> ) ;;
#xtranslate <w>. \<c\> . \<p:BackGroundImage\> (\<a1\> , \<a2\> , \<a3\> , \<a4\>) => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> , \<a4\> );;
#xtranslate <w>. \<c\> . \<p:CellNavigation, EditOption, ImageList\> := \<arg\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg\>);;
#xtranslate <w>. \<c\> . \<p:CheckBoxEnabled,GroupEnabled,PaintDoubleBuffer\> => GetProperty ( <"w">, \<"c"\> , \<"p"\>);;
#xtranslate <w> .\<c\> . \<p:CheckBoxEnabled,GroupEnabled,PaintDoubleBuffer,CheckBoxAllItems\> := \<n\> => SetProperty ( <"w">, \<"c"\>, \<"p"\> , \<n\> ) ;;
#xtranslate <w>. \<c\> . \<p:GroupDeleteAll\> \[()\]  => Domethod ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:GroupDelete,GroupAdd,GroupExpand,GroupCollapsed,GroupDeleteAllItems\> (\<a1\>) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\> ) ;;
#xtranslate <w>. \<c\> . \<p:GroupAdd> (\<a1\> , \<a2\>) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\> , \<a2\> ) ;;
#xtranslate <w>. \<c\> . \<p:GroupInfo,GroupItemID,GroupGetAllItemIndex,GroupExist\> (\<n1\>) => GetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n1\> );;
#xtranslate <w>. \<c\> . \<p:GroupInfo,GroupItemID,GroupCheckBoxAllItems\> (\<n1\>) := \<arg\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n1\>, \<arg\>);;
;;
;;   // MonthCalendar
#xtranslate <w>. \<c\> . \<p:FontColor, OuterFontColor, BackColor, BorderColor, TitleFontColor, TitleBackColor, View, VisibleMax, VisibleMin\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:FontColor, OuterFontColor, BackColor, BorderColor, TitleFontColor, TitleBackColor, View\> := \<n\> => SetProperty ( <"w">, \<"c"\>, \<"p"\> , \<n\> ) ;;
;;
;;   // TimePicker
#xtranslate <w>. \<c\> . \<p:Format\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:Format\> := \<arg\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg\>);;
;;
;;   // TreeView
#xtranslate <w>. \<c\> . \<p:AllValue,RootValue,FirstItemValue,ImageCount,ImageList,HasLines,FullRowSelect\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:ParentValue,ChildValue,SiblingValue,ItemText,IsTrueNode,NodeFlag,IsExpand,ImageIndex,HasButton,Cargo,CargoScan,GetPathValue,GetPathName,GetDisplayLevel\> (\<n1\>) => GetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n1\> );;
#xtranslate <w>. \<c\> . \<p:NodeFlag,ImageIndex,HasButton,Cargo\> (\<n1\>) := \<arg\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n1\>, \<arg\>);;
#xtranslate <w>. \<c\> . \<p:TextColor,BackColor,LineColor,DynamicBackColor,DynamicForeColor, DynamicFont\> := \<arg\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg\>);;
#xtranslate <w>. \<c\> . \<p:AddImage,ImageList,HasLines,FullRowSelect\> := \<arg\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg\>);;
#xtranslate <w>. \<c\> . \<p:SetDefaultNodeFlag> (\<a1\>) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\>) ;;
#xtranslate <w>. \<c\> . \<p:SetDefaultAllNodeFlag> => Domethod ( <"w">, \<"c"\> , \<"p"\>) ;;
#xtranslate <w>. \<c\> . \<p:Sort\> (\<a1\> , \<a2\> , \<a3\> , \<a4\> , \<a5\> ) => Domethod ( <"w">, \<"c"\> , \<"p"\> , \<a1\> , \<a2\> , \<a3\> , \<a4\> , \<a5\> ) ;;
;;
;;   // RichEditBox 
#xtranslate <w>. \<c\> . \<p:FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,FontColor,FontBackColor,FontScript,Link\>          => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,FontColor,FontBackColor,FontScript,Link\> := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\> ) ;;
#xtranslate <w>. \<c\> . \<p:RTFTextMode,AutoURLDetect,Zoom,SelectRange,CaretPos,Value,GetSelectText,GetTextLength,ViewRect\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:RTFTextMode,AutoURLDetect,Zoom,SelectRange,CaretPos,Value,ViewRect\> := \<n\>      => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\> ) ;;
#xtranslate <w>. \<c\> . \<p:BackGroundColor\> := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\> ) ;;
#xtranslate <w>. \<c\> . \<p:SelectAll,UnSelectAll\> \[()\] => DoMethod ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:AddText,AddTextAndSelect\> (\<arg\>) := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg\> , \<n\> ) ;;
#xtranslate <w>. \<c\> . \<p:ParaAlignment, ParaNumbering, ParaNumberingStyle, ParaNumberingStart, ParaOffset, ParaLineSpacing, ParaIndent\>          => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:ParaAlignment, ParaNumbering, ParaNumberingStyle, ParaNumberingStart, ParaOffset, ParaLineSpacing, ParaIndent\> := \<n\> => SetProperty ( <"w">, \<"c"\> , \<"p"\> , \<n\> ) ;;
#xtranslate <w>. \<c\> . \<p:LoadFile,SaveFile\> (\<arg1\>,\<arg2\>,\<arg3\>) => DoMethod ( <"w">, \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\>, \<arg3\> ) ;;
#xtranslate <w>. \<c\> . \<p:RTFLoadFile,RTFSaveFile\> (\<arg1\>,\<arg2\>,\<arg3\>) => DoMethod ( <"w">, \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\>, \<arg3\> ) ;;
#xtranslate <w>. \<c\> . \<p:RTFLoadFile,RTFSaveFile\> (\<arg1\>,\<arg2\>)          => DoMethod ( <"w">, \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> ) ;;
#xtranslate <w>. \<c\> . \<p:CanPaste,CanUndo,CanRedo\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:SelCopy,SelPaste,SelCut,SelClear,Undo,Redo,ClearUndoBuffer\> \[()\] => DoMethod ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:FindText,ReplaceText,ReplaceAllText\> (\<arg1\>,\<arg2\>,\<arg3\>,\<arg4\>,\<arg5\>) => GetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> , \<arg3\> , \<arg4\> , \<arg5\> ) ;;
#xtranslate <w>. \<c\> . \<p:GetClickLinkRange,GetClickLinkText\> => GetProperty ( <"w">, \<"c"\> , \<"p"\> ) ;;
#xtranslate <w>. \<c\> . \<p:GetTextRange,GetPosChar\> (\<arg1\>) => GetProperty ( <"w">, \<"c"\> , \<"p"\> , \<arg1\> ) ;;
#xtranslate <w>. \<c\> . \<p:RTFPrint\> (\<arg1\>,\<arg2\>,\<arg3\>,\<arg4\>,\<arg5\>,\<arg6\>) => DoMethod ( <"w">, \<"c"\> , \<"p"\> , \<arg1\> , \<arg2\> , \<arg3\> , \<arg4\> , \<arg5\> , \<arg6\> ) ;;


	***********************************************************************
	* Std / Main / Child
	***********************************************************************


	#xcommand DEFINE WINDOW <w> ;
			[ <dummy1: OF, PARENT> <parent> ] ;
			[ AT <row>,<col> ] ;
			[ ROW <row> ] ;
			[ COL <col> ] ;
			[ WIDTH <wi> ];
			[ HEIGHT <h> ];
			[ VIRTUAL WIDTH <vWidth> ] ;                             
			[ VIRTUAL HEIGHT <vHeight> ] ;                             
			[ TITLE <title> ] ;
			[ ICON <icon> ] ;
			[ <main:  MAIN> ] ;
			[ <child: CHILD> ] ;
			[ <panel: PANEL> ] ;
			[ <noshow: NOSHOW> ] ;
			[ <topmost: TOPMOST> ] ;
			[ <noautorelease: NOAUTORELEASE> ] ;
			[ <nominimize: NOMINIMIZE> ] ;
			[ <nomaximize: NOMAXIMIZE> ] ;
			[ <nosize: NOSIZE> ] ;
			[ <nosysmenu: NOSYSMENU> ] ;                             
			[ <nocaption: NOCAPTION> ] ;                             
			[ CURSOR <cursor> ] ;
			[ ON INIT <InitProcedure> ] ;
			[ ON RELEASE <ReleaseProcedure> ] ;
			[ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ON MOUSECLICK <ClickProcedure> ] ;
			[ ON MOUSEDRAG <MouseDragProcedure> ] ;
			[ ON MOUSEMOVE <MouseMoveProcedure> ] ;
			[ ON SIZE <SizeProcedure> ] ;
			[ ON MAXIMIZE <MaximizeProcedure> ] ;
			[ ON MINIMIZE <MinimizeProcedure> ] ;
			[ ON PAINT <PaintProcedure> ] ;
		   [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ NOTIFYICON <NotifyIcon> ] ;
			[ NOTIFYTOOLTIP <NotifyIconTooltip> ] ;
			[ ON NOTIFYCLICK <NotifyLeftClick> ] ;
			[ ON GOTFOCUS <GotFocusProcedure> ] ;
			[ ON LOSTFOCUS <LostFocusProcedure> ] ;
			[ ON SCROLLUP <scrollup> ] ;
			[ ON SCROLLDOWN <scrolldown> ] ;
			[ ON SCROLLLEFT <scrollleft> ] ;
			[ ON SCROLLRIGHT <scrollright> ] ;
			[ ON HSCROLLBOX <hScrollBox> ] ;
			[ ON VSCROLLBOX <vScrollBox> ] ;
			[ <helpbutton:  HELPBUTTON> ] ;
			[ <main:  WINDOWTYPE MAIN> ] ;
			[ <child: WINDOWTYPE CHILD> ] ;
			[ WINDOWTYPE STANDARD ] ;
			[ VISIBLE <visible> ] ;
			[ AUTORELEASE <autorelease> ] ;
			[ MINBUTTON <minbutton> ] ;
			[ MAXBUTTON <maxbutton> ] ;
			[ SIZABLE <sizable> ] ;
			[ SYSMENU <sysmenu> ] ;
			[ TITLEBAR <titlebar> ] ;
			[ FONTNAME <FontName> FONTSIZE <FontSize> ] ;
	=>;
	DECLARE WINDOW <w>  ;;
	DECLARE CUSTOM COMPONENTS <w> ;;
	_DefineWindow ( <"w">, <title>, <col>, <row>, <wi>, <h>, <.nominimize.>, <.nomaximize.>, <.nosize.>, <.nosysmenu.>, <.nocaption.>,.F., '',<{InitProcedure}>, <{ReleaseProcedure}> , <{MouseDragProcedure}>, <{SizeProcedure}> , <{ClickProcedure}> , <{MouseMoveProcedure}>, <backcolor> , <{PaintProcedure}> , <.noshow.> , <.topmost.> , <.main.> , <icon> , <.child.> , <FontName> , <FontSize>, <NotifyIcon> , <NotifyIconTooltip> , <{NotifyLeftClick}>  , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight> , <vWidth> , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}> , <.helpbutton.> , <{MaximizeProcedure}> , <{MinimizeProcedure}> , <cursor> , <.noautorelease.> , <{interactivecloseprocedure}> , <visible> , <autorelease> , <minbutton> , <maxbutton> , <sizable> , <sysmenu> , <titlebar> , <"parent"> , <.panel.> )  


	***********************************************************************
	* Std / Main / Child (Propertized TOPMOST / HELPBUTTON )
	***********************************************************************


	#xcommand DEFINE WINDOW <w> ;
			[ <dummy1: OF, PARENT> <parent> ] ;
			[ AT <row>,<col> ] ;
			[ ROW <row> ] ;
			[ COL <col> ] ;
			[ WIDTH <wi> ];
			[ HEIGHT <h> ];
			[ VIRTUALWIDTH <vWidth> ] ;                             
			[ VIRTUALHEIGHT <vHeight> ] ;                             
			[ TITLE <title> ] ;
			[ ICON <icon> ] ;
			WINDOWTYPE ;
			[ <main:  MAIN> ] ;
			[ <child: CHILD> ] ;
			[ <panel: PANEL> ] ;
			[ <noshow: NOSHOW> ] ;
			[ TOPMOST <topmost> ] ;
			[ <noautorelease: NOAUTORELEASE> ] ;
			[ <nominimize: NOMINIMIZE> ] ;
			[ <nomaximize: NOMAXIMIZE> ] ;
			[ <nosize: NOSIZE> ] ;
			[ <nosysmenu: NOSYSMENU> ] ;                             
			[ <nocaption: NOCAPTION> ] ;                             
			[ CURSOR <cursor> ] ;
			[ ONINIT <InitProcedure> ] ;
			[ ONRELEASE <ReleaseProcedure> ] ;
			[ ONINTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ONMOUSECLICK <ClickProcedure> ] ;
			[ ONMOUSEDRAG <MouseDragProcedure> ] ;
			[ ONMOUSEMOVE <MouseMoveProcedure> ] ;
			[ ONSIZE <SizeProcedure> ] ;
			[ ONMAXIMIZE <MaximizeProcedure> ] ;
			[ ONMINIMIZE <MinimizeProcedure> ] ;
			[ ONPAINT <PaintProcedure> ] ;
		   [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ NOTIFYICON <NotifyIcon> ] ;
			[ NOTIFYTOOLTIP <NotifyIconTooltip> ] ;
			[ ONNOTIFYCLICK <NotifyLeftClick> ] ;
			[ ONGOTFOCUS <GotFocusProcedure> ] ;
			[ ONLOSTFOCUS <LostFocusProcedure> ] ;
			[ ONSCROLLUP <scrollup> ] ;
			[ ONSCROLLDOWN <scrolldown> ] ;
			[ ONSCROLLLEFT <scrollleft> ] ;
			[ ONSCROLLRIGHT <scrollright> ] ;
			[ ONHSCROLLBOX <hScrollBox> ] ;
			[ ONVSCROLLBOX <vScrollBox> ] ;
			[ HELPBUTTON <helpbutton> ] ;
			[ <main:  WINDOWTYPE MAIN> ] ;
			[ <child: WINDOWTYPE CHILD> ] ;
			[ WINDOWTYPE STANDARD ] ;
			[ VISIBLE <visible> ] ;
			[ AUTORELEASE <autorelease> ] ;
			[ MINBUTTON <minbutton> ] ;
			[ MAXBUTTON <maxbutton> ] ;
			[ SIZABLE <sizable> ] ;
			[ SYSMENU <sysmenu> ] ;
			[ TITLEBAR <titlebar> ] ;
			[ FONTNAME <FontName> FONTSIZE <FontSize> ] ;
	=>;
	DECLARE WINDOW <w>  ;;
	DECLARE CUSTOM COMPONENTS <w> ;;
	_DefineWindow ( <"w">, <title>, <col>, <row>, <wi>, <h>, <.nominimize.>, <.nomaximize.>, <.nosize.>, <.nosysmenu.>, <.nocaption.>,.F., '',<{InitProcedure}>, <{ReleaseProcedure}> , <{MouseDragProcedure}>, <{SizeProcedure}> , <{ClickProcedure}> , <{MouseMoveProcedure}>, <backcolor> , <{PaintProcedure}> , <.noshow.> , <.topmost.> , <.main.> , <icon> , <.child.> , <FontName> , <FontSize>, <NotifyIcon> , <NotifyIconTooltip> , <{NotifyLeftClick}>  , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight> , <vWidth> , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}> , <.helpbutton.> , <{MaximizeProcedure}> , <{MinimizeProcedure}> , <cursor> , <.noautorelease.> , <{interactivecloseprocedure}> , <visible> , <autorelease> , <minbutton> , <maxbutton> , <sizable> , <sysmenu> , <titlebar> , <"parent"> , <.panel.> )  


	***********************************************************************
	* Modal 
	***********************************************************************


	#xcommand DEFINE WINDOW <w> ;
			[ AT <row>,<col> ] ;
			[ ROW <row> ] ;
			[ COL <col> ] ;
			[ WIDTH <wi> ];
			[ HEIGHT <h> ];
			[ VIRTUAL WIDTH <vWidth> ] ;                             
			[ VIRTUAL HEIGHT <vHeight> ] ;                             
			[ TITLE <title> ] ;
			[ ICON <icon> ] ;
			MODAL ;
			[ <noshow: NOSHOW> ] ;
			[ <noautorelease: NOAUTORELEASE> ] ;
			[ <nosize: NOSIZE> ] ;
			[ <nosysmenu: NOSYSMENU> ] ;                             
			[ <nocaption: NOCAPTION> ] ;                             
			[ CURSOR <cursor> ] ;
			[ ON INIT <InitProcedure> ] ;
			[ ON RELEASE <ReleaseProcedure> ] ;
			[ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ON MOUSECLICK <ClickProcedure> ] ;
			[ ON MOUSEDRAG <MouseDragProcedure> ] ;
			[ ON MOUSEMOVE <MouseMoveProcedure> ] ;
			[ ON SIZE <SizeProcedure> ] ;
			[ ON PAINT <PaintProcedure> ] ;
		   [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ ON GOTFOCUS <GotFocusProcedure> ] ;
			[ ON LOSTFOCUS <LostFocusProcedure> ] ;
			[ ON SCROLLUP <scrollup> ] ;
			[ ON SCROLLDOWN <scrolldown> ] ;
			[ ON SCROLLLEFT <scrollleft> ] ;
			[ ON SCROLLRIGHT <scrollright> ] ;
			[ ON HSCROLLBOX <hScrollBox> ] ;
			[ ON VSCROLLBOX <vScrollBox> ] ;
			[ <helpbutton:  HELPBUTTON> ] ;
			[ VISIBLE <visible> ] ;
			[ AUTORELEASE <autorelease> ] ;
			[ SIZABLE <sizable> ] ;
			[ SYSMENU <sysmenu> ] ;
			[ TITLEBAR <titlebar> ] ;
			[ FONTNAME <FontName> FONTSIZE <FontSize> ] ;
			[ <shorttitlebar: SHORTTITLEBAR> ] ;
	=>;
	DECLARE WINDOW <w> ;;
       _DefineModalWindow ( <"w">, <title>, <col>, <row>, <wi>, <h>, "" , <.nosize.>, <.nosysmenu.>, <.nocaption.> ,.F., '',<{InitProcedure}>, <{ReleaseProcedure}> , <{MouseDragProcedure}> , <{SizeProcedure}> , <{ClickProcedure}> , <{MouseMoveProcedure}>, [<backcolor>]  , <{PaintProcedure}> , <icon> , <FontName> , <FontSize> , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight>  , <vWidth>  , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}>  , <.helpbutton.> , <cursor> , <.noshow.>  , <.noautorelease.>  , <{interactivecloseprocedure}> , <visible> , <autorelease> , <sizable> , <sysmenu> , <titlebar> , <.shorttitlebar.> ) 


	***********************************************************************
	* Modal (Propertized HELPBUTTON / EVENTS)
	***********************************************************************


	#xcommand DEFINE WINDOW <w> ;
			[ AT <row>,<col> ] ;
			[ ROW <row> ] ;
			[ COL <col> ] ;
			[ WIDTH <wi> ];
			[ HEIGHT <h> ];
			[ VIRTUALWIDTH <vWidth> ] ;                             
			[ VIRTUALHEIGHT <vHeight> ] ;                             
			[ TITLE <title> ] ;
			[ ICON <icon> ] ;
			WINDOWTYPE MODAL ;
			[ <noshow: NOSHOW> ] ;
			[ <noautorelease: NOAUTORELEASE> ] ;
			[ <nosize: NOSIZE> ] ;
			[ <nosysmenu: NOSYSMENU> ] ;                             
			[ <nocaption: NOCAPTION> ] ;                             
			[ CURSOR <cursor> ] ;
			[ ONINIT <InitProcedure> ] ;
			[ ONRELEASE <ReleaseProcedure> ] ;
			[ ONINTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ONMOUSECLICK <ClickProcedure> ] ;
			[ ONMOUSEDRAG <MouseDragProcedure> ] ;
			[ ONMOUSEMOVE <MouseMoveProcedure> ] ;
			[ ONSIZE <SizeProcedure> ] ;
			[ ONPAINT <PaintProcedure> ] ;
		   [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ ONGOTFOCUS <GotFocusProcedure> ] ;
			[ ONLOSTFOCUS <LostFocusProcedure> ] ;
			[ ONSCROLLUP <scrollup> ] ;
			[ ONSCROLLDOWN <scrolldown> ] ;
			[ ONSCROLLLEFT <scrollleft> ] ;
			[ ONSCROLLRIGHT <scrollright> ] ;
			[ ONHSCROLLBOX <hScrollBox> ] ;
			[ ONVSCROLLBOX <vScrollBox> ] ;
			[ HELPBUTTON <helpbutton> ] ;
			[ VISIBLE <visible> ] ;
			[ AUTORELEASE <autorelease> ] ;
			[ SIZABLE <sizable> ] ;
			[ SYSMENU <sysmenu> ] ;
			[ TITLEBAR <titlebar> ] ;
			[ FONTNAME <FontName> FONTSIZE <FontSize> ] ;
			[ <shorttitlebar: SHORTTITLEBAR> ] ;
	=>;
	DECLARE WINDOW <w> ;;
       _DefineModalWindow ( <"w">, <title>, <col>, <row>, <wi>, <h>, "" , <.nosize.>, <.nosysmenu.>, <.nocaption.> ,.F., '',<{InitProcedure}>, <{ReleaseProcedure}> , <{MouseDragProcedure}> , <{SizeProcedure}> , <{ClickProcedure}> , <{MouseMoveProcedure}>, [<backcolor>]  , <{PaintProcedure}> , <icon> , <FontName> , <FontSize> , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight>  , <vWidth>  , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}>  , <.helpbutton.> , <cursor> , <.noshow.>  , <.noautorelease.>  , <{interactivecloseprocedure}> , <visible> , <autorelease> , <sizable> , <sysmenu> , <titlebar> , <.shorttitlebar.> ) 


	***********************************************************************
	* SplitChild
	***********************************************************************


	#xcommand  DEFINE WINDOW <w> ;
		[ WIDTH <wi> ];
		[ HEIGHT <h> ];
		[ VIRTUAL WIDTH <vWidth> ] ;                             
		[ VIRTUAL HEIGHT <vHeight> ] ;                             
		[ TITLE <title> ] ;
		SPLITCHILD ;
		[ <nocaption: NOCAPTION> ] ;
		[ CURSOR <cursor> ] ;
		[ FONT <FontName> SIZE <FontSize> ] ;
		[ GRIPPERTEXT <grippertext> ] ;
		[ <break: BREAK> ] ;
		[ <focused: FOCUSED> ] ;
		[ ON GOTFOCUS <GotFocusProcedure> ] ;
		[ ON LOSTFOCUS <LostFocusProcedure> ] ;
		[ ON SCROLLUP <scrollup> ] ;
		[ ON SCROLLDOWN <scrolldown> ] ;
		[ ON SCROLLLEFT <scrollleft> ] ;
		[ ON SCROLLRIGHT <scrollright> ] ;
		[ ON HSCROLLBOX <hScrollBox> ] ;
		[ ON VSCROLLBOX <vScrollBox> ] ;
		[ TITLEBAR <titlebar> ] ;
		[ FONTNAME <FontName> FONTSIZE <FontSize> ] ;
      [ ON PAINT <PaintProcedure> ] ;
      => ;
	DECLARE WINDOW <w>  ;;
	_DefineSplitChildWindow ( <"w">, <wi>, <h> , <.break.> , <grippertext> , <.nocaption.> , <title> , <FontName> , <FontSize> , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight>  , <vWidth> , <.focused.>  , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}> , <cursor> , <titlebar> , <{PaintProcedure}> ) ;;


	***********************************************************************
	* SplitChild (Propertized BREAK / FOCUSED / EVENTS)
	***********************************************************************


	#xcommand  DEFINE WINDOW <w> ;
		[ WIDTH <wi> ];
		[ HEIGHT <h> ];
		[ VIRTUALWIDTH <vWidth> ] ;                             
		[ VIRTUALHEIGHT <vHeight> ] ;                             
		[ TITLE <title> ] ;
		WINDOWTYPE SPLITCHILD ;
		[ <nocaption: NOCAPTION> ] ;
		[ CURSOR <cursor> ] ;
		[ FONT <FontName> SIZE <FontSize> ] ;
		[ GRIPPERTEXT <grippertext> ] ;
		[ BREAK <break> ] ;
		[ FOCUSED <focused> ] ;
		[ ONGOTFOCUS <GotFocusProcedure> ] ;
		[ ONLOSTFOCUS <LostFocusProcedure> ] ;
		[ ONSCROLLUP <scrollup> ] ;
		[ ONSCROLLDOWN <scrolldown> ] ;
		[ ONSCROLLLEFT <scrollleft> ] ;
		[ ONSCROLLRIGHT <scrollright> ] ;
		[ ONHSCROLLBOX <hScrollBox> ] ;
		[ ONVSCROLLBOX <vScrollBox> ] ;
		[ TITLEBAR <titlebar> ] ;
		[ FONTNAME <FontName> FONTSIZE <FontSize> ] ;
      [ ONPAINT <PaintProcedure> ] ;
      => ;
	DECLARE WINDOW <w>  ;;
	_DefineSplitChildWindow ( <"w">, <wi>, <h> , <.break.> , <grippertext> , <.nocaption.> , <title> , <FontName> , <FontSize> , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight>  , <vWidth> , <.focused.>  , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}> , <cursor> , <titlebar> , <{PaintProcedure}>  ) ;;




	#xcommand LOAD WINDOW <w> ; 
	=> ;
	DECLARE WINDOW <w> ;;
	_HMG_SYSDATA \[ 214 \] := <"w"> ;;
	#include \<<w>.fmg\> 

	#xcommand LOAD WINDOW <ww> AS <w> ; 
	=> ;
	DECLARE WINDOW <w> ;;
	_HMG_SYSDATA \[ 214 \] := <"w"> ; #include \<<ww>.fmg\>


	#xcommand LOAD WINDOW <n> AT <r> , <c> WIDTH <w> HEIGHT <h> ; 
	=> ;
	DECLARE WINDOW <n> ;;
	_HMG_SYSDATA \[ 214 \] := <"n"> ;;
	_HMG_SYSDATA \[ 235 \] := <r> ;;
	_HMG_SYSDATA \[ 236 \] := <c> ;;
	_HMG_SYSDATA \[ 237 \] := <w> ;;
	_HMG_SYSDATA \[ 238 \] := <h> ;;
	#include \<<n>.fmg\> 



#xcommand RELEASE WINDOW <name> ;
	=>;
	DoMethod ( <"name"> , 'Release' )

#xcommand RELEASE WINDOW ALL  ;
	=>;
	ReleaseAllWindows()

#xcommand RELEASE WINDOW MAIN  ;
	=>;
	ReleaseAllWindows()

#xtranslate EXIT PROGRAM  ;
	=>;
	ReleaseAllWindows()

#xcommand ACTIVATE WINDOW <name, ...> ;
	=>;
    _ActivateWindow ( \{<"name">\} )


#xcommand ACTIVATE WINDOW DEBUGGER <name, ...>   =>   _ActivateWindow ( \{<"name">\}, .F. , .T. )


#xcommand ACTIVATE WINDOW ALL ;
	=>;
    _ActivateAllWindows()

#xcommand CENTER WINDOW <name> ;
	=>;
	DoMethod ( <"name"> , 'Center' )

 #xcommand CENTER WINDOW <name> DESKTOP;
	=>;
	DoMethod ( <"name"> , 'CenterDesktop' )

#xcommand CENTER WINDOW <name> IN <name2>;
	=>;
	DoMethod ( <"name"> , 'CenterIn' , <"name2"> )

#xcommand MAXIMIZE WINDOW <name> ;
	=>;
	DoMethod ( <"name"> , 'Maximize' ) 

#xcommand MINIMIZE WINDOW <name> ;
	=>;
	DoMethod ( <"name"> , 'Minimize' )

#xcommand RESTORE WINDOW <name> ;
	=>;
	DoMethod ( <"name"> , 'Restore' )

#xcommand SHOW WINDOW <name> ;
	=>;
	DoMethod ( <"name"> , 'Show' )

#xcommand HIDE WINDOW <name> ;
	=>;
	DoMethod ( <"name"> , 'Hide' )

#xcommand END WINDOW ;
	=>;
_EndWindow ()

#xtranslate DO EVENTS => DoEvents()

#xtranslate FETCH [ PROPERTY ] [ WINDOW ] <Arg1> <Arg2> TO <Arg3> ;
=> ;
<Arg3> := GetProperty ( <"Arg1"> , <"Arg2"> )

#xtranslate MODIFY [ PROPERTY ] [ WINDOW ] <Arg1> <Arg2> <Arg3> ;
=> ;
SetProperty ( <"Arg1"> , <"Arg2"> , <Arg3> )


#xcommand DEFINE WINDOW TEMPLATE ;
			[ <dummy1: OF, PARENT> <parent> ] ;
			[ AT <row>,<col> ];
			[ WIDTH <wi> ];
			[ HEIGHT <h> ];
			[ VIRTUAL WIDTH <vWidth> ] ;                             
			[ VIRTUAL HEIGHT <vHeight> ] ;                             
			[ TITLE <title> ] ;
			[ ICON <icon> ] ;
			[ <main:  MAIN> ] ;
			[ <child: CHILD> ] ;
			[ <panel: PANEL> ] ;
			[ <noshow: NOSHOW> ] ;
			[ <topmost: TOPMOST> ] ;
			[ <noautorelease: NOAUTORELEASE> ] ;
			[ <nominimize: NOMINIMIZE> ] ;
			[ <nomaximize: NOMAXIMIZE> ] ;
			[ <nosize: NOSIZE> ] ;
			[ <nosysmenu: NOSYSMENU> ] ;                             
			[ <nocaption: NOCAPTION> ] ;                             
			[ CURSOR <cursor> ] ;
			[ ON INIT <InitProcedure> ] ;
			[ ON RELEASE <ReleaseProcedure> ] ;
			[ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ON MOUSECLICK <ClickProcedure> ] ;
			[ ON MOUSEDRAG <MouseDragProcedure> ] ;
			[ ON MOUSEMOVE <MouseMoveProcedure> ] ;
			[ ON SIZE <SizeProcedure> ] ;
			[ ON MAXIMIZE <MaximizeProcedure> ] ;
			[ ON MINIMIZE <MinimizeProcedure> ] ;
			[ ON PAINT <PaintProcedure> ] ;
		   [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ NOTIFYICON <NotifyIcon> ] ;
			[ NOTIFYTOOLTIP <NotifyIconTooltip> ] ;
			[ ON NOTIFYCLICK <NotifyLeftClick> ] ;
			[ ON GOTFOCUS <GotFocusProcedure> ] ;
			[ ON LOSTFOCUS <LostFocusProcedure> ] ;
			[ ON SCROLLUP <scrollup> ] ;
			[ ON SCROLLDOWN <scrolldown> ] ;
			[ ON SCROLLLEFT <scrollleft> ] ;
			[ ON SCROLLRIGHT <scrollright> ] ;
			[ ON HSCROLLBOX <hScrollBox> ] ;
			[ ON VSCROLLBOX <vScrollBox> ] ;
			[ <helpbutton:  HELPBUTTON> ] ;
			[ VISIBLE <visible> ] ;
			[ AUTORELEASE <autorelease> ] ;
			[ MINBUTTON <minbutton> ] ;
			[ MAXBUTTON <maxbutton> ] ;
			[ SIZABLE <sizable> ] ;
			[ SYSMENU <sysmenu> ] ;
			[ TITLEBAR <titlebar> ] ;
	=>;
	_DefineWindow ( , <title>, <col>, <row>, <wi>, <h>, <.nominimize.>, <.nomaximize.>, <.nosize.>, <.nosysmenu.>, <.nocaption.>,.F., '',<{InitProcedure}>, <{ReleaseProcedure}> , <{MouseDragProcedure}>, <{SizeProcedure}> , <{ClickProcedure}> , <{MouseMoveProcedure}>, [<backcolor>] , <{PaintProcedure}> , <.noshow.> , <.topmost.> , <.main.> , <icon> , <.child.> , <FontName> , <FontSize>, <NotifyIcon> , <NotifyIconTooltip> , <{NotifyLeftClick}>  , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight> , <vWidth> , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}> , <.helpbutton.> , <{MaximizeProcedure}> , <{MinimizeProcedure}> , <cursor>  , <.noautorelease.> , <{interactivecloseprocedure}> , <visible> , <autorelease> , <minbutton> , <maxbutton> , <sizable> , <sysmenu> , <titlebar> , <"parent"> , <.panel.> ) 


#xcommand DEFINE WINDOW TEMPLATE ;
			[ AT <row>,<col> ];
			[ WIDTH <wi> ];
			[ HEIGHT <h> ];
			[ VIRTUAL WIDTH <vWidth> ] ;                             
			[ VIRTUAL HEIGHT <vHeight> ] ;                             
			[ TITLE <title> ] ;
			[ ICON <icon> ] ;
			MODAL ;
			[ <noshow: NOSHOW> ] ;
			[ <noautorelease: NOAUTORELEASE> ] ;
			[ <nosize: NOSIZE> ] ;
			[ <nosysmenu: NOSYSMENU> ] ;                             
			[ <nocaption: NOCAPTION> ] ;                             
			[ CURSOR <cursor> ] ;
			[ ON INIT <InitProcedure> ] ;
			[ ON RELEASE <ReleaseProcedure> ] ;
			[ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ON MOUSECLICK <ClickProcedure> ] ;
			[ ON MOUSEDRAG <MouseDragProcedure> ] ;
			[ ON MOUSEMOVE <MouseMoveProcedure> ] ;
			[ ON SIZE <SizeProcedure> ] ;
			[ ON PAINT <PaintProcedure> ] ;
		   [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ ON GOTFOCUS <GotFocusProcedure> ] ;
			[ ON LOSTFOCUS <LostFocusProcedure> ] ;
			[ ON SCROLLUP <scrollup> ] ;
			[ ON SCROLLDOWN <scrolldown> ] ;
			[ ON SCROLLLEFT <scrollleft> ] ;
			[ ON SCROLLRIGHT <scrollright> ] ;
			[ ON HSCROLLBOX <hScrollBox> ] ;
			[ ON VSCROLLBOX <vScrollBox> ] ;
			[ <helpbutton:  HELPBUTTON> ] ;
	=>;
	_DefineModalWindow ( , <title>, <col>, <row>, <wi>, <h>, "" , <.nosize.>, <.nosysmenu.>, <.nocaption.> ,.F., '',<{InitProcedure}>, <{ReleaseProcedure}> , <{MouseDragProcedure}> , <{SizeProcedure}> , <{ClickProcedure}> , <{MouseMoveProcedure}>, [<backcolor>]  , <{PaintProcedure}> , <icon> , <FontName> , <FontSize> , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight>  , <vWidth>  , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}> , <.helpbutton.> , <cursor> , <.noshow.>  , <.noautorelease.>  , <{interactivecloseprocedure}> )   


#xcommand  DEFINE WINDOW TEMPLATE ;
		[ WIDTH <wi> ];
		[ HEIGHT <h> ];
		[ VIRTUAL WIDTH <vWidth> ] ;                             
		[ VIRTUAL HEIGHT <vHeight> ] ;                             
		[ TITLE <title> ] ;
		SPLITCHILD ;
		[ <nocaption: NOCAPTION> ] ;
		[ CURSOR <cursor> ] ;
		[ FONT <FontName> SIZE <FontSize> ] ;
		[ GRIPPERTEXT <grippertext> ] ;
		[ <break: BREAK> ] ;
		[ <focused: FOCUSED> ] ;
		[ ON GOTFOCUS <GotFocusProcedure> ] ;
		[ ON LOSTFOCUS <LostFocusProcedure> ] ;
		[ ON SCROLLUP <scrollup> ] ;
		[ ON SCROLLDOWN <scrolldown> ] ;
		[ ON SCROLLLEFT <scrollleft> ] ;
		[ ON SCROLLRIGHT <scrollright> ] ;
		[ ON HSCROLLBOX <hScrollBox> ] ;
		[ ON VSCROLLBOX <vScrollBox> ] ;
      [ ON PAINT <PaintProcedure> ] ;
      => ;
	_DefineSplitChildWindow ( , <wi>, <h> , <.break.> , <grippertext> , <.nocaption.> , <title> , <FontName> , <FontSize> , <{GotFocusProcedure}>, <{LostFocusProcedure}> , <vHeight>  , <vWidth> , <.focused.>  , <{scrollleft}> , <{scrollright}> , <{scrollup}> , <{scrolldown}> , <{hScrollBox}> , <{vScrollBox}> , <cursor>, NIL,  , <{PaintProcedure}>  ) ;;


   
#xtranslate WAIT WINDOW <message>         => WaitWindow ( <message> , .F. )
#xtranslate WAIT WINDOW <message> NOWAIT  => WaitWindow ( <message> , .T. )
#xtranslate WAIT CLEAR                    => WaitWindow ()



#xtranslate SET TOOLTIPSTYLE BALLOON  => _HMG_SYSDATA \[55\] := .T.
#xtranslate SET TOOLTIPSTYLE STANDARD => _HMG_SYSDATA \[55\] := .F.

#xtranslate SET TOOLTIPBACKCOLOR <aColor> => _HMG_SYSDATA \[56\] := <aColor>
#xtranslate SET TOOLTIPFORECOLOR <aColor> => _HMG_SYSDATA \[57\] := <aColor>


// by Dr. Claudio Soto (December 2014)

#xtranslate SET TOOLTIPMENU ON         =>   SetToolTipMenu ( .T. )
#xtranslate SET TOOLTIPMENU OFF        =>   SetToolTipMenu ( .F. )
#xtranslate SET TOOLTIPMENU TO <lOn>   =>   SetToolTipMenu ( <lOn> )
#xtranslate ToolTipMenuIsActive ()     =>   _HMG_SYSDATA \[ 510 \]


#xtranslate SET TOOLTIPCUSTOMDRAW ON         =>   SetToolTipCustomDraw ( .T. )
#xtranslate SET TOOLTIPCUSTOMDRAW OFF        =>   SetToolTipCustomDraw ( .F. )
#xtranslate SET TOOLTIPCUSTOMDRAW TO <lOn>   =>   SetToolTipCustomDraw ( <lOn> )
#xtranslate ToolTipCustomDrawIsActive ()     =>   _HMG_SYSDATA \[ 509 \]

#define TOOLTIPICON_NONE            0
#define TOOLTIPICON_INFO            1
#define TOOLTIPICON_WARNING         2
#define TOOLTIPICON_ERROR           3
#define TOOLTIPICON_INFO_LARGE      4
#define TOOLTIPICON_WARNING_LARGE   5
#define TOOLTIPICON_ERROR_LARGE     6


#xtranslate SET TOOLTIPCUSTOMDRAW FORM <FormName> [ BACKCOLOR <aBackColor> ] [ FORECOLOR <aForeColor> ] [ ARRAYFONT <aFont> ] [ BALLOON <lBalloon> ] [ TITLE <cTitle> ] [ ICON <xIcon> ] =>;
            SetToolTipCustomDrawForm ( <"FormName">, <aBackColor>, <aForeColor>, <aFont>, <lBalloon>, <cTitle>, <xIcon> )

#xtranslate SET TOOLTIPCUSTOMDRAW CONTROL <ControlName> OF <ParentName> [ BACKCOLOR <aBackColor> ] [ FORECOLOR <aForeColor> ] [ ARRAYFONT <aFont> ] [ BALLOON <lBalloon> ] [ TITLE <cTitle> ] [ ICON <xIcon> ] =>;
            SetToolTipCustomDrawControl ( <"ControlName">, <"ParentName">, <aBackColor>, <aForeColor>, <aFont>, <lBalloon>, <cTitle>, <xIcon> )


// by Dr. Claudio Soto (June 2013)

#xtranslate CREATE EVENT PROCNAME <cProcName> [HWND <hWnd>] [MSG <nMsg>] =>;
EventCreate (<"cProcName">, <hWnd>, <nMsg>)

#xtranslate CREATE EVENT PROCNAME <cProcName> [HWND <hWnd>] [MSG <nMsg>] STOREINDEX <VarStoreIndex> =>;
<VarStoreIndex> := EventCreate (<"cProcName">, <hWnd>, <nMsg>)


// by Dr. Claudio Soto (April 2016)

#xtranslate CREATE EVENT CODEBLOCK <bCodeBlock> [HWND <hWnd>] [MSG <nMsg>] =>;
EventCreate (<bCodeBlock>, <hWnd>, <nMsg>)

#xtranslate CREATE EVENT CODEBLOCK <bCodeBlock> [HWND <hWnd>] [MSG <nMsg>] STOREINDEX <VarStoreIndex> =>;
<VarStoreIndex> := EventCreate (<bCodeBlock>, <hWnd>, <nMsg>)



// by Dr. Claudio Soto (July 2013)

#define LWA_COLORKEY 0x01
#define LWA_ALPHA    0x02

#xtranslate SET WINDOW <FormName> TRANSPARENT TO <nAlphaBlend> =>;   // nAlphaBlend = 0 to 255 (completely transparent = 0, opaque = 255)
SetLayeredWindowAttributes (GetFormHandle(<"FormName">), 0, <nAlphaBlend>, LWA_ALPHA)

#xtranslate SET WINDOW <FormName> [ TRANSPARENT ] TO OPAQUE =>;
SetLayeredWindowAttributes (GetFormHandle(<"FormName">), 0, 255, LWA_ALPHA)

#xtranslate SET WINDOW <FormName> TRANSPARENT TO COLOR <aColor> =>;
SetLayeredWindowAttributes (GetFormHandle(<"FormName">), RGB(<aColor>\[1\], <aColor>\[2\], <aColor>\[3\]), 0, LWA_COLORKEY)



#define FLASHW_CAPTION 1
#define FLASHW_TRAY 2
#define FLASHW_ALL (FLASHW_CAPTION + FLASHW_TRAY)

#xtranslate FLASH WINDOW <FormName> CAPTION COUNT <nTimes> INTERVAL <nMilliseconds> =>;
FlashWindowEx (GetFormHandle(<"FormName">), FLASHW_CAPTION, <nTimes>, <nMilliseconds>) 

#xtranslate FLASH WINDOW <FormName> TASKBAR COUNT <nTimes> INTERVAL <nMilliseconds> =>;
FlashWindowEx (GetFormHandle(<"FormName">), FLASHW_TRAY, <nTimes>, <nMilliseconds>) 

#xtranslate FLASH WINDOW <FormName> [ ALL ] COUNT <nTimes> INTERVAL <nMilliseconds> =>;
FlashWindowEx (GetFormHandle(<"FormName">), FLASHW_ALL, <nTimes>, <nMilliseconds>) 


// ANIMATE WINDOW MODE <nFlags>
#define AW_HOR_POSITIVE 0x00000001
#define AW_HOR_NEGATIVE 0x00000002
#define AW_VER_POSITIVE 0x00000004
#define AW_VER_NEGATIVE 0x00000008
#define AW_CENTER       0x00000010
#define AW_HIDE         0x00010000
#define AW_ACTIVATE     0x00020000
#define AW_SLIDE        0x00040000
#define AW_BLEND        0x00080000

#xtranslate ANIMATE WINDOW <FormName> INTERVAL <nMilliseconds> MODE <nFlags> =>;
AnimateWindow (GetFormHandle(<"FormName">), <nMilliseconds>, <nFlags>)

#xtranslate ANIMATE WINDOW <FormName> MODE <nFlags>  =>;
AnimateWindow (GetFormHandle(<"FormName">), 200, <nFlags>)


#xtranslate SET WINDOW MAIN [ FIRST ] OFF   =>   _HMG_MainWindowFirst := .F.
#xtranslate SET WINDOW MAIN [ FIRST ] ON    =>   _HMG_MainWindowFirst := .T.


#xcommand SET MIXEDMODE => REQUEST HB_GT_WIN_DEFAULT

#xtranslate RELEASE MEMORY => iif ( .T., ( HMG_GarbageCall() , EmptyWorkingSet() ), NIL )


// Show Window
#define SW_HIDE 0
#define SW_NORMAL 1
#define SW_SHOWNORMAL 1
#define SW_SHOWMINIMIZED 2
#define SW_MAXIMIZE 3
#define SW_SHOWMAXIMIZED 3
#define SW_SHOWNOACTIVATE 4
#define SW_SHOW 5
#define SW_MINIMIZE 6
#define SW_SHOWMINNOACTIVE 7
#define SW_SHOWNA 8
#define SW_RESTORE 9
#define SW_SHOWDEFAULT 10
#define SW_FORCEMINIMIZE 11
#define SW_MAX 11


// Window Style
#define WS_BORDER             0x800000
#define WS_CAPTION            0xC00000
#define WS_CHILD              0x40000000
#define WS_CHILDWINDOW        0x40000000
#define WS_CLIPCHILDREN       0x2000000
#define WS_CLIPSIBLINGS       0x4000000
#define WS_DISABLED           0x8000000
#define WS_DLGFRAME           0x400000
#define WS_GROUP              0x20000
#define WS_HSCROLL            0x100000
#define WS_ICONIC             0x20000000
#define WS_MAXIMIZE           0x1000000
#define WS_MAXIMIZEBOX        0x10000
#define WS_MINIMIZE           0x20000000
#define WS_MINIMIZEBOX        0x20000
#define WS_OVERLAPPED         0
#define WS_OVERLAPPEDWINDOW   0xCF0000
#define WS_POPUP              0x80000000
#define WS_POPUPWINDOW        0x80880000
#define WS_SIZEBOX            0x40000
#define WS_SYSMENU            0x80000
#define WS_TABSTOP            0x10000
#define WS_THICKFRAME         0x40000
#define WS_TILED              0
#define WS_TILEDWINDOW        0xCF0000
#define WS_VISIBLE            0x10000000
#define WS_VSCROLL            0x200000


// Window Extended Style
#define WS_EX_ACCEPTFILES        16
#define WS_EX_APPWINDOW          0x40000
#define WS_EX_CLIENTEDGE         512
#define WS_EX_COMPOSITED         0x2000000 /* XP */
#define WS_EX_CONTEXTHELP        0x400
#define WS_EX_CONTROLPARENT      0x10000
#define WS_EX_DLGMODALFRAME      1
#define WS_EX_LAYERED            0x80000   /* w2k */
#define WS_EX_LAYOUTRTL          0x400000 /* w98, w2k */
#define WS_EX_LEFT               0
#define WS_EX_LEFTSCROLLBAR      0x4000
#define WS_EX_LTRREADING         0
#define WS_EX_MDICHILD           64
#define WS_EX_NOACTIVATE         0x8000000 /* w2k */
#define WS_EX_NOINHERITLAYOUT    0x100000 /* w2k */
#define WS_EX_NOPARENTNOTIFY     4
#define WS_EX_OVERLAPPEDWINDOW   0x300
#define WS_EX_PALETTEWINDOW      0x188
#define WS_EX_RIGHT              0x1000
#define WS_EX_RIGHTSCROLLBAR     0
#define WS_EX_RTLREADING         0x2000
#define WS_EX_STATICEDGE         0x20000
#define WS_EX_TOOLWINDOW         128
#define WS_EX_TOPMOST            8
#define WS_EX_TRANSPARENT        32
#define WS_EX_WINDOWEDGE         256


// SetWindowPos()
#define SWP_DRAWFRAME      0x0020
#define SWP_FRAMECHANGED   0x0020
#define SWP_HIDEWINDOW     0x0080
#define SWP_NOACTIVATE     0x0010
#define SWP_NOCOPYBITS     0x0100
#define SWP_NOMOVE         0x0002
#define SWP_NOSIZE         0x0001
#define SWP_NOREDRAW       0x0008
#define SWP_NOZORDER       0x0004
#define SWP_SHOWWINDOW     0x0040
#define SWP_NOOWNERZORDER  0x0200
#define SWP_NOREPOSITION   SWP_NOOWNERZORDER
#define SWP_NOSENDCHANGING 0x0400
#define SWP_DEFERERASE     0x2000
#define SWP_ASYNCWINDOWPOS 0x4000


#command SET DEFAULT ICON TO <iconname>  =>  _HMG_DefaultIconName := <iconname>


// SetClassLongPtr() and GetClassLongPtr()
#define GCLP_MENUNAME (-8)
#define GCLP_HBRBACKGROUND (-10)
#define GCLP_HCURSOR (-12)
#define GCLP_HICON (-14)
#define GCLP_HMODULE (-16)
#define GCLP_WNDPROC (-24)
#define GCLP_HICONSM (-34)

#define GCL_CBWNDEXTRA (-18)
#define GCL_CBCLSEXTRA (-20)
#define GCL_STYLE (-26)
#define GCW_ATOM (-32)


// SetWindowLongPtr() and GetWindowLongPtr()
#define GWLP_WNDPROC (-4)
#define GWLP_HINSTANCE (-6)
#define GWLP_HWNDPARENT (-8)
#define GWLP_USERDATA (-21)
#define GWLP_ID (-12)

#define GWL_STYLE (-16)
#define GWL_EXSTYLE (-20)


#xtranslate HMG_IsWin64() => IF( EMPTY( GetEnv( "ProgramW6432" ) ), .F., .T. )
