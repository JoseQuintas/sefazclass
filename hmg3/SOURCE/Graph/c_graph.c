
/*
File:		c_graph.c
Author:		Grigory Filatov
Description:	Graph Library for HMG
Status:		Public Domain
Notes:		Support function for DRAW commands

Based on works of:

		Alfredo Arteaga 14/10/2001 original idea
		Alfredo Arteaga TGRAPH 2, 12/03/2002
*/

#include "HMG_UNICODE.h"

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include <wingdi.h>
#include <winuser.h>

HB_FUNC ( LINEDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;
   hWnd1 = (HWND) HMG_parnl(1);
   hdc1 = GetDC( hWnd1 );
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(7), (COLORREF) RGB( (int) hb_parvni(6,1), (int) hb_parvni(6,2), (int) hb_parvni(6,3) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   MoveToEx( hdc1, (int) hb_parni(3), (int) hb_parni(2), NULL );
   LineTo( hdc1, (int) hb_parni(5), (int) hb_parni(4) );
   SelectObject( hdc1, (HGDIOBJ) hgdiobj1 );
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( RECTDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   hWnd1 = (HWND) HMG_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(7), (COLORREF) RGB( (int) hb_parvni(6,1), (int) hb_parvni(6,2), (int) hb_parvni(6,3) ) );

   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(9))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parvni(8,1),(int) hb_parvni(8,2),(int) hb_parvni(8,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   Rectangle((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( ROUNDRECTDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   hWnd1 = (HWND) HMG_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(9), (COLORREF) RGB( (int) hb_parvni(8,1), (int) hb_parvni(8,2), (int) hb_parvni(8,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(11))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parvni(10,1),(int) hb_parvni(10,2),(int) hb_parvni(10,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   RoundRect((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4),(int) hb_parni(6),(int) hb_parni(7));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( ELLIPSEDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   hWnd1 = (HWND) HMG_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(7), (COLORREF) RGB( (int) hb_parvni(6,1), (int) hb_parvni(6,2), (int) hb_parvni(6,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(9))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parvni(8,1),(int) hb_parvni(8,2),(int) hb_parvni(8,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   Ellipse((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( ARCDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;
   hWnd1 = (HWND) HMG_parnl (1);
   hdc1 = GetDC ( hWnd1 );
   hpen = CreatePen( PS_SOLID, (int) hb_parni(11), (COLORREF) RGB( (int) hb_parvni(10,1), (int) hb_parvni(10,2), (int) hb_parvni(10,3) ) );
   hgdiobj1 = SelectObject( hdc1, hpen );
   Arc( hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4),(int) hb_parni(7),(int) hb_parni(6),(int) hb_parni(9),(int) hb_parni(8));
   SelectObject( hdc1, hgdiobj1);
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC ( PIEDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   hWnd1 = (HWND) HMG_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(11), (COLORREF) RGB( (int) hb_parvni(10,1), (int) hb_parvni(10,2), (int) hb_parvni(10,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(13))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parvni(12,1),(int) hb_parvni(12,2),(int) hb_parvni(12,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   Pie((HDC) hdc1,(int) hb_parni(3),(int) hb_parni(2),(int) hb_parni(5),(int) hb_parni(4),(int) hb_parni(7),(int) hb_parni(6),(int) hb_parni(9),(int) hb_parni(8));
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC( POLYGONDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1,hgdiobj2;
   HPEN hpen;
   HBRUSH hbrush;
   POINT apoints[1024];
   int number=hb_parinfa(2,0);
   int i;
   hWnd1 = (HWND) HMG_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(5), (COLORREF) RGB( (int) hb_parvni(4,1), (int) hb_parvni(4,2), (int) hb_parvni(4,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   if (hb_parl(7))
   {
      hbrush = CreateSolidBrush((COLORREF) RGB((int) hb_parvni(6,1),(int) hb_parvni(6,2),(int) hb_parvni(6,3)));
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   else
   {
      hbrush = GetSysColorBrush((int) COLOR_WINDOW);
      hgdiobj2 = SelectObject((HDC) hdc1, hbrush);
   }
   for(i = 0; i <= number-1; i++)
   {
   apoints[i].x=hb_parvni(2,i+1);
   apoints[i].y=hb_parvni(3,i+1);
   }
   Polygon((HDC) hdc1,apoints,number);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj2);
   DeleteObject( hpen );
   DeleteObject( hbrush );
   ReleaseDC( hWnd1, hdc1 );
}

HB_FUNC( POLYBEZIERDRAW )
{
   HWND hWnd1;
   HDC hdc1;
   HGDIOBJ hgdiobj1;
   HPEN hpen;
   POINT apoints[1024];
   DWORD number=(DWORD) hb_parinfa(2,0);
   DWORD i;
   hWnd1 = (HWND) HMG_parnl (1);
   hdc1 = GetDC((HWND) hWnd1);
   hpen = CreatePen( (int) PS_SOLID, (int) hb_parni(5), (COLORREF) RGB( (int) hb_parvni(4,1), (int) hb_parvni(4,2), (int) hb_parvni(4,3) ) );
   hgdiobj1 = SelectObject((HDC) hdc1, hpen);
   for(i = 0; i <= number-1; i++)
   {
   apoints[i].x=hb_parvni(2,i+1);
   apoints[i].y=hb_parvni(3,i+1);
   }
   PolyBezier((HDC) hdc1,apoints,number);
   SelectObject((HDC) hdc1,(HGDIOBJ) hgdiobj1);
   DeleteObject( hpen );
   ReleaseDC( hWnd1, hdc1 );
}

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

HB_FUNC( WNDBOXIN )
{
   RECT rct;

   rct.top    = hb_parni( 2 );
   rct.left   = hb_parni( 3 );
   rct.bottom = hb_parni( 4 );
   rct.right  = hb_parni( 5 );

   WindowBoxIn( (HDC) HMG_parnl (1), &rct );
}


HB_FUNC ( GETDC )
{
   HDC hDC = GetDC ( (HWND) HMG_parnl (1) );
   HMG_retnl ((LONG_PTR) hDC );
}

HB_FUNC ( RELEASEDC )
{
   hb_retl( ReleaseDC( (HWND) HMG_parnl (1), (HDC) HMG_parnl (2) ) ) ;
}

