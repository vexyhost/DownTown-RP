local run = 0
local down = 0

addEventHandler( "onClientPreRender", getRootElement(), 
	function( slice )
		if ( not isPedInVehicle( getLocalPlayer( ) ) and getControlState( "sprint" ) ) or down > 0 then
			run = run + slice
			if run >= 40000 then
				if isPedOnGround( getLocalPlayer( ) ) then
					setPedAnimation(getLocalPlayer(), "FAT", "idle_tired", 5000, true, false, true)
					run = 19000
				else
					toggleControl( 'sprint', false )
					setTimer( toggleControl, 5000, 1, 'sprint', true )
				end
			end
			if not getControlState( "sprint" ) then
				down = math.max( 0, down - slice )
			else
				down = 500
			end
		else
			if run > 0 then
				run = math.max( 0, run - math.ceil( slice / 3 ) )
			end
		end
	end
)

--LIMP TIMING

function limpeffect ( source, key, keystate )
	if isPedInVehicle (getLocalPlayer ()) then
		return
	else
		islimping = getElementData ( getLocalPlayer (), "legdamage" )
		if islimping == 1 then
			local makeplayerlimp = setTimer ( limpeffectparttwo , 200, 1, source, key, state )
			if 	lookingthroughcamera ~= 1 then
				toggleControl ("right", false )
				toggleControl ("left", false )
				toggleControl ("forwards", false )
				toggleControl ("backwards", false )
			end
		end
	end
end

function limpeffectparttwo ( source, key, keystate )
	if isPedInVehicle (getLocalPlayer ()) then
		return
	else
		islimping = getElementData ( getLocalPlayer (), "legdamage" )
		if islimping == 1 then
			local makeplayerlimp = setTimer ( limpeffect, 500, 1, source, key, state )
			if 	lookingthroughcamera ~= 1 then
				if shieldon ~= 1 then
					toggleControl ("right", true )
					toggleControl ("left", true )
					toggleControl ("forwards", true )
					toggleControl ("backwards", true )
				end
			end
		end
	end
end

function startalimp ()
	local theplayer = getLocalPlayer ()
	if (getPedArmor ( theplayer )) == 0 then
		setElementData ( getLocalPlayer (), "legdamage", 1 )
		local makeplayerlimp = setTimer ( limpeffect, 300, 1, source, key, state )
	end
end


bodyPartAnim = { 
	[7] = {	"DAM_LegL_frmBK",	42	},
	[8] = {	"DAM_LegR_frmBK",	52	},
}

function damagenoise ( attacker, weapon, bodypart, loss )
	if bodypart == 7 or bodypart == 8 then
		if attacker then
		
				triggerServerEvent ( "onAnimation", getLocalPlayer(), localPlayer, bodypart ) 
				--Blood stuff
				function blood()
				local boneX,boneY,boneZ = getPedBonePosition(getLocalPlayer(), bodyPartAnim[bodypart][2])
				local rot = math.rad(getPedRotation ( getLocalPlayer() ))	
					triggerServerEvent ( "onSangrando", getLocalPlayer(), boneX,boneY,boneZ, -math.sin(rot), math.cos(rot), -0.1, 500, 1.0 ) 
				end
				blood()
				setTimer(blood,50,50)
				--
				local makeplayerlimp = setTimer ( limpeffect, 1000, 1, source, key, state )
		end
	end
end

addEventHandler ( "onClientPlayerDamage", getLocalPlayer (), damagenoise )


function greetingHandler3 (  x,y,z, rot1, rot2, n,t,d )
fxAddBlood ( x,y,z, rot1, rot2, n,t,d )
end
addEvent( "onClientSangrando", true )
addEventHandler( "onClientSangrando", getRootElement(), greetingHandler3 )