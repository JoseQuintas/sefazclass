
// Multi-Thread Demo WITH INHERIT PUBLIC vars, contrib by Roberto Lopez, March 2017

// NOTE: This is a classic ( conventional ) way how to use Multi-Thread at level of the OS, share ( inherit ) public and static vars

#include <hmg.ch>
#include "hbthread.ch"

FUNCTION Main

aThread := { NIL, NIL }

IF !hb_mtvm()
   MSGSTOP("There is no support for multi-threading")
   QUIT
ENDIF

DEFINE WINDOW Form_1 AT 301 , 503 WIDTH 550 HEIGHT 350 MAIN

    DEFINE BUTTON Button_1
        ROW    10
        COL    10
        WIDTH  160
        HEIGHT 28
        ACTION ( aThread[ 1 ] := hb_threadStart( HB_THREAD_INHERIT_PUBLIC , @Show_Time() ) )
        CAPTION "Start Clock Thread"
    END BUTTON

    DEFINE BUTTON Button_2
        ROW    50
        COL    10
        WIDTH  160
        HEIGHT 28
        ACTION ( aThread[ 2 ] := hb_threadStart( HB_THREAD_INHERIT_PUBLIC , @Show_Progress() ) )
        CAPTION "Start ProgressBar Thread"
    END BUTTON

    DEFINE LABEL Label_1
        ROW    10
        COL    360
        WIDTH  120
        HEIGHT 24
        VALUE "Clock Here!"
    END LABEL

    DEFINE PROGRESSBAR ProgressBar_1
        ROW    250
        COL    360
        WIDTH  150
        HEIGHT 30
        RANGEMIN 1
        RANGEMAX 10
        VALUE 0
    END PROGRESSBAR

    DEFINE BUTTON Button_3
        ROW    170
        COL    140
        WIDTH  260
        HEIGHT 28
        ACTION button_3_action()
        CAPTION "UI Still Responding to User Events!!!"
    END BUTTON

    DEFINE BUTTON Button_4
        ROW    250
        COL    10
        WIDTH  160
        HEIGHT 28
        ACTION button_4_action()
        CAPTION "Terminate all Threads"
    END BUTTON
    
END WINDOW

Form_1.Center
Form_1.Activate

Return


FUNCTION Show_Time()
   Form_1.button_1.enabled := .F. // disable 'Start Thread' button to avoid accidentally start a new thread!
   DO WHILE .T.   // thread infinite loop
      Form_1.label_1.value := Time()
      hb_idleSleep( .5 )
   ENDDO
RETURN nil


FUNCTION Show_Progress()
   Form_1.button_2.enabled := .F. //  disable 'Start Progress' button to avoid accidentally start a new thread!
   DO WHILE .T.   // thread infinite loop
      nValue := Form_1.progressBar_1.value
      nValue ++
      if nValue > 10
         nValue := 1
      endif
      Form_1.progressBar_1.value := nValue
      hb_idleSleep( .5 )
   ENDDO
RETURN nil


FUNCTION button_3_action
   MSGINFO('Clock and ProgressBar keep updating even the main thread is stopped at this MsgInfo!!!')
Return Nil


FUNCTION button_4_action
LOCAL i
   FOR i := 1 TO HMG_LEN( aThread ) 
      IF aThread[ i ] <> NIL
         hb_threadDetach( aThread[ i ] )   // close thread handle
         hb_threadQuitRequest( aThread[ i ] )   // terminate thread
         aThread[ i ] := NIL
      ENDIF
   NEXT
   Form_1.progressBar_1.value := 0
   Form_1.label_1.value := "Clock Here!"

   Form_1.button_1.enabled := .T.
   Form_1.button_2.enabled := .T.
Return Nil
