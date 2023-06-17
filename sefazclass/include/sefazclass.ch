#define WS_PROJETO_BPE               "bpe"
#define WS_PROJETO_CTE               "cte"
#define WS_PROJETO_MDFE              "mdfe"
#define WS_PROJETO_NFE               "nfe"

#define WS_AMBIENTE_HOMOLOGACAO      "2"
#define WS_AMBIENTE_PRODUCAO         "1"

#define WS_XMLNS_BPE                 [xmlns="http://www.portalfiscal.inf.br/bpe"]
#define WS_XMLNS_CTE                 [xmlns="http://www.portalfiscal.inf.br/cte"]
#define WS_XMLNS_NFE                 [xmlns="http://www.portalfiscal.inf.br/nfe"]
#define WS_XMLNS_MDFE                [xmlns="http://www.portalfiscal.inf.br/mdfe"]

#define WS_RETORNA_PROTOCOLO    "1"
#define WS_RETORNA_RECIBO       "0"

#define XML_UTF8                   [<?xml version="1.0" encoding="UTF-8"?>]

#define WS_BPE_DEFAULT  "1.00"
#define WS_NFE_DEFAULT  "4.00"
#define WS_CTE_DEFAULT  "3.00"
#define WS_MDFE_DEFAULT "3.00"

#define WS_BPE_CONSULTAPROTOCOLO { ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeConsulta" }, ;
   { "MS",   "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta" }, ;
   { "PR",   "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BpeConsulta" }, ;
   { "SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ms/bpeConsulta.asmx" }, ;
   ;
   { "MS",   "1.00H", "https://homologacao.bpe.ms.gov.br/ws/BPeConsulta" } }

#define WS_BPE_RECEPCAO { ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeRecepcao" }, ;
   { "MS",   "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta" }, ;
   { "PR",   "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BPeRecepcao" }, ;
   { "SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ws/bpeRecepcao/bpeRecepcao.asmx" } }

#define WS_BPE_RECEPCAOEVENTO { ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeRecepcaoEvento" }, ;
   { "MS",   "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeRecepcaoEvento" }, ;
   { "PR",   "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BPeRecepcaoEvento" }, ;
   { "SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ws/bpeRecepcaoEvento.asmx" } }

#define WS_BPE_STATUSSERVICO { ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/BPeStatusServico" }, ;
   { "MS",   "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeStatusServico" }, ;
   { "PR",   "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BPeStatusServico" }, ;
   { "SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ms/bpeStatusServico/bpeStatusServico.asmx" }, ;
   ;
   { "MS",   "1.00H", "https://homologacao.bpe.ms.gov.br/ws/BPeStatusServico" }, ;
   { "SVRS", "1.00H", "https://bpe-homologacao.svrs.rs.gov.br/ws/bpeStatusServico/bpeStatusServico.asmx" } }

#define WS_BPE_QRCODE { ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/portalbpe/sistema/qrcode.xhtml" }, ;
   { "MS",   "1.00P", "http://www.dfe.ms.gov.br/qrcode" }, ;
   { "PR",   "1.00P", "https://www.fazenda.pr.gov.br/qrcode" }, ;
   { "SVRS", "1.00P", "https://bpe-portal.sefazvirtual.rs.gov.br/bpe/qrCode" } }

