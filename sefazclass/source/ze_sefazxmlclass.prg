/*
ZE_SPEDXMLCLASS - CLASSES PARA NFE/CTE/MDFE/CCE
2010.07.19 José Quintas

2018.07.26 - Uso de MultipleNodeToArray - Tem nota com 1 unico produto começando em 17
*/

#include "hbclass.ch"
#include "sefazclass.ch"

CREATE CLASS NfeCadastroClass STATIC

   VAR  Nome                INIT ""
   VAR  Cnpj                INIT ""
   VAR  InscricaoEstadual   INIT ""
   VAR  InscricaoMunicipal  INIT ""
   VAR  CNAE                INIT ""
   VAR  Endereco            INIT ""
   VAR  Numero              INIT ""
   VAR  Complemento         INIT ""
   VAR  Bairro              INIT ""
   VAR  Cidade              INIT ""
   VAR  CidadeIbge          INIT ""
   VAR  Uf                  INIT ""
   VAR  Cep                 INIT ""
   VAR  Pais                INIT ""
   VAR  PaisBACEN           INIT ""
   VAR  Telefone            INIT ""

   ENDCLASS

CREATE CLASS NfeEnderecoEntregaClass STATIC

   VAR  Cnpj        INIT ""
   VAR  Endereco    INIT ""
   VAR  Numero      INIT ""
   VAR  Compl       INIT ""
   VAR  Bairro      INIT ""
   VAR  Cidade      INIT ""
   VAR  CidadeIbge  INIT ""
   VAR  Uf          INIT ""

   ENDCLASS

CREATE CLASS NfeVolumesClass STATIC // From NfeTransporteClass

   VAR  Qtde         INIT 0
   VAR  Especie      INIT ""
   VAR  Marca        INIT ""
   VAR  PesoLiquido  INIT 0
   VAR  PesoBruto    INIT 0
   VAR  Numeros      INIT ""

   ENDCLASS

CREATE CLASS NfeTransporteClass STATIC

   VAR  Nome              INIT ""
   VAR  Cnpj              INIT ""
   VAR  InscricaoEstadual INIT ""
   VAR  Endereco          INIT ""
   VAR  Cidade            INIT ""
   VAR  CidadeIbge        INIT ""
   VAR  Uf                INIT ""
   VAR  Placa             INIT ""
   VAR  PlacaUf           INIT ""
   VAR  Volumes
   METHOD Init()

   ENDCLASS

METHOD Init() CLASS NfeTransporteClass

   ::Volumes := NfeVolumesClass():New()

   RETURN SELF

CREATE CLASS NfeTotaisClass STATIC

   VAR  IcmBas     INIT 0
   VAR  IcmVal     INIT 0
   VAR  SubBas     INIT 0
   VAR  SubVal     INIT 0
   VAR  MonBas    INIT 0
   VAR  MonVal    INIT 0
   VAR  IpiVal     INIT 0
   VAR  IIVal      INIT 0
   VAR  IssVal     INIT 0
   VAR  PisVal     INIT 0
   VAR  CofVal     INIT 0
   VAR  ValPro     INIT 0
   VAR  ValSeg     INIT 0
   VAR  ValFre     INIT 0
   VAR  ValDesc    INIT 0 // 2018.01.23 Jackson
   VAR  ValOut     INIT 0
   VAR  ValNot     INIT 0
   VAR  ValTrib    INIT 0 // 2018.01.23 Jackson
   VAR  VIcmsDeson INIT 0 // 2018.03.27 Jackson

   ENDCLASS

CREATE CLASS NfeIIClass STATIC

   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   ENDCLASS

CREATE CLASS NfeIpiClass STATIC

   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   ENDCLASS

CREATE CLASS NfeIssClass STATIC

   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   ENDCLASS

CREATE CLASS NfeIcmsClass STATIC

   VAR  Cst      INIT ""
   VAR  Base     INIT 0
   VAR  Reducao  INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0
   VAR  VDeson   INIT 0 // Jackson 2018/03/27

   ENDCLASS

CREATE CLASS NfeIcmsStClass STATIC

   VAR  Base      INIT 0
   VAR  IVA       INIT 0
   VAR  Reducao   INIT 0
   VAR  Aliquota  INIT 0
   VAR  Valor     INIT 0

   ENDCLASS

CREATE CLASS NfeIcmsMonoClass STATIC

   VAR Base     INIT 0
   VAR Aliquota INIT 0
   VAR Valor    INIT 0

   ENDCLASS

CREATE CLASS NfePisClass STATIC

   VAR  Cst      INIT ""
   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   ENDCLASS

CREATE CLASS NfeCofinsClass STATIC

   VAR  Cst      INIT ""
   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   ENDCLASS

CREATE CLASS NfeRastroClass STATIC

   VAR nLote INIT ""
   VAR qLote INIT 0
   VAR dFab  INIT Ctod("")
   VAR dVal  INIT Ctod("")

   ENDCLASS

CREATE CLASS NfeProdutoClass STATIC

   VAR  Codigo        INIT ""
   VAR  Nome          INIT ""
   VAR  CfOp          INIT ""
   VAR  NCM           INIT ""
   VAR  GTIN          INIT ""
   VAR  GTINTRIB      INIT ""
   VAR  CEST          INIT ""
   VAR  CBenef        INIT ""
   VAR  Anp           INIT ""
   VAR  Unidade       INIT ""
   VAR  UnidTrib      INIT "" // 2019.01.08 Fernando Queiroz
   VAR  Pedido        INIT "" // 2018.01.23 Jackson
   VAR  Qtde          INIT 0
   VAR  QtdeTrib      INIT 0
   VAR  ValorUnitario INIT 0
   VAR  ValUnitTrib   INIT 0 // 2019.01.08 Fernando Queiroz
   VAR  ValorTotal    INIT 0
   VAR  Desconto      INIT 0 // 2018.01.23 Jackson
   VAR  Icms
   VAR  IcmsSt
   VAR  IcmsMono
   VAR  Iss
   VAR  Ipi
   VAR  Pis
   VAR  Cofins
   VAR  II
   VAR  InfAdicional  INIT "" // 2018.01.23 Jackson
   VAR  Rastro        INIT {}
   METHOD Init()

   ENDCLASS

METHOD Init() CLASS NfeProdutoClass

   ::Icms     := NfeIcmsClass():New()
   ::IcmsSt   := NfeIcmsStClass():New()
   ::IcmsMono := NfeIcmsMonoClass():New()
   ::Iss      := NfeIssClass():New()
   ::II       := NfeIIClass():New()
   ::Ipi      := NfeIpiClass():New()
   ::Pis      := NfePisClass():New()
   ::Cofins   := NfeCofinsClass():New()

   RETURN SELF

