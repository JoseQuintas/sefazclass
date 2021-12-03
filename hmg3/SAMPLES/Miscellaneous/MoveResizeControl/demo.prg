
// By Dr. Claudio Soto (April 2014) based on the contribution of Marek Olszewski and B. P. Davis

#include "HMG.ch"

FUNCTION MAIN
local i, cLabelName

   Define window Form_1;
          At 0,0;
          width 700;
          height 400;
          title "Move and Resize Control With Cursor";
          main

      @ 300, 10 LABEL Label_0 VALUE "Put the cursor over control and press F3 (Info), F5 (Move) or F9 (Resize), while Move or Resize ESC -> Undo" AUTOSIZE

      DEFINE button Button_1
         Row 120
         Col 15
         width 120
         height 30
         caption "New Form"
         action New_Form()
       END button


      for i := 1 to 3
         cLabelName := "Label_"+HB_NTOS(i,1)

         define label &cLabelName
               PARENT Form_1
               row 20
               col 120*(i-1) + 40
               value "Label no. "+ str(i,1)
               Width 110
               Height 40
               Fontsize 10
               tooltip "this is label no.  "+str(i,1)
               Alignment Center
               BackColor {255,255,0}
               TabStop .t.
         end label

      next i

End window

// HMG_EnableKeyControlWithCursor (.F.) /* lOnOff: Move and Resize Control With Cursor, for default is On */
CREATE EVENT PROCNAME HMG_KeyControlWithCursor()

Form_1.center
Form_1.activate

return nil


PROCEDURE New_Form
LOCAL aRows
IF IsWindowDefined (Form_2) == .F.
   aRows := ARRAY (9)
   aRows [1]   := {'Simpson','Homer','555-5555'}
   aRows [2]   := {'Mulder','Fox','324-6432'}
   aRows [3]   := {'Smart','Max','432-5892'}
   aRows [4]   := {'Grillo','Pepe','894-2332'}
   aRows [5]   := {'Kirk','James','346-9873'}
   aRows [6]   := {'Barriga','Carlos','394-9654'}
   aRows [7]   := {'Flanders','Ned','435-3211'}
   aRows [8]   := {'Smith','John','123-1234'}
   aRows [9]   := {'Pedemonti','Flavio','000-0000'}

   DEFINE WINDOW Form_2 ;
      AT 0,0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE "Form2" ;
      WINDOWTYPE STANDARD

      @ 100,100 GRID Grid_1 ;
         WIDTH 400 ;
         HEIGHT 300 ;
         HEADERS {'Last Name','First Name','Phone'} ;
         WIDTHS {140,140,140};
         ITEMS aRows ;
         VALUE 1;
         JUSTIFY { GRID_JTFY_LEFT,GRID_JTFY_LEFT, GRID_JTFY_RIGHT }
   END WINDOW
   ACTIVATE WINDOW Form_2
ENDIF
RETURN



****************************************************************
*   GENERAL FUNCTIONS for Move and Resize Control With Cursor  *
****************************************************************


FUNCTION HMG_KeyControlWithCursor
   IF HMG_EnableKeyControlWithCursor() <> .T.
      RETURN NIL
   ENDIF
   IF HMG_GetLastVirtualKeyUp() == VK_F3       // Info
      HMG_CleanLastVirtualKeyUp()
      HMG_InfoControlWithCursor()
   ELSEIF HMG_GetLastVirtualKeyUp() == VK_F5   // Move
      HMG_CleanLastVirtualKeyUp()
      HMG_MoveControlWithCursor()
   ELSEIF HMG_GetLastVirtualKeyUp() == VK_F9   // Resize
      HMG_CleanLastVirtualKeyUp()
      HMG_ResizeControlWithCursor()
   ENDIF
RETURN NIL


FUNCTION HMG_EnableKeyControlWithCursor(lOnOff)
STATIC lOn := .T.
   IF ValType (lOnOff) == "L"
      lOn := lOnOff
   ENDIF
RETURN lOn


PROCEDURE HMG_InfoControlWithCursor
LOCAL hWnd, nCol, nRow
LOCAL cFormName, cControlName
   GetCursorPos (@nCol, @nRow)
   hWnd := WindowFromPoint (nCol, nRow)
   IF GetControlIndexByHandle (hWnd) > 0
      GetControlNameByHandle (hWnd, @cControlName, @cFormName)
      MsgInfo ({ cFormName +"."+ cControlName, HB_OSNEWLINE(),HB_OSNEWLINE(),;
                 "Row    : ", GetProperty (cFormName, cControlName, "Row"), HB_OSNEWLINE(),;
                 "Col    : ", GetProperty (cFormName, cControlName, "Col"), HB_OSNEWLINE(),;
                 "Width  : ", GetProperty (cFormName, cControlName, "Width"), HB_OSNEWLINE(),;
                 "Height : ", GetProperty (cFormName, cControlName, "Height")},"Control Info")
   ENDIF
RETURN


PROCEDURE HMG_MoveControlWithCursor
LOCAL hWnd, nCol, nRow
LOCAL cFormName, cControlName
   GetCursorPos (@nCol, @nRow)
   hWnd := WindowFromPoint (nCol, nRow)
   IF GetControlIndexByHandle (hWnd) > 0
      GetControlNameByHandle (hWnd, @cControlName, @cFormName)
      DoMethod(cFormName, cControlName, "SetFocus")
      HMG_InterActiveMove  (hWnd)
      nCol := GetWindowCol (hWnd)
      nRow := GetWindowRow (hWnd)
      ScreenToClient (GetFormHandle(cFormName), @nCol, @nRow)
      SetProperty (cFormName, cControlName, "Col", nCol)
      SetProperty (cFormName, cControlName, "Row", nRow)
   ENDIF
RETURN


PROCEDURE HMG_ResizeControlWithCursor
LOCAL hWnd, nCol, nRow
LOCAL nWidth, nHeight
LOCAL cFormName, cControlName
   GetCursorPos (@nCol, @nRow)
   hWnd := WindowFromPoint (nCol, nRow)
   IF GetControlIndexByHandle (hWnd) > 0
      GetControlNameByHandle (hWnd, @cControlName, @cFormName)
      DoMethod(cFormName, cControlName, "SetFocus")
      HMG_InterActiveSize (hWnd)
      nWidth   := GetWindowWidth  (hWnd)
      nHeight  := GetWindowHeight (hWnd)
      SetProperty (cFormName, cControlName, "Width",  nWidth)
      SetProperty (cFormName, cControlName, "Height", nHeight)
   ENDIF
RETURN



#pragma BEGINDUMP

#include "HMG_UNICODE.h"
#include <windows.h>
#include "hbapi.h"


HB_FUNC ( HMG_INTERACTIVEMOVE )
{
   HWND hWnd = (HWND) hb_parnl (1);
   if (! IsWindow(hWnd) )
       hWnd = GetFocus();
   keybd_event  (VK_RIGHT, 0, 0, 0);
   keybd_event  (VK_LEFT,  0, 0, 0);
   SendMessage  (hWnd, WM_SYSCOMMAND, SC_MOVE, 0);
   RedrawWindow (hWnd, NULL, NULL, RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW);
}


HB_FUNC ( HMG_INTERACTIVESIZE )
{
   HWND hWnd = (HWND) hb_parnl (1);
   if (! IsWindow(hWnd) )
       hWnd = GetFocus();
   keybd_event  (VK_DOWN,  0, 0, 0);
   keybd_event  (VK_RIGHT, 0, 0, 0);
   SendMessage  (hWnd, WM_SYSCOMMAND, SC_SIZE, 0);
   RedrawWindow (hWnd, NULL, NULL, RDW_ERASE | RDW_FRAME | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW);
}

#pragma ENDDUMP