#define WS_CTE_CONSULTAPROTOCOLO { ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteConsulta" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteConsulta" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteConsulta" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
   { "SP",   "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeConsultaV4.asmx" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteConsulta?wsdl" }, ;
   { "SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteConsulta.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteConsulta.asmx" }, ;
   { "SP",   "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeConsultaV4.asmx" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cteconsulta/CteConsulta.asmx" } }

#define WS_CTE_RETAUTORIZACAO { ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteRetRecepcao" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteRetRecepcao" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteRetRecepcao" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteRetRecepcao?wsdl" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
   { "SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteRetRecepcao.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRetRecepcao.asmx" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cteretrecepcao/cteRetRecepcao.asmx" } }

#define WS_CTE_ENVIAEVENTO { ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/RecepcaoEvento" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteRecepcaoEvento" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews2/services/CteRecepcaoEvento?wsdl" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteRecepcaoEvento?wsdl" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
   { "SP",   "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoEventoV4.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteweb/services/cteRecepcaoEvento.asmx" }, ;
   { "SP",   "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoEventoV4.asmx" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcaoevento/cterecepcaoevento.asmx" } }

#define WS_CTE_INUTILIZA { ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteInutilizacao" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteInutilizacao" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteInutilizacao" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteInutilizacao?wsdl" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteInutilizacao.asmx" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cteinutilizacao/cteinutilizacao.asmx" } }

#define WS_CTE_AUTORIZACAO { ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteRecepcao" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteRecepcao" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteRecepcao" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteRecepcao?wsdl" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "SP",   "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeRecepcaoSincV4.asmx" }, ;
   { "SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteRecepcao.asmx" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/cterecepcao/CteRecepcao.asmx" } }

#define WS_CTE_STATUSSERVICO { ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/cte/services/CteStatusServico" }, ;
   { "MT",   "3.00P", "https://cte.sefaz.mt.gov.br/ctews/services/CteStatusServico" }, ;
   { "MS",   "3.00P", "https://producao.cte.ms.gov.br/ws/CteStatusServico" }, ;
   { "PR",   "3.00P", "https://cte.fazenda.pr.gov.br/cte/CteStatusServico?wsdl" }, ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
   { "SP",   "4.00P", "https://nfe.fazenda.sp.gov.br/CTeWS/WS/CTeStatusServicoV4.asmx" }, ;
   { "SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/cteWEB/services/CteStatusServico.asmx" }, ;
   { "SVRS", "3.00P", "https://cte.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" }, ;
   ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/cteWEB/services/cteStatusServico.asmx" }, ;
   { "SP",   "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeWS/WS/CTeStatusServicoV4.asmx" }, ;
   { "SVRS", "3.00H", "https://cte-homologacao.svrs.rs.gov.br/ws/ctestatusservico/CteStatusServico.asmx" } }

#define WS_CTE_QRCODE { ;
   { "SP", "3.00P", "https://nfe.fazenda.sp.gov.br/CTeConsulta/qrCode" } }

#define WS_MDFE_CONSULTANAOENCERRADOS { ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/mdfeConsNaoEnc/mdfeConsNaoenc.asmx" }, ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsNaoEnc/MDFeConsNaoEnc.asmx" } }

#define WS_MDFE_CONSULTAPROTOCOLO { ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" }, ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeConsulta/MDFeConsulta.asmx" } }

#define WS_MDFE_RETAUTORIZACAO { ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" }, ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRetRecepcao/MDFeRetRecepcao.asmx" } }

#define WS_MDFE_DISTRIBUICAO { ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/WS/MDFeDistribuicaoDFe/MDFeDistribuicaoDFe.asmx" } }

#define WS_MDFE_EVENTO { ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" }, ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoEvento/MDFeRecepcaoEvento.asmx" } }

#define WS_MDFE_AUTORIZACAO { ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" }, ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFerecepcao/MDFeRecepcao.asmx" } }

#define WS_MDFE_RECEPCAOSINC { ;
   { "**", "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeRecepcaoSinc/MDFeRecepcaoSinc.asmx" }, ;
   { "**", "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeRecepcaoSinc/MDFeRecepcaoSinc.asmx" } }

#define WS_MDFE_STATUSSERVICO { ;
   { "**",   "3.00P", "https://mdfe.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" }, ;
   ;
   { "**",   "3.00H", "https://mdfe-homologacao.svrs.rs.gov.br/ws/MDFeStatusServico/MDFeStatusServico.asmx" } }

#define WS_MDFE_QRCODE { ;
   { "**", "3.00P", "https://dfe-portal.svrs.rs.gov.br/mdfe/qrCode" }, ;
   ;
   { "**", "3.00H", "https://dfe-portal.svrs.rs.gov.br/mdfe/qrCode" } }

