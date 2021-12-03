#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 02 - Property Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change Window Title' ACTION  Win_1.Title := 'New Title'
             ITEM 'Retrieve Window Title' ACTION  MsgInfo ( Win_1.Title )
           END POPUP
        END MENU

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

