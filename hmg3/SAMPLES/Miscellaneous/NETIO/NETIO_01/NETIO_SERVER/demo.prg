REQUEST HB_GT_WIN_DEFAULT
function main()

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
