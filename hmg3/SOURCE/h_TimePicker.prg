/*----------------------------------------------------------------------------
 HMG Source File --> h_TimePicker.prg

 Copyright 2012-2017 by Dr. Claudio Soto (from Uruguay).

 mail: <srvet@adinet.com.uy>
 blog: http://srvet.blogspot.com

 Permission to use, copy, modify, distribute and sell this software
 and its documentation for any purpose is hereby granted without fee,
 provided that the above copyright notice appear in all copies and
 that both that copyright notice and this permission notice appear
 in supporting documentation.
 It is provided "as is" without express or implied warranty.

----------------------------------------------------------------------------*/



MEMVAR _HMG_SYSDATA
#include "hmg.ch"
#include "common.ch"

*-----------------------------------------------------------------------------*
Function _DefineTimePick ( ControlName, ParentForm, x, y, w, h, cValue, ;
                           fontname, fontsize, tooltip, change, lostfocus, ;
                           gotfocus, shownone, HelpId, invisible, notabstop, ;
                           bold, italic, underline, strikeout , Field, Enter, cTimeFormat)
*-----------------------------------------------------------------------------*
LOCAL cParentForm , mVar , k
LOCAL ControlHandle
LOCAL FontHandle
LOCAL cParentTabName
LOCAL TimeValue24h
LOCAL WorkArea

   DEFAULT cValue      TO ""
   DEFAULT cTimeFormat TO _TIMELONG24H
   DEFAULT w           TO 110
   DEFAULT h           TO 24
   DEFAULT change      TO ""
   DEFAULT lostfocus   TO ""
   DEFAULT gotfocus    TO ""
   DEFAULT invisible   TO FALSE
   DEFAULT notabstop   TO FALSE
   DEFAULT shownone    TO FALSE


   If ValType ( Field ) != 'U'
      if HB_UAT ( '>', Field ) == 0
         MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " : You must specify a fully qualified field name. Program Terminated" )
      Else
         WorkArea := HB_ULEFT ( Field , HB_UAT ( '>', Field ) - 2 )
         If Select (WorkArea) != 0
            cValue := &(Field)
         EndIf
      EndIf
   EndIf

   if _HMG_SYSDATA [ 264 ] = .T.
      ParentForm := _HMG_SYSDATA [ 223 ]
      if .Not. Empty (_HMG_SYSDATA [ 224 ]) .And. ValType(FontName) == "U"
         FontName := _HMG_SYSDATA [ 224 ]
      EndIf
      if .Not. Empty (_HMG_SYSDATA [ 182 ]) .And. ValType(FontSize) == "U"
         FontSize := _HMG_SYSDATA [ 182 ]
      EndIf
   endif

   if _HMG_SYSDATA [ 183 ] > 0
      IF _HMG_SYSDATA [ 240 ] == .F.
         x := x + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
         y := y + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]]
         ParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
         cParentTabName := _HMG_SYSDATA [ 225 ]
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError("Window: "+ ParentForm + " is not defined. Program terminated" )
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError ("Control: " + ControlName + " Of " + ParentForm + " Already defined. Program terminated" )
   endif

   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm := ParentForm

   ParentForm = GetFormHandle (ParentForm)

//------------------------------------------------------------------------------------------------//

   ControlHandle := InitTimePick (ParentForm, x, y, w, h, shownone, invisible, notabstop)

   IF DateTime_SetFormat (ControlHandle, cTimeFormat) == .F.
      MsgHMGError ( "Time Picker Control: " + ControlName + " Of " + ParentForm + ": Invalid Time Format" )
   ENDIF

   IF .NOT. EMPTY (cValue)
      TimeValue24h := HMG_TimeToValue (cValue)
      SetTimePick ( ControlHandle, TimeValue24h [1], TimeValue24h [2], TimeValue24h [3])
   ENDIF

