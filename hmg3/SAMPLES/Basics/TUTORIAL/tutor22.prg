#include "hmg.ch"

Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 640 HEIGHT 450 ;
        TITLE 'Tutor 22: SplitBox Test' ;
        MAIN 

        DEFINE SPLITBOX 

            LISTBOX List_1 ;
                WIDTH 200 ;
                HEIGHT 400 ;
                ITEMS {'Item 1','Item 2','Item 3','Item 4','Item 5'} ;
                VALUE 3 ;
                TOOLTIP 'ListBox 1' 

            EDITBOX Edit_1 ;
                WIDTH 200 ;
                HEIGHT 400 ;
                VALUE 'EditBox!!' ;
                TOOLTIP 'EditBox' ;
                MAXLENGTH 255 

        END SPLITBOX

    END WINDOW

    CENTER WINDOW Win_1

    ACTIVATE WINDOW Win_1

Return Nil
