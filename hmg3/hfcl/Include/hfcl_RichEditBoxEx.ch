
************************************
*   Extended rich edit file type   *
************************************

#define RICHEDITFILEEX_ANSI      1   // ANSI text file
#define RICHEDITFILEEX_UTF8      2   // UTF-8 text file
#define RICHEDITFILEEX_UTF16LE   3   // UTF-16 LE (little endian) text file
#define RICHEDITFILEEX_RTF       4   // RTF file
#define RICHEDITFILEEX_UTF16BE   5   // UTF-16 BE (big endian) text file

***************************************
*   Extended properties and methods   *
***************************************

#xtranslate Ex. <w>. <c> . <p:HasNonAsciiChars,HasNonAnsiChars> => GetPropertyEx ( <"w">, <"c"> , <"p"> )
#xtranslate Ex. <w>. <c> . <p:LoadFile,SaveFile> (<arg1>,<arg2>,<arg3>) => DoMethodEx ( <"w">, <"c"> , <"p"> , <arg1> , <arg2>, <arg3> )
#xtranslate Ex. <w>. <c> . <p:LoadFile,SaveFile> (<arg1>,<arg2>) => DoMethodEx ( <"w">, <"c"> , <"p"> , <arg1> , <arg2> )
#xtranslate Ex. <w>. <c> . <p:LoadFile,SaveFile> (<arg1>) => DoMethodEx ( <"w">, <"c"> , <"p"> , <arg1> )
#xtranslate Ex. <w>. <p:GetScreenPos,GetWindowPos> (<arg1>,<arg2>) => GetPropertyEx ( <"w">, <"p"> , <arg1>, <arg2> )
#xtranslate Ex. <w>. <c> . <p:GetScreenPos,GetWindowPos> (<arg1>,<arg2>) => GetPropertyEx ( <"w">, <"c"> , <"p"> , <arg1>, <arg2> )
#xtranslate Ex. <w>. <p:DrawBorder> [()] => DoMethodEx ( <"w">, <"p"> )
#xtranslate Ex. <w>. <p:DrawBorder> (<arg1>) => DoMethodEx ( <"w">, <"p">, <arg1> )
#xtranslate Ex. <w>. <p:DrawBorder> (,<arg2>) => DoMethodEx ( <"w">, <"p">,, <arg2> )
#xtranslate Ex. <w>. <p:DrawBorder> (<arg1>,<arg2>) => DoMethodEx ( <"w">, <"p">, <arg1>, <arg2> )

******************************
*   Extended print dialog    *
******************************

#xcommand SELECT PRINTER DIALOG EX ;
   [ PARENT <parent> ] ;
   [ <Preview  : PREVIEW> ] ;
   [ <NoSaveButton   : NOSAVEBUTTON> ] ;
   [ DIALOGFILENAME <DialogFileName> ] ;
   [ SAVEAS <FullFileName> ] ;
=> ;
_HMG_SYSDATA \[ 513 \] := .f. ;;
_HMG_SYSDATA \[ 373 \]  = HMG_PrintDialogEx( <"parent"> )  ;;
_HMG_SYSDATA \[ 374 \] := _HMG_SYSDATA \[ 373 \] \[1\]    ;;
_HMG_SYSDATA \[ 375 \] := _HMG_SYSDATA \[ 373 \] \[2\]  ;;
_HMG_SYSDATA \[ 376 \] := _HMG_SYSDATA \[ 373 \] \[3\] ;;
_HMG_SYSDATA \[ 377 \] := _HMG_SYSDATA \[ 373 \] \[4\] ;;
_HMG_SYSDATA \[ 378 \] := <.Preview.>       ;;
_HMG_SYSDATA \[ 505 \] := <.NoSaveButton.> ;;
_HMG_SYSDATA \[ 506 \] := HMG_IsNotDefParam ( <DialogFileName> , NIL );;
_HMG_SYSDATA \[ 507 \] := HMG_IsNotDefParam ( <FullFileName>   , NIL );;
_HMG_SYSDATA \[ 508 \] := <.Preview.> ;;
_HMG_SYSDATA \[ 378 \] := if ( _HMG_SYSDATA \[ 507 \] <> NIL, .T., <.Preview.> ) ;;
_hmg_printer_InitUserMessages()         ;;
_HMG_SYSDATA \[ 379 \] := strzero( Seconds() * 100 , 8 ) 

#xcommand SELECT PRINTER DIALOG EX ;
   [ PARENT <parent> ] ;
   TO <lSuccess> ;
   [ <Preview  : PREVIEW> ] ;
   [ <NoSaveButton   : NOSAVEBUTTON> ] ;
   [ DIALOGFILENAME <DialogFileName> ] ;
   [ SAVEAS <FullFileName> ] ;
=> ;
_HMG_SYSDATA \[ 513 \] := .f. ;;
_HMG_SYSDATA \[ 373 \]  = HMG_PrintDialogEx( <"parent"> )  ;;
_HMG_SYSDATA \[ 374 \] := _HMG_SYSDATA \[ 373 \] \[1\]    ;;
_HMG_SYSDATA \[ 375 \] := _HMG_SYSDATA \[ 373 \] \[2\]  ;;
_HMG_SYSDATA \[ 376 \] := _HMG_SYSDATA \[ 373 \] \[3\] ;;
_HMG_SYSDATA \[ 377 \] := _HMG_SYSDATA \[ 373 \] \[4\] ;;
<lSuccess> := if ( _HMG_SYSDATA \[ 374 \] <> 0 , .T. , .F. ) ;;
_HMG_SYSDATA \[ 378 \] := <.Preview.> ;;
_HMG_SYSDATA \[ 505 \] := <.NoSaveButton.> ;;
_HMG_SYSDATA \[ 506 \] := HMG_IsNotDefParam ( <DialogFileName> , NIL );;
_HMG_SYSDATA \[ 507 \] := HMG_IsNotDefParam ( <FullFileName>   , NIL );;
_HMG_SYSDATA \[ 508 \] := <.Preview.> ;;
_HMG_SYSDATA \[ 378 \] := if ( _HMG_SYSDATA \[ 507 \] <> NIL, .T., <.Preview.> ) ;;
_hmg_printer_InitUserMessages() ;;
_HMG_SYSDATA \[ 379 \] := strzero( Seconds() * 100 , 8 ) 


