local roadblocksarr = { }
local maxroadblocks = 5000

function roadblockCreateWorldObject(objectid, tempObjectPosX, tempObjectPosY, tempObjectPosZ, tempObjectPosRot)
		local slot = 0
		for i = 1, maxroadblocks do
			if (roadblocksarr[i]==nil) then
				if objectid == 1437 then
					roadblocksarr[i] = createObject ( objectid, tempObjectPosX, tempObjectPosY, tempObjectPosZ, -25, 0, tempObjectPosRot )
				else
					roadblocksarr[i] = createObject ( objectid, tempObjectPosX, tempObjectPosY, tempObjectPosZ, 0, 0, tempObjectPosRot )
				end
				triggerClientEvent("onSetBreakable", roadblocksarr[i])
				setElementInterior ( roadblocksarr[i], getElementInterior ( client ) )
				setElementDimension ( roadblocksarr[i], getElementDimension ( client ) )
				slot = i
				break
			end
		end
		if not (slot == 0) then
			outputChatBox("Bloqueo generado con ID #" .. slot.. ".", client, 0, 255, 0)
		else
			outputChatBox("Demasiados bloqueos ya generado, por favor, elimina algunos.", client, 0, 255, 0)
		end
end
addEvent( "roadblockCreateWorldObject", true )
addEventHandler( "roadblockCreateWorldObject", getRootElement(), roadblockCreateWorldObject )

function getNearbyRoadblocks(thePlayer, commandName)
	if exports.factions:isPlayerInFaction ( thePlayer, 1 ) or exports.factions:isPlayerInFaction ( thePlayer, 2 ) or exports.factions:isPlayerInFaction ( thePlayer, 10 ) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Bloqueos cercanos:", thePlayer, 255, 126, 0)
		local found = false	
		for i = 1, maxroadblocks do
			if not (roadblocksarr[i]==nil) then
				local x, y, z = getElementPosition(roadblocksarr[i])
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10) then
					outputChatBox("   Bloqueo ID: " .. i .. ".", thePlayer, 255, 126, 0)
					found = true
				end
			end
		end
		if not (found) then
			outputChatBox("   Nada.", thePlayer, 255, 126, 0)
		end
	else
	outputChatBox("(( Autorizado: SFPD - SFMD - Constructora ))", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("nearbybloqueos", getNearbyRoadblocks, false, false)

function removeRoadblock(thePlayer, commandName, id)
	if exports.factions:isPlayerInFaction ( thePlayer, 1 ) or  exports.factions:isPlayerInFaction ( thePlayer, 2 ) or exports.factions:isPlayerInFaction ( thePlayer, 10 ) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Bloqueo ID]", thePlayer, 255, 194, 15)
		else
			id = tonumber(id)
			if (roadblocksarr[id]==nil) then
				outputChatBox("Ninguna barrera fue encontrada con este ID", thePlayer, 255, 0, 0)
			else
				local object = roadblocksarr[id]
				destroyElement(object)
				roadblocksarr[id] = nil
				outputChatBox("Borraste el bloqueo con ID #" .. id .. ".", thePlayer, 0, 255, 0)
			end
		end
	else
	outputChatBox("(( Autorizado: SFPD - SFMD - Constructora ))", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("quitarbloqueo", removeRoadblock, false, false)

function removeAllRoadblocks(thePlayer, commandName)
	if exports.factions:isPlayerInFaction ( thePlayer, 1 ) or exports.factions:isPlayerInFaction ( thePlayer, 2 ) or exports.factions:isPlayerInFaction ( thePlayer, 10 ) then
		for i = 1, maxroadblocks do
			if not (roadblocksarr[i]==nil) then
				local object = roadblocksarr[i]
				destroyElement(object)
			end
		end
		roadblocksarr = { }
		outputChatBox("Todos los bloqueos fueron quitados.", thePlayer, 0, 255, 0)
		exports.factions:sendMessageToFaction(1, getPlayerName(thePlayer):gsub("_", " ").." ha quitado los bloqueos.")
		exports.factions:sendMessageToFaction(10, getPlayerName(thePlayer):gsub("_", " ").." ha quitado los bloqueos de la obra.")
	else
	outputChatBox("(( Autorizado: SFPD - SFMD - Constructora ))", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("quitarbloqueos", removeAllRoadblocks, false, false)

function onRoadblockStart(thePlayer, commandName)
    if exports.factions:isPlayerInFaction ( thePlayer, 1 ) or exports.factions:isPlayerInFaction ( thePlayer, 2 ) or exports.factions:isPlayerInFaction ( thePlayer, 10 ) then
		triggerClientEvent(thePlayer, "enableRoadblockGUI", getRootElement(), true)
	else
	outputChatBox("(( Autorizado: SFPD - SFMD - Constructora ))", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("bloqueos", onRoadblockStart, false, false)