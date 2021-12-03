#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 08 - ComboBox Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change ComboBox Value' ACTION  Win_1.Combo_1.Value := 2
             ITEM 'Retrieve ComboBox Value' ACTION  MsgInfo ( Str(Win_1.Combo_1.Value))
             SEPARATOR
             ITEM 'Add Combo Item' ACTION Win_1.Combo_1.AddItem ('New List Item')
             ITEM 'Remove Combo Item' ACTION Win_1.Combo_1.DeleteItem (2)
             ITEM 'Change Combo Item' ACTION Win_1.Combo_1.Item (1) := 'New Item Text'
             ITEM 'Get Combo Item Count' ACTION MsgInfo (Str(Win_1.Combo_1.ItemCount))
           END POPUP
        END MENU

            @ 10, 10 COMBOBOX Combo_1 ITEMS {'Option 1','Option 2','Option 3'}

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

