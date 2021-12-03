/*
* HMG Hello World Demo
* (c) 2002-2004 Roberto Lopez at <http://hmgforum.com>
* Enhanced by Pablo César on May 3rd, 2014
*/

#include "hmg.ch"

Function Main
DEFINE WINDOW Win1 ;
	AT 240,320 ;
	WIDTH 400 ;
	HEIGHT 280 ;
	TITLE 'ListBox Multiselect looks like ComboBox' ;
    MAIN

	DEFINE LISTBOX LIST1
		ROW	10
		COL	10
		WIDTH	100
		HEIGHT	22
		VALUE 0
		ITEMS	{ 'Item 01','Item 02','Item 03','Item 04','Item 05','Item 06','Item 07','Item 08','Item 09','Item 10' }
		DISPLAYEDIT .T.
        ONCHANGE ShowSelected(This.Value)
        ONGOTFOCUS  MoreHeight()
		ONLOSTFOCUS LessHeight()
		MULTISELECT .T.
		TABSTOP .F.
	END LISTBOX

	DEFINE BUTTON BUTTON1
		ROW	10
		COL	150
		CAPTION	'Delete Items 8,9,10'
		ACTION	DeleteTest()
		WIDTH	180
	END BUTTON
	
	DEFINE BUTTON BUTTON2
		ROW	50
		COL	150
		CAPTION	'Delete all Items and Add'
		ACTION	DelAddTest()
		WIDTH	180
	END BUTTON
	
	DEFINE BUTTON BUTTON3
		ROW	90
		COL	150
		CAPTION	'Show Items selected'
		ACTION	GetMultiValue(GetProperty("Win1","LIST1","Value"))
		WIDTH	180
	END BUTTON
	
	DEFINE STATUSBAR FONT "Courier New" SIZE 9
	     STATUSITEM ""
	END STATUSBAR
END WINDOW
ACTIVATE WINDOW Win1
Return Nil

Function MoreHeight()
SetProperty("Win1","LIST1","HEIGHT",140)
Return Nil

Function LessHeight()
SetProperty("Win1","LIST1","HEIGHT",22);DoEvents()
Return Nil

Function DeleteTest
	Win1.List1.DeleteItem(10)
	Win1.List1.DeleteItem(9)
	Win1.List1.DeleteItem(8)
Return Nil

Function DelAddTest()
Local i, aNumbers := {'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten' }

DoMethod ( "Win1", "List1", 'DeleteAllItems' )
For i=1 To 10
    DoMethod ( "Win1", "List1", 'AddItem', aNumbers[i] )
Next
Return Nil

Function GetMultiValue(aValue)
Local i, cTxt := "", nLen := Len(aValue)

for i := 1 to nLen
	cTxt := cTxt + PadR( AllTrim( hb_ValToStr( GetProperty( "Win1", "LIST1", "Item", aValue[i] ) ) ), 25 ) + CRLF
Next i

If Len(aValue) == 0
	MsgInfo('No Selection')
Else
    MsgInfo(cTxt,"Item"+If(nLen>1,"s","")+" selected")
EndIf
Return Nil

Function ShowSelected(aValue)
Local nLen := Len(aValue)

If nLen > 0
   Setproperty("Win1","StatusBar","Item",1,PadC(AllTrim(Str(nLen))+" Item"+If(nLen>1,"s","")+" selected",58))
EndIf
Return Nil