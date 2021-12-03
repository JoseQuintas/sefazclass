/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

FUNCTION Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
    WIDTH 620 HEIGHT 540 ;
    TITLE "HMG Pseudo Calendar DatePicker Demo" ;
		MAIN ;
    FONT "Arial" SIZE 12

    // True calendar datepicker

    @  10, 10 DATEPICKER Date_1 WIDTH 270 ; 
              FONT "Arial" SIZE 12 ;
              TOOLTIP "DatePicker Control"

    // Pseudo calendar datepicker with calendar icon

    @ 230, 10 DATEPICKER Date_2 WIDTH 247 ;
              FONT "Arial" SIZE 12 ;
              UPDOWN
              TOOLTIP "DatePicker Control UpDown"

    @ 230,257 BUTTON Button_2 PICTURE "Calendar20" ;
              WIDTH 23 HEIGHT 23 ;
              ACTION (Form_1.Calendar_2.VISIBLE := ! Form_1.Calendar_2.VISIBLE ) ;
              TOOLTIP "Calendar Toggle"

    @ 260, 10 MONTHCALENDAR Calendar_2 WIDTH 270 HEIGHT 185 ;
              FONT "Arial" SIZE 12 ;
              NOTODAY INVISIBLE ;
              TITLEBACKCOLOR WHITE ;
              ON CHANGE (Form_1.Date_2.VALUE := Form_1.Calendar_2.VALUE, Form_1.Calendar_2.VISIBLE := .N.)

    // Pseudo calendar datepicker with down triangle

    @  10,310 DATEPICKER Date_3 WIDTH 247 ;
              FONT "Arial" SIZE 12 ;
              UPDOWN
              TOOLTIP "DatePicker Control UpDown"

    @  10,557 BUTTON Button_3 CAPTION HB_UTF8CHR(0x25BE) ;
              WIDTH 23 HEIGHT 23 ;
              ACTION (Form_1.Calendar_3.VISIBLE := ! Form_1.Calendar_3.VISIBLE ) ;
              TOOLTIP "Calendar Toggle"

    @  40,310 MONTHCALENDAR Calendar_3 WIDTH 270 HEIGHT 185 ;
              FONT "Arial" SIZE 12 ;
              NOTODAY INVISIBLE ;
              TITLEBACKCOLOR WHITE ;
              ON CHANGE (Form_1.Date_3.VALUE := Form_1.Calendar_3.VALUE, Form_1.Calendar_3.VISIBLE := .N.)

    // Pseudo calendar datepicker with calendar character and down triangle

    @ 230,310 DATEPICKER Date_4 WIDTH 230 ;
              FONT "Arial" SIZE 12 ;
              UPDOWN
              TOOLTIP "DatePicker Control UpDown"

    @ 230,540 BUTTON Button_4 CAPTION W(0x1F4C5) + W(0x25BE) ;
              FONT "Segoe UI Symbol" SIZE 12 ;
              WIDTH 40 HEIGHT 23 ;
              ACTION (Form_1.Calendar_4.VISIBLE := ! Form_1.Calendar_4.VISIBLE ) ;
              TOOLTIP "Calendar Toggle"

    @ 260,310 MONTHCALENDAR Calendar_4 WIDTH 270 HEIGHT 185 ;
              FONT "Arial" SIZE 12 ;
              NOTODAY INVISIBLE ;
              TITLEBACKCOLOR WHITE ;
              ON CHANGE (Form_1.Date_4.VALUE := Form_1.Calendar_4.VALUE, Form_1.Calendar_4.VISIBLE := .N.)

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

RETURN NIL

