#include "inkey.ch"
#include "bostaurus.ch"
#include "i_color.ch"
#include "hbclass.ch"

FUNCTION MAIN

   LOCAL oWin := { NIL, NIL, NIL, NIL }, oJanela

   hb_gtReLoad( "WVG" )
   //wvt_SetGui( .T. )
   SetMode(25,80)
   CLS
   oWin[ 1 ] := MyClass():New()
   oWin[ 2 ] := MyClass():New()
   oWin[ 3 ] := MyClass():New()
   oWin[ 4 ] := MyClass():New()
   oWin[ 1 ]:Create( , , { -1, -1 }, { -10, -35 } )
   oWin[ 2 ]:Create( , , { -1, -41 }, { -10, -35 } )
   oWin[ 3 ]:Create( , , { -13, -1 }, { -10, -35 } )
   oWin[ 4 ]:Create( , , { -13, -41 }, { -10, -35 } )
   Inkey(0)
   DO WHILE .T.
      FOR EACH oJanela IN oWin
         //nCont := iif( nCont >= 6, 1, nCont + 1 )
         //BT_ClientAreaInvalidateAll( oJanela:hWnd )
         //Proc_On_Paint( nCont, oJanela )
         oJanela:Repaint( oJanela:__EnumIndex )
      NEXT
      IF Inkey(0) == K_ESC
         EXIT
      ENDIF
   ENDDO

   RETURN Nil

CREATE CLASS MyClass INHERIT wvgTstRectangle

   METHOD Repaint( n )
   ENDCLASS

METHOD Repaint( n ) Class MyClass

   BT_ClientAreaInvalidateAll( ::hWnd )
   Proc_On_Paint( n, Self )

   RETURN Self

PROCEDURE Proc_ON_PAINT( Cont, oJanela )

   LOCAL n_hWnd, nWidth, nHeight
   LOCAL hDC, BTstruct, nAlignText, nTypeText

   n_hWnd := oJanela:hWnd
   nWidth := oJanela:CurrentSize[ 1 ] // BT_ClientAreaWidth( n_hWnd )
   nHeight := oJanela:CurrentSize[ 2 ] // BT_ClientAreaHeight( n_hWnd )

   hDC = BT_CreateDC( n_hWnd, BT_HDC_INVALIDCLIENTAREA, @BTstruct)

   DO CASE
   CASE cont = 1
      BT_DrawGradientFillHorizontal( hDC, 0, 0, nWidth / 2, nHeight, BLACK, BLUE )
      BT_DrawGradientFillHorizontal( hDC, 0, nWidth / 2, nWidth / 2, nHeight, BLUE, BLACK )

   CASE cont = 2
      BT_DrawGradientFillVertical( hDC, 0, 0, nWidth, nHeight / 2, BLACK, RED )
      BT_DrawGradientFillVertical( hDC, nHeight / 2, 0, nWidth, nHeight / 2, RED, BLACK )

   CASE cont = 3
      BT_DrawGradientFillVertical( hDC, 0,0, nWidth, nHeight / 2, RED, GREEN )
      BT_DrawGradientFillVertical( hDC, nHeight / 2, 0, nWidth, nHeight / 2, GREEN, BLUE )

   CASE cont = 4
      BT_DrawGradientFillHorizontal( hDC, 0, 0, nWidth / 2, nHeight, GREEN, BLUE )
      BT_DrawGradientFillHorizontal( hDC, 0, nWidth / 2, nWidth / 2, nHeight, BLUE, RED )

   CASE cont = 5
      BT_DrawGradientFillVertical( hDC, 0, 0, nWidth, nHeight, WHITE, BLACK )

   CASE cont = 6
      BT_DrawGradientFillHorizontal( hDC, 0, 0, nWidth, nHeight, { 100, 0, 123 }, BLACK )

   END CASE

   nTypeText  := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD + BT_TEXT_ITALIC + BT_TEXT_UNDERLINE
   nAlignText := BT_TEXT_CENTER + BT_TEXT_BASELINE
   BT_DrawText( hDC, nHeight / 2 - 3, nWidth / 2 + 3, "The Power of Bostaurus", "Comic Sans MS", 18, GRAY, BLACK, nTypeText, nAlignText ) // Shadow Effect
   BT_DrawText( hDC, nHeight / 2, nWidth / 2, "The Power of Bostaurus", "Comic Sans MS", 18, YELLOW, BLACK, nTypeText, nAlignText )

   BT_DeleteDC( BTstruct )

   RETURN
