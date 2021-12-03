/*
	HMG ComboBox Image Property Demo
	(c) 2008 Roberto Lopez
*/

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

#include "hmg.ch"

Function Main
Local aImages := { '00.bmp' ,'01.bmp' , '02.bmp' , '03.bmp' , '04.bmp' , '05.bmp' , '06.bmp' , '07.bmp' , '08.bmp' , '09.bmp' }
Local aItems := {}
Local aRet := {}

	aadd ( aItems , { 4 , 'Item 01' } )
	aadd ( aItems , { 2 , 'Item 02' } )
	aadd ( aItems , { 6 , 'Item 03' } )
	aadd ( aItems , { 1 , 'Item 04' } )
	aadd ( aItems , { 3 , 'Item 05' } )
	aadd ( aItems , { 7 , 'Item 06' } )

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		TITLE 'ComboBox Demo' ;
		MAIN 

		DEFINE MAIN MENU
			DEFINE POPUP '&Test'
				MENUITEM 'Get Value' ACTION MsgInfo( Str ( Form_1.Combo_1.Value ) )
				MENUITEM 'Set Value' ACTION Form_1.Combo_1.Value := 2
				MENUITEM 'Add Item' ACTION Form_1.Combo_1.AddItem ( { 3 , 'New' } )
				MENUITEM 'Delete Item' ACTION Form_1.Combo_1.DeleteItem ( 1 )
				MENUITEM 'Set Item' ACTION Form_1.Combo_1.Item ( 2 ) := { 0 , 'Modified' }
				MENUITEM 'Get Item' ACTION ( aRet := Form_1.Combo_1.Item ( 1 ) , MsgInfo (Str(aRet[1]) + ' ' + aRet[2] ) )
				MENUITEM 'Get ItemCount' ACTION MsgInfo (Str(Form_1.Combo_1.ItemCount) )
				MENUITEM 'Get DisplayValue' ACTION MsgInfo ( Form_1.Combo_1.DisplayValue )
				MENUITEM 'Set DisplayValue' ACTION Form_1.Combo_1.DisplayValue := 'Hey'
			END POPUP
		END MENU

		DEFINE COMBOBOX Combo_1 
			ROW		10
			COL		10
			WIDTH		100 
			ITEMS		aItems 
			VALUE		1 
			IMAGE		aImages
			DISPLAYEDIT	.T.
			ONDISPLAYCHANGE	PLAYBEEP()
		END COMBOBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

