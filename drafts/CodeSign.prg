// Code Sign

#define URL "http://timestamp.verisign.com/scripts/timstamp.dll"

PROCEDURE Main

   LOCAL oSignedCode, oSigner, oElement

   oSignedCode := win_OleCreateObject( "CAPICOM.SignedCode" )
   oSigner     := win_OleCreateObject( "CAPICOM.Signer" )

   oSignedCode:FileName       := "d:\temp\test2.exe"
   oSignedCode:Description    := "José M. C. Quintas"
   oSignedCode:DescriptionURL := "www.josequintas.com.br"
   ? oSignedCode:Sign( oSigner )
   ? oSignedCode:TimeStamp( URL )
   ? oSignedCode:Verify()

   FOR EACH oElement IN oSignedCode:Certificates
      ? oElement:SubjectName
   NEXT

   RETURN


