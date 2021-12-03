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
#define BROWSE_JTFY_LEFT        	0
#define BROWSE_JTFY_RIGHT       	1
#define BROWSE_JTFY_CENTER      	2
#define BROWSE_JTFY_JUSTIFYMASK 	3

#xtranslate MemVar . <AreaName> . <FieldName> =>  MemVar<AreaName><FieldName>
///////////////////////////////////////////////////////////////////////////////
// STANDARD BROWSE
///////////////////////////////////////////////////////////////////////////////

#xcommand @ <row>,<col> BROWSE <name> 		;
		[ OF <parent> ] 		;
		[ WIDTH <w> ] 			;
		[ HEIGHT <h> ] 			;
		[ HEADERS <headers> ] 		;
		[ WIDTHS <widths> ] 		;
		[ WORKAREA <workarea> ]	;
		[ FIELDS <Fields> ] 		;
		[ VALUE <value> ] 		;
		[ FONT <fontname> ] 		;
		[ SIZE <fontsize> ] 		;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ]  		;
		[ BACKCOLOR <backcolor> ] ;
		[ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
		[ INPUTMASK <inputmask> ]	;
		[ FORMAT <format> ]	;
		[ INPUTITEMS <inputitems> ]	;
		[ DISPLAYITEMS <displayitems> ]	;
		[ FONTCOLOR <fontcolor> ]	;
		[ ON GOTFOCUS <gotfocus> ] 	;
		[ ON CHANGE <change> ]  	;
		[ ON LOSTFOCUS <lostfocus> ] 	;
		[ ON DBLCLICK <dblclick> ]  	;
		[ <edit : EDIT> ] 		;
		[ <inplace : INPLACE> ]		;
		[ <append : APPEND> ] 		;
		[ ON HEADCLICK <aHeadClick> ] 	;
		[ WHEN <aWhenFields> ]		;
		[ VALID <aValidFields> ]	;
		[ VALIDMESSAGES <aValidMessages> ] ;
		[ READONLY <aReadOnly> ] 	;
		[ <lock: LOCK> ] 		;
		[ <Delete: DELETE> ]		;
		[ <style: NOLINES> ] 		;// Browse+
		[ IMAGE <aImage> ] 		;// Browse+
		[ JUSTIFY <aJust> ] 		;// Browse+
		[ <novscroll: NOVSCROLL> ] 	;                             
		[ HELPID <helpid> ] 		;
		[ <break: BREAK> ] 		;                             
		[ HEADERIMAGES <headerimages> ] ;
	=>;
_DefineBrowse ( <"name"> , 	;
		<"parent"> , 	;
		<col> ,		;
		<row> ,		;
		<w> , 		;
		<h> , 		;
		<headers> , 	;
		<widths> , 	;
		<Fields> , 	;
		<value> ,	;
		<fontname> , 	;
		<fontsize> , 	;
		<tooltip> , 	;
		<{change}> ,	;
		<{dblclick}> ,  ;
		<aHeadClick> ,  ;
		<{gotfocus}> ,	;
		<{lostfocus}>, 	;
		<"workarea"> ,	;
		<.Delete.>,  	;
		<.style.> ,	;
		<aImage> ,	;
		<aJust> , ;
		<helpid>  , ;
		<.bold.> , ;
		<.italic.> , ;
		<.underline.> , ;
		<.strikeout.> , ;
		<.break.>  , ;
		<backcolor> , ;
		<fontcolor> , ;
		<.lock.>  , ;
		<.inplace.> , ;
		<.novscroll.> , ;
		<.append.> , ;
		<aReadOnly> , ;
		<aValidFields> , ;
		<aValidMessages> , ;
		<.edit.> , <dynamicbackcolor> , <aWhenFields> , <dynamicforecolor> , <inputmask> , <format> , <inputitems> , <displayitems> , <headerimages> )

///////////////////////////////////////////////////////////////////////////////
// SPLITBOX BROWSE 
///////////////////////////////////////////////////////////////////////////////
#xcommand BROWSE <name> 		;
		[ OF <parent> ] 		;
		[ WIDTH <w> ] 			;
		[ HEIGHT <h> ] 			;
		[ HEADERS <headers> ] 		;
		[ WIDTHS <widths> ] 		;
		[ WORKAREA <WorkArea> ]		;
		[ FIELDS <Fields> ] 		;
		[ VALUE <value> ] 		;
		[ FONT <fontname> ] 		;
		[ SIZE <fontsize> ] 		;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ]  		;
		[ BACKCOLOR <backcolor> ] ;
		[ DYNAMICBACKCOLOR <dynamicbackcolor> ] ;
		[ DYNAMICFORECOLOR <dynamicforecolor> ] ;
		[ INPUTMASK <inputmask> ]	;
		[ INPUTITEMS <inputitems> ]	;
		[ DISPLAYITEMS <displayitems> ]	;
		[ FORMAT <format> ]	;
		[ FONTCOLOR <fontcolor> ] ;
		[ ON GOTFOCUS <gotfocus> ] 	;
		[ ON CHANGE <change> ]  	;
		[ ON LOSTFOCUS <lostfocus> ] 	;
		[ ON DBLCLICK <dblclick> ]  	;
		[ <edit : EDIT> ] 		;
		[ <inplace : INPLACE> ]		;
		[ <append : APPEND> ] 		;
		[ ON HEADCLICK <aHeadClick> ] 	;
		[ WHEN <aWhenFields> ]		;
		[ VALID <aValidFields> ]	;
		[ VALIDMESSAGES <aValidMessages> ] ;
		[ READONLY <aReadOnly> ] 	;
		[ <lock: LOCK> ] 		;
		[ <Delete: DELETE> ]		;
		[ <style: NOLINES> ] 		;// Browse+
		[ IMAGE <aImage> ] 		;// Browse+
		[ JUSTIFY <aJust> ] 		;// Browse+
		[ <novscroll: NOVSCROLL> ] 	;                             
		[ HELPID <helpid> ] 		;
		[ <break: BREAK> ] 		;                             
		[ HEADERIMAGES <headerimages> ] ;
	=>;
_DefineBrowse ( <"name"> , 	;
		<"parent"> , 	;
		 ,		;
		 ,		;
		<w> , 		;
		<h> , 		;
		<headers> , 	;
		<widths> , 	;
		<Fields> , 	;
		<value> ,	;
		<fontname> , 	;
		<fontsize> , 	;
		<tooltip> , 	;
		<{change}> ,	;
		<{dblclick}> ,  ;
		<{aHeadClick}> ,;
		<{gotfocus}> ,	;
		<{lostfocus}>, 	;
		<"WorkArea"> ,	;
		<.Delete.>,  	;
		<.style.> ,	;
		<aImage> ,	;
		<aJust> , ;
		<helpid>  , ;
		<.bold.> , ;
		<.italic.> , ;
		<.underline.> , ;
		<.strikeout.> , ;
		<.break.>  , ;
		<backcolor> , ;
		<fontcolor> , ;
		<.lock.> , ;
		<.inplace.> , ;
		<.novscroll.> , ;
		<.append.> , ;
		<aReadOnly> , ;
		 <{aValidFields}> , ;
		<aValidMessages> , ;
		<.edit.>  , <dynamicbackcolor> , <aWhenFields> , <dynamicforecolor> , <inputmask> , <format> , <inputitems> , <displayitems> , <headerimages> )

#xcommand SET BROWSESYNC ON => _HMG_SYSDATA \[ 254 \] := .T.
#xcommand SET BROWSESYNC OFF => _HMG_SYSDATA \[ 254 \] := .F.
