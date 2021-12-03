/*
* HMG Grid Demo
* (c) 2005 Roberto Lopez
*/

#include "hmg.ch"
#include "hfcl.ch"

#define NTrim( n )   LTrim( TRAN( n,"999,999,999,999,999,999,999.99" ) )


Function Main

Local aRows [75] [5]



   bColor  := { || IF( GetRowTruth( This.CellRowIndex ), GREEN, RED ) }
    aColors := ARRAY( 5 )
    AFILL( aColors, bColor )

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 440 ;
		TITLE 'Mixed Data Type Grid Test' ;
		MAIN

		DEFINE MAIN MENU
			DEFINE POPUP 'File'
				MENUITEM 'Set Item'	ACTION SetItem()
				MENUITEM 'Get Item'	ACTION MsM( Form_1.Grid_1.Item( Form_1.Grid_1.Value ), "Row:" + LTRIM(STR( Form_1.Grid_1.Value ) ) )
			END POPUP
		END MENU

		aRows [1]	:= {1,date(),113.12,1 , .t. }
		aRows [2]	:= {2,date(),123.12,2 , .f. }
		aRows [3]	:= {3,date(),133.12,3, .t. }
		aRows [4]	:= {1,date(),143.12,4, .f. }
		aRows [5]	:= {2,date(),153.12,5, .t. }
		aRows [6]	:= {3,date(),163.12,6, .f. }
		aRows [7]	:= {1,date(),173.12,7, .t. }
		aRows [8]	:= {2,date(),183.12,8, .f. }
		aRows [9]	:= {3,date(),193.12,9, .t. }
		aRows [10]	:= {1,date(),113.12,10, .f. }
		aRows [11]	:= {2,date(),123.12,11, .t. }
		aRows [12]	:= {3,date(),133.12,12, .f. }
		aRows [13]	:= {1,date(),143.12,13, .t. }
		aRows [14]	:= {2,date(),153.12,14, .f. }
		aRows [15]	:= {3,date(),163.12,15, .t. }
		aRows [16]	:= {1,date(),173.12,16, .f. }
		aRows [17]	:= {2,date(),183.12,17, .t. }
		aRows [18]	:= {3,date(),193.12,18, .f. }
		aRows [19]	:= {1,date(),113.12,19, .t. }
		aRows [20]	:= {2,date(),123.12,20, .f. }
		aRows [21]	:= {1,date(),113.12,10, .f. }
		aRows [22]	:= {2,date(),123.12,11, .t. }
		aRows [23]	:= {3,date(),133.12,12, .f. }
		aRows [24]	:= {1,date(),143.12,13, .t. }
		aRows [25]	:= {2,date(),153.12,14, .f. }
		aRows [26]	:= {3,date(),163.12,15, .t. }
		aRows [27]	:= {1,date(),173.12,16, .f. }
		aRows [28]	:= {2,date(),183.12,17, .t. }
		aRows [29]	:= {3,date(),193.12,18, .f. }
		aRows [30]	:= {1,date(),113.12,19, .t. }
		aRows [31]	:= {2,date(),123.12,20, .f. }
		aRows [32]	:= {1,date(),113.12,10, .f. }
		aRows [33]	:= {2,date(),123.12,11, .t. }
		aRows [34]	:= {3,date(),133.12,12, .f. }
		aRows [35]	:= {1,date(),143.12,13, .t. }
		aRows [36]	:= {2,date(),153.12,14, .f. }
		aRows [37]	:= {3,date(),163.12,15, .t. }
		aRows [38]	:= {1,date(),173.12,16, .f. }
		aRows [39]	:= {2,date(),183.12,17, .t. }
		aRows [40]	:= {3,date(),193.12,18, .f. }
		aRows [41]	:= {1,date(),113.12,19, .t. }
		aRows [42]	:= {2,date(),123.12,20, .f. }
		aRows [43]	:= {1,date(),113.12,10, .f. }
		aRows [44]	:= {2,date(),123.12,11, .t. }
		aRows [45]	:= {3,date(),133.12,12, .f. }
		aRows [46]	:= {1,date(),143.12,13, .t. }
		aRows [47]	:= {2,date(),153.12,14, .f. }
		aRows [48]	:= {3,date(),163.12,15, .t. }
		aRows [49]	:= {1,date(),173.12,16, .f. }
		aRows [50]	:= {2,date(),183.12,17, .t. }
		aRows [51]	:= {3,date(),193.12,18, .f. }
		aRows [52]	:= {1,date(),113.12,19, .t. }
		aRows [53]	:= {2,date(),123.12,20, .f. }
		aRows [54]	:= {1,date(),113.12,10, .f. }
		aRows [55]	:= {2,date(),123.12,11, .t. }
		aRows [56]	:= {3,date(),133.12,12, .f. }
		aRows [57]	:= {1,date(),143.12,13, .t. }
		aRows [58]	:= {2,date(),153.12,14, .f. }
		aRows [59]	:= {3,date(),163.12,15, .t. }
		aRows [60]	:= {1,date(),173.12,16, .f. }
		aRows [61]	:= {2,date(),183.12,17, .t. }
		aRows [62]	:= {3,date(),193.12,18, .f. }
		aRows [63]	:= {1,date(),113.12,19, .t. }
		aRows [64]	:= {2,date(),123.12,20, .f. }
		aRows [65]	:= {1,date(),113.12,10, .f. }
		aRows [66]	:= {2,date(),123.12,11, .t. }
		aRows [67]	:= {3,date(),133.12,12, .f. }
		aRows [68]	:= {1,date(),143.12,13, .t. }
		aRows [69]	:= {2,date(),153.12,14, .f. }
		aRows [70]	:= {3,date(),163.12,15, .t. }
		aRows [71]	:= {1,date(),173.12,16, .f. }
		aRows [72]	:= {2,date(),183.12,17, .t. }
		aRows [73]	:= {3,date(),193.12,18, .f. }
		aRows [74]	:= {1,date(),113.12,19, .t. }
		aRows [75]	:= {2,date(),123.12,20, .f. }
		
		mergedheaders := {{2,3,"Multi Header1"},{4,5,"Multi Header2"}}