CREATE CLASS NfePagamentosClass STATIC

   VAR  TipoPago    INIT ""  // 2018.01.23 Jackson
   VAR  ValorPago   INIT 0   // 2018.01.23 Jackson
   VAR  Integracao  INIT ""  // 2018.01.23 Jackson
   VAR  Cnpj_Ope    INIT ""  // 2018.01.23 Jackson
   VAR  Bandeira    INIT ""  // 2018.01.23 Jackson
   VAR  Autorizacao INIT ""  // 2018.01.23 Jackson

   END CLASS

CREATE CLASS NfeDuplicataClass STATIC

   VAR  Duplicata  INIT ""  // 2018.01.23 Jackson
   VAR  Vencimento INIT Ctod("" )
   VAR  Valor      INIT 0

   ENDCLASS

CREATE CLASS DocSpedClass STATIC

   VAR  cChave                  INIT ""
   VAR  cModFis                 INIT "" // 2014.11.20
   VAR  TipoNFe                 INIT "" // 2018.01.23 Jackson
   VAR  TipoEmissao             INIT "" // 2018.01.23 Jackson
   VAR  cEvento                 INIT "" // 2014.11.20
   VAR  Protocolo               INIT ""
   VAR  cNumDoc                 INIT ""
   VAR  cSerie                  INIT "" // 2018.01.23 Jackson
   VAR  DataEmissao             INIT Ctod( "" )
   VAR  DataHora                INIT ""  // 2018.01.23 Jackson
   VAR  DataSaida               INIT Ctod( "" )
   VAR  cAmbiente               INIT ""
   VAR  NaturezaOperacao        INIT ""
   VAR  Emitente             // --- init
   VAR  Destinatario         // --- init
   VAR  Remetente            // --- init // CTE
   VAR  EnderecoEntrega      // --- init
   VAR  Produto                 INIT {}
   VAR  Transporte           // --- init
   VAR  Duplicata               INIT {}
   VAR  Totais               // --- init
   VAR  ExportacaoUfEmbarque    INIT ""
   VAR  ExportacaoLocalEmbarque INIT ""
   VAR  InfAdicionais           INIT ""
   VAR  cAssinatura             INIT ""
   VAR  cSequencia              INIT "01" // Carta Correção
   VAR  Valor                   INIT 0  // CTE
   VAR  cErro                   INIT "" // Texto do erro
   VAR  PesoCarga               INIT 0  // Cte
   VAR  ValorCarga              INIT 0  // Cte
   VAR  Status                  INIT ""
   VAR  Pagamentos              INIT {} // 2018.01.23 Jackson
   METHOD Init()

   ENDCLASS

METHOD Init() CLASS DocSpedClass

   ::Emitente        := NfeCadastroClass():New()
   ::Destinatario    := NfeCadastroClass():New()
   ::Remetente       := NfeCadastroClass():New()
   ::EnderecoEntrega := NfeEnderecoEntregaClass():New()
   ::Transporte      := NfeTransporteClass():New()
   ::Totais          := NfeTotaisClass():New()

   RETURN SELF

