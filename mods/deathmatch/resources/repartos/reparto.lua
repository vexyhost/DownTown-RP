---------------- Sistema de repartos de stock a las tiendas.

blip2T = {}
marker2T = {}

function solicitarReparto(player)
	reparto = false
	local vehicle = getPedOccupiedVehicle(player)
	local x, y, z = getElementPosition(player)
	if exports.factions:isPlayerInFaction(player, 7) then
		if not vehicle or getElementModel(vehicle) ~= 414 then outputChatBox("(( Debes de estar subido en un vehículo de reparto ))", player, 255, 0, 0) return end
		if getElementData(player, "int.reparto") then outputChatBox("(( No puedes hacer más de un pedido a la vez ))", player, 255, 0, 0) return end
		if getElementData(player, "driverTransport") then
			local p2 = getPlayerFromName(getElementData(player, "driverTransport"))
			if p2 and p2 ~= player then
				outputChatBox("Esta vez vamos a ir por el buen camino, sin bugs de dinero el servidor prosperará.", player, 255, 0, 0)
				exports.logs:addLogMessage("breparto", "Intento bug POR: "..tostring(getPlayerName(player)).." Y POR:"..tostring(getPlayerName(p2)))
				return
			end
		end
		if (exports.factions:isPlayerInFaction(player, 7) and getDistanceBetweenPoints3D(1338.94, 273.79, 19.56, x, y, z) > 5) then outputChatBox("(( Debes de estar en el Punto de Base para los Repartos ))", player, 255, 0, 0) return end
		local sql = exports.sql:query_assoc("SELECT * FROM interiors ORDER BY productos ASC")
		for k, v in ipairs(sql) do
			if v and v.interiorID and exports.interiors:isTienda(v.interiorID) == true and v.productos <= 6000 and reparto == false and (v.interiorType == 0 or (v.interiorType == 2 and v.characterID > 0)) then
				reparto = true
				setElementData(player, "int.reparto", tonumber(v.interiorID))
				outputChatBox("El local '"..tostring(v.interiorName).."' necesita productos. Usa /areparto para anular el reparto.", player, 0, 255, 0)
				outputChatBox("¡Recuerda realizar el reparto con este camión!", player, 255, 255, 255)
				blip2T[player] = createBlip(v.dropoffX, v.dropoffY, v.dropoffZ, 34, 2, 0, 0, 255, 255, 0, 99999.0, player)
				marker2T[player] = createMarker(v.dropoffX, v.dropoffY, v.dropoffZ, "cylinder", 10, 255, 255, 255, 127, player)
				addEventHandler("onMarkerHit", marker2T[player], repartoListo2)
				setElementParent(blip2T[player], marker2T[player])
				local idveh = getElementData(vehicle, "idveh")
				setElementData(player, "idtransporte", tonumber(idveh))
				setElementData(vehicle, "driverTransport", getPlayerName(player))
			end	
		end
		if reparto == false then
			outputChatBox("(( Actualmente no hay locales que requieran productos ))", player, 255, 0, 0) 
		end
	end
end
addCommandHandler("reparto", solicitarReparto)
 
function repartoListo2 (vehicle)
	if getElementType(vehicle) == "vehicle" and (getElementModel(vehicle) == 414) then
		local player = getVehicleController(vehicle)
		if source == marker2T[player] then
			if getElementData(player, "int.reparto") and getElementData(player, "int.reparto") > 0 then
				exports.interiors:giveProductos(getElementData(player, "int.reparto"), 50)
				removeElementData(player, "int.reparto")
				removeEventHandler("onMarkerHit", marker2T[player], repartoListo2)
				local idveh = getElementData(vehicle, "idveh")
				local idveh2 = getElementData(player, "idtransporte")
				if tonumber(idveh) ~= tonumber(idveh2) then
					outputChatBox("Este vehículo no es en el que llevas la mercancía. Reparto inválido.", player, 255, 0, 0)
					outputChatBox("Puedes volver con el vehículo que usaste /reparto, o anular el reparto (/areparto)", player, 255, 0, 0)
					return
				end
				if exports.factions:isPlayerInFaction(player, 7) then 
					outputChatBox("Has rellenado este local por $"..tostring(math.floor(0.025*getElementHealth(vehicle))).." correctamente.", player, 0, 255, 0)
				    exports.players:giveMoney(player, math.floor(0.025*getElementHealth(vehicle)))
					exports.factions:giveFactionPresupuesto(7, 50)
					removeElementData(vehicle, "driverTransport")
				end
				destroyElement(marker2T[player])	
			end
		end
	end 
end

function anularReparto2 (player)
	if not exports.factions:isPlayerInFaction(player, 7) then return end
	if not getElementData(player, "int.reparto") then outputChatBox("(( No tienes un pedido pendiente ))", player, 255, 0, 0) return end
	local vehicle = getPedOccupiedVehicle(player)
	removeElementData(player, "int.reparto")
	removeElementData(player, "idtransporte")
	removeElementData(vehicle, "driverTransport")
	destroyElement(marker2T[player])
	outputChatBox("Has cancelado el reparto correctamente.", player, 0, 255, 0)
end
addCommandHandler("areparto", anularReparto2)