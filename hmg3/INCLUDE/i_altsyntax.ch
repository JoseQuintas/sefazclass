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
   Copyright 1999-2003, http://www.harbour-project.org/

   "WHAT32"
   Copyright 2002 AJ Wos <andrwos@aust1.net>

   "HWGUI"
   Copyright 2001-2007 Alexander S.Kresin <alex@belacy.belgorod.su>

---------------------------------------------------------------------------*/

#xcommand EDITOPTION          <editoption>         => _HMG_SYSDATA \[ 248 \]  := <editoption>

#xcommand ONKEY               <onkey>              => _HMG_SYSDATA \[ 247 \]  := <{onkey}>

#xcommand ON KEY              <onkey>              => _HMG_SYSDATA \[ 247 \]  := <{onkey}>

#xcommand ONSELECT            <onselect>           => _HMG_SYSDATA \[ 386 \]  := <{onselect}>

#xcommand ONLINK              <onlink>             => _HMG_SYSDATA \[ 387 \]  := <{onlink}>

#xcommand ONVSCROLL           <onvscroll>          => _HMG_SYSDATA \[ 388 \]  := <{onvscroll}>

#xcommand LOCKCOLUMNS         <value>              => _HMG_SYSDATA \[ 281 \]  := <value>

#xcommand DISABLEDBACKCOLOR   <value>              => _HMG_SYSDATA \[ 298 \]  := <value>

#xcommand DISABLEDFORECOLOR   <value>              => _HMG_SYSDATA \[ 299 \]  := <value>

#xcommand DISABLEDFONTCOLOR   <value>              => _HMG_SYSDATA \[ 299 \]  := <value>

#xcommand BORDERCOLOR         <color>              => _HMG_SYSDATA \[ 298 \]  := <color>

#xcommand OUTERFONTCOLOR      <color>              => _HMG_SYSDATA \[ 299 \]  := <color>

#xcommand CELLNAVIGATION      <cellnavigation>     => _HMG_SYSDATA \[ 329 \]  := <cellnavigation>

#xcommand DYNAMICDISPLAY      <value>              => _HMG_SYSDATA \[ 244 \]  := <value>

#xcommand DRAGITEMS           <dragitems>          => _HMG_SYSDATA \[ 352 \]  := <dragitems>

#xcommand MULTILINE           <multiline>          => _HMG_SYSDATA \[ 353 \]  := <multiline>

#xcommand HEADERIMAGES        <headerimages>       => _HMG_SYSDATA \[ 246 \]  := <headerimages>

#xcommand ONCANCEL            <oncancel>           => _HMG_SYSDATA \[ 299 \]  := <{oncancel}>

#xcommand ONCLOSEUP           <oncloseup>          => _HMG_SYSDATA \[ 247 \]  := <{oncloseup}>

#xcommand ON CLOSEUP          <oncloseup>          => _HMG_SYSDATA \[ 247 \]  := <{oncloseup}>

#xcommand ONDROPDOWN          <ondropdown>         => _HMG_SYSDATA \[ 248 \]  := <{ondropdown}>

#xcommand ON DROPDOWN         <ondropdown>         => _HMG_SYSDATA \[ 248 \]  := <{ondropdown}>

#xcommand DROPPEDWIDTH        <droppedwidth>       => _HMG_SYSDATA \[ 249 \]  := <droppedwidth>

#xcommand ITEMSOURCE          <itemsource, ...>    => _HMG_SYSDATA \[ 402 \]  := \{<"itemsource">\}

#xcommand VALUESOURCE         <valuesource>        => _HMG_SYSDATA \[ 403 \]  := <"valuesource">

#xcommand COLUMNCONTROLS      <editcontrols>       => _HMG_SYSDATA \[ 388 \]  := <editcontrols>

#xcommand COLUMNVALID         <columnvalid>        => _HMG_SYSDATA \[ 387 \]  := <columnvalid>

#xcommand COLUMNWHEN          <columnwhen>         => _HMG_SYSDATA \[ 386 \]  := <columnwhen>

#xcommand WORKAREA            <workarea>           => _HMG_SYSDATA \[ 480 \]  := <"workarea">

#xcommand FIELD               <field>              => _HMG_SYSDATA \[ 385 \]  := <"field">

#xcommand FIELDS              <fields>             => _HMG_SYSDATA \[ 481 \]  := <fields>

#xcommand ALLOWDELETE         <deletable>          => _HMG_SYSDATA \[ 482 \]  := <deletable>

#xcommand NOVSCROLLBAR        <nvs>                => _HMG_SYSDATA \[ 398 \]  := <nvs>

#xcommand VSCROLLBAR          <vs>                 => _HMG_SYSDATA \[ 398 \]  := .NOT. <vs>

#xcommand NOHSCROLLBAR        <nvs>                => _HMG_SYSDATA \[ 394 \]  := <nvs>

#xcommand HSCROLLBAR          <vs>                 => _HMG_SYSDATA \[ 394 \]  := .NOT. <vs>

#xcommand INPLACEEDIT         <inplaceedit>        => _HMG_SYSDATA \[ 401 \]  := <inplaceedit>

#xcommand DISPLAYITEMS        <displayitems>       => _HMG_SYSDATA \[ 354 \]  := <displayitems>

#xcommand INPUTITEMS          <inputitems>         => _HMG_SYSDATA \[ 355 \]  := <inputitems>

#xcommand DATE                <datetype>           => _HMG_SYSDATA \[ 400 \]  := <datetype>

#xcommand DATATYPE DATE                            => _HMG_SYSDATA \[ 400 \]  := .T.

#xcommand DATATYPE NUMERIC                         => _HMG_SYSDATA \[ 477 \]  := .T.

#xcommand DATATYPE CHARACTER                       => _HMG_SYSDATA \[ 477 \]  := .F.; _HMG_SYSDATA\[ 400 \] := .F.

#xcommand VALID               <valid>              => _HMG_SYSDATA \[ 483 \]  := <valid>

#xcommand VALIDMESSAGES       <validmessages>      => _HMG_SYSDATA \[ 484 \]  := <validmessages>

#xcommand READONLY            <readonly>           => _HMG_SYSDATA \[ 441 \]  := <readonly>

#xcommand VIRTUAL             <virtual>            => _HMG_SYSDATA \[ 410 \]  := <virtual>

#xcommand LOCK                <lock>               => _HMG_SYSDATA \[ 485 \]  := <lock>

#xcommand ALLOWAPPEND         <appendable>         => _HMG_SYSDATA \[ 486 \]  := <appendable>

#xcommand FONTITALIC          <i>                  => _HMG_SYSDATA \[ 413 \]  := <i>

#xcommand FONTSTRIKEOUT       <s>                  => _HMG_SYSDATA \[ 414 \]  := <s>

#xcommand FONTUNDERLINE       <u>                  => _HMG_SYSDATA \[ 415 \]  := <u>

#xcommand AUTOSIZE            <a>                  => _HMG_SYSDATA \[ 409 \]  := <a>

#xcommand ENDELLIPSES         <lvalue>             => _HMG_SYSDATA \[ 281 \]  := <lvalue>

#xcommand NOPREFIX            <lvalue>             => _HMG_SYSDATA \[ 387 \]  := <lvalue>

#xcommand ADJUSTIMAGE         <a>                  => _HMG_SYSDATA \[ 409 \]  := <a>

#xcommand SHOWHEADERS         <columnheaders>      => _HMG_SYSDATA \[ 382 \]  := <columnheaders>

#xcommand HEADERS             <headers>            => _HMG_SYSDATA \[ 445 \]  := <headers>

#xcommand HEADER              <headers>            => _HMG_SYSDATA \[ 445 \]  := <headers>

#xcommand WIDTHS              <widths>             => _HMG_SYSDATA \[ 446 \]  := <widths>

#xcommand ONDBLCLICK          <dblclick>           => _HMG_SYSDATA \[ 447 \]  := <{dblclick}>

#xcommand ON DBLCLICK         <dblclick>           => _HMG_SYSDATA \[ 447 \]  := <{dblclick}>

#xcommand ADDRESS             <address>            => _HMG_SYSDATA \[ 406 \]  := <address>

#xcommand ONHEADCLICK         <aHeadClick>         => _HMG_SYSDATA \[ 448 \]  := <aHeadClick>

#xcommand DYNAMICBACKCOLOR    <aDynamicBackColor>  => _HMG_SYSDATA \[ 391 \]  := <aDynamicBackColor>

#xcommand DYNAMICFORECOLOR    <aDynamicForeColor>  => _HMG_SYSDATA \[ 390 \]  := <aDynamicForeColor>

#xcommand TITLEBACKCOLOR      <color>              => _HMG_SYSDATA \[ 391 \]  := <color>

#xcommand TITLEFONTCOLOR      <color>              => _HMG_SYSDATA \[ 390 \]  := <color>

#xcommand VIEW                <view>               => _HMG_SYSDATA \[ 464 \]  := <view>

#xcommand ONGETBOLDDAYS       <getbolddays>        => _HMG_SYSDATA \[ 488 \]  := <getbolddays>

#xcommand ON GETBOLDDAYS      <getbolddays>        => _HMG_SYSDATA \[ 488 \]  := <getbolddays>

#xcommand ON HEADCLICK        <aHeadClick>         => _HMG_SYSDATA \[ 448 \]  := <aHeadClick>

#xcommand WHEN                <aWhenFields>        => _HMG_SYSDATA \[ 389 \]  := <aWhenFields>

#xcommand NOLINES             <nolines>            => _HMG_SYSDATA \[ 449 \]  := <nolines>

#xcommand LINES               <lines>              => _HMG_SYSDATA \[ 449 \]  := .NOT. <lines>

#xcommand IMAGE               <aImage>             => _HMG_SYSDATA \[ 450 \]  := <aImage>

#xcommand JUSTIFY             <aJustify>           => _HMG_SYSDATA \[ 451 \]  := <aJustify>

#xcommand MULTISELECT         <multiselect>        => _HMG_SYSDATA \[ 455 \]  := <multiselect>

#xcommand ALLOWEDIT           <edit>               => _HMG_SYSDATA \[ 456 \]  := <edit>

#xcommand PROGID              <progid>             => _HMG_SYSDATA \[ 356 \]  := <progid>

#xcommand SORT                <sort>               => _HMG_SYSDATA \[ 464 \]  := <sort>

#xcommand OPAQUE              <opaque>             => _HMG_SYSDATA \[ 444 \]  := <opaque>

#xcommand TRANSPARENTCOLOR    <transparentcolor>   => _HMG_SYSDATA \[ 444 \]  := <transparentcolor>

#xcommand AUTOPLAY            <autoplay>           => _HMG_SYSDATA \[ 488 \]  := <autoplay>

#xcommand CENTER              <center>             => _HMG_SYSDATA \[ 489 \]  := <center>

#xcommand FILE                <file>               => _HMG_SYSDATA \[ 487 \]  := <file>

#xcommand NOAUTOSIZEWINDOW    <noautosizewindow>   => _HMG_SYSDATA \[ 490 \]  := <noautosizewindow>

#xcommand AUTOSIZEWINDOW      <autosizewindow>     => _HMG_SYSDATA \[ 490 \]  := .NOT. <autosizewindow>

#xcommand NOAUTOSIZEMOVIE     <noautosizemovie>    => _HMG_SYSDATA \[ 384 \]  := <noautosizemovie>

#xcommand AUTOSIZEMOVIE       <autosizemovie>      => _HMG_SYSDATA \[ 384 \]  := .NOT. <autosizemovie>

#xcommand NOERRORDLG          <noerrordlg>         => _HMG_SYSDATA \[ 492 \]  := <noerrordlg>

#xcommand ERRORDLG            <errordlg>           => _HMG_SYSDATA \[ 492 \]  := .NOT. <errordlg>

#xcommand NOMENU              <nomenu>             => _HMG_SYSDATA \[ 493 \]  := <nomenu>

