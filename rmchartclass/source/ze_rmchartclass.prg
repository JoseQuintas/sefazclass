/*
ZE_RMCHARTCLASS - class to use rmchart.dll
2016.05 José Quintas

Note: Wrong parameters may cause crash. Not all methods have required conversion.
*/

#require "hbct.hbc"
#include "hbclass.ch"
#include "hbdyn.ch"

#define RMC_USERWM         ""               // Your watermark
#define RMC_USERWMCOLOR    RMC_COLOR_BLACK  // Color for the watermark
#define RMC_USERWMLUCENT   30               // Lucent factor between 1(=not visible) and 255(=opaque)
#define RMC_USERWMALIGN    RMC_TEXTCENTER   // Alignment for the watermark
#define RMC_USERFONTSIZE   0                // Fontsize; if 0: maximal size is used

CREATE CLASS RMChartClass

   VAR    hDLL
   VAR    aIdChartList                     INIT {}
   CLASSVAR ChartID INIT 0

   DESTRUCTOR Destroy()
   METHOD GetChartID()                     INLINE ::ChartID += 1, AAdd( ::aIdChartList, ::ChartID ), ::ChartID
   METHOD FreeChartList()
   METHOD Init()                           INLINE ::hDLL := hb_libLoad( "RMChart.dll" )
   METHOD AddBarSeries(a,b,c, ... )        INLINE ::CallDllStd( "RMC_ADDBARSERIES", a, b, ::ToDouble( c ), ... )
   METHOD AddRegion( ... )                 INLINE ::CallDllStd( "RMC_ADDREGION", ... )
   METHOD AddCaption( ... )                INLINE ::CallDllStd( "RMC_ADDCAPTION", ... )
   METHOD AddDataAxis(a,b,c,d,e, ... )     INLINE ::CallDllStd( "RMC_ADDDATAAXIS", a, b, c, ::ToDecimal( d ), ::ToDecimal( e ), ... )
   METHOD AddGrid( ... )                   INLINE ::CallDllStd( "RMC_ADDGRID", ... )
   METHOD AddGridLessSeries(a,b,c,d,e,...) INLINE ::CallDllStd( "RMC_ADDGRIDLESSSERIES", a, b, ::ToDouble( c ), d, ::ToLong( e ), ... )
   METHOD AddHightLowSeries(a,b,c,...)     INLINE ::CallDllStd( "RMC_ADDHIGHTLOWSERIES", a, b, ::ToDouble( c ), ... )
   METHOD AddLabelAxis( ... )              INLINE ::CallDllStd( "RMC_ADDLABELAXIS", ... )
   METHOD AddLegend( ... )                 INLINE ::CallDllStd( "RMC_ADDLEGEND", ... )
   METHOD AddLineSeries( a,b,c, ... )      INLINE ::CallDllStd( "RMC_ADDLINESERIES", a, b, ::ToDouble( c ), ... )
   METHOD AddToolTips( ... )               INLINE ::CallDllStd( "RMC_ADDTOOLTIPS", ... )
   METHOD AddVolumeBarSeries(a,b,c,...)    INLINE ::CallDllStd( "RMC_ADDVOLUMEBARSERIES", a, b, ::ToDouble( c ), ... )
   METHOD AddXAxis(a,b,c,d,e,...)          INLINE ::CallDllStd( "RMC_ADDXAXIS", a, b, c, ::ToDouble( d ), ::ToDouble( e ), ... )
   METHOD AddXSeries(a,b,c,d,e,...)        INLINE ::CallDllStd( "RMC_ADDXSERIES", a, b, ::ToDouble( c ), d, ::ToDouble( e ), ... )
   METHOD AddYAxis(a,b,c,d,e,...)          INLINE ::CallDllStd( "RMC_ADDYAXIS", a, b, c, ::ToDouble( d ), ::ToDouble( e ), ... )
   METHOD AddYSeries(a,b,c,d,e,...)        INLINE ::CallDllStd( "RMC_ADDYSERIES", a, b, ::ToDouble( c ), d, ::ToDouble( e ), ... )
   METHOD CalcAverage(a,b,c,d,...)         INLINE ::CallDllStd( "RMC_CALCAVERAGE", a, b, c, ::ToDouble( d ), ... )
   METHOD CalcTrend(a,b,c,d,e,... )        INLINE ::CallDllStd( "RMC_CALLTREND", a, b, c, ::ToDouble( d ), ::ToDouble( e ), ... )
   METHOD CoBox( ... )                     INLINE ::CallDllStd( "RMC_COBOX", ... )
   METHOD CoCircle( ... )                  INLINE ::CallDllStd( "RMC_COCIRCLE", ... )
   METHOD CoDash( ... )                    INLINE ::CallDllStd( "RMC_CODASH", ... )
   METHOD CoDelete( ... )                  INLINE ::CallDllStd( "RMC_CODELETE", ... )
   METHOD CoImage( ... )                   INLINE ::CallDllStd( "RMC_COIMAGE", ... )
   METHOD CoLine( a, b, c, d, ... )        INLINE ::CallDllStd( "RMC_COLINE", a, b, ::ToLong( c ), ::ToLong( d ), ... )
   METHOD CoPolygon( ... )                 INLINE ::CallDllStd( "RMC_COPOLYGON", ... )
   METHOD CoSymbol( ... )                  INLINE ::CallDllStd( "RMC_COSYMBOL", ... )
   METHOD CoText( ... )                    INLINE ::CallDllStd( "RMC_COTEXT", ... )
   METHOD CoVisible( ... )                 INLINE ::CallDllStd( "RMC_COVISIBLE", ... )
   METHOD CreateChart( ... )               INLINE ::CallDllStd( "RMC_CREATECHART", ... )
   /* METHOD CreateChartOnDc( ... )           INLINE ::CallDllStd( "RMC_CREATECHARONDC", ... )  // uncomment if you know what you are doing */
   METHOD CreateChartFromFile( ... )       INLINE ::CallDllStd( "RMC_CREATECHARFROMFILE", ... )
   METHOD DeleteChart( ... )               INLINE ::CallDllStd( "RMC_DELETECHART", ... )
   METHOD Draw( ... )                      INLINE ::CallDllStd( "RMC_DRAW", ... )
   METHOD Draw2Clipboard( ... )            INLINE ::CallDllStd( "RMC_DRAW2CLIPBOARD", ... )
   METHOD Draw2Printer( ... )              INLINE ::CallDllStd( "RMC_DRAW2PRINTER", ... )
   METHOD Draw2File( ... )                 INLINE ::CallDllStd( "RMC_DRAW2FILE", ... )
   METHOD GetChartSizeFromFile( ... )      INLINE ::CallDllStd( "RMC_GETCHARTSIZEFROMFILE", ... )
   METHOD GetCtrlHeight( ... )             INLINE ::CallDllStd( "RMC_GETCTRLHEIGHT", ... )
   METHOD GetCtrlWidth( ... )              INLINE ::CallDllStd( "RMC_GETCTRLWIDTH", ... )
   METHOD GetData( ... )                   INLINE ::CallDllStd( "RMC_GETDATA", ... )
   METHOD GetDataCount( ... )              INLINE ::CallDllStd( "RMC_GRETDATACOUNT", ... )
   METHOD GetDataLocation( ... )           INLINE ::CallDllStd( "RMC_GETDATALOCATION", ... )
   METHOD GetDataLocationXY( ... )         INLINE ::CallDllStd( "RMC_GETDATALOCATIONXY", ... )
   METHOD GetGridLocation( ... )           INLINE ::CallDllStd( "RMC_GETGRIDLOCATION", ... )
   METHOD GetHighPart( ... )               INLINE ::CallDllStd( "RMC_GETHIGHPART", ... )
   METHOD GetImageSizeFromFile( ... )      INLINE ::CallDllStd( "RMC_GETIMAGESIZEFROMFILE", ... )
   METHOD GetInfo( ... )                   INLINE ::CallDllStd( "RMC_GETINFO", ... )
   METHOD GetInfoXY( ... )                 INLINE ::CallDllStd( "RMC_GETINFOXY", ... )
   METHOD GeTLowPart( ... )                INLINE ::CallDllStd( "RMC_GETLOWPART", ... )
   METHOD GetSeriesDataRange( ... )        INLINE ::CallDllStd( "RMC_GETSERIESDATARANGE", ... )
   METHOD GetVersion( ... )                INLINE ::CallDllStd( "RMC_GETVERSION", ... )
   METHOD Magnifier( ... )                 INLINE ::CallDllStd( "RMC_MAGNIFIER", ... )
   METHOD Paint( ... )                     INLINE ::CallDllStd( "RMC_PAINT", ... )
   METHOD Reset( ... )                     INLINE ::CallDllStd( "RMC_RESET", ... )
   METHOD Rnd( ... )                       INLINE ::CallDllStd( "RMC_RND", ... )
   METHOD SaveBMP( ... )                   INLINE ::CallDllStd( "RMC_SAVEBMP", ... )
   METHOD SetCaptionText( ... )            INLINE ::CallDllStd( "RMC_SETCAPTIONTEXT", ... )
   METHOD SetCaptionBGColor( ... )         INLINE ::CallDllStd( "RMC_SETCAPTIONBGCOLOR", ... )
   METHOD SetCaptionTextColor( ... )       INLINE ::CallDllStd( "RMC_SETCAPTIONTEXTCOLOR", ... )
   METHOD SetCaptionFontBold( ... )        INLINE ::CallDllStd( "RMC_SETCAPTIONFONTBOLD", ... )
   METHOD SetCaptionFontSize( ... )        INLINE ::CallDllStd( "RMC_SETCAPTIONFONTSIZE", ... )
   METHOD SetCtrlBGColor( ... )            INLINE ::CallDllStd( "RMC_SETCTRLBGCOLOR", ... )
   METHOD SetCtrlBGImage( ... )            INLINE ::CallDllStd( "RMC_SETCTRLBGIMAGE", ... )
   METHOD SetCtrlFont( ... )               INLINE ::CallDllStd( "RMC_SETCTRLFONT", ... )
   METHOD SetCtrlSize( ... )               INLINE ::CallDllStd( "RMC_SETCTRLSIZE", ... )
   METHOD SetCtrlStyle( ... )              INLINE ::CallDllStd( "RMC_SETCTRLSTYLE", ... )
   METHOD SetCustomTooltipText( ... )      INLINE ::CallDllStd( "RMC_SETCUSTOMTOOLTIPTEXT", ... )
   METHOD SetDataXAlignment( ... )         INLINE ::CallDllStd( "RMC_SETDATAXALIGNMENT", ... )
   METHOD SetDaXDecimalDigits( ... )       INLINE ::CallDllStd( "RMC_SETDAXDECIMALDIGITS", ... )
   METHOD SetDaXFontSize( ... )            INLINE ::CallDllStd( "RMC_SETDAXFONTSIZE", ... )
   METHOD SetDaXLineColor( ... )           INLINE ::CallDllStd( "RMC_SETDAXLINECOLOR", ... )
   METHOD SetDaXLineStyle( ... )           INLINE ::CallDllStd( "RMC_SETDAXLINESTLE", ... )
   METHOD SetDaXMaxValue( ... )            INLINE ::CallDllStd( "RMC_SETDAXMAXVALUE", ... )
   METHOD SetDaXMinValue( ... )            INLINE ::CallDllStd( "RMC_SETDAXMINVALUE", ... )
   METHOD SetDaXText( ... )                INLINE ::CallDllStd( "RMC_SETDAXTEXT", ... )
   METHOD SetDaXTextColor( ... )           INLINE ::CallDllStd( "RMC_SETDAXTEXTCOLOR", ... )
   METHOD SetDaXTickCount( ... )           INLINE ::CallDllStd( "RMC_SETDAXTICKCOLOR", ... )
   METHOD SetDaXUnit( ... )                INLINE ::CallDllStd( "RMC_SETDAXUNIT", ... )
   METHOD SetGridBGColor( ... )            INLINE ::CallDllStd( "RMC_SETGRIDBGCOLOR", ... )
   METHOD SetGridBIColor( ... )            INLINE ::CallDllStd( "RMC_SETGRIDBICOLOR", ... )
   METHOD SetGridGradient( ... )           INLINE ::CallDllStd( "RMC_SETGRIDGRADIENT", ... )
   METHOD SetGridMargin( ... )             INLINE ::CallDllStd( "RMC_SETGRIDMARGIN", ... )
   METHOD SetHelpIngGrid( ... )            INLINE ::CallDllStd( "RMC_SETHELPINGGRID", ... )
   METHOD SetLAXAlignment( ... )           INLINE ::CallDllStd( "RMC_SETLAXALIGNMENT", ... )
   METHOD SetLAXCount( ... )               INLINE ::CallDllStd( "RMC_SETLAXCOUNT", ... )
   METHOD SetLAXFontSize( ... )            INLINE ::CallDllStd( "RMC_SETLAXFONTSIZE", ... )
   METHOD SetAXLabelAlignment( ... )       INLINE ::CallDllStd( "RMC_SETAXLABELALIGNMENT", ... )
   METHOD SetAXLabels( ... )               INLINE ::CallDllStd( "RMC_SETAXLABELS", ... )
   METHOD SetAXLabelsFile( ... )           INLINE ::CallDllStd( "RMC_SETAXLABELSFILE", ... )
   METHOD SetAxLabelsRange( ... )          INLINE ::CallDllStd( "RMC_SETAXLABELSRANGE", ... )
   METHOD SetAXLineColor( ... )            INLINE ::CallDllStd( "RMC_SETAXLINECOLOR", ... )
   METHOD SetAXLineStyle( ... )            INLINE ::CallDllStd( "RMC_SETAXLINESTYLE", ... )
   METHOD SetLAXText( ... )                INLINE ::CallDllStd( "RMC_SETLAXTEXT", ... )
   METHOD SetLAXTickCount( ... )           INLINE ::CallDllStd( "RMC_SETLAXTICKCOUNT", ... )
   METHOD SetLegendAlignment( ... )        INLINE ::CallDllStd( "RMC_SETLEGENDALIGNMENT", ... )
   METHOD SetLegendBGColor( ... )          INLINE ::CallDllStd( "RMC_SETLEGENDBGCOLOR", ... )
   METHOD SetLegendFontBold( ... )         INLINE ::CallDllStd( "RMC_SETLEGENDFONTBOLD", ... )
   METHOD SetLegendFontSize( ... )         INLINE ::CallDllStd( "RMC_SETLEGENDFONTSIZE", ... )
   METHOD SetLegendHide( ... )             INLINE ::CallDllStd( "RMC_SETLEGENDHIDE", ... )
   METHOD SetLegendStyle( ... )            INLINE ::CallDllStd( "RMC_SETLEGENDSTYLE", ... )
   METHOD SetLegendText( ... )             INLINE ::CallDllStd( "RMC_SETLEGENDTEXT", ... )
   METHOD SetLegendTextColor( ... )        INLINE ::CallDllStd( "RMC_SETLEGENDTEXTCOLOR", ... )
   METHOD SetMouseClick( ... )             INLINE ::CallDllStd( "RMC_SETMOUSECLICK", ... )
   METHOD SetRegionFooter( ... )           INLINE ::CallDllStd( "RMC_SETREGIONFOOTER", ... )
   METHOD SetRegionMargin( ... )           INLINE ::CallDllStd( "RMC_SETREGIONMARGIN", ... )
   METHOD SetRegionBorder( ... )           INLINE ::CallDllStd( "RMC_SETREGIONBORDER", ... )
   METHOD SetRMCFile( ... )                INLINE ::CallDllStd( "RMC_SETRMCFILE", ... )
   METHOD SetSeriesColor( ... )            INLINE ::CallDllStd( "RMC_SETSERIESCOLOR", ... )
   METHOD SetSeriesExplodeMode( ... )      INLINE ::CallDllStd( "RMC_SETSERIESEXPLODEMODE", ... )
   METHOD SetSeriesStartAngle( ... )       INLINE ::CallDllStd( "RMC_SETSERIESSTARTANGLE", ... )
   METHOD SetSeriesData( ... )             INLINE ::CallDllStd( "RMC_SETSERIESDATA", ... )
   METHOD SetSeriesDataFile( ... )         INLINE ::CallDllStd( "RMC_SETSERIESDATAFILE", ... )
   METHOD SetSeriesDataRange( ... )        INLINE ::CallDllStd( "RMC_SETSERIESDATARANGE", ... )
   METHOD SetSeriesSingleData( ... )       INLINE ::CallDllStd( "RMC_SETSERIESSINGLEDATA", ... )
   METHOD SetSeriesDataAxis( ... )         INLINE ::CallDllStd( "RMC_SETSERIESDATAAXIS", ... )
   METHOD SetSeriesHarchMode( ... )        INLINE ::CallDllStd( "RMC_SETSERIESHARCHMODE", ... )
   METHOD SetSeriesHide( ... )             INLINE ::CallDllStd( "RMC_SETSERIESHIDE", ... )
   METHOD SetSeriesHightLowColor( ... )    INLINE ::CallDllStd( "RMC_SETSERIESHIGHLOWCOLOR", ... )
   METHOD SetSeriesLineStyle( ... )        INLINE ::CallDllStd( "RMC_SETSERIESLINESTYLE", ... )
   METHOD SetSeriesLucent( ... )           INLINE ::CallDllStd( "RMC_SETSERIESLUCENT", ... )
   METHOD SetSeriesPPColumn( ... )         INLINE ::CallDllStd( "RMC_SETSERIESPPCOUMN", ... )
   METHOD SetSeriesPPColumnArray( ... )    INLINE ::CallDllStd( "RMC_SETSERIESPPCOLUMNARRAY", ... )
   METHOD SetSeriesVertical( ... )         INLINE ::CallDllStd( "RMC_SETSERIESVERTICAL", ... )
   METHOD SetSeriesStyle( ... )            INLINE ::CallDllStd( "RMC_SETSERIESSTYLE", ... )
   METHOD SetSeriesSymbol( ... )           INLINE ::CallDllStd( "RMC_SETSERIESSYMBOL", ... )
   METHOD SetSeriesValueLabel( ... )       INLINE ::CallDllStd( "RMC_SETSERIESVALUELABEL", ... )
   METHOD SetSeriesXAxis( ... )            INLINE ::CallDllStd( "RMC_SETSERIESXAXIS", ... )
   METHOD SetSeriesYAxis( ... )            INLINE ::CallDllStd( "RMC_SETSERIESYAXIS", ... )
   METHOD SetSingleBarColors( ... )        INLINE ::CallDllStd( "RMC_SETSINGLEBARCOLORS", ... )
   METHOD SetTooltipWidth( ... )           INLINE ::CallDllStd( "RMC_SETTOOLTIPWIDTH", ... )
   METHOD SetWaterMark( ... )              INLINE ::CallDllStd( "RMC_SETWATERMARK", ... )
   METHOD SetXAXAlignment( ... )           INLINE ::CallDllStd( "RMC_SETXYALIGNMENT", ... )
   METHOD SetYAXAlignment( ... )           INLINE ::CallDllStd( "RMC_SETYAXALIGNMENT", ... )
   METHOD SetXAXDecimalDigits( ... )       INLINE ::CallDllStd( "RMC_SETXAXDECIMALDIGITS", ... )
   METHOD SetYAXDecimalDigits( ... )       INLINE ::CallDllStd( "RMC_SETYAXDECIMALDIGITS", ... )
   METHOD SetXAXFontSize( ... )            INLINE ::CallDllStd( "RMC_SETXAXFONTSIZE", ... )
   METHOD SetYAXFontSize( ... )            INLINE ::CallDllStd( "RMC_SETYAXFONTSIZE", ... )
   METHOD SetXAXLabels( ... )              INLINE ::CallDllStd( "RMC_SETXAXLABELS", ... )
   METHOD SetYAXLabels( ... )              INLINE ::CallDllStd( "RMC_SETYAXLABELS", ... )
   METHOD SetXAXLabelAlignment( ... )      INLINE ::CallDllStd( "RMC_SETXAXLABELALIGNMENT", ... )
   METHOD SetYAXLabelAlignment( ... )      INLINE ::CallDllStd( "RMC_SETYAXLABELALIGNMENT", ... )
   METHOD SetXAXLineColor( ... )           INLINE ::CallDllStd( "RMC_SETXAXLINECOLOR", ... )
   METHOD SetYAXLineCOlor( ... )           INLINE ::CallDllStd( "RMC_SETYAXLINECOLOR", ... )
   METHOD SetXAXLineStyle( ... )           INLINE ::CallDllStd( "RMC_SETXAXLINESTYLE", ... )
   METHOD SetYAXLineStyle( ... )           INLINE ::CallDllStd( "RMC_SETYAXLINESTYLE", ... )
   METHOD SetXAXMaxValue( ... )            INLINE ::CallDllStd( "RMC_SETXAXMAXVALUE", ... )
   METHOD SetYAXMaxValue( ... )            INLINE ::CallDllStd( "RMC_SETYAXMAXVALUE", ... )
   METHOD SetXAXMinValue( ... )            INLINE ::CallDllStd( "RMC_SETXAXMINVALUE", ... )
   METHOD SetYAXMinValue( ... )            INLINE ::CallDllStd( "RMC_SETYAXMINVALUE", ... )
   METHOD SetXAXText( ... )                INLINE ::CallDllStd( "RMC_SETXAXTEXT", ... )
   METHOD SetYAXText( ... )                INLINE ::CallDllStd( "RMC_SETYAXTEXT", ... )
   METHOD SetXAXTextColor( ... )           INLINE ::CallDllStd( "RMC_SETXAXTEXTCOLOR", ... )
   METHOD SetYAXTextColor( ... )           INLINE ::CallDllStd( "RMC_SETYAXTEXTCOLOR", ... )
   METHOD SetXAXTickCount( ... )           INLINE ::CallDllStd( "RMC_SETXAXTICKCOUNT", ... )
   METHOD SetYAXTickCount( ... )           INLINE ::CallDllStd( "RMC_SETYAXTICKCOUNT", ... )
   METHOD SetXAXUnit( ... )                INLINE ::CallDllStd( "RMC_SETXAXUNIT", ... )
   METHOD SetYAXUnit( ... )                INLINE ::CallDllStd( "RMC_SETYAXUNIT", ... )
   METHOD ShowTooltips( ... )              INLINE ::CallDllStd( "RMC_SHOWTOOLTIPS", ... )
   METHOD Split( s, a )                    INLINE ::CallDllStd( "RMC_SPLIT", s, a )            // RMChart 4.14 String/Array
   METHOD Split2Double( s, a )             INLINE ::CallDllStd( "RMC_SPLIT2DOUBLE", s, a )     // RMChart 4.14 String/Array
   METHOD Split2Long( s, a )               INLINE ::CallDllStd( "RMC_SPLIT2LONG", s, a )       // RMChart 4.14 String/Array
   METHOD WriteRMCFile( ... )              INLINE ::CallDllStd( "RMC_WRITERMCFILE", ... )
   METHOD Zoom( ... )                      INLINE ::CallDllStd( "RMC_ZOOM", ... )
   METHOD CallDllStd( cName, ... )         INLINE hb_DynCall( { cName, ::hDLL, HB_DYN_CALLCONV_STDCALL }, ... )
   METHOD ToDecimal( xValue )              INLINE xValue + 1.01 - 1.01
   METHOD ToDouble( xValue )
   METHOD ToLong( xValue )

   ENDCLASS

METHOD ToDouble( xValue ) CLASS RMChartClass

   LOCAL cDouble := "", oElement

   DO CASE
   CASE ValType( xValue ) == "N"
      RETURN xValue
   CASE ValType( xValue ) == "A"
      FOR EACH oElement IN xValue
         cDouble += FToC( oElement )
      NEXT
   OTHERWISE
      RETURN 0
   ENDCASE

   RETURN cDouble

METHOD ToLong( xValue ) CLASS RMChartClass

   LOCAL cLong := "", oElement

   DO CASE
   CASE ValType( xValue ) == "N"
      RETURN xValue
   CASE ValType( xValue ) == "A"
      FOR EACH oElement IN xValue
         cLong += L2Bin( oElement )
      NEXT
   OTHERWISE
      RETURN 0
   ENDCASE

   RETURN cLong

METHOD FreeChartList() CLASS RMChartClass

   LOCAL nChart

   FOR EACH nChart IN ::aIdChartList
      ::Reset( nChart )
   NEXT

   RETURN Nil

METHOD Destroy() CLASS RMChartClass

   hb_libFree( ::hDLL )

   RETURN Nil
