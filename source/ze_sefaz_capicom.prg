/*
ZE_CAPICOM - ROTINAS PRA USO DA CAPICOM
José Quintas
*/

#include "sefaz_capicom.ch"
#include "sefazclass.ch"

FUNCTION CapicomEscolheCertificado( dValidFrom, dValidTo )

   LOCAL oCertificado, oStore, cNomeCertificado := "NENHUM", oColecao

   oStore := win_oleCreateObject( "CAPICOM.Store" )
   oStore:Open( CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
   oColecao := oStore:Certificates()
   DO CASE
   CASE oColecao:Count() == 1
      oCertificado     := oColecao:item(1)
      dValidFrom       := oCertificado:ValidFromDate
      dValidTo         := oCertificado:ValidToDate
      cNomeCertificado := oCertificado:SubjectName
   CASE oColecao:Count() > 1
      oCertificado     := oColecao:Select( "Selecione o certificado para uso da Nfe","Selecione o certificado", .F. )
      dValidFrom       := oCertificado:item(1):ValidFromDate
      dValidTo         := oCertificado:item(1):ValidToDate
      cNomeCertificado := oCertificado:item(1):SubjectName
   ENDCASE
   IF "CN=" $ cNomeCertificado
      cNomeCertificado := Substr( cNomeCertificado, At( "CN=", cNomeCertificado ) + 3 )
      IF "," $ cNomeCertificado
         cNomeCertificado := Substr( cNomeCertificado, 1, At( ",", cNomeCertificado ) - 1 )
      ENDIF
   ENDIF
   // oStore:Close()

   RETURN cNomeCertificado

FUNCTION CapicomCertificado( cNomeCertificado, dValidFrom, dValidTo, lValidDate )

   LOCAL oStore, oColecao, oCertificado, nCont, lValid, lSelected := .F.

   hb_Default( @lValidDate, .T. )
   oStore := Win_OleCreateObject( "CAPICOM.Store" )
   oStore:Open( CAPICOM_CURRENT_USER_STORE, "My", CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
   oColecao := oStore:Certificates()
   //aList := oColecao:Find( CAPICOM_CERTIFICATE_FIND_ISSUER_NAME, cNomeCertificado, .T. )
   FOR nCont = 1 TO oColecao:Count()
      IF cNomeCertificado $ oColecao:Item( nCont ):SubjectName ;
         .OR. cNomeCertificado == oColecao:Item( nCont ):ThumbPrint
         lValid := oColecao:Item( nCont ):ValidFromDate <= Date() ;
         .AND. oColecao:Item( nCont ):ValidToDate >= Date()
         IF ! ( lValid == lValidDate )
            LOOP
         ENDIF
         // se tem A3 e A1 na mesma máquina, ambos válidos, pega o A1
         IF ! lSelected .OR. "PJ A1" $ oColecao:Item( nCont ):SubjectName
            oCertificado := oColecao:Item( nCont )
            dValidFrom   := oCertificado:ValidFromDate
            dValidTo     := oCertificado:ValidToDate
            lSelected    := .T.
         ENDIF
      ENDIF
   NEXT
   oStore:Close()
   //IF aList:Count() > 0
   //   oCertificado := aList:Item(0)
   //   dValidFrom   := oCertificado:ValidFromDate
   //   dValidTo     := oCertificado:ValidToDate
   //ENDIF

   RETURN oCertificado

FUNCTION CapicomRemoveCertificado( cNomeCertificado, lValidDate )

   LOCAL oCertificado, oStore

   hb_Default( @lValidDate, .F. )

   oCertificado := CapicomCertificado( cNomeCertificado,, lValidDate )
   IF ValType( oCertificado ) == "O"
      oStore := win_OleCreateObject( "CAPICOM.Store" )
      oStore:open( CAPICOM_CURRENT_USER_STORE, CAPICOM_MY_STORE, CAPICOM_STORE_OPEN_READ_WRITE )
      oStore:Remove( oCertificado )
      oStore:Close()
   ENDIF

   RETURN NIL

FUNCTION CapicomInstalaPFX( cFileName, cPassword, lREMOVER )

   LOCAL oCertificado, oStore, cID

   hb_Default( @lREMOVER, .F. )

   BEGIN SEQUENCE WITH __BreakBlock()

      oCertificado := win_OleCreateObject( "CAPICOM.Certificate" )
      oCertificado:Load( cFileName, cPassword, CAPICOM_KEY_STORAGE_DEFAULT, 0 )
      cID := oCertificado:SubjectName

      IF "CN=" $ cID
         cID := Substr( cID, At( "CN=", cID ) + 3 )
         IF "," $ cID
            cID := Substr( cID, 1, At( ",", cID ) - 1 )
         ENDIF
      ENDIF

      oStore := win_OleCreateObject( "CAPICOM.Store" )
      oStore:open( CAPICOM_CURRENT_USER_STORE, CAPICOM_MY_STORE, CAPICOM_STORE_OPEN_READ_WRITE )
      IF lREMOVER
         oStore:Remove( oCertificado )
      ELSE
         oStore:Add( oCertificado )
      ENDIF

   ENDSEQUENCE

   RETURN cID

FUNCTION CapicomInstalaCER( cFileName, cPassword, lREMOVER ) // administrator

   LOCAL oCertificado, oStore, cID

   hb_Default( @lREMOVER, .F. )

   BEGIN SEQUENCE WITH __BreakBlock()

      oCertificado := win_OleCreateObject( "CAPICOM.Certificate" )
      oCertificado:Load( cFileName, cPassword, CAPICOM_KEY_STORAGE_DEFAULT, 0 )
      cID := oCertificado:SubjectName

      IF "CN=" $ cID
         cID := Substr( cID, At( "CN=", cID ) + 3 )
         IF "," $ cID
            cID := Substr( cID, 1, At( ",", cID ) - 1 )
         ENDIF
      ENDIF

      oStore := win_OleCreateObject( "CAPICOM.Store" )
      oStore:open( CAPICOM_LOCAL_MACHINE_STORE, "Root", CAPICOM_STORE_OPEN_READ_WRITE )
      IF lREMOVER
         BEGIN SEQUENCE WITH __BreakBlock()
            oStore:Remove( oCertificado )
         ENDSEQUENCE
      ELSE
         oStore:Add( oCertificado )
      ENDIF
      oStore:Close() // Not sure

   ENDSEQUENCE

   RETURN cID

FUNCTION CapicomCertificadoRoot( cNomeCertificado, dValidFrom, dValidTo, lValidDate )

   LOCAL oStore, oColecao, oCertificado, nCont, lValid

   hb_Default( @lValidDate, .T. )
   oStore := Win_OleCreateObject( "CAPICOM.Store" )
   oStore:Open( CAPICOM_CURRENT_USER_STORE, "Root", CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
   oColecao := oStore:Certificates()
   //aList := oColecao:Find( CAPICOM_CERTIFICATE_FIND_ISSUER_NAME, cNomeCertificado, .T. )
   FOR nCont = 1 TO oColecao:Count()
      IF cNomeCertificado $ oColecao:Item( nCont ):SubjectName
         lValid := oColecao:Item( nCont ):ValidFromDate <= Date() .AND. oColecao:Item( nCont ):ValidToDate >= Date()
         IF ! ( lValid == lValidDate )
            LOOP
         ENDIF
         oCertificado := oColecao:Item( nCont )
         dValidFrom   := oCertificado:ValidFromDate
         dValidTo     := oCertificado:ValidToDate
         EXIT
      ENDIF
   NEXT
   oStore:Close()

   RETURN oCertificado
