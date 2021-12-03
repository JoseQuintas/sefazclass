#include "hmg.ch"

function Main()

        // Database driver.
	REQUEST DBFCDX , DBFFPT

        // [x]Harbour modifiers.
	SET CENTURY ON
	SET DELETED OFF
        SET DATE TO BRITISH

        // Request all languages for test.
        REQUEST HB_LANG_ES
        REQUEST HB_LANG_EU
        REQUEST HB_LANG_CS852
        REQUEST HB_LANG_CSISO
        REQUEST HB_LANG_CSKAM
        REQUEST HB_LANG_CA
        REQUEST HB_LANG_EN
        REQUEST HB_LANG_FR
        REQUEST HB_LANG_GL
        REQUEST HB_LANG_DE
        REQUEST HB_LANG_HE862
        REQUEST HB_LANG_HEWIN
        REQUEST HB_LANG_HU852
//        REQUEST HB_LANG_HUCWI
        REQUEST HB_LANG_HUWIN
        REQUEST HB_LANG_IT
        REQUEST HB_LANG_PL852
        REQUEST HB_LANG_PLISO
        REQUEST HB_LANG_PLMAZ
        REQUEST HB_LANG_PT
        REQUEST HB_LANG_RO
        REQUEST HB_LANG_RUWIN
        REQUEST HB_LANG_SRISO
        REQUEST HB_LANG_SR852
        REQUEST HB_LANG_ES

        // Set default language to English.
        HB_LANGSELECT( "EN" )

        // Define window.
	DEFINE WINDOW Win_1			;
	        AT        0,0 			;
	        WIDTH     640 			;
        	HEIGHT    480 			;
	        TITLE     "EDIT Command Demo" 	;
        	MAIN 				;
		ON INIT OpenTable() 		;
		ON RELEASE CloseTable() 	;
		BACKCOLOR GRAY

		DEFINE MAIN MENU OF Win_1
        		POPUP "&File"
                		ITEM "&Simple Edit test"   ACTION EDIT WORKAREA CLIENTES
                                ITEM "&Advanced Edit test" ACTION AdvTest()
				SEPARATOR
                                ITEM "Language selection"  ACTION SelecLang()
                                SEPARATOR
                                ITEM "About"               ACTION About()
                                SEPARATOR
        	        	ITEM "E&xit"               ACTION Win_1.Release
		        END POPUP
		END MENU

	END WINDOW

        // Open window.
	MAXIMIZE WINDOW Win_1
	ACTIVATE WINDOW Win_1

Return Nil



/*-----------------------------------------------------------------------------*/
Procedure OpenTable()

	USE CLIENTES VIA "DBFCDX" INDEX CLIENTES NEW

Return Nil



/*-----------------------------------------------------------------------------*/
Procedure CloseTable()

        CLOSE CLIENTES

Return Nil



/*-----------------------------------------------------------------------------*/
Procedure AdvTest()

        LOCAL aFields   := { "Nombre", "Apellidos", "Dirección", "Población " ,;
                             "Estado", "Codigo ZIP", "F. Nacimiento", "Casado",;
                             "Edad", "Salario", "Notas"    }
        LOCAL aReadOnly := { .f., .f., .f., .f., .f., .f., .f., .f., .t., .f., .f. }
        LOCAL bSave     := {|aContent, lEdit| AdvTestSave( aContent, lEdit ) }

        // Advise.
        MsgInfo( "This sample show advanced features of EDIT." + Chr(13) + Chr(13) +;
                 "It's designed for Spanish language, so changing to" + Chr(13) + ;
                 "Spanish language for better performance", "" )
        HB_LANGSELECT( "ES" )

        // Advanced EDIT.
        EDIT WORKAREA    CLIENTES ;
                TITLE    "Clientes" ;
                FIELDS   aFields ;
                READONLY aReadOnly ;
                SAVE     bSave

Return Nil



/*-----------------------------------------------------------------------------*/
Procedure AdvTestSave( aContent, lEdit )

        LOCAL i
        LOCAL aFields  := { "Nombre", "Apellidos", "Dirección", "Población " ,;
                            "Estado", "Codigo ZIP", "F. Nacimiento", "Casado",;
                            "Edad", "Salario", "Notas"    }

        // Chek content.
        FOR i := 1 TO Len( aContent )-4
                IF Empty( aContent[i] )
                        MsgInfo( aFields[i] + " no puede estar vacio" )
                        Return .f.
                ENDIF
        NEXT

        // Calculate age.
        aContent[9] := 0
        FOR i := ( Year( aContent[7] ) + 1 ) to Year( Date() )
                aContent[9] += 1
        NEXT

        // Save record.
        IF .NOT. lEdit
                CLIENTES->( dbAppend() )
        ENDIF
        FOR i := 1 TO Len( aContent )
                CLIENTES->( FieldPut( i, aContent[i] ) )
        NEXT

