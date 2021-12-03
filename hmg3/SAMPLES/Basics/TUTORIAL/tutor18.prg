#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 640 HEIGHT 480 ;
        TITLE 'Tutor 18: ToolBar Test' ;
        MAIN ;
        FONT 'Arial' SIZE 10 

        DEFINE MAIN MENU 
            POPUP '&File'
                ITEM '&Disable ToolBar Button' ACTION Win_1.Button_1.Enabled := .F.
                ITEM '&Enable ToolBar Button' ACTION Win_1.Button_1.Enabled := .T.
                ITEM '&Exit' ACTION Win_1.Release
            END POPUP
        END MENU

        DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 80,80 FLAT BORDER

            BUTTON Button_1 ;
                CAPTION '&Button &1' ;
                PICTURE 'button1.bmp' ;
                ACTION MsgInfo('Click! 1')

            BUTTON Button_2 ;
                CAPTION '&Button 2' ;
                PICTURE 'button2.bmp' ;
                ACTION MsgInfo('Click! 2') ;
                SEPARATOR

            BUTTON Button_3 ;
                CAPTION 'Button &3' ;
                PICTURE 'button3.bmp' ;
                ACTION MsgInfo('Click! 3')

        END TOOLBAR

    END WINDOW

    CENTER WINDOW Win_1

    ACTIVATE WINDOW Win_1

Return Nil

