/*
* HMG Activex Demo
*/

#include "hmg.ch"

Function Main

	Load Window Demo
	Activate Window Demo

Return

Procedure demo_button_1_action

	Demo.Activex_1.Object:Navigate("http://www.hmgforum.com/")

Return