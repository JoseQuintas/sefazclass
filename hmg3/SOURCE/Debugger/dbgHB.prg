
/*----------------------------------------------------------------------------
 HMG DEBUGGER - GUI Debugger for HMG

 Copyright 2015-2016 by Dr. Claudio Soto (from Uruguay).
 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor Boston, MA 02110-1301, USA
 (or visit their web site at http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG DEBUGGER.

 The exception is that, if you link the HMG DEBUGGER library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG DEBUGGER library code into it.
 
 add
 GUIDoEvents() : instead INLINE now Method with Errorblock
----------------------------------------------------------------------------*/


#pragma DEBUGINFO=OFF

#define HB_CLS_NOTOBJECT   /* do not inherit from HBObject calss */
#include "hbclass.ch"

#include "hbdebug.ch"
#include "hbmemvar.ch"


/* Information structure stored in DATA aCallStack */
#define CSTACK_MODULE           1  // module name (.prg file)
#define CSTACK_FUNCTION         2  // function name
#define CSTACK_LINE             3  // start line
#define CSTACK_LEVEL            4  // eval stack level of the function
#define CSTACK_LOCALS           5  // an array with local variables
#define CSTACK_STATICS          6  // an array with STATIC variables


/* Information structure stored in aCallStack[ n ][ CSTACK_LOCALS ]
   { cLocalName, nLocalIndex, "Local", ProcName( 1 ), nLevel } */
#define VAR_NAME                1
#define VAR_POS                 2
#define VAR_TYPE                3
#define VAR_LEVEL               4  // eval stack level of the function


/* Information structure stored in ::aBreakPoints */
#define BP_LINE                 1  // line number
#define BP_MODULE               2  // module name (.prg file)
#define BP_FUNC                 3  // function name

/* Information structure stored in ::aWatch (watchpoints) */
#define WP_TYPE                 1  // WP = watchpoint, TR = tracepoint
#define WP_EXPR                 2  // source of an expression
#define WP_VALUE                3  // tracepoint value
#define WP_FOUND                4  // tracepoint found

#define _TRACEPOINT_TEXT_       "tp"
#define _WATCHPOINT_TEXT_       "wp"


/* Information structure stored in ::aModules */
#define MODULE_NAME             1
#define MODULE_STATICS          2
#define MODULE_GLOBALS          3
#define MODULE_EXTERNGLOBALS    4


#define VAR_MAX_LEN             72


#define MAX_SCAN_LINES          1500


#command IFFAIL(<r>) => IF t_oDebugger:pInfo == NIL; RETURN <r>; ENDIF


THREAD STATIC t_oDebugger


/* Debugger entry point */
PROCEDURE __dbgEntry( nMode, uParam1, uParam2, uParam3, uParam4, uParam5 )

   DO CASE
   CASE nMode == HB_DBG_GETENTRY

      __dbgSetEntry()

   CASE nMode == HB_DBG_ACTIVATE

      IF t_oDebugger == NIL
         t_oDebugger := HMGDebugger():New()
         t_oDebugger:pInfo := uParam1
      ENDIF

      t_oDebugger:nProcLevel := uParam2
      t_oDebugger:aCallStack := uParam3
      t_oDebugger:aModules   := uParam4
      t_oDebugger:aBreakPoints := uParam5

      t_oDebugger:Activate()

   ENDCASE

RETURN


/*********************************************************************
   Harbour Debugger .PRG Functions ( harbour\src\debug\dbgentry.c )
*********************************************************************/
/*
__dbgSetEntry()
__dbgSetGo( pInfo )
__dbgSetTrace( pInfo )
__dbgSetCBTrace( pInfo, lCBTrace )
__dbgSetNextRoutine( pInfo )
__dbgSetQuit( pInfo )
__dbgSetToCursor( pInfo, cModule, nLine )
__dbgGetExprValue( pInfo, cExpr|nWatch, @lValid )
__dbgGetSourceFiles( pInfo )
__dbgIsValidStopLine( pInfo, cModule, nLine )
__dbgAddBreak( pInfo, cModule, nLine, cFunction )
__dbgDelBreak( pInfo, nWatch )
__dbgIsBreak( pInfo, cModule, nLine )
__dbgGetBreakPoints( pInfo )
__dbgAddWatch( pInfo, cExpr, lTrace)
__dbgDelWatch( pInfo, nWatch )
__dbgSetWatch( pInfo, nWatch, cExpr, lTrace )
__dbgCntWatch( pInfo )
__dbgGetWatchPoints( pInfo )
__dbgGetSets()
__dbgGetModuleName( pInfo, cFullName )
__dbgModuleMatch( pInfo, cModule1, cModule2 )
__dbgSendMsg( nProcLevel, pObject, Message, nParamOffset )
*/


/*************************************************************************************************************
   HMGDebugger Class is an adaptation of the HBDebugger Class of Harbour ( harbour\src\debug\debugger.prg )
*************************************************************************************************************/

CLASS HMGDebugger

   VAR pInfo

   VAR aCallStack        INIT {}   // stack of procedures with debug info
   VAR aProcStack        INIT {}   // stack of all procedures
   VAR nProcLevel        INIT 0    // procedure level where the debugger is currently
   VAR aModules          INIT {}   // array of modules with STATIC and GLOBAL variables
   VAR aBreakPoints      INIT {}
   VAR aWatch            INIT {}
   VAR aCurrentLineInfo  INIT {}

   VAR lExitLoop         INIT .F.

   VAR cSettingsFileName INIT "init.dbg"
   VAR aPathForFiles     INIT {}

   VAR nTabWidth         INIT 4

   VAR lAnimate          INIT .F.
   VAR lAnimateStopBP    INIT .T.
   VAR lAnimateStopTP    INIT .T.
   VAR lCBTrace          INIT .T.
   VAR nSpeed            INIT 0

   VAR lActive           INIT .F.
   VAR lDeactivate       INIT .F.

   METHOD New()
   METHOD Activate()
   METHOD LoadCallStack()
   METHOD HandleEvent()

   METHOD Go()
   METHOD Step()
   METHOD Animate()
   METHOD Pause()
   METHOD Trace()
   METHOD SetCBTrace( lCBTrace )
   METHOD SetNextRoutine()
   METHOD GetSourceFiles()
   METHOD GetNextValidStopLine( nProcLevel )
METHOD GetNextValidStopLineEx( cFileName, nLine )
   METHOD IsValidStopLine( cFileName, nLine )
   METHOD SetToCursor( cFileName, nLine )
   METHOD Quit()
   METHOD Exit()

   METHOD BreakPointCount()
   METHOD IsBreakPoint( cFileName, nLine )
   METHOD BreakPointToggle( cFileName, nLine )
   METHOD BreakPointDelete( nPos )
   METHOD BreakPointDeleteAll()
   METHOD BreakPointAddFunc( cFuncName )

   METHOD GetExprValue( xExpr, lValid )
   METHOD WatchCount()
   METHOD WatchDeleteAll()
   METHOD WatchDelete( nWatch )
   METHOD WatchGetInfo( nWatch )
   METHOD WatchSetExpr( nWatch, cExpr )
   METHOD WatchPointAdd( cExpr )
   METHOD TracepointAdd( cExpr )

   METHOD SetPathForFiles( cPath )
   METHOD LoadSourceFile( cFileName )
   METHOD GetCodeLineInfo( nProc )

   METHOD DoCommand( cCommand )
   METHOD RestoreSettings( cFileName )
   METHOD SaveSettings( cFileName )

   METHOD VarGetInfo( aVar )
   METHOD VarGetName( aVar )
   METHOD VarGetValType( aVar )
   METHOD VarGetValue( aVar )
   METHOD VarSetValue( aVar, uValue )

   METHOD GetAreas()
   METHOD GetRec( cAlias )
   METHOD GetArrayInfo( cArrName, aArrValue )
   METHOD GetHashInfo( cHashName, aHashValue )
   METHOD GetObjectInfo( cObjName, oObject, aObjRawValue )

   METHOD GetBreakPoints()
   METHOD GetWatch()
   METHOD GetVars( aRawVars, nStackLevel, lShowPublics, lShowPrivates, lShowStatics, lShowLocals )   // updates monitored variables
   METHOD GetProcStack()
