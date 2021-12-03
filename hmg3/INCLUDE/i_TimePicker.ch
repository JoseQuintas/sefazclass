/*----------------------------------------------------------------------------
 HMG Header File --> i_TimePicker.ch  

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay). 

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

----------------------------------------------------------------------------*/



#xcommand @ <row>,<col> TIMEPICKER <name> ;
         [ <dummy1: OF, PARENT> <parent> ] ;
         [ VALUE <v> ] ;
         [ FIELD <field> ] ;
         [ FORMAT <timeformat>] ;
         [ WIDTH <w> ] ;
         [ HEIGHT <h> ] ;
         [ FONT <fontname> ] ;
         [ SIZE <fontsize> ] ;
         [ <bold : BOLD> ] ;
         [ <italic : ITALIC> ] ;
         [ <underline : UNDERLINE> ] ;
         [ <strikeout : STRIKEOUT> ] ;
         [ TOOLTIP <tooltip> ] ;
         [ < shownone: SHOWNONE > ] ;
         [ ON GOTFOCUS <gotfocus> ] ;
         [ ON CHANGE <change> ] ;
         [ ON LOSTFOCUS <lostfocus> ] ;
         [ ON ENTER <enter> ] ;
         [ HELPID <helpid> ] ;
         [ <invisible: INVISIBLE> ] ;
         [ <notabstop: NOTABSTOP> ] ;
   => ;
   _DefineTimePick ( <"name"> , ;
                     <"parent"> , ;
                     <col> , ;
                     <row> , ;
                     <w> , ;
                     <h> , ;
                     <v> , ;
                     <fontname> , ;
                     <fontsize> , ;
                     <tooltip> , ;
                     <{change}> , ;
                     <{lostfocus}> , ;
                     <{gotfocus}> , ;
                     <.shownone.> , ;
                      <helpid> , ; 
                      <.invisible.> , ; 
                      <.notabstop.> , ;
                      <.bold.>, <.italic.>, <.underline.>, <.strikeout.> , ;
                      <"field">, <{enter}>, <timeformat> )


#xtranslate   _TIMELONG24H    => "HH:mm:ss"
#xtranslate   _TIMESHORT24H   => "HH:mm"
#xtranslate   _TIMELONG12H    => "hh:mm:ss tt"
#xtranslate   _TIMESHORT12H   => "hh:mm tt"

