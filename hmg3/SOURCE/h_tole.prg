/*
* Harbour Project source code:
* Compatibility calls.
*
* Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
* www - http://harbour-project.org
*
*/

MEMVAR _HMG_SYSDATA

#include "hmg.ch"

#define HB_CLS_NOTOBJECT  /* avoid definition of method: INIT */

#include "hbclass.ch"

#include "common.ch"
#include "error.ch"

#define EG_OLEEXCEPTION 1001   // Harbour constant (..\contrib\hbwin\legacy.prg)

__THREAD STATIC s_bBreak := { | oError | Break( oError ) }

STATIC PROCEDURE Throw( oError )
   LOCAL lError := Eval( ErrorBlock(), oError )
   IF ! ISLOGICAL( lError ) .OR. lError
      __ErrInHandler()
   ENDIF
   Break( oError )

STATIC FUNCTION ThrowOpError( nSubCode, cOperator, ... )
   LOCAL oError

   oError := ErrorNew()
   oError:Args          := { ... }
   oError:CanDefault    := .F.
   oError:CanRetry      := .F.
   oError:CanSubstitute := .T.
   oError:Description   := "argument error"
   oError:GenCode       := EG_ARG
   oError:Operation     := cOperator
   oError:Severity      := ES_ERROR
   oError:SubCode       := nSubCode
   oError:SubSystem     := "BASE"

   RETURN Throw( oError )

CREATE CLASS TOLEAUTO FROM WIN_OLEAUTO
   /* TODO: Implement compatibility to the required extent */
   VAR cClassName
   METHOD New( xOle, cClass )
   METHOD hObj( xOle )

   METHOD OleValuePlus( xArg )            OPERATOR "+"
   METHOD OleValueMinus( xArg )           OPERATOR "-"
   METHOD OleValueMultiply( xArg )        OPERATOR "*"
   METHOD OleValueDivide( xArg )          OPERATOR "/"
   METHOD OleValueModulus( xArg )         OPERATOR "%"
   METHOD OleValuePower( xArg )           OPERATOR "^"
   METHOD OleValueInc()                   OPERATOR "++"
   METHOD OleValueDec()                   OPERATOR "--"
   METHOD OleValueEqual( xArg )           OPERATOR "="
   METHOD OleValueExactEqual( xArg )      OPERATOR "=="
   METHOD OleValueNotEqual( xArg )        OPERATOR "!="
ENDCLASS

METHOD hObj( xOle ) CLASS TOLEAUTO

   IF PCount() > 0 .AND. xOle != NIL
      IF ISNUMBER( xOle )
         xOle := __OLEPDISP( xOle )
      ENDIF
      IF HB_ISPOINTER( xOle )
         ::__hObj := xOle
      ENDIF
   ENDIF

   RETURN ::__hObj

METHOD New( xOle, cClass ) CLASS TOLEAUTO
   LOCAL hOle
   LOCAL oError

   IF ISNUMBER( xOle )
      xOle := __OLEPDISP( xOle )
   ENDIF

   IF HB_ISPOINTER( xOle )
      ::__hObj := xOle
      IF ISCHARACTER( cClass )
         ::cClassName := cClass
      ELSE
         ::cClassName := hb_ntos( win_P2N( xOle ) )
      ENDIF
   ELSEIF ISCHARACTER( xOle )
      hOle := __OleCreateObject( xOle )
      IF ! Empty( hOle )
         ::__hObj := hOle
         ::cClassName := xOle
      ELSE
         oError := ErrorNew()
         oError:Args          := hb_AParams()
         oError:CanDefault    := .F.
         oError:CanRetry      := .F.
         oError:CanSubstitute := .T.
         oError:Description   := win_oleErrorText()
         oError:GenCode       := EG_OLEEXCEPTION
         oError:Operation     := ProcName()
         oError:Severity      := ES_ERROR
         oError:SubCode       := -1
         oError:SubSystem     := "TOleAuto"

         RETURN Throw( oError )
      ENDIF
   ENDIF

   RETURN Self

