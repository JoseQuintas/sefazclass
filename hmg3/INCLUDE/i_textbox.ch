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

// TEXTBOX

#xcommand @ <row>, <col> TEXTBOX <name>               	;
			[ <dummy1: OF, PARENT> <parent> ] ;
                        [ HEIGHT <height> ]          	;
                        [ WIDTH <width> ]            	;
			[ FIELD <field> ]		;
                        [ VALUE <value> ]            	;
			[ < readonly: READONLY > ] 	;
                        [ FONT <fontname> ]          	;
                        [ SIZE <fontsize> ]          	;
			[ <bold : BOLD> ] ;
			[ <italic : ITALIC> ] ;
			[ <underline : UNDERLINE> ] ;
			[ <strikeout : STRIKEOUT> ] ;
                        [ TOOLTIP <tooltip> ]        	;
			[ BACKCOLOR <backcolor> ] ;
			[ FONTCOLOR <fontcolor> ] ;
			[ DISABLEDBACKCOLOR <disabledbackcolor> ] ;
			[ DISABLEDFONTCOLOR <disabledfontcolor> ] ;
                        [ MAXLENGTH <maxlength> ]    	;
                        [ <upper: UPPERCASE> ]       	;
                        [ <lower: LOWERCASE> ]       	;
                        [ <numeric: NUMERIC> ]       	;
                        [ <password: PASSWORD> ]     	;
                        [ ON CHANGE <change> ]       	;
                        [ ON GOTFOCUS <gotfocus> ]   	;
                        [ ON LOSTFOCUS <lostfocus> ] 	;
                        [ ON ENTER <enter> ]		;
                        [ <RightAlign: RIGHTALIGN> ]	;
			[ <invisible: INVISIBLE> ]	;
			[ <notabstop: NOTABSTOP> ]	;
                        [ HELPID <helpid> ] 		;
         =>;
         _DefineTextBox( <"name">, <"parent">, <col>, <row>, <width>, <height>, <value>, ;
				<fontname>, <fontsize>, <tooltip>, <maxlength>, ;
                        <.upper.>, <.lower.>, <.numeric.>, <.password.>, ;
				<{lostfocus}>, <{gotfocus}>, <{change}>, <{enter}>, ;
				<.RightAlign.>, <helpid>, <.readonly.> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.> , <"field"> , <backcolor> , <fontcolor> , <.invisible.> , <.notabstop.>  , <disabledbackcolor> , <disabledfontcolor> )


// TEXTBOX ( NUMERIC INPUTMASK )

#xcommand @ <row>,<col> TEXTBOX <name>		;
		[ <dummy1: OF, PARENT> <parent> ] ;
                [ HEIGHT <height> ]		;
		[ WIDTH <w> ]			;
		[ FIELD <field> ]		;
		[ VALUE <value> ]		;
		[ < readonly: READONLY > ] 	;
		[ FONT <fontname> ]		;
		[ SIZE <fontsize> ]		;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ]		;
		[ BACKCOLOR <backcolor> ] ;
		[ FONTCOLOR <fontcolor> ] ;
		[ DISABLEDBACKCOLOR <disabledbackcolor> ] ;
		[ DISABLEDFONTCOLOR <disabledfontcolor> ] ;
		NUMERIC				;
		INPUTMASK <inputmask>		;
                [ FORMAT <format> ]		;
                [ ON CHANGE <change> ]		;
		[ ON GOTFOCUS <gotfocus> ]	;
		[ ON LOSTFOCUS <lostfocus> ]	;
                [ ON ENTER <enter> ]		;
                [ <RightAlign: RIGHTALIGN> ]    ;
		[ <invisible: INVISIBLE> ]	;
		[ <notabstop: NOTABSTOP> ]	;
		[ HELPID <helpid> ] 		;
	=>;
	_DefineMaskedTextBox ( <"name">, <"parent">, <col>, <row>, <inputmask> , <w> , <value> , <fontname> , <fontsize> , <tooltip>   , <{lostfocus}>  , <{gotfocus}> , <{change}> , <height> , <{enter}> , <.RightAlign.>  , <helpid> , <format> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.>  , <"field">  , <backcolor> , <fontcolor> , <.readonly.> , <.invisible.> , <.notabstop.>  , <disabledbackcolor> , <disabledfontcolor> )

