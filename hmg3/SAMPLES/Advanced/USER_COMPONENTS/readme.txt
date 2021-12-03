
HMG USER COMPONENTS SAMPLE
--------------------------

To run this sample, please add the following text to c:\hmg\include\usrinit.ch

#define BASEDEF_MYBUTTON 

#xcommand @ <row>,<col> MYBUTTON <name> ;
		OF <parent> ;
		CAPTION <caption> ;
		ACTION <action> ;
	=>;
	_DefineMyButton(<"name">,<row>,<col>,<caption>,<{action}>,<"parent">)

#undef BASEDEF_MYBUTTON 

And ADD the following to c:\hmg\include\i_usrsoop.ch without leaving blank
lines between the text currently in that file and this.

#define SOOP_MYBUTTON ;;
#xtranslate <Window> . \<Control\> . Disable  => Domethod ( <"Window">, \<"Control"\> , "Disable" )  ;;
#xtranslate <Window> . \<Control\> . Enable  => Domethod ( <"Window">, \<"Control"\> , "Enable" )  ;;
#xtranslate <Window> . \<Control\> . Handle  => GetProperty ( <"Window">, \<"Control"\> , "Handle" )  ;;
#xtranslate <Window> . \<Control\> . Handle  := \<v\> => SetProperty ( <"Window">, \<"Control"\> , "Handle" , \<v\> )  ;;
#undef SOOP_MYBUTTON ;;