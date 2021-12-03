/*
  CSBox ( Combined Search Box )

  Started by Bicahi Esgici <esgici@gmail.com>

  Enhanced by S.Rathinagiri <srgiri@dataone.in>

  Revised by Grigory Filatov <gfilatov@inbox.ru>
*/

MEMVAR _HMG_SYSDATA
#include "hmg.ch"


PROC _DefineComboSearchBox( cCSBoxName,; 
                            cCSBoxParent,; 
                            cCSBoxCol,; 
                            cCSBoxRow,; 
                            cCSBoxWidth,; 
                            cCSBoxHeight,; 
                            cCSBoxValue,;
                            cFontName,; 
                            nFontSize,; 
                            cToolTip,; 
                            nMaxLenght,;
                            lUpper,; 
                            lLower,; 
                            lNumeric,;
                            bLostFocus,; 
                            bGotFocus,; 
                            bEnter,;
                            lRightAlign,; 
                            nHelpId,; 
                            lBold,; 
                            lItalic,; 
                            lUnderline,; 
                            aBackColor,; 
                            aFontColor,; 
                            lNoTabStop,; 
                            aArray,;
                            lAnyWhere,;
                            nDropHeight,;
                            lAdditive,;
                            nRowOffset,;
                            nColOffset;
                            )

   LOCAL   cParentName := ''

   DEFAULT cCSBoxWidth  := 120
   DEFAULT cCSBoxHeight := 24
   DEFAULT cCSBoxValue  := ""
   DEFAULT bGotFocus    := ""
   DEFAULT bLostFocus   := ""
   DEFAULT nMaxLenght   := 255
   DEFAULT lUpper       := .F.
   DEFAULT lLower       := .F.
   DEFAULT lNumeric     := .F.
   DEFAULT bEnter       := ""
   DEFAULT lAnyWhere    := .F.
   DEFAULT nDropHeight  := 0
   DEFAULT lAdditive := .f.
   DEFAULT nRowOFfset := 0
   DEFAULT nColOFfset := 0
   
   
   IF _HMG_SYSDATA [ 264 ] = .T.                  // _HMG_BeginWindowActive
      cParentName := _HMG_SYSDATA [ 223 ]         // _HMG_ActiveFormName 
   ELSE
      cParentName := cCSBoxParent
   ENDIF

 _DefineTextBox( cCSBoxName,;
               cCSBoxParent,;
               cCSBoxcol,;
               cCSBoxRow,;
               cCSBoxWidth,;
               cCSBoxheight,;
               cCSBoxValue,;
               cFontName,;
               nFontSize,;
               cToolTip,;
               nMaxLenght,;
               lUpper,;
               lLower,;
               lNumeric,;
               .f.,;
				   bLostFocus,;
				   bGotFocus,;
				   {||CreateCSBox( cParentName, cCSBoxName, aArray, lAnyWhere, nDropHeight, lAdditive, nRowOFfset, nColOFfset )},;
				   bEnter,;
				   lRightAlign,;
				   nHelpId,;
				   .f.,;
				   lBold,;
				   lItalic,;
				   lUnderline,;
				   .f.,;
				   ,;
				   aBackColor,;
				   aFontColor,;
				   .f.,;
				   iif(lNoTabStop,.f.,.t.);
				   )   
   
   
   
   && DEFINE TEXTBOX &cCSBoxName
      && PARENT        &cCSBoxParent
      && ROW           cCSBoxRow
      && COL           cCSBoxCol
      && WIDTH         cCSBoxWidth
      && HEIGHT        cCSBoxHeight
      && VALUE         cCSBoxValue
      && FONTNAME      cFontName
      && FONTSIZE      nFontSize
      && TOOLTIP       cToolTip
      && MAXLENGTH     nMaxLenght
      && UPPERCASE     lUpper
      && LOWERCASE     lLower
      && NUMERIC       lNumeric
      && ONLOSTFOCUS   bLostFocus
      && ONGOTFOCUS    bGotFocus
      && ONENTER       bEnter
      && ONCHANGE      CreateCSBox( cParentName, cCSBoxName, aArray, lAnyWhere, nDropHeight )
      && RIGHTALIGN    lRightAlign
      && HELPID        nHelpId
      && FONTBOLD      lBold
      && FONTITALIC    lItalic
      && FONTUNDERLINE lUnderline
      && BACKCOLOR     aBackColor
      && FONTCOLOR     aFontColor
      && TABSTOP       lNoTabStop
   && END TEXTBOX

RETURN // _DefineComboSearchBox()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.

