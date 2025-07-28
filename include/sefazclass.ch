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

#define XML_UTF8                   [<?xml version="1.0" encoding="UTF-8"?>]

#define WS_RETORNA_RECIBO "0"
#define WS_RETORNA_PROTOCOLO "1"

#define WS_BPE_DEFAULT  "1.00"
#define WS_NFE_DEFAULT  "4.00"
#define WS_CTE_DEFAULT  "4.00"
#define WS_MDFE_DEFAULT "3.00"

#define WS_BPE_RECEPCAO { ;
   ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeRecepcao" }, ;
   { "MS",   "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeConsulta" }, ;
   { "PR",   "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BPeRecepcao" }, ;
   { "SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ws/bpeRecepcao/bpeRecepcao.asmx" } }

#define WS_BPE_QRCODE { ;
   ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/portalbpe/sistema/qrcode.xhtml" }, ;
   { "MS",   "1.00P", "http://www.dfe.ms.gov.br/qrcode" }, ;
   { "PR",   "1.00P", "https://www.fazenda.pr.gov.br/qrcode" }, ;
   { "SVRS", "1.00P", "https://bpe-portal.sefazvirtual.rs.gov.br/bpe/qrCode" } }

#define WS_BPE_RECEPCAOEVENTO { ;
   ;
   { "MG",   "1.00P", "https://bpe.fazenda.mg.gov.br/bpe/services/BPeRecepcaoEvento" }, ;
   { "MS",   "1.00P", "https://bpe.fazenda.ms.gov.br/ws/BPeRecepcaoEvento" }, ;
   { "PR",   "1.00P", "https://bpe.fazenda.pr.gov.br/bpe/BPeRecepcaoEvento" }, ;
   { "SVRS", "1.00P", "https://bpe.svrs.rs.gov.br/ws/bpeRecepcaoEvento.asmx" } }

#define WS_CTE_QRCODE { ;
   ;
   { "SP",   "3.00P", "https://nfe.fazenda.sp.gov.br/CTeConsulta/qrCode" }, ;
   { "PR",   "3.00P", "http://www.fazenda.pr.gov.br/cte/qrcode" }, ;
   { "MS",   "3.00P", "http://www.dfe.ms.gov.br/cte/qrcode" }, ;
   { "MT",   "3.00P", "https://www.sefaz.mt.gov.br/cte/qrcode" }, ;
   { "MG",   "3.00P", "https://cte.fazenda.mg.gov.br/portalcte/sistema/qrcode.xhtml" }, ;
   { "RS",   "3.00P", "https://dfe-portal.svrs.rs.gov.br/cte/qrCode" }, ;
   { "PI",   "3.00P", "http://www.sefaz.pi.gov.br/nfce/qrcode" }, ;
   { "SVSP", "3.00P", "https://nfe.fazenda.sp.gov.br/CTeConsulta/qrCode" }, ;
   { "SVRS", "3.00P", "https://dfe-portal.svrs.rs.gov.br/cte/qrCode" }, ;
   ;
   { "SVRS", "3.00H", "https://dfe-portal.svrs.rs.gov.br/cte/qrCode" }, ;
   { "SVSP", "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeConsulta/qrCode" }, ;
   { "RS",   "3.00H", "https://dfe-portal.svrs.rs.gov.br/cte/qrCode" }, ;
   { "PI",   "3.00H", "http://www.sefaz.pi.gov.br/nfce/qrcode" }, ;
   { "MG",   "3.00H", "https://cte.fazenda.mg.gov.br/portalcte/sistema/qrcode.xhtml" }, ;
   { "MT",   "3.00H", "https://homologacao.sefaz.mt.gov.br/cte/qrcode" }, ;
   { "MS",   "3.00H", "http://www.dfe.ms.gov.br/cte/qrcode" }, ;
   { "PR",   "3.00H", "http://www.fazenda.pr.gov.br/cte/qrcode" }, ;
   { "SP",   "3.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeConsulta/qrCode" }, ;
   ;
   { "SP", "4.00P", "https://nfe.fazenda.sp.gov.br/CTeConsulta/qrCode" }, ;
   { "PR", "4.00P", "http://www.fazenda.pr.gov.br/cte/qrcode" }, ;
   ;
   { "SP", "4.00H", "https://homologacao.nfe.fazenda.sp.gov.br/CTeConsulta/qrCode" }, ;
   { "PR", "4.00H", "http://www.fazenda.pr.gov.br/cte/qrcode" } }

#define WS_MDFE_QRCODE { ;
   ;
   { "**", "3.00P", "https://dfe-portal.svrs.rs.gov.br/mdfe/qrCode" }, ;
   ;
   { "**", "3.00H", "https://dfe-portal.svrs.rs.gov.br/mdfe/qrCode" } }