//------------------------------------------------------------------------------------------------//

   if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   Else
      FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
   endif

   If _HMG_SYSDATA [ 265 ] = .T.
      aAdd ( _HMG_SYSDATA [ 142 ] , Controlhandle )
   EndIf

   if ValType(tooltip) != "U"
      SetToolTip ( ControlHandle , tooltip , GetFormToolTipHandle (cParentForm) )
   Endif

   k := _GetControlFree()

   Public &mVar. := k

   _HMG_SYSDATA [  1 ]  [k] :=  "TIMEPICK"
   _HMG_SYSDATA [  2 ]  [k] :=  ControlName
   _HMG_SYSDATA [  3 ]  [k] :=  ControlHandle
   _HMG_SYSDATA [  4 ]  [k] :=  ParentForm
   _HMG_SYSDATA [  5 ]  [k] :=  0
   _HMG_SYSDATA [  6 ]  [k] :=  Enter
   _HMG_SYSDATA [  7 ]  [k] :=  Field
   _HMG_SYSDATA [  8 ]  [k] :=  Nil
   _HMG_SYSDATA [  9 ]  [k] :=  cTimeFormat
   _HMG_SYSDATA [ 10 ]  [k] :=  lostfocus
   _HMG_SYSDATA [ 11 ]  [k] :=  gotfocus
   _HMG_SYSDATA [ 12 ]  [k] :=  change
   _HMG_SYSDATA [ 13 ]  [k] :=  .F.
   _HMG_SYSDATA [ 14 ]  [k] :=  Nil
   _HMG_SYSDATA [ 15 ]  [k] :=  Nil
   _HMG_SYSDATA [ 16 ]  [k] :=  ""
   _HMG_SYSDATA [ 17 ]  [k] :=  {}
   _HMG_SYSDATA [ 18 ]  [k] :=  y
   _HMG_SYSDATA [ 19 ]  [k] :=  x
   _HMG_SYSDATA [ 20 ]  [k] :=  w
   _HMG_SYSDATA [ 21 ]  [k] :=  h
   _HMG_SYSDATA [ 22 ]  [k] :=  0
   _HMG_SYSDATA [ 23 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 )
   _HMG_SYSDATA [ 24 ]  [k] :=  iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 )
   _HMG_SYSDATA [ 25 ]  [k] :=  ""
   _HMG_SYSDATA [ 26 ]  [k] :=  0
   _HMG_SYSDATA [ 27 ]  [k] :=  fontname
   _HMG_SYSDATA [ 28 ]  [k] :=  fontsize
   _HMG_SYSDATA [ 29 ]  [k] :=  {bold,italic,underline,strikeout}
   _HMG_SYSDATA [ 30 ]  [k] :=  tooltip
   _HMG_SYSDATA [ 31 ]  [k] :=  cParentTabName
   _HMG_SYSDATA [ 32 ]  [k] :=  0
   _HMG_SYSDATA [ 33 ]  [k] :=  ''
   _HMG_SYSDATA [ 34 ]  [k] :=  iif (invisible,FALSE,TRUE)
   _HMG_SYSDATA [ 35 ]  [k] :=  HelpId
   _HMG_SYSDATA [ 36 ]  [k] :=  FontHandle
   _HMG_SYSDATA [ 37 ]  [k] :=  0
   _HMG_SYSDATA [ 38 ]  [k] :=  .T.
   _HMG_SYSDATA [ 39 ]  [k] :=  0
   _HMG_SYSDATA [ 40 ]  [k] :=  { NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL }

Return Nil


Procedure _DataTimePickerRefresh (i)
Local Field
   Field := _HMG_SYSDATA [ 7 ] [i]
   _SetValue ( '' , '' , &Field , i )
Return

Procedure _DataTimePickerSave (ControlName, ParentForm)
Local Field , i
   i := GetControlIndex ( ControlName , ParentForm)
   Field := _HMG_SYSDATA [ 7 ] [i]
   REPLACE &Field WITH _GetValue ( Controlname , ParentForm )
Return



//*****************************************************************************************



//---------------------------------------------------
FUNCTION HMG_GetNextTimeDigits (cTime, nValue)
//---------------------------------------------------
LOCAL cDigit, nPos
      cTime := ALLTRIM (cTime)
      nPos  := HB_UAT (":",cTime)
      IF nPos > 1
         cDigit := HB_USUBSTR (cTime, 1, nPos-1)
         IF TYPE (cDigit) == "N"
            nValue := VAL (cDigit)
            cTime  := HB_USUBSTR (cTime, nPos+1)
         ELSE
            nValue := -100
            cTime  := ""
         ENDIF
      ELSE
         nValue := -100
         cTime  := ""
      ENDIF
      // MsgDebug (cDigit, nValue, cTime)
RETURN cTime


//------------------------------------------
FUNCTION HMG_GetTimeAMPM (cTime)   // Return "am", "pm" or "", if cTime is passed by reference and exist "am" or "pm" in cTime : "am|pm" is removed from cTime.
//------------------------------------------
LOCAL nPos, nPosAM, nPosPM, cAMPM
   IF ValType (cTime) == "C"
      cTime  := HMG_LOWER (ALLTRIM(cTime))
      nPosAM := HB_UTF8RAT ("am", cTime)
      nPosPM := HB_UTF8RAT ("pm", cTime)
      IF nPosAM <> 0 .AND. nPosPM <> 0
         MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
      ELSEIF nPosAM <> 0 .OR. nPosPM <> 0
         nPos  := MAX (nPosAM, nPosPM)
         cAMPM := HB_USUBSTR (cTime, nPos, 2)
         cTime := ALLTRIM (HB_USUBSTR (cTime, 1, nPos-1))
      ELSE
         cAMPM := ""
      ENDIF
   ELSE
      MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
   ENDIF
