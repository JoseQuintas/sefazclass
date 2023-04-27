/*
ze_rmchart.ch - to use ze_rmchart.prg
*/

/* RMC default */
#define RMC_DEFAULT                      0

/* RMC_Colors */
#define RMC_COLOR_ALICE_BLUE             -984833
#define RMC_COLOR_ANTIQUE_WHITE          -332841
#define RMC_COLOR_AQUAMARINE             -8388652
#define RMC_COLOR_ARMY_GREEN             -10053274
#define RMC_COLOR_AUTUMN_ORANGE          -39373
#define RMC_COLOR_AVOCADO_GREEN          -10053325
#define RMC_COLOR_AZURE                  -983041
#define RMC_COLOR_BABY_BLUE              -10053121
#define RMC_COLOR_BANANA_YELLOW          -3355597
#define RMC_COLOR_BEIGE                  -657956
#define RMC_COLOR_BISQUE                 -6972
#define RMC_COLOR_BLACK                  -16777216
#define RMC_COLOR_BLANCHED_ALMOND        -5171
#define RMC_COLOR_BLUE                   -16776961
#define RMC_COLOR_BLUE_VIOLET            -7722014
#define RMC_COLOR_BROWN                  -5952982
#define RMC_COLOR_BURLYWOOD              -2180985
#define RMC_COLOR_CADET_BLUE             -10510688
#define RMC_COLOR_CHALK                  -103
#define RMC_COLOR_CHARTREUSE             -8388864
#define RMC_COLOR_CHOCOLATE              -2987746
#define RMC_COLOR_CORAL                  -32944
#define RMC_COLOR_CORN_FLOWER_BLUE       -10185235
#define RMC_COLOR_CORN_SILK              -1828
#define RMC_COLOR_CRIMSON                -2354116
#define RMC_COLOR_CYAN                   -16711681
#define RMC_COLOR_DARK_BLUE              -16777077
#define RMC_COLOR_DARK_BROWN             -10079437
#define RMC_COLOR_DARK_CRIMSON           -6737050
#define RMC_COLOR_DARK_CYAN              -16741493
#define RMC_COLOR_DARK_GOLD              -3368653
#define RMC_COLOR_DARK_GOLDENROD         -4684277
#define RMC_COLOR_DARK_GRAY              -5658199
#define RMC_COLOR_DARK_GREEN             -16751616
#define RMC_COLOR_DARK_KHAKI             -4343957
#define RMC_COLOR_DARK_MAGENTA           -7667573
#define RMC_COLOR_DARK_OLIVE_GREEN       -11179217
#define RMC_COLOR_DARK_ORANGE            -29696
#define RMC_COLOR_DARK_ORCHID            -6737204
#define RMC_COLOR_DARK_RED               -7667712
#define RMC_COLOR_DARK_SALMON            -1468806
#define RMC_COLOR_DARK_SEA_GREEN         -7357301
#define RMC_COLOR_DARK_SLATE_BLUE        -12042869
#define RMC_COLOR_DARK_SLATE_GRAY        -13676721
#define RMC_COLOR_DARK_TURQUOISE         -16724271
#define RMC_COLOR_DARK_VIOLET            -7077677
#define RMC_COLOR_DEEP_AZURE             -10079233
#define RMC_COLOR_DEEP_PINK              -60269
#define RMC_COLOR_DEEP_PURPLE            -13434778
#define RMC_COLOR_DEEP_RIVER             -10092340
#define RMC_COLOR_DEEP_ROSE              -3394663
#define RMC_COLOR_DEEP_SKY_BLUE          -16728065
#define RMC_COLOR_DEEP_YELLOW            -13312
#define RMC_COLOR_DEFAULT                0
#define RMC_COLOR_DESERT_BLUE            -13408615
#define RMC_COLOR_DIM_GRAY               -9868951
#define RMC_COLOR_DODGER_BLUE            -14774017
#define RMC_COLOR_DULL_GREEN             -6697882
#define RMC_COLOR_EASTER_PURPLE          -3368449
#define RMC_COLOR_FADE_GREEN             -6697831
#define RMC_COLOR_FIREBRICK              -5103070
#define RMC_COLOR_FLORAL_WHITE           -1296
#define RMC_COLOR_FOREST_GREEN           -14513374
#define RMC_COLOR_GAINSBORO              -2302756
#define RMC_COLOR_GHOST_WHITE            -460545
#define RMC_COLOR_GHOST_GREEN            -3342388
#define RMC_COLOR_GOLD                   -10496
#define RMC_COLOR_GOLDENROD              -2448096
#define RMC_COLOR_GRAPE                  -10079335
#define RMC_COLOR_GRASS_GREEN            -16737997
#define RMC_COLOR_GRAY                   -8355712
#define RMC_COLOR_GREEN                  -16744448
#define RMC_COLOR_GREEN_YELLOW           -5374161
#define RMC_COLOR_MONKEYDEW              -983056
#define RMC_COLOR_HOT_PINK               -38476
#define RMC_COLOR_INDIAN_RED             -3318692
#define RMC_COLOR_INDIGO                 -11861886
#define RMC_COLOR_IVORY                  -16
#define RMC_COLOR_KHAKI                  -989556
#define RMC_COLOR_KENTUCKY_GREEN         -13395610
#define RMC_COLOR_LAVENDER               -1644806
#define RMC_COLOR_LAVENDER_BLUSH         -3851
#define RMC_COLOR_LAWN_GREEN             -8586240
#define RMC_COLOR_LEMON_CHIFFON          -1331
#define RMC_COLOR_LIGHT_BLUE             -5383962
#define RMC_COLOR_LIGHT_CORAL            -1015680
#define RMC_COLOR_LIGHT_CYAN             -2031617
#define RMC_COLOR_LIGHT_GOLDENROD        -1122942
#define RMC_COLOR_LIGHT_GOLDENROD_YELLOW -329006
#define RMC_COLOR_LIGHT_GRAY             -2894893
#define RMC_COLOR_LIGHT_GREEN            -7278960
#define RMC_COLOR_LIGHT_ORANGE           -26317
#define RMC_COLOR_LIGHT_PINK             -18751
#define RMC_COLOR_LIGHT_SALMON           -24454
#define RMC_COLOR_LIGHT_SEA_GREEN        -14634326
#define RMC_COLOR_LIGHT_SKY_BLUE         -7876870
#define RMC_COLOR_LIGHT_SLATE_GRAY       -8943463
#define RMC_COLOR_LIGHT_STEEL_BLUE       -5192482
#define RMC_COLOR_LIGHT_VIOLET           -26113
#define RMC_COLOR_LIGHT_YELLOW           -32
#define RMC_COLOR_LIME                   -16711936
#define RMC_COLOR_LIME_GREEN             -13447886
#define RMC_COLOR_LINEN                  -331546
#define RMC_COLOR_MAGENTA                -65281
#define RMC_COLOR_MAROON                 -8388608
#define RMC_COLOR_MARTIAN_GREEN          -6697933
#define RMC_COLOR_MEDIUM_AQUAMARINE      -10039894
#define RMC_COLOR_MEDIUM_BLUE            -16777011
#define RMC_COLOR_MEDIUM_ORCHID          -4565549
#define RMC_COLOR_MEDIUM_PURPLE          -7114533
#define RMC_COLOR_MEDIUM_SEA_GREEN       -12799119
#define RMC_COLOR_MEDIUM_SLATE_BLUE      -8689426
#define RMC_COLOR_MEDIUM_SPRING_GREEN    -16713062
#define RMC_COLOR_MEDIUM_TURQUOISE       -12004916
#define RMC_COLOR_MEDIUM_VIOLET_RED      -3730043
#define RMC_COLOR_MIDNIGHT_BLUE          -15132304
#define RMC_COLOR_MINT_CREAM             -655366
#define RMC_COLOR_MISTY_ROSE             -6943
#define RMC_COLOR_MOCCASIN               -6987
#define RMC_COLOR_MOON_GREEN             -3342490
#define RMC_COLOR_MOSS_GREEN             -13408666
#define RMC_COLOR_NAVAJO_WHITE           -8531
#define RMC_COLOR_NAVY                   -16777088
#define RMC_COLOR_OCEAN_GREEN            -10053223
#define RMC_COLOR_OLD_LACE               -133658
#define RMC_COLOR_OLIVE                  -8355840
#define RMC_COLOR_OLIVE_DRAB             -9728477
#define RMC_COLOR_ORANGE                 -23296
#define RMC_COLOR_ORANGE_RED             -47872
#define RMC_COLOR_ORCHID                 -2461482
#define RMC_COLOR_PALE_GOLDENROD         -1120086
#define RMC_COLOR_PALE_GREEN             -6751336
#define RMC_COLOR_PALE_TURQUOISE         -5247250
#define RMC_COLOR_PALE_VIOLET_RED        -2396013
#define RMC_COLOR_PALE_YELLOW            -52
#define RMC_COLOR_PAPAYA_WHIP            -4139
#define RMC_COLOR_PEACH_PUFF             -9543
#define RMC_COLOR_PERU                   -3308225
#define RMC_COLOR_PINK                   -16181
#define RMC_COLOR_PLUM                   -2252579
#define RMC_COLOR_POWDER_BLUE            -5185306
#define RMC_COLOR_PURPLE                 -8388480
#define RMC_COLOR_RED                    -65536
#define RMC_COLOR_ROSY_BROWN             -4419697
#define RMC_COLOR_ROYAL_BLUE             -12490271
#define RMC_COLOR_SADDLE_BROWN           -7650029
#define RMC_COLOR_SALMON                 -360334
#define RMC_COLOR_SAND                   -13159
#define RMC_COLOR_SANDY_BROWN            -744352
#define RMC_COLOR_SEA_GREEN              -13726889
#define RMC_COLOR_SEA_SHELL              -2578
#define RMC_COLOR_SIENNA                 -6270419
#define RMC_COLOR_SILVER                 -4144960
#define RMC_COLOR_SKY_BLUE               -7876885
#define RMC_COLOR_SLATE_BLUE             -9807155
#define RMC_COLOR_SLATE_GRAY             -9404272
#define RMC_COLOR_SNOW                   -1286
#define RMC_COLOR_SPRING_GREEN           -16711809
#define RMC_COLOR_STEEL_BLUE             -12156236
#define RMC_COLOR_TAN                    -2968436
#define RMC_COLOR_TEAL                   -16744320
#define RMC_COLOR_THISTLE                -2572328
#define RMC_COLOR_TOMATO                 -40121
#define RMC_COLOR_TRANSPARENT            -2
#define RMC_COLOR_TROPICAL_PINK          -39322
#define RMC_COLOR_TURQUOISE              -12525360
#define RMC_COLOR_VIOLET                 -1146130
#define RMC_COLOR_VIOLET_RED             -3137392
#define RMC_COLOR_WALNUT                 -10079488
#define RMC_COLOR_WHEAT                  -663885
#define RMC_COLOR_WHITE                  -1
#define RMC_COLOR_WHITE_SMOKE            -657931
#define RMC_COLOR_YELLOW                 -256
#define RMC_COLOR_YELLOW_GREEN           -6632142