FUNCTION CreateObject( xOle, cClass )
   RETURN TOleAuto():New( xOle, cClass )

FUNCTION GetActiveObject( xOle, cClass )
   LOCAL o := TOleAuto():New()
   LOCAL hOle
   LOCAL oError

   IF ISNUMBER( xOle )
      xOle := __OLEPDISP( xOle )
   ENDIF

   IF HB_ISPOINTER( xOle )
      o:__hObj := xOle
      IF ISCHARACTER( cClass )
         o:cClassName := cClass
      ELSE
         o:cClassName := hb_ntos( win_P2N( xOle ) )
      ENDIF
   ELSEIF ISCHARACTER( xOle )
      hOle := __OleGetActiveObject( xOle )
      IF ! Empty( hOle )
         o:__hObj := hOle
         o:cClassName := xOle
      ELSE
         oError := ErrorNew()
         oError:Args          := hb_AParams()
         oError:CanDefault    := .F.
         oError:CanRetry      := .F.
         oError:CanSubstitute := .T.
         oError:Description   := win_oleErrorText()
         oError:GenCode       := EG_OLEEXCEPTION
         oError:Operation     := ProcName()
         oError:Severity      := ES_ERROR
         oError:SubCode       := -1
         oError:SubSystem     := "TOleAuto"

         RETURN Throw( oError )
      ENDIF
   ENDIF

   RETURN o

METHOD OleValuePlus( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ::OleValue + xArg
   RECOVER
      RETURN ThrowOpError( 1081, "+", Self, xArg )
   END SEQUENCE

   RETURN xRet

METHOD OleValueMinus( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ::OleValue - xArg
   RECOVER
      RETURN ThrowOpError( 1082, "-", Self, xArg )
   END SEQUENCE

   RETURN xRet

METHOD OleValueMultiply( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ::OleValue * xArg
   RECOVER
      RETURN ThrowOpError( 1083, "*", Self, xArg )
   END SEQUENCE

   RETURN xRet

METHOD OleValueDivide( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ::OleValue / xArg
   RECOVER
      RETURN ThrowOpError( 1084, "/", Self, xArg )
   END SEQUENCE

   RETURN xRet

METHOD OleValueModulus( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ::OleValue % xArg
   RECOVER
      RETURN ThrowOpError( 1085, "%", Self, xArg )
   END SEQUENCE

   RETURN xRet

METHOD OleValuePower( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ::OleValue ^ xArg
   RECOVER
      RETURN ThrowOpError( 1088, "^", Self, xArg )
   END SEQUENCE

   RETURN xRet

METHOD OleValueInc() CLASS TOLEAUTO

   BEGIN SEQUENCE WITH s_bBreak
      ++::OleValue
   RECOVER
      RETURN ThrowOpError( 1086, "++", Self )
   END SEQUENCE

   RETURN Self

METHOD OleValueDec() CLASS TOLEAUTO

   BEGIN SEQUENCE WITH s_bBreak
      --::OleValue
   RECOVER
      RETURN ThrowOpError( 1087, "--", Self )
   END SEQUENCE

   RETURN Self

METHOD OleValueEqual( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ( ::OleValue = xArg ) /* NOTE: Intentionally using '=' operator. */
   RECOVER
      RETURN ThrowOpError( 1089, "=", Self, xArg )
   END SEQUENCE

   RETURN xRet

METHOD OleValueExactEqual( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ( ::OleValue == xArg )
   RECOVER
      RETURN ThrowOpError( 1090, "==", Self, xArg )
   END SEQUENCE

   RETURN xRet

METHOD OleValueNotEqual( xArg ) CLASS TOLEAUTO
   LOCAL xRet

   BEGIN SEQUENCE WITH s_bBreak
      xRet := ( ::OleValue != xArg )
   RECOVER
      RETURN ThrowOpError( 1091, "!=", Self, xArg )
   END SEQUENCE

   RETURN xRet
