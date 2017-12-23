#include "sefazclass.ch"

FUNCTION SefazSoapList( nWsServico, cNFCe, cVersao )

   hb_default( @cNFCe, "N" )
   hb_Default( @cVersao, "DEFAULT" )

   DO CASE

   CASE nWsServico == WS_BPE_RECEPCAO

      RETURN { ;
         { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.fazenda.ms.gov.br/ws/BPeRecepcao" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.svrs.rs.gov.br/ws/bpeRecepcao/bpeRecepcao.asmx" }, ;
         ;
         { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://homologacao.bpe.ms.gov.br/ws/BPeRecepcao" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://bpe-homologacao.srvs.rs.gov.br/ws/bpeRecepcao/bpeRecepcao.asmx" } }

   CASE nWsServico == WS_BPE_RECEPCAOEVENTO

      RETURN { ;
         { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.fazenda.ms.gov.br/ws/BPeRecepcaoEvento" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.svrs.rs.gov.br/ms/bpeRecepcaoEvento/bpeRecepcaoEvento.asmx" }, ;
         ;
         { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://homologacao.bpe.ms.gov.br/ws/BPeRecepcaoEvento" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeRecepcaoEvento/bpeRecepcaoEvento.asmx" } }

   CASE nWsServico == WS_BPE_CONSULTAPROTOCOLO

      RETURN { ;
         { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.svrs.rs.gov.br/ms/bpeConsulta.asmx" }, ;
         ;
         { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://homologacao.bpe.ms.gov.br/ws/BPeConsulta" } }

   CASE nWsServico == WS_BPE_STATUSSERVICO

      RETURN { ;
         { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.fazenda.ms.gov.br/ws/BPeStatusServico" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.svrs.rs.gov.br/ms/bpeStatusServico/bpeStatusServico.asmx" }, ;
         ;
         { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://homologacao.bpe.ms.gov.br/ws/BPeStatusServico" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx" } }

   CASE nWsServico == WS_BPE_QRCODE

      RETURN { ;
         { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     "http://dfe.ms.gov.br/bpe/qrcode" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     "https://bpe.svrs.rs.gov.br/ws/bpeQrCode/qrCode.asmx" }, ;
         ;
         { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  "http//www.dfe.ms.gov.br/bpe/qrcode" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeQrCode/qrCode.asmx" } }

   CASE nWsServico == WS_CTE_CONSULTACADASTRO

      RETURN { ;
         { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CadConsultaCadastro" } }

   CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO

      RETURN { ;
         { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteConsulta" }, ;
         { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteConsulta" }, ;
         { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteConsulta" }, ;
         { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
         { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteConsulta?wsdl" }, ;
         { "SVSP", "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteConsulta.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" }, ;
         ;
         { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" } }

   CASE nWsServico == WS_CTE_INUTILIZACAO

      RETURN { ;
         { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteInutilizacao" }, ;
         { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteInutilizacao" }, ;
         { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteInutilizacao" }, ;
         { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteInutilizacao?wsdl" }, ;
         { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" }, ;
         ;
         { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" } }

   CASE nWsServico == WS_CTE_RECEPCAO

      RETURN { ;
         { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteRecepcao" }, ;
         { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteRecepcao" }, ;
         { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteRecepcao" }, ;
         { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteRecepcao?wsdl" }, ;
         { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
         { "SVSP", "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" }, ;
         ;
         { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" } }

   CASE nWsServico == WS_CTE_RECEPCAOEVENTO

      RETURN { ;
         { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/RecepcaoEvento" }, ;
         { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteRecepcaoEvento" }, ;
         { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento?wsdl" }, ;
         { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento?wsdl" }, ;
         { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" }, ;
         ;
         { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" } }

   CASE nWsServico == WS_CTE_RETRECEPCAO

      RETURN { ;
         { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteRetRecepcao" }, ;
         { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteRetRecepcao" }, ;
         { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteRetRecepcao" }, ;
         { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteRetRecepcao?wsdl" }, ;
         { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
         { "SVSP", "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteRetRecepcao.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" }, ;
         ;
         { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" } }

   CASE nWsServico == WS_CTE_STATUSSERVICO

      RETURN { ;
         { "MG",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.mg.gov.br/cte/services/CteStatusServico" }, ;
         { "MT",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.sefaz.mt.gov.br/ctews/services/CteStatusServico" }, ;
         { "MS",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://producao.cte.ms.gov.br/ws/CteStatusServico" }, ;
         { "PR",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.fazenda.pr.gov.br/cte/CteStatusServico?wsdl" }, ;
         { "SP",   "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
         { "SVSP", "3.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteStatusServico.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_PRODUCAO,    "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" }, ;
         ;
         { "SP",   "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
         { "SVRS", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://cte-homologacao.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" } }

   CASE nWsServico == WS_MDFE_CONSNAOENC

      RETURN { ;
         { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/mdfeConsNaoEnc/mdfeConsNaoenc.asmx" }, ;
         { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsNaoEnc/MDFeConsNaoEnc.asmx" } }

   CASE nWsServico == WS_MDFE_CONSULTA

      RETURN { ;
         { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" }, ;
         { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" } }

   CASE nWsServico == WS_MDFE_DISTRIBUICAODFE

      RETURN { ;
         { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/WS/MDFeDistribuicaoDFe/MDFeDistribuicaoDFe.asmx" } }

   CASE nWsServico == WS_MDFE_RECEPCAO

      RETURN { ;
         { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" }, ;
         { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" } }

   CASE nWsServico == WS_MDFE_RECEPCAOEVENTO

      RETURN { ;
         { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" }, ;
         { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" } }

   CASE nWsServico == WS_MDFE_RETRECEPCAO

      RETURN { ;
         { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" }, ;
         { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" } }

   CASE nWsServico == WS_MDFE_STATUSSERVICO

      RETURN { ;
         { "**", "3.00", WS_AMBIENTE_PRODUCAO,    "https://mdfe.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" }, ;
         ;
         { "**", "3.00", WS_AMBIENTE_HOMOLOGACAO, "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" } }

   ENDCASE

   DO CASE
   CASE cVersao != "3.10" // este case é pra NFE 3.10
   CASE cNFCe != "N"      // NFE, não consumidor

   CASE nWsServico == WS_NFE_AUTORIZACAO

      RETURN { ;
         { "AM",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao" }, ;
         { "BA",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeAutorizacao?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeAutorizacao" }, ;
         { "MS",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.fazenda.ms.gov.br/producao/services2/NfeAutorizacao" }, ;
         { "MT",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeAutorizacao?wsdl" }, ;
         { "PR",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_PRODUCAO,     "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_PRODUCAO,     "https://www.scan.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
         { "SCVAN", "3.10", WS_AMBIENTE_PRODUCAO,     "https://www.svc.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_PRODUCAO,     "https://www.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
         ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO,  "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl" }, ;
         { "PR",    "3.10", WS_AMBIENTE_HOMOLOGACAO,  "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_HOMOLOGACAO,  "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_HOMOLOGACAO,  "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_HOMOLOGACAO,  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" } }

   CASE nWsServico == WS_NFE_CONSULTACADASTRO

      RETURN { ;
         { "BA",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl" }, ;
         { "ES",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx" }, ;
         { "GO",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl" }, ;
         { "MA",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/CadConsultaCadastro2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
         ;
         { "AM",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homnfe.sefaz.am.gov.br/services2/services/CadConsultaCadastro2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl" }, ;
         { "ES",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx" }, ;
         { "GO",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homolog.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl" }, ;
         { "MA",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.ms.gov.br/homologacao/services2/CadConsultaCadastro2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" } }

   CASE nWsServico == WS_NFE_CONSULTADEST

      RETURN { ;
         { "RS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx" }, ;
         { "AN",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx" }, ;
         ;
         { "RS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx" } }

   CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO

      RETURN { ;
         { "AM",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/NfeConsulta2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.scan.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
         { "SCVAN", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
         ;
         { "AM",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeConsulta2.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl" }, ;
         { "MS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeConsulta2" }, ;
         { "PE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.nfe.fazenda.gov.br/SCAN/NfeConsulta2/NfeConsulta2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" } }

   CASE nWsServico == WS_NFE_DISTRIBUICAODFE

      RETURN { ;
         { "AN",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx" } }

   CASE nWsServico == WS_NFE_DOWNLOADNF

      RETURN { ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefazrs.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefazvirtual.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx" }, ;
         { "AN",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx" }, ;
         ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.nfe.fazenda.gov.br/nfedownloadnf/nfedownloadnf.asmx" } }

   CASE nWsServico == WS_NFE_INUTILIZACAO

      RETURN { ;
         { "AM",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ba.gov.br/webservices/NfeInutilizacao/NfeInutilizacao.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/NfeInutilizacao2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.scan.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
         ;
         { "AM",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeInutilizacao2.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeInutilizacao2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.nfe.fazenda.gov.br/SCAN/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" } }

   CASE nWsServico == WS_NFE_RECEPCAO

      RETURN { ;
         { "AM",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.am.gov.br/services2/services/NfeRecepcao2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRecepcao2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.scan.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
         { "SCVAN", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.svc.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
         ;
         { "AM",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homnfe.sefaz.am.gov.br/services2/services/NfeRecepcao2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRecepcao2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.nfe.fazenda.gov.br/SCAN/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" } }

   CASE nWsServico == WS_NFE_RECEPCAOEVENTO

      RETURN { ;
         { "AM",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento" }, ;
         { "BA",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx" }, ;
         { "CE",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl" }, ;
         { "GO",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/RecepcaoEvento?wsdl" }, ;
         { "MG",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento" }, ;
         { "MS",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/RecepcaoEvento" }, ;
         { "MT",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl" }, ;
         { "PE",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento" }, ;
         { "PR",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe2.fazenda.pr.gov.br/nfe-evento/NFeRecepcaoEvento?wsdl" }, ;
         { "RS",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         { "SP",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx" }, ;
         { "SVRS",  "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         { "SCAN",  "1.00", WS_AMBIENTE_PRODUCAO,    "https://www.scan.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
         { "SVAN",  "1.00", WS_AMBIENTE_PRODUCAO,    "https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
         { "SCVAN", "1.00", WS_AMBIENTE_PRODUCAO,    "https://www.svc.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
         { "AN",    "1.00", WS_AMBIENTE_PRODUCAO,    "https://www.nfe.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
         ;
         { "AM",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento" }, ;
         { "BA",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx" }, ;
         { "CE",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl" }, ;
         { "GO",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcaoEvento?wsdl" }, ;
         { "MG",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento" }, ;
         { "MS",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.ms.gov.br/homologacao/services2/RecepcaoEvento" }, ;
         { "MT",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl" }, ;
         { "PE",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento" }, ;
         { "PR",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRecepcaoEvento?wsdl" }, ;
         { "RS",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         { "SP",    "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx" }, ;
         { "SVRS",  "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         { "SVAN",  "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" } }

   CASE nWsServico == WS_NFE_RETAUTORIZACAO

      RETURN { ;
         { "AM",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao" }, ;
         { "BA",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetAutorizacao?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetAutorizacao" }, ;
         { "MS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetAutorizacao" }, ;
         { "MT",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetAutorizacao?wsdl" }, ;
         { "PR",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.scan.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
         { "SCVAN", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.svc.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
         ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl" }, ;
         { "PR",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" } }

   CASE nWsServico == WS_NFE_RETRECEPCAO

      RETURN { ;
         { "AM",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetRecepcao2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.scan.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
         { "SCVAN", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.svc.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
         ;
         { "AM",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRetRecepcao2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl" }, ;
         { "PR",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.nfe.fazenda.gov.br/SCAN/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" } }

   CASE nWsServico == WS_NFE_STATUSSERVICO

      RETURN { ;
         { "AM",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeStatus2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/NfeStatusServico2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfe.svrs.rs.gov.br/ws/nfeStatusServico/NfeStatusServico2.asmx" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.scan.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
         { "SCVAN", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
         ;
         { "AM",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico2" }, ;
         { "BA",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx" }, ;
         { "CE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl" }, ;
         { "GO",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl" }, ;
         { "MG",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeStatusServico2" }, ;
         { "MS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeStatusServico2" }, ;
         { "MT",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl" }, ;
         { "PE",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2" }, ;
         { "PR",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl" }, ;
         { "RS",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
         { "SP",    "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx" }, ;
         { "SVRS",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
         { "SCAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.nfe.fazenda.gov.br/SCAN/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
         { "SVAN",  "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" } }

   ENDCASE

   DO CASE
   CASE cVersao != "3.10" // Este case é pra NFCE 3.10
   CASE cNFCE != "S"      // NFCE consumidor
   CASE nWsServico == WS_NFE_AUTORIZACAO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.fazenda.pr.gov.br/nfce/NFeAutorizacao3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
         ;
         { "PR",   "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeAutorizacao3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" } }

   CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.fazenda.pr.gov.br/nfce/NFeConsulta3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         ;
         { "PR",   "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeConsulta3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" } }

   CASE nWsServico == WS_NFE_INUTILIZACAO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.fazenda.pr.gov.br/nfce/NFeInutilizacao3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         ;
         { "PR",   "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeInutilizacao3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfce-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" } }

   CASE nWsServico == WS_NFE_RECEPCAOEVENTO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfce.fazenda.pr.gov.br/nfce/NFeRecepcaoEvento" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,    "https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         ;
         { "PR",   "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeRecepcaoEvento" }, ;
         { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO, "https://nfce-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" } }

   CASE nWsServico == WS_NFE_RETAUTORIZACAO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.fazenda.pr.gov.br/nfce/NFeRetAutorizacao3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
         ;
         { "PR",   "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeRetAutorizacao3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" } }

   CASE nWsServico == WS_NFE_STATUSSERVICO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.fazenda.pr.gov.br/nfce/NFeStatusServico3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_PRODUCAO,    "https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
         ;
         { "PR",   "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeStatusServico3" }, ;
         { "SVRS", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" } }

   CASE nWsServico == WS_NFE_QRCODE

      RETURN { ;
         { "AC", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www.sefaznet.ac.gov.br/nfce/qrcode?" }, ;
         { "AL", "3.10", WS_AMBIENTE_PRODUCAO,    "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?" }, ;
         { "AP", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefaz.ap.gov.br/nfce/nfcep.php?" }, ;
         { "AM", "3.10", WS_AMBIENTE_PRODUCAO,    "http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?" }, ;
         { "BA", "3.10", WS_AMBIENTE_PRODUCAO,    "http://nfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
         { "CE", "3.10", WS_AMBIENTE_PRODUCAO,    "http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
         { "DF", "3.10", WS_AMBIENTE_PRODUCAO,    "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
         { "ES", "3.10", WS_AMBIENTE_PRODUCAO,    "http://app.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?" }, ;
         { "GO", "3.10", WS_AMBIENTE_PRODUCAO,    "http://nfe.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe" }, ;
         { "MA", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?" }, ;
         { "MT", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www.sefaz.mt.gov.br/nfce/consultanfce?" }, ;
         { "MS", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www.dfe.ms.gov.br/nfce/qrcode?" }, ;
         { "MG", "3.10", WS_AMBIENTE_PRODUCAO,    "" }, ;
         { "PA", "3.10", WS_AMBIENTE_PRODUCAO,    "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/nfceForm.seam?" }, ;
         { "PB", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www.receita.pb.gov.br/nfce?" }, ;
         { "PR", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?" }, ;
         { "PE", "3.10", WS_AMBIENTE_PRODUCAO,    "http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe?" }, ;
         { "PI", "3.10", WS_AMBIENTE_PRODUCAO,    "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf?" }, ;
         { "RJ", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?" }, ;
         { "RN", "3.10", WS_AMBIENTE_PRODUCAO,    "http://nfce.set.rn.gov.br/consultarNFCe.aspx?" }, ;
         { "RS", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?" }, ;
         { "RO", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp?" }, ;
         { "RR", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.sefaz.rr.gov.br/nfce/servlet/qrcode?" }, ;
         { "SC", "3.10", WS_AMBIENTE_PRODUCAO,    "" }, ;
         { "SP", "3.10", WS_AMBIENTE_PRODUCAO,    "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx?" }, ;
         { "SE", "3.10", WS_AMBIENTE_PRODUCAO,    "http://www.nfce.se.gov.br/portal/consultarNFCe.jsp?" }, ;
         { "TO", "3.10", WS_AMBIENTE_PRODUCAO,    "" }, ;
         ;
         { "AC", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://www.hml.sefaznet.ac.gov.br/nfce/qrcode?" }, ;
         { "AL", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?" }, ;
         { "AP", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://www.sefaz.ap.gov.br/nfcehml/nfce.php?" }, ;
         { "AM", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://homnfce.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?" }, ;
         { "BA", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://hnfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
         { "CE", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
         { "DF", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
         { "ES", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?" }, ;
         { "GO", "3.10", WS_AMBIENTE_HOMOLOGACAO, "" }, ;
         { "MA", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?" }, ;
         { "MT", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce?" }, ;
         { "MS", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://www.dfe.ms.gov.br/nfce/qrcode?" }, ;
         { "MG", "3.10", WS_AMBIENTE_HOMOLOGACAO, "" }, ;
         { "PA", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/nfceForm.seam" }, ;
         { "PB", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://www.receita.pb.gov.br/nfcehom" }, ;
         { "PR", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?" }, ;
         { "PE", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe?" }, ;
         { "PI", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf?" }, ;
         { "RJ", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?" }, ;
         { "RN", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://hom.nfce.set.rn.gov.br/consultarNFCe.aspx?" }, ;
         { "RS", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?" }, ;
         { "RO", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp" }, ;
         { "RR", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://200.174.88.103:8080/nfce/servlet/qrcode?" }, ;
         { "SC", "3.10", WS_AMBIENTE_HOMOLOGACAO, "" }, ;
         { "SP", "3.10", WS_AMBIENTE_HOMOLOGACAO, "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx" }, ;
         { "SE", "3.10", WS_AMBIENTE_HOMOLOGACAO, "http://www.hom.nfe.se.gov.br/portal/consultarNFCe.jsp?" }, ;
         { "TO", "3.10", WS_AMBIENTE_HOMOLOGACAO, "" } }

   ENDCASE

   DO CASE
   CASE cVersao != "4.00" // Este case é pra NFE 4.00
   CASE cNFCe != "N"      // NFE, não consumidor
   ENDCASE

   DO CASE
   CASE cVersao != "4.00" // Este case é pra NFCE 4.00
   CASE cNFCe != "S"      // NFCE, consumidor
   ENDCASE

   RETURN {}
