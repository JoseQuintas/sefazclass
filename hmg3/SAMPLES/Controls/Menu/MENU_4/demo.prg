/*
* HMG Hello World Demo
*/

#include "hmg.ch"

Function Main

	public aMenu :=	{ {"Cadastro","MsgInfo('Cadastro')"} ,;
			{"Consulta","MsgInfo('Consulta')"} ,;
			{"Sair"    ,"MsgInfo('Sair')"    }},;
			cAction

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN 

		DEFINE MAIN MENU

			For nI=1 To Len(aMenu)
				POPUP aMenu[nI][1]
					cAction:=aMenu[nI][2]
					ITEM aMenu[nI][1] ACTION { || &cAction }
				END POPUP
			Next

		END MENU

	END WINDOW

	ACTIVATE WINDOW Win_1

Return

