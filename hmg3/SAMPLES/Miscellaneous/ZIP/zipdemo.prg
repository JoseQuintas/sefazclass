#include "hmg.ch"

Function main()

	DEFINE WINDOW form_1 ; 
		AT 114,218 ;
		WIDTH 334 ;
		HEIGHT 276 ; 
		TITLE 'ZIP TEST' ; 
		MAIN 

		DEFINE MAIN MENU

			DEFINE POPUP "Test"
				MENUITEM 'Create Zip' ACTION CreateZip()
			END POPUP

		END MENU

		@ 80,120 PROGRESSBAR Progress_1 RANGE 0,10 SMOOTH

		@ 120,120 LABEL label_1 VALUE ''


	END WINDOW 

	form_1.center
	form_1.activate

Return NIL

*------------------------------------------------------------------------------*
Function CreateZip()
*------------------------------------------------------------------------------*
local aDir:=Directory("*.txt")
local afiles:={}
Local x
local nLen

	For x:=1 to len(aDir)
	    aadd(afiles,adir[x,1])
	next

	COMPRESS afiles ;
		TO 'ZipTest.Zip' ;
		BLOCK {|cFile,nPos| ProgressUpdate( nPos , cFile ) }  ;
		OVERWRITE

Return nil

*------------------------------------------------------------------------------*
function ProgressUpdate(nPos , cFile )
*------------------------------------------------------------------------------*

	Form_1.Progress_1.Value := nPos
	Form_1.Label_1.Value := cFile

Return Nil


