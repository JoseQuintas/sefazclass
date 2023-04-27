/*
TESTRMCHART
José Quintas
*/

#include "ze_rmchart.ch"
#include "hbgtinfo.ch"
#include "inkey.ch"

#define MAX_SIZE_ONE oCrt:CurrentSize[ 1 ]
#define MAX_SIZE_TWO oCrt:CurrentSize[ 2 ]

FUNCTION Main()

   LOCAL oRmChart, oCrt1, nOpc := 1, nTemp

   SetMode(40,100)
   SET WRAP ON
   SetColor( "W/B" )
   CLS
   hb_ThreadStart( { || tstRMChart() } )
   oRmChart := RMChartClass():New()
   oCrt1 := wvgTstRectangle():New( , , { 0, -20 }, { -MaxRow() - 1, -MaxCol() + 19 } )
   oCrt1:Create()

   DO WHILE .T.
      @ 0, 0 SAY ""
      @ Row() + 1, 1 PROMPT " Single Bars (10)"
      @ Row() + 1, 1 PROMPT " Grouped Bars (1)"
      @ Row() + 1, 1 PROMPT " Four Regions (2) "
      @ Row() + 1, 1 PROMPT " Pyramid (3) "
      @ Row() + 1, 1 PROMPT " Single Bars (4) "
      @ Row() + 1, 1 PROMPT " Donut (5) "
      @ Row() + 1, 1 PROMPT " Stacked Bars (6) "
      @ Row() + 1, 1 PROMPT " Grouped Bars (7) "
      @ Row() + 1, 1 PROMPT " Single Bars (8) "
      @ Row() + 1, 1 PROMPT " Pie (9) "
      MENU TO nOpc
      nTemp := 1
      DO CASE
      CASE LastKey() == K_ESC ; EXIT
      CASE nOpc == nTemp++ ; Graphic10( oCrt1, oRMChart, 1 )
      CASE nOpc == nTemp++ ; Graphic1(  oCrt1, oRMChart, 1 )
      CASE nOpc == nTemp++ ; Graphic2(  oCrt1, oRMChart, 1 )
      CASE nOpc == nTemp++ ; Graphic3(  oCrt1, oRMChart, 1 )
      CASE nOpc == nTemp++ ; Graphic4(  oCrt1, oRmChart, 1 )
      CASE nOpc == nTemp++ ; Graphic5(  oCrt1, oRmChart, 1 )
      CASE nOpc == nTemp++ ; Graphic6(  oCrt1, oRmChart, 1 )
      CASE nOpc == nTemp++ ; Graphic7(  oCrt1, oRmChart, 1 )
      CASE nOpc == nTemp++ ; Graphic8(  oCrt1, oRmChart, 1 )
      CASE nOpc == nTemp++ ; Graphic9(  oCrt1, oRMChart, 1 )
      CASE nOpc == nTemp // dummy
      ENDCASE
   ENDDO
   //oRmChart:DeleteChart(1)
   //oRMChart:Destroy()

   RETURN NIL

FUNCTION AMax( x )

   LOCAL nVal, oElement

   nVal := x[ 1 ]
   FOR EACH oElement IN x
      IF oElement > nVal
         nVal := oElement
      ENDIF
   NEXT

   RETURN nVal

