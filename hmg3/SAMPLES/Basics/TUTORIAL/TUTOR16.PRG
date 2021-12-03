#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 16 Spinner Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change Spinner Value' ACTION  Win_1.Spinner_1.Value := 8
             ITEM 'Retrieve Spinner Value' ACTION  MsgInfo ( Str(Win_1.Spinner_1.Value)) 
           END POPUP
        END MENU 

        @ 10,10 SPINNER Spinner_1 ;
            RANGE 0,10 ;
            VALUE 5 ;
            WIDTH 100 

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

