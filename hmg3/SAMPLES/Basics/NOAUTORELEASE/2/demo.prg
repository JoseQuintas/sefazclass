/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

* NoAutoRelease Style Demo

* Using this style speed up application execution, since the forms are 
* loaded / created / activated only once (at program startup). Later you 
* only must show or hide them as needed.

#include "hmg.ch"

// DECLARE WINDOW is required, since the windows are referred from code, 
// using semi-oop syntax, prior its definition in code (main window menu)

DECLARE WINDOW Std_Form
DECLARE WINDOW Child_Form
DECLARE WINDOW Topmost_Form
DECLARE WINDOW Modal_Form

Function Main

	*--------------------------------------------------------------------*
	* Main Form Definition
	*--------------------------------------------------------------------*
	DEFINE WINDOW Main_Form ;
		AT 0,0 ;
		WIDTH 540 ;
		HEIGHT 380 ;
		TITLE 'NoAutoRelease Style Demo' ;
		ICON 'DEMO.ICO' ;
		MAIN ;
		FONT 'Arial' SIZE 10

		DEFINE MAIN MENU 
			POPUP '&File'
				ITEM 'Show Standard Form' ACTION Std_Form.Show
				ITEM 'Hide Standard Form' ACTION Std_Form.Hide
				SEPARATOR
				ITEM 'Show Child Form' ACTION Child_Form.Show
				ITEM 'Hide Child Form' ACTION Child_Form.Hide
				SEPARATOR
				ITEM 'Show Topmost Form' ACTION Topmost_Form.Show
				ITEM 'Hide Topmost Form' ACTION Topmost_Form.Hide
				SEPARATOR
				ITEM 'Show Modal Form' ACTION Modal_Form.Show
				SEPARATOR
				ITEM 'Exit'		ACTION Main_Form.Release
			END POPUP
		END MENU

	END WINDOW
	*--------------------------------------------------------------------*
	* Standard Form Definition
	*--------------------------------------------------------------------*
	DEFINE WINDOW Std_Form ;
		AT 300,300 ;
		WIDTH 320 ;
		HEIGHT 240 ;
		TITLE 'Standard Form' 

		DEFINE BUTTON Button_1
			ROW	10
			COL	10
			CAPTION 'Hide Form'
			ACTION	ThisWindow.Hide
		END BUTTON

	END WINDOW
	*--------------------------------------------------------------------*
	* Child Form Definition
	*--------------------------------------------------------------------*
	DEFINE WINDOW Child_Form ;
		AT 100,100 ;
		WIDTH 320 ;
		HEIGHT 240 ;
		TITLE 'Child Form' ;
		CHILD 

		DEFINE BUTTON Button_1
			ROW	10
			COL	10
			CAPTION 'Hide Form'
			ACTION	ThisWindow.Hide
		END BUTTON

	END WINDOW
	*--------------------------------------------------------------------*
	* Topmost Form Definition
	*--------------------------------------------------------------------*
	DEFINE WINDOW Topmost_Form ;
		AT 100,500 ;
		WIDTH 320 ;
		HEIGHT 240 ;
		TITLE 'Topmost Form' ;
		TOPMOST ;

		DEFINE BUTTON Button_1
			ROW	10
			COL	10
			CAPTION 'Hide Form'
			ACTION	ThisWindow.Hide
		END BUTTON

	END WINDOW
	*--------------------------------------------------------------------*
	* Modal Form Definition
	*--------------------------------------------------------------------*
	DEFINE WINDOW Modal_Form ;
		AT 200,200 ;
		WIDTH 320 ;
		HEIGHT 240 ;
		TITLE 'Modal Form' ;
		MODAL 

		DEFINE BUTTON Button_1
			ROW	10
			COL	10
			CAPTION 'Hide Form'
			ACTION	ThisWindow.Hide
		END BUTTON

	END WINDOW

	// Using ACTIVATE WINDOW ALL command, all defined windows will be 
	// activated simultaneously. NOAUTORELEASE and NOSHOW styles in 
	// non-main windows are forced.

	// NOAUTORELEASE window clause, makes that, when the user closes the 
	// windows interactively they are hide instead released from memory, 
	// then, there is no need to reload / redefine / activate prior 
	// show it again.

	//NOSHOW clause makes that the windows be not displayed at activation.

	ACTIVATE WINDOW ALL

Return Nil



