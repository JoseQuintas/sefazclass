
#include "hmg.ch"

#define WS_BORDER           0x00800000
#define WM_SETREDRAW        0x0b

/******
*
*       Define QHTM control
*
*/
Function _DefineQhtm( ControlName, ParentForm, x, y, w, h, Value, fname, resname, fontname, fontsize, Change, lBorder, bold, italic, underline, strikeout)
Local mVar, k := 0, ControlHandle, FontHandle, nId 

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
         x  := x + _HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]]
         y  := y + _HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] 
         ParentForm := _HMG_SYSDATA [ 332 ] [_HMG_SYSDATA [ 183 ]]
         cParentTabName := _HMG_SYSDATA [ 225 ] 
      ENDIF
   EndIf

   If .Not. _IsWindowDefined (ParentForm)
      MsgHMGError(_HMG_SYSDATA [ 136 ][1]+ ParentForm + _HMG_SYSDATA [ 136 ][2])
   Endif

   If _IsControlDefined (ControlName,ParentForm)
      MsgHMGError (_HMG_SYSDATA [ 136 ][4] + ControlName + _HMG_SYSDATA [ 136 ][5] + ParentForm + _HMG_SYSDATA [ 136 ][6])
   endif
   
   mVar := '_' + ParentForm + '_' + ControlName

   cParentForm = ParentForm

   ParentForm = GetFormHandle (ParentForm)
   
   nId := _GetId()

   ControlHandle := CreateQHTM(ParentForm, nId, IIF (lBorder ==.T., WS_BORDER, 0), y, x, w, h)

   if ValType(fontname) != "U" .and. ValType(fontsize) != "U"
      FontHandle := _SetFont (ControlHandle,FontName,FontSize,bold,italic,underline,strikeout)
   Else
     FontHandle := _SetFont (ControlHandle,_HMG_SYSDATA [ 342 ],_HMG_SYSDATA [ 343 ],bold,italic,underline,strikeout)
   endif


   If ( Valtype( Value ) == 'C' )
      SetWindowText( ControlHandle, Value )
   ElseIf ( Valtype( fname ) == 'C' )
      QHTM_LoadFile( ControlHandle, fname )
   ElseIf ( Valtype( resname ) == 'C' )
      QHTM_LoadRes( ControlHandle, resname )
   Endif

   QHTM_FormCallBack( ControlHandle )

   k := _GetControlFree()
   Public &mVar. := k

   _HMG_SYSDATA [  1 ]   [k] := 'QHTM'
   _HMG_SYSDATA [  2 ]   [k] := ControlName
   _HMG_SYSDATA [  3 ]   [k] := ControlHandle
   _HMG_SYSDATA [  4 ]   [k] := ParentForm
   _HMG_SYSDATA [  5 ]   [k] := nId
   _HMG_SYSDATA [  6 ]   [k] := ""
   _HMG_SYSDATA [  7 ]   [k] := {}
   _HMG_SYSDATA [  8 ]   [k] := Value
   _HMG_SYSDATA [  9 ]   [k] := ""
   _HMG_SYSDATA [ 10 ]   [k] := ""
   _HMG_SYSDATA [ 11 ]   [k] := ""
   _HMG_SYSDATA [ 12 ]   [k] := Change
   _HMG_SYSDATA [ 13 ]   [k] := .F.
   _HMG_SYSDATA [ 14 ]   [k] := NIL
   _HMG_SYSDATA [ 15 ]   [k] := NIL
   _HMG_SYSDATA [ 16 ]   [k] := ""
   _HMG_SYSDATA [ 17 ]   [k] := {}
   _HMG_SYSDATA [ 18 ]   [k] := x
   _HMG_SYSDATA [ 19 ]   [k] := y
   _HMG_SYSDATA [ 20 ]   [k] := w
   _HMG_SYSDATA [ 21 ]   [k] := h
   _HMG_SYSDATA [ 22 ]   [k] := 0
   _HMG_SYSDATA [ 23 ]   [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 333 ] [_HMG_SYSDATA [ 183 ]] , -1 ) 
   _HMG_SYSDATA [ 24 ]   [k] := iif ( _HMG_SYSDATA [ 183 ] > 0 ,_HMG_SYSDATA [ 334 ] [_HMG_SYSDATA [ 183 ]] , -1 ) 
   _HMG_SYSDATA [ 25 ]   [k] := ''
   _HMG_SYSDATA [ 26 ]   [k] := 0
   _HMG_SYSDATA [ 27 ]   [k] := fontname
   _HMG_SYSDATA [ 28 ]   [k] := fontsize
   _HMG_SYSDATA [ 29 ]   [k] := {bold,italic,underline,strikeout}
   _HMG_SYSDATA [ 30 ]   [k] := ''
   _HMG_SYSDATA [ 31 ]   [k] := 0
   _HMG_SYSDATA [ 32 ]   [k] := 0
   _HMG_SYSDATA [ 33 ]   [k] := ''
   _HMG_SYSDATA [ 34 ]   [k] := .T.  
   _HMG_SYSDATA [ 35 ]   [k] := 0
   _HMG_SYSDATA [ 36 ]   [k] := ''
   _HMG_SYSDATA [ 37 ]   [k] := 0
   _HMG_SYSDATA [ 38 ]   [k] := .T.
   _HMG_SYSDATA [ 39 ]   [k] := 0
   _HMG_SYSDATA [ 40 ]   [k] := ''

