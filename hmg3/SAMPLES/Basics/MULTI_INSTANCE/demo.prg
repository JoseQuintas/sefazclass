/*
* HMG Multiple Instances Demo
* (c) 2003 Roberto Lopez
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_Main ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 200 ;
		TITLE 'Multi-Instance Demo' ;
		MAIN 

	END WINDOW

	LOAD WINDOW BaseForm AS Form_1
	LOAD WINDOW BaseForm AS Form_2
	LOAD WINDOW BaseForm AS Form_3
	LOAD WINDOW BaseForm AS Form_4
	LOAD WINDOW BaseForm AS Form_5

	Form_1.Row := 50
	Form_2.Row := 100
	Form_3.Row := 150
	Form_4.Row := 200
	Form_5.Row := 250

	Form_1.Col := 50
	Form_2.Col := 100
	Form_3.Col := 150
	Form_4.Col := 200
	Form_5.Col := 250

	Form_1.Title := 'Instance 1'
	Form_2.Title := 'Instance 2'
	Form_3.Title := 'Instance 3'
	Form_4.Title := 'Instance 4'
	Form_5.Title := 'Instance 5'

	ACTIVATE WINDOW Form_Main , Form_1 , Form_2 , Form_3 , Form_4 , Form_5

Return

