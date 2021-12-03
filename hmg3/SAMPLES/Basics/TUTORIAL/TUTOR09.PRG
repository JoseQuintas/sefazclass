#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 09 - Button Test' ;
        MAIN 

        @ 10,10 BUTTON Button_1 ;
            CAPTION 'Click Here!' ;
                    ACTION MsgInfo('Button Clicked!') 

    END WINDOW

    ACTIVATE WINDOW Win_1

Return


