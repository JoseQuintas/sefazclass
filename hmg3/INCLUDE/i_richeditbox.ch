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

#xcommand @ <row>,<col> RICHEDITBOX <name> ;
		[ <dummy1: OF, PARENT> <parent> ] ;
		[ WIDTH <w> ] ;
		[ HEIGHT <h> ] ;
		[ FIELD <field> ]		;
		[ VALUE <value> ] ;
		[ < readonly: READONLY > ] ;
		[ FONT <f> ] ;
		[ SIZE <s> ] ;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ] ;
		[ BACKCOLOR <backcolor> ] ;
		[ MAXLENGTH <maxlength> ] ;
                [ ON GOTFOCUS <gotfocus> ] ;
                [ ON CHANGE <change> ] ;
                [ ON LOSTFOCUS <lostfocus> ] ;
		[ HELPID <helpid> ] 		;
		[ <invisible: INVISIBLE> ] ;
		[ <notabstop: NOTABSTOP> ] ;
      [ <noHscroll: NOHSCROLL> ] ;
      [ <noVscroll: NOVSCROLL> ] ;
      [ ON SELECT <selectchange> ] ;
      [ ON LINK <onlink> ] ;
      [ ON VSCROLL  <OnVScroll> ] ;
	=>;
	_DefineRichEditBox ( <"name">, <"parent">, <col>, <row>, <w>, <h>, <value> ,<f>,<s> , <tooltip>  , <maxlength>  , <{gotfocus}>  , <{change}>  , <{lostfocus}>  , <.readonly.> , .f. , <helpid>, <.invisible.>, <.notabstop.> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <"field"> , <backcolor> , <.noHscroll.> , <.noVscroll.> , <{selectchange}> , <{onlink}> , <{OnVScroll}> )

//SPLITBOX VERSION

#xcommand RICHEDITBOX <name> ;
		[ <dummy1: OF, PARENT> <parent> ] ;
		[ WIDTH <w> ] ;
		[ HEIGHT <h> ] ;
		[ FIELD <field> ]		;
		[ VALUE <value> ] ;
		[ < readonly: READONLY > ] ;
		[ FONT <f> ] ;
		[ SIZE <s> ] ;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ] ;
		[ BACKCOLOR <backcolor> ] ;
		[ MAXLENGTH <maxlength> ] ;
                [ ON GOTFOCUS <gotfocus> ] ;
                [ ON CHANGE <change> ] ;
                [ ON LOSTFOCUS <lostfocus> ] ;
		[ HELPID <helpid> ] 		;
		[ <break: BREAK> ] ;
		[ <invisible: INVISIBLE> ] ;
		[ <notabstop: NOTABSTOP> ] ;
      [ <noHscroll: NOHSCROLL> ] ;
      [ <noVscroll: NOVSCROLL> ] ;
      [ ON SELECT <selectchange> ] ;
      [ ON LINK <onlink> ] ;
      [ ON VSCROLL  <OnVScroll> ] ;
      =>;
	_DefineRichEditBox ( <"name">, <"parent">, , , <w>, <h>, <value> ,<f>,<s> , <tooltip>  , <maxlength>  , <{gotfocus}>  , <{change}>  , <{lostfocus}>  , <.readonly.> , <.break.>  , <helpid>, <.invisible.>, <.notabstop.> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <"field">  , <backcolor>  , <.noHscroll.> , <.noVscroll.> , <{selectchange}> , <{onlink}> , <{OnVScroll}>  )



// By Dr. Claudio Soto, January 2014

 
************
*   Font   *
************

#define RTF_FONTAUTOBACKCOLOR -1   // Transparent
#define RTF_FONTAUTOCOLOR     -1


#define RTF_SUBSCRIPT     1
#define RTF_SUPERSCRIPT   2
#define RTF_NORMALSCRIPT  3



*****************
*   Paragraph   *
*****************

// Alignment
#define RTF_LEFT     1
#define RTF_RIGHT    2
#define RTF_CENTER   3
#define RTF_JUSTIFY  4   // Not Work

// Numbering
#define RTF_NOBULLETNUMBER         1   // No paragraph numbering or bullets
#define RTF_BULLET                 2   // Insert a bullet at the beginning of each selected paragraph
#define RTF_ARABICNUMBER           3   // Use Arabic numbers          ( 0,  1,   2, ... )
#define RTF_LOWERCASELETTER        4   // Use lowercase letters       ( a,  b,   c, ... )
#define RTF_UPPERCASELETTER        5   // Use lowercase Roman letters ( i, ii, iii, ... )
#define RTF_LOWERCASEROMANNUMBER   6   // Use uppercase letters       ( A,  B,   C, ... )
#define RTF_UPPERCASEROMANNUMBER   7   // Use uppercase Roman letters ( I, II, III, ... )
#define RTF_CUSTOMCHARACTER        8   // Uses a sequence of characters beginning with the Unicode character specified by the nNumberingStar

// NumberingStyle
#define RTF_NONE        0
#define RTF_PAREN       1   // Follows the number with a right parenthesis.
#define RTF_PARENS      2   // Encloses the number in parentheses
#define RTF_PERIOD      3   // Follows the number with a period
#define RTF_PLAIN       4   // Displays only the number
#define RTF_NONUMBER    5   // Continues a numbered list without applying the next number or bullet
#define RTF_NEWNUMBER   6   // Starts a new number with nNumberingStart


#define RTF_AUTOBACKGROUNDCOLOR   -1


*****************
*   File type   *
*****************

#define RICHEDITFILE_TEXT        1
#define RICHEDITFILE_TEXTUTF8    2
#define RICHEDITFILE_TEXTUTF16   3
#define RICHEDITFILE_RTF         4
#define RICHEDITFILE_RTFUTF8     5

