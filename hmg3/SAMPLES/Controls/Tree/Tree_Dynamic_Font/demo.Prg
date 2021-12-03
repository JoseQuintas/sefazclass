#include "hmg.ch"

Function main()

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 480 ;
		TITLE 'TreeView Sample' ;
		MAIN 

		DEFINE MAIN MENU
			POPUP '&File'
				ITEM 'Get Tree Value' ACTION MsgInfo( Str ( Form_1.Tree_1.Value ) ) 
				ITEM 'Set Tree Value' ACTION Form_1.Tree_1.Value := val(inputbox('',''))
				ITEM 'Collapse Item' ACTION Form_1.Tree_1.Collapse ( val(inputbox('','') ) )
				ITEM 'Expand Item' ACTION Form_1.Tree_1.Expand ( val(inputbox('','') ) )
			END POPUP
		END MENU

		DEFINE CONTEXT MENU 
			ITEM 'About'				ACTION MsgInfo ("Free GUI Library For Harbour","HMG Tree Demo") 
		END MENU

		DEFINE TREE Tree_1 AT 10,10 WIDTH 400 HEIGHT 600 VALUE 15 FONT "ARIAL" SIZE 14;
             ON DBLCLICK IF (Form_1.Tree_1.IsExpand (Form_1.Tree_1.Value) == .F. ,; 
                             Form_1.Tree_1.Expand (Form_1.Tree_1.Value) ,;
                             Form_1.Tree_1.Collapse (Form_1.Tree_1.Value) );

			NODE 'Item 1' 
				TREEITEM 'Item 1.1'
				TREEITEM 'Item 1.2' ID 999
				TREEITEM 'Item 1.3'
			END NODE

			NODE 'Item 2'

				TREEITEM 'Item 2.1'

				NODE 'Item 2.2'
					TREEITEM 'Item 2.2.1'
					TREEITEM 'Item 2.2.2'
					TREEITEM 'Item 2.2.3'
					TREEITEM 'Item 2.2.4'
					TREEITEM 'Item 2.2.5'
					TREEITEM 'Item 2.2.6'
					TREEITEM 'Item 2.2.7'
					TREEITEM 'Item 2.2.8'
				END NODE

				TREEITEM 'Item 2.3'

			END NODE

			NODE 'Item 3'
				TREEITEM 'Item 3.1'
				TREEITEM 'Item 3.2'

				NODE 'Item 3.3'
					TREEITEM 'Item 3.3.1'
					TREEITEM 'Item 3.3.2'
				END NODE

			END NODE

		END TREE


		@ 10,600 BUTTON Button_1 ;
		CAPTION 'Delete Item' ;
		ACTION Form_1.Tree_1.DeleteItem( Form_1.Tree_1.Value ) ;
		WIDTH 150

		@ 40,600 BUTTON Button_2 ;
		CAPTION 'Delete All Items' ;
		ACTION Form_1.Tree_1.DeleteAllItems ;
		WIDTH 150

		@ 70,600 BUTTON Button_3 ;
		CAPTION 'Get Item Count' ;
		ACTION MsgInfo ( Str ( Form_1.Tree_1.ItemCount ) ) ;
		WIDTH 150

		@ 100,600 BUTTON Button_4 ;
		CAPTION 'DeleteAll / Add Test' ;
		ACTION AddItemTest() ;
		WIDTH 150

		@ 130,600 BUTTON Button_5 ;
		CAPTION 'Set Value' ;
		ACTION Form_1.Tree_1.Value := 1 ;
		WIDTH 150

		@ 160,600 BUTTON Button_6 ;
		CAPTION 'Get Item' ;
		ACTION MsgInfo ( Form_1.Tree_1.Item ( Form_1.Tree_1.Value ) ) ;
		WIDTH 150

		@ 190,600 BUTTON Button_7 ;
		CAPTION 'Set Item' ;
		ACTION Form_1.Tree_1.Item( Form_1.Tree_1.Value ) := 'New Item text' ;
		WIDTH 150

      @ 250,600 BUTTON Button_8  CAPTION 'Dynamic OFF' ACTION SET_DYNAMIC (0)
      @ 300,600 BUTTON Button_9  CAPTION 'Dynamic 1'   ACTION SET_DYNAMIC (1)
      @ 350,600 BUTTON Button_10 CAPTION 'Dynamic 2'   ACTION SET_DYNAMIC (2)

      @ 450,600 BUTTON Button_11 CAPTION 'FullRow On/Off' ACTION SET_DYNAMIC (3)

	END WINDOW

   MAXIMIZE WINDOW Form_1
   
	ACTIVATE WINDOW Form_1

