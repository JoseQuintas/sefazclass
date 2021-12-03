/*
	HMG ComboBox Image Property Demo
	(c) 2008 Roberto Lopez
*/

#Include "hmg.ch"
// #include "common.ch"

/*

- 'Image' Property specify a character array containing image file names or 
resource names.

When you add an item, must specify the image array index number (zero based)
and the text associated with it.

When adding items at startup you must to use a two dimensional array.
This array must have one row for each combo item and two columns.
The first column must contain the image index and the second the text for 
the item.

When using the additem or Item properties you must use a single array 
containing two elements. The first, the image index item and the second, 
the text for the item. 

When you retrieve the item, using the 'item' property, it will return a two
elwments array containing the image index and the text of the item.

When 'Image' and 'ItemSource' properties are used simultaneously, 
'ItemSource' must be specified as a list containing two field names.
The first, the image index for the items, the second, the item text.

'Sort' and 'Image' can't be used simultaneously.

- 'DroppedWidth' property is used to set the dropdown list in a combobox control.
'DroppedWidth' can't be less that ComboBox width.

- OnDropDown Event will be executed when the user attempt to open dropdown list

- OnCloseUp Event will be executed when the user closes the dropdown list

*/

Function Main() 		
Local aImages := { '00.bmp' ,'01.bmp' , '02.bmp' , '03.bmp' , '04.bmp' , '05.bmp' , '06.bmp' , '07.bmp' , '08.bmp' , '09.bmp' }

	Use Cidades Alias Cidades New
	Index On Descricao To Cidades1

	DEFINE WINDOW Form_1			;
		AT 0,0				;
		WIDTH 500			;  
		HEIGHT 120			;
		TITLE "Exemplos ComboBox New"	;		
		MAIN				;      
		NOMAXIMIZE			;
		NOSIZE				

		DEFINE MAIN MENU
			DEFINE POPUP '&Test'
				MENUITEM 'Get Combo_1 Value' ACTION MsgInfo( Str ( Form_1.Combo_1.Value ) )
				MENUITEM 'Set Combo_1 Value' ACTION Form_1.Combo_1.Value := 2
				MENUITEM 'Refresh Combo_1' ACTION Form_1.Combo_1.Refresh
			END POPUP
		END MENU


		@ 10, 10 COMBOBOX Combo_1				;
			ITEMSOURCE CIDADES->CODIGO , CIDADES->DESCRICAO	; 
			VALUE 5						;
			WIDTH 200					;
			HEIGHT 100					;
			IMAGE aImages 					;
			DROPPEDWIDTH 500				;
			ON DROPDOWN PlayBeep()				;
			ON CLOSEUP PlayAsterisk()		


		DEFINE COMBOBOX Combo_2
			ROW 10
			COL 250
			ITEMSOURCE CIDADES->CODIGO , CIDADES->DESCRICAO
			VALUE 2
			WIDTH 200					
			HEIGHT 100					
			IMAGE aImages
			DROPPEDWIDTH 350
			ONDROPDOWN PlayBeep()
			ONCLOSEUP PlayAsterisk()		
		END COMBOBOX

	END WINDOW		

	CENTER WINDOW   Form_1

	ACTIVATE WINDOW Form_1

Return