FUNCTION XmlToDoc( cXmlInput, lAutorizado )

   LOCAL oDocSped

   hb_Default( @lAutorizado, .T. )

   IF ! ["] $ cXmlInput  // Petrobras usa aspas simples
      cXmlInput := StrTran( cXmlInput, ['], ["] )
   ENDIF
   oDocSped := DocSpedClass():New()
   DO CASE
   CASE "<ProcInutNFe" $ cXmlInput
      oDocSped:cModFis := "55"
      oDocSped:cEvento := "110999"
      XmlToDocNfeInut( cXmlInput, @oDocSped )
   CASE "<nfeProc" $ cXmlInput
      oDocSped:cModFis := "55"
      oDocSped:cEvento  := "110100"
      XmlToDocNfeEmi( cXmlInput, @oDocSped )
   CASE "<cteProc" $ cXmlInput .OR. "<procCTe" $ cXmlInput // proc=CTE 3.0
      oDocSped:cModFis := "57"
      oDocSped:cEvento  := "110100"
      XmlToDocCteEmi( cXmlInput, @oDocSped )
   CASE "<mdfeProc" $ cXmlInput
      oDocSped:cModFis := "58"
      oDocSped:cEvento  := "110100"
      XmlToDocMDFEEmi( cXmlInput, @oDocSped )
   CASE "<procEventoNFe" $ cXmlInput .AND. "<descEvento>Cancelamento" $ cXmlInput
      oDocSped:cModFis := "55"
      oDocSped:cEvento  := "110111"
      XmlToDocNfeCancel( cXmlInput, @oDocSped )
   CASE "<procEventoNFe" $ cXmlInput
      oDocSped:cModFis := "55"
      oDocSped:cEvento := XmlNode( cXmlInput, "tpEvento" )
      IF Len( SoNumeros( oDocSped:cEvento ) ) == 6
         XmlToDocNfeEvento( cXmlInput, @oDocSped )
      ENDIF
   CASE "<procCancNFe" $ cXmlInput .AND. "<xServ>CANCELAR" $ cXmlInput
      oDocSped:cModFis := "55"
      oDocSped:cEvento  := "110111"
      XmlToDocNFECancel( cXmlInput, @oDocSped )
   CASE "<procEventoCTe" $ cXmlInput .AND. "<descEvento>Cancelamento" $ cXmlInput
      oDocSped:cModFis := "57"
      oDocSped:cEvento  := "110111"
      XmlToDocCTeCancel( cXmlInput, @oDocSped )
   CASE "<procEventoMDFe" $ cXmlInput .AND. "<descEvento>Cancelamento" $ cXmlInput
      oDocSped:cModFis := "58"
      oDocSped:cEvento  := "110111"
      XmlToDocMDFECancel( cXmlInput, @oDocSped )
   CASE "<procEventoMDFe" $ cXmlInput
      oDocSped:cModFis := "58"
      oDocSped:cEvento  := XmlNode( cXmlInput, "tpEvento" ) // "110112"
      IF Len( SoNumeros( oDocSped:cEvento ) ) == 6
         XmlToDocMDFEEnc( cXmlInput, @oDocSped )
      ENDIF
   CASE "<infMDFe" $ cXmlInput
      oDocSped:cModFis := "58"
      oDocSped:cEvento  := "000000"
      XmlToDocMDFEEmi( cXmlInput, @oDocSped )
   CASE "<infCte" $ cXmlInput
      oDocSped:cModFis := "57"
      oDocSped:cEvento  := "000000"
      XmlToDocCteEmi( cXmlInput, @oDocSped )
   CASE "<infNFe" $ cXmlInput
      oDocSped:cModFis := "55"
      oDocSped:cEvento  := "000000"
      XmlToDocNfeEmi( cXmlInput, @oDocSped )
   //CASE "<infEvento" $ cXmlInput
   //   // pode ser pra qualquer documento
   //   oDocSped:cModFis := "XX"
   //   oDocSped:cEvento  := "XX"
   OTHERWISE
      oDocSped:cErro := "Documento não identificado"
   ENDCASE
   IF Empty( oDocSped:Destinatario:Cnpj ) .AND. Empty( oDocSped:Destinatario:Nome )
      oDocSped:Destinatario := oDocSped:Emitente
   ENDIF
   oDocSped:cChave := SoNumeros( oDocSped:cChave )
   IF Len( oDocSped:cChave ) == 44
      oDocSped:cModFis := DfeModFis( oDocSped:cChave )
      oDocSped:cSerie  := Substr( oDocSped:cChave, 23, 3 )
   ENDIF
   DO CASE
   CASE ! Empty( oDocSped:cErro )
   CASE Len( oDocSped:cChave ) != 44
      oDocSped:cErro := "Tamanho da chave de acesso inválido"
   CASE Right( oDocSped:cChave, 1 ) != CalculaDigito( Substr( oDocSped:cChave, 1, 43 ), "11" )
      oDocSped:cErro := "Dígito da chave de acesso inválido"
   CASE Substr( oDocSped:cChave, 5, 2 ) < "01" .OR. Substr( oDocSped:cChave, 5, 2 ) > "12"
      oDocSped:cErro := "Mes da chave inválido"
   CASE ! ValidCnpjCpf( DfeEmitente( oDocSped:cChave ) )
      oDocSped:cErro := "CNPJ inválido na chave de acesso"
   CASE Val( oDocSped:Protocolo ) == 0 .AND. lAutorizado
      oDocSped:cErro := "Sem protocolo"
   CASE Empty( oDocSped:cAssinatura ) .AND. lAutorizado
      oDocSped:cErro := "Sem assinatura"
   CASE oDocSped:cAmbiente != WS_AMBIENTE_PRODUCAO
      oDocSped:cErro := "Não é ambiente de produção"
   CASE oDocSped:cEvento = "110100" .AND. Empty( oDocSped:cNumDoc )
      oDocSped:cErro := "Número de documento vazio"
   ENDCASE
   IF ! Empty( oDocSped:cErro )
      oDocSped:cModFis := "XX"
      oDocSped:cEvento := "XXXXXX"
   ENDIF

   RETURN oDocSped

STATIC FUNCTION XmlToDocNfeEmi( cXmlInput, oDocSped )

   LOCAL aList, aList2
   LOCAL cBlocoInfNfeComTag, cBlocoChave, cBlocoIde, cBlocoInfAdic
   LOCAL cBlocoEmit, cBlocoEndereco, cBlocoDest, cBlocoTransporte, cBlocoTransp, cBlocoVeiculo, cBlocoVol, cBlocoTotal
   LOCAL cBlocoItem, cBlocoProd,  cBlocoIpi, cBlocoIcms, cBlocoPis, cBlocoCofins, cBlocoRastro
   LOCAL cBlocoComb, cBlocoCobranca, cBlocoDup, cBlocoPG

   cBlocoInfNfeComTag := XmlNode( cXmlInput, "infNFe", .T. )

   cBlocoChave := XmlElement( cBlocoInfNfeComTag, "Id" )
   cBlocoChave := Substr( cBlocoChave, 4 )
   cBlocoChave := AllTrim( cBlocoChave )
   IF Len( cBlocoChave ) <> 44
      oDocSped:cErro := "Chave de Acesso Inválida"
      RETURN Nil
   ENDIF
   WITH OBJECT oDocSped
      :cChave := cBlocoChave
      :cAssinatura := XmlNode( cXmlInput, "Signature" )
      cBlocoIde := XmlNode( cXmlInput, "ide" )
         :cNumDoc := XmlNode( cBlocoIde, "nNF" )
         IF Empty( oDocSped:cNumDoc )
            oDocSped:cErro := "Sem número de documento"
            RETURN Nil
         ENDIF
         :cNumDoc          := StrZero( Val( :cNumDoc ), 9 )
         :TipoNFe          := XmlNode( cBlocoIde, "tpNF" )  // 2018.02.23 Jackson
         :TipoEmissao      := XmlNode( cBlocoIde, "tpEmis" ) // 2018.01.23 Jackson
         :NaturezaOperacao := XmlNode( cBlocoIde, "natOp" ) // 2018.01.23 Jackson
         IF ! Empty( XmlDate( XmlNode( cBlocoIde, "dhEmi" ) ) )
            :DataHora    := XmlNode( cBlocoIde, "dEmi" ) // 2018.01.23 Jackson
            :DataEmissao := XmlDate( XmlNode( cBlocoIde, "dhEmi" ) )
            :DataSaida   := XmlDate( XmlNode( cBlocoIde, "dhSaiEnt" ) )
         ELSE
            :DataEmissao := XmlDate( XmlNode( cBlocoIde, "dEmi" ) )
            :DataSaida   := XmlDate( XmlNode( cBlocoIde, "dSaiEnt" ) )
         ENDIF
         IF Empty( :DataSaida )
            :DataSaida := oDocSped:DataEmissao
         ENDIF
         :cAmbiente := XmlNode( cBlocoIde, "tpAmb" )

      cBlocoInfAdic := XmlNode( cXmlInput, "InfAdic" )
         :InfAdicionais := XmlNode( cBlocoInfAdic, "InfCpl" )
   ENDWITH

   cBlocoEmit := XmlNode( cXmlInput, "emit" )
      WITH OBJECT oDocSped:Emitente
         :Cnpj              := Transform( DfeEmitente( oDocSped:cChave ), "@R 99.999.999/9999-99" )
         :Nome              := Upper( XmlNode( cBlocoEmit, "xNome" ) )
         :InscricaoEstadual := XmlNode( cBlocoEmit, "IE" )
         cBlocoEndereco := XmlNode( cBlocoEmit, "enderEmit" )
            :Endereco   := Upper( XmlNode( cBlocoEndereco, "xLgr" ) )
            :Numero     := XmlNode( cBlocoEndereco, "nro" )
            :Complemento:= XmlNode( cBlocoEndereco, "xCpl" )
            :Bairro     := Upper( XmlNode( cBlocoEndereco, "xBairro" ) )
            :CidadeIbge := XmlNode( cBlocoEndereco, "cMun" )
            :Cidade     := Upper( XmlNode( cBlocoEndereco, "xMun" ) )
            :Uf         := Upper( XmlNode( cBlocoEndereco, "UF" ) )
            :Cep        := Transform( XmlNode( cBlocoEndereco, "CEP" ), "@R 99999-999" )
            :Telefone   := XmlNode( cBlocoEndereco, "fone" )
         ENDWITH

      cBlocoDest := XmlNode( cXmlInput, "dest" )
      WITH OBJECT oDocSped:Destinatario
         :Cnpj := Trim( XmlNode( cBlocoDest, "CNPJ" ) )
         IF Len( Trim( :Cnpj ) ) = 0
            :Cnpj := XmlNode( cBlocoDest, "CPF" )
            :Cnpj := Transform( :Cnpj, "@R 999.999.999-99" )
         ELSE
            :Cnpj := Transform( :Cnpj, "@R 99.999.999/9999-99" )
         ENDIF
         :Nome := Upper( XmlNode( cBlocoDest, "xNome" ) )
         :InscricaoEstadual := XmlNode( cBlocoDest, "IE" )
         cBlocoEndereco := XmlNode( cBlocoDest, "enderDest" )
            :Endereco   := Upper( XmlNode( cBlocoEndereco, "xLgr" ) )
            :Numero     := XmlNode( cBlocoEndereco, "nro" )
            :Complemento:= XmlNode( cBlocoEndereco, "xCpl" )
            :Bairro     := Upper( XmlNode( cBlocoEndereco, "xBairro" ) )
            :CidadeIbge := XmlNode( cBlocoEndereco, "cMun" )
            :Cidade     := Upper( XmlNode( cBlocoEndereco, "xMun" ) )
            :Uf         := Upper( XmlNode( cBlocoEndereco, "UF" ) )
            :Cep        := Transform( XmlNode( cBlocoEndereco, "CEP" ), "@R 99999-999" )
            :Telefone   := XmlNode( cBlocoEndereco, "fone" )
      ENDWITH

   cBlocoTransporte := XmlNode( cXmlInput, "transp" )
      WITH OBJECT oDocSped:Transporte
         cBlocoTransp := XmlNode( cBlocoTransporte, "transporta" )
            :Cnpj              := Transform( XmlNode( cBlocoTransp, "CNPJ" ), "@R 99.999.999/9999-99" )
            :Nome              := Upper( XmlNode( cBlocoTransp, "xNome" ) )
            :InscricaoEstadual := XmlNode( cBlocoTransp, "IE" )
            :Endereco          := Upper( XmlNode( cBlocoTransp, "xEnder" ) )
            :Cidade            := Upper( XmlNode( cBlocoTransp, "xMun" ) )
            :Uf                := Upper( XmlNode( cBlocoTransp, "UF" ) )
         cBlocoVol := XmlNode( cBlocoTransporte, "vol" )
            :Volumes:Qtde        := Val( XmlNode( cBlocoVol, "qVol" ) )
            :Volumes:Especie     := Upper( XmlNode( cBlocoVol, "esp" ) )
            :Volumes:Marca       := Upper( XmlNode( cBlocoVol, "marca" ) )
            :Volumes:PesoLiquido := Val( XmlNode( cBlocoVol, "pesoL" ) )
            :Volumes:PesoBruto   := Val( XmlNode( cBlocoVol, "pesoB" ) )
            :Volumes:Numeros     := XmlNode( cBlocoVol, "nvol" ) // 2018.01.23 Jackson
         cBlocoVeiculo := XmlNode( cBlocoTransporte, "veicTransp" )
            :PlacaUf := Upper( XmlNode( cBlocoVeiculo, "UF" ) )
            :Placa   := Upper( XmlNode( cBlocoVeiculo, "placa" ) )
      ENDWITH

   cBlocoTotal := XmlNode( cXmlInput, "total" )
      WITH OBJECT oDocSped:Totais
         :IpiVal   := Val( XmlNode( cBlocoTotal, "vIPI" ) )
         :IIVal    := Val( XmlNode( cBlocoTotal, "vII" ) )
         :IcmBas   := Val( XmlNode( cBlocoTotal, "vBC" ) )
         :IcmVal   := Val( XmlNode( cBlocoTotal, "vICMS" ) )
         :SubBas   := Val( XmlNode( cBlocoTotal, "vBCST" ) )
         :SubVal   := Val( XmlNode( cBlocoTotal, "vST" ) )
         :MonBas   := Val( XmlNode( cBlocoTotal, "qBCMono" ) )
         :MonVal   := Val( XmlNode( cBlocoTotal, "vICMSMono" ) )
         :PisVal   := Val( XmlNode( cBlocoTotal, "vPIS" ) )
         :CofVal   := Val( XmlNode( cBlocoTotal, "vCOFINS" ) )
         :ValPro   := Val( XmlNode( cBlocoTotal, "vProd" ) )
         :ValSeg   := Val( XmlNode( cBlocoTotal, "vSeg" ) )
         :ValFre   := Val( XmlNode( cBlocoTotal, "vFrete" ) )
         :ValDesc  := Val( XmlNode( cBlocoTotal, "vDesc" ) ) // 2018.01.23 Jackson
         :ValOut   := Val( XmlNode( cBlocoTotal, "vOutro" ) )
         :ValNot   := Val( XmlNode( cBlocoTotal, "vNF" ) )
         :ValTrib  := Val( XmlNode( cBlocoTotal, "vTotTrib" ) ) // 2018.01.23 Jackson
      ENDWITH

   aList := MultipleNodeToArray( cXmlInput, "det" )
   FOR EACH cBlocoItem IN aList
      AAdd( oDocSped:Produto, NFEProdutoClass():New() )
      WITH OBJECT Atail( oDocSped:Produto )
         cBlocoProd := XmlNode( cBlocoItem, "prod" )
            :Codigo          := XmlNode( cBlocoProd, "cProd" )
            :Nome            := Upper( XmlNode( cBlocoProd, "xProd" ) )
            :CFOP            := Transform( XmlNode( cBlocoProd, "CFOP" ), "@R 9.9999" )
            :NCM             := XmlNode( cBlocoProd, "NCM" )
            :GTIN            := SoNumeros( XmlNode( cBlocoProd, "cEAN" ) )
            :GTINTrib        := SoNumeros( XmlNode( cBlocoProd, "cEANTrib" ) )
            :CEST            := SoNumeros( XmlNode( cBLocoProd, "CEST" ) )
            IF Empty( :GTINTrib )
               :GTINTrib := :GTIN
            ENDIF
            :CBenef          := XmlNode( cBlocoProd, "cBenef" )
            :Unidade         := Upper( XmlNode( cBlocoProd, "uCom" ) )
            :UnidTrib        := Upper( XmlNode( cBlocoProd, "uTrib" ) ) // 2019.01.08 Fernando Queiroz
            :Qtde            := Val( XmlNode( cBlocoProd, "qCom" ) )
            :QtdeTrib        := Val( XmlNode( cBlocoProd, "qTrib" ) ) // 2019.01.08 Fernando Queiroz
            :ValorUnitario   := Val( XmlNode( cBlocoProd, "vUnCom" ) )
            :ValUnitTrib     := Val( XmlNode( cBlocoProd, "vUnTrib" ) ) // 2019.01.08 Fernando Queiroz
            :ValorTotal      := Val( XmlNode( cBlocoProd, "vProd" ) )
            :Desconto        := Val( XmlNode( cBlocoProd, "vDesc" ) ) // 2018.01.23 Jackson
            :Pedido          := Val( XmlNode( cBlocoProd, "xPed" ) ) // 2018.01.23 Jackson
            :InfAdicional    := XmlNode( cBlocoProd, "infAdProd" ) // 2018.01.23 Jackson
         cBlocoIpi := XmlNode( cBlocoItem, "IPI" )
            :Ipi:Base        := Val( XmlNode( cBlocoIpi, "vBC" ) )
            :Ipi:Aliquota    := Val( XmlNode( cBlocoIpi, "pIPI" ) )
            :Ipi:Valor       := Val( XmlNode( cBlocoIpi, "vIPI" ) )
         cBlocoIcms := XmlNode( cBlocoItem, "ICMS" )
            :Icms:Cst     := XmlNode( cBlocoIcms, "orig" ) + XmlNode( cBlocoIcms, "CST" )
            IF Len( :Icms:Cst ) < 3
               :Icms:Cst     := XmlNode( cBlocoIcms, "orig" ) + XmlNode( cBlocoIcms, "CSOSN" )
            ENDIF
            :Icms:Base       := Val( XmlNode( cBlocoIcms, "vBC" ) )
            :Icms:Reducao    := Val( XmlNode( cBlocoIcms, "pRedBC" ) )
            :Icms:Aliquota   := Val( XmlNode( cBlocoIcms, "pICMS" ) )
            :Icms:Valor      := Val( XmlNode( cBlocoIcms, "vICMS" ) )
            :IcmsSt:Base     := Val( XmlNode( cBlocoIcms, "vBCST" ) )
            :IcmsSt:Iva      := Val( XmlNode( cBlocoIcms, "pMVAST" ) )
            :IcmsSt:Reducao  := Val( XmlNode( cBlocoIcms, "pRedBCST" ) )
            :IcmsSt:Aliquota := Val( XmlNode( cBlocoIcms, "pICMSST" ) )
            :IcmsSt:Valor    := Val( XmlNode( cBlocoIcms, "vICMSST" ) )
            :IcmsMono:Base   := Val( XmlNode( cBlocoIcms, "qBCMono" ) )
            :IcmsMono:Aliquota := Val( XmlNode( cBlocoIcms, "adRemICMS" ) )
            :IcmsMono:Valor  := Val( XmlNode( cBlocoIcms, "vICMSMono" ) )
         cBlocoPis := XmlNode( cBlocoItem, "PIS" )
            :Pis:Cst         := XmlNode( cBlocoPis, "CST" )
            :Pis:Base        := Val( XmlNode( cBlocoPis, "vBC" ) )
            :Pis:Aliquota    := Val( XmlNode( cBlocoPis, "pPIS" ) )
            :Pis:Valor       := Val( XmlNode( cBlocoPis, "vPIS" ) )
         cBlocoCofins := XmlNode( cBlocoItem, "COFINS" )
            :Cofins:Cst      := XmlNode( cBlocoCofins, "CST" )
            :Cofins:Base     := Val( XmlNode( cBlocoCofins, "vBC" ) )
            :Cofins:Aliquota := Val( XmlNode( cBlocoCofins, "pCOFINS" ) )
            :Cofins:Valor    := Val( XmlNode( cBlocoCofins, "vCOFINS" ) )
         cBlocoComb := XmlNode( cBlocoItem, "comb" )
            :Anp             := XmlNode( cBlocoComb, "cProdANP" )
         aList2 := MultipleNodeToArray( cBlocoItem, "rastro" )
            FOR EACH cBlocoRastro IN aList2
               AAdd( :Rastro, NfeRastroClass() )
               WITH OBJECT Atail( :Rastro )
                  :nLote := XmlNode( cBlocoRastro, "nLote" )
                  :qLote := Val( XmlNode( cBlocoRastro, "qLote" ) )
                  :dFab  := XmlDate( XmlNode( cBlocoRastro, "dFab" ) )
                  :dVal  := XmlDate( XmlNode( cBlocoRastro, "dVal" ) )
               ENDWITH
            NEXT
      ENDWITH
   NEXT

   cBlocoCobranca := XmlNode( cXmlInput, "cobr" )
   aList := MultipleNodeToArray( cBlocoCobranca, "dup" )
   FOR EACH cBlocoDup IN aList
      //cBlocoDup := XmlNode( cBlocoCobranca, "dup" )
      //IF Len( Trim( cBlocoDup ) ) = 0
      //   EXIT
      //ENDIF
      AAdd( oDocSped:Duplicata, NFEDuplicataClass():New() )
      WITH OBJECT Atail( oDocSped:Duplicata )
         :Duplicata  := XmlNode( cBlocoDup, "nDup" ) // 2018.01.23 Jackson
         :Vencimento := XmlDate( XmlNode( cBlocoDup, "dVenc" ) )
         :Valor      := Val( XmlNode( cBlocoDup, "vDup" ) )
      ENDWITH
   NEXT

   // Detalhes dos Blocos de Pagamentos na NFCe
   // 2018.02.23 Jackson
   aList := MultipleNodeToArray( cXmlInput, "pag" )
   FOR EACH cBlocoPG IN aList
      AAdd( oDocSped:Pagamentos, NfePagamentosClass():New() )
      WITH OBJECT Atail( oDocSped:Pagamentos )
         :TipoPago    := XmlNode( cBlocoPG, "tPag" )
         :ValorPago   := Val( XmlNode( cBlocoPG, "vPag" ) )
         :Integracao  := XmlNode( cBlocoPG, "tpIntegra" )
         :Cnpj_Ope    := XmlNode( cBlocoPG, "CNPJ" )
         :Bandeira    := XmlNode( cBlocoPG, "tBand" )
         :Autorizacao := XmlNode( cBlocoPG, "cAut" )
      ENDWITH
   NEXT

   WITH OBJECT oDocSPed
      :Protocolo := XmlNode( cXmlInput, "nProt" )
      :Status    := XmlNode( cXmlInput, "cStat" )
   ENDWITH

   RETURN Nil

STATIC FUNCTION XmlToDocNfeCancel( cXmlInput, oDocSped )

   LOCAL mChave, mProtocolo, mXmlInfComTag, mXmlInf

   IF "<infEvento" $ cXmlInput // Evento
      mChave := XmlNode( cXmlInput, "chNFe" )
      mProtocolo := XmlNode( XmlNode( cXmlInput, "retEvento" ), "nProt" )
      // tem o protocolo enviado para cancelamento, e o de retorno
   ELSE
      IF "retCancNFe" $ cXmlInput // Tem que ser antes do outro
         mXmlInf := XmlNode( cXmlInput, "infCanc" )
         mChave := XmlNode( mXmlInf, "chNFe" )
         mProtocolo := XmlNode( mXmlInf, "nProt" )
      ELSEIF "CancNFe" $ cXmlInput
         mXmlInfComTag := XmlNode( cXmlInput, "infCanc",.T. )
         mChave := XmlElement( mXmlInfComTag, "Id" )
         IF Substr( mChave,1, 2 ) == "ID"
            mChave := Substr( mChave, 3 )
         ENDIF
         mProtocolo := XmlNode( mXmlInfComTag, "nProt" )
      ELSE
         //SayScroll( "Formato do arquivo de cancelamento diferente. Avise JPA" )
         mChave := ""
         mProtocolo := ""
      End If
   ENDIF
   IF Len( AllTrim( mChave ) ) == 0
      oDocSped:cErro := "Sem chave de acesso"
      RETURN .F.
   ELSE
      oDocSped:cChave   := mChave
      oDocSped:Protocolo     := mProtocolo
      oDocSped:cAmbiente     := XmlNode( cXmlInput, "tpAmb" )
      oDocSped:Emitente:Cnpj := Transform( DfeEmitente( mChave ), "@R 99.999.999/9999-99" )
      oDocSped:cNumDoc       := DfeNumero( mChave )
      oDocSped:cAssinatura   := XmlNode( cXmlInput, "Signature" )
      oDocSped:Status        := "111"
   ENDIF

   RETURN Nil

STATIC FUNCTION XmlToDocNfeEvento( XmlInput, oDocSped )

   LOCAL mXmlProcEvento, mXmlEvento, mXmlInfEvento, mXmlRetEvento

   mXmlProcEvento := XmlNode( XmlInput, "procEventoNFe" )
      mXmlEvento := XmlNode( mXmlProcEvento, "evento" )
         mXmlInfEvento := XmlNode( mXmlEvento, "infEvento" )
            oDocSped:cAmbiente         := XmlNode( mXmlInfEvento, "tpAmb" )
            oDocSped:Emitente:Cnpj     := Transform( XmlNode( mXmlInfEvento, "CNPJ" ), "@R 99.999.999/9999-99" )
            oDocSped:Destinatario:Cnpj := oDocSped:Emitente:Cnpj
            oDocSped:cChave       := XmlNode( mXmlInfEvento, "chNFe" )
            //oDocSped:TipoEvento      := XmlNode( mXmlInfEvento, "tpEvento" )
            oDocSped:cSequencia        := StrZero( Val( XmlNode( mXmlInfEvento, "nSeqEvento" ) ), 2 )
            // mXmldetEvento           := XmlNode( mXmlInfEvento, "detEvento" )
               //oDocSped:Texto        := XmlNode( mXmlDetEvento, "xCorrecao" )
         oDocSped:cAssinatura          := XmlNode( mXmlEvento, "Signature" )
      mXmlRetEvento := XmlNode( mXmlProcEvento, "retEvento" )
         mXmlInfEvento := XmlNode( mXmlRetEvento, "infEvento" )
            //oDocSped:Status          := XmlNode( mXmlInfEvento, "cStat" )
            oDocSped:Protocolo         := XmlNode( mXmlInfEvento, "nProt" )

   RETURN Nil

STATIC FUNCTION XmlToDocMDFEEmi( cXmlInput, oMDFE )

   LOCAL cBlocoInfNfeComTag, cBlocoChave, cBlocoIde, cBlocoInfAdic
   LOCAL cBlocoEmit, cBlocoEndereco

   cXmlInput := XmlTransform( cXmlInput )

   cBlocoInfNfeComTag := XmlNode( cXmlInput, "infMDFe", .T. )

   cBlocoChave := XmlElement( cBlocoInfNfeComTag, "Id" )
   cBlocoChave := Substr( cBlocoChave, 5, 44 )
   cBlocoChave := AllTrim( cBlocoChave )
   IF Len( cBlocoChave ) <> 44
      oMDFE:cErro := "Chave de acesso inválida"
      RETURN Nil
   ENDIF
   oMDFE:cChave := cBlocoChave
   oMDFE:cAssinatura := XmlNode( cXmlInput, "Signature" )
   cBlocoIde := XmlNode( cXmlInput, "ide" )
      oMDFE:cNumDoc := XmlNode( cBlocoIde, "nMDF" )
      IF Len( Trim( oMDFE:cNumDoc ) ) = 0
         oMDFE:cErro := "Sem número de documento"
         RETURN Nil
      ENDIF
      oMDFE:cNumDoc     := StrZero( Val( oMDFE:cNumDoc ), 9 )
      oMDFE:DataEmissao := XmlDate( XmlNode( cBlocoIde, "dhEmi" ) )
      oMDFE:cAmbiente   := XmlNode( cBlocoIde, "tpAmb" )

   cBlocoInfAdic := XmlNode( cXmlInput, "InfAdic" )
      oMDFE:InfAdicionais := XmlNode( cBlocoInfAdic, "InfCpl" )

   cBlocoEmit := XmlNode( cXmlInput, "emit" )
      oMDFE:Emitente:Cnpj              := Trim( Transform( XmlNode( cBlocoEmit, "CNPJ" ), "@R 99.999.999/9999-99" ) )
      oMDFE:Emitente:Nome              := Upper( XmlNode( cBlocoEmit, "xNome" ) )
      oMDFE:Emitente:InscricaoEstadual := XmlNode( cBlocoEmit, "IE" )
      cBlocoEndereco := XmlNode( cBlocoEmit, "enderEmit" )
         oMDFE:Emitente:Endereco   := Upper( XmlNode( cBlocoEndereco, "xLgr" ) )
         oMDFE:Emitente:Numero     := XmlNode( cBlocoEndereco, "nro" )
         oMDFE:Emitente:Complemento:= XmlNode( cBlocoEndereco, "xCpl" )
         oMDFE:Emitente:Bairro     := Upper( XmlNode( cBlocoEndereco, "xBairro" ) )
         oMDFE:Emitente:CidadeIbge := XmlNode( cBlocoEndereco, "cMun" )
         oMDFE:Emitente:Cidade     := Upper( XmlNode( cBlocoEndereco, "xMun" ) )
         oMDFE:Emitente:Uf         := Upper( XmlNode( cBlocoEndereco, "UF" ) )
         oMDFE:Emitente:Cep        := Transform( XmlNode( cBlocoEndereco, "CEP" ), "@R 99999-999" )
         oMDFE:Emitente:Telefone   := XmlNode( cBlocoEndereco, "fone" )

   oMDFE:Protocolo := XmlNode( cXmlInput, "nProt" )
   oMDFE:Status    := XmlNode( cXmlInput, "cStat" )

   RETURN Nil

STATIC FUNCTION XmlToDocMDFEEnc( XmlInput, oDocSped )

   LOCAL mXmlProcEvento, mXmlEvento, mXmlInfEvento

   mXmlProcEvento := XmlNode( XmlInput, "procEventoMDFe" )
      mXmlEvento := XmlNode( mXmlProcEvento, "eventoMDFe" )
         mXmlInfEvento := XmlNode( mXmlEvento, "infEvento" )
            oDocSped:cAmbiente         := XmlNode( mXmlInfEvento, "tpAmb" )
            oDocSped:Emitente:Cnpj     := Transform( XmlNode( mXmlInfEvento, "CNPJ" ), "@R 99.999.999/9999-99" )
            oDocSped:Destinatario:Cnpj := oDocSped:Emitente:Cnpj
            oDocSped:cChave       := XmlNode( mXmlInfEvento, "chMDFe" )
            //oDocSped:TipoEvento      := XmlNode( mXmlInfEvento, "tpEvento" )
            oDocSped:cSequencia        := StrZero(Val( XmlNode( mXmlInfEvento, "nSeqEvento" ) ), 2 )
            // mXmldetEvento           := XmlNode( mXmlInfEvento, "detEvento" )
               //oDocSped:Texto        := XmlNode( mXmlDetEvento, "xCorrecao" )
         oDocSped:cAssinatura          := XmlNode( mXmlEvento, "Signature" )
      oDocSped:Protocolo               := XmlNode( mXmlEvento, "nProt" )

   RETURN Nil

STATIC FUNCTION XmlToDocMDFECancel( cXmlInput, oDocSped )

   LOCAL mChave, mProtocolo

   IF "<infEvento" $ cXmlInput // Evento
      mChave := XmlNode( cXmlInput, "chMDFe" )
      mProtocolo := XmlNode( XmlNode( cXmlInput, "retEventoMDFe" ), "nProt" )
      // tem o protocolo enviado para cancelamento, e o de retorno
   ENDIF
   IF Len( AllTrim( mChave ) ) == 0
      oDocSped:cErro := "Sem chave de acesso"
      RETURN .F.
   ELSE
      oDocSped:cAmbiente     := XmlNode( cXmlInput, "tpAmb" )
      oDocSped:cSequencia    := StrZero( Val( XmlNode( cXmlInput, "nSeqEvento" ) ), 2 )
      oDocSPed:cChave   := mChave
      oDocSped:Protocolo     := mProtocolo
      oDocSped:Emitente:Cnpj := Transform( DfeEmitente( mChave ), "@R 99.999.999/9999-99" )
      oDocSPed:cNumDoc       := DfeNumero( mChave )
      oDocSped:cAssinatura   := XmlNode( cXmlInput, "Signature" )
      oDocSped:Status        := "111"
   ENDIF

   RETURN Nil

STATIC FUNCTION XmlToDocNfeInut( cXmlInput, oDocSped )

   LOCAL nPosIni, cModelo, cSerie

   oDocSped:cAmbiente := XmlNode( cXmlInput, "tpAmb" )
   nPosIni := At( cXmlInput, [<InfInut] )
   IF nPosIni != 0
      oDocSped:DataEmissao   := Stod( Left( SoNumeros( XmlNode( cXmlInput, "dhRecbto" ) ), 8 ) )
      oDocSped:Emitente:Cnpj := Transform( XmlNode( cXmlInput, "CNPJ" ), "@R 99.999.999/9999-99" )
      oDocSped:cAssinatura   := XmlNode( cXmlInput, "Signature" )
      oDocSped:cSequencia    := "01"
      oDocSped:Protocolo     := XmlNode( cXmlInput, "infInut" )
      oDocSped:Status        := "111"
      oDocSped:DataEmissao   := Stod( Left( SoNumeros( XmlNode( cXmlInput, "dhRecbto" ) ), 8 ) )
      cModelo                := StrZero( Val( XmlNode( cXmlInput, "mod" ) ), 2 )
      cSerie                 := Str( Val( XmlNode( cXmlInput, "serie" ) ), 1 )
      oDocSped:cNumDoc       := StrZero( Val( XmlNode( cXmlInput, "nNFIni" ) ), 9 )
      oDocSped:cChave        := Substr( SoNumeros( Substr( cXmlInput, nPosIni, 60 ) ), 1, 2 ) + ;
                                Substr( Dtos( oDocSped:DataEmissao ), 3, 4 ) + ;
                                SoNumeros( oDocSped:Emitente:Cnpj ) + ;
                                cModelo + ;
                                cSerie + ;
                                oDocSped:cNumDoc + ;
                                "1" + ;
                                StrZero( 0, 8 )
      oDocSped:cChave         := oDocSped:cChave + CalculaDigito( oDocSped:cChave, "11" )
   ENDIF

   RETURN Nil

STATIC FUNCTION XmlToDocCteEmi( XmlInput, oDocSped )

   LOCAL XmlProc, XmlCte, XmlInfCte, XmlIde, mTemp, XmlEmit, XmlEndereco
   LOCAL XmlRemetente, XmlDestinatario, XmlPrest, XmlProt, XmlInfProt, XmlInfCteComTag

   IF Empty( XmlProc := XmlNode( XmlInput, "cteProc" ) )
      XmlProc := XmlNode( XmlInput, "procCTe" )
      IF Empty( XmlProc )
         XmlProc := XmlInput
      ENDIF
   ENDIF

      XmlCte := XmlNode( XmlProc, "CTe" )
         XmlInfCteComTag := XmlNode( XmlProc, "CTe", .T. )
         XmlInfCte := XmlNode( XmlCte, "infCte" )
            oDocSped:cChave := Substr( XmlElement( XmlInfCteComTag, "id" ), 4 )  // id minusculo
            IF Empty( oDocSped:cChave )
               oDocSped:cChave := Substr( XmlElement( XmlInfCteComTag, "Id" ), 4 ) // id maiusculo
            ENDIF
            XmlIde := XmlNode( XmlInfCte, "ide" )
               oDocSped:cNumDoc := StrZero( Val( XmlNode( XmlIde, "nCT" ) ), 9 )
               mTemp := XmlNode( XmlIde, "dhEmi" ) // Data/hora
               mTemp := Substr( mTemp, 1, 10 ) // Data aaaa-mm-dd
               mTemp := Substr( mTemp, 9, 2 ) + "/" + Substr( mTemp, 6, 2 ) + "/" + Substr( mTemp, 1, 4 )
               oDocSped:DataEmissao := Ctod( mTemp )
               oDocSped:cAmbiente   := XmlNode( XmlIde, "tpAmb" )
            XmlEmit := XmlNode( XmlInfCte, "emit" )
               oDocSped:Emitente:Cnpj := Trim( Transform( XmlNode( XmlEmit, "CNPJ" ), "@R 99.999.999/9999-99" ) )
               oDocSped:Emitente:Nome := XmlNode( XmlEmit, "xNome" )
               XmlEndereco := XmlNode( XmlEmit, "enderEmit" )
                  oDocSped:Emitente:Endereco := XmlNode( XmlEndereco, "xLgr" ) + " " + XmlNode( XmlEndereco, "nro" )
                  oDocSped:Emitente:Bairro   := XmlNode( XmlEndereco, "xBairro" )
                  oDocSped:Emitente:Cidade   := XmlNode( XmlEndereco, "xMun" )
                  oDocSped:Emitente:Uf       := XmlNode( XmlEndereco, "UF" )
                  oDocSped:Emitente:Cep      := Transform( XmlNode( XmlEndereco, "CEP" ), "@R 99999-999" )
                  oDocSped:Emitente:Telefone := XmlNode( XmlEndereco, "fone" )
            XmlRemetente := XmlNode( XmlInfCte, "rem" )
               oDocSped:Remetente:Cnpj := Trim( Transform( XmlNode( XmlRemetente, "CNPJ" ), "@R 99.999.999/9999-99" ) )
               oDocSped:Remetente:Nome := XmlNode( XmlRemetente, "xNome" )
               XmlEndereco := XmlNode( XmlRemetente, "enderReme" )
                  oDocSped:Remetente:Endereco := XmlNode( XmlRemetente, "xLgr" ) + " " + XmlNode( XmlEndereco, "nro" )
                  oDocSped:Remetente:Bairro   := XmlNode( XmlRemetente, "xBairro" )
                  oDocSped:Remetente:Cidade   := XmlNode( XmlRemetente, "xMun" )
                  oDocSped:Remetente:Uf       := XmlNode( XmlRemetente, "UF" )
                  oDocSped:Remetente:Cep      := Transform( XmlNode( XmlRemetente, "CEP" ), "@R 99999-999" )
                  oDocSped:Remetente:Telefone := XmlNode( XmlRemetente, "fone" )
            XmlDestinatario := XmlNode( XmlInfCte, "dest" )
               oDocSped:Destinatario:Cnpj := Trim( XmlNode( XmlDestinatario, "CNPJ" ) )
               IF Empty( oDocSped:Destinatario:Cnpj )
                  oDocSped:Destinatario:Cnpj := Transform( XmlNode( XmlDestinatario, "CPF" ), "@R 999.999.999-99" )
               ELSE
                  oDocSped:Destinatario:Cnpj := Transform( oDocSped:Destinatario:Cnpj, "@R 99.999.999/9999-99" )
               ENDIF
               oDocSped:Destinatario:Nome := XmlNode( XmlDestinatario, "xNome" )
               XmlEndereco := XmlNode( XmlDestinatario, "enderDest" )
                  oDocSped:Destinatario:Endereco := XmlNode( XmlDestinatario, "xLgr" ) + " " + XmlNode( XmlEndereco, "nro" )
                  oDocSped:Destinatario:Bairro   := XmlNode( XmlDestinatario, "xBairro" )
                  oDocSped:Destinatario:Cidade   := XmlNode( XmlDestinatario, "xMun" )
                  oDocSped:Destinatario:Uf       := XmlNode( XmlDestinatario, "UF" )
                  oDocSped:Destinatario:Cep      := XmlNode( XmlDestinatario, "CEP" )
                  oDocSped:Destinatario:Telefone := XmlNode( XmlDestinatario, "fone" )
               XmlPrest := XmlNode( XmlInfCte, "vPrest" )
                  oDocSped:Valor := Val( XmlNode(XmlPrest, "vTPrest" ) )
      oDocSped:PesoCarga  := Val( XmlNode( XmlCte, "vCarga" ) )
      oDocSped:ValorCarga := Val( XmlNode( XmlCte, "qCarga" ) )
      oDocSped:cAssinatura := XmlNode( XmlCte, "Signature" )
   XmlProt := XmlNode(XmlProc, "protCTe" )
      XmlInfProt := XmlNode( XmlProt, "infProt" )
      oDocSped:Protocolo := XmlNode( XmlInfProt, "nProt" )
      oDocSped:Status    := XmlNode( XmlProt, "cStat" )

   RETURN oDocSped

STATIC FUNCTION XmlToDocCteCancel( cXmlInput, oDocSped )

   LOCAL mXmlInfCanc, mXmlInfCancComTag, mChave, mProtocolo

   mProtocolo := ""
   mChave     := ""
   IF "procEventoCTe" $ cXmlInput
      mChave := XmlNode( cXmlInput, "chCTe" )
      mProtocolo := XmlNode( XmlNode( cXmlInput, "retEventoCTe" ), "nProt" )
   ELSEIF "procCancCTe" $ cXmlInput
      mXmlInfCanc := XmlNode( cXmlInput, "procCancCTe" )
      mXmlInfCancComTag := XmlNode( cXmlInput, "procCancCTe", .T. )
      mChave      := XmlElement( mXmlInfCancComTag, "Id" )
      mChave      := Substr( mChave, 3 )
      mProtocolo  := XmlNode( mXmlInfCanc, "nProt" )
   ELSEIF "retCancCTe" $ cXmlInput
      mXmlInfCanc := XmlNode( cXmlInput, "retCancCTe" )
      mChave      := XmlNode( mXmlInfCanc, "chCTe" )
      mProtocolo  := XmlNode( mXmlInfCanc, "nProt" )
   ENDIF
   IF Len( Trim( mChave ) ) != 0
      oDocSped:cChave        := mChave
      oDocSped:Protocolo     := mProtocolo
      oDocSped:cAmbiente     := XmlNode( cXmlInput, "tpAmb" )
      oDocSped:Emitente:Cnpj := Transform( DfeEmitente( mChave ), "@R 99.999.999/9999-99" )
      oDocSped:cNumDoc       := DfeNumero( mChave )
      oDocSped:cAssinatura   := XmlNode( cXmlInput, "Signature" )
      oDocSped:Status        := "111"
   ENDIF

   RETURN oDocSped

FUNCTION PicNfe( cChave )

   RETURN Transform( cChave, "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9" )

FUNCTION DfeModFis( cKey )

   RETURN Substr( cKey, 21, 2 )

FUNCTION DfeSerie( cKey )

   RETURN Substr( cKey, 23, 3 )

FUNCTION DfeNumero( cKey )

   RETURN Substr( cKey, 26, 9 )

FUNCTION DfeEmitente( cKey )

   RETURN Substr( cKey, 7, 14 )

FUNCTION DFeUF( cKey )

   RETURN SefazClass():UFSigla( cKey )
