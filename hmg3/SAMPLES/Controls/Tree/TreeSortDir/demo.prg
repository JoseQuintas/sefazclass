
// Demo of the new features of the TREE control
// by Dr. Claudio Soto (November 2013)

#include "directry.ch"
#include "hmg.ch"


PROCEDURE Main

#define _ID_INI_  0
PUBLIC nItemID := NIL

   SET FONT TO "Tahoma", 9

   DEFINE WINDOW Form_1; 
      AT 0 , 0; 
      WIDTH 560 HEIGHT 600; 
      TITLE "Sort Tree Directory";
      MAIN; 
      NOMAXIMIZE; 
      NOSIZE

      DEFINE STATUSBAR
         STATUSITEM ""
      END STATUSBAR

      @ 5,5 FRAME Frame_1  WIDTH 540  HEIGHT 90

      @ 25, 15 LABEL Label_1 VALUE "Source"
      @ 20, 70 TEXTBOX TextBoxPATH  WIDTH 465  HEIGHT 24  VALUE GetMyDocumentsFolder()

      @ 65, 15 LABEL Label_2 VALUE "File mask"
      @ 60, 70 TEXTBOX Text_1  WIDTH 120  HEIGHT 24  VALUE "*.*"

      @ 60, 210 CHECKBOX Check_1 CAPTION "Include hidden folders and files"  WIDTH 190  HEIGHT 24  VALUE .T.
     
      @ 60, 435 BUTTON ButtonScan  CAPTION "Scan" ACTION  BuildTree()

      DEFINE TREE Tree_1; 
             AT 110, 5; 
             WIDTH 540; 
             HEIGHT 255;      
             NODEIMAGES { "folder.bmp" } ;
             ITEMIMAGES { "documents.bmp" };
             ON DBLCLICK MsgInfo ({" Value          = ",Form_1.Tree_1.Value, HB_OsNewLine(),;
                                   " Item           = ",Form_1.Tree_1.Item (Form_1.Tree_1.Value), HB_OsNewLine(),;
                                   " IsTrueNode     = ",Form_1.Tree_1.IsTrueNode (Form_1.Tree_1.Value), HB_OsNewLine(),; 
                                   " FlagNode       = ",Form_1.Tree_1.NodeFlag (Form_1.Tree_1.Value), HB_OsNewLine(),; 
                                   " ImageIndex     = ",HB_VALTOEXP(Form_1.Tree_1.ImageIndex (Form_1.Tree_1.Value)), HB_OsNewLine(),;
                                   " RootValue      = ",Form_1.Tree_1.RootValue, HB_OsNewLine(),;
                                   " FirstItemValue = ",Form_1.Tree_1.FirstItemValue, HB_OsNewLine(),;
                                   " ParentValue    = ",Form_1.Tree_1.ParentValue(Form_1.Tree_1.Value), HB_OsNewLine(), HB_OsNewLine(),;
                                   " ChildValues    = ",HB_VALTOEXP(Form_1.Tree_1.ChildValue (Form_1.Tree_1.Value)), HB_OsNewLine(), HB_OsNewLine(),;
                                   " ChildText      = ",HB_VALTOEXP(Form_1.Tree_1.ItemText(Form_1.Tree_1.ChildValue (Form_1.Tree_1.Value))), HB_OsNewLine(), HB_OsNewLine(),;
                                   " SiblingValues  = ",HB_VALTOEXP(Form_1.Tree_1.SiblingValue (Form_1.Tree_1.Value)), HB_OsNewLine(), HB_OsNewLine(),;
                                   " SiblingText    = ",HB_VALTOEXP(Form_1.Tree_1.ItemText(Form_1.Tree_1.SiblingValue (Form_1.Tree_1.Value)))});
             ITEMIDS
      END TREE

      Form_1.Tree_1.TextColor := RED
      Form_1.Tree_1.BackColor := WHITE
      Form_1.Tree_1.LineColor := NAVY


      @ 380, 5 FRAME FrameSort CAPTION "Sort Options" WIDTH  540 HEIGHT 100

      @ 400, 30 CHECKBOX CheckSort1 CAPTION "Recuesive(Sub-folders)" WIDTH 150 VALUE .T.
      @ 425, 30 CHECKBOX CheckSort2 CAPTION "CaseSensitive"          WIDTH 150 VALUE .F.
      @ 450, 30 CHECKBOX CheckSort3 CAPTION "Ascending Order"        WIDTH 150 VALUE .T.
      
      @ 400, 250 RADIOGROUP RadioGroupSort OPTIONS {"Nodes First","Nodes Last","Nodes Mix"} VALUE 3 TRANSPARENT 

      @ 425, 435 BUTTON ButtonSort  CAPTION "Sort"  ACTION Proc_Sort ()

      @ 520,  50 CHECKBOX CheckExpand CAPTION "Expand/Collapse Recursive (Sub-folders)"  WIDTH 240  HEIGHT 24  VALUE .T.

      @ 490,  50 BUTTON ButtonExpand    CAPTION "Expand"    ACTION  Proc_Expand ()
      @ 490, 175 BUTTON ButtonCollapse  CAPTION "Collapse"  ACTION  Form_1.Tree_1.Collapse ( Form_1.Tree_1.Value , Form_1.CheckExpand.Value )

      @ 490, 400 BUTTON ButtonUpdateFlags CAPTION "Update Images" ACTION  Proc_UpdateFlags()
      
   END WINDOW
  
   CENTER WINDOW Form_1
   ACTIVATE WINDOW Form_1

