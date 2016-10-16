/*
ZE_SPEDXMLCLASS - CLASSES PARA NFE/CTE/MDFE/CCE
2010.07.19

...
2016.07.05.1200 - Formatação do fonte
2016.07.10.1330 - Status do documento

*** Sujeito a mudanças nos nomes em atualizações futuras, e novos campos
*/

#include "hbclass.ch"

CREATE CLASS NfeCadastroClass

   VAR  Nome                INIT ""
   VAR  Cnpj                INIT ""
   VAR  InscricaoEstadual   INIT ""
   VAR  InscricaoMunicipal  INIT ""
   VAR  CNAE                INIT ""
   VAR  Endereco            INIT ""
   VAR  Numero              INIT ""
   VAR  Compl               INIT ""
   VAR  Bairro              INIT ""
   VAR  Cidade              INIT ""
   VAR  CidadeIbge          INIT ""
   VAR  Uf                  INIT ""
   VAR  Cep                 INIT ""
   VAR  Pais                INIT ""
   VAR  PaisBACEN           INIT ""
   VAR  Telefone            INIT ""

   END CLASS

CREATE CLASS NfeEnderecoEntregaClass

   VAR  Cnpj        INIT ""
   VAR  Endereco    INIT ""
   VAR  Numero      INIT ""
   VAR  Compl       INIT ""
   VAR  Bairro      INIT ""
   VAR  Cidade      INIT ""
   VAR  CidadeIbge  INIT ""
   VAR  Uf          INIT ""

   END CLASS

CREATE CLASS NfeVolumesClass // From NfeTransporteClass

   VAR  Qtde         INIT 0
   VAR  Especie      INIT ""
   VAR  Marca        INIT ""
   VAR  PesoLiquido  INIT 0
   VAR  PesoBruto    INIT 0
   VAR  Lacres       INIT ""

   END CLASS

CREATE CLASS NfeTransporteClass

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

   END CLASS

METHOD Init() CLASS NfeTransporteClass

   ::Volumes := NfeVolumesClass():New()

   RETURN SELF

CREATE CLASS NfeTotaisClass

   VAR  IcmBas INIT 0
   VAR  IcmVal INIT 0
   VAR  SubBas INIT 0
   VAR  SubVal INIT 0
   VAR  IpiVal INIT 0
   VAR  IIVal  INIT 0
   VAR  IssVal INIT 0
   VAR  PisVal INIT 0
   VAR  CofVal INIT 0
   VAR  ValPro INIT 0
   VAR  ValSeg INIT 0
   VAR  ValFre INIT 0
   VAR  ValOut INIT 0
   VAR  ValNot INIT 0

   END CLASS

CREATE CLASS NfeIIClass

   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   END CLASS

CREATE CLASS NfeIpiClass

   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   END CLASS

CREATE CLASS NfeIssClass

   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   END CLASS

CREATE CLASS NfeIcmsClass

   VAR  Cst      INIT ""
   VAR  Base     INIT 0
   VAR  Reducao  INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   END CLASS

CREATE CLASS NfeIcmsStClass

   VAR  Base      INIT 0
   VAR  IVA       INIT 0
   VAR  Reducao   INIT 0
   VAR  Aliquota  INIT 0
   VAR  Valor     INIT 0

   END CLASS

CREATE CLASS NfePisClass

   VAR  Cst      INIT ""
   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   END CLASS

CREATE CLASS NfeCofinsClass

   VAR  Cst      INIT ""
   VAR  Base     INIT 0
   VAR  Aliquota INIT 0
   VAR  Valor    INIT 0

   END CLASS

CREATE CLASS NfeProdutoClass

   VAR  Codigo        INIT ""
   VAR  Nome          INIT ""
   VAR  CfOp          INIT ""
   VAR  NCM           INIT ""
   VAR  GTIN          INIT ""
   VAR  Anp           INIT ""
   VAR  Unidade       INIT ""
   VAR  Qtde          INIT 0
   VAR  ValorUnitario INIT 0
   VAR  ValorTotal    INIT 0
   VAR  Icms
   VAR  IcmsSt
   VAR  Iss
   VAR  Ipi
   VAR  Pis
   VAR  Cofins
   VAR  II
   METHOD Init()

   END CLASS

METHOD Init() CLASS NfeProdutoClass

   ::Icms   := NfeIcmsClass():New()
   ::IcmsSt := NfeIcmsStClass():New()
   ::Iss    := NfeIssClass():New()
   ::II     := NfeIIClass():New()
   ::Ipi    := NfeIpiClass():New()
   ::Pis    := NfePisClass():New()
   ::Cofins := NfeCofinsClass():New()

   RETURN SELF

CREATE CLASS NfeDuplicataClass

   VAR  Vencimento INIT Ctod("" )
   VAR  Valor      INIT 0

   END CLASS

CREATE CLASS DocSpedClass

   VAR  ChaveAcesso             INIT ""
   VAR  cTipoDoc                INIT "" // 2014.11.20
   VAR  cEvento                 INIT "" // 2014.11.20
   VAR  Protocolo               INIT ""
   VAR  cNumDoc                 INIT ""
   VAR  DataEmissao             INIT Ctod( "" )
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
   VAR  cERRO                   INIT "" // Texto do erro
   VAR  PesoCarga               INIT 0  // Cte
   VAR  ValorCarga              INIT 0  // Cte
   VAR  Status                  INIT ""
   METHOD Init()

   END CLASS

