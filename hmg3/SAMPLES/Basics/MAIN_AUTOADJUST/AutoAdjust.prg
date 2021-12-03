* AutoAdjust (c) 2007-2015 MigSoft / Danny / Pablo César
*-------------------------------------------------------*

Function AutoAdjust( cForm )
Local hWnd := GetFormHandle( cForm )

Local i,;                    // From no
      k,;                    // Control no                  
      ParentForm,;  
      ControlCount,; 
      ControlName,; 
      ControlType,; 
      nWidth,; 
      nHeight,; 
      lvisible := .T.,; 
      nDivw,; 
      nDivh
      
IF GetDesktopWidth() < GetWindowWidth ( hWnd )
   nWidth := GetDesktopWidth()
ELSE
   nWidth := GetWindowWidth ( hWnd )
ENDIF

IF GetDesktopHeight() < GetWindowHeight ( hWnd )
   nHeight := GetDesktopHeight()
ELSE
   nHeight := GetWindowHeight( hWnd )
ENDIF

IF IsWindowVisible( hWnd ) .AND. ! IsAppXPThemed()
   HideWindow ( hWnd )
ELSE
   lvisible := .F.
ENDIF

i := aScan ( _HMG_SYSDATA[67], hWnd )

ParentForm := _HMG_SYSDATA[66] [i]

IF _HMG_SYSDATA[ 92, i ] > 0 .AND. _HMG_SYSDATA[ 91, i ] > 0
   nDivw := nWidth  / _HMG_SYSDATA[ 92, i]
   nDivh := nHeight / _HMG_SYSDATA[ 91, i]
ELSE
   nDivw := 1
   nDivh := 1
ENDIF

ControlCount := LEN ( _HMG_SYSDATA[ 3 ] )

FOR k := 1 To ControlCount
    ControlName := _HMG_SYSDATA[ 2, k ]
    
    IF _IsControlDefined ( ControlName, ParentForm )
       ControlType := _HMG_SYSDATA[ 1, k ]
    
       IF !EMPTY( ControlName ) .AND. !( ControlType $ "MENU,HOTKEY,TOOLBAR,MESSAGEBAR,ITEMMESSAGE,TIMER" )
    
          DO CASE
             CASE ControlType $ "RADIOGROUP,TEXT,BUTTON"
                  _SetControlSizePos( ControlName, ParentForm,;
                   _GetControlRow( ControlName, ParentForm ) * nDivh, ;   // row
                   _GetControlCol ( ControlName, ParentForm ) * nDivw ,;  // column
                   _GetControlWidth( ControlName, ParentForm ) * nDivw,;  // with
                   _GetControlHeight ( ControlName, ParentForm ) )        // height
                
             CASE ControlType == "SLIDER"
                  _SetControlSizePos ( ControlName, ParentForm,;
                  _GetControlRow ( ControlName, ParentForm ) * nDivh, _GetControlCol ( ControlName, ParentForm ) * nDivw,;
                  _GetControlWidth ( ControlName, ParentForm ) * nDivw, _GetControlHeight ( ControlName, ParentForm ) * nDivh )
            
             CASE ControlType == "STATUSBAR"  
                  // do nothing
    
             CASE !ControlType $ "TOOLBUTTON"
                  _SetControlSizePos ( ControlName, ParentForm,;
                  _GetControlRow ( ControlName, ParentForm ) * nDivh, _GetControlCol ( ControlName, ParentForm ) * nDivw,;
                  _GetControlWidth ( ControlName, ParentForm ) * nDivw, _GetControlHeight ( ControlName, ParentForm ) * nDivh )
          OTHERWISE
             IF EMPTY( _HMG_SYSDATA[ 28, k ] )
                _SetFontSize ( ControlName, ParentForm , 8 * nDivh )
             ELSE
                _SetFontSize ( ControlName, ParentForm , _HMG_SYSDATA[28] [k] * nDivh )
             ENDIF
          ENDCASE
       ENDIF
    ENDIF
NEXT k

_HMG_SYSDATA[92] [i] := nWidth
_HMG_SYSDATA[91] [i] := nHeight

IF lvisible
   ShowWindow ( hWnd )
ENDIF
Return Nil

FUNCTION ISAPPXPTHEMED()
RETURN ( OS_ISWINXP_OR_LATER() ;     // <= hrb\contrib/hbwin/legacycv.c
         .AND. IsAppThemed() )       // <= HMG\h_window.prg