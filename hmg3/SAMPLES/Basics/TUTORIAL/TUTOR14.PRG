#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 14 Image Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change Image Content' ACTION  Win_1.Image_1.Picture := 'Open.Bmp'
             ITEM 'Retrieve Image Content' ACTION  MsgInfo ( Win_1.Image_1.Picture)
           END POPUP
        END MENU 

            @ 10,10 IMAGE Image_1 ;
            PICTURE 'Demo.Bmp' ;
            WIDTH 90 ;
            HEIGHT 90

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

