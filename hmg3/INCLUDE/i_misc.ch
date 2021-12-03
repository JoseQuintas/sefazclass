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

#define HKEY_CLASSES_ROOT     0x80000000
#define HKEY_CURRENT_USER     0x80000001
#define HKEY_LOCAL_MACHINE    0x80000002
#define HKEY_USERS            0x80000003
#define HKEY_CURRENT_CONFIG   0x80000005

#define HKEY_PERFORMANCE_DATA      0x80000004
#define HKEY_PERFORMANCE_TEXT      0x80000050
#define HKEY_PERFORMANCE_NLSTEXT   0x80000060
#define HKEY_DYN_DATA              0x80000006


#define SYNCHRONIZE             1048576   
#define STANDARD_RIGHTS_READ    131072     
#define STANDARD_RIGHTS_WRITE   131072     
#define STANDARD_RIGHTS_ALL     2031616    

#define KEY_QUERY_VALUE         1    
#define KEY_SET_VALUE           2    
#define KEY_CREATE_SUB_KEY      4    
#define KEY_ENUMERATE_SUB_KEYS  8    
#define KEY_NOTIFY              16   
#define KEY_CREATE_LINK         32   

#define KEY_READ        25 
#define KEY_WRITE        6 
#define KEY_EXECUTE     25 
#define KEY_ALL_ACCESS  63 

#define REG_SZ                          1      
#define REG_EXPAND_SZ                   2      
#define REG_BINARY                      3      
#define REG_DWORD                       4      


#define BIF_RETURNONLYFSDIRS (0x00000001)
#define BIF_DONTGOBELOWDOMAIN (0x00000002)
#define BIF_STATUSTEXT (0x00000004)
#define BIF_RETURNFSANCESTORS (0x00000008)
#define BIF_EDITBOX (0x00000010)
#define BIF_VALIDATE (0x00000020)
#define BIF_NEWDIALOGSTYLE (0x00000040)
#define BIF_BROWSEINCLUDEURLS (0x00000080)
#define BIF_USENEWUI (BIF_EDITBOX | BIF_NEWDIALOGSTYLE)
#define BIF_UAHINT (0x00000100)
#define BIF_NONEWFOLDERBUTTON (0x00000200)
#define BIF_NOTRANSLATETARGETS (0x00000400)
#define BIF_BROWSEFORCOMPUTER (0x00001000)
#define BIF_BROWSEFORPRINTER (0x00002000)
#define BIF_BROWSEINCLUDEFILES (0x00004000)
#define BIF_SHAREABLE (0x00008000)
#define BIF_BROWSEFILEJUNCTIONS (0x00010000)


#define CSIDL_DESKTOP                   0x0000        
#define CSIDL_INTERNET                  0x0001        
#define CSIDL_PROGRAMS                  0x0002        
#define CSIDL_CONTROLS                  0x0003        
#define CSIDL_PRINTERS                  0x0004        
#define CSIDL_PERSONAL                  0x0005        
#define CSIDL_FAVORITES                 0x0006        
#define CSIDL_STARTUP                   0x0007        
#define CSIDL_RECENT                    0x0008        
#define CSIDL_SENDTO                    0x0009        
#define CSIDL_BITBUCKET                 0x000a        
#define CSIDL_STARTMENU                 0x000b        
#define CSIDL_DESKTOPDIRECTORY          0x0010        
#define CSIDL_DRIVES                    0x0011        
#define CSIDL_NETWORK                   0x0012        
#define CSIDL_NETHOOD                   0x0013        
#define CSIDL_FONTS                     0x0014        
#define CSIDL_TEMPLATES                 0x0015
#define CSIDL_COMMON_STARTMENU          0x0016        
#define CSIDL_COMMON_PROGRAMS           0X0017        
#define CSIDL_COMMON_STARTUP            0x0018        
#define CSIDL_COMMON_DESKTOPDIRECTORY   0x0019        
#define CSIDL_APPDATA                   0x001a        
#define CSIDL_PRINTHOOD                 0x001b        
#define CSIDL_LOCAL_APPDATA             0x001c        
#define CSIDL_ALTSTARTUP                0x001d        
#define CSIDL_COMMON_ALTSTARTUP         0x001e        
#define CSIDL_COMMON_FAVORITES          0x001f
#define CSIDL_INTERNET_CACHE            0x0020
#define CSIDL_COOKIES                   0x0021
#define CSIDL_HISTORY                   0x0022
#define CSIDL_COMMON_APPDATA            0x0023        
#define CSIDL_WINDOWS                   0x0024        
#define CSIDL_SYSTEM                    0x0025        
#define CSIDL_PROGRAM_FILES             0x0026        
#define CSIDL_MYPICTURES                0x0027        
#define CSIDL_PROFILE                   0x0028        
#define CSIDL_SYSTEMX86                 0x0029        
#define CSIDL_PROGRAM_FILESX86          0x002a        
#define CSIDL_PROGRAM_FILES_COMMON      0x002b        
#define CSIDL_PROGRAM_FILES_COMMONX86   0x002c        
#define CSIDL_COMMON_TEMPLATES          0x002d        
#define CSIDL_COMMON_DOCUMENTS          0x002e        
#define CSIDL_COMMON_ADMINTOOLS         0x002f        
#define CSIDL_ADMINTOOLS                0x0030        
#define CSIDL_CONNECTIONS               0x0031        

#define CSIDL_FLAG_CREATE               0x8000        
#define CSIDL_FLAG_DONT_VERIFY          0x4000        
#define CSIDL_FLAG_MASK                 0xFF00        


// by Dr. Claudio Soto, April 2016

#xtranslate CHECK TYPE [ <lSoft: SOFT> ] <var> AS <type> [, <varN> AS <typeN> ] => ;
            HMG_CheckType( <.lSoft.>, { <"type"> , ValType( <var> ), <"var"> } [, { <"typeN"> , ValType( <varN> ), <"varN"> } ] )  
