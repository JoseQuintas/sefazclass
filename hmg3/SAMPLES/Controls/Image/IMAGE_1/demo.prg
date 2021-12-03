
#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 480 ;
		TITLE 'Hello World!' ;
		MAIN 

		DEFINE MAIN MENU
			POPUP 'File'
				ITEM 'Select Image' ACTION Form_1.Image_1.Picture := Getfile ( { {'jpg Files','*.jpg'} , {'gif Files','*.gif'} } , 'Select Image' ) 
			END POPUP
		END MENU

		DEFINE IMAGE Image_1
			ROW	0
			COL	0
			HEIGHT	430
		        WIDTH	635
			PICTURE	'HMGLogo.gif'
			STRETCH	.F.
		END IMAGE

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1 

Return