METHOD GUIDoEvents() // Jimmy

   // Code Blocks that call the GUI functions
   VAR bGUICreateFormDebugger  INIT {|| ProcInitGUIDebugger( .T. ) }
   VAR bGUIReleaseFormDebugger INIT {|| NIL }   // this code block is initialized in ProcInitGUIDebugger()
   VAR bGUIUpdateInfo          INIT {|| NIL }   // this code block is initialized in ProcInitGUIDebugger()
   VAR bGUIDoEvents            INIT {|| NIL }   // this code block is initialized in ProcInitGUIDebugger()
   VAR bGUIReleaseAllWindows   INIT {|| NIL }   // this code block is initialized in ProcInitGUIDebugger()
   VAR bGUIMessageBox          INIT {|| NIL }   // this code block is initialized in ProcInitGUIDebugger()
   VAR lGUIShowMessageBox      INIT .T.

   METHOD GUICreateFormDebugger()    INLINE   EVAL( ::bGUICreateFormDebugger )
   METHOD GUIReleaseFormDebugger()   INLINE   EVAL( ::bGUIReleaseFormDebugger )
   METHOD GUIUpdateInfo()            INLINE   EVAL( ::bGUIUpdateInfo )
*   METHOD GUIDoEvents()              INLINE   EVAL( ::bGUIDoEvents ) // Jimmy
   METHOD GUIReleaseAllWindows()     INLINE   EVAL( ::bGUIReleaseAllWindows )
   METHOD GUIMessageBox( ... )       INLINE   Iif( ::lGUIShowMessageBox, EVAL( ::bGUIMessageBox, ... ), NIL )

ENDCLASS


METHOD New() CLASS HMGDebugger

   t_oDebugger := Self

RETURN Self


METHOD Activate() CLASS HMGDebugger
   IFFAIL( NIL )
   ::LoadCallStack()
   IF ! ::lActive
      ::lActive := .T.
      ::SetPathForFiles( GetEnv( "PATH" ) )
      ::GUICreateFormDebugger() // GUI: create window debugger monitor
   ENDIF
   ::HandleEvent()
RETURN NIL


METHOD LoadCallStack() CLASS HMGDebugger
   LOCAL i
   LOCAL nDebugLevel
   LOCAL nCurrLevel
   LOCAL nlevel
   LOCAL nPos

   IFFAIL( NIL )
   ::aProcStack := Array( ::nProcLevel )
   nCurrLevel := __dbgProcLevel() - 1
   nDebugLevel := nCurrLevel - ::nProcLevel + 1

   FOR i := nDebugLevel TO nCurrLevel
      nLevel := nCurrLevel - i + 1
      nPos := AScan( ::aCallStack, {| a | a[ CSTACK_LEVEL ] == nLevel } )
      IF nPos > 0
         // a procedure with debug info
         ::aProcStack[ i - nDebugLevel + 1 ] := ::aCallStack[ nPos ]
      ELSE
         ::aProcStack[ i - nDebugLevel + 1 ] := { NIL /*ProcFile( i )*/, ProcName( i ) + "(" + hb_ntos( ProcLine( i ) ) + ")", NIL, nLevel, NIL, NIL }
      ENDIF
   NEXT
RETURN NIL    // ::aProcStack -- > { cFileName, cFuncName, nLine, nLevel, aLocals, aStatics }


METHOD HandleEvent() CLASS HMGDebugger
   THREAD STATIC cBreakPointFunc := ""
   LOCAL xValue, i
   LOCAL lTracePoint := .F., lBreakPoint := .F.
   LOCAL nLine, cFileName, cFuncName, cInfo, nProcLevel
   LOCAL nTimeIni := hb_MilliSeconds()

   IFFAIL( NIL )

   nProcLevel := ::aCallStack[ 1 ][ CSTACK_LEVEL ]
   cFileName  := ::aCallStack[ 1 ][ CSTACK_MODULE ]
   cFuncName  := ::aCallStack[ 1 ][ CSTACK_FUNCTION ]
   nLine      := ::aCallStack[ 1 ][ CSTACK_LINE ]
   cInfo      := ""

   FOR i := 1 TO Len( ::aWatch )
      IF ::aWatch [ i ] [ WP_TYPE ] == _TRACEPOINT_TEXT_
         xValue := ::GetExprValue( i )
         IF ValType( xValue ) != ValType( ::aWatch [ i ] [ WP_VALUE ] )  .OR.  xValue  != ::aWatch [ i ] [ WP_VALUE ]
            ::aWatch [ i ] [ WP_VALUE ] := xValue
            ::aWatch [ i ] [ WP_FOUND ] := .T.
            lTracePoint := .T.
         ELSE
            ::aWatch [ i ] [ WP_FOUND ] := .F.
         ENDIF
      ENDIF
   NEXT

   IF lTracePoint
      cInfo := cInfo + "< TP: TracePoint >"
   ENDIF

   IF ::IsBreakPoint( cFileName, nLine ) > 0
      cInfo := cInfo + "< BP: BreakPoint >"
      lBreakPoint := .T.
   ELSE
      i := AScan( ::aBreakPoints, {| aBreak | aBreak[ BP_FUNC ] == cFuncName .OR. aBreak[ BP_FUNC ] == ( "(b)" + cFuncName ) } )
      IF i > 0 .AND. cBreakPointFunc != cFuncName
         cInfo := cInfo + "< BP: BreakPoint FUNCTION >"
         cBreakPointFunc := cFuncName
         lBreakPoint := .T.
      ENDIF
   ENDIF

   ::aCurrentLineInfo  := { nProcLevel, cFileName, cFuncName, nLine, cInfo, ::cSettingsFileName }

   IF ::lDeactivate == .T.
      RETURN NIL
   ENDIF

   ::GUIUpdateInfo()   // GUI: update info in window monitor

   IF ::lAnimate .AND. ( ( ::lAnimateStopTP .AND. lTracePoint ) .OR. ( ::lAnimateStopBP .AND. lBreakPoint ) )
      ::Pause()
   ENDIF

   ::lExitLoop := .F.

  /*-----------------------------------
    Methods that set ::lExitLoop := .T.
    -----------------------------------
      ::Go()
      ::Step()
      ::Animate()
      ::Trace()
      ::SetNextRoutine()
      ::SetToCursor()
      ::Quit()
      ::Exit()
    -----------------------------------*/

   DO WHILE ! ::lExitLoop
      ::GUIDoEvents()   // GUI: execute Do Events function
      hb_releaseCPU()
      IF ::lAnimate
         IF ::nSpeed != 0
            WHILE ( ( hb_MilliSeconds() - nTimeIni ) < ::nSpeed ) .AND. ( ! ::lExitLoop )
               ::GUIDoEvents()   // GUI: execute Do Events function
               hb_releaseCPU()
            ENDDO
         ENDIF
         RETURN NIL
      ENDIF
   ENDDO

