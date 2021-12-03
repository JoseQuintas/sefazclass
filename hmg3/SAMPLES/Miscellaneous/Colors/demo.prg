/*
 * MiniGUI 'Table of Colors' Demo
 *
 * (c) 2011 Grigory Filatov <gfilatov@inbox.ru>
*/


#include "hmg.ch"

Static aColors

Procedure Main
Local aData := {}
Local lInit := .f.

	SET MULTIPLE OFF

	aEval( ( aColors := InitColorsArray() ), { |x| aAdd( aData, { "COLOR_"+ x[1] } ) } )

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT iif( IsWinXP(), 596, 600 ) ;
		TITLE 'Table of Colors' ;
		MAIN ;
		NOMAXIMIZE NOSIZE

		DEFINE MAIN MENU
			DEFINE POPUP '&File'
				MENUITEM '&Show Items Count'	ACTION MsgInfo(Form_1.Grid_1.ItemCount, "Items Count")
				SEPARATOR
            MENUITEM '&Copy to Clipboard' + Chr(9) + 'CTRL+C' ACTION CopyClipboard()
			END POPUP
		END MENU

		DEFINE GRID Grid_1
			ROW 	12
			COL	12
			WIDTH	370
			HEIGHT	iif( IsWinXP(), 497, 504 )
			WIDTHS	{ 350 - iif(IsAppThemed(), 2, 0) }
			VALUE	1
			VIRTUAL .T.
			ITEMCOUNT Len(aData)
			ON QUERYDATA OnDataRequest( aData )
			ON CHANGE iif( lInit, Show_RGB(), lInit := .t. )
			HEADERS {"HMG Color Name"}
			DYNAMICFORECOLOR { { |x,nItem| GetColumnForeColor( nItem ) } }
			DYNAMICBACKCOLOR { { |x,nItem| GetColumnBackColor( nItem ) } }
			FONTNAME "Verdana"
			FONTSIZE 10
		END GRID

		DEFINE STATUSBAR FONT "MS Sans serif" SIZE 9 BOLD
			STATUSITEM "Value RGB: " + aColors [ 1 ] [ 2 ]
		END STATUSBAR

      ON KEY CONTROL+C ACTION CopyClipboard()

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return


Procedure CopyClipboard
Local cText
Local nRow := Form_1.Grid_1.CellRowFocused
   IF nRow > 0
      cText := Form_1.Grid_1.CellEx (nRow, 1)
      System.Clipboard := cText
      MsgInfo (cText,"Copy to Clipboard")
   ENDIF
Return


Procedure OnDataRequest( aData )

 This.QueryData := aData [ This.QueryRowIndex ] [ 1 ]

Return


Procedure Show_RGB

 Form_1.StatusBar.Item( 1 ) := "Value RGB: " + aColors [ Form_1.Grid_1.Value ] [ 2 ]

Return


Function GetColumnForeColor( n )
Local aColor

 n := This.CellRowIndex

 Switch n
   case 27
     aColor := WHITE
     exit
   case 28
   case 34
   case 35
   case 61
   case 62
   case 99
   case 100
   case 184
   case 187
   case 188
   case 189
   case 190
   case 191
   case 192
   case 195
   case 196
   case 200
   case 204
   case 208
   case 220
   case 260
   case 268
   case 272
   case 320
   case 324
   case 336
   case 340
   case 344
   case 348
   case 352
   case 356
   case 360
   case 364
   case 368
   case 372
   case 376
   case 380
   case 384
   case 388
   case 392
   case 396
   case 400
   case 404
   case 408
   case 412
   case 416
   case 424
   case 428
   case 432
   case 436
   case 441
   case 442
   case 443
   case 444
   case 445
   case 451
   case 452
   case 453
   case 454
     aColor := YELLOW
     exit
   otherwise
     aColor := BLACK
 EndSwitch

Return aColor


Function GetColumnBackColor( n )
Local cColor

 n := This.CellRowIndex

 cColor := aColors [ n ] [ 2 ]

Return { Val( Token( cColor, " ", 1 ) ), Val( Token( cColor, " ", 2 ) ), Val( Token( cColor, " ", 3 ) ) }


Function GetHeaderForeColor( n )
Local cColor := aColors [ n ] [ 2 ]
Return { Val( Token( cColor, " ", 1 ) ), Val( Token( cColor, " ", 2 ) ), Val( Token( cColor, " ", 3 ) ) }


