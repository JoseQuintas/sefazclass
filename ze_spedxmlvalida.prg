/*
ze_spedxmlvalida - Validação de XML
2016.07.28.1620 - José Quintas
*/

PROCEDURE PTESValidaXml

   LOCAL cRetorno

   Inkey(0)
   cRetorno := ValidaXml( MemoRead( "d:\jpa\cordeiro\nfe\tmp\nf000094053-02-assinado.xml" ), "NFE" )
   MsgExclamation( cRetorno )

   RETURN

FUNCTION ValidaXml( cXml, cTipo )

   LOCAL oXmlDomDoc, oXmlSchema, oXmlErro, cFileXSD := "", cRetorno := "ERRO"

   hb_DefaultValue( @cTipo, "" )

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

      DO CASE
      CASE cTipo == "NFE" ;    cFileXSD := Left( hb_Argv(0), Rat( "\", hb_Argv(0) ) ) + "schemmas\pl_008i2_cfop_externo\nfe_v3.10.xsd"
      OTHERWISE
         cRetorno := "OK"       /* Validação básica */
         BREAK
      ENDCASE
      IF .NOT. File( cFileXSD )
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