RETURN NIL


/*************************************************************/


METHOD Animate() CLASS HMGDebugger
   IFFAIL( NIL )
   __dbgResetRunFlags( ::pInfo )
   ::lAnimate := .T.
RETURN NIL


METHOD Step() CLASS HMGDebugger   // CMD_STEP
   IFFAIL( NIL )
   __dbgResetRunFlags( ::pInfo )
   ::lAnimate := .F.
   ::lExitLoop := .T.
RETURN NIL


METHOD Trace() CLASS HMGDebugger   // CMD_TRACE
   IFFAIL( NIL )
   ::Step() // force a Step(), be careful with the order of call ::Step() method, because __dbgResetRunFlags() in ::Step() method sets __dbgSetTrace() to Off
   __dbgSetTrace( ::pInfo )
RETURN NIL


METHOD Go() CLASS HMGDebugger   // CMD_GO
   IFFAIL( NIL )
   __dbgSetGo( ::pInfo )
   ::lAnimate := .F.
   ::lExitLoop := .T.
RETURN NIL


METHOD SetNextRoutine() CLASS HMGDebugger   // CMD_NEXTR
   IFFAIL( NIL )
   __dbgSetNextRoutine( ::pInfo )
   ::lAnimate := .F.
   ::lExitLoop := .T.
RETURN NIL


METHOD Pause() CLASS HMGDebugger
   IFFAIL( NIL )
   __dbgResetRunFlags( ::pInfo )
   ::lAnimate := .F.
RETURN NIL


METHOD SetCBTrace( lCBTrace ) CLASS HMGDebugger
   IFFAIL( NIL )
   hb_default( @lCBTrace, .T. )
   __dbgSetCBTrace( ::pInfo, lCBTrace )
   ::lCBTrace := lCBTrace
RETURN NIL


METHOD GetSourceFiles() CLASS HMGDebugger
   IFFAIL( NIL )
   RETURN __dbgGetSourceFiles( ::pInfo )


METHOD GetNextValidStopLine( nProcLevel ) CLASS HMGDebugger
LOCAL i
LOCAL cFileName
LOCAL nLine
   IFFAIL( 0 )
   hb_default( @nProcLevel, 1 )
   cFileName := ProcFile( nProcLevel )
   nLine     := ProcLine( nProcLevel )
   FOR i := nLine + 1 TO nLine + MAX_SCAN_LINES + 1
      IF __dbgIsValidStopLine( ::pInfo, cFileName, i )
         RETURN i
      ENDIF
   NEXT
RETURN 0


METHOD GetNextValidStopLineEx( cFileName, nLine ) CLASS HMGDebugger
LOCAL i
   IFFAIL( 0 )
   hb_default( @cFileName, ProcFile( 1 ) )
   hb_default( @nLine,     ProcLine( 1 ) )
   FOR i := nLine + 1 TO nLine + MAX_SCAN_LINES + 1
      IF __dbgIsValidStopLine( ::pInfo, cFileName, i )
         RETURN i
      ENDIF
   NEXT
RETURN 0


METHOD IsValidStopLine( cFileName, nLine ) CLASS HMGDebugger
   IFFAIL( .F. )
   hb_default( @cFileName, ProcFile( 1 ) )
   hb_default( @nLine, ::GetNextValidStopLine( 2 ) )
RETURN __dbgIsValidStopLine( ::pInfo, cFileName, nLine )


METHOD SetToCursor( cFileName, nLine ) CLASS HMGDebugger   // CMD_TOCURS
   IFFAIL( .F. )
   hb_default( @cFileName, ProcFile( 1 ) )
   hb_default( @nLine, ::GetNextValidStopLine( 2 ) )
   IF ! __dbgIsValidStopLine( ::pInfo, cFileName, nLine )
      ::GUIMessageBox( "SetToCursor: Invalid File Name (", cFileName, ") and/or Line Number (", nLine, ")" )   // GUI: message box info
      RETURN .F.
   ENDIF
   __dbgSetToCursor( ::pInfo, cFileName, nLine )
   ::lExitLoop := .T.
RETURN .T.


METHOD Quit() CLASS HMGDebugger   // CMD_QUIT
   IFFAIL( NIL )
   __dbgSetQuit( ::pInfo )
   t_oDebugger := NIL
   ::lExitLoop := .T.
   ::GUIReleaseAllWindows()   // GUI: close all windows and exit the program
RETURN NIL


METHOD Exit() CLASS HMGDebugger   // CMD_EXIT
   ::lExitLoop := .T.
   // ::GUIReleaseFormDebugger()   // GUI: close window of debugger
RETURN NIL


METHOD BreakPointCount() CLASS HMGDebugger
   RETURN Len( ::GetBreakPoints() )


METHOD IsBreakPoint( cFileName, nLine ) CLASS HMGDebugger
   IFFAIL( 0 )
RETURN __dbgIsBreak( ::pInfo, cFileName, nLine ) + 1


METHOD BreakPointToggle( cFileName, nLine ) CLASS HMGDebugger   // CMD_BADD  &  CMD_BDEL
   LOCAL nAt
   IFFAIL( 0 )
   hb_default( @cFileName, ProcFile( 1 ) )
   hb_default( @nLine, ::GetNextValidStopLine( 2 ) )
   nAt := ::IsBreakPoint( cFileName, nLine )
   IF nAt > 0
      __dbgDelBreak( ::pInfo, nAt - 1)
      RETURN( - nAt )
   ELSEIF ::IsValidStopLine( cFileName, nLine )
      __dbgAddBreak( ::pInfo, cFileName, nLine )
      nAt := ::IsBreakPoint( cFileName, nLine )
      RETURN nAt
   ELSE
      ::GUIMessageBox( "ToggleBreakPoint: Invalid File Name (", cFileName, ") and/or Line Number (", nLine, ")" )   // GUI: message box info
      RETURN 0
   ENDIF
RETURN 0


METHOD BreakPointDelete( nPos ) CLASS HMGDebugger
   IFFAIL( .F. )
   IF nPos >= 1 .AND. nPos <= ::BreakPointCount()
      __dbgDelBreak( ::pInfo, nPos - 1 )
   ELSE
      ::GUIMessageBox( "BreakPointDelete: Invalid BreakPoint Number (", nPos, ")" )   // GUI: message box info
      RETURN .F.   // Invalid BreakPoint Number
   ENDIF
RETURN .T.


METHOD BreakPointDeleteAll() CLASS HMGDebugger
   LOCAL i
   IFFAIL( NIL )
   FOR i := ::BreakPointCount() TO 1 STEP -1
      __dbgDelBreak( ::pInfo, i - 1 )
   NEXT
RETURN NIL


METHOD BreakPointAddFunc( cFuncName ) CLASS HMGDebugger
   IFFAIL( .F. )
   IF ValType( cFuncName ) == "C" .AND. ! Empty( cFuncName )
      cFuncName := Upper( AllTrim( cFuncName ) )
      __dbgAddBreak( ::pInfo, NIL, NIL, cFuncName )
   ELSE
      ::GUIMessageBox( "BreakPointAddFunc: Invalid Function Name" )   // GUI: message box info
      RETURN .F.   // Invalid Function Name
   ENDIF
RETURN .T.