#define WS_NFE_CONSULTACADASTRO { ;
   { "MG",   "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
   { "MS",   "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/CadConsultaCadastro4" }, ;
   { "PR",   "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/CadConsultaCadastro4" }, ;
   { "BA",   "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx" }, ;
   { "CE",   "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/CadConsultaCadastro4" }, ;
   { "GO",   "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4" }, ;
   { "MS",   "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4" }, ;
   { "MT",   "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro4" }, ;
   { "PE",   "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro4" }, ;
   { "PR",   "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/CadConsultaCadastro4" }, ;
   { "RS",   "4.00P",  "https://cad.sefazrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx" }, ;
   { "SP",   "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro4.asmx" }, ;
   { "SVRS", "4.00P",  "https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx" }, ;
   ;
   { "MS",   "4.00HC", "https://hom.nfce.fazenda.ms.gov.br/ws/CadConsultaCadastro4" }, ;
   { "PR",   "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/CadConsultaCadastro4" }, ;
   { "AM",   "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx" }, ;
   { "BA",   "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx" }, ;
   { "GO",   "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4?wsdl" }, ;
   { "MG",   "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/cadconsultacadastro2" }, ;
   { "MS",   "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4" }, ;
   { "MT",   "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro4?wsdl" }, ;
   { "PE",   "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro4" }, ;
   { "PR",   "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/CadConsultaCadastro4?wsdl" }, ;
   { "SP",   "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/cadconsultacadastro4.asmx" } }

#define WS_NFE_CONSULTADEST { ;
   { "RS",   "3.10P", "https://nfe.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx" }, ;
   { "AN",   "3.10P", "https://www.nfe.fazenda.gov.br/NFeConsultaDest/NFeConsultaDest.asmx" }, ;
   ;
   { "RS",   "3.10H", "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeConsultaDest/nfeConsultaDest.asmx" } }

