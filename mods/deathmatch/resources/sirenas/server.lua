p_lights = {}
p_timer = {}
p_lvar = {}
p_pvar = {}
p_lvar2 = {}
p_lvar3 = {}
p_lvar4 = {}

local models =
    {
        [ 427 ] = true,
		[ 490 ] = true,
		[ 528 ] = true,
		[ 523 ] = true,
		[ 596 ] = true,
		[ 597 ] = true,
		[ 598 ] = true,
		[ 599 ] = true,
		[ 601 ] = true,
    }
 
function toggleLights(thePlayer, cmd, level)
	if not exports.factions:isPlayerInFaction(thePlayer, 1) and not exports.factions:isPlayerInFaction(thePlayer, 2) and not exports.factions:isPlayerInFaction(thePlayer, 8) and not exports.factions:isPlayerInFaction(thePlayer, 5) and not getElementData(thePlayer, "enc1") then return end
		local veh = getPedOccupiedVehicle(thePlayer)
		if not veh then outputChatBox("No estás subido a un vehículo.", thePlayer, 255, 0, 0) return end
		local id = getElementModel(veh)
		removeVehicleSirens(veh)
		addVehicleSirens(veh,1,1)
	local level = tonumber(level)
	if not (level) or (level<1) or (level>3) then outputChatBox("Utiliza /luces 1, 2, o 3.", thePlayer, 255, 255, 255, true) return end
	
	removeVehicleSirens(veh)
	addVehicleSirens(veh,1,1)
    setVehicleSirens(veh,1,1,0,2,0,0,255, 0)
	setVehicleSirens(veh,2,1,0,2,0,0,255, 0)
	setVehicleSirens(veh,3,1,0,2,0,0,255, 0)
	setVehicleSirens(veh,4,1,0,2,0,0,255, 0)
	if(level == 1) then
		triggerClientEvent(getRootElement(), "setEmerlights", getRootElement(), getPlayerName(thePlayer), 1)
		if(p_lights[veh] == 0) or(p_lights[veh] == nil) then
			exports.chat:me( thePlayer, "activa las luces de emergencia." )
			p_pvar[veh] = 1
			p_lights[veh] = 1
			setElementData ( thePlayer, "sirenas", true )
			setVehicleOverrideLights ( veh, 2 )
			setVehicleSirensOn ( veh, true )
			removeVehicleSirens(veh)
			p_timer[veh] = setTimer(
			function()
				if(p_lvar3[veh] == 4) then
					setTimer(function() p_lvar3[veh] = 0 end, 1000, 1)
					setTimer(
					function()
						if(p_lvar4[veh] == 1)then
							p_lvar4[veh] = 0
							setVehicleLightState ( veh, 1, 0)
							setVehicleLightState ( veh, 2, 0)
							setVehicleLightState ( veh, 0, 1)
							setVehicleLightState ( veh, 3, 1)
							setVehicleHeadLightColor(veh, 77, 77, 255)
						else
							setVehicleLightState ( veh, 3, 0)
							setVehicleLightState ( veh, 0, 0)
							setVehicleLightState ( veh, 1, 1)
							setVehicleLightState ( veh, 2, 1)	
							setVehicleHeadLightColor(veh, 255, 77, 77)
							p_lvar4[veh] = 1
						end
					end, 50, 5)
				return end
				if(p_lvar2[veh] == 0) or (p_lvar2[veh] == nil) then
					p_lvar2[veh] = 1
					-- 0 = vorne links 1 = vorne rechts 2 = hinten links 3 = hinten rechts
					setVehicleLightState ( veh, 1, 0)
					setVehicleLightState ( veh, 2, 0)
					setVehicleLightState ( veh, 0, 1)
					setVehicleLightState ( veh, 3, 1)
					setVehicleHeadLightColor(veh, 0, 0, 255)
				else
					setVehicleLightState ( veh, 3, 0)
					setVehicleLightState ( veh, 0, 0)
					setVehicleLightState ( veh, 1, 1)
					setVehicleLightState ( veh, 2, 1)	
					setVehicleHeadLightColor(veh, 255, 0, 0)
					p_lvar2[veh] = 0
				end
				if(p_lvar3[veh] == nil) then p_lvar3[veh] = 0  end
				p_lvar3[veh] = (p_lvar3[veh]+1)
			end, 500, 0)
		else
				p_lights[veh] = 0
				exports.chat:me( thePlayer, "desactiva las luces de emergencia." )
				triggerClientEvent(getRootElement(), "setEmerlights", getRootElement(), getPlayerName(thePlayer), 0)
				killTimer(p_timer[veh])
				setElementData ( thePlayer, "sirenas", false )
				setVehicleLightState ( veh, 0, 0)
				setVehicleLightState ( veh, 1, 0)
				setVehicleLightState ( veh, 2, 0)
				setVehicleLightState ( veh, 3, 0)	
				setVehicleHeadLightColor(veh, 255, 255, 255)
				setVehicleOverrideLights ( veh, 1 )
				setVehicleSirensOn ( veh, false )
				removeVehicleSirens(veh,1,1)
				setVehicleSirens(veh,1,1,0,2,0,0,255, 0)
				setVehicleSirens(veh,2,1,0,2,0,0,255, 0)
				setVehicleSirens(veh,3,1,0,2,0,0,255, 0)
				setVehicleSirens(veh,4,1,0,2,0,0,255, 0)
			end
	elseif(level == 2) then
		triggerClientEvent(getRootElement(), "setEmerlights", getRootElement(), getPlayerName(thePlayer), 2)
		if(p_lights[veh] == 0) or(p_lights[veh] == nil) then
			exports.chat:me( thePlayer, "activa las luces de emergencia." )
			p_lights[veh] = 1
			setVehicleOverrideLights ( veh, 2 )
			removeVehicleSirens(veh)
			setVehicleSirensOn ( veh, false )
			p_timer[veh] = setTimer(
			function()
				if(p_lvar3[veh] == 4) then
					setTimer(function() p_lvar3[veh] = 0 end, 1000, 1)
					setTimer(
					function()
						if(p_lvar4[veh] == 1)then
							p_lvar4[veh] = 0
							setVehicleLightState ( veh, 1, 0)
							setVehicleLightState ( veh, 2, 0)
							setVehicleLightState ( veh, 0, 1)
							setVehicleLightState ( veh, 3, 1)
							setVehicleHeadLightColor(veh, 77, 77, 255)
						else
							setVehicleLightState ( veh, 3, 0)
							setVehicleLightState ( veh, 0, 0)
							setVehicleLightState ( veh, 1, 1)
							setVehicleLightState ( veh, 2, 1)	
							setVehicleHeadLightColor(veh, 255, 77, 77)
							p_lvar4[veh] = 1
						end
					end, 50, 5)
				return end
				if(p_lvar2[veh] == 0) or (p_lvar2[veh] == nil) then
					p_lvar2[veh] = 1
					-- 0 = vorne links 1 = vorne rechts 2 = hinten links 3 = hinten rechts
					setVehicleLightState ( veh, 1, 0)
					setVehicleLightState ( veh, 2, 0)
					setVehicleLightState ( veh, 0, 1)
					setVehicleLightState ( veh, 3, 1)
					setVehicleHeadLightColor(veh, 0, 0, 255)
				else
					setVehicleLightState ( veh, 3, 0)
					setVehicleLightState ( veh, 0, 0)
					setVehicleLightState ( veh, 1, 1)
					setVehicleLightState ( veh, 2, 1)	
					setVehicleHeadLightColor(veh, 255, 0, 0)
					p_lvar2[veh] = 0
				end
				if(p_lvar3[veh] == nil) then p_lvar3[veh] = 0  end
				p_lvar3[veh] = (p_lvar3[veh]+1)
			end, 500, 0)
		else
			p_lights[veh] = 0
			exports.chat:me( thePlayer, "desactiva las luces de emergencia." )
			triggerClientEvent(getRootElement(), "setEmerlights", getRootElement(), getPlayerName(thePlayer), 0)
			setElementData ( thePlayer, "sirenas", false )
			killTimer(p_timer[veh])
			setVehicleLightState ( veh, 0, 0)
			setVehicleLightState ( veh, 1, 0)
			setVehicleLightState ( veh, 2, 0)
			setVehicleLightState ( veh, 3, 0)	
			setVehicleHeadLightColor(veh, 255, 255, 255)
			setVehicleOverrideLights ( veh, 1 )
			setVehicleSirensOn ( veh, false )
		end
	elseif (level==3) then
		exports.chat:me( thePlayer, "activa las luces de emergencia." )
		triggerClientEvent(getRootElement(), "setEmerlights", getRootElement(), getPlayerName(thePlayer), 2)         
	end
