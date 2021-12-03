#include "hmg.ch"

DECLARE WINDOW Form_1

Function InOtherPrg()
LOCAL Width  := BT_ClientAreaWidth  ("Form_1")
LOCAL Height := BT_ClientAreaHeight ("Form_1")  
LOCAL hDC, BTstruct

hDC = BT_CreateDC ("Form_1", BT_HDC_INVALIDCLIENTAREA, @BTstruct)

Form_1.Title             := 'Changed title from in OTHER Prg' 
Form_1.Label_1.Value     := 'TITLE changed from OTHER Prg'
Form_1.Label_1.Col       := 200
BT_DrawGradientFillVertical (hDC, 0, 0, Width, Height, RED, BLACK)
Form_1.Label_2.FontColor := WHITE
Form_1.Button_1.SetFocus
Return Nil