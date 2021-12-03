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

		DEFINE TREE Tree_1 AT 10,10 WIDTH 200 HEIGHT 400 VALUE 15

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

		@ 10,400 BUTTON Button_1 ;
		CAPTION 'Delete Item' ;
		ACTION Form_1.Tree_1.DeleteItem( Form_1.Tree_1.Value ) ;
		WIDTH 150

		@ 40,400 BUTTON Button_2 ;
		CAPTION 'Delete All Items' ;
		ACTION Form_1.Tree_1.DeleteAllItems ;
		WIDTH 150

		@ 70,400 BUTTON Button_3 ;
		CAPTION 'Get Item Count' ;
		ACTION MsgInfo ( Str ( Form_1.Tree_1.ItemCount ) ) ;
		WIDTH 150

		@ 100,400 BUTTON Button_4 ;
		CAPTION 'DeleteAll / Add Test' ;
		ACTION AddItemTest() ;
		WIDTH 150

		@ 130,400 BUTTON Button_5 ;
		CAPTION 'Set Value' ;
		ACTION Form_1.Tree_1.Value := 1 ;
		WIDTH 150

		@ 160,400 BUTTON Button_6 ;
		CAPTION 'Get Item' ;
		ACTION MsgInfo ( Form_1.Tree_1.Item ( Form_1.Tree_1.Value ) ) ;
		WIDTH 150

		@ 190,400 BUTTON Button_7 ;
		CAPTION 'Set Item' ;
		ACTION Form_1.Tree_1.Item( Form_1.Tree_1.Value ) := 'New Item text' ;
		WIDTH 150

	END WINDOW

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

