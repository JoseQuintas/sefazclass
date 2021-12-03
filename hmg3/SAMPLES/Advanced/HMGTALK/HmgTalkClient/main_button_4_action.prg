#include "hmg.ch"

declare window Main

Function main_button_4_action
	c_RingTone := Getfile ( { {'WAV Files','*.*'} } , 'Open File' , 'Media\' , .f. , .t. )
Return Nil
