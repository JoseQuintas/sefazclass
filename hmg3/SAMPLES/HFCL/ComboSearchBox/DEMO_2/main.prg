  /*
     

      CSBox ( Combined Search Box ) try


    */

    #include "hmg.ch"

    *!!!!!!!!!!!!!!!!!!!!!!	
    #include "hfcl.ch"
    *!!!!!!!!!!!!!!!!!!!!!!

    PROC Main()

       aCountries := HB_ATOKENS( MEMOREAD( "Countries.lst" ),   CRLF )
       
       ASORT( aCountries )                    // This Array MUST be sorted
           
       DEFINE WINDOW frmCSBTest ;
          AT 0,0 ;
          WIDTH 550 ;
          HEIGHT 300;
          TITLE 'CSBox ( Combined Search Box ) Test' ;
          MAIN
         
          ON KEY ESCAPE ACTION frmCSBTest.Release
          

          define label countries
             row 25
             col 100
             width 100
             value "Countries"
          end label

          define combosearchbox s1
             row 25
             col 190
             width 200
             fontname "Courier"
             fontitalic .t.
             fontbold .t.
             fontcolor {255,255,255}
             backcolor {0,0,255}
             items acountries
             on enter msginfo(frmcsbtest.s1.value)
             anywheresearch .f.
             // dropheight 50
             additive .t.
             rowoffset 50
             coloffset 0
          end combosearchbox
            

            
       END WINDOW // frmCSBTest
       
       frmCSBTest.Center


	* !!!!!!
	* CombosearchBox already inherits all properties events 
	* and methods from TextBox!!!
	* Test it uncommenting the following:
	*
	* frmCSBTest.s1.Value := '*'
	*
	* !!!!!!

       
       frmCSBTest.Activate

         
    RETU // Main()


