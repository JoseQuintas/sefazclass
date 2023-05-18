#include "inkey.ch"
#include "bostaurus.ch"
#include "i_color.ch"
#include "hbclass.ch"

FUNCTION MAIN

   LOCAL oWin, nKey := 0, nCont

   hb_gtReLoad( "WVG" )
   //wvt_SetGui( .T. )
   SetMode(25,80)
   CLS
   oWin := MyClass():New()
   oWin:Create( , , { -1, -1 }, { -5, -35 } )
   DO WHILE nKey != K_ESC
      FOR nCont = 1 TO 100
         oWin:SetValue( nCont, 100 )
         IF ( nKey := Inkey(1) ) == K_ESC
            EXIT
         ENDIF
      NEXT
      IF nKey == K_ESC
         EXIT
      ENDIF
   ENDDO

   RETURN Nil

CREATE CLASS MyClass INHERIT wvgTstRectangle

   VAR nIndex INIT 1
   VAR nTotal INIT 1
   METHOD Paint()
   METHOD SetValue( nIndex, nTotal ) INLINE ::nIndex := nIndex, ::nTotal := nTotal, ::Paint()

   ENDCLASS

METHOD Paint() Class MyClass

   LOCAL nWidth, nHeight
   LOCAL hDC, BTstruct, nAlignText, nTypeText, aSize

   BT_ClientAreaInvalidateAll( ::hWnd )
   aSize := ::CurrentSize()
   nWidth := aSize[ 1 ] // BT_ClientAreaWidth( n_hWnd )
   nHeight := aSize[ 2 ] // BT_ClientAreaHeight( n_hWnd )

   hDC = BT_CreateDC( ::hWnd, BT_HDC_INVALIDCLIENTAREA, @BTstruct)

   BT_DrawGradientFillHorizontal( hDC, 0, 0, Int( ( nWidth * ::nIndex ) / ::nTotal ), nHeight, BLACK, BLUE )

   BT_DrawGradientFillHorizontal( hDC, 0, Int( ( nWidth * ::nIndex ) / ::nTotal ), nWidth - Int( ( nWidth * ::nIndex ) / ::nTotal ), nHeight, BLACK, RED )

   nTypeText  := BT_TEXT_TRANSPARENT + BT_TEXT_BOLD + BT_TEXT_ITALIC
   nAlignText := BT_TEXT_LEFT + BT_TEXT_BASELINE
   BT_DrawText( hDC, 40, 55, "Testing graphic", "Comic Sans MS", 25, YELLOW, BLACK, nTypeText, nAlignText )

   BT_DeleteDC( BTstruct )

   RETURN Nil

FUNCTION AppVersaoExe()

   RETURN ""
