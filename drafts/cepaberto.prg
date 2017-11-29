
STATIC FUNCTION CepAberto( cCep )

#define CEP_TOKEN "Token token=xxx"
#define CEP_URL   "http://www.cepaberto.com/api/v2/ceps.xml?cep="

   cUrl := CEP_URL + cCep
   oMSXML := win_OleCreateObject( "MSXML2.XMLHTTP" )
   oMSXML:Open( "GET", cUrl, .F. )
   oMSXML:SetRequestHeader( "Authorization", CEP_TOKEN )
   oMSXML:Send()

   RETURN oMSXML:ResponseBody

   /*
   <?xml version="1.0" encoding="UTF-8"?>
   <cep>
   <altitude>35.4</altitude>
   <bairro>Todos os Santos</bairro>
   <cep>20735050</cep>
   <latitude>-22.9004167</latitude>
   <longitude>-43.2876229</longitude>
   <logradouro>Rua Ajuratuba</logradouro>
   <cidade>Rio de Janeiro</cidade>
   <ddd>21</ddd>
   <ibge>3304557</ibge>
   <estado>RJ</estado>
   </cep>
   */
