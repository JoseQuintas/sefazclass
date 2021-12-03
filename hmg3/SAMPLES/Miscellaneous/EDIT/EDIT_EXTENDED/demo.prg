#include "hmg.ch"

#define CRLF    HB_OsNewLine()



/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: Main()
 * Description: Main function of the demo. Create the main window.
 *  Parameters: None
 *      Return: NIL
****************************************************************************************/
function Main()

        // Database driver.
        REQUEST DBFNTX
        REQUEST DBFCDX, DBFFPT

        // [x]Harbour modifiers.
        SET CENTURY ON
        SET DELETED OFF
        SET DATE TO BRITISH

        // Request available languages for test.
        REQUEST HB_LANG_PT      // Portuguese.
        REQUEST HB_LANG_EU      // Basque.
        REQUEST HB_LANG_EN      // English.
        REQUEST HB_LANG_ES      // Spanish.
        REQUEST HB_LANG_FR      // French.
        REQUEST HB_LANG_IT      // Italian.
//        REQUEST HB_LANG_NL      // Dutch.
        REQUEST HB_LANG_PLWIN   // Polish Windows CP-1250
        REQUEST HB_LANG_DE      // German.


        // Set default language to English.
        HB_LANGSELECT( "EN" )

        // Define the main window.
        DEFINE WINDOW Win_1                  ;
           AT         0,0                    ;
           WIDTH      getdesktopWidth()      ;
           HEIGHT     getDeskTopHeight()-27  ;
           TITLE      "EDIT EXTENDED Demo"   ;
           MAIN                              ;
           NOMAXIMIZE                        ;
           NOSIZE                            ;
           ON INIT    OpenTable()            ;
           ON RELEASE CloseTable()           ;
           BACKCOLOR  GRAY

           DEFINE MAIN MENU OF Win_1
              POPUP "DBF&NTX Demo"
                      ITEM "&Simple EDIT EXTENDED test on DBFNTX driver"        ;
                              ACTION BasicDemo( "TEST2" )
                      ITEM "&Advanced EDIT EXTENDED test on DBFNTX driver"      ;
                              ACTION AdvancedDemo( "TEST2" )
              END POPUP
              POPUP "&DBF&CDX Demo"
                      ITEM "&Simple EDIT EXTENDED test on DBFCDX driver"        ;
                              ACTION BasicDemo( "TEST1" )
                      ITEM "&Advanced EDIT EXTENDED test on DBFCDX driver"      ;
                              ACTION AdvancedDemo( "TEST1" )
              END POPUP
              POPUP "&Language"
                      ITEM "&Select language"                                   ;
                              ACTION SelectLang()
              END POPUP
              POPUP "&Exit"
                      ITEM "About EDIT EXTENDED demo"                           ;
                              ACTION About()
                      SEPARATOR
                      ITEM "&Exit demo"                                         ;
                              ACTION Win_1.Release
              END POPUP
           END MENU

           DEFINE STATUSBAR FONT "ms sans serif" SIZE 9
               STATUSITEM "HMG EDIT EXTENDED command demo"
           END STATUSBAR

        END WINDOW

        // Open window.
        ACTIVATE WINDOW Win_1

return NIL



/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: OpenTable()
 * Description: Open the database files and check the index files.
 *  Parameters: None
 *      Return: NIL
