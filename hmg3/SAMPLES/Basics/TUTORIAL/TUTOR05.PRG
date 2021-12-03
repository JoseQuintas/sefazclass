#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 05 - CheckBox Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change CheckBox Value' ACTION  Win_1.Check_1.Value := .T.
             ITEM 'Retrieve CheckBox Value' ACTION  MsgInfo ( if(Win_1.Check_1.Value,'.T.','.F.'))
           END POPUP
        END MENU

            @ 100, 120 CHECKBOX Check_1 CAPTION 'Check Me!'

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

