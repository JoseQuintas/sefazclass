
/*
File:    h_graph.prg
Author:     Grigory Filatov / Rathinagiri (Pie Graph)
Description:
Status:     Public Domain
Notes:      Support function for DRAW commands

Based on works of:

      Alfredo Arteaga 14/10/2001 original idea
      Alfredo Arteaga TGRAPH 2, 12/03/2002
*/
MEMVAR _HMG_SYSDATA
#include "hmg.ch"

function drawline(window,row,col,row1,col1,penrgb,penwidth)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i]

   if formhandle > 0

      if ValType(penrgb) == "U"
         penrgb = {0,0,0}
      endif

      if ValType(penwidth) == "U"
         penwidth = 1
      endif

      linedraw( formhandle,row,col,row1,col1,penrgb,penwidth)

      aadd ( _HMG_SYSDATA [ 102 ] [i] , { || linedraw( formhandle,row,col,row1,col1,penrgb,penwidth) } )

   endif

return nil

function drawrect(window,row,col,row1,col1,penrgb,penwidth,fillrgb)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i] , fill

if formhandle > 0

   if ValType(penrgb) == "U"
      penrgb = {0,0,0}
   endif

   if ValType(penwidth) == "U"
      penwidth = 1
   endif

   if ValType(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif

   rectdraw( FormHandle,row,col,row1,col1,penrgb,penwidth,fillrgb,fill)

   aadd ( _HMG_SYSDATA [ 102 ] [i] , { || rectdraw( FormHandle,row,col,row1,col1,penrgb,penwidth,fillrgb,fill) } )

endif
return nil

function drawroundrect(window,row,col,row1,col1,width,height,penrgb,penwidth,fillrgb)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i] , fill

