*----------------------------------------------------------------
* ZE_CAPICOM - ROTINAS PRA USO DA CAPICOM
*----------------------------------------------------------------

*-----------------------------------------------------------------

#define _CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED           2
#define _CAPICOM_CURRENT_USER_STORE                   2

FUNCTION CapicomEscolheCertificado()

   LOCAL oCertificado, oCapicomStore, cNomeCertificado := "NENHUM", oColecao

   oCapicomStore        := win_oleCreateObject( "CAPICOM.Store" )
   oCapicomStore:Open( _CAPICOM_CURRENT_USER_STORE, 'My', _CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
   oColecao := oCapicomStore:Certificates()
   oCertificado := oColecao:Select( "Selecione o certificado para uso da Nfe","Selecione o certificado", .F. )
   IF oCertificado:Count() > 0
      cNomeCertificado := oCertificado:Item( 1 ):SubjectName
   ENDIF
   IF "CN=" $ cNomeCertificado
      cNomeCertificado := Substr( cNomeCertificado, At( "CN=", cNomeCertificado ) + 3 )
      IF "," $ cNomeCertificado
         cNomeCertificado := Substr( cNomeCertificado, 1, At( ",", cNomeCertificado ) - 1 )
      ENDIF
   ENDIF
   // oCapicomStore:Close()
   RETURN cNomeCertificado


FUNCTION CapicomCertificado( cNomeCertificado )

   LOCAL oCapicomStore, oColecao, oCertificado, nCont

   oCapicomStore := Win_OleCreateObject( "CAPICOM.Store" )
   oCapicomStore:Open( _CAPICOM_CURRENT_USER_STORE, "My", _CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
   oColecao := oCapicomStore:Certificates()
   FOR nCont = 1 TO oColecao:Count()
      IF cNomeCertificado $ oColecao:Item( nCont ):SubjectName
         oCertificado := oColecao:Item( nCont )
         EXIT
      ENDIF
   NEXT
   // oCapicomStore:Close()
   RETURN oCertificado
