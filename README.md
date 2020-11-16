# Sefazclass

Classe com funções pra Sefaz

Crie e/ou altere \harbour\bin\hbmk.hbc

acrescente

libpaths=pasta do arquivo sefazclass.hbc


# Como funciona o Webservice do governo:

Entregar XML e receber uma resposta.

No geral, a autorização de documentos envolve duas etapas:

1. Entrega o XML que retorna um número de recibo (ou erro)
2. Consulta esse recibo que retorna o protocolo (ou erro)

Já outras etapas: cancelamento, carta de correção, inutilização, etc. envolve apenas uma etapa:

1. Entrega o XML e já obtém o protocolo (ou erro)

# E a Sefazclass:

Tem eventos que tratam cada etapa.

- Autorização de NFE, CTE, MDFE: NfeLoteEnvia(), CteLoteEnvia(), MDFeLoteEnvia()
- Cancelamento:  NfeEventoCancela(), CteEventoCancela(), MDFeEventoCancela()
- Carta de correção: NfeEventoCarta(), CteEventoCarta()
- Inutilização: NfeInutiliza(), CteInutiliza()
- Outros eventos: CteEventoDesacordo(), MdfeEventoEncerramento(), MdfeEventoInclusaoCondutor(), NfeEventoManifestacao()

Verifique o nome dos parâmetros e saberá o que informar.
Dúvidas, consulte o manual da SEFAZ, que contém todos os detalhes.

# Considerações:

- A Sefazclass não trata arquivos XMLs, e sim o conteúdo. cXML representa o conteúdo do XML
- cCertificado é o nome do certificado, veja em propriedades do certificado o CN=

A Sefazclass não inventa nada, tudo está dentro dos manuais do governo.

Para entregar os XMLs, cada UF ou serviço é para um endereço de internet diferente.
Nos fontes da Sefazclass já tem muitos desses endereços, mas não significa que tem todos, ou que estão atualizados.
Cabe ao usuário da classe fazer os testes finais e informar algum endereço errado ou inexistente.

Atualizada até:

NFE 4.00
NFCE 4.00
CTE 3.00
MDFE 3.00
