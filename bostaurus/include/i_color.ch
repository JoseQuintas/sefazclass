/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2016 Dr. Claudio Soto <srvet@adinet.com.uy>
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
   Copyright 1999-2003, http://www.harbour-project.org/

   "WHAT32"
   Copyright 2002 AJ Wos <andrwos@aust1.net>

   "HWGUI"
   Copyright 2001-2007 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/
#define BLACK     {   0 ,   0 ,   0 }
#define WHITE     { 255 , 255 , 255 }
#define GRAY      { 128 , 128 , 128 }
#define RED       { 255 ,   0 ,   0 }
#define GREEN     {   0 , 255 ,   0 }
#define BLUE      {   0 ,   0 , 255 }
#define CYAN      { 153 , 217 , 234 }
#define YELLOW    { 255 , 255 ,   0 }
#define PINK      { 255 , 128 , 192 }
#define FUCHSIA   { 255 ,   0 , 255 }
#define BROWN     { 128 ,  64 ,  64 }
#define ORANGE    { 255 , 128 ,  64 }
#define PURPLE    { 128 ,   0 , 128 }

#define SILVER    { 192 , 192 , 192 }
#define MAROON    { 128 ,   0 ,   0 }
#define OLIVE     { 128 , 128 ,   0 }
#define LGREEN    {   0 , 128 ,   0 }
#define AQUA      {   0 , 255 , 255 }
#define NAVY      {   0 ,   0 , 128 }
#define TEAL      {   0 , 128 , 128 }

