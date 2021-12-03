/*----------------------------------------------------------------------------
 HMG - Harbour Windows GUI library source code

 Copyright 2002-2017 Roberto Lopez <mail.box.hmg@gmail.com>
 http://sites.google.com/site/hmgweb/

 Head of HMG project:

      2002-2012 Roberto Lopez <mail.box.hmg@gmail.com>
      http://sites.google.com/site/hmgweb/

      2012-2017 Dr. Claudio Soto <srvet@adinet.com.uy>
      http://srvet.blogspot.com

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of HMG.

 The exception is that, if you link the HMG library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 HMG library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2008, http://www.harbour-project.org/

	"WHAT32"
	Copyright 2002 AJ Wos <andrwos@aust1.net>

	"HWGUI"
  	Copyright 2001-2008 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

/*
  The adaptation of the source code of this file to support UNICODE character set and WIN64 architecture was made
  by Dr. Claudio Soto, November 2012 and June 2014 respectively.
  mail: <srvet@adinet.com.uy>
  blog: http://srvet.blogspot.com
*/

#include "HMG_UNICODE.h"

#include "hbapi.h"
#include "hbwinole.h"

HB_FUNC( OLE2TXTERROR )
{
   HRESULT  lOleError;

   if( HB_ISNUM( 1 ) )
      lOleError = hb_parnl( 1 );
   else
      lOleError = hb_oleGetError();

   switch( lOleError )
   {
      case S_OK:                    hb_retc_const( "S_OK" );                     break;
      case CO_E_CLASSSTRING:        hb_retc_const( "CO_E_CLASSSTRING" );         break;
      case OLE_E_WRONGCOMPOBJ:      hb_retc_const( "OLE_E_WRONGCOMPOBJ" );       break;
      case REGDB_E_CLASSNOTREG:     hb_retc_const( "REGDB_E_CLASSNOTREG" );      break;
      case REGDB_E_WRITEREGDB:      hb_retc_const( "REGDB_E_WRITEREGDB" );       break;
      case E_OUTOFMEMORY:           hb_retc_const( "E_OUTOFMEMORY" );            break;
      case E_INVALIDARG:            hb_retc_const( "E_INVALIDARG" );             break;
      case E_UNEXPECTED:            hb_retc_const( "E_UNEXPECTED" );             break;
      case E_NOTIMPL:               hb_retc_const( "E_NOTIMPL" );                break;
      case DISP_E_UNKNOWNNAME:      hb_retc_const( "DISP_E_UNKNOWNNAME" );       break;
      case DISP_E_UNKNOWNLCID:      hb_retc_const( "DISP_E_UNKNOWNLCID" );       break;
      case DISP_E_BADPARAMCOUNT:    hb_retc_const( "DISP_E_BADPARAMCOUNT" );     break;
      case DISP_E_BADVARTYPE:       hb_retc_const( "DISP_E_BADVARTYPE" );        break;
      case DISP_E_EXCEPTION:        hb_retc_const( "DISP_E_EXCEPTION" );         break;
      case DISP_E_MEMBERNOTFOUND:   hb_retc_const( "DISP_E_MEMBERNOTFOUND" );    break;
      case DISP_E_NONAMEDARGS:      hb_retc_const( "DISP_E_NONAMEDARGS" );       break;
      case DISP_E_OVERFLOW:         hb_retc_const( "DISP_E_OVERFLOW" );          break;
      case DISP_E_PARAMNOTFOUND:    hb_retc_const( "DISP_E_PARAMNOTFOUND" );     break;
      case DISP_E_TYPEMISMATCH:     hb_retc_const( "DISP_E_TYPEMISMATCH" );      break;
      case DISP_E_UNKNOWNINTERFACE: hb_retc_const( "DISP_E_UNKNOWNINTERFACE" );  break;
      case DISP_E_PARAMNOTOPTIONAL: hb_retc_const( "DISP_E_PARAMNOTOPTIONAL" );  break;
      default:
      {
         char   buf[ 16 ];

         hb_snprintf( buf, 16, "0x%08x", ( UINT ) ( HB_PTRUINT ) lOleError );
         hb_retc( buf );
      }
   }
}

HB_FUNC( __OLEPDISP )
{
   hb_oleInit();
   hb_oleItemPut( hb_param( -1, HB_IT_ANY ), ( IDispatch * ) ( HB_PTRUINT ) hb_parnint( 1 ) );
}
