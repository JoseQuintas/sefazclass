/*
TSTICON
1992.12 José Quintas
*/

#include "inkey.ch"
#include "hbgtinfo.ch"
#include "wvgparts.ch"

FUNCTION Main()

   LOCAL nRow, aControlList := {}, oControl

   SetMode(40,132)
   SetColor( "W/B" )
   CLS
   nRow := Int( ( MaxRow() - 16 ) / 2 )
   WITH OBJECT oControl := wvgtstIcon():New()
      :SetColorBG( SetColor() )
      :cImage := "icojpatecnologia"
      :Create( , , { -nRow, -24 }, { -5.5, -84 } )
   ENDWITH

   @ 25, 0 SAY ""
   AAdd( aControlList, oControl )
   WITH OBJECT oControl := wvgTstIcon():New()
      :SetColorBG( SetColor() ) // "W/B" )
      :cImage := "icoSanta"
      :Create( , , { -( Row() + 1 ), -33 }, { -6, -13 } )
   ENDWITH
   AAdd( aControlList, oControl )
   Inkey(0)
   FOR EACH oControl IN aControlList
      oControl:Destroy()
   NEXT
   wvgSetAppWindow():Refresh()

   RETURN NIL
