/**
 * This demo is based on the example: RichDemo
 * Copyright 2003-2009 by Janusz Pora <JanuszPora@onet.eu>
 *
 * Adapted and Enhanced for HMG by Dr. Claudio Soto, January 2014
 * Enhanced for HMG By Kevin Carmody, November 2014
 * Enhanced & Skinned for HMG By Eduardo L. Azar, December 2014
*/

#include "hmg.ch"
#include "directry.ch"

FUNCTION MAIN

   REQUEST DBFNTX
   REQUEST DBFDBT

   SET DATE BRITISH
   SET DELETE ON
   SET CENTURY ON

   SET TOOLTIPCUSTOMDRAW ON
   SET TOOLTIPSTYLE BALLOON
   SET TOOLTIPBACKCOLOR { 250, 250, 210}

   SET NAVIGATION EXTENDED
   SET LANGUAGE TO ENGLISH

   PRIVATE nFontNameValue := 0
   PRIVATE nFontSizeValue := 0
   PRIVATE FlagOnSelect   := .F.

   PRIVATE cFind         := ""
   PRIVATE cReplace      := ""
   PRIVATE lDown         := .T.
   PRIVATE lMatchCase    := .F.
   PRIVATE lWholeWord    := .F.
   PRIVATE cToolTipTitle := "Function:"
   PRIVATE cCurrentForm  := 'FORM_1'
   PRIVATE ccolor
   PRIVATE acolorS
   PRIVATE uncolor

   PRIVATE aFontColor       := RTF_FONTAUTOCOLOR
   PRIVATE aFontBackColor   := RTF_FONTAUTOBACKCOLOR
   PRIVATE aBackgroundColor := { 255, 255, 255 }

   PRIVATE cFileName     := ""
   PRIVATE cAuxFileName  := ""
   PRIVATE aViewRect     := {}
   PRIVATE memospace := 1.0
   PRIVATE tmemospace := "Line Spacing Value : " + ALLTRIM(STR(memospace))
   PRIVATE activ_doc := "0"
   PRIVATE lapos
   PRIVATE presing
   PRIVATE rubytuesday := ""
   PRIVATE blackfriday := ""
   PRIVATE lamarca := "N"
   PRIVATE puntero := 0
   PRIVATE texshow := 'NEW'
   PRIVATE AARP := {}
   PRIVATE cfolder := ''
   PRIVATE buscar := ''

   PRIVATE Aux_Tab0 := 'Auxiliary Document 1Push this button to load Auxiliary Document 1 (save option disable)'
   PRIVATE Aux_Tab1 := 'Go to Quick Start Menu to load a recent file as Auxiliary Document 1 (save option disable)'
   PRIVATE Aux_Tab2 := 'Go to Quick Start Menu to load a recent file as Auxiliary Document 1 (save option disable)'
   PRIVATE Aux_Tab3 := 'Push this button to load Auxiliary Document 3 (save option disable)'
   PRIVATE Aux_Tab4 := 'Push this button to load Auxiliary Document 4 (save option disable)'
   PRIVATE Aux_Tab5 := 'Push this button to load Auxiliary Document 5 (save option disable)'

   PRIVATE Aux_FileN0 := ''
   PRIVATE Aux_FileN1 := ''
   PRIVATE Aux_FileN2 := ''
   PRIVATE Aux_FileN3 := ''
   PRIVATE Aux_FileN4 := ''
   PRIVATE Aux_FileN5 := ''

   PRIVATE aColors

   PRIVATE aFontList := {}
   PRIVATE aFontSize         := {'8','9','10','11','12','14','16','18','20','22','24','26','28','36','48','72'}
   PRIVATE aZoomValue        := {'500%','300%','200%','150%','100%','75%','50%','25%'}
   PRIVATE aZoomPercentage   := { 500  , 300  , 200  , 150  , 100  , 75  , 50  , 25  }

   PRIVATE pantancho := GetDesktopWidth()
   PRIVATE pantalto := GetDesktopHeight()
   PRIVATE ctr
   PRIVATE ctc
   PRIVATE FSNGI := 15
   PRIVATE FSNGO := 20

   PRIVATE MSMLeft   := 20
   PRIVATE MSMTop    := 15
   PRIVATE MSMRight  := 10
   PRIVATE MSMBottom := 15
   PRIVATE MSnRow, MSnCol
   PRIVATE MSNROW  :=  + 10
   PRIVATE MSNCOL  := 210 / 2
   PRIVATE nPag := 1
   PRIVATE MSPREH := "Page N°"
   PRIVATE MSPOSTH := ''
   PRIVATE vppage := ''
   PRIVATE MLeft
   PRIVATE MTop
   PRIVATE MRight
   PRIVATE MBottom
   PRIVATE nRow
   PRIVATE nCol
   PRIVATE nPag
   PRIVATE MSPREH
   PRIVATE MSPOSTH
   PRIVATE memobull := "10"
   PRIVATE memoinc
   PRIVATE memodec
   PRIVATE memointerlin := "Apply active line space" + chr(10)

   centrador := pantancho - 800
   ctc := INT(centrador / 2)
   centrador := pantalto - 600
   ctr := INT(centrador / 2)


   IF FILE("RECENTS.DBF")
   ELSE
      Aadd( AARP , { 'ASELEC'         ,'C',001,000 } )
      Aadd( AARP , { 'ADIRECC'        ,'C',255,000 } )
      Aadd( AARP , { 'ANOMBRE'        ,'C',255,000 } )
      Aadd( AARP , { 'ABYTES'         ,'C',012,000 } )
      Aadd( AARP , { 'AFECHA'         ,'C',012,000 } )
      Aadd( AARP , { 'AHORA'          ,'C',008,000 } )
      Aadd( AARP , { 'AATRIB'         ,'C',006,003 } )
      Aadd( AARP , { 'ACHARGED'       ,'N',001,000 } )
      DBCreate( "RECENTS" , AARP  )
   ENDIF

   IF file("MNPSETUP.MEM")
      RESTORE FROM MNPSETUP.MEM ADDITIVE
   ELSE
      SAVE TO MNPSETUP.MEM ALL LIKE MS*
   ENDIF

   RESTORE FROM MNPSETUP.MEM ADDITIVE
   MLeft    := MSMLeft
   MTop     := MSMTop
   MRight   := MSMRight
   MBottom  := MSMBottom
   nRow      := MSnRow
   nCol      := MSnCol
   nPag := 1
   MSPREH    := MSPREH
   MSPOSTH   := MSPOSTH

   USE

   USE RECENTS ALIAS RECENTS
   INDEX On ANOMBRE To RFILES
   PACK

   bColor := { 255 , 255 , 255 }
   hColor := { ||  if ( recents->acharged == 0 , { 221,   0,   0 } , { 7 , 71 , 41 } ) }

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 800 HEIGHT 600 ;
      NOSIZE ;
      NOSYSMENU ;
      NOCAPTION ;
      BACKCOLOR { 218,229,243 } ;
      MAIN

      ON KEY CONTROL+C  ACTION GUARDA_CLIP()
      ON KEY CONTROL+B  ACTION CHEKA_BOLD()
      ON KEY CONTROL+I  ACTION CHEKA_ITALIC()
      ON KEY CONTROL+U  ACTION CHEKA_SUBRA()
      ON KEY F1         ACTION HelpProc()


      DEFINE IMAGE RIBBON_1
         ROW	0
         COL	0
         WIDTH	800
         HEIGHT 136
         PICTURE	'TAB1'
         STRETCH	.T.
      END IMAGE

       DEFINE IMAGE MINITAB_0
         ROW	41
         COL	52
         WIDTH	44
         HEIGHT 22
         PICTURE	'START_ON'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE MINITAB_1
         ROW	41
         COL	107
         WIDTH	81
         HEIGHT 22
         PICTURE	'AUX1_OFF'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE MINITAB_2
         ROW	41
         COL	199
         WIDTH	81
         HEIGHT 22
         PICTURE	'AUX2_OFF'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE MINITAB_3
         ROW	41
         COL	291
         WIDTH	81
         HEIGHT 22
         PICTURE	'AUX3_OFF'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE MINITAB_4
         ROW	41
         COL	390
         WIDTH	81
         HEIGHT 22
         PICTURE	'AUX4_OFF'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE MINITAB_5
         ROW	41
         COL	482
         WIDTH	81
         HEIGHT 22
         PICTURE	'AUX5_OFF'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE MINITAB_6
         ROW	41
         COL	585
         WIDTH	156
         HEIGHT 22
         PICTURE	'AUX_CLOSE_OFF'
         STRETCH	.T.
      END IMAGE


       DEFINE IMAGE MARCO_IZ
         ROW	136
         COL	0
         WIDTH	3
         HEIGHT 462
         PICTURE	'MARCO_LAT'
         STRETCH	.T.
      END IMAGE

       DEFINE IMAGE MARCO_DE
         ROW	136
         COL	797
         WIDTH	3
         HEIGHT 462
         PICTURE	'MARCO_LAT'
         STRETCH	.T.
      END IMAGE

       DEFINE IMAGE MARCO_INF
         ROW	597
         COL	0
         WIDTH	800
         HEIGHT 3
         PICTURE	'MARCO_INF'
         STRETCH	.T.
      END IMAGE

      @ 150,10 RICHEDITBOX miniwrite_1 ;
         WIDTH 775 ;
         HEIGHT 430 ;
         VALUE '';
         FONT "Calibri" SIZE 12;
         MAXLENGTH -1;
         NOHSCROLL;
         ON CHANGE ( marvin() ) ;
         ON SELECT OnSelectProc ();
         ON LINK   OnLinkProc ();
         ON VSCROLL ( Form_1.miniwrite_1.Refresh )

      @ 150,10 RICHEDITBOX Auxiliary_0 ;
         WIDTH 775 ;
         HEIGHT 430 ;
         VALUE '' ;
         MAXLENGTH -1

      @ 150,10 RICHEDITBOX Auxiliary_1 ;
         WIDTH 775 ;
         HEIGHT 430 ;
         VALUE 'x';
         FONT "Calibri" SIZE 12;
         MAXLENGTH -1;
         NOHSCROLL;
         ON CHANGE ( nil ) ;
         ON SELECT ( nil );
         ON LINK   ( nil );
         ON VSCROLL ( nil )

      @ 150,10 RICHEDITBOX Auxiliary_2 ;
         WIDTH 775 ;
         HEIGHT 430 ;
         VALUE 'x';
         FONT "Calibri" SIZE 12;
         MAXLENGTH -1;
         NOHSCROLL;
         ON CHANGE ( nil ) ;
         ON SELECT ( nil );
         ON LINK   ( nil );
         ON VSCROLL ( nil )

      @ 150,10 RICHEDITBOX Auxiliary_3 ;
         WIDTH 775 ;
         HEIGHT 430 ;
         VALUE '';
         FONT "Calibri" SIZE 12;
         MAXLENGTH -1;
         NOHSCROLL;
         ON CHANGE ( nil ) ;
         ON SELECT ( nil );
         ON LINK   ( nil );
         ON VSCROLL ( NIL )

      @ 150,10 RICHEDITBOX Auxiliary_4 ;
         WIDTH 775 ;
         HEIGHT 430 ;
         VALUE '';
         FONT "Calibri" SIZE 12;
         MAXLENGTH -1;
         NOHSCROLL;
         ON CHANGE ( nil ) ;
         ON SELECT ( nil );
         ON LINK   ( nil );
         ON VSCROLL ( nil )

      @ 150,10 RICHEDITBOX Auxiliary_5 ;
         WIDTH 775 ;
         HEIGHT 430 ;
         VALUE '';
         FONT "Calibri" SIZE 12;
         MAXLENGTH -1;
         NOHSCROLL;
         ON CHANGE ( nil ) ;
         ON SELECT ( nil );
         ON LINK   ( nil );
         ON VSCROLL ( nil )

         Form_1.Auxiliary_0.HIDE
         Form_1.Auxiliary_1.HIDE
         Form_1.Auxiliary_2.HIDE
         Form_1.Auxiliary_3.HIDE
         Form_1.Auxiliary_4.HIDE
         Form_1.Auxiliary_5.HIDE

         Define_Control_Context_Menu ("Miniwrite_1")
         Define_Control_Context_Menu ("Auxiliary_1")
         Define_Control_Context_Menu ("Auxiliary_2")
         Define_Control_Context_Menu ("Auxiliary_3")
         Define_Control_Context_Menu ("Auxiliary_4")
         Define_Control_Context_Menu ("Auxiliary_5")

       DEFINE IMAGE BOT_SHUT
         ROW	4
         COL	768
         WIDTH	28
         HEIGHT 28
         PICTURE	'apagaon'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_BOLD
         ROW	92
         COL	123
         WIDTH	23
         HEIGHT 23
         PICTURE	'bold_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_ITAL
         ROW	92
         COL	148
         WIDTH	23
         HEIGHT 23
         PICTURE	'ital_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_SUBRA
         ROW	92
         COL	173
         WIDTH	23
         HEIGHT 23
         PICTURE	'subra_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_TACHA
         ROW	92
         COL	198
         WIDTH	23
         HEIGHT 23
         PICTURE	'tach_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_SUB
         ROW	92
         COL	229
         WIDTH	23
         HEIGHT 23
         PICTURE	'sub_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_SUP
         ROW	92
         COL	254
         WIDTH	23
         HEIGHT 23
         PICTURE	'sup_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_BULL
         ROW	67
         COL	289
         WIDTH	36
         HEIGHT 23
         PICTURE	'bull_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_INDENTMEN
         ROW	67
         COL	327
         WIDTH	67
         HEIGHT 23
         PICTURE	'sangrias_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_INTERLIN
         ROW	67
         COL	396
         WIDTH	36
         HEIGHT 23
         PICTURE	'interl_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_ALIZQ
         ROW	92
         COL	289
         WIDTH	26
         HEIGHT 23
         PICTURE	'alin_izq_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_ALCENT
         ROW	92
         COL	318
         WIDTH	26
         HEIGHT 23
         PICTURE	'alin_cent_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_ALDER
         ROW	92
         COL	347
         WIDTH	27
         HEIGHT 23
         PICTURE	'alin_dere_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_JUSTI
         ROW	92
         COL	377
         WIDTH	26
         HEIGHT 23
         PICTURE	'alin_justi_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_FRENCH
         ROW	92
         COL	406
         WIDTH	26
         HEIGHT 23
         PICTURE	'alin_french_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_CAPS
         ROW	67
         COL	714
         WIDTH	76
         HEIGHT 15
         PICTURE	'caps_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_NUM
         ROW	83
         COL	714
         WIDTH	76
         HEIGHT 15
         PICTURE	'num_off'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE BOT_INS
         ROW	99
         COL	714
         WIDTH	76
         HEIGHT 15
         PICTURE	'ins_off'
         STRETCH	.T.
      END IMAGE


	@ 93 , 565 COMBOBOX Combo_3 ;
            ITEMS {'500%','300%','200%','150%','100%','75%','50%','25%'} ;
            VALUE 5 ;
			   WIDTH 52 ;
            HEIGHT 200 ;
            FONT "Calibri" SIZE 9 ;
            BOLD ;
            TOOLTIP ('Zoom Ratio') ;
            ON CHANGE ( Form_1.miniwrite_1.Zoom := aZoomPercentage [ Form_1.Combo_3.VALUE ] ,;
                          Form_1.miniwrite_1.SetFocus )

   GetFontList ( NIL, NIL, DEFAULT_CHARSET, NIL, NIL, NIL, @aFontList )

   @ 68, 123 COMBOBOX Combo_1 ;
              ITEMS aFontList;
              VALUE 20 ;
              WIDTH 110;
              HEIGHT 100;
              FONT 'Calibri' SIZE 9 ;
              BOLD ;
              DROPPEDWIDTH 200 ;
              TOOLTIP ('Font Name') ;
              ON GOTFOCUS  ( nFontNameValue := Form_1.Combo_1.VALUE ) ;
              ON CHANGE    ( Form_1.miniwrite_1.FontName := Form_1.Combo_1.ITEM (Form_1.Combo_1.VALUE) );
              ON CANCEL IF ( HMG_GetLastVirtualKeyDown() == VK_ESCAPE, ( HMG_CleanLastVirtualKeyDown(), Form_1.Combo_1.VALUE := nFontNameValue ), NIL ) ;

   @ 68, 236 COMBOBOX Combo_2 ;
              ITEMS aFontSize ;
              VALUE 3 ;
              WIDTH 40;
              HEIGHT 100;
              FONT 'CALIBRI' SIZE 9 ;
              BOLD ;
              TOOLTIP 'Font Size' ;
              ON GOTFOCUS  ( nFontSizeValue := Form_1.Combo_2.VALUE ) ;
              ON CHANGE    ( Form_1.miniwrite_1.FontSize := VAL (Form_1.Combo_2.ITEM (Form_1.Combo_2.VALUE)) );
              ON CANCEL IF ( HMG_GetLastVirtualKeyDown() == VK_ESCAPE, ( HMG_CleanLastVirtualKeyDown(), Form_1.Combo_2.VALUE := nFontSizeValue ), NIL ) ;


       @ 43,54 LABEL TAB_0 ;
          WIDTH 40 HEIGHT 18 ;
          VALUE '' ;
          ACTION (  PRENDE_MINIBOT() , rest_principal() )  ;
          TOOLTIP 'Principal Document full edition' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT

       @ 43,109 LABEL AUXTAB_1 ;
          WIDTH 77 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( rest_aux_1() ) ;
          TOOLTIP 'Go to Quick Start Menu to load a Recent RFT FIle' + chr(10) + 'as Auxiliary Document 1 (save option disable)' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT

       @ 43,201 LABEL AUXTAB_2 ;
          WIDTH 77 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( rest_aux_2() )  ;
          TOOLTIP 'Go to Quick Start Menu to load a Recent RFT FIle' + chr(10) + 'as Auxiliary Document 2 (save option disable)' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT

       @ 43,293 LABEL AUXTAB_3 ;
          WIDTH 77 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( rest_aux_3() )  ;
          TOOLTIP 'Press here to load Auxiliary Document 3 (save option disable)' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT

       @ 43,392 LABEL AUXTAB_4 ;
          WIDTH 77 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( APAGA_MINIBOT() , rest_aux_4() )  ;
          TOOLTIP 'Press here to load Auxiliary Document 4 (save option disable)' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT

       @ 43,484 LABEL AUXTAB_5 ;
          WIDTH 77 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( rest_aux_5() )  ;
          TOOLTIP 'Press to load Auxiliary Document 5 (save option disable)' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT

       @ 43,587 LABEL AUXCLOSE ;
          WIDTH 152 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( CLOSE_AUXDOC() , PRENDE_MINIBOT()  )  ;
          TOOLTIP 'Press to close Auxiliary Documents' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT


       @ 5,769 LABEL BOT_EXIT ;
          WIDTH 26 HEIGHT 26 ;
          VALUE '' ;
          ACTION ( GranSalida() )  ;
          TOOLTIP 'Quit' ;
          TRANSPARENT

       @ 17,10 LABEL BOT_MASTER ;
          WIDTH 36 HEIGHT 36 ;
          VALUE '' ;
          ACTION ( QUICK_MENU() ) ;
          TOOLTIP 'QUICK START MENU' ;
          TRANSPARENT

       @ 9,62 LABEL BOT_MINI1 ;
          WIDTH 16 HEIGHT 16 ;
          VALUE '' ;
          ACTION ( savefileas() ) ;
          TOOLTIP 'Save As' ;
          TRANSPARENT

       @ 11,190 LABEL TITU_ACTUAL ;
         WIDTH 50 HEIGHT 16 ;
         VALUE 'RTF File:' ;
         BOLD ;
         FONTCOLOR { 128 , 128 , 128 } ;
         TRANSPARENT

       @ 11,242 LABEL ARCHI_ACTUAL ;
         WIDTH 500 HEIGHT 16 ;
         VALUE '' ;
         BOLD ;
         BACKCOLOR { 255 , 255 , 255 } ;
         TRANSPARENT

       @ 79,655 LABEL SELE_FROM ;
         WIDTH 100 HEIGHT 16 ;
         VALUE '' ;
         FONT "CALIBRI" SIZE 9 ;
         BOLD ;
         TRANSPARENT

       @ 96,655 LABEL SELE_to ;
         WIDTH 100 HEIGHT 16 ;
         VALUE '' ;
         FONT "CALIBRI" SIZE 9 ;
         BOLD ;
         TRANSPARENT

       @ 9,82 LABEL BOT_MINI2 ;
          WIDTH 16 HEIGHT 16 ;
          VALUE '' ;
          ACTION ( newdoc1() ) ;
          TOOLTIP 'Create a New RTF Document' ;
          TRANSPARENT

       @ 9,102 LABEL BOT_MINI3 ;
          WIDTH 16 HEIGHT 16 ;
          VALUE '' ;
          ACTION ( cAuxFileName := GetFile ( { {"RTF files", "*.rtf"} }, NIL, GetCurrentFolder() ),;
                   IF ( EMPTY(cAuxFileName),;
                   NIL,;
                 ( cFileName := cAuxFileName, Form_1.miniwrite_1.RTFLoadFile ( cFileName, 4, .F.), MAGISTER() , AGAPITO_RTF() ) )  ) ;
          TOOLTIP 'Open RTF Document File' ;
          TRANSPARENT

       @ 9,122 LABEL BOT_MINI4 ;
          WIDTH 16 HEIGHT 16 ;
          VALUE '' ;
          ACTION ( v_Print() ) ;
          TOOLTIP 'Preview, and print, with additional' + chr(10) + 'options like saving file as PDF.-' ;
          TRANSPARENT

       @ 9,144 LABEL BOT_MINI5 ;
          WIDTH 16 HEIGHT 16 ;
          VALUE '' ;
          ACTION ( HelpProc() ) ;
          TOOLTIP 'Help' ;
          TRANSPARENT

       @ 69,11 LABEL BOT_RIBC1 ;
          WIDTH 44 HEIGHT 44 ;
          VALUE '' ;
          ACTION Form_1.miniwrite_1.SelPaste () ;
          TOOLTIP 'Paste' ;
          TRANSPARENT

       @ 69,62 LABEL BOT_RIBC2 ;
          WIDTH 20 HEIGHT 19 ;
          VALUE '' ;
          ACTION MULTICUT() ;
          TOOLTIP 'Cut' ;
          TRANSPARENT

       @ 69,88 LABEL BOT_RIBC3 ;
          WIDTH 20 HEIGHT 19 ;
          VALUE '' ;
          ACTION MULTICOPY() ;
          TOOLTIP 'Copy' ;
          TRANSPARENT

       @ 94,62 LABEL BOT_RIBC4 ;
          WIDTH 20 HEIGHT 19 ;
          VALUE '' ;
          ACTION MULTICLEAR() ;
          TOOLTIP 'Clear / Delete selected word or paragraph' ;
          TRANSPARENT

       @ 94,88 LABEL BOT_RIBC5X ;
          WIDTH 20 HEIGHT 19 ;
          VALUE '' ;
          ACTION clipp_view() ;
          TOOLTIP 'View Clippboard contents' ;
          TRANSPARENT

       @ 94,125 LABEL BOT_RIBF1 ;
          WIDTH 19 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( cheka_bold() ) ;
          TOOLTIP 'Bold' ;
          TRANSPARENT

       @ 94,150 LABEL BOT_RIBF2 ;
          WIDTH 19 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( cheka_italic() ) ;
          TOOLTIP 'Italic' ;
          TRANSPARENT

       @ 94,175 LABEL BOT_RIBF3 ;
          WIDTH 19 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( cheka_subra() ) ;
          TOOLTIP 'Underline' ;
          TRANSPARENT

       @ 94,200 LABEL BOT_RIBF4 ;
          WIDTH 19 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( cheka_tacha() ) ;
          TOOLTIP 'Strike' ;
          TRANSPARENT

       @ 94,231 LABEL BOT_RIBF5 ;
          WIDTH 19 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( cheka_sub() );
          TOOLTIP 'SubScript' ;
          TRANSPARENT

       @ 94,256 LABEL BOT_RIBF6 ;
          WIDTH 19 HEIGHT 19 ;
          VALUE '' ;
          ACTION  ( cheka_sup() );
          TOOLTIP 'SuperScript' ;
          TRANSPARENT

       @ 119,270 LABEL BOT_RIBF6X ;
          WIDTH 7 HEIGHT 7 ;
          VALUE '' ;
          ACTION  ( Fontformat() );
          TOOLTIP 'Fonts / Types Options' ;
          TRANSPARENT

       @ 69,291 LABEL BOT_RIBP1 ;
          WIDTH 21 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( bull_set() );
          TOOLTIP 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Bullets' + chr(10) + 'Style active: None'  ;
          TRANSPARENT

       @ 69,314 LABEL BOT_RIBP1B ;
          WIDTH 9 HEIGHT 19 ;
          VALUE '' ;
          ACTION ParagraphFormat() ;
          TOOLTIP 'Bullets Options' ;
          TRANSPARENT

       @ 69,330 LABEL BOT_RIBP2 ;
          WIDTH 22 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( (Form_1.miniwrite_1.ParaIndent := Form_1.miniwrite_1.ParaIndent - 15, Form_1.miniwrite_1.ParaIndent := IF (Form_1.miniwrite_1.ParaIndent < 0 , 150, Form_1.miniwrite_1.ParaIndent)) ) ;
          TOOLTIP 'Offset out' ;
          TRANSPARENT

       @ 69,356 LABEL BOT_RIBP2_3 ;
          WIDTH 9 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( INCRE_DECRE() ) ;
          TOOLTIP 'Indent Options' ;
          TRANSPARENT

       @ 69,369 LABEL BOT_RIBP3 ;
          WIDTH 22 HEIGHT 19 ;
          VALUE '' ;
          ACTION (Form_1.miniwrite_1.ParaIndent := Form_1.miniwrite_1.ParaIndent + 15, Form_1.miniwrite_1.ParaIndent := IF (Form_1.miniwrite_1.ParaIndent > 150 , 0, Form_1.miniwrite_1.ParaIndent)) ;
          TOOLTIP 'Offset in' ;
          TRANSPARENT

       @ 69,398 LABEL BOT_RIBP4 ;
          WIDTH 21 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.ParaLineSpacing := memospace ) ;
          TOOLTIP memointerlin + tmemospace ;
          TRANSPARENT

       @ 69,421 LABEL BOT_RIBP4B ;
          WIDTH 9 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( L_SPAC() ) ;
          TOOLTIP 'Line Spacing Options' ;
          TRANSPARENT

       @ 94,290 LABEL BOT_RIBP5 ;
          WIDTH 24 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.ParaAlignment := RTF_LEFT , OnSelectProc() );
          TOOLTIP 'Apply paragraph alignment to Left' ;
          TRANSPARENT

       @ 94,319 LABEL BOT_RIBP6 ;
          WIDTH 24 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.ParaAlignment := RTF_CENTER , OnSelectProc() );
          TOOLTIP 'Apply paragraph alignment to Center' ;
          TRANSPARENT

       @ 94,348 LABEL BOT_RIBP7 ;
          WIDTH 24 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.ParaAlignment := RTF_RIGHT , OnSelectProc() );
          TOOLTIP 'Apply paragraph alignment to Right' ;
          TRANSPARENT

       @ 94,378 LABEL BOT_RIBP8 ;
          WIDTH 24 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.ParaAlignment := RTF_JUSTIFY , form_1.miniwrite_1.paraindent := 0 , form_1.miniwrite_1.paraoffset := 0 , OnSelectProc() );
          TOOLTIP 'Apply paragraph alignment to Justify' ;
          TRANSPARENT

       @ 94,407 LABEL BOT_RIBPF ;
          WIDTH 24 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( IF(form_1.miniwrite_1.ParaAlignment <> 4 , nil , ( form_1.miniwrite_1.paraindent := fsngi , form_1.miniwrite_1.paraoffset := FSNGO )) , OnSelectProc() );
          TOOLTIP 'Apply paragraph alignment to Justify' + chr(10) + 'with First Line programable indented' ;
          TRANSPARENT


       @ 69,446 LABEL BOT_RIBX01 ;
          WIDTH 20 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.Undo () ) ;
          TOOLTIP 'UNDO' ;
          TRANSPARENT

       @ 69,472 LABEL BOT_RIBX02 ;
          WIDTH 20 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.Redo () ) ;
          TOOLTIP 'REDO' ;
          TRANSPARENT

       @ 69,506 LABEL BOT_RIBX03 ;
          WIDTH 22 HEIGHT 19 ;
          VALUE '' ;
          ACTION  Form_1.miniwrite_1.Link := .T. ;
          TOOLTIP 'Poner Link' ;
          TRANSPARENT

       @ 69,547 LABEL BOT_RIBX04 ;
          WIDTH 24 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.CaretPos := 1 , cFind := Form_1.miniwrite_1.GetSelectText,;
                   FINDTEXTDIALOG ON ACTION FindReplaceOnClickProc() FIND cFind CHECKDOWN lDown CHECKMATCHCASE lMatchCase CHECKWHOLEWORD lWholeWord ) ;
          TOOLTIP 'Find' ;
          TRANSPARENT

       @ 69,580 LABEL BOT_RIBX05 ;
          WIDTH 24 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.CaretPos := 1 , cFind := Form_1.miniwrite_1.GetSelectText,;
                   REPLACETEXTDIALOG ON ACTION FindReplaceOnClickProc() FIND cFind REPLACE cReplace CHECKMATCHCASE lMatchCase CHECKWHOLEWORD lWholeWord ) ;
          TOOLTIP 'Find & Replace' ;
          TRANSPARENT

       @ 94,446 LABEL BOT_RIBE5 ;
          WIDTH 21 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.FontBackColor := -1 ) ;
          TOOLTIP 'Apply Default Windows Font Background Color' ;
          TRANSPARENT

       @ 94,469 LABEL BOT_RIBE6 ;
          WIDTH 9 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( aFontBackColor := GetColor ( Form_1.miniwrite_1.FontBackColor, NIL, .T.), IF (ValType (aFontBackColor [1]) == "N",( Form_1.miniwrite_1.FontBackColor := aFontBackColor  ) , NIL) );
          TOOLTIP 'Select and apply new Font Background Color' ;
          TRANSPARENT

       @ 94,485 LABEL BOT_RIBE7 ;
          WIDTH 21 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.FontColor := -1 ) ;
          TOOLTIP 'Apply Default Windows Font Color' ;
          TRANSPARENT

       @ 94,508 LABEL BOT_RIBE8 ;
          WIDTH 9 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( aFontColor := GetColor(Form_1.miniwrite_1.FontColor, NIL, .T.), IF (ValType (aFontColor [1]) == "N",( Form_1.miniwrite_1.FontColor := aFontColor ) , NIL) );
          TOOLTIP 'Select and apply new Font Color' ;
          TRANSPARENT

       @ 94,524 LABEL BOT_RIBE9 ;
          WIDTH 21 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( Form_1.miniwrite_1.BackgroundColor := RTF_AUTOBACKGROUNDCOLOR ) ;
          TOOLTIP 'Apply Default Windows Background Color' ;
          TRANSPARENT

       @ 94,547 LABEL BOT_RIBE10 ;
          WIDTH 9 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( aBackgroundColor := GetColor (NIL, NIL, .T.), IF (ValType (aBackgroundColor [1]) == "N",( Form_1.miniwrite_1.BackgroundColor := aBackgroundColor ) , NIL) ) ;
          TOOLTIP 'Select and apply new background Color' ;
          TRANSPARENT


      Form_1.miniwrite_1.BackGroundColor := aBackgroundColor

      Form_1.miniwrite_1.SelectAll ()
      Form_1.miniwrite_1.FontColor     := aFontColor
      Form_1.miniwrite_1.FontBackColor := aFontBackColor
      Form_1.miniwrite_1.UnSelectAll ()
      Form_1.miniwrite_1.CaretPos := 0

      Form_1.miniwrite_1.ClearUndoBuffer
      Form_1.BOT_RIBX01.Enabled := .F.
      Form_1.BOT_RIBX02.Enabled := .F.

  DEFINE TIMER keystatus INTERVAL 300 ;
    ACTION {||
      Form_1.BOT_CAPS.PICTURE := IF(ISCAPSLOCKACTIVE(), 'caps_on','caps_off')
      Form_1.BOT_NUM.PICTURE  := IF(ISNUMLOCKACTIVE() , 'num_on','num_off')
      Form_1.BOT_INS.PICTURE  := IF(ISINSERTACTIVE()  , 'ins_on','ins_off')
      RETURN NIL
      }

     SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

      IF FILE('RTF_INFO.RTF')
         cfilename := 'RTF_INFO.RTF'
         Form_1.miniwrite_1.RTFLoadFile ( cfilename, 4, .F.)
         activ_doc := "0"
         Aux_FileN0 := cFilename
         magister()
      ELSE
         Form_1.miniwrite_1.VALUE := "Microsoft said:" + HB_OSNEWLINE() + HB_OSNEWLINE() +;
                                    "Unicode is a worldwide character encoding standard that provides a unique number to represent " +;
                                    "each character used in modern computing, including technical symbols and special characters used in publishing. " +;
                                    "Unicode is required by modern standards, such as XML and ECMAScript (JavaScript), and is the official mechanism " +;
                                    "for implementing ISO/IEC 10646 (UCS: Universal Character Set). " + HB_OSNEWLINE() +;
                                    "It is supported by many operating systems, all modern browsers, and many other products. " +;
                                    "New Windows applications should use Unicode to avoid the inconsistencies of varied code pages and " +;
                                    "to aid in simplifying localization." + HB_OSNEWLINE() + HB_OSNEWLINE() +;
                                    "Thereby HMG-Unicode is the future in the xBase programming for Windows ..." + HB_OSNEWLINE() +;
                                    "www.hmgforum.com" + HB_OSNEWLINE()
      ENDIF

   END WINDOW

   CENTER   WINDOW Form_1
   ACTIVATE WINDOW Form_1

