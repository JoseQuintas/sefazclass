#include "hmg.ch"

Function Main

OpenTables()

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 640 HEIGHT 480 ;
        TITLE 'Tutor 20: GRID Test' ;
        MAIN NOMAXIMIZE 

        DEFINE MAIN MENU 
            POPUP 'File'
                ITEM 'Set Grid RecNo' ACTION Win_1.Grid_1.Value := Val ( InputBox ('Set Grid RecNo','') )
                ITEM 'Get Grid RecNo' ACTION MsgInfo ( Str ( Win_1.Grid_1.RecNo ) )
                SEPARATOR
                ITEM 'Exit' ACTION Win_1.Release
            END POPUP
            POPUP 'Help'
                ITEM 'About' ACTION MsgInfo ("Tutor 20: GRID Test") 
            END POPUP
        END MENU

        @ 10,10 GRID Grid_1 ;
            WIDTH 610 ;
            HEIGHT 390 ; 
            HEADERS { 'Code' , 'First Name' , 'Last Name', 'Birth Date', 'Married' , 'Biography' } ;
            WIDTHS { 150 , 150 , 150 , 150 , 150 , 150 } ;
            ROWSOURCE "Test" ;
            COLUMNFIELDS { 'Code' , 'First' , 'Last' , 'Birth' , 'Married' , 'Bio' } ;
            COLUMNCONTROLS {{'TEXTBOX','NUMERIC','999'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','CHARACTER'},{'TEXTBOX','DATE'},{'CHECKBOX'},{'TEXTBOX','CHARACTER'}};
            ALLOWDELETE ;
            EDIT

    END WINDOW

    CENTER WINDOW Win_1

    ACTIVATE WINDOW Win_1

Return Nil

Procedure OpenTables()
    Use Test
//    Win_1.Grid_1.RecNo := RecNo() 
Return Nil

