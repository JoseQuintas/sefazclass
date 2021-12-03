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

#xcommand ENABLE MENUITEM <control> OF <form>;
	=>;
	_EnableMenuItem ( <"control"> , <"form"> )

#xcommand DISABLE MENUITEM <control> OF <form>;
	=>;
	_DisableMenuItem ( <"control"> , <"form"> )

#xcommand CHECK MENUITEM <control> OF <form>;
	=>;
	_CheckMenuItem ( <"control"> , <"form"> )

#xcommand UNCHECK MENUITEM <control> OF <form>;
	=>;
	_UnCheckMenuItem ( <"control"> , <"form"> )

#xcommand DEFINE MAIN MENU [ OF <parent> ] ;
=>;
_DefineMainMenu( <"parent"> )

#xcommand DEFINE MAINMENU [ OF <parent> ] ;
=>;
_DefineMainMenu( <"parent"> )

#xcommand DEFINE MAINMENU [ PARENT <parent> ] ;
=>;
_DefineMainMenu( <"parent"> )


#xcommand DEFINE CONTEXT MENU [ OF <parent> ] ;
=>;
_DefineContextMenu( <"parent"> )

#xcommand DEFINE CONTEXTMENU [ OF <parent> ] ;
=>;
_DefineContextMenu( <"parent"> )



#xcommand DEFINE CONTEXTMENU [ PARENT <parent> ] ;
=>;
_DefineContextMenu( <"parent"> )





#xcommand DEFINE NOTIFY MENU [ OF <parent> ] ;
=>;
_DefineNotifyMenu( <"parent"> )

#xcommand DEFINE NOTIFYMENU [ OF <parent> ] ;
=>;
_DefineNotifyMenu( <"parent"> )

#xcommand DEFINE NOTIFYMENU [ PARENT <parent> ] ;
=>;
_DefineNotifyMenu( <"parent"> )



#xcommand DEFINE MAINMENU [ OF <parent> ] ;
=>;
_DefineMainMenu( <"parent"> )

#xcommand POPUP <caption> [ NAME <name> ];
=> ;
_DefineMenuPopup( <caption> , <"name"> )

#xcommand DEFINE POPUP <caption> [ NAME <name> ];
=> ;
_DefineMenuPopup( <caption> , <"name">  )

#xcommand DEFINE MENU POPUP <caption> [ NAME <name> ];
=> ;
_DefineMenuPopup( <caption> , <"name">  )

#xcommand ITEM <caption> [ ACTION <action> ] [ NAME <name> ] [ IMAGE <image> ] [ <checked : CHECKED> ] [ <NoTrans : NOTRANSPARENT> ] [ TOOLTIP <tooltip> ];
=> ;
_DefineMenuItem ( <caption> , <{action}> , <"name"> , <image> , <.checked.> , <.NoTrans.> , <tooltip> )

#xcommand MENUITEM <caption> [ ACTION <action> ] [ NAME <name> ] [ IMAGE <image> ] [ <checked : CHECKED> ] [ <NoTrans : NOTRANSPARENT> ] [ TOOLTIP <tooltip> ];
=> ;
_DefineMenuItem ( <caption> , <{action}> , <"name"> , <image> , <.checked.> , <.NoTrans.> , <tooltip> )

#xcommand MENUITEM <caption> [ ONCLICK <action> ] [ NAME <name> ] [ IMAGE <image> ] [ CHECKED <checked> ] [ TRANSPARENT  <transparent> ] [ TOOLTIP <tooltip> ];
=> ;
_DefineMenuItem ( <caption> , <{action}> , <"name"> , <image> , <.checked.> , <.transparent.> , <tooltip> )

#xcommand SEPARATOR ;
=> ;
_DefineSeparator ()

#xcommand END POPUP ;
=> ;
_EndMenuPopup()

#xcommand END MENU ;
=> ;
_EndMenu()

#xcommand DEFINE DROPDOWN MENU BUTTON <button> [ OF <parent> ] ;
=>;
_DefineDropDownMenu( <"button"> , <"parent"> )

#xcommand DEFINE DROPDOWNMENU OWNERBUTTON <button> [ PARENT <parent> ] ;
=>;
_DefineDropDownMenu( <"button"> , <"parent"> )



// by Dr. Claudio Soto (March 2013)

#xcommand RELEASE MAIN MENU     OF <parent>   =>   ReleaseMainMenu    ( <"parent"> )
#xcommand RELEASE MAINMENU      OF <parent>   =>   ReleaseMainMenu    ( <"parent"> )

#xcommand RELEASE CONTEXT MENU  OF <parent>   =>   ReleaseContextMenu ( <"parent"> )
#xcommand RELEASE CONTEXTMENU   OF <parent>   =>   ReleaseContextMenu ( <"parent"> )

#xcommand RELEASE NOTIFY MENU   OF <parent>   =>   ReleaseNotifyMenu ( <"parent"> )
#xcommand RELEASE NOTIFYMENU    OF <parent>   =>   ReleaseNotifyMenu ( <"parent"> )

#xcommand RELEASE DROPDOWN MENU BUTTON      <button> OF <parent>   =>   ReleaseDropDownMenu ( <"button"> ,  <"parent"> )
#xcommand RELEASE DROPDOWNMENU  OWNERBUTTON <button> OF <parent>   =>   ReleaseDropDownMenu ( <"button"> ,  <"parent"> )



// by Dr. Claudio Soto (May 2013)

#xcommand DEFINE CONTROL CONTEXT MENU <cControlName> [ OF <cParentName> ]     => _DefineControlContextMenu ( <"cControlName"> , <"cParentName"> )
#xcommand DEFINE CONTROL CONTEXT MENU <cControlName> [ PARENT <cParentName> ] => _DefineControlContextMenu ( <"cControlName"> , <"cParentName"> )
#xcommand DEFINE CONTROL CONTEXTMENU  <cControlName> [ OF <cParentName> ]     => _DefineControlContextMenu ( <"cControlName"> , <"cParentName"> )
#xcommand DEFINE CONTROL CONTEXTMENU  <cControlName> [ PARENT <cParentName> ] => _DefineControlContextMenu ( <"cControlName"> , <"cParentName"> )

#xcommand RELEASE CONTROL CONTEXT MENU <cControlName>   OF <cParentName>      => ReleaseControlContextMenu ( <"cControlName"> , <"cParentName"> )
#xcommand RELEASE CONTROL CONTEXT MENU  <cControlName>  PARENT <cParentName>  => ReleaseControlContextMenu ( <"cControlName"> , <"cParentName"> )
#xcommand RELEASE CONTROL CONTEXTMENU <cControlName>    OF <cParentName>      => ReleaseControlContextMenu ( <"cControlName"> , <"cParentName"> )
#xcommand RELEASE CONTROL CONTEXTMENU  <cControlName>   PARENT <cParentName>  => ReleaseControlContextMenu ( <"cControlName"> , <"cParentName"> )


#define WM_MENURBUTTONUP 290
#define WM_MENUCOMMAND 0x0126
#define WM_MENUGETOBJECT 0x0124
#define WM_MENUDRAG 0x0123
//#define WM_MENUCHAR 288
#define WM_MENUSELECT 287
#define WM_NEXTMENU 531
