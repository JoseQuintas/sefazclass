/*
* HMG InputMask Demo
* (c) 2003 Roberto lopez
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 480 ;
		TITLE 'InputMask Demo' ;
		MAIN ;
		BACKCOLOR YELLOW

		DEFINE MAIN MENU
			POPUP 'Test'
				ITEM 'Set Text_1 FontColor' ACTION Form_1.Text_1.FontColor := GetColor() 
				ITEM 'Set Label_1 FontColor' ACTION Form_1.Label_1.FontColor := GetColor()
				ITEM 'Set Check_1 FontColor' ACTION Form_1.Check_1.FontColor := GetColor() 
				ITEM 'Set Radio_1 FontColor' ACTION Form_1.Radio_1.FontColor := GetColor()
				ITEM 'Set Spinner_1 FontColor' ACTION Form_1.Spinner_1.FontColor := GetColor()
				ITEM 'Set Edit_1 FontColor' ACTION Form_1.Edit_1.FontColor := GetColor()
				ITEM 'Set List_1 FontColor' ACTION Form_1.List_1.FontColor := GetColor()
				ITEM 'Set Grid_1 FontColor' ACTION Form_1.Grid_1.FontColor := GetColor()
				SEPARATOR
				ITEM 'Set Text_1 BackColor' ACTION Form_1.Text_1.BackColor := GetColor() 
				ITEM 'Set Label_1 BackColor' ACTION Form_1.Label_1.BackColor := GetColor()
				ITEM 'Set Check_1 BackColor' ACTION Form_1.Check_1.BackColor := GetColor()
				ITEM 'Set Radio_1 BackColor' ACTION Form_1.Radio_1.BackColor := GetColor()
				ITEM 'Set Frame_1 BackColor' ACTION Form_1.Frame_1.BackColor := GetColor()
				ITEM 'Set Spinner_1 BackColor' ACTION Form_1.Spinner_1.BackColor := GetColor()
				ITEM 'Set Edit_1 BackColor' ACTION Form_1.Edit_1.BackColor := GetColor()
				ITEM 'Set List_1 BackColor' ACTION Form_1.List_1.BackColor := GetColor()
				ITEM 'Set Grid_1 BackColor' ACTION Form_1.Grid_1.BackColor := GetColor()
				ITEM 'Set Slider_1 BackColor' ACTION Form_1.Slider_1.BackColor := GetColor()
			END POPUP
		END MENU

		@ 10,10 TEXTBOX Text_1 ;
		VALUE 'Hi All' ;
		BACKCOLOR RED ;
		FONTCOLOR YELLOW

		@ 40,10 LABEL Label_1 VALUE 'hI All !!' ;
			BACKCOLOR YELLOW ;
			FONTCOLOR BLUE

		@ 70,10 CHECKBOX Check_1 CAPTION 'CheckBox' ;
			VALUE .T. ;
			BACKCOLOR YELLOW ;
			FONTCOLOR BLUE

		@ 100,10 RADIOGROUP Radio_1 ;
			OPTIONS { 'One' , 'Two' , 'Three', 'Four' } ;
			VALUE 1 ;
			TOOLTIP 'RadioGroup' ;
			BACKCOLOR YELLOW ;
			FONTCOLOR BLUE

		@ 220,10 FRAME Frame_1 CAPTION 'Frame_1' ;
			WIDTH 130 ;
			HEIGHT 110 ;
			BACKCOLOR YELLOW 

		@ 350,10 SLIDER Slider_1 ;
			RANGE 1,10 ;
			VALUE 5 ;
			TOOLTIP 'Slider' ;
			BACKCOLOR YELLOW 

		@ 400,10 SPINNER Spinner_1 ;
			RANGE 0,10 ;
			VALUE 5 ;
			WIDTH 100 ;
			TOOLTIP 'Range 1,65000' ;
			BACKCOLOR RED ;
			FONTCOLOR YELLOW

		@ 10,200 EDITBOX Edit_1 ;
			VALUE 'Hi All' ;
			BACKCOLOR RED ;
			FONTCOLOR YELLOW

		@ 300,200 LISTBOX List_1 ;
			WIDTH 120 ;
			HEIGHT 90 ;
			ITEMS {'Item 1','Item 2','Item 3'} ;
			VALUE 1  ;
			TOOLTIP 'ListBox' ;
			BACKCOLOR RED ;
			FONTCOLOR YELLOW

		@ 10,400 GRID Grid_1 ;
			WIDTH 200 ;
			HEIGHT 140 ;
			HEADERS { 'Last Name','First Name'} ;
			WIDTHS { 100,100} ;
			ITEMS { { 'Simpson','Homer'} , {'Mulder','Fox'} } ;
			VALUE 1 ;
			TOOLTIP 'Grid Control' ;
			BACKCOLOR RED ;
			FONTCOLOR YELLOW ;
			ON HEADCLICK { {|| MsgInfo('Header 1 Clicked !')} , { || MsgInfo('Header 2 Clicked !')} } ;
			ON DBLCLICK MsgInfo ('DoubleClick!','Grid') 

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