Return

Function AddItemTest()

	Form_1.Tree_1.DeleteAllItems

	Form_1.Tree_1.AddItem( 'New Root Item 1'   , 0 )

	Form_1.Tree_1.AddItem( 'New Item 1.1' , 1 )
	Form_1.Tree_1.AddItem( 'New Item 1.2' , 1 )
	Form_1.Tree_1.AddItem( 'New Item 1.3' , 1 )

	Form_1.Tree_1.AddItem( 'New Root Item 2'   , 0 )

	Form_1.Tree_1.AddItem( 'New Item 2.1' , 5 )
	Form_1.Tree_1.AddItem( 'New Item 2.2' , 5 )
	Form_1.Tree_1.AddItem( 'New Item 2.3' , 5 )

	Form_1.Tree_1.AddItem( 'New Item 1.4' , 1 )
	Form_1.Tree_1.AddItem( 'New Item 1.4.1' , 5 )

Return Nil


PROCEDURE SET_DYNAMIC (option)

STATIC LastOption := 0

Local aColors := { YELLOW, GREEN, BLUE, PINK, FUCHSIA, BROWN, ORANGE, PURPLE, SILVER, MAROON, OLIVE, LGREEN, AQUA, NAVY, TEAL }
Local nLen    := HMG_LEN (aColors)
Local cFontName := "Calibri" 
Local aFont   := { ARRAY FONT cFontName SIZE 12 BOLD     ,;
                   ARRAY FONT cFontName SIZE 12 ITALIC    ,;
                   ARRAY FONT cFontName SIZE 12 UNDERLINE ,;
                   ARRAY FONT cFontName SIZE 12 STRIKEOUT ,;
                   ARRAY FONT cFontName SIZE 12 }


   DO CASE
      CASE option == 0
         Form_1.Tree_1.DynamicForeColor := NIL
         Form_1.Tree_1.DynamicBackColor := NIL
         Form_1.Tree_1.DynamicFont      := NIL
         Form_1.Tree_1.HasLines         := .T.
         Form_1.Tree_1.FullRowSelect    := .F.
         Form_1.Tree_1.ChangeFontSize   := NIL   // Set default FontSize of the control 

      CASE option == 1
         Form_1.Tree_1.DynamicForeColor := {|| IF ( Form_1.Tree_1.IsTrueNode (This.TreeItemValue), BLUE, NIL) }
         Form_1.Tree_1.DynamicBackColor := {|| IF (This.TreeItemValue == Form_1.Tree_1.Value, YELLOW, NIL) }
         Form_1.Tree_1.DynamicFont      := {|| ARRAY FONT cFontName SIZE 24 BOLD }         
         Form_1.Tree_1.ChangeFontSize   := 24   // Expand FontSize of the control 

      CASE option == 2
         Form_1.Tree_1.DynamicForeColor := {|| IF (This.TreeItemValue == Form_1.Tree_1.Value, WHITE, aColors [ nLen + 1 - Form_1.Tree_1.GetDisplayLevel (This.TreeItemValue) ]) }
         Form_1.Tree_1.DynamicBackColor := {|| IF (This.TreeItemValue == Form_1.Tree_1.Value, BLACK, aColors [ Form_1.Tree_1.GetDisplayLevel (This.TreeItemValue) ]) }
         Form_1.Tree_1.DynamicFont      := {|| aFont [ Form_1.Tree_1.GetDisplayLevel (This.TreeItemValue) ] }
         Form_1.Tree_1.ChangeFontSize   := NIL   // Set default FontSize of the control 

      CASE option == 3 .AND. LastOption <> 0
         Form_1.Tree_1.FullRowSelect := .NOT. Form_1.Tree_1.FullRowSelect 
         Form_1.Tree_1.HasLines := .NOT. Form_1.Tree_1.HasLines
   ENDCASE
   
   IF option <> 3
      LastOption := option
   ENDIF
   
   Form_1.Tree_1.Redraw
   Form_1.Tree_1.SetFocus
RETURN
