#include "hmg.ch"
Function Main

    DEFINE WINDOW Win_1 ;
        AT 0,0 ;
        WIDTH 640 ;
        HEIGHT 480 ;
        TITLE 'Tutor 21: Data-Bound Controls Test' ;
        MAIN ;
        ON INIT OpenTables() ;
        ON RELEASE CloseTables()

        DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 100,30 FLAT RIGHTTEXT BORDER

            BUTTON TOP ;
                CAPTION '&Top' ;
                PICTURE 'primero.bmp' ;
                ACTION ( DbGoTop() , Refresh() )

            BUTTON PREVIOUS ;
                CAPTION '&Previous';
                PICTURE 'anterior.bmp' ;
                ACTION ( DbSkip(-1) , Refresh() )

            BUTTON NEXT ;
                CAPTION '&Next';
                PICTURE 'siguiente.bmp' ;
                ACTION ( DbSkip(1) , if ( eof() , DbGoBottom() , Nil ) , Refresh() )

            BUTTON BOTTOM ;
                CAPTION '&Bottom' ;
                PICTURE 'ultimo.bmp' ;
                ACTION ( DbGoBottom() , Refresh() )

            BUTTON SAVE ;
                CAPTION '&Save' ;
                PICTURE 'guardar.bmp' ;
                ACTION ( Save() , Refresh() )

            BUTTON UNDO ;
                CAPTION '&Undo' ;
                PICTURE 'deshacer.bmp' ;
                ACTION ( Refresh() )

        END TOOLBAR

        @ 50,10 LABEL LABEL_1 VALUE 'Code:'
        @ 80,10 LABEL LABEL_2 VALUE 'First Name'
        @ 110,10 LABEL LABEL_3 VALUE 'Last Name'
        @ 140,10 LABEL LABEL_4 VALUE 'Birth Date:'
        @ 170,10 LABEL LABEL_5 VALUE 'Married:'
        @ 200,10 LABEL LABEL_6 VALUE 'Bio:'

        @ 50,200 TEXTBOX TEXT_1;
            FIELD TEST->CODE ;
            NUMERIC ;
            MAXLENGTH 10

        @ 80,200 TEXTBOX TEXT_2;
	    WIDTH 150 ;	
            FIELD TEST->FIRST ;
            MAXLENGTH 30

        @ 110,200 TEXTBOX TEXT_3;
	    WIDTH 150 ;	
            FIELD TEST->LAST ;
            MAXLENGTH 30

        @ 140,200 DATEPICKER DATE_4 ;
            FIELD Test->Birth

        @ 170,200 CHECKBOX CHECK_5 ;
            CAPTION '' ;
            FIELD Test->Married 

        @ 200,200 EDITBOX EDIT_6 ;
            FIELD Test->Bio ;
            HEIGHT 100

    END WINDOW

    Win_1.Text_1.SetFocus

    ACTIVATE WINDOW Win_1

Return Nil

Procedure Refresh

    Win_1.Text_1.Refresh
    Win_1.Text_2.Refresh
    Win_1.Text_3.Refresh
    Win_1.Date_4.Refresh
    Win_1.Check_5.Refresh
    Win_1.Edit_6.Refresh
    Win_1.Text_1.SetFocus

Return

Procedure Save

    Win_1.Text_1.Save
    Win_1.Text_2.Save
    Win_1.Text_3.Save
    Win_1.Date_4.Save
    Win_1.Check_5.Save
    Win_1.Edit_6.Save

Return

Procedure OpenTables 
    USE TEST
Return

Procedure CloseTables
    USE
Return
