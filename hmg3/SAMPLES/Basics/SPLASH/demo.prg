/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_Main ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'Main Window' ;
		MAIN ;
		NOSHOW 

	END WINDOW

	DEFINE WINDOW Form_Splash ;
		AT 0,0 ;
		WIDTH 500 HEIGHT 200 ;
		TITLE '';
		TOPMOST NOCAPTION ;
		ON INIT SplashDelay() ;
		ON RELEASE Form_Main.Maximize()

		@ 70,10 LABEL Label_1 ;
		WIDTH 500 HEIGHT 40 ;
		VALUE 'Splash WIndow (Wait a Moment)' ;
		FONT 'Arial' SIZE 24 

	END WINDOW

	CENTER WINDOW Form_Splash

	ACTIVATE WINDOW Form_Splash , Form_Main

Return Nil

Procedure SplashDelay()

Local iTime

	iTime := Seconds()

	Do While Seconds() - iTime < 5
	EndDo

	Form_Splash.Release

Return