METHOD GetExprValue( xExpr, lValid ) CLASS HMGDebugger   // CMD_CALC
   LOCAL xResult
   LOCAL bOldError, oErr
   IFFAIL( NIL )
   lValid := .F.
   bOldError := Errorblock( {|oErr|Break(oErr)} )
   BEGIN SEQUENCE
      xResult := __dbgGetExprValue( ::pInfo, xExpr, @lValid )
      IF ! lValid
         xResult := "Syntax error"
      ENDIF
   RECOVER USING oErr
      xResult := oErr:operation + ": " + oErr:description
      IF HB_ISARRAY( oErr:args )
         xResult += "; arguments:"
         AEval( oErr:args, {| x | xResult += " " + AllTrim( __dbgValToStr( x ) ) } )
      ENDIF
      lValid := .F.
   END SEQUENCE
   Errorblock( bOldError )
RETURN xResult


METHOD WatchCount() CLASS HMGDebugger
   RETURN Len( ::aWatch )


METHOD WatchDelete( nWatch ) CLASS HMGDebugger   // CMD_WDEL
   IFFAIL( .F. )
   IF nWatch < 1 .OR. nWatch > Len( ::aWatch )
      ::GUIMessageBox( "WatchDelete: Invalid Watch number (", nWatch, ")" )   // GUI: message box info
      RETURN .F.   // Invalid Watch number
   ENDIF
   __dbgDelWatch( ::pInfo, nWatch - 1 )
   hb_ADel( ::aWatch, nWatch, .T. )
RETURN .T.


METHOD WatchDeleteAll() CLASS HMGDebugger
   LOCAL i
   IFFAIL( NIL )
   FOR i := ::WatchCount() TO 1 STEP -1
      __dbgDelWatch( ::pInfo, i - 1 )
      hb_ADel( ::aWatch, i, .T. )
   NEXT
RETURN NIL


METHOD WatchGetInfo( nWatch ) CLASS HMGDebugger
   LOCAL xValue
   LOCAL cValType
   LOCAL lValid
   LOCAL aWatch
   IFFAIL( {} )
   IF nWatch < 1 .OR. nWatch > Len( ::aWatch )
      ::GUIMessageBox( "WatchGetInfo: Invalid Watch number (", nWatch, ")" )   // GUI: message box info
      RETURN {}   // Invalid Watch number
   ENDIF
   aWatch := ::aWatch[ nWatch ]   // aWatch[ WP_TYPE ], aWatch[ WP_EXPR ]
   xValue := ::GetExprValue( nWatch, @lValid )
   IF lValid
      cValType  := ValType( xValue )
      xValue := __dbgValToStr( xValue )
   ELSE
      cValType := "U"   // xValue := "Undefined", xValue contains error description
   ENDIF
RETURN { aWatch[ WP_TYPE ], aWatch[ WP_EXPR ], cValType, xValue, __dbgValToStr( lValid ) }


METHOD WatchSetExpr( nWatch, cExpr ) CLASS HMGDebugger
   LOCAL lTracePoint
   IFFAIL( .F. )
   IF ValType( cExpr ) != "C" .OR. Empty( cExpr )
      ::GUIMessageBox( "WatchSetExpr: Invalid expression type (", cExpr, ")" )   // GUI: message box info
      RETURN .F.   // Invalid expression type
   ENDIF
   IF nWatch < 1 .OR. nWatch > Len( ::aWatch )
      ::GUIMessageBox( "WatchSetExpr: Invalid Watch number (", nWatch, ")" )   // GUI: message box info
      RETURN .F.   // Invalid Watch number
   ENDIF
   cExpr := AllTrim( cExpr )
   ::aWatch[ nWatch ][ WP_EXPR ] := cExpr
   lTracePoint := Iif( ::aWatch[ nWatch ][ WP_TYPE ] == _TRACEPOINT_TEXT_ , .T. , .F.)
   __dbgSetWatch( ::pInfo, nWatch - 1, cExpr, lTracePoint )
   IF lTracePoint
      ::aWatch[ nWatch ][ WP_VALUE ] := ::GetExprValue( cExpr )
      ::aWatch[ nWatch ][ WP_FOUND ] := .F.
   ENDIF
RETURN .T.


METHOD WatchPointAdd( cExpr ) CLASS HMGDebugger   // CMD_WADD
   LOCAL aWatch
   IFFAIL( 0 )
   IF ValType( cExpr ) != "C" .OR. Empty( cExpr )
      ::GUIMessageBox( "WatchPointAdd: Invalid expression type (", cExpr, ")" )   // GUI: message box info
      RETURN 0   // Invalid expression type
   ENDIF
   cExpr := AllTrim( cExpr )
   aWatch := { _WATCHPOINT_TEXT_ , cExpr }
   __dbgAddWatch( ::pInfo, cExpr, .F. )
   AAdd( ::aWatch, aWatch )
RETURN Len( ::aWatch )   // return --> nWatch


METHOD TracePointAdd( cExpr ) CLASS HMGDebugger
   LOCAL aWatch, nLen
   IFFAIL( .F. )
   IF ValType( cExpr ) != "C" .OR. Empty( cExpr )
   ::GUIMessageBox( "TracePointAdd: Invalid expression type (", cExpr, ")" )   // GUI: message box info
      RETURN .F.   // Invalid expression type
   ENDIF
   cExpr := AllTrim( cExpr )
   aWatch := { _TRACEPOINT_TEXT_ , cExpr, NIL, .F. }
   __dbgAddWatch( ::pInfo, cExpr, .T. )
   AAdd( ::aWatch, aWatch )
   nLen := Len( ::aWatch )
   ::aWatch[ nLen ][ WP_VALUE ] := ::GetExprValue( cExpr )
RETURN .T.


METHOD SetPathForFiles( cPath ) CLASS HMGDebugger
   RETURN ::aPathForFiles := __dbgPathToArray( cPath )


METHOD LoadSourceFile( cFileName ) CLASS HMGDebugger
LOCAL cPrgCode, aLineCode := {}
LOCAL i, cFileFullName := ""
   IF ! hb_FileExists( cFileName )
      FOR i := 1 TO Len( ::aPathForFiles )
         cFileFullName := ::aPathForFiles[ i ] + hb_ps() + cFileName
         IF hb_FileExists( cFileFullName )
            cFileName := cFileFullName
            EXIT
         ENDIF
      NEXT
   ENDIF
   IF ! hb_FileExists( cFileName )
      ::GUIMessageBox( "LoadSourceFile: File Not Found (", cFileName, ")" )   // GUI: message box info
   ELSE
      cPrgCode := hb_MemoRead( cFileName )
      cPrgCode := StrTran( cPrgCode, Chr( 9 ), Space( ::nTabWidth ) )   // expand Tabs
      aLineCode := __dbgTextToArray( cPrgCode )
   ENDIF
RETURN aLineCode


METHOD GetCodeLineInfo( nProcLevel ) CLASS HMGDebugger
   LOCAL nLine
   LOCAL cFileName
   LOCAL cFuncName
   LOCAL aStackLevel := {}
   IFFAIL( {} )
   hb_default( @nProcLevel, 1 )
   IF nProcLevel <= ::nProcLevel
      nProcLevel  := ::aCallStack[ nProcLevel ][ CSTACK_LEVEL ]
      cFileName   := ::aCallStack[ nProcLevel ][ CSTACK_MODULE ]
      cFuncName   := ::aCallStack[ nProcLevel ][ CSTACK_FUNCTION ]
      nLine       := ::aCallStack[ nProcLevel ][ CSTACK_LINE ]
      aStackLevel := { nProcLevel, cFileName, cFuncName, nLine }
   ELSE
      ::GUIMessageBox( "GetCodeLineInfo: Invalid ProcLevel ( #", nProcLevel, " )" )   // GUI: message box info
   ENDIF