#xcommand MENU                <menu>               => _HMG_SYSDATA \[ 493 \]  := .NOT. <menu>

#xcommand NOOPEN              <noopen>             => _HMG_SYSDATA \[ 494 \]  := <noopen>

#xcommand OPEN                <open>               => _HMG_SYSDATA \[ 494 \]  := .NOT. <open>

#xcommand NOPLAYBAR           <noplaybar>          => _HMG_SYSDATA \[ 495 \]  := <noplaybar>

#xcommand PLAYBAR             <playbar>            => _HMG_SYSDATA \[ 495 \]  := .NOT. <playbar>

#xcommand SHOWALL             <showall>            => _HMG_SYSDATA \[ 496 \]  := <showall>

#xcommand SHOWMODE            <showmode>           => _HMG_SYSDATA \[ 497 \]  := <showmode>

#xcommand SHOWNAME            <showname>           => _HMG_SYSDATA \[ 498 \]  := <showname>

#xcommand SHOWPOSITION        <showposition>       => _HMG_SYSDATA \[ 499 \]  := <showposition>

#xcommand RANGEMIN            <lo>                 => _HMG_SYSDATA \[ 465 \]  := <lo>

#xcommand RANGEMAX            <hi>                 => _HMG_SYSDATA \[ 466 \]  := <hi>

#xcommand VERTICAL            <vertical>           => _HMG_SYSDATA \[ 467 \]  := <vertical>

#xcommand SMOOTH              <smooth>             => _HMG_SYSDATA \[ 468 \]  := <smooth>

#xcommand OPTIONS             <aOptions>           => _HMG_SYSDATA \[ 469 \]  := <aOptions>

#xcommand SPACING             <spacing>            => _HMG_SYSDATA \[ 470 \]  := <spacing>

#xcommand NOTICKS             <noticks>            => _HMG_SYSDATA \[ 471 \]  := <noticks>

#xcommand TICKMARKS           <tickmarks>          => _HMG_SYSDATA \[ 471 \]  := .NOT. <tickmarks>

#xcommand BOTH                <both>               => _HMG_SYSDATA \[ 472 \]  := <both>

#xcommand TOP                 <top>                => _HMG_SYSDATA \[ 473 \]  := <top>

#xcommand LEFT                <left>               => _HMG_SYSDATA \[ 474 \]  := <left>

#xcommand UPPERCASE           <uppercase>          => _HMG_SYSDATA \[ 475 \]  := <uppercase>

#xcommand LOWERCASE           <lowercase>          => _HMG_SYSDATA \[ 476 \]  := <lowercase>

#xcommand CASECONVERT UPPER                        => _HMG_SYSDATA \[ 475 \]  := .T.

#xcommand CASECONVERT LOWER                        => _HMG_SYSDATA \[ 476 \]  := .T.

#xcommand CASECONVERT NONE                         => _HMG_SYSDATA \[ 476 \]  := .F.; _HMG_SYSDATA \[ 475 \] := .F.

#xcommand NUMERIC             <numeric>            => _HMG_SYSDATA \[ 477 \]  := <numeric>

#xcommand PASSWORD            <password>           => _HMG_SYSDATA \[ 478 \]  := <password>

#xcommand INPUTMASK           <inputmask>          => _HMG_SYSDATA \[ 479 \]  := <inputmask>

#xcommand FORMAT              <format>             => _HMG_SYSDATA \[ 500 \]  := <format>

#xcommand NOTODAY             <notoday>            => _HMG_SYSDATA \[ 452 \]  := <notoday>

#xcommand TODAY               <today>              => _HMG_SYSDATA \[ 452 \]  := .NOT. <today>

#xcommand NOTODAYCIRCLE       <notodaycircle>      => _HMG_SYSDATA \[ 453 \]  := <notodaycircle>

#xcommand TODAYCIRCLE         <todaycircle>        => _HMG_SYSDATA \[ 453 \]  := .NOT. <todaycircle>

#xcommand WEEKNUMBERS         <weeknumbers>        => _HMG_SYSDATA \[ 454 \]  := <weeknumbers>

#xcommand ROW                 <row>                => _HMG_SYSDATA \[ 431 \]  := <row>

#xcommand COL                 <col>                => _HMG_SYSDATA \[ 432 \]  := <col>

#xcommand PARENT              <of>                 => _HMG_SYSDATA \[ 417 \]  := <"of">

#xcommand CAPTION             <caption>            => _HMG_SYSDATA \[ 418 \]  := <caption>

#xcommand ACTION              <action>             => _HMG_SYSDATA \[ 419 \]  := <{action}>

#xcommand ONCLICK             <action>             => _HMG_SYSDATA \[ 419 \]  := <{action}>

#xcommand ON CLICK            <action>             => _HMG_SYSDATA \[ 419 \]  := <{action}>

#xcommand DYNAMICFONT         <font>               => _HMG_SYSDATA \[ 453 \]  := <font>

#xcommand ONCHECKBOXCLICKED   <action>             => _HMG_SYSDATA \[ 454 \]  := <{action}>

#xcommand ON CHECKBOXCLICKED  <action>             => _HMG_SYSDATA \[ 454 \]  := <{action}>

#xcommand ON INPLACEEDITEVENT <action>             => _HMG_SYSDATA \[ 352 \]  := <{action}>

#xcommand ONINPLACEEDITEVENT  <action>             => _HMG_SYSDATA \[ 352 \]  := <{action}>

#xcommand WIDTH               <width>              => _HMG_SYSDATA \[ 420 \]  := <width>

#xcommand HEIGHT              <height>             => _HMG_SYSDATA \[ 421 \]  := <height>

#xcommand FONTNAME            <font>               => _HMG_SYSDATA \[ 422 \]  := <font>

#xcommand FONTSIZE            <size>               => _HMG_SYSDATA \[ 423 \]  := <size>

#xcommand ITEMCOUNT           <itemcount>          => _HMG_SYSDATA \[ 407 \]  := <itemcount>

#xcommand TOOLTIP             <tooltip>            => _HMG_SYSDATA \[ 424 \]  := <tooltip>

#xcommand FLAT                <flat>               => _HMG_SYSDATA \[ 425 \]  := <flat>

#xcommand ONGOTFOCUS          <ongotfocus>         => _HMG_SYSDATA \[ 426 \]  := <{ongotfocus}>

#xcommand ON GOTFOCUS         <ongotfocus>         => _HMG_SYSDATA \[ 426 \]  := <{ongotfocus}>

#xcommand ONLOSTFOCUS         <onlostfocus>        => _HMG_SYSDATA \[ 427 \]  := <{onlostfocus}>

#xcommand ON LOSTFOCUS        <onlostfocus>        => _HMG_SYSDATA \[ 427 \]  := <{onlostfocus}>

#xcommand TABSTOP             <notabstop>          => _HMG_SYSDATA \[ 428 \]  := .NOT. <notabstop>

#xcommand HELPID              <helpid>             => _HMG_SYSDATA \[ 429 \]  := <helpid>

#xcommand VISIBLE             <visible>            => _HMG_SYSDATA \[ 430 \]  := .NOT. <visible>

#xcommand PICTURE             <picture>            => _HMG_SYSDATA \[ 433 \]  := <picture>

#xcommand TRANSPARENT         <transparent>        => _HMG_SYSDATA \[ 463 \]  := <transparent>

#xcommand TRANSPARENTHEADER   <transparentheader>  => _HMG_SYSDATA \[ 452 \]  := <transparentheader>

#xcommand PICTALIGNMENT       <alignment:LEFT,RIGHT,TOP,BOTTOM> => _HMG_SYSDATA \[ 381 \] := <"alignment">

#xcommand STRETCH             <stretch>            => _HMG_SYSDATA \[ 411 \]  := <stretch>

#xcommand VALUE               <value>              => _HMG_SYSDATA \[ 434 \]  := <value>

#xcommand ONCHANGE            <onchange>           => _HMG_SYSDATA \[ 435 \]  := <{onchange}>

#xcommand ONSAVE              <onsave>             => _HMG_SYSDATA \[ 277 \]  := IF ( valtype( <onsave> ) == 'U' , NIL , <{onsave}> )

#xcommand ON CHANGE           <onchange>           => _HMG_SYSDATA \[ 435 \]  := <{onchange}>

#xcommand ON QUERYDATA        <onquerydata>        => _HMG_SYSDATA \[ 408 \]  := <{onquerydata}>

#xcommand ONQUERYDATA         <onquerydata>        => _HMG_SYSDATA \[ 408 \]  := <{onquerydata}>

#xcommand DISPLAYEDIT         <displayedit>        => _HMG_SYSDATA \[ 396 \]  := <displayedit>

#xcommand GRIPPERTEXT         <grippertext>        => _HMG_SYSDATA \[ 395 \]  := <grippertext>

#xcommand ON DISPLAYCHANGE    <displaychange>      => _HMG_SYSDATA \[ 397 \]  := <{displaychange}>

#xcommand ONDISPLAYCHANGE     <displaychange>      => _HMG_SYSDATA \[ 397 \]  := <{displaychange}>

#xcommand ITEM                <aRows>              => _HMG_SYSDATA \[ 436 \]  := <aRows>

#xcommand ITEMS               <aRows>              => _HMG_SYSDATA \[ 436 \]  := <aRows>

#xcommand ONENTER             <enter>              => _HMG_SYSDATA \[ 437 \]  := <{enter}>

#xcommand ON ENTER            <enter>              => _HMG_SYSDATA \[ 437 \]  := <{enter}>

#xcommand SHOWNONE            <shownone>           => _HMG_SYSDATA \[ 438 \]  := <shownone>

#xcommand UPDOWN              <updown>             => _HMG_SYSDATA \[ 439 \]  := <updown>

#xcommand READONLYFIELDS      <readonly>           => _HMG_SYSDATA \[ 441 \]  := <readonly>

#xcommand MAXLENGTH           <maxlength>          => _HMG_SYSDATA \[ 442 \]  := <maxlength>

#xcommand BREAK               <break>              => IF ( _HMG_SYSDATA \[ 383 \] , _HMG_SYSDATA \[ 443 \] := <break> , EVAL({|b| BREAK(b)}, <break>) )

#xcommand BACKCOLOR           <color>              => _HMG_SYSDATA \[ 457 \]  := <color>

#xcommand BACKGROUNDCOLOR     <color>              => _HMG_SYSDATA \[ 457 \]  := <color>     /* ADD */

#xcommand CENTERALIGN         <centeralign>        => _HMG_SYSDATA \[ 393 \]  := <centeralign>

#xcommand RIGHTALIGN          <rightalign>         => _HMG_SYSDATA \[ 440 \]  := <rightalign>

#xcommand ALIGNMENT RIGHT                          => _HMG_SYSDATA \[ 440 \]  := .T. ; _HMG_SYSDATA \[ 393 \] := .F.

#xcommand ALIGNMENT CENTER                         => _HMG_SYSDATA \[ 440 \]  := .F. ; _HMG_SYSDATA \[ 393 \] := .T.

#xcommand ALIGNMENT LEFT                           => _HMG_SYSDATA \[ 440 \]  := .F. ; _HMG_SYSDATA \[ 393 \] := .F.

#xcommand FONTCOLOR           <color>              => _HMG_SYSDATA \[ 458 \]  := <color>

#xcommand FORECOLOR           <color>              => _HMG_SYSDATA \[ 399 \]  := <color>

#xcommand FONTBOLD            <bold>               => _HMG_SYSDATA \[ 412 \]  := <bold>

#xcommand BORDER              <border>             => _HMG_SYSDATA \[ 459 \]  := <border>

#xcommand CLIENTEDGE          <clientedge>         => _HMG_SYSDATA \[ 460 \]  := <clientedge>

#xcommand HSCROLL             <hscroll>            => _HMG_SYSDATA \[ 461 \]  := <hscroll>

#xcommand VSCROLL             <vscroll>            => _HMG_SYSDATA \[ 462 \]  := <vscroll>

