
*------------------------------------------------------------------------------*
2009-09-01 00:56 UTC+0200 Przemyslaw Czerpak (druzus/at/priv.onet.pl)
*------------------------------------------------------------------------------*

    + added new library: HBNETIO.
      It implements alternative RDD IO API which uses own TCP/IP sockets
      to exchange data between client and server.
      This library contains client and server code and is fully MT safe.
      On client side it's enough to execute:
         NETIO_CONNECT( [<cServer>], [<cPort>], [<nTimeOut>] ) -> <lOK>
      function to register alternative NETIO RDD API and set default
      server address and port.
         <cServer>  - server addres       (default 127.0.0.1)
         <cPort>    - server port         (default 2941)
         <nTimeOut> - connection timeout  (default -1 - not timeout)
      Above settings are thread local and parameters of the 1-st successful
      connection are used as default values for each new thread.
      After registering NETIO client by above function each file starting
      "net:" prefix is automatically redirected to given NETIO server, i.e.
         use "net:mytable"
      It's also possible to pass NETIO server and port as part of file name,
      i.e.:
         use "net:192.168.0.1:10005:mytable"
      On the server side the following functions are available:
      create NETIO listen socket:
         NETIO_LISTEN( [<nPort>], [<cAddress>], [<cRootDir>] )
                                                -> <pListenSocket> | NIL
      accept new connection on NETIO listen socket:
         NETIO_ACCEPT( <pListenSocket> [, <nTimeOut>] )
                                                -> <pConnectionSocket> | NIL
      start connection server:
         NETIO_SERVER( <pConnectionSocket> ) -> NIL
      stop connection accepting or connection server:
         NETIO_SERVERSTOP( <pListenSocket> | <pConnectionSocket>, <lStop> )
                                                -> NIL
      activate MT NETIO server (it needs MT HVM):
         NETIO_MTSERVER( [<nPort>], [<cAddress>] ) -> <pListenSocket> | NIL

      To create NETIO server is enough to compile and link with MT HVM
      this code:

         proc main()
            local pListenSocket

            pListenSocket := netio_mtserver()
            if empty( pListenSocket )
               ? "Cannot start server."
            else
               wait "Press any key to stop NETIO server."
               netio_serverstop( pListenSocket )
               pListenSocket := NIL
            endif
         return

      NETIO works with all core RDDs (DBF, DBFFPT, DBFBLOB, DBFNTX, DBFCDX,
      DBFNSX, SDF, DELIM) and any other RDD which inherits from above or
      use standard RDD IO API (hb_file*() functions).
      Without touching even single line in RDD code it gives the same
      functionality as REDBFCDX in xHarbour but for all RDDs.
      It's possible that such direct TCP/IP connection is faster then
      file server protocols especially if they need more then one IP frame
      to exchange data so it's one of the reason to use it in such cases.
      Please make real speed tests.
      The second reason to use NETIO server is resolving problem with
      concurrent access to the same files using Harbour applications
      compiled for different platforms, i.e. DOS, LINUX, Windows and OS2.
      It's very hard to configure all client stations to use correct
      locking system. NETIO fully resolves this problem so it can be
      interesting alternative also for MS-Windows users only if they
      do not want to play with oplocks setting on each station.
      I'm interesting in user opinions about real life NETIO usage.

      Have a fun with this new toy ;-)