#define WS_NFE_QRCODE { ;
   ;
   { "PR",   "3.10H", "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe" }, ;
   { "SE",   "3.10H", "http://www.hom.nfe.se.gov.br/portal/consultarNFCe.jsp" }, ;
   ;
   { "PR",   "3.10P", "http://www.dfeportal.fazenda.pr.gov.br/dfe-portal/rest/servico/consultaNFCe" }, ;
   { "SE",   "3.10P", "http://www.nfce.se.gov.br/portal/consultarNFCe.jsp" }, ;
   { "SP",   "3.10P", "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx" }, ;
   ;
   { "AC",   "4.00H", "http://www.hml.sefaznet.ac.gov.br/nfce/qrcode" }, ;
   { "AL",   "4.00H", "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp" }, ;
   { "AM",   "4.00H", "http://homnfce.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp" }, ;
   { "AP",   "4.00H", "https://www.sefaz.ap.gov.br/nfcehml/nfce.php" }, ;
   { "BA",   "4.00H", "http://hnfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
   { "CE",   "4.00H", "http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
   { "DF",   "4.00H", "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
   { "ES",   "4.00H", "http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx" }, ;
   { "GO",   "4.00H", "https://nfewebhomolog.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe" }, ;
   { "MA",   "4.00H", "http://homologacao.sefaz.ma.gov.br/portal/consultarNFCe.jsp" }, ;
   { "MG",   "4.00H", "https://portalsped.fazenda.mg.gov.br/portalnfce/sistema/qrcode.xhtml" }, ;
   { "MS",   "4.00H", "http://www.dfe.ms.gov.br/nfce/qrcode" }, ;
   { "MT",   "4.00H", "http://homologacao.sefaz.mt.gov.br/nfce/consultanfce" }, ;
   { "PA",   "4.00H", "https://appnfc.sefa.pa.gov.br/portal-homologacao/view/consultas/nfce/nfceForm.seam" }, ;
   { "PB",   "4.00H", "http://www.receita.pb.gov.br/nfcehom" }, ;
   { "PR",   "4.00H", "http://www.fazenda.pr.gov.br/nfce/qrcode" }, ;
   { "PE",   "4.00H", "http://nfcehomolog.sefaz.pe.gov.br/nfce/consulta" }, ;
   { "PI",   "4.00H", "http://webas.sefaz.pi.gov.br/nfceweb-homologacao/consultarNFCe.jsf" }, ;
   { "RJ",   "4.00H", "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode" }, ;
   { "RN",   "4.00H", "http://hom.nfce.set.rn.gov.br/consultarNFCe.aspx" }, ;
   { "RO",   "4.00H", "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp" }, ;
   { "RR",   "4.00H", "https://www.sefaz.rr.gov.br/nfce/servlet/wp_consulta_nfce" }, ;
   { "RS",   "4.00H", "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx" }, ;
   { "SP",   "4.00H", "https://www.homologacao.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx" }, ;
   { "TO",   "4.00H", "http://apps.sefaz.to.gov.br/portal-nfce-homologacao/qrcodeNFCe"  }, ;
   ;
   { "AC",   "4.00P", "http://www.sefaznet.ac.gov.br/nfce/qrcode" }, ;
   { "AL",   "4.00P", "http://nfce.sefaz.al.gov.br/QRCode/consultarNFCe.jsp" }, ;
   { "BA",   "4.00P", "http://nfe.sefaz.ba.gov.br/servicos/nfce/modulos/geral/NFCEC_consulta_chave_acesso.aspx" }, ;
   { "CE",   "4.00H", "http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html" }, ;
   { "DF",   "4.00P", "http://dec.fazenda.df.gov.br/ConsultarNFCe.aspx" }, ;
   { "GO",   "4.00P", "https://nfeweb.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe" }, ;
   { "MA",   "4.00P", "http://www.nfce.sefaz.ma.gov.br/portal/consultarNFCe.jsp" }, ;
   { "MG",   "4.00P", "https://portalsped.fazenda.mg.gov.br/portalnfce/sistema/qrcode.xhtml" }, ;
   { "MS",   "4.00P", "http://www.dfe.ms.gov.br/nfce/qrcode" }, ;
   { "MT",   "4.00P", "http://www.sefaz.mt.gov.br/nfce/consultanfce" }, ;
   { "PA",   "4.00P", "https://appnfc.sefa.pa.gov.br/portal/view/consultas/nfce/nfceForm.seam" }, ;
   { "PB",   "4.00P", "http://www.receita.pb.gov.br/nfce" }, ;
   { "PE",   "4.00P", "http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe" }, ;
   { "PI",   "4.00P", "http://webas.sefaz.pi.gov.br/nfceweb/consultarNFCe.jsf" }, ;
   { "PR",   "4.00P", "http://www.fazenda.pr.gov.br/nfce/qrcode" }, ;
   { "RJ",   "4.00P", "http://www4.fazenda.rj.gov.br/consultaNFCe/QRCode" }, ;
   { "RN",   "4.00P", "http://nfce.set.rn.gov.br/consultarNFCe.aspx" }, ;
   { "RS",   "4.00P", "https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx" }, ;
   { "RO",   "4.00P", "http://www.nfce.sefin.ro.gov.br/consultanfce/consulta.jsp" }, ;
   { "RR",   "4.00P", "https://www.sefaz.rr.gov.br/nfce/servlet/qrcode" }, ;
   { "SE",   "4.00P", "http://www.nfe.se.gov.br/portal/consultarNFCe.jsp" }, ;
   { "SP",   "4.00P", "https://www.nfce.fazenda.sp.gov.br/NFCeConsultaPublica/Paginas/ConsultaQRCode.aspx" }, ;
   { "TO",   "4.00P", "http://apps.sefaz.to.gov.br/portal-nce/qrcodeNFCe" } }

#define WS_NFE_CHAVE { ;
   ;
   { "AC", "2.00H", "http://www.sefaznet.ac.gov.br/nfce/consulta" }, ;
   { "AL", "2.00H", "http://www.sefaz.al.gov.br/nfce/consulta" }, ;
   { "AM", "2.00H", "http://www.sefaz.am.gov.br/nfce/consulta" }, ;
   { "AP", "2.00H", "https://www.sefaz.ap.gov.br/nfce/consulta" }, ;
   { "BA", "2.00H", "http://hinternet.sefaz.ba.gov.br/nfce/consulta" }, ;
   { "CE", "2.00H", "http://www.sefaz.ce.gov.br/nfce/consulta" }, ;
   { "DF", "2.00H", "http://www.fazenda.df.gov.br/nfce/consulta" }, ;
   { "ES", "2.00H", "http://www.sefaz.es.gov.br/nfce/consulta" }, ;
   { "GO", "2.00H", "http://www.sefaz.go.gov.br/nfce/consulta" }, ;
   { "MA", "2.00H", "http://www.sefaz.ma.gov.br/nfce/consulta" }, ;
   { "MG", "2.00H", " https://hportalsped.fazenda.mg.gov.br/portalnfce" }, ;
   { "MS", "2.00H", "http://www.dfe.ms.gov.br/nfce/consulta" }, ;
   { "MT", "2.00H", "http://www.sefaz.mt.gov.br/nfce/consultanfce" }, ;
   { "PA", "2.00H", "http://www.sefa.pa.gov.br/nfce/consulta" }, ;
   { "PE", "2.00H", "http://nfce.sefaz.pe.gov.br/nfce/consulta" }, ;
   { "PI", "2.00H", "http://www.sefaz.pi.gov.br/nfce/consulta" }, ;
   { "PR", "2.00H", "http://www.fazenda.pr.gov.br/nfce/consulta" }, ;
   { "RJ", "2.00H", "http://www.fazenda.rj.gov.br/nfce/consulta" }, ;
   { "RR", "2.00H", "http://www.sefaz.rr.gov.br/nfce/consulta" }, ;
   { "RS", "2.00H", "http://www.sefaz.rs.gov.br/nfce/consulta" }, ;
   { "SP", "2.00H", "https://www.homologacao.nfce.fazenda.sp.gov.br/consulta" }, ;
   ;
   { "AC", "2.00P", "http://www.sefaznet.ac.gov.br/nfce/consulta" }, ;
   { "AL", "2.00P", "http://www.sefaz.al.gov.br/nfce/consulta" }, ;
   { "AM", "2.00P", "http://www.sefaz.am.gov.br/nfce/consulta" }, ;
   { "AP", "2.00P", "https://www.sefaz.ap.gov.br/nfce/consulta" }, ;
   { "BA", "2.00P", "http://www.sefaz.ba.gov.br/nfce/consulta" }, ;
   { "CE", "2.00P", "http://www.sefaz.ce.gov.br/nfce/consulta" }, ;
   { "DF", "2.00P", "http://www.fazenda.df.gov.br/nfce/consulta" }, ;
   { "GO", "2.00P", "http://www.sefaz.go.gov.br/nfce/consulta" }, ;
   { "MA", "2.00P", "http://www.sefaz.ma.gov.br/nfce/consulta" }, ;
   { "MG", "2.00P", "http://portalsped.fazenda.mg.gov.br/portalnfce" }, ;
   { "MS", "2.00P", "http://www.dfe.ms.gov.br/nfce/consulta" }, ;
   { "MT", "2.00P", "http://www.sefaz.mt.gov.br/nfce/consultanfce" }, ;
   { "PA", "2.00P", "http://www.sefa.pa.gov.br/nfce/consulta" }, ;
   { "PE", "2.00P", "http://nfce.sefaz.pe.gov.br/nfce/consulta" }, ;
   { "PI", "2.00P", "http://www.sefaz.pi.gov.br/nfce/consulta" }, ;
   { "PR", "2.00P", "http://www.fazenda.pr.gov.br/nfce/consulta" }, ;
   { "RJ", "2.00P", "http://www.fazenda.rj.gov.br/nfce/consulta" }, ;
   { "RR", "2.00P", "http://www.sefaz.rr.gov.br/nfce/consulta" }, ;
   { "RS", "2.00P", "http://www.sefaz.rs.gov.br/nfce/consulta" }, ;
   { "SP", "2.00P", "https://www.nfce.fazenda.sp.gov.br/consulta" } }