RETURN aStackLevel


METHOD DoCommand( cCommand ) CLASS HMGDebugger
   LOCAL cCommand2 := cCommand
   LOCAL cParam1 := ""
   LOCAL cParam2 := ""
   LOCAL lValid := .T.
   LOCAL n

   IFFAIL( NIL )
   IF ValType( cCommand ) != "C" .OR. Empty( cCommand )
      RETURN NIL
   ENDIF

   cCommand := AllTrim( cCommand )
   n := At( " ", cCommand )
   IF n > 0
      cParam1 := AllTrim( SubStr( cCommand, n + 1 ) )
      cCommand := Left( cCommand, n - 1 )
      n := At( " ", cParam1 )
      IF n > 0
         cParam2 := AllTrim( SubStr( cParam1, n + 1 ) )
         cParam1 := Left( cParam1, n - 1 )
      ENDIF
   ENDIF
   cCommand := Upper( cCommand )

   DO CASE
      CASE Left( cCommand, 2 ) == "//" .OR. Left( cCommand, 1 )  == "!" .OR. Left( cCommand, 1 )  == "#"
         RETURN NIL   // comment, skip line

      CASE cCommand == "BREAKPOINT" .OR. cCommand == "BP"
         IF ! Empty( cParam1 ) .AND. IsDigit( cParam2 )
            ::BreakPointToggle( cParam1, Val( cParam2 ) )
         ELSEIF hb_asciiIsAlpha( cParam1 ) .OR. Left( cParam1, 1 ) == "_"
            ::BreakPointAddFunc( cParam1 )
         ELSE
            lValid := .F.
         ENDIF

      CASE cCommand == "TRACEPOINT" .OR. cCommand == "TP"
         IF ! Empty( cParam1 )
            ::TracePointAdd( cParam1 )
         ELSE
            lValid := .F.
         ENDIF

      CASE cCommand == "WATCHPOINT" .OR. cCommand == "WP"
         IF ! Empty( cParam1 )
            ::WatchPointAdd( cParam1 )
         ELSE
            lValid := .F.
         ENDIF

      CASE cCommand == "CODEBLOCKTRACE" .OR. cCommand == "CBTRACE"
         IF cParam1 $ ".T.,TRUE,YES"
            ::SetCBTrace( .T. )
         ELSEIF cParam1 $ ".F.,FALSE,NO"
            ::SetCBTrace( .F. )
         ELSE
            lValid := .F.
         ENDIF

      CASE cCommand == "ANIMATEBREAKPOINT" .OR. cCommand == "ANIMATEBP"
         IF cParam1 $ ".T.,TRUE,YES"
            ::lAnimateStopBP := .T.
         ELSEIF cParam1 $ ".F.,FALSE,NO"
            ::lAnimateStopBP := .F.
         ELSE
            lValid := .F.
         ENDIF

      CASE cCommand == "ANIMATETRACEPOINT" .OR. cCommand == "ANIMATETP"
         IF cParam1 $ ".T.,TRUE,YES"
            ::lAnimateStopTP := .T.
         ELSEIF cParam1 $ ".F.,FALSE,NO"
            ::lAnimateStopTP := .F.
         ELSE
            lValid := .F.
         ENDIF

      CASE cCommand == "SPEED"
         IF IsDigit( cParam1 )
            ::nSpeed := Min( Val( cParam1 ), 65534 )
         ELSE
            lValid := .F.
         ENDIF

      OTHERWISE
         lValid := .F.

   ENDCASE
   IF lValid == .F.
      ::GUIMessageBox( "DoCommand: Command Error (", AllTrim( cCommand2 ), ")" )   // GUI: message box info
   ENDIF
RETURN NIL


METHOD RestoreSettings( cFileName ) CLASS HMGDebugger
   LOCAL aCommand
   LOCAL i
   IFFAIL( NIL )
   IF hb_FileExists( cFileName )
      aCommand := __dbgTextToArray( hb_MemoRead( cFileName ) )
      FOR i := 1 TO Len( aCommand )
         ::DoCommand( AllTrim( aCommand[ i ] ) )
      NEXT
   ELSE
      ::GUIMessageBox( "RestoreSettings: Invalid File Name (", cFileName, ")" )   // GUI: message box info
   ENDIF
RETURN NIL


METHOD SaveSettings( cFileName ) CLASS HMGDebugger
   LOCAL cInfo := ""
   LOCAL aBreakPoints, aWatch
   LOCAL i

   IFFAIL( NIL )
   IF Empty( cFileName )
      ::GUIMessageBox( "SaveSettings: Invalid File Name" )   // GUI: message box info
   ELSE
      ::cSettingsFileName := cFileName
   ENDIF

   aBreakPoints := ::GetBreakPoints()
   cInfo += "# BREAKPOINTS #" + hb_eol()
   FOR i := 1 TO Len( aBreakPoints )
      IF aBreakPoints[ i ] [ BP_LINE ] <> NIL
         cInfo += "BP " + aBreakPoints[ i ] [ BP_MODULE ] + " " + hb_ntos( aBreakPoints[ i ] [ BP_LINE ] ) + hb_eol()
      ELSE
         cInfo += "BP " + aBreakPoints[ i ] [ BP_FUNC ] + hb_eol()
      ENDIF
   NEXT
   cInfo += hb_eol()

   aWatch := ::aWatch
   cInfo += "# TRACEPOINTS #" + hb_eol()
   FOR i := 1 TO Len( aWatch )
      IF aWatch[ i ] [ WP_TYPE ] == _TRACEPOINT_TEXT_
         cInfo += Upper( aWatch[ i ] [ WP_TYPE ] ) + " " + aWatch[ i ] [ WP_EXPR ] + hb_eol()
      ENDIF
   NEXT
   cInfo += hb_eol()

   cInfo += "# WATCHPOINTS #" + hb_eol()
   FOR i := 1 TO Len( aWatch )
      IF aWatch[ i ] [ WP_TYPE ] == _WATCHPOINT_TEXT_
         cInfo += Upper( aWatch[ i ] [ WP_TYPE ] ) + " " + aWatch[ i ] [ WP_EXPR ] + hb_eol()
      ENDIF
   NEXT
   cInfo += hb_eol()

   cInfo += "# OTHERS #" + hb_eol()
   cInfo += "CodeBlockTrace "    + Iif( ::lCBTrace,       "YES", "NO" ) + hb_eol()
   cInfo += "AnimateBreakPoint " + Iif( ::lAnimateStopBP, "YES", "NO" ) + hb_eol()
   cInfo += "AnimateTracePoint " + Iif( ::lAnimateStopTP, "YES", "NO" ) + hb_eol()
   IF ::nSpeed != 0
      cInfo += "Speed " + hb_ntos( ::nSpeed ) + hb_eol()
   ENDIF

   hb_MemoWrit( cFileName, cInfo )

RETURN NIL


METHOD VarGetInfo( aVar ) CLASS HMGDebugger
   LOCAL xValue := ::VarGetValue( aVar )
   LOCAL cType := Left( aVar[ VAR_TYPE ], 1 )
   DO CASE
      CASE cType == "G" ; cType := "Global"
      CASE cType == "L" ; cType := "Local"
      CASE cType == "S" ; cType := "STATIC"
      OTHERWISE         ; cType := aVar[ VAR_TYPE ]
   ENDCASE