#xtranslate   COLOR_Snow               =>   { 255 , 250 , 250 }
#xtranslate   COLOR_GhostWhite         =>   { 248 , 248 , 255 }
#xtranslate   COLOR_WhiteSmoke         =>   { 245 , 245 , 245 }
#xtranslate   COLOR_Gainsboro          =>   { 220 , 220 , 220 }
#xtranslate   COLOR_FloralWhite        =>   { 255 , 250 , 240 }
#xtranslate   COLOR_OldLace            =>   { 253 , 245 , 230 }
#xtranslate   COLOR_Linen              =>   { 250 , 240 , 230 }
#xtranslate   COLOR_AntiqueWhite       =>   { 250 , 235 , 215 }
#xtranslate   COLOR_PapayaWhip         =>   { 255 , 239 , 213 }
#xtranslate   COLOR_BlanchedAlmond     =>   { 255 , 235 , 205 }
#xtranslate   COLOR_Bisque             =>   { 255 , 228 , 196 }
#xtranslate   COLOR_PeachPuff          =>   { 255 , 218 , 185 }
#xtranslate   COLOR_NavajoWhite        =>   { 255 , 222 , 173 }
#xtranslate   COLOR_Moccasin           =>   { 255 , 228 , 181 }
#xtranslate   COLOR_Cornsilk           =>   { 255 , 248 , 220 }
#xtranslate   COLOR_Ivory              =>   { 255 , 255 , 240 }
#xtranslate   COLOR_LemonChiffon       =>   { 255 , 250 , 205 }
#xtranslate   COLOR_Seashell           =>   { 255 , 245 , 238 }
#xtranslate   COLOR_Honeydew           =>   { 240 , 255 , 240 }
#xtranslate   COLOR_MintCream          =>   { 245 , 255 , 250 }
#xtranslate   COLOR_Azure              =>   { 240 , 255 , 255 }
#xtranslate   COLOR_AliceBlue          =>   { 240 , 248 , 255 }
#xtranslate   COLOR_Lavender           =>   { 230 , 230 , 250 }
#xtranslate   COLOR_LavenderBlush      =>   { 255 , 240 , 245 }
#xtranslate   COLOR_MistyRose          =>   { 255 , 228 , 225 }
#xtranslate   COLOR_White              =>   { 255 , 255 , 255 }
#xtranslate   COLOR_Black              =>   {   0 ,   0 ,   0 }
#xtranslate   COLOR_DarkSlateGray      =>   {  47 ,  79 ,  79 }
#xtranslate   COLOR_DimGrey            =>   { 105 , 105 , 105 }
#xtranslate   COLOR_SlateGrey          =>   { 112 , 128 , 144 }
#xtranslate   COLOR_LightSlateGray     =>   { 119 , 136 , 153 }
#xtranslate   COLOR_Grey               =>   { 190 , 190 , 190 }
#xtranslate   COLOR_LightGray          =>   { 211 , 211 , 211 }
#xtranslate   COLOR_MidnightBlue       =>   {  25 ,  25 , 112 }
#xtranslate   COLOR_NavyBlue           =>   {   0 ,   0 , 128 }
#xtranslate   COLOR_CornflowerBlue     =>   { 100 , 149 , 237 }
#xtranslate   COLOR_DarkSlateBlue      =>   {  72 ,  61 , 139 }
#xtranslate   COLOR_SlateBlue          =>   { 106 ,  90 , 205 }
#xtranslate   COLOR_MediumSlateBlue    =>   { 123 , 104 , 238 }
#xtranslate   COLOR_LightSlateBlue     =>   { 132 , 112 , 255 }
#xtranslate   COLOR_MediumBlue         =>   {   0 ,   0 , 205 }
#xtranslate   COLOR_RoyalBlue          =>   {  65 , 105 , 225 }
#xtranslate   COLOR_Blue               =>   {   0 ,   0 , 255 }
#xtranslate   COLOR_DodgerBlue         =>   {  30 , 144 , 255 }
#xtranslate   COLOR_DeepSkyBlue        =>   {   0 , 191 , 255 }
#xtranslate   COLOR_SkyBlue            =>   { 135 , 206 , 235 }
#xtranslate   COLOR_LightSkyBlue       =>   { 135 , 206 , 250 }
#xtranslate   COLOR_SteelBlue          =>   {  70 , 130 , 180 }
#xtranslate   COLOR_LightSteelBlue     =>   { 176 , 196 , 222 }
#xtranslate   COLOR_LightBlue          =>   { 173 , 216 , 230 }
#xtranslate   COLOR_PowderBlue         =>   { 176 , 224 , 230 }
#xtranslate   COLOR_PaleTurquoise      =>   { 175 , 238 , 238 }
#xtranslate   COLOR_DarkTurquoise      =>   {   0 , 206 , 209 }
#xtranslate   COLOR_MediumTurquoise    =>   {  72 , 209 , 204 }
#xtranslate   COLOR_Turquoise          =>   {  64 , 224 , 208 }
#xtranslate   COLOR_Cyan               =>   {   0 , 255 , 255 }
#xtranslate   COLOR_LightCyan          =>   { 224 , 255 , 255 }
#xtranslate   COLOR_CadetBlue          =>   {  95 , 158 , 160 }
#xtranslate   COLOR_MediumAquamarine   =>   { 102 , 205 , 170 }
#xtranslate   COLOR_Aquamarine         =>   { 127 , 255 , 212 }
#xtranslate   COLOR_DarkGreen          =>   {   0 , 100 ,   0 }
#xtranslate   COLOR_DarkOliveGreen     =>   {  85 , 107 ,  47 }
#xtranslate   COLOR_DarkSeaGreen       =>   { 143 , 188 , 143 }
#xtranslate   COLOR_SeaGreen           =>   {  46 , 139 ,  87 }
#xtranslate   COLOR_MediumSeaGreen     =>   {  60 , 179 , 113 }
#xtranslate   COLOR_LightSeaGreen      =>   {  32 , 178 , 170 }
#xtranslate   COLOR_PaleGreen          =>   { 152 , 251 , 152 }
#xtranslate   COLOR_SpringGreen        =>   {   0 , 255 , 127 }
#xtranslate   COLOR_LawnGreen          =>   { 124 , 252 ,   0 }
#xtranslate   COLOR_Green              =>   {   0 , 255 ,   0 }
#xtranslate   COLOR_Chartreuse         =>   { 127 , 255 ,   0 }
#xtranslate   COLOR_MediumSpringGree   =>   {   0 , 250 , 154 }
#xtranslate   COLOR_GreenYellow        =>   { 173 , 255 ,  47 }
#xtranslate   COLOR_LimeGreen          =>   {  50 , 205 ,  50 }
#xtranslate   COLOR_YellowGreen        =>   { 154 , 205 ,  50 }
#xtranslate   COLOR_ForestGreen        =>   {  34 , 139 ,  34 }
#xtranslate   COLOR_OliveDrab          =>   { 107 , 142 ,  35 }
#xtranslate   COLOR_DarkKhaki          =>   { 189 , 183 , 107 }
#xtranslate   COLOR_Khaki              =>   { 240 , 230 , 140 }
#xtranslate   COLOR_PaleGoldenrod      =>   { 238 , 232 , 170 }
#xtranslate   COLOR_LightGoldenrodYe   =>   { 250 , 250 , 210 }
#xtranslate   COLOR_LightYellow        =>   { 255 , 255 , 224 }
#xtranslate   COLOR_Yellow             =>   { 255 , 255 ,   0 }
#xtranslate   COLOR_Gold               =>   { 255 , 215 ,   0 }
#xtranslate   COLOR_LightGoldenrod     =>   { 238 , 221 , 130 }
#xtranslate   COLOR_Goldenrod          =>   { 218 , 165 ,  32 }
#xtranslate   COLOR_DarkGoldenrod      =>   { 184 , 134 ,  11 }
#xtranslate   COLOR_RosyBrown          =>   { 188 , 143 , 143 }
#xtranslate   COLOR_IndianRed          =>   { 205 ,  92 ,  92 }
#xtranslate   COLOR_SaddleBrown        =>   { 139 ,  69 ,  19 }
#xtranslate   COLOR_Sienna             =>   { 160 ,  82 ,  45 }
#xtranslate   COLOR_Peru               =>   { 205 , 133 ,  63 }
#xtranslate   COLOR_Burlywood          =>   { 222 , 184 , 135 }
#xtranslate   COLOR_Beige              =>   { 245 , 245 , 220 }
#xtranslate   COLOR_Wheat              =>   { 245 , 222 , 179 }
#xtranslate   COLOR_SandyBrown         =>   { 244 , 164 ,  96 }
#xtranslate   COLOR_Tan                =>   { 210 , 180 , 140 }
#xtranslate   COLOR_Chocolate          =>   { 210 , 105 ,  30 }
#xtranslate   COLOR_Firebrick          =>   { 178 ,  34 ,  34 }
#xtranslate   COLOR_Brown              =>   { 165 ,  42 ,  42 }
#xtranslate   COLOR_DarkSalmon         =>   { 233 , 150 , 122 }
#xtranslate   COLOR_Salmon             =>   { 250 , 128 , 114 }
#xtranslate   COLOR_LightSalmon        =>   { 255 , 160 , 122 }
#xtranslate   COLOR_Orange             =>   { 255 , 165 ,   0 }
#xtranslate   COLOR_DarkOrange         =>   { 255 , 140 ,   0 }
#xtranslate   COLOR_Coral              =>   { 255 , 127 ,  80 }
#xtranslate   COLOR_LightCoral         =>   { 240 , 128 , 128 }
#xtranslate   COLOR_Tomato             =>   { 255 ,  99 ,  71 }
#xtranslate   COLOR_OrangeRed          =>   { 255 ,  69 ,   0 }
#xtranslate   COLOR_Red                =>   { 255 ,   0 ,   0 }
#xtranslate   COLOR_HotPink            =>   { 255 , 105 , 180 }
#xtranslate   COLOR_DeepPink           =>   { 255 ,  20 , 147 }
#xtranslate   COLOR_Pink               =>   { 255 , 192 , 203 }
#xtranslate   COLOR_LightPink          =>   { 255 , 182 , 193 }
#xtranslate   COLOR_PaleVioletRed      =>   { 219 , 112 , 147 }
#xtranslate   COLOR_Maroon             =>   { 176 ,  48 ,  96 }
#xtranslate   COLOR_MediumVioletRed    =>   { 199 ,  21 , 133 }
#xtranslate   COLOR_VioletRed          =>   { 208 ,  32 , 144 }
#xtranslate   COLOR_Magenta            =>   { 255 ,   0 , 255 }
#xtranslate   COLOR_Violet             =>   { 238 , 130 , 238 }
#xtranslate   COLOR_Plum               =>   { 221 , 160 , 221 }
#xtranslate   COLOR_Orchid             =>   { 218 , 112 , 214 }
#xtranslate   COLOR_MediumOrchid       =>   { 186 ,  85 , 211 }
#xtranslate   COLOR_DarkOrchid         =>   { 153 ,  50 , 204 }
#xtranslate   COLOR_BlueViolet         =>   { 138 ,  43 , 226 }
#xtranslate   COLOR_Purple             =>   { 160 ,  32 , 240 }
#xtranslate   COLOR_MediumPurple       =>   { 147 , 112 , 219 }
#xtranslate   COLOR_Thistle            =>   { 216 , 191 , 216 }
#xtranslate   COLOR_Snow1              =>   { 255 , 250 , 250 }
#xtranslate   COLOR_Snow2              =>   { 238 , 233 , 233 }
#xtranslate   COLOR_Snow3              =>   { 205 , 201 , 201 }
#xtranslate   COLOR_Snow4              =>   { 139 , 137 , 137 }
#xtranslate   COLOR_Seashell1          =>   { 255 , 245 , 238 }
#xtranslate   COLOR_Seashell2          =>   { 238 , 229 , 222 }
#xtranslate   COLOR_Seashell3          =>   { 205 , 197 , 191 }
#xtranslate   COLOR_Seashell4          =>   { 139 , 134 , 130 }
#xtranslate   COLOR_AntiqueWhite1      =>   { 255 , 239 , 219 }
#xtranslate   COLOR_AntiqueWhite2      =>   { 238 , 223 , 204 }
#xtranslate   COLOR_AntiqueWhite3      =>   { 205 , 192 , 176 }
#xtranslate   COLOR_AntiqueWhite4      =>   { 139 , 131 , 120 }
#xtranslate   COLOR_Bisque1            =>   { 255 , 228 , 196 }
#xtranslate   COLOR_Bisque2            =>   { 238 , 213 , 183 }
#xtranslate   COLOR_Bisque3            =>   { 205 , 183 , 158 }
#xtranslate   COLOR_Bisque4            =>   { 139 , 125 , 107 }
#xtranslate   COLOR_PeachPuff1         =>   { 255 , 218 , 185 }
#xtranslate   COLOR_PeachPuff2         =>   { 238 , 203 , 173 }
#xtranslate   COLOR_PeachPuff3         =>   { 205 , 175 , 149 }
#xtranslate   COLOR_PeachPuff4         =>   { 139 , 119 , 101 }
#xtranslate   COLOR_NavajoWhite1       =>   { 255 , 222 , 173 }
#xtranslate   COLOR_NavajoWhite2       =>   { 238 , 207 , 161 }
#xtranslate   COLOR_NavajoWhite3       =>   { 205 , 179 , 139 }
#xtranslate   COLOR_NavajoWhite4       =>   { 139 , 121 ,  94 }
#xtranslate   COLOR_LemonChiffon1      =>   { 255 , 250 , 205 }
#xtranslate   COLOR_LemonChiffon2      =>   { 238 , 233 , 191 }
#xtranslate   COLOR_LemonChiffon3      =>   { 205 , 201 , 165 }
#xtranslate   COLOR_LemonChiffon4      =>   { 139 , 137 , 112 }
#xtranslate   COLOR_Cornsilk1          =>   { 255 , 248 , 220 }
#xtranslate   COLOR_Cornsilk2          =>   { 238 , 232 , 205 }
#xtranslate   COLOR_Cornsilk3          =>   { 205 , 200 , 177 }
#xtranslate   COLOR_Cornsilk4          =>   { 139 , 136 , 120 }
#xtranslate   COLOR_Ivory1             =>   { 255 , 255 , 240 }
#xtranslate   COLOR_Ivory2             =>   { 238 , 238 , 224 }
#xtranslate   COLOR_Ivory3             =>   { 205 , 205 , 193 }
#xtranslate   COLOR_Ivory4             =>   { 139 , 139 , 131 }
#xtranslate   COLOR_Honeydew1          =>   { 240 , 255 , 240 }
#xtranslate   COLOR_Honeydew2          =>   { 224 , 238 , 224 }
#xtranslate   COLOR_Honeydew3          =>   { 193 , 205 , 193 }
#xtranslate   COLOR_Honeydew4          =>   { 131 , 139 , 131 }
#xtranslate   COLOR_LavenderBlush1     =>   { 255 , 240 , 245 }
#xtranslate   COLOR_LavenderBlush2     =>   { 238 , 224 , 229 }
#xtranslate   COLOR_LavenderBlush3     =>   { 205 , 193 , 197 }
#xtranslate   COLOR_LavenderBlush4     =>   { 139 , 131 , 134 }
#xtranslate   COLOR_MistyRose1         =>   { 255 , 228 , 225 }
#xtranslate   COLOR_MistyRose2         =>   { 238 , 213 , 210 }
#xtranslate   COLOR_MistyRose3         =>   { 205 , 183 , 181 }
#xtranslate   COLOR_MistyRose4         =>   { 139 , 125 , 123 }
#xtranslate   COLOR_Azure1             =>   { 240 , 255 , 255 }
#xtranslate   COLOR_Azure2             =>   { 224 , 238 , 238 }
#xtranslate   COLOR_Azure3             =>   { 193 , 205 , 205 }
#xtranslate   COLOR_Azure4             =>   { 131 , 139 , 139 }
#xtranslate   COLOR_SlateBlue1         =>   { 131 , 111 , 255 }
#xtranslate   COLOR_SlateBlue2         =>   { 122 , 103 , 238 }
#xtranslate   COLOR_SlateBlue3         =>   { 105 ,  89 , 205 }
#xtranslate   COLOR_SlateBlue4         =>   {  71 ,  60 , 139 }
#xtranslate   COLOR_RoyalBlue1         =>   {  72 , 118 , 255 }
#xtranslate   COLOR_RoyalBlue2         =>   {  67 , 110 , 238 }
#xtranslate   COLOR_RoyalBlue3         =>   {  58 ,  95 , 205 }
#xtranslate   COLOR_RoyalBlue4         =>   {  39 ,  64 , 139 }
#xtranslate   COLOR_Blue1              =>   {   0 ,   0 , 255 }
#xtranslate   COLOR_Blue2              =>   {   0 ,   0 , 238 }
#xtranslate   COLOR_Blue3              =>   {   0 ,   0 , 205 }
#xtranslate   COLOR_Blue4              =>   {   0 ,   0 , 139 }
#xtranslate   COLOR_DodgerBlue1        =>   {  30 , 144 , 255 }
#xtranslate   COLOR_DodgerBlue2        =>   {  28 , 134 , 238 }
#xtranslate   COLOR_DodgerBlue3        =>   {  24 , 116 , 205 }
#xtranslate   COLOR_DodgerBlue4        =>   {  16 ,  78 , 139 }
#xtranslate   COLOR_SteelBlue1         =>   {  99 , 184 , 255 }
#xtranslate   COLOR_SteelBlue2         =>   {  92 , 172 , 238 }
#xtranslate   COLOR_SteelBlue3         =>   {  79 , 148 , 205 }
#xtranslate   COLOR_SteelBlue4         =>   {  54 , 100 , 139 }
#xtranslate   COLOR_DeepSkyBlue1       =>   {   0 , 191 , 255 }
#xtranslate   COLOR_DeepSkyBlue2       =>   {   0 , 178 , 238 }
#xtranslate   COLOR_DeepSkyBlue3       =>   {   0 , 154 , 205 }
#xtranslate   COLOR_DeepSkyBlue4       =>   {   0 , 104 , 139 }
#xtranslate   COLOR_SkyBlue1           =>   { 135 , 206 , 255 }
#xtranslate   COLOR_SkyBlue2           =>   { 126 , 192 , 238 }
#xtranslate   COLOR_SkyBlue3           =>   { 108 , 166 , 205 }
#xtranslate   COLOR_SkyBlue4           =>   {  74 , 112 , 139 }
#xtranslate   COLOR_LightSkyBlue1      =>   { 176 , 226 , 255 }
#xtranslate   COLOR_LightSkyBlue2      =>   { 164 , 211 , 238 }
#xtranslate   COLOR_LightSkyBlue3      =>   { 141 , 182 , 205 }
#xtranslate   COLOR_LightSkyBlue4      =>   {  96 , 123 , 139 }
#xtranslate   COLOR_SlateGray1         =>   { 198 , 226 , 255 }
#xtranslate   COLOR_SlateGray2         =>   { 185 , 211 , 238 }
#xtranslate   COLOR_SlateGray3         =>   { 159 , 182 , 205 }
#xtranslate   COLOR_SlateGray4         =>   { 108 , 123 , 139 }
#xtranslate   COLOR_LightSteelBlue1    =>   { 202 , 225 , 255 }
#xtranslate   COLOR_LightSteelBlue2    =>   { 188 , 210 , 238 }
#xtranslate   COLOR_LightSteelBlue3    =>   { 162 , 181 , 205 }
#xtranslate   COLOR_LightSteelBlue4    =>   { 110 , 123 , 139 }
#xtranslate   COLOR_LightBlue1         =>   { 191 , 239 , 255 }
#xtranslate   COLOR_LightBlue2         =>   { 178 , 223 , 238 }
#xtranslate   COLOR_LightBlue3         =>   { 154 , 192 , 205 }
#xtranslate   COLOR_LightBlue4         =>   { 104 , 131 , 139 }
#xtranslate   COLOR_LightCyan1         =>   { 224 , 255 , 255 }
#xtranslate   COLOR_LightCyan2         =>   { 209 , 238 , 238 }
#xtranslate   COLOR_LightCyan3         =>   { 180 , 205 , 205 }
#xtranslate   COLOR_LightCyan4         =>   { 122 , 139 , 139 }
#xtranslate   COLOR_PaleTurquoise1     =>   { 187 , 255 , 255 }
#xtranslate   COLOR_PaleTurquoise2     =>   { 174 , 238 , 238 }
#xtranslate   COLOR_PaleTurquoise3     =>   { 150 , 205 , 205 }
#xtranslate   COLOR_PaleTurquoise4     =>   { 102 , 139 , 139 }
#xtranslate   COLOR_CadetBlue1         =>   { 152 , 245 , 255 }
#xtranslate   COLOR_CadetBlue2         =>   { 142 , 229 , 238 }
#xtranslate   COLOR_CadetBlue3         =>   { 122 , 197 , 205 }
#xtranslate   COLOR_CadetBlue4         =>   {  83 , 134 , 139 }
#xtranslate   COLOR_Turquoise1         =>   {   0 , 245 , 255 }
#xtranslate   COLOR_Turquoise2         =>   {   0 , 229 , 238 }
#xtranslate   COLOR_Turquoise3         =>   {   0 , 197 , 205 }
#xtranslate   COLOR_Turquoise4         =>   {   0 , 134 , 139 }
#xtranslate   COLOR_Cyan1              =>   {   0 , 255 , 255 }
#xtranslate   COLOR_Cyan2              =>   {   0 , 238 , 238 }
#xtranslate   COLOR_Cyan3              =>   {   0 , 205 , 205 }
#xtranslate   COLOR_Cyan4              =>   {   0 , 139 , 139 }
#xtranslate   COLOR_DarkSlateGray1     =>   { 151 , 255 , 255 }
#xtranslate   COLOR_DarkSlateGray2     =>   { 141 , 238 , 238 }
#xtranslate   COLOR_DarkSlateGray3     =>   { 121 , 205 , 205 }
#xtranslate   COLOR_DarkSlateGray4     =>   {  82 , 139 , 139 }
#xtranslate   COLOR_Aquamarine1        =>   { 127 , 255 , 212 }
#xtranslate   COLOR_Aquamarine2        =>   { 118 , 238 , 198 }
#xtranslate   COLOR_Aquamarine3        =>   { 102 , 205 , 170 }
#xtranslate   COLOR_Aquamarine4        =>   {  69 , 139 , 116 }
#xtranslate   COLOR_DarkSeaGreen1      =>   { 193 , 255 , 193 }
#xtranslate   COLOR_DarkSeaGreen2      =>   { 180 , 238 , 180 }
#xtranslate   COLOR_DarkSeaGreen3      =>   { 155 , 205 , 155 }
#xtranslate   COLOR_DarkSeaGreen4      =>   { 105 , 139 , 105 }
#xtranslate   COLOR_SeaGreen1          =>   {  84 , 255 , 159 }
#xtranslate   COLOR_SeaGreen2          =>   {  78 , 238 , 148 }
#xtranslate   COLOR_SeaGreen3          =>   {  67 , 205 , 128 }
#xtranslate   COLOR_SeaGreen4          =>   {  46 , 139 ,  87 }
#xtranslate   COLOR_PaleGreen1         =>   { 154 , 255 , 154 }
#xtranslate   COLOR_PaleGreen2         =>   { 144 , 238 , 144 }
#xtranslate   COLOR_PaleGreen3         =>   { 124 , 205 , 124 }
#xtranslate   COLOR_PaleGreen4         =>   {  84 , 139 ,  84 }
#xtranslate   COLOR_SpringGreen1       =>   {   0 , 255 , 127 }
#xtranslate   COLOR_SpringGreen2       =>   {   0 , 238 , 118 }
#xtranslate   COLOR_SpringGreen3       =>   {   0 , 205 , 102 }
#xtranslate   COLOR_SpringGreen4       =>   {   0 , 139 ,  69 }
#xtranslate   COLOR_Green1             =>   {   0 , 255 ,   0 }
#xtranslate   COLOR_Green2             =>   {   0 , 238 ,   0 }
#xtranslate   COLOR_Green3             =>   {   0 , 205 ,   0 }
#xtranslate   COLOR_Green4             =>   {   0 , 139 ,   0 }
#xtranslate   COLOR_Chartreuse1        =>   { 127 , 255 ,   0 }
#xtranslate   COLOR_Chartreuse2        =>   { 118 , 238 ,   0 }
#xtranslate   COLOR_Chartreuse3        =>   { 102 , 205 ,   0 }
#xtranslate   COLOR_Chartreuse4        =>   {  69 , 139 ,   0 }
#xtranslate   COLOR_OliveDrab1         =>   { 192 , 255 ,  62 }
#xtranslate   COLOR_OliveDrab2         =>   { 179 , 238 ,  58 }
#xtranslate   COLOR_OliveDrab3         =>   { 154 , 205 ,  50 }
#xtranslate   COLOR_OliveDrab4         =>   { 105 , 139 ,  34 }
#xtranslate   COLOR_DarkOliveGreen1    =>   { 202 , 255 , 112 }
#xtranslate   COLOR_DarkOliveGreen2    =>   { 188 , 238 , 104 }
#xtranslate   COLOR_DarkOliveGreen3    =>   { 162 , 205 ,  90 }
#xtranslate   COLOR_DarkOliveGreen4    =>   { 110 , 139 ,  61 }
#xtranslate   COLOR_Khaki1             =>   { 255 , 246 , 143 }
#xtranslate   COLOR_Khaki2             =>   { 238 , 230 , 133 }
#xtranslate   COLOR_Khaki3             =>   { 205 , 198 , 115 }
#xtranslate   COLOR_Khaki4             =>   { 139 , 134 ,  78 }
#xtranslate   COLOR_LightGoldenrod1    =>   { 255 , 236 , 139 }
#xtranslate   COLOR_LightGoldenrod2    =>   { 238 , 220 , 130 }
#xtranslate   COLOR_LightGoldenrod3    =>   { 205 , 190 , 112 }
#xtranslate   COLOR_LightGoldenrod4    =>   { 139 , 129 ,  76 }
#xtranslate   COLOR_LightYellow1       =>   { 255 , 255 , 224 }
#xtranslate   COLOR_LightYellow2       =>   { 238 , 238 , 209 }
#xtranslate   COLOR_LightYellow3       =>   { 205 , 205 , 180 }
#xtranslate   COLOR_LightYellow4       =>   { 139 , 139 , 122 }
#xtranslate   COLOR_Yellow1            =>   { 255 , 255 ,   0 }
#xtranslate   COLOR_Yellow2            =>   { 238 , 238 ,   0 }
#xtranslate   COLOR_Yellow3            =>   { 205 , 205 ,   0 }
#xtranslate   COLOR_Yellow4            =>   { 139 , 139 ,   0 }
#xtranslate   COLOR_Gold1              =>   { 255 , 215 ,   0 }
#xtranslate   COLOR_Gold2              =>   { 238 , 201 ,   0 }
#xtranslate   COLOR_Gold3              =>   { 205 , 173 ,   0 }
#xtranslate   COLOR_Gold4              =>   { 139 , 117 ,   0 }
#xtranslate   COLOR_Goldenrod1         =>   { 255 , 193 ,  37 }
#xtranslate   COLOR_Goldenrod2         =>   { 238 , 180 ,  34 }
#xtranslate   COLOR_Goldenrod3         =>   { 205 , 155 ,  29 }
#xtranslate   COLOR_Goldenrod4         =>   { 139 , 105 ,  20 }
#xtranslate   COLOR_DarkGoldenrod1     =>   { 255 , 185 ,  15 }
#xtranslate   COLOR_DarkGoldenrod2     =>   { 238 , 173 ,  14 }
#xtranslate   COLOR_DarkGoldenrod3     =>   { 205 , 149 ,  12 }
#xtranslate   COLOR_DarkGoldenrod4     =>   { 139 , 101 ,   8 }
#xtranslate   COLOR_RosyBrown1         =>   { 255 , 193 , 193 }
#xtranslate   COLOR_RosyBrown2         =>   { 238 , 180 , 180 }
#xtranslate   COLOR_RosyBrown3         =>   { 205 , 155 , 155 }
#xtranslate   COLOR_RosyBrown4         =>   { 139 , 105 , 105 }
#xtranslate   COLOR_IndianRed1         =>   { 255 , 106 , 106 }
#xtranslate   COLOR_IndianRed2         =>   { 238 ,  99 ,  99 }
#xtranslate   COLOR_IndianRed3         =>   { 205 ,  85 ,  85 }
#xtranslate   COLOR_IndianRed4         =>   { 139 ,  58 ,  58 }
#xtranslate   COLOR_Sienna1            =>   { 255 , 130 ,  71 }
#xtranslate   COLOR_Sienna2            =>   { 238 , 121 ,  66 }
#xtranslate   COLOR_Sienna3            =>   { 205 , 104 ,  57 }
#xtranslate   COLOR_Sienna4            =>   { 139 ,  71 ,  38 }
#xtranslate   COLOR_Burlywood1         =>   { 255 , 211 , 155 }
#xtranslate   COLOR_Burlywood2         =>   { 238 , 197 , 145 }
#xtranslate   COLOR_Burlywood3         =>   { 205 , 170 , 125 }
#xtranslate   COLOR_Burlywood4         =>   { 139 , 115 ,  85 }
#xtranslate   COLOR_Wheat1             =>   { 255 , 231 , 186 }
#xtranslate   COLOR_Wheat2             =>   { 238 , 216 , 174 }
#xtranslate   COLOR_Wheat3             =>   { 205 , 186 , 150 }
#xtranslate   COLOR_Wheat4             =>   { 139 , 126 , 102 }
#xtranslate   COLOR_Tan1               =>   { 255 , 165 ,  79 }
#xtranslate   COLOR_Tan2               =>   { 238 , 154 ,  73 }
#xtranslate   COLOR_Tan3               =>   { 205 , 133 ,  63 }
#xtranslate   COLOR_Tan4               =>   { 139 ,  90 ,  43 }
#xtranslate   COLOR_Chocolate1         =>   { 255 , 127 ,  36 }
#xtranslate   COLOR_Chocolate2         =>   { 238 , 118 ,  33 }
#xtranslate   COLOR_Chocolate3         =>   { 205 , 102 ,  29 }
#xtranslate   COLOR_Chocolate4         =>   { 139 ,  69 ,  19 }
#xtranslate   COLOR_Firebrick1         =>   { 255 ,  48 ,  48 }
#xtranslate   COLOR_Firebrick2         =>   { 238 ,  44 ,  44 }
#xtranslate   COLOR_Firebrick3         =>   { 205 ,  38 ,  38 }
#xtranslate   COLOR_Firebrick4         =>   { 139 ,  26 ,  26 }
#xtranslate   COLOR_Brown1             =>   { 255 ,  64 ,  64 }
#xtranslate   COLOR_Brown2             =>   { 238 ,  59 ,  59 }
#xtranslate   COLOR_Brown3             =>   { 205 ,  51 ,  51 }
#xtranslate   COLOR_Brown4             =>   { 139 ,  35 ,  35 }
#xtranslate   COLOR_Salmon1            =>   { 255 , 140 , 105 }
#xtranslate   COLOR_Salmon2            =>   { 238 , 130 ,  98 }
#xtranslate   COLOR_Salmon3            =>   { 205 , 112 ,  84 }
#xtranslate   COLOR_Salmon4            =>   { 139 ,  76 ,  57 }
#xtranslate   COLOR_LightSalmon1       =>   { 255 , 160 , 122 }
#xtranslate   COLOR_LightSalmon2       =>   { 238 , 149 , 114 }
#xtranslate   COLOR_LightSalmon3       =>   { 205 , 129 ,  98 }
#xtranslate   COLOR_LightSalmon4       =>   { 139 ,  87 ,  66 }
#xtranslate   COLOR_Orange1            =>   { 255 , 165 ,   0 }
#xtranslate   COLOR_Orange2            =>   { 238 , 154 ,   0 }
#xtranslate   COLOR_Orange3            =>   { 205 , 133 ,   0 }
#xtranslate   COLOR_Orange4            =>   { 139 ,  90 ,   0 }
#xtranslate   COLOR_DarkOrange1        =>   { 255 , 127 ,   0 }
#xtranslate   COLOR_DarkOrange2        =>   { 238 , 118 ,   0 }
#xtranslate   COLOR_DarkOrange3        =>   { 205 , 102 ,   0 }
#xtranslate   COLOR_DarkOrange4        =>   { 139 ,  69 ,   0 }
#xtranslate   COLOR_Coral1             =>   { 255 , 114 ,  86 }
#xtranslate   COLOR_Coral2             =>   { 238 , 106 ,  80 }
#xtranslate   COLOR_Coral3             =>   { 205 ,  91 ,  69 }
#xtranslate   COLOR_Coral4             =>   { 139 ,  62 ,  47 }
#xtranslate   COLOR_Tomato1            =>   { 255 ,  99 ,  71 }
#xtranslate   COLOR_Tomato2            =>   { 238 ,  92 ,  66 }
#xtranslate   COLOR_Tomato3            =>   { 205 ,  79 ,  57 }
#xtranslate   COLOR_Tomato4            =>   { 139 ,  54 ,  38 }
#xtranslate   COLOR_OrangeRed1         =>   { 255 ,  69 ,   0 }
#xtranslate   COLOR_OrangeRed2         =>   { 238 ,  64 ,   0 }
#xtranslate   COLOR_OrangeRed3         =>   { 205 ,  55 ,   0 }
#xtranslate   COLOR_OrangeRed4         =>   { 139 ,  37 ,   0 }
#xtranslate   COLOR_Red1               =>   { 255 ,   0 ,   0 }
#xtranslate   COLOR_Red2               =>   { 238 ,   0 ,   0 }
#xtranslate   COLOR_Red3               =>   { 205 ,   0 ,   0 }
#xtranslate   COLOR_Red4               =>   { 139 ,   0 ,   0 }
#xtranslate   COLOR_DeepPink1          =>   { 255 ,  20 , 147 }
#xtranslate   COLOR_DeepPink2          =>   { 238 ,  18 , 137 }
#xtranslate   COLOR_DeepPink3          =>   { 205 ,  16 , 118 }
#xtranslate   COLOR_DeepPink4          =>   { 139 ,  10 ,  80 }
#xtranslate   COLOR_HotPink1           =>   { 255 , 110 , 180 }
#xtranslate   COLOR_HotPink2           =>   { 238 , 106 , 167 }
#xtranslate   COLOR_HotPink3           =>   { 205 ,  96 , 144 }
#xtranslate   COLOR_HotPink4           =>   { 139 ,  58 ,  98 }
#xtranslate   COLOR_Pink1              =>   { 255 , 181 , 197 }
#xtranslate   COLOR_Pink2              =>   { 238 , 169 , 184 }
#xtranslate   COLOR_Pink3              =>   { 205 , 145 , 158 }
#xtranslate   COLOR_Pink4              =>   { 139 ,  99 , 108 }
#xtranslate   COLOR_LightPink1         =>   { 255 , 174 , 185 }
#xtranslate   COLOR_LightPink2         =>   { 238 , 162 , 173 }
#xtranslate   COLOR_LightPink3         =>   { 205 , 140 , 149 }
#xtranslate   COLOR_LightPink4         =>   { 139 ,  95 , 101 }
#xtranslate   COLOR_PaleVioletRed1     =>   { 255 , 130 , 171 }
#xtranslate   COLOR_PaleVioletRed2     =>   { 238 , 121 , 159 }
#xtranslate   COLOR_PaleVioletRed3     =>   { 205 , 104 , 137 }
#xtranslate   COLOR_PaleVioletRed4     =>   { 139 ,  71 ,  93 }
#xtranslate   COLOR_Maroon1            =>   { 255 ,  52 , 179 }
#xtranslate   COLOR_Maroon2            =>   { 238 ,  48 , 167 }
#xtranslate   COLOR_Maroon3            =>   { 205 ,  41 , 144 }
#xtranslate   COLOR_Maroon4            =>   { 139 ,  28 ,  98 }
#xtranslate   COLOR_VioletRed1         =>   { 255 ,  62 , 150 }
#xtranslate   COLOR_VioletRed2         =>   { 238 ,  58 , 140 }
#xtranslate   COLOR_VioletRed3         =>   { 205 ,  50 , 120 }
#xtranslate   COLOR_VioletRed4         =>   { 139 ,  34 ,  82 }
#xtranslate   COLOR_Magenta1           =>   { 255 ,   0 , 255 }
#xtranslate   COLOR_Magenta2           =>   { 238 ,   0 , 238 }
#xtranslate   COLOR_Magenta3           =>   { 205 ,   0 , 205 }
#xtranslate   COLOR_Magenta4           =>   { 139 ,   0 , 139 }
#xtranslate   COLOR_Orchid1            =>   { 255 , 131 , 250 }
#xtranslate   COLOR_Orchid2            =>   { 238 , 122 , 233 }
#xtranslate   COLOR_Orchid3            =>   { 205 , 105 , 201 }
#xtranslate   COLOR_Orchid4            =>   { 139 ,  71 , 137 }
#xtranslate   COLOR_Plum1              =>   { 255 , 187 , 255 }
#xtranslate   COLOR_Plum2              =>   { 238 , 174 , 238 }
#xtranslate   COLOR_Plum3              =>   { 205 , 150 , 205 }
#xtranslate   COLOR_Plum4              =>   { 139 , 102 , 139 }
#xtranslate   COLOR_MediumOrchid1      =>   { 224 , 102 , 255 }
#xtranslate   COLOR_MediumOrchid2      =>   { 209 ,  95 , 238 }
#xtranslate   COLOR_MediumOrchid3      =>   { 180 ,  82 , 205 }
#xtranslate   COLOR_MediumOrchid4      =>   { 122 ,  55 , 139 }
#xtranslate   COLOR_DarkOrchid1        =>   { 191 ,  62 , 255 }
#xtranslate   COLOR_DarkOrchid2        =>   { 178 ,  58 , 238 }
#xtranslate   COLOR_DarkOrchid3        =>   { 154 ,  50 , 205 }
#xtranslate   COLOR_DarkOrchid4        =>   { 104 ,  34 , 139 }
#xtranslate   COLOR_Purple1            =>   { 155 ,  48 , 255 }
#xtranslate   COLOR_Purple2            =>   { 145 ,  44 , 238 }
#xtranslate   COLOR_Purple3            =>   { 125 ,  38 , 205 }
#xtranslate   COLOR_Purple4            =>   {  85 ,  26 , 139 }
#xtranslate   COLOR_MediumPurple1      =>   { 171 , 130 , 255 }
#xtranslate   COLOR_MediumPurple2      =>   { 159 , 121 , 238 }
#xtranslate   COLOR_MediumPurple3      =>   { 137 , 104 , 205 }
#xtranslate   COLOR_MediumPurple4      =>   {  93 ,  71 , 139 }
#xtranslate   COLOR_Thistle1           =>   { 255 , 225 , 255 }
#xtranslate   COLOR_Thistle2           =>   { 238 , 210 , 238 }
#xtranslate   COLOR_Thistle3           =>   { 205 , 181 , 205 }
#xtranslate   COLOR_Thistle4           =>   { 139 , 123 , 139 }
#xtranslate   COLOR_grey11             =>   {  28 ,  28 ,  28 }
#xtranslate   COLOR_grey21             =>   {  54 ,  54 ,  54 }
#xtranslate   COLOR_grey31             =>   {  79 ,  79 ,  79 }
#xtranslate   COLOR_grey41             =>   { 105 , 105 , 105 }
#xtranslate   COLOR_grey51             =>   { 130 , 130 , 130 }
#xtranslate   COLOR_grey61             =>   { 156 , 156 , 156 }
#xtranslate   COLOR_grey71             =>   { 181 , 181 , 181 }
#xtranslate   COLOR_grey81             =>   { 207 , 207 , 207 }
#xtranslate   COLOR_grey91             =>   { 232 , 232 , 232 }
#xtranslate   COLOR_DarkGrey           =>   { 169 , 169 , 169 }
#xtranslate   COLOR_DarkBlue           =>   {   0 ,   0 , 139 }
#xtranslate   COLOR_DarkCyan           =>   {   0 , 139 , 139 }
#xtranslate   COLOR_DarkMagenta        =>   { 139 ,   0 , 139 }
#xtranslate   COLOR_DarkRed            =>   { 139 ,   0 ,   0 }
#xtranslate   COLOR_LightGreen         =>   { 144 , 238 , 144 }
