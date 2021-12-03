
#include 'hmg.ch'

FUNCTION Main()

    DEFINE WINDOW Win_1 ; 
        AT 0,0 ; 
        WIDTH 1000 ; 
        HEIGHT 1000 ; 
        TITLE 'Win_1' ; 
        MAIN ; 
        NOSIZE  

        DEFINE MAIN MENU
          DEFINE POPUP 'Get'
            MENUITEM 'Get Row'              ACTION MsgInfo ( 'Row:  '              + HB_NTOS ( Win_1.Control_1.Row            ) )
            MENUITEM 'Get Col'              ACTION MsgInfo ( 'Col:  '              + HB_NTOS ( Win_1.Control_1.Col            ) )
            MENUITEM 'Get Width'            ACTION MsgInfo ( 'Width:  '            + HB_NTOS ( Win_1.Control_1.Width          ) )
            MENUITEM 'Get Height'           ACTION MsgInfo ( 'Height:  '           + HB_NTOS ( Win_1.Control_1.Height         ) )
            MENUITEM 'Get Font Name'        ACTION MsgInfo ( 'Font Name:  '        +           Win_1.Control_1.FontName         )
            MENUITEM 'Get Font Size'        ACTION MsgInfo ( 'Font Size:  '        + HB_NTOS ( Win_1.Control_1.FontSize       ) )
            MENUITEM 'Get Font Color'       ACTION MsgInfo ( 'Font Color:  '       + GetRGB  ( Win_1.Control_1.FontColor      ) )
            MENUITEM 'Get Outer Font Color' ACTION MsgInfo ( 'Outer Font Color:  ' + GetRGB  ( Win_1.Control_1.OuterFontColor ) )
            MENUITEM 'Get Back Color'       ACTION MsgInfo ( 'Back Color:  '       + GetRGB  ( Win_1.Control_1.BackColor      ) )
            MENUITEM 'Get Title Font Color' ACTION MsgInfo ( 'Title Font Color:  ' + GetRGB  ( Win_1.Control_1.TitleFontColor ) )
            MENUITEM 'Get Title Back Color' ACTION MsgInfo ( 'Title Back Color:  ' + GetRGB  ( Win_1.Control_1.TitleBackColor ) )
            MENUITEM 'Get Range Min'        ACTION MsgInfo ( 'Range Min:  '        + GetDate ( Win_1.Control_1.RangeMin       ) )
            MENUITEM 'Get Range Max'        ACTION MsgInfo ( 'Range Max:  '        + GetDate ( Win_1.Control_1.RangeMax       ) )
            MENUITEM 'Get Visible Min'      ACTION MsgInfo ( 'Visible Min:  '      + GetDate ( Win_1.Control_1.VisibleMin     ) )
            MENUITEM 'Get Visible Max'      ACTION MsgInfo ( 'Visible Max:  '      + GetDate ( Win_1.Control_1.VisibleMax     ) )
            MENUITEM 'Get View'             ACTION MsgInfo ( 'View:  '             + HB_NTOS ( Win_1.Control_1.View           ) )
          END POPUP
          DEFINE POPUP 'Set'
            MENUITEM 'Set Row'              ACTION Win_1.Control_1.Row            := Val(      InputBox('Enter Row'              , , HB_NTOS ( Win_1.Control_1.Row               ) ) )
            MENUITEM 'Set Col'              ACTION Win_1.Control_1.Col            := Val(      InputBox('Enter Col'              , , HB_NTOS ( Win_1.Control_1.Col               ) ) )
            MENUITEM 'Set Width'            ACTION Win_1.Control_1.Width          := Val(      InputBox('Enter Width'            , , HB_NTOS ( Win_1.Control_1.Width             ) ) )
            MENUITEM 'Set Height'           ACTION Win_1.Control_1.Height         := Val(      InputBox('Enter Height'           , , HB_NTOS ( Win_1.Control_1.Height            ) ) )
            MENUITEM 'Set Font Color'       ACTION Win_1.Control_1.FontColor      := SetRGB  ( InputBox('Enter Font Color'       , , GetRGB  ( Win_1.Control_1.FontColor         ) ) )
            MENUITEM 'Set Outer Font Color' ACTION Win_1.Control_1.OuterFontColor := SetRGB  ( InputBox('Enter Outer Font Color' , , GetRGB  ( Win_1.Control_1.OuterFontColor    ) ) )
            MENUITEM 'Set Back Color'       ACTION Win_1.Control_1.BackColor      := SetRGB  ( InputBox('Enter Back Color'       , , GetRGB  ( Win_1.Control_1.BackColor         ) ) )
            MENUITEM 'Set Title Font Color' ACTION Win_1.Control_1.TitleFontColor := SetRGB  ( InputBox('Enter Title Font Color' , , GetRGB  ( Win_1.Control_1.TitleFontColor    ) ) )
            MENUITEM 'Set Title Back Color' ACTION Win_1.Control_1.TitleBackColor := SetRGB  ( InputBox('Enter Title Back Color' , , GetRGB  ( Win_1.Control_1.TitleBackColor    ) ) )
            MENUITEM 'Set Range Min'        ACTION Win_1.Control_1.RangeMin       := SetDate ( InputBox('Enter Range Min'        , , GetDate ( Win_1.Control_1.RangeMin          ) ) )
            MENUITEM 'Set Range Max'        ACTION Win_1.Control_1.RangeMax       := SetDate ( InputBox('Enter Range Max'        , , GetDate ( Win_1.Control_1.RangeMax          ) ) )
            MENUITEM 'Set View'             ACTION Win_1.Control_1.View           := Val(      InputBox('Enter View'             , , HB_NTOS ( Win_1.Control_1.View              ) ) )
          END POPUP
          DEFINE POPUP 'Value'
            MENUITEM 'Get Value'            ACTION MsgInfo ( ShowDate ( Win_1.Control_1.Value ) )
            MENUITEM 'Set Value'            ACTION Win_1.Control_1.Value          := SetDate ( InputBox('Enter Value'            , , GetDate ( Win_1.Control_1.Value             ) ) )
          END POPUP
        END MENU

        @ 10,10 MONTHCALENDAR CONTROL_1 ; 
            OF Win_1 ; 
            RANGEMIN HB_DATE(YEAR(DATE()), MONTH(DATE()), 1) ;
            WIDTH 320 ;
            HEIGHT 230 ;
            FONT 'Arial' ; 
            SIZE 12 ;
            FONTCOLOR NAVY ;
            OUTERFONTCOLOR BLUE ;
            BACKCOLOR PINK ;
            TITLEBACKCOLOR GREEN ;
            BORDERCOLOR YELLOW

    END WINDOW

    CENTER WINDOW Win_1
    ACTIVATE WINDOW Win_1