STATIC PROC CreateCSBox( cParentName, cCSBoxName, aItems, lAnyWhere , nDropHeight, lAdditive, nRowOFfset, nColOFfset ) 

   LOCAL nFormRow       := thisWindow.row
   LOCAL nFormCol       := thisWindow.col
   LOCAL nControlRow    := this.row + 1
   LOCAL nControlCol    := this.col + 1
   LOCAL nControlWidth  := this.width
   LOCAL nControlHeight := this.height
   LOCAL cCurValue      := this.value
   LOCAL aResults       := {}
   LOCAL nContIndx      := GetControlIndex( this.name, thiswindow.name )   
   LOCAL result         := 0
   LOCAL nItemNo        := 0
   LOCAL nListBoxHeight := 0
   LOCAL caret          := this.CaretPos

   LOCAL cCSBxName := 'frm' + cCSBoxName
   DEFAULT lAdditive := .f.
   PRIVATE lRetainItem := lAdditive

   IF !EMPTY(cCurValue)

      IF _HMG_SYSDATA [ 23, nContIndx ] # -1                     // _HMG_aControlContainerRow
         nControlRow += _HMG_SYSDATA [  23, nContIndx ]          // _HMG_aControlContainerRow
         nControlCol += _HMG_SYSDATA [  24, nContIndx ]          // _HMG_aControlContainerCol 
      ENDIF   


      FOR nItemNo := 1 TO HMG_LEN(aItems)
         IF HMG_UPPER( aItems[ nItemNo ] ) == HMG_UPPER( cCurValue )
            EXIT // item selected already
         ENDIF
         IF lAnyWhere == .T.
            IF HB_UAT(HMG_UPPER(cCurValue),HMG_UPPER(aItems[nItemNo])) > 0
               AADD(aResults,aItems[ nItemNo ])
            ENDIF            
         ELSE
            IF HMG_UPPER( HB_ULEFT( aItems[ nItemNo ], HMG_LEN(cCurValue))) == HMG_UPPER(cCurValue)
               AADD(aResults,aItems[ nItemNo ])
            ENDIF
         ENDIF   
      NEXT nItemNo

      IF HMG_LEN( aResults ) > 0

         nListBoxHeight := MAX(MIN((HMG_LEN(aResults) * 16)+6,thiswindow.height - nControlRow - nControlHeight - 14),40)
         
         DEFINE WINDOW &cCSBxName ;
            AT     nFormRow+nControlRow+GetTitleHeight() + nRowOFfset, nFormCol+nControlCol + nColOFfset ;
            WIDTH  nControlWidth+GetBorderWidth() ;
            HEIGHT nListBoxHeight+nControlHeight+GetBorderHeight() ;
            TITLE '' ;
            MODAL ;
            NOCAPTION ;
            NOSIZE;
            ON INIT SetProperty( cCSBxName, '_cstext', "CaretPos", caret )
         
            ON KEY UP     OF This.Window ACTION _CSDoUpKey()  
            ON KEY DOWN   OF This.Window ACTION _CSDoDownKey()
            ON KEY ESCAPE OF This.Window ACTION _CSDoEscKey( cParentName, cCSBoxName ) 
            
            DEFINE TEXTBOX _cstext
               ROW           3
               COL           3
               WIDTH         nControlWidth
               HEIGHT        nControlHeight
               FONTNAME      this.fontname
               FONTSIZE      this.Fontsize
               TOOLTIP       this.tooltip
               FONTBOLD      this.fontbold
               FONTITALIC    this.fontitalic
               FONTUNDERLINE this.fontunderline
               BACKCOLOR     this.backcolor
               FONTCOLOR     this.fontcolor
               ON CHANGE     _CSTextChanged  ( cParentName, aItems, lAnyWhere, nDropHeight )
               ON ENTER      _CSItemSelected ( cParentName, cCSBoxName )
            END TEXTBOX
            
            DEFINE LISTBOX _cslist
               ROW         nControlHeight+3
               COL         3
               WIDTH       nControlWidth
               HEIGHT      nListBoxHeight-GetBorderHeight()
               ITEMS       aResults
               ON DBLCLICK _CSItemSelected( cParentName, cCSBoxName )
               VALUE       1    
            END LISTBOX
            
         END WINDOW

         SetProperty( cCSBxName, '_cstext', "VALUE", cCurValue )
         SetProperty( cCSBxName, '_cstext', "CaretPos", caret )

         ACTIVATE WINDOW &cCSBxName

      ENDIF

   ENDIF   

RETURN // CreateCSBox()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._
   