/* CtrlStyle */
#define RMC_CTRLSTYLEFLAT                0
#define RMC_CTRLSTYLEFLATSHADOW          1
#define RMC_CTRLSTYLE3D                  2
#define RMC_CTRLSTYLE3DLIGHT             3
#define RMC_CTRLSTYLEIMAGE               4
#define RMC_CTRLSTYLEIMAGETILED          5

/* SeriesType */
#define RMC_BARSERIES                    1
#define RMC_LINESERIES                   2
#define RMC_GRIDLESSSERIES               3 // sample VB=2 duplicated???
#define RMC_VOLUMEBARSERIES              4
#define RMC_HIGHLOWSERIES                5
#define RMC_XYSERIES                     6

/* BarSeriesType */
#define RMC_BARSINGLE                    1
#define RMC_BARGROUP                     2
#define RMC_BARSTACKED                   3
#define RMC_BARSTACKED100                4
#define RMC_FLOATINGBAR                  5
#define RMC_FLOATINGBARGROUP             6

/* LineSeriesType */
#define RMC_LINE                         21
#define RMC_AREA                         22
#define RMC_LINE_INDEXED                 23
#define RMC_AREA_INDEXED                 24
#define RMC_AREA_STACKED                 25
#define RMC_AREA_STACKED100              26