#xcommand TRANSPARENT         <transparent>        => _HMG_SYSDATA \[ 463 \]  := <transparent>

#xcommand ROWSOURCE           <value>              => _HMG_SYSDATA \[ 327 \]  := <value>

#xcommand COLUMNFIELDS        <value>              => _HMG_SYSDATA \[ 326 \]  := <value>

#xcommand BUFFERED            <value>              => _HMG_SYSDATA \[ 325 \]  := <value>

#xcommand HANDCURSOR          <handcursor>         => _HMG_SYSDATA \[ 392 \]  := <handcursor>

#xcommand WRAP                <wrap>               => _HMG_SYSDATA \[ 404 \]  := <wrap>

#xcommand INCREMENT           <increment>          => _HMG_SYSDATA \[ 405 \]  := <increment>

#xcommand HORIZONTAL          <horizontal>         => _HMG_SYSDATA \[ 357 \]  := <horizontal>



/*----------------------------------------------------------------------------
Frame
---------------------------------------------------------------------------*/


#xcommand DEFINE FRAME <name> ;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 418 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 463 \]  := .F.      ;;
   _HMG_SYSDATA \[ 444 \]     := .F.      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.


#xcommand END FRAME ;
   =>;
   _BeginFrame (;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 418 \],;
      _HMG_SYSDATA \[ 422 \],;
      _HMG_SYSDATA \[ 423 \],;
      _HMG_SYSDATA \[ 444 \],;
      _HMG_SYSDATA \[ 412 \],;
      _HMG_SYSDATA \[ 413 \],;
      _HMG_SYSDATA \[ 415 \],;
      _HMG_SYSDATA \[ 414 \],;
      _HMG_SYSDATA \[ 457 \],;
      _HMG_SYSDATA \[ 458 \],;
      _HMG_SYSDATA \[ 463 \] )


*-----------------------------------------------------------------------------*
* ACTIVEX
*-----------------------------------------------------------------------------*
#xcommand DEFINE ACTIVEX <name>;
   =>;
   _HMG_SYSDATA \[ 432 \]     := 0     ;;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := ""    ;;
   _HMG_SYSDATA \[ 431 \]     := 0     ;;
   _HMG_SYSDATA \[ 420 \]     := 0     ;;
   _HMG_SYSDATA \[ 421 \]     := 0     ;;
   _HMG_SYSDATA \[ 356 \]     := 0

#xcommand END ACTIVEX;
   =>;
   _DefineActivex(;
      _HMG_SYSDATA \[ 416 \] , ;
      _HMG_SYSDATA \[ 417 \] , ;
      _HMG_SYSDATA \[ 431 \] , ;
      _HMG_SYSDATA \[ 432 \] , ;
      _HMG_SYSDATA \[ 420 \] , ;
      _HMG_SYSDATA \[ 421 \] , ;
      _HMG_SYSDATA \[ 356 \])

/*----------------------------------------------------------------------------
List Box
---------------------------------------------------------------------------*/
#xcommand DEFINE LISTBOX <name>;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .T.      ;;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 436 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 447 \]  := NIL      ;;
   _HMG_SYSDATA \[ 455 \]  := .F.      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 443 \]     := .F.      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 428 \]     := .F.      ;;
   _HMG_SYSDATA \[ 464 \]     := .F.      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 352 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.


#xcommand END LISTBOX;
   =>;
   _HMG_SYSDATA \[ 383 \] := .F.;;
   _DefineListBox(;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 436 \],;
      _HMG_SYSDATA \[ 434 \],;
      _HMG_SYSDATA \[ 422 \],;
      _HMG_SYSDATA \[ 423 \],;
      _HMG_SYSDATA \[ 424 \],;
      _HMG_SYSDATA \[ 435 \],;
      _HMG_SYSDATA \[ 447 \],;
      _HMG_SYSDATA \[ 426 \],;
      _HMG_SYSDATA \[ 427 \],;
      _HMG_SYSDATA \[ 443 \],;
      _HMG_SYSDATA \[ 429 \],;
      _HMG_SYSDATA \[ 430 \],;
      _HMG_SYSDATA \[ 428 \],;
      _HMG_SYSDATA \[ 464 \],;
      _HMG_SYSDATA \[ 412 \],;
      _HMG_SYSDATA \[ 413 \],;
      _HMG_SYSDATA \[ 415 \],;
      _HMG_SYSDATA \[ 414 \],;
      _HMG_SYSDATA \[ 457 \],;
      _HMG_SYSDATA \[ 458 \],;
      _HMG_SYSDATA \[ 455 \],;
      _HMG_SYSDATA \[ 352 \] )

///////////////////////////////////////////////////////////////////////////////
// ANIMATEBOX COMMANDS
///////////////////////////////////////////////////////////////////////////////

#xcommand DEFINE ANIMATEBOX <name>;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 488 \]     := .F.      ;;
   _HMG_SYSDATA \[ 489 \]     := .F.      ;;
   _HMG_SYSDATA \[ 463 \]  := .F.      ;;
   _HMG_SYSDATA \[ 487 \]     := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL


#xcommand END ANIMATEBOX;
   =>;
   _DefineAnimateBox(;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 488 \],;
      _HMG_SYSDATA \[ 489 \],;
      _HMG_SYSDATA \[ 463 \],;
      _HMG_SYSDATA \[ 487 \],;
      _HMG_SYSDATA \[ 429 \])

#xcommand DEFINE PLAYER <name> ;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 487 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 490 \]  := .F.      ;;
   _HMG_SYSDATA \[ 384 \]  := .F.      ;;
   _HMG_SYSDATA \[ 492 \]  := .F.      ;;
   _HMG_SYSDATA \[ 493 \]     := .F.      ;;
   _HMG_SYSDATA \[ 494 \]     := .F.      ;;
   _HMG_SYSDATA \[ 495 \]     := .F.      ;;
   _HMG_SYSDATA \[ 496 \]     := .F.      ;;
   _HMG_SYSDATA \[ 497 \]     := .F.      ;;
   _HMG_SYSDATA \[ 498 \]     := .F.      ;;
   _HMG_SYSDATA \[ 499 \]  := .F.      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL


#xcommand END PLAYER;
   =>;
   _DefinePlayer(;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 487 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 490 \],;
      _HMG_SYSDATA \[ 384 \],;
      _HMG_SYSDATA \[ 492 \],;
      _HMG_SYSDATA \[ 493 \],;
      _HMG_SYSDATA \[ 494 \],;
      _HMG_SYSDATA \[ 495 \],;
      _HMG_SYSDATA \[ 496 \],;
      _HMG_SYSDATA \[ 497 \],;
      _HMG_SYSDATA \[ 498 \],;
      _HMG_SYSDATA \[ 499 \],;
      _HMG_SYSDATA \[ 429 \])

/*----------------------------------------------------------------------------
Progress Bar
---------------------------------------------------------------------------*/


#xcommand DEFINE PROGRESSBAR <name>;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 465 \]     := NIL      ;;
   _HMG_SYSDATA \[ 466 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 467 \]     := .F.      ;;
   _HMG_SYSDATA \[ 468 \]     := .F.      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 399 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL


#xcommand END PROGRESSBAR;
   =>;
   _DefineProgressBar(;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 465 \],;
      _HMG_SYSDATA \[ 466 \],;
      _HMG_SYSDATA \[ 424 \],;
      _HMG_SYSDATA \[ 467 \],;
      _HMG_SYSDATA \[ 468 \],;
      _HMG_SYSDATA \[ 429 \],;
      _HMG_SYSDATA \[ 430 \],;
      _HMG_SYSDATA \[ 434 \] , _HMG_SYSDATA \[ 457 \] , _HMG_SYSDATA \[ 399 \] )


/*----------------------------------------------------------------------------
Radio Group
---------------------------------------------------------------------------*/

#xcommand DEFINE RADIOGROUP <name>;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 469 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 470 \]     := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 428 \]     := .F.      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 463 \]  := .F.      ;;
   _HMG_SYSDATA \[ 357 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.


#xcommand END RADIOGROUP;
   =>;
   _DefineradioGroup(;
      _HMG_SYSDATA \[ 416 \] , ;
      _HMG_SYSDATA \[ 417 \] , ;
      _HMG_SYSDATA \[ 432 \] , ;
      _HMG_SYSDATA \[ 431 \] , ;
      _HMG_SYSDATA \[ 469 \] , ;
      _HMG_SYSDATA \[ 434 \] , ;
      _HMG_SYSDATA \[ 422 \] , ;
      _HMG_SYSDATA \[ 423 \] , ;
      _HMG_SYSDATA \[ 424 \] , ;
      _HMG_SYSDATA \[ 435 \] , ;
      _HMG_SYSDATA \[ 420 \] , ;
      _HMG_SYSDATA \[ 470 \] , ;
      _HMG_SYSDATA \[ 429 \] , ;
      _HMG_SYSDATA \[ 430 \] , ;
      _HMG_SYSDATA \[ 428 \] , ;
      _HMG_SYSDATA \[ 412 \] , ;
      _HMG_SYSDATA \[ 413 \] , ;
      _HMG_SYSDATA \[ 415 \] , ;
      _HMG_SYSDATA \[ 414 \] , ;
      _HMG_SYSDATA \[ 457 \] , ;
      _HMG_SYSDATA \[ 458 \] , ;
      _HMG_SYSDATA \[ 463 \] , ;
      _HMG_SYSDATA \[ 441 \] , _HMG_SYSDATA \[ 357 \] )


/*----------------------------------------------------------------------------
Slider
---------------------------------------------------------------------------*/

#xcommand DEFINE SLIDER <name>;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 465 \]     := NIL      ;;
   _HMG_SYSDATA \[ 466 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 467 \]     := .F.      ;;
   _HMG_SYSDATA \[ 471 \]     := .F.      ;;
   _HMG_SYSDATA \[ 472 \]     := .F.      ;;
   _HMG_SYSDATA \[ 473 \]     := .F.      ;;
   _HMG_SYSDATA \[ 474 \]     := .F.      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 428 \]     := .F.      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL


#xcommand END SLIDER;
   =>;
   _DefineSlider(;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 465 \],;
      _HMG_SYSDATA \[ 466 \],;
      _HMG_SYSDATA \[ 434 \],;
      _HMG_SYSDATA \[ 424 \],;
      _HMG_SYSDATA \[ 435 \],;
      _HMG_SYSDATA \[ 467 \],;
      _HMG_SYSDATA \[ 471 \],;
      _HMG_SYSDATA \[ 472 \],;
      _HMG_SYSDATA \[ 473 \],;
      _HMG_SYSDATA \[ 474 \],;
      _HMG_SYSDATA \[ 429 \],;
      _HMG_SYSDATA \[ 430 \] ,;
      _HMG_SYSDATA \[ 428 \] , ;
      _HMG_SYSDATA \[ 457 \] )

/*----------------------------------------------------------------------------
Text Box
---------------------------------------------------------------------------*/

