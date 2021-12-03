/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-2008 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
 * Based on HBW32 samples included in Harbour distribution

*/

#include "hmg.ch"

PROCEDURE Main()

	DEFINE WINDOW form_1 ; 
		AT 114,218 ;
		WIDTH 334 ;
		HEIGHT 276 ; 
		TITLE 'REGISTRY TEST' ; 
		MAIN 

		DEFINE MAIN MENU

			DEFINE POPUP "Test"
				MENUITEM 'Read Registry' ACTION ReadRegistryTest()
				MENUITEM 'Write Registry' ACTION WriteRegistryTest()
			END POPUP

		END MENU


	END WINDOW 

	form_1.center
	form_1.activate

Return NIL

Procedure ReadRegistryTest()

	MsgInfo (hb_ValToStr( RegistryRead( "HKEY_CURRENT_USER\Control Panel\Desktop\Wallpaper" ) ) , "HKEY_CURRENT_USER\Control Panel\Desktop\Wallpaper" )

Return

Procedure WriteRegistryTest()
Local c := ''

	If MsgYesNo ( 'This will change HKEY_CURRENT_USER\Control Panel\Desktop\Wallpaper.','Are you sure?' ) 

		c := InputBox ( '' , 'New Value:' )

		If .Not. Empty (c)
			RegistryWrite( "HKEY_CURRENT_USER\Control Panel\Desktop\Wallpaper" , c  )
		Endif

	Endif

Return

