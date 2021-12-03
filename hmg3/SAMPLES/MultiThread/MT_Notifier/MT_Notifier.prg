
// Multi-Thread version of Win_Msg demo ( without INHERIT PUBLIC vars ), by Dr. Claudio Soto, March 2017


/*  
  Win_Msg - A kind of Notification message so easy and friendly Demo
  Version.........: 1.1
  Created by......: Pablo César on February 9th, 2017
 */

#include <hmg.ch>

STATIC s_hWnd_Form1 := 0

Function Main()
LOCAL nMainThreadHandle
PRIVATE nMainThreadID
PRIVATE nThreadCount := 0

   IF !hb_mtvm()
      MSGSTOP("There is no support for multi-threading")
      QUIT
   ENDIF

   nMainThreadID := GetCurrentThreadID()
   
   nMainThreadHandle := GetCurrentThreadHandle()
   SetThreadPriority( nMainThreadHandle, THREAD_PRIORITY_ABOVE_NORMAL )   // for default THREAD_PRIORITY_NORMAL

   DEFINE WINDOW Form_1 AT 100 , 100 WIDTH 550 HEIGHT 380 MAIN
      @  10,  10 LABEL Label_1 VALUE "" AUTOSIZE
      @  50, 100 BUTTON Button_1 CAPTION "Notifier MT"  ACTION CreateThread()
      @ 150, 200 BUTTON Button_2 CAPTION "Click"  ACTION MsgInfo( "Total Thread Count: "+ hb_NtoS( nThreadCount ) )
   END WINDOW
   Form_1.Activate

Return Nil


PROCEDURE CreateThread
LOCAL pThID[ 5 ]


#define WAY_ONE 1

// set inter-thread data exchange, this is the way because vars PUBLIC are not INHERITED
#if WAY_ONE
   s_hWnd_Form1 := Form_1.HANDLE
#else
   HMG_ThreadShareData( 1, Form_1.HANDLE )
#endif

   //                             Notifier( cMsg, ERROR, nSeconds, lCenter, nTransparency )
   pThID[ 1 ] := hb_threadStart( @Notifier(), "Thread Count "+ hb_NtoS( ++nThreadCount ) + CRLF + "Printing file xxxxx.xxx sent to EPSON LX-300", NIL,   3, NIL, NIL )
   pThID[ 2 ] := hb_threadStart( @Notifier(), "Thread Count "+ hb_NtoS( ++nThreadCount ) + CRLF + "Printing file xxxxx.xxx sent to EPSON LX-300", NIL,   3, NIL, NIL )
   pThID[ 3 ] := hb_threadStart( @Notifier(), "Thread Count "+ hb_NtoS( ++nThreadCount ) + CRLF + "File not found!",                           1, NIL, NIL, NIL )
   pThID[ 4 ] := hb_threadStart( @Notifier(), "Thread Count "+ hb_NtoS( ++nThreadCount ) + CRLF + "Printing file xxxxx.xxx sent to EPSON LX-300", NIL,   3, NIL, 128 )
   pThID[ 5 ] := hb_threadStart( @Notifier(), "Thread Count "+ hb_NtoS( ++nThreadCount ) + CRLF + "File not found!",                           1, NIL, NIL, 100 )

   Form_1.Label_1.VALUE := "Total Thread Count: "+ hb_NtoS( nThreadCount )

// NOTE: Because when you create a GUI control inside a Thread each thread take a local Windows Message Queue,
// is necessary you attach all Message Queue to the main thread Message Queue to allow
// invoke DO EVENTS in any thread for empty the Windows Message Queue of all thread.


#if 1

// EnumThreadID( [ nProcessID ] ) --> return array { nThreadID1, nThreadID2, ... }
   aThreadID = EnumThreadID()
   FOR i := 1 TO HMG_LEN( aThreadID )
      IF aThreadID[ i ] <> nMainThreadID
         AttachThreadInput( nMainThreadID, aThreadID[ i ], .T. )   // attach all thread Message Queue to main thread Message Queue
      ENDIF
   NEXT

#else

   AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( pThID[ 1 ] ), .T. )
   AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( pThID[ 2 ] ), .T. )
   AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( pThID[ 3 ] ), .T. )
   AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( pThID[ 4 ] ), .T. )
   AttachThreadInput( nMainThreadID, HMG_ThreadHBtoWinID( pThID[ 5 ] ), .T. )

#endif


RETURN



Function Notifier( cMsg, ERROR, nSeconds, lCenter, nTransparency, nCol )
LOCAL nHeight, nWidth
LOCAL nLeft, nTop
LOCAL hWnd, aBcolor, nWinRow, nWinCol
LOCAL nTimeIni
LOCAL hWinMain

   nHeight := 82
   nWidth := 204
   nLeft := (GetDesktopWidth() - 5) - nWidth
   nTop := (GetDesktopHeight() - 50) - nHeight
   nWinRow := nTop
   nWinCol := nLeft

   DEFAULT lCenter := .f.
   DEFAULT nTransparency := 255
   DEFAULT nSeconds := 2

   If ValType( ERROR ) = "U"
      aBcolor := {0,153,0}
   Else
      aBcolor := {204,0,0}
   Endif


nLeft := hb_Random() * ( GetDesktopWidth()  - nWidth  - 10 )
nTop  := hb_Random() * ( GetDesktopHeight() - nHeight - 10 )


   DEFINE WINDOW Win_Msg AT nTop, nLeft WIDTH nWidth HEIGHT nHeight TOPMOST ;
      NOMAXIMIZE NOMINIMIZE NOSIZE NOSYSMENU NOCAPTION BACKCOLOR aBcolor

      DEFINE LABEL Label_1
         ROW         10
         COL         10
         WIDTH       nWidth - 20
         HEIGHT      nHeight - 20
         VALUE       cMsg
         FONTNAME    "MS Shell Dlg"
         FONTSIZE    10
         FONTBOLD    .F.
         BACKCOLOR   aBcolor
         FONTCOLOR   WHITE
         CENTERALIGN .T. 
      END LABEL

   END WINDOW

   If lCenter
      CENTER WINDOW Win_Msg
   Endif

   SET WINDOW Win_Msg TRANSPARENT TO nTransparency

   hWnd := Win_Msg.HANDLE

   HMG_ChangeWindowStyle( hWnd, WS_EX_CLIENTEDGE, NIL, .T. )

   AnimateWindow(hWnd, (nSeconds*300), AW_VER_NEGATIVE)


// get inter-thread data exchange, this is the way because vars PUBLIC are not INHERITED
#if WAY_ONE
   hWinMain := s_hWnd_Form1
#else
   hWinMain := HMG_ThreadShareData( 1 )
#endif

SetFocus( hWinMain )

   nTimeIni := hb_MilliSeconds()
   WHILE( ( hb_MilliSeconds() - nTimeIni ) < nSeconds * 1000 )
      DO EVENTS
      Sleep( 20 )   // allow the OS to switch to other thread
   ENDDO

   AnimateWindow( hWnd, (nSeconds*1500), (AW_BLEND + AW_HIDE) )

SetFocus( hWinMain )

   SendMessage( hWnd, WM_SYSCOMMAND, SC_CLOSE, 0 )

Return Nil

