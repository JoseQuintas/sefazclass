/*
ZE_SEFAZ_GNRELOTE - GNRE do DIFAL a partir do XML da NF-e autorizada
2026.11 José Quintas

ze_GnreLoteDifal( aXmlNFe, dPagamento ) --> cXml do lote (TLote_GNRE versão 2.00)
   aXmlNFe    = array com o XML de cada NF-e autorizada (procNFe ou NFe)
   dPagamento = data de vencimento/pagamento das guias (padrão: hoje)
   Para cada NF-e: guia do DIFAL (receita 100102, vICMSUFDest) e do FCP (receita 100129, vFCPUFDest).
   Na UF sem receita própria de FCP, o FCP vai na guia do DIFAL como valor do fundo de pobreza.
   ES, MS e PB não recebem o DIFAL por GNRE: a nota fica fora do lote.
   O lote pode ser enviado pelo portal (Lote > Processar) ou pelo webservice GnreLoteRecepcao.

ze_GnreGuiaDifal( cXmlNFe, dPagamento ) --> cXml das guias (TDadosGNRE) da NF-e, vazio se não tem DIFAL

Regras por UF tiradas das tabelas do Portal GNRE (Consultar Configurações das UF's) em 2026-11-05:
   documento de origem aceito e campos extras.
*/

#define GNRE_RECEITA_DIFAL "100102"
#define GNRE_RECEITA_FCP   "100129"

FUNCTION ze_GnreLoteDifal( aXmlNFe, dPagamento )

   LOCAL cXml := "", cXmlNFe

   hb_Default( @dPagamento, Date() )

   FOR EACH cXmlNFe IN aXmlNFe
      cXml += ze_GnreGuiaDifal( cXmlNFe, dPagamento )
   NEXT
   IF Empty( cXml )
      RETURN ""
   ENDIF

   RETURN [<TLote_GNRE xmlns="http://www.gnre.pe.gov.br" versao="2.00">] + ;
      XmlTag( "guias", cXml, , .F. ) + ;
      [</TLote_GNRE>]

FUNCTION ze_GnreGuiaDifal( cXmlNFe, dPagamento )

   LOCAL cIde, cEmit, cDest, cTotal, cUF, nDifal, nFcp, cXml := "", hNFe

   hb_Default( @dPagamento, Date() )

   cIde   := XmlNode( cXmlNFe, "ide" )
   cEmit  := XmlNode( cXmlNFe, "emit" )
   cDest  := XmlNode( cXmlNFe, "dest" )
   cTotal := XmlNode( cXmlNFe, "ICMSTot" )
   cUF    := XmlNode( XmlNode( cDest, "enderDest" ), "UF" )
   nDifal := Val( XmlNode( cTotal, "vICMSUFDest" ) )
   nFcp   := Val( XmlNode( cTotal, "vFCPUFDest" ) )
   IF nDifal + nFcp <= 0 .OR. Empty( GnreUF( cUF ) )
      RETURN ""
   ENDIF

   hNFe := { "ide" => cIde, "emit" => cEmit, "dest" => cDest, "uf" => cUF, "data" => dPagamento, ;
      "chave" => XmlNode( cXmlNFe, "chNFe" ) }
   IF Empty( hNFe[ "chave" ] )
      hNFe[ "chave" ] := SoNumero( XmlElement( cXmlNFe, "Id" ) )
   ENDIF

   IF GnreUF( cUF )[ 3 ] .AND. nFcp > 0
      // FCP em guia própria
      IF nDifal > 0
         cXml += GnreGuia( hNFe, GNRE_RECEITA_DIFAL, nDifal, 0 )
      ENDIF
      cXml += GnreGuia( hNFe, GNRE_RECEITA_FCP, nFcp, 0 ) // na receita do FCP o valor é o principal
   ELSE
      cXml += GnreGuia( hNFe, GNRE_RECEITA_DIFAL, nDifal, nFcp )
   ENDIF

   RETURN cXml