STATIC PROC _CSTextChanged( cParentName, aItems, lAnyWhere, nDropHeight )

   LOCAL cCurValue      := GetProperty( ThisWindow.Name, '_cstext', "VALUE" ) 
   LOCAL aResults       := {}
   LOCAL nItemNo        := 0
   LOCAL nListBoxHeight := 0
   LOCAL nParentHeight  := GetProperty(cParentName,"HEIGHT")
   LOCAL nParentRow     := GetProperty(cParentName,"ROW")

   DoMethod( ThisWindow.Name, "_csList", 'DeleteAllItems' ) 


   FOR nItemNo := 1 TO HMG_LEN(aItems)
      IF lAnyWhere == .T.
         IF HB_UAT(HMG_UPPER(cCurValue),HMG_UPPER(aItems[nItemNo])) > 0
            AADD(aResults,aItems[ nItemNo ])
         ENDIF            
      ELSE
         IF HMG_UPPER( HB_ULEFT( aItems[ nItemNo ], HMG_LEN(cCurValue))) == HMG_UPPER(cCurValue)
            AADD(aResults,aItems[ nItemNo ])
         ENDIF
      ENDIF   
   NEXT nItemNo


   IF HMG_LEN(aResults) > 0
      FOR nItemNo := 1 TO HMG_LEN(aResults)
         DoMethod( ThisWindow.Name, "_csList", 'AddItem', aResults[ nItemNo ] ) 
      NEXT i
      SetProperty( ThisWindow.Name, "_csList", "VALUE", 1 ) 
   ENDIF

   nListBoxHeight := MAX(MIN((HMG_LEN(aResults) * 16)+6,(nParentHeight + nParentRow - ;
                    GetProperty( ThisWindow.Name, 'ROW' ) -  ;
                    GetProperty( ThisWindow.Name, "_csText", 'ROW' ) -  ;
                    GetProperty( ThisWindow.Name, "_csText", 'HEIGHT' ) -  14)), 40) 

   IF nDropHeight > 0
      nListBoxHeight := MIN (nListBoxHeight, nDropHeight)
   ENDIF
   
   SetProperty( ThisWindow.Name, "_csList", "HEIGHT", nListBoxHeight - GetBorderHeight() ) 
   SetProperty( ThisWindow.Name, "HEIGHT", nListBoxHeight + GetProperty( ThisWindow.Name, '_cstext', "HEIGHT" ) ) 

RETURN // _CSTextChanged()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._

STATIC PROC _CSItemSelected( cParentName, cTxBName )

   LOCAL nListValue
   LOCAL cListItem

   IF GetProperty( ThisWindow.Name, "_csList", "VALUE" ) > 0 

      nListValue := GetProperty( ThisWindow.Name, '_csList', "VALUE" )
      cListItem  := GetProperty( ThisWindow.Name, '_csList', "ITEM", nListValue )

      SetProperty( cParentName, cTxBName, "VALUE", cListItem )

      SetProperty(cParentName,cTxBName,"CARETPOS",;
                    HMG_LEN( GetProperty( ThisWindow.Name, '_csList', "ITEM",; 
                         GetProperty( ThisWindow.Name, '_csList', "VALUE" ) ) ) )
   ELSE
      IF lRetainItem // lAdditive!
         stopcontroleventprocedure( cTxBName, cParentName, .t. )
         SetProperty( cParentName, cTxBName, "VALUE", GetProperty( ThisWindow.Name, '_cstext', "VALUE" ) )
         SetProperty(cParentName,cTxBName,"CARETPOS",;
                       HMG_LEN( GetProperty( cParentName, cTxBName, "VALUE" ) ) )
         stopcontroleventprocedure( cTxBName, cParentName, .f. )
      ENDIF   
   ENDIF  
   DoMethod( ThisWindow.Name, "Release" ) 
   DoMethod( cParentName, "SetFocus" ) 
          
RETURN // _CSItemSelected()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._

STATIC PROC _CSDoUpKey()

   IF GetProperty( ThisWindow.Name, '_csList', "ItemCount" ) > 0 .AND. GetProperty( ThisWindow.Name, '_csList', "VALUE" ) > 1

      SetProperty( ThisWindow.Name, '_csList', "VALUE", GetProperty( ThisWindow.Name, '_csList', "VALUE" ) - 1 )

   ENDIF
   
RETURN // _CSDoUpKey()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._

STATIC PROC _CSDoDownKey()

   IF GetProperty( ThisWindow.Name, '_csList', "ItemCount" ) > 0 .AND. ;
      GetProperty( ThisWindow.Name, '_csList', "VALUE" )     < ;
      GetProperty( ThisWindow.Name, '_csList', "ItemCount" )

      SetProperty( ThisWindow.Name, '_csList', "VALUE", GetProperty( ThisWindow.Name, '_csList', "VALUE" ) + 1 ) 

   ENDIF

RETURN // _CSDoDownKey()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._

STATIC PROC _CSDoEscKey( cParentName, cCSBoxName )

   IF .not. lRetainItem
      SetProperty( cParentName, cCSBoxName, "VALUE", '' )
   ELSE
      stopcontroleventprocedure( cCSBoxName, cParentName, .t. )
      SetProperty( cParentName, cCSBoxName, "VALUE", GetProperty( ThisWindow.Name, '_cstext', "VALUE" ) )
      SetProperty(cParentName,cCSBoxName,"CARETPOS",;
                    HMG_LEN( GetProperty( cParentName, cCSBoxName, "VALUE" ) ) )
      DoMethod( cParentName,cCSBoxName,"SETFOCUS" )
      stopcontroleventprocedure( cCSBoxName, cParentName, .f. )
   ENDIF   

   DoMethod( ThisWindow.Name, "Release" ) 
   DoMethod( cParentName, "SetFocus" ) 

RETURN // _CSDoEscKey()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._

