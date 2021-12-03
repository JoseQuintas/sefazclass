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
#xcommand @ <row>,<col>  ANIMATEBOX <name> ;
			[ <dummy1: OF, PARENT> <parent> ] ;
			WIDTH <w> ;
			HEIGHT <h> ;
			[ FILE <file> ] ;
			[ <autoplay: AUTOPLAY> ] ;
			[ <center : CENTER> ] ;
			[ <transparent: TRANSPARENT> ] ;
			[ HELPID <helpid> ] 		;
	=>;
    _DefineAnimateBox( <"name">,<"parent">,<col>, <row>, <w>, <h>, <.autoplay.>, <.center.>, <.transparent.>,<file> , <helpid> )

#xcommand OPEN ANIMATEBOX <ControlName> OF <ParentForm> FILE <FileName> ;
=> ;
_OpenAnimateBox ( <"ControlName"> , <"ParentForm"> , <FileName> )

#xcommand PLAY ANIMATEBOX <ControlName> OF <ParentForm> ;
=> ;
_PlayAnimateBox ( <"ControlName"> , <"ParentForm"> )

#xcommand SEEK ANIMATEBOX <ControlName> OF <ParentForm> POSITION <frame> ;
=> ;
_SeekAnimateBox ( <"ControlName"> , <"ParentForm"> , <frame> )

#xcommand STOP ANIMATEBOX <ControlName> OF <ParentForm> ;
=> ;
_StopAnimateBox ( <"ControlName"> , <"ParentForm"> )

#xcommand CLOSE ANIMATEBOX <ControlName> OF <ParentForm> ;
=> ;
_CloseAnimateBox ( <"ControlName"> , <"ParentForm"> )

#xcommand DESTROY ANIMATEBOX <ControlName> OF <ParentForm> ;
=> ;
_DestroyAnimateBox ( <"ControlName"> , <"ParentForm"> )

#xtranslate  OpenAnimateBox ( <ControlName> , <ParentForm> , <FileName> );
=> ;
_OpenAnimateBox ( <"ControlName"> , <"ParentForm"> , <FileName> )

#xtranslate  PlayAnimateBox ( <ControlName> , <ParentForm> );
=> ;
_PlayAnimateBox ( <"ControlName"> , <"ParentForm"> )

#xtranslate  SeekAnimateBox ( <ControlName> , <ParentForm> , <frame> );
=> ;
_SeekAnimateBox ( <"ControlName"> , <"ParentForm"> , <frame> )

#xtranslate StopAnimateBox ( <ControlName> , <ParentForm> );
=> ;
_StopAnimateBox ( <"ControlName"> , <"ParentForm"> )

#xtranslate CloseAnimateBox ( <ControlName> , <ParentForm> ) ;
=> ;
_CloseAnimateBox ( <"ControlName"> , <"ParentForm"> )

#xtranslate DestroyAnimateBox ( <ControlName> , <ParentForm> );
=> ;
_DestroyAnimateBox ( <"ControlName"> , <"ParentForm"> )
 
#xcommand @ <row>,<col>  PLAYER <name> ;
			[ <dummy1: OF, PARENT> <parent> ] ;
			WIDTH <w> ;
			HEIGHT <h> ;
                        FILE <file> ;
			[ <noautosizewindow: NOAUTOSIZEWINDOW> ] ;
			[ <noautosizemovie : NOAUTOSIZEMOVIE> ] ;
			[ <noerrordlg: NOERRORDLG> ] ;
			[ <nomenu: NOMENU> ] ;
			[ <noopen: NOOPEN> ] ;                             
			[ <noplaybar: NOPLAYBAR> ] ;                             
			[ <showall: SHOWALL> ] ;                             
			[ <showmode: SHOWMODE> ] ;                             
			[ <showname: SHOWNAME> ] ;                             
			[ <showposition: SHOWPOSITION> ] ;                             
			[ HELPID <helpid> ] 		;
	=>;
    _DefinePlayer( <"name">,<"parent">,<file>,<col>, <row>, <w>, <h>, <.noautosizewindow.>, <.noautosizemovie.>, <.noerrordlg.>,<.nomenu.>,<.noopen.>,<.noplaybar.>,<.showall.>,<.showmode.>,<.showname.>,<.showposition.> , <helpid> )

#xcommand PLAY PLAYER <name> OF <parent> ;
	=> ;
	_PlayPlayer ( <"name"> , <"parent"> )

#xcommand PLAY PLAYER <name> OF <parent> REVERSE ;
	=> ;
	_PlayPlayerReverse ( <"name"> , <"parent"> )	

#xcommand STOP PLAYER <name> OF <parent> ;
	=> ;
	_StopPlayer ( <"name"> , <"parent"> )	

#xcommand PAUSE PLAYER <name> OF <parent> ;
	=> ;
	_PausePlayer ( <"name"> , <"parent"> )	

#xcommand CLOSE PLAYER <name> OF <parent> ;
	=> ;
	_ClosePlayer ( <"name"> , <"parent"> )	

#xcommand DESTROY PLAYER <name> OF <parent> ;
	=> ;
	_DestroyPlayer ( <"name"> , <"parent"> )	

#xcommand EJECT PLAYER <name> OF <parent> ;
	=> ;
	_EjectPlayer ( <"name"> , <"parent"> )	

#xcommand OPEN PLAYER <name> OF <parent> FILE <file> ;
	=> ;
	_OpenPlayer ( <"name"> , <"parent"> , <file> )	

#xcommand OPEN PLAYER <name> OF <parent> DIALOG ;
	=> ;
	_OpenPlayerDialog ( <"name"> , <"parent"> )	

#xcommand RESUME PLAYER <name> OF <parent> ;
	=> ;
	_ResumePlayer ( <"name"> , <"parent"> )	

#xcommand SET PLAYER <name> OF <parent> POSITION HOME ;
	=> ;
	_SetPlayerPositionHome ( <"name"> , <"parent"> )	

#xcommand SET PLAYER <name> OF <parent> POSITION END ;
	=> ;
	_SetPlayerPositionEnd ( <"name"> , <"parent"> )	

#xcommand SET PLAYER <name> OF <parent> REPEAT ON ;
	=> ;
	_SetPlayerRepeatOn ( <"name"> , <"parent"> )	

#xcommand SET PLAYER <name> OF <parent> REPEAT OFF ;
	=> ;
	_SetPlayerRepeatOff ( <"name"> , <"parent"> )	

#xcommand SET PLAYER <name> OF <parent> SPEED <speed> ;
	=> ;
	_SetPlayerSpeed ( <"name"> , <"parent"> , <speed> )	

#xcommand SET PLAYER <name> OF <parent> VOLUME <volume> ;
	=> ;
	_SetPlayerVolume ( <"name"> , <"parent"> , <volume> )	

#xcommand SET PLAYER <name> OF <parent> ZOOM <zoom> ;
	=> ;
	_SetPlayerZoom ( <"name"> , <"parent"> , <zoom> )	

#xcommand PLAY WAVE  <wave>  [<r:  FROM RESOURCE>] ;
                            [<s:  SYNC>];
                            [<ns: NOSTOP>] ;
                            [<l:  LOOP>] ;
                            [<nd: NODEFAULT>] ;
	=> playwave(<wave>,<.r.>,<.s.>,<.ns.>,<.l.>,<.nd.>)

#xcommand STOP WAVE  => stopwave()
#xcommand STOP WAVE NODEFAULT => stopwave()
