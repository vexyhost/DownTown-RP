local stingers = 1
function onCreateStinger(x, y, z, rx, ry, rz)
	if exports.factions:isPlayerInFaction(source, 1) then
	stinger = createObject(2899, x, y, z+0.1, rx, ry, rz)
	setElementData(stinger, "isStinger", true)
	setElementData(stinger, "idStinger", tonumber(stingers))
	outputChatBox("Clavos con ID "..stingers.." creado. /quitarclavos [id] para quitarlo.", source, 0, 255, 0)
	stingers = stingers + 1
	triggerClientEvent( "onCreateStinger", getRootElement(), x, y, z)
	stingerPlant(source)
	end
end
addEvent( "onCreateStinger", true )
addEventHandler( "onCreateStinger", getRootElement(), onCreateStinger)

function stingerPlant(player)
	exports.chat:me(player, "tira una fila de clavos en el suelo")
	setPedAnimation(player, "BOMBER", "BOM_plant", 3000, false, false, false)
	setTimer(setPedAnimation, 2000, 1, player)
end

function deleteStinger(player, cmd, idStinger)
	if exports.factions:isPlayerInFaction(player, 1) then
		if not idStinger then outputChatBox("Sintaxis: /quitarclavos [id] (/nearbyclavos). id -1 los quitará todos.", player, 255, 255, 255) return end
		if tonumber(idStinger) == -1 then outputChatBox("Todos los clavos fueron removidos.", player, 0, 255, 0) end
		for k, v in ipairs(getElementsByType("object")) do
			if getElementData(v, "idStinger") == tonumber(idStinger) or (getElementData(v, "idStinger") and tonumber(idStinger) == -1) then
				destroyElement(v)
				if tonumber(idStinger) >= 1 then
					outputChatBox("Clavos con ID "..tostring(idStinger).." removido.", player, 255, 0, 0)
				end
			end
		end
	else
		outputChatBox("No eres policia.", player, 255, 0, 0)
	end
end
addCommandHandler("quitarclavos", deleteStinger)

function nearByClavos(player)
	if exports.factions:isPlayerInFaction(player, 1) then
		local px, py, pz = getElementPosition(player)
		for k, v in ipairs(getElementsByType("object")) do
			local x, y, z = getElementPosition(v)
			if getElementData(v, "idStinger") and getDistanceBetweenPoints3D(px, py, pz, x, y, z) < 5 then
				outputChatBox("Clavos ID "..tostring(getElementData(v, "idStinger"))..".", player, 0, 255, 0)
			end
		end
	else
		outputChatBox("No eres policia.", player, 255, 0, 0)
	end
end
addCommandHandler("nearbyclavos", nearByClavos)

function aceleracion(vehicle)
	setVehicleHandling( vehicle, "engineAcceleration", 4)
	outputChatBox("Notas que el vehículo va mucho más despacio. ¡Te han pinchado los neumaticos!", source, 255, 0, 0)
end
addEvent( "onLimitarCoche", true )
addEventHandler( "onLimitarCoche", getRootElement(), aceleracion)