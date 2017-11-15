#define WS_BPE_CONSULTA               1
#define WS_BPE_RECEPCAO               2
#define WS_BPE_RECEPCAOEVENTO         3
#define WS_BPE_STATUSSERVICO          4
#define WS_BPE_QRCODE                 5

#define WS_CTE_CONSULTACADASTRO       6
#define WS_CTE_CONSULTAPROTOCOLO      7
#define WS_CTE_INUTILIZACAO           8
#define WS_CTE_RECEPCAO               9
#define WS_CTE_RECEPCAOEVENTO        10
#define WS_CTE_RETRECEPCAO           11
#define WS_CTE_STATUSSERVICO         12

#define WS_MDFE_CONSULTA             13
#define WS_MDFE_CONSNAOENC           14
#define WS_MDFE_RECEPCAO             15
#define WS_MDFE_RECEPCAOEVENTO       16
#define WS_MDFE_RETRECEPCAO          17
#define WS_MDFE_STATUSSERVICO        18

#define WS_NFE_AUTORIZACAO           19
#define WS_NFE_CONSULTACADASTRO      20
#define WS_NFE_CONSULTAPROTOCOLO     21
#define WS_NFE_INUTILIZACAO          22
#define WS_NFE_RECEPCAO              23
#define WS_NFE_RECEPCAOEVENTO        24
#define WS_NFE_RETAUTORIZACAO        25
#define WS_NFE_RETRECEPCAO           26
#define WS_NFE_STATUSSERVICO         27

#define WS_NFE_DISTRIBUICAODFE       28
#define WS_MDFE_DISTRIBUICAODFE      29
#define WS_NFE_DOWNLOADNF            30
#define WS_NFE_CONSULTADEST          31

#define WS_AMBIENTE_HOMOLOGACAO      "2"
#define WS_AMBIENTE_PRODUCAO         "1"

#define WS_PROJETO_BPE               "bpe"
#define WS_PROJETO_CTE               "cte"
#define WS_PROJETO_MDFE              "mdfe"
#define WS_PROJETO_NFE               "nfe"

#define WS_VERSAO_BPE                "1.00"
#define WS_VERSAO_CTE                "2.00"
#define WS_VERSAO_MDFE               "3.00"
#define WS_VERSAO_NFE                "3.10"
#define WS_VERSAO_NFEEVENTO          "1.00"

#define WS_XMLNS_BPE                 [xmlns="http://www.portalfiscal.inf.br/bpe"]
#define WS_XMLNS_CTE                 [xmlns="http://www.portalfiscal.inf.br/cte"]
#define WS_XMLNS_NFE                 [xmlns="http://www.portalfiscal.inf.br/nfe"]
#define WS_XMLNS_MDFE                [xmlns="http://www.portalfiscal.inf.br/mdfe"]

#define WS_RETORNA_PROTOCOLO    "1"
#define WS_RETORNA_RECIBO       "0"

#define XML_UTF8                   [<?xml version="1.0" encoding="UTF-8"?>]