#xcommand DEFINE TEXTBOX <name>;
   =>;
   _HMG_SYSDATA \[ 416 \]  := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]  := NIL      ;;
   _HMG_SYSDATA \[ 432 \]  := NIL      ;;
   _HMG_SYSDATA \[ 298 \]     := NIL      ;;
   _HMG_SYSDATA \[ 299 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]  := NIL      ;;
   _HMG_SYSDATA \[ 420 \]  := NIL      ;;
   _HMG_SYSDATA \[ 421 \]  := NIL      ;;
   _HMG_SYSDATA \[ 434 \]  := NIL      ;;
   _HMG_SYSDATA \[ 422 \]  := NIL      ;;
        _HMG_SYSDATA \[ 385 \]     := NIL          ;;
   _HMG_SYSDATA \[ 423 \]  := NIL      ;;
   _HMG_SYSDATA \[ 424 \]  := NIL      ;;
   _HMG_SYSDATA \[ 442 \]  := NIL      ;;
   _HMG_SYSDATA \[ 475 \]  := .F.      ;;
   _HMG_SYSDATA \[ 476 \]  := .F.      ;;
   _HMG_SYSDATA \[ 477 \]  := .F.      ;;
   _HMG_SYSDATA \[ 478 \]  := .F.      ;;
   _HMG_SYSDATA \[ 427 \] := NIL ;;
   _HMG_SYSDATA \[ 426 \] := NIL    ;;
   _HMG_SYSDATA \[ 435 \]  := NIL      ;;
   _HMG_SYSDATA \[ 437 \]  := NIL      ;;
   _HMG_SYSDATA \[ 440 \] := .F.    ;;
        _HMG_SYSDATA \[ 441 \]   := .F.         ;;
        _HMG_SYSDATA \[ 400 \]   := .F.         ;;
        _HMG_SYSDATA \[ 429 \]    := NIL          ;;
   _HMG_SYSDATA \[ 479 \]  := NIL      ;;
   _HMG_SYSDATA \[ 500 \]  := NIL      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 428 \]     := .F.      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.


#xcommand END TEXTBOX;
   =>;
   iif(_HMG_SYSDATA \[ 479 \] == NIL .and. _HMG_SYSDATA \[ 400 \] == .F. ,;
      _DefineTextBox(;
         _HMG_SYSDATA \[ 416 \],;
         _HMG_SYSDATA \[ 417 \],;
         _HMG_SYSDATA \[ 432 \],;
         _HMG_SYSDATA \[ 431 \],;
         _HMG_SYSDATA \[ 420 \],;
         _HMG_SYSDATA \[ 421 \],;
         _HMG_SYSDATA \[ 434 \],;
         _HMG_SYSDATA \[ 422 \],;
         _HMG_SYSDATA \[ 423 \],;
         _HMG_SYSDATA \[ 424 \],;
         _HMG_SYSDATA \[ 442 \],;
         _HMG_SYSDATA \[ 475 \],;
         _HMG_SYSDATA \[ 476 \],;
         _HMG_SYSDATA \[ 477 \],;
         _HMG_SYSDATA \[ 478 \],;
         _HMG_SYSDATA \[ 427 \],;
         _HMG_SYSDATA \[ 426 \],;
         _HMG_SYSDATA \[ 435 \],;
         _HMG_SYSDATA \[ 437 \],;
         _HMG_SYSDATA \[ 440 \],;
                        _HMG_SYSDATA \[ 429 \] , ;
                        _HMG_SYSDATA \[ 441 \],;
                        _HMG_SYSDATA \[ 412 \] , ;
                        _HMG_SYSDATA \[ 413 \] , ;
                        _HMG_SYSDATA \[ 415 \] , ;
                        _HMG_SYSDATA \[ 414 \] ,;
                        _HMG_SYSDATA \[ 385 \],_HMG_SYSDATA \[ 457 \],_HMG_SYSDATA \[ 458 \],_HMG_SYSDATA \[ 430 \],_HMG_SYSDATA \[ 428 \] , _HMG_SYSDATA \[ 298 \] , _HMG_SYSDATA \[ 299 \] );
   ,;
      IF ( _HMG_SYSDATA \[ 477 \] == .T. , _DefineMaskedTextBox(;
         _HMG_SYSDATA \[ 416 \],;
         _HMG_SYSDATA \[ 417 \],;
         _HMG_SYSDATA \[ 432 \],;
         _HMG_SYSDATA \[ 431 \],;
         _HMG_SYSDATA \[ 479 \],;
         _HMG_SYSDATA \[ 420 \],;
         _HMG_SYSDATA \[ 434 \],;
         _HMG_SYSDATA \[ 422 \],;
         _HMG_SYSDATA \[ 423 \],;
         _HMG_SYSDATA \[ 424 \],;
         _HMG_SYSDATA \[ 427 \],;
         _HMG_SYSDATA \[ 426 \],;
         _HMG_SYSDATA \[ 435 \],;
         _HMG_SYSDATA \[ 421 \],;
         _HMG_SYSDATA \[ 437 \],;
         _HMG_SYSDATA \[ 440 \],;
         _HMG_SYSDATA \[ 429 \],;
                        _HMG_SYSDATA \[ 500 \] , ;
                        _HMG_SYSDATA \[ 412 \] , ;
                        _HMG_SYSDATA \[ 413 \] , ;
                        _HMG_SYSDATA \[ 415 \] , ;
                        _HMG_SYSDATA \[ 414 \],;
                        _HMG_SYSDATA \[ 385 \],_HMG_SYSDATA \[ 457 \],_HMG_SYSDATA \[ 458 \],_HMG_SYSDATA \[ 441 \],_HMG_SYSDATA \[ 430 \],_HMG_SYSDATA \[ 428 \] , _HMG_SYSDATA \[ 298 \] , _HMG_SYSDATA \[ 299 \] ) , _DefineCharMaskTextBox ( _HMG_SYSDATA \[ 416 \] , _HMG_SYSDATA \[ 417 \], _HMG_SYSDATA \[ 432 \], _HMG_SYSDATA \[ 431 \], _HMG_SYSDATA \[ 479 \] , _HMG_SYSDATA \[ 420 \] , _HMG_SYSDATA \[ 434 \] , _HMG_SYSDATA \[ 422 \] , _HMG_SYSDATA \[ 423 \] , _HMG_SYSDATA \[ 424 \] , _HMG_SYSDATA \[ 427 \] , _HMG_SYSDATA \[ 426 \] , _HMG_SYSDATA \[ 435 \] , _HMG_SYSDATA \[ 421 \] , _HMG_SYSDATA \[ 437 \] , _HMG_SYSDATA \[ 440 \] , _HMG_SYSDATA \[ 429 \] , _HMG_SYSDATA \[ 412 \] , _HMG_SYSDATA \[ 413 \] , _HMG_SYSDATA \[ 415 \] , _HMG_SYSDATA \[ 414 \] , _HMG_SYSDATA \[ 385 \] , _HMG_SYSDATA \[ 457 \] , _HMG_SYSDATA \[ 458 \] , _HMG_SYSDATA \[ 400 \] , _HMG_SYSDATA \[ 441 \] , _HMG_SYSDATA \[ 430 \] , _HMG_SYSDATA \[ 428 \] , _HMG_SYSDATA \[ 298 \] , _HMG_SYSDATA \[ 299 \] ) ) ;
   )

/*----------------------------------------------------------------------------
Month Calendar
---------------------------------------------------------------------------*/

#xcommand DEFINE MONTHCALENDAR <name> ;
  =>;
  _HMG_SYSDATA \[ 416 \]    := <"name"> ;;
  _HMG_SYSDATA \[ 417 \]    := NIL    ;;
  _HMG_SYSDATA \[ 432 \]    := NIL    ;;
  _HMG_SYSDATA \[ 431 \]    := NIL    ;;
  _HMG_SYSDATA \[ 420 \]    := NIL    ;;
  _HMG_SYSDATA \[ 421 \]    := NIL    ;;
  _HMG_SYSDATA \[ 434 \]    := NIL    ;;
  _HMG_SYSDATA \[ 422 \]    := NIL    ;;
  _HMG_SYSDATA \[ 423 \]    := NIL    ;;
  _HMG_SYSDATA \[ 424 \]    := NIL    ;;
  _HMG_SYSDATA \[ 452 \]    := .F.    ;;
  _HMG_SYSDATA \[ 453 \]  := .F.    ;;
  _HMG_SYSDATA \[ 454 \]  := .F.    ;;
  _HMG_SYSDATA \[ 435 \]    := NIL    ;;
  _HMG_SYSDATA \[ 429 \]    := NIL    ;;
  _HMG_SYSDATA \[ 430 \]    := .F.    ;;
  _HMG_SYSDATA \[ 428 \]    := .F.    ;;
  _HMG_SYSDATA \[ 412 \]    := .F.    ;;
  _HMG_SYSDATA \[ 413 \]  := .F.    ;;
  _HMG_SYSDATA \[ 415 \]  := .F.    ;;
  _HMG_SYSDATA \[ 414 \]  := .F.    ;;
  _HMG_SYSDATA \[ 458 \]    := NIL    ;;
  _HMG_SYSDATA \[ 299 \]    := NIL    ;;
  _HMG_SYSDATA \[ 457 \]    := NIL    ;;
  _HMG_SYSDATA \[ 298 \]    := NIL    ;;
  _HMG_SYSDATA \[ 390 \]    := NIL    ;;
  _HMG_SYSDATA \[ 391 \]    := NIL    ;;
  _HMG_SYSDATA \[ 465 \]    := NIL    ;;
  _HMG_SYSDATA \[ 466 \]    := NIL    ;;
  _HMG_SYSDATA \[ 464 \]    := NIL    ;;
  _HMG_SYSDATA \[ 488 \]    := NIL

#xcommand END MONTHCALENDAR;
  =>;
  _DefineMonthCal (;
    _HMG_SYSDATA \[ 416 \],;
    _HMG_SYSDATA \[ 417 \],;
    _HMG_SYSDATA \[ 432 \],;
    _HMG_SYSDATA \[ 431 \],;
    _HMG_SYSDATA \[ 420 \],;
    _HMG_SYSDATA \[ 421 \],;
    _HMG_SYSDATA \[ 434 \],;
    _HMG_SYSDATA \[ 422 \],;
    _HMG_SYSDATA \[ 423 \],;
    _HMG_SYSDATA \[ 424 \],;
    _HMG_SYSDATA \[ 452 \],;
    _HMG_SYSDATA \[ 453 \],;
    _HMG_SYSDATA \[ 454 \],;
    _HMG_SYSDATA \[ 435 \],;
    _HMG_SYSDATA \[ 429 \],;
    _HMG_SYSDATA \[ 430 \],;
    _HMG_SYSDATA \[ 428 \],;
    _HMG_SYSDATA \[ 412 \],;
    _HMG_SYSDATA \[ 413 \],;
    _HMG_SYSDATA \[ 415 \],;
    _HMG_SYSDATA \[ 414 \],;
    _HMG_SYSDATA \[ 458 \],;
    _HMG_SYSDATA \[ 299 \],;
    _HMG_SYSDATA \[ 457 \],;
    _HMG_SYSDATA \[ 298 \],;
    _HMG_SYSDATA \[ 390 \],;
    _HMG_SYSDATA \[ 391 \],;
    _HMG_SYSDATA \[ 465 \],;
    _HMG_SYSDATA \[ 466 \],;
    _HMG_SYSDATA \[ 464 \],;
    _HMG_SYSDATA \[ 488 \] )

/*----------------------------------------------------------------------------
Button
---------------------------------------------------------------------------*/

#xcommand DEFINE BUTTON <name> ;
        =>;
        _HMG_SYSDATA \[ 416 \]              := <"name"> ;;
        _HMG_SYSDATA \[ 417 \]                := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
        _HMG_SYSDATA \[ 418 \]           := NIL      ;;
        _HMG_SYSDATA \[ 419 \]            := NIL      ;;
        _HMG_SYSDATA \[ 420 \]             := NIL      ;;
        _HMG_SYSDATA \[ 421 \]            := NIL      ;;
        _HMG_SYSDATA \[ 422 \]              := NIL      ;;
        _HMG_SYSDATA \[ 423 \]              := NIL      ;;
        _HMG_SYSDATA \[ 424 \]           := NIL      ;;
        _HMG_SYSDATA \[ 425 \]              := .F.      ;;
        _HMG_SYSDATA \[ 426 \]        := NIL      ;;
        _HMG_SYSDATA \[ 427 \]       := NIL      ;;
        _HMG_SYSDATA \[ 428 \]         := .F.      ;;
        _HMG_SYSDATA \[ 429 \]            := NIL      ;;
        _HMG_SYSDATA \[ 430 \]         := .F.      ;;
        _HMG_SYSDATA \[ 431 \]               := NIL      ;;
        _HMG_SYSDATA \[ 432 \]               := NIL      ;;
        _HMG_SYSDATA \[ 433 \]           := NIL      ;;
        _HMG_SYSDATA \[ 463 \]     := .T.    ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 353 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.


