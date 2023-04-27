/*
SatDllClass - Pra facilitar o uso da sat.dll
2016.11.30.2000 - José Quintas

Nota: Apenas chamadas intermediárias
*/

CREATE CLASS SatDllClass

   VAR nHandle

   METHOD New()                                INLINE ::nHandle := hb_LibLoad( "sat.dll" ), SELF
   METHOD Destroy()                            INLINE hb_LibFree( ::nHandle )
   METHOD ConsultarStatusOperacional( ... )    INLINE ::CallDllStd( "ConsultarStatusOperacional", ... )
   METHOD AtivarSAT( ... )                     INLINE ::CallDllStd( "AtivarAT", ... )
   METHOD ComunicarCertificadoICPBRASIL( ... ) INLINE ::CallDllStd( "ComunicarCertificadoICPBRASIL", ... )
   METHOD EnviarDadosVenda( ... )              INLINE ::CallDllStd( "EnviarDadosVenda", ... )
   METHOD CancelarUltimaVenda( ... )           INLINE ::CallDllStd( "CancelarUltimaVenda", ... )
   METHOD ConsultarSAT( ... )                  INLINE ::CallDllStd( "ConsultarSAT", ... )
   METHOD TesteFimAFim( ... )                  INLINE ::CallDllStd( "TesteFimAFim", ... )
   METHOD ConsultarNumeroSessao( ... )         INLINE ::CallDllStd( "ConsultarNumeroSessao( ... )
   METHOD ConfigurarInferfaceDeRede( ... )     INLINE ::CallDllStd( "ConfigurarInferfaceDeRede", ... )
   METHOD AssociarAssinatura( ... )            INLINE ::CallDllStd( "AssociarAssinatura", ... )
   METHOD AtualizarSoftwareSAT( ... )          INLINE ::CallDllStd( "AtualizarSoftwareSAT", ... )
   METHOD ExtrairLogs( ... )                   INLINE ::CallDllStd( "ExtrairLogs", ... )
   METHOD BloquearSAT( ... )                   INLINE ::CallDllStd( "BloquearSAT", ... )
   METHOD DesbloquearSAT( ... )                INLINE ::CallDllStd( "DesbloquearSAT", ... )
   METHOD TrocarCodigoDeAtivacao( ... )        INLINE ::CallDllStd( "TrocarCodigoDeAtivacao", ... )
   METHOD CallDllStd( cName, ... )             INLINE hb_DynCall( { cName, ::nHandle, HB_DYN_CALLCONV_STDCALL }, ... )

   ENDCLASS
