/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 640 HEIGHT 480 ;
      TITLE "Month Calendar Control Demo" ;
      ICON "DEMO.ICO" ;
      MAIN ;
      FONT "Arial" SIZE 9

      // month calendar 1

      @ 10,10 MONTHCALENDAR Month_1 ;
         VALUE date() ;
         TOOLTIP "Month Calendar Control NoToday" ;
         NOTODAY ;
         INVISIBLE ;
         ON CHANGE MsgInfo ( "Month_1 Change" , "Info" )

      @ 10,370 BUTTON Button_11 ;
         CAPTION "SHOW" ;
         ACTION Form_1.Month_1.Show

      @ 50,370 BUTTON Button_12 ;
         CAPTION "HIDE" ;
         ACTION Form_1.Month_1.Hide

      @ 90,370 BUTTON Button_13 ;
         CAPTION "IS VISIBLE ?" ;
         ACTION MsgInfo ( if ( Form_1.Month_1.Visible , "TRUE" , "FALSE" ) , "Info" )

      @ 10,490 BUTTON Button_14 ;
         CAPTION "SET DATE" ;
         ACTION Form_1.Month_1.Value := Date()

      @ 50,490 BUTTON Button_15 ;
         CAPTION "GET DATE" ;
         ACTION MsgInfo ( GetDate ( Form_1.Month_1.Value ) , "Info" )

      // month calendar 2

      @ 210,10 MONTHCALENDAR Month_2 ;
         VALUE D"2001/01/01" ;
         FONT "Arial" SIZE 12 ;
         WIDTH 320 ;
         HEIGHT 205 ;
         TOOLTIP "Month Calendar Control NoTodayCircle WeekNumbers NoTabStop BoldDays" ;
         NOTODAYCIRCLE ;
         WEEKNUMBERS ;
         NOTABSTOP ;
         ON CHANGE MsgInfo( "Month_2 Change" , "Info" ) ;
         ON GETBOLDDAYS { | dStart, dEnd | BoldDays( dStart, dEnd ) }

      @ 210,370 BUTTON Button_21 ;
         CAPTION "SHOW" ;
         ACTION Form_1.Month_2.Show

      @ 250,370 BUTTON Button_22 ;
         CAPTION "HIDE" ;
         ACTION Form_1.Month_2.Hide

      @ 290,370 BUTTON Button_23 ;
         CAPTION "IS VISIBLE ?" ;
         ACTION MsgInfo ( if ( Form_1.Month_2.Visible , "TRUE" , "FALSE" ) , "Info" )

      @ 210,490 BUTTON Button_24 ;
         CAPTION "SET DATE" ;
         ACTION Form_1.Month_2.Value := D"2001/01/01"

      @ 250,490 BUTTON Button_25 ;
         CAPTION "GET DATE" ;
         ACTION MsgInfo ( GetDate ( Form_1.Month_2.Value ) , "Info" )

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

Static Function GetDate ( dDate )

   Local nDay := Day(dDate)
   Local nMonth := Month(dDate)
   Local nYear := Year(dDate)
   Local cRet := ""

   cRet += "Day: "+StrZero(nDay,2)
   cRet += space(2)
   cRet += "Month: "+StrZero(nMonth,2)
   cRet += space(2)
   cRet += "Year: "+StrZero(nYear,4)

   Return cRet

STATIC FUNCTION BoldDays ( dStart, dEnd )

  LOCAL aBold := {}
  LOCAL dTest := dStart

  WHILE dTest <= dEnd
    IF DAY(dTest) == 1 .OR. DAY(dTest) == 15 .OR. DAY(dTest) == 29
      AADD(aBold, dTest)
    ENDIF
    dTest ++
  END WHILE

  RETURN aBold
