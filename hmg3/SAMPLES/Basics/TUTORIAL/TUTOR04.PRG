#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 300 ;
        TITLE 'Tutor 04 TextBox Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change TextBox Content' ACTION  Win_1.Text_1.Value := 'New TextBox Value'
             ITEM 'Retrieve TextBox Content' ACTION  MsgInfo ( Win_1.Text_1.Value)
             SEPARATOR
             ITEM 'Change Numeric TextBox Content' ACTION  Win_1.Text_2.Value := 100
             ITEM 'Retrieve Numeric TextBox Content' ACTION  MsgInfo ( Str(Win_1.Text_2.Value))
             SEPARATOR
             ITEM 'Change Numeric (InputMask) TextBox Content' ACTION  Win_1.Text_3.Value := 1234.12
             ITEM 'Retrieve Numeric (InputMask) TextBox Content' ACTION  MsgInfo ( Str(Win_1.Text_3.Value))


           END POPUP
        END MENU

        @ 40 , 120 TEXTBOX Text_1
        @ 80 , 120 TEXTBOX Text_2 NUMERIC
        @ 120 , 120 TEXTBOX Text_3 NUMERIC INPUTMASK '9999.99'

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