RETURN NIL

//***************************************************************************

STATIC FUNCTION ShowDate ( dDate )

  LOCAL cRet := ;
    "Year: "  + STRZERO(YEAR(dDate) , 4) + E"\r\n" + ;
    "Month: " + STRZERO(MONTH(dDate), 2) + " (" + CMONTH(dDate) + E")\r\n" + ;
    "Day of month: "   + STRZERO(DAY(dDate)  , 2) + E"\r\n" + ;
    "Day of week: " + STR(DOW(dDate),1) + " (" + CDOW(dDate) + E")\r\n" + ;
    "Week number: " + STRZERO(HB_WEEK(dDate), 2) + E"\r\n" + ;
    "Day of year: " + STRZERO(dDate - HB_DATE(YEAR(dDate), 1, 1) - 1, 3) + E"\r\n" + ;
    "Julian date: " + HB_NTOS(dDate - D"0000-00-00")

  RETURN cRet

//***************************************************************************

STATIC FUNCTION GetRGB ( aRGB )

  LOCAL cRet := ;
    HB_NTOS(aRGB[1]) + ',' + ;
    HB_NTOS(aRGB[2]) + ',' + ;
    HB_NTOS(aRGB[3])

  RETURN cRet

//***************************************************************************

STATIC FUNCTION SetRGB ( cRGB )

  LOCAL acRGB := HB_ATOKENS(cRGB + ',,', ',')
  LOCAL anRGB := { ;
    VAL(acRGB[1]), ;
    VAL(acRGB[2]), ;
    VAL(acRGB[3])  }

  RETURN anRGB

//***************************************************************************

STATIC FUNCTION GetDate ( dDate )

  LOCAL cRet := ;
    STRZERO(YEAR (dDate), 4) + '-' + ;
    STRZERO(MONTH(dDate), 2) + '-' + ;
    STRZERO(DAY  (dDate), 2)

  RETURN cRet

//***************************************************************************

STATIC FUNCTION SetDate ( cDate )

  LOCAL acDate := HB_ATOKENS(cDate + '--', '-')
  LOCAL dDate  := HB_DATE( ;
    VAL(acDate[1]), ;
    VAL(acDate[2]), ;
    VAL(acDate[3])  )

  RETURN dDate

//***************************************************************************