#define WS_NFE_CONSULTAPROTOCOLO { ;
   { "AM",    "4.00P",  "https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta4" }, ;
   { "BA",    "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" }, ;
   { "CE",    "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/NFeConsultaProtocolo4" }, ;
   { "GO",    "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4" }, ;
   { "MG",    "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4" }, ;
   { "MS",    "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4" }, ;
   { "MT",    "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta4" }, ;
   { "PE",    "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeConsultaProtocolo4" }, ;
   { "PR",    "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/NFeConsultaProtocolo4" }, ;
   { "RS",    "4.00P",  "https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   { "SP",    "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx" }, ;
   { "SVAN",  "4.00P",  "https://www.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" }, ;
   { "SVCAN", "4.00P",  "https://www.svc.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" }, ;
   { "SVCRS", "4.00P",  "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   { "SVRS",  "4.00P",  "https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   ;
   { "AM",    "4.00H",  "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta4" }, ;
   { "BA",    "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" }, ;
   { "CE",    "4.00H",  "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeConsultaProtocolo4" }, ;
   { "GO",    "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4" }, ;
   { "MG",    "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4" }, ;
   { "MS",    "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4" }, ;
   { "MT",    "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta4" }, ;
   { "PE",    "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeConsultaProtocolo4" }, ;
   { "PR",    "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeConsultaProtocolo4" }, ;
   { "RS",    "4.00H",  "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   { "SP",    "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx" }, ;
   { "SVAN",  "4.00H",  "https://hom.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" }, ;
   { "SVCAN", "4.00H",  "https://hom.svc.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx" }, ;
   { "SVCRS", "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   { "SVRS",  "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta4" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.fazenda.ms.gov.br/ws/NFeConsultaProtocolo4" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeConsulta4" }, ;
   { "MS",    "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/NFeConsultaProtocolo4" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx" } }

#define WS_NFE_DISTRIBUICAO { ;
   { "AN",   "3.10P", "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx" }, ;
   ;
   { "AN",   "4.00P", "https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx" }, ;
   ;
   { "AN",   "4.00H", "https://hom1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx" } }

#define WS_NFE_EVENTO { ;
   { "AN",    "4.00H",  "https://hom1.nfe.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "AM",    "4.00H",  "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4" }, ;
   { "BA",    "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "CE",    "4.00H",  "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeRecepcaoEvento4" }, ;
   { "GO",    "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4" }, ;
   { "MG",    "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4" }, ;
   { "MS",    "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" }, ;
   { "MT",    "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento4" }, ;
   { "PE",    "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeRecepcaoEvento4" }, ;
   { "PR",    "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeRecepcaoEvento4" }, ;
   { "RS",    "4.00H",  "https://nfe-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SP",    "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx" }, ;
   { "SVAN",  "4.00H",  "https://hom.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "SVCAN", "4.00H",  "https://hom.svc.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "SVCRS", "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SVRS",  "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.fazenda.ms.gov.br/ws/NFeRecepcaoEvento4" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeRecepcaoEvento4" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeRecepcaoEvento4.asmx" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   ;
   { "AN",    "4.00P",  "https://www.nfe.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "AM",    "4.00P",  "https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4" }, ;
   { "BA",    "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "CE",    "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/NFeRecepcaoEvento4" }, ;
   { "GO",    "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4" }, ;
   { "MG",    "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4" }, ;
   { "MS",    "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4" }, ;
   { "MT",    "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento4" }, ;
   { "PE",    "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeRecepcaoEvento4" }, ;
   { "PR",    "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/NFeRecepcaoEvento4" }, ;
   { "RS",    "4.00P",  "https://nfe.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SP",    "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx" }, ;
   { "SVAN",  "4.00P",  "https://www.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "SVCAN", "4.00P",  "https://www.svc.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx" }, ;
   { "SVCRS", "4.00P",  "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SVRS",  "4.00P",  "https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/RecepcaoEvento4" }, ;
   { "MS",    "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/NFeRecepcaoEvento4" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeRecepcaoEvento4" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeRecepcaoEvento4.asmx" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx" } }

#define WS_NFE_INUTILIZA { ;
   { "AM",    "4.00H",  "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao4" }, ;
   { "BA",    "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx" }, ;
   { "CE",    "4.00H",  "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeInutilizacao4" }, ;
   { "GO",    "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/NFeInutilizacao4" }, ;
   { "MG",    "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4" }, ;
   { "MS",    "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/NFeInutilizacao4" }, ;
   { "MT",    "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao4" }, ;
   { "PE",    "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeInutilizacao4" }, ;
   { "PR",    "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeInutilizacao4" }, ;
   { "RS",    "4.00H",  "https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   { "SP",    "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx" }, ;
   { "SVAN",  "4.00H",  "https://hom.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx" }, ;
   { "SVCRS", "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   { "SVRS",  "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao4" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.fazenda.ms.gov.br/ws/NFeInutilizacao4" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeInutilizacao4" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeInutilizacao4.asmx" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   ;
   { "AM",    "4.00P",  "https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao4" }, ;
   { "BA",    "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx" }, ;
   { "CE",    "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/NFeInutilizacao4" }, ;
   { "GO",    "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/NFeInutilizacao4" }, ;
   { "MG",    "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4" }, ;
   { "MS",    "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/NFeInutilizacao4" }, ;
   { "MT",    "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao4" }, ;
   { "PE",    "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeInutilizacao4" }, ;
   { "PR",    "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/NFeInutilizacao4" }, ;
   { "RS",    "4.00P",  "https://nfe.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   { "SP",    "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx" }, ;
   { "SVAN",  "4.00P",  "https://www.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx" }, ;
   { "SVCAN", "4.00P",  "https://www.svc.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx" }, ;
   { "SVCRS", "4.00P",  "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   { "SVRS",  "4.00P",  "https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeInutilizacao4" }, ;
   { "MS",    "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/NFeInutilizacao4" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeInutilizacao4" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeInutilizacao4.asmx" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx" } }

#define WS_NFE_AUTORIZACAO { ;
   { "AM",    "4.00H",  "https://homnfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4" }, ;
   { "BA",    "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/NFeAutorizacao4/NFeAutorizacao4.asmx" }, ;
   { "CE",    "4.00H",  "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeAutorizacao4" }, ;
   { "GO",    "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/NFeAutorizacao4" }, ;
   { "MG",    "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeAutorizacao4" }, ;
   { "MS",    "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/NFeAutorizacao4" }, ;
   { "MT",    "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao4" }, ;
   { "PE",    "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeAutorizacao4" }, ;
   { "PR",    "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeAutorizacao4" }, ;
   { "RS",    "4.00H",  "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "SP",    "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao4.asmx" }, ;
   { "SVAN",  "4.00H",  "https://hom.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx" }, ;
   { "SVCAN", "4.00H",  "https://hom.svc.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx" }, ;
   { "SVCRS", "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "SVRS",  "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.fazenda.ms.gov.br/ws/NFeAutorizacao4" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeAutorizacao4" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeAutorizacao4.asmx" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "AM",    "4.00P",  "https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4" }, ;
   { "BA",    "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/NFeAutorizacao4/NFeAutorizacao4.asmx" }, ;
   { "CE",    "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/NFeAutorizacao4" }, ;
   { "GO",    "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/NFeAutorizacao4" }, ;
   { "MG",    "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeAutorizacao4" }, ;
   { "MS",    "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/NFeAutorizacao4" }, ;
   { "MT",    "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao4" }, ;
   { "PE",    "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeAutorizacao4" }, ;
   { "PR",    "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/NFeAutorizacao4" }, ;
   { "RS",    "4.00P",  "https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "SP",    "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao4.asmx" }, ;
   { "SVAN",  "4.00P",  "https://www.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx" }, ;
   { "SVCAN", "4.00P",  "https://www.svc.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx" }, ;
   { "SVCRS", "4.00P",  "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "SVRS",  "4.00P",  "https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeAutorizacao4" }, ;
   { "MS",    "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/NFeAutorizacao4" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeAutorizacao4" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeAutorizacao4.asmx" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx" } }

#define WS_NFE_RETAUTORIZACAO { ;
   { "AM",    "4.00H",  "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao4" }, ;
   { "BA",    "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" }, ;
   { "CE",    "4.00H",  "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeRetAutorizacao4" }, ;
   { "GO",    "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4" }, ;
   { "MG",    "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeRetAutorizacao4" }, ;
   { "MS",    "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/NFeRetAutorizacao4" }, ;
   { "MT",    "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao4" }, ;
   { "PE",    "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeRetAutorizacao4" }, ;
   { "PR",    "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeRetAutorizacao4" }, ;
   { "RS",    "4.00H",  "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "SP",    "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao4.asmx" }, ;
   { "SVAN",  "4.00H",  "https://hom.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" }, ;
   { "SVCAN", "4.00H",  "https://hom.svc.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" }, ;
   { "SVCRS", "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "SVRS",  "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao4" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.fazenda.ms.gov.br/ws/NFeRetAutorizacao4" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeRetAutorizacao4" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeRetAutorizacao4.asmx" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "AM",    "4.00P",  "https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao4" }, ;
   { "BA",    "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" }, ;
   { "CE",    "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/NFeRetAutorizacao4" }, ;
   { "GO",    "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4" }, ;
   { "MG",    "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRetAutorizacao4" }, ;
   { "MS",    "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/NFeRetAutorizacao4" }, ;
   { "MT",    "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao4" }, ;
   { "PE",    "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeRetAutorizacao4" }, ;
   { "PR",    "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/NFeRetAutorizacao4" }, ;
   { "RS",    "4.00P",  "https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "SP",    "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao4.asmx" }, ;
   { "SVAN",  "4.00P",  "https://www.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" }, ;
   { "SVCAN", "4.00P",  "https://www.svc.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx" }, ;
   { "SVCRS", "4.00P",  "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "SVRS",  "4.00P",  "https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeRetAutorizacao4" }, ;
   { "MS",    "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/NFeRetAutorizacao4" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeRetAutorizacao4" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeRetAutorizacao4.asmx" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx" } }

#define WS_NFE_STATUSSERVICO { ;
   { "AM",    "4.00H",  "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico4" }, ;
   { "BA",    "4.00H",  "https://hnfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx" }, ;
   { "CE",    "4.00H",  "https://nfeh.sefaz.ce.gov.br/nfe4/services/NFeStatusServico4" }, ;
   { "GO",    "4.00H",  "https://homolog.sefaz.go.gov.br/nfe/services/NFeStatusServico4" }, ;
   { "MG",    "4.00H",  "https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4" }, ;
   { "MS",    "4.00H",  "https://hom.nfe.sefaz.ms.gov.br/ws/NFeStatusServico4" }, ;
   { "MT",    "4.00H",  "https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico4" }, ;
   { "PE",    "4.00H",  "https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeStatusServico4" }, ;
   { "PR",    "4.00H",  "https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeStatusServico4" }, ;
   { "RS",    "4.00H",  "https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "SP",    "4.00H",  "https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx" }, ;
   { "SVAN",  "4.00H",  "https://hom.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx" }, ;
   { "SVCAN", "4.00H",  "https://hom.svc.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx" }, ;
   { "SVCRS", "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "SVRS",  "4.00H",  "https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "AM",    "4.00HC", "https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico4" }, ;
   { "MS",    "4.00HC", "https://hom.nfce.fazenda.ms.gov.br/ws/NFeStatusServico4" }, ;
   { "PR",    "4.00HC", "https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeStatusServico4" }, ;
   { "RS",    "4.00HC", "https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "SP",    "4.00HC", "https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeStatusServico4.asmx" }, ;
   { "SVRS",  "4.00HC", "https://nfce-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "AM",    "4.00P",  "https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico4" }, ;
   { "BA",    "4.00P",  "https://nfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx" }, ;
   { "CE",    "4.00P",  "https://nfe.sefaz.ce.gov.br/nfe4/services/NFeStatusServico4" }, ;
   { "GO",    "4.00P",  "https://nfe.sefaz.go.gov.br/nfe/services/NFeStatusServico4" }, ;
   { "MG",    "4.00P",  "https://nfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4" }, ;
   { "MS",    "4.00P",  "https://nfe.sefaz.ms.gov.br/ws/NFeStatusServico4" }, ;
   { "MT",    "4.00P",  "https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico4" }, ;
   { "PE",    "4.00P",  "https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeStatusServico4" }, ;
   { "PR",    "4.00P",  "https://nfe.sefa.pr.gov.br/nfe/NFeStatusServico4" }, ;
   { "RS",    "4.00P",  "https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "SP",    "4.00P",  "https://nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx" }, ;
   { "SVAN",  "4.00P",  "https://www.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx" }, ;
   { "SVCAN", "4.00P",  "https://www.svc.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx" }, ;
   { "SVCRS", "4.00P",  "https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "SVRS",  "4.00P",  "https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "AM",    "4.00PC", "https://nfce.sefaz.am.gov.br/nfce-services/services/NfeStatusServico4" }, ;
   { "MS",    "4.00PC", "https://nfce.fazenda.ms.gov.br/ws/NFeStatusServico4" }, ;
   { "PR",    "4.00PC", "https://nfce.sefa.pr.gov.br/nfce/NFeStatusServico4" }, ;
   { "RS",    "4.00PC", "https://nfce.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" }, ;
   { "SP",    "4.00PC", "https://nfce.fazenda.sp.gov.br/ws/NFeStatusServico4.asmx" }, ;
   { "SVRS",  "4.00PC", "https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx" } }

#define WS_NFE_QRCODE { ;
   ;
   { "PR",   "3.10H", "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe" }, ;
   { "SE",   "3.10H", "http://www.hom.nfe.se.gov.br/portal/consultarNFCe.jsp" }, ;
   ;
   { "PR",   "3.10P", "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe?" }, ;
   { "SE",   "3.10P", "http://www.nfce.se.gov.br/portal/consultarNFCe.jsp?" }, ;
   { "SP",   "3.10P", "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx?" }, ;
   ;
   { "AC",   "4.00H", "http://www.hml.sefaznet.ac.gov.br/nfce/qrcode?" }, ;
   { "AL",   "4.00H", "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp" }, ;
   { "AM",   "4.00H", "http://homnfce.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp" }, ;
   { "AP",   "4.00H", "https://www.sefaz.ap.gov.br/nfcehml/nfce.php" }, ;
   { "BA",   "4.00H", "http://hnfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
   { "CE",   "4.00H", "http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
   { "DF",   "4.00H", "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
   { "ES",   "4.00H", "http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx?" }, ;
   { "GO",   "4.00H", "http://homolog.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe" }, ;
   { "MA",   "4.00H", "http://homologacao.sefaz.ma.gov.br/portal/consultarNFCe.jsp" }, ;
   { "MS",   "4.00H", "http://www.dfe.ms.gov.br/nfce/qrcode?" }, ;
   { "MT",   "4.00H", "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce" }, ;
   { "PA",   "4.00H", "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/nfceForm.seam" }, ;
   { "PB",   "4.00H", "http://www.receita.pb.gov.br/nfcehom" }, ;
   { "PR",   "4.00H", "http://www.fazenda.pr.gov.br/nfce/qrcode?" }, ;
   { "PE",   "4.00H", "http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe" }, ;
   { "PI",   "4.00H", "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf" }, ;
   { "RJ",   "4.00H", "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode" }, ;
   { "RN",   "4.00H", "http://hom.nfce.set.rn.gov.br/consultarNFCe.aspx?" }, ;
   { "RO",   "4.00H", "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp" }, ;
   { "RR",   "4.00H", "https://www.sefaz.rr.gov.br/nfce/servlet/wp_consulta_nfce" }, ;
   { "RS",   "4.00H", "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx" }, ;
   { "SP",   "4.00H", "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx" }, ;
   { "TO",   "4.00H", "http://apps.sefaz.to.gov.br/portal-nfce-homologacao/qrcodeNFCe"  }, ;
   ;
   { "AC",   "4.00P", "http://www.sefaznet.ac.gov.br/nfce/qrcode?" }, ;
   { "AL",   "4.00P", "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp?" }, ;
   { "BA",   "4.00P", "http://nfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
   { "DF",   "4.00P", "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
   { "GO",   "4.00P", "http://nfe.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe" }, ;
   { "MA",   "4.00P", "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp" }, ;
   { "MT",   "4.00P", "http://www.sefaz.mt.gov.br/nfce/consultanfce" }, ;
   { "PA",   "4.00P", "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/nfceForm.seam" }, ;
   { "PB",   "4.00P", "http://www.receita.pb.gov.br/nfce" }, ;
   { "PR",   "4.00P", "http://www.fazenda.pr.gov.br/nfce/qrcode?" }, ;
   { "PE",   "4.00P", "http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe" }, ;
   { "PI",   "4.00P", "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf" }, ;
   { "RJ",   "4.00P", "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode" }, ;
   { "RN",   "4.00P", "http://nfce.set.rn.gov.br/consultarNFCe.aspx" }, ;
   { "RS",   "4.00P", "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx" }, ;
   { "RO",   "4.00P", "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp" }, ;
   { "RR",   "4.00P", "https://www.sefaz.rr.gov.br/nfce/servlet/qrcode" }, ;
   { "SE",   "4.00P", "http://www.nfe.se.gov.br/portal/consultarNFCe.jsp" }, ;
   { "SP",   "4.00P", "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx" }, ;
   { "TO",   "4.00P", "http://apps.sefaz.to.gov.br/portal-nce/qrcodeNFCe" } }

#define WS_NFE_CHAVE { ;
   { "AC", "1.00P", "www.sefaznet.ac.gov.br/nfce/consulta" }, ;
   { "SP", "1.00P", "https://www.nfce.fazenda.sp.gov.br/consulta" }, ;
   { "PR", "1.00P", "http://www.fazenda.pr.gov.br" }, ;
   { "RR", "1.00P", "https://www.sefaz.rr.gov.br/nfce/servlet/wp_consulta_nfce" }, ;
   ;
   { "AC", "1.00H", "http://hml.sefaznet.ac.gov.br/nfce/consulta" }, ;
   { "SP", "1.00H", "http://www.homologacao.nfce.fazenda.sp.gov.br/consulta" }, ;
   { "PR", "1.00H", "http://www.fazenda.pr.gov.br" }, ;
   { "RR", "1.00H", "http://www.sefaz.rr.gov.br/nfce/servlet/wp_consulta_nfce" }, ;
   ;
   { "AC", "2.00H", "www.sefaznet.ac.gov.br/nfce/consulta" }, ;
   { "SP", "2.00H", "https://www.homologacao.nfce.fazenda.sp.gov.br/consulta" }, ;
   { "RR", "2.00H", "http://www.sefaz.rr.gov.br/nfce/consulta" }, ;
   { "PR", "2.00H", "http://www.fazenda.pr.gov.br/nfce/consulta" }, ;
   ;
   { "AC", "2.00P", "www.sefaznet.ac.gov.br/nfce/consulta" }, ;
   { "SP", "2.00P", "https://www.nfce.fazenda.sp.gov.br/consulta" }, ;
   { "RR", "2.00P", "http://www.sefaz.rr.gov.br/nfce/consulta" }, ;
   { "PR", "2.00P", "http://www.fazenda.pr.gov.br/nfce/consulta" } }

#define WS_NFE_CONSULTAGTIN { ;
   { "**", "1.00P", "https://dfe-servico.svrs.rs.gov.br/ws/ccgConsGTIN/ccgConsGTIN.asmx" } }
