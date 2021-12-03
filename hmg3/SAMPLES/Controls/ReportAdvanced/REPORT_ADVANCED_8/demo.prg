#include "hmg.ch"

Function Main

	Public i := 1
	Public aRows [ 20 ] [ 3 ]

	aRows [1]	:= {'Simpson','Homer','555-5555'}
	aRows [2]	:= {'Mulder','Fox','324-6432'} 
	aRows [3]	:= {'Smart','Max','432-5892'} 
	aRows [4]	:= {'Grillo','Pepe','894-2332'} 
	aRows [5]	:= {'Kirk','James','346-9873'} 
	aRows [6]	:= {'Barriga','Carlos','394-9654'} 
	aRows [7]	:= {'Flanders','Ned','435-3211'} 
	aRows [8]	:= {'Smith','John','123-1234'} 
	aRows [9]	:= {'Pedemonti','Flavio','000-0000'} 
	aRows [10]	:= {'Gomez','Juan','583-4832'} 
	aRows [11]	:= {'Fernandez','Raul','321-4332'} 
	aRows [12]	:= {'Borges','Javier','326-9430'} 
	aRows [13]	:= {'Alvarez','Alberto','543-7898'} 
	aRows [14]	:= {'Gonzalez','Ambo','437-8473'} 
	aRows [15]	:= {'Batistuta','Gol','485-2843'} 
	aRows [16]	:= {'Vinazzi','Amigo','394-5983'} 
	aRows [17]	:= {'Pedemonti','Flavio','534-7984'} 
	aRows [18]	:= {'Samarbide','Armando','854-7873'} 
	aRows [19]	:= {'Pradon','Alejandra','???-????'} 
	aRows [20]	:= {'Reyes','Monica','432-5836'} 

	LOAD REPORT DEMO

	DEFINE WINDOW Win_1 ;
		ROW 0 ;
		COL 0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello Report' ;
		WINDOWTYPE MAIN 

		DEFINE MAIN MENU
			POPUP 'File'
				ITEM 'Execute Report'	ACTION ( i := 1 , ExecuteReport('Demo',.t.,.t. ) )
			END POPUP
		END MENU

	END WINDOW

	Win_1.Center

	Win_1.Activate

Return