/* BarSeriesStyle */
#define RMC_BAR_FLAT                     1
#define RMC_BAR_FLAT_GRADIENT1           2
#define RMC_BAR_FLAT_GRADIENT2           3
#define RMC_BAR_HOVER                    4
#define RMC_COLUMN_FLAT                  5
#define RMC_BAR_3D                       6
#define RMC_BAR_3D_GRADIENT              7
#define RMC_COLUMN_3D                    8
#define RMC_COLUMN_3D_GRADIENT           9
#define RMC_COLUMN_FLUTED                10

/* CTypes only for tRMC_INFO */
#define RMC_VOLBAR                       31
#define RMC_HIGHLOW                      41
#define RMC_GRIDLESS                     51
#define RMC_CUSTOMLINE                   60
#define RMC_XYCHART                      70
#define RMC_GRIDBASED                    10

/* LineSeriesStyle */
#define RMC_LINE_FLAT                    21
#define RMC_LINE_FLAT_DOT                19
#define RMC_LINE_FLAT_DASH               18
#define RMC_LINE_FLAT_DASHDOT            17
#define RMC_LINE_FLAT_DASHDOTDOT         16
#define RMC_LINE_CABLE                   22
#define RMC_LINE_3D                      23
#define RMC_LINE_3D_GRADIENT             24
#define RMC_AREA_FLAT                    25
#define RMC_AREA_FLAT_GRADIENT_V         26
#define RMC_AREA_FLAT_GRADIENT_H         27
#define RMC_AREA_FLAT_GRADIENT_C         28
#define RMC_AREA_3D                      29
#define RMC_AREA_3D_GRADIENT_V           30
#define RMC_AREA_3D_GRADIENT_H           31
#define RMC_AREA_3D_GRADIENT_C           32
#define RMC_LINE_CABLE_SHADOW            34
#define RMC_LINE_SYMBOLONLY              35