Return .t.



/*-----------------------------------------------------------------------------*/
Procedure SelecLang()

        LOCAL aLangName := { "Basque"             ,;
                             "Czech 852"          ,;
                             "Czech ISO-8859-2"   ,;
                             "Czech KAM"          ,;
                             "Catalan"            ,;
                             "English"            ,;
                             "French"             ,;
                             "Galician"           ,;
                             "German"             ,;
                             "Hebrew 862"         ,;
                             "Hebrew 1255"        ,;
                             "Hungarian 852"      ,;
                             "Hungarian CWI-2"    ,;
                             "Hungarian WINDOWS-1",;
                             "Italian"            ,;
                             "Polish 852"         ,;
                             "Polish ISO-8859-1"  ,;
                             "Polish Mozowia"     ,;
                             "Portuguese"         ,;
                             "Romanian"           ,;
                             "Russian WINDOWS-1"  ,;
                             "Serbian ISO-8859-2" ,;
                             "Serbian 852"        ,;
                             "Spanish"             }

        LOCAL aLangID   := { "EU"    ,;
                             "CS852" ,;
                             "CSISO" ,;
                             "CSKAM" ,;
                             "CA"    ,;
                             "EN"    ,;
                             "FR"    ,;
                             "GL"    ,;
                             "DE"    ,;
                             "HE862" ,;
                             "HEWIN" ,;
                             "HU852" ,;
                             "HUCWI" ,;
                             "HUWIN" ,;
                             "IT"    ,;
                             "PL852" ,;
                             "PLISO" ,;
                             "PLMAZ" ,;
                             "PT"    ,;
                             "RO"    ,;
                             "RUWIN" ,;
                             "SRISO" ,;
                             "SR852" ,;
                             "ES"     }

        LOCAL nItem

        // Language selection.
        MsgInfo( "You can change EDIT interface language, by changing" + Chr(13) + ;
                 "[x]Harbour default language with HB_LANGSELECT() fuction." + Chr( 13 ) + Chr( 13 ) +;
                 "If your language is not supported and you want translate" + Chr( 13 ) + ;
                 "the EDIT interface to it, please post a message to the" + Chr( 13 ) + ;
                 "HMG discussion group at Yahoo Groups." , "" )
        nItem := SelItem( aLangName )
        IF .NOT. nItem == 0
                HB_LANGSELECT( aLangID[nItem] )
        ENDIF

return ( nil )



/*-----------------------------------------------------------------------------*/
Procedure SelItem( aItems )

        LOCAL nItem := 0

        DEFINE WINDOW wndSelItem ;
                AT 0, 0 ;
                WIDTH 265 ;
                HEIGHT 160 ;
                TITLE "" ;
                MODAL ;
                NOSIZE ;
                NOSYSMENU

                @ 20, 20 LISTBOX lbxItems ;
                        WIDTH 140 ;
                        HEIGHT 100 ;
                        ITEMS aItems ;
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

        wndSelItem.lbxItems.SetFocus

        CENTER WINDOW wndSelItem
        ACTIVATE WINDOW wndSelItem

return ( nItem )


/*-----------------------------------------------------------------------------*/
Procedure About()

        MsgInfo( Chr( 13 ) + ;
                 "EDIT command for HMG" + Chr( 13 ) + ;
                 "(c) Roberto López" + Chr( 13 ) + Chr( 13 ) + ;
                 "The EDIT command was developed by:" + Chr( 13 ) + ;
                 " *  Roberto López" + Chr( 13 ) + ;
                 " *  Grigory Filiatov" + Chr( 13 ) + ;
                 " *  Cristóbal Mollá" + Chr( 13 ) + Chr( 13 ) + ;
                 "Status of the language support:" + Chr( 13 ) + ;
                 " *  English    - Ready" + Chr( 13 ) + ;
                 " *  Spanish    - Ready" + Chr( 13 ) + ;
                 " *  Russian    - Ready (Thanks to Grigory Filiatov)" + Chr( 13 ) + ;
                 " *  Catalan    - Implemented but not tested (somebody can do it?)" + Chr( 13 ) + ;
                 " *  Portuguese - Ready (Thanks to Clovis Nogueira Jr.)" + Chr( 13 ) + ;
                 " *  Polish     - Ready (Thanks to Janusz Poura)" + Chr( 13 ) + ;
		 " *  French     - Ready (Thanks to C. Jouniauxdiv)" + Chr( 13 ) + ;
		 " *  Italian    - Ready (Thanks to Lupano Piero)" + Chr( 13 ) + ;
                 " *  German     - Ready (Thanks to Janusz Poura)" + Chr( 13 ) + Chr( 13 ) + ;
		 "Please report bugs to HMG discusion group at groups.yahoo.com" )
return ( nil )
