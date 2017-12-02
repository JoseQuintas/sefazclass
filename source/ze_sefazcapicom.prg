/*
ZE_CAPICOM - ROTINAS PRA USO DA CAPICOM
José Quintas
*/

#include "sefaz_capicom.ch"

FUNCTION CapicomEscolheCertificado( dValidFrom, dValidTo )

   LOCAL oCertificado, oCapicomStore, cNomeCertificado := "NENHUM", oColecao

   oCapicomStore        := win_oleCreateObject( "CAPICOM.Store" )
   oCapicomStore:Open( CAPICOM_CURRENT_USER_STORE, 'My', CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
   oColecao         := oCapicomStore:Certificates()
   DO CASE
   CASE oColecao:Count() == 1
      dValidFrom       := oColecao:item(1):ValidFromDate
      dValidTo         := oColecao:item(1):ValidToDate
      cNomeCertificado := oColecao:item(1):SubjectName
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
   // oCapicomStore:Close()

   RETURN cNomeCertificado

FUNCTION CapicomCertificado( cNomeCertificado )

   LOCAL oCapicomStore, oColecao, oCertificado, nCont

   oCapicomStore := Win_OleCreateObject( "CAPICOM.Store" )
   oCapicomStore:Open( CAPICOM_CURRENT_USER_STORE, "My", CAPICOM_STORE_OPEN_MAXIMUM_ALLOWED )
   oColecao := oCapicomStore:Certificates()
   FOR nCont = 1 TO oColecao:Count()
      IF cNomeCertificado $ oColecao:Item( nCont ):SubjectName
         oCertificado := oColecao:Item( nCont )
         EXIT
      ENDIF
   NEXT
   // oCapicomStore:Close()

   RETURN oCertificado
