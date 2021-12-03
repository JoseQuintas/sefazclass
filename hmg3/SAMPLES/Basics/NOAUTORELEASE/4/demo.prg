/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

* NoAutoRelease Style Demo / ACTIVATE WINDOW ALL command

* Using ACTIVATE WINDOW ALL command, all defined windows will be activated 
* simultaneously. NOAUTORELEASE and NOSHOW styles in non-main windows 
* are forced.

#include "hmg.ch"

DECLARE WINDOW Std_Form
DECLARE WINDOW Child_Form
DECLARE WINDOW Topmost_Form
DECLARE WINDOW Modal_Form

Function Main

	LOAD WINDOW Main_Form
	LOAD WINDOW Std_Form
	LOAD WINDOW Child_Form
	LOAD WINDOW Topmost_Form
	LOAD WINDOW Modal_Form

	ACTIVATE WINDOW ALL 

Return Nil



