

#xcommand @ <row>,<col> QHTM <name> ;
      [ <dummy1: OF, PARENT> <parent> ] ;
      [ VALUE  <value> ]     ;
      [ FILE <fname> ]       ;
      [ RESOURCE <resname> ] ;
      [ WIDTH <w> ] ;
      [ HEIGHT <h> ] ;
      [ FONT <fontname> ]   ;
      [ SIZE <fontsize> ]   ;
      [ ON CHANGE <change> ] ;
      [ <border: BORDER> ] ;
      [ <bold : BOLD> ] ;
      [ <italic : ITALIC> ] ;
      [ <underline : UNDERLINE> ] ;
      [ <strikeout : STRIKEOUT> ] ;
=>;
      _DefineQhtm ( <"name">, ;
                   <"parent">, ;
                   <row>, ;
                   <col>, ;
                   <w>, ;
                   <h> , ;
                   <value>, ;
                   <fname>, ;
                   <resname>, ;
                   <fontname>, ;
                   <fontsize>, ;
                   <{change}> , ;
                   <.border.>, ;
                   <.bold.>,;
                   <.italic.>, ;
                  <.underline.>, ;
                  <.strikeout.> )


/*----------------------------------------------------------------------------
QHTM
---------------------------------------------------------------------------*/

#define WM_USER               1024
#define QHTM_OPT_ZOOMLEVEL    ( 2 )
#define QHTM_SET_OPTION       ( WM_USER + 3 )
#define QHTM_GET_SCROLL_POS   ( WM_USER + 6 )
#define QHTM_SET_SCROLL_POS   ( WM_USER + 7 )

#xtranslate QHTM_GetScrollPos( <nHandle> )         => SendMessage( <nHandle>, QHTM_GET_SCROLL_POS, 0, 0 ) 

#xtranslate QHTM_SetScrollPos( <nHandle>, <nPos> ) => SendMessage( <nHandle>, QHTM_SET_SCROLL_POS, <nPos>, 0 )

#xtranslate QHTM_SetZoomLevel( <hWnd>, <nLevel> )  => SendMessage (<hWnd>, QHTM_SET_OPTION, QHTM_OPT_ZOOMLEVEL, <nLevel>)   // nLevel = 0 ... 4


