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
*
* NOAUTORELEASE clause, makes that, when the user closes the windows 
* interactively they are hide instead released from memory, then, there is 
* no need to reload / redefine prior to show it again.
*
* NOSHOW clause makes that the windows be not displayed at activation.

#include "hmg.ch"

// DECLARE WINDOW is required, since the windows are referred from code, 
// using semi-oop syntax, prior its definition in code (main window menu)

DECLARE WINDOW Std_Form
DECLARE WINDOW Child_Form
DECLARE WINDOW Topmost_Form
DECLARE WINDOW Modal_Form

Function Main

	// Load windows from external '.fmg' form definition files

	LOAD WINDOW Main_Form
	LOAD WINDOW Std_Form
	LOAD WINDOW Child_Form
	LOAD WINDOW Topmost_Form
	LOAD WINDOW Modal_Form

	// Activate windows
	// All except main has NOSHOW style, so only main window will be
	// visible at program startup.

	ACTIVATE WINDOW Std_Form	, ;
			Child_Form	, ;
			Topmost_Form	, ;
			Modal_Form	, ;
			Main_Form

Return Nil



