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


#ifndef _HMG_VERSION_NUMBER_
   #define _HMG_VERSION_NUMBER_         "HMG 3.4.4"
   #define _HMG_VERSION_WIN32_STABLE_   "Stable"   // "Stable", "Test" or ""
   #define _HMG_VERSION_WIN64_STABLE_   "Stable"   // "Stable", "Test" or ""
   #define _HMG_VERSION_PATCH_          ""         // if "" --> not exist patch in this version
#endif



#ifndef _HMG_OFFICIAL_
   #define _HMG_OFFICIAL_
#endif

#ifndef _INCLUDE_HMG_CH_
   #define _INCLUDE_HMG_CH_
#endif

REQUEST ERRORSYS

#include "i_UsrInit.ch"
#include "i_UsrSOOP.ch"

#include "i_Thread.ch"
#include "i_Class.ch"
#include "i_UNICODE.ch"
#include "BosTaurus.ch"
#include "i_TimePicker.ch"
#include "i_MsgBox.ch"
#include "i_Dialogs.ch"

#include "i_window.ch"
#include "i_this.ch"
#include "i_var.ch"
#include "i_media.ch"
#include "i_pseudofunc.ch"
#include "i_exec.ch"
#include "i_comm.ch"
#include "i_keybd.ch"
#include "i_checkbox.ch"
#include "i_menu.ch"
#include "i_misc.ch"
#include "i_timer.ch"
#include "i_frame.ch"
#include "i_slider.ch"
#include "i_progressbar.ch"
#include "i_button.ch"
#include "i_image.ch"
#include "i_radiogroup.ch"
#include "i_activex.ch"
#include "i_label.ch"
#include "i_combobox.ch"
#include "i_datepicker.ch"
#include "i_listbox.ch"
#include "i_spinner.ch"
#include "i_textbox.ch"
#include "i_editbox.ch"
#include "i_grid.ch"
#include "i_tab.ch"
#include "i_controlmisc.ch"
#include "i_color.ch"
#include "i_toolbar.ch"
#include "i_splitbox.ch"
#include "i_tree.ch"
#include "i_status.ch"
#include "i_ini.ch"
#include "i_Help.ch"
#include "i_monthcal.ch"
#include "i_region.ch"
#include "i_socket.ch"
#include "i_ipaddress.ch"
#include "i_altsyntax.ch"
#include "i_edit.ch"
#include "i_report.ch"
#include "i_lang.ch"
#include "i_hyperlink.ch"
#include "i_zip.ch"
#include "i_graph.ch"
#include "i_richeditbox.ch"
#include "i_browse.ch"
#include "i_dll.ch"
#include "i_print.ch"
#include "i_rptgen.ch"

#include "HMG_HPDF.ch"
#include "hbzebra.ch"
