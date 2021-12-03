/*
 * HMG - Harbour Win32 GUI library Demo
*/

#include "hmg.ch"

Function Main

Local aSer:={ {14280,20420,12870,25347, 7640},;
           { 8350,10315,15870, 5347,12340},;
           {12345, -8945,10560,15600,17610} }

	Define Window GraphTest ;
		At 0,0 ;
		Width 640 ;
		Height 480 ;
		Title "Graph" ;
		Main ;
		Nomaximize ;
		Icon "Main" ;
		BackColor { 255 , 255 , 255 } ;
		On Init DrawBarGraph ( aSer ) ;

		Define Button Button_1
			Row	415
			Col	20
			Caption	'Bars'
			Action DrawBarGraph ( aSer )
		End Button

		Define Button Button_2
			Row	415
			Col	185
			Caption	'Lines'
			Action DrawLinesGraph ( aSer )
		End Button

		Define Button Button_3
			Row	415
			Col	340
			Caption	'Points'
			Action DrawPointsGraph ( aSer )
		End Button

		Define Button Button_4
			Row	415
			Col	500
			Caption	'Print'
			Action PRINT GRAPH OF GraphTest PREVIEW DIALOG
		End Button

	End Window

	GraphTest.Center

	Activate Window GraphTest

Return

Procedure DrawBarGraph ( aSer )

	ERASE WINDOW GraphTest

	DRAW GRAPH							;
		IN WINDOW GraphTest					;
		AT 20,20						;
		TO 400,610						;
		TITLE "Sales and Product"				;
		TYPE BARS						;
		SERIES aSer						;
		YVALUES {"Jan","Feb","Mar","Apr","May"}			;
		DEPTH 15						;
		BARWIDTH 15						;
		HVALUES 5						;
		SERIENAMES {"Serie 1","Serie 2","Serie 3"}		;
		COLORS { {128,128,255}, {255,102, 10}, {55,201, 48} }	;
		3DVIEW    						;
		SHOWGRID                        			;
		SHOWXVALUES                     			;
		SHOWYVALUES                     			;
		SHOWLEGENDS 						;
		NOBORDER
		
Return

Procedure DrawLinesGraph ( aSer )

	ERASE WINDOW GraphTest

	DRAW GRAPH							;
		IN WINDOW GraphTest					;
		AT 20,20						;
		TO 400,610						;
		TITLE "Sales and Product"				;
		TYPE LINES						;
		SERIES aSer						;
		YVALUES {"Jan","Feb","Mar","Apr","May"}			;
		DEPTH 15						;
		BARWIDTH 15						;
		HVALUES 5						;
		SERIENAMES {"Serie 1","Serie 2","Serie 3"}		;
		COLORS { {128,128,255}, {255,102, 10}, {55,201, 48} }	;
		3DVIEW    						;
		SHOWGRID                        			;
		SHOWXVALUES                     			;
		SHOWYVALUES                     			;
		SHOWLEGENDS 						;
		NOBORDER

Return

Procedure DrawPointsGraph ( aSer )

	ERASE WINDOW GraphTest

	DRAW GRAPH							;
		IN WINDOW GraphTest					;
		AT 20,20						;
		TO 400,610						;
		TITLE "Sales and Product"				;
		TYPE POINTS						;
		SERIES aSer						;
		YVALUES {"Jan","Feb","Mar","Apr","May"}			;
		DEPTH 15						;
		BARWIDTH 15						;
		HVALUES 5						;
		SERIENAMES {"Serie 1","Serie 2","Serie 3"}		;
		COLORS { {128,128,255}, {255,102, 10}, {55,201, 48} }	;
		3DVIEW    						;
		SHOWGRID                        			;
		SHOWXVALUES                     			;
		SHOWYVALUES                     			;
		SHOWLEGENDS 						;
		NOBORDER

Return