RETURN


*********************************************************
PROCEDURE EnableButtons ( lEnabled )
*********************************************************
   Form_1.ButtonScan.Enabled        := lEnabled
   Form_1.ButtonSort.Enabled        := lEnabled
   Form_1.ButtonExpand.Enabled      := lEnabled
   Form_1.ButtonCollapse.Enabled    := lEnabled
   Form_1.ButtonUpdateFlags.Enabled := lEnabled
RETURN


*********************************************************
PROCEDURE Proc_Sort
*********************************************************
LOCAL aNodePosition := { TREESORTNODE_FIRST, TREESORTNODE_LAST, TREESORTNODE_MIX }   // Constants defined in file: \include\i_tree.ch
   IF Form_1.Tree_1.ItemCount > 0
      WaitWindow("Wait...", .T.)
      Form_1.Tree_1.DisableUpdate

      TREESORT Tree_1 OF Form_1 ; 
          ITEM           Form_1.Tree_1.Value ; 
          RECURSIVE      Form_1.CheckSort1.Value ;
          CASESENSITIVE  Form_1.CheckSort2.Value ;
          ASCENDINGORDER Form_1.CheckSort3.Value ;
          NODEPOSITION   aNodePosition [ Form_1.RadioGroupSort.Value ]

   // Form_1.Tree_1.Sort ( Form_1.Tree_1.Value, Form_1.CheckSort1.Value, Form_1.CheckSort2.Value, Form_1.CheckSort3.Value, aNodePosition [Form_1.RadioGroupSort.Value] )

      Form_1.Tree_1.EnableUpdate
      WaitWindow()
   ENDIF
RETURN


*********************************************************
PROCEDURE Proc_Expand
*********************************************************
   IF Form_1.Tree_1.ItemCount > 0
      WaitWindow("Wait...", .T.)
      Form_1.Tree_1.DisableUpdate 
      Form_1.Tree_1.Expand ( Form_1.Tree_1.Value , Form_1.CheckExpand.Value ) 
      Form_1.Tree_1.EnableUpdate
      WaitWindow()
   ENDIF
RETURN



