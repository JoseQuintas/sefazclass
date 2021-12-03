/*
* HMG Grid Demo
* (c) 2009 Roberto Lopez
*/

#include "hmg.ch"

Function Main

Local aRows [40] [3]

	
	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 400 ;
		TITLE 'Cell Navigation Grid Test' ;
		MAIN 
		
        ON KEY ESCAPE ACTION Form_1.Release
        
		DEFINE MAIN MENU
			DEFINE POPUP 'File'
				MENUITEM 'Set Value To {5,2}'	ACTION Form_1.Grid_1.Value := {5,2}
				MENUITEM 'Set Value To {0,0}'	ACTION Form_1.Grid_1.Value := {0,0}
				MENUITEM 'Get Value'		ACTION GetSelectionValue()
				MENUITEM 'Delete Item 5'	ACTION Form_1.Grid_1.DeleteItem(5)
				MENUITEM 'AddItem'		ACTION Form_1.Grid_1.AddItem({'X','X','X'})
				MENUITEM 'Delete All Items'	ACTION Form_1.Grid_1.DeleteAllItems
			END POPUP
		END MENU

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

		aRows [21]	:= {'Fernandez','Raul','321-4332'} 
		aRows [22]	:= {'Borges','Javier','326-9430'} 
		aRows [23]	:= {'Alvarez','Alberto','543-7898'} 
		aRows [24]	:= {'Gonzalez','Ambo','437-8473'} 
		aRows [25]	:= {'Batistuta','Gol','485-2843'} 
		aRows [26]	:= {'Vinazzi','Amigo','394-5983'} 
		aRows [27]	:= {'Pedemonti','Flavio','534-7984'} 
		aRows [28]	:= {'Samarbide','Armando','854-7873'} 
		aRows [29]	:= {'Pradon','Alejandra','???-????'} 
		aRows [30]	:= {'Reyes','Monica','432-5836'} 

		aRows [31]	:= {'Fernandez','Raul','321-4332'} 
		aRows [32]	:= {'Borges','Javier','326-9430'} 
		aRows [33]	:= {'Alvarez','Alberto','543-7898'} 
		aRows [34]	:= {'Gonzalez','Ambo','437-8473'} 
		aRows [35]	:= {'Batistuta','Gol','485-2843'} 
		aRows [36]	:= {'Vinazzi','Amigo','394-5983'} 
		aRows [37]	:= {'Pedemonti','Flavio','534-7984'} 
		aRows [38]	:= {'Samarbide','Armando','854-7873'} 
		aRows [39]	:= {'Pradon','Alejandra','???-????'} 
		aRows [40]	:= {'Reyes','Monica','432-5836'} 
		 
		DEFINE GRID Grid_1 
			ROW		10
			COL		10 
			WIDTH		500 
			HEIGHT		322 
			HEADERS		{'Column 1','Column 2','Column 3'} 
			WIDTHS		{100,100,100} 
			ITEMS		aRows 
			ALLOWEDIT	.T.
			CELLNAVIGATION	.T. 
			ONCHANGE	GridChange()
			VALUE		{ 3 , 2 }
		END GRID 
        
	END WINDOW

 	Form_1.Grid_1.setfocus

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

Function GridChange()

	Static OnChangeCounter := 0
	a := this.value
	OnChangeCounter++
	form_1.title := '  Row: ' + alltrim(str(a [1])) + ' Col: ' + alltrim(str(a [2])) + Space(10) + 'OnChange Count: ' + alltrim(str(OnChangeCounter))

return

Function GetSelectionValue
Local a

	a := Form_1.Grid_1.Value

	MsgInfo( Str (  a [1] ) + ' ' + Str (  a [2] ) )

Return nil

