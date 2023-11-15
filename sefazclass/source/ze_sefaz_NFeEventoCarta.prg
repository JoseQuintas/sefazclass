#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEventoCarta( Self, cChave, nSequencia, cTexto, cCertificado, cAmbiente )

   LOCAL cXml := ""

   cXml += [<detEvento versao="1.00">]
   cXml +=    XmlTag( "descEvento", "Carta de Correcao" )
   cXml +=    XmlTag( "xCorrecao", cTexto )
   cXml +=    [<xCondUso>]
   cXml +=    "A Carta de Correcao e disciplinada pelo paragrafo 1o-A do art. 7o do Convenio S/N, "
   cXml +=    "de 15 de dezembro de 1970 e pode ser utilizada para regularizacao de erro ocorrido na "
   cXml +=    "emissao de documento fiscal, desde que o erro nao esteja relacionado com: "
   cXml +=    "I - as variaveis que determinam o valor do imposto tais como: base de calculo, aliquota, "
   cXml +=    "diferenca de preco, quantidade, valor da operacao ou da prestacao; "
   cXml +=    "II - a correcao de dados cadastrais que implique mudanca do remetente ou do destinatario; "
   cXml +=    "III - a data de emissao ou de saida."
   cXml +=    [</xCondUso>]
   cXml += [</detEvento>]

   ::NFeEvento( cChave, nSequencia, "110110", cXml, cCertificado, cAmbiente )

   RETURN ::cXmlRetorno

