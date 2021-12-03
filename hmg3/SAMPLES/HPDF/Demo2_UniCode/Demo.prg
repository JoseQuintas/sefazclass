#include "hmg.ch"

Function Main()
SELECT HPDFDOC "sample.pdf" PAPERLENGTH 300 PAPERWIDTH 300 LOG
START HPDFDOC
    START HPDFPAGE
	
	SET HPDFDOC ENCODING TO "WinAnsiEncoding"
	    
		@ 10,20  HPDFPRINT "I want Euro sign here: "+CHR(128)
		
        @ 20,20  HPDFPRINT "I want this STRIKEOUT (not working)" STRIKEOUT

		@ 18,67  HPDFPRINT "_________" // COLOR { 51, 255, 255 }
		@ 20,92  HPDFPRINT "<----  This line was drawing to simulate a baseline (made manually)" SIZE 9 COLOR { 0, 0, 255 }
		
        @ 30,20  HPDFPRINT "I want this italic" ITALIC
        @ 40,20  HPDFPRINT "I want this bold" BOLD
        @ 50,20  HPDFPRINT "I want this UNDERLINE (not working)" UNDERLINE
		
		@ 50,67  HPDFPRINT "_________" // COLOR { 255, 0, 0 }
		@ 52,92  HPDFPRINT "<----  This line was drawing to simulate a baseline (made manually)" SIZE 9 COLOR { 0, 0, 255 }
        
		@ 60,20 HPDFPRINT "I have HMG 3.2.1 (stable) in Courier-Bold" FONT "Courier-Bold"
        
        @ 80, 10 HPDFPRINT "This is a sample Text in default font in ITALIC." ITALIC
        @ 90, 10 HPDFPRINT "This is a sample Text in default font in BOLD." BOLD
        
        @ 100, 10 HPDFPRINT "This is a sample Text in Arial or Helvetica font in ITALIC." FONT "aRIAL" SIZE 14 ITALIC
        @ 110, 10 HPDFPRINT "This is a sample Text in Arial or Helvetica font in BOLD and ITALIC." FONT "aRIAL" SIZE 14 BOLD ITALIC
        
        @ 120, 10 HPDFPRINT "This is a sample Text in Times-Roman font in ITALIC with size 8" font "TIMES-ROMAN" SIZE 8 ITALIC
        
        @ 135, 200 HPDFPRINT "This is right aligned text" SIZE 14 RIGHT
        
        @ 150, 105 HPDFPRINT "This is center aligned text" COLOR { 255, 0, 0 } CENTER
        
        @ 170, 100 HPDFPRINT "This is text in bigger font size" SIZE 30 COLOR { 255, 0, 0 }
        
        @ 190, 10 HPDFPRINT "The font is Tscparan.TTF" size 12
        
        @ 210, 10 HPDFPRINT UNICODE 'இது தமிழிலும் அச்சடிக்க உதவுகின்றது' to 230, 800 font 'TAU_Elango_Kapilan' size 20

        @ 230, 10 HPDFPRINT UNICODE 'இது தமிழிலும் அச்சடிக்க உதவுகின்றது' to 250, 800 size 20

        @ 250, 10 HPDFPRINT UNICODE 'இது தமிழிலும் அச்சடிக்க உதவுகின்றது' to 270, 800 size 24


    END HPDFPAGE
END HPDFDOC
Execute File 'sample.pdf'
Return Nil