****************************************************************************************/
procedure OpenTable()

        // Open the TEST1 database file with the DBFCDX Driver.----------------
        dbUseArea( .t., "DBFCDX", "TEST1.DBF", "TEST1" )

        // Check the existance of the index files.-----------------------------
        if !File( "TEST1.CDX" )

                // Create order by first field plus last field.
                // You can't search by this order. Only for test.
                TEST1->( ordCreate( "TEST1.CDX",                        ;
                                    "First Name",                       ;
                                    "TEST1->First + TEST1->Last",       ;
                                    {|| TEST1->First  + TEST1->Last } ) )

                // Create order by last field.
                TEST1->( ordCreate( "TEST1.CDX",                        ;
                                    "Last Name",                        ;
                                    "TEST1->Last",                      ;
                                    {|| TEST1->Last } ) )

                // Create order by hiredate field.
                TEST1->( ordCreate( "TEST1.CDX",                        ;
                                    "Hire Date",                        ;
                                    "TEST1->Hiredate",                  ;
                                    {|| TEST1->Hiredate } ) )

                // Create order by age field.
                TEST1->( ordCreate( "TEST1.CDX",                        ;
                                    "Age",                              ;
                                    "TEST1->Age",                       ;
                                    {|| TEST1->Age } ) )

                // Create order by.
                // You can't search by this order. Only for test.
                TEST1->( ordCreate( "TEST1.CDX",                        ;
                                    "Married",                          ;
                                    "TEST1->Married",                   ;
                                    {|| TEST1->Married } ) )
        endif

        // Open the index files for TEST1 workarea. ---------------------------
        TEST1->( ordListAdd( "TEST1.CDX", "First Name" ) )
        TEST1->( ordListAdd( "TEST1.CDX", "Last Name" ) )
        TEST1->( ordListAdd( "TEST1.CDX", "Hire Date" ) )
        TEST1->( ordListAdd( "TEST1.CDX", "Age" ) )
        TEST1->( ordListAdd( "TEST1.CDX", "Married" ) )
        TEST1->( ordSetFocus( 1 ) )


        // Open the TEST2 database file with the DBFNTX Driver.----------------
        dbUseArea( .t., "DBFNTX", "TEST2.DBF", "TEST2" )

        // Check the existance of the index files.-----------------------------
        if !File( "TEST2COM.NTX" )

                // Create order by first field plus last field.
                // You can't search by this order. Only for test.
                TEST2->( ordCreate( "TEST2COM.NTX",                     ;
                                    "First Name",                       ;
                                    "TEST2->First + TEST2->Last",       ;
                                    {|| TEST2->First  + TEST2->Last } ) )
        endif
        if !File( "TEST2LAS.NTX" )

                // Create order by last field.
                TEST2->( ordCreate( "TEST2LAS.NTX",                     ;
                                    "Last Name",                        ;
                                    "TEST2->Last",                      ;
                                    {|| TEST2->Last } ) )
        endif
        if !File( "TEST2HIR.NTX" )

                // Create order by hiredate field.
                TEST2->( ordCreate( "TEST2HIR.NTX",                     ;
                                    "Hire Date",                        ;
                                    "TEST2->Hiredate",                  ;
                                    {|| TEST2->Hiredate } ) )
        endif
        if !File( "TEST2AGE.NTX" )

                // Create order by age field.
                TEST2->( ordCreate( "TEST2AGE.NTX",                     ;
                                    "Age",                              ;
                                    "TEST2->Age",                       ;
                                    {|| TEST2->Age } ) )
        endif
        if !File( "TEST2MAR.NTX" )

                // Create order by.
                // You can't search by this order. Only for test.
                TEST2->( ordCreate( "TEST2MAR.NTX",                     ;
                                    "Married",                          ;
                                    "TEST2->Married",                   ;
                                    {|| TEST2->Married } ) )
        endif

        // Open the index files for TEST2 workarea. ---------------------------
        TEST2->( ordListAdd( "TEST2COM.NTX", "First Name" ) )
        TEST2->( ordListAdd( "TEST2LAS.NTX", "Last Name" ) )
        TEST2->( ordListAdd( "TEST2HIR.NTX", "Hire Date" ) )
        TEST2->( ordListAdd( "TEST2AGE.NTX", "Age" ) )
        TEST2->( ordListAdd( "TEST2MAR.NTX", "Married" ) )
        TEST2->( ordSetFocus( 1 ) )

return



/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: CloseTable()
 * Description: Closes the active databases.
 *  Parameters: None
 *      Return: NIL
****************************************************************************************/
procedure CloseTable()

        CLOSE TEST1
        CLOSE TEST2

