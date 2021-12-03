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


// WINDOWS (THIS)

   #xtranslate This . <p:Title,NotifyIcon,NotifyTooltip,FocusedControl> => GetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> )
   #xtranslate This . <p:Title,Cursor,NotifyTooltip> := <arg> => SetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> , <arg> )
   #xtranslate This . <p:Activate,Center,Release,Maximize,Minimize,Restore> [ () ] => DoMethod ( _HMG_SYSDATA \[ 316 \] , <"p"> )


// WINDOWS (THISWINDOW)

   #xtranslate ThisWindow . <p:Title,NotifyIcon,NotifyTooltip,FocusedControl,Name,Row,Col,Width,Height> => GetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> )
   #xtranslate ThisWindow . <p:Title,Cursor,NotifyIcon,NotifyTooltip,Row,Col,Width,Height> := <arg> => SetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> , <arg> )
   #xtranslate ThisWindow . <p:Activate,Center,Redraw,CenterDesktop,Release,Maximize,Minimize,Restore,Show,Hide,SetFocus> [ () ] => DoMethod ( _HMG_SYSDATA \[ 316 \] , <"p"> )
   #xtranslate ThisWindow . <p:CenterIn> (\<arg\>) => DoMethod ( _HMG_SYSDATA \[ 316 \] , \<"p"\> , \<"arg"\> )
   #xtranslate ThisWindow . <p:HANDLE,INDEX,IsMinimized,IsMaximized,ClientAreaWidth,ClientAreaHeight> => GetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> )
   #xtranslate ThisWindow . <p:NoClose,NoCaption,NoMaximize,NoMinimize,NoSize,NoSysMenu,HScroll,VScroll,Enabled> => GetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> )
   #xtranslate ThisWindow . <p:NoClose,NoCaption,NoMaximize,NoMinimize,NoSize,NoSysMenu,HScroll,VScroll,Enabled> := <arg> => SetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> , <arg> )
   #xtranslate ThisWindow . <p:AlphaBlendTransparent,BackColorTransparent> := <arg> => SetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> , <arg> )


// CONTROLS

// RichEditBox ( by Dr. Claudio Soto, January 2014 )
#xtranslate ThisRichEditBox . <p: GetClickLinkRange, GetClickLinkText > => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> )

// GridEx ( by Dr. Claudio Soto, April 2013 )
#xtranslate This . <p:ColumnCOUNT> => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> )

#xtranslate This . <p:ColumnHEADER, ColumnWIDTH, ColumnJUSTIFY, ColumnCONTROL, ColumnDYNAMICBACKCOLOR, ColumnDYNAMICFORECOLOR,; 
                      ColumnVALID, ColumnWHEN, ColumnONHEADCLICK, ColumnDISPLAYPOSITION> (<n>) => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <n>)

#xtranslate This . <p:ColumnHEADER, ColumnWIDTH, ColumnJUSTIFY, ColumnCONTROL, ColumnDYNAMICBACKCOLOR, ColumnDYNAMICFORECOLOR,; 
                      ColumnVALID, ColumnWHEN, ColumnONHEADCLICK, ColumnDISPLAYPOSITION> (<n>) := <arg> => SetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <n> , <arg> )

#xtranslate This . <p:CellEx> (<n1>, <n2>) => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <n1>, <n2>)
#xtranslate This . <p:CellEx> (<n1>, <n2>) := <arg> => SetProperty (  _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \]  , <"p"> , <n1>, <n2>, <arg>)

#xtranslate This . <p:AddColumnEx> (<a1> , <a2> , <a3> , <a4> , <a5> ) => Domethod (  _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <a1> , <a2> , <a3> , <a4> , <a5> )

#xtranslate This . <p:AddItemEx> (<a1> , <a2>) => Domethod (  _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <a1> , <a2> )

#xtranslate This . <p:BackGroundImage> (<a1> , <a2> , <a3> , <a4>) => SetProperty (  _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <a1> , <a2> , <a3> , <a4> )

#xtranslate This . <p:CellRowFocused, CellColFocused, CellRowClicked, CellColClicked> => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> )


* Property without arguments

   #xtranslate This . <p:Format,BackColor,FontColor,ForeColor,Value,Address,Picture,Tooltip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeout,Caption,Displayvalue,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Length,Position,CaretPos> => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> )
   #xtranslate This . <p:Format,BackColor,FontColor,ForeColor,Value,ReadOnly,Address,Picture,Tooltip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeout,Caption,DisplayValue,Enabled,Checked,RangeMin,RangeMax,Repeat,Speed,Volume,Zoom,Position,CaretPos>	:= <arg>	=> SetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <arg> )
   #xtranslate This . <p:HANDLE,INDEX,TYPE> => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> )

