#xcommand DECLARE CUSTOM COMPONENTS <Window> ;
=>;
_dummy() ;;
#define SOOP_MYBUTTON ;;
#xtranslate <Window> . \<Control\> . Print ( ) => Domethod ( <"Window">, \<"Control"\> , "Print" )  ;;
#xtranslate <Window> . \<Control\> . Print  => Domethod ( <"Window">, \<"Control"\> , "Print" )  ;;
#undef SOOP_MYBUTTON ;;