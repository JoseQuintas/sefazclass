#include "hmg.ch"
function main

	define window m at 0,0 width 800 height 600 main On Init ShowPie() backcolor { 255,255,255}

		define button x
			row 10
			col 10
			caption "Draw"
			action showpie()
		end button

		Define Button Button_1
			Row	10
			Col	150
			Caption	'Print'
			Action PRINT GRAPH OF m PREVIEW DIALOG
		End Button

	end window

	m.center

	m.activate

return nil


function showpie

ERASE WINDOW m

DRAW GRAPH IN WINDOW m AT 100,100;
      TO 500,500 ;
      TITLE "Sales" ;
      TYPE PIE;
      SERIES {1500,1800,200,500,800};
		DEPTH 25;
		SERIENAMES {"Product 1","Product 2","Product 3","Product 4","Product 5"};
		COLORS {{255,0,0},{0,0,255},{255,255,0},{0,255,0},{255,128,64},{128,0,128}};
		3DVIEW;
		SHOWXVALUES; 
		SHOWLEGENDS NOBORDER

return nil