/* LineSeriesStyle */
#define RMC_LSTYLE_LINE                  1
#define RMC_LSTYLE_SPLINE                2
#define RMC_LSTYLE_STAIR                 3
#define RMC_LSTYLE_LINE_AREA             4 // Draws a line and a transparent area
#define RMC_LSTYLE_SPLINE_AREA           5 // Draws a spline and a transparent area
#define RMC_LSTYLE_STAIR_AREA            6 // Draws a stair and a transparent area

/* LineSeriesSymbol */
#define RMC_SYMBOL_NONE                  0
#define RMC_SYMBOL_BULLET                21
#define RMC_SYMBOL_ROUND                 1
#define RMC_SYMBOL_DIAMOND               2
#define RMC_SYMBOL_SQUARE                3
#define RMC_SYMBOL_STAR                  4
#define RMC_SYMBOL_ARROW_DOWN            5
#define RMC_SYMBOL_ARROW_UP              6
#define RMC_SYMBOL_POINT                 7
#define RMC_SYMBOL_CIRCLE                8
#define RMC_SYMBOL_RECTANGLE             9
#define RMC_SYMBOL_CROSS                 10
#define RMC_SYMBOL_BULLET_SMALL          22
#define RMC_SYMBOL_ROUND_SMALL           11
#define RMC_SYMBOL_DIAMOND_SMALL         12
#define RMC_SYMBOL_SQUARE_SMALL          13
#define RMC_SYMBOL_STAR_SMALL            14
#define RMC_SYMBOL_ARROW_DOWN_SMALL      15
#define RMC_SYMBOL_ARROW_UP_SMALL        16
#define RMC_SYMBOL_POINT_SMALL           17
#define RMC_SYMBOL_CIRCLE_SMALL          18
#define RMC_SYMBOL_RECTANGLE_SMALL       19
#define RMC_SYMBOL_CROSS_SMALL           20

