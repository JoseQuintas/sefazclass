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

#xcommand @ <row>,<col> MONTHCALENDAR <name> ;
    [ <dummy1: OF, PARENT> <parent> ] ;
    [ VALUE <v> ] ;
    [ RANGEMIN <rangemin> ] ;
    [ RANGEMAX <rangemax> ] ;
    [ WIDTH <width> ] ;
    [ HEIGHT <height> ] ;
    [ FONT <fontname> ] ;
    [ SIZE <fontsize> ] ;
    [ <bold : BOLD> ] ;
    [ <italic : ITALIC> ] ;
    [ <underline : UNDERLINE> ] ;
    [ <strikeout : STRIKEOUT> ] ;
    [ FONTCOLOR <fontcolor> ] ;
    [ OUTERFONTCOLOR <outerfontcolor> ] ;
    [ BACKCOLOR <backcolor> ] ;
    [ BORDERCOLOR <bordercolor> ] ;
    [ TITLEFONTCOLOR <titlefontcolor> ] ;
    [ TITLEBACKCOLOR <titlebackcolor> ] ;
    [ VIEW <view> ] ;
    [ TOOLTIP <tooltip> ] ;
    [ < notoday: NOTODAY > ] ;
    [ < notodaycircle: NOTODAYCIRCLE > ] ;
    [ < weeknumbers: WEEKNUMBERS > ] ;
    [ < invisible: INVISIBLE > ] ;
    [ < notabstop: NOTABSTOP > ] ;
    [ ON CHANGE <change> ] ;
    [ ON GETBOLDDAYS <getbolddays> ] ;
    [ HELPID <helpid> ]     ;
  =>;
  _DefineMonthCal ( <"name"> , ;
                     <"parent"> , ;
                     <col> , ;
                     <row> , ;
                     <width> , ;
                     <height> , ;
                     <v> , ;
                     <fontname> , ;
                     <fontsize> , ;
                     <tooltip> , ;
                     <.notoday.> , ;
                     <.notodaycircle.> , ;
                     <.weeknumbers.> , ;
                     <{change}>  , ;
                     <helpid>, ;
                     <.invisible.>, ;
                     <.notabstop.> , ;
                     <.bold.>, <.italic.>, <.underline.>, <.strikeout.>, ;
                     <fontcolor>, ;
                     <outerfontcolor>, ;
                     <backcolor>, ;
                     <bordercolor>, ;
                     <titlefontcolor>,  ;
                     <titlebackcolor>, ;
                     <rangemin>, ;
                     <rangemax>, ;
                     <view>, ;
                     <{getbolddays}> )

#define MCM_FIRST               0x1000

#define MCM_GETCURSEL           (MCM_FIRST+1)
#define MCM_SETCURSEL           (MCM_FIRST+2)
#define MCM_GETMAXSELCOUNT      (MCM_FIRST+3)
#define MCM_SETMAXSELCOUNT      (MCM_FIRST+4)
#define MCM_GETSELRANGE         (MCM_FIRST+5)
#define MCM_SETSELRANGE         (MCM_FIRST+6)
#define MCM_GETMONTHRANGE       (MCM_FIRST+7)
#define MCM_SETDAYSTATE         (MCM_FIRST+8)
#define MCM_GETMINREQRECT       (MCM_FIRST+9)
#define MCM_SETCOLOR            (MCM_FIRST+10)
#define MCM_GETCOLOR            (MCM_FIRST+11)
#define MCM_SETFIRSTDAYOFWEEK   (MCM_FIRST+15)
#define MCM_GETFIRSTDAYOFWEEK   (MCM_FIRST+16)
#define MCM_GETRANGE            (MCM_FIRST+17)
#define MCM_SETRANGE            (MCM_FIRST+18)
#define MCM_GETMONTHDELTA       (MCM_FIRST+19)
#define MCM_SETMONTHDELTA       (MCM_FIRST+20)
#define MCM_GETMAXTODAYWIDTH    (MCM_FIRST+21)
#define MCM_GETCURRENTVIEW      (MCM_FIRST+22)
#define MCM_GETCALENDARCOUNT    (MCM_FIRST+23)
#define MCM_GETCALENDARGRIDINFO (MCM_FIRST+24)
#define MCM_GETCALID            (MCM_FIRST+27)
#define MCM_SETCALID            (MCM_FIRST+28)
#define MCM_SIZERECTTOMIN       (MCM_FIRST+29)
#define MCM_SETCALENDARBORDER   (MCM_FIRST+30)
#define MCM_GETCALENDARBORDER   (MCM_FIRST+31)
#define MCM_SETCURRENTVIEW      (MCM_FIRST+32)

#define MCN_FIRST               -746

#define MCN_VIEWCHANGE          (MCN_FIRST-4)
#define MCN_SELCHANGE           (MCN_FIRST-3)
#define MCN_SELECT              (MCN_FIRST)
//#define MCN_GETDAYSTATE         (MCN_FIRST+3)
#define MCN_GETDAYSTATE         (MCN_FIRST-1)

#define MCMV_MONTH         0
#define MCMV_YEAR          1
#define MCMV_DECADE        2
#define MCMV_CENTURY       3
#define MCMV_MAX           MCMV_CENTURY

// by Dr. Claudio Soto (April 2013)

#define MCSC_BACKGROUND    0
#define MCSC_TEXT          1
#define MCSC_TITLEBK       2
#define MCSC_TITLETEXT     3
#define MCSC_MONTHBK       4
#define MCSC_TRAILINGTEXT  5