Static Function IsWinXP()
  Local aVer := WinVersion()

Return "XP" $ aVer[1]


Static Function InitColorsArray()

Local aClrData := { ;
 {"Snow", "255 250 250"} ,;
 {"GhostWhite", "248 248 255"} ,;
 {"WhiteSmoke", "245 245 245"} ,;
 {"Gainsboro", "220 220 220"} ,;
 {"FloralWhite", "255 250 240"} ,;
 {"OldLace", "253 245 230"} ,;
 {"Linen", "250 240 230"} ,;
 {"AntiqueWhite", "250 235 215"} ,;
 {"PapayaWhip", "255 239 213"} ,;
 {"BlanchedAlmond", "255 235 205"} ,;
 {"Bisque", "255 228 196"} ,;
 {"PeachPuff", "255 218 185"} ,;
 {"NavajoWhite", "255 222 173"} ,;
 {"Moccasin", "255 228 181"} ,;
 {"Cornsilk", "255 248 220"} ,;
 {"Ivory", "255 255 240"} ,;
 {"LemonChiffon", "255 250 205"} ,;
 {"Seashell", "255 245 238"} ,;
 {"Honeydew", "240 255 240"} ,;
 {"MintCream", "245 255 250"} ,;
 {"Azure", "240 255 255"} ,;
 {"AliceBlue", "240 248 255"} ,;
 {"Lavender", "230 230 250"} ,;
 {"LavenderBlush", "255 240 245"} ,;
 {"MistyRose", "255 228 225"} ,;
 {"White", "255 255 255"} ,;
 {"Black", "0 0 0"} ,;
 {"DarkSlateGray", "47 79 79"} ,;
 {"DimGrey", "105 105 105"} ,;
 {"SlateGrey", "112 128 144"} ,;
 {"LightSlateGray", "119 136 153"} ,;
 {"Grey", "190 190 190"} ,;
 {"LightGray", "211 211 211"} ,;
 {"MidnightBlue", "25 25 112"} ,;
 {"NavyBlue (Navy)", "0 0 128"} ,;
 {"CornflowerBlue", "100 149 237"} ,;
 {"DarkSlateBlue", "72 61 139"} ,;
 {"SlateBlue", "106 90 205"} ,;
 {"MediumSlateBlue", "123 104 238"} ,;
 {"LightSlateBlue", "132 112 255"} ,;
 {"MediumBlue", "0 0 205"} ,;
 {"RoyalBlue", "65 105 225"} ,;
 {"Blue", "0 0 255"} ,;
 {"DodgerBlue", "30 144 255"} ,;
 {"DeepSkyBlue", "0 191 255"} ,;
 {"SkyBlue", "135 206 235"} ,;
 {"LightSkyBlue", "135 206 250"} ,;
 {"SteelBlue", "70 130 180"} ,;
 {"LightSteelBlue", "176 196 222"} ,;
 {"LightBlue", "173 216 230"} ,;
 {"PowderBlue", "176 224 230"} ,;
 {"PaleTurquoise", "175 238 238"} ,;
 {"DarkTurquoise", "0 206 209"} ,;
 {"MediumTurquoise", "72 209 204"} ,;
 {"Turquoise", "64 224 208"} ,;
 {"Cyan", "0 255 255"} ,;
 {"LightCyan", "224 255 255"} ,;
 {"CadetBlue", "95 158 160"} ,;
 {"MediumAquamarine", "102 205 170"} ,;
 {"Aquamarine", "127 255 212"} ,;
 {"DarkGreen", "0 100 0"} ,;
 {"DarkOliveGreen", "85 107 47"} ,;
 {"DarkSeaGreen", "143 188 143"} ,;
 {"SeaGreen", "46 139 87"} ,;
 {"MediumSeaGreen", "60 179 113"} ,;
 {"LightSeaGreen", "32 178 170"} ,;
 {"PaleGreen", "152 251 152"} ,;
 {"SpringGreen", "0 255 127"} ,;
 {"LawnGreen", "124 252 0"} ,;
 {"Green", "0 255 0"} ,;
 {"Chartreuse", "127 255 0"} ,;
 {"MediumSpringGreen", "0 250 154"} ,;
 {"GreenYellow", "173 255 47"} ,;
 {"LimeGreen", "50 205 50"} ,;
 {"YellowGreen", "154 205 50"} ,;
 {"ForestGreen", "34 139 34"} ,;
 {"OliveDrab", "107 142 35"} ,;
 {"DarkKhaki", "189 183 107"} ,;
 {"Khaki", "240 230 140"} ,;
 {"PaleGoldenrod", "238 232 170"} ,;
 {"LightGoldenrodYellow", "250 250 210"} ,;
 {"LightYellow", "255 255 224"} ,;
 {"Yellow", "255 255 0"} ,;
 {"Gold", "255 215 0"} ,;
 {"LightGoldenrod", "238 221 130"} ,;
 {"Goldenrod", "218 165 32"} ,;
 {"DarkGoldenrod", "184 134 11"} ,;
 {"RosyBrown", "188 143 143"} ,;
 {"IndianRed", "205 92 92"} ,;
 {"SaddleBrown", "139 69 19"} ,;
 {"Sienna", "160 82 45"} ,;
 {"Peru", "205 133 63"} ,;
 {"Burlywood", "222 184 135"} ,;
 {"Beige", "245 245 220"} ,;
 {"Wheat", "245 222 179"} ,;
 {"SandyBrown", "244 164 96"} ,;
 {"Tan", "210 180 140"} ,;
 {"Chocolate", "210 105 30"} ,;
 {"Firebrick", "178 34 34"} ,;
 {"Brown", "165 42 42"} ,;
 {"DarkSalmon", "233 150 122"} ,;
 {"Salmon", "250 128 114"} ,;
 {"LightSalmon", "255 160 122"} ,;
 {"Orange", "255 165 0"} ,;
 {"DarkOrange", "255 140 0"} ,;
 {"Coral", "255 127 80"} ,;
 {"LightCoral", "240 128 128"} ,;
 {"Tomato", "255 99 71"} ,;
 {"OrangeRed", "255 69 0"} ,;
 {"Red", "255 0 0"} ,;
 {"HotPink", "255 105 180"} ,;
 {"DeepPink", "255 20 147"} ,;
 {"Pink", "255 192 203"} ,;
 {"LightPink", "255 182 193"} ,;
 {"PaleVioletRed", "219 112 147"} ,;
 {"Maroon", "176 48 96"} ,;
 {"MediumVioletRed", "199 21 133"} ,;
 {"VioletRed", "208 32 144"} ,;
 {"Magenta", "255 0 255"} ,;
 {"Violet", "238 130 238"} ,;
 {"Plum", "221 160 221"} ,;
 {"Orchid", "218 112 214"} ,;
 {"MediumOrchid", "186 85 211"} ,;
 {"DarkOrchid", "153 50 204"} ,;
 {"BlueViolet", "138 43 226"} ,;
 {"Purple", "160 32 240"} ,;
 {"MediumPurple", "147 112 219"} ,;
 {"Thistle", "216 191 216"} ,;
 {"Snow1", "255 250 250"} ,;
 {"Snow2", "238 233 233"} ,;
 {"Snow3", "205 201 201"} ,;
 {"Snow4", "139 137 137"} ,;
 {"Seashell1", "255 245 238"} ,;
 {"Seashell2", "238 229 222"} ,;
 {"Seashell3", "205 197 191"} ,;
 {"Seashell4", "139 134 130"} ,;
 {"AntiqueWhite1", "255 239 219"} ,;
 {"AntiqueWhite2", "238 223 204"} ,;
 {"AntiqueWhite3", "205 192 176"} ,;
 {"AntiqueWhite4", "139 131 120"} ,;
 {"Bisque1", "255 228 196"} ,;
 {"Bisque2", "238 213 183"} ,;
 {"Bisque3", "205 183 158"} ,;
 {"Bisque4", "139 125 107"} ,;
 {"PeachPuff1", "255 218 185"} ,;
 {"PeachPuff2", "238 203 173"} ,;
 {"PeachPuff3", "205 175 149"} ,;
 {"PeachPuff4", "139 119 101"} ,;
 {"NavajoWhite1", "255 222 173"} ,;
 {"NavajoWhite2", "238 207 161"} ,;
 {"NavajoWhite3", "205 179 139"} ,;
 {"NavajoWhite4", "139 121 94"} ,;
 {"LemonChiffon1", "255 250 205"} ,;
 {"LemonChiffon2", "238 233 191"} ,;
 {"LemonChiffon3", "205 201 165"} ,;
 {"LemonChiffon4", "139 137 112"} ,;
 {"Cornsilk1", "255 248 220"} ,;
 {"Cornsilk2", "238 232 205"} ,;
 {"Cornsilk3", "205 200 177"} ,;
 {"Cornsilk4", "139 136 120"} ,;
 {"Ivory1", "255 255 240"} ,;
 {"Ivory2", "238 238 224"} ,;
 {"Ivory3", "205 205 193"} ,;
 {"Ivory4", "139 139 131"} ,;
 {"Honeydew1", "240 255 240"} ,;
 {"Honeydew2", "224 238 224"} ,;
 {"Honeydew3", "193 205 193"} ,;
 {"Honeydew4", "131 139 131"} ,;
 {"LavenderBlush1", "255 240 245"} ,;
 {"LavenderBlush2", "238 224 229"} ,;
 {"LavenderBlush3", "205 193 197"} ,;
 {"LavenderBlush4", "139 131 134"} ,;
 {"MistyRose1", "255 228 225"} ,;
 {"MistyRose2", "238 213 210"} ,;
 {"MistyRose3", "205 183 181"} ,;
 {"MistyRose4", "139 125 123"} ,;
 {"Azure1", "240 255 255"} ,;
 {"Azure2", "224 238 238"} ,;
 {"Azure3", "193 205 205"} ,;
 {"Azure4", "131 139 139"} ,;
 {"SlateBlue1", "131 111 255"} ,;
 {"SlateBlue2", "122 103 238"} ,;
 {"SlateBlue3", "105 89 205"} ,;
 {"SlateBlue4", "71 60 139"} ,;
 {"RoyalBlue1", "72 118 255"} ,;
 {"RoyalBlue2", "67 110 238"} ,;
 {"RoyalBlue3", "58 95 205"} ,;
 {"RoyalBlue4", "39 64 139"} ,;
 {"Blue1", "0 0 255"} ,;
 {"Blue2", "0 0 238"} ,;
 {"Blue3", "0 0 205"} ,;
 {"Blue4", "0 0 139"} ,;
 {"DodgerBlue1", "30 144 255"} ,;
 {"DodgerBlue2", "28 134 238"} ,;
 {"DodgerBlue3", "24 116 205"} ,;
 {"DodgerBlue4", "16 78 139"} ,;
 {"SteelBlue1", "99 184 255"} ,;
 {"SteelBlue2", "92 172 238"} ,;
 {"SteelBlue3", "79 148 205"} ,;
 {"SteelBlue4", "54 100 139"} ,;
 {"DeepSkyBlue1", "0 191 255"} ,;
 {"DeepSkyBlue2", "0 178 238"} ,;
 {"DeepSkyBlue3", "0 154 205"} ,;
 {"DeepSkyBlue4", "0 104 139"} ,;
 {"SkyBlue1", "135 206 255"} ,;
 {"SkyBlue2", "126 192 238"} ,;
 {"SkyBlue3", "108 166 205"} ,;
 {"SkyBlue4", "74 112 139"} ,;
 {"LightSkyBlue1", "176 226 255"} ,;
 {"LightSkyBlue2", "164 211 238"} ,;
 {"LightSkyBlue3", "141 182 205"} ,;
 {"LightSkyBlue4", "96 123 139"} ,;
 {"SlateGray1", "198 226 255"} ,;
 {"SlateGray2", "185 211 238"} ,;
 {"SlateGray3", "159 182 205"} ,;
 {"SlateGray4", "108 123 139"} ,;
 {"LightSteelBlue1", "202 225 255"} ,;
 {"LightSteelBlue2", "188 210 238"} ,;
 {"LightSteelBlue3", "162 181 205"} ,;
 {"LightSteelBlue4", "110 123 139"} ,;
 {"LightBlue1", "191 239 255"} ,;
 {"LightBlue2", "178 223 238"} ,;
 {"LightBlue3", "154 192 205"} ,;
 {"LightBlue4", "104 131 139"} ,;
 {"LightCyan1", "224 255 255"} ,;
 {"LightCyan2", "209 238 238"} ,;
 {"LightCyan3", "180 205 205"} ,;
 {"LightCyan4", "122 139 139"} ,;
 {"PaleTurquoise1", "187 255 255"} ,;
 {"PaleTurquoise2", "174 238 238"} ,;
 {"PaleTurquoise3", "150 205 205"} ,;
 {"PaleTurquoise4", "102 139 139"} ,;
 {"CadetBlue1", "152 245 255"} ,;
 {"CadetBlue2", "142 229 238"} ,;
 {"CadetBlue3", "122 197 205"} ,;
 {"CadetBlue4", "83 134 139"} ,;
 {"Turquoise1", "0 245 255"} ,;
 {"Turquoise2", "0 229 238"} ,;
 {"Turquoise3", "0 197 205"} ,;
 {"Turquoise4", "0 134 139"} ,;
 {"Cyan1", "0 255 255"} ,;
 {"Cyan2", "0 238 238"} ,;
 {"Cyan3", "0 205 205"} ,;
 {"Cyan4", "0 139 139"} ,;
 {"DarkSlateGray1", "151 255 255"} ,;
 {"DarkSlateGray2", "141 238 238"} ,;
 {"DarkSlateGray3", "121 205 205"} ,;
 {"DarkSlateGray4", "82 139 139"} ,;
 {"Aquamarine1", "127 255 212"} ,;
 {"Aquamarine2", "118 238 198"} ,;
 {"Aquamarine3", "102 205 170"} ,;
 {"Aquamarine4", "69 139 116"} ,;
 {"DarkSeaGreen1", "193 255 193"} ,;
 {"DarkSeaGreen2", "180 238 180"} ,;
 {"DarkSeaGreen3", "155 205 155"} ,;
 {"DarkSeaGreen4", "105 139 105"} ,;
 {"SeaGreen1", "84 255 159"} ,;
 {"SeaGreen2", "78 238 148"} ,;
 {"SeaGreen3", "67 205 128"} ,;
 {"SeaGreen4", "46 139 87"} ,;
 {"PaleGreen1", "154 255 154"} ,;
 {"PaleGreen2", "144 238 144"} ,;
 {"PaleGreen3", "124 205 124"} ,;
 {"PaleGreen4", "84 139 84"} ,;
 {"SpringGreen1", "0 255 127"} ,;
 {"SpringGreen2", "0 238 118"} ,;
 {"SpringGreen3", "0 205 102"} ,;
 {"SpringGreen4", "0 139 69"} ,;
 {"Green1", "0 255 0"} ,;
 {"Green2", "0 238 0"} ,;
 {"Green3", "0 205 0"} ,;
 {"Green4", "0 139 0"} ,;
 {"Chartreuse1", "127 255 0"} ,;
 {"Chartreuse2", "118 238 0"} ,;
 {"Chartreuse3", "102 205 0"} ,;
 {"Chartreuse4", "69 139 0"} ,;
 {"OliveDrab1", "192 255 62"} ,;
 {"OliveDrab2", "179 238 58"} ,;
 {"OliveDrab3", "154 205 50"} ,;
 {"OliveDrab4", "105 139 34"} ,;
 {"DarkOliveGreen1", "202 255 112"} ,;
 {"DarkOliveGreen2", "188 238 104"} ,;
 {"DarkOliveGreen3", "162 205 90"} ,;
 {"DarkOliveGreen4", "110 139 61"} ,;
 {"Khaki1", "255 246 143"} ,;
 {"Khaki2", "238 230 133"} ,;
 {"Khaki3", "205 198 115"} ,;
 {"Khaki4", "139 134 78"} ,;
 {"LightGoldenrod1", "255 236 139"} ,;
 {"LightGoldenrod2", "238 220 130"} ,;
 {"LightGoldenrod3", "205 190 112"} ,;
 {"LightGoldenrod4", "139 129 76"} ,;
 {"LightYellow1", "255 255 224"} ,;
 {"LightYellow2", "238 238 209"} ,;
 {"LightYellow3", "205 205 180"} ,;
 {"LightYellow4", "139 139 122"} ,;
 {"Yellow1", "255 255 0"} ,;
 {"Yellow2", "238 238 0"} ,;
 {"Yellow3", "205 205 0"} ,;
 {"Yellow4", "139 139 0"} ,;
 {"Gold1", "255 215 0"} ,;
 {"Gold2", "238 201 0"} ,;
 {"Gold3", "205 173 0"} ,;
 {"Gold4", "139 117 0"} ,;
 {"Goldenrod1", "255 193 37"} ,;
 {"Goldenrod2", "238 180 34"} ,;
 {"Goldenrod3", "205 155 29"} ,;
 {"Goldenrod4", "139 105 20"} ,;
 {"DarkGoldenrod1", "255 185 15"} ,;
 {"DarkGoldenrod2", "238 173 14"} ,;
 {"DarkGoldenrod3", "205 149 12"} ,;
 {"DarkGoldenrod4", "139 101 8"} ,;
 {"RosyBrown1", "255 193 193"} ,;
 {"RosyBrown2", "238 180 180"} ,;
 {"RosyBrown3", "205 155 155"} ,;
 {"RosyBrown4", "139 105 105"} ,;
 {"IndianRed1", "255 106 106"} ,;
 {"IndianRed2", "238 99 99"} ,;
 {"IndianRed3", "205 85 85"} ,;
 {"IndianRed4", "139 58 58"} ,;
 {"Sienna1", "255 130 71"} ,;
 {"Sienna2", "238 121 66"} ,;
 {"Sienna3", "205 104 57"} ,;
 {"Sienna4", "139 71 38"} ,;
 {"Burlywood1", "255 211 155"} ,;
 {"Burlywood2", "238 197 145"} ,;
 {"Burlywood3", "205 170 125"} ,;
 {"Burlywood4", "139 115 85"} ,;
 {"Wheat1", "255 231 186"} ,;
 {"Wheat2", "238 216 174"} ,;
 {"Wheat3", "205 186 150"} ,;
 {"Wheat4", "139 126 102"} ,;
 {"Tan1", "255 165 79"} ,;
 {"Tan2", "238 154 73"} ,;
 {"Tan3", "205 133 63"} ,;
 {"Tan4", "139 90 43"} ,;
 {"Chocolate1", "255 127 36"} ,;
 {"Chocolate2", "238 118 33"} ,;
 {"Chocolate3", "205 102 29"} ,;
 {"Chocolate4", "139 69 19"} ,;
 {"Firebrick1", "255 48 48"} ,;
 {"Firebrick2", "238 44 44"} ,;
 {"Firebrick3", "205 38 38"} ,;
 {"Firebrick4", "139 26 26"} ,;
 {"Brown1", "255 64 64"} ,;
 {"Brown2", "238 59 59"} ,;
 {"Brown3", "205 51 51"} ,;
 {"Brown4", "139 35 35"} ,;
 {"Salmon1", "255 140 105"} ,;
 {"Salmon2", "238 130 98"} ,;
 {"Salmon3", "205 112 84"} ,;
 {"Salmon4", "139 76 57"} ,;
 {"LightSalmon1", "255 160 122"} ,;
 {"LightSalmon2", "238 149 114"} ,;
 {"LightSalmon3", "205 129 98"} ,;
 {"LightSalmon4", "139 87 66"} ,;
 {"Orange1", "255 165 0"} ,;
 {"Orange2", "238 154 0"} ,;
 {"Orange3", "205 133 0"} ,;
 {"Orange4", "139 90 0"} ,;
 {"DarkOrange1", "255 127 0"} ,;
 {"DarkOrange2", "238 118 0"} ,;
 {"DarkOrange3", "205 102 0"} ,;
 {"DarkOrange4", "139 69 0"} ,;
 {"Coral1", "255 114 86"} ,;
 {"Coral2", "238 106 80"} ,;
 {"Coral3", "205 91 69"} ,;
 {"Coral4", "139 62 47"} ,;
 {"Tomato1", "255 99 71"} ,;
 {"Tomato2", "238 92 66"} ,;
 {"Tomato3", "205 79 57"} ,;
 {"Tomato4", "139 54 38"} ,;
 {"OrangeRed1", "255 69 0"} ,;
 {"OrangeRed2", "238 64 0"} ,;
 {"OrangeRed3", "205 55 0"} ,;
 {"OrangeRed4", "139 37 0"} ,;
 {"Red1", "255 0 0"} ,;
 {"Red2", "238 0 0"} ,;
 {"Red3", "205 0 0"} ,;
 {"Red4", "139 0 0"} ,;
 {"DeepPink1", "255 20 147"} ,;
 {"DeepPink2", "238 18 137"} ,;
 {"DeepPink3", "205 16 118"} ,;
 {"DeepPink4", "139 10 80"} ,;
 {"HotPink1", "255 110 180"} ,;
 {"HotPink2", "238 106 167"} ,;
 {"HotPink3", "205 96 144"} ,;
 {"HotPink4", "139 58 98"} ,;
 {"Pink1", "255 181 197"} ,;
 {"Pink2", "238 169 184"} ,;
 {"Pink3", "205 145 158"} ,;
 {"Pink4", "139 99 108"} ,;
 {"LightPink1", "255 174 185"} ,;
 {"LightPink2", "238 162 173"} ,;
 {"LightPink3", "205 140 149"} ,;
 {"LightPink4", "139 95 101"} ,;
 {"PaleVioletRed1", "255 130 171"} ,;
 {"PaleVioletRed2", "238 121 159"} ,;
 {"PaleVioletRed3", "205 104 137"} ,;
 {"PaleVioletRed4", "139 71 93"} ,;
 {"Maroon1", "255 52 179"} ,;
 {"Maroon2", "238 48 167"} ,;
 {"Maroon3", "205 41 144"} ,;
 {"Maroon4", "139 28 98"} ,;
 {"VioletRed1", "255 62 150"} ,;
 {"VioletRed2", "238 58 140"} ,;
 {"VioletRed3", "205 50 120"} ,;
 {"VioletRed4", "139 34 82"} ,;
 {"Magenta1", "255 0 255"} ,;
 {"Magenta2", "238 0 238"} ,;
 {"Magenta3", "205 0 205"} ,;
 {"Magenta4", "139 0 139"} ,;
 {"Orchid1", "255 131 250"} ,;
 {"Orchid2", "238 122 233"} ,;
 {"Orchid3", "205 105 201"} ,;
 {"Orchid4", "139 71 137"} ,;
 {"Plum1", "255 187 255"} ,;
 {"Plum2", "238 174 238"} ,;
 {"Plum3", "205 150 205"} ,;
 {"Plum4", "139 102 139"} ,;
 {"MediumOrchid1", "224 102 255"} ,;
 {"MediumOrchid2", "209 95 238"} ,;
 {"MediumOrchid3", "180 82 205"} ,;
 {"MediumOrchid4", "122 55 139"} ,;
 {"DarkOrchid1", "191 62 255"} ,;
 {"DarkOrchid2", "178 58 238"} ,;
 {"DarkOrchid3", "154 50 205"} ,;
 {"DarkOrchid4", "104 34 139"} ,;
 {"Purple1", "155 48 255"} ,;
 {"Purple2", "145 44 238"} ,;
 {"Purple3", "125 38 205"} ,;
 {"Purple4", "85 26 139"} ,;
 {"MediumPurple1", "171 130 255"} ,;
 {"MediumPurple2", "159 121 238"} ,;
 {"MediumPurple3", "137 104 205"} ,;
 {"MediumPurple4", "93 71 139"} ,;
 {"Thistle1", "255 225 255"} ,;
 {"Thistle2", "238 210 238"} ,;
 {"Thistle3", "205 181 205"} ,;
 {"Thistle4", "139 123 139"} ,;
 {"grey11", "28 28 28"} ,;
 {"grey21", "54 54 54"} ,;
 {"grey31", "79 79 79"} ,;
 {"grey41", "105 105 105"} ,;
 {"grey51", "130 130 130"} ,;
 {"grey61", "156 156 156"} ,;
 {"grey71", "181 181 181"} ,;
 {"grey81", "207 207 207"} ,;
 {"grey91", "232 232 232"} ,;
 {"DarkGrey", "169 169 169"} ,;
 {"DarkBlue", "0 0 139"} ,;
 {"DarkCyan", "0 139 139"} ,;
 {"DarkMagenta", "139 0 139"} ,;
 {"DarkRed", "139 0 0"} ,;
 {"LightGreen", "144 238 144"} }

/*
Text := ""
FOR i = 1 TO HMG_LEN (aClrData)
   cColor := aClrData [i] [2]
   cRGB := PADL( Token( cColor, " ", 1 ) ,3) +" , "+ PADL( Token( cColor, " ", 2 ) ,3) +" , "+ PADL( Token( cColor, " ", 3 ) ,3)
   Text := Text + "#xtranslate   " + PAD ("COLOR_"+ aClrData [i] [1], 20) +  "   =>   { "+ cRGB +" }" + HB_OsNewLine()
NEXT
HB_MemoWrit ("colors.ch", Text)
*/

Return aClrData
