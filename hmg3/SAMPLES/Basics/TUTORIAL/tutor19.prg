#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 19 Tab Test' ;
        MAIN

        DEFINE MAIN MENU 
            POPUP '&StatusBar Test'
                ITEM 'Set Status Item 1' ACTION Win_1.StatusBar.Item(1) := "New value 1"
                ITEM 'Set Status Item 2' ACTION Win_1.StatusBar.Item(2) := "New value 2"
            END POPUP
        END MENU

	DEFINE STATUSBAR 
            STATUSITEM "Item 1" ACTION MsgInfo('Click! 1') 
            STATUSITEM "Item 2" WIDTH 100 ACTION MsgInfo('Click! 2')
            CLOCK 
            DATE 
            STATUSITEM "Item 5" WIDTH 100
        END STATUSBAR

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

