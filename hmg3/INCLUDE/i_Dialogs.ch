/*----------------------------------------------------------------------------
 HMG Header File --> i_Dialogs.ch  

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


#xtranslate FINDTEXTDIALOG  ;
           [ <dummy1: ACTION,ON ACTION> <action> ];
           [ FIND <cFind> ] ;
           [ <NoUpDown: NOUPDOWN> ] ;
           [ <NoMatchCase: NOMATCHCASE> ] ;
           [ <NoWholeWord: NOWHOLEWORD> ] ;
           [ CHECKDOWN <CheckDown> ] ;
           [ CHECKMATCHCASE <CheckMatchCase> ] ;
           [ CHECKWHOLEWORD <CheckWholeWord> ] ;
           [ TITLE <cTitle> ] ;
=> FindTextDlg ( <{action}>, <cFind>, <.NoUpDown.>, <.NoMatchCase.>, <.NoWholeWord.>, <CheckDown>, <CheckMatchCase>, <CheckWholeWord>, <cTitle> ) 


#xtranslate REPLACETEXTDIALOG ;
           [ <dummy1: ACTION,ON ACTION> <action> ];
           [ FIND <cFind> ] ;
           [ REPLACE <cReplace> ] ;
           [ <NoMatchCase: NOMATCHCASE> ] ;
           [ <NoWholeWord: NOWHOLEWORD> ] ;
           [ CHECKMATCHCASE <CheckMatchCase> ] ;
           [ CHECKWHOLEWORD <CheckWholeWord> ] ;
           [ TITLE <cTitle> ] ;
=> ReplaceTextDlg ( <{action}>, <cFind>, <cReplace>, <.NoMatchCase.>, <.NoWholeWord.>, <CheckMatchCase>, <CheckWholeWord> , <cTitle> ) 



#xtranslate FindReplaceDlg.Show           => FINDREPLACEDLGSHOW (.T.)
#xtranslate FindReplaceDlg.Hide           => FINDREPLACEDLGSHOW (.F.)
#xtranslate FindReplaceDlg.Release        => FINDREPLACEDLGRELEASE (.T.)


#xtranslate FindReplaceDlg.IsRelease      => FINDREPLACEDLGISRELEASE ()
#xtranslate FindReplaceDlg.IsOpen         => .NOT.( FINDREPLACEDLGISRELEASE () )
#xtranslate FindReplaceDlg.HANDLE         => FINDREPLACEDLGGETHANDLE ()
#xtranslate FindReplaceDlg.Title          => FINDREPLACEDLGGETTITLE ()
#xtranslate FindReplaceDlg.Title := <arg> => FINDREPLACEDLGSETTITLE (<arg>)


#xtranslate FindReplaceDlg.ROW    => IF ( FindReplaceDlg.IsOpen, GetWindowRow    ( FINDREPLACEDLGGETHANDLE () ), 0)
#xtranslate FindReplaceDlg.COL    => IF ( FindReplaceDlg.IsOpen, GetWindowCol    ( FINDREPLACEDLGGETHANDLE () ), 0)
#xtranslate FindReplaceDlg.WIDTH  => IF ( FindReplaceDlg.IsOpen, GetWindowWidth  ( FINDREPLACEDLGGETHANDLE () ), 0)
#xtranslate FindReplaceDlg.HEIGHT => IF ( FindReplaceDlg.IsOpen, GetWindowHeight ( FINDREPLACEDLGGETHANDLE () ), 0)

#xtranslate FindReplaceDlg.ROW    := <arg> => IF ( FindReplaceDlg.IsOpen, _SetWindowSizePos ( FINDREPLACEDLGGETHANDLE (), <arg>,      ,      ,       ), NIL)
#xtranslate FindReplaceDlg.COL    := <arg> => IF ( FindReplaceDlg.IsOpen, _SetWindowSizePos ( FINDREPLACEDLGGETHANDLE (),      , <arg>,      ,       ), NIL)
#xtranslate FindReplaceDlg.WIDTH  := <arg> => IF ( FindReplaceDlg.IsOpen, _SetWindowSizePos ( FINDREPLACEDLGGETHANDLE (),      ,      , <arg>,       ), NIL)
#xtranslate FindReplaceDlg.HEIGHT := <arg> => IF ( FindReplaceDlg.IsOpen, _SetWindowSizePos ( FINDREPLACEDLGGETHANDLE (),      ,      ,      , <arg> ), NIL)



#xtranslate _HMG_FindReplaceOptions => _HMG_SYSDATA \[ 503 \]

#xtranslate FindReplaceDlg.RetValue      => _HMG_FindReplaceOptions \[ 1 \]
#xtranslate FindReplaceDlg.Find          => _HMG_FindReplaceOptions \[ 2 \]
#xtranslate FindReplaceDlg.Replace       => _HMG_FindReplaceOptions \[ 3 \]
#xtranslate FindReplaceDlg.Down          => _HMG_FindReplaceOptions \[ 4 \]
#xtranslate FindReplaceDlg.MatchCase     => _HMG_FindReplaceOptions \[ 5 \]
#xtranslate FindReplaceDlg.WholeWord     => _HMG_FindReplaceOptions \[ 6 \]


//  FindReplaceDlg.RetValue
#define FRDLG_UNKNOWN    -1
#define FRDLG_CANCEL      0   // Cancel or Close dialog
#define FRDLG_FINDNEXT    1
#define FRDLG_REPLACE     2
#define FRDLG_REPLACEALL  3



#xtranslate SET DIALOGBOX [ POSITION ] ROW <nRow> COL <nCol> => ;
            _HMG_DialogBoxProperty ( <nRow>, <nCol>, .F., 0, .T.)

#xtranslate SET DIALOGBOX [ POSITION ] CENTER OF <hWnd> => ;
            _HMG_DialogBoxProperty ( NIL, NIL, .T., <hWnd>, .T.)

#xtranslate SET DIALOGBOX [ POSITION ] CENTER OF PARENT => ;
            _HMG_DialogBoxProperty ( NIL, NIL, .T., NIL, .T.)

#xtranslate SET DIALOGBOX [ POSITION ] CENTER OF DESKTOP => ;
            _HMG_DialogBoxProperty ( NIL, NIL, .T., GetDesktopWindow(), .T.)

#xtranslate SET DIALOGBOX [ POSITION ] DISABLE => ;
            _HMG_DialogBoxProperty ( NIL, NIL, NIL, NIL, .F.)



#define WM_SYSCOMMAND   274
#define SC_CLOSE     0xF060

#xtranslate VirtualKeyboard.FILENAME            => "OSK.EXE"
#xtranslate VirtualKeyboard.FULLFILENAME        => GetSystemDir()+"\"+VirtualKeyboard.FILENAME
#xtranslate VirtualKeyboard.FULLFILENAMEWOW64   => GetSystemWow64Directory()+"\"+VirtualKeyboard.FILENAME

#xtranslate VirtualKeyboard.HANDLE           => _HMG_VirtualKeyboardGetHandle()
#xtranslate VirtualKeyboard.OPEN [ SHOW ]    => EXECUTE FILE VirtualKeyboard.FULLFILENAME
#xtranslate VirtualKeyboard.OPEN   HIDE      => EXECUTE FILE VirtualKeyboard.FULLFILENAME HIDE
#xtranslate VirtualKeyboard.RELEASE          => SendMessage (VirtualKeyboard.HANDLE, WM_SYSCOMMAND, SC_CLOSE, 0 )
#xtranslate VirtualKeyboard.TITLE            => GetWindowText (VirtualKeyboard.HANDLE)
#xtranslate VirtualKeyboard.TITLE := <arg>   => SetWindowText (VirtualKeyboard.HANDLE, <arg>)
#xtranslate VirtualKeyboard.SHOW             => ShowWindow (VirtualKeyboard.HANDLE)
#xtranslate VirtualKeyboard.HIDE             => HideWindow (VirtualKeyboard.HANDLE)
#xtranslate VirtualKeyboard.IsVisible        => IsWindowVisible (VirtualKeyboard.HANDLE)
#xtranslate VirtualKeyboard.IsOpen           => IsValidWindowHandle (VirtualKeyboard.HANDLE)
#xtranslate VirtualKeyboard.IsRelease        => .NOT. VirtualKeyboard.IsOpen
#xtranslate VirtualKeyboard.IsMinimize       => IsMinimized (VirtualKeyboard.HANDLE)
#xtranslate VirtualKeyboard.IsMaximize       => IsMaximized (VirtualKeyboard.HANDLE)

#xtranslate VirtualKeyboard.ROW    => GetWindowRow    ( VirtualKeyboard.HANDLE )
#xtranslate VirtualKeyboard.COL    => GetWindowCol    ( VirtualKeyboard.HANDLE )
#xtranslate VirtualKeyboard.WIDTH  => GetWindowWidth  ( VirtualKeyboard.HANDLE )
#xtranslate VirtualKeyboard.HEIGHT => GetWindowHeight ( VirtualKeyboard.HANDLE )

#xtranslate VirtualKeyboard.ROW    := <arg> => _SetWindowSizePos ( VirtualKeyboard.HANDLE, <arg>,      ,      ,       )
#xtranslate VirtualKeyboard.COL    := <arg> => _SetWindowSizePos ( VirtualKeyboard.HANDLE,      , <arg>,      ,       )
#xtranslate VirtualKeyboard.WIDTH  := <arg> => _SetWindowSizePos ( VirtualKeyboard.HANDLE,      ,      , <arg>,       )
#xtranslate VirtualKeyboard.HEIGHT := <arg> => _SetWindowSizePos ( VirtualKeyboard.HANDLE,      ,      ,      , <arg> )

