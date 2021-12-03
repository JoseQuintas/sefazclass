
            /*
             

              AutoFill in Text Box try

              Started by Esgici
             
              Enhanced by Roberto Lopez and Rathinagiri
             
              2009.05.10
             
    */        #include "hmg.ch"
              #include "hfcl.ch"


            PROC Main()

               aCountries := HB_ATOKENS( MEMOREAD( "Countries.lst" ),   CRLF )
               
               ASORT( aCountries )                    // This Array MUST be sorted
                   
               DEFINE WINDOW frmAFTest ;
                  AT 0,0 ;
                  WIDTH  550 ;
                  HEIGHT 300 ;
                  TITLE 'AutoFill in Text Box try (BE2)' ;
                  MAIN
                 
                  ON KEY ESCAPE ACTION frmAFTest.Release
                 
                  DEFINE LABEL lblCountry
                     ROW        50
                     COL        50
                     VALUE      "Country :"
                     RIGHTALIGN .T.
                     AUTOSIZE   .T.
                  END LABEL // lblCountry
                       
                  DEFINE TEXTBOX txbCountry
                     ROW         48
                     COL         110
                     ONCHANGE    AutoFill( aCountries )
                     ONGOTFOCUS  AFKeySet( aCountries )
                     ONLOSTFOCUS AFKeyRls(  )
                  END TEXTBOX // txbCountry   
                     
               END WINDOW // frmAFTest
               
               frmAFTest.Center
               
               frmAFTest.Activate

                 
            RETU // Main()

            