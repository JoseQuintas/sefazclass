#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 11 - CheckButton Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change Text CheckButton Value' ACTION  Win_1.CheckButton_1.Value := .T.
             ITEM 'Retrieve Text CheckButton Value' ACTION  MsgInfo ( if(Win_1.CheckButton_1.Value,'.T.','.F.'))
             SEPARATOR
             ITEM 'Change Picture CheckButton Value' ACTION  Win_1.CheckButton_2.Value := .T.
             ITEM 'Retrieve Picture CheckButton Value' ACTION  MsgInfo ( if(Win_1.CheckButton_2.Value,'.T.','.F.')) 
           END POPUP
        END MENU

            @ 10,10 CHECKBUTTON CheckButton_1 ;
                CAPTION 'CheckButton' ;
                VALUE .F. 

            @ 50,10 CHECKBUTTON CheckButton_2 ;
                PICTURE 'Open.Bmp' ;
                WIDTH 27 ; 
                HEIGHT 27 ;
                VALUE .F. ;
                TOOLTIP 'Graphical CheckButton' 

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

