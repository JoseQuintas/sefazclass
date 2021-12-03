#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 300 ;
        TITLE 'Tutor 13 EditBox Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change EditBox Content' ACTION  Win_1.Edit_1.Value := 'New EditBox Value'
             ITEM 'Retrieve EditBox Content' ACTION  MsgInfo ( Win_1.Edit_1.Value)
           END POPUP
        END MENU 

        @ 10,10 EDITBOX Edit_1 ;
            WIDTH 300 ;
            HEIGHT 150 

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