RETURN { cType , aVar[ VAR_NAME ] , ValType( xValue ) , __dbgValToStr( xValue ) }


METHOD VarGetName( aVar ) CLASS HMGDebugger
   RETURN aVar[ VAR_NAME ]


METHOD VarGetValType( aVar ) CLASS HMGDebugger
   LOCAL xValue := ::VarGetValue( aVar )
RETURN ValType( xValue )


METHOD VarGetValue( aVar ) CLASS HMGDebugger
   LOCAL cType := Left( aVar[ VAR_TYPE ], 1 )
   DO CASE
      CASE cType == "G" ; RETURN __dbgVMVarGGet( aVar[ VAR_LEVEL ], aVar[ VAR_POS ] )
      CASE cType == "L" ; RETURN __dbgVMVarLGet( __dbgProcLevel() - aVar[ VAR_LEVEL ], aVar[ VAR_POS ] )
      CASE cType == "S" ; RETURN __dbgVMVarSGet( aVar[ VAR_LEVEL ], aVar[ VAR_POS ] )
      OTHERWISE         ; RETURN aVar[ VAR_POS ] // Public or Private
   ENDCASE
RETURN NIL


METHOD VarSetValue( aVar, xValue ) CLASS HMGDebugger
   LOCAL nProcLevel
   LOCAL cType := Left( aVar[ VAR_TYPE ], 1 )
   IF cType == "G"
      __dbgVMVarGSet( aVar[ VAR_LEVEL ], aVar[ VAR_POS ], xValue )
   ELSEIF cType == "L"
      nProcLevel := __dbgProcLevel() - aVar[ VAR_LEVEL ]   // skip debugger stack
      __dbgVMVarLSet( nProcLevel, aVar[ VAR_POS ], xValue )
   ELSEIF cType == "S"
      __dbgVMVarSSet( aVar[ VAR_LEVEL ], aVar[ VAR_POS ], xValue )
   ELSE
      // Public or Private
      aVar[ VAR_POS ] := xValue
      &( aVar[ VAR_NAME ] ) := xValue
   ENDIF
RETURN NIL


METHOD GetProcStack() CLASS HMGDebugger
LOCAL cProcLevel, cFileName, cFuncName, cLine
LOCAL i, arr := {}
   FOR i := 1 TO Len( ::aProcStack )
      cProcLevel := Iif( Empty(::aProcStack[i,CSTACK_LEVEL]),    "", __dbgValToStr( ::aProcStack[i,CSTACK_LEVEL] ) )
      cFileName  := Iif( Empty(::aProcStack[i,CSTACK_MODULE]),   "", ::aProcStack[i,CSTACK_MODULE] )
      cFuncName  := Iif( Empty(::aProcStack[i,CSTACK_FUNCTION]), "", ::aProcStack[i,CSTACK_FUNCTION] )
      cLine      := Iif( Empty(::aProcStack[i,CSTACK_LINE]),     "", __dbgValToStr( ::aProcStack[i,CSTACK_LINE] ) )
      AAdd( arr, { cProcLevel, cFileName, cFuncName, cLine } )
   NEXT
RETURN arr


METHOD GetAreas() CLASS HMGDebugger
LOCAL arr1[512], n, i, nAreas := 0, nAlias
LOCAL aAreas := {}
   #define WA_ITEMS  12

   FOR n := 1 TO 512
      IF ( (n)->( Used() ) )
         arr1[ ++nAreas ] := n
      ENDIF
   NEXT

   nAlias := Select()
   FOR i := 1 TO nAreas
      Select( arr1[i] )
      AAdd ( aAreas, Array( WA_ITEMS ) )
      aAreas [i] [ 1] := Iif( arr1[i]==nAlias, "*", "" ) + Alias()
      aAreas [i] [ 2] := hb_ntos( arr1[i] )
      aAreas [i] [ 3] := rddname()
      aAreas [i] [ 4] := hb_ntos( Reccount() )
      aAreas [i] [ 5] := hb_ntos( Recno() )
      aAreas [i] [ 6] := Iif( Bof(), "Yes", "No" )
      aAreas [i] [ 7] := Iif( Eof(), "Yes", "No" )
      aAreas [i] [ 8] := Iif( Found(), "Yes", "No" )
      aAreas [i] [ 9] := Iif( Deleted(), "Yes", "No" )
      aAreas [i] [10] := dbFilter()
      aAreas [i] [11] := ordName()
      aAreas [i] [12] := ordKey()
   NEXT
   Select( nAlias )

RETURN aAreas


METHOD GetRec( cAlias ) CLASS HMGDebugger
LOCAL af, nCount, i, cValue
LOCAL arr := {}
   IF Empty( cAlias )
      cAlias := Alias()
   ENDIF
   IF Empty( cAlias ) .OR. ( i := Select( cAlias ) ) == 0
      Return arr
   ENDIF
   af := (cAlias)->(dbStruct())
   nCount := Len( af )
   FOR i := 1 TO nCount
      cValue := __dbgValToStr( (cAlias)->( FieldGet(i) ) )
      IF Len( cValue ) > VAR_MAX_LEN
         cValue := Left( cValue, VAR_MAX_LEN )
      ENDIF
      AAdd( arr, { af[i,1], af[i,2], Ltrim( Str( af[i,3] ) ), cValue } )   // { cName, cType, cLength, cValue }
   NEXT
RETURN arr



METHOD GetArrayInfo( cArrName, aArrValue ) CLASS HMGDebugger
LOCAL arr := {}
LOCAL cValType
LOCAL cValue, i
   IF ValType( aArrValue ) != "A"
      ::GUIMessageBox( "GetArrayInfo: Invalid data type ( ValType: " + ValType( aArrValue ) + " )" )   // GUI: message box info
   ELSE
      FOR i := 1 TO Len( aArrValue )
         cValType := Valtype( aArrValue[ i ] )
         cValue := __dbgValToStr( aArrValue[ i ] )
         IF Len( cValue ) > VAR_MAX_LEN
            cValue := Left( cValue, VAR_MAX_LEN )
         ENDIF
         AAdd( arr, { cArrName+" [ "+hb_ntos(i)+" ]", cValType, cValue } )
      NEXT
   ENDIF
RETURN arr


METHOD GetHashInfo( cHashName, aHashValue ) CLASS HMGDebugger
LOCAL arr := {}
LOCAL cValType
LOCAL cValue, i
   IF ValType( aHashValue ) != "H"
      ::GUIMessageBox( "GetHashInfo: Invalid data type ( ValType: " + ValType( aHashValue ) + " )" )   // GUI: message box info
   ELSE
      FOR i := 1 TO Len( aHashValue )
         cValType := Valtype( hb_HValueAt( aHashValue, i ) )
         cValue := __dbgValToStr( hb_HValueAt( aHashValue, i ) )
         IF Len( cValue ) > VAR_MAX_LEN
            cValue := Left( cValue, VAR_MAX_LEN )
         ENDIF
         AAdd( arr, { cHashName +" [ "+ __dbgValToStr( hb_HKeyAt( aHashValue, i ) ) +" ]", cValType, cValue } )
      NEXT
   ENDIF
RETURN arr


