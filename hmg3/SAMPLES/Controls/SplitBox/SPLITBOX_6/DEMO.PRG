/*
 * HMG - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <mail.box.hmg@gmail.com>
 * http://www.hmgforum.com//
*/

#include "hmg.ch"

Function Main

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 HEIGHT 480 ;
		TITLE 'HMG SplitBox Demo' ;
		MAIN ;
		FONT 'Arial' SIZE 10 

		DEFINE STATUSBAR
			STATUSITEM 'HMG Power Ready - Click / Drag Grippers And Enjoy !' 
		END STATUSBAR
	
		DEFINE MAIN MENU
			POPUP '&File'
				ITEM 'Get Tree Value' ACTION MsgInfo( Str ( ( Form_1.Tree_1.Value ) ) )
				ITEM 'Set Tree Value' ACTION Form_1.Tree_1.Value := 10
			END POPUP
		END MENU

		DEFINE SPLITBOX 

			DEFINE TREE Tree_1 WIDTH 200 HEIGHT 400 VALUE 10 BREAK

				NODE 'Item 1    (1)'
					TREEITEM 'Item 1.1    (2)'
					TREEITEM 'Item 1.2    (3)'
					TREEITEM 'Item 1.3    (4)'
				END NODE

				NODE 'Item 2    (5)'
			
					TREEITEM 'Item 2.1    (6)'

					NODE 'Item 2.2    (7)'
						TREEITEM 'Item 2.2.1    ( 8)'
						TREEITEM 'Item 2.2.2    ( 9)'
						TREEITEM 'Item 2.2.3    (10)'
					END NODE

					TREEITEM 'Item 2.3    (11)'

				END NODE

			END TREE

			DEFINE GRID Grid_1
				WIDTH 200 
				HEIGHT 400 
				HEADERS {'Last Name','First Name'} 
				WIDTHS {100,100}
				ITEMS { {'Simpson','Homer'} , {'Mulder','Fox'} } 
				VALUE 1 
				TOOLTIP 'Grid Control'
                        END GRID

		END SPLITBOX

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