*********************************************************
PROCEDURE Proc_UpdateFlags
*********************************************************
STATIC lSetImage := .F., nImageIndex := 0
LOCAL i, aAllValue, iSel, iUnsel, nValue

   IF Form_1.Tree_1.ItemCount > 0
      
      EnableButtons ( .F. )
      
      IF lSetImage == .F.   // avoid multiple add in TreeView the same image
         lSetImage := .T.
         Form_1.Tree_1.AddImage := "folder_empty.bmp"
         nImageIndex := Form_1.Tree_1.ImageCount - 1
      ENDIF

      iUnSelect := iSelect := nImageIndex

      aAllValue := Form_1.Tree_1.AllValue

      FOR i = 1 TO Form_1.Tree_1.ItemCount
          nValue := aAllValue [i]
          
          IF Form_1.Tree_1.IsTrueNode ( nValue ) == .F. .AND. Form_1.Tree_1.NodeFlag ( nValue ) == .T.
             // Form_1.Tree_1.NodeFlag ( nValue )   := .F.
             Form_1.Tree_1.ImageIndex ( nValue ) := { iUnSelect , iSelect }
          ENDIF
      NEXT

      EnableButtons ( .T. )
      MsgInfo ("The image has changed of the empty folders", "Done")
   ENDIF
RETURN



*********************************************************
PROCEDURE BuildTree
*********************************************************
LOCAL   cPath := Form_1.TextBoxPATH.Value
PRIVATE lBreak := .F.

   Form_1.ButtonScan.Caption := "Press Esc Stop"
   EnableButtons ( .F. )
   
   ON KEY ESCAPE OF Form_1 ACTION lBreak := MsgYesNo( "Stop Scan?", "Confirm action")

   IF .NOT.( EMPTY( cPath ) )

      Form_1.Tree_1.DeleteAllItems
      Form_1.Tree_1.DisableUpdate
      nItemID := _ID_INI_
      
      DEFINE NODE cPath  IMAGES { "structure.bmp" }   ID nItemID++
         ScanDir( cPath )
      END NODE
      
      Form_1.Tree_1.Expand ( Form_1.Tree_1.RootValue )
      Form_1.Tree_1.EnableUpdate
      
      Form_1.StatusBar.Item( 1 ) := HB_NTOS (Form_1.Tree_1.ItemCount) + " files/folders"
      
      Form_1.Tree_1.Value := Form_1.Tree_1.FirstItemValue // Form_1.Tree_1.RootValue
      
      Form_1.Tree_1.SetFocus

   ENDIF

   RELEASE KEY ESCAPE OF Form_1

   Form_1.ButtonScan.Caption     := "Scan"
   EnableButtons ( .T. )
RETURN



****************************************************************
PROCEDURE ScanDir( cPath )
****************************************************************
LOCAL cMask     := AllTrim( Form_1.Text_1.Value )
LOCAL cAttr     := IIF ( Form_1.Check_1.Value, "H", "" )
LOCAL i, aDir, aFiles, xItem

   IF HB_URIGHT ( cPath, 1 ) <> "\" 
      cPath = cPath + "\"
   ENDIF


   BEGIN SEQUENCE

      aDir := DIRECTORY( cPath, ( "D" + cAttr ) )
      
      FOR i = 1 TO HMG_LEN (aDir)
         xItem := aDir [i]
         
         IF ( "D" $ xItem[ F_ATTR ] ) .AND. ( xItem[ F_NAME ] <> "." ) .AND. ( xItem[ F_NAME ] <> ".." )
         
            DEFINE NODE xItem [ F_NAME ]   IMAGES Nil   ID nItemID++
               ScanDir( cPath + xItem [ F_NAME ] )
            END NODE
         
         ENDIF 

         DO EVENTS
         IF lBreak == .T.
            BREAK
         ENDIF 
      NEXT


      aFiles := DIRECTORY( ( cPath + cMask ), cAttr )

      FOR i = 1 TO HMG_LEN (aFiles)
         xItem := aFiles [i]
         
         TREEITEM xItem [ F_NAME ]   IMAGES Nil   ID nItemID++
         
         Form_1.StatusBar.Item( 1 ) := "Scan " + HB_NTOS (Form_1.Tree_1.ItemCount) + " files/folders [ " +  cPath + xItem[ F_NAME ] + "]"
         
         DO EVENTS
         IF lBreak == .T.
            BREAK
         ENDIF   
      NEXT
   
   END
 
RETURN