// TEXTBOX ( CHARACTER INPUTMASK )

#xcommand @ <row>,<col> TEXTBOX <name>		;
		[ <dummy1: OF, PARENT> <parent> ] ;
                [ HEIGHT <height> ]		;
		[ WIDTH <w> ]			;
		[ FIELD <field> ]		;
		[ VALUE <value> ]		;
		[ < readonly: READONLY > ] 	;
		[ FONT <fontname> ]		;
		[ SIZE <fontsize> ]		;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ]		;
		[ BACKCOLOR <backcolor> ] ;
		[ FONTCOLOR <fontcolor> ] ;
		[ DISABLEDBACKCOLOR <disabledbackcolor> ] ;
		[ DISABLEDFONTCOLOR <disabledfontcolor> ] ;
		INPUTMASK <inputmask>		;
                [ ON CHANGE <change> ]		;
		[ ON GOTFOCUS <gotfocus> ]	;
		[ ON LOSTFOCUS <lostfocus> ]	;
                [ ON ENTER <enter> ]		;
                [ <RightAlign: RIGHTALIGN> ]    ;
		[ <invisible: INVISIBLE> ]	;
		[ <notabstop: NOTABSTOP> ]	;
		[ HELPID <helpid> ] 		;
	=>;
	_DefineCharMaskTextBox ( <"name">, <"parent">, <col>, <row>, <inputmask> , <w> , <value> , <fontname> , <fontsize> , <tooltip>   , <{lostfocus}>  , <{gotfocus}> , <{change}> , <height> , <{enter}> , <.RightAlign.>  , <helpid> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.>  , <"field">  , <backcolor> , <fontcolor> , .f. , <.readonly.>  , <.invisible.> , <.notabstop.>  , <disabledbackcolor> , <disabledfontcolor> )

// TEXTBOX ( DATE TYPE )

#xcommand @ <row>,<col> TEXTBOX <name>		;
		[ <dummy1: OF, PARENT> <parent> ] ;
                [ HEIGHT <height> ]		;
		[ WIDTH <w> ]			;
		[ FIELD <field> ]		;
		[ VALUE <value> ]		;
		[ < readonly: READONLY > ] 	;
		[ FONT <fontname> ]		;
		[ SIZE <fontsize> ]		;
		[ <bold : BOLD> ] ;
		[ <italic : ITALIC> ] ;
		[ <underline : UNDERLINE> ] ;
		[ <strikeout : STRIKEOUT> ] ;
		[ TOOLTIP <tooltip> ]		;
		[ BACKCOLOR <backcolor> ] ;
		[ FONTCOLOR <fontcolor> ] ;
		[ DISABLEDBACKCOLOR <disabledbackcolor> ] ;
		[ DISABLEDFONTCOLOR <disabledfontcolor> ] ;
		< date : DATE > 		;
                [ ON CHANGE <change> ]		;
		[ ON GOTFOCUS <gotfocus> ]	;
		[ ON LOSTFOCUS <lostfocus> ]	;
                [ ON ENTER <enter> ]		;
                [ <RightAlign: RIGHTALIGN> ]    ;
		[ <invisible: INVISIBLE> ]	;
		[ <notabstop: NOTABSTOP> ]	;
		[ HELPID <helpid> ] 		;
	=>;
	_DefineCharMaskTextBox ( <"name">, <"parent">, <col>, <row>, "" , <w> , <value> , <fontname> , <fontsize> , <tooltip>   , <{lostfocus}>  , <{gotfocus}> , <{change}> , <height> , <{enter}> , <.RightAlign.>  , <helpid> ,<.bold.>, <.italic.>, <.underline.>, <.strikeout.>  , <"field">  , <backcolor> , <fontcolor> , <.date.> , <.readonly.>  , <.invisible.> , <.notabstop.>  , <disabledbackcolor> , <disabledfontcolor> )

