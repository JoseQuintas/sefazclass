#include "sefazclass.ch"

FUNCTION ze_sefaz_NFeEventoManifestacao( Self, cChave, cCnpj, cCodigoEvento, xJust, cCertificado, cAmbiente )

   LOCAL cDescEvento

   hb_Default( @cCnpj, Replicate( "0", 14 ) )
   ::cUF := "AN"

   DO CASE
   CASE cCodigoEvento == "210200" ; cDescEvento := "Confirmacao da Operacao"
   CASE cCodigoEvento == "210210" ; cDescEvento := "Ciencia da Operacao"
   CASE cCodigoEvento == "210220" ; cDescEvento := "Desconhecimento da Operacao"
   CASE cCodigoEvento == "210240" ; cDescEvento := "Operacao nao Realizada"
   ENDCASE

   ::cXmlDocumento +=       [<detEvento versao="1.00">]
   ::cXmlDocumento +=          XmlTag( "descEvento", cDescEvento )
   IF cCodigoEvento == "210240"
      ::cXmlDocumento +=          XmlTag( "xJust", xJust )
   ENDIF
   ::cXmlDocumento +=       [</detEvento>]
   ::NFeEvento( cChave, 1, cCodigoEvento, ::cXmlDocumento, cCertificado, cAmbiente, cCnpj )

   RETURN ::cXmlRetorno