FUNCTION Graphic1( oCrt, oRMChart, nIdChart )

   LOCAL cLegenda, cLabels, cTitulo, aDados, cImagem, cUnidade, cTextoVert, nMax, oElement, nCont

   cLegenda   := "Entradas*Saidas*Mais Um"
   cLabels    := "Janeiro*Fevereiro*Março*Abril*Maio*Junho*Julho*Agosto*Setembro*Outubro*Novembro*Dezembro"
   cTitulo    := "Gráfico de Teste"
   aDados     := { ;
      { 225.25, 100.00, 100.00, 150.00, 250.00, 300.00, 25.00, 75.00, 300.00, 200.00, 325.00, 300.00 }, ;
      { 220.00, 100.00, 125.00, 300.00, 150.00, 125.00, 85.00, 50.00, 285.00, 275.00, 295.00, 280.00 }, ;
      { 125.25, 100.00, 100.00, 150.00, 250.00, 300.00, 25.00, 75.00, 300.00, 200.00, 325.00, 300.00 } }
   cImagem    := ""
   cUnidade   := "R$ "
   cTextoVert := ""
   nMax       := 0

   FOR EACH oElement IN aDados
      nMax := Max( nMax, aMax( oElement ) )
   NEXT

   nMax := Round( ( Int( nMax / 10 ) * 10 ) + 10, 2 )

   oRMChart:CreateChart( oCrt:hWnd, nIdChart, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_AZURE, RMC_CTRLSTYLE3DLIGHT, .F., cImagem, "", 0, 0 )
   oRMChart:AddRegion( nIdChart, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, "RmChart", .F. )
   oRMChart:AddCaption( nIdChart, 1, cTitulo, RMC_COLOR_TRANSPARENT, RMC_COLOR_RED, 9, .T. )
   oRMChart:AddGrid( nIdChart, 1, RMC_COLOR_LIGHT_BLUE, .F., 20, 20, MAX_SIZE_ONE - 100, MAX_SIZE_TWO - 100, RMC_BICOLOR_LABELAXIS )
   oRMChart:AddLabelAxis( nIdChart, 1, cLabels, 1, Len( aDados[ 1 ] ), RMC_LABELAXISBOTTOM, 8, RMC_COLOR_BLACK, RMC_TEXTCENTER, RMC_COLOR_BLACK, RMC_LINESTYLENONE, "" )
   oRMChart:AddDataAxis( nIdChart, 1, RMC_DATAAXISRIGHT, 0.0, nMax, Len( aDados[ 1 ] ), 8, RMC_COLOR_BLACK, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, 1, cUnidade, cTextoVert, "", RMC_TEXTCENTER )
   oRMChart:AddLegend( nIdChart, 1, cLegenda, RMC_LEGEND_BOTTOM, RMC_COLOR_TRANSPARENT, RMC_LEGENDNORECT, RMC_COLOR_RED, 8, .T. )

   FOR nCont = 1 TO Len( aDados )
      oRMChart:AddBarSeries( nIdChart, 1, aDados[ nCont ], 12, RMC_BARGROUP, RMC_BAR_FLAT_GRADIENT2, .F., 0, .F., 1, RMC_VLABEL_NONE, nCont, RMC_HATCHBRUSH_ONPRINTING )
   NEXT

   oRMChart:Draw( nIdChart )
   oRMCHart:Reset(nIdChart)
   // oRMChart:Draw2Printer( ID_RMC1, 0, 0, 0, 0, 0, RMC_BMP )

   RETURN NIL

