#include 'hmg.ch'

Declare Window Test_1
Declare Window Andy1

Procedure Opentest

	IF !IsWindowDefined(Test_1) .And. !IsWindowDefined(Andy1)

		Load Window Test_1
		Load Window Andy1

		Test_1.Row := 30
		Test_1.Col := 30

		Andy1.Row := 200
		Andy1.Col := 200

		Activate Window Andy1 , Test_1

	EndIf

Return