RETURN cAMPM


//------------------------------------------
FUNCTION HMG_IsTimeAMPM (cTime) // Return .T. if cTime contains the substring "am" or "pm"
//------------------------------------------
LOCAL cAMPM := HMG_GetTimeAMPM (cTime)
   IF HMG_LOWER(cAMPM) == "am" .OR. HMG_LOWER(cAMPM) == "pm"
      RETURN .T.
   ENDIF
RETURN .F.


//------------------------------------------
FUNCTION HMG_TimeToValue (cTime)
//------------------------------------------
LOCAL cAMPM
LOCAL nHour, nMinute, nSecond

   IF ValType (cTime) == "C"
      cAMPM := HMG_GetTimeAMPM (@cTime)   //  If exist "am"|"pm" remove of cTime and return cAMPM or ""
      cTime := cTime  + ":00:"
      cTime := HMG_GetNextTimeDigits (cTime, @nHour)
      cTime := HMG_GetNextTimeDigits (cTime, @nMinute)
      cTime := HMG_GetNextTimeDigits (cTime, @nSecond)

      IF (nHour == 12) .AND. (HMG_LOWER(cAMPM) == "am")
         nHour := 0
      ENDIF
      IF (nHour < 12) .AND. HMG_LOWER(cAMPM) == "pm"
         nHour := nHour + 12
      ENDIF

      // MsgDebug (nHour, nMinute, nSecond, cAMPM)
      IF (nHour < 0 .OR. nHour > 23) .OR. (nMinute < 0 .OR. nMinute > 59) .OR. (nSecond < 0 .OR. nSecond > 59)
         MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
      ENDIF
   ELSE
      MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
   ENDIF
RETURN {nHour, nMinute, nSecond}


//-----------------------------------------------
FUNCTION HMG_ValueToTime (aValue, cTimeFormat)
//-----------------------------------------------
LOCAL cTime, cAMPM, nHour, nMinute, nSecond

   DEFAULT cTimeFormat TO _TIMELONG24H
   nHour   := aValue [1]
   nMinute := aValue [2]
   nSecond := aValue [3]

   IF (nHour < 0 .OR. nHour > 23) .OR. (nMinute < 0 .OR. nMinute > 59) .OR. (nSecond < 0 .OR. nSecond > 59)
       MsgHMGError ("Invalid Time Value. Program Terminated")
   ENDIF

   DO CASE
      CASE ALLTRIM(cTimeFormat) == ALLTRIM( _TIMELONG24H )
           cTime := STRZERO (nHour, 2) +":"+ STRZERO (nMinute, 2) +":"+ STRZERO (nSecond, 2)

      CASE ALLTRIM(cTimeFormat) == ALLTRIM( _TIMESHORT24H )
           cTime := STRZERO (nHour, 2) +":"+ STRZERO (nMinute, 2)

      CASE ALLTRIM(cTimeFormat) == ALLTRIM( _TIMELONG12H )
           IF     nHour == 0
                    cAMPM := "am"
                    nHour := 12
           ELSEIF nHour > 0 .AND. nHour < 12
                    cAMPM := "am"
           ELSEIF nHour == 12
                    cAMPM := "pm"
           ELSEIF nHour > 12
                    cAMPM := "pm"
                    nHour := nHour - 12
           ENDIF
           cTime := STRZERO (nHour, 2) +":"+ STRZERO (nMinute, 2) +":"+ STRZERO (nSecond, 2) +" "+ cAMPM

      CASE ALLTRIM(cTimeFormat) == ALLTRIM( _TIMESHORT12H )
           IF     nHour == 0
                    cAMPM := "am"
                    nHour := 12
           ELSEIF nHour > 0 .AND. nHour < 12
                    cAMPM := "am"
           ELSEIF nHour == 12
                    cAMPM := "pm"
           ELSEIF nHour > 12
                    cAMPM := "pm"
                    nHour := nHour - 12
           ENDIF
           cTime := STRZERO (nHour, 2) +":"+ STRZERO (nMinute, 2) +" "+ cAMPM

      OTHERWISE
           MsgHMGError ("Invalid Time format, must be string in format HH:MM [am|pm] or HH:MM:SS [am|pm]. Program Terminated")
   ENDCASE
RETURN cTime


//------------------------------------------------
FUNCTION HMG_TimeToTime (cTime, cNewTimeFormat)
//------------------------------------------------
LOCAL aValue   := HMG_TimeToValue (cTime)
LOCAL cNewTime := HMG_ValueToTime (aValue, cNewTimeFormat)
RETURN cNewTime
