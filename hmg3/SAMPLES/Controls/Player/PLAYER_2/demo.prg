/*

	Player control demo.

	Mustafá & Roberto Lopez

*/
 
#include "hmg.ch"

Function main()

	DEFINE WINDOW Form_1 AT 115,143 WIDTH 575 HEIGHT 425 MAIN TITLE "MP3 Player" 

		DEFINE PLAYER Player_1
			ROW    0
			COL    0
			WIDTH  0
			HEIGHT 0
			FILE ''
			HELPID Nil
			NOAUTOSIZEWINDOW .F.            
			NOAUTOSIZEMOVIE .F.              
			NOERRORDLG .F.
			NOMENU .F.
			NOOPEN .F.
			NOPLAYBAR .T.
			SHOWALL .F.
			SHOWMODE .F.
			SHOWNAME .F.                  
			SHOWPOSITION .F.
		END PLAYER
           
		@ 130,020 BUTTON Button_D1 ;
			CAPTION "Play MP3" ;
			ACTION Form_1.Player_1.Play() 

		@ 130,120 BUTTON Button_D2 ;
			CAPTION "Pause MP3" ;
			ACTION Form_1.Player_1.Pause()
                                 
		@ 130,220 BUTTON Button_D3 ;
			CAPTION "Resume MP3" ;
			ACTION Form_1.Player_1.Resume()

		@ 130,320 BUTTON Button_D4 ;
			CAPTION "End MP3" ;
			ACTION Form_1.Player_1.Position := 1

		@ 130,450 BUTTON Button_D5 ;
			CAPTION "Search" ;
			ACTION Busca_Music()

		@ 180,30 LABEL label_1 ;
			VALUE 'Volume:' 

		@ 180,100 SLIDER slider_1 ;
			RANGE 0,10 ;
			ON CHANGE Form_1.Player_1.Volume := Form_1.Slider_1.Value * 100 


	END WINDOW

	Form_1.Center
	Form_1.Activate

Return Nil


*-------------------------------------------*
Procedure Busca_Music()
*-------------------------------------------*

	Form_1.Player_1.Open ( GetFile( { { 'Mp3 Files' , '*.mp3'} } , '' , '' , .f. , .f. ) )

RETURN NIL
