# pdfclass
work with harupdf as a traditional report

A quick sample:

From => To

@ 1, 1 SAY nValue PICTURE "999,999.99"  => oPDF:DrawText( 1, 1, nValue, "999,999.99"

@ nLin, 1 SAY "x" => oPDF:DrawText( oPDF:nRow, 1, "x" )

IF nLin > 60 => oPDF:MaxRowTest()

Automatic Headers => oPDF:acHeaders := { "Title", "SubTitle", "Others..." }

SET DEVICE TO PRINT => oPDF:Begin()

SET DEVICE TO SCREEN => oPDF:End()