#xcommand END BUTTON ;
        =>;
        iif ( _HMG_SYSDATA \[ 433 \] == NIL ,;
            _DefineButton (;
          _HMG_SYSDATA \[ 416 \],;
          _HMG_SYSDATA \[ 417 \] ,;
          _HMG_SYSDATA \[ 432 \] ,;
          _HMG_SYSDATA \[ 431 \] ,;
          _HMG_SYSDATA \[ 418 \] ,;
          _HMG_SYSDATA \[ 419 \] ,;
          _HMG_SYSDATA \[ 420 \] ,;
          _HMG_SYSDATA \[ 421 \] ,;
          _HMG_SYSDATA \[ 422 \] ,;
          _HMG_SYSDATA \[ 423 \] ,;
          _HMG_SYSDATA \[ 424 \] ,;
          _HMG_SYSDATA \[ 426 \]  ,;
          _HMG_SYSDATA \[ 427 \] ,;
          _HMG_SYSDATA \[ 425 \] ,;
          _HMG_SYSDATA \[ 428 \]  ,;
          _HMG_SYSDATA \[ 429 \] ,;
          _HMG_SYSDATA \[ 430 \] , ;
      _HMG_SYSDATA \[ 412 \] , ;
      _HMG_SYSDATA \[ 413 \] , ;
      _HMG_SYSDATA \[ 415 \] , ;
      _HMG_SYSDATA \[ 414 \] , _HMG_SYSDATA \[ 353 \] ;
      ) ,;
      iif ( _HMG_SYSDATA \[ 418 \] == NIL , ;
      _DefineImageButton (;
          _HMG_SYSDATA \[ 416 \],;
          _HMG_SYSDATA \[ 417 \],;
          _HMG_SYSDATA \[ 432 \],;
          _HMG_SYSDATA \[ 431 \],;
          "",;
          _HMG_SYSDATA \[ 419 \] ,;
          _HMG_SYSDATA \[ 420 \] ,;
          _HMG_SYSDATA \[ 421 \] ,;
          _HMG_SYSDATA \[ 433 \] ,;
          _HMG_SYSDATA \[ 424 \] ,;
          _HMG_SYSDATA \[ 426 \]  ,;
          _HMG_SYSDATA \[ 427 \]  ,;
          _HMG_SYSDATA \[ 425 \]  ,;
           .NOT. (_HMG_SYSDATA \[ 463 \]) ,;
          _HMG_SYSDATA \[ 429 \] ,;
          _HMG_SYSDATA \[ 430 \] , _HMG_SYSDATA \[ 428 \] ) , ;
         _DefineMixedButton ( ;
          _HMG_SYSDATA \[ 416 \],;
          _HMG_SYSDATA \[ 417 \] ,;
          _HMG_SYSDATA \[ 432 \] ,;
          _HMG_SYSDATA \[ 431 \] ,;
          _HMG_SYSDATA \[ 418 \] ,;
          _HMG_SYSDATA \[ 419 \] ,;
          _HMG_SYSDATA \[ 420 \] ,;
          _HMG_SYSDATA \[ 421 \] ,;
          _HMG_SYSDATA \[ 422 \] ,;
          _HMG_SYSDATA \[ 423 \] ,;
          _HMG_SYSDATA \[ 424 \] ,;
          _HMG_SYSDATA \[ 426 \]  ,;
          _HMG_SYSDATA \[ 427 \] ,;
          _HMG_SYSDATA \[ 425 \] ,;
          _HMG_SYSDATA \[ 428 \]  ,;
          _HMG_SYSDATA \[ 429 \] ,;
          _HMG_SYSDATA \[ 430 \] , ;
      _HMG_SYSDATA \[ 412 \] , ;
      _HMG_SYSDATA \[ 413 \] , ;
      _HMG_SYSDATA \[ 415 \] , ;
      _HMG_SYSDATA \[ 414 \] , _HMG_SYSDATA \[ 433 \] , _HMG_SYSDATA \[ 381 \] , _HMG_SYSDATA \[ 353 \], ;
          .NOT.(_HMG_SYSDATA \[ 463 \]) ) ) )

/*----------------------------------------------------------------------------
Image
---------------------------------------------------------------------------*/


#xcommand DEFINE IMAGE <name> ;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 433 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 419 \]     := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 411 \]     := .F.      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 463 \]     := .F.      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 409 \]     := .F.      ;;
   _HMG_SYSDATA \[ 444 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL

#xcommand END IMAGE ;
   =>;
   _DefineImage(;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 433 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 419 \],;
      _HMG_SYSDATA \[ 429 \],;
      _HMG_SYSDATA \[ 430 \],;
      _HMG_SYSDATA \[ 411 \],;
      _HMG_SYSDATA \[ 463 \],;
      _HMG_SYSDATA \[ 457 \],;
      _HMG_SYSDATA \[ 409 \],;
      _HMG_SYSDATA \[ 444 \],;
      _HMG_SYSDATA \[ 424 \] )



/*----------------------------------------------------------------------------
Check Box/Button
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKBOX <name> ;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name">    ;;
   _HMG_SYSDATA \[ 417 \]        := NIL         ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 418 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
        _HMG_SYSDATA \[ 428 \]         := .F.          ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
        _HMG_SYSDATA \[ 415 \]     := .F.          ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 463 \]  := .F.      ;;
        _HMG_SYSDATA \[ 385 \]             := NIL;;
   _HMG_SYSDATA \[ 437 \] := NIL

#xcommand DEFINE CHECKBUTTON <name> ;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name">    ;;
   _HMG_SYSDATA \[ 417 \]        := NIL         ;;
   _HMG_SYSDATA \[ 418 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
        _HMG_SYSDATA \[ 433 \]           := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
        _HMG_SYSDATA \[ 415 \]     := .F.          ;;
        _HMG_SYSDATA \[ 428 \]         := .F.          ;;
        _HMG_SYSDATA \[ 385 \] := NIL;;
        _HMG_SYSDATA \[ 463 \] := .T.;;
        _HMG_SYSDATA \[ 437 \] := NIL

#xcommand END CHECKBOX ;
   =>;
   _DefineCheckBox (;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 418 \],;
      _HMG_SYSDATA \[ 434 \],;
      _HMG_SYSDATA \[ 422 \],;
      _HMG_SYSDATA \[ 423 \],;
      _HMG_SYSDATA \[ 424 \],;
      _HMG_SYSDATA \[ 435 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 427 \],;
      _HMG_SYSDATA \[ 426 \],;
      _HMG_SYSDATA \[ 429 \],;
                _HMG_SYSDATA \[ 430 \],;
                _HMG_SYSDATA \[ 428 \],;
                _HMG_SYSDATA \[ 412 \] ,;
                _HMG_SYSDATA \[ 413 \] , ;
                _HMG_SYSDATA \[ 415 \] , ;
                _HMG_SYSDATA \[ 414 \],;
                _HMG_SYSDATA \[ 385 \] ,_HMG_SYSDATA \[ 457 \],_HMG_SYSDATA \[ 458 \] , _HMG_SYSDATA \[ 463 \], _HMG_SYSDATA \[ 437 \] )

#xcommand END CHECKBUTTON ;
   =>;
   IIF ( _HMG_SYSDATA \[ 433 \] == NIL , _DefineCheckButton (;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 418 \],;
      _HMG_SYSDATA \[ 434 \],;
      _HMG_SYSDATA \[ 422 \],;
      _HMG_SYSDATA \[ 423 \],;
      _HMG_SYSDATA \[ 424 \],;
      _HMG_SYSDATA \[ 435 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 427 \],;
      _HMG_SYSDATA \[ 426 \],;
      _HMG_SYSDATA \[ 429 \],;
                _HMG_SYSDATA \[ 430 \]  , ;
                _HMG_SYSDATA \[ 428 \] ,;
                _HMG_SYSDATA \[ 412 \] , ;
                _HMG_SYSDATA \[ 413 \] , ;
                _HMG_SYSDATA \[ 415 \] , ;
                _HMG_SYSDATA \[ 414 \] , _HMG_SYSDATA \[ 437 \] ) , ;
           _DefineImageCheckButton ( ;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 433 \],;
      _HMG_SYSDATA \[ 434 \],;
      "" ,;
      0 , ;
      _HMG_SYSDATA \[ 424 \]  , ;
      _HMG_SYSDATA \[ 435 \]  , ;
      _HMG_SYSDATA \[ 420 \] , ;
      _HMG_SYSDATA \[ 421 \] , ;
      _HMG_SYSDATA \[ 427 \], ;
      _HMG_SYSDATA \[ 426 \] , ;
      _HMG_SYSDATA \[ 429 \], ;
      _HMG_SYSDATA \[ 430 \] ,;
      _HMG_SYSDATA \[ 428 \] ,;
      .NOT. _HMG_SYSDATA \[ 463 \], _HMG_SYSDATA \[ 437 \] ) )

/*----------------------------------------------------------------------------
Combo Box
---------------------------------------------------------------------------*/

#xcommand DEFINE COMBOBOX <name>;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .T.      ;;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]  := NIL      ;;
   _HMG_SYSDATA \[ 436 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]  := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 428 \]  := .F.      ;;
   _HMG_SYSDATA \[ 464 \]     := .F.      ;;
   _HMG_SYSDATA \[ 435 \]  := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 437 \]  := NIL      ;;
   _HMG_SYSDATA \[ 429 \]  := NIL      ;;
   _HMG_SYSDATA \[ 430 \]  := .F.      ;;
   _HMG_SYSDATA \[ 412 \]  := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 402 \]   := NIL     ;;
   _HMG_SYSDATA \[ 403 \]  := NIL      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 443 \]     := .F.      ;;
   _HMG_SYSDATA \[ 395 \]  := ""    ;;
   _HMG_SYSDATA \[ 396 \]  := .F.      ;;
   _HMG_SYSDATA \[ 397 \] := NIL    ;;
   _HMG_SYSDATA \[ 450 \] := NIL    ;;
   _HMG_SYSDATA \[ 249 \] := NIL    ;;
   _HMG_SYSDATA \[ 248 \] := NIL    ;;
   _HMG_SYSDATA \[ 247 \] := NIL    ;;
   _HMG_SYSDATA \[ 415 \]  := .F.;;
   _HMG_SYSDATA \[ 299 \] := NIL;;
   _HMG_SYSDATA \[ 463 \] := .T.

#xcommand END COMBOBOX ;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .F.      ;;
   _DefineCombo (;
      _HMG_SYSDATA \[ 416 \] , ;
      _HMG_SYSDATA \[ 417 \] , ;
      _HMG_SYSDATA \[ 432 \] , ;
      _HMG_SYSDATA \[ 431 \] , ;
      _HMG_SYSDATA \[ 420 \] , ;
      _HMG_SYSDATA \[ 436 \] , ;
      _HMG_SYSDATA \[ 434 \] , ;
      _HMG_SYSDATA \[ 422 \] , ;
      _HMG_SYSDATA \[ 423 \] , ;
      _HMG_SYSDATA \[ 424 \] , ;
      _HMG_SYSDATA \[ 435 \] , ;
      _HMG_SYSDATA \[ 421 \] , ;
      _HMG_SYSDATA \[ 426 \] , ;
      _HMG_SYSDATA \[ 427 \] , ;
      _HMG_SYSDATA \[ 437 \] , ;
      _HMG_SYSDATA \[ 429 \] , ;
      _HMG_SYSDATA \[ 430 \] , ;
      _HMG_SYSDATA \[ 428 \] , ;
      _HMG_SYSDATA \[ 464 \] , ;
      _HMG_SYSDATA \[ 412 \] , ;
      _HMG_SYSDATA \[ 413 \] , ;
      _HMG_SYSDATA \[ 415 \] , ;
      _HMG_SYSDATA \[ 414 \] , ;
      _HMG_SYSDATA \[ 402 \] , ;
      _HMG_SYSDATA \[ 403 \] , ;
      _HMG_SYSDATA \[ 396 \] , ;
      _HMG_SYSDATA \[ 397 \] , ;
      _HMG_SYSDATA \[ 443 \] , ;
      _HMG_SYSDATA \[ 395 \] , ;
      _HMG_SYSDATA \[ 450 \] , ;
      _HMG_SYSDATA \[ 249 \] , ;
      _HMG_SYSDATA \[ 248 \] , ;
      _HMG_SYSDATA \[ 247 \] , ;
      _HMG_SYSDATA \[ 299 \] , ;
      .not. _HMG_SYSDATA \[ 463 \] )