RETURN


PROCEDURE QUICK_MENU
cCurrentForm := "CALEN_F1"
	DEFINE WINDOW CALEN_F1 ;
      AT ctr + 33, ctc + 3 ;
		WIDTH 493 HEIGHT 487 ;
		TITLE '' ;
      MODAL ;
      NOSIZE ;
      NOSYSMENU ;
      NOCAPTION ;
      BACKCOLOR { 218,229,243 }

      DEFINE IMAGE MSGBUSCA_2
         ROW	0
         COL	0
         WIDTH	493
         HEIGHT 487
         PICTURE	'COMANDOS'
         STRETCH	.T.
      END IMAGE

      @ 33, 14 LABEL Q_1 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( COMANDOFF() , cheqlleno() , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Create a new document' ;
          TRANSPARENT

      @ 74, 14 LABEL Q_2 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( COMANDOFF() , cAuxFileName := GetFile ( { {"RTF files", "*.rtf"} }, NIL, GetCurrentFolder() ),;
                   IF ( EMPTY(cAuxFileName),;
                   NIL,;
                 ( cFileName := cAuxFileName, Form_1.miniwrite_1.RTFLoadFile ( cFileName, 4, .F.), MAGISTER() , AGAPITO_RTF() ) ) , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Load a Document' ;
          TRANSPARENT

      @ 115, 14 LABEL Q_3 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( COMANDOFF() , CLAPTON() , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Load a document from table list' ;
          TRANSPARENT

      @ 155, 14 LABEL Q_4 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( SaveFile() , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Save a document' ;
          TRANSPARENT

      @ 197, 14 LABEL Q_5 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( nil , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Save a document as' ;
          TRANSPARENT

      @ 238, 14 LABEL Q_6 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( COMANDOFF() , SET_PRIN() , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Set printer margins' ;
          TRANSPARENT

      @ 279, 14 LABEL Q_7 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( COMANDOFF() , O_PRINT() , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Print on Printer' ;
          TRANSPARENT

      @ 320, 14 LABEL Q_8 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( COMANDOFF() , V_PRINT() , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Preview, and print, with additional' + chr(10) + 'options like saving file as PDF.-' ;
          TRANSPARENT

      @ 367, 14 LABEL Q_9 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( COMANDOFF() , about() ,  CALEN_F1.RELEASE ) ;
          TOOLTIP 'About' ;
          TRANSPARENT

      @ 412, 14 LABEL Q_10 ;
          WIDTH 41 HEIGHT 34 ;
          VALUE '' ;
          ACTION ( FORM_1.miniwrite_1.SelectAll , FORM_1.miniwrite_1.SELCLEAR , CALEN_F1.RELEASE ) ;
          TOOLTIP 'Close this document' ;
          TRANSPARENT

      @ 460, 365 LABEL TEXTODEL_YES ;
          WIDTH 113 HEIGHT 16 ;
          VALUE '' ;
          ACTION ( CALEN_F1.RELEASE ) ;
          TOOLTIP 'Close Start Menu Window' ;
          TRANSPARENT

      SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW CALEN_F1
RETURN

**********************************************************
PROCEDURE V_Print
**********************************************************
LOCAL lSuccessVar

   SELECT PRINTER DIALOG TO lSuccessVar PREVIEW
   IF lSuccessVar == .T.
      aSelRange := { 0, -1 }
      MSPREH += " "
      MSPOSTH := " " + MSPOSTH
      nPag := 1
      PrintPageCodeBlock := { || @ nRow , nCol PRINT MSPREH + HB_NTOS( nPag++ ) + MSPOSTH CENTER }
      Form_1.miniwrite_1.RTFPrint ( aSelRange, mLeft, mTop, mRight, mBottom, PrintPageCodeBlock )
   ENDIF
RETURN

**********************************************************
PROCEDURE FindReplaceOnClickProc
**********************************************************
LOCAL lSelectFindText
LOCAL aPosRange := {0,0}

   IF FindReplaceDlg.RetValue == FRDLG_CANCEL
      RETURN
   ENDIF

   cFind           := FindReplaceDlg.Find
   cReplace        := FindReplaceDlg.Replace
   lDown           := FindReplaceDlg.Down
   lMatchCase      := FindReplaceDlg.MatchCase
   lWholeWord      := FindReplaceDlg.WholeWord
   lSelectFindText := .T.

   DO CASE
      CASE FindReplaceDlg.RetValue == FRDLG_FINDNEXT
           aPosRange := Form_1.miniwrite_1.FindText ( cFind, lDown, lMatchCase, lWholeWord, lSelectFindText )

      CASE FindReplaceDlg.RetValue == FRDLG_REPLACE
           aPosRange := Form_1.miniwrite_1.ReplaceText ( cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )

      CASE FindReplaceDlg.RetValue == FRDLG_REPLACEALL
           aPosRange := Form_1.miniwrite_1.ReplaceAllText ( cFind, cReplace, lMatchCase, lWholeWord, lSelectFindText )
   ENDCASE

   IF aPosRange [1] == -1
      MsgInfo ("Can't find the text:" + HB_OSNEWLINE() + cFind)
   ELSE
      MoveDialog ( aPosRange [1] )
   ENDIF

RETURN

**********************************************************
PROCEDURE MoveDialog ( nPos )
**********************************************************
LOCAL CharRowCol := Form_1.miniwrite_1.GetPosChar (nPos)
#define OFFSET_DLG 30

   IF CharRowCol [1] <> -1 .AND. CharRowCol [2] <> -1

      IF ( FindReplaceDlg.HEIGHT + OFFSET_DLG ) < CharRowCol [1]
         FindReplaceDlg.Row := CharRowCol [1] - ( FindReplaceDlg.HEIGHT + OFFSET_DLG )
      ELSEIF FindReplaceDlg.Row < CharRowCol [1] + OFFSET_DLG
         FindReplaceDlg.Row := CharRowCol [1] + OFFSET_DLG
      ENDIF

   ENDIF

RETURN



**********************************************************
PROCEDURE OnSelectProc
**********************************************************
STATIC xenix := .F.
LOCAL nPos
LOCAL cfrom
LOCAL cto
LOCAL ellugar

   IF xenix == .T.
      RETURN
   ENDIF
   xenix := .T.


   master := HB_VALTOEXP (Form_1.miniwrite_1.SelectRange)
   master := HB_URIGHT(master,HMG_LEN(Master)-1)
   master := HB_ULEFT (master,HMG_LEN(master)-1)
   master := STRTRAN ( master ,",", ".")
   ellugar := HB_UAT(".",master)
   cfrom   := HB_ULEFT (master,ellugar -1)
   cto     := HB_URIGHT(master,ellugar)
   FORM_1.SELE_FROM.VALUE :=  ALLTRIM(cfrom)
   FORM_1.SELE_TO.VALUE   :=  ALLTRIM(cto)

   nPos := ASCAN ( aFontList, Form_1.miniwrite_1.FontName )
   IF nPos > 0
      Form_1.Combo_1.VALUE := nPos
   ENDIF

   nPos := ASCAN ( aFontSize, HB_NTOS (Form_1.miniwrite_1.FontSize) )
   IF nPos > 0
      Form_1.Combo_2.VALUE := nPos
   ENDIF

   IF ( Form_1.miniwrite_1.FontBold , FORM_1.BOT_BOLD.PICTURE := "bold_on" , FORM_1.BOT_BOLD.PICTURE := "bold_off" )
   IF ( Form_1.miniwrite_1.FontItalic , FORM_1.BOT_ITAL.PICTURE := "ital_on" , FORM_1.BOT_ITAL.PICTURE := "ital_off" )
   IF ( Form_1.miniwrite_1.FontUnderline , FORM_1.BOT_SUBRA.PICTURE := "subra_on" , FORM_1.BOT_SUBRA.PICTURE := "subra_off" )
   IF ( Form_1.miniwrite_1.FontStrikeOut , FORM_1.BOT_TACHA.PICTURE := "tach_on" , FORM_1.BOT_TACHA.PICTURE := "tach_off" )
   IF ( Form_1.miniwrite_1.FontScript == RTF_SUBSCRIPT , ( FORM_1.BOT_SUB.PICTURE := "sub_on" , FORM_1.BOT_SUP.PICTURE := "sup_off" ), FORM_1.BOT_SUB.PICTURE := "sub_off" )
   IF ( Form_1.miniwrite_1.FontScript == RTF_SUPERSCRIPT , ( FORM_1.BOT_SUP.PICTURE := "sup_on" , FORM_1.BOT_SUB.PICTURE := "sub_off" ) , FORM_1.BOT_SUP.PICTURE := "sup_off" )

   DO CASE
      CASE Form_1.miniwrite_1.ParaAlignment == RTF_LEFT
           Form_1.BOT_ALIZQ.PICTURE	:= 'alin_izq_on'
           Form_1.BOT_ALCENT.PICTURE := 'alin_cent_off'
           Form_1.BOT_ALDER.PICTURE := 'alin_dere_off'
           FORM_1.BOT_JUSTI.PICTURE := 'alin_justi_off'
           FORM_1.BOT_FRENCH.PICTURE := 'alin_french_off'
      CASE Form_1.miniwrite_1.ParaAlignment == RTF_CENTER
           Form_1.BOT_ALIZQ.PICTURE	:= 'alin_izq_off'
           Form_1.BOT_ALCENT.PICTURE := 'alin_cent_on'
           Form_1.BOT_ALDER.PICTURE := 'alin_dere_off'
           FORM_1.BOT_JUSTI.PICTURE := 'alin_justi_off'
           FORM_1.BOT_FRENCH.PICTURE := 'alin_french_off'
      CASE Form_1.miniwrite_1.ParaAlignment == RTF_RIGHT
           Form_1.BOT_ALIZQ.PICTURE	:= 'alin_izq_off'
           Form_1.BOT_ALCENT.PICTURE := 'alin_cent_off'
           Form_1.BOT_ALDER.PICTURE := 'alin_dere_on'
           FORM_1.BOT_JUSTI.PICTURE := 'alin_justi_off'
           FORM_1.BOT_FRENCH.PICTURE := 'alin_french_off'
      CASE Form_1.miniwrite_1.ParaAlignment == RTF_JUSTIFY
           Form_1.BOT_ALIZQ.PICTURE	:= 'alin_izq_off'
           Form_1.BOT_ALCENT.PICTURE := 'alin_cent_off'
           Form_1.BOT_ALDER.PICTURE := 'alin_dere_off'
           FORM_1.BOT_JUSTI.PICTURE := 'alin_justi_on'
           scourge := form_1.miniwrite_1.paraindent
           SCOURGE := ROUND(scourge,1)
           RACERX  := form_1.miniwrite_1.paraoffset
           RACERX  := ROUND(racerx,1)
           IF scourge == fsngi .AND. racerx == FSNGO
              FORM_1.BOT_FRENCH.PICTURE := 'alin_french_on'
              FORM_1.BOT_JUSTI.PICTURE := 'alin_justi_off'
           ELSE
              FORM_1.BOT_FRENCH.PICTURE := 'alin_french_off'
           ENDIF
   END CASE

   xenix := .F.
RETURN

*****************************************************************
PROCEDURE OnLinkProc
*****************************************************************
   cLink := ALLTRIM ( ThisRichEditBox.GetClickLinkText )

   IF  HMG_LOWER( HB_USUBSTR (cLink,1,7) ) == "http://" .OR. HMG_LOWER( HB_USUBSTR (cLink,1,4) ) == "www."
       ShellExecute ( NIL, "Open", cLink, NIL, NIL, SW_SHOWNORMAL )

   ELSEIF "@" $ cLink .AND. "." $ cLink .AND. .NOT.( " " $ cLink )
       ShellExecute ( NIL, "Open", "rundll32.exe", "url.dll,FileProtocolHandler mailto:" + cLink, NIL, SW_SHOWNORMAL )

   ELSE
       MsgInfo ( cLink, "On Link" )
   ENDIF

RETURN


*****************************************************************
PROCEDURE HelpProc
*****************************************************************
cCurrentForm := "Form_2"
   Form_1.BOT_MINI5.ENABLED := .F.

   DEFINE WINDOW Form_2 ;
      AT ctr + 40, ctc + 97 ;
      WIDTH 636 ;
      HEIGHT 529 ;
      TITLE '' ;
      MODAL ;
      NOSIZE ;
      NOSYSMENU ;
      NOCAPTION ;
      BACKCOLOR { 218,229,243 } ;
      ON INIT     ( Form_2.RichEditBox_2.RTFLoadFile ("Help.RTF", .F., 4) );
      ON RELEASE  ( Form_1.BOT_MINI5.ENABLED := .T. );

      DEFINE IMAGE RIB_1
         ROW	0
         COL	0
         WIDTH	636
         HEIGHT 24
         PICTURE	'HP_S'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE RIB_2
         ROW	24
         COL	0
         WIDTH	7
         HEIGHT 475
         PICTURE	'BULLET_Il'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE RIB_3
         ROW	24
         COL	626
         WIDTH	10
         HEIGHT 475
         PICTURE	'HP_D'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE RIB_4
         ROW	496
         COL	0
         WIDTH	636
         HEIGHT 33
         PICTURE	'HP_I'
         STRETCH	.T.
      END IMAGE


      @ 30,10 RICHEDITBOX RichEditBox_2 ;
         WIDTH 610 ;
         HEIGHT 458 ;
         MAXLENGTH -1;
         NOHSCROLL;
         READONLY;
         BACKCOLOR {255,255,255}

      @ 500, 442 LABEL RESPDEL_YES ;
          WIDTH 80 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( v_Print() , Form_2.Release ) ;
          TOOLTIP '' ;
          BACKCOLOR { 7 , 71 , 41 } ;
          TRANSPARENT

      @ 500, 543 LABEL RESPDEL_NO ;
          WIDTH 80 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( Form_2.Release ) ;
          TOOLTIP '' ;
          BACKCOLOR {218,229,243} ;
          TRANSPARENT

      SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW Form_2

RETURN

*****************************************************************
PROCEDURE InfoProc
*****************************************************************
cCurrentForm := "Form_3"
   DEFINE WINDOW Form_3 ;
      AT 0,0 ;
      WIDTH 400 HEIGHT 300 ;
      MODAL;
      NOCAPTION;
      NOSIZE

      @ 10,10 RICHEDITBOX RichEditBox_3 ;
         WIDTH  Form_3.ClientAreaWidth  - 20 ;
         HEIGHT Form_3.ClientAreaHeight - 20 ;
         MAXLENGTH -1;
         NOHSCROLL;
         READONLY;
         BACKCOLOR NAVY;
         ON LINK IF ( HMG_UPPER( ALLTRIM (ThisRichEditBox.GetClickLinkText) ) == HMG_UPPER ("Click Here"), Form_3.Release, OnLinkProc ( ThisRichEditBox.GetClickLinkText ) )

         ON KEY  ESCAPE  ACTION Form_3.Release

         CreateTextRTF ()

      SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   CENTER   WINDOW Form_3
   ACTIVATE WINDOW Form_3

RETURN


**************************
PROCEDURE CreateTextRTF
**************************

   Form_3.RichEditBox_3.VALUE := " " + HB_OSNEWLINE()

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := "RichEditBox Demo"
      Form_3.RichEditBox_3.FontName      := "Comic Sans MS"
      Form_3.RichEditBox_3.FontSize      := 24
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .T.
      Form_3.RichEditBox_3.FontColor     := RED

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := HB_OSNEWLINE() + "by Dr. Claudio Soto" + HB_OSNEWLINE()
      Form_3.RichEditBox_3.FontName      := "Book Antiqua"
      Form_3.RichEditBox_3.FontSize      := 16
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .F.
      Form_3.RichEditBox_3.FontColor     := SILVER

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := "srvet@adinet.com.uy "
      Form_3.RichEditBox_3.FontName      := "Arial"
      Form_3.RichEditBox_3.FontSize      := 12
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .T.
      Form_3.RichEditBox_3.FontColor     := YELLOW
      Form_3.RichEditBox_3.Link          := .T.
      Form_3.RichEditBox_3.AddText (-1)  := HB_OSNEWLINE()

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := "http://srvet.blogspot.com" + HB_OSNEWLINE()
      Form_3.RichEditBox_3.FontName      := "Arial"
      Form_3.RichEditBox_3.FontSize      := 12
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .T.
      Form_3.RichEditBox_3.FontColor     := YELLOW

      Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := HB_OSNEWLINE() + "Press ESC or "
      Form_3.RichEditBox_3.FontName      := "Book Antiqua"
      Form_3.RichEditBox_3.FontSize      := 8
      Form_3.RichEditBox_3.FontBold      := .T.
      Form_3.RichEditBox_3.FontItalic    := .F.
      Form_3.RichEditBox_3.FontColor     := { 168, 168, 0}
      Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := " Click Here "
      Form_3.RichEditBox_3.Link          := .T.
      Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := " for Close this Window" + HB_OSNEWLINE()

   Form_3.RichEditBox_3.AddTextAndSelect ( -1 ) := " "

   Form_3.RichEditBox_3.SelectAll ()
      Form_3.RichEditBox_3.ParaAlignment   := RTF_CENTER
      Form_3.RichEditBox_3.ParaLineSpacing := 1.5
   Form_3.RichEditBox_3.UnSelectAll ()

RETURN

PROCEDURE MARVIN
IF (Form_1.miniwrite_1.CanUndo,  (Form_1.BOT_RIBX01.Enabled := .T.) ,  (Form_1.BOT_RIBX01.Enabled := .F.))
IF (Form_1.miniwrite_1.CanRedo,  (Form_1.BOT_RIBX02.Enabled := .T.) ,  (Form_1.BOT_RIBX02.Enabled := .F.))
IF (Form_1.miniwrite_1.FontBold, (Form_1.BOT_BOLD.PICTURE := 'bold_on') ,  (Form_1.BOT_BOLD.PICTURE := 'bold_off'))
IF (Form_1.miniwrite_1.FontItalic , Form_1.BOT_ITAL.PICTURE := 'ital_on' , FORM_1.BOT_ITAL.PICTURE := "ital_off" )

IF ( Form_1.miniwrite_1.FontUnderline , FORM_1.BOT_SUBRA.PICTURE := "subra_on" , FORM_1.BOT_SUBRA.PICTURE := "subra_off" )
IF ( Form_1.miniwrite_1.FontStrikeOut , FORM_1.BOT_TACHA.PICTURE := "tach_on" , FORM_1.BOT_TACHA.PICTURE := "tach_off" )
IF ( Form_1.miniwrite_1.FontScript == RTF_SUBSCRIPT , ( FORM_1.BOT_SUB.PICTURE := "sub_on" , FORM_1.BOT_SUP.PICTURE := "sup_off" ), FORM_1.BOT_SUB.PICTURE := "sub_off" )
IF ( Form_1.miniwrite_1.FontScript == RTF_SUPERSCRIPT , ( FORM_1.BOT_SUP.PICTURE := "sup_on" , FORM_1.BOT_SUB.PICTURE := "sub_off" ) , FORM_1.BOT_SUP.PICTURE := "sup_off" )

IF (Form_1.miniwrite_1.CanUndo,  (Form_1.BOT_RIBX01.Enabled := .T.) ,  (Form_1.BOT_RIBX01.Enabled := .F.))
IF (Form_1.miniwrite_1.CanRedo,  (Form_1.BOT_RIBX02.Enabled := .T.) ,  (Form_1.BOT_RIBX02.Enabled := .F.))

Form_1.miniwrite_1.Refresh
RETURN



PROCEDURE elsub
Form_1.miniwrite_1.FontScript := RTF_SUBSCRIPT

RETURN

PROCEDURE elsup
Form_1.miniwrite_1.FontScript := RTF_SUPERSCRIPT

RETURN

PROCEDURE cheka_bold
IF Form_1.miniwrite_1.FontBold == .F.
   Form_1.miniwrite_1.FontBold := .T.
   Form_1.BOT_BOLD.PICTURE := 'bold_on'
   RETURN
ENDIF
IF Form_1.miniwrite_1.FontBold == .T.
   Form_1.miniwrite_1.FontBold := .F.
   Form_1.BOT_BOLD.PICTURE := 'bold_off'
   RETURN
ENDIF
RETURN

PROCEDURE cheka_italic
IF Form_1.miniwrite_1.FontItalic == .F.
   Form_1.miniwrite_1.FontItalic := .T.
   Form_1.BOT_ITAL.PICTURE := 'ital_on'
   RETURN
ENDIF
IF Form_1.miniwrite_1.FontItalic == .T.
   Form_1.miniwrite_1.FontItalic := .F.
   Form_1.BOT_ITAL.PICTURE := 'ital_on'
   RETURN
ENDIF
RETURN

PROCEDURE cheka_subra
IF Form_1.miniwrite_1.FontUnderline == .F.
   Form_1.miniwrite_1.FontUnderline := .T.
   Form_1.BOT_SUBRA.PICTURE := 'subra_on'
   RETURN
ENDIF
IF Form_1.miniwrite_1.FontUnderline == .T.
   Form_1.miniwrite_1.FontUnderline := .F.
   Form_1.BOT_SUBRA.PICTURE := 'subra_on'
   RETURN
ENDIF
RETURN

PROCEDURE cheka_tacha
IF Form_1.miniwrite_1.FontStrikeOut == .F.
   Form_1.miniwrite_1.FontStrikeOut := .T.
   Form_1.BOT_TACHA.PICTURE := 'tach_on'
   RETURN
ENDIF
IF Form_1.miniwrite_1.FontStrikeOut == .T.
   Form_1.miniwrite_1.FontStrikeOut := .F.
   Form_1.BOT_TACHA.PICTURE := 'tach_on'
   RETURN
ENDIF
RETURN

PROCEDURE cheka_sub
IF Form_1.miniwrite_1.FontScript == RTF_SUBSCRIPT
   Form_1.miniwrite_1.FontScript := RTF_NORMALSCRIPT
   Form_1.BOT_SUB.PICTURE := 'sub_off'
   RETURN
ENDIF
IF Form_1.miniwrite_1.FontScript <> RTF_SUBSCRIPT
   Form_1.miniwrite_1.FontScript := RTF_SUBSCRIPT
   Form_1.BOT_SUB.PICTURE := 'sub_on'
   RETURN
ENDIF
RETURN

PROCEDURE cheka_sup
IF Form_1.miniwrite_1.FontScript == RTF_SUPERSCRIPT
   Form_1.miniwrite_1.FontScript := RTF_NORMALSCRIPT
   Form_1.BOT_SUP.PICTURE := 'sup_off'
   RETURN
ENDIF
IF Form_1.miniwrite_1.FontScript <> RTF_SUPERSCRIPT
   Form_1.miniwrite_1.FontScript := RTF_SUPERSCRIPT
   Form_1.BOT_SUP.PICTURE := 'sup_on'
   RETURN
ENDIF
RETURN


PROCEDURE FontFormat

LOCAL aFont := GETFONT( ;
  Form_1.miniwrite_1.FONTNAME     , ;
  Form_1.miniwrite_1.FONTSIZE     , ;
  Form_1.miniwrite_1.FONTBOLD     , ;
  Form_1.miniwrite_1.FONTITALIC   , ;
  Form_1.miniwrite_1.FONTCOLOR    , ;
  Form_1.miniwrite_1.FONTUNDERLINE, ;
  Form_1.miniwrite_1.FONTSTRIKEOUT  )

LOCAL nPos

IF !EMPTY(aFont[1])
  Form_1.miniwrite_1.FONTNAME          := cFontName := aFont[1]
  Form_1.miniwrite_1.FONTSIZE          := nFontSize := aFont[2]
  Form_1.miniwrite_1.FONTBOLD          := aFont[3]
  Form_1.miniwrite_1.FONTITALIC        := aFont[4]
  Form_1.miniwrite_1.FONTCOLOR         := aFontColor := aFont[5]
  Form_1.miniwrite_1.FONTUNDERLINE     := aFont[6]
  Form_1.miniwrite_1.FONTSTRIKEOUT     := aFont[7]
  Form_1.COMBO_1.DISPLAYVALUE := cFontName
  Form_1.COMBO_2.DISPLAYVALUE := nFontSize
ENDIF

RETURN

PROCEDURE ParagraphFormat
LOCAL funes := VAL(HB_ULEFT(memobull,1))
LOCAL mori := VAL(HB_URIGHT(memobull,1)) + 1
LOCAL lNum
LOCAL xNew, xOld
LOCAL hBitmap1 := 0

cCurrentForm := "Parabull"

DEFINE WINDOW Parabull ;
  AT ctr + 140, ctc + 270 ;
  WIDTH 403 ;
  HEIGHT 239 ;
  TITLE '' ;
  MODAL ;
  NOSIZE ;
  NOSYSMENU ;
  NOCAPTION ;
  BACKCOLOR { 218,229,243 }

  DEFINE IMAGE RIB_1
    ROW	0
    COL	0
    WIDTH	403
    HEIGHT 24
    PICTURE	'BULLET_S'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_2
    ROW	24
    COL	0
    WIDTH	7
    HEIGHT 200
    PICTURE	'BULLET_Il'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_3
    ROW	24
    COL	392
    WIDTH	11
    HEIGHT 200
    PICTURE	'BULLET_ID'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_4
    ROW	206
    COL	0
    WIDTH	403
    HEIGHT 33
    PICTURE	'BULLET_I'
    STRETCH	.T.
  END IMAGE

  @ 25, 10 FRAME frNum ;
    CAPTION 'Bullets types' ;
    WIDTH 380 ;
    HEIGHT 175 ;
    TRANSPARENT

  @ 160, 10 FRAME frNumB ;
    CAPTION '' ;
    WIDTH 230 ;
    HEIGHT 40 ;
    TRANSPARENT

  @ 35, 240 FRAME frNumC ;
    CAPTION 'Style' ;
    WIDTH 140 ;
    HEIGHT 160 ;
    TRANSPARENT

  @ 40, 20 RADIOGROUP rgNumFormat ;
    OPTIONS { 'Bullets','Arabic numerals','Lowercase letters','Lowercase Roman numerals','Uppercase letters','Uppercase Roman numerals' } ;
    VALUE funes ;
    WIDTH 185 ;
    SPACING 20 ;
    ON CHANGE ( samplebull() ) ;
    TRANSPARENT

  @ 50,250 RADIOGROUP rgNumStyle ;
    OPTIONS { 'No punctuation','Period','Right parenthesis','Two parentheses','Hidden number' } ;
    VALUE mori ;
    WIDTH 120 ;
    SPACING 20 ;
    ON CHANGE ( STYLEBULL() ) ;
    TRANSPARENT

   Parabull.rgNumStyle.ENABLED := .F.

  @ 167, 250 LABEL laNumStart VALUE 'Start with:' AUTOSIZE TRANSPARENT

  @ 165,330 TEXTBOX tbNumStart ;
    WIDTH 40 ;
    HEIGHT 20 ;
    VALUE 1 ;
    NUMERIC INPUTMASK '999'

  DEFINE IMAGE BULL_SAMPLE
    ROW	175
    COL	25
    WIDTH	205
    HEIGHT 20
    PICTURE	'MSGBULL00'
    STRETCH	.T.
  END IMAGE

  @ 210, 28 LABEL RESPDEL_CLEAR ;
          WIDTH 150 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( FORM_1.miniwrite_1.ParaNumbering := RTF_NOBULLETNUMBER , FORM_1.miniwrite_1.ParaOffset := 0 , Parabull.Release ) ;
          TOOLTIP '' ;
          BACKCOLOR { 218,229,243 } ;
          TRANSPARENT


  @ 210, 192 LABEL RESPDEL_YES ;
          WIDTH 92 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( ACTUA_BULL() , Parabull.Release ) ;
          TOOLTIP '' ;
          BACKCOLOR { 218,229,243 } ;
          TRANSPARENT

  @ 210, 298 LABEL RESPDEL_NO ;
          WIDTH 92 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( Parabull.Release ) ;
          TOOLTIP '' ;
          BACKCOLOR { 218,229,243 } ;
          TRANSPARENT

     SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO


END WINDOW

ACTIVATE WINDOW Parabull

RETURN

//***************************************************************************

STATIC PROCEDURE ParagraphInit

LOCAL nParAlign     := Form_1.miniwrite_1.PARAALIGNMENT
LOCAL nParIndent    := Form_1.miniwrite_1.PARAINDENT
LOCAL nParOffset    := Form_1.miniwrite_1.PARAOFFSET
LOCAL nParSpacing   := Form_1.miniwrite_1.PARALINESPACING
LOCAL nParNumFormat := Form_1.miniwrite_1.PARANUMBERING
LOCAL nParNumStyle  := Form_1.miniwrite_1.PARANUMBERINGSTYLE
LOCAL nParNumStart  := Form_1.miniwrite_1.PARANUMBERINGSTART
LOCAL lNum          := (nParNumFormat >= RTF_ARABICNUMBER)

Parabull.rgAlign.VALUE            := ASCAN(aAlignValue, nParAlign)
Parabull.tbLeftIndent.VALUE       := nParIndent
Parabull.tbLeftOffset.VALUE       := nParOffset
Parabull.coLineSpace.DISPLAYVALUE := STR(MIN(99, nParSpacing), 4, 1)
Parabull.rgNumFormat.VALUE        := nParNumFormat
Parabull.rgNumStyle.VALUE         := MAX(1, IF(lNum, nParNumStyle, RTF_PERIOD) - 1)
Parabull.tbNumStart.VALUE         := IF(lNum, nParNumStart, 1)
Parabull.rgNumStyle.ENABLED       := lNum
Parabull.laNumStart.ENABLED       := lNum
Parabull.tbNumStart.ENABLED       := lNum

RETURN

//***************************************************************************

STATIC PROCEDURE ParagraphSet

LOCAL nParAlign     := Parabull.rgAlign.VALUE
LOCAL nParIndent    := Parabull.tbLeftIndent.VALUE
LOCAL nParOffset    := Parabull.tbLeftOffset.VALUE
LOCAL nParSpacing   := VAL(Parabull.coLineSpace.DISPLAYVALUE)
LOCAL nParNumFormat := Parabull.rgNumFormat.VALUE
LOCAL nParNumStyle  := Parabull.rgNumStyle.VALUE
LOCAL nParNumStart  := Parabull.tbNumStart.VALUE
LOCAL lNum          := (nParNumFormat >= RTF_ARABICNUMBER)

Parabull.RELEASE
Form_1.miniwrite_1.PARAALIGNMENT      := aAlignValue[nParAlign]
Form_1.miniwrite_1.PARAINDENT         := nParIndent
Form_1.miniwrite_1.PARAOFFSET         := nParOffset
Form_1.miniwrite_1.PARALINESPACING    := nParSpacing
Form_1.miniwrite_1.PARANUMBERING      := nParNumFormat
IF lNum
  Form_1.miniwrite_1.PARANUMBERINGSTYLE := nParNumStyle + 1
  Form_1.miniwrite_1.PARANUMBERINGSTART := nParNumStart
ELSE
  Form_1.miniwrite_1.PARANUMBERINGSTYLE := RTF_NOBULLETNUMBER
  Form_1.miniwrite_1.PARANUMBERINGSTART := 0
END

RETURN


PROCEDURE O_Print
LOCAL lSuccessVar

   SELECT PRINTER DIALOG TO lSuccessVar

   IF lSuccessVar == .T.

      aSelRange := { 0, -1 }
      MSPREH += " "
      MSPOSTH := " " + MSPOSTH
      nPag := 1

      PrintPageCodeBlock := { || @ nRow , nCol PRINT MSPREH + HB_NTOS( nPag++ ) + MSPOSTH CENTER }

      Form_1.miniwrite_1.RTFPrint ( aSelRange, mLeft, mTop, mRight, mBottom, PrintPageCodeBlock )

   ENDIF
RETURN


PROCEDURE L_SPAC
cCurrentForm := "SPACE_L"

DEFINE WINDOW SPACE_L ;
  AT ctr + 140, ctc + 270 ;
  WIDTH 215 ;
  HEIGHT 200 ;
  TITLE '' ;
  MODAL ;
  NOSIZE ;
  NOSYSMENU ;
  NOCAPTION ;
  BACKCOLOR { 218,229,243 } ;
  ON INIT  nil



  DEFINE IMAGE RIB_1
    ROW	0
    COL	0
    WIDTH  215
    HEIGHT 24
    PICTURE	'SPACELIN_S'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_2
    ROW	24
    COL	0
    WIDTH	7
    HEIGHT 161
    PICTURE	'BULLET_Il'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_3
    ROW	24
    COL	204
    WIDTH	11
    HEIGHT 161
    PICTURE	'BULLET_ID'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_4
    ROW	167
    COL	0
    WIDTH	215
    HEIGHT 33
    PICTURE	'SHORT_I'
    STRETCH	.T.
  END IMAGE



  @ 40, 50 RADIOGROUP Interlin ;
    OPTIONS {'1.0 Space Line','1.5 Space Line','2.0 Space Line','2.5 Space Line','3.0 Space Line'} ;
    VALUE 1 ;
    WIDTH 110 ;
    SPACING 20 ;
    ON CHANGE ( nil ) ;
    TRANSPARENT

  @ 171, 10 LABEL RESPDEL_YES ;
          WIDTH 83 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( SPACER() , SPACE_L.Release ) ;
          TOOLTIP '' ;
          BACKCOLOR { 218,229,243 } ;
          TRANSPARENT

  @ 171, 116 LABEL RESPDEL_NO ;
          WIDTH 83 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( SPACE_L.Release ) ;
          TOOLTIP '' ;
          BACKCOLOR { 218,229,243 } ;
          TRANSPARENT

     SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO


   END WINDOW

   ACTIVATE WINDOW SPACE_L


RETURN


PROCEDURE CLOSE_AUXDOC
cCurrentForm := "REFAY"

DEFINE WINDOW REFAY ;
  AT ctr + 140, ctc + 540 ;
  WIDTH 215 ;
  HEIGHT 200 ;
  TITLE '' ;
  MODAL ;
  NOSIZE ;
  NOSYSMENU ;
  NOCAPTION ;
  BACKCOLOR { 255,255,255 } ;
  ON INIT  nil

  DEFINE IMAGE RIB_1
    ROW	0
    COL	0
    WIDTH  215
    HEIGHT 24
    PICTURE	'CLEANUAX'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_2
    ROW	24
    COL	0
    WIDTH	7
    HEIGHT 161
    PICTURE	'BULLET_Il'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_3
    ROW	24
    COL	204
    WIDTH	11
    HEIGHT 161
    PICTURE	'BULLET_ID'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_4
    ROW	167
    COL	0
    WIDTH	215
    HEIGHT 33
    PICTURE	'CLEANINF'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE IAUX_BOT1
    ROW	35
    COL	40
    WIDTH 121
    HEIGHT 21
    PICTURE	'BOT_AUX1_OFF'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE IAUX_BOT2
    ROW	60
    COL	40
    WIDTH 121
    HEIGHT 21
    PICTURE	'BOT_AUX2_OFF'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE IAUX_BOT3
    ROW	85
    COL	40
    WIDTH 121
    HEIGHT 21
    PICTURE	'BOT_AUX3_OFF'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE IAUX_BOT4
    ROW	110
    COL	40
    WIDTH 121
    HEIGHT 21
    PICTURE	'BOT_AUX4_OFF'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE IAUX_BOT5
    ROW	135
    COL	40
    WIDTH 121
    HEIGHT 21
    PICTURE	'BOT_AUX5_OFF'
    STRETCH	.T.
  END IMAGE

  @ 37, 42 LABEL BOT1_RESP ;
          WIDTH 117 HEIGHT 17 ;
          VALUE '' ;
          ACTION ( IF(EMPTY(ALLTRIM(AUX_FILEN1)) , nil  , MARCACLEAN1() )  )  ;
          TOOLTIP '' ;
          TRANSPARENT

  @ 62, 42 LABEL BOT2_RESP ;
          WIDTH 117 HEIGHT 17 ;
          VALUE '' ;
          ACTION ( IF(EMPTY(ALLTRIM(AUX_FILEN2)) , nil  , MARCACLEAN2() )  )  ;
          TOOLTIP '' ;
          TRANSPARENT

  @ 87, 42 LABEL BOT3_RESP ;
          WIDTH 117 HEIGHT 17 ;
          VALUE '' ;
          ACTION ( IF(ALLTRIM(FORM_1.AUXILIARY_3.VALUE) == '' , MSGINFO("DID NOTHING","Warning") , MARCACLEAN3() )  )  ;
          TOOLTIP '' ;
          TRANSPARENT

  @ 112, 42 LABEL BOT4_RESP ;
          WIDTH 117 HEIGHT 17 ;
          VALUE '' ;
          ACTION ( IF(EMPTY(ALLTRIM(AUX_FILEN4)) , nil , MARCACLEAN4() )  ) ;
          TOOLTIP '' ;
          TRANSPARENT

  @ 137, 42 LABEL BOT5_RESP ;
          WIDTH 117 HEIGHT 17 ;
          VALUE '' ;
          ACTION ( IF(EMPTY(ALLTRIM(AUX_FILEN5)) , nil , MARCACLEAN5() )  ) ;
          TOOLTIP '' ;
          TRANSPARENT


  @ 171, 10 LABEL RESPDEL_YES ;
          WIDTH 83 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( future_clean() , REFAY.Release ) ;
          TOOLTIP '' ;
          TRANSPARENT

  @ 171, 116 LABEL RESPDEL_NO ;
          WIDTH 83 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( REFAY.Release ) ;
          TOOLTIP '' ;
          TRANSPARENT

     SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW REFAY


RETURN

PROCEDURE SPACER
IF ( SPACE_L.interlin.value == 1 , ( memospace := 1.0 , tmemospace := "Line Spacing Value : " + ALLTRIM(STR(memospace)) ), nil)
IF ( SPACE_L.interlin.value == 2 , ( memospace := 1.5 , tmemospace := "Line Spacing Value : " + ALLTRIM(STR(memospace)) ), nil)
IF ( SPACE_L.interlin.value == 3 , ( memospace := 2.0 , tmemospace := "Line Spacing Value : " + ALLTRIM(STR(memospace)) ), nil)
IF ( SPACE_L.interlin.value == 4 , ( memospace := 2.5 , tmemospace := "Line Spacing Value : " + ALLTRIM(STR(memospace)) ), nil)
IF ( SPACE_L.interlin.value == 5 , ( memospace := 3.0 , tmemospace := "Line Spacing Value : " + ALLTRIM(STR(memospace)) ), nil)
RETURN

PROCEDURE INCRE_DECRE
cCurrentForm := "INDENT_L"

DEFINE WINDOW INDENT_L ;
  AT ctr + 140, ctc + 270 ;
  WIDTH 215 ;
  HEIGHT 180 ;
  TITLE '' ;
  MODAL ;
  NOSIZE ;
  NOSYSMENU ;
  NOCAPTION ;
  BACKCOLOR { 218,229,243 } ;
  ON INIT  nil

  DEFINE IMAGE RIB_1
    ROW	0
    COL	0
    WIDTH  215
    HEIGHT 24
    PICTURE	'INDENT_S'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_2
    ROW	24
    COL	0
    WIDTH	7
    HEIGHT 141
    PICTURE	'BULLET_Il'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_3
    ROW	24
    COL	204
    WIDTH	11
    HEIGHT 141
    PICTURE	'BULLET_ID'
    STRETCH	.T.
  END IMAGE

  DEFINE IMAGE RIB_4
    ROW	147
    COL	0
    WIDTH	215
    HEIGHT 33
    PICTURE	'SHORT_I'
    STRETCH	.T.
  END IMAGE

  @   25, 10 FRAME IND_01 ;
            CAPTION 'Indent All Paragraph' ;
            WIDTH 190 ;
            HEIGHT 65 ;
            TRANSPARENT

  @   95, 10 FRAME IND_02 ;
            CAPTION 'Indent Paragraph French Style' ;
            WIDTH 190 ;
            HEIGHT 45 ;
            TRANSPARENT

  @ 151, 10 LABEL RESPDEL_YES ;
          WIDTH 83 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( FSNGI := INDENT_L.LINE_FIRST.VALUE , FSNGO := INDENT_L.LINE_FIRST.VALUE - INDENT_L.LINE_FIRST.VALUE - INDENT_L.LINE_FIRST.VALUE , INDENT_L.Release ) ; // ParagraphSet() , Parabull.Release
          TOOLTIP '' ;
          TRANSPARENT

  @ 151, 116 LABEL RESPDEL_NO ;
          WIDTH 83 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( INDENT_L.Release ) ;
          TOOLTIP '' ;
          TRANSPARENT

  @  44, 20 LABEL Label_I1 ;
            VALUE 'OUT indentation (mm)' ;
            AUTOSIZE ;
            FONT "CALIBRI" SIZE 10 ;
            TRANSPARENT

  @  42,145 TEXTBOX Out_Ind ;
            WIDTH 40 ;
            HEIGHT 20 ;
            VALUE 0 ;
            NUMERIC INPUTMASK '99 '


  @  67, 20 LABEL Label_I2 ;
            VALUE 'IN indentation (mm)' ;
            AUTOSIZE ;
            FONT "CALIBRI" SIZE 10 ;
            TRANSPARENT

  @  65,145 TEXTBOX In_Ind ;
            WIDTH 40 ;
            HEIGHT 20 ;
            VALUE 0 ;
            NUMERIC INPUTMASK '99 '

  @  114, 20 LABEL Label_F1 ;
            VALUE 'First Line (mm)' ;
            AUTOSIZE ;
            FONT "CALIBRI" SIZE 10 ;
            TRANSPARENT

  @  112,145 TEXTBOX Line_First ;
            WIDTH 40 ;
            HEIGHT 20 ;
            VALUE FSNGO ;
            NUMERIC INPUTMASK '999'

     SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW INDENT_L

RETURN

PROCEDURE CARGAPRINCIPI
GOTO puntero
rubytuesday := RECENTS->ADIRECC
Aux_FileN1 := RECENTS->ANOMBRE
IF HMG_LEN(ALLTRIM(FORM_1.MINIWRITE_1.VALUE)) <5
      Form_1.MINIWRITE_1.RTFLoadFile(rubytuesday, 4, .F.)
      magister()
ENDIF
RETURN

PROCEDURE CARGAUX1
GOTO puntero
rubytuesday := RECENTS->ADIRECC
Aux_FileN1 := RECENTS->ANOMBRE
IF HB_USUBSTR(FORM_1.AUXILIARY_1.VALUE,1,1) == 'x'
   IF FILE(rubytuesday)
      Form_1.minitab_1.PICTURE := 'AUX1_BY'
      Form_1.AUXILIARY_1.RTFLoadFile(rubytuesday, 4, .F.)
      magistera1()
   ENDIF
ENDIF
RETURN

PROCEDURE CARGAUX2
GOTO puntero
blackfriday := RECENTS->ADIRECC
Aux_FileN2 := RECENTS->ANOMBRE
IF HB_USUBSTR(FORM_1.AUXILIARY_2.VALUE,1,1) == 'x'
   IF FILE(blackfriday)
      Form_1.minitab_2.PICTURE := 'AUX2_BY'
      Form_1.AUXILIARY_2.RTFLoadFile(blackfriday, 4, .F.)
      magistera2()
   ENDIF
ENDIF
RETURN

PROCEDURE ABOUT
cCurrentForm := "ABOUT_S"

DEFINE WINDOW ABOUT_S ;
	AT ctr + 129, ctc + 208 ;
  WIDTH 269 ;
  HEIGHT 349 ;
  TITLE '' ;
  MODAL ;
  NOSIZE ;
  NOSYSMENU ;
  NOCAPTION ;
  BACKCOLOR { 218,229,243 } ;
  ON INIT  nil

  DEFINE IMAGE RIB_1
    ROW	0
    COL	0
    WIDTH  269
    HEIGHT 349
    PICTURE	'ABOUT'
    STRETCH	.T.
  END IMAGE

  @ 321, 144 LABEL RESPDEL_YES ;
          WIDTH 110 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( ABOUT_S.Release ) ;
          TOOLTIP '' ;
          BACKCOLOR { 218,229,243 } ;
          TRANSPARENT

     SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW ABOUT_S

RETURN

PROCEDURE CLAPTON()
local cSMsg:=""

IF RECENTS->(RECCOUNT()) == 0
   RECENTEMPTY()
   RETURN
ENDIF

cCurrentForm := "BIG_S"

DEFINE WINDOW BIG_S;
	AT ctr + 60, ctc + 208 ;
	WIDTH 275;
	HEIGHT 423;
   TITLE '' ;
   MODAL ;
   BACKCOLOR { 255 , 255, 255 } ;
   NOSIZE ;
   NOSYSMENU ;
   NOCAPTION

   @ 249,10  LABEL LABEL_C1 VALUE 'Full' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT
   @ 259,10  LABEL LABEL_C2 VALUE 'name' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT
   @ 296,10   LABEL LABEL_C3 VALUE 'Size:' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT
   @ 296,145  LABEL LABEL_C4 VALUE 'Date:' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT

   @ 244 ,50 EDITBOX M_Archivo ;
         WIDTH 215 ;
         HEIGHT 45 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE '' ;
         BACKCOLOR {218,229,243} ;
         DISABLEDBACKCOLOR {218,229,243} ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         MAXLENGTH 250 ;
         NOHSCROLL ;
         READONLY ;
         TOOLTIP ""

   @ 294 , 50 TEXTBOX M_SIZE ;
         HEIGHT 20 ;
         WIDTH 90 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE '123.456.456' ;
         READONLY  ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         TOOLTIP ('Filesize in character numbers')

   @ 294 , 175 TEXTBOX M_DATE ;
         HEIGHT 20 ;
         WIDTH 90 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE '' ;
         READONLY  ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         TOOLTIP ('Date of last access')


   @ 0, 0 GRID GRID_VISTA	;
			WIDTH 275  ;
			HEIGHT 219 	;
    		HEADERS {'A','                               RECENT FILES'} ;
   	   WIDTHS { 25 , 225 }     ;
			BACKCOLOR {255,255,255};
         FONT "CALIBRI" SIZE 9 ;
         VALUE { 1 , 1 } ;
			ROWSOURCE "RECENTS" ;
      	COLUMNFIELDS { 'RECENTS->ASELEC' , 'RECENTS->ANOMBRE' } ;
         DYNAMICBACKCOLOR { bColor , bColor } ;
         DYNAMICFORECOLOR { hColor , hColor} ;
			ON DBLCLICK ( nil ) ;
         ON CHANGE ( PUNTERO := BIG_S.GRID_VISTA.RECNO , MOSTRADOR() ) ;
         JUSTIFY { GRID_JTFY_CENTER , GRID_JTFY_LEFT } ;
         CELLNAVIGATION

   @ 224, 3 FRAME INFOFILE ;
         CAPTION 'Selected File Info' ;
         WIDTH 270 ;
         HEIGHT 98 ;
         TRANSPARENT

   @ 325, 3 FRAME ACTIONS ;
         CAPTION 'Load selected file As' ;
         WIDTH 135 ;
         HEIGHT 98 ;
         TRANSPARENT

   DEFINE IMAGE BOT_MASTER
      ROW	344
      COL	10
      WIDTH  121
      HEIGHT 21
      PICTURE	'BOT_AUX0_OFF'
      STRETCH	.T.
   END IMAGE


   DEFINE IMAGE BOT_AUX0
      ROW	369
      COL	10
      WIDTH  121
      HEIGHT 21
      PICTURE	'BOT_AUX1_OFF'
      STRETCH	.T.
   END IMAGE

   DEFINE IMAGE BOT_AUX2
      ROW	394
      COL	10
      WIDTH  121
      HEIGHT 21
      PICTURE	'BOT_AUX2_OFF'
      STRETCH	.T.
   END IMAGE

   @ 345, 11 LABEL AUX_BOT0 ;
          WIDTH 119 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( CARGAPRINCIPI() , BIG_S.RELEASE ) ;
          TOOLTIP 'Load Selected Document as Principal' ;
          TRANSPARENT

   @ 370, 11 LABEL AUX_BOT1 ;
          WIDTH 119 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( cargaux1() , BIG_S.RELEASE ) ;
          TOOLTIP 'Load Selected Document as Auxiliary Document 1' ;
          TRANSPARENT

   @ 395, 11 LABEL AUX_BOT2 ;
          WIDTH 119 HEIGHT 19 ;
          VALUE '' ;
          ACTION (  cargaux2() , BIG_S.RELEASE ) ;
          TOOLTIP 'Load Selected Document as Auxiliary Document 2' ;
          TRANSPARENT

   DEFINE IMAGE DEL_DOC_TABLE
      ROW	339
      COL	142
      WIDTH  132
      HEIGHT 34
      PICTURE	'BOT_DEL_TABLE'
      STRETCH	.T.
   END IMAGE

   @ 340, 144 LABEL DEL_BOT_FILE ;
          WIDTH 128 HEIGHT 32 ;
          VALUE '' ;
          ACTION ( BIG_S.GRID_VISTA.Delete , BIG_S.GRID_VISTA.SAVE , BIG_S.RELEASE ) ;
          TOOLTIP 'Load Selected Document as Auxiliary Document 5' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT

   DEFINE IMAGE QUIT_TABLE
      ROW	378
      COL	142
      WIDTH  132
      HEIGHT 34
      PICTURE	'BOT_QUIT_TABLE'
      STRETCH	.T.
   END IMAGE

   @ 379, 144 LABEL QUIT_SEARCH ;
          WIDTH 128 HEIGHT 32 ;
          VALUE '' ;
          ACTION ( nil , BIG_S.RELEASE ) ;
          TOOLTIP 'Load Selected Document as Auxiliary Document 5' ;
          BACKCOLOR { 7,71,41 } ;
          TRANSPARENT

   BIG_S.QUIT_SEARCH.SETFOCUS

   SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

END WINDOW

BIG_S.Activate

return NIL

PROCEDURE Cargabase
APPEND BLANK
   recents->ASELEC := tselect
   recents->ADIRECC := tdireccion
   recents->ANOMBRE := tarchivo
   recents->ABYTES := tbytes
   recents->AFECHA := tfecha
   recents->AHORA := thora
   recents->AATRIB := tatribut
RETURN

PROCEDURE MOSTRADOR
LOCAL elsize := VAL(recents->abytes)
elsize := STRTRAN(recents->abytes,",",".")
MODIFY CONTROL M_ARCHIVO OF BIG_S Value RECENTS->ANOMBRE
MODIFY CONTROL M_SIZE OF BIG_S VALUE recents->abytes
MODIFY CONTROL M_DATE OF BIG_S VALUE RECENTS->AFECHA
RETURN

PROCEDURE MOSTRAR_TABLAS
RETURN

//***************************************************************************

PROCEDURE SaveFile
BUSCAR := HMG_UPPER(ALLTRIM(cFileName))
IF EMPTY(cFileName) .OR. cFileName == "NEW"
   MSGINFO("Found that the file contains NEW", "Warning")
   SaveFileAs()
   AGAPITO_RTF()
ELSE
   IF HMG_UPPER(ALLTRIM(cfilename)) == 'RTF_INFO.RTF'
   ELSE
      Form_1.miniwrite_1.RTFSaveFile ( cFileName, 4, .F.)
   ENDIF
END
RETURN

//***************************************************************************

PROCEDURE SaveFileAs
lapos := 0
cAuxFileName := PutFile ( { {"RTF files", "*.rtf"} }, NIL, GetCurrentFolder(), NIL, cFileName, ".rtf" )

IF EMPTY(cAuxFileName)
   MSGINFO("The document " + CAuxfilename + " was not saved" , "Warning")
ELSE
  cFileName := cAuxFileName
  Form_1.miniwrite_1.RTFSaveFile ( cFileName, 4, .F.)
  lapos := HMG_LEN(ALLTRIM(cfilename)) - HB_UTF8RAT ("\",cfilename)
  TEXSHOW := HB_URIGHT(cFileName,lapos)
  TEXSHOW := HB_USUBSTR(TEXSHOW,1,HMG_LEN(TEXSHOW)-4)
  Form_1.ARCHI_ACTUAL.VALUE := TEXSHOW
  APPEND BLANK
  recents->adirecc := ALLTRIM(cFileName)
  recents->anombre  := TEXSHOW
  recents->afecha   := DTOC(date())
  recents->abytes   := ALLTRIM(STR(HMG_LEN(ALLTRIM(FORM_1.miniwrite_1.value))))
  recents->ahora    := TIME()
ENDIF
RETURN

//***************************************************************************


PROCEDURE CHEQLLENO
LOCAL sanz
SANZ := ALLTRIM(FORM_1.miniwrite_1.VALUE)
IF HMG_LEN(sanz) == 0
   MSGINFO("The document is empty" , "Warning")
ELSE
   NEWDOC2()
ENDIF
RETURN

PROCEDURE MAGISTER
lapos := 0
presing := ''
IF ALLTRIM(Aux_FileN0) == ''
   RETURN
ENDIF
lapos := HMG_LEN(ALLTRIM(Aux_FileN0)) - HB_UTF8RAT ("\",Aux_FileN0)
presing := ''
BUSCAR := HMG_UPPER(ALLTRIM(Aux_FileN0))
presing := ALLTRIM(HB_URIGHT(Aux_FileN0,lapos))
presing := HB_ULEFT(presing,HMG_LEN(PRESING)-4)
Form_1.ARCHI_ACTUAL.VALUE := PRESING
RETURN

PROCEDURE MAGISTERA1
lapos := 0
presing := ''
IF rubytuesday == ''
   RETURN
ENDIF
lapos := HMG_LEN(ALLTRIM(rubytuesday)) - HB_UTF8RAT ("\",rubytuesday)
BUSCAR := HMG_UPPER(ALLTRIM(rubytuesday))
presing := ALLTRIM(HB_URIGHT(rubytuesday,lapos))
presing := HB_ULEFT(presing,HMG_LEN(PRESING)-4)
Form_1.ARCHI_ACTUAL.VALUE := PRESING
RETURN

PROCEDURE MAGISTERA2
lapos := 0
presing := ''
IF blackfriday == ''
   RETURN
ENDIF
lapos := HMG_LEN(ALLTRIM(blackfriday)) - HB_UTF8RAT ("\",blackfriday)
BUSCAR := HMG_UPPER(ALLTRIM(blackfriday))
presing := ALLTRIM(HB_URIGHT(blackfriday,lapos))
presing := HB_ULEFT(presing,HMG_LEN(PRESING)-4)
Form_1.ARCHI_ACTUAL.VALUE := PRESING
RETURN

PROCEDURE MAGISTERA3
lapos := 0
presing := ''
IF ALLTRIM(Aux_FileN3) == ''
   RETURN
ENDIF
lapos := HMG_LEN(ALLTRIM(Aux_FileN3)) - HB_UTF8RAT ("\",Aux_FileN3)
BUSCAR := HMG_UPPER(ALLTRIM(Aux_FileN3))
presing := ALLTRIM(HB_URIGHT(Aux_FileN3,lapos))
presing := HB_ULEFT(presing,HMG_LEN(PRESING)-4)
Aux_Tab3 := 'Push this button to see Auxiliary Document 3'
FORM_1.AUXTAB_3.TOOLTIP := Aux_Tab3
Form_1.ARCHI_ACTUAL.VALUE := PRESING
RETURN

PROCEDURE MAGISTERA4
lapos := 0
presing := ''
IF ALLTRIM(Aux_FileN4) == ''
   RETURN
ENDIF
lapos := HMG_LEN(ALLTRIM(Aux_FileN4)) - HB_UTF8RAT ("\",Aux_FileN4)
BUSCAR := HMG_UPPER(ALLTRIM(Aux_FileN4))
presing := ALLTRIM(HB_URIGHT(Aux_FileN4,lapos))
presing := HB_ULEFT(presing,HMG_LEN(PRESING)-4)
Aux_Tab4 := 'Push this button to see Auxiliary Document 3'
FORM_1.AUXTAB_4.TOOLTIP := Aux_Tab4
Form_1.ARCHI_ACTUAL.VALUE := PRESING
RETURN

PROCEDURE MAGISTERA5
lapos := 0
presing := ''
IF ALLTRIM(Aux_FileN5) == ''
   RETURN
ENDIF
lapos := HMG_LEN(ALLTRIM(Aux_FileN5)) - HB_UTF8RAT ("\",Aux_FileN5)
BUSCAR := HMG_UPPER(ALLTRIM(Aux_FileN5))
presing := ALLTRIM(HB_URIGHT(Aux_FileN5,lapos))
presing := HB_ULEFT(presing,HMG_LEN(PRESING)-4)
Aux_Tab5 := 'Push this button to see Auxiliary Document 3'
FORM_1.AUXTAB_5.TOOLTIP := Aux_Tab5
Form_1.ARCHI_ACTUAL.VALUE := PRESING
RETURN

PROCEDURE RECENTEMPTY
cCurrentForm := "NOTIEMPTY"


DEFINE WINDOW NOTIEMPTY;
	AT ctr + 85, ctc + 208 ;
	WIDTH 211;
	HEIGHT 170;
   TITLE '' ;
   MODAL ;
   BACKCOLOR { 255 , 255, 255 } ;
   NOSIZE ;
   NOSYSMENU ;
   NOCAPTION

   DEFINE IMAGE BOT_AUX0
      ROW	0
      COL	0
      WIDTH  211
      HEIGHT 170
      PICTURE	'EMPTY00'
      STRETCH	.T.
   END IMAGE

   @ 142, 68 LABEL AUX_BOT4 ;
          WIDTH 130 HEIGHT 19 ;
          VALUE '' ;
          ACTION ( nil , NOTIEMPTY.RELEASE ) ;
          TOOLTIP '' ;
          TRANSPARENT

   SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

END WINDOW

NOTIEMPTY.Activate

return NIL

PROCEDURE SAMPLEBULL
IF Parabull.rgNumFormat.VALUE == 1
   memobull := "10"
   Parabull.rgNumStyle.ENABLED := .F.
   Parabull.BULL_SAMPLE.PICTURE := 'MSGBULL00'
ENDIF
IF Parabull.rgNumFormat.VALUE == 2
   memobull := "2"
   Parabull.rgNumStyle.ENABLED := .T.
   STYLEBULL()
ENDIF
IF Parabull.rgNumFormat.VALUE == 3
   memobull := "3"
   Parabull.rgNumStyle.ENABLED := .T.
   STYLEBULL()
ENDIF
IF Parabull.rgNumFormat.VALUE == 4
   memobull := "4"
   Parabull.rgNumStyle.ENABLED := .T.
   STYLEBULL()
ENDIF
IF Parabull.rgNumFormat.VALUE == 5
   memobull := "5"
   Parabull.rgNumStyle.ENABLED := .T.
   STYLEBULL()
ENDIF
IF Parabull.rgNumFormat.VALUE == 6
   memobull := "6"
   Parabull.rgNumStyle.ENABLED := .T.
   STYLEBULL()
ENDIF
RETURN


PROCEDURE STYLEBULL
IF Parabull.rgNumStyle.Value == 1
   memobull := HB_ULEFT(memobull,1) + "0"
   SHOW_SBULL()
   RETURN
ENDIF
IF Parabull.rgNumStyle.Value == 2
   memobull := HB_ULEFT(memobull,1) + "1"
   SHOW_SBULL()
   RETURN
ENDIF
IF Parabull.rgNumStyle.Value == 3
   memobull := HB_ULEFT(memobull,1) + "2"
   SHOW_SBULL()
   RETURN
ENDIF
IF Parabull.rgNumStyle.Value == 4
   memobull := HB_ULEFT(memobull,1) + "3"
   SHOW_SBULL()
   RETURN
ENDIF
RETURN

PROCEDURE SHOW_SBULL
DO CASE
   CASE memobull == "10"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULL00'
   CASE memobull == "20"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULN0'
   CASE memobull == "21"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULN1'
   CASE memobull == "22"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULN2'
   CASE memobull == "23"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULN3'
   CASE memobull == "30"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULL0'
   CASE memobull == "31"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULL1'
   CASE memobull == "32"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULL2'
   CASE memobull == "33"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULL3'
   CASE memobull == "40"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULRL0'
   CASE memobull == "41"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULRL1'
   CASE memobull == "42"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULRL2'
   CASE memobull == "43"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULRL3'
   CASE memobull == "50"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULU0'
   CASE memobull == "51"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULU1'
   CASE memobull == "52"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULU2'
   CASE memobull == "53"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULU3'
   CASE memobull == "60"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULRU0'
   CASE memobull == "61"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULRU1'
   CASE memobull == "62"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULRU2'
   CASE memobull == "63"
        Parabull.BULL_SAMPLE.PICTURE := 'MSGBULRU3'
END CASE
RETURN

PROCEDURE ACTUA_BULL
DO CASE
   CASE memobull == "10"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Bullets' + chr(10) + 'Style active: None'
   CASE memobull == "20"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Arabic Numerals' + chr(10) + 'Style active: None'
   CASE memobull == "21"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Arabic Numerals' + chr(10) + 'Style active: Period'
   CASE memobull == "22"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Arabic Numerals' + chr(10) + 'Style active: Parenthesis at right'
   CASE memobull == "23"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Arabic Numerals' + chr(10) + 'Style active: Dual Parenthesis '
   CASE memobull == "30"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Lower Case Letters' + chr(10) + 'Style active: None'
   CASE memobull == "31"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Lower Case Letters' + chr(10) + 'Style active: Period'
   CASE memobull == "32"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Lower Case Letters' + chr(10) + 'Style active: Parenthesis at right'
   CASE memobull == "33"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Lower Case Letters' + chr(10) + 'Style active: Dual Parenthesis'
   CASE memobull == "40"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Lower Case Roman Numbers' + chr(10) + 'Style active: None'
   CASE memobull == "41"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Lower Case Roman Numbers' + chr(10) + 'Style active: Period'
   CASE memobull == "42"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Lower Case Roman Numbers' + chr(10) + 'Style active: Parenthesis at right'
   CASE memobull == "43"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Lower Case Roman Numbers' + chr(10) + 'Style active: Dual Parenthesis'
   CASE memobull == "50"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Upper Case Letters' + chr(10) + 'Style active: None'
   CASE memobull == "51"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Upper Case Letters' + chr(10) + 'Style active: Period'
   CASE memobull == "52"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Upper Case Letters' + chr(10) + 'Style active: Parenthesis at right'
   CASE memobull == "53"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Upper Case Letters' + chr(10) + 'Style active: Dual Parenthesis'
   CASE memobull == "60"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Upper Case Roman Numbers' + chr(10) + 'Style active: None'
   CASE memobull == "61"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Upper Case Roman Numbers' + chr(10) + 'Style active: Period'
   CASE memobull == "62"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Upper Case Roman Numbers' + chr(10) + 'Style active: Parenthesis at right'
   CASE memobull == "63"
        FORM_1.BOT_RIBP1.TOOLTIP := 'Apply bullet type to Paragraph active' + chr(10) + chr(10) + 'Type active: Upper Case Roman Numbers' + chr(10) + 'Style active: Dual Parenthesis'
END CASE
RETURN


PROCEDURE BULL_SET
DO CASE
   CASE memobull == "10"
        Form_1.miniwrite_1.ParaNumbering := RTF_BULLET
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "20"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_ARABICNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PLAIN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "21"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_ARABICNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PERIOD
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "22"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_ARABICNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PAREN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "23"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_ARABICNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PARENS
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "30"
        Form_1.miniwrite_1.ParaNumbering := RTF_LOWERCASELETTER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PLAIN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "31"
        Form_1.miniwrite_1.ParaNumbering := RTF_LOWERCASELETTER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PERIOD
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "32"
        Form_1.miniwrite_1.ParaNumbering := RTF_LOWERCASELETTER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PAREN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "33"
        Form_1.miniwrite_1.ParaNumbering := RTF_LOWERCASELETTER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PARENS
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "40"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_UPPERCASELETTER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PLAIN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "41"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_UPPERCASELETTER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PERIOD
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "42"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_UPPERCASELETTER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PAREN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "43"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_UPPERCASELETTER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PARENS
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "50"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_LOWERCASEROMANNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PLAIN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "51"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_LOWERCASEROMANNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PERIOD
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "52"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_LOWERCASEROMANNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PAREN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "53"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_LOWERCASEROMANNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PARENS
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "60"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_UPPERCASEROMANNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PLAIN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "61"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_UPPERCASEROMANNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PERIOD
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "62"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_UPPERCASEROMANNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PAREN
        Form_1.miniwrite_1.ParaOffset := 5
   CASE memobull == "63"
        Form_1.miniwrite_1.ParaNumberingStart := 1
        Form_1.miniwrite_1.ParaNumbering := RTF_UPPERCASEROMANNUMBER
        Form_1.miniwrite_1.ParaNumberingStyle := RTF_PARENS
        Form_1.miniwrite_1.ParaOffset := 5
END CASE
RETURN

PROCEDURE AGAPITO_RTF
 	If .Not. Empty(Buscar)
       LOCATE FOR TRIM(Buscar) $ (HMG_UPPER(ADIRECC))
       DO WHILE FOUND()
          elloco := RecNo()
          recents->afecha   := DTOC(date())
          recents->abytes   := ALLTRIM(STR(HMG_LEN(ALLTRIM(FORM_1.miniwrite_1.value))))
          recents->ahora    := TIME()
          RETURN
       ENDDO
       cFileName := cAuxFileName
       Form_1.miniwrite_1.RTFSaveFile ( cFileName, 4, .F.)
       lapos := HMG_LEN(ALLTRIM(cfilename)) - HB_UTF8RAT ("\",cfilename)
       TEXSHOW := HB_URIGHT(cFileName,lapos)
       TEXSHOW := HB_USUBSTR(TEXSHOW,1,HMG_LEN(TEXSHOW)-4)
       Form_1.ARCHI_ACTUAL.VALUE := TEXSHOW
       APPEND BLANK
       recents->adirecc := ALLTRIM(cFileName)
       recents->anombre  := TEXSHOW
       recents->afecha   := DTOC(date())
       recents->abytes   := ALLTRIM(STR(HMG_LEN(ALLTRIM(FORM_1.miniwrite_1.value))))
       recents->ahora    := TIME()
       RETURN
   EndIf
Return

PROCEDURE GRANSALIDA
cCurrentForm := "INFO_SALIDA"


	DEFINE WINDOW INFO_SALIDA ;
      AT ctr + 38, ctc + 582 ;
		WIDTH 215 HEIGHT 170 ;
		TITLE '' ;
      MODAL ;
      NOSIZE ;
      NOSYSMENU ;
      NOCAPTION ;
      BACKCOLOR { 250,241,228 }

      DEFINE IMAGE RIBBON_1
         ROW	0
         COL	0
         WIDTH	215
         HEIGHT 170
         PICTURE	'surequit'
         STRETCH	.T.
      END IMAGE

      @ 142, 54 LABEL RESP_YES ;
          WIDTH 64 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( INFO_SALIDA.RELEASE , Form_1.RELEASE ) ;
          TOOLTIP '' ;
          TRANSPARENT

      @ 142, 136 LABEL RESP_NO ;
          WIDTH 64 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( INFO_SALIDA.RELEASE ) ;
          TOOLTIP '' ;
          TRANSPARENT


      @ 05, 80 LABEL TITU_01 VALUE 'WARNING' AUTOSIZE FONT 'ARIAL' BOLD SIZE 9 FONTCOLOR { 221,0,0 } TRANSPARENT
      @ 35, 15 LABEL TITU_02 VALUE "You've choose closing Miniwriter." AUTOSIZE FONT 'Calibri' SIZE 9 FONTCOLOR { 0,105,155 } TRANSPARENT
      @ 60, 15 LABEL TITU_03 VALUE 'To avoid losing last changes you' AUTOSIZE FONT 'CALIBRI' SIZE 9 FONTCOLOR { 0,105,155 } TRANSPARENT // el color antes era 0,0,128
      @ 75, 15 LABEL TITU_04 VALUE 'make on active document active,' AUTOSIZE FONT 'CALIBRI' SIZE 9 FONTCOLOR { 0,105,155 } TRANSPARENT
      @ 90, 15 LABEL TITU_05 VALUE 'save it now.' AUTOSIZE FONT 'CALIBRI' SIZE 9 FONTCOLOR { 0,105,155 } TRANSPARENT
      @ 115, 15 LABEL TITU_06 VALUE 'Please confirm your selection' AUTOSIZE FONT 'CALIBRI' SIZE 9 FONTCOLOR { 0,105,155 } TRANSPARENT

      SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW INFO_SALIDA

RETURN

PROCEDURE NEWDOC1
cCurrentForm := "INFO_NEW"


	DEFINE WINDOW INFO_NEW ;
      AT ctr + 28, ctc + 53 ;
		WIDTH 196 HEIGHT 185 ;
		TITLE '' ;
      MODAL ;
      NOSIZE ;
      NOSYSMENU ;
      NOCAPTION ;
      BACKCOLOR { 218,229,243 }


      DEFINE IMAGE RIBBON_1
         ROW	0
         COL	0
         WIDTH	196
         HEIGHT 185
         PICTURE	'warnewup'
         STRETCH	.T.
      END IMAGE

      @ 157, 8 LABEL RESP_SAVE ;
          WIDTH 49 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( SaveFile() , INFO_NEW.RELEASE , cFileName := "NEW" , Form_1.miniwrite_1.VALUE := "" , MAGISTER() ) ;
          TOOLTIP '' ;
          TRANSPARENT

      @ 157, 64 LABEL RESP_DISCARD ;
          WIDTH 59 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( INFO_NEW.RELEASE , cFileName := "NEW", Form_1.miniwrite_1.VALUE := "" , MAGISTER() ) ;
          TOOLTIP '' ;
          TRANSPARENT

      @ 157, 130 LABEL RESP_CANCEL ;
          WIDTH 54 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( INFO_NEW.RELEASE ) ;
          TOOLTIP '' ;
          TRANSPARENT

      SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO


   END WINDOW

   ACTIVATE WINDOW INFO_NEW

RETURN

PROCEDURE NEWDOC2
cCurrentForm := "INFO_NEW"


	DEFINE WINDOW INFO_NEW ;
      AT ctr + 60, ctc + 208 ;
      WIDTH 211;
      HEIGHT 170;
      TITLE '' ;
      MODAL ;
      BACKCOLOR { 255 , 255, 255 } ;
      NOSIZE ;
      NOSYSMENU ;
      NOCAPTION


      DEFINE IMAGE RIBBON_1
         ROW	0
         COL	0
         WIDTH	211
         HEIGHT 170
         PICTURE	'warnew'
         STRETCH	.T.
      END IMAGE

      @ 142, 23 LABEL RESP_SAVE ;
          WIDTH 49 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( SaveFile() , INFO_NEW.RELEASE , cFileName := "NEW" , Form_1.miniwrite_1.VALUE := "" , MAGISTER() ) ;
          TOOLTIP '' ;
          TRANSPARENT

      @ 142, 79 LABEL RESP_DISCARD ;
          WIDTH 59 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( INFO_NEW.RELEASE , cFileName := "NEW", Form_1.miniwrite_1.VALUE := "" , MAGISTER() ) ;
          TOOLTIP '' ;
          TRANSPARENT

      @ 142, 145 LABEL RESP_CANCEL ;
          WIDTH 54 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( INFO_NEW.RELEASE ) ;
          TOOLTIP '' ;
          TRANSPARENT

      SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW INFO_NEW

RETURN


PROCEDURE SET_PRIN
local cSMsg:=""
cCurrentForm := "PRIN_SET"


DEFINE WINDOW PRIN_SET;
	AT ctr + 60, ctc + 208 ;
	WIDTH 275;
	HEIGHT 413;
   TITLE '' ;
   MODAL ;
   BACKCOLOR { 255 , 255, 255 } ;
   NOSIZE ;
   NOSYSMENU ;
   NOCAPTION

   DEFINE IMAGE SET_TP
      ROW	50
      COL	1
      WIDTH  269
      HEIGHT 24
      PICTURE	'SETUP_PS'
      STRETCH	.T.
   END IMAGE


   DEFINE IMAGE SET_LP
      ROW	74
      COL	1
      WIDTH  22
      HEIGHT 295
      PICTURE	'SETUP_PL'
      STRETCH	.T.
   END IMAGE

   DEFINE IMAGE SET_PP
      ROW	198
      COL	1
      WIDTH  22
      HEIGHT 57
      PICTURE	'SETUP_PP'
      STRETCH	.T.
   END IMAGE

   DEFINE IMAGE SET_RP
      ROW	74
      COL	259
      WIDTH  11
      HEIGHT 295
      PICTURE	'SETUP_PR'
      STRETCH	.T.
   END IMAGE

   DEFINE IMAGE SET_BP
      ROW	369
      COL	1
      WIDTH  269
      HEIGHT 33
      PICTURE	'SETUP_PIF'
      STRETCH	.T.
   END IMAGE

   @ 85, 27 FRAME PR_AREA ;
         CAPTION 'Printable Area' ;
         WIDTH 228 ;
         HEIGHT 120 ;
         TRANSPARENT

   @ 213, 27 FRAME HD_AREA ;
         CAPTION 'Header Setup' ;
         WIDTH 228 ;
         HEIGHT 145 ;
         TRANSPARENT

   @ 374, 24 LABEL SET_SAVE ;
          WIDTH 66 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( nil , PRIN_SET.RELEASE ) ;
          TOOLTIP 'Save SETUP as default' ;
          TRANSPARENT

   @ 374, 98 LABEL SET_APLY ;
          WIDTH 69 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( PRI_M_APPLY() , PRIN_SET.RELEASE ) ;
          TOOLTIP 'Apply this Setup only to Principal Document active' ;
          TRANSPARENT

   @ 374, 175 LABEL QUIT_SEARCH ;
          WIDTH 82 HEIGHT 18 ;
          VALUE '' ;
          ACTION ( nil , PRIN_SET.RELEASE ) ;
          TOOLTIP 'Cancel Setup and exit' ;
          TRANSPARENT

  @ 102,35  LABEL LABEL_C1 VALUE 'Left Margin (in millimeters):' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT
  @ 127,35  LABEL LABEL_C2 VALUE 'Rigght Margin (in millimeters):' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT
  @ 152,35  LABEL LABEL_C3 VALUE 'Top Margin (in millimeters):' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT
  @ 177,35  LABEL LABEL_C4 VALUE 'Bottom Margin (in millimeters):' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT

   @ 101 , 213 TEXTBOX S_L ;
         HEIGHT 20 ;
         WIDTH 35 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE MSMLEFT ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         TOOLTIP ('Filesize in character numbers') ;
         NUMERIC INPUTMASK "999"


   @ 126 , 213 TEXTBOX R_L ;
         HEIGHT 20 ;
         WIDTH 35 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE MSMRIGHT ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         TOOLTIP ('Filesize in character numbers') ;
         NUMERIC INPUTMASK "999"

   @ 151 , 213 TEXTBOX R_T ;
         HEIGHT 20 ;
         WIDTH 35 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE MSMTOP ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         TOOLTIP ('Filesize in character numbers') ;
         NUMERIC INPUTMASK "999"

   @ 176 , 213 TEXTBOX T_B ;
         HEIGHT 20 ;
         WIDTH 35 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE MSMBOTTOM ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         TOOLTIP ('Filesize in character numbers') ;
         NUMERIC INPUTMASK "999"


  @ 234,35  LABEL LABEL_C5 VALUE 'From Top Edge (in millimiters)' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT
  @ 259,35  LABEL LABEL_C6 VALUE 'From Left Edge (in millimiters)' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT

  @ 282,55  LABEL LABEL_C7 VALUE 'Include Page Number in Header' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT

  @ 307,35  LABEL LABEL_C8 VALUE 'Header:' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT
  @ 332,35  LABEL LABEL_C9 VALUE 'Text Post Number:' AUTOSIZE FONT "ARIAL" SIZE 9 TRANSPARENT

   @ 233 , 213 TEXTBOX H_T ;
         HEIGHT 20 ;
         WIDTH 35 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE MSNROW ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         TOOLTIP ('Filesize in character numbers') ;
         NUMERIC INPUTMASK "999"

   @ 258 , 213 TEXTBOX H_L ;
         HEIGHT 20 ;
         WIDTH 35 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE MSNCOL ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         TOOLTIP ('Filesize in character numbers') ;
         NUMERIC INPUTMASK "999"

      DEFINE CHECKBOX M_PH
         ROW    283
         COL    35
         WIDTH  13
         HEIGHT 13
         VALUE .T.
         ONCHANGE nil
         TRANSPARENT .T.
      END CHECKBOX

   @ 305 , 83 TEXTBOX H_H ;
         HEIGHT 20 ;
         WIDTH 165 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE MSPREH ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         MAXLENGTH 40 ;
         TOOLTIP ('Header size must be less than 40 chars')

   @ 330 , 138 TEXTBOX H_PH ;
         HEIGHT 20 ;
         WIDTH 110 ;
         FONT "Calibri" SIZE 10 ;
         BOLD ;
         VALUE MSPOSTH ;
         BACKCOLOR {218,229,243} ;
         FONTCOLOR {0,0,128} ;
         DISABLEDBACKCOLOR {218,229,243}  ;
         DISABLEDFONTCOLOR {0,   0,  128} ;
         MAXLENGTH 40 ;
         TOOLTIP ('Post number text in header must be less than 20 chars')

         PRIN_SET.QUIT_SEARCH.SETFOCUS

         ON KEY  ESCAPE  ACTION Prin_Set.Release

         SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW PRIN_SET

RETURN

PROCEDURE PRI_S_SAVE1
MSMLEFT     := PRIN_SET.S_L.VALUE
MSMRIGHT    := PRIN_SET.R_L.VALUE
MSMTOP      := PRIN_SET.R_T.VALUE
MSMBOTTON    := PRIN_SET.T_B.VALUE
MSNROW      := PRIN_SET.H_T.VALUE
MSNCOL      := PRIN_SET.H_L.VALUE
MSPREH      := PRIN_SET.H_H.VALUE
MSPOSTH     := PRIN_SET.H_PH.VALUE
IF PRIN_SET.MSPAGEY.M_PH.VALUE == .T.
   MSPAGE   := "S"
   MSPAGENO := 0
ELSE
   MSPAGE   := "S"
   MSPAGENO := 0
ENDIF
SAVE TO MNPSETUP.MEM ALL LIKE MS*
RETURN

PROCEDURE PRI_S_RESTORE
RESTORE FROM MNPSETUP.MEM ADDITIVE

PRIN_SET.S_L.VALUE := MSMLEFT
PRIN_SET.R_L.VALUE := MSMRIGHT
PRIN_SET.R_T.VALUE := MSMTOP
PRIN_SET.T_B.VALUE := MSMBOTTON
PRIN_SET.H_T.VALUE := MSNROW
PRIN_SET.H_L.VALUE := MSNCOL
PRIN_SET.H_H.VALUE := MSPREH
PRIN_SET.H_PH.VALUE := MSPOSTH
IF MSPAGE := "S"
   PRIN_SET.MSPAGEY.M_PH.VALUE := .T.
ELSE
   PRIN_SET.MSPAGEY.M_PH.VALUE := .T.
ENDIF
RETURN

PROCEDURE PRI_M_APPLY
MLEFT     := PRIN_SET.S_L.VALUE
MRIGHT    := PRIN_SET.R_L.VALUE
MTOP     := PRIN_SET.R_T.VALUE
MBOTTON   := PRIN_SET.T_B.VALUE
nROW      := PRIN_SET.H_T.VALUE
nCOL      := PRIN_SET.H_L.VALUE
MSPREH      := PRIN_SET.H_H.VALUE
MSPOSTH     := PRIN_SET.H_PH.VALUE
RETURN

PROCEDURE COMANDOFF
calen_F1.MSGBUSCA_2.PICTURE := 'COMANDOS_OFF'
calen_F1.Q_1.ENABLED := .F.
calen_F1.Q_2.ENABLED := .F.
calen_F1.Q_3.ENABLED := .F.
calen_F1.Q_4.ENABLED := .F.
calen_F1.Q_5.ENABLED := .F.
calen_F1.Q_6.ENABLED := .F.
calen_F1.Q_7.ENABLED := .F.
calen_F1.Q_8.ENABLED := .F.
calen_F1.Q_9.ENABLED := .F.
calen_F1.Q_10.ENABLED := .F.
calen_F1.TEXTODEL_YES.ENABLED := .F.
RETURN

PROCEDURE rest_principal
PRENDE_CTRL()
APAGA_TABS()
APAGA_RTFS()
FORM_1.MINITAB_0.PICTURE := 'START_ON'
FORM_1.MINIWRITE_1.SHOW
activ_doc := "0"
MAGISTER()
RETURN

PROCEDURE rest_aux_1
IF HB_USUBSTR(FORM_1.AUXILIARY_1.VALUE,1,1) <> 'x'
   APAGA_CTRL()
   APAGA_TABS()
   APAGA_RTFS()
   FORM_1.MINITAB_1.PICTURE := 'AUX1_ON'
   FORM_1.Auxiliary_1.SHOW
   MAGISTERA1()
   activ_doc := "1"
   APAGA_MINIBOT()
ENDIF
RETURN

PROCEDURE rest_aux_2
IF HB_USUBSTR(FORM_1.AUXILIARY_2.VALUE,1,1) <> 'x'
   APAGA_CTRL()
   APAGA_TABS()
   APAGA_RTFS()
   FORM_1.MINITAB_2.PICTURE := 'AUX2_ON'
   FORM_1.Auxiliary_2.SHOW
   MAGISTERA2()
   activ_doc := "2"
   APAGA_MINIBOT()
ENDIF
RETURN

PROCEDURE rest_aux_3
IF ALLTRIM(Aux_FileN3) == ''
   APAGA_CTRL()
   Aux_FileN3 := GetFile ( { {"RTF files", "*.rtf"} }, NIL, GetCurrentFolder() )
   IF ( EMPTY(Aux_FileN3),NIL,( cFileName := Aux_FileN3, Form_1.Auxiliary_3.RTFLoadFile ( cFileName, 4, .F.), MAGISTERA3() ) )
      APAGA_TABS()
      APAGA_RTFS()
      IF ALLTRIM(Aux_FileN3) == ''
         FORM_1.MINITAB_0.PICTURE := 'START_ON'
         FORM_1.MINIWRITE_1.SHOW
         PRENDE_CTRL()
         PRENDE_MINIBOT()
      ELSE
         FORM_1.MINITAB_3.PICTURE := 'AUX3_ON'
         FORM_1.Auxiliary_3.SHOW
         activ_doc := "3"
         MAGISTERA3()
         APAGA_MINIBOT()
      ENDIF
ELSE
   APAGA_CTRL()
   APAGA_TABS()
   APAGA_RTFS()
   FORM_1.MINITAB_3.PICTURE := 'AUX3_ON'
   FORM_1.Auxiliary_3.SHOW
   MAGISTERA3()
   activ_doc := "3"
   APAGA_MINIBOT()
ENDIF
RETURN

PROCEDURE rest_aux_4
IF ALLTRIM(Aux_FileN4) == ''
   APAGA_CTRL()
   Aux_FileN4 := GetFile ( { {"RTF files", "*.rtf"} }, NIL, GetCurrentFolder() )
   IF ( EMPTY(Aux_FileN4),NIL,( cFileName := Aux_FileN4, Form_1.Auxiliary_4.RTFLoadFile ( cFileName, 4, .F.), MAGISTERA4() ) )
      APAGA_TABS()
      APAGA_RTFS()
      IF ALLTRIM(Aux_FileN4) == ''
         FORM_1.MINITAB_0.PICTURE := 'START_ON'
         FORM_1.MINIWRITE_1.SHOW
         PRENDE_CTRL()
         PRENDE_MINIBOT()
      ELSE
         FORM_1.MINITAB_4.PICTURE := 'AUX4_ON'
         FORM_1.Auxiliary_4.SHOW
         activ_doc := "4"
         MAGISTERA4()
         APAGA_MINIBOT()
      ENDIF
ELSE
   APAGA_CTRL()
   APAGA_TABS()
   APAGA_RTFS()
   FORM_1.MINITAB_4.PICTURE := 'AUX4_ON'
   FORM_1.Auxiliary_4.SHOW
   MAGISTERA4()
   activ_doc := "4"
   APAGA_MINIBOT()
ENDIF
RETURN

PROCEDURE rest_aux_5
IF ALLTRIM(Aux_FileN5) == ''
   APAGA_CTRL()
   Aux_FileN5 := GetFile ( { {"RTF files", "*.rtf"} }, NIL, GetCurrentFolder() )
   IF ( EMPTY(Aux_FileN5),NIL,( cFileName := Aux_FileN5, Form_1.Auxiliary_5.RTFLoadFile ( cFileName, 4, .F.), MAGISTERA5() ) )
      APAGA_TABS()
      APAGA_RTFS()
      IF ALLTRIM(Aux_FileN5) == ''
         FORM_1.MINITAB_0.PICTURE := 'START_ON'
         FORM_1.MINIWRITE_1.SHOW
         PRENDE_CTRL()
      ELSE
         FORM_1.MINITAB_5.PICTURE := 'AUX5_ON'
         FORM_1.Auxiliary_5.SHOW
         activ_doc := "5"
         MAGISTERA5()
         APAGA_MINIBOT()
      ENDIF
ELSE
   APAGA_CTRL()
   APAGA_TABS()
   APAGA_RTFS()
   FORM_1.MINITAB_5.PICTURE := 'AUX5_ON'
   FORM_1.Auxiliary_5.SHOW
   MAGISTERA5()
   activ_doc := "5"
   APAGA_MINIBOT()
ENDIF
RETURN

PROCEDURE APAGA_TABS
FORM_1.MINITAB_0.PICTURE := 'START_OFF'
IF ALLTRIM(Aux_FileN1) == ''
   FORM_1.MINITAB_1.PICTURE := 'AUX1_OFF'
ELSE
   FORM_1.MINITAB_1.PICTURE := 'AUX1_BY'
ENDIF
IF ALLTRIM(Aux_FileN2) == ''
   FORM_1.MINITAB_2.PICTURE := 'AUX2_OFF'
ELSE
   FORM_1.MINITAB_2.PICTURE := 'AUX2_BY'
ENDIF
IF ALLTRIM(Aux_FileN3) == ''
   FORM_1.MINITAB_3.PICTURE := 'AUX3_OFF'
ELSE
   FORM_1.MINITAB_3.PICTURE := 'AUX3_BY'
ENDIF
IF ALLTRIM(Aux_FileN4) == ''
   FORM_1.MINITAB_4.PICTURE := 'AUX4_OFF'
ELSE
   FORM_1.MINITAB_4.PICTURE := 'AUX4_BY'
ENDIF
IF ALLTRIM(Aux_FileN5) == ''
   FORM_1.MINITAB_5.PICTURE := 'AUX5_OFF'
ELSE
   FORM_1.MINITAB_5.PICTURE := 'AUX5_BY'
ENDIF
RETURN

PROCEDURE APAGA_RTFS
FORM_1.MINIWRITE_1.HIDE
FORM_1.Auxiliary_1.HIDE
FORM_1.Auxiliary_2.HIDE
FORM_1.Auxiliary_3.HIDE
FORM_1.Auxiliary_4.HIDE
FORM_1.Auxiliary_5.HIDE
RETURN

PROCEDURE APAGA_CTRL
FORM_1.BOT_MASTER.ENABLED := .F.
FORM_1.BOT_MINI1.ENABLED  := .F.
FORM_1.BOT_MINI2.ENABLED  := .F.
FORM_1.BOT_MINI3.ENABLED  := .F.
RETURN

PROCEDURE PRENDE_CTRL
FORM_1.BOT_MASTER.ENABLED := .T.
FORM_1.BOT_MINI1.ENABLED  := .T.
FORM_1.BOT_MINI2.ENABLED  := .T.
FORM_1.BOT_MINI3.ENABLED  := .T.
RETURN

PROCEDURE CLIPP_VIEW
   cCurrentForm := "Form_2X"

   IF FILE( "CLIP.RTF" )
   ELSE
      RETURN
   ENDIF
   DEFINE WINDOW Form_2X ;
      AT ctr + 40, ctc + 204 ;
      WIDTH 410 ;
      HEIGHT 529 ;
      TITLE '' ;
      MODAL ;
      NOSIZE ;
      NOSYSMENU ;
      NOCAPTION ;
      BACKCOLOR { 218,229,243 } ;
      ON INIT  ( Form_2X.CLIPFULL.RTFLoadFile ("CLIP.RTF", .F., 4) )

      DEFINE IMAGE RIB_1
         ROW	0
         COL	0
         WIDTH	410
         HEIGHT 24
         PICTURE	'HP_CC'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE RIB_2
         ROW	24
         COL	0
         WIDTH	7
         HEIGHT 475
         PICTURE	'BULLET_Il'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE RIB_3
         ROW	24
         COL	400
         WIDTH	10
         HEIGHT 475
         PICTURE	'HP_D'
         STRETCH	.T.
      END IMAGE

      DEFINE IMAGE RIB_4
         ROW	496
         COL	0
         WIDTH	410
         HEIGHT 33
         PICTURE	'HP_IC'
         STRETCH	.T.
      END IMAGE


      @ 30,10 RICHEDITBOX CLIPFULL ;
         WIDTH 384 ;
         HEIGHT 458 ;
         MAXLENGTH -1;
         NOHSCROLL;
         READONLY;
         BACKCOLOR {255,255,255}


      @ 500, 318 LABEL RESPDEL_NO ;
          WIDTH 80 HEIGHT 20 ;
          VALUE '' ;
          ACTION ( Form_2X.Release ) ;
          TOOLTIP 'Quit Clippboard Contents Window' ;
          TRANSPARENT


      SET TOOLTIPCUSTOMDRAW FORM &cCurrentForm  TITLE cToolTipTitle  ICON TOOLTIPICON_INFO

   END WINDOW

   ACTIVATE WINDOW Form_2X

RETURN

PROCEDURE GUARDA_CLIP
LOCAL CLIPFileName
IF activ_doc == "0"
   FORM_1.MINIWRITE_1.SELCOPY()
ENDIF
IF activ_doc == "1"
   FORM_1.AUXILIARY_1.SELCOPY()
ENDIF
IF activ_doc == "2"
   FORM_1.AUXILIARY_2.SELCOPY()
ENDIF
IF activ_doc == "3"
   FORM_1.AUXILIARY_3.SELCOPY()
ENDIF
IF activ_doc == "4"
   FORM_1.AUXILIARY_4.SELCOPY()
ENDIF
IF activ_doc == "5"
   FORM_1.AUXILIARY_5.SELCOPY()
ENDIF
Form_1.AUXILIARY_0.SelectAll
Form_1.AUXILIARY_0.SelClear
FORM_1.AUXILIARY_0.SELPASTE
CLIPFileName := "CLIP.RTF"
Form_1.AUXILIARY_0.RTFSaveFile ( CLIPFileName, 4, .F.)
RETURN

PROCEDURE MULTICUT
IF activ_doc == "0"
   Form_1.miniwrite_1.SelCut()
ENDIF
IF activ_doc == "1"
   Form_1.AUXILIARY_1.SelCut()
ENDIF
IF activ_doc == "2"
   Form_1.AUXILIARY_2.SelCut()
ENDIF
IF activ_doc == "3"
   Form_1.AUXILIARY_3.SelCut()
ENDIF
IF activ_doc == "4"
   Form_1.AUXILIARY_4.SelCut()
ENDIF
IF activ_doc == "5"
   Form_1.AUXILIARY_5.SelCut()
ENDIF
RETURN

PROCEDURE MULTICOPY
IF activ_doc == "0"
   Form_1.miniwrite_1.SelCopy()
ENDIF
IF activ_doc == "1"
   Form_1.AUXILIARY_1.SelCopy()
ENDIF
IF activ_doc == "2"
   Form_1.AUXILIARY_2.SelCopy()
ENDIF
IF activ_doc == "3"
   Form_1.AUXILIARY_3.SelCopy()
ENDIF
IF activ_doc == "4"
   Form_1.AUXILIARY_4.SelCopy()
ENDIF
IF activ_doc == "5"
   Form_1.AUXILIARY_5.SelCopy()
ENDIF
RETURN

PROCEDURE MULTICLEAR
IF activ_doc == "0"
   Form_1.miniwrite_1.SelClear()
ENDIF
IF activ_doc == "1"
   Form_1.AUXILIARY_1.SelClear()
ENDIF
IF activ_doc == "2"
   Form_1.AUXILIARY_2.SelClear()
ENDIF
IF activ_doc == "3"
   Form_1.AUXILIARY_3.SelClear()
ENDIF
IF activ_doc == "4"
   Form_1.AUXILIARY_4.SelClear()
ENDIF
IF activ_doc == "5"
   Form_1.AUXILIARY_5.SelClear()
ENDIF
RETURN

PROCEDURE MARCACLEAN1
IF REFAY.IAUX_BOT1.PICTURE == "BOT_AUX1_OFF"
   REFAY.IAUX_BOT1.PICTURE := "BOT_AUX1_ON"
   RETURN
ENDIF

IF REFAY.IAUX_BOT1.PICTURE == "BOT_AUX1_ON"
   REFAY.IAUX_BOT1.PICTURE := "BOT_AUX1_OFF"
   RETURN
ENDIF
RETURN

PROCEDURE MARCACLEAN2
DO CASE
   CASE REFAY.IAUX_BOT2.PICTURE == "BOT_AUX2_OFF"
        REFAY.IAUX_BOT2.PICTURE := "BOT_AUX2_ON"
        RETURN

   CASE REFAY.IAUX_BOT2.PICTURE == "BOT_AUX2_ON"
        REFAY.IAUX_BOT2.PICTURE := "BOT_AUX2_OFF"
        RETURN

END CASE
RETURN

PROCEDURE MARCACLEAN3
IF REFAY.IAUX_BOT3.PICTURE == "BOT_AUX3_OFF"
   REFAY.IAUX_BOT3.PICTURE := "BOT_AUX3_ON"
   RETURN
ENDIF
IF REFAY.IAUX_BOT3.PICTURE == "BOT_AUX3_ON"
   REFAY.IAUX_BOT3.PICTURE := "BOT_AUX3_OFF"
   RETURN
ENDIF
RETURN

PROCEDURE MARCACLEAN4
DO CASE
   CASE REFAY.IAUX_BOT4.PICTURE == "BOT_AUX4_OFF"
        REFAY.IAUX_BOT4.PICTURE := "BOT_AUX4_ON"
        RETURN

   CASE REFAY.IAUX_BOT4.PICTURE.VALUE == "BOT_AUX4_ON"
        REFAY.IAUX_BOT4.PICTURE.VALUE := "BOT_AUX4_OFF"
        RETURN

END CASE
RETURN

PROCEDURE MARCACLEAN5
DO CASE
   CASE REFAY.IAUX_BOT5.PICTURE == "BOT_AUX5_OFF"
        REFAY.IAUX_BOT5.PICTURE := "BOT_AUX5_ON"
        RETURN

   CASE REFAY.IAUX_BOT5.PICTURE.VALUE == "BOT_AUX5_ON"
        REFAY.IAUX_BOT5.PICTURE.VALUE := "BOT_AUX5_OFF"
        RETURN

END CASE
RETURN

PROCEDURE FUTURE_CLEAN
IF  REFAY.IAUX_BOT1.PICTURE == "BOT_AUX1_ON"
    Form_1.auxiliary_1.CaretPos := 1
    Form_1.AUXILIARY_1.SelectAll
    Form_1.AUXILIARY_1.SelClear
    Form_1.AUXILIARY_1.VALUE := "x"
    REFAY.IAUX_BOT1.PICTURE := "BOT_AUX1_OFF"
    FORM_1.MINITAB_1.PICTURE := 'AUX1_OFF'
ENDIF
IF  REFAY.IAUX_BOT2.PICTURE == "BOT_AUX2_ON"
    Form_1.auxiliary_2.CaretPos := 1
    Form_1.AUXILIARY_2.SelectAll
    Form_1.AUXILIARY_2.SelClear
    Form_1.AUXILIARY_2.VALUE := "x"
    REFAY.IAUX_BOT2.PICTURE := "BOT_AUX2_OFF"
    FORM_1.MINITAB_2.PICTURE := 'AUX2_OFF'
ENDIF
IF  REFAY.IAUX_BOT3.PICTURE == "BOT_AUX3_ON"
    Form_1.AUXILIARY_3.VALUE := ''
    REFAY.IAUX_BOT3.PICTURE := "BOT_AUX3_OFF"
    FORM_1.MINITAB_3.PICTURE := 'AUX3_OFF'
    Aux_FileN3 := ''
    FORM_1.AUXTAB_3.TOOLTIP := 'Press here to load Auxiliary Document 3 (save option disable)'
ENDIF
IF  REFAY.IAUX_BOT4.PICTURE == "BOT_AUX4_ON"
    Form_1.AUXILIARY_4.VALUE := ''
    REFAY.IAUX_BOT4.PICTURE := "BOT_AUX4_OFF"
    FORM_1.MINITAB_4.PICTURE := 'AUX4_OFF'
    Aux_FileN4 := ''
    FORM_1.AUXTAB_4.TOOLTIP := 'Press here to load Auxiliary Document 4 (save option disable)'
ENDIF
IF  REFAY.IAUX_BOT5.PICTURE == "BOT_AUX5_ON"
    Form_1.AUXILIARY_5.VALUE := 'x'
    REFAY.IAUX_BOT1.PICTURE := "BOT_AUX5_OFF"
    FORM_1.MINITAB_5.PICTURE := 'AUX5_OFF'
    Aux_FileN5 := ''
    FORM_1.AUXTAB_5.TOOLTIP := 'Press here to load Auxiliary Document 5 (save option disable)'
ENDIF
APAGA_RTFS()
PRENDE_CTRL()
FORM_1.MINITAB_0.PICTURE := 'START_ON'
FORM_1.MINIWRITE_1.SHOW
Form_1.Auxiliary_1.HIDE
Form_1.Auxiliary_2.HIDE
Form_1.Auxiliary_3.HIDE
Form_1.Auxiliary_4.HIDE
Form_1.Auxiliary_5.HIDE
MAGISTER()
RETURN

PROCEDURE Define_Control_Context_Menu (AUX_RICHBOX)

Do Case

   Case AUX_RICHBOX == "Miniwrite_1"
        DEFINE CONTROL CONTEXTMENU &AUX_RICHBOX OF Form_1
            ITEM " Copy selected text to clippboard" IMAGE "COPY" ACTION GUARDA_CLIP()
            Item " Paste text from clippboard" IMAGE "PASTE" ACTION ( Form_1.miniwrite_1.SelPaste() )
            SEPARATOR
            ITEM " Bold" IMAGE "BOLD_M" ACTION ( cheka_bold() )
            ITEM " Italic" IMAGE "ITAL_M" ACTION ( cheka_italic() )
            ITEM " Underline" IMAGE "SUBRA_M" ACTION ( cheka_subra() )
            ITEM " Strike" IMAGE "STRIKE_M" ACTION ( cheka_tacha() )
            ITEM " Subscript" IMAGE "SUB_M" ACTION ( cheka_sub() )
            ITEM " Superscript" IMAGE "SUP_M" ACTION ( cheka_sup() )
            SEPARATOR
            ITEM " Left Alignment" IMAGE "LEFT_M" ACTION ( Form_1.miniwrite_1.ParaAlignment := RTF_LEFT , OnSelectProc() )
            ITEM " Center Alignment" IMAGE "CENTER_M" ACTION ( Form_1.miniwrite_1.ParaAlignment := RTF_CENTER , OnSelectProc() )
            ITEM " Right Alignment" IMAGE "RIGHT_M" ACTION ( Form_1.miniwrite_1.ParaAlignment := RTF_RIGHT , OnSelectProc() )
            ITEM " Justify Alignment" IMAGE "JUST_M" ACTION ( Form_1.miniwrite_1.ParaAlignment := RTF_JUSTIFY , form_1.miniwrite_1.paraindent := 0 , form_1.miniwrite_1.paraoffset := 0 , OnSelectProc() )
            ITEM " First Line French Alignment" IMAGE "FRENCH_M" ACTION (IF(form_1.miniwrite_1.ParaAlignment <> 4 , nil , ( form_1.miniwrite_1.paraindent := fsngi , form_1.miniwrite_1.paraoffset := FSNGO )) , OnSelectProc() )
        END MENU
   Case AUX_RICHBOX == "Auxiliary_1"
        DEFINE CONTROL CONTEXTMENU &AUX_RICHBOX OF Form_1
            ITEM " Copy selected text to clippboard" IMAGE "COPY" ACTION GUARDA_CLIP()
        END MENU
   Case AUX_RICHBOX == "Auxiliary_2"
        DEFINE CONTROL CONTEXTMENU &AUX_RICHBOX OF Form_1
            ITEM " Copy selected text to clippboard" IMAGE "COPY" ACTION GUARDA_CLIP()
        END MENU
   Case AUX_RICHBOX == "Auxiliary_3"
        DEFINE CONTROL CONTEXTMENU &AUX_RICHBOX OF Form_1
            ITEM " Copy selected text to clippboard" IMAGE "COPY" ACTION GUARDA_CLIP()
        END MENU
   Case AUX_RICHBOX == "Auxiliary_4"
        DEFINE CONTROL CONTEXTMENU &AUX_RICHBOX OF Form_1
            ITEM " Copy selected text to clippboard" IMAGE "COPY" ACTION GUARDA_CLIP()
        END MENU
   Case AUX_RICHBOX == "Auxiliary_5"
        DEFINE CONTROL CONTEXTMENU &AUX_RICHBOX OF Form_1
            ITEM " Copy selected text to clippboard" IMAGE "COPY" ACTION GUARDA_CLIP()
        END MENU
Endcase
RETURN

PROCEDURE APAGA_MINIBOT
FORM_1.Combo_1.ENABLED := .F.
FORM_1.Combo_2.ENABLED := .F.
FORM_1.Combo_3.ENABLED := .F.
FORM_1.BOT_MASTER.ENABLED := .F.
FORM_1.BOT_MINI1.ENABLED := .F.
FORM_1.BOT_MINI2.ENABLED := .F.
FORM_1.BOT_MINI3.ENABLED := .F.
FORM_1.BOT_MINI4.ENABLED := .F.
FORM_1.BOT_RIBC1.ENABLED := .F.
FORM_1.BOT_RIBC2.ENABLED := .F.
FORM_1.BOT_RIBC3.ENABLED := .F.
FORM_1.BOT_RIBC4.ENABLED := .F.
FORM_1.BOT_RIBF1.ENABLED := .F.
FORM_1.BOT_RIBF2.ENABLED := .F.
FORM_1.BOT_RIBF3.ENABLED := .F.
FORM_1.BOT_RIBF4.ENABLED := .F.
FORM_1.BOT_RIBF5.ENABLED := .F.
FORM_1.BOT_RIBF6.ENABLED := .F.
FORM_1.BOT_RIBF6X.ENABLED := .F.
FORM_1.BOT_RIBP1.ENABLED := .F.
FORM_1.BOT_RIBP1B.ENABLED := .F.
FORM_1.BOT_RIBP2.ENABLED := .F.
FORM_1.BOT_RIBP2_3.ENABLED := .F.
FORM_1.BOT_RIBP3.ENABLED := .F.
FORM_1.BOT_RIBP4.ENABLED := .F.
FORM_1.BOT_RIBP4B.ENABLED := .F.
FORM_1.BOT_RIBP5.ENABLED := .F.
FORM_1.BOT_RIBP6.ENABLED := .F.
FORM_1.BOT_RIBP7.ENABLED := .F.
FORM_1.BOT_RIBP8.ENABLED := .F.
FORM_1.BOT_RIBPF.ENABLED := .F.
FORM_1.BOT_RIBX01.ENABLED := .F.
FORM_1.BOT_RIBX02.ENABLED := .F.
FORM_1.BOT_RIBX03.ENABLED := .F.
FORM_1.BOT_RIBX04.ENABLED := .F.
FORM_1.BOT_RIBX05.ENABLED := .F.
FORM_1.BOT_RIBE5.ENABLED := .F.
FORM_1.BOT_RIBE6.ENABLED := .F.
FORM_1.BOT_RIBE7.ENABLED := .F.
FORM_1.BOT_RIBE8.ENABLED := .F.
FORM_1.BOT_RIBE9.ENABLED := .F.
FORM_1.BOT_RIBE10.ENABLED := .F.
RETURN

PROCEDURE PRENDE_MINIBOT
FORM_1.Combo_1.ENABLED := .T.
FORM_1.Combo_2.ENABLED := .T.
FORM_1.Combo_3.ENABLED := .T.
FORM_1.BOT_MASTER.ENABLED := .T.
FORM_1.BOT_MINI1.ENABLED := .T.
FORM_1.BOT_MINI2.ENABLED := .T.
FORM_1.BOT_MINI3.ENABLED := .T.
FORM_1.BOT_MINI4.ENABLED := .T.
FORM_1.BOT_RIBC1.ENABLED := .T.
FORM_1.BOT_RIBC2.ENABLED := .T.
FORM_1.BOT_RIBC3.ENABLED := .T.
FORM_1.BOT_RIBC4.ENABLED := .T.
FORM_1.BOT_RIBF1.ENABLED := .T.
FORM_1.BOT_RIBF2.ENABLED := .T.
FORM_1.BOT_RIBF3.ENABLED := .T.
FORM_1.BOT_RIBF4.ENABLED := .T.
FORM_1.BOT_RIBF5.ENABLED := .T.
FORM_1.BOT_RIBF6.ENABLED := .T.
FORM_1.BOT_RIBF6X.ENABLED := .T.
FORM_1.BOT_RIBP1.ENABLED := .T.
FORM_1.BOT_RIBP1B.ENABLED := .T.
FORM_1.BOT_RIBP2.ENABLED := .T.
FORM_1.BOT_RIBP2_3.ENABLED := .T.
FORM_1.BOT_RIBP3.ENABLED := .T.
FORM_1.BOT_RIBP4.ENABLED := .T.
FORM_1.BOT_RIBP4B.ENABLED := .T.
FORM_1.BOT_RIBP5.ENABLED := .T.
FORM_1.BOT_RIBP6.ENABLED := .T.
FORM_1.BOT_RIBP7.ENABLED := .T.
FORM_1.BOT_RIBP8.ENABLED := .T.
FORM_1.BOT_RIBPF.ENABLED := .T.
FORM_1.BOT_RIBX01.ENABLED := .T.
FORM_1.BOT_RIBX02.ENABLED := .T.
FORM_1.BOT_RIBX03.ENABLED := .T.
FORM_1.BOT_RIBX04.ENABLED := .T.
FORM_1.BOT_RIBX05.ENABLED := .T.
FORM_1.BOT_RIBE5.ENABLED := .T.
FORM_1.BOT_RIBE6.ENABLED := .T.
FORM_1.BOT_RIBE7.ENABLED := .T.
FORM_1.BOT_RIBE8.ENABLED := .T.
FORM_1.BOT_RIBE9.ENABLED := .T.
FORM_1.BOT_RIBE10.ENABLED := .T.
RETURN

function win_p2n( x ); return __xhb_p2n( x )
function hb_gt_gui(); return Nil
function hb_gt_gui_default(); return Nil
REQUEST HB_GT_WVG
REQUEST HB_GT_WVG_DEFAULT
