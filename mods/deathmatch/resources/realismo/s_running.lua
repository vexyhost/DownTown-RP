function greetingHandler ( x,y,z, rot1, rot2, n,t,d )
triggerClientEvent ( "onClientSangrando", getRootElement(), x,y,z, rot1, rot2, n,t,d )
end
addEvent( "onSangrando", true )
addEventHandler( "onSangrando", getRootElement(), greetingHandler )

bodyPartAnim = { 
	[7] = {	"DAM_LegL_frmBK",	42	},
	[8] = {	"DAM_LegR_frmBK",	52	},
}

function greetingHandler4 ( player, bodypart )
setPedAnimation ( player, "ped", bodyPartAnim[bodypart][1], 5000, false, true, false )
end
addEvent( "onAnimation", true )
addEventHandler( "onAnimation", getRootElement(), greetingHandler4 )