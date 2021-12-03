/*
* HMG InputMask Demo
* (c) 2003 Roberto lopez
*/

/*

	InputMask String For Character TextBox

        9	Displays digits
	!       Displays Alphabetic Characters (uppercase)
	A	Displays Alphabetic Characters

	(All other characters are included in text in the position indicated 
	by the mask)

	Format String

	No Format Stirng Is Allowed For Character TextBox

*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 450 ;
		HEIGHT 250 ;
		TITLE 'InputMask Demo' ;
		MAIN 

		DEFINE MAIN MENU
			POPUP 'Test'
				ITEM 'Get Text_1 Value' ACTION MsgInfo (Form_1.Text_1.Value)
				ITEM 'Set Text_1 Value' ACTION Form_1.Text_1.Value := 'GEW-57927/X'
				ITEM 'Set Text_1 Focus' ACTION Form_1.Text_1.SetFocus
				SEPARATOR
				ITEM 'Get Text_2 Value' ACTION MsgInfo (Form_1.Text_2.Value)
				ITEM 'Set Text_2 Value' ACTION Form_1.Text_2.Value := '123.456.789-12' 
				ITEM 'Set Text_2 Focus' ACTION Form_1.Text_2.SetFocus
				SEPARATOR
				ITEM 'Get Text_3 Value' ACTION MsgInfo (Form_1.Text_3.Value)
				ITEM 'Set Text_3 Value' ACTION Form_1.Text_3.Value := '12.345.678' 
				ITEM 'Set Text_3 Focus' ACTION Form_1.Text_3.SetFocus
				SEPARATOR
				ITEM 'Get Text_4 Value' ACTION MsgInfo (Form_1.Text_4.Value)
				ITEM 'Set Text_4 Value' ACTION Form_1.Text_4.Value := '1234-1234-1234-1234' 
				ITEM 'Set Text_4 Focus' ACTION Form_1.Text_4.SetFocus
				SEPARATOR
				ITEM 'Get Text_5 Value' ACTION MsgInfo (Form_1.Text_5.Value)
				ITEM 'Set Text_5 Value' ACTION Form_1.Text_5.Value := 'AA-999/9(A-AAA)'   
				ITEM 'Set Text_5 Focus' ACTION Form_1.Text_5.SetFocus
				SEPARATOR
				ITEM 'Get Text_6 Value' ACTION MsgInfo (Form_1.Text_6.Value)
				ITEM 'Set Text_6 Value' ACTION Form_1.Text_6.Value := '(253) 427 - 7362'   
				ITEM 'Set Text_6 Focus' ACTION Form_1.Text_6.SetFocus

			END POPUP
		END MENU

		@ 10,10 LABEL label_1 ;
			VALUE 'Simple Code:' ;
			WIDTH 100

		@ 10,120 TEXTBOX text_1 ;
			VALUE 'ZFA-17529/Z' ;
			INPUTMASK 'AAA-99999/A'

		@ 10,290 LABEL label_1b ;
			VALUE 'AAA-99999/A' 
			WIDTH 100

		@ 40,10 LABEL label_2 ;
			VALUE 'Brazil ID:' ;
			WIDTH 100 

		@ 40,120 TEXTBOX text_2 ;
			VALUE '123.456.789-12' ;
			INPUTMASK '999.999.999-99' 

		@ 40,290 LABEL label_2b ;
			VALUE '999.999.999-99' 

		@ 70,10 LABEL label_3 ;
			VALUE 'Argentina ID:' ;
			WIDTH 100

		@ 70,120 TEXTBOX text_3 ;
			VALUE '12.123.123' ;
			INPUTMASK '99.999.999' 

		@ 70,290 LABEL label_3b ;
			VALUE '99.999.999' 


		@ 100,10 LABEL label_4 ;
			VALUE 'Credit Card:' ;
			WIDTH 100

		@ 100,120 TEXTBOX text_4 ;
			WIDTH 150 ;
			VALUE '1234-1234-1234-1234' ;
			INPUTMASK '9999-9999-9999-9999' 

		@ 100,290 LABEL label_4b ;
			VALUE '9999-9999-9999-9999' ;
			WIDTH 160

		@ 130,10 LABEL label_5 ;
			VALUE 'Complex Code:' ;
			WIDTH 100

		@ 130,120 TEXTBOX text_5 ;
			WIDTH 130 ;
			VALUE 'JZ-123/4(X-DKS)' ;
			INPUTMASK 'AA-999/9(A-AAA)'  

		@ 130,290 LABEL label_5b ;
			VALUE 'AA-999/9(A-AAA)' 

		@ 160,10 LABEL label_6 ;
			VALUE 'Phone Number:' ;
			WIDTH 100

		@ 160,120 TEXTBOX text_6 ;
			WIDTH 130 ;
			VALUE '(651) 384 - 8372' ;
			INPUTMASK '(999) 999 - 9999'  

		@ 160,290 LABEL label_6b ;
			VALUE '(999) 999 - 9999'  

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return


