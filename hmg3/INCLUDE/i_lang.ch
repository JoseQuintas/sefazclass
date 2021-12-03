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

#xtranslate SET LANGUAGE TO SPANISH     =>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_ES		; HB_LANGSELECT( "ES" )		; InitMessages("ES")
#xtranslate SET LANGUAGE TO ENGLISH     =>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_EN		; HB_LANGSELECT( "EN" )		; InitMessages("EN")
#xtranslate SET LANGUAGE TO FRENCH		=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_FR		; HB_LANGSELECT( "FR" )		; InitMessages("FR")
#xtranslate SET LANGUAGE TO PORTUGUESE  =>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_PT     ; HB_LANGSELECT( "PT" )    ; InitMessages("PT")
#xtranslate SET LANGUAGE TO GERMAN		=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_DEWIN	; HB_LANGSELECT( "DEWIN" )	; InitMessages("DE")
#xtranslate SET LANGUAGE TO RUSSIAN		=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_RUWIN	; HB_LANGSELECT( "RUWIN" )	; InitMessages("RU")
#xtranslate SET LANGUAGE TO ITALIAN		=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_IT		; HB_LANGSELECT( "IT" )		; InitMessages("IT")
#xtranslate SET LANGUAGE TO POLISH		=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_PLWIN	; HB_LANGSELECT( "PLWIN" )	; InitMessages("PL")
#xtranslate SET LANGUAGE TO BASQUE		=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_EU		; HB_LANGSELECT( "EU" )		; InitMessages("EU")
#xtranslate SET LANGUAGE TO CROATIAN		=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_HR852	; HB_LANGSELECT( "HR852" )	; InitMessages("HR")
#xtranslate SET LANGUAGE TO SLOVENIAN	=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_SLWIN	; HB_LANGSELECT( "SLWIN" )	; InitMessages("SL")
#xtranslate SET LANGUAGE TO CZECH 		=>  _HMG_SYSDATA \[ 211 \] := '  ' ; REQUEST HB_LANG_CSWIN	; HB_LANGSELECT( "CSWIN" )	; InitMessages("CS")

// Languages Not Supported by hb_LangSelect()
#xtranslate SET LANGUAGE TO FINNISH		=>  _HMG_SYSDATA \[ 211 \] := '  ' ;								; InitMessages("FI")
#xtranslate SET LANGUAGE TO DUTCH       =>  _HMG_SYSDATA \[ 211 \] := '  ' ;								; InitMessages("NL")


#xtranslate SET CODEPAGE TO ENGLISH		=>  hb_setcodepage("EN")
#xtranslate SET CODEPAGE TO SPANISH		=>  REQUEST HB_CODEPAGE_ESWIN ; hb_setcodepage("ESWIN")
#xtranslate SET CODEPAGE TO BULGARIAN		=>  REQUEST HB_CODEPAGE_BGWIN ; hb_setcodepage("BGWIN")
#xtranslate SET CODEPAGE TO GERMAN		=>  REQUEST HB_CODEPAGE_DEWIN ; hb_setcodepage("DEWIN")
#xtranslate SET CODEPAGE TO GREEK		=>  REQUEST HB_CODEPAGE_ELWIN ; hb_setcodepage("ELWIN")
#xtranslate SET CODEPAGE TO HUNGARIAN		=>  REQUEST HB_CODEPAGE_HUWIN ; hb_setcodepage("HUWIN")
#xtranslate SET CODEPAGE TO POLISH		=>  REQUEST HB_CODEPAGE_PLWIN ; hb_setcodepage("PLWIN")
#xtranslate SET CODEPAGE TO PORTUGUESE		=>  REQUEST HB_CODEPAGE_PT850 ; hb_setcodepage("PT850")
#xtranslate SET CODEPAGE TO RUSSIAN		=>  REQUEST HB_CODEPAGE_RU1251 ; hb_setcodepage("RU1251")
#xtranslate SET CODEPAGE TO SERBIAN		=>  REQUEST HB_CODEPAGE_SRWIN ; hb_setcodepage("SRWIN")
#xtranslate SET CODEPAGE TO SLOVENIAN		=>  REQUEST HB_CODEPAGE_SLWIN ; hb_setcodepage("SLWIN")

#xtranslate SET CODEPAGE TO UNICODE              =>  SET (_SET_CODEPAGE, "UTF8")

// #xtranslate SET CODEPAGE TO UNICODE              =>  REQUEST HB_CODEPAGE_UTF8 ; hb_setcodepage("UTF8")
