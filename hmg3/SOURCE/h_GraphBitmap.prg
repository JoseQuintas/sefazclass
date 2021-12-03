/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2008, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net>

	"HWGUI"
  	Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

/*
 * (c) Alfredo Arteaga, 2001-2002 ( Original Idea )
 *
 * (c) Grigory Filatov, 2003-2004 ( Translation for MiniGUI )
 *
 * (c) Siri Rathinagiri, 2016 ( Adaptation for Draw in Bitmap )
*/


#include "hmg.ch"


FUNCTION HMG_Graph( nWidth, nHeight, aSerieValues, cTitle, aSerieYNames, nBarDepth, nBarWidth, nSeparation, aTitleColor, nHValues, ;
                    l3DView, lShowGrid, lShowXGrid, lShowYGrid, lShowXValues, lShowYValues, lShowLegends, aSerieNames, aSerieColors, nGraphType, ;
                    lShowValues, cPicture, nLegendWindth, lNoBorder )

   LOCAL nI, nJ, nPos, nMax, nMin, nMaxBar, nDeep
   LOCAL nRange, nResH, nResV,  nWide, aPoint
   LOCAL nXMax, nXMin, nHigh, nRel, nZero, nRPos, nRNeg
   LOCAL hBitmap, hDC, BTStruct
   LOCAL nTop := 0
   LOCAL nLeft := 0
   LOCAL nBottom := nHeight
   LOCAL nRight := nWidth

   CHECK TYPE SOFT ;
         nWidth         AS NUMERIC     ,;
         nHeight        AS NUMERIC     ,;
         aSerieValues   AS ARRAY       ,;
         cTitle         AS CHARACTER   ,;
         aSerieYNames   AS ARRAY       ,;
         nBarDepth      AS NUMERIC     ,;
         nBarWidth      AS NUMERIC     ,;
         nSeparation    AS NUMERIC     ,;
         aTitleColor    AS ARRAY       ,;
         nHValues       AS NUMERIC     ,;
         l3DView        AS LOGICAL     ,;
         lShowGrid      AS LOGICAL     ,;
         lShowXGrid     AS LOGICAL     ,;
         lShowYGrid     AS LOGICAL     ,;
         lShowXValues   AS LOGICAL     ,;
         lShowYValues   AS LOGICAL     ,;
         lShowLegends   AS LOGICAL     ,;
         aSerieNames    AS ARRAY       ,;
         aSerieColors   AS ARRAY       ,;
         nGraphType     AS NUMERIC     ,;
         lShowValues    AS LOGICAL     ,;
         cPicture       AS CHARACTER   ,;
         nLegendWindth  AS NUMERIC     ,;
         lNoBorder      AS LOGICAL

   DEFAULT cTitle   := ""
   DEFAULT nSeparation     := 0
   DEFAULT cPicture := "999,999.99"
   DEFAULT nLegendWindth := 50

   If ( HMG_LEN (aSerieNames) != HMG_LEN ( aSerieValues ) ) .or. ;
      ( HMG_LEN ( aSerieNames ) != HMG_LEN ( aSerieColors ) )
      MsgHMGError("DRAW GRAPH: 'Series' / 'SerieNames' / 'Colors' arrays size mismatch. Program terminated", "HMG Error" )
   EndIf

   hBitmap := BT_BitmapCreateNew ( nWidth, nHeight, WHITE )
   hDC := BT_CreateDC( hBitmap, BT_HDC_BITMAP, @BTStruct )

   IF lShowGrid
      lShowXGrid := lShowYGrid := .T.
   ENDIF

   IF nBottom <> NIL .AND. nRight <> NIL
      nHeight := nBottom - nTop / 2
      nWidth  := nRight - nLeft / 2
      nBottom -= IF( lShowYValues, 42, 32)
      nRight  -= IF( lShowLegends, 32 + nLegendWindth , 32 )
   ENDIF
   nTop    += 1 + IF( Empty( cTitle ), 30, 44 )             // Top gap
   nLeft   += 1 + IF( lShowXValues, 80 + nBarDepth, 30 + nBarDepth )     // LEFT
   DEFAULT nBottom := nHeight - 2 - IF( lShowYValues, 40, 30 )    // Bottom
   DEFAULT nRight  := nWidth - 2 - IF( lShowLegends, 30 + nLegendWindth , 30 ) // RIGHT

   l3DView     := IF( nGraphType == POINTS, .F., l3DView )
   nDeep   := IF( l3DView, nBarDepth, 1 )
   nMaxBar := nBottom - nTop - nDeep - 5
   nResH   := nResV := 1
   nWide   := ( nRight - nLeft )* nResH / ( nMax( aSerieValues ) + 1 ) * nResH

   // Graph area
   //
   IF ! lNoBorder
      DrawWindowBoxInBitmap( hDC, Max( 1, nTop - 44 ), Max( 1, nLeft - 80 - nBarDepth ), nHeight - 1, nWidth - 1 )
   ENDIF

   // Back area
   //
   IF l3DView
      DrawRectInBitmap( hDC, nTop+1, nLeft, nBottom - nDeep, nRight, WHITE )
   ELSE
      DrawRectInBitmap( hDC, nTop-5, nLeft, nBottom, nRight, WHITE )
   ENDIF

   IF l3DView
      // Bottom area
      FOR nI := 1 TO nDeep+1
          DrawLineInBitmap( hDC, nBottom-nI, nLeft-nDeep+nI, nBottom-nI, nRight-nDeep+nI, WHITE )
      NEXT nI

      // Lateral
      FOR nI := 1 TO nDeep
          DrawLineInBitmap( hDC, nTop+nI, nLeft-nI, nBottom-nDeep+nI, nLeft-nI, SILVER )
      NEXT nI

      // Graph borders
      FOR nI := 1 TO nDeep+1
          DrawLineInBitmap( hDC, nBottom-nI     ,nLeft-nDeep+nI-1 ,nBottom-nI     ,nLeft-nDeep+nI  ,GRAY )
          DrawLineInBitmap( hDC, nBottom-nI     ,nRight-nDeep+nI-1,nBottom-nI     ,nRight-nDeep+nI ,BLACK )
          DrawLineInBitmap( hDC, nTop+nDeep-nI+1,nLeft-nDeep+nI-1 ,nTop+nDeep-nI+1,nLeft-nDeep+nI  ,BLACK )
          DrawLineInBitmap( hDC, nTop+nDeep-nI+1,nLeft-nDeep+nI-3 ,nTop+nDeep-nI+1,nLeft-nDeep+nI-2,BLACK )
      NEXT nI

      FOR nI=1 TO nDeep+2
          DrawLineInBitmap( hDC, nTop+nDeep-nI+1,nLeft-nDeep+nI-3,nTop+nDeep-nI+1,nLeft-nDeep+nI-2 ,BLACK )
          DrawLineInBitmap( hDC, nBottom+ 2-nI+1,nRight-nDeep+nI ,nBottom+ 2-nI+1,nRight-nDeep+nI-2,BLACK )
      NEXT nI

      DrawLineInBitmap( hDC, nTop         ,nLeft        ,nTop           ,nRight       ,BLACK )
      DrawLineInBitmap( hDC, nTop- 2      ,nLeft        ,nTop- 2        ,nRight+ 2    ,BLACK )
      DrawLineInBitmap( hDC, nTop         ,nLeft        ,nBottom-nDeep  ,nLeft        ,GRAY  )
      DrawLineInBitmap( hDC, nTop+nDeep   ,nLeft-nDeep  ,nBottom        ,nLeft-nDeep  ,BLACK )
      DrawLineInBitmap( hDC, nTop+nDeep   ,nLeft-nDeep-2,nBottom+ 2     ,nLeft-nDeep-2,BLACK )
      DrawLineInBitmap( hDC, nTop         ,nRight       ,nBottom-nDeep  ,nRight       ,BLACK )
      DrawLineInBitmap( hDC, nTop- 2      ,nRight+ 2    ,nBottom-nDeep+2,nRight+ 2    ,BLACK )
      DrawLineInBitmap( hDC, nBottom-nDeep,nLeft        ,nBottom-nDeep  ,nRight       ,GRAY  )
      DrawLineInBitmap( hDC, nBottom      ,nLeft-nDeep  ,nBottom        ,nRight-nDeep ,BLACK )
      DrawLineInBitmap( hDC, nBottom+ 2   ,nLeft-nDeep-2,nBottom+ 2     ,nRight-nDeep ,BLACK )
   ENDIF


   // Graph info
   //

   IF !Empty(cTitle)
      DrawTextInBitmap( hDC, nTop - 30 * nResV, nLeft, cTitle, 'Arial', 12, aTitleColor, 2 )
   ENDIF


   // Legends
   //
   IF lShowLegends
      nPos := nTop
      FOR nI := 1 TO HMG_LEN( aSerieNames )
         DrawBarInBitmap( hDC, nRight+(8*nResH), nPos+(9*nResV), 8*nResH, 7*nResV, l3DView, 1, aSerieColors[nI] )
         DrawTextInBitmap( hDC, nPos, nRight+(20*nResH), aSerieNames[nI], 'Arial', 8, BLACK, 0 )
         nPos += 18*nResV
      NEXT nI
   ENDIF

   // Max, Min values
   nMax := 0
   FOR nJ := 1 TO HMG_LEN(aSerieNames)
      FOR nI :=1 TO HMG_LEN(aSerieValues[nJ])
         nMax := Max( aSerieValues[nJ][nI], nMax )
      NEXT nI
   NEXT nJ
   nMin := 0
   FOR nJ := 1 TO HMG_LEN(aSerieNames)
      FOR nI :=1 TO HMG_LEN(aSerieValues[nJ])
         nMin := Min( aSerieValues[nJ][nI], nMin )
      NEXT nI
   NEXT nJ

   nXMax := IF( nMax > 0, DetMaxVal( nMax ), 0 )
   nXMin := IF( nMin < 0, DetMaxVal( nMin ), 0 )
   nHigh := nXMax + nXMin
   nMax  := Max( nXMax, nXMin )

   nRel  := ( nMaxBar / nHigh )
   nMaxBar := nMax * nRel



   nZero := nTop + (nMax*nRel) + nDeep + 5    // Zero pos
   IF l3DView
      FOR nI := 1 TO nDeep+1
          DrawLineInBitmap( hDC, nZero-nI+1, nLeft-nDeep+nI   , nZero-nI+1, nRight-nDeep+nI, SILVER )
      NEXT nI
      FOR nI := 1 TO nDeep+1
          DrawLineInBitmap( hDC, nZero-nI+1, nLeft-nDeep+nI-1 , nZero-nI+1, nLeft -nDeep+nI, GRAY )
          DrawLineInBitmap( hDC, nZero-nI+1, nRight-nDeep+nI-1, nZero-nI+1, nRight-nDeep+nI, BLACK )
      NEXT nI
      DrawLineInBitmap( hDC, nZero-nDeep, nLeft, nZero-nDeep, nRight, GRAY )
   ENDIF

   aPoint := Array( HMG_LEN( aSerieNames ), HMG_LEN( aSerieValues[1] ), 2 )
   nRange := nMax / nHValues

   // xLabels
   nRPos := nRNeg := nZero - nDeep
   FOR nI := 0 TO nHValues
      IF lShowXValues
         IF nRange*nI <= nXMax
            DrawTextInBitmap( hDC, nRPos, nLeft-nDeep-70, Transform(nRange*nI, cPicture), 'Arial', 8, BLUE )
         ENDIF
         IF nRange*(-nI) >= nXMin*(-1)
            DrawTextInBitmap( hDC, nRNeg, nLeft-nDeep-70, Transform(nRange*-nI, cPicture), 'Arial', 8, BLUE )
         ENDIF
      ENDIF

      IF lShowXGrid
         IF nRange*nI <= nXMax
            IF l3DView
               FOR nJ := 0 TO nDeep + 1
                  DrawLineInBitmap( hDC, nRPos + nJ, nLeft - nJ - 1, nRPos + nJ, nLeft - nJ, BLACK )
               NEXT nJ
            ENDIF
            DrawLineInBitmap( hDC, nRPos, nLeft, nRPos, nRight, BLACK )
         ENDIF
         IF nRange*-nI >= nXMin*-1
            IF l3DView
               FOR nJ := 0 TO nDeep + 1
                  DrawLineInBitmap( hDC, nRNeg + nJ, nLeft - nJ - 1, nRNeg + nJ, nLeft - nJ, BLACK )
               NEXT nJ
            ENDIF
            DrawLineInBitmap( hDC, nRNeg, nLeft, nRNeg, nRight, BLACK )
         ENDIF
      ENDIF
      nRPos -= ( nMaxBar / nHValues )
      nRNeg += ( nMaxBar / nHValues )
   NEXT nI

   IF lShowYGrid .and. nGraphType <> BARS
      nPos:=IF(l3DView, nTop, nTop-5 )
      nI  := nLeft + nWide
      FOR nJ := 1 TO nMax(aSerieValues)
         DrawLineInBitmap( hDC, nBottom-nDeep, nI, nPos, nI, COLOR_GREY41 )
         DrawLineInBitmap( hDC, nBottom, nI-nDeep, nBottom-nDeep, nI, COLOR_GREY41 )
         nI += nWide
      NEXT
   ENDIF

   DO WHILE .T.    // Bar adjust
      nPos = nLeft + ( nWide / 2 )
      nPos += ( nWide + nSeparation ) * ( HMG_LEN(aSerieNames) + 1 ) * HMG_LEN(aSerieValues[1])
      IF nPos > nRight
         nWide--
      ELSE
         EXIT
      ENDIF
   ENDDO

   nMin := nMax / nMaxBar

   nPos := nLeft + ( ( nWide + nSeparation ) / 2 )            // first point graph
   // nRange := ( ( nWide + nSeparation ) * HMG_LEN(aSerieNames) ) / 2 // Variable 'NRANGE' is assigned but not used in function. asistex

   IF lShowYValues .AND. HMG_LEN( aSerieYNames ) > 0                // Show yLabels
      nBarWidth  := ( nRight - nLeft ) / ( nMax(aSerieValues) + 1 )
      nI := nLeft + nBarWidth
      FOR nJ := 1 TO nMax(aSerieValues)
         // cName := "yVal_Name_"+LTrim(Str(nJ)) //  Variable 'CNAME' is assigned but not used in function.  asistex
         DrawTextInBitmap( hDC, nBottom + 8, nI - nDeep - IF(l3DView, 0, 8), aSerieYNames[nJ], 'Arial', 8, BLUE )
         nI += nBarWidth
      NEXT
   ENDIF

   IF lShowYGrid .and. nGraphType == BARS
      nPos := IF( l3DView, nTop, nTop-5 )
      nI  := nLeft + ( ( nWide + nSeparation ) / 2 ) + nWide
      FOR nJ := 1 TO nMax( aSerieValues )
         DrawLineInBitmap( hDC, nBottom-nDeep, nI - nWide , nPos, nI - nWide, COLOR_GREY41 )
         DrawLineInBitmap( hDC, nBottom, nI-nDeep - nWide , nBottom-nDeep, nI - nWide, COLOR_GREY41 )
         nI += ( ( hmg_len( aSerieNames ) + 1 ) * ( nWide + nSeparation ) )
      NEXT
   ENDIF

   // Bars
   //

   IF nGraphType == BARS
      if nMin <> 0
         nPos := nLeft + ( ( nWide + nSeparation ) / 2 )
         FOR nI=1 TO HMG_LEN(aSerieValues[1])
            FOR nJ=1 TO HMG_LEN(aSerieNames)
               DrawBarInBitmap( hDC, nPos, nZero, aSerieValues[nJ,nI] / nMin + nDeep, nWide, l3DView, nDeep, aSerieColors[nJ] )
               nPos += nWide+nSeparation
            NEXT nJ
            nPos += nWide+nSeparation
         NEXT nI
      endif
   ENDIF

   // Lines
   //
   IF nGraphType == LINES
      if nMin <> 0
         nBarWidth  := ( nRight - nLeft ) / ( nMax(aSerieValues) + 1 )
         nPos := nLeft + nBarWidth
         FOR nI := 1 TO HMG_LEN(aSerieValues[1])
            FOR nJ=1 TO HMG_LEN(aSerieNames)
               IF !l3DView
                  DrawPointInBitmap( hDC, nGraphType, nPos, nZero, aSerieValues[nJ,nI] / nMin + nDeep, aSerieColors[nJ] )
               ENDIF
               aPoint[nJ,nI,2] := nPos
               aPoint[nJ,nI,1] := nZero - ( aSerieValues[nJ,nI] / nMin + nDeep )
            NEXT nJ
            nPos += nBarWidth
         NEXT nI

         FOR nI := 1 TO HMG_LEN(aSerieValues[1])-1
            FOR nJ := 1 TO HMG_LEN(aSerieNames)
               IF l3DView
                  DrawPolygonInBitmap(hDC,{{aPoint[nJ,nI,1],aPoint[nJ,nI,2]},{aPoint[nJ,nI+1,1],aPoint[nJ,nI+1,2]}, ;
                              {aPoint[nJ,nI+1,1]-nDeep,aPoint[nJ,nI+1,2]+nDeep},{aPoint[nJ,nI,1]-nDeep,aPoint[nJ,nI,2]+nDeep}, ;
                              {aPoint[nJ,nI,1],aPoint[nJ,nI,2]}},,,aSerieColors[nJ])
               ELSE
                  DrawLineInBitmap( hDC, aPoint[ nJ, nI, 1 ], aPoint[ nJ, nI, 2 ], aPoint[ nJ, nI+1, 1 ], aPoint[ nJ, nI + 1, 2 ], aSerieColors[ nJ ] )
               ENDIF
            NEXT nJ
         NEXT nI

      endif
   ENDIF

   // Points
   //
   IF nGraphType == POINTS
      if nMin <> 0
         nBarWidth := ( nRight - nLeft ) / ( nMax(aSerieValues) + 1 )
         nPos := nLeft + nBarWidth
         FOR nI := 1 TO HMG_LEN(aSerieValues[1])
            FOR nJ=1 TO HMG_LEN(aSerieNames)
               DrawPointInBitmap( hDC, nGraphType, nPos, nZero, aSerieValues[nJ,nI] / nMin + nDeep, aSerieColors[nJ] )
               aPoint[nJ,nI,2] := nPos
               aPoint[nJ,nI,1] := nZero - aSerieValues[nJ,nI] / nMin
            NEXT nJ
            nPos += nBarWidth
         NEXT nI
      ENDIF
   endif

   IF lShowValues
      IF nGraphType == BARS
         nPos := nLeft + nWide + ( ( nWide+nSeparation ) * ( HMG_LEN(aSerieNames) / 2 ) )
      ELSE
         nBarWidth := ( nRight - nLeft ) / ( nMax(aSerieValues) + 1 )
         nPos := nLeft + nBarWidth
      ENDIF
      FOR nI := 1 TO HMG_LEN( aSerieValues[ 1 ] )
         FOR nJ := 1 TO HMG_LEN( aSerieNames )
            DrawTextInBitmap( hDC, nZero - ( aSerieValues[nJ,nI] / nMin + nDeep + 18 ), IF(nGraphType == BARS, nPos - IF(l3DView, 44, 46), nPos + 10), Transform( aSerieValues[ nJ, nI ], cPicture ), 'Arial', 8 )
            nPos+= IF( nGraphType == BARS, nWide + nSeparation, 0 )
         NEXT nJ
         IF nGraphType == BARS
            nPos += nWide + nSeparation
         ELSE
            nPos += nBarWidth
         ENDIF
      NEXT nI
   ENDIF

   IF l3DView
      DrawLineInBitmap( hDC, nZero, nLeft-nDeep, nZero, nRight-nDeep, BLACK )
   ELSE
      IF nXMax<>0 .AND. nXMin<>0
         DrawLineInBitmap( hDC, nZero-1, nLeft-2, nZero-1, nRight, RED )
      ENDIF

   endif

   BT_DeleteDC( BTstruct )