#define SEFAZ_SOAPACTION_LIST { ;
      ;
      { "**", WS_CTE_CONSULTAPROTOCOLO, WS_PROJETO_CTE,  "cteConsultaCT",        "http://www.portalfiscal.inf.br/cte/wsdl/CteConsulta" }, ;
      { "**", WS_CTE_RETRECEPCAO,       WS_PROJETO_CTE,  "cteRetRecepcao",       "http://www.portalfiscal.inf.br/cte/wsdl/CteRetRecepcao" }, ;
      { "**", WS_CTE_RECEPCAOEVENTO,    WS_PROJETO_CTE,  "cteRecepcaoEvento",    "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcaoEvento" }, ;
      { "**", WS_CTE_INUTILIZACAO,      WS_PROJETO_CTE,  "cteInutilizacaoCT",    "http://www.portalfiscal.inf.br/cte/wsdl/CteInutilizacao" }, ;
      { "**", WS_CTE_RECEPCAO,          WS_PROJETO_CTE,  "cteRecepcaoLote",      "http://www.portalfiscal.inf.br/cte/wsdl/CteRecepcao" }, ;
      { "**", WS_CTE_STATUSSERVICO,     WS_PROJETO_CTE,  "cteStatusServicoCT",   "http://www.portalfiscal.inf.br/cte/wsdl/CteStatusServico" }, ;
      { "**", WS_MDFE_CONSNAOENC,       WS_PROJETO_MDFE, "mdfeConsNaoEnc",       "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsNaoEnc" }, ;
      { "**", WS_MDFE_CONSULTA,         WS_PROJETO_MDFE, "mdfeConsultaMDF",      "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeConsulta" }, ;
      { "**", WS_MDFE_RETRECEPCAO,      WS_PROJETO_MDFE, "mdfeRetRecepcao",      "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRetRecepcao" }, ;
      { "**", WS_MDFE_DISTRIBUICAODFE,  "??????",        "mdfeDistDFeInteresse", "http://www.portalfiscal.inf.br/nfe/wsdl/MDFeDistribuicaoDFe" }, ;
      { "**", WS_MDFE_RECEPCAOEVENTO,   WS_PROJETO_MDFE, "mdfeRecepcaoEvento",   "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcaoEvento" }, ;
      { "**", WS_MDFE_RECEPCAO,         WS_PROJETO_MDFE, "MDFeRecepcao",         "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeRecepcao" }, ;
      { "**", WS_MDFE_STATUSSERVICO,    WS_PROJETO_MDFE, "MDFeStatusServico",    "http://www.portalfiscal.inf.br/mdfe/wsdl/MDFeStatusServico/mdfeStatusServicoMDF" }, ;
      { "**", WS_NFE_CONSULTACADASTRO,  WS_PROJETO_NFE,  "CadConsultaCadastro2", "http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro2" }, ;
      { "**", WS_NFE_CONSULTADEST,      WS_PROJETO_NFE,  "nfeConsultaNFDest",    "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaDest/nfeConsultaNFDest" }, ;
      { "**", WS_NFE_DISTRIBUICAODFE,   "???",           "nfeDistDFeInteresse",  "http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe" }, ;
      { "**", WS_NFE_RECEPCAOEVENTO,    WS_PROJETO_NFE,  "nfeRecepcaoEvento",    "http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento" }, ;
      { "**", WS_NFE_INUTILIZACAO,      WS_PROJETO_NFE,  "NfeInutilizacaoNF2",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao2" }, ;
      { "**", WS_NFE_AUTORIZACAO,       WS_PROJETO_NFE,  "NfeAutorizacao",       "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao" }, ;
      { "**", WS_BPE_RECEPCAO,          WS_PROJETO_BPE,  "BpeRecepcao",          "http://www.portalfiscal.inf.br/bpe/wsdl/BPeRecepcao/bpeRecepcao" }, ;
      { "**", WS_BPE_RECEPCAOEVENTO,    WS_PROJETO_BPE,  "BpeRecepcaoEvento",    "http://www.portalfiscal.inf.br/bpe/wsdl/bpeRecepcaoEvento" }, ;
      { "**", WS_BPE_CONSULTA,          WS_PROJETO_BPE,  "BpeConsulta",          "http://www.portalfiscal.inf.br/bpe/wsdl/BPeConsulta/bpeConsultaBP" }, ;
      { "**", WS_BPE_STATUSSERVICO,     WS_PROJETO_BPE,  "BpeStatusServicoBP",   "http://www.portalfiscal.inf.br/bpe/wsdl/BPeStatusServico" }, ;
      { "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO", ;
	           WS_NFE_AUTORIZACAO,       WS_PROJETO_NFE,  "nfeAutorizacaoLote",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeAutorizacao" }, ;
      { "**", WS_NFE_RETAUTORIZACAO,    WS_PROJETO_NFE,  "NfeRetAutorizacao",    "http://www.portalfiscal.inf.br/nfe/wsdl/NfeRetAutorizacao" }, ;
      { "**", WS_NFE_STATUSSERVICO,     WS_PROJETO_NFE,  "nfeStatusServicoNF2",  "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico2" }, ;
      { "BA", WS_NFE_STATUSSERVICO,     WS_PROJETO_NFE,  "nfeStatusServicoNF",   "http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico" }, ;
      { "**", WS_NFE_CONSULTAPROTOCOLO, WS_PROJETO_NFE,  "NfeConsulta2",         "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2" }, ;
      { "BA", WS_NFE_CONSULTAPROTOCOLO, WS_PROJETO_NFE,  "nfeConsultaNF",        "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta" }, ;
      { "AC,AL,AP,DF,ES,PB,RJ,RN,RO,RR,SC,SE,TO", ;
              WS_NFE_CONSULTAPROTOCOLO, WS_PROJETO_NFE,  "nfeConsultaNF2",       "http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsulta2" } }

#define SEFAZ_NFE_URL_LIST { ;
   ;
   { "AM",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao" }, ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.sefaz.ba.gov.br/webservices/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl" }, ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeAutorizacao?wsdl" }, ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeAutorizacao" }, ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.fazenda.ms.gov.br/producao/services2/NfeAutorizacao" }, ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao?wsdl" }, ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeAutorizacao?wsdl" }, ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl" }, ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
   { "SP",    WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://www.scan.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
   { "SCVAN", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://www.svc.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,       "3.10", "https://www.sefazvirtual.fazenda.gov.br/NfeAutorizacao/NfeAutorizacao.asmx" }, ;
   ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeAutorizacao?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "3.10", "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeAutorizacao3?wsdl" }, ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "3.10", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
   { "SP",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "3.10", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO,       "3.10", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta2" }, ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.sefaz.ba.gov.br/webservices/NfeConsulta/NfeConsulta.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta2" }, ;
   { "BA",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeConsulta2.asmx" }, ;
   ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://homnfe.sefaz.am.gov.br/services2/services/CadConsultaCadastro2" }, ;
   { "BA",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/CadConsultaCadastro2.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2" }, ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.sefaz.ba.gov.br/webservices/NfeInutilizacao/NfeInutilizacao.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao2" }, ;
   { "BA",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeInutilizacao2.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe.sefaz.am.gov.br/services2/services/NfeRecepcao2" }, ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://homnfe.sefaz.am.gov.br/services2/services/NfeRecepcao2" }, ;
   { "BA",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRecepcao2.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento" }, ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento" }, ;
   ;
   { "AM",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao" }, ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.sefaz.ba.gov.br/webservices/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2" }, ;
   ;
   { "AM",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetRecepcao2" }, ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx" }, ;
   ;
   { "AM",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico2" }, ;
   ;
   { "AM",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico2" },;
   ;
   { "BA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx" }, ;
   ;
   { "BA",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://hnfe.sefaz.ba.gov.br/webservices/sre/RecepcaoEvento.asmx" }, ;
   { "BA",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://hnfe.sefaz.ba.gov.br/webservices/nfenw/NfeRetRecepcao2.asmx" }, ;
   { "BA",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://hnfe.sefaz.ba.gov.br/webservices/NfeStatusServico/NfeStatusServico.asmx" }, ;
   ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_DOWNLOADNF,        "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl" }, ;
   ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeConsulta2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_DOWNLOADNF,        "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl" }, ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeInutilizacao2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfeh.sefaz.ce.gov.br/nfe2/services/RecepcaoEvento?wsdl" }, ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeStatusServico2?wsdl" }, ;
   { "CE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetAutorizacao?wsdl" }, ;
   ;
   { "ES",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx" }, ;
   { "ES",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx" }, ;
   ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.sefaz.go.gov.br/nfe/services/v2/RecepcaoEvento?wsdl" }, ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeRetAutorizacao?wsdl" }, ;
   { "GO",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl" }, ;
   ;
   { "GO",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://homolog.sefaz.go.gov.br/nfe/services/v2/CadConsultaCadastro2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeConsulta2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeInutilizacao2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcao2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRecepcaoEvento?wsdl" }, ;
   { "GO",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeRetRecepcao2?wsdl" }, ;
   { "GO",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://homolog.sefaz.go.gov.br/nfe/services/v2/NfeStatusServico2?wsdl" }, ;
   ;
   { "MA",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl" }, ;
   { "MA",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://sistemas.sefaz.ma.gov.br/wscadastro/CadConsultaCadastro2?wsdl" }, ;
   ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2" }, ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2" }, ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2" }, ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento" }, ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetAutorizacao" }, ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2" }, ;
   { "MG",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.fazenda.mg.gov.br/nfe2/services/NfeStatus2" }, ;
   ;
   { "MG",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://hnfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
   { "MG",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeConsulta2" }, ;
   { "MG",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeInutilizacao2" }, ;
   { "MG",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRecepcao2" }, ;
   { "MG",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeRetRecepcao2" }, ;
   { "MG",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://hnfe.fazenda.mg.gov.br/nfe2/services/RecepcaoEvento" }, ;
   { "MG",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://hnfe.fazenda.mg.gov.br/nfe2/services/NfeStatusServico2" }, ;
   ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.fazenda.ms.gov.br/producao/services2/CadConsultaCadastro2" }, ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.fazenda.ms.gov.br/producao/services2/NfeConsulta2" }, ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.fazenda.ms.gov.br/producao/services2/NfeInutilizacao2" }, ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRecepcao2" }, ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.fazenda.ms.gov.br/producao/services2/RecepcaoEvento" }, ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetAutorizacao" }, ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe.fazenda.ms.gov.br/producao/services2/NfeRetRecepcao2" }, ;
   { "MS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.fazenda.ms.gov.br/producao/services2/NfeStatusServico2" }, ;
   ;
   { "MS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://homologacao.nfe.ms.gov.br/homologacao/services2/CadConsultaCadastro2" }, ;
   { "MS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeConsulta2" }, ;
   { "MS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeInutilizacao2" }, ;
   { "MS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRecepcao2" }, ;
   { "MS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://homologacao.nfe.ms.gov.br/homologacao/services2/RecepcaoEvento" }, ;
   { "MS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeRetRecepcao2" }, ;
   { "MS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://homologacao.nfe.ms.gov.br/homologacao/services2/NfeStatusServico2" }, ;
   ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl" }, ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao?wsdl" }, ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl" }, ;
   ;
   { "MT",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRecepcao2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento?wsdl" }, ;
   { "MT",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetRecepcao2?wsdl" }, ;
   { "MT",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico2?wsdl" }, ;
   ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro2" }, ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2" }, ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2" }, ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento" }, ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetAutorizacao?wsdl" }, ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2" }, ;
   { "PE",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2" }, ;
   ;
   { "PE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
   { "PE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeConsulta2" }, ;
   { "PE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeInutilizacao2" }, ;
   { "PE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRecepcao2" }, ;
   { "PE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/RecepcaoEvento" }, ;
   { "PE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeRetRecepcao2" }, ;
   { "PE",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NfeStatusServico2" }, ;
   ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl" }, ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl" }, ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl" }, ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl" }, ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe2.fazenda.pr.gov.br/nfe-evento/NFeRecepcaoEvento?wsdl" }, ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl" }, ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl" }, ;
   { "PR",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://homologacao.nfe.fazenda.pr.gov.br/nfe/CadConsultaCadastro2?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeConsulta3?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeInutilizacao3?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRecepcao2?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRecepcaoEvento?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRetRecepcao2?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeStatusServico3?wsdl" }, ;
   { "PR",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "3.10", "https://homologacao.nfe.fazenda.pr.gov.br/nfe/NFeRetAutorizacao3?wsdl" }, ;
   ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTADEST,      "3.10", "https://nfe.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx" }, ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_DOWNLOADNF,        "3.10", "https://nfe.sefazrs.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx" }, ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
   { "RS",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
   ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTADEST,      "3.10", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx" }, ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_DOWNLOADNF,        "3.10", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeDownloadNF/nfeDownloadNF.asmx" }, ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
   { "RS",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
   ;
   { "SP",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx" }, ;
   { "SP",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx" }, ;
   { "SP",    WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx" }, ;
   { "SP",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx" }, ;
   { "SP",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx" }, ;
   { "SP",    WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx" }, ;
   ;
   { "SP",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://homologacao.nfe.fazenda.sp.gov.br/ws/cadconsultacadastro2.asmx" }, ;
   { "SP",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsulta2.asmx" }, ;
   { "SP",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao2.asmx" }, ;
   { "SP",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "3.10", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao.asmx" }, ;
   { "SP",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://homologacao.nfe.fazenda.sp.gov.br/ws/recepcaoevento.asmx" }, ;
   { "SP",    WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico2.asmx" }, ;
   ;
   { "SVRS",  WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTACADASTRO,  "3.10", "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://nfe.svrs.rs.gov.br/ws/nfeStatusServico/NfeStatusServico2.asmx" }, ;
   ;
   { "SVRS",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTACADASTRO,  "3.10", "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,    "3.10", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
   { "SVRS",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
   ;
   { "SCAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://www.scan.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://www.scan.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://www.scan.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://www.scan.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://www.scan.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://www.scan.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://www.scan.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
   ;
   { "SCAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://hom.nfe.fazenda.gov.br/SCAN/NfeConsulta2/NfeConsulta2.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://hom.nfe.fazenda.gov.br/SCAN/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://hom.nfe.fazenda.gov.br/SCAN/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "1.00", "https://hom.nfe.fazenda.gov.br/SCAN/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
   { "SCAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://hom.nfe.fazenda.gov.br/SCAN/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
   ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://www.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,      "3.10", "https://www.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_DOWNLOADNF,        "3.10", "https://www.sefazvirtual.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://www.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://www.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://www.sefazvirtual.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://www.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://www.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
   ;
   { "SVAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://hom.sefazvirtual.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_DOWNLOADNF,        "3.10", "https://hom.nfe.fazenda.gov.br/nfedownloadnf/nfedownloadnf.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,      "3.10", "https://hom.sefazvirtual.fazenda.gov.br/NfeInutilizacao2/NfeInutilizacao2.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAO,          "3.10", "https://hom.sefazvirtual.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,    "1.00", "https://hom.sefazvirtual.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETRECEPCAO,       "3.10", "https://hom.sefazvirtual.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
   { "SVAN",  WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,     "3.10", "https://hom.sefazvirtual.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
   ;
   { "SCVAN", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO, "3.10", "https://www.svc.fazenda.gov.br/NfeConsulta2/NfeConsulta2.asmx" }, ;
   { "SCVAN", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAO,          "3.10", "https://www.svc.fazenda.gov.br/NfeRecepcao2/NfeRecepcao2.asmx" }, ;
   { "SCVAN", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://www.svc.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" }, ;
   { "SCVAN", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,    "3.10", "https://www.svc.fazenda.gov.br/NfeRetAutorizacao/NfeRetAutorizacao.asmx" }, ;
   { "SCVAN", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETRECEPCAO,       "3.10", "https://www.svc.fazenda.gov.br/NfeRetRecepcao2/NfeRetRecepcao2.asmx" }, ;
   { "SCVAN", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,     "3.10", "https://www.svc.fazenda.gov.br/NfeStatusServico2/NfeStatusServico2.asmx" }, ;
   ;
   { "AN",    WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTADEST,      "3.10", "https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx" }, ;
   { "AN",    WS_AMBIENTE_PRODUCAO,    WS_NFE_DISTRIBUICAODFE,   "3.10", "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx" }, ;
   { "AN",    WS_AMBIENTE_PRODUCAO,    WS_NFE_DOWNLOADNF,        "3.10", "https://www.nfe.fazenda.gov.br/NfeDownloadNF/NfeDownloadNF.asmx" }, ;
   { "AN",    WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,    "1.00", "https://www.nfe.fazenda.gov.br/RecepcaoEvento/RecepcaoEvento.asmx" } }

#define SEFAZ_CTE_URL_LIST { ;
   ;
   { "MG",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "2.00", "https://cte.fazenda.mg.gov.br/cte/services/CteRecepcao" }, ;
   { "MG",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "2.00", "https://cte.fazenda.mg.gov.br/cte/services/CteRetRecepcao" }, ;
   { "MG",   WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "2.00", "https://cte.fazenda.mg.gov.br/cte/services/CteInutilizacao" }, ;
   { "MG",   WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://cte.fazenda.mg.gov.br/cte/services/CteConsulta" }, ;
   { "MG",   WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "2.00", "https://cte.fazenda.mg.gov.br/cte/services/CteStatusServico" }, ;
   { "MG",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "2.00", "https://cte.fazenda.mg.gov.br/cte/services/RecepcaoEvento" }, ;
   ;
   { "MS",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "2.00", "https://producao.cte.ms.gov.br/ws/CteRecepcao" }, ;
   { "MS",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "2.00", "https://producao.cte.ms.gov.br/ws/CteRetRecepcao" }, ;
   { "MS",   WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "2.00", "https://producao.cte.ms.gov.br/ws/CteInutilizacao" }, ;
   { "MS",   WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://producao.cte.ms.gov.br/ws/CteConsulta" }, ;
   { "MS",   WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "2.00", "https://producao.cte.ms.gov.br/ws/CteStatusServico" }, ;
   { "MS",   WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTACADASTRO,  "2.00", "https://producao.cte.ms.gov.br/ws/CadConsultaCadastro" }, ;
   { "MS",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "2.00", "https://producao.cte.ms.gov.br/ws/CteRecepcaoEvento" }, ;
   ;
   { "MT",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "2.00", "https://cte.sefaz.mt.gov.br/ctews/services/CteRecepcao" }, ;
   { "MT",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "2.00", "https://cte.sefaz.mt.gov.br/ctews/services/CteRetRecepcao" }, ;
   { "MT",   WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "2.00", "https://cte.sefaz.mt.gov.br/ctews/services/CteInutilizacao" }, ;
   { "MT",   WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://cte.sefaz.mt.gov.br/ctews/services/CteConsulta" }, ;
   { "MT",   WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "2.00", "https://cte.sefaz.mt.gov.br/ctews/services/CteStatusServico" }, ;
   { "MT",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "2.00", "https://cte.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento?wsdl" }, ;
   ;
   { "PR",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "2.00", "https://cte.fazenda.pr.gov.br/cte/CteRecepcao?wsdl" }, ;
   { "PR",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "2.00", "https://cte.fazenda.pr.gov.br/cte/CteRetRecepcao?wsdl" }, ;
   { "PR",   WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "2.00", "https://cte.fazenda.pr.gov.br/cte/CteInutilizacao?wsdl" }, ;
   { "PR",   WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://cte.fazenda.pr.gov.br/cte/CteConsulta?wsdl" }, ;
   { "PR",   WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "2.00", "https://cte.fazenda.pr.gov.br/cte/CteStatusServico?wsdl" }, ;
   { "PR",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "2.00", "https://cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento?wsdl" }, ;
   ;
   { "SP",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "SP",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
   { "SP",   WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
   { "SP",   WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
   { "SP",   WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
   { "SP",   WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "2.00", "https://nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
   { "SP",   WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
   ;
   { "SP",   WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RECEPCAO,          "2.00", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "SP",   WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RETRECEPCAO,       "2.00", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
   { "SP",   WS_AMBIENTE_HOMOLOGACAO, WS_CTE_INUTILIZACAO,      "2.00", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
   { "SP",   WS_AMBIENTE_HOMOLOGACAO, WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
   { "SP",   WS_AMBIENTE_HOMOLOGACAO, WS_CTE_STATUSSERVICO,     "2.00", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
   { "SP",   WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RECEPCAOEVENTO,    "2.00", "https://homologacao.nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
   ;
   { "SVSP", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "SVSP", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteRetRecepcao.asmx" }, ;
   { "SVSP", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteConsulta.asmx" }, ;
   { "SVSP", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "2.00", "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteStatusServico.asmx" }, ;
   ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAO,          "2.00", "https://cte.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_CTE_RETRECEPCAO,       "2.00", "https://cte.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_CTE_INUTILIZACAO,      "2.00", "https://cte.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_CTE_STATUSSERVICO,     "2.00", "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_CTE_RECEPCAOEVENTO,    "2.00", "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" }, ;
   ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RECEPCAO,          "2.00", "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RETRECEPCAO,       "2.00", "https://cte-homologacao.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_INUTILIZACAO,      "2.00", "https://cte-homologacao.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_CONSULTAPROTOCOLO, "2.00", "https://cte-homologacao.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_STATUSSERVICO,     "2.00", "https://cte-homologacao.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_CTE_RECEPCAOEVENTO,    "2.00", "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" } }

#define SEFAZ_MDFE_URL_LIST   { ;
   ;
   { "**", WS_AMBIENTE_PRODUCAO,    WS_MDFE_DISTRIBUICAODFE, "3.00", "https://mdfe.svrs.rs.gov.br/WS/MDFeDistribuicaoDFe/MDFeDistribuicaoDFe.asmx" }, ;
   { "**", WS_AMBIENTE_PRODUCAO,    WS_MDFE_CONSULTA,        "3.00", "https://mdfe.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" }, ;
   { "**", WS_AMBIENTE_PRODUCAO,    WS_MDFE_RECEPCAO,        "3.00", "https://mdfe.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" }, ;
   { "**", WS_AMBIENTE_PRODUCAO,    WS_MDFE_RECEPCAOEVENTO,  "3.00", "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" }, ;
   { "**", WS_AMBIENTE_PRODUCAO,    WS_MDFE_RETRECEPCAO,     "3.00", "https://mdfe.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" }, ;
   { "**", WS_AMBIENTE_PRODUCAO,    WS_MDFE_STATUSSERVICO,   "3.00", "https://mdfe.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" }, ;
   { "**", WS_AMBIENTE_PRODUCAO,    WS_MDFE_CONSNAOENC,      "3.00", "https://mdfe.svrs.rs.gov.br/ws/mdfeConsNaoEnc/mdfeConsNaoenc.asmx" }, ;
   ;
   { "**", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_CONSULTA,        "3.00", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" }, ;
   { "**", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_CONSNAOENC,      "3.00", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsNaoEnc/MDFeConsNaoEnc.asmx" }, ;
   { "**", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_RECEPCAO,        "3.00", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" }, ;
   { "**", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_RECEPCAOEVENTO,  "3.00", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" }, ;
   { "**", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_RETRECEPCAO,     "3.00", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" }, ;
   { "**", WS_AMBIENTE_HOMOLOGACAO, WS_MDFE_STATUSSERVICO,   "3.00", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" } }

#define SEFAZ_NFCE_URL_LIST { ;
   ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_NFE_AUTORIZACAO,        "3.10", "https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_NFE_CONSULTAPROTOCOLO,  "3.10", "https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_NFE_INUTILIZACAO,       "3.10", "https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_NFE_RECEPCAOEVENTO,     "3.10", "https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_NFE_RETAUTORIZACAO,     "3.10", "https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_PRODUCAO,    WS_NFE_STATUSSERVICO,      "3.10", "https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" }, ;
   ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_AUTORIZACAO ,       "3.10", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_CONSULTAPROTOCOLO,  "3.10", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_INUTILIZACAO,       "3.10", "https://nfce-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RECEPCAOEVENTO,     "3.10", "https://nfce-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_RETAUTORIZACAO,     "3.10", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx" }, ;
   { "SVRS", WS_AMBIENTE_HOMOLOGACAO, WS_NFE_STATUSSERVICO,      "3.10", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx" } }

// 1¦ Parte ( Endereco da Consulta - Fonte: http://nfce.encat.org/desenvolvedor/qrcode/ )
#define SEFAZ_QRCODE_URL_LIST { ;
   ;
   { "AC", WS_AMBIENTE_PRODUCAO,    "http://www.sefaznet.ac.gov.br/nfce/qrcode?" }, ;
   { "AL", WS_AMBIENTE_PRODUCAO,    "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?" }, ;
   { "AP", WS_AMBIENTE_PRODUCAO,    "https://www.sefaz.ap.gov.br/nfce/nfcep.php?" }, ;
   { "AM", WS_AMBIENTE_PRODUCAO,    "http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?" }, ;
   { "BA", WS_AMBIENTE_PRODUCAO,    "http://nfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
   { "CE", WS_AMBIENTE_PRODUCAO,    "http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
   { "DF", WS_AMBIENTE_PRODUCAO,    "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
   { "ES", WS_AMBIENTE_PRODUCAO,    "http://app.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?" }, ;
   { "GO", WS_AMBIENTE_PRODUCAO,    "http://nfe.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe" }, ;
   { "MA", WS_AMBIENTE_PRODUCAO,    "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?" }, ;
   { "MT", WS_AMBIENTE_PRODUCAO,    "http://www.sefaz.mt.gov.br/nfce/consultanfce?" }, ;
   { "MS", WS_AMBIENTE_PRODUCAO,    "http://www.dfe.ms.gov.br/nfce/qrcode?" }, ;
   { "MG", WS_AMBIENTE_PRODUCAO,    "" }, ;
   { "PA", WS_AMBIENTE_PRODUCAO,    "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/nfceForm.seam?" }, ;
   { "PB", WS_AMBIENTE_PRODUCAO,    "http://www.receita.pb.gov.br/nfce?" }, ;
   { "PR", WS_AMBIENTE_PRODUCAO,    "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?" }, ;
   { "PE", WS_AMBIENTE_PRODUCAO,    "http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe?" }, ;
   { "PI", WS_AMBIENTE_PRODUCAO,    "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf?" }, ;
   { "RJ", WS_AMBIENTE_PRODUCAO,    "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?" }, ;
   { "RN", WS_AMBIENTE_PRODUCAO,    "http://nfce.set.rn.gov.br/consultarNFCe.aspx?" }, ;
   { "RS", WS_AMBIENTE_PRODUCAO,    "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?" }, ;
   { "RO", WS_AMBIENTE_PRODUCAO,    "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp?" }, ;
   { "RR", WS_AMBIENTE_PRODUCAO,    "https://www.sefaz.rr.gov.br/nfce/servlet/qrcode?" }, ;
   { "SC", WS_AMBIENTE_PRODUCAO,    "" }, ;
   { "SP", WS_AMBIENTE_PRODUCAO,    "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx?" }, ;
   { "SE", WS_AMBIENTE_PRODUCAO,    "http://www.nfce.se.gov.br/portal/consultarNFCe.jsp?" }, ;
   { "TO", WS_AMBIENTE_PRODUCAO,    "" }, ;
   ;
   { "AC", WS_AMBIENTE_HOMOLOGACAO, "http://hml.sefaznet.ac.gov.br/nfce/qrcode?" }, ;
   { "AL", WS_AMBIENTE_HOMOLOGACAO, "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?" }, ;
   { "AP", WS_AMBIENTE_HOMOLOGACAO, "https://www.sefaz.ap.gov.br/nfcehml/nfce.php?" }, ;
   { "AM", WS_AMBIENTE_HOMOLOGACAO, "http://homnfce.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp?" }, ;
   { "BA", WS_AMBIENTE_HOMOLOGACAO, "http://hnfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
   { "CE", WS_AMBIENTE_HOMOLOGACAO, "http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
   { "DF", WS_AMBIENTE_HOMOLOGACAO, "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
   { "ES", WS_AMBIENTE_HOMOLOGACAO, "http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?" }, ;
   { "GO", WS_AMBIENTE_HOMOLOGACAO, "" }, ;
   { "MA", WS_AMBIENTE_HOMOLOGACAO, "http://www.hom.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp?" }, ;
   { "MT", WS_AMBIENTE_HOMOLOGACAO, "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce?" }, ;
   { "MS", WS_AMBIENTE_HOMOLOGACAO, "http://www.dfe.ms.gov.br/nfce/qrcode?" }, ;
   { "MG", WS_AMBIENTE_HOMOLOGACAO, "" }, ;
   { "PA", WS_AMBIENTE_HOMOLOGACAO, "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/nfceForm.seam" }, ;
   { "PB", WS_AMBIENTE_HOMOLOGACAO, "http://www.receita.pb.gov.br/nfcehom" }, ;
   { "PR", WS_AMBIENTE_HOMOLOGACAO, "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?" }, ;
   { "PE", WS_AMBIENTE_HOMOLOGACAO, "http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe?" }, ;
   { "PI", WS_AMBIENTE_HOMOLOGACAO, "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf?" }, ;
   { "RJ", WS_AMBIENTE_HOMOLOGACAO, "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode?" }, ;
   { "RN", WS_AMBIENTE_HOMOLOGACAO, "http://hom.nfce.set.rn.gov.br/consultarNFCe.aspx?" }, ;
   { "RS", WS_AMBIENTE_HOMOLOGACAO, "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx?" }, ;
   { "RO", WS_AMBIENTE_HOMOLOGACAO, "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp" }, ;
   { "RR", WS_AMBIENTE_HOMOLOGACAO, "http://200.174.88.103:8080/nfce/servlet/qrcode?" }, ;
   { "SC", WS_AMBIENTE_HOMOLOGACAO, "" }, ;
   { "SP", WS_AMBIENTE_HOMOLOGACAO, "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx" }, ;
   { "SE", WS_AMBIENTE_HOMOLOGACAO, "http://www.hom.nfe.se.gov.br/portal/consultarNFCe.jsp?" }, ;
   { "TO", WS_AMBIENTE_HOMOLOGACAO, "" } }

#define SEFAZ_BPE_URL_LIST { ;
   ;
   { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_RECEPCAO,       "1.00", "https://bpe.fazenda.ms.gov.br/ws/BPeRecepcao" }, ;
   { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_RECEPCAOEVENTO, "1.00", "https://bpe.fazenda.ms.gov.br/ws/BPeRecepcaoEvento" }, ;
   { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_CONSULTA,       "1.00", "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta" }, ;
   { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_STATUSSERVICO,  "1.00", "https://bpe.fazenda.ms.gov.br/ws/BPeStatusServico" }, ;
   { "MS",   "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_QRCODE,         "http://dfe.ms.gov.br/bpe/qrcode" }, ;
   ;
   { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_RECEPCAO,       "1.00", "https://homologacao.bpe.ms.gov.br/ws/BPeRecepcao" }, ;
   { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_RECEPCAOEVENTO, "1.00", "https://homologacao.bpe.ms.gov.br/ws/BPeRecepcaoEvento" }, ;
   { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_CONSULTA,       "1.00", "https://homologacao.bpe.ms.gov.br/ws/BPeConsulta" }, ;
   { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_STATUSSERVICO,  "1.00", "https://homologacao.bpe.ms.gov.br/ws/BPeStatusServico" }, ;
   { "MS",   "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_QRCODE,         "http//www.dfe.ms.gov.br/bpe/qrcode" }, ;
   ;
   { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_RECEPCAO,       "1.00", "https://bpe.svrs.rs.gov.br/ws/bpeRecepcao/bpeRecepcao.asmx" }, ;
   { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_RECEPCAOEVENTO, "1.00", "https://bpe.svrs.rs.gov.br/ms/bpeRecepcaoEvento/bpeRecepcaoEvento.asmx" }, ;
   { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_CONSULTA,       "1.00", "https://bpe.svrs.rs.gov.br/ms/bpeConsulta.asmx" }, ;
   { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_STATUSSERVICO,  "1.00", "https://bpe.svrs.rs.gov.br/ms/bpeStatusServico/bpeStatusServico.asmx" }, ;
   { "SVRS", "1.00", WS_AMBIENTE_PRODUCAO,     WS_BPE_QRCODE,         "1.00", "https://bpe.svrs.rs.gov.br/ws/bpeQrCode/qrCode.asmx" }, ;
   ;
   { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_RECEPCAO,       "1.00", "https://bpe-homologacao.srvs.rs.gov.br/ws/bpeRecepcao/bpeRecepcao.asmx" }, ;
   { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_RECEPCAOEVENTO, "1.00", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeRecepcaoEvento/bpeRecepcaoEvento.asmx" }, ;
   { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_CONSULTA,       "1.00", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeConsulta/bpeConsulta.asmx" }, ;
   { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_STATUSSERVICO,  "1.00", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx" }, ;
   { "SVRS", "1.00", WS_AMBIENTE_HOMOLOGACAO,  WS_BPE_QRCODE,         "1.00", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeQrCode/qrCode.asmx" } }
