#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeEventoCarta( Self, cChave, nSequencia, aAlteracoes, cCertificado, cAmbiente )

   LOCAL oElement, cXml := ""

   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXml += [<detEvento versaoEvento="] + ::cVersao + [">]
   cXml +=      [<evCCeCTe>]
   cXml +=          XmlTag( "descEvento", "Carta de Correcao" )
   FOR EACH oElement IN aAlteracoes
      cXml +=       [<infCorrecao>]
      cXml +=          XmlTag( "grupoAlterado", oElement[ 1 ] )
      cXml +=          XmlTag( "campoAlterado", oElement[ 2 ] )
      cXml +=          XmlTag( "valorAlterado", oElement[ 3 ] )
      cXml +=       [</infCorrecao>]
   NEXT
   cXml +=       [<xCondUso>]
   cXml +=          "A Carta de Correcao e disciplinada pelo Art. 58-B "
   cXml +=          "do CONVENIO/SINIEF 06/89: Fica permitida a utilizacao de carta "
   cXml +=          "de correcao, para regularizacao de erro ocorrido na emissao de "
   cXml +=          "documentos fiscais relativos a prestacao de servico de transporte, "
   cXml +=          "desde que o erro nao esteja relacionado com: I - as variaveis que "
   cXml +=          "determinam o valor do imposto tais como: base de calculo, aliquota, "
   cXml +=          "diferenca de preco, quantidade, valor da prestacao;II - a correcao "
   cXml +=          "de dados cadastrais que implique mudanca do emitente, tomador, "
   cXml +=          "remetente ou do destinatario;III - a data de emissao ou de saida."
   cXml +=       [</xCondUso>]
   cXml +=    [</evCCeCTe>]
   cXml += [</detEvento>]

   ::CTeEvento( cChave, nSequencia, "110110", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

