/*
ze_spedxmlvalida - Validação de XML
2016.07.28.1620 - José Quintas
2016.09.26.1850 - Arquivo XSD como parâmetro
2016.10.04.0930 - Validações simples acrescentadas
*/

PROCEDURE PTESValidaXml

   LOCAL cRetorno, cFileXsd, cXml

   cFileXsd := hb_Cwd() + "schemmas\"
   cFileXsd += "pl_008i2_cfop_externo\nfe_v3.10.xsd"
   //cFileXsd += "pl_cte_200a_nt2015.004\cte_v2.00.xsd"
   //cFileXsd += "pl_mdfe_100a\mdfe_v1.00.xsd"
   //cFileXsd += "pl_mdfe_300\mdfe_v3.00.xsd"

   cXml     := MemoRead( "d:\jpa\cordeiro\nfe\tmp\nf000094053-02-assinado.xml" )

   Inkey(0)
   cRetorno := ValidaXml( cXml, cFileXsd )
   MsgExclamation( cRetorno )

   RETURN

FUNCTION ValidaXml( cXml, cFileXsd )

   LOCAL oXmlDomDoc, oXmlSchema, oXmlErro, cRetorno := "ERRO"

   hb_Default( @cFileXsd, "" )

   IF " <" $ cXml .OR. "> " $ cXml
      cRetorno := "Espaços inválidos no XML entre as tags"
      RETURN cRetorno
   ENDIF

   BEGIN SEQUENCE WITH __BreakBlock()

      cRetorno   := "Erro Carregando MSXML2.DomDocument.6.0"
      oXmlDomDoc := win_OleCreateObject( "MSXML2.DomDocument.6.0" )
      oXmlDomDoc:aSync            := .F.
      oXmlDomDoc:ResolveExternals := .F.
      oXmlDomDoc:ValidateOnParse  := .T.

      cRetorno   := "Erro Carregando XML"
      oXmlDomDoc:LoadXml( cXml )
      IF oXmlDomDoc:ParseError:ErrorCode <> 0
         cRetorno := "Erro XML inválido " + ;
                     " Linha: "   + AllTrim( Transform( oXmlDomDoc:ParseError:Line, "" ) ) + ;
                     " coluna: "  + AllTrim( Transform( oXmlDomDoc:ParseError:LinePos, "" ) ) + ;
                     " motivo: "  + AllTrim( Transform( oXmlDomDoc:ParseError:Reason, "" ) ) + ;
                     " errcode: " + AllTrim( Transform( oXmlDomDoc:ParseError:ErrorCode, "" ) )
          BREAK
      ENDIF

      cRetorno   := "Erro Carregando MSXML2.XMLSchemaCache.6.0"
      oXmlSchema := win_OleCreateObject( "MSXML2.XMLSchemaCache.6.0" )

      IF Empty( cFileXsd )
         cRetorno := "OK"
         BREAK
      ENDIF
      IF ! File( cFileXSD )
         cRetorno := "Erro não encontrado arquivo " + cFileXSD
         BREAK
      ENDIF

      cRetorno := "Erro Carregando " + cFileXSD
      oXmlSchema:Add( "http://www.portalfiscal.inf.br/nfe", cFileXSD )

      oXmlDomDoc:Schemas := oXmlSchema
      oXmlErro := oXmlDomDoc:Validate()
      IF oXmlErro:ErrorCode <> 0
         cRetorno := "Erro: " + AllTrim( Transform( oXmlErro:ErrorCode, "" ) ) + " " + AllTrim( Transform( oXmlErro:Reason, "" ) )
         BREAK
      ENDIF
      cRetorno := "OK"

   END SEQUENCE

   RETURN cRetorno
