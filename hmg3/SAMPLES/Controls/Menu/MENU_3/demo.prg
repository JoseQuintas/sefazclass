/*
* HMG Menu Demo
*/

#include "hmg.ch"

Function Main
LOCAL N
LOCAL m_char
LOCAL m_executar

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN  

		DEFINE MAIN MENU
		    POPUP "&Option"
		        FOR N := 1 TO 3
		            m_char = strzero(n,2)
		            m_executar  =  "ACT_"  +  m_char  +  "( )"
		            MENUITEM  'EXE ' + m_char  ACTION &m_executar
		        NEXT
		    END POPUP
		END MENU

	END WINDOW

	ACTIVATE WINDOW Win_1

Return

Procedure act_01()
	MsgInfo ('Action 01')
Return
Procedure act_02()
	MsgInfo ('Action 02')
Return
Procedure act_03()
	MsgInfo ('Action 03')
Return

