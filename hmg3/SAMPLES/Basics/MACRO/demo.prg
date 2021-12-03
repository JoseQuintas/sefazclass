#include "hmg.ch"

Function Main
Local Botoes := {'1','2','3'} , i

	DEFINE WINDOW Win_1 ;
		AT 0,0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE 'Hello World!' ;
		MAIN  

		For i := 1 to 3

			CN := 'Control_' + Alltrim(Str(i))

			@ i*100 ,10  BUTTON &CN ;
				CAPTION Botoes[i] ;
				ACTION MsgInfo('Test') ;
				WIDTH 100 ;
				HEIGHT 25

		Next i

	END WINDOW

	ACTIVATE WINDOW Win_1

Return