RETURN hBitmap


FUNCTION HMG_PieGraph( nWidth, nHeight, aSerieValues, aSerieNames, aSerieColors, cTitle, aTitleColor, nDepth, l3DView, lShowXValues, lShowLegends, lNoBorder )
   LOCAL fromrow := 0
   LOCAL fromcol := 0
   LOCAL torow := nHeight
   LOCAL tocol := nWidth
   LOCAL topleftrow
   LOCAL topleftcol
   LOCAL toprightrow
   LOCAL toprightcol
   LOCAL bottomrightrow
   LOCAL bottomrightcol
   LOCAL bottomleftrow
   LOCAL bottomleftcol
   LOCAL middletopcol
   LOCAL middleleftrow
   LOCAL middleleftcol
   LOCAL middlebottomcol
   LOCAL middlerightrow
   LOCAL middlerightcol
   LOCAL fromradialrow
   LOCAL fromradialcol
   LOCAL toradialrow
   LOCAL toradialcol
   LOCAL degrees := {}
   LOCAL cumulative := {}
   LOCAL j,i,sum := 0
   LOCAL shadowcolor
   LOCAL previos_cumulative
   LOCAL hDC, hBitmap, BTStruct

   CHECK TYPE SOFT;
         nWidth         AS NUMERIC   ,;
         nHeight        AS NUMERIC   ,;
         aSerieValues   AS ARRAY     ,;
         aSerieNames    AS ARRAY     ,;
         aSerieColors   AS ARRAY     ,;
         cTitle         AS CHARACTER ,;
         aTitleColor    AS ARRAY     ,;
         nDepth         AS NUMERIC   ,;
         l3DView        AS LOGICAL   ,;
         lShowXValues   AS LOGICAL   ,;
         lShowLegends   AS LOGICAL   ,;
         lNoBorder      AS LOGICAL

   hBitmap := BT_BitmapCreateNew ( nWidth, nHeight, WHITE )
   hDC := BT_CreateDC( hBitmap, BT_HDC_BITMAP, @BTStruct )

   if ! lNoBorder

      DrawLineInBitmap( hDC, torow  ,fromcol  ,torow  ,tocol  ,WHITE)
      DrawLineInBitmap( hDC, torow-1,fromcol+1,torow-1,tocol-1,GRAY )
      DrawLineInBitmap( hDC, torow-1,fromcol  ,fromrow  ,fromcol  ,GRAY )
      DrawLineInBitmap( hDC, torow-2,fromcol+1,fromrow+1,fromcol+1,GRAY )
      DrawLineInBitmap( hDC, fromrow  ,fromcol  ,fromrow  ,tocol-1,GRAY )
      DrawLineInBitmap( hDC, fromrow+1,fromcol+1,fromrow+1,tocol-2,GRAY )
      DrawLineInBitmap( hDC, fromrow  ,tocol  ,torow  ,tocol  ,WHITE)
      DrawLineInBitmap( hDC, fromrow  ,tocol-1,torow-1,tocol-1,GRAY )

   endif

   if HMG_LEN(ALLTRIM(cTitle)) > 0
      DrawTextInBitmap( hDC, fromrow + 10, iif(HMG_LEN(ALLTRIM(cTitle)) * 12 > (tocol - fromcol),fromcol,int(((tocol - fromcol) - (HMG_LEN(ALLTRIM(cTitle)) * 12))/2) + fromcol), ALLTRIM(cTitle), 'Arial', 12, aTitleColor )
      fromrow := fromrow + 40
   endif

   if lShowLegends
      if HMG_LEN(aSerieNames) * 20 > (torow - fromrow)
         msginfo("No space for showing legends")
      else
         torow := torow - (HMG_LEN(aSerieNames) * 20)
      endif
   endif

   DrawRectInBitmap( hDC, fromrow + 10, fromcol + 10, torow - 10, tocol - 10, WHITE )

   if l3DView
      torow := torow - nDepth
   endif

   fromcol := fromcol + 25
   tocol := tocol - 25
   torow := torow - 25
   fromrow := fromrow + 25


   topleftrow := fromrow
   topleftcol := fromcol
   toprightrow := fromrow
   toprightcol := tocol
   bottomrightrow := torow
   bottomrightcol := tocol
   bottomleftrow := torow
   bottomleftcol := fromcol
   middletopcol := fromcol + int(tocol - fromcol) / 2
   middleleftrow := fromrow + int(torow - fromrow) / 2
   middleleftcol := fromcol
   middlebottomcol := fromcol + int(tocol - fromcol) / 2
   middlerightrow := fromrow + int(torow - fromrow) / 2
   middlerightcol := tocol

   torow := torow + 1
   tocol := tocol + 1

   for i := 1 to HMG_LEN(aSerieValues)
      sum := sum + aSerieValues[i]
   next i
   for i := 1 to HMG_LEN(aSerieValues)
      aadd(degrees,Round(aSerieValues[i]/sum * 360,0))
   next i
   sum := 0
   for i := 1 to HMG_LEN(degrees)
      sum := sum + degrees[i]
   next i
   if sum <> 360
      degrees[HMG_LEN(degrees)] := degrees[HMG_LEN(degrees)] + (360 - sum)
   endif

   sum := 0
   for i := 1 to HMG_LEN(degrees)
      sum := sum + degrees[i]
      aadd(cumulative,sum)
   next i

   previos_cumulative := -1

   fromradialrow := middlerightrow
   fromradialcol := middlerightcol
   for i := 1 to HMG_LEN(cumulative)

      if cumulative[i] == previos_cumulative
         loop
      endif

      previos_cumulative := cumulative[i]

      shadowcolor := {iif(aSerieColors[i,1] > 50,aSerieColors[i,1] - 50,0),iif(aSerieColors[i,2] > 50,aSerieColors[i,2] - 50,0),iif(aSerieColors[i,3] > 50,aSerieColors[i,3] - 50,0)}

      do case
         case cumulative[i] <= 45
            toradialcol := middlerightcol
            toradialrow := middlerightrow - Round(cumulative[i] / 45 * (middlerightrow - toprightrow),0)
            DrawPieInBitmap(hDC,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,aSerieColors[i])
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         case cumulative[i] <= 90 .and. cumulative[i] > 45
            toradialrow := toprightrow
            toradialcol := toprightcol - Round((cumulative[i] - 45) / 45 * (toprightcol - middletopcol),0)
            DrawPieInBitmap(hDC,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,aSerieColors[i])
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         case cumulative[i] <= 135 .and. cumulative[i] > 90
            toradialrow := topleftrow
            toradialcol := middletopcol - Round((cumulative[i] - 90) / 45 * (middletopcol - topleftcol),0)
            DrawPieInBitmap(hDC,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,aSerieColors[i])
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         case cumulative[i] <= 180 .and. cumulative[i] > 135
            toradialcol := topleftcol
            toradialrow := topleftrow + Round((cumulative[i] - 135) / 45 * (middleleftrow - topleftrow),0)
            DrawPieInBitmap(hDC,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,aSerieColors[i])
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         case cumulative[i] <= 225 .and. cumulative[i] > 180
            toradialcol := topleftcol
            toradialrow := middleleftrow + Round((cumulative[i] - 180) / 45 * (bottomleftrow - middleleftrow),0)
            if l3DView
               for j := 1 to nDepth
                  DrawArcInBitmap(hDC,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
               next j
            endif
            DrawPieInBitmap(hDC,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,aSerieColors[i])
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         case cumulative[i] <= 270 .and. cumulative[i] > 225
            toradialrow := bottomleftrow
            toradialcol := bottomleftcol + Round((cumulative[i] - 225) / 45 * (middlebottomcol - bottomleftcol),0)
            if l3DView
               for j := 1 to nDepth
                  DrawArcInBitmap(hDC,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
               next j
            endif
            DrawPieInBitmap(hDC,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,aSerieColors[i])
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         case cumulative[i] <= 315 .and. cumulative[i] > 270
            toradialrow := bottomleftrow
            toradialcol := middlebottomcol + Round((cumulative[i] - 270) / 45 * (bottomrightcol - middlebottomcol),0)
            if l3DView
               for j := 1 to nDepth
                  DrawArcInBitmap(hDC,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
               next j
            endif
            DrawPieInBitmap(hDC,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,aSerieColors[i])
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         case cumulative[i] <= 360 .and. cumulative[i] > 315
            toradialcol := bottomrightcol
            toradialrow := bottomrightrow - Round((cumulative[i] - 315) / 45 * (bottomrightrow - middlerightrow),0)
            if l3DView
               for j := 1 to nDepth
                  DrawArcInBitmap(hDC,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
               next j
            endif
            DrawPieInBitmap(hDC,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,aSerieColors[i])
            fromradialrow := toradialrow
            fromradialcol := toradialcol
         endcase
      if l3DView
         DrawLineInBitmap(hDC, middleleftrow, middleleftcol, middleleftrow+nDepth, middleleftcol, BLACK )
         DrawLineInBitmap(hDC, middlerightrow, middlerightcol, middlerightrow+nDepth, middlerightcol, BLACK )
         DrawArcInBitmap(hDC,fromrow + nDepth,fromcol,torow + nDepth,tocol,middleleftrow+nDepth,middleleftcol,middlerightrow+nDepth,middlerightcol )
      endif
   next i
   if lShowLegends
      fromrow := torow + 20 + iif(l3DView,nDepth,0)
      for i := 1 to HMG_LEN(aSerieNames)
         DrawRectInBitmap(hDC, fromrow, fromcol, fromrow + 15, fromcol + 15, aSerieColors[ i ] )
         DrawTextInBitmap( hDC, fromrow, fromcol + 20, aSerieNames[i]+iif(lShowXValues," - "+ALLTRIM(Str(aSerieValues[i],19,2))+" ("+ALLTRIM(Str(degrees[i] / 360 * 100,6,2))+" %)",""), 'Arial', 8, aSerieColors[i] )
         fromrow := fromrow + 20
      next i
   endif

   BT_DeleteDC( BTstruct )

RETURN hBitmap


**************************************************************************************


PROCEDURE DrawWindowBoxInBitmap( hDC, row, col, rowr, colr, nPenWidth )
   BT_DrawRectangle ( hDC, Row, Col, Colr - col, rowr - row, BLACK, nPenWidth )
RETURN


PROCEDURE DrawRectInBitmap( hDC, row, col, row1, col1, aColor, nPenWidth )
   BT_DrawFillRectangle (hDC, Row, Col, col1 - col, row1 - row, aColor, aColor, nPenWidth )
RETURN


PROCEDURE DrawLineInBitmap( hDC, Row1, Col1, Row2, Col2, aColor, nPenWidth )
   BT_DrawLine ( hDC, Row1, Col1, Row2, Col2, aColor, nPenWidth )
RETURN


PROCEDURE DrawTextInBitmap( hDC, Row, Col, cText, cFontName, nFontSize, aColor, nAlign )
   default nAlign := 0
   do case
   case nAlign == 0
      BT_DrawText ( hDC, Row, Col, cText, cFontName, nFontSize, aColor, )
   case nAlign == 1
      BT_DrawText ( hDC, Row, Col, cText, cFontName, nFontSize, aColor, , BT_TEXT_RIGHT )
   case nAlign == 2
      BT_DrawText ( hDC, Row, Col, cText, cFontName, nFontSize, aColor, , BT_TEXT_CENTER )
   endcase
RETURN


PROCEDURE DrawPointInBitmap( hDC, nGraphType, nY, nX, nHigh, aColor )
   IF nGraphType == POINTS
      DrawCircleInBitmap( hDC, nX - nHigh - 3, nY - 3, 8, aColor )
   ELSEIF nGraphType == LINES
      DrawCircleInBitmap( hDC, nX - nHigh - 2, nY - 2, 6, aColor )
   ENDIF
RETURN


PROCEDURE DrawCircleInBitmap( hDC, nCol, nRow, nWidth, aColor, nPenWidth )
   BT_DrawFillEllipse( hDC, nCol, nRow, nWidth, nWidth, aColor, aColor, nPenWidth)
RETURN


PROCEDURE DrawBarInBitmap( hDC, nY, nX, nHigh, nWidth, l3DView, nDeep, aColor )
   LOCAL nColTop, nShadow, nShadow2, nH := nHigh

   nColTop := ClrShadow( RGB(aColor[1],aColor[2],aColor[3]), 20 )  // Tenia 15      Color arriba de la barra
   nShadow := ClrShadow( nColTop, 20 )  // Tenia 15      Color del costado de la barra
   nShadow2 := ClrShadow( nColTop, 40 ) // Añadido para el Gradiente
   nColTop := {GetRed(nColTop),GetGreen(nColTop),GetBlue(nColTop)}
   nShadow := {GetRed(nShadow),GetGreen(nShadow),GetBlue(nShadow)}
   nShadow2 := {GetRed(nShadow2),GetGreen(nShadow2),GetBlue(nShadow2)} // Añadido para el Gradiente
   BT_DrawGradientFillVertical( hDC, nX+nDeep-nHigh, nY, nWidth+1, nHigh-nDeep, aColor, nShadow2 )   // Barra Front con Gradiente
   IF l3DView
      // Lateral
      DrawPolygonInBitmap( hDC,{{nX-1,nY+nWidth+1},{nX+nDeep-nHigh,nY+nWidth+1},;
               {nX-nHigh+1,nY+nWidth+nDeep},{nX-nDeep,nY+nWidth+nDeep},;
               {nX-1,nY+nWidth+1}},nShadow,,nShadow )
      // Superior
      nHigh   := Max( nHigh, nDeep )
      DrawPolygonInBitmap( hDC,{{nX-nHigh+nDeep,nY+1},{nX-nHigh+nDeep,nY+nWidth+1},;
               {nX-nHigh+1,nY+nWidth+nDeep},{nX-nHigh+1,nY+nDeep},;
               {nX-nHigh+nDeep,nY+1}},nColTop,,nColTop )
      // Border
      DrawBoxInBitmap( hDC, nY, nX, nH, nWidth, l3DView, nDeep )
   ENDIF
RETURN


PROCEDURE DrawArcInBitmap(hDC,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth)
   if ValType(penrgb) == "U"
      penrgb = BLACK
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   BT_DrawArc (hDC, row, col, row1, col1, rowr, colr, rowr1, colr1, penrgb, penwidth)
RETURN


PROCEDURE DrawPieInBitmap(hDC,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth,fillrgb)
   if ValType(penrgb) == "U"
      penrgb = BLACK
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   if ValType(fillrgb) == "U"
      fillrgb := WHITE
   endif
   BT_DrawPie (hDC, row, col, row1, col1, rowr, colr, rowr1, colr1, penrgb, penwidth, fillrgb)
RETURN


PROCEDURE DrawPolygonInBitmap( hDC, apoints, penrgb, penwidth, fillrgb )
   LOCAL xarr := {}
   LOCAL yarr := {}
   LOCAL x
   if ValType(penrgb) == "U"
      penrgb = BLACK
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   if ValType(fillrgb) == "U"
      fillrgb := WHITE
   endif
   for x := 1 to HMG_LEN(apoints)
       aadd(xarr,apoints[x,2])
       aadd(yarr,apoints[x,1])
   next x
   BT_DrawPolygon ( hDC, yarr, xarr, penrgb, penwidth, fillrgb )
RETURN


PROCEDURE DrawBoxInBitmap( hDC, nY, nX, nHigh, nWidth, l3DView, nDeep )

   // Set Border
   DrawLineInBitmap( hDC, nX, nY        , nX-nHigh+nDeep    , nY       , BLACK )  // LEFT
   DrawLineInBitmap( hDC, nX, nY+nWidth , nX-nHigh+nDeep    , nY+nWidth, BLACK )  // RIGHT
   DrawLineInBitmap( hDC, nX-nHigh+nDeep, nY, nX-nHigh+nDeep, nY+nWidth, BLACK )  // Top
   DrawLineInBitmap( hDC, nX, nY, nX, nY+nWidth, BLACK )                          // Bottom
   IF l3DView
      // Set shadow
      DrawLineInBitmap( hDC, nX-nHigh+nDeep, nY+nWidth, nX-nHigh, nY+nDeep+nWidth, BLACK )
      DrawLineInBitmap( hDC, nX, nY+nWidth, nX-nDeep, nY+nWidth+nDeep, BLACK )
      IF nHigh > 0
         DrawLineInBitmap( hDC, nX-nDeep, nY+nWidth+nDeep, nX-nHigh, nY+nWidth+nDeep, BLACK )
         DrawLineInBitmap( hDC, nX-nHigh, nY+nDeep, nX-nHigh , nY+nWidth+nDeep, BLACK )
         DrawLineInBitmap( hDC, nX-nHigh+nDeep, nY, nX-nHigh, nY+nDeep, BLACK )
      ELSE
         DrawLineInBitmap( hDC, nX-nDeep, nY+nWidth+nDeep, nX-nHigh+1, nY+nWidth+nDeep, BLACK )
         DrawLineInBitmap( hDC, nX, nY, nX-nDeep, nY+nDeep, BLACK )
      ENDIF
   ENDIF

RETURN


FUNCTION ClrShadow( nColor, nFactor )
   LOCAL aHSL, aRGB

   aHSL := RGB2HSL( GetRed(nColor), GetGreen(nColor), GetBlue(nColor) )
   aHSL[3] -= nFactor
   aRGB := HSL2RGB( aHSL[1], aHSL[2], aHSL[3] )

RETURN RGB( aRGB[1], aRGB[2], aRGB[3] )


/*-----------------------------------*/

#define PARAM_IS_3_NUMBERS

#ifdef PARAM_IS_3_NUMBERS

/*-----------------------------------*/
// 3 params numerics
/*-----------------------------------*/

FUNCTION RGB2HSL( nR, nG, nB )

   LOCAL nMax, nMin, nDelta
   LOCAL nH, nS, nL

   nR := nR / 255
   nG := nG / 255
   nB := nB / 255
   nMax := Max( nR, Max( nG, nB ) )
   nMin := Min( nR, Min( nG, nB ) )
   nDelta := nMax - nMin

#else  // PARAM_IS_ARRAY

/*-----------------------------------*/
// 1 param array rgb
/*-----------------------------------*/

FUNCTION RGB2HSL( aRGB )

   LOCAL nMax, nMin, nDelta
   LOCAL nH, nS, nL, nR, nG, nB

   nR := aRGB[1] / 255
   nG := aRGB[2] / 255
   nB := aRGB[3] / 255
   nMax := Max( nR, Max( nG, nB ) )
   nMin := Min( nR, Min( nG, nB ) )
   nDelta := nMax - nMin

#endif

  // Calcular nH hue
   IF nDelta == 0
      nH := 0

   // Red = nMax
   ELSEIF ( nMax == nR )
      nH := (( nG - nB) / nDelta) % 6

   // Green = nMax
   ELSEIF ( nMax == nG )
      nH := (nB - nR) / nDelta + 2;

   // Blue = nMax
   ELSE
      nH := (nR - nG) / nDelta + 4;

   ENDIF

   nH := Int( nH * 60 )

   // Cambiar hues negativos en positivos. 360°
   IF ( nH < 0 )
      nH += 360
   ENDIF

   // Calcular nL lightness
   nL := ( nMax + nMin ) / 2

   // Calcular nS saturation
   nS := iif( nDelta == 0, 0, nDelta / ( 1 - Abs( 2 * nL - 1 )) )

   nS := nS * 100
   nL := nL * 100

   RETURN { nH, nS, nL }

/*-----------------------------------*/

#ifdef PARAM_IS_3_NUMBERS

/*-----------------------------------*/
// 3 params numerics
/*-----------------------------------*/

FUNCTION HSL2RGB( nH, nS, nL )

   LOCAL nR := 0, nG := 0, nB := 0, c, x, m

   // c = is color intensity, chroma
   // x = the second largest component (first is chroma)
   // m = the amount to add to each channel to match the lightness

   nS /= 100
   nL /= 100

#else  // PARAM_IS_ARRAY

/*-----------------------------------*/
// 1 param array rgb
/*-----------------------------------*/

FUNCTION HSL2RGB( aHSL )

   LOCAL nR := 0, nG := 0, nB := 0, nH, nS, nL, c, x, m
   /*
   c = es la intensida del color, chroma.
   x = segundo componente mayor, primero es chroma.
   m = cantidad a agregar a cada canal para conseguir lightness
   */

   nH := aHSL[1]
   nS := aHSL[2] / 100
   nL := aHSL[3] / 100

#endif


   c := ( 1 - Abs( 2 * nL - 1 ) ) * nS
   x := c * ( 1 - Abs( ( nH / 60 ) % 2 - 1 ) )
   m := nL - c / 2

   IF (0 <= nH .And. nH < 60)
      nR := c
      nG := x
      nB := 0
   ELSEIF (60 <= nH .And. nH < 120)
      nR := x
      nG := c
      nB := 0
   ELSEIF (120 <= nH .And. nH < 180)
      nR := 0
      nG := c
      nB := x
   ELSEIF (180 <= nH .And. nH < 240)
      nR := 0
      nG := x
      nB := c
   ELSEIF (240 <= nH .And. nH < 300)
      nR := x
      nG := 0
      nB := c
   ELSEIF (300 <= nH .And. nH < 360)
      nR := c
      nG := 0
      nB := x
   ENDIF

   nR := Int( ( nR + m ) * 255 )
   nG := Int( ( nG + m ) * 255 )
   nB := Int( ( nB + m ) * 255 )

   RETURN { nR, nG, nB }

/*-----------------------------------*/

STATIC FUNCTION nMax(aSerieValues)
   LOCAL nI, nMax := 0

   FOR nI :=1 TO HMG_LEN( aSerieValues )
      nMax := Max( HMG_LEN(aSerieValues[nI]), nMax )
   NEXT nI

RETURN( nMax )


STATIC FUNCTION DetMaxVal(nNum)
   LOCAL nE, nMax, nMan, nVal, nOffset

   nE:=9
   nVal:=0
   nNum:=Abs(nNum)

   DO WHILE .T.

      nMax := 10**nE

      IF Int(nNum/nMax)>0

         nMan:=(nNum/nMax)-Int(nNum/nMax)
         nOffset:=1
         nOffset:=IF(nMan<=.75,.75,nOffset)
         nOffset:=IF(nMan<=.50,.50,nOffset)
         nOffset:=IF(nMan<=.25,.25,nOffset)
         nOffset:=IF(nMan<=.00,.00,nOffset)
         nVal := (Int(nNum/nMax)+nOffset)*nMax
         EXIT

      ENDIF

      nE--

   ENDDO

RETURN (nVal)