/*----------------------------------------------------------------------------
Datepicker
---------------------------------------------------------------------------*/


#xcommand DEFINE DATEPICKER <name> ;
   => ;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 438 \]     := .F.      ;;
   _HMG_SYSDATA \[ 439 \]     := .F.      ;;
   _HMG_SYSDATA \[ 440 \]     := .F.      ;;
   _HMG_SYSDATA \[ 426 \]     := NIL      ;;
   _HMG_SYSDATA \[ 385 \]     := NIL      ;;
   _HMG_SYSDATA \[ 428 \]     := .F.      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]     := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]     := .F.      ;;
   _HMG_SYSDATA \[ 414 \]     := .F.      ;;
   _HMG_SYSDATA \[ 437 \]     := NIL      ;;
   _HMG_SYSDATA \[ 415 \]     := .F.      ;;
   _HMG_SYSDATA \[ 500 \]     := NIL


#xcommand END DATEPICKER ;
   => ;
        _DefineDatePick (;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 434 \],;
      _HMG_SYSDATA \[ 422 \],;
      _HMG_SYSDATA \[ 423 \],;
      _HMG_SYSDATA \[ 424 \],;
      _HMG_SYSDATA \[ 435 \],;
      _HMG_SYSDATA \[ 427 \],;
      _HMG_SYSDATA \[ 426 \],;
      _HMG_SYSDATA \[ 438 \],;
      _HMG_SYSDATA \[ 439 \],;
      _HMG_SYSDATA \[ 440 \],;
      _HMG_SYSDATA \[ 429 \],;
                _HMG_SYSDATA \[ 430 \] , ;
                _HMG_SYSDATA \[ 428 \],;
                _HMG_SYSDATA \[ 412 \] , ;
                _HMG_SYSDATA \[ 413 \] , ;
                _HMG_SYSDATA \[ 415 \] , ;
                _HMG_SYSDATA \[ 414 \],;
                _HMG_SYSDATA \[ 385 \] , _HMG_SYSDATA \[ 437 \] , _HMG_SYSDATA \[ 500 \] )



/*----------------------------------------------------------------------------
Timepicker  ( by Dr. Claudio Soto, April 2013 )
---------------------------------------------------------------------------*/

#xcommand DEFINE TIMEPICKER <name> ;
      => ;
      _HMG_SYSDATA \[ 416 \]  := <"name"> ;;
      _HMG_SYSDATA \[ 417 \]  := NIL ;;
      _HMG_SYSDATA \[ 432 \]  := NIL ;;
      _HMG_SYSDATA \[ 431 \]  := NIL ;;
      _HMG_SYSDATA \[ 434 \]  := NIL ;;
      _HMG_SYSDATA \[ 420 \]  := NIL ;;
      _HMG_SYSDATA \[ 421 \]  := NIL ;;
      _HMG_SYSDATA \[ 422 \]  := NIL ;;
      _HMG_SYSDATA \[ 423 \]  := NIL ;;
      _HMG_SYSDATA \[ 424 \]  := NIL ;;
      _HMG_SYSDATA \[ 438 \]  := .F. ;;
      _HMG_SYSDATA \[ 439 \]  := .F. ;;
      _HMG_SYSDATA \[ 440 \]  := .F. ;;
      _HMG_SYSDATA \[ 426 \]  := NIL ;;
      _HMG_SYSDATA \[ 385 \]  := NIL ;;
      _HMG_SYSDATA \[ 428 \]  := .F. ;;
      _HMG_SYSDATA \[ 435 \]  := NIL ;;
      _HMG_SYSDATA \[ 427 \]  := NIL ;;
      _HMG_SYSDATA \[ 429 \]  := NIL ;;
      _HMG_SYSDATA \[ 430 \]  := .F. ;;
      _HMG_SYSDATA \[ 412 \]  := .F. ;;
      _HMG_SYSDATA \[ 413 \]  := .F. ;;
      _HMG_SYSDATA \[ 414 \]  := .F. ;;
      _HMG_SYSDATA \[ 437 \]  := NIL ;;
      _HMG_SYSDATA \[ 415 \]  := .F. ;;
      _HMG_SYSDATA \[ 500 \]  := ""


#xcommand END TIMEPICKER ;
      => ;
      _DefineTimePick (;
         _HMG_SYSDATA \[ 416 \],;
         _HMG_SYSDATA \[ 417 \],;
         _HMG_SYSDATA \[ 432 \],;
         _HMG_SYSDATA \[ 431 \],;
         _HMG_SYSDATA \[ 420 \],;
         _HMG_SYSDATA \[ 421 \],;
         _HMG_SYSDATA \[ 434 \],;
         _HMG_SYSDATA \[ 422 \],;
         _HMG_SYSDATA \[ 423 \],;
         _HMG_SYSDATA \[ 424 \],;
         _HMG_SYSDATA \[ 435 \],;
         _HMG_SYSDATA \[ 427 \],;
         _HMG_SYSDATA \[ 426 \],;
         _HMG_SYSDATA \[ 438 \],;
         _HMG_SYSDATA \[ 429 \],;
         _HMG_SYSDATA \[ 430 \],;
         _HMG_SYSDATA \[ 428 \],;
         _HMG_SYSDATA \[ 412 \],;
         _HMG_SYSDATA \[ 413 \],;
         _HMG_SYSDATA \[ 415 \],;
         _HMG_SYSDATA \[ 414 \],;
         _HMG_SYSDATA \[ 385 \],;
         _HMG_SYSDATA \[ 437 \],;
         _HMG_SYSDATA \[ 500 \] )


/*----------------------------------------------------------------------------
Edit Box
---------------------------------------------------------------------------*/

#xcommand DEFINE EDITBOX <name> ;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .T.      ;;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 298 \]     := NIL      ;;
   _HMG_SYSDATA \[ 299 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 441 \]     := .F.      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 442 \]     := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 443 \]     := .F.      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
        _HMG_SYSDATA \[ 415 \]     := .F.          ;;
        _HMG_SYSDATA \[ 428 \]         := .F.          ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
        _HMG_SYSDATA \[ 385 \]             := NIL ;;
   _HMG_SYSDATA \[ 398 \]         := .F.          ;;
   _HMG_SYSDATA \[ 394 \]         := .F.


#xcommand END EDITBOX ;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .F.      ;;
      _DefineEditBox(;
         _HMG_SYSDATA \[ 416 \],;
         _HMG_SYSDATA \[ 417 \],;
         _HMG_SYSDATA \[ 432 \],;
         _HMG_SYSDATA \[ 431 \],;
         _HMG_SYSDATA \[ 420 \],;
         _HMG_SYSDATA \[ 421 \],;
         _HMG_SYSDATA \[ 434 \],;
         _HMG_SYSDATA \[ 422 \],;
         _HMG_SYSDATA \[ 423 \],;
         _HMG_SYSDATA \[ 424 \],;
         _HMG_SYSDATA \[ 442 \],;
         _HMG_SYSDATA \[ 426 \],;
         _HMG_SYSDATA \[ 435 \],;
         _HMG_SYSDATA \[ 427 \],;
         _HMG_SYSDATA \[ 441 \],;
         _HMG_SYSDATA \[ 443 \],;
         _HMG_SYSDATA \[ 429 \],;
                        _HMG_SYSDATA \[ 430 \] , ;
                        _HMG_SYSDATA \[ 428 \] ,;
                        _HMG_SYSDATA \[ 412 \] , ;
                        _HMG_SYSDATA \[ 413 \] , ;
                        _HMG_SYSDATA \[ 415 \] , ;
                        _HMG_SYSDATA \[ 414 \] ,;
                        _HMG_SYSDATA \[ 385 \], ;
         _HMG_SYSDATA \[ 457 \], ;
         _HMG_SYSDATA \[ 458 \], ;
         _HMG_SYSDATA \[ 398 \], ;
         _HMG_SYSDATA \[ 394 \] , _HMG_SYSDATA \[ 298 \] , _HMG_SYSDATA \[ 299 \] )


/*----------------------------------------------------------------------------
Rich Edit Box
---------------------------------------------------------------------------*/

#xcommand DEFINE RICHEDITBOX <name> ;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .T.      ;;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 441 \]     := .F.      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 442 \]     := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 443 \]     := .F.      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]     := .F.          ;;
   _HMG_SYSDATA \[ 428 \]         := .F.          ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 385 \]     := NIL ;;
   _HMG_SYSDATA \[ 461 \]  := NIL ;;
   _HMG_SYSDATA \[ 462 \]  := NIL ;;
   _HMG_SYSDATA \[ 386 \]     := NIL ;;
   _HMG_SYSDATA \[ 387 \]  := NIL ;;
   _HMG_SYSDATA \[ 388 \]  := NIL

#xcommand END RICHEDITBOX ;
   =>;
      _HMG_SYSDATA \[ 383 \]     := .F.      ;;
      _DefineRichEditBox(;
         _HMG_SYSDATA \[ 416 \],;
         _HMG_SYSDATA \[ 417 \],;
         _HMG_SYSDATA \[ 432 \],;
         _HMG_SYSDATA \[ 431 \],;
         _HMG_SYSDATA \[ 420 \],;
         _HMG_SYSDATA \[ 421 \],;
         _HMG_SYSDATA \[ 434 \],;
         _HMG_SYSDATA \[ 422 \],;
         _HMG_SYSDATA \[ 423 \],;
         _HMG_SYSDATA \[ 424 \],;
         _HMG_SYSDATA \[ 442 \],;
         _HMG_SYSDATA \[ 426 \],;
         _HMG_SYSDATA \[ 435 \],;
         _HMG_SYSDATA \[ 427 \],;
         _HMG_SYSDATA \[ 441 \],;
         _HMG_SYSDATA \[ 443 \],;
         _HMG_SYSDATA \[ 429 \],;
                        _HMG_SYSDATA \[ 430 \] , ;
                        _HMG_SYSDATA \[ 428 \] ,;
                        _HMG_SYSDATA \[ 412 \] , ;
                        _HMG_SYSDATA \[ 413 \] , ;
                        _HMG_SYSDATA \[ 415 \] , ;
                        _HMG_SYSDATA \[ 414 \] ,;
                        _HMG_SYSDATA \[ 385 \],;
         _HMG_SYSDATA \[ 457 \], _HMG_SYSDATA \[ 461 \], _HMG_SYSDATA \[ 462 \],;
         _HMG_SYSDATA \[ 386 \], _HMG_SYSDATA \[ 387 \], _HMG_SYSDATA \[ 388 \]  )

/*----------------------------------------------------------------------------
Label
---------------------------------------------------------------------------*/

#xcommand DEFINE LABEL <name> ;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 459 \]     := .F.      ;;
   _HMG_SYSDATA \[ 460 \]  := .F.      ;;
   _HMG_SYSDATA \[ 461 \]     := .F.      ;;
   _HMG_SYSDATA \[ 462 \]     := .F.      ;;
   _HMG_SYSDATA \[ 463 \]  := .F.      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 419 \]     := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.      ;;
   _HMG_SYSDATA \[ 424 \]           := NIL          ;;
   _HMG_SYSDATA \[ 440 \]  := .F.      ;;
   _HMG_SYSDATA \[ 409 \]     := .F. ;;
   _HMG_SYSDATA \[ 393 \] := .F.;;
   _HMG_SYSDATA \[ 281 \]  := .F.;;
   _HMG_SYSDATA \[ 387 \]  := .F.