STATIC FUNCTION GnreGuia( hNFe, cReceita, nIcms, nFcp )

   LOCAL cEnder, cEnderDest, cDocDest, cItem, cTipoDoc, cExtra := "", aCampo, xValor, cDetalhe, cProduto

   cEnder     := XmlNode( hNFe[ "emit" ], "enderEmit" )
   cEnderDest := XmlNode( hNFe[ "dest" ], "enderDest" )
   IF ! Empty( XmlNode( hNFe[ "dest" ], "CNPJ" ) )
      cDocDest := XmlTag( "CNPJ", XmlNode( hNFe[ "dest" ], "CNPJ" ) )
   ELSE
      cDocDest := XmlTag( "CPF", XmlNode( hNFe[ "dest" ], "CPF" ) )
   ENDIF
   cTipoDoc := GnreUF( hNFe[ "uf" ] )[ 1 ]
   IF HB_ISHASH( cTipoDoc ) // documento diferente por receita
      cTipoDoc := hb_HGetDef( cTipoDoc, cReceita, "10" )
   ENDIF
   cDetalhe := hb_HGetDef( GnreUF( hNFe[ "uf" ] )[ 4 ], cReceita, "" )
   cProduto := iif( Len( GnreUF( hNFe[ "uf" ] ) ) < 5, "", hb_HGetDef( GnreUF( hNFe[ "uf" ] )[ 5 ], cReceita, "" ) )
   FOR EACH aCampo IN GnreUF( hNFe[ "uf" ] )[ 2 ]
      IF aCampo[ 1 ] == cReceita
         DO CASE
         CASE aCampo[ 3 ] == "chave" ; xValor := hNFe[ "chave" ]
         CASE aCampo[ 3 ] == "data"  ; xValor := Left( XmlNode( hNFe[ "ide" ], "dhEmi" ), 10 )
         OTHERWISE                   ; xValor := "NF " + XmlNode( hNFe[ "ide" ], "nNF" ) // TO aceita 15 caracteres
         ENDCASE
         cExtra += XmlTag( "campoExtra", XmlTag( "codigo", aCampo[ 2 ] ) + XmlTag( "valor", xValor ), , .F. )
      ENDIF
   NEXT

   cItem := ;
      XmlTag( "receita", cReceita ) + ;
      iif( Empty( cDetalhe ), "", XmlTag( "detalhamentoReceita", cDetalhe ) ) + ;
      [<documentoOrigem tipo="] + cTipoDoc + [">] + ;
         iif( cTipoDoc == "10", XmlNode( hNFe[ "ide" ], "nNF" ), hNFe[ "chave" ] ) + [</documentoOrigem>] + ;
      iif( Empty( cProduto ), "", XmlTag( "produto", cProduto ) ) + ;
      XmlTag( "referencia", XmlTag( "periodo", "0" ) + ;
         XmlTag( "mes", Substr( XmlNode( hNFe[ "ide" ], "dhEmi" ), 6, 2 ) ) + ;
         XmlTag( "ano", Left( XmlNode( hNFe[ "ide" ], "dhEmi" ), 4 ) ), , .F. ) + ;
      XmlTag( "dataVencimento", hNFe[ "data" ] ) + ;
      iif( nIcms > 0, [<valor tipo="11">] + NumberXml( nIcms, 2 ) + [</valor>], "" ) + ;
      iif( nFcp > 0,  [<valor tipo="12">] + NumberXml( nFcp, 2 ) + [</valor>], "" ) + ;
      XmlTag( "contribuinteDestinatario", ;
         XmlTag( "identificacao", cDocDest, , .F. ) + ;
         XmlTag( "razaoSocial", Left( XmlNode( hNFe[ "dest" ], "xNome" ), 60 ) ) + ;
         XmlTag( "municipio", Right( XmlNode( cEnderDest, "cMun" ), 5 ) ), , .F. ) + ;
      iif( Empty( cExtra ), "", XmlTag( "camposExtras", cExtra, , .F. ) )

   RETURN [<TDadosGNRE versao="2.00">] + ;
      XmlTag( "ufFavorecida", hNFe[ "uf" ] ) + ;
      XmlTag( "tipoGnre", "0" ) + ;
      XmlTag( "contribuinteEmitente", ;
         XmlTag( "identificacao", XmlTag( "CNPJ", XmlNode( hNFe[ "emit" ], "CNPJ" ) ), , .F. ) + ;
         XmlTag( "razaoSocial", Left( XmlNode( hNFe[ "emit" ], "xNome" ), 60 ) ) + ;
         XmlTag( "endereco", Left( XmlNode( cEnder, "xLgr" ) + ", " + XmlNode( cEnder, "nro" ), 60 ) ) + ;
         XmlTag( "municipio", Right( XmlNode( cEnder, "cMun" ), 5 ) ) + ;
         XmlTag( "uf", XmlNode( cEnder, "UF" ) ) + ;
         XmlTag( "cep", XmlNode( cEnder, "CEP" ) ) + ;
         iif( Empty( XmlNode( cEnder, "fone" ) ), "", XmlTag( "telefone", XmlNode( cEnder, "fone" ) ) ), , .F. ) + ;
      XmlTag( "itensGNRE", XmlTag( "item", cItem, , .F. ), , .F. ) + ;
      XmlTag( "valorGNRE", nIcms + nFcp ) + ;
      XmlTag( "dataPagamento", hNFe[ "data" ] ) + ;
      [</TDadosGNRE>]

