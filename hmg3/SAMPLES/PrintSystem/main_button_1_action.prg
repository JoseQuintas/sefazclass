#include "hmg.ch"

declare window Main

Function main_button_1_action

	Use Test

	LOAD REPORT Test

	EXECUTE REPORT Test PREVIEW SELECTPRINTER

	Use

Return Nil
