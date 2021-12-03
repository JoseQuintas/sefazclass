
#include "hmg.ch"

Function Main

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 500 HEIGHT 300 ;
      TITLE 'EditBox Demo' ;
      MAIN

      @ 30,10 EDITBOX Edit_1 ;
         WIDTH 400 ;
         HEIGHT 200 ;
         VALUE 'EditBox: Overwrite (press INSERT key) and DoubleClick demo!!!' 

   END WINDOW


   CREATE EVENT PROCNAME OnkeyAllEditBox()

   CREATE EVENT PROCNAME EditBox_DBLCLICK() HWND Form_1.Edit_1.HANDLE STOREINDEX nIndex
   EventProcessAllHookMessage ( nIndex, .T. ) 
   
   Form_1.Center()
   Form_1.Activate()
Return Nil



Function OnkeyAllEditBox()
STATIC lInsert := .F.
LOCAL hWnd := EventHWND()
LOCAL nIndex := GetControlIndexByHandle (hWnd)
LOCAL X,Y, nWidth, nHeight, ch, nStart, nEnd, A, B, C
   IF nIndex > 0 .AND. GetControlTypeByIndex (nIndex) == "EDIT"
      
      HMG_EditControlGetSel (hWnd, @nStart, @nEnd)
      ch := HMG_EditControlGetChar (hWnd, nEnd)

      HMG_GetAverageFontSize (hWnd, @nWidth, @nHeight)
      nWidth := HMG_GetCharWidth (hWnd, ch, @A, @B, @C)
      
      IF GetKeyState (VK_INSERT) <> 0
         CreateCaret (hWnd, 0, INT(nWidth), nHeight)
      ELSE
         #define SM_CXBORDER 5
         CreateCaret (hWnd, 0, GetSystemMetrics(SM_CXBORDER) , nHeight)
      ENDIF
      ShowCaret (hWnd)
      
      IF EventMSG() == WM_CHAR
         IF GetKeyState (VK_INSERT) <> 0 .AND. EventWPARAM() <> VK_RETURN .AND. EventWPARAM() <> VK_BACK
            HMG_EditControlSetSel (hWnd, nEnd, nEnd+1)
         ENDIF
      ENDIF
   ENDIF
Return NIL



Function EditBox_DBLCLICK()
LOCAL nStart, nEnd
      #define WM_LBUTTONDBLCLK 515
      IF EventMSG() == WM_LBUTTONDBLCLK
         MsgInfo ("DBLCLICK")
      ENDIF
Return NIL