Return Nil



/******
*
*       QHTM_LoadFromVal( ControlName, ParentForm, cValue )
*
*       Load web-page from variable
*
*/
Procedure QHTM_LoadFromVal( ControlName, ParentForm, cValue )
Local nHandle := GetControlHandle( ControlName, ParentForm )

If ( nHandle > 0 )
   SetWindowText( nHandle, cValue )
Endif

Return

/******
*
*       QHTM_LoadFromFile( ControlName, ParentForm, cFile )
*
*       Load web-page from file
*
*/
Procedure QHTM_LoadFromFile( ControlName, ParentForm, cFile )
Local nHandle := GetControlHandle( ControlName, ParentForm )

If ( nHandle > 0 )
   QHTM_LoadFile( nHandle, cFile )
Endif

Return

/******
*
*       QHTM_LoadFromRes( ControlName, ParentForm, cResName )
*
*       Load web-page from resource
*
*/
Procedure QHTM_LoadFromRes( ControlName, ParentForm, cResName )
Local nHandle := GetControlHandle( ControlName, ParentForm )

If ( nHandle > 0 )
   QHTM_LoadRes( nHandle, cResName )
Endif

Return

/******
*
*       QHTM_GetLink( lParam )
*
*       Receive QHTM link
*
*/
Function QHTM_GetLink( lParam )
Local cLink := QHTM_GetNotify( lParam )

QHTM_SetReturnValue( lParam, .F. )

Return cLink

/******
*
*       QHTM_ScrollPos( nHandle, nPos )
*
*       nHandle - descriptor of QHTM
*       nPos - old/new position of scrollbar
*       
*       Get/Set position of scrollbar QHTM
*
*/
Function QHTM_ScrollPos( nHandle, nPos )
Local nParamCount := PCount()

Switch nParamCount

   Case 0  
     nPos := 0
     Exit

   Case 1

     If HB_ISNUMERIC( nHandle )
        nPos := QHTM_GetScrollPos( nHandle )
     Endif
     Exit

   Case 2

     If ( HB_ISNUMERIC( nHandle ) .and. HB_ISNUMERIC( nPos ) )
        QHTM_SetScrollPos( nHandle, nPos )
     Else
        nPos := 0
     Endif
   
End Switch

Return nPos

/******
*
*       QHTM_ScrollPercent( nHandle, nPercent )
*
*       nHandle  - descriptor of QHTM
*       nPercent - old/new position of scrollbar (in percentage)
*       
*       Get/Set position of scrollbar QHTM
*
*/
Function QHTM_ScrollPercent( nHandle, nPercent )
Local nParamCount := PCount(), ;
      nHeight                , ;
      aSize                  , ;
      nPos

If HB_ISNUMERIC( nHandle )

   nHeight := GetWindowHeight( nHandle )
   aSize := QHTM_GetSize( nHandle )
            
   If ( aSize[ 2 ] > nHeight )
      aSize[ 2 ] -= nHeight
    Endif
    
Endif

Switch nParamCount

   Case 0
     nPercent := 0
     Exit

   Case 1
   
     nPos  := QHTM_GetScrollPos( nHandle )
     nPercent := Min( Round( ( ( nPos / aSize[ 2 ] ) * 100 ), 2 ), 100.00 )
     Exit

   Case 2

     If HB_ISNUMERIC( nPercent )
        nPos := Round( ( nPercent * aSize[ 2 ] * 0.01 ), 0 )
        QHTM_SetScrollPos( nHandle, nPos )
     Else
        nPercent := 0
     Endif

End Switch

Return nPercent

/******
*
*       QHTM_EnableUpdate( ControlName, ParentForm, lEnable )
*
*       Enable/disable redraw of control
*
*/
Procedure QHTM_EnableUpdate( ControlName, ParentForm, lEnable )

IF Valtype(lEnable) == "U" 
   lEnable := .T.
ENDIF

If ( PCount() < 2 )
   Return
Endif
 
SendMessage( GetControlHandle( ControlName, ParentForm ), WM_SETREDRAW, Iif( lEnable, 1, 0 ), 0 )

Return


********************************************************************************************

Function QHTM_Zoom ( ControlName, ParentForm, nLevel )
   QHTM_SetZoomLevel(GetControlHandle( ControlName, ParentForm ), nLevel)
Return Nil
