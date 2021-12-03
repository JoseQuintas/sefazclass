/*
* HMG - Harbour Win32 GUI library Demo
*
* Copyright 2002-2010 Roberto Lopez <mail.box.hmg@gmail.com>
* http://www.hmgforum.com//
*
*/

#include "hmg.ch"

#xcommand DRAW PANEL IN WINDOW <parent> ;
      AT <frow>,<fcol> ;
      TO <trow>,<tcol> ;
          =>;
      DrawWindowBoxRaised( <"parent">, <frow>, <fcol>, <trow>, <tcol> )

#xcommand DRAW BOX IN WINDOW <parent> ;
      AT <frow>,<fcol> ;
      TO <trow>,<tcol> ;
          =>;
      DrawWindowBoxIn( <"parent">, <frow>, <fcol>, <trow>, <tcol> )

function main

   define window x ;
      at 0,0 ;
      width 640 ;
      height 480 ;
      title "Draw Box And Panel Sample By Grigory Filatov" ;
      main nomaximize nosize ;
      on init x.Button_1.Setfocus

      DRAW BOX         ;
      IN WINDOW x         ;
      AT 20,20         ;
      TO 200,300

      @ 110, 140 LABEL Label_1 VALUE "Box In" AUTOSIZE

      DRAW PANEL         ;
      IN WINDOW x         ;
      AT 20,320         ;
      TO 200,610

      @ 110, 440 LABEL Label_2 VALUE "Panel" AUTOSIZE

      @ 220,20 FRAME Frame_1 ;
         CAPTION "Frame Title" ;
         WIDTH 280 ;
         HEIGHT 180 ;
         OPAQUE

      @ 220,320 FRAME Frame_2 ;
         WIDTH 290 ;
         HEIGHT 180 ;
         OPAQUE

      @ 310, 410 LABEL Label_3 VALUE "Frame without title" AUTOSIZE

      @ 414, 530 BUTTON Button_1 ;
         CAPTION "&Close" ;
         ACTION ThisWindow.Release ;
         WIDTH 78 HEIGHT 26

   end window

   x.center

   Activate Window x

Return


function DrawWindowBoxIn(window,row,col,rowr,colr)
   Local i := GetFormIndex ( Window )
   Local FormHandle := GetFormHandle ( Window )
   Local hDC := GetDC( FormHandle )

   WndBoxIn( hDC, row, col, rowr, colr )
   aadd ( _HMG_SYSDATA [ 102 ] [i] , { || WndBoxIn( hDC := GetDC( FormHandle ), row, col, rowr, colr ), ReleaseDC( FormHandle, hDC ) } )
   ReleaseDC( FormHandle, hDC )

return nil

function DrawWindowBoxRaised(window,row,col,rowr,colr)
   Local i := GetFormIndex ( Window )
   Local FormHandle := GetFormHandle ( Window )
   Local hDC := GetDC( FormHandle )

   WndBoxIn( hDC, row, col, rowr, colr )
   aadd ( _HMG_SYSDATA [ 102 ] [i] , { || WndBoxRaised( hDC := GetDC( FormHandle ), row, col, rowr, colr ), ReleaseDC( FormHandle, hDC ) } )
   ReleaseDC( FormHandle, hDC )

return nil


#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"

void WndDrawBox( HDC hDC, RECT * rct, HPEN hPUpLeft, HPEN hPBotRit )
{
   HPEN hOldPen = ( HPEN ) SelectObject( hDC, hPUpLeft );
   POINT pt;

   MoveToEx( hDC, rct->left, rct->bottom, &pt );

   LineTo( hDC, rct->left, rct->top );
   LineTo( hDC, rct->right, rct->top );
   SelectObject( hDC, hPBotRit );

   MoveToEx( hDC, rct->left, rct->bottom, &pt );

   LineTo( hDC, rct->right, rct->bottom );
   LineTo( hDC, rct->right, rct->top - 1 );
   SelectObject( hDC, hOldPen );
}

void WindowBoxIn( HDC hDC, RECT * pRect )
{
   HPEN hWhite = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) );
   HPEN hGray = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) );

   WndDrawBox( hDC, pRect, hGray, hWhite );

   DeleteObject( hGray );
   DeleteObject( hWhite );
}

void WindowRaised( HDC hDC, RECT * pRect )
{
   HPEN hGray  = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) );
   HPEN hWhite = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) );

   WndDrawBox( hDC, pRect, hWhite, hGray );

   DeleteObject( hGray );
   DeleteObject( hWhite );
}

HB_FUNC ( GETDC )
{
   hb_retnl( (ULONG) GetDC( (HWND) hb_parnl(1) ) ) ;
}

HB_FUNC ( RELEASEDC )
{
   hb_retl( ReleaseDC( (HWND) hb_parnl(1), (HDC) hb_parnl(2) ) ) ;
}

HB_FUNC( WNDBOXIN )
{
   RECT rct;

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   WindowBoxIn( ( HDC ) hb_parnl( 1 ), &rct );
}

HB_FUNC( WNDBOXRAISED )
{
   RECT rct;

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   WindowRaised( ( HDC ) hb_parnl( 1 ), &rct );
}

#pragma ENDDUMP



/*
	
*------------------------------------------------------------------------------*
Procedure _RefreshDataControls (i)
*------------------------------------------------------------------------------*
Local SplitIndex
Local x
Local w

   If Len ( _HMG_SYSDATA [ 102 ] [i] ) > 0
      SendMessage( _HMG_SYSDATA [ 67 ] [i] , WM_PAINT , 0 , 0 )
   EndIf
...

*/