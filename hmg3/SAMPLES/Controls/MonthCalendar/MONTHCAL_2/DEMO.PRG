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
      FONT "Arial" SIZE 10

      // Month Calendar 1

      @ 10,10 MONTHCALENDAR Month_1 ;
         VALUE date() ;
         TOOLTIP "Month Calendar Control NoToday" ;
         NOTODAY ;
         ON CHANGE MsgInfo( "Month_1 Change" , "Info")

      @ 10,300 BUTTON Button_1 ;
         CAPTION "SET DATE" ;
         ACTION Form_1.Month_1.Value := Date()

      @ 50,300 BUTTON Button_2 ;
         CAPTION "GET DATE" ;
         ACTION MsgInfo ( GetDate ( Form_1.Month_1.Value ) , "Info" )

      // Month Calendar 2

      @ 210,10 MONTHCALENDAR Month_2 ;
         VALUE CTOD("01/01/2001") ;
         FONT "Courier" SIZE 12 ;
         TOOLTIP "Month Calendar Control NoTodayCircle WeekNumbers" ;
         NOTODAYCIRCLE ;
         WEEKNUMBERS ;
         ON CHANGE MsgInfo( "Month_2 Change" , "Info" )

      @ 210,300 BUTTON Button_3 ;
         CAPTION "SET DATE" ;
         ACTION Form_1.Month_2.Value := CToD("01/01/2001")

      @ 250,300 BUTTON Button_4 ;
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


