
// by Andrés González López, September 2014

#include "hmg.ch"

FUNCTION Main()

   DEFINE WINDOW Form_1; 
      AT 0,0; 
      WIDTH 800; 
      HEIGHT 600; 
      NOSIZE; 
      NOMAXIMIZE;
      ON GOTFOCUS Form_1.Tree_1.SetFocus;
      MAIN
      
      ON KEY F1  OF Form_1 ACTION OnKeyFx (  2 )
      ON KEY F2  OF Form_1 ACTION OnKeyFx (  5 )
      ON KEY F3  OF Form_1 ACTION OnKeyFx (  8 )
      ON KEY F4  OF Form_1 ACTION OnKeyFx ( 12 )
      ON KEY F5  OF Form_1 ACTION OnKeyFx ( 22 )

      ON KEY F9  OF Form_1 ACTION ( Form_1.Tree_1.Value:= 1,;
                                    IF ( Form_1.Tree_1.IsExpand (Form_1.Tree_1.Value) == .T.,; 
                                         Form_1.Tree_1.Collapse (Form_1.Tree_1.Value, .T.),;   // Collapse All
                                         Form_1.Tree_1.Expand   (Form_1.Tree_1.Value, .T.)))   // Expand All

      DEFINE TREE Tree_1;
         AT 10,10; 
         WIDTH 250; 
         HEIGHT 550; 
         VALUE 1; 
         FONT "Calibri" SIZE 11; 
         ON CHANGE OnChangeTree (This.Value);
         NODEIMAGES { "folder.gif", "folder_page.gif" }; 
         ITEMIMAGES { "Page.gif",   "page_next.gif"   }; 
         NOROOTBUTTON 
         
         NODE 'MY APP '
            
            NODE 'BOOK      [F1]'
               TREEITEM 'Science'
               TREEITEM 'Literature' 
            END NODE
            
            NODE 'MUSIC     [F2]'
               TREEITEM 'Rock' 
               TREEITEM 'Classic'
            END NODE
            
            NODE 'VIDEOS    [F3]'
               TREEITEM 'Documentary' 
               TREEITEM 'Series'
               TREEITEM 'Sports'
            END NODE
            
            NODE 'EMAIL     [F4]'
               TREEITEM 'Send' 
               TREEITEM 'Inbox' 
               TREEITEM 'Outbox' 
               TREEITEM 'Drafts'
               TREEITEM 'Spam'
               TREEITEM 'Sent Items'
               NODE 'OTHER'
                  TREEITEM 'Backup'
                  TREEITEM 'Calendar'
               END NODE
            END NODE
            
            NODE 'ABOUT...  [F5]'
            END NODE
            
         END NODE
      END TREE

   Form_1.Tree_1.Expand (1)
   Form_1.Tree_1.NodeFlag (22) := .T.
   Form_1.Tree_1.FontSize := 12 // The control must have a size greater than or equal to font size of DynamicFont so that the text does not appear cut
   Form_1.Tree_1.DynamicFont      := {|| TreeFont() }
   Form_1.Tree_1.DynamicBackColor := {|| IF (This.TreeItemValue == Form_1.Tree_1.Value, WHITE, NIL ) }
   Form_1.Tree_1.DynamicForeColor := {|| IF (This.TreeItemValue == Form_1.Tree_1.Value, BLUE,  NIL ) }

   END WINDOW

   CENTER WINDOW Form_1
   ACTIVATE WINDOW Form_1
   
Return nil



Function TreeFont
LOCAL aFont
   IF Form_1.Tree_1.NodeFlag (This.TreeItemValue) == .T.   // for default: True Node always has the NodeFlag() == .T.
      aFont := ARRAY FONT "Calibri" SIZE 12 BOLD
   ELSE
      aFont := ARRAY FONT "Calibri" SIZE 11
   ENDIF
Return aFont



FUNCTION OnKeyFx ( nItem )
   OnChangeTree( nItem )
   Form_1.Tree_1.Value:= nItem
   IF Form_1.Tree_1.IsExpand( Form_1.Tree_1.Value )
      Form_1.Tree_1.Collapse( Form_1.Tree_1.Value )
   ELSE   
      Form_1.Tree_1.Expand( Form_1.Tree_1.Value )
   ENDIF
RETURN nil


FUNCTION OnChangeTree ( nItem )
   DO CASE
      CASE nItem = 1
      CASE nItem = 2
      CASE nItem = 3
      //  CASE nOption 4 to 22  ....
   ENDCASE
   Form_1.TITLE := "#"+HB_NTOS (nItem) + " --> " + HB_VALTOEXP ( Form_1.Tree_1.GetPathName (nItem) )
RETURN nil

