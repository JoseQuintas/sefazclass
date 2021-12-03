MEMVAR _HMG_SYSDATA
            /*
             

              AutoFill in Text Box try

              Started by Esgici
             
              Enhanced by Roberto Lopez and Rathinagiri
             
              2009.05.10
             
    */        #include "hmg.ch"

            PROC AutoFill( ;              // Auto filling text box
                            aList,;       // Items list
                            nCaller,;     // NIL : OnChange, 1: UP, 2: Down
                            cControlName )
                           
               STATIC cLastVal := '',;
                      n1Result := 0
               
               LOCAL  cFrmName := '',;
                      cTxBname := '',;
                      cTxBValue := '',;     // Text Box Value
                      nCarePos  := 0,;  // Text Box CaretPos
                      cCurval   := ''

               cFrmName := thiswindow.name
               if pcount() == 3
                  cTxBName := cControlName
               else
                  cTxBName := this.name
               endif
               cTxBValue := GetProperty( cFrmName, cTxBName, "Value" )     // Text Box Value
               nCarePos  := GetProperty( cFrmName, cTxBName, "CaretPos" )  // Text Box CaretPos
                 
               IF HB_ISNIL( nCaller )

                  IF !( cLastVal == cTxBValue )   
                 
                     // cCurval  := HB_ULEFT( cTxBValue, nCarePos )
                     cCurval  := HB_ULEFT( cTxBValue, nCarePos )
                     
                     IF !EMPTY( cCurval )
                     
                        // n1Result := ASCAN( aList, { | c1 | HMG_UPPER( HB_ULEFT( c1, HMG_LEN( cCurval ) ) ) == HMG_UPPER( cCurval )} )
                         n1Result := ASCAN( aList, { | c1 | HMG_UPPER( HB_ULEFT( c1, HMG_LEN( cCurval ) ) ) == HMG_UPPER( cCurval )} )
                       
                        IF n1Result > 0
                           cCurval := aList[ n1Result ]
                        ENDIF n1Result > 0
                       
                     ENDIF !EMPTY( cCurval )
                     
                     cLastVal := cCurval
                     
                     AF_Apply( cFrmName,cTxBName,cCurval, nCarePos )     
                     
                  ENDIF cLastVal # cCurval     
                 
               ELSE
               
                  IF n1Result > 0
                 
                     IF nCaller < 2
                        n1Result -= IF( n1Result > 1, 1, 0 )
                     ELSE
                        n1Result += IF( n1Result < HMG_LEN( aList ), 1, 0 )
                     ENDIF   
                         
                     cCurval := aList[ n1Result ]
                           
                     cLastVal := cCurval
                     
                     AF_Apply( cFrmName,cTxBName,cCurval, nCarePos )     
                     
                  ENDIF n1Result > 0
                 
               ENDIF HB_ISNIL( nCaller )
                                       
            RETU // AutoFill()   
               
            *-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.

            PROC AF_Apply( ;
                           cFrmName,;
                           cTxBName,;
                           cValue,;
                           nPosit )

               SetProperty( cFrmName, cTxBName, "Value", cValue )       
               SetProperty( cFrmName, cTxBName, "CaretPos", nPosit )       

            RETU // AF_Apply()

            *-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.

            PROC AFKeySet(;
                           aitems )
               Local cFrmName := thiswindow.name,;
                     cTxBName := this.name
                           
               ON KEY UP   OF &cFrmName  ACTION AutoFill(  aitems, 1,cTxBName )
               ON KEY DOWN OF &cFrmName  ACTION AutoFill(  aitems, 2,cTxBName )

            RETU // AFKeySet()

            *-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.

            PROC AFKeyRls( )
               Local cFrmName := thiswindow.name
                           
               RELEASE KEY UP   OF &cFrmName
               RELEASE KEY DOWN OF &cFrmName

            RETU // AFKeyRls()

            *-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.



