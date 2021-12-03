#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 10 - Picture Button Test' ;
        MAIN 

            @ 10,10 BUTTON PictureButton_1 ;
                PICTURE 'button.bmp' ;
                ACTION MsgInfo('Picture Button Clicked!!') ;
                WIDTH 27 ;
                HEIGHT 27 ;
                TOOLTIP 'Picture Button Tooltip' 

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

