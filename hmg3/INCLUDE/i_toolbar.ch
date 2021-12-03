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

******************************************************************************
* Original ToolBar 
******************************************************************************

#xcommand  DEFINE TOOLBAR <controlname> ;
		[ OF <parentwindowname> ] ;
      [ BUTTONSIZE <buttonwidth> , <buttonheight> ] ;
      [ IMAGESIZE <imagewidth> , <imageheight> ] ;
		[ <strictwidth : STRICTWIDTH> ] ;		
		[ FONT <fontname> ] ;			
		[ SIZE <fontsize> ] ;			
		[ <bold : BOLD> ] ;		
		[ <italic : ITALIC> ] ;		
		[ <underline : UNDERLINE> ] ;	
		[ <strikeout : STRIKEOUT> ] ;	
		[ TOOLTIP <tooltip> ] ;		
		[ <flat: FLAT> ] ;
		[ <bottom: BOTTOM> ] ;
		[ <righttext: RIGHTTEXT> ] ;
		[ <dummy1: GRIPPERTEXT, CAPTION> <grippertext> ] ;
		[ <border : BORDER> ] ;		
	        [ <break: BREAK> ] ;                           
      => ;
	_DefineToolBar ( <"controlname">	, ;
		<"parentwindowname">		, ;
		<buttonwidth>			, ;
		<buttonheight>			, ;
		<.flat.>			, ;
		<.bottom.>			, ;
		<.righttext.>			, ;
		<.border.>			, ;
		<fontname>			, ;
		<fontsize>			, ;
		<.bold.>			, ;
		<.italic.>			, ;
		<.underline.>			, ;
		<.strikeout.>			, ;
		<tooltip>			, ;
		<grippertext>			, ;
		<.break.>			, ;
		<imagewidth> 			, ;
		<imageheight>			, ;
		<.strictwidth.>                   ;
		)  

******************************************************************************
* Propertized ToolBar
******************************************************************************

#xcommand  DEFINE TOOLBAR <controlname> ;
		[ PARENT <parentwindowname> ] ;
      [ BUTTONWIDTH <buttonwidth> ] [ BUTTONHEIGHT <buttonheight> ] ;
      [ IMAGEWIDTH <imagewidth> ] [ IMAGEHEIGHT <imageheight> ] ;
		[ STRICTWIDTH <strictwidth> ] ;		
		[ FONTNAME <fontname> ] ;			
		[ FONTSIZE <fontsize> ] ;			
		[ FONTBOLD <bold> ] ;		
		[ FONTITALIC <italic> ] ;		
		[ FONTUNDERLINE <underline> ] ;	
		[ FONTSTRIKEOUT <strikeout> ] ;	
		[ TOOLTIP <tooltip> ] ;		
		[ FLAT <flat> ] ;
		[ BOTTOM <bottom> ] ;
		[ RIGHTTEXT <righttext> ] ;
		[ GRIPPERTEXT <grippertext> ] ;
		[ BORDER <border> ] ;		
	   [ BREAK <break> ] ;                           
      => ;
	_DefineToolBar ( <"controlname">	, ;
		<"parentwindowname">		, ;
		<buttonwidth>			, ;
		<buttonheight>			, ;
		<.flat.>			, ;
		<.bottom.>			, ;
		<.righttext.>			, ;
		<.border.>			, ;
		<fontname>			, ;
		<fontsize>			, ;
		<.bold.>			, ;
		<.italic.>			, ;
		<.underline.>			, ;
		<.strikeout.>			, ;
		<tooltip>			, ;
		<grippertext>			, ;
		<.break.>			, ;
		<imagewidth> 			, ;
		<imageheight>			, ;
		<.strictwidth.>                   ;
		)  


******************************************************************************
* Original ToolBar Button
******************************************************************************

#xcommand BUTTON <controlname> ;
		[ CAPTION <caption> ] ;
		[ PICTURE <picture> ] ;
		[ ACTION <action> ] ;
		[ TOOLTIP <tooltip> ] ;
		[ <separator: SEPARATOR> ] ;
	   [ <autosize: AUTOSIZE> ] ;             
		[ <dropdown: DROPDOWN> ] ;
		[ <wholedropdown: WHOLEDROPDOWN> ] ;
		[ <check: CHECK> ] ;
		[ <group: GROUP> ] ;
      [ <notrans: NOTRANSPARENT>];
	=>;
	_DefineToolButton ( <"controlname"> , ;
		<picture> , ;
		<caption> , ;
		<{action}> , ;
		<.separator.> , ;
		<.autosize.> , ;
		<.check.> , ;
		<.group.> , ;
		<.dropdown.> , ;
		<.wholedropdown.> , ;
		<tooltip>, ;
      <.notrans.> ) 


******************************************************************************
* Propertized ToolBar Button: 
******************************************************************************


#xcommand TOOLBUTTON <controlname> ;
		[ CAPTION <caption> ] ;
		[ PICTURE <picture> ] ;
		[ ONCLICK <action> ] ;
		[ TOOLTIP <tooltip> ] ;
		[ SEPARATOR <separator> ] ;
	   [ AUTOSIZE <autosize> ] ;             
		[ DROPDOWN <dropdown> ] ;
		[ WHOLEDROPDOWN <wholedropdown> ] ;
		[ CHECK <check> ] ;
		[ GROUP <group> ] ;
      [ NOTRANSPARENT <notrans>];
	=>;
	_DefineToolButton ( <"controlname"> , ;
		<picture> , ;
		<caption> , ;
		<{action}> , ;
		<.separator.> , ;
		<.autosize.> , ;
		<.check.> , ;
		<.group.> , ;
		<.dropdown.> , ;
		<.wholedropdown.> , ;
		<tooltip> , ;
      <.notrans.> ) 


#xcommand  END TOOLBAR => _EndToolbar()