/* HighLowSeriesStyle */
#define RMC_OHLC                         1
#define RMC_CANDLESTICK                  2
#define RMC_VOLUMEBAR                    31

/* GridlessSeriesStyle */
#define RMC_PIE_FLAT                     51
#define RMC_PIE_GRADIENT                 52
#define RMC_PIE_3D                       53
#define RMC_PIE_3D_GRADIENT              54
#define RMC_DONUT_FLAT                   55
#define RMC_DONUT_GRADIENT               56
#define RMC_DONUT_3D                     57
#define RMC_DONUT_3D_GRADIENT            58
#define RMC_PYRAMIDE                     59
#define RMC_PYRAMIDE3                    60

/* PieDonutAlignment */
#define RMC_FULL                         1
#define RMC_HALF_TOP                     2
#define RMC_HALF_RIGHT                   3
#define RMC_HALF_BOTTOM                  4
#define RMC_HALF_LEFT                    5

/* XYSeriesStyle */
#define RMC_XY_LINE                      70
#define RMC_XY_LINE_DOT                  69
#define RMC_XY_LINE_DASH                 68
#define RMC_XY_LINE_DASHDOT              67
#define RMC_XY_LINE_DASHDOTDOT           66
#define RMC_XY_SYMBOL                    71
#define RMC_XY_CABLE                     73

/* Hatchmodes */
#define RMC_HATCHBRUSH_OFF               0
#define RMC_HATCHBRUSH_ON                1
#define RMC_HATCHBRUSH_ONPRINTING        2

/* DAxisAlignment */
#define RMC_DATAAXISLEFT                 1
#define RMC_DATAAXISRIGHT                2
#define RMC_DATAAXISTOP                  3
#define RMC_DATAAXISBOTTOM               4

/* LAxisAlignment */
#define RMC_LABELAXISLEFT                5
#define RMC_LABELAXISRIGHT               6
#define RMC_LABELAXISTOP                 7
#define RMC_LABELAXISBOTTOM              8

/* XAxisAlignment */
#define RMC_XAXISBOTTOM                  12
#define RMC_XAXISTOP                     11

/* YAxisAlignment */
#define RMC_YAXISLEFT                    9
#define RMC_YAXISRIGHT                   10

/* AxisType */
#define RMC_DATAAXIS                     1
#define RMC_LABELAXIS                    2

/* AxisLineStyle */
#define RMC_LINESTYLESOLID               0
#define RMC_LINESTYLEDASH                1
#define RMC_LINESTYLEDOT                 2
#define RMC_LINESTYLEDASHDOT             3
#define RMC_LINESTYLENONE                6

/* LabelTextAlignment */
#define RMC_TEXTCENTER                   0
#define RMC_TEXTLEFT                     1
#define RMC_TEXTRIGHT                    2
#define RMC_TEXTDOWNWARD                 3
#define RMC_TEXTUPWARD                   4

/* LegendAlignment */
#define RMC_LEGEND_NONE                  -1
#define RMC_LEGEND_TOP                   1
#define RMC_LEGEND_LEFT                  2
#define RMC_LEGEND_RIGHT                 3
#define RMC_LEGEND_BOTTOM                4
#define RMC_LEGEND_UL                    5
#define RMC_LEGEND_UR                    6
#define RMC_LEGEND_LL                    7
#define RMC_LEGEND_LR                    8
#define RMC_LEGEND_ONVLABELS             9
#define RMC_LEGEND_CUSTOM_TOP            11
#define RMC_LEGEND_CUSTOM_LEFT           12
#define RMC_LEGEND_CUSTOM_RIGHT          13
#define RMC_LEGEND_CUSTOM_BOTTOM         14
#define RMC_LEGEND_CUSTOM_UL             15
#define RMC_LEGEND_CUSTOM_UR             16
#define RMC_LEGEND_CUSTOM_LL             17
#define RMC_LEGEND_CUSTOM_LR             18
#define RMC_LEGEND_CUSTOM_CENTER         19
#define RMC_LEGEND_CUSTOM_CR             20
#define RMC_LEGEND_CUSTOM_CL             21

