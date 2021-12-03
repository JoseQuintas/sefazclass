
#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 480 ;
		TITLE '' ;
		MAIN ;
		BACKCOLOR {212,208,251} 

		@ 40,10 LABEL Label_1 VALUE 'hI All !!' ;
			BACKCOLOR {212,208,251} ;
			FONTCOLOR BLUE

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return

