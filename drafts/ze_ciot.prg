// ANTT CIOT

#include "hbclass.ch"

CREATE CLASS ciotclass

   VAR cBaseUrl
   VAR cCertSubject

   METHOD New( lProducao, cCertSubject )
   METHOD HttpPost( cEndpoint, hData )
   METHOD ConsultarSituacaoTransportador( hData )
   METHOD ConsultarFrotaTransportador( hData )
   METHOD DeclaracaoOperacaoTransporte( hData )
   METHOD CancelamentoOperacaoTransporte( hData )
   METHOD RetificacaoOperacaoTransporte( hData )
   METHOD EncerramentoOperacaoTransporte( hData )
   METHOD ConsultarExcecao( hData )
   METHOD ConsultarCIOTGerado( hData )

   ENDCLASS

METHOD ciotclass:New( lProducao, cCertSubject )

   IF lProducao != Nil
      IF lProducao
         ::cBaseUrl := "https://appservices-hml.antt.gov.br/pefServices"
      ELSE
         ::cBaseUrl := "https://appservices.antt.gov.br/pefServices"
      ENDIF
   ENDIF
   IF cCertSubject != Nil
      ::cCertSubject := cCertSubject
   ENDIF

   RETURN Self

METHOD ciotclass:HttpPost( cEndpoint, hData )

   LOCAL cUrl := ::cBaseUrl + cEndpoint
   LOCAL cJson := hb_jsonEncode( hData )
   LOCAL cResponse, oInternet

   oInternet := win_OleCreateObject( "MSXML2.ServerXMLHTTP" )
   oInternet:Open( "POST", cUrl, .F. )
   oInternet:SetOption( 3, ::cCertSubject )
   oInternet:SetRequestHeader( "content-Type", "application/json" )
   oInternet:Send( cJson )
   cResponse := oInternet:ResponseText

   RETURN hb_jsonDecode( cResponse )

METHOD ciotclass:ConsultarSituacaoTransportador( hData )
   /*
   LOCAL hReq := { ;
      "CpfCnpjInteressado" => "12345678901", ; // string, 11 ou 14 dígitos
      "CpfCnpjTransportador" => "98765432100", ; // string, 11 ou 14 dígitos
      "RNTRCTransportador" => "000123456" }     // string, até 8 dígitos
   */

   RETURN ::HttpPost( "/ConsultarSituacaoTransportador", hData )

METHOD ciotclass:ConsultarFrotaTransportador( hData )
   /*
   LOCAL hReq := { ;
      "CpfCnpjInteressado" => "12345678901", ;
      "CpfCnpjTransportador" => "98765432100", ;
      "RNTRCTransportador" => "000123456" }
   */
   RETURN ::HttpPost( "/ConsultarFrotaTransportador", hData )

METHOD ciotclass:DeclaracaoOperacaoTransporte( hData )
   /*
   LOCAL hReq := { ;
      "CpfCnpjContratante" => "12345678000199", ; // CNPJ, 14 dígitos
      "CpfCnpjTransportador" => "98765432100", ;  // CPF, 11 dígitos
      "RNTRCTransportador" => "000123456", ;      // RNTRC, até 8 dígitos
      "NumeroContrato" => "CONTR12345", ;         // string, até 20 caracteres
      "DataInicio" => "2026-08-17", ;             // formato YYYY-MM-DD
      "DataFim" => "2026-08-20", ;                // formato YYYY-MM-DD
      "ValorFrete" => 15000.75, ;                 // numérico, até 2 decimais
      "PlacaVeiculo" => "ABC1234" }               // string, 7 caracteres
   */

   RETURN ::HttpPost( "/DeclaracaoOperacaoTransporte", hData )

METHOD ciotclass:CancelamentoOperacaoTransporte( hData )
   /*
   LOCAL hReq := { ;
      "NumeroCIOT" => "12345678901234567890", ; // string, 20 caracteres
      "MotivoCancelamento" => "Erro de cadastro" } // string, até 255 caracteres
   */

   RETURN ::HttpPost( "/CancelamentoOperacaoTransporte", hData )

METHOD ciotclass:RetificacaoOperacaoTransporte( hData )
   /*
   LOCAL hReq := { ;
      "NumeroCIOT" => "12345678901234567890", ;
      "NovoValorFrete" => 18000.00 } // numérico, até 2 decimais
   */
   RETURN ::HttpPost( "/RetificacaoOperacaoTransporte", hData )

METHOD ciotclass:EncerramentoOperacaoTransporte( hData )
   /*
   LOCAL hReq := { ;
      "NumeroCIOT" => "12345678901234567890", ;
      "DataEncerramento" => "2026-08-20" } // formato YYYY-MM-DD
   */
   RETURN ::HttpPost( "/EncerramentoOperacaoTransporte", hData )

METHOD ciotclass:ConsultarExcecao( hData )
   /*
   LOCAL hReq := { ;
      "NumeroCIOT" => "12345678901234567890" }
   */
   RETURN ::HttpPost( "/ConsultarExcecao", hData )

METHOD ciotclass:ConsultarCIOTGerado( hData )
   /*
   LOCAL hReq := { ;
      "CpfCnpjContratante" => "12345678000199", ;
      "NumeroContrato" => "CONTR12345" }
   */
   RETURN ::HttpPost( "/ConsultarCIOTGerado", hData )
