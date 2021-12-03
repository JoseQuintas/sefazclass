
    #command @ <row>, <col> COMBOSEARCHBOX <name>                  ;
             [ <dummy1: OF, PARENT> <parent> ] ;
                            [ HEIGHT <height> ]             ;
                            [ WIDTH <width> ]               ;
                            [ VALUE <value> ]               ;
                            [ FONT <fontname> ]             ;
                            [ SIZE <fontsize> ]             ;
                            [ <bold : BOLD> ] ;
                            [ <italic : ITALIC> ] ;
                            [ <underline : UNDERLINE> ] ;
                            [ TOOLTIP <tooltip> ]           ;
                            [ BACKCOLOR <backcolor> ] ;
                            [ FONTCOLOR <fontcolor> ] ;
                            [ MAXLENGTH <maxlenght> ]       ;
                            [ <upper: UPPERCASE> ]          ;
                            [ <lower: LOWERCASE> ]          ;
                            [ <numeric: NUMERIC> ]          ;
                            [ ON GOTFOCUS <gotfocus> ]      ;
                            [ ON LOSTFOCUS <lostfocus> ]    ;
                            [ ON ENTER <enter> ]      ;
                            [ <RightAlign: RIGHTALIGN> ]   ;
                            [ <notabstop: NOTABSTOP> ]   ;
                            [ HELPID <helpid> ]       ;
                            [ ITEMS <aitems>  ]     ;
                            [ <anywhere :ANYWHERESEARCH> ];
                            [ <dropheight :DROPPEDHEIGHT> ];
                            [ <additive :ADDITIVE> ];
                            [ ROWOFFSET <nrowoffset> ];
                            [ COLOFFSET <ncoloffset> ];
             =>;
             _DefineComboSearchBox( <"name">, <"parent">, <col>, <row>, <width>, <height>, <value>, ;
                <fontname>, <fontsize>, <tooltip>, <maxlenght>, ;
                            <.upper.>, <.lower.>, <.numeric.>, ;
                <{lostfocus}>, <{gotfocus}>, <{enter}>, ;
                <.RightAlign.>, <helpid>, <.bold.>, <.italic.>, <.underline.>, <backcolor> , <fontcolor> , <.notabstop.>, <aitems>,<.anywhere.>,<dropheight>, <.additive.>, <nrowoffset>, <ncoloffset>)

	#xcommand ANYWHERESEARCH	<sort>	;
	=>;
	_HMG_SYSDATA \[ 464 \]		:= <sort>
	#xcommand DROPHEIGHT	<dropheight>	;
	=>;
	_HMG_SYSDATA \[ 249 \]		:= <dropheight>
	#xcommand ADDITIVE	<additive>	;
	=>;
	_HMG_SYSDATA \[ 439 \]		:= <additive>
	#xcommand ROWOFFSET	<rowoffset>	;
	=>;
	_HMG_SYSDATA \[ 449 \]		:= <rowoffset>
	#xcommand COLOFFSET	<coloffset>	;
	=>;
	_HMG_SYSDATA \[ 450 \]		:= <coloffset>
                
                
                               
    #xcommand DEFINE COMBOSEARCHBOX <name>;
       =>;
       _HMG_SYSDATA \[ 416 \]   := <"name">   ;; //name
       _HMG_SYSDATA \[ 417 \]   := Nil      ;; //parent
       _HMG_SYSDATA \[ 431 \]   := Nil      ;; //row
       _HMG_SYSDATA \[ 432 \]   := Nil      ;; //col
       _HMG_SYSDATA \[ 421 \]   := Nil      ;; // height
       _HMG_SYSDATA \[ 420 \]   := Nil      ;; // width
       _HMG_SYSDATA \[ 434 \]   := Nil      ;; //value
       _HMG_SYSDATA \[ 422 \]  := Nil      ;; //font
       _HMG_SYSDATA \[ 423 \]   := Nil      ;; // size
       _HMG_SYSDATA \[ 412 \]   := .f.      ;; //bold
       _HMG_SYSDATA \[ 413 \]   := .f.      ;; // italic
       _HMG_SYSDATA \[ 415 \]   := .f.      ;; // underline
       _HMG_SYSDATA \[ 424 \]   := Nil      ;; //tooltip
       _HMG_SYSDATA \[ 457 \]   := Nil      ;; // backcolor
       _HMG_SYSDATA \[ 458 \]   := Nil      ;; // fontcolor
       _HMG_SYSDATA \[ 442 \] := Nil   ;; // maxlength
       _HMG_SYSDATA \[ 475 \] := .f.      ;; //upper
       _HMG_SYSDATA \[ 476 \]   := .f.      ;;  //lower
       _HMG_SYSDATA \[ 477 \]   := .f.      ;;  // numeric
       _HMG_SYSDATA \[ 426 \] := Nil      ;; // gotfocus
       _HMG_SYSDATA \[ 427 \]   := Nil         ;; //lostfocus
       _HMG_SYSDATA \[ 437 \]   := Nil         ;; //enter
       _HMG_SYSDATA \[ 440 \]    := .f.          ;; //rightalign
       _HMG_SYSDATA \[ 428 \]   := .t.      ;; //tabstop
       _HMG_SYSDATA \[ 429 \]   := Nil      ;; // helpid
       _HMG_SYSDATA \[ 436 \]      := Nil   ;;    // items
       _HMG_SYSDATA \[ 464 \]      := .f.   ;;    // anywhere search
       _HMG_SYSDATA \[ 249 \]      := 0    ;;// dropped height
       _HMG_SYSDATA \[ 439 \]      := .f.  ;;  // additive
       _HMG_SYSDATA \[ 449 \]      := 0    ;;// rowoffset
       _HMG_SYSDATA \[ 450 \]      := 0    // coloffset
         
    #xcommand END COMBOSEARCHBOX;
       =>;
          _DefineComboSearchBox(;
             _HMG_SYSDATA \[ 416 \],; //name
             _HMG_SYSDATA \[ 417 \],; //parent
             _HMG_SYSDATA \[ 432 \],; //col
             _HMG_SYSDATA \[ 431 \],; //row
             _HMG_SYSDATA \[ 420 \],; //width
             _HMG_SYSDATA \[ 421 \],; //height
             _HMG_SYSDATA \[ 434 \],; //value
             _HMG_SYSDATA \[ 422 \],; //fontname
             _HMG_SYSDATA \[ 423 \],; //fontsize
             _HMG_SYSDATA \[ 424 \],; //tooltip
             _HMG_SYSDATA \[ 442 \],; //maxlength
             _HMG_SYSDATA \[ 475 \],; //upper
             _HMG_SYSDATA \[ 476 \],; //lower
             _HMG_SYSDATA \[ 477 \],; //numeric
             _HMG_SYSDATA \[ 427 \],; //lostfocus
             _HMG_SYSDATA \[ 426 \],; //gotfocus
             _HMG_SYSDATA \[ 437 \],; //enter
             _HMG_SYSDATA \[ 440 \],; //rightalign
             _HMG_SYSDATA \[ 429 \],; //helpid
             _HMG_SYSDATA \[ 412 \],; //bold
             _HMG_SYSDATA \[ 413 \] , ; //italic
             _HMG_SYSDATA \[ 415 \],; //underline
             _HMG_SYSDATA \[ 457 \] , ; //backcolor
             _HMG_SYSDATA \[ 458 \] , ;// fontcolor
             _HMG_SYSDATA \[ 428 \] ,; //tabstop
             _HMG_SYSDATA \[ 436 \] ,; // aitems
             _HMG_SYSDATA \[ 464 \] ,; //  anywhere search
             _HMG_SYSDATA \[ 249 \] ,; //  droppedheight
             _HMG_SYSDATA \[ 439 \] ,; //  additive
             _HMG_SYSDATA \[ 449 \] ,; //  rowoffset
             _HMG_SYSDATA \[ 450 \] ; //  coloffset
             ) 
       
                   
               