//		mergedheaders := {{2,4,"Multi Header1"}}

      summation := {{.f.,""},{.f.,""},{.t.,"$ 999,999.99"},{.t.,"9999999999"},{.f.,""}}

		@ 10,10 GRID Grid_1 ;
			WIDTH 620 ;
			HEIGHT 330 ;
			HEADERS {'Column 1','Column 2','Column 3','Column 4','Column 5'} ;
			WIDTHS {140,140,140,140,140} ;
			JUSTIFY {0,0,1,1,0};
			ITEMS aRows ;
			VALUE 1 ;
			EDIT ;
			COLUMNCONTROLS { {'COMBOBOX',{'One','Two','Three'}} , {'DATEPICKER','DROPDOWN'} ,{'TEXTBOX','NUMERIC','$ 999,999.99'}  , { 'SPINNER' , 1 , 20 } , { 'CHECKBOX' , 'Yes' , 'No' } } ;
			DYNAMICFORECOLOR aColors // { fColor , fColor, fColor, fColor, fColor } 
			
		DEFINE BUTTON BUTTON_1
		   ROW 340
		   COL 10
		   CAPTION "Print"
//		   action form_1.grid_1.print
    	   action doprint()
//		   ACTION _GridPrint("Grid_1","Form_1")
        END BUTTON

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

RETURN


function doprint
PRINT GRID grid_1;
      OF form_1;
      FONT "Arial";
      SIZE 12;
      ORIENTATION "P";
      SHOWWINDOW ;
      HEADERS {"Header1","Header2"} ;
      MERGEHEADERS mergedheaders ;
      COLUMNSUM summation ;
      WIDTHS {0,20,20,20,40} ;
      PAPERSIZE PRINTER_PAPER_USER ;
      PAPERWIDTH 200 ;
      PAPERHEIGHT 200;
      VERTICALLINES;
      HORIZONTALLINES;
      LEFT 15;
      TOP 15;
      RIGHT 15;
      BOTTOM 15
 

return nil


PROCEDURE SETITEM()

	Form_1.Grid_1.Item (2) := { 2 , date() , 456.12 , 10 , .T. }

RETURN

/*
PROCEDURE GETITEM()
   
local a

	a := Form_1.Grid_1.Item (2)

	msginfo ( str ( a [1] )				, '1' )
	msginfo ( dtoc ( a [2] )			, '2' )
	msginfo ( str( a [3] )				, '3' )
	msginfo ( str ( a [4] )				, '4' )
	msginfo ( if ( a [5] == .t. , '.t.' , '.f.' )	, '5' )
*/
RETURN
*/

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._

FUNC GetRowTruth( nItemNo )
RETU Form_1.Grid_1.Cell( nItemNo, 5 )
  
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._


/*

   Simplified version of MsgMulty()
   
*/

PROC MsM( xMesaj, cTitle  )

   LOCA cMessage := ""
      
   IF VALTYPE( xMesaj  ) # "A"
      xMesaj := { xMesaj }
   ENDIF
   
   AEVAL( xMesaj, { | x1, i1 | cMessage +=  Any2Strg( x1 ) + CRLF } )
   
   MsgInfo( cMessage, cTitle )
   
RETU //  MsM()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._

FUNC Any2Strg( xAny )

   LOCA cRVal  := '???',;
        nType  :=  0,;
        aCases := { { "A", { | x | "{...}" } },;                
                    { "B", { | x | "{||}" } },;                
                    { "C", { | x | x }},;
                    { "M", { | x | x   } },;                   
                    { "D", { | x | DTOC( x ) } },;             
                    { "L", { | x | IF( x,"On","Off") } },;    
                    { "N", { | x | NTrim( x )  } },;
                    { "O", { | x | ":Object:" } },;
                    { "U", { | x | "<NIL>" } } }
                    
   IF (nType := ASCAN( aCases, { | a1 | VALTYPE( xAny ) == a1[ 1 ] } ) ) > 0
      cRVal := EVAL( aCases[ nType, 2 ], xAny )
   ENDIF    
                   
RETU cRVal // Any2Strg()
          
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._