return



/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: BasicDemo( cArea)
 * Description: Run a basic demo (without parameters) of EDIT command.
 *  Parameters: [cArea]         Character. Name of the workarea.
 *      Return: NIL
****************************************************************************************/
procedure BasicDemo( cArea )

        // Basic demo of EDIT command.
        EDIT EXTENDED WORKAREA &cArea


return



/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: AdvancedDemo( cArea )
 * Description: Runs a advanced demo of EDIT command with all parameters.
 *  Parameters: [cArea]         Character. Name of the workarea.
 *      Return: NIL
****************************************************************************************/
procedure AdvancedDemo( cArea )

        // Local variable declarations.----------------------------------------
        LOCAL aFieldName   := { "First Name", "Last Name", "Adress", "City",    ;
                                "State", "ZIP Code", "Hire date", "Married?",   ;
                                "Age", "Salary", "Notes"    }
        LOCAL aFieldAdvise := { "Enter the first name of the employee",         ;
                                "Enter the last name of the employee",          ;
                                "Enter the adress",                             ;
                                "Enter the city",                               ;
                                "Enter the State in two character mode",        ;
                                "Enter the Zip code in xxxxx-xxxx format",      ;
                                "Select the hire date",                         ;
                                "Check the box if the employee is married",     ;
                                "Enter the age",                                ;
                                "Enter the salary",                             ;
                                "Enter some notes of this employee if you want" }
        LOCAL aVisTable    := { .t., .t., .t., .t., .f., .f., .f., .f., .t., .t., .f. }
        LOCAL aFieldEdit   := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .f., .t. }
        LOCAL aOptions     := Array( 3, 2 )
        LOCAL bSave        := {|aValues, lNew| AdvancedSave( aValues, lNew, cArea ) }
        LOCAL bSearch      := {|| MsgInfo( "Your own search function" ) }
        LOCAL bPrint       := {|| MsgInfo( "Your own print function" ) }
        aOptions[1,1] := "Execute option 1"
        aOptions[1,2] := {|| MsgInfo( "You can do something here 1" ) }
        aOptions[2,1] := "Execute option 2"
        aOptions[2,2] := { || MsgInfo( "You can do something here 2" ) }
        aOptions[3,1] := "Execute option 3"
        aOptions[3,2] := { || MsgInfo( "You can do something here 3" ) }

        // Edit extended demo.-------------------------------------------------
        EDIT EXTENDED                           ;
                WORKAREA &cArea                 ;
                TITLE "Employees maintenance"   ;
                FIELDNAMES aFieldName           ;
                FIELDMESSAGES aFieldAdvise      ;
                FIELDENABLED aFieldEdit         ;
                TABLEVIEW aVisTable             ;
                OPTIONS aOptions                ;
                ON SAVE bSave                   ;
                ON FIND bSearch                 ;
                ON PRINT bPrint


return

/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: AdvancedSave( aValues, lNew )
 * Description: Checks and save the record.
 *  Parameters: [aValues]       Array. Values of the record.
 *              [lNew]          Logical. If .t. append mode, .f. edit mode.
 *      Return: lReturn         Logical. If .t. exit edit window, .f. stay in edit window.
****************************************************************************************/
function AdvancedSave( aValues, lNew, cArea )

        // Variable declaration.-----------------------------------------------
        LOCAL i := 1

        // Check for empty values.
        IF Empty( aValues[1] )   // First name.
                msgInfo( "First name can't be an empty value" )
                return ( .f. )
        ENDIF

        // Calculate the salary.
        aValues[10] := 100.5

        // Save the record.
        IF lNew
                (cArea)->( dbAppend() )
        ENDIF
        FOR i := 1 TO Len( aValues )
                (cArea)->( FieldPut( i, aValues[i] ) )
        NEXT

return ( .t. )



/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: SelectLang()
 * Description: Select the [x]Harbour default language.
 *  Parameters: None
 *      Return: NIL
