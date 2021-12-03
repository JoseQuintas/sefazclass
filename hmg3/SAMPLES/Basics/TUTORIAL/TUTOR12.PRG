#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 12 - DatePicker Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change DatePicker Value' ACTION  Win_1.date_1.Value := Date()
             ITEM 'Retrieve DatePicker Value' ACTION  MsgInfo ( dtoc(Win_1.Date_1.Value))
           END POPUP
        END MENU

        @ 10,10 DATEPICKER Date_1

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