METHOD GetObjectInfo( cObjName, oObject, aObjRawValue ) CLASS HMGDebugger
LOCAL aVars, aMethods, i
LOCAL xValue, cValType, cValue
LOCAL arr := {}
   #define _OBJ_SEP_   ":"
   aObjRawValue := {}
   IF ValType( oObject ) != "O"
      ::GUIMessageBox( "GetObjectInfo: Invalid data type ( ValType: " + ValType( oObject ) + " )" )   // GUI: message box info
   ELSE
      aVars := __objGetMsgList( oObject )   // create list of object messages
      aMethods := __objGetMethodList( oObject )   // create list of object method
      FOR i := 1 TO Len( aVars )
         xValue := __dbgObjGetValue( oObject, aVars[i] )
         cValType := Valtype( xValue )
         cValue := __dbgValToStr( xValue )
         IF Len( cValue ) > VAR_MAX_LEN
            cValue := Left( cValue, VAR_MAX_LEN )
         ENDIF
         AAdd( arr, { cObjName + _OBJ_SEP_ + aVars[i], cValType, cValue } )
         AAdd( aObjRawValue, xValue )
      NEXT
      FOR i := 1 TO Len( aMethods )
         AAdd( arr, { cObjName + _OBJ_SEP_ + aMethods[ i ], "", "Method" } )
         AAdd( aObjRawValue, NIL )
      NEXT
   ENDIF
RETURN arr


METHOD GUIDoEvents() CLASS HMGDebugger // Jimmy
LOCAL bOldError

   bOldError := Errorblock( {||Break()} )
   BEGIN SEQUENCE
      EVAL( ::bGUIDoEvents )
   END SEQUENCE
   Errorblock( bOldError )

RETURN Self

FUNCTION __dbgValToStr( uVal )

   LOCAL cType := ValType( uVal ), i, s, nLen

   DO CASE
   CASE uVal == NIL  ; RETURN "NIL"
   CASE cType == "B" ; RETURN "{|| ... }"
   CASE cType == "A"
      s := ""
      nLen := Min( 8, Len( uVal ) )
      FOR i := 1 TO nLen
         s += '"' + Valtype( uVal[i] ) + '"' + Iif( i==nLen, "", ", " )
      NEXT
      IF nLen < Len( uVal )
         s += ", ..."
      ENDIF
      RETURN "Array(" + hb_ntos( Len( uVal ) ) + "): { " + s + " }"
   CASE cType $ "CM" ; RETURN '"' + uVal + '"'
   CASE cType == "L" ; RETURN Iif( uVal, ".T.", ".F." )
   CASE cType == "D" ; RETURN DToC( uVal )
   CASE cType == "T" ; RETURN hb_TToC( uVal )
   CASE cType == "N" ; RETURN Str( uVal )
   CASE cType == "O" ; RETURN "Class " + uVal:ClassName() + " object"
   CASE cType == "H" ; RETURN "Hash(" + hb_ntos( Len( uVal ) ) + ")"
   CASE cType == "P" ; RETURN "Pointer"
   ENDCASE

   RETURN "U"


STATIC FUNCTION __dbgObjGetValue( oObject, cVar, lCanAcc )

   LOCAL xResult
   LOCAL oErr

   IFFAIL( NIL )
   BEGIN SEQUENCE WITH {|| Break() }
      xResult := __dbgSENDMSG( t_oDebugger:nProcLevel, oObject, cVar )
      lCanAcc := .T.
   RECOVER
      BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }
         /* Try to access variables using class code level */
         xResult := __dbgSENDMSG( 0, oObject, cVar )
         lCanAcc := .T.
      RECOVER USING oErr
         xResult := oErr:description
         lCanAcc := .F.
      END SEQUENCE
   END SEQUENCE

   RETURN xResult


#if 0
STATIC FUNCTION __dbgObjSetValue( oObject, cVar, xValue )

   LOCAL oErr

   IFFAIL( NIL )
   BEGIN SEQUENCE WITH {|| Break() }
      __dbgSENDMSG( t_oDebugger:nProcLevel, oObject, "_" + cVar, xValue )
   RECOVER
      BEGIN SEQUENCE WITH {| oErr | Break( oErr ) }
         /* Try to access variables using class code level */
         __dbgSENDMSG( 0, oObject, "_" + cVar, xValue )
      RECOVER USING oErr
         t_oDebugger:GUIMessageBox( "__dbgObjSetValue: error (", oErr:description, ")" )   // GUI: message box info
      END SEQUENCE
   END SEQUENCE

   RETURN xValue
#endif


STATIC FUNCTION __dbgPathToArray( cList )
   LOCAL aList := {}
   LOCAL cSep := hb_osPathListSeparator()
   LOCAL cDirSep := hb_osPathDelimiters()
   LOCAL nPos
   IF cList != NIL
      DO WHILE ( nPos := At( cSep, cList ) ) > 0
         AAdd( aList, Left( cList, nPos - 1 ) )        // Add a new element
         cList := SubStr( cList, nPos + 1 )
      ENDDO
      AAdd( aList, cList )              // Add final element
      /* Strip ending delimiters */
      AEval( aList, {| x, i | Iif( Right( x, 1 ) $ cDirSep, aList[ i ] := hb_StrShrink( x ), ) } )
   ENDIF
RETURN aList


STATIC FUNCTION __dbgTextToArray( cString )
   RETURN hb_ATokens( StrTran( cString, Chr( 13 ) ), Chr( 10 ) )


FUNCTION HMG_Debugger()
   IF t_oDebugger == NIL
      t_oDebugger := HMGDebugger():New()
   ENDIF
RETURN t_oDebugger



/*********************************************************************************
   Get --> BreakPoints(), Watch(), Vars()
*********************************************************************************/


METHOD GetBreakPoints() CLASS HMGDebugger
   IFFAIL( {} )
RETURN __dbgGetBreakPoints( ::pInfo )


METHOD GetWatch() CLASS HMGDebugger
   RETURN ::aWatch


METHOD GetVars( aRawVars, nStackLevel, lShowPublics, lShowPrivates, lShowStatics, lShowLocals ) CLASS HMGDebugger // updates monitored variables
   LOCAL nCount
   LOCAL n
   LOCAL m
   LOCAL i
   LOCAL xValue
   LOCAL cType
   LOCAL cName
   LOCAL aVars
   LOCAL aBVars
   LOCAL hSkip
   LOCAL lShowGlobals
   LOCAL lShowAllGlobals

   hb_default( @aRawVars,      {}  )
   hb_default( @nStackLevel,    1  )
   hb_default( @lShowPublics,  .T. )
   hb_default( @lShowPrivates, .T. )
   hb_default( @lShowStatics,  .T. )
   hb_default( @lShowLocals,   .T. )

   aBVars := {}

   IF lShowPublics
      nCount := __mvDbgInfo( HB_MV_PUBLIC )
      FOR n := nCount TO 1 STEP -1
         xValue := __mvDbgInfo( HB_MV_PUBLIC, n, @cName )
         AAdd( aBVars, { cName, xValue, "Public", 0 } )
      NEXT
   ENDIF

   IF lShowPrivates
      /* CA-Cl*pper shows only local private variables in monitor
       * We are marking non local private variables with "GLOBAL" text
       *    HB_MV_PRIVATE_GLOBAL --> PRIVATE created outside of current function/procedure
       *    HB_MV_PRIVATE_LOCAL  --> PRIVATE created in current function/procedure
       */
      nCount := __mvDbgInfo( HB_MV_PRIVATE )
      IF nCount > 0
         m := __mvDbgInfo( HB_MV_PRIVATE_LOCAL, ::nProcLevel )
         hSkip := { => }
         hb_HAllocate( hSkip, nCount )
         FOR n := nCount TO 1 STEP -1
            xValue := __mvDbgInfo( HB_MV_PRIVATE, n, @cName )
            IF ! cName $ hSkip
               AAdd( aBVars, { cName, xValue, Iif( m > 0, "Private LOCAL", "Private GLOBAL" ), Iif( m > 0, ::nProcLevel, 0 ) } )
               hSkip[ cName ] := NIL
            ENDIF
            --m
         NEXT
      ENDIF
   ENDIF

   IF (::pInfo != NIL) .AND. ::aProcStack[ nStackLevel ][ CSTACK_LINE ] != NIL

      lShowGlobals := .T.
      lShowAllGlobals := .T.

      IF lShowGlobals
         cName := ::aProcStack[ nStackLevel ][ CSTACK_MODULE ]
         FOR n := 1 TO Len( ::aModules )
            IF ! lShowAllGlobals
               IF ! hb_FileMatch( ::aModules[ n ][ MODULE_NAME ], cName )
                  LOOP
               ENDIF
            ENDIF
            aVars := ::aModules[ n ][ MODULE_GLOBALS ]
            FOR m := 1 TO Len( aVars )
