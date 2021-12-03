/* HMG Grid Demo
 * Author: Javier Parada
 * On April, 2010
 *
 * Adapted to Grid by Pablo César
 * On March 4th, 2015
*/

#include "hmg.ch"
#define MY_RED          { 255, 091, 091 }
#define MY_PURPLE       { 244, 244, 244 }

REQUEST DBFCDX

Function Main()
RDDSETDEFAULT("DBFCDX")
OpenTable()

PRIVATE bckColor := { || If( (Articulos->(RecNo())) % 2 == 0, WHITE , MY_PURPLE ) }
PRIVATE bckFore  := { || If( (Articulos->(RecNo())) % 2 == 0, BLACK , BLUE      ) }
												
DEFINE WINDOW Form_1 ;
	AT 0,0 ;
	WIDTH 482 HEIGHT 540 ;
	TITLE "Products in the Stock" ;
	FONT "Segoe UI" SIZE 09 ;
	MAIN NOSIZE ;
	ON RELEASE DbCloseAll()
					
	@ 10, 10 GRID Grid_1	;
		WIDTH 455	;
		HEIGHT 490 	;	
		HEADERS { "Code", "Description", "In Stock" } ;
		WIDTHS { 55, 300, 90 }	;
		VALUE {9,2} ;
		FONT "Segoe UI" SIZE 09 ;
		BACKCOLOR { 244,244,244 } ;
		DYNAMICBACKCOLOR { bckColor, bckColor, { || If( AtCellCol( 3 ) < 0, MY_RED, If( (Articulos->(RecNo())) % 2 == 0, WHITE , MY_PURPLE ) ) } } ;
        DYNAMICFORECOLOR { bckFore , bckFore , { || If( AtCellCol( 3 ) < 0, WHITE , If( (Articulos->(RecNo())) % 2 == 0, BLACK , BLUE      ) ) } } ;
		ROWSOURCE "Articulos" ;
		COLUMNFIELDS { "Articulos->f_cve_art", "Articulos->f_nomb_art", "Transform( ExistActual('01', Articulos->f_cve_art),'9999')" } ;
		NOLINES ;
		JUSTIFY { BROWSE_JTFY_LEFT, BROWSE_JTFY_LEFT, BROWSE_JTFY_RIGHT }
		
END WINDOW
Form_1.Grid_1.SETFOCUS
CENTER WINDOW Form_1
ACTIVATE WINDOW Form_1
Return Nil

Function AtCellCol(nColIndex)
Local nRowIndex := This.CellRowIndex
Local nRet := Val(GetProperty( "Form_1", "Grid_1", "CellEx", nRowIndex, nColIndex ))
Return nRet

Function ExistActual( CveAlm, CveArt )
Local cArea:= SaveDbf(), nOrd, nRes := 0

Select Existencias
nOrd := SaveDbf()
Set Order To 1 

If DbSeek( CveAlm + CveArt )
   nRes := Existencias->f_exis_Act
Endif
RestDbf(nOrd)
RestDbf(cArea)
Return nRes

Function SaveDbf( )
Return ( { Select(), Iif( Used(), OrdSetFocus(), .F.) , Iif( Used(), Recno(), .F. ) } )

Function RestDbf( _Arreglo )
Select( _Arreglo[1] )
If ValType( _Arreglo[2] ) = "C" .and. ! Empty( _Arreglo[2] )
   OrdSetFocus( _Arreglo[2] )
Endif
If ValType( _Arreglo[3] ) = 'N'
   Go _Arreglo[3]
Endif
Return Nil

Function OpenTable()
Use ptvartic Index ptvartic Alias Articulos New
Use ptvexist Index ptvexist Alias Existencias New
Return Nil