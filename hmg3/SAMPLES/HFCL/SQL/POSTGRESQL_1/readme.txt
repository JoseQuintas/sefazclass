To run this sample, you'll need the following files.

- comerr32.dll
- gssapi32.dll
- k5sprt32.dll
- krb5_32.dll
- libeay32.dll
- libiconv-2.dll
- libintl-8.dll
- libpq.dll
- ssleay32.dll

These files are included in the PostgreSql distribution.

You can download at http://www.postgresql.org/.

*------------------------------------------------------------------------------*
Classes
*------------------------------------------------------------------------------*

CREATE CLASS TPQServer
    VAR      pDb
    VAR      lTrans
    VAR      lallCols  INIT .T.
    VAR      Schema    INIT "public"
    VAR      lError    INIT .F.
    VAR      cError    INIT ""
    VAR      lTrace    INIT .F.
    VAR      pTrace

    METHOD   New( cHost, cDatabase, cUser, cPass, nPort, Schema )
    METHOD   Destroy()
    METHOD   Close()              INLINE ::Destroy()

    METHOD   StartTransaction()
    METHOD   TransactionStatus()  INLINE PQtransactionstatus(::pDb)
    METHOD   Commit()
    METHOD   Rollback()

    METHOD   Query( cQuery )
    METHOD   Execute( cQuery )    INLINE ::Query(cQuery)
    METHOD   SetSchema( cSchema )

    METHOD   NetErr()             INLINE ::lError
    METHOD   ErrorMsg()           INLINE ::cError

    METHOD   TableExists( cTable )
    METHOD   ListTables()
    METHOD   TableStruct( cTable )
    METHOD   CreateTable( cTable, aStruct )
    METHOD   DeleteTable( cTable  )
    METHOD   TraceOn(cFile)
    METHOD   TraceOff()
    METHOD   SetVerbosity(num)    INLINE PQsetErrorVerbosity( ::pDb, iif( num >= 0 .and. num <= 2, num, 1 )  )

ENDCLASS

CREATE CLASS TPQQuery
    VAR      pQuery
    VAR      pDB

    VAR      nResultStatus

    VAR      lBof
    VAR      lEof
    VAR      lRead
    VAR      lAllCols INIT .T.

    VAR      lError   INIT .F.
    VAR      cError   INIT ""

    VAR      cQuery
    VAR      nRecno
    VAR      nFields
    VAR      nLastrec

    VAR      aStruct
    VAR      aKeys
    VAR      TableName
    VAR      Schema
    VAR      rows     INIT 0

    METHOD   New( pDB, cQuery, lallCols, cSchema, res )
    METHOD   Destroy()
    METHOD   Close()            INLINE ::Destroy()

    METHOD   Refresh()
    METHOD   Fetch()            INLINE ::Skip()
    METHOD   Read()
    METHOD   Skip( nRecno )

    METHOD   Bof()              INLINE ::lBof
    METHOD   Eof()              INLINE ::lEof
    METHOD   RecNo()            INLINE ::nRecno
    METHOD   Lastrec()          INLINE ::nLastrec
    METHOD   Goto(nRecno)

    METHOD   NetErr()           INLINE ::lError
    METHOD   ErrorMsg()         INLINE ::cError

    METHOD   FCount()           INLINE ::nFields
    METHOD   FieldName( nField )
    METHOD   FieldPos( cField )
    METHOD   FieldLen( nField )
    METHOD   FieldDec( nField )
    METHOD   FieldType( nField )
    METHOD   Update( oRow )
    METHOD   Delete( oRow )
    METHOD   Append( oRow )
    METHOD   SetKey()

    METHOD   Changed(nField)    INLINE ::aRow[nField] != ::aOld[nField]
    METHOD   Blank()            INLINE ::GetBlankRow()

    METHOD   Struct()

    METHOD   FieldGet( nField, nRow )
    METHOD   GetRow( nRow )
    METHOD   GetBlankRow()

ENDCLASS

CREATE CLASS TPQRow
   VAR      aRow
   VAR      aOld
   VAR      aStruct

   METHOD   New( row, old, struct )
   METHOD   FCount()           INLINE Len(::aRow)
   METHOD   FieldGet( nField )
   METHOD   FieldPut( nField, Value )
   METHOD   FieldName( nField )
   METHOD   FieldPos( cFieldName )
   METHOD   FieldLen( nField )
   METHOD   FieldDec( nField )
   METHOD   FieldType( nField )
   METHOD   Changed( nField )     INLINE !(::aRow[nField] == ::aOld[nField])
   METHOD   FieldGetOld( nField ) INLINE ::aOld[nField]

ENDCLASS