/* LegendStyle */
#define RMC_LEGENDNORECT                 1
#define RMC_LEGENDRECT                   2
#define RMC_LEGENDRECTSHADOW             3
#define RMC_LEGENDROUNDRECT              4
#define RMC_LEGENDROUNDRECTSHADOW        5

/* ValueLabels */
#define RMC_VLABEL_NONE                  0
#define RMC_VLABEL_DEFAULT               1
#define RMC_VLABEL_PERCENT               5
#define RMC_VLABEL_ABSOLUTE              6
#define RMC_VLABEL_TWIN                  7
#define RMC_VLABEL_LEGENDONLY            8
#define RMC_VLABEL_DEFAULT_NOZERO        11
#define RMC_VLABEL_PERCENT_NOZERO        15
#define RMC_VLABEL_ABSOLUTE_NOZERO       16
#define RMC_VLABEL_TWIN_NOZERO           17

/* GridBicolorMode */
#define RMC_BICOLOR_NONE                 0
#define RMC_BICOLOR_DATAAXIS             1
#define RMC_BICOLOR_LABELAXIS            2
#define RMC_BICOLOR_BOTH                 3

/* RMCError */
#define RMC_ERROR_MAXINST                -1
#define RMC_ERROR_MAXREGION              -2
#define RMC_ERROR_MAXSERIES              -3
#define RMC_ERROR_ALLOC                  -4
#define RMC_ERROR_NODATA                 -5
#define RMC_ERROR_CTRLID                 -6
#define RMC_ERROR_SERIESINDEX            -7
#define RMC_ERROR_CREATEBITMAP           -8
#define RMC_ERROR_WRONGREGION            -9
#define RMC_ERROR_PARENTHANDLE           -10
#define RMC_ERROR_CREATEWINDOW           -11
#define RMC_ERROR_INIGDIP                -12
#define RMC_ERROR_PRINT                  -13
#define RMC_ERROR_NOGDIP                 -14
#define RMC_ERROR_RMCFILE                -15
#define RMC_ERROR_FILEFOUND              -16
#define RMC_ERROR_READLINES              -17
#define RMC_ERROR_XYAXIS                 -18
#define RMC_ERROR_LEGENDTEXT             -19
#define RMC_ERROR_EMF                    -20
#define RMC_ERROR_NODATA_COUNT           -21
#define RMC_ERROR_NODATA_ZERO            -22
#define RMC_ERROR_NOCOLOR                -23
#define RMC_ERROR_CLIPBOARD              -24
#define RMC_ERROR_CBINFO                 -25
#define RMC_ERROR_FILECREATE             -26
#define RMC_ERROR_MAXCUSTOM              -27
#define RMC_ERROR_DATAINDEX              -28
#define RMC_ERROR_AXISALIGNMENT          -29
#define RMC_ERROR_ARRAYDIM               -90
#define RMC_ERROR_LEGENDSIZE             1

/* RMCFileType */
#define RMC_EMF                          1
#define RMC_EMFPLUS                      2
#define RMC_BMP                          3

/* Custom Objects */

/* CO Type */
#define RMC_CO_TEXT                      1
#define RMC_CO_BOX                       2
#define RMC_CO_CIRCLE                    3
#define RMC_CO_LINE                      4
#define RMC_CO_IMAGE                     5
#define RMC_CO_SYMBOL                    6
#define RMC_CO_POLYGON                   7

/* Line alignment for custom text */
#define RMC_LINE_HORIZONTAL              0
#define RMC_LINE_UPWARD                  1
#define RMC_LINE_DOWNWARD                3

/* Line style for Custom lines */
#define RMC_FLAT_LINE                    21
#define RMC_DOT_LINE                     19
#define RMC_DASH_LINE                    18
#define RMC_DASHDOT_LINE                 17
#define RMC_DASHDOTDOT_LINE              16

