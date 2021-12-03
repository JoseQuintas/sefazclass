/*
* HMG Virtual Grid Demo
* (c) 2009 Roberto Lopez
*/

#include "hmg.ch"

Function Main

Local aValue := { Nil , Nil }


	* We will work with multiples index.
	* It will be better to work with an unique 'OrderBag' file.
	* So, we will use DBFCDX RDD.

	REQUEST DBFCDX , DBFFPT
	RDDSETDEFAULT( "DBFCDX" )

	USE TEST

	INDEX ON CODE	TAG A-CODE	TO TEST		ASCENDING
	INDEX ON FIRST	TAG A-FIRST	TO TEST		ASCENDING
	INDEX ON LAST	TAG A-LAST	TO TEST		ASCENDING
	INDEX ON BIRTH	TAG A-BIRTH	TO TEST		ASCENDING

	INDEX ON CODE	TAG D-CODE	TO TEST		DESCENDING
	INDEX ON FIRST	TAG D-FIRST	TO TEST		DESCENDING
	INDEX ON LAST	TAG D-LAST	TO TEST		DESCENDING
	INDEX ON BIRTH	TAG D-BIRTH	TO TEST		DESCENDING

	SET ORDER TO TAG A-CODE

	GO TOP

	* Grid Column Controls Definitions

	aCtrl_1 := {'TEXTBOX'	,'NUMERIC','9999999999'}
	aCtrl_2 := {'TEXTBOX'	,'CHARACTER'}
	aCtrl_3 := {'TEXTBOX'	,'CHARACTER'}
	aCtrl_4 := {'DATEPICKER','UPDOWN'}
	aCtrl_5 := {'CHECKBOX'	,'Yes','No' }
	aCtrl_6 := {'EDITBOX' }

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 800 ;
		HEIGHT 510 ;
		TITLE 'Multiple Index Test' ;
		MAIN 


		DEFINE MAIN MENU 
			POPUP 'Test'
				ITEM 'Order Col.1 Ascending' ACTION Order1Ascending()
				ITEM 'Order Col.2 Ascending' ACTION Order2Ascending()
				ITEM 'Order Col.3 Ascending' ACTION Order3Ascending()
				ITEM 'Order Col.4 Ascending' ACTION Order4Ascending()
				ITEM 'Order Col.1 Descending' ACTION Order1Descending()
				ITEM 'Order Col.2 Descending' ACTION Order2Descending()
				ITEM 'Order Col.3 Descending' ACTION Order3Descending()
				ITEM 'Order Col.4 Descending' ACTION Order4Descending()
			END POPUP
		END MENU


		@ 10,10 GRID Grid_1 ;
			WIDTH 770 ;
			HEIGHT 400 ;
			HEADERS {'Column 1','Column 2','Column 3','Column 4','Column 5','Column 6'} ;
			WIDTHS {140,140,140,100,100,100};
			VALUE { 1 , 1 } ;
			ROWSOURCE "Test" ;
			COLUMNFIELDS { 'Code' ,  'First' , 'Last' ,  'Birth' , 'Married' , 'Bio' } 

		
	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return



Procedure Order1Ascending

	SET ORDER TO TAG A-CODE IN Test

	Form_1.Grid_1.Refresh

Return

Procedure Order2Ascending

	SET ORDER TO TAG A-FIRST IN Test

	Form_1.Grid_1.Refresh

Return

Procedure Order3Ascending

	SET ORDER TO TAG A-LAST IN Test

	Form_1.Grid_1.Refresh

Return

Procedure Order4Ascending

	SET ORDER TO TAG A-BIRTH IN Test

	Form_1.Grid_1.Refresh

Return

Procedure Order1Descending

	SET ORDER TO TAG D-CODE IN Test

	Form_1.Grid_1.Refresh

Return

Procedure Order2Descending

	SET ORDER TO TAG D-FIRST IN Test

	Form_1.Grid_1.Refresh

Return

Procedure Order3Descending

	SET ORDER TO TAG D-LAST IN Test

	Form_1.Grid_1.Refresh

Return

Procedure Order4Descending

	SET ORDER TO TAG D-BIRTH IN Test

	Form_1.Grid_1.Refresh

Return