FUNCTION Graphic2( oCrt, oRMChart, ID_RMC1 )

   LOCAL sTemp1, aData1, sTemp2, sTemp3 := "", aData2, aData3, aData4, aData5, aData6, aData7, aData8

   sTemp1 := "Label 1*Label 2*Label 3*Label 4*Label 5"
   aData1 := { 30,40,70,60,20 }
   sTemp2 := "Label 1*Label 2*Label 3*Label 4*Label 5"
   aData2 := { 20, 10, 15, 25, 30 }
   aData3 := { 25, 30, 10, 20, 15 }
   aData4 := { 10, 20, 40, 20, 30 }
   aData5 := { 40, 30, 20, 30, 20 }
   aData6 := { 30, 50, 20, 40, 60 }
   aData7 := { 240, 230, 220, 180, 170, 160, 145, 130, 125, 115 }
   aData8 := { 162, 124, 86, 44, 24, 62, 104, 228, 146, 84 }

   oRMChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_ALICE_BLUE, RMC_CTRLSTYLEFLATSHADOW, .F., "", "", 0, 0 )

   oRMChart:AddRegion( ID_RMC1, 0, 0, Int( MAX_SIZE_ONE / 2 ) - 5, Int( MAX_SIZE_TWO / 2 ) - 5, "", .F. )
   oRMChart:AddGrid( ID_RMC1, 1, RMC_COLOR_BEIGE, .F., 0, 0, 0, 0, RMC_BICOLOR_NONE )
   oRMChart:AddDataAxis( ID_RMC1, 1, RMC_DATAAXISLEFT, 0, 100, 11, 8, RMC_COLOR_BLACK, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, 0, "", "DATAAXIS1", "", RMC_TEXTCENTER )
   oRMChart:AddLabelAxis( ID_RMC1, 1, sTemp1, 1, 5, RMC_LABELAXISBOTTOM, 8, RMC_COLOR_BLACK, RMC_TEXTCENTER, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, "LABELAXIS1" )
   oRMChart:AddBarSeries( ID_RMC1, 1, aData1, 5,RMC_BARSINGLE, RMC_BAR_3D, .F., RMC_COLOR_DEFAULT, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )

   oRMChart:AddRegion( ID_RMC1, Int( MAX_SIZE_ONE / 2 ) + 1, 0, Int( MAX_SIZE_ONE / 2 ) - 5, Int( MAX_SIZE_TWO / 2 ) - 5, "", .F. )
   oRMChart:AddGrid( ID_RMC1, 2, RMC_COLOR_BEIGE, .F., 0, 0, 0, 0, RMC_BICOLOR_NONE )
   oRMChart:AddDataAxis( ID_RMC1, 2, RMC_DATAAXISTOP, 0, 100, 10, 8, RMC_COLOR_BLACK, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, 0, "", "DATAAXIS2", "", RMC_TEXTCENTER )
   oRMChart:AddLabelAxis( ID_RMC1, 2, sTemp2, 1, 5, RMC_LABELAXISLEFT,8, RMC_COLOR_BLACK, RMC_TEXTCENTER, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, "LABELAXIS2" )
   oRMChart:AddBarSeries( ID_RMC1, 2, aData2, 5, RMC_BARSTACKED, RMC_COLUMN_FLAT, .F., RMC_COLOR_DEFAULT, .T., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   oRMChart:AddBarSeries( ID_RMC1, 2, aData3, 5, RMC_BARSTACKED, RMC_COLUMN_FLAT, .F., RMC_COLOR_DEFAULT, .T., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   oRMChart:AddBarSeries( ID_RMC1, 2, aData4, 5, RMC_BARSTACKED, RMC_COLUMN_FLAT, .F., RMC_COLOR_DEFAULT, .T., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   oRMChart:AddBarSeries( ID_RMC1, 2, aData5, 5, RMC_BARSTACKED, RMC_COLUMN_FLAT, .F., RMC_COLOR_DEFAULT, .T., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )

   oRMChart:AddRegion( ID_RMC1, 0, Int( MAX_SIZE_TWO / 2 ) + 1, Int( MAX_SIZE_ONE / 2 ) - 5, Int( MAX_SIZE_TWO / 2 ) - 5, "", .F. )
   oRMChart:AddLegend( ID_RMC1, 3, "AGUA*LUZ*TELEFONE*COMIDA*IMPOSTOS", RMC_LEGEND_ONVLABELS, 0, 0, 0, 0, 0 )
   oRMChart:AddGridlessSeries( ID_RMC1, 3, aData6, 5, 0, 0, RMC_PIE_3D_GRADIENT, RMC_FULL, 2, .F., RMC_VLABEL_DEFAULT, RMC_HATCHBRUSH_OFF, 0 )

   oRMChart:AddRegion( ID_RMC1, Int( MAX_SIZE_ONE / 2 ) + 1, Int( MAX_SIZE_TWO / 2 ) + 1, Int( MAX_SIZE_ONE / 2 ) - 5, Int( MAX_SIZE_TWO / 2 ) - 5, "", .F.)
   oRMChart:AddGrid( ID_RMC1, 4, RMC_COLOR_ALICE_BLUE, .T., 0, 0, 0, 0, RMC_BICOLOR_NONE )
   oRMChart:AddDataAxis( ID_RMC1, 4, RMC_DATAAXISLEFT, 0, 250, 11, 8, RMC_COLOR_BLUE, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, 0, "$ ", "DATAAXIS4", "", RMC_TEXTCENTER )
   oRMChart:AddLabelAxis( ID_RMC1, 4, sTemp3, 1, 10, RMC_LABELAXISBOTTOM, 8, RMC_COLOR_BLACK, RMC_TEXTCENTER, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, "LABELAXIS4" )
   oRMChart:AddBarSeries( ID_RMC1, 4, aData7, 10, RMC_BARSINGLE, RMC_BAR_FLAT_GRADIENT2, .F., RMC_COLOR_GOLD, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   oRMChart:AddLineSeries( ID_RMC1, 4, aData8, 10, 0, 0, RMC_LINE, RMC_LINE_CABLE, RMC_LSTYLE_LINE, .F., RMC_COLOR_GREEN, RMC_SYMBOL_NONE, 2, RMC_VLABEL_DEFAULT, RMC_HATCHBRUSH_OFF )
   oRMChart:SetWatermark( RMC_USERWM, RMC_USERWMCOLOR, RMC_USERWMLUCENT, RMC_USERWMALIGN, RMC_USERFONTSIZE )
   oRMChart:Draw( ID_RMC1 )
   oRmChart:Reset(ID_RMC1)

   RETURN NIL

FUNCTION Graphic3( oCrt, oRMChart, ID_RMC1 )

   LOCAL sTemp := "Apples*Bananas*Pears*Cherries"
   LOCAL aData := { 30.25, 26.75, 15.89, 46.23 }

   oRMChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_DEFAULT, RMC_CTRLSTYLEFLAT, .F., "", "Tahoma", RMC_COLOR_DEFAULT, 0 )
   oRMChart:AddRegion( ID_RMC1, 0, 0, MAX_SIZE_ONE - 5, MAX_SIZE_TWO - 5, "", .F. )
   oRMChart:AddLegend( ID_RMC1, 1, sTemp, RMC_LEGEND_CUSTOM_UL, RMC_COLOR_DEFAULT, RMC_LEGENDRECTSHADOW, RMC_COLOR_DEFAULT, 8, .F. )
   oRMChart:AddGridlessSeries( ID_RMC1, 1, aData, 4, 0, 0, RMC_PYRAMIDE3, RMC_FULL, 0, .F., RMC_VLABEL_DEFAULT, RMC_HATCHBRUSH_OFF, 0 )
   oRMChart:SetWatermark( RMC_USERWM, RMC_USERWMCOLOR, RMC_USERWMLUCENT, RMC_USERWMALIGN, RMC_USERFONTSIZE )
   oRMChart:Draw( ID_RMC1 )
   oRMChart:Reset(ID_RMC1)

   RETURN NIL

FUNCTION Graphic4( oCrt, oRmChart, ID_RMC1 )

   oRMChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_TRANSPARENT, RMC_CTRLSTYLEIMAGE, .F., "seasky.jpg", "Tahoma", 0, RMC_COLOR_DEFAULT )
   oRMChart:AddRegion( ID_RMC1, 5, 5, -15, -15, "", .F. )
   oRMChart:AddGrid( ID_RMC1, 1, RMC_COLOR_TRANSPARENT, .F., 0, 0, 0, 0, RMC_BICOLOR_NONE )
   oRMChart:AddDataAxis( ID_RMC1, 1, RMC_DATAAXISLEFT, 0, 100, 11, 8, RMC_COLOR_CHALK, RMC_COLOR_CHALK, RMC_LINESTYLEDOT, 0, "", "", "", RMC_TEXTCENTER )
   oRMChart:AddLabelAxis( ID_RMC1, 1, "Label 1*Label 2*Label 3*Label 4*Label 5", 1,5, RMC_LABELAXISBOTTOM, 8, RMC_COLOR_YELLOW, RMC_TEXTCENTER, RMC_COLOR_CHALK, RMC_LINESTYLENONE, "" )
   oRMChart:AddBarSeries( ID_RMC1, 1, { 50, 70, 40, 60, 30 }, 5, RMC_BARSINGLE, RMC_BAR_FLAT_GRADIENT2, .T., RMC_COLOR_TRANSPARENT, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   oRMChart:SetWatermark( RMC_USERWM, RMC_USERWMCOLOR, RMC_USERWMLUCENT, RMC_USERWMALIGN, RMC_USERFONTSIZE )
   oRMChart:Draw( ID_RMC1 )
   oRMChart:Reset( ID_RMC1 )

   RETURN NIL

FUNCTION Graphic5( oCrt, oRmChart, ID_RMC1 )

   LOCAL aColors := { RMC_COLOR_LIGHT_GREEN, RMC_COLOR_YELLOW, RMC_COLOR_GOLDENROD, RMC_COLOR_CRIMSON }
   LOCAL aData   := { 40, 30, 60, 20 }

   oRmChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_MIDNIGHT_BLUE, RMC_CTRLSTYLEIMAGE, .F., "seasky.jpg", "Tahoma", 0, RMC_COLOR_DEFAULT )
   oRMChart:AddRegion( ID_RMC1, 5, 5, -5, -5, "", .F. )
   oRMChart:AddLegend( ID_RMC1, 1, "Apples*Citrons*Bananas*Cherries", RMC_LEGEND_CUSTOM_CENTER, RMC_COLOR_DEFAULT, RMC_LEGENDNORECT, RMC_COLOR_WHITE, 8, .F. )
   oRmChart:AddGridlessSeries( ID_RMC1, 1, aData, 4, aColors, 4, RMC_DONUT_GRADIENT, RMC_FULL, 0, .F., RMC_VLABEL_TWIN, RMC_HATCHBRUSH_OFF, 0 )
   oRmChart:SetWatermark( RMC_USERWM, RMC_USERWMCOLOR, RMC_USERWMLUCENT, RMC_USERWMALIGN, RMC_USERFONTSIZE )
   oRmChart:Draw( ID_RMC1 )
   ORMChart:Reset( ID_RMC1 )

   RETURN NIL

FUNCTION Graphic6( oCrt, oRmChart, ID_RMC1 )

   LOCAL aData, sTemp

   oRMChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_BISQUE, RMC_CTRLSTYLE3DLIGHT, .F., "", "Tahoma", 0, RMC_COLOR_DEFAULT )
   oRMChart:AddRegion( ID_RMC1, 5, 5, -5, -5, "this is the footer", .F. )
   oRMChart:AddCaption( ID_RMC1, 1, "Example of stacked bars", RMC_COLOR_BISQUE, RMC_COLOR_BLACK, 11, .F. )
   oRMChart:AddGrid( ID_RMC1, 1, RMC_COLOR_CORN_SILK, .F., 0, 0, 0, 0, RMC_BICOLOR_NONE )
   oRMChart:AddDataAxis( ID_RMC1, 1, RMC_DATAAXISLEFT, 0, 50000, 11, 8, RMC_COLOR_BLACK, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, 0, " $","optional axis text, 9 points bold\9b", "", RMC_TEXTCENTER )
   sTemp = "Label Nr. 1*Label Nr. 2*Label Nr. 3*Label Nr. 4*Label Nr. 5*Label Nr. 6"
   oRMChart:AddLabelAxis( ID_RMC1, 1, sTemp, 1, 6, RMC_LABELAXISBOTTOM, 8, RMC_COLOR_BLACK, RMC_TEXTCENTER, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, "optional label axis text" )
   sTemp = "Apples*Pears*Cherries*Strawberries"
   oRMChart:AddLegend( ID_RMC1, 1, sTemp, RMC_LEGEND_CUSTOM_UL, RMC_COLOR_LIGHT_YELLOW, RMC_LEGENDRECT, RMC_COLOR_BLUE, 8, .F. )
   aData := { 10000, 10000, 16000, 12000, 20000, 10000 }
   oRMChart:AddBarSeries( ID_RMC1, 1, aData, 6, RMC_BARSTACKED, RMC_COLUMN_FLAT, .F., RMC_COLOR_DARK_BLUE, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   aData := { 5000, 7000, 4000, 15000, 10000, 10000 }
   oRMChart:AddBarSeries( ID_RMC1, 1, aData, 6, RMC_BARSTACKED, RMC_COLUMN_FLAT, .F., RMC_COLOR_DARK_GREEN, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   aData := { 10000, 3000, 12000, 10000, 5000, 20000 }
   oRMChart:AddBarSeries(ID_RMC1,1,aData, 6,RMC_BARSTACKED,RMC_COLUMN_FLAT,.F.,RMC_COLOR_MAROON,.F.,1,RMC_VLABEL_NONE,1,RMC_HATCHBRUSH_OFF)
   aData := { 5000, 9000, 12000, 6000, 10000, 5000 }
   oRMChart:AddBarSeries( ID_RMC1, 1, aData, 6, RMC_BARSTACKED, RMC_COLUMN_FLAT, .F., RMC_COLOR_DARK_GOLDENROD, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   oRMChart:SetWatermark( RMC_USERWM, RMC_USERWMCOLOR, RMC_USERWMLUCENT, RMC_USERWMALIGN, RMC_USERFONTSIZE )
   oRMChart:Draw( ID_RMC1 )
   ORMChart:Reset( ID_RMC1 )

   RETURN NIL

FUNCTION Graphic7( oCrt, oRMChart, ID_RMC1 )

   LOCAL aData, sTemp

   oRmChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE,MAX_SIZE_TWO, RMC_COLOR_TRANSPARENT, RMC_CTRLSTYLEIMAGETILED, .F., "seasky.jpg", "Tahoma", 0, RMC_COLOR_DEFAULT )
   oRmChart:AddRegion( ID_RMC1, 5, 5, -50, -50, "", .F. )
   oRmChart:AddGrid( ID_RMC1, 1, RMC_COLOR_TRANSPARENT, .F., 0, 0, 0, 0, RMC_BICOLOR_NONE )
   oRmChart:AddDataAxis( ID_RMC1, 1, RMC_DATAAXISLEFT, 0, 100, 11, 8, RMC_COLOR_DEFAULT, RMC_COLOR_DEFAULT, RMC_LINESTYLESOLID, 0, "", "", "", RMC_TEXTCENTER )
   sTemp = "2000*2001*2002*2003*2004"
   oRmChart:AddLabelAxis( ID_RMC1, 1, sTemp, 1,5, RMC_LABELAXISBOTTOM, 8, RMC_COLOR_DEFAULT, RMC_TEXTCENTER, RMC_COLOR_DEFAULT, RMC_LINESTYLESOLID, "" )
   sTemp = "First quarter*Second quarter*Third quarter*Fourth quarter"
   oRmChart:AddLegend( ID_RMC1, 1, sTemp, RMC_LEGEND_TOP, RMC_COLOR_DEFAULT, RMC_LEGENDNORECT, RMC_COLOR_DEFAULT, 8, .F. )
   aData := { 30, 20, 40, 60, 10 }
   oRmChart:AddBarSeries( ID_RMC1, 1, aData, 5, RMC_BARGROUP, RMC_BAR_HOVER, .F., RMC_COLOR_DEFAULT, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   aData := { 30, 20, 50, 70, 60 }
   oRmChart:AddBarSeries( ID_RMC1, 1, aData, 5, RMC_BARGROUP, RMC_BAR_HOVER, .F., RMC_COLOR_DEFAULT, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   aData := { 40, 10, 30, 20, 80 }
   oRmChart:AddBarSeries( ID_RMC1, 1, aData, 5, RMC_BARGROUP, RMC_BAR_HOVER, .F., RMC_COLOR_DEFAULT, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   aData := { 70, 50, 80, 40, 30 }
   oRmChart:AddBarSeries( ID_RMC1, 1, aData, 5, RMC_BARGROUP, RMC_BAR_HOVER, .F., RMC_COLOR_DEFAULT, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   oRmChart:SetWatermark( RMC_USERWM, RMC_USERWMCOLOR, RMC_USERWMLUCENT, RMC_USERWMALIGN, RMC_USERFONTSIZE )
   oRmChart:Draw( ID_RMC1 )
   ORMChart:Reset( ID_RMC1 )

   RETURN NIL

FUNCTION Graphic8( oCrt, oRMChart, ID_RMC1 )

   LOCAL sTemp, aData

   oRMChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_ALICE_BLUE, RMC_CTRLSTYLEFLAT, .F., "", "Tahoma", 0, RMC_COLOR_DEFAULT )
   oRMChart:AddRegion( ID_RMC1, 5, 5, -50, -50, "", .F. )
   oRMChart:AddCaption( ID_RMC1, 1, "This is the chart's caption", RMC_COLOR_BLUE, RMC_COLOR_YELLOW, 11, .T. )
   oRMChart:AddGrid( ID_RMC1, 1, RMC_COLOR_WHITE, .F., 0, 0, 0, 0, RMC_BICOLOR_LABELAXIS )
   oRMChart:AddDataAxis( ID_RMC1, 1, RMC_DATAAXISLEFT, 0, 100, 11, 8, RMC_COLOR_BLACK, RMC_COLOR_BLACK, RMC_LINESTYLESOLID, 0, "", "", "", RMC_TEXTCENTER )
   sTemp = "Label 1*Label 2*Label 3*Label 4*Label 5"
   oRMChart:AddLabelAxis( ID_RMC1, 1, sTemp, 1, 5, RMC_LABELAXISBOTTOM, 8, RMC_COLOR_BLACK, RMC_TEXTCENTER, RMC_COLOR_BLACK, RMC_LINESTYLENONE, "" )
   aData := { 50, 70, 40, 60, 30 }
   oRMChart:AddBarSeries( ID_RMC1, 1, aData, 5, RMC_BARSINGLE, RMC_BAR_FLAT_GRADIENT2, .F., RMC_COLOR_DEFAULT, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF )
   oRMChart:SetWatermark( RMC_USERWM, RMC_USERWMCOLOR, RMC_USERWMLUCENT, RMC_USERWMALIGN, RMC_USERFONTSIZE )
   oRMChart:Draw( ID_RMC1 )
   oRMChart:Reset( ID_RMC1 )

   RETURN NIL

FUNCTION Graphic9( oCrt, oRMChart, ID_RMC1 )

   LOCAL aColor, aData, sTemp

   oRMChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_TRANSPARENT, RMC_CTRLSTYLEFLAT, .F., "", "Tahoma", 0, RMC_COLOR_DEFAULT )
   ORMChart:AddRegion( ID_RMC1, 5, 5, -5, -5, "", .F. )
   aColor := { RMC_COLOR_MAROON, RMC_COLOR_MEDIUM_BLUE, RMC_COLOR_CRIMSON, RMC_COLOR_DEFAULT }
   aData := { 80, 50, 60, 30 }
   oRMChart:AddGridlessSeries(ID_RMC1, 1, aData, 4, aColor, 4, RMC_PIE_3D_GRADIENT, RMC_HALF_TOP, 0, .F., RMC_VLABEL_NONE, RMC_HATCHBRUSH_OFF, 0)
   sTemp := "This is a 3D pie with semicircle alignment, tooltips, a custom text" + Chr(10) + Chr(13) + "and a discreet watermark."
   oRMChart:COText( ID_RMC1, 1, sTemp, 100, 270, 400, 50, RMC_BOX_3D_SHADOW, RMC_COLOR_MOCCASIN, RMC_COLOR_DEFAULT, 0, RMC_LINE_HORIZONTAL, RMC_COLOR_MAROON, "09C" )
   oRMChart:SetWatermark( "RMChart", RMC_COLOR_AUTUMN_ORANGE, 25, 1, RMC_USERFONTSIZE )
   oRMChart:Draw( ID_RMC1 )
   oRMCHart:Reset( ID_RMC1 )

   RETURN NIL

FUNCTION Graphic10( oCrt, oRmChart, ID_RMC1 )

   LOCAL sTemp, aData, aXPoints, aYPoints, nAverage := 0, nL := 0, nT := 0, nR := 0, nB := 0

   oRmChart:CreateChart( oCrt:hWnd, ID_RMC1, 0, 0, MAX_SIZE_ONE, MAX_SIZE_TWO, RMC_COLOR_AZURE, RMC_CTRLSTYLEFLAT, .F., "", "Tahoma", 0, RMC_COLOR_DEFAULT )
   oRmChart:AddRegion(ID_RMC1, 5, 5, -5, -5, "", .F. )
   oRMChart:AddCaption(ID_RMC1, 1, "This is the chart's caption", RMC_COLOR_BLUE, RMC_COLOR_YELLOW, 11, .T. )
   oRMChart:AddGrid(ID_RMC1, 1, RMC_COLOR_BEIGE, .F., 0, 0, 0, 0, RMC_BICOLOR_LABELAXIS)
   oRMChart:AddDataAxis(ID_RMC1, 1, RMC_DATAAXISLEFT, 0, 100, 11, 8, RMC_COLOR_BLACK, RMC_COLOR_BLACK, RMC_LINESTYLEDOT, 0, "", "", "", RMC_TEXTCENTER )
   sTemp := "Label 1*Label 2*Label 3*Label 4*Label 5"
   oRMChart:AddLabelAxis(ID_RMC1, 1, sTemp, 1, 5, RMC_LABELAXISBOTTOM, 8, RMC_COLOR_BLACK, RMC_TEXTCENTER, RMC_COLOR_BLACK, RMC_LINESTYLENONE, "")
   aData := { 60, 70, 40, 60, 30 }
   oRMChart:AddBarSeries(ID_RMC1, 1, aData, 5, RMC_BARSINGLE, RMC_BAR_FLAT_GRADIENT2, .F., RMC_COLOR_CORN_FLOWER_BLUE, .F., 1, RMC_VLABEL_NONE, 1, RMC_HATCHBRUSH_OFF)
   oRMChart:SetSeriesColor( ID_RMC1, 1, 1, RMC_COLOR_RED, 3 )
   //oRMChart:CalcAverage( ID_RMC1, 1, 1, @nAverage, @nL, @nT, @nR, @nB, 0 )
   oRMChart:CODash( ID_RMC1, 1, nL, nT, nR, nB, RMC_FLAT_LINE, RMC_COLOR_GREEN, .F., 2, 0, 0 )
   aXPoints := { 480, 565, 565 }
   aYPoints := { 185, 185, 218 }
   oRMChart:COLine( ID_RMC1, 2, aXPoints, aYPoints, 3, RMC_FLAT_LINE, RMC_COLOR_GREEN, 0, 2, 0, RMC_ANCHOR_ARROW_OPEN )
   oRMChart:COText( ID_RMC1, 3, "Average: " + LTrim(Transform(nAverage,"999,999,999.99")), 480, 169 ,0, 0, 0, 0, 0, 0, 0, 0, "" )
   oRMChart:Draw(ID_RMC1)
   oRMChart:Reset( ID_RMC1 )
   HB_SYMBOL_UNUSED( sTemp + aData + aXPoints + aYPoints + nL + nT + nR + nB  + nAverage )

   RETURN NIL

FUNCTION TstRmChart()

   LOCAL oRmChart, oCrt1, oControl

   hb_gtReload( "WVG" )
   SetMode(40,100)
   SET WRAP ON
   SetColor( "W/B" )
   CLS
   oRmChart := RMChartClass():New()
   oCrt1 := wvgTstRectangle():New( , , { -5, -1 }, { -MaxRow(), -MaxCol() } )
   oCrt1:Create()

   oControl := wvgTstTrackbar():New()
   oControl:Create( , , { -1, -1 }, { -2, -90 }, , .F. )
   oControl:SetValues( , 1, 10 )
   oControl:Show()
   oControl:bChanged := { | nOpc | ShowGraphic( nOpc, oCrt1, oRmChart ) }
   Inkey(0)
   //oRmChart:DeleteChart(1)
   //oRMChart:Destroy()

   RETURN NIL

FUNCTION ShowGraphic( nOpc, oCrt1, oRmChart )

   LOCAL nTemp := 1

   DO CASE
   CASE nOpc == nTemp++ ; Graphic10( oCrt1, oRMChart, 1 )
   CASE nOpc == nTemp++ ; Graphic1(  oCrt1, oRMChart, 1 )
   CASE nOpc == nTemp++ ; Graphic2(  oCrt1, oRMChart, 1 )
   CASE nOpc == nTemp++ ; Graphic3(  oCrt1, oRMChart, 1 )
   CASE nOpc == nTemp++ ; Graphic4(  oCrt1, oRmChart, 1 )
   CASE nOpc == nTemp++ ; Graphic5(  oCrt1, oRmChart, 1 )
   CASE nOpc == nTemp++ ; Graphic6(  oCrt1, oRmChart, 1 )
   CASE nOpc == nTemp++ ; Graphic7(  oCrt1, oRmChart, 1 )
   CASE nOpc == nTemp++ ; Graphic8(  oCrt1, oRmChart, 1 )
   CASE nOpc == nTemp++ ; Graphic9(  oCrt1, oRMChart, 1 )
   CASE nOpc == nTemp // dummy
   ENDCASE

   RETURN NIL
