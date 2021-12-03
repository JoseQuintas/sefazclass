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
				ITEM 'Set Tree Value' ACTION Form_1.Tree_1.Value := Val ( InputBox ('','') )
				ITEM 'Collapse Item' ACTION Form_1.Tree_1.Collapse ( val(inputbox('','') ) )
				ITEM 'Expand Item' ACTION Form_1.Tree_1.Expand ( val(inputbox('','') ) )
			END POPUP
		END MENU

		DEFINE CONTEXT MENU 
			ITEM 'About'				ACTION MsgInfo ("Free GUI Library For Harbour","HMG Tree Demo") 
		END MENU

		DEFINE TREE Tree_1 AT 10,30 WIDTH 200 HEIGHT 400 ITEMIDS

			NODE 'Item 1' ID 10
				TREEITEM 'Item 1.1' ID 11
				TREEITEM 'Item 1.2' ID 12
				TREEITEM 'Item 1.3' ID 13
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

	Form_1.Tree_1.AddItem( 'Root' , 0 , 100 )

	Form_1.Tree_1.AddItem( 'Glennon Farm' , 100 , 111 )

	Form_1.Tree_1.AddItem( 'North 80' , 111 , 222 )

	Form_1.Tree_1.AddItem( 'farm 1' , 222 , 2221 )

	Form_1.Tree_1.AddItem( 'farm 11' , 0 , 3331 )

Return Nil

