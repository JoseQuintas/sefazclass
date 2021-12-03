#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 400 ;
        HEIGHT 200 ;
        TITLE 'Tutor 07 - ListBox Test' ;
        MAIN 

        DEFINE MAIN MENU
           POPUP "First Popup"
             ITEM 'Change ListBox Value' ACTION  Win_1.List_1.Value := 2
             ITEM 'Retrieve ListBox Value' ACTION  MsgInfo ( Str(Win_1.List_1.Value))
             SEPARATOR
             ITEM 'Add List Item' ACTION Win_1.List_1.AddItem ('New List Item')
             ITEM 'Remove List Item' ACTION Win_1.List_1.DeleteItem (2)
             ITEM 'Change List Item' ACTION Win_1.List_1.Item (1) := 'New Item Text'
             ITEM 'Get List Item Count' ACTION MsgInfo (Str(Win_1.List_1.ItemCount))
           END POPUP
        END MENU

            @ 10, 10 LISTBOX List_1 ITEMS {'Option 1','Option 2','Option 3'}

    END WINDOW

    ACTIVATE WINDOW Win_1

Return

