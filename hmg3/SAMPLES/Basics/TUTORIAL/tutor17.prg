#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 250 ;
        TITLE 'Tutor 17 Tab Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change Tab Value' ACTION  Win_1.Tab_1.Value := 2
             ITEM 'Retrieve Tab Value' ACTION  MsgInfo ( Str(Win_1.Tab_1.Value)) 
           END POPUP
        END MENU 

	DEFINE TAB Tab_1 ;
            AT 10,10 ;
            WIDTH 350 ;
            HEIGHT 150 

            PAGE 'Page 1'
                @ 50,50 LABEL Label_1 VALUE 'Page 1'
            END PAGE

            PAGE 'Page 2' 
                @ 50,50 LABEL Label_2 VALUE 'Page 2'
            END PAGE

        END TAB

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