end
addCommandHandler("luces", toggleLights)

function sirenasSonoras2(player)
	if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 2) then
		local veh = getPedOccupiedVehicle(player)
		triggerClientEvent(getRootElement(), "toggleSirenSound", veh)
	end
end
addCommandHandler("sonoras", sirenasSonoras2)

estadoS = {}
function gruasirena(player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then outputChatBox("No estás en un vehículo", player, 255, 0, 0) return end
    if tonumber(getElementModel(vehicle)) ~= 552 and tonumber(getElementModel(vehicle)) ~= 525 then outputChatBox("Este vehículo no es el correcto.", player, 255, 0, 0) return end	
		if not estadoS[player] then
			exports.chat:me( player, "pulsa el botón y enciende la sirena." )
			estadoS[player] = 1
		    addVehicleSirens(vehicle, 2, 2, true, true, true, true)
		    setVehicleSirens(vehicle, 1, 0.6, -0.5, 1.5, 255, 178.5, 61.2, 255, 255)
		    setVehicleSirens(vehicle, 2, -0.7, -0.5, 1.5, 255, 178.5, 61.2, 255, 255)
			outputChatBox("Has activado las luces de servicio de la grua, pulsa [H].", player, 0, 255, 0)
		elseif estadoS[player] == 1 then
			exports.chat:me( player, "pulsa el botón y apaga la sirena." )
			outputChatBox("Has desactivado las luces de servicio de la grua, usa /sgrua para activarlas.", player, 0, 255, 0)
			removeVehicleSirens(vehicle)
			estadoS[player] = nil
		end
	end
addCommandHandler("sgrua", gruasirena)


sweepersi = {}
function sirenasweeper(player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then outputChatBox("No estás en un vehículo", player, 255, 0, 0) return end
    if tonumber(getElementModel(vehicle)) ~= 574 then outputChatBox("Este vehículo no es el correcto.", player, 255, 0, 0) return end	
		if not sweepersi[player] then
			exports.chat:me( player, "pulsa el botón y enciende las luces de servicio del Sweeper." )
			sweepersi[player] = 1
		    addVehicleSirens(vehicle, 2, 2, false, true, true, true)
            setVehicleSirens(vehicle, 1, 0.4, 0.4, 1.3, 255, 127.5, 0, 255, 255)
            setVehicleSirens(vehicle, 2, -0.3, 0.4, 1.3, 255, 127.5, 0, 255, 255)
			outputChatBox("Has activado las luces de servicio del Sweeper, pulsa [H].", player, 0, 255, 0)
		elseif sweepersi[player] == 1 then
			exports.chat:me( player, "pulsa el botón y apaga las luces de servicio del Sweeper." )
			outputChatBox("Has desactivado las luces de servicio del Sweeper, usa /ssweeper para activarlas.", player, 0, 255, 0)
			removeVehicleSirens(vehicle)
			sweepersi[player] = nil
		end
	end
addCommandHandler("ssweeper", sirenasweeper)


addEventHandler ( "onVehicleExplode", getRootElement(), 
function()
	if(p_lights[source] == 1) then
		killTimer(p_timer[source])	
	end
end )

addEventHandler ( "onVehicleRespawn", getRootElement(), 
function()
	if(p_lights[source] == 1) then
		killTimer(p_timer[source])	
	end
end )

addEventHandler("onElementDestroy", getRootElement(), 
function ()
	if getElementType(source) == "vehicle" then
		if(p_lights[source] == 1) then
			killTimer(p_timer[source])
		end
	end
end)