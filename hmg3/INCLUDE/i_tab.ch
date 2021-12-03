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

#xcommand DEFINE TAB <name> ;
		[ <dummy1: OF, PARENT> <parent> ] ;
		AT <row> , <col> ;
		WIDTH <w> ;
		HEIGHT <h> ;
		[ VALUE <value> ] ;
		[ FONT <f> ] ;
		[ SIZE <s> ] ;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ] ;
      [ <buttons: BUTTONS> ]       ;
      [ <flat: FLAT> ]       ;
      [ <hottrack: HOTTRACK> ]       ;
      [ <vertical: VERTICAL> ]       ;
		[ ON CHANGE <change> ] ;
      [ <notabstop: NOTABSTOP> ]       ;
      [ <multiline: MULTILINE> ]       ;
      [ <NoTrans: NOTRANSPARENT> ] ;
	=>;
	_BeginTab( <"name"> , <"parent"> , <row> , <col> , <w> , <h> , <value> , <f> , <s> , <tooltip> , <{change}> , <.buttons.> , <.flat.> , <.hottrack.> , <.vertical.>, <.notabstop.> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <.multiline.> , <.NoTrans.> ) 


* Alternate Syntax

#xcommand DEFINE TAB <name> ;
		[ PARENT> <parent> ] ;
		ROW <row> ;
		COL <col> ;
		WIDTH <w> ;
		HEIGHT <h> ;
		[ VALUE <value> ] ;
		[ FONTNAME <f> ] ;
		[ FONTSIZE <s> ] ;
		[ FONTBOLD <bold> ] ;
		[ FONTITALIC <italic> ] ;
		[ FONTUNDERLINE <underline> ] ;
		[ FONTSTRIKEOUT <strikeout> ] ;
		[ TOOLTIP <tooltip> ] ;
      [ BUTTONS <buttons> ]       ;
      [ FLAT <flat> ]       ;
      [ HOTTRACK <hottrack> ]       ;
      [ VERTICAL <vertical> ]       ;
		[ ON CHANGE <change> ] ;
      [ TABSTOP <tabstop> ]       ;
      [ MULTILINE <multiline> ]       ;
      [ TRANSPARENT <Trans> ] ;
	=>;
	_BeginTab( <"name"> , <"parent"> , <row> , <col> , <w> , <h> , <value> , <f> , <s> , <tooltip> , <{change}> , <.buttons.> , <.flat.> , <.hottrack.> , <.vertical.>, !<.tabstop.> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <.multiline.> , !<.Trans.>) 



#xcommand PAGE <caption> [ IMAGE <image> ] ;
	=>;
	_BeginTabPage ( <caption> , <image> ) 

#xcommand DEFINE PAGE <caption>  [ IMAGE <image> ] ;
	=>;
	_BeginTabPage ( <caption> , <image> ) 

#xcommand DEFINE TAB PAGE <caption>  [ IMAGE <image> ] ;
	=>;
	_BeginTabPage ( <caption> , <image> ) 

#xcommand END PAGE ;
	=>;
	_EndTabPage()

#xcommand END TAB ;
	=>;
	_EndTab()


