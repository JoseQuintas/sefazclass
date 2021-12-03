#include "hmg.ch"

Function main()

	DEFINE WINDOW Media_Test ;
		AT 0,0 ;
		WIDTH 550 ;
		HEIGHT 400 ;
		TITLE 'Media Test' ;
		MAIN 

		@ 200,0 PLAYER Player_1 ;
			WIDTH 100 ;
			HEIGHT 100 ;
			FILE "sample.avi" ;
			SHOWALL NOMENU

		@ 330,0 LABEL Label_1 VALUE 'SAMPLE.AVI'

		@ 275,110 PLAYER Player_2 ;
			WIDTH 100 ;
			HEIGHT 25 ;
			FILE "sample.mp3" ;
			SHOWALL

		@ 330,110 LABEL Label_2 VALUE 'SAMPLE.MP3'

		@ 275,220 PLAYER Player_3 ;
			WIDTH 100 ;
			HEIGHT 25 ;
			FILE "sample.wav" ;
			SHOWALL

		@ 330,220 LABEL Label_3 VALUE 'SAMPLE.WAV'

		@ 275,330 PLAYER Player_4 ;
			WIDTH 100 ;
			HEIGHT 25 ;
			FILE "sample.mid" ;
			SHOWALL

		@ 330,330 LABEL Label_4 VALUE 'SAMPLE.MID'

		@ 200,440 PLAYER Player_5 ;
			WIDTH 100 ;
			HEIGHT 100 ;
			FILE "sample.wmv" ;
			SHOWALL NOMENU

		@ 330,440 LABEL Label_5 VALUE 'SAMPLE.wmv'

		@ 0,0 BUTTON Button_D1 ;
			CAPTION "Play AVI" ;
			ACTION Media_Test.Player_1.Play() 

		@ 30,0 BUTTON Button_D2 ;
			CAPTION "Play MP3" ;
			ACTION Media_Test.Player_2.Play() 

		@ 60,0 BUTTON Button_D3 ;
			CAPTION "Play Wave" ;
			ACTION Media_Test.Player_3.Play() 

		@ 90,0 BUTTON Button_D4 ;
			CAPTION "Play Mid" ;
			ACTION Media_Test.Player_4.Play() 

		@ 120,0 BUTTON Button_D5 ;
			CAPTION "Play wmv" ;
			ACTION Media_Test.Player_5.Play() 

		@ 0,100 BUTTON Button_A1 ;
			CAPTION "Pause AVI" ;
			ACTION Media_Test.Player_1.Pause()

		@ 30,100 BUTTON Button_A2 ;
			CAPTION "Pause MP3" ;
			ACTION Media_Test.Player_2.Pause()

		@ 60,100 BUTTON Button_A3 ;
			CAPTION "Pause Wave" ;
			ACTION Media_Test.Player_3.Pause()

		@ 90,100 BUTTON Button_A4 ;
			CAPTION "Pause Mid" ;
			ACTION Media_Test.Player_4.Pause() 

		@ 120,100 BUTTON Button_A5 ;
			CAPTION "Pause wmv" ;
			ACTION Media_Test.Player_5.Pause() 

		@ 0,200 BUTTON Button_R1 ;
			CAPTION "Resume AVI" ;
			ACTION Media_Test.Player_1.Resume()

		@ 30,200 BUTTON Button_R2 ;
			CAPTION "Resume MP3" ;
			ACTION Media_Test.Player_2.Resume()

		@ 60,200 BUTTON Button_R3 ;
			CAPTION "Resume Wave" ;
			ACTION Media_Test.Player_3.Resume()

		@ 90,200 BUTTON Button_R4 ;
			CAPTION "Resume Mid" ;
			ACTION Media_Test.Player_4.Resume()

		@ 120,200 BUTTON Button_R5 ;
			CAPTION "Resume wmv" ;
			ACTION Media_Test.Player_5.Resume()

		@ 0,300 BUTTON Button_E1 ;
			CAPTION "End AVI" ;
			ACTION Media_Test.Player_1.Position := 1

		@ 30,300 BUTTON Button_E2 ;
			CAPTION "End MP3" ;
			ACTION Media_Test.Player_2.Position := 1

		@ 60,300 BUTTON Button_E3 ;
			CAPTION "End Wave" ;
			ACTION Media_Test.Player_3.Position := 1

		@ 90,300 BUTTON Button_E4 ;
			CAPTION "End Mid" ;
			ACTION Media_Test.Player_4.Position := 1

		@ 120,300 BUTTON Button_E5 ;
			CAPTION "End wmv" ;
			ACTION Media_Test.Player_5.Position := 1

	END WINDOW

	CENTER WINDOW Media_Test

	ACTIVATE WINDOW Media_Test 

Return