* Property with 1 argument

   #xtranslate This . <p:Item,Caption,Header> (<n>) => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <n> )
   #xtranslate This . <p:Item,Caption,Header> (<n>) := <arg> => SetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <n> , <arg> )	

* Property with 2 arguments

   #xtranslate This . <p:Cell> ( <n1> , <n2> ) => GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <n1> , <n2> )
   #xtranslate This . <p:Cell> ( <n1> , <n2> ) := <arg> => SetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <n1> , <n2> , <arg> )

* Method without arguments

   #xtranslate This . <p:Redraw,Refresh,DeleteAllItems,Release,Play,Stop,Close,PlayReverse,Pause,Eject,OpenDialog,Resume,Save> [ () ] => DoMethod ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> )

* Method with 1 argument

   #xtranslate This . <p:AddItem,DeleteItem,Open,Seek,DeletePage,DeleteColumn,Expand,Collapse> (<arg>) => DoMethod ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <arg> )

* Method with 2 arguments

   #xtranslate This . <p:AddItem> (<arg1>,<arg2>) => DoMethod ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <arg1> , <arg2> )

* Method with 3 arguments

   #xtranslate This . <p:AddItem,AddPage> (<arg1>,<arg2>,<arg3>) => DoMethod ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <arg1> , <arg2> , <arg3> )

* Method with 4 arguments

   #xtranslate This . <p:AddControl,AddColumn> ( <arg1> , <arg2> , <arg3>  , <arg4> ) => DoMethod ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <arg1> , <arg2> , <arg3> , <arg4> )


// COMMON ( REQUIRES TYPE CHECK )

   #xtranslate This . <p:Name,Row,Col,Width,Height> => if ( _HMG_SYSDATA \[ 231 \] == 'C' , GetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> ) , GetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> ) )
   #xtranslate This . <p:Row,Col,Width,Height> := <arg> => if ( _HMG_SYSDATA \[ 231 \] == 'C' , SetProperty ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> , <arg> ) , SetProperty ( _HMG_SYSDATA \[ 316 \] , <"p"> , <arg> ) )
   #xtranslate This . <p:Show,Hide,SetFocus> [ () ] => if ( _HMG_SYSDATA \[ 231 \] == 'C' , DoMethod ( _HMG_SYSDATA \[ 316 \] , _HMG_SYSDATA \[ 317 \] , <"p"> ) , DoMethod ( _HMG_SYSDATA \[ 316 \] , <"p"> ) )

// EVENT PROCEDURES

   #xtranslate This.QueryRowIndex      => _HMG_SYSDATA \[ 201 \]
   #xtranslate This.QueryColIndex      => _HMG_SYSDATA \[ 202 \]
   #xtranslate This.QueryData          => _HMG_SYSDATA \[ 230 \]
   #xtranslate This.CellRowIndex       => _HMG_SYSDATA \[ 195 \]
   #xtranslate This.CellColIndex       => _HMG_SYSDATA \[ 196 \]
   #xtranslate This.CellRow            => _HMG_SYSDATA \[ 197 \]
   #xtranslate This.CellCol            => _HMG_SYSDATA \[ 198 \]
   #xtranslate This.CellWidth          => _HMG_SYSDATA \[ 199 \]
   #xtranslate This.CellHeight         => _HMG_SYSDATA \[ 200 \]
   #xtranslate This.CellValue          => _HMG_SYSDATA \[ 318 \]
   #xtranslate This.CellValueEx := <arg> => _HMG_SYSDATA \[ 318 \] := <arg>
   #xtranslate This.CellValue   := <arg> => _HMG_SetGridCellEditValue ( <arg> ) 

   #xtranslate This.EditBuffer         => _HMG_SYSDATA \[ 278 \] 
   #xtranslate This.MarkBuffer         => _HMG_SYSDATA \[ 279 \]
   #xtranslate This.AppendBuffer       => _HMG_SYSDATA \[ 280 \] 


// by Dr. Claudio Soto, April 2016
   #xtranslate This.InplaceEditControlHandle  => GridInplaceEdit_ControlHandle()
   #xtranslate This.InplaceEditControlIndex   => GridInplaceEdit_ControlIndex()
   #xtranslate This.InplaceEditGridName       => GridInplaceEdit_GridName()
   #xtranslate This.InplaceEditParentName     => GridInplaceEdit_ParentName()

   #xtranslate This.IsInplaceEditEventInit       => IIF( _HMG_GridInplaceEdit_StageEvent == 1, .T., .F. )
   #xtranslate This.IsInplaceEditEventRun        => IIF( _HMG_GridInplaceEdit_StageEvent == 2, .T., .F. )
   #xtranslate This.IsInplaceEditEventFinish     => IIF( _HMG_GridInplaceEdit_StageEvent == 3, .T., .F. )