****************************************************************************************/
procedure SelectLang()

        LOCAL cMessage  := ""
        LOCAL nItem     := 0
        LOCAL aLangName := { "Basque"             ,;
                             "Dutch"              ,;
                             "English"            ,;
                             "French"             ,;
                             "German"             ,;
                             "Italian"            ,;
                             "Polish"             ,;
                             "Portuguese"         ,;
                             "Spanish"             }
        LOCAL aLangID   := { "EU"    ,;
                             "NL"    ,;
                             "EN"    ,;
                             "FR"    ,;
                             "DE"    ,;
                             "IT"    ,;
                             "PLWIN" ,;
                             "PT"    ,;
                             "ES"     }

        // Language selection.
        cMessage := CRLF
        cMessage += "You can change EDIT EXTENDED interface default language, by changing   " + CRLF
        cMessage += "[x]Harbour default language with HB_LANGSELECT() fuction.   " + CRLF
        cMessage += CRLF
        cMessage += "If your language is not supported and you want translate   " + CRLF
        cMessage += "the EDIT EXTENDED interface to it, please post a message to the   " + CRLF
        cMessage += "HMG discussion group at Yahoo Groups.   " + CRLF
        MsgInfo( cMessage , "EDIT EXTENDED demo" )
        nItem := SelectItem( aLangName )
        IF .NOT. nItem == 0
                HB_LANGSELECT( aLangID[nItem] )
        ENDIF

return



/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: SelectItem( acItems )
 * Description: Select an item from an array of character items.
 *  Parameters: [acItems]       Array of character items.
 *      Return: [nItem]         Number of selected item.
****************************************************************************************/
function SelectItem( acItems )

        // Local variable declarations.----------------------------------------
        LOCAL nItem := 0

        // Create the selection window.----------------------------------------
        DEFINE WINDOW wndSelItem ;
                AT 0, 0 ;
                WIDTH 265 ;
                HEIGHT 160 ;
                TITLE "Select item" ;
                MODAL ;
                NOSIZE ;
                NOSYSMENU

                @ 20, 20 LISTBOX lbxItems ;
                        WIDTH 140 ;
                        HEIGHT 100 ;
                        ITEMS acItems ;
                        VALUE 1 ;
                        FONT "Arial" ;
                        SIZE 9

                @ 20, 170 BUTTON btnSel ;
                        CAPTION "&Select" ;
                        ACTION {|| nItem := wndSelItem.lbxItems.Value, wndSelItem.Release } ;
                        WIDTH 70 ;
                        HEIGHT 30 ;
                        FONT "ms sans serif" ;
                        SIZE 8

        END WINDOW

        // Activate the window.------------------------------------------------
        wndSelItem.lbxItems.SetFocus
        CENTER WINDOW wndSelItem
        ACTIVATE WINDOW wndSelItem

return ( nItem )



/****************************************************************************************
 * HMG EDIT EXTENDED command demo
 * (c) Roberto López [mail.box.hmg@gmail.com]
 *     Cristóbal Mollá [cemese@terra.es]
 *
 * Application: DEMO.EXE
 *    Function: About()
 * Description: Shows the about window.
 *  Parameters: None
 *      Return: NIL
****************************************************************************************/
procedure About()

        // Local variable declaration.-----------------------------------------
        LOCAL cMessage := ""

        // Shows the about window.---------------------------------------------
        cMessage := CRLF
        cMessage += "EDIT EXTENDED command for HMG   " + CRLF
        cMessage += "Last Update: January 2004    " + CRLF
        cMessage += CRLF
        cMessage += "The EDIT EXTENDED command was developed by:  " + CRLF
        cMessage += "---> Roberto López" + CRLF
        cMessage += "---> Cristóbal Mollá" + CRLF
        cMessage += CRLF
        cMessage += "Please report bugs to HMG discusion group at http://www.hmgforum.com" + CRLF
        MsgInfo( cMessage, "About EDIT EXTENDED command demo" )

RETURN NIL














