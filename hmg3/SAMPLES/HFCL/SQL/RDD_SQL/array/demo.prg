
* RDD SQL DEMO
* Based on Harbour Compiler Contrib Samples
* Adapted for HMG by Roberto Lopez - 2009

#include "hmg.ch"

REQUEST SQLMIX

PROC main()

   RDDSETDEFAULT("SQLMIX")
   DBCREATE("persons", {{"NAME", "C", 20, 0}, {"FAMILYNAME", "C", 20, 0}, {"BIRTH", "D", 8, 0}, {"AMOUNT", "N", 9, 2}},, .T., "persons")

   DBAPPEND();  AEVAL({PADR("Bil", 20),  PADR("Gatwick", 20),  STOD("19650124"), 123456.78}, {|X,Y| FIELDPUT(Y, X)})
   DBAPPEND();  AEVAL({PADR("Tom", 20),  PADR("Heathrow", 20), STOD("19870512"),   9086.54}, {|X,Y| FIELDPUT(Y, X)})
   DBAPPEND();  AEVAL({PADR("John", 20), PADR("Weber", 20),    STOD("19750306"),   2975.45}, {|X,Y| FIELDPUT(Y, X )})
   DBAPPEND();  AEVAL({PADR("Sim", 20),  PADR("Simsom", 20),   STOD("19930705"),  32975.37}, {|X,Y| FIELDPUT(Y, X )})

   INDEX ON FIELD->AMOUNT TO amount
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
			HEADERS 	{'Name','Family Name','Birth'}
			WIDTHS		{135,135,135}
			ROWSOURCE	"Persons"
			COLUMNFIELDS	{'Name','FamilyName','Birth'}
		END GRID
		                           	
	END WINDOW

	Win_1.Grid1.Value := { 1 , 1 }

	Win_1.Center

	Win_1.Activate

RETURN

PROC RDDSYS();  RETURN