if formhandle > 0
   if ValType(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   if ValType(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif
   roundrectdraw( FormHandle,row,col,row1,col1,width,height,penrgb,penwidth,fillrgb,fill)

   aadd ( _HMG_SYSDATA [ 102 ] [i] , { || roundrectdraw( FormHandle,row,col,row1,col1,width,height,penrgb,penwidth,fillrgb,fill) } )

endif
return nil

function drawellipse(window,row,col,row1,col1,penrgb,penwidth,fillrgb)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i] , fill

if formhandle > 0
   if ValType(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   if ValType(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif
   ellipsedraw( FormHandle ,row,col,row1,col1,penrgb,penwidth,fillrgb,fill)

   aadd ( _HMG_SYSDATA [ 102 ] [i] , { || ellipsedraw( FormHandle ,row,col,row1,col1,penrgb,penwidth,fillrgb,fill) } )

endif
return nil

function drawarc(window,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i]

if formhandle > 0
   if ValType(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   arcdraw( FormHandle ,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth)
   aadd ( _HMG_SYSDATA [ 102 ] [i] , { || arcdraw( FormHandle ,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth) } )

endif

return nil

function drawpie(window,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth,fillrgb)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i] , fill

if formhandle > 0
   if ValType(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   if ValType(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif
   piedraw( FormHandle,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth,fillrgb,fill)

   aadd ( _HMG_SYSDATA [ 102 ] [i] , { || piedraw( FormHandle,row,col,row1,col1,rowr,colr,rowr1,colr1,penrgb,penwidth,fillrgb,fill) } )

endif
return nil

function drawpolygon(window,apoints,penrgb,penwidth,fillrgb)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i] , fill
local xarr := {}
local yarr := {}
local x

if formhandle > 0
   if ValType(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   if ValType(fillrgb) == "U"
      fillrgb := {255,255,255}
      fill := .f.
   else
      fill := .t.
   endif
   for x := 1 to HMG_LEN(apoints)
       aadd(xarr,apoints[x,2])
       aadd(yarr,apoints[x,1])
   next x
   polygondraw(FormHandle,xarr,yarr,penrgb,penwidth,fillrgb,fill)
   aadd( _HMG_SYSDATA [ 102 ][i] , {||polygondraw(FormHandle,xarr,yarr,penrgb,penwidth,fillrgb,fill)})
endif
return nil

function drawpolybezier(window,apoints,penrgb,penwidth)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i]
local xarr := {}
local yarr := {}
local x

if formhandle > 0
   if ValType(penrgb) == "U"
      penrgb = {0,0,0}
   endif
   if ValType(penwidth) == "U"
      penwidth = 1
   endif
   for x := 1 to HMG_LEN(apoints)
       aadd(xarr,apoints[x,2])
       aadd(yarr,apoints[x,1])
   next x
   polybezierdraw(FormHandle,xarr,yarr,penrgb,penwidth)
   aadd( _HMG_SYSDATA [ 102 ][i] , {||polybezierdraw(FormHandle,xarr,yarr,penrgb,penwidth)})
endif
return nil

function erasewindow(window)
Local i := GetFormIndex ( Window )
Local FormHandle := _HMG_SYSDATA [ 67  ] [i]

   if formhandle > 0

      if _HMG_SYSDATA [  65 ] [i] == .F.

         If ValType ( _HMG_SYSDATA [ 102 ] [i] ) == 'A'

            asize(_HMG_SYSDATA [ 102 ][i],0)
            redrawwindow(formhandle)

         endif

      endif

   endif

return nil

Procedure GraphShow(parent,nTop,nLeft,nBottom,nRight,nHeight,nWidth,aData,cTitle,aYVals,nBarD,nWideB,nSep,nXRanges,;
   l3D,lGrid,lxGrid,lyGrid,lxVal,lyVal,lLegends,aSeries,aColors,nType,lViewVal,cPicture , nLegendWindth , lNoborder )
   LOCAL nI, nJ, nPos, nMax, nMin, nMaxBar, nDeep
   LOCAL nRange, nResH, nResV,  nWide, aPoint, cName
   LOCAL nXMax, nXMin, nHigh, nRel, nZero, nRPos, nRNeg

   DEFAULT cTitle   := ""
   DEFAULT nSep     := 0
   DEFAULT cPicture := "999,999.99"
   DEFAULT nLegendWindth := 50

   If    ( HMG_LEN (aSeries) != HMG_LEN (aData) ) .or. ;
      ( HMG_LEN (aSeries) != HMG_LEN (aColors) )

      MsgHMGError("DRAW GRAPH: 'Series' / 'SerieNames' / 'Colors' arrays size mismatch. Program terminated","HMG Error")
   EndIf

   _HMG_SYSDATA [ 108 ] [ GetFormIndex (parent) ] := { nTop , nLeft , nRight - nLeft , nBottom - nTop }

   If _IsControlDefined ( 'Graph_Title', Parent )
      _ReleaseControl ( 'Graph_Title', Parent )
   EndIf

   For ni := 1 To 16
      cName := "Ser_Name_"+LTrim(Str(ni))
      If _IsControlDefined ( cName, Parent )
         _ReleaseControl ( cName , Parent )
      EndIf
   Next

   For ni := 0 To 15
      cName := "xPVal_Name_"+LTrim(Str(ni))
      If _IsControlDefined ( cName, Parent )
         _ReleaseControl ( cName , Parent )
      EndIf
   Next

   For ni := 0 To 15
      cName := "xNVal_Name_"+LTrim(Str(ni))
      If _IsControlDefined ( cName, Parent )
         _ReleaseControl ( cName , Parent )
      EndIf
   Next

   For ni := 1 To 16
      cName := "yVal_Name_"+LTrim(Str(ni))
      If _IsControlDefined ( cName, Parent )
         _ReleaseControl ( cName , Parent )
      EndIf
   Next

   FOR nI := 1 TO HMG_LEN(aData[1])
      FOR nJ := 1 TO HMG_LEN(aSeries)
         cName := "Data_Name_"+LTrim(Str(nI))+LTrim(Str(nJ))
         If _IsControlDefined ( cName, Parent )
            _ReleaseControl ( cName , Parent )
         EndIf
      Next nJ
   Next nI

   IF lGrid
      lxGrid := lyGrid := .T.
   ENDIF
   IF nBottom <> NIL .AND. nRight <> NIL
      nHeight := nBottom - nTop / 2
      nWidth  := nRight - nLeft / 2
      nBottom -= IF(lyVal, 42, 32)
      nRight  -= IF(lLegends, 32 + nLegendWindth , 32)
   ENDIF
   nTop    += 1 + IF(Empty(cTitle), 30, 44)             // Top gap
   nLeft   += 1 + IF(lxVal, 80 + nBarD, 30 + nBarD)     // LEFT
   DEFAULT nBottom := nHeight -2 - IF(lyVal, 40, 30)    // Bottom
   DEFAULT nRight  := nWidth - 2 - IF(lLegends, 30 + nLegendWindth , 30) // RIGHT

   l3D     := IF( nType == POINTS, .F., l3D )
   nDeep   := IF( l3D, nBarD, 1 )
   nMaxBar := nBottom - nTop - nDeep - 5
   nResH   := nResV := 1
   nWide   := ( nRight - nLeft )*nResH / ( nMax(aData) + 1 ) * nResH

   // Graph area
   //
   IF ! lNoborder
      DrawWindowBoxIn( parent, Max(1,nTop-44), Max(1,nLeft-80-nBarD), nHeight-1, nWidth-1 )
   ENDIF

   // Back area
   //
   IF l3D
      drawrect( parent, nTop+1, nLeft, nBottom-nDeep, nRight, WHITE, , WHITE )
   ELSE
      drawrect( parent, nTop-5, nLeft, nBottom, nRight, , , WHITE )
   ENDIF

   IF l3D
         // Bottom area
         FOR nI := 1 TO nDeep+1
             DrawLine( parent, nBottom-nI, nLeft-nDeep+nI, nBottom-nI, nRight-nDeep+nI, WHITE )
         NEXT nI

         // Lateral
         FOR nI := 1 TO nDeep
             DrawLine( parent, nTop+nI, nLeft-nI, nBottom-nDeep+nI, nLeft-nI, {192, 192, 192} )
         NEXT nI

         // Graph borders
         FOR nI := 1 TO nDeep+1
             DrawLine( parent, nBottom-nI     ,nLeft-nDeep+nI-1 ,nBottom-nI     ,nLeft-nDeep+nI  ,GRAY )
             DrawLine( parent, nBottom-nI     ,nRight-nDeep+nI-1,nBottom-nI     ,nRight-nDeep+nI ,BLACK )
             DrawLine( parent, nTop+nDeep-nI+1,nLeft-nDeep+nI-1 ,nTop+nDeep-nI+1,nLeft-nDeep+nI  ,BLACK )
             DrawLine( parent, nTop+nDeep-nI+1,nLeft-nDeep+nI-3 ,nTop+nDeep-nI+1,nLeft-nDeep+nI-2,BLACK )
         NEXT nI

         FOR nI=1 TO nDeep+2
             DrawLine( parent, nTop+nDeep-nI+1,nLeft-nDeep+nI-3,nTop+nDeep-nI+1,nLeft-nDeep+nI-2 ,BLACK )
             DrawLine( parent, nBottom+ 2-nI+1,nRight-nDeep+nI ,nBottom+ 2-nI+1,nRight-nDeep+nI-2,BLACK )
         NEXT nI

         DrawLine( parent, nTop         ,nLeft        ,nTop           ,nRight       ,BLACK )
         DrawLine( parent, nTop- 2      ,nLeft        ,nTop- 2        ,nRight+ 2    ,BLACK )
         DrawLine( parent, nTop         ,nLeft        ,nBottom-nDeep  ,nLeft        ,GRAY  )
         DrawLine( parent, nTop+nDeep   ,nLeft-nDeep  ,nBottom        ,nLeft-nDeep  ,BLACK )
         DrawLine( parent, nTop+nDeep   ,nLeft-nDeep-2,nBottom+ 2     ,nLeft-nDeep-2,BLACK )
         DrawLine( parent, nTop         ,nRight       ,nBottom-nDeep  ,nRight       ,BLACK )
         DrawLine( parent, nTop- 2      ,nRight+ 2    ,nBottom-nDeep+2,nRight+ 2    ,BLACK )
         DrawLine( parent, nBottom-nDeep,nLeft        ,nBottom-nDeep  ,nRight       ,GRAY  )
         DrawLine( parent, nBottom      ,nLeft-nDeep  ,nBottom        ,nRight-nDeep ,BLACK )
         DrawLine( parent, nBottom+ 2   ,nLeft-nDeep-2,nBottom+ 2     ,nRight-nDeep ,BLACK )
   ENDIF


   // Graph info
   //

   IF !Empty(cTitle)
      @ nTop-30*nResV, nLeft LABEL Graph_Title OF &parent ;
      WIDTH nRight - nLeft + nLegendWindth - 50 ;
      HEIGHT 18 ;
      VALUE cTitle  ;
      FONTCOLOR RED ;
      FONT "Arial" SIZE 12 ;
      BOLD CENTERALIGN TRANSPARENT
   ENDIF


   // Legends
   //
   IF lLegends
      nPos := nTop
      FOR nI := 1 TO HMG_LEN(aSeries)
         DrawBar( parent, nRight+(8*nResH), nPos+(9*nResV), 8*nResH, 7*nResV, l3D, 1, aColors[nI] )
         cName := "Ser_Name_"+LTrim( Str( nI ) )
         @ nPos, nRight+(20*nResH) LABEL &cName OF &parent ;
      VALUE aSeries[nI] AUTOSIZE ;
      FONTCOLOR BLACK ;
      FONT "Arial" SIZE 8 TRANSPARENT
         nPos += 18*nResV
      NEXT nI
   ENDIF

   // Max, Min values
   nMax := 0
   FOR nJ := 1 TO HMG_LEN(aSeries)
      FOR nI :=1 TO HMG_LEN(aData[nJ])
         nMax := Max( aData[nJ][nI], nMax )
      NEXT nI
   NEXT nJ
   nMin := 0
   FOR nJ := 1 TO HMG_LEN(aSeries)
      FOR nI :=1 TO HMG_LEN(aData[nJ])
         nMin := Min( aData[nJ][nI], nMin )
      NEXT nI
   NEXT nJ

   nXMax := IF( nMax > 0, DetMaxVal( nMax ), 0 )
   nXMin := IF( nMin < 0, DetMaxVal( nMin ), 0 )
   nHigh := nXMax + nXMin
   nMax  := Max( nXMax, nXMin )

   nRel  := ( nMaxBar / nHigh )
   nMaxBar := nMax * nRel



   nZero := nTop + (nMax*nRel) + nDeep + 5    // Zero pos
   IF l3D
      FOR nI := 1 TO nDeep+1
          DrawLine( parent, nZero-nI+1, nLeft-nDeep+nI   , nZero-nI+1, nRight-nDeep+nI, {192, 192, 192} )
      NEXT nI
      FOR nI := 1 TO nDeep+1
          DrawLine( parent, nZero-nI+1, nLeft-nDeep+nI-1 , nZero-nI+1, nLeft -nDeep+nI, GRAY )
          DrawLine( parent, nZero-nI+1, nRight-nDeep+nI-1, nZero-nI+1, nRight-nDeep+nI, BLACK )
      NEXT nI
      DrawLine( parent, nZero-nDeep, nLeft, nZero-nDeep, nRight, GRAY )
   ENDIF

   aPoint := Array( HMG_LEN( aSeries ), HMG_LEN( aData[1] ), 2 )
   nRange := nMax / nXRanges

   // xLabels
   nRPos := nRNeg := nZero - nDeep
   FOR nI := 0 TO nXRanges
      IF lxVal
         IF nRange*nI <= nXMax
            cName := "xPVal_Name_"+LTrim(Str(nI))
            @ nRPos, nLeft-nDeep-70 LABEL &cName OF &parent ;
         VALUE Transform(nRange*nI, cPicture) ;
         WIDTH 60 ;
         HEIGHT 14 ;
         FONTCOLOR BLUE FONT "Arial" SIZE 8 TRANSPARENT RIGHTALIGN
         ENDIF
         IF nRange*(-nI) >= nXMin*(-1)
            cName := "xNVal_Name_"+LTrim(Str(nI))
            @ nRNeg, nLeft-nDeep-70 LABEL &cName OF &parent ;
         VALUE Transform(nRange*-nI, cPicture) ;
         WIDTH 60 ;
         HEIGHT 14 ;
         FONTCOLOR BLUE FONT "Arial" SIZE 8 TRANSPARENT RIGHTALIGN
         ENDIF
      ENDIF

   UpdateGraph ( GetFormHandle (parent) )

      IF lxGrid
         IF nRange*nI <= nXMax
            IF l3D
               FOR nJ := 0 TO nDeep + 1
                  DrawLine( parent, nRPos + nJ, nLeft - nJ - 1, nRPos + nJ, nLeft - nJ, BLACK )
               NEXT nJ
            ENDIF
            DrawLine( parent, nRPos, nLeft, nRPos, nRight, BLACK )
         ENDIF
         IF nRange*-nI >= nXMin*-1
            IF l3D
               FOR nJ := 0 TO nDeep + 1
                  DrawLine( parent, nRNeg + nJ, nLeft - nJ - 1, nRNeg + nJ, nLeft - nJ, BLACK )
               NEXT nJ
            ENDIF
            DrawLine( parent, nRNeg, nLeft, nRNeg, nRight, BLACK )
         ENDIF
      ENDIF
      nRPos -= ( nMaxBar / nXRanges )
      nRNeg += ( nMaxBar / nXRanges )
   NEXT nI

   IF lYGrid
      nPos:=IF(l3D, nTop, nTop-5 )
      nI  := nLeft + nWide
      FOR nJ := 1 TO nMax(aData)
         Drawline( parent, nBottom-nDeep, nI, nPos, nI, {100,100,100} )
         Drawline( parent, nBottom, nI-nDeep, nBottom-nDeep, nI, {100,100,100} )
         nI += nWide
      NEXT
   ENDIF

   DO WHILE .T.    // Bar adjust
      nPos = nLeft + ( nWide / 2 )
      nPos += ( nWide + nSep ) * ( HMG_LEN(aSeries) + 1 ) * HMG_LEN(aData[1])
      IF nPos > nRight
         nWide--
      ELSE
         EXIT
      ENDIF
   ENDDO

   nMin := nMax / nMaxBar

   nPos := nLeft + ( ( nWide + nSep ) / 2 )            // first point graph
   // nRange := ( ( nWide + nSep ) * HMG_LEN(aSeries) ) / 2  //  Variable 'NRANGE' is assigned but not used in function

   IF lyVal .AND. HMG_LEN(aYVals) > 0                // Show yLabels
      nWideB  := ( nRight - nLeft ) / ( nMax(aData) + 1 )
      nI := nLeft + nWideB
      FOR nJ := 1 TO nMax(aData)
         cName := "yVal_Name_"+LTrim(Str(nJ))
         @ nBottom + 8, nI - nDeep - IF(l3D, 0, 8) LABEL &cName OF &parent ;
      VALUE aYVals[nJ] AUTOSIZE ;
      FONTCOLOR BLUE ;
      FONT "Arial" SIZE 8 TRANSPARENT
         nI += nWideB
      NEXT
   ENDIF



   // Bars
   //

   IF nType == BARS
      if nMin <> 0
         nPos := nLeft + ( ( nWide + nSep ) / 2 )
         FOR nI=1 TO HMG_LEN(aData[1])
            FOR nJ=1 TO HMG_LEN(aSeries)
               DrawBar( parent, nPos, nZero, aData[nJ,nI] / nMin + nDeep, nWide, l3D, nDeep, aColors[nJ] )
               nPos += nWide+nSep
            NEXT nJ
            nPos += nWide+nSep
         NEXT nI
      endif
   ENDIF

   // Lines
   //
   IF nType == LINES
   if nMin <> 0
      nWideB  := ( nRight - nLeft ) / ( nMax(aData) + 1 )
      nPos := nLeft + nWideB
      FOR nI := 1 TO HMG_LEN(aData[1])
         FOR nJ=1 TO HMG_LEN(aSeries)
            IF !l3D
               DrawPoint( parent, nType, nPos, nZero, aData[nJ,nI] / nMin + nDeep, aColors[nJ] )
            ENDIF
            aPoint[nJ,nI,2] := nPos
            aPoint[nJ,nI,1] := nZero - ( aData[nJ,nI] / nMin + nDeep )
         NEXT nJ
         nPos += nWideB
      NEXT nI

      FOR nI := 1 TO HMG_LEN(aData[1])-1
         FOR nJ := 1 TO HMG_LEN(aSeries)
            IF l3D
               drawpolygon(parent,{{aPoint[nJ,nI,1],aPoint[nJ,nI,2]},{aPoint[nJ,nI+1,1],aPoint[nJ,nI+1,2]}, ;
                           {aPoint[nJ,nI+1,1]-nDeep,aPoint[nJ,nI+1,2]+nDeep},{aPoint[nJ,nI,1]-nDeep,aPoint[nJ,nI,2]+nDeep}, ;
                           {aPoint[nJ,nI,1],aPoint[nJ,nI,2]}},,,aColors[nJ])
            ELSE
               DrawLine(parent,aPoint[nJ,nI,1],aPoint[nJ,nI,2],aPoint[nJ,nI+1,1],aPoint[nJ,nI+1,2],aColors[nJ])
            ENDIF
         NEXT nI
      NEXT nI

   endif
   ENDIF

   // Points
   //
   IF nType == POINTS
      if nMin <> 0
      nWideB := ( nRight - nLeft ) / ( nMax(aData) + 1 )
      nPos := nLeft + nWideB
      FOR nI := 1 TO HMG_LEN(aData[1])
         FOR nJ=1 TO HMG_LEN(aSeries)
            DrawPoint( parent, nType, nPos, nZero, aData[nJ,nI] / nMin + nDeep, aColors[nJ] )
            aPoint[nJ,nI,2] := nPos
            aPoint[nJ,nI,1] := nZero - aData[nJ,nI] / nMin
         NEXT nJ
         nPos += nWideB
      NEXT nI
   ENDIF

   IF lViewVal
      IF nType == BARS
         nPos := nLeft + nWide + ( (nWide+nSep) * ( HMG_LEN(aSeries) / 2 ) )
      ELSE
         nWideB := ( nRight - nLeft ) / ( nMax(aData) + 1 )
         nPos := nLeft + nWideB
      ENDIF
      FOR nI := 1 TO HMG_LEN(aData[1])
         FOR nJ := 1 TO HMG_LEN(aSeries)
            cName := "Data_Name_"+LTrim(Str(nI))+LTrim(Str(nJ))
            @ nZero - ( aData[nJ,nI] / nMin + nDeep ), IF(nType == BARS, nPos - IF(l3D, 8, 10), nPos + 10) ;
         LABEL &cName OF &parent ;
         VALUE Transform(aData[nJ,nI], cPicture) AUTOSIZE ;
         FONT "Arial" SIZE 8 BOLD TRANSPARENT
            nPos+=IF( nType == BARS, nWide + nSep, 0)
         NEXT nJ
         IF nType == BARS
            nPos += nWide + nSep
         ELSE
            nPos += nWideB
         ENDIF
      NEXT nI
   ENDIF

   IF l3D
      DrawLine( parent, nZero, nLeft-nDeep, nZero, nRight-nDeep, BLACK )
   ELSE
      IF nXMax<>0 .AND. nXMin<>0
         DrawLine( parent, nZero-1, nLeft-2, nZero-1, nRight, RED )
      ENDIF

   endif
   ENDIF


RETURN


STAT PROC DrawBar( parent, nY, nX, nHigh, nWidth, l3D, nDeep, aColor )
   LOCAL nI, nColTop, nShadow, nH := nHigh

   nColTop := ClrShadow( RGB(aColor[1],aColor[2],aColor[3]), 15 )
   nShadow := ClrShadow( nColTop, 15 )
   nColTop := {GetRed(nColTop),GetGreen(nColTop),GetBlue(nColTop)}
   nShadow := {GetRed(nShadow),GetGreen(nShadow),GetBlue(nShadow)}

   FOR nI=1 TO nWidth
      DrawLine( parent, nX, nY+nI, nX+nDeep-nHigh, nY+nI, aColor )  // front
   NEXT nI

   IF l3D
      // Lateral
      drawpolygon( parent,{{nX-1,nY+nWidth+1},{nX+nDeep-nHigh,nY+nWidth+1},;
                   {nX-nHigh+1,nY+nWidth+nDeep},{nX-nDeep,nY+nWidth+nDeep},;
                   {nX-1,nY+nWidth+1}},nShadow,,nShadow )
      // Superior
      nHigh   := Max( nHigh, nDeep )
      drawpolygon( parent,{{nX-nHigh+nDeep,nY+1},{nX-nHigh+nDeep,nY+nWidth+1},;
                   {nX-nHigh+1,nY+nWidth+nDeep},{nX-nHigh+1,nY+nDeep},;
                   {nX-nHigh+nDeep,nY+1}},nColTop,,nColTop )
      // Border
      DrawBox( parent, nY, nX, nH, nWidth, l3D, nDeep )
   ENDIF

RETURN

STATIC PROC DrawBox( parent, nY, nX, nHigh, nWidth, l3D, nDeep )

   // Set Border
   DrawLine( parent, nX, nY        , nX-nHigh+nDeep    , nY       , BLACK )  // LEFT
   DrawLine( parent, nX, nY+nWidth , nX-nHigh+nDeep    , nY+nWidth, BLACK )  // RIGHT
   DrawLine( parent, nX-nHigh+nDeep, nY, nX-nHigh+nDeep, nY+nWidth, BLACK )  // Top
   DrawLine( parent, nX, nY, nX, nY+nWidth, BLACK )                          // Bottom
   IF l3D
      // Set shadow
      DrawLine( parent, nX-nHigh+nDeep, nY+nWidth, nX-nHigh, nY+nDeep+nWidth, BLACK )
      DrawLine( parent, nX, nY+nWidth, nX-nDeep, nY+nWidth+nDeep, BLACK )
      IF nHigh > 0
         DrawLine( parent, nX-nDeep, nY+nWidth+nDeep, nX-nHigh, nY+nWidth+nDeep, BLACK )
         DrawLine( parent, nX-nHigh, nY+nDeep, nX-nHigh , nY+nWidth+nDeep, BLACK )
         DrawLine( parent, nX-nHigh+nDeep, nY, nX-nHigh, nY+nDeep, BLACK )
      ELSE
         DrawLine( parent, nX-nDeep, nY+nWidth+nDeep, nX-nHigh+1, nY+nWidth+nDeep, BLACK )
         DrawLine( parent, nX, nY, nX-nDeep, nY+nDeep, BLACK )
      ENDIF
   ENDIF

RETURN


STATIC PROC DrawPoint( parent, nType, nY, nX, nHigh, aColor )

   IF nType == POINTS

         Circle( parent, nX - nHigh - 3, nY - 3, 8, aColor )

   ELSEIF nType == LINES

      Circle( parent, nX - nHigh - 2, nY - 2, 6, aColor )

   ENDIF

RETURN


STATIC PROC Circle( window, nCol, nRow, nWidth, aColor )
   drawellipse(window, nCol, nRow, nCol + nWidth - 1, nRow + nWidth - 1, , , aColor)
RETURN


STATIC FUNCTION nMax(aData)
   LOCAL nI, nMax := 0

   FOR nI :=1 TO HMG_LEN( aData )
      nMax := Max( HMG_LEN(aData[nI]), nMax )
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


STATIC FUNCTION ClrShadow( nColor, nFactor )
   LOCAL aHSL, aRGB

   aHSL := RGB2HSL( GetRed(nColor), GetGreen(nColor), GetBlue(nColor) )
   aHSL[3] -= nFactor
   aRGB := HSL2RGB( aHSL[1], aHSL[2], aHSL[3] )

RETURN RGB( aRGB[1], aRGB[2], aRGB[3] )


STATIC FUNCTION RGB2HSL( nR, nG, nB )
   LOCAL nMax, nMin
   LOCAL nH, nS, nL

   IF nR < 0
      nR := Abs( nR )
      nG := GetGreen( nR )
      nB := GetBlue( nR )
      nR := GetRed( nR )
   ENDIF

   nR := nR / 255
   nG := nG / 255
   nB := nB / 255
   nMax := Max( nR, Max( nG, nB ) )
   nMin := Min( nR, Min( nG, nB ) )
   nL := ( nMax + nMin ) / 2

   IF nMax = nMin
      nH := 0
      nS := 0
   ELSE
      IF nL < 0.5
         nS := ( nMax - nMin ) / ( nMax + nMin )
      ELSE
         nS := ( nMax - nMin ) / ( 2.0 - nMax - nMin )
      ENDIF
      DO CASE
         CASE nR = nMax
            nH := ( nG - nB ) / ( nMax - nMin )
         CASE nG = nMax
            nH := 2.0 + ( nB - nR ) / ( nMax - nMin )
         CASE nB = nMax
            nH := 4.0 + ( nR - nG ) / ( nMax - nMin )
      ENDCASE
   ENDIF

   nH := Int( (nH * 239) / 6 )
   IF nH < 0 ; nH += 240 ; ENDIF
   nS := Int( nS * 239 )
   nL := Int( nL * 239 )

RETURN { nH, nS, nL }


STATIC FUNCTION HSL2RGB( nH, nS, nL )
   LOCAL nFor
   LOCAL nR, nG, nB
   LOCAL nTmp1, nTmp2, aTmp3 := { 0, 0, 0 }

   nH /= 239
   nS /= 239
   nL /= 239
   IF nS == 0
      nR := nL
      nG := nL
      nB := nL
   ELSE
      IF nL < 0.5
         nTmp2 := nL * ( 1 + nS )
      ELSE
         nTmp2 := nL + nS - ( nL * nS )
      ENDIF
      nTmp1 := 2 * nL - nTmp2
      aTmp3[1] := nH + 1 / 3
      aTmp3[2] := nH
      aTmp3[3] := nH - 1 / 3
      FOR nFor := 1 TO 3
         IF aTmp3[nFor] < 0
            aTmp3[nFor] += 1
         ENDIF
         IF aTmp3[nFor] > 1
            aTmp3[nFor] -= 1
         ENDIF
         IF 6 * aTmp3[nFor] < 1
            aTmp3[nFor] := nTmp1 + ( nTmp2 - nTmp1 ) * 6 * aTmp3[nFor]
         ELSE
            IF 2 * aTmp3[nFor] < 1
               aTmp3[nFor] := nTmp2
            ELSE
               IF 3 * aTmp3[nFor] < 2
                  aTmp3[nFor] := nTmp1 + ( nTmp2 - nTmp1 ) * ( ( 2 / 3 ) - aTmp3[nFor] ) * 6
               ELSE
                  aTmp3[nFor] := nTmp1
               ENDIF
            ENDIF
         ENDIF
      NEXT nFor
      nR := aTmp3[1]
      nG := aTmp3[2]
      nB := aTmp3[3]
   ENDIF

RETURN { Int( nR * 255 ), Int( nG * 255 ), Int( nB * 255 ) }


function DrawWindowBoxIn(window,row,col,rowr,colr)
   Local i := GetFormIndex ( Window )
   Local FormHandle := _HMG_SYSDATA [ 67  ] [i]
   Local hDC := GetDC( FormHandle )

   WndBoxIn( hDC, row, col, rowr, colr )
   aadd ( _HMG_SYSDATA [ 102 ] [i] , { || WndBoxIn( hDC := GetDC( FormHandle ), row, col, rowr, colr ), ReleaseDC( FormHandle, hDC ) } )
   ReleaseDC( FormHandle, hDC )

return nil


function drawpiegraph(windowname,fromrow,fromcol,torow,tocol,series,aname,colors,ctitle,depth,l3d,lxval,lsleg,lnoborder)
local topleftrow
local topleftcol
local toprightrow
local toprightcol
local bottomrightrow
local bottomrightcol
local bottomleftrow
local bottomleftcol

local middletopcol
local middleleftrow
local middleleftcol

local middlebottomcol
local middlerightrow
local middlerightcol
local fromradialrow
local fromradialcol
local toradialrow
local toradialcol
local degrees := {}
local cumulative := {}
local j,i,sum := 0
local cname
local shadowcolor
local previos_cumulative

_HMG_SYSDATA [ 108 ] [ GetFormIndex (windowname) ] := { fromrow , fromcol , tocol - fromcol , torow - fromrow }

if ! lnoborder

   DrawLine(windowname, torow  ,fromcol  ,torow  ,tocol  ,WHITE)
   DrawLine(windowname, torow-1,fromcol+1,torow-1,tocol-1,GRAY )
   DrawLine(windowname, torow-1,fromcol  ,fromrow  ,fromcol  ,GRAY )
   DrawLine(windowname, torow-2,fromcol+1,fromrow+1,fromcol+1,GRAY )
   DrawLine(windowname, fromrow  ,fromcol  ,fromrow  ,tocol-1,GRAY )
   DrawLine(windowname, fromrow+1,fromcol+1,fromrow+1,tocol-2,GRAY )
   DrawLine(windowname, fromrow  ,tocol  ,torow  ,tocol  ,WHITE)
   DrawLine(windowname, fromrow  ,tocol-1,torow-1,tocol-1,GRAY )

endif

if HMG_LEN(ALLTRIM(ctitle)) > 0
   if _iscontroldefined("title_of_pie",windowname)
      _releasecontrol("title_of_pie",windowname)
   endif
   define label title_of_pie
      parent &windowname
      row fromrow + 10
      col iif(HMG_LEN(ALLTRIM(ctitle)) * 12 > (tocol - fromcol),fromcol,int(((tocol - fromcol) - (HMG_LEN(ALLTRIM(ctitle)) * 12))/2) + fromcol)
      autosize .t.
      fontcolor {0,0,255}
      fontbold .t.
      fontname "Arial"
      fontunderline .t.
      fontsize 12
      value ALLTRIM(ctitle)
   transparent .t.
   end label
   fromrow := fromrow + 40
endif

if lsleg
   if HMG_LEN(aname) * 20 > (torow - fromrow)
      msginfo("No space for showing legends")
   else
      torow := torow - (HMG_LEN(aname) * 20)
   endif
endif

drawrect(windowname,fromrow+10,fromcol+10,torow-10,tocol-10,{0,0,0},1,{255,255,255})

if l3d
   torow := torow - depth
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

for i := 1 to HMG_LEN(series)
   sum := sum + series[i]
next i
for i := 1 to HMG_LEN(series)
   aadd(degrees,Round(series[i]/sum * 360,0))
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

   shadowcolor := {iif(colors[i,1] > 50,colors[i,1] - 50,0),iif(colors[i,2] > 50,colors[i,2] - 50,0),iif(colors[i,3] > 50,colors[i,3] - 50,0)}

   do case
      case cumulative[i] <= 45
         toradialcol := middlerightcol
         toradialrow := middlerightrow - Round(cumulative[i] / 45 * (middlerightrow - toprightrow),0)
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 90 .and. cumulative[i] > 45
         toradialrow := toprightrow
         toradialcol := toprightcol - Round((cumulative[i] - 45) / 45 * (toprightcol - middletopcol),0)
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 135 .and. cumulative[i] > 90
         toradialrow := topleftrow
         toradialcol := middletopcol - Round((cumulative[i] - 90) / 45 * (middletopcol - topleftcol),0)
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 180 .and. cumulative[i] > 135
         toradialcol := topleftcol
         toradialrow := topleftrow + Round((cumulative[i] - 135) / 45 * (middleleftrow - topleftrow),0)
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 225 .and. cumulative[i] > 180
         toradialcol := topleftcol
         toradialrow := middleleftrow + Round((cumulative[i] - 180) / 45 * (bottomleftrow - middleleftrow),0)
         if l3d
            for j := 1 to depth
               drawarc(windowname,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
            next j
         endif
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 270 .and. cumulative[i] > 225
         toradialrow := bottomleftrow
         toradialcol := bottomleftcol + Round((cumulative[i] - 225) / 45 * (middlebottomcol - bottomleftcol),0)
         if l3d
            for j := 1 to depth
               drawarc(windowname,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
            next j
         endif
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 315 .and. cumulative[i] > 270
         toradialrow := bottomleftrow
         toradialcol := middlebottomcol + Round((cumulative[i] - 270) / 45 * (bottomrightcol - middlebottomcol),0)
         if l3d
            for j := 1 to depth
               drawarc(windowname,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
            next j
         endif
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      case cumulative[i] <= 360 .and. cumulative[i] > 315
         toradialcol := bottomrightcol
         toradialrow := bottomrightrow - Round((cumulative[i] - 315) / 45 * (bottomrightrow - middlerightrow),0)
         if l3d
            for j := 1 to depth
               drawarc(windowname,fromrow + j,fromcol,torow+j,tocol,fromradialrow+j,fromradialcol,toradialrow+j,toradialcol,shadowcolor)
            next j
         endif
         drawpie(windowname,fromrow,fromcol,torow,tocol,fromradialrow,fromradialcol,toradialrow,toradialcol,,,colors[i])
         fromradialrow := toradialrow
         fromradialcol := toradialcol
      endcase
   if l3d
      drawline(windowname,middleleftrow,middleleftcol,middleleftrow+depth,middleleftcol)
      drawline(windowname,middlerightrow,middlerightcol,middlerightrow+depth,middlerightcol)
      drawarc(windowname,fromrow + depth,fromcol,torow + depth,tocol,middleleftrow+depth,middleleftcol,middlerightrow+depth,middlerightcol)
   endif
next i
if lsleg
   fromrow := torow + 20 + iif(l3d,depth,0)
   for i := 1 to HMG_LEN(aname)
      if _iscontroldefined("pielegend_"+ALLTRIM(Str(i,3,0)),windowname)
         _releasecontrol("pielegend_"+ALLTRIM(Str(i,3,0)),windowname)
      endif
      cname := "pielegend_"+ALLTRIM(Str(i,3,0))
      drawrect(windowname,fromrow,fromcol,fromrow + 15,fromcol + 15,{0,0,0},1,colors[i])
      define label &cname
         parent &windowname
         row fromrow
         col fromcol + 20
         fontname "Arial"
         fontsize 8
         autosize .t.
         value aname[i]+iif(lxval," - "+ALLTRIM(Str(series[i],19,2))+" ("+ALLTRIM(Str(degrees[i] / 360 * 100,6,2))+" %)","")
         fontcolor colors[i]
   transparent .t.
      end label
      fromrow := fromrow + 20
   next i
endif
return nil

Function printgraph ( cWindowName , lPreview , lDialog )
local aLocation

   If .Not. _IsWindowDefined ( cWindowName )
      MsgHMGError("Window: "+ cWindowName + " is not defined. Program terminated" )
   Endif

   If ValType ( _HMG_SYSDATA [ 108 ] [ GetFormIndex (cWindowName ) ] ) <> 'A'
      MsgHMGError("Window: "+ cWindowName + " Don't have a graph. Program terminated" )
      Return Nil
   Endif

   If HMG_LEN ( _HMG_SYSDATA [ 108 ] [ GetFormIndex (cWindowName ) ] ) <> 4
      MsgHMGError("Window: "+ cWindowName + " Don't have a graph. Program terminated" )
      Return Nil
   Endif

   if valtype ( lPreview ) = 'U'
      lPreview := .F.
   endif

   if valtype ( lDialog ) = 'U'
      lDialog := .F.
   endif

   aLocation := _HMG_SYSDATA [ 108 ] [ GetFormIndex (cWindowName ) ]

   PrintWindow ( cWindowName , lPreview , lDialog , aLocation [1] , aLocation [2] , aLocation [3] , aLocation [4] )

return nil
