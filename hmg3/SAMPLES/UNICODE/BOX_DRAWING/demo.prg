#include <hmg.ch>

Function Main()
// SET CODEPAGE TO UNICODE
MsgInfo(hb_UChar(0x250C)+Replicate(hb_UChar(0x2500),20)+hb_UChar(0x2510)+CRLF+; // Simple
        hb_UChar(0x2502)+Replicate(hb_UChar(0x2003),20)+hb_UChar(0x2502)+CRLF+;
        hb_UChar(0x2514)+Replicate(hb_UChar(0x2500),20)+hb_UChar(0x2518)+CRLF+;
        hb_UChar(0x250F)+Replicate(hb_UChar(0x2501),20)+hb_UChar(0x2513)+CRLF+; // Heavy
        hb_UChar(0x2503)+Replicate(hb_UChar(0x2003),20)+hb_UChar(0x2503)+CRLF+;
        hb_UChar(0x2517)+Replicate(hb_UChar(0x2501),20)+hb_UChar(0x251B)+CRLF+;
        hb_UChar(0x2554)+Replicate(hb_UChar(0x2550),20)+hb_UChar(0x2557)+CRLF+; // Double
        hb_UChar(0x2551)+Replicate(hb_UChar(0x2007),20)+hb_UChar(0x2551)+CRLF+;
        hb_UChar(0x255A)+Replicate(hb_UChar(0x2550),20)+hb_UChar(0x255D)+CRLF+;
        hb_UChar(0x2504)+Replicate(hb_UChar(0x2504),20)+hb_UChar(0x2504)+CRLF+; // Dash
        hb_UChar(0x250A)+Replicate(hb_UChar(0x2592),20)+hb_UChar(0x250A)+CRLF+;
        hb_UChar(0x2504)+Replicate(hb_UChar(0x2504),20)+hb_UChar(0x2504)+CRLF+;
        hb_UChar(0x2663)+hb_UChar(0x2752)+hb_UChar(0x2713),"Box Drawing")
Return Nil