#xcommand END LABEL ;
   =>;
   _DefineLabel(;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 434 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 422 \],;
      _HMG_SYSDATA \[ 423 \],;
      _HMG_SYSDATA \[ 412 \],;
      _HMG_SYSDATA \[ 459 \],;
      _HMG_SYSDATA \[ 460 \],;
      _HMG_SYSDATA \[ 461 \],;
      _HMG_SYSDATA \[ 462 \],;
      _HMG_SYSDATA \[ 463 \],;
      _HMG_SYSDATA \[ 457 \],;
      _HMG_SYSDATA \[ 458 \],;
      _HMG_SYSDATA \[ 419 \],;
      _HMG_SYSDATA \[ 424 \],;
      _HMG_SYSDATA \[ 429 \],;
      _HMG_SYSDATA \[ 430 \] , ;
      _HMG_SYSDATA \[ 413 \] , ;
      _HMG_SYSDATA \[ 415 \] , ;
      _HMG_SYSDATA \[ 414 \] , ;
      _HMG_SYSDATA \[ 409 \] , ;
      _HMG_SYSDATA \[ 440 \] , ;
      _HMG_SYSDATA \[ 393 \] , ;
      _HMG_SYSDATA \[ 281 \] , ;
      _HMG_SYSDATA \[ 387 \] )

/*----------------------------------------------------------------------------
IP Address
---------------------------------------------------------------------------*/

#xcommand DEFINE IPADDRESS <name> ;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 430 \]     := .F.      ;;
        _HMG_SYSDATA \[ 428 \]         := .F.          ;;
   _HMG_SYSDATA \[ 415 \]  := .F.

#xcommand END IPADDRESS ;
=>;
   _DefineIPAddress( ;
      _HMG_SYSDATA \[ 416 \] , ;
      _HMG_SYSDATA \[ 417 \] , ;
      _HMG_SYSDATA \[ 432 \] , ;
      _HMG_SYSDATA \[ 431 \] , ;
      _HMG_SYSDATA \[ 420 \] , ;
      _HMG_SYSDATA \[ 421 \] , ;
      _HMG_SYSDATA \[ 434 \] , ;
      _HMG_SYSDATA \[ 422 \] , ;
      _HMG_SYSDATA \[ 423 \] , ;
      _HMG_SYSDATA \[ 424 \], ;
      _HMG_SYSDATA \[ 427 \] , ;
      _HMG_SYSDATA \[ 426 \] , ;
      _HMG_SYSDATA \[ 435 \] , ;
      _HMG_SYSDATA \[ 429 \]  , ;
   _HMG_SYSDATA \[ 430 \] , ;
   _HMG_SYSDATA \[ 428 \] ,;
   _HMG_SYSDATA \[ 412 \] , ;
   _HMG_SYSDATA \[ 413 \] , ;
   _HMG_SYSDATA \[ 415 \] , ;
   _HMG_SYSDATA \[ 414 \] )


/*----------------------------------------------------------------------------
Grid
---------------------------------------------------------------------------*/



#xcommand DEFINE GRID <name> ;
   =>;
   _HMG_SYSDATA \[ 383 \]  := .T.      ;;
   _HMG_SYSDATA \[ 382 \]  := NIL      ;;
   _HMG_SYSDATA \[ 416 \]  := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]  := NIL      ;;
   _HMG_SYSDATA \[ 432 \]  := NIL      ;;
   _HMG_SYSDATA \[ 431 \]  := NIL      ;;
   _HMG_SYSDATA \[ 420 \]  := NIL      ;;
   _HMG_SYSDATA \[ 421 \]  := NIL      ;;
   _HMG_SYSDATA \[ 445 \]  := NIL      ;;
   _HMG_SYSDATA \[ 446 \]  := NIL      ;;
   _HMG_SYSDATA \[ 281 \]  := NIL      ;;
   _HMG_SYSDATA \[ 436 \]  := NIL      ;;
   _HMG_SYSDATA \[ 434 \]  := NIL      ;;
   _HMG_SYSDATA \[ 422 \]  := NIL      ;;
   _HMG_SYSDATA \[ 423 \]  := NIL      ;;
   _HMG_SYSDATA \[ 424 \]  := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 435 \]  := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 447 \]  := NIL      ;;
   _HMG_SYSDATA \[ 448 \]  := NIL      ;;
   _HMG_SYSDATA \[ 449 \]  := .F.      ;;
   _HMG_SYSDATA \[ 450 \]  := NIL      ;;
   _HMG_SYSDATA \[ 451 \]  := NIL      ;;
   _HMG_SYSDATA \[ 429 \]  := NIL      ;;
   _HMG_SYSDATA \[ 455 \]  := .F.      ;;
   _HMG_SYSDATA \[ 443 \]  := .F.      ;;
   _HMG_SYSDATA \[ 412 \]  := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.      ;;
   _HMG_SYSDATA \[ 408 \]  := NIL      ;;
   _HMG_SYSDATA \[ 407 \]  := NIL      ;;
   _HMG_SYSDATA \[ 457 \]  := NIL      ;;
   _HMG_SYSDATA \[ 458 \]  := NIL      ;;
   _HMG_SYSDATA \[ 441 \]  := NIL      ;;
   _HMG_SYSDATA \[ 410 \]  := .F.      ;;
   _HMG_SYSDATA \[ 401 \]  := .F.      ;;
   _HMG_SYSDATA \[ 456 \]  := .F.      ;;
   _HMG_SYSDATA \[ 329 \]  := .F.      ;;
   _HMG_SYSDATA \[ 391 \]  := NIL      ;;
   _HMG_SYSDATA \[ 390 \]  := NIL      ;;
   _HMG_SYSDATA \[ 388 \]  := NIL      ;;
   _HMG_SYSDATA \[ 246 \]  := NIL      ;;
   _HMG_SYSDATA \[ 387 \]  := NIL      ;;
   _HMG_SYSDATA \[ 327 \]  := NIL      ;;
   _HMG_SYSDATA \[ 326 \]  := NIL      ;;
   _HMG_SYSDATA \[ 325 \]  := .F.      ;;
   _HMG_SYSDATA \[ 482 \]  := .F.      ;;
   _HMG_SYSDATA \[ 486 \]  := NIL      ;;
   _HMG_SYSDATA \[ 244 \]  := NIL      ;;
   _HMG_SYSDATA \[ 277 \]  := NIL      ;;
   _HMG_SYSDATA \[ 386 \]  := NIL   ;;
   _HMG_SYSDATA \[ 419 \]  := NIL   ;; // ON CLICK
   _HMG_SYSDATA \[ 247 \]  := NIL   ;; // ON KEY
   _HMG_SYSDATA \[ 248 \]  := NIL   ;; // EditOption
   _HMG_SYSDATA \[ 463 \]  := .T.   ;; // Transparent
   _HMG_SYSDATA \[ 453 \]  := NIL   ;; // DynamicFont
   _HMG_SYSDATA \[ 454 \]  := NIL   ;; // ON CHECKBOXCLICKED
   _HMG_SYSDATA \[ 452 \]  := .T.   ;; // TransparentHeader
   _HMG_SYSDATA \[ 352 \]  := NIL      // ON INPLACEEDITEVENT

#xcommand END GRID ;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .F.      ;;
_DefineGrid ( _HMG_SYSDATA \[ 416 \] ,       ;
      _HMG_SYSDATA \[ 417 \] ,         ;
      _HMG_SYSDATA \[ 432 \] ,         ;
      _HMG_SYSDATA \[ 431 \] ,         ;
      _HMG_SYSDATA \[ 420 \] ,      ;
      _HMG_SYSDATA \[ 421 \] ,      ;
      _HMG_SYSDATA \[ 445 \] ,      ;
      _HMG_SYSDATA \[ 446 \] ,      ;
      _HMG_SYSDATA \[ 436 \] ,      ;
      _HMG_SYSDATA \[ 434 \] ,      ;
      _HMG_SYSDATA \[ 422 \] ,      ;
      _HMG_SYSDATA \[ 423 \] ,      ;
      _HMG_SYSDATA \[ 424 \] ,      ;
      _HMG_SYSDATA \[ 435 \] ,      ;
      _HMG_SYSDATA \[ 447 \] ,   ;
      _HMG_SYSDATA \[ 448 \] ,      ;
      _HMG_SYSDATA \[ 426 \] ,      ;
      _HMG_SYSDATA \[ 427 \],    ;
      _HMG_SYSDATA \[ 449 \],    ;
      _HMG_SYSDATA \[ 450 \],    ;
      _HMG_SYSDATA \[ 451 \]  ,     ;
      _HMG_SYSDATA \[ 443 \] ,      ;
      _HMG_SYSDATA \[ 429 \] ,      ;
      _HMG_SYSDATA \[ 412 \],       ;
      _HMG_SYSDATA \[ 413 \],       ;
      _HMG_SYSDATA \[ 415 \], ;
      _HMG_SYSDATA \[ 414 \] ,   ;
      _HMG_SYSDATA \[ 410 \] ,      ;
      _HMG_SYSDATA \[ 408 \] ,      ;
      _HMG_SYSDATA \[ 407 \] ,      ;
      NIL ,;
      NIL ,;
      NIL ,;
      _HMG_SYSDATA \[ 455 \] , ;
      NIL ,;
      _HMG_SYSDATA \[ 457 \] , ;
      _HMG_SYSDATA \[ 458 \] , ;
      _HMG_SYSDATA \[ 456 \] , ;
      _HMG_SYSDATA \[ 388 \] , ;
      _HMG_SYSDATA \[ 391 \] , ;
      _HMG_SYSDATA \[ 390 \] , ;
      _HMG_SYSDATA \[ 387 \] , ;
      _HMG_SYSDATA \[ 386 \] , ;
      _HMG_SYSDATA \[ 382 \] , ;
      _HMG_SYSDATA \[ 246 \] , ;
      _HMG_SYSDATA \[ 329 \] , ;
      _HMG_SYSDATA \[ 327 \] , ;
      _HMG_SYSDATA \[ 326 \] , ;
      _HMG_SYSDATA \[ 486 \] , ;
      _HMG_SYSDATA \[ 325 \] , ;
      _HMG_SYSDATA \[ 482 \] , ;
      _HMG_SYSDATA \[ 244 \] , ;
      _HMG_SYSDATA \[ 277 \] , ;
      _HMG_SYSDATA \[ 281 \] , ;
      _HMG_SYSDATA \[ 419 \] , _HMG_SYSDATA \[ 247 \] , _HMG_SYSDATA \[ 248 \] , ;
      .not. _HMG_SYSDATA \[ 463 \] , .not. _HMG_SYSDATA \[ 452 \], _HMG_SYSDATA \[ 453 \], _HMG_SYSDATA \[ 454 \], _HMG_SYSDATA \[ 352 \] )

/*----------------------------------------------------------------------------
BROWSE
---------------------------------------------------------------------------*/

#xcommand DEFINE BROWSE <name> ;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .T.      ;;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]               := NIL          ;;
   _HMG_SYSDATA \[ 431 \]               := NIL          ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 445 \]     := NIL      ;;
   _HMG_SYSDATA \[ 446 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 447 \]  := NIL      ;;
   _HMG_SYSDATA \[ 448 \]  := NIL      ;;
   _HMG_SYSDATA \[ 449 \]     := .F.      ;;
   _HMG_SYSDATA \[ 450 \]     := NIL      ;;
   _HMG_SYSDATA \[ 451 \]     := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
        _HMG_SYSDATA \[ 456 \]              := .F.          ;;
        _HMG_SYSDATA \[ 443 \]             := .F.     ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.      ;;
   _HMG_SYSDATA \[ 480 \]     := NIL      ;;
   _HMG_SYSDATA \[ 481 \]     := NIL      ;;
   _HMG_SYSDATA \[ 482 \]     := .F.      ;;
   _HMG_SYSDATA \[ 486 \]        := .F.      ;;
   _HMG_SYSDATA \[ 483 \]     := NIL      ;;
   _HMG_SYSDATA \[ 441 \]     := NIL      ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 485 \]     := .F.      ;;
   _HMG_SYSDATA \[ 484 \]  := NIL      ;;
   _HMG_SYSDATA \[ 391 \]  := NIL      ;;
   _HMG_SYSDATA \[ 390 \]  := NIL      ;;
   _HMG_SYSDATA \[ 398 \]     := .F.      ;;
   _HMG_SYSDATA \[ 389 \]        := NIL ;;
   _HMG_SYSDATA \[ 479 \]     := NIL      ;;
   _HMG_SYSDATA \[ 500 \]     := NIL      ;;
   _HMG_SYSDATA \[ 355 \]     := NIL      ;;
   _HMG_SYSDATA \[ 354 \]     := NIL      ;;
   _HMG_SYSDATA \[ 246 \]     := NIL      ;;
   _HMG_SYSDATA \[ 401 \]  := .F.

#xcommand END BROWSE ;
   =>;
   _HMG_SYSDATA \[ 383 \]     := .F.      ;;
_DefineBrowse ( _HMG_SYSDATA \[ 416 \] ,  ;
      _HMG_SYSDATA \[ 417 \] ,   ;
      _HMG_SYSDATA \[ 432 \] ,      ;
      _HMG_SYSDATA \[ 431 \] ,      ;
      _HMG_SYSDATA \[ 420 \] ,      ;
      _HMG_SYSDATA \[ 421 \] ,      ;
      _HMG_SYSDATA \[ 445 \] ,   ;
      _HMG_SYSDATA \[ 446 \] ,   ;
      _HMG_SYSDATA \[ 481 \] ,   ;
      _HMG_SYSDATA \[ 434 \] ,   ;
      _HMG_SYSDATA \[ 422 \] ,   ;
      _HMG_SYSDATA \[ 423 \] ,   ;
      _HMG_SYSDATA \[ 424 \] ,   ;
      _HMG_SYSDATA \[ 435 \] ,   ;
      _HMG_SYSDATA \[ 447 \]  ,  ;
      _HMG_SYSDATA \[ 448 \] ,;
      _HMG_SYSDATA \[ 426 \] ,   ;
      _HMG_SYSDATA \[ 427 \],    ;
      _HMG_SYSDATA \[ 480 \] ,   ;
      _HMG_SYSDATA \[ 482 \],    ;
      _HMG_SYSDATA \[ 449 \] ,   ;
      _HMG_SYSDATA \[ 450 \] ,   ;
      _HMG_SYSDATA \[ 451 \] ,   ;
      _HMG_SYSDATA \[ 429 \]  , ;
      _HMG_SYSDATA \[ 412 \] , ;
      _HMG_SYSDATA \[ 413 \] , ;
      _HMG_SYSDATA \[ 415 \] , ;
      _HMG_SYSDATA \[ 414 \] , ;
      _HMG_SYSDATA \[ 443 \]  , ;
      _HMG_SYSDATA \[ 457 \] , ;
      _HMG_SYSDATA \[ 458 \] , ;
      _HMG_SYSDATA \[ 485 \]  , ;
      _HMG_SYSDATA \[ 401 \] , ;
      _HMG_SYSDATA \[ 398 \] , ;
      _HMG_SYSDATA \[ 486 \] , ;
      _HMG_SYSDATA \[ 441 \] , ;
      _HMG_SYSDATA \[ 483 \] , ;
      _HMG_SYSDATA \[ 484 \] , ;
      _HMG_SYSDATA \[ 456 \] , _HMG_SYSDATA \[ 391 \] , _HMG_SYSDATA \[ 389 \] , _HMG_SYSDATA \[ 390 \] , _HMG_SYSDATA \[ 479 \] , _HMG_SYSDATA \[ 500 \] , _HMG_SYSDATA \[ 355 \] , _HMG_SYSDATA \[ 354 \] , _HMG_SYSDATA  \[ 246 \] )

/*----------------------------------------------------------------------------
Hyperlink
---------------------------------------------------------------------------*/

#xcommand DEFINE HYPERLINK <name> ;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]           := NIL          ;;
   _HMG_SYSDATA \[ 431 \]           := NIL          ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 421 \]  := NIL      ;;
        _HMG_SYSDATA \[ 406 \]       := NIL          ;;
        _HMG_SYSDATA \[ 434 \]         := NIL          ;;
        _HMG_SYSDATA \[ 409 \]      := .F.          ;;
        _HMG_SYSDATA \[ 422 \]          := NIL          ;;
        _HMG_SYSDATA \[ 423 \]          := NIL          ;;
        _HMG_SYSDATA \[ 412 \]      := .F.          ;;
        _HMG_SYSDATA \[ 413 \]    := .F.          ;;
        _HMG_SYSDATA \[ 424 \]       := NIL          ;;
        _HMG_SYSDATA \[ 457 \]     := NIL          ;;
        _HMG_SYSDATA \[ 458 \]     := NIL          ;;
        _HMG_SYSDATA \[ 459 \]        := .F.          ;;
        _HMG_SYSDATA \[ 460 \]    := .F.          ;;
        _HMG_SYSDATA \[ 461 \]       := .F.          ;;
        _HMG_SYSDATA \[ 462 \]       := .F.          ;;
        _HMG_SYSDATA \[ 463 \]   := .F.          ;;
        _HMG_SYSDATA \[ 429 \]        := NIL          ;;
   _HMG_SYSDATA \[ 392 \]  := .F.      ;;
        _HMG_SYSDATA \[ 430 \]     := .F.          ;;
   _HMG_SYSDATA \[ 440 \]  := .F.   ;;
   _HMG_SYSDATA \[ 393 \]  := .F.



#xcommand END HYPERLINK ;
   =>;
_DefineLabel (      ;
   _HMG_SYSDATA \[ 416 \],    ;
   _HMG_SYSDATA \[ 417 \],    ;
   _HMG_SYSDATA \[ 432 \],     ;
   _HMG_SYSDATA \[ 431 \],     ;
   _HMG_SYSDATA \[ 434 \],    ;
   _HMG_SYSDATA \[ 420 \],    ;
   _HMG_SYSDATA \[ 421 \],    ;
   _HMG_SYSDATA \[ 422 \],    ;
   _HMG_SYSDATA \[ 423 \],    ;
   _HMG_SYSDATA \[ 412 \],    ;
   _HMG_SYSDATA \[ 459 \] ,   ;
   _HMG_SYSDATA \[ 460 \] ,  ;
   .F. ,   ;
   .F. ,   ;
   _HMG_SYSDATA \[ 463 \] ,   ;
   _HMG_SYSDATA \[ 457 \]  , ;
   IF ( valtype(_HMG_SYSDATA \[ 458 \]) = "U" , { 0 , 0 , 255 } , _HMG_SYSDATA \[ 458 \] ) , ;
   _HMG_SYSDATA \[ 406 \], ;
   _HMG_SYSDATA \[ 424 \], ;
   _HMG_SYSDATA \[ 429 \], ;
   _HMG_SYSDATA \[ 430 \], ;
   _HMG_SYSDATA \[ 413 \], ;
   .t., ;
   .F. , ;
   _HMG_SYSDATA \[ 409 \] , ;
   _HMG_SYSDATA \[ 440 \] , ;
   _HMG_SYSDATA \[ 393 \] ) ;;
   IF ( _HMG_SYSDATA \[ 392 \] , INITHYPERLINKCURSOR ( GetControlhandle ( _HMG_SYSDATA \[ 416 \] , IF ( !empty(_HMG_SYSDATA \[ 223 \]) , _HMG_SYSDATA \[ 223 \] , _HMG_SYSDATA \[ 417 \] ) ) ) , _DUMMY() )

/*----------------------------------------------------------------------------
Spinner
---------------------------------------------------------------------------*/


#xcommand DEFINE SPINNER <name>;
   =>;
   _HMG_SYSDATA \[ 416 \]     := <"name"> ;;
   _HMG_SYSDATA \[ 417 \]     := NIL      ;;
   _HMG_SYSDATA \[ 432 \]     := NIL      ;;
   _HMG_SYSDATA \[ 431 \]     := NIL      ;;
   _HMG_SYSDATA \[ 420 \]     := NIL      ;;
   _HMG_SYSDATA \[ 434 \]     := NIL      ;;
   _HMG_SYSDATA \[ 422 \]     := NIL      ;;
   _HMG_SYSDATA \[ 423 \]     := NIL      ;;
   _HMG_SYSDATA \[ 465 \]     := NIL      ;;
   _HMG_SYSDATA \[ 466 \]     := NIL      ;;
   _HMG_SYSDATA \[ 424 \]     := NIL      ;;
   _HMG_SYSDATA \[ 435 \]     := NIL      ;;
   _HMG_SYSDATA \[ 427 \]  := NIL      ;;
   _HMG_SYSDATA \[ 426 \]  := NIL      ;;
   _HMG_SYSDATA \[ 421 \]     := NIL      ;;
   _HMG_SYSDATA \[ 429 \]     := NIL      ;;
   _HMG_SYSDATA \[ 412 \]     := .F.      ;;
   _HMG_SYSDATA \[ 413 \]  := .F.      ;;
   _HMG_SYSDATA \[ 414 \]  := .F.      ;;
   _HMG_SYSDATA \[ 415 \]  := .F.      ;;
   _HMG_SYSDATA \[ 428 \]    := .F.   ;;
   _HMG_SYSDATA \[ 457 \]     := NIL      ;;
   _HMG_SYSDATA \[ 458 \]     := NIL      ;;
   _HMG_SYSDATA \[ 404 \]     := .F.      ;;
   _HMG_SYSDATA \[ 441 \]     := .F.      ;;
   _HMG_SYSDATA \[ 405 \]     := NIL      ;;
        _HMG_SYSDATA \[ 430 \]         := .F.   ;;
   _HMG_SYSDATA \[ 428 \]     := .F.

#xcommand END SPINNER;
   =>;
   _DefineSpinner(;
      _HMG_SYSDATA \[ 416 \],;
      _HMG_SYSDATA \[ 417 \],;
      _HMG_SYSDATA \[ 432 \],;
      _HMG_SYSDATA \[ 431 \],;
      _HMG_SYSDATA \[ 420 \],;
      _HMG_SYSDATA \[ 434 \],;
      _HMG_SYSDATA \[ 422 \],;
      _HMG_SYSDATA \[ 423 \],;
      _HMG_SYSDATA \[ 465 \],;
      _HMG_SYSDATA \[ 466 \],;
      _HMG_SYSDATA \[ 424 \],;
      _HMG_SYSDATA \[ 435 \],;
      _HMG_SYSDATA \[ 427 \],;
      _HMG_SYSDATA \[ 426 \],;
      _HMG_SYSDATA \[ 421 \],;
      _HMG_SYSDATA \[ 429 \] , ;
           _HMG_SYSDATA \[ 430 \] , ;
      _HMG_SYSDATA \[ 428 \] , ;
      _HMG_SYSDATA \[ 412 \] , ;
      _HMG_SYSDATA \[ 413 \] , ;
      _HMG_SYSDATA \[ 415 \] , ;
      _HMG_SYSDATA \[ 414 \] , ;
      _HMG_SYSDATA \[ 404 \] , ;
      _HMG_SYSDATA \[ 441 \] , ;
      _HMG_SYSDATA \[ 405 \] ,;
      _HMG_SYSDATA \[ 457 \],;
      _HMG_SYSDATA \[ 458 \])