METHOD Init() CLASS DocSpedClass

   ::Emitente        := NfeCadastroClass():New()
   ::Destinatario    := NfeCadastroClass():New()
   ::Remetente       := NfeCadastroClass():New()
   ::EnderecoEntrega := NfeEnderecoEntregaClass():New()
   ::Transporte      := NfeTransporteClass():New()
   ::Totais          := NfeTotaisClass():New()

   RETURN SELF

FUNCTION XmlToDoc( cXmlInput )

   LOCAL oDoc

   IF ! ["] $ cXmlInput  // Petrobras usa aspas simples
      cXmlInput := StrTran( cXmlInput, ['], ["] )
   ENDIF
   oDoc := DocSpedClass():New()
   DO CASE
   CASE "<nfeProc"      $ cXmlInput
      oDoc:cTipoDoc := "55"
      oDoc:cEvento  := "110100"
      XmlToDocNfeEmi( cXmlInput, @oDoc )
   CASE "<cteProc" $ cXmlInput
      oDoc:cTipoDoc := "57"
      oDoc:cEvento  := "110100"
      XmlToDocCteEmi( cXmlInput, @oDoc )
   CASE "<mdfeProc" $ cXmlInput
      oDoc:cTipoDoc := "58"
      oDoc:cEvento  := "110100"
      XmlToDocMDFEEmi( cXmlInput, @oDoc )
   CASE "<procEventoNFe" $ cXmlInput .AND. "<descEvento>Cancelamento" $ cXmlInput
      oDoc:cTipoDoc := "55"
      oDoc:cEvento  := "110111"
      XmlToDocNfeCancel( cXmlInput, @oDoc )
   CASE "<procCancNFe" $ cXmlInput .AND. "<xServ>CANCELAR" $ cXmlInput
      oDoc:cTipoDoc := "55"
      oDoc:cEvento  := "110111"
      XmlToDocNFECancel( cXmlInput, @oDoc )
   CASE "<procEventoCTe" $ cXmlInput .AND. "<descEvento>Cancelamento" $ cXmlInput
      oDoc:cTipoDoc := "57"
      oDoc:cEvento  := "110111"
      XmlToDocCTeCancel( cXmlInput, @oDoc )
   CASE "<procEventoNFe" $ cXmlInput .AND. "<descEvento>Carta de Correcao" $ cXmlInput
      oDoc:cTipoDoc := "55"
      oDoc:cEvento  := "110110"
      XmlToDocNfeCCe( cXmlInput, @oDoc )
   CASE "<procEventoMDFe" $ cXmlInput .AND. "<descEvento>Cancelamento" $ cXmlInput
      oDoc:cTipoDoc := "58"
      oDoc:cEvento  := "110111"
      XmlToDocMDFECancel( cXmlInput, @oDoc )
   CASE "<procEventoMDFe" $ cXmlInput .AND. "<descEvento>Encerramento" $ cXmlInput
      oDoc:cTipoDoc := "58"
      oDoc:cEvento  := "110112"
      XmlToDocMDFEEnc( cXmlInput, @oDoc )
   CASE "<infMDFe" $ cXmlInput
      oDoc:cTipoDoc := "58"
      oDoc:cEvento  := "000000"
      XmlToDocMDFEEmi( cXmlInput, @oDoc )
   CASE "<infCte" $ cXmlInput
      oDoc:cTipoDoc := "57"
      oDoc:cEvento  := "000000"
      XmlToDocCteEmi( cXmlInput, @oDoc )
   CASE "<infNFe" $ cXmlInput
      oDoc:cTipoDoc := "55"
      oDoc:cEvento  := "000000"
      XmlToDocNfeEmi( cXmlInput, @oDoc )
   //CASE "<infEvento" $ cXmlInput
   //   // pode ser pra qualquer documento
   //   oDoc:cTipoDoc := "XX"
   //   oDoc:cEvento  := "XX"
   OTHERWISE
      oDoc:cErro := "Documento não identificado"
   ENDCASE
   IF Empty( oDoc:Destinatario:Cnpj ) .AND. Empty( oDoc:Destinatario:Nome )
      oDoc:Destinatario := oDoc:Emitente
   ENDIF
   oDoc:ChaveAcesso := SoNumeros( oDoc:ChaveAcesso )
   DO CASE
   CASE Len( oDoc:cErro ) != 0
   CASE Len( oDoc:ChaveAcesso ) != 44
      oDoc:cErro := "Tamanho da chave de acesso inválido"
   CASE Right( oDoc:ChaveAcesso, 1 ) != CalculaDigito( Substr( oDoc:ChaveAcesso, 1, 43 ), "11" )
      oDoc:cErro := "Dígito da chave de acesso inválido"
   CASE Substr( oDoc:ChaveAcesso, 5, 2 ) < "01" .OR. Substr( oDoc:ChaveAcesso, 5, 2 ) > "12"
      oDoc:cErro := "Mes da chave inválido"
   CASE ! ValidCnpjCpf( Substr( oDoc:ChaveAcesso, 7, 14 ) )
      oDoc:cErro := "CNPJ inválido na chave de acesso"
   CASE Val( oDoc:Protocolo ) == 0
      oDoc:cErro := "Sem protocolo"
   CASE Empty( oDoc:cAssinatura )
      oDoc:cErro := "Sem assinatura"
   CASE oDoc:cAmbiente != "1"
      oDoc:cErro := "Não é ambiente de produção"
   CASE oDoc:cTipoDoc != Substr( oDoc:ChaveAcesso, 21, 2 )
      oDoc:cErro := "Tipo de documento " + Substr( oDoc:ChaveAcesso, 21, 2 )
   CASE oDoc:cEvento = "110100" .AND. Empty( oDoc:cNumDoc )
      oDoc:cErro := "Número de documento vazio"
   ENDCASE
   IF Len( oDoc:cErro ) != 0
      oDoc:cTipoDoc := "XX"
      oDoc:cEvento  := "XXXXXX"
   ENDIF

   RETURN oDoc

FUNCTION XmlToDocNfeEmi( cXmlInput, oNfe )

   LOCAL nCont
   LOCAL cBlocoInfNfeComTag, cBlocoChave, cBlocoIde, cBlocoInfAdic
   LOCAL cBlocoEmit, cBlocoEndereco, cBlocoDest, cBlocoTransporte, cBlocoTransp, cBlocoVeiculo, cBlocoVol, cBlocoTotal
   LOCAL cBlocoDetalhe, cBlocoItem, cBlocoProd,  cBlocoIpi, cBlocoIcms, cBlocoPis, cBlocoCofins
   LOCAL cBlocoComb, cBlocoCobranca, cBlocoDup

   cBlocoInfNfeComTag := XmlNode( cXmlInput, "infNFe", .T. )

   cBlocoChave := XmlElement( cBlocoInfNfeComTag, "Id" )
   cBlocoChave := Substr( cBlocoChave, 4 )
   cBlocoChave := AllTrim( cBlocoChave )
   IF Len( cBlocoChave ) <> 44
      oNfe:cErro := "Chave de Acesso Inválida"
      RETURN NIL
   ENDIF
   oNfe:ChaveAcesso := cBlocoChave
   oNfe:cAssinatura := XmlNode( cXmlInput, "Signature" )
   cBlocoIde := XmlNode( cXmlInput, "ide" )
      oNfe:cNumDoc := XmlNode( cBlocoIde, "nNF" )
      IF Len( Trim( oNfe:cNumDoc ) ) = 0
         oNfe:cErro := "Sem número de documento"
         RETURN NIL
      ENDIF
      oNfe:cNumDoc := StrZero( Val( oNfe:cNumDoc ), 9 )
      IF ! Empty( XmlDate( XmlNode( cBlocoIde, "dhEmi" ) ) )
         oNfe:DataEmissao := XmlDate( XmlNode( cBlocoIde, "dhEmi" ) )
         oNfe:DataSaida   := XmlDate( XmlNode( cBlocoIde, "dhSaiEnt" ) )
      ELSE
         oNfe:DataEmissao := XmlDate( XmlNode( cBlocoIde, "dEmi" ) )
         oNfe:DataSaida   := XmlDate( XmlNode( cBlocoIde, "dSaiEnt" ) )
      ENDIF
      IF Empty( oNfe:DataSaida )
         oNfe:DataSaida := oNfe:DataEmissao
      ENDIF
      oNfe:cAmbiente := XmlNode( cBlocoIde, "tpAmb" )

   cBlocoInfAdic := XmlNode( cXmlInput, "InfAdic" )
      oNfe:InfAdicionais := XmlNode( cBlocoInfAdic, "InfCpl" )

   cBlocoEmit := XmlNode( cXmlInput, "emit" )
      oNfe:Emitente:Cnpj              := Transform( Substr( oNfe:ChaveAcesso, 7, 14 ), "@R 99.999.999/9999-99" )
      oNfe:Emitente:Nome              := Upper( XmlNode( cBlocoEmit, "xNome" ) )
      oNfe:Emitente:InscricaoEstadual := XmlNode( cBlocoEmit, "IE" )
      cBlocoEndereco := XmlNode( cBlocoEmit, "enderEmit" )
         oNfe:Emitente:Endereco   := Upper( XmlNode( cBlocoEndereco, "xLgr" ) )
         oNfe:Emitente:Numero     := XmlNode( cBlocoEndereco, "nro" )
         oNfe:Emitente:Compl      := XmlNode( cBlocoEndereco, "xCpl" )
         oNfe:Emitente:Bairro     := Upper( XmlNode( cBlocoEndereco, "xBairro" ) )
         oNfe:Emitente:CidadeIbge := XmlNode( cBlocoEndereco, "cMun" )
         oNfe:Emitente:Cidade     := Upper( XmlNode( cBlocoEndereco, "xMun" ) )
         oNfe:Emitente:Uf         := Upper( XmlNode( cBlocoEndereco, "UF" ) )
         oNfe:Emitente:Cep        := Transform( XmlNode( cBlocoEndereco, "CEP" ), "@R 99999-999" )
         oNfe:Emitente:Telefone   := XmlNode( cBlocoEndereco, "fone" )

      cBlocoDest := XmlNode( cXmlInput, "dest" )
      oNfe:Destinatario:Cnpj := Trim( XmlNode( cBlocoDest, "CNPJ" ) )
      IF Len( Trim( oNfe:Destinatario:Cnpj ) ) = 0
         oNfe:Destinatario:Cnpj := XmlNode( cBlocoDest, "CPF" )
         oNfe:Destinatario:Cnpj := Transform( oNfe:Destinatario:Cnpj, "@R 999.999.999-99" )
      ELSE
         oNfe:Destinatario:Cnpj := Transform( oNfe:Destinatario:Cnpj, "@R 99.999.999/9999-99" )
      ENDIF
      oNfe:Destinatario:Nome := Upper( XmlNode( cBlocoDest, "xNome" ) )
      oNfe:Destinatario:InscricaoEstadual := XmlNode( cBlocoDest, "IE" )
      cBlocoEndereco := XmlNode( cBlocoDest, "enderDest" )
         oNfe:Destinatario:Endereco   := Upper( XmlNode( cBlocoEndereco, "xLgr" ) )
         oNfe:Destinatario:Numero     := XmlNode( cBlocoEndereco, "nro" )
         oNfe:Destinatario:Compl      := XmlNode( cBlocoEndereco, "xCpl" )
         oNfe:Destinatario:Bairro     := Upper( XmlNode( cBlocoEndereco, "xBairro" ) )
         oNfe:Destinatario:CidadeIbge := XmlNode( cBlocoEndereco, "cMun" )
         oNfe:Destinatario:Cidade     := Upper( XmlNode( cBlocoEndereco, "xMun" ) )
         oNfe:Destinatario:Uf         := Upper( XmlNode( cBlocoEndereco, "UF" ) )
         oNfe:Destinatario:Cep        := Transform( XmlNode( cBlocoEndereco, "CEP" ), "@R 99999-999" )
         oNfe:Destinatario:Telefone   := XmlNode( cBlocoEndereco, "fone" )

   cBlocoTransporte := XmlNode( cXmlInput, "transp" )
      cBlocoTransp := XmlNode( cBlocoTransporte, "transporta" )
         oNfe:Transporte:Cnpj              := Transform( XmlNode( cBlocoTransp, "CNPJ" ), "@R 99.999.999/9999-99" )
         oNfe:Transporte:Nome              := Upper( XmlNode( cBlocoTransp, "xNome" ) )
         oNfe:Transporte:InscricaoEstadual := XmlNode( cBlocoTransp, "IE" )
         oNfe:Transporte:Endereco          := Upper( XmlNode( cBlocoTransp, "xEnder" ) )
         oNfe:Transporte:Cidade            := Upper( XmlNode( cBlocoTransp, "xMun" ) )
         oNfe:Transporte:Uf                := Upper( XmlNode( cBlocoTransp, "UF" ) )
      cBlocoVol := XmlNode( cBlocoTransporte, "vol" )
         oNfe:Transporte:Volumes:Qtde        := Val( XmlNode( cBlocoVol, "qVol" ) )
         oNfe:Transporte:Volumes:Especie     := Upper( XmlNode( cBlocoVol, "esp" ) )
         oNfe:Transporte:Volumes:Marca       := Upper( XmlNode( cBlocoVol, "marca" ) )
         oNfe:Transporte:Volumes:PesoLiquido := Val( XmlNode( cBlocoVol, "pesoL" ) )
         oNfe:Transporte:Volumes:PesoBruto   := Val( XmlNode( cBlocoVol, "pesoB" ) )
      cBlocoVeiculo := XmlNode( cBlocoTransporte, "veicTransp" )
      oNfe:Transporte:PlacaUf := Upper( XmlNode( cBlocoVeiculo, "UF" ) )
      oNfe:Transporte:Placa   := Upper( XmlNode( cBlocoVeiculo, "placa" ) )

   cBlocoTotal := XmlNode( cXmlInput, "total" )
      oNfe:Totais:IpiVal := Val( XmlNode( cBlocoTotal, "vIPI" ) )
      oNfe:Totais:IIVal  := Val( XmlNode( cBlocoTotal, "vII" ) )
      oNfe:Totais:IcmBas := Val( XmlNode( cBlocoTotal, "vBC" ) )
      oNfe:Totais:IcmVal := Val( XmlNode( cBlocoTotal, "vICMS" ) )
      oNfe:Totais:SubBas := Val( XmlNode( cBlocoTotal, "vBCST" ) )
      oNfe:Totais:SubVal := Val( XmlNode( cBlocoTotal, "vST" ) )
      oNfe:Totais:PisVal := Val( XmlNode( cBlocoTotal, "vPIS" ) )
      oNfe:Totais:CofVal := Val( XmlNode( cBlocoTotal, "vCOFINS" ) )
      oNfe:Totais:ValPro := Val( XmlNode( cBlocoTotal, "vProd" ) )
      oNfe:Totais:ValSeg := Val( XmlNode( cBlocoTotal, "vSeg" ) )
      oNfe:Totais:ValFre := Val( XmlNode( cBlocoTotal, "vFrete" ) )
      oNfe:Totais:ValOut := Val( XmlNode( cBlocoTotal, "vOutro" ) )
      oNfe:Totais:ValNot := Val( XmlNode( cBlocoTotal, "vNF" ) )

   cBlocoDetalhe := ""
   IF "<det" $ cXmlInput
      cBlocoDetalhe := Substr( cXmlInput, At( "<det", cXmlInput ) - 1 )
   ENDIF
   FOR nCont = 1 TO 1000
      cBlocoItem := XmlNode( cBlocoDetalhe, [det nItem="] + LTrim( Str( nCont ) ) + ["])
      IF Len( Trim( cBlocoItem ) ) = 0 // Se acabaram os itens
         EXIT
      ENDIF
      AAdd( oNFE:Produto, NFEProdutoClass():New() )
      cBlocoProd := XmlNode( cBlocoItem, "prod" )
         oNfe:Produto[ nCont ]:Codigo          := XmlNode( cBlocoProd, "cProd" )
         oNfe:Produto[ nCont ]:Nome            := Upper( XmlNode( cBlocoProd, "xProd" ) )
         oNfe:Produto[ nCont ]:CFOP            := Transform( XmlNode( cBlocoProd, "CFOP" ), "@R 9.9999" )
         oNfe:Produto[ nCont ]:NCM             := XmlNode( cBlocoProd, "NCM" )
         oNfe:Produto[ nCont ]:GTIN            := XmlNode( cBlocoProd, "cEAN" )
         oNfe:Produto[ nCont ]:Unidade         := Upper( XmlNode( cBlocoProd, "uCom" ) )
         oNfe:Produto[ nCont ]:Qtde            := Val( XmlNode( cBlocoProd, "qCom" ) )
         oNfe:Produto[ nCont ]:ValorUnitario   := Val( XmlNode( cBlocoProd, "vUnCom" ) )
         oNfe:Produto[ nCont ]:ValorTotal      := Val( XmlNode( cBlocoProd, "vProd" ) )
      cBlocoIpi := XmlNode( cBlocoItem, "IPI" )
         oNfe:Produto[ nCont ]:Ipi:Base        := Val( XmlNode( cBlocoIpi, "vBC" ) )
         oNfe:Produto[ nCont ]:Ipi:Aliquota    := Val( XmlNode( cBlocoIpi, "pIPI" ) )
         oNfe:Produto[ nCont ]:Ipi:Valor       := Val( XmlNode( cBlocoIpi, "vIPI" ) )
      cBlocoIcms := XmlNode( cBlocoItem, "ICMS" )
         oNfe:Produto[ nCont ]:Icms:Cst        := XmlNode( cBlocoIcms, "orig" ) + XmlNode( cBlocoIcms, "CST" )
         oNfe:Produto[ nCont ]:Icms:Base       := Val( XmlNode( cBlocoIcms, "vBC" ) )
         oNfe:Produto[ nCont ]:Icms:Reducao    := Val( XmlNode( cBlocoIcms, "vRedBC" ) )
         oNfe:Produto[ nCont ]:Icms:Aliquota   := Val( XmlNode( cBlocoIcms, "pICMS" ) )
         oNfe:Produto[ nCont ]:Icms:Valor      := Val( XmlNode( cBlocoIcms, "vICMS" ) )
         oNfe:Produto[ nCont ]:IcmsSt:Base     := Val( XmlNode( cBlocoIcms, "vBCST" ) )
         oNfe:Produto[ nCont ]:IcmsSt:Iva      := Val( XmlNode( cBlocoIcms, "pMVAST" ) )
         oNfe:Produto[ nCont ]:IcmsSt:Reducao  := Val( XmlNode( cBlocoIcms, "pRedBCST" ) )
         oNfe:Produto[ nCont ]:IcmsSt:Aliquota := Val( XmlNode( cBlocoIcms, "pICMSST" ) )
         oNfe:Produto[ nCont ]:IcmsSt:Valor    := Val( XmlNode( cBlocoIcms, "vICMSST" ) )
      cBlocoPis := XmlNode( cBlocoItem, "PIS" )
         oNfe:Produto[ nCont ]:Pis:Cst         := XmlNode( cBlocoPis, "CST" )
         oNfe:Produto[ nCont ]:Pis:Base        := Val( XmlNode( cBlocoPis, "vBC" ) )
         oNfe:Produto[ nCont ]:Pis:Aliquota    := Val( XmlNode( cBlocoPis, "pPIS" ) )
         oNfe:Produto[ nCont ]:Pis:Valor       := Val( XmlNode( cBlocoPis, "vPIS" ) )
      cBlocoCofins := XmlNode( cBlocoItem, "COFINS" )
         oNfe:Produto[ nCont ]:Cofins:Cst      := XmlNode( cBlocoCofins, "CST" )
         oNfe:Produto[ nCont ]:Cofins:Base     := Val( XmlNode( cBlocoCofins, "vBC" ) )
         oNfe:Produto[ nCont ]:Cofins:Aliquota := Val( XmlNode( cBlocoCofins, "pCOFINS" ) )
         oNfe:Produto[ nCont ]:Cofins:Valor    := Val( XmlNode( cBlocoCofins, "vCOFINS" ) )
      cBlocoComb := XmlNode( cBlocoItem, "comb" )
         oNfe:Produto[ nCont ]:Anp             := XmlNode( cBlocoComb, "cProdANP" )
      cBlocoDetalhe := Substr( cBlocoDetalhe, At( "</det", cBlocoDetalhe ) + 4 )
   NEXT

   cBlocoCobranca := XmlNode( cXmlInput, "cobr" )
   FOR nCont = 1 TO 500
      cBlocoDup := XmlNode( cBlocoCobranca, "dup" )
      IF Len( Trim( cBlocoDup ) ) = 0
         EXIT
      ENDIF
      AAdd( oNfe:Duplicata, NFEDuplicataClass():New() )
      oNfe:Duplicata[ nCont ]:Vencimento := XmlDate( XmlNode( cBlocoDup, "dVenc" ) )
      oNfe:Duplicata[ nCont ]:Valor      := Val( XmlNode( cBlocoDup, "vDup" ) )
      cBlocoCobranca := Substr( cBlocoCobranca, At( "</dup>", cBlocoCobranca ) + 3 )
   NEXT
   oNfe:Protocolo := XmlNode( cXmlInput, "nProt" )
   oNFE:Status    := XmlNode( cXmlInput, "cStat" )

   RETURN NIL

FUNCTION XmlToDocNfeCancel( cXmlInput, oNFe )

   LOCAL mXmlInfComTag, mXmlInf

   DO CASE
   CASE "<infEvento" $ cXmlInput // Evento
      oNFe:ChaveAcesso := XmlNode( cXmlInput, "chNFe" )
      oNFe:Protocolo   := XmlNode( XmlNode( cXmlInput, "retEvento" ), "nProt" )
      // tem o protocolo enviado para cancelamento, e o de retorno
   CASE "retCancNFe" $ cXmlInput // Tem que ser antes do outro
      mXmlInf := XmlNode( cXmlInput, "infCanc" )
      oNFe:ChaveAcesso := XmlNode( mXmlInf, "chNFe" )
      oNFe:Protocolo   := XmlNode( mXmlInf, "nProt" )
   CASE "CancNFe" $ cXmlInput
      mXmlInfComTag := XmlNode( cXmlInput, "infCanc",.T. )
      oNFe:ChaveAcesso := XmlElement( mXmlInfComTag, "Id" )
      IF Substr( oNFe:ChaveAcesso, 1, 2 ) == "ID"
         oNFe:ChaveAcesso := Substr( oNFe:ChaveAcesso, 3 )
      ENDIF
      oNFe:Protocolo := XmlNode( mXmlInfComTag, "nProt" )
   OTHERWISE
      oNFe:cErro       := "Formato do arquivo de cancelamento diferente. Avise desenvolvedor"
      oNFe:ChaveAcesso := ""
      oNFe:Protocolo   := ""
      RETURN .F.
   ENDCASE
   IF Len( AllTrim( oNFe:Chave ) ) == 0
      oNfe:cErro := "Sem chave de acesso"
      RETURN .F.
   ELSE
      oNFE:cAmbiente     := XmlNode( cXmlInput, "tpAmb" )
      oNfe:Emitente:Cnpj := Transform( Substr( oNFe:cChave, 7, 14 ), "@R 99.999.999/9999-99" )
      oNfe:cNumDoc       := Substr( oNFe:cChave, 26, 9 )
      oNfe:cAssinatura   := XmlNode( cXmlInput, "Signature" )
      oNfe:Status        := "111"
   ENDIF

   RETURN NIL

FUNCTION XmlToDocNfeCce( XmlInput, oDocSped )

   LOCAL mXmlProcEvento, mXmlEvento, mXmlInfEvento, mXmlRetEvento

   mXmlProcEvento := XmlNode( XmlInput, "procEventoNFe" )
      mXmlEvento := XmlNode( mXmlProcEvento, "evento" )
         mXmlInfEvento := XmlNode( mXmlEvento, "infEvento" )
            oDocSped:cAmbiente         := XmlNode( mXmlInfEvento, "tpAmb" )
            oDocSped:Emitente:Cnpj     := Transform( XmlNode( mXmlInfEvento, "CNPJ" ), "@R 99.999.999/9999-99" )
            oDocSped:Destinatario:Cnpj := oDocSped:Emitente:Cnpj
            oDocSped:ChaveAcesso       := XmlNode( mXmlInfEvento, "chNFe" )
            //oDocSped:TipoEvento      := XmlNode( mXmlInfEvento, "tpEvento" )
            oDocSped:cSequencia        := StrZero(Val( XmlNode( mXmlInfEvento, "nSeqEvento" ) ), 2 )
            // mXmldetEvento           := XmlNode( mXmlInfEvento, "detEvento" )
               //oDocSped:Texto        := XmlNode( mXmlDetEvento, "xCorrecao" )
         oDocSped:cAssinatura          := XmlNode( mXmlEvento, "Signature" )
      mXmlRetEvento := XmlNode( mXmlProcEvento, "retEvento" )
         mXmlInfEvento := XmlNode( mXmlRetEvento, "infEvento" )
            //oDocSped:Status          := XmlNode( mXmlInfEvento, "cStat" )
            oDocSped:Protocolo         := XmlNode( mXmlInfEvento, "nProt" )

   RETURN NIL

FUNCTION XmlToDocMDFEEmi( cXmlInput, oMDFE )

   LOCAL cBlocoInfNfeComTag, cBlocoChave, cBlocoIde, cBlocoInfAdic
   LOCAL cBlocoEmit, cBlocoEndereco

   cXmlInput := XmlTransform( cXmlInput )

   cBlocoInfNfeComTag := XmlNode( cXmlInput, "infMDFe", .T. )

   cBlocoChave := XmlElement( cBlocoInfNfeComTag, "Id" )
   cBlocoChave := Substr( cBlocoChave, 5, 44 )
   cBlocoChave := AllTrim( cBlocoChave )
   IF Len( cBlocoChave ) <> 44
      oMDFE:cErro := "Chave de acesso inválida"
      RETURN NIL
   ENDIF
   oMDFE:ChaveAcesso := cBlocoChave
   oMDFE:cAssinatura := XmlNode( cXmlInput, "Signature" )
   cBlocoIde := XmlNode( cXmlInput, "ide" )
      oMDFE:cNumDoc := XmlNode( cBlocoIde, "nMDF" )
      IF Len( Trim( oMDFE:cNumDoc ) ) = 0
         oMDFE:cErro := "Sem número de documento"
         RETURN NIL
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
         oMDFE:Emitente:Compl      := XmlNode( cBlocoEndereco, "xCpl" )
         oMDFE:Emitente:Bairro     := Upper( XmlNode( cBlocoEndereco, "xBairro" ) )
         oMDFE:Emitente:CidadeIbge := XmlNode( cBlocoEndereco, "cMun" )
         oMDFE:Emitente:Cidade     := Upper( XmlNode( cBlocoEndereco, "xMun" ) )
         oMDFE:Emitente:Uf         := Upper( XmlNode( cBlocoEndereco, "UF" ) )
         oMDFE:Emitente:Cep        := Transform( XmlNode( cBlocoEndereco, "CEP" ), "@R 99999-999" )
         oMDFE:Emitente:Telefone   := XmlNode( cBlocoEndereco, "fone" )

   oMDFE:Protocolo := XmlNode( cXmlInput, "nProt" )
   oMDFE:Status    := XmlNode( cXmlInput, "cStat" )

   RETURN NIL

FUNCTION XmlToDocMDFEEnc( XmlInput, oDocSped )

   LOCAL mXmlProcEvento, mXmlEvento, mXmlInfEvento

   mXmlProcEvento := XmlNode( XmlInput, "procEventoMDFe" )
      mXmlEvento := XmlNode( mXmlProcEvento, "eventoMDFe" )
         mXmlInfEvento := XmlNode( mXmlEvento, "infEvento" )
            oDocSped:cAmbiente         := XmlNode( mXmlInfEvento, "tpAmb" )
            oDocSped:Emitente:Cnpj     := Transform( XmlNode( mXmlInfEvento, "CNPJ" ), "@R 99.999.999/9999-99" )
            oDocSped:Destinatario:Cnpj := oDocSped:Emitente:Cnpj
            oDocSped:ChaveAcesso       := XmlNode( mXmlInfEvento, "chMDFe" )
            //oDocSped:TipoEvento      := XmlNode( mXmlInfEvento, "tpEvento" )
            oDocSped:cSequencia        := StrZero(Val( XmlNode( mXmlInfEvento, "nSeqEvento" ) ), 2 )
            // mXmldetEvento           := XmlNode( mXmlInfEvento, "detEvento" )
               //oDocSped:Texto        := XmlNode( mXmlDetEvento, "xCorrecao" )
         oDocSped:cAssinatura          := XmlNode( mXmlEvento, "Signature" )
      oDocSped:Protocolo               := XmlNode( mXmlEvento, "nProt" )

   RETURN NIL

FUNCTION XmlToDocMDFECancel( cXmlInput, oDocSped )

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
      oDocSPed:ChaveAcesso   := mChave
      oDocSped:Protocolo     := mProtocolo
      oDocSped:Emitente:Cnpj := Transform( Substr( mChave, 7, 14 ), "@R 99.999.999/9999-99" )
      oDocSPed:cNumDoc       := Substr( mChave, 26, 9 )
      oDocSped:cAssinatura   := XmlNode( cXmlInput, "Signature" )
      oDocSped:Status        := "111"
   ENDIF

   RETURN NIL

FUNCTION XmlToDocCteEmi( XmlInput, oCTE )

   LOCAL XmlProc, XmlCte, XmlInfCte, XmlIde, mTemp, XmlEmit, XmlEndereco
   LOCAL XmlRemetente, XmlDestinatario, XmlPrest, XmlProt, XmlInfProt, XmlInfCteComTag

   XmlProc := XmlNode( XmlInput, "cteProc" )
      XmlCte := XmlNode( XmlProc, "CTe" )
         XmlInfCteComTag := XmlNode( XmlProc, "CTe", .T. )
         XmlInfCte := XmlNode( XmlCte, "infCte" )
            oCte:ChaveAcesso := Substr( XmlElement( XmlInfCteComTag, "id" ), 4 )  // id minusculo
            IF Empty( oCte:ChaveAcesso )
               oCte:ChaveAcesso := Substr( XmlElement( XmlInfCteComTag, "Id" ), 4 ) // id maiusculo
            ENDIF
            XmlIde := XmlNode( XmlInfCte, "ide" )
               oCte:cNumDoc := StrZero( Val( XmlNode( XmlIde, "nCT" ) ), 9 )
               mTemp := XmlNode( XmlIde, "dhEmi" ) // Data/hora
               mTemp := Substr( mTemp, 1, 10 ) // Data aaaa-mm-dd
               mTemp := Substr( mTemp, 9, 2 ) + "/" + Substr( mTemp, 6, 2 ) + "/" + Substr( mTemp, 1, 4 )
               oCte:DataEmissao := Ctod( mTemp )
               oCte:cAmbiente   := XmlNode( XmlIde, "tpAmb" )
            XmlEmit := XmlNode( XmlInfCte, "emit" )
               oCte:Emitente:Cnpj := Trim( Transform( XmlNode( XmlEmit, "CNPJ" ), "@R 99.999.999/9999-99" ) )
               oCte:Emitente:Nome := XmlNode( XmlEmit, "xNome" )
               XmlEndereco := XmlNode( XmlEmit, "enderEmit" )
                  oCte:Emitente:Endereco := XmlNode( XmlEndereco, "xLgr" ) + " " + XmlNode( XmlEndereco, "nro" )
                  oCte:Emitente:Bairro   := XmlNode( XmlEndereco, "xBairro" )
                  oCte:Emitente:Cidade   := XmlNode( XmlEndereco, "xMun" )
                  oCte:Emitente:Uf       := XmlNode( XmlEndereco, "UF" )
                  oCte:Emitente:Cep      := Transform( XmlNode( XmlEndereco, "CEP" ), "@R 99999-999" )
                  oCte:Emitente:Telefone := XmlNode( XmlEndereco, "fone" )
            XmlRemetente := XmlNode( XmlInfCte, "rem" )
               oCte:Remetente:Cnpj := Trim( Transform( XmlNode( XmlRemetente, "CNPJ" ), "@R 99.999.999/9999-99" ) )
               oCte:Remetente:Nome := XmlNode( XmlRemetente, "xNome" )
               XmlEndereco := XmlNode( XmlRemetente, "enderReme" )
                  oCte:Remetente:Endereco := XmlNode( XmlRemetente, "xLgr" ) + " " + XmlNode( XmlEndereco, "nro" )
                  oCte:Remetente:Bairro   := XmlNode( XmlRemetente, "xBairro" )
                  oCte:Remetente:Cidade   := XmlNode( XmlRemetente, "xMun" )
                  oCte:Remetente:Uf       := XmlNode( XmlRemetente, "UF" )
                  oCte:Remetente:Cep      := Transform( XmlNode( XmlRemetente, "CEP" ), "@R 99999-999" )
                  oCte:Remetente:Telefone := XmlNode( XmlRemetente, "fone" )
            XmlDestinatario := XmlNode( XmlInfCte, "dest" )
               oCte:Destinatario:Cnpj := Trim( XmlNode( XmlDestinatario, "CNPJ" ) )
               IF Empty( oCte:Destinatario:Cnpj )
                  oCte:Destinatario:Cnpj := Transform( XmlNode( XmlDestinatario, "CPF" ), "@R 999.999.999-99" )
               ELSE
                  oCte:Destinatario:Cnpj := Transform( oCte:Destinatario:Cnpj, "@R 99.999.999/9999-99" )
               ENDIF
               oCte:Destinatario:Nome := XmlNode( XmlDestinatario, "xNome" )
               XmlEndereco := XmlNode( XmlDestinatario, "enderDest" )
                  oCte:Destinatario:Endereco := XmlNode( XmlDestinatario, "xLgr" ) + " " + XmlNode( XmlEndereco, "nro" )
                  oCte:Destinatario:Bairro   := XmlNode( XmlDestinatario, "xBairro" )
                  oCte:Destinatario:Cidade   := XmlNode( XmlDestinatario, "xMun" )
                  oCte:Destinatario:Uf       := XmlNode( XmlDestinatario, "UF" )
                  oCte:Destinatario:Cep      := XmlNode( XmlDestinatario, "CEP" )
                  oCte:Destinatario:Telefone := XmlNode( XmlDestinatario, "fone" )
               XmlPrest := XmlNode( XmlInfCte, "vPrest" )
                  oCte:Valor := Val( XmlNode(XmlPrest, "vTPrest" ) )
      oCte:PesoCarga  := Val( XmlNode( XmlCte, "vCarga" ) )
      oCte:ValorCarga := Val( XmlNode( XmlCte, "qCarga" ) )
      oCte:cAssinatura := XmlNode( XmlCte, "Signature" )
   XmlProt := XmlNode(XmlProc, "protCTe" )
      XmlInfProt := XmlNode( XmlProt, "infProt" )
      oCte:Protocolo := XmlNode( XmlInfProt, "nProt" )
      oCte:Status    := XmlNode( XmlProt, "cStat" )

   RETURN oCte

FUNCTION XmlToDocCteCancel( cXmlInput, oCTE )

   LOCAL mXmlInfCanc, mXmlInfCancComTag, mChave, mProtocolo

   mProtocolo = ""
   mChave = ""
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
      oCte:ChaveAcesso   := mChave
      oCte:Protocolo     := mProtocolo
      oCte:cAmbiente     := XmlNode( cXmlInput, "tpAmb" )
      oCte:Emitente:Cnpj := Transform( Substr( mChave, 7, 14 ), "@R 99.999.999/9999-99" )
      oCte:cNumDoc       := Substr( mChave, 26, 9 )
      oCTE:cAssinatura   := XmlNode( cXmlInput, "Signature" )
      oCte:Status        := "111"
   ENDIF

   RETURN oCte

FUNCTION TrimXml( cTexto )

   cTexto := AllTrim( cTexto )
   cTexto := StrTran( cTexto, "  ", " " )
   cTexto := StrTran( cTexto, "  ", " " )
   cTexto := StrTran( cTexto, "  ", " " )

   RETURN cTexto

FUNCTION PicNfe( cChave )

   RETURN Transform( cChave, "@R 99-99/99-99.999.999/9999-99.99.999.999999999.9.99999999.9" )
