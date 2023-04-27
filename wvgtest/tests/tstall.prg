/*
TESTGTWVG - Teste das funções adicionais pra GTWVG
José Quintas
*/

#include "inkey.ch"
#include "wvtwin.ch"
#include "wvgparts.ch"

PROCEDURE Main

   LOCAL aCtlList := Array(50), GetList := {}, cText := "This is a GET", nCont, nCtlIndex := 1

   hb_gtReLoad( "WVG" )
   SetMode( 28, 120 )
   SetColor("N/W,N/W")
   SET SCOREBOARD OFF
   CLS

   SetColor( "B/W" )
   FOR nCont = 1 TO 6
      WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstText():New()
         :cFontName := "Arial"
         :nFontSize := nCont * 10 + 20
         :cText := "Test of " + :cFontName + " " + Ltrim( Str( :nFontSize ) )
         :Create( , , { -( nCont * 4 - 3 ), -95 }, { -4, -20 } )
      ENDWITH
   NEXT

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstMonthCalendar():New()
      :Create( , , { -1, -63 }, { -12, -30 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstCommandLink():New()
      :cText := "Cmd Link"
      :Create( , , { -13, -63 }, { -5, -15 } )
      :SetNote( "Vista and Above" )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstTrackbar():New()
      :Create( , , { -20, -60 }, { -2, -20 }, , .F. )
      :SetValues( 1, 1, 20 )
      :Show()
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstUpDown():New()
      :Create( , , { -18, -82 }, { -3, -5 } )
      :SetValues( 1, 1, 100 )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstEditMultiline():New()
      :cText := GetEditText()
      :Create( , , { -1, -2 }, { -5, -35 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstPushButton():New()
      :Create( , , { -7, -2 }, { -9, -30 } )
      :SetCaption( { , WVG_IMAGE_ICONRESOURCE, "tstico" } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstLineVertical():New()
      :Create( , , { -1, -38 }, { -16, 4 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstScrollbar():New()
      :Style += SBS_VERT
      :Create( , , { -1, -39 }, { -14, -2 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstScrollbar():New()
      :Style += SBS_HORZ
      :Create( , , { -17, -2 }, { -1, -36 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstLineHorizontal():New()
      :Create( , , { -16.5, -2 }, { 4, -36 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstIcon():New()
      :cImage := "tstico"
      :Create( , , { -19, -2 }, { -3, -8 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstBitmap():New()
      :cImage := "tstbmp"
      :Create( , , { -19, -41 }, { -3, -8 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstcheckbox():New()
      :cText := "Satisfied?"
      :Create( , , { -19, -15 }, { -1, -10 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstCheckBox():New()
      :cText := "Not Satisfied?"
      :Style += BS_LEFTTEXT
      :Create( , , { -21, -15 }, { -1, -10 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstRectangle():New()
      :Create( , , { -19, -30 }, { -3, -10 } )
      :SetColorBG( WIN_RGB( 52, 101, 164 ) )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstListBox():New()
      :Create( , , { -1, -43 }, { -5, -16 } )
      :AddItem( "Harbour" )
      :AddItem( "GtWvt" )
      :AddItem( "Wvtgui" )
      :AddItem( "Modeless" )
      :AddItem( "Dialogs" )
      :AddItem( "WVT" )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstText():New()
      :cText := "Degree"
      :Create( , , { -6.5, -43 }, { -1, -17 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstComboBox():New()
      :Create( , , { -7.5, -43 }, { -6, -17 } )
      :AddItem( "First" )
      :AddItem( "Second" )
      :AddItem( "Third" )
      :AddItem( "Fourth" )
      :AddItem( "Fifth" )
      :SetValue( 1 )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstGroupbox():new()
      :cText := "Compiler"
      :Create( , , { -9, -43 }, { -4.3, -17 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstRadioButton():New()
      :cText := "Harbour"
      :Create( , , { -10, -45 }, { -1, -12 } )
      :SetCheck( .T. )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstRadioButton():New()
      :Style += BS_LEFTTEXT
      :cText := "Clipper"
      :Create( , , { -11, -45 }, { -1, -12 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstRadioButton():New()
      :cText := "Xbase++"
      :Create( , , { -12, -45 }, { -1, -12 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstText():New()
      :cText := "Scrollable Text"
      :Create( , , { -14, -43 }, { -1, -18 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstScrollText():New()
      :cText := "This is Text Field"
      :Create( , , { -15, -43 }, { -1, -18 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstText():New()
      :cText := "Right Justified Numerics"
      :Create( , , { -16, -43 }, { -1, -18 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstEdit():New()
      :Style += ES_NUMBER + ES_RIGHT
      :cText := "1234567"
      :Create( , , { -17, -43 }, { -1, -18 } )
   ENDWITH

   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstButton():New()
      :cText := "OK"
      :Create( , , { -20, -50 }, { -1, -8 } )
   ENDWITH
   wvgSetAppWindow():Refresh()

   //oControl := wvgtstStatusbar():New()
   //oControl:Create( , , { -28, 1 }, { -1, -50 } )

   @ 23, 62 SAY "SAY in frame"

   SetColor( "N/W,N/W,,,N/W" )
   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgtstGroupBox():New()
      :cText := "GET in Groupbox"
      :Create( , , { -24, -60 }, { -2, -Len( cText ) - 4 } )
   ENDWITH

   //oControl := wvgtstFrame():New()
   //oControl:Create( , , { -25, -62 }, { -1, -Len( cText ) } )
   @ 25, 62 GET cText
   READ
   WITH OBJECT aCtlList[ nCtlIndex++ ] := wvgProgressbar():New()
      :Create( ,, { -18, -1 }, { -2, -110 } )
      FOR nCont = 1 TO 50
         //:SetCaption( Ltrim(Str(nCont)) + "/50" ) // do not work
         :SetValue( nCont, 1, 50 )
         Inkey(0.5)
      NEXT
   ENDWITH

   Inkey(0)
   ( nCtlIndex )

   RETURN

FUNCTION GetEditText()

   RETURN Replicate( Space(10) + hb_Eol(), 10 )
   //   "This sample is to show GTWVG possibilites." + hb_eol() + ;
   //   "It does not use existing GTWVG controls," + hb_eol() + ;
   //   "but uses features of GTWVG." + hb_eol() + ;
   //   "Think possibilites to expand." + hb_eol()
