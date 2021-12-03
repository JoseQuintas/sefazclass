#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 300 ;
        TITLE 'Tutor 06 - RadioGroup Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change RadioGroup Value' ACTION  Win_1.Radio_1.Value := 2
             ITEM 'Retrieve RadioGroup Value' ACTION  MsgInfo ( Str(Win_1.Radio_1.Value))

           END POPUP
        END MENU

            @ 80, 120 RADIOGROUP Radio_1 OPTIONS {'Option 1','Option 2','Option 3'}

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

