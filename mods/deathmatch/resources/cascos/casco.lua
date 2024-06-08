-- motero
txt = engineLoadTXD( "cascos/cascomotero.txd" )
engineImportTXD( txt, 2053 )
dff = engineLoadDFF( "cascos/cascomotero.dff", 0 )
engineReplaceModel( dff, 2053 )

-- motocross
engineImportTXD( engineLoadTXD( "cascos/moto.txd" ), 2054 )
engineReplaceModel( engineLoadDFF( "cascos/moto.dff", 0 ), 2054 )
engineImportTXD( engineLoadTXD( "cascos/motosporting.txd" ), 3008 )
engineReplaceModel( engineLoadDFF( "cascos/moto.dff", 0 ), 3008 )
engineImportTXD( engineLoadTXD( "cascos/cascomonster1.txd" ), 3009 )
engineReplaceModel( engineLoadDFF( "cascos/moto.dff", 0 ), 3009 )
engineImportTXD( engineLoadTXD( "cascos/cascomonster2.txd" ), 3010 )
engineReplaceModel( engineLoadDFF( "cascos/moto.dff", 0 ), 3010 )

-- casco jet
engineImportTXD( engineLoadTXD( "cascos/cascojet.txd" ), 3011 )
engineReplaceModel( engineLoadDFF( "cascos/cascojet.dff", 0 ), 3011 )

-- integral
engineImportTXD( engineLoadTXD( "cascos/casconaranja.txd" ), 2052 )
engineImportTXD( engineLoadTXD( "cascos/cascoverde.txd" ), 954 )
engineImportTXD( engineLoadTXD( "cascos/cascoazul.txd" ), 1248 )
engineImportTXD( engineLoadTXD( "cascos/cascomilitar.txd" ), 1310 )

engineImportTXD( engineLoadTXD( "cascos/casco1.txd" ), 2908 )
engineReplaceModel( engineLoadDFF( "cascos/cascointegral.dff", 0 ), 2908 )
engineImportTXD( engineLoadTXD( "cascos/casco2.txd" ), 2907 )
engineReplaceModel( engineLoadDFF( "cascos/cascointegral.dff", 0 ), 2907 )
engineImportTXD( engineLoadTXD( "cascos/casco3.txd" ), 2906 )
engineReplaceModel( engineLoadDFF( "cascos/cascointegral.dff", 0 ), 2906 )
engineImportTXD( engineLoadTXD( "cascos/casco4.txd" ), 2905 )
engineReplaceModel( engineLoadDFF( "cascos/cascointegral.dff", 0 ), 2905 )
engineImportTXD( engineLoadTXD( "cascos/casco5.txd" ), 3007 )
engineReplaceModel( engineLoadDFF( "cascos/cascointegral.dff", 0 ), 3007 )

ids = { 2052,954,1248,1310,1277 }
for k, id in ipairs( ids ) do
	engineReplaceModel( engineLoadDFF( "cascos/cascointegral.dff", 0 ), id )
end