* RDD SQL DEMO
* Based on Harbour Compiler Contrib Samples
* Adapted for HMG by Roberto Lopez - 2009

#include "hmg.ch"

REQUEST SDDODBC, SQLMIX

#define RDDI_CONNECT          1001
 
PROC main()

	RDDSETDEFAULT( "SQLMIX" )
	SET( 4, "yyyy-mm-dd" )
	RDDINFO( RDDI_CONNECT, { "ODBC", "DBQ="  + "test.mdb;Driver={Microsoft Access Driver (*.mdb)}" } )
	DBUSEAREA( .T.,, "select * from test", "test" )

	INDEX ON FIELD->SALARY TO salary
	DBGOTOP()

	DEFINE WINDOW Win_1 ;
		ROW 0 ;
		COL 0 ;
		WIDTH 500 ;
		HEIGHT 400 ;
		TITLE 'RDD SQL' ;
		WINDOWTYPE MAIN  

		DEFINE GRID grid1
			ROW 		10
			COL 		10
			WIDTH		470			
			HEIGHT		330
			HEADERS 	{'First','Last','Salary'}
			WIDTHS		{135,135,135}
			ROWSOURCE	"TEST"
			COLUMNFIELDS	{'First','Last','Salary'}
		END GRID
		                           	
	END WINDOW

	Win_1.Center

	Win_1.Activate

RETURN   
