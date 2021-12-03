/*
* HMG Hello World Demo
* (c) 2002-2009 Roberto Lopez <mail.box.hmg@gmail.com>
*/

// remove the console window in the back


#include "hmg.ch"
REQUEST HB_GT_NUL_DEFAULT
// REQUEST HB_GT_CGI_DEFAULT

Function Main


	DEFINE WINDOW Win_1 ;
		ROW 0 ;
		COL 0 ;
		WIDTH 400 ;
		HEIGHT 400 ;
		TITLE hb_gtVersion() ;
		WINDOWTYPE MAIN

	END WINDOW

	Win_1.Center

	Win_1.Activate

Return

FUNCTION win_p2n( x ); RETURN __xhb_p2n( x )
