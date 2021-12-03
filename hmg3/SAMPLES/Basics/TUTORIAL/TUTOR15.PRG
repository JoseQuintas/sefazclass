#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 15 Progressbar Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'ProgressBar Test' ACTION  DoTest()
           END POPUP
        END MENU 

        @ 10,10 PROGRESSBAR Progress_1 ;
            RANGE 0 , 65535

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

Procedure DoTest()
Local i

    For i = 0 To 65535 Step 25
        Win_1.Progress_1.Value := i
    Next i

Return

