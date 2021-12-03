
* RDD SQL DEMO
* Based on Harbour Compiler Contrib Samples
* Adapted for HMG by Roberto Lopez - 2009

#include "hmg.ch"
#include "dbinfo.ch"
#include "error.ch"

#define DBI_QUERY             1001

#define RDDI_CONNECT          1001
#define RDDI_DISCONNECT       1002
#define RDDI_EXECUTE          1003
#define RDDI_ERROR            1004
#define RDDI_ERRORNO          1005
#define RDDI_NEWID            1006
#define RDDI_AFFECTEDROWS     1007
#define RDDI_QUERY            1008

REQUEST SDDMY, SQLMIX

Function Main
LOCAL hConn

	RDDSETDEFAULT("SQLMIX")

	IF RDDINFO(RDDI_CONNECT, {"MYSQL", "localhost", "root","1234", "test"}) == 0
		MSGSTOP("Unable connect to the server")
		RETURN 
	ENDIF

	CreateTable()

	DBUSEAREA( .T.,, "SELECT * FROM country", "country" )

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
			HEADERS 	{'Code','Name','Residents'}
			WIDTHS		{135,155,135}
			ROWSOURCE	"COUNTRY"
			COLUMNFIELDS	{'Code','Name','Residents'}
		END GRID

	END WINDOW

	Win_1.Center

	Win_1.Activate

Return

STATIC PROC CreateTable()
   ? RDDINFO(RDDI_EXECUTE, "DROP TABLE country")
   ? RDDINFO(RDDI_EXECUTE, "CREATE TABLE country (CODE char(3), NAME char(50), RESIDENTS int(11))")
   ? RDDINFO(RDDI_EXECUTE, "INSERT INTO country values ('LTU', 'Lithuania', 3369600), ('USA', 'United States of America', 305397000), ('POR', 'Portugal', 10617600), ('POL', 'Poland', 38115967), ('AUS', 'Australia', 21446187), ('FRA', 'France', 64473140), ('RUS', 'Russia', 141900000)")
RETURN

PROC RDDSYS();  RETURN
