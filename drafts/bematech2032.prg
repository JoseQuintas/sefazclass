#include "hbdyn.ch"
#include "hbclass.ch"

PROCEDURE Main

   LOCAL oPrinter := MP2032():New()

   ? oPrinter:Le_Status()
   ? oPrinter:IniciaPorta()
   ? oPrinter:ComandoTx( "sei la" )
   ? oPrinter:nHandle
   oPrinter:Destroy()

   RETURN

CREATE CLASS MP2032

   VAR    nHandle

   METHOD Init()                                          INLINE ::nHandle := hb_LibLoad( "mp2032.dll" )
   METHOD Destroy()                                       INLINE hb_LibFree( ::nHandle )
   METHOD CallDllStd( cName, ... )                        INLINE hb_DynCall( { cName, ::nHandle, HB_DYN_CALLCONV_STDCALL }, ... )
   METHOD IniciaPorta( cPorta )                           INLINE ::CallDllStd( "IniciaPorta", cPorta )
   METHOD BematechTx( cComando )                          INLINE ::CallDllStd( "BematechTX", cComando )
   METHOD ComandoTx( cBufTrans, nFlag )                   INLINE ::CallDllStd( "ComandoTX", cBufTrans, nFlag )
   METHOD CaracterGrafico( cBufTrans, nTamBufTrans )      INLINE ::CallDllStd( "CaracterGrafico", cBufTrans, nTamBufTrans )
   METHOD Le_Status()                                     INLINE ::CallDllStd( "Le_Status" )
   METHOD AutenticaDoc( cTexto, nTempo )                  INLINE ::CallDllStd( "AutenticaDoc", cTexto, nTempo )
   METHOD DocumentInserted()                              INLINE ::CallDllStd( "DocumentInserted" )
   METHOD FechaPorta()                                    INLINE ::CallDllStd( "FechaPorta" )
   METHOD Le_Status_Gaveta()                              INLINE ::CallDllStd( "Le_Status_Gaveta" )
   METHOD ConfiguraTamanhoExtrato( nNumeroLinhas )        INLINE ::CallDllStd( "ConfiguraTamanhoExtrato", nNumeroLinhas )
   METHOD HabilitaExtratoLongo( nFlag )                   INLINE ::CallDllStd( "HabilitaExtratoLongo", nFlag )
   METHOD HabilitaEsperaImpressao( nFlag )                INLINE ::CallDllStd( "HabilitaEsperaImpressao", nFlag )
   METHOD EsperaImpressao()                               INLINE ::CallDllStd( "EsperaImpressao" )
   METHOD ConfiguraModeloImpressora( nModeloImpressora )  INLINE ::CallDllStd( "ConfiguraModeloImpressora" )
   METHOD AcionaGuilhotina( nModo )                       INLINE ::CallDllStd( "AcionaGuilhotina", nModo )
   METHOD FormataTx( cBufTrans, nTpoLtra, nItalic, nSublin, nExpand, nEnfat )
                                                          INLINE ::CallDllStd( "FormataTX", cBufTrans, nTpoLtra, nItalic, nSublin, nExpand, nEnfat )
   METHOD HabilitaPresenterRetratil( nFlag )              INLINE ::CallDllStd( "HabilitaPresenterRetratil", nFlag )
   METHOD ProgramaPresenterRetratil( nTempo )             INLINE ::CallDllStd( "ProgramaPresenterRetratil", nFlag )
   METHOD VerificaPapelPresenter()                        INLINE ::CallDllStd( "VerificaPapelPresenter" )
   METHOD ConfiguraCodigoBarras( nAltura, nLargura, nPosicaoCaracteres, nFonte, nMargem ) ;
                                                          INLINE ::CallDllStd( "ConfiguraCodigoBarras", nAltura, nLargura, nPosicaoCaracteres, nFonte, nMargem )
   METHOD ImprimeCodigoBarrasUPCA( cCodigo )              INLINE ::CallDllStd( "ImprimeCodigoBarrasUPCA", cCodigo )
   METHOD ImprimeCodigoBarrasUPCE( cCodigo )              INLINE ::CallDllStd( "ImprimeCodigoBarrasUPCE", cCodigo )
   METHOD ImprimeCodigoBarrasEAN13( cCodigo )             INLINE ::CallDllStd( "ImprimeCodigoBarrasEAN13", cCodigo )
   METHOD ImprimeCodigoBarrasEAN8( cCodigo )              INLINE ::CallDllStd( "ImprimeCodigoBarrasEAN8", cCodigo )
   METHOD ImprimeCodigoBarrasCODE39( cCodigo )            INLINE ::CallDllStd( "ImprimeCodigoBarrasCODE39", cCodigo )
   METHOD ImprimeCodigoBarrasCODE93( cCodigo )            INLINE ::CallDllStd( "ImprimeCodigoBarrasCODE93", cCodigo )
   METHOD ImprimeCodigoBarrasCODE128( cCodigo )           INLINE ::CallDllStd( "ImprimeCodigoBarrasCODE128", cCodigo )
   METHOD ImprimeCodigoBarrasITF( cCodigo )               INLINE ::CallDllStd( "ImprimeCodigoBarrasITF", cCodigo )
   METHOD ImprimeCodigoBarrasCODABAR( cCodigo )           INLINE ::CallDllStd( "ImprimeCodigoBarrasCODABAR", cCodigo )
   METHOD ImprimeCodigoBarrasISBN( cCodigo )              INLINE ::CallDllStd( "ImprimeCodigoBarrasISBN", cCodigo )
   METHOD ImprimeCodigoBarrasMSI( cCodigo )               INLINE ::CallDllStd( "ImprimeCodigoBarrasMSI", cCodigo )
   METHOD ImprimeCodigoBarrasPLESSEY( cCodigo )           INLINE ::CallDllStd( "ImprimeCodigoBarrasPLESSEY", cCodigo )
   METHOD ImprimeCodigoBarrasPDF417( nNivelCorrecaoErros, nAltura, nLargura, nColunas, cCodigo ) ;
                                                          INLINE ::CallDllStd( "ImprimeCodigoBarrasPDF417", nNivelCorrecaoErros, nAltura, nLargura, nColunas, cCodigo )
   METHOD ImprimeCodigoQRCODE( nErrorCorrectionLevel, nModuleSize, nCodeType, nQRCodeVersion, nEncodingModes, cCodeQr ) ;
                                                          INLINE ::CallDllStd( "ImprimeCodigoQRCODE", nErrorCorrectionLevel, nModuleSize, nCodeType, nQRCodeVersion, nEncodingModes, cCodeQr )
   METHOD ImprimeBitmap( cName, nMode )                   INLINE ::CallDllStd( "ImprimeBitMap", cName, nMode )
   METHOD ImprimeBmpEspecial( cName As String, nxScale, nyScale, nAngle ) ;
                                                          INLINE ::CallDllStd( "ImprimeBmpEspecial", cName As String, nxScale, nyScale, nAngle )
   METHOD AjustaLarguraPapel( nWidth )                    INLINE ::CallDllStd( "AjustaLarguraPapel", nWidth )
   METHOD SelectDithering( nType )                        INLINE ::CallDllStd( "SelectDithering", nType )
   METHOD PrinterReset()                                  INLINE ::CallDllStd( "PrinterReset" )
   METHOD LeituraStatusEstendido( cByte )                 INLINE ::CallDllStd( "LeituraStatusEstendido", cByte ) // byte
   METHOD IoControl( nFlag, nMode )                       INLINE ::CallDllStd( "IoControl", nFlag, nMode )
   METHOD DefineNVBitmap( nCount, aFileNames )            INLINE ::CallDllStd( "DefineNVBitmap", nCount, aFileNames )
   METHOD PrintNVBitmap( nImage, nMode )                  INLINE ::CallDllStd( "PrintVBitmap", nImage, nMode )
   METHOD Define1NVBitMap( cFileName )                    INLINE ::CallDllStd( "Define1NVBitmap", cFileName )
   METHOD DefineDLBitmap( cFileName )                     INLINE ::CallDllStd( "DefineDLBitmap", FileName )
   METHOD PrintDLBitmap( nMode )                          INLINE ::CallDllStd( "PrintDLBitmap", nMode )
   METHOD AtualizaFirmware( cFileName )                   INLINE ::CallDllStd( "AtualizaFirmware", cFileName )

   ENDCLASS
