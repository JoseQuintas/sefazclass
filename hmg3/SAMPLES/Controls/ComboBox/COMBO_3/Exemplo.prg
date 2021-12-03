/*
* HMG ComboBox Demo
* Contributed by "Sistemas Victory" <victory@cultura.com.br>
* Modified by Roberto Lopez
*/

#include "hmg.ch"

Function Main

	SET INTERACTIVECLOSE QUERY
	SET NAVIGATION EXTENDED
	
	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
	        WIDTH 600 ;
        	HEIGHT 400 ;
	        TITLE 'Exemplo Funcao' ;
        	MAIN ;
		FONT 'Arial' ;
		SIZE 10

			@ 120   , 030  Label     L_CODIGO ;
				VALUE 'Codigo:' 

			@ 120   , 150  TextBox   T_CODIGO  ;
				ON GOTFOCUS Form_1.L_CODIGO.FontBold := .T. ;
				ON LOSTFOCUS Form_1.L_CODIGO.FontBold := .F. 

			*---------------------------------------------

			@ 160   , 030  Label     L_ESPECIE ;
				VALUE 'Especie:'  

			@ 160   , 150  COMBOBOX  C_ESPECIE ;
				ITEMS { 'A' , 'B' , 'C' } ;
				value 1 ;
				ON GOTFOCUS Form_1.L_ESPECIE.FontBold := .T. ;
				ON LOSTFOCUS Form_1.L_ESPECIE.FontBold := .F. 

			*---------------------------------------------

			@ 200   , 030  Label     L_DESCRICAO  ;
				VALUE 'Descricao:'  

			@ 200   , 150  TextBox   T_DESCRICAO ;
				ON GOTFOCUS Form_1.L_DESCRICAO.FontBold := .T. ;
				ON LOSTFOCUS Form_1.L_DESCRICAO.FontBold := .F. 

			*---------------------------------------------

			@ 240   , 030  Label     L_CODIR ;
				VALUE 'Auxiliar:' 

			@ 240   , 150  COMBOBOX  C_CODIR  ;
				ITEMS { '1' , '2' , '3' } ;
				VALUE 1 ;
				ON GOTFOCUS Form_1.L_CODIR.FontBold := .T. ;
				ON LOSTFOCUS Form_1.L_CODIR.FontBold := .F. 

			*---------------------------------------------

			@ 280   , 030  Label     L_DESCG ;
				VALUE 'Endereco:' 

			@ 280   , 150  TextBox   T_DESCG ;
				ON GOTFOCUS Form_1.L_DESCG.FontBold := .T. ;
				ON LOSTFOCUS Form_1.L_DESCG.FontBold := .F. 

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return



