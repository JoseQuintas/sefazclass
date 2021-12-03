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

#xcommand DEFINE STATUSBAR ;
	[ <dummy1: OF, PARENT> <parent> ] ;
	[ FONT <fontname> ]          ;
	[ SIZE <fontsize> ]          ;
	[ <bold : BOLD> ] ;
	[ <italic : ITALIC> ] ;
	[ <underline : UNDERLINE> ] ;
	[ <strikeout : STRIKEOUT> ] ;
	[ <top : TOP> ] ;
      => ;
	_StartStatusBar	(	;
			<"parent">	, ;
			<fontname>	, ;
			<fontsize>	, ;
			<.bold.>	, ;
			<.italic.>	, ;
			<.underline.>	, ;
			<.strikeout.>	, ;
			<.top.>		;
				)


#xcommand STATUSITEM [ <caption> ] ;
	[ WIDTH <width> ] ;
	[ ACTION <uAction> ] ;
	[ ICON <image> ] ;
	[STYLE] [ <style:FLAT,RAISED> ] ;
	[ TOOLTIP <tooltip> ] ;
       => ;
        _DefineStatusBarItem	(		;
				<caption>	, ;
				<width>		, ;
				<image>		, ;
				<"style">	, ;
				<tooltip>	, ;
				<{uAction}>	;
				)

#xcommand  END STATUSBAR ;
      => ;
_EndStatusBar (	_HMG_SYSDATA \[ 212 \]		, ;
			_HMG_SYSDATA \[ 143 \]		, ;
			_HMG_SYSDATA \[ 144 \]		, ;
			_HMG_SYSDATA \[ 145 \]		, ;
			_HMG_SYSDATA \[ 148 \]		, ;
			_HMG_SYSDATA \[ 147 \]		, ;
			_HMG_SYSDATA \[ 146 \]		, ;
			_HMG_SYSDATA \[ 213 \]		, ;
			_HMG_SYSDATA \[ 165 \]		, ;
			_HMG_SYSDATA \[ 272 \]		, ;
			_HMG_SYSDATA \[ 273 \]		, ;
			_HMG_SYSDATA \[ 274 \]	, ;
			_HMG_SYSDATA \[ 275 \]	, ;
			_HMG_SYSDATA \[ 276 \]		;
			)

#xcommand DATE ;
	[ <w: WIDTH > <nSize> ] ;
	[ ACTION <uAction> ] ;
	[ TOOLTIP <cToolTip> ] ;
       => ;
        _DefineStatusBarItem	(		;
				Dtoc(Date())	, ;
				if ( <.w.> == .f. , if ( lower ( left ( set ( _SET_DATEFORMAT ) , 4 ) ) == "yyyy" .or. lower ( right ( set ( _SET_DATEFORMAT ) , 4 ) ) == "yyyy", 90 , 70 ) , <nSize> ) 		, ;
						, ;
						, ;
				<cToolTip>	, ;
				<{uAction}>	;
				)


#xcommand CLOCK ;
             [ WIDTH <nSize> ] ;
             [ ACTION <uAction> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ INTERVAL <nIntervalUpdate> ] ;
       => ;
        _SetStatusClock( _HMG_SYSDATA \[ 223 \] , <nSize> , <cToolTip> , <{uAction}> , <nIntervalUpdate> )

#xcommand KEYBOARD ;
             [ WIDTH <nSize> ] ;
             [ ACTION <uAction> ] ;
             [ TOOLTIP <cToolTip> ] ;
             [ INTERVAL <nIntervalUpdate> ] ;
       => ;
        _SetStatusKeybrd( _HMG_SYSDATA \[ 223 \] , <nSize> , <cToolTip> , <{uAction}> , <nIntervalUpdate> )




#xcommand DEFINE STATUSBAR ;
	[ PARENT> <parent> ] ;
	[ FONTNAME <fontname> ]          ;
	[ FONTSIZE <fontsize> ]          ;
	[ FONTBOLD <bold> ] ;
	[ FONTITALIC <italic> ] ;
	[ FONTUNDERLINE <underline> ] ;
	[ FONTSTRIKEOUT <strikeout> ] ;
	[ TOP <top> ] ;
      => ;
	_StartStatusBar	(	;
			<"parent">	, ;
			<fontname>	, ;
			<fontsize>	, ;
			<.bold.>	, ;
			<.italic.>	, ;
			<.underline.>	, ;
			<.strikeout.>	, ;
			<.top.>		;
				)



