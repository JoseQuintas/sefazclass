#include "sefazclass.ch"

FUNCTION SefazSoapList( nWsServico, cNFCe, cVersao )

   hb_default( @cNFCe, "N" )
   hb_Default( @cVersao, "DEFAULT" )

   DO CASE

   CASE nWsServico == WS_BPE_RECEPCAO

      RETURN { ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_RECEPCAO,          "https://bpe.fazenda.ms.gov.br/ws/BPeRecepcao" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_RECEPCAO,          "https://bpe.svrs.rs.gov.br/ws/bpeRecepcao/bpeRecepcao.asmx" }, ;
         ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_RECEPCAO,          "https://homologacao.bpe.ms.gov.br/ws/BPeRecepcao" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_RECEPCAO,          "https://bpe-homologacao.srvs.rs.gov.br/ws/bpeRecepcao/bpeRecepcao.asmx" } }

   CASE nWsServico == WS_BPE_RECEPCAOEVENTO

      RETURN { ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_RECEPCAOEVENTO,    "https://bpe.fazenda.ms.gov.br/ws/BPeRecepcaoEvento" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_RECEPCAOEVENTO,    "https://bpe.svrs.rs.gov.br/ms/bpeRecepcaoEvento/bpeRecepcaoEvento.asmx" }, ;
         ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_RECEPCAOEVENTO,    "https://homologacao.bpe.ms.gov.br/ws/BPeRecepcaoEvento" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_RECEPCAOEVENTO,    "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeRecepcaoEvento/bpeRecepcaoEvento.asmx" } }

   CASE nWsServico == WS_BPE_CONSULTAPROTOCOLO

      RETURN { ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_CONSULTAPROTOCOLO, "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_CONSULTAPROTOCOLO, "https://bpe.svrs.rs.gov.br/ms/bpeConsulta.asmx" }, ;
         ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_CONSULTAPROTOCOLO, "https://homologacao.bpe.ms.gov.br/ws/BPeConsulta" } }

   CASE nWsServico == WS_BPE_STATUSSERVICO

      RETURN { ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_STATUSSERVICO,     "https://bpe.fazenda.ms.gov.br/ws/BPeStatusServico" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_STATUSSERVICO,     "https://bpe.svrs.rs.gov.br/ms/bpeStatusServico/bpeStatusServico.asmx" }, ;
         ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_STATUSSERVICO,     "https://homologacao.bpe.ms.gov.br/ws/BPeStatusServico" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_STATUSSERVICO,     "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx" } }

   CASE nWsServico == WS_BPE_QRCODE

      RETURN { ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_QRCODE,            "http://dfe.ms.gov.br/bpe/qrcode" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_QRCODE,            "https://bpe.svrs.rs.gov.br/ws/bpeQrCode/qrCode.asmx" }, ;
         ;
         { "MS",   "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_QRCODE,            "http//www.dfe.ms.gov.br/bpe/qrcode" }, ;
         { "SVRS", "1.00", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_QRCODE,            "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeQrCode/qrCode.asmx" } }

   CASE nWsServico == WS_CTE_CONSULTACADASTRO

      RETURN { ;
         { "MS",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTACADASTRO,  "https://producao.cte.ms.gov.br/ws/CadConsultaCadastro" } }

   CASE nWsServico == WS_CTE_CONSULTAPROTOCOLO

      RETURN { ;
         { "MG",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "https://cte.fazenda.mg.gov.br/cte/services/CteConsulta" }, ;
         { "MS",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "https://producao.cte.ms.gov.br/ws/CteConsulta" }, ;
         { "MT",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "https://cte.sefaz.mt.gov.br/ctews/services/CteConsulta" }, ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
         { "PR",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "https://cte.fazenda.pr.gov.br/cte/CteConsulta?wsdl" }, ;
         { "SVSP", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteConsulta.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" }, ;
         ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_CONSULTAPROTOCOLO, "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_CONSULTAPROTOCOLO, "https://cte-homologacao.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" } }

   CASE nWsServico == WS_CTE_INUTILIZACAO

      RETURN { ;
         { "MG",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "https://cte.fazenda.mg.gov.br/cte/services/CteInutilizacao" }, ;
         { "MS",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "https://producao.cte.ms.gov.br/ws/CteInutilizacao" }, ;
         { "MT",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "https://cte.sefaz.mt.gov.br/ctews/services/CteInutilizacao" }, ;
         { "PR",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "https://cte.fazenda.pr.gov.br/cte/CteInutilizacao?wsdl" }, ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "https://cte.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" }, ;
         ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_INUTILIZACAO,      "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_INUTILIZACAO,      "https://cte-homologacao.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" } }

   CASE nWsServico == WS_CTE_RECEPCAO

      RETURN { ;
         { "MG",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "https://cte.fazenda.mg.gov.br/cte/services/CteRecepcao" }, ;
         { "MS",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "https://producao.cte.ms.gov.br/ws/CteRecepcao" }, ;
         { "MT",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "https://cte.sefaz.mt.gov.br/ctews/services/CteRecepcao" }, ;
         { "PR",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "https://cte.fazenda.pr.gov.br/cte/CteRecepcao?wsdl" }, ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
         { "SVSP", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "https://cte.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" }, ;
         ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RECEPCAO,          "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RECEPCAO,          "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" } }

   CASE nWsServico == WS_CTE_RECEPCAOEVENTO

      RETURN { ;
         { "MG",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "https://cte.fazenda.mg.gov.br/cte/services/RecepcaoEvento" }, ;
         { "MS",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "https://producao.cte.ms.gov.br/ws/CteRecepcaoEvento" }, ;
         { "MT",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "https://cte.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento?wsdl" }, ;
         { "PR",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "https://cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento?wsdl" }, ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "https://nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" }, ;
         ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RECEPCAOEVENTO,    "https://homologacao.nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RECEPCAOEVENTO,    "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" } }

   CASE nWsServico == WS_CTE_RETRECEPCAO

      RETURN { ;
         { "MG",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "https://cte.fazenda.mg.gov.br/cte/services/CteRetRecepcao" }, ;
         { "MS",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "https://producao.cte.ms.gov.br/ws/CteRetRecepcao" }, ;
         { "MT",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "https://cte.sefaz.mt.gov.br/ctews/services/CteRetRecepcao" }, ;
         { "PR",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "https://cte.fazenda.pr.gov.br/cte/CteRetRecepcao?wsdl" }, ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
         { "SVSP", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteRetRecepcao.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "https://cte.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" }, ;
         ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RETRECEPCAO,       "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RETRECEPCAO,       "https://cte-homologacao.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" } }

   CASE nWsServico == WS_CTE_STATUSSERVICO

      RETURN { ;
         { "MG",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "https://cte.fazenda.mg.gov.br/cte/services/CteStatusServico" }, ;
         { "MT",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "https://cte.sefaz.mt.gov.br/ctews/services/CteStatusServico" }, ;
         { "MS",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "https://producao.cte.ms.gov.br/ws/CteStatusServico" }, ;
         { "PR",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "https://cte.fazenda.pr.gov.br/cte/CteStatusServico?wsdl" }, ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
         { "SVSP", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteStatusServico.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" }, ;
         ;
         { "SP",   "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_STATUSSERVICO,     "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
         { "SVRS", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_STATUSSERVICO,     "https://cte-homologacao.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" } }

   CASE nWsServico == WS_MDFE_CONSNAOENC

      RETURN { ;
         { "**", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_MDFE_CONSNAOENC,      "https://mdfe.svrs.rs.gov.br/ws/mdfeConsNaoEnc/mdfeConsNaoenc.asmx" }, ;
         { "**", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_CONSNAOENC,      "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsNaoEnc/MDFeConsNaoEnc.asmx" } }

   CASE nWsServico == WS_MDFE_CONSULTA

      RETURN { ;
         { "**", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_MDFE_CONSULTA,        "https://mdfe.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" }, ;
         { "**", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_CONSULTA,        "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" } }

   CASE nWsServico == WS_MDFE_DISTRIBUICAODFE

      RETURN { ;
         { "**", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_MDFE_DISTRIBUICAODFE, "https://mdfe.svrs.rs.gov.br/WS/MDFeDistribuicaoDFe/MDFeDistribuicaoDFe.asmx" } }

   CASE nWsServico == WS_MFE_RECEPCAO

      RETURN { ;
         { "**", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_MDFE_RECEPCAO,        "https://mdfe.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" }, ;
         { "**", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_RECEPCAO,        "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" } }

   CASE nWsServico == WS_MDFE_RECEPCAOEVENTO

      RETURN { ;
         { "**", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_MDFE_RECEPCAOEVENTO,  "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" }, ;
         { "**", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_RECEPCAOEVENTO,  "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" } }

   CASE nWsServico == WS_MDFE_RETRECEPCAO

      RETURN { ;
         { "**", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_MDFE_RETRECEPCAO,     "https://mdfe.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" }, ;
         { "**", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_RETRECEPCAO,     "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" } }

   CASE nWsServico == WS_MDFE_STATUSSERVICO

      RETURN { ;
         { "**", "3.00", "3.00", WS_AMBIENTE_PRODUCAO,    WS_MDFE_STATUSSERVICO,   "https://mdfe.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" }, ;
         ;
         { "**", "3.00", "3.00", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_STATUSSERVICO,   "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" } }

   ENDCASE

   DO CASE
   CASE cVersao != "3.10" // este case é pra NFE 3.10
   CASE cNFCe != "N"      // NFE, não consumidor

   CASE nWsServico == WS_NFE_AUTORIZACAO

      RETURN { ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeAutorizacao?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeAutorizacao" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.fazenda.ms.gov.br/producao/services2/NfeAutorizacao" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeAutorizacao?wsdl" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://www.scan.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
         { "SCVAN", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://www.svc.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "https://www.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
         ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" } }

   CASE nWsServico == WS_NFE_CONSULTACADASTRO

      RETURN { ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl" }, ;
         { "ES",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl" }, ;
         { "MA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.fazenda.ms.gov.br/producao/services2/CadConsultaCadastro2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
         ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://homnfe.sefaz.am.gov.br/services2/services/CadConsultaCadastro2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl" }, ;
         { "ES",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://homolog.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl" }, ;
         { "MA",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://hnfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://homologacao.nfe.ms.gov.br/homologacao/services2/CadConsultaCadastro2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://homologacao.nfe.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://homologacao.nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" } }

   CASE nWsServico == WS_NFE_CONSULTADEST

      RETURN { ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTADEST,      "https://nfe.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx" }, ;
         { "AN",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTADEST,      "https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx" }, ;
         ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTADEST,      "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx" } }

   CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO

      RETURN { ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.fazenda.ms.gov.br/producao/services2/NfeConsulta2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://www.scan.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
         { "SCVAN", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "https://www.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
         ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeConsulta2.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeConsulta2" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://hom.nfe.fazenda.gov.br/SCAN/NfeConsulta2/NfeConsulta2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" } }

   CASE nWsServico == MS_NFE_DISTRIBUICAODFE

      RETURN { ;
         { "AN",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_DISTRIBUICAODFE,   "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx" } }

   CASE nWsServico == WS_NFE_DOWNLOADNF

      RETURN { ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_DOWNLOADNF,        "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_DOWNLOADNF,        "https://nfe.sefazrs.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_DOWNLOADNF,        "https://www.sefazvirtual.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx" }, ;
         { "AN",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_DOWNLOADNF,        "https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx" }, ;
         ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_DOWNLOADNF,        "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_DOWNLOADNF,        "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_DOWNLOADNF,        "https://hom.nfe.fazenda.gov.br/nfedownloadnf/nfedownloadnf.asmx" } }

   CASE nWsServico == WS_NFE_INUTILIZACAO

      RETURN { ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.sefaz.ba.gov.br/webservices/NfeInutilizacao/NfeInutilizacao.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.fazenda.ms.gov.br/producao/services2/NfeInutilizacao2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://www.scan.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
         ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeInutilizacao2.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeInutilizacao2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://hom.nfe.fazenda.gov.br/SCAN/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" } }

   CASE nWsServico == WS_NFE_RECEPCAO

      RETURN { ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe.sefaz.am.gov.br/services2/services/NfeRecepcao2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRecepcao2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://www.scan.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://www.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
         { "SCVAN", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "https://www.svc.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
         ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://homnfe.sefaz.am.gov.br/services2/services/NfeRecepcao2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRecepcao2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://hom.nfe.fazenda.gov.br/SCAN/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "https://hom.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" } }

   CASE nWsServico == WS_NFE_RECEPCAOEVENTO

      RETURN { ;
         { "AM",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento" }, ;
         { "BA",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx" }, ;
         { "CE",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl" }, ;
         { "GO",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/RecepcaoEvento?wsdl" }, ;
         { "MG",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento" }, ;
         { "MS",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.fazenda.ms.gov.br/producao/services2/RecepcaoEvento" }, ;
         { "MT",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl" }, ;
         { "PE",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento" }, ;
         { "PR",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe2.fazenda.pr.gov.br/nfe-evento/NFeRecepcaoEvento?wsdl" }, ;
         { "RS",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         { "SP",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx" }, ;
         { "SVRS",  "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         { "SCAN",  "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://www.scan.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
         { "SVAN",  "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
         { "SCVAN", "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://www.svc.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
         { "AN",    "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "https://www.nfe.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
         ;
         { "AM",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento" }, ;
         { "BA",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://hnfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx" }, ;
         { "CE",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://nfeh.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl" }, ;
         { "GO",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcaoEvento?wsdl" }, ;
         { "MG",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://hnfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento" }, ;
         { "MS",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://homologacao.nfe.ms.gov.br/homologacao/services2/RecepcaoEvento" }, ;
         { "MT",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl" }, ;
         { "PE",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento" }, ;
         { "PR",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRecepcaoEvento?wsdl" }, ;
         { "RS",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://nfe-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         { "SP",    "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://homologacao.nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx" }, ;
         { "SVRS",  "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         { "SVAN",  "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" } }

   CASE nWsServico == WS_NFE_RETAUTORIZAAO

      RETURN { ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetAutorizacao?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetAutorizacao" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetAutorizacao" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetAutorizacao?wsdl" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://www.scan.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://www.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
         { "SCVAN", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "https://www.svc.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
         ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" } }

   CASE nWsServico == WS_NFE_RETRECEPCAO

      RETURN { ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetRecepcao2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://www.scan.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://www.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
         { "SCVAN", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "https://www.svc.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
         ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRetRecepcao2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://hom.nfe.fazenda.gov.br/SCAN/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "https://hom.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" } }

   CASE nWsServico == WS_NFE_STATUSSERVICO

      RETURN { ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeStatus2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.fazenda.ms.gov.br/producao/services2/NfeStatusServico2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://nfe.svrs.rs.gov.br/ws/nfeStatusServico/NfeStatusServico2.asmx" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://www.scan.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://www.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
         { "SCVAN", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "https://www.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
         ;
         { "AM",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico2" }, ;
         { "BA",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://hnfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx" }, ;
         { "CE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl" }, ;
         { "GO",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl" }, ;
         { "MG",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeStatusServico2" }, ;
         { "MS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeStatusServico2" }, ;
         { "MT",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl" }, ;
         { "PE",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2" }, ;
         { "PR",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl" }, ;
         { "RS",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
         { "SP",    "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx" }, ;
         { "SVRS",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
         { "SCAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://hom.nfe.fazenda.gov.br/SCAN/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
         { "SVAN",  "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" } }

   ENDCASE

   DO CASE
   CASE cVersao != "3.10" // Este case é pra NFCE 3.10
   CASE cNFCE != "S"      // NFCE consumidor
   CASE nWsServico == WS_NFE_AUTORIZACAO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,        "https://nfce.fazenda.pr.gov.br/nfce/NFeAutorizacao3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,        "https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
         ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,        "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeAutorizacao3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" } }

   CASE nWsServico == WS_NFE_CONSULTAPROTOCOLO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO,  "https://nfce.fazenda.pr.gov.br/nfce/NFeConsulta3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO,  "https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
         ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO,  "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeConsulta3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO,  "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" } }

   CASE nWsServico == WS_NFE_INUTILIZACAO .AND. NFCe == "S"

      RETURN { ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,       "https://nfce.fazenda.pr.gov.br/nfce/NFeInutilizacao3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,       "https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
         ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,       "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeInutilizacao3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,       "https://nfce-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" } }

   CASE nWsServico == WS_NFE_RECEPCAOEVENTO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,     "https://nfce.fazenda.pr.gov.br/nfce/NFeRecepcaoEvento" }, ;
         { "SVRS", "3.10", "1.00", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,     "https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
         ;
         { "PR",   "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,     "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeRecepcaoEvento" }, ;
         { "SVRS", "3.10", "1.00", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,     "https://nfce-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" } }

   CASE nWsServico == WS_NFE_RETAUTORIZACAO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,     "https://nfce.fazenda.pr.gov.br/nfce/NFeRetAutorizacao3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,     "https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
         ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,     "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeRetAutorizacao3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,     "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" } }

   CASE nWsServico == WS_NFE_STATUSSERVICO .AND. cNFCe == "S"

      RETURN { ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,      "https://nfce.fazenda.pr.gov.br/nfce/NFeStatusServico3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,      "https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
         ;
         { "PR",   "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,      "https://homologacao.nfce.fazenda.pr.gov.br/nfce/NFeStatusServico3" }, ;
         { "SVRS", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,      "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" } }

   CASE nWsServico == WS_NFE_QRCODE

      RETURN { ;
         { "AC", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www.sefaznet.ac.gov.br/nfce/qrcode?" }, ;
         { "AL", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?" }, ;
         { "AP", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "https://www.sefaz.ap.gov.br/nfce/nfcep.php?" }, ;
         { "AM", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?" }, ;
         { "BA", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://nfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
         { "CE", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
         { "DF", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
         { "ES", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://app.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?" }, ;
         { "GO", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://nfe.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe" }, ;
         { "MA", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?" }, ;
         { "MT", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www.sefaz.mt.gov.br/nfce/consultanfce?" }, ;
         { "MS", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www.dfe.ms.gov.br/nfce/qrcode?" }, ;
         { "MG", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "" }, ;
         { "PA", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/nfceForm.seam?" }, ;
         { "PB", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www.receita.pb.gov.br/nfce?" }, ;
         { "PR", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?" }, ;
         { "PE", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe?" }, ;
         { "PI", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf?" }, ;
         { "RJ", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?" }, ;
         { "RN", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://nfce.set.rn.gov.br/consultarNFCe.aspx?" }, ;
         { "RS", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?" }, ;
         { "RO", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp?" }, ;
         { "RR", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "https://www.sefaz.rr.gov.br/nfce/servlet/qrcode?" }, ;
         { "SC", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "" }, ;
         { "SP", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx?" }, ;
         { "SE", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "http://www.nfce.se.gov.br/portal/consultarNFCe.jsp?" }, ;
         { "TO", "3.10", "3.10", WS_AMBIENTE_PRODUCAO,    WS_NFE_QRCODE, "" }, ;
         ;
         { "AC", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://www.hml.sefaznet.ac.gov.br/nfce/qrcode?" }, ;
         { "AL", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?" }, ;
         { "AP", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "https://www.sefaz.ap.gov.br/nfcehml/nfce.php?" }, ;
         { "AM", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://homnfce.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?" }, ;
         { "BA", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://hnfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
         { "CE", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
         { "DF", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
         { "ES", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?" }, ;
         { "GO", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "" }, ;
         { "MA", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?" }, ;
         { "MT", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce?" }, ;
         { "MS", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://www.dfe.ms.gov.br/nfce/qrcode?" }, ;
         { "MG", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "" }, ;
         { "PA", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/nfceForm.seam" }, ;
         { "PB", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://www.receita.pb.gov.br/nfcehom" }, ;
         { "PR", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?" }, ;
         { "PE", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe?" }, ;
         { "PI", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf?" }, ;
         { "RJ", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?" }, ;
         { "RN", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://hom.nfce.set.rn.gov.br/consultarNFCe.aspx?" }, ;
         { "RS", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?" }, ;
         { "RO", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp" }, ;
         { "RR", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://200.174.88.103:8080/nfce/servlet/qrcode?" }, ;
         { "SC", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "" }, ;
         { "SP", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx" }, ;
         { "SE", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "http://www.hom.nfe.se.gov.br/portal/consultarNFCe.jsp?" }, ;
         { "TO", "3.10", "3.10", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_QRCODE, "" } }

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
