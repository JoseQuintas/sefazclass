/*
* HMG InputMask Demo
* (c) 2003 Roberto lopez
*/

/*

	InputMask String For numeric textBox

        9	Displays digits
        $       Displays a dollar sign in place of a leading space 
        *       Displays an asterisk in place of a leading space 
        .       Specifies a decimal point position
        ,       Specifies a comma position

	Format String

        C       Displays CR after positive numbers
        X       Displays DB after negative numbers
        (       Encloses negative numbers in parentheses
	E	Displays points as thousand separator and comma as decimal 
		separator.

*/

#include "hmg.ch"

Function Main

	SET NAVIGATION EXTENDED

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 500 ;
		TITLE 'InputMask Demo' ;
		MAIN 

		DEFINE MAIN MENU
			POPUP 'Test'
				ITEM 'Get Text_1 Value' ACTION MsgInfo (Str(Form_1.Text_1.Value))
				ITEM 'Set Text_1 Value' ACTION Form_1.Text_1.Value := 123456.12
				ITEM 'Set Text_1 Focus' ACTION Form_1.Text_1.SetFocus
			END POPUP
		END MENU

		@ 10,10 TEXTBOX Text_1 ;
		VALUE 1234567.12 ;
		NUMERIC INPUTMASK "$9,999,999.99" 


		@ 50,10 TEXTBOX Text_2 ;
		VALUE 1234.56 ;
		NUMERIC INPUTMASK "$9,999.99" FORMAT 'CX' 


		@ 90,10 TEXTBOX Text_3 ;
		VALUE -123.0 ;
		NUMERIC INPUTMASK "999,999.99" FORMAT '('

		@ 130,10 TEXTBOX Text_4 ;
		VALUE 123.0 ;
		NUMERIC INPUTMASK "999.9" 	

		@ 170,10 TEXTBOX Text_5 ;
		VALUE -123.45 ;
		NUMERIC INPUTMASK "$9,999.99" FORMAT 'CX'

		@ 210,10 TEXTBOX Text_6 ;
		VALUE 1234.56 ;
		NUMERIC INPUTMASK "$***,999.99" 

		@ 250,10 TEXTBOX Text_7 ;
		VALUE 12345678.12 ;
		NUMERIC INPUTMASK "99999999.99" 

		@ 290,10 TEXTBOX Text_8 ;
		VALUE 1.1 ;
		NUMERIC INPUTMASK "9.9" 

		@ 330,10 TEXTBOX Text_9 ;
		VALUE 1234567890.12 ;
		NUMERIC INPUTMASK "$9999999999.99" 

		@ 370,10 TEXTBOX Text_10 ;
		VALUE 123456 ;
		NUMERIC INPUTMASK "$9999999" 

		@ 410,10 TEXTBOX Text_11 ;
			VALUE 1234.56 ;
			NUMERIC INPUTMASK "99,999.99" FORMAT 'E'

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

