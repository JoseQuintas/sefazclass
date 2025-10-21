#include "sefazclass.ch"

FUNCTION ze_sefaz_CTeGeraEventoAutorizado( Self, cXmlAssinado, cXmlProtocolo )

   ::cProjeto := WS_PROJETO_CTE
   hb_Default( @::cVersao, WS_CTE_DEFAULT )
   cXmlAssinado  := iif( cXmlAssinado == NIL, ::cXmlDocumento, cXmlAssinado )
   cXmlProtocolo := iif( cXmlProtocolo == NIL, ::cXmlProtocolo, cXmlProtocolo )

   ::nStatus := Val( XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "cStat" ) )
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "retEventoCTe" ), "xMotivo" ) // runner
   IF hb_AScan( { 135, 155 }, { | e | e == ::nStatus } ) == 0
      ::cXmlRetorno := [<erro text="*ERRO* CteGeraEventoAutorizado() N�o autorizado" />] + cXmlProtocolo
      RETURN NIL
   ENDIF
   ::cXmlAutorizado := XML_UTF8
   ::cXmlAutorizado += [<procEventoCTe versao="] + ::cVersao + [" ] + WS_XMLNS_CTE + [>]
   ::cXmlAutorizado +=    cXmlAssinado
   ::cXmlAutorizado += [<retEventoCTe versao="] + ::cVersao + [">]
   ::cXmlAutorizado +=    XmlNode( cXmlProtocolo, "retEventoCTe" ) // hb_UTF8ToStr()
   ::cXmlAutorizado += [</retEventoCTe>]
   ::cXmlAutorizado += [</procEventoCTe>]
   ::cMotivo := XmlNode( XmlNode( cXmlProtocolo, "infEvento" ), "xMotivo" ) // hb_UTF8ToStr()

   RETURN NIL