AAdd( aVars[ m ], ::aProcStack[ m ][ CSTACK_LEVEL ] )
               AAdd( aBVars, aVars[ m ] )
            NEXT
            IF ! lShowAllGlobals
               aVars := ::aModules[ n ][ MODULE_EXTERNGLOBALS ]
               FOR m := 1 TO Len( aVars )
AAdd( aVars[ m ], ::aProcStack[ m ][ CSTACK_LEVEL ] )
                  AAdd( aBVars, aVars[ m ] )
               NEXT
            ENDIF
         NEXT
      ENDIF

      IF lShowStatics
         cName := ::aProcStack[ nStackLevel ][ CSTACK_MODULE ]
         n := AScan( ::aModules, {| a | hb_FileMatch( a[ MODULE_NAME ], cName ) } )
         IF n > 0
            aVars := ::aModules[ n ][ MODULE_STATICS ]
            FOR m := 1 TO Len( aVars )
AAdd( aVars[ m ], ::aProcStack[ m ][ CSTACK_LEVEL ] )
               AAdd( aBVars, aVars[ m ] )
            NEXT
         ENDIF
         aVars := ::aProcStack[ nStackLevel ][ CSTACK_STATICS ]
         FOR n := 1 TO Len( aVars )
AAdd( aVars[ n ], ::aProcStack[ n ][ CSTACK_LEVEL ] )
            AAdd( aBVars, aVars[ n ] )
         NEXT
      ENDIF

      IF lShowLocals
         aVars := ::aProcStack[ nStackLevel ][ CSTACK_LOCALS ]
         FOR n := 1 TO Len( aVars )
            cName := aVars[ n ][ VAR_NAME ]
            m := AScan( aBVars, ; // Is there another var with this name ?
            {| aVar | aVar[ VAR_NAME ] == cName .AND. Left( aVar[ VAR_TYPE ], 1 ) == "S" } )
            IF m > 0
               aBVars[ m ] := aVars[ n ]
            ELSE
               AAdd( aBVars, aVars[ n ] )
            ENDIF
         NEXT
      ENDIF
   ENDIF

  /*
   * Creates an array with info of the variables:
   *    { { cProcLevel, cType, cVarName, cValType, cValue }, ... }
   *
   * aBVars is useful for set/get the value of a variable:
   *    aVarInfo := ::VarGetInfo( aBVars[ i ] )
   *    xValue := ::VarGetValue( aBVars[ i ] )
   *    ::VarSetValue( aBVars[ i ], xValue )
   */

   aVars := {}
   FOR i := 1 TO Len( aBVars )
      cType := Left( aBVars [i] [ VAR_TYPE ], 1 )
      xValue := ::VarGetValue( aBVars [i] )
      DO CASE
         CASE cType == "G"
            AAdd( aVars, { __dbgValToStr( aBVars [i] [ VAR_LEVEL ] ),     "Global", aBVars [i] [ VAR_NAME ], ValType( xValue ), __dbgValToStr( xValue ) } )
         CASE cType == "L"
            AAdd( aVars, { __dbgValToStr( aBVars [i] [ VAR_LEVEL ] ),     "Local",  aBVars [i] [ VAR_NAME ], ValType( xValue ), __dbgValToStr( xValue ) } )
         CASE cType == "S"
            AAdd( aVars, { __dbgValToStr( aBVars [i] [ VAR_LEVEL + 1 ] ), "STATIC", aBVars [i] [ VAR_NAME ], ValType( xValue ), __dbgValToStr( xValue ) } )
         OTHERWISE
            AAdd( aVars, { __dbgValToStr( aBVars [i] [ VAR_LEVEL ] ), aBVars [i] [ VAR_TYPE ], aBVars [i] [ VAR_NAME ], ValType( xValue ), __dbgValToStr( xValue ) } )
      ENDCASE
   NEXT

   aRawVars := aBVars

RETURN aVars



#pragma BEGINDUMP
#include "hbapi.h"


typedef struct
{
   char * szModule;
   int    nLine;
   char * szFunction;
} HB_BREAKPOINT;

typedef struct
{
   int      nIndex;
   PHB_ITEM xValue;
} HB_TRACEPOINT;

typedef struct
{
   char * szName;
   char   cType;
   union
   {
      int      num;
      PHB_ITEM ptr;
   } frame;
   int nIndex;
} HB_VARINFO;

typedef struct
{
   char *       szExpr;
   PHB_ITEM     pBlock;
   int          nVars;
   char **      aVars;
   HB_VARINFO * aScopes;
} HB_WATCHPOINT;

typedef struct
{
   char *       szModule;
   char *       szFunction;
   int          nLine;
   int          nProcLevel;
   int          nLocals;
   HB_VARINFO * aLocals;
   int          nStatics;
   HB_VARINFO * aStatics;
} HB_CALLSTACKINFO;

typedef struct
{
   HB_BOOL bQuit;
   HB_BOOL bGo;
   HB_BOOL bInside;
   int     nBreakPoints;
   HB_BREAKPOINT * aBreak;
   int nTracePoints;
   HB_TRACEPOINT * aTrace;
   int nWatchPoints;
   HB_WATCHPOINT * aWatch;
   HB_BOOL         bTraceOver;
   int     nTraceLevel;
   HB_BOOL bNextRoutine;
   HB_BOOL bCodeBlock;
   HB_BOOL bToCursor;
   int     nToCursorLine;
   char *  szToCursorModule;
   int     nProcLevel;
   int     nCallStackLen;
   HB_CALLSTACKINFO * aCallStack;
   HB_BOOL bCBTrace;
   HB_BOOL ( * pFunInvoke )( void );
   HB_BOOL bInitGlobals;
   HB_BOOL bInitStatics;
   HB_BOOL bInitLines;
} HB_DEBUGINFO;


//        __dbgResetRunFlags( pInfo )
HB_FUNC ( __DBGRESETRUNFLAGS )
{
   HB_DEBUGINFO * info = ( HB_DEBUGINFO * ) hb_parptr( 1 );

   if( info )
   {  if( info->bToCursor )
          hb_xfree( info->szToCursorModule );
      info->bGo          = HB_FALSE;
      info->bTraceOver   = HB_FALSE;
      info->bNextRoutine = HB_FALSE;
      info->bToCursor    = HB_FALSE;
   }
}


#pragma ENDDUMP