/*
UF --> { tipo do documento de origem, { { receita, código do campo extra, conteúdo } }, FCP em receita própria, { receita => detalhamento }, { receita => produto } }
documento de origem: 10 = número da nota, 22 = chave da NF-e, 24 = chave do DF-e ({ receita => tipo } quando muda por receita)
conteúdo do campo extra: chave = chave da NF-e, data = data de emissão, obs = número da nota
MA: produto 34 = Indústria não especificados
GO: recusou o FCP junto com o DIFAL (valor total diferente do principal), pendente
ES, MS e PB: não usam GNRE para o DIFAL
*/
STATIC FUNCTION GnreUF( cUF )

   STATIC hUF := { ;
      "AC" => { "10", { { "100102", "149", "chave" } }, .F., { "100102" => "000055" } }, ;
      "AL" => { "22", {}, .T., { "100129" => "000079" } }, ;
      "AM" => { "22", { { "100102", "115", "chave" } }, .T., {=>} }, ;
      "AP" => { "10", { { "100102", "49", "chave" } }, .F., {=>} }, ;
      "BA" => { "22", {}, .T., {=>} }, ;
      "CE" => { "10", {}, .T., {=>} }, ;
      "DF" => { "10", {}, .T., {=>} }, ;
      "GO" => { "10", { { "100102", "121", "chave" } }, .F., {=>} }, ;
      "MA" => { { "100102" => "10", "100129" => "22" }, { { "100102", "113", "chave" } }, .T., { "100102" => "000055" }, { "100102" => "34" } }, ;
      "MG" => { "10", {}, .T., { "100129" => "000051" } }, ;
      "MT" => { "22", {}, .T., { "100102" => "000055", "100129" => "000057" } }, ;
      "PA" => { "24", {}, .F., {=>} }, ;
      "PE" => { "24", {}, .F., {=>} }, ;
      "PI" => { "10", {}, .T., {=>} }, ;
      "PR" => { "10", { { "100102", "66", "chave" } }, .F., {=>} }, ;
      "RJ" => { "24", { { "100102", "132", "data" } }, .F., {=>} }, ;
      "RN" => { "22", { { "100129", "116", "chave" } }, .T., {=>} }, ;
      "RO" => { "10", { { "100102", "52", "chave" } }, .F., {=>} }, ;
      "RR" => { "10", { { "100102", "50", "chave" } }, .F., {=>} }, ;
      "RS" => { "22", { { "100102", "91", "chave" }, { "100129", "91", "chave" } }, .T., {=>} }, ;
      "SC" => { "24", { { "100102", "96", "chave" } }, .F., {=>} }, ;
      "SE" => { "10", { { "100102", "89", "chave" }, { "100129", "89", "chave" } }, .T., {=>} }, ;
      "TO" => { "10", { { "100102", "107", "chave" }, { "100102", "106", "obs" }, ;
                        { "100129", "107", "chave" }, { "100129", "106", "obs" } }, .T., {=>} } }

   RETURN hb_HGetDef( hUF, cUF, {} )