/* Anchors for custom lines */
#define RMC_ANCHOR_NONE                  0
#define RMC_ANCHOR_ROUND                 1
#define RMC_ANCHOR_BULLET                2
#define RMC_ANCHOR_ARROW_CLOSED          3
#define RMC_ANCHOR_ARROW_OPEN            4

/* Styles for custom box/text */
#define RMC_BOX_NONE                     0
#define RMC_BOX_FLAT                     1
#define RMC_BOX_ROUNDEDGE                2
#define RMC_BOX_RHOMBUS                  3
#define RMC_BOX_GRADIENTH                4
#define RMC_BOX_GRADIENTV                5
#define RMC_BOX_3D                       6
#define RMC_BOX_FLAT_SHADOW              7
#define RMC_BOX_GRADIENTH_SHADOW         8
#define RMC_BOX_GRADIENTV_SHADOW         9
#define RMC_BOX_3D_SHADOW                10

/* Styles for custom Circle */
#define RMC_CIRCLE_FLAT                  1
#define RMC_CIRCLE_BULLET                2

/* Zoom mode */
#define RMC_ZOOM_DISABLE                 0
#define RMC_ZOOM_EXTERNAL                1
#define RMC_ZOOM_INTERNAL                2

/* nChartType in tRMC_INFO holds one of these when in zoom- or magnifier-mode */
#define RMC_ZOOM_MODE                   -99
#define RMC_MAGNIFIER_MODE              -98

/* RMCMouseButton */
#define RMC_MOUSEMOVE                   &H200
#define RMC_LBUTTONDOWN                 &H201
#define RMC_LBUTTONUP                   &H202
#define RMC_LBUTTONDBLCLK               &H203
#define RMC_RBUTTONDOWN                 &H204
#define RMC_RBUTTONUP                   &H205
#define RMC_RBUTTONDBLCLK               &H206
#define RMC_MBUTTONDOWN                 &H207
#define RMC_MBUTTONUP                   &H208
#define RMC_MBUTTONDBLCLK               &H209
#define RMC_SHIFTLBUTTONDOWN            &H20A
#define RMC_SHIFTLBUTTONUP              &H20B
#define RMC_SHIFTLBUTTONDBLCLK          &H20C
#define RMC_SHIFTRBUTTONDOWN            &H20D
#define RMC_SHIFTRBUTTONUP              &H20E
#define RMC_SHIFTRBUTTONDBLCLK          &H20F
#define RMC_SHIFTMBUTTONDOWN            &H210
#define RMC_SHIFTMBUTTONUP              &H211
#define RMC_SHIFTMBUTTONDBLCLK          &H212
#define RMC_CTRLLBUTTONDOWN             &H213
#define RMC_CTRLLBUTTONUP               &H214
#define RMC_CTRLLBUTTONDBLCLK           &H215
#define RMC_CTRLRBUTTONDOWN             &H216
#define RMC_CTRLRBUTTONUP               &H217
#define RMC_CTRLRBUTTONDBLCLK           &H218
#define RMC_CTRLMBUTTONDOWN             &H219
#define RMC_CTRLMBUTTONUP               &H21A
#define RMC_CTRLMBUTTONDBLCLK           &H21B

/* ExplodeMode */
#define RMC_EXPLODE_NONE                0
#define RMC_EXPLODE_SMALLEST            -1
#define RMC_EXPLODE_BIGGEST             -2

/* RMC_CreateMode */
#define RMC_CREATEIT                    0
#define RMC_RESETIT                     1

/* ReturnType */
#define RMC_RETDOUBLE                   0
#define RMC_RETLONG                     1
#define RMC_RETSTRING                   2

#define RMC_USERWM         ""               // Your watermark
#define RMC_USERWMCOLOR    RMC_COLOR_BLACK  // Color for the watermark
#define RMC_USERWMLUCENT   30               // Lucent factor between 1(=not visible) and 255(=opaque)
#define RMC_USERWMALIGN    RMC_TEXTCENTER   // Alignment for the watermark
#define RMC_USERFONTSIZE   0                // Fontsize; if 0: maximal size is used
