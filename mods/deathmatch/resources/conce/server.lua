local markerConce = createMarker(1763.74, 116.71, 34, "cylinder", 2, 240, 161, 104, 69)

function guiConce( player )
	if player and isElement(player) and getElementType(player) == "player" then
		if exports.objetivos:getNivel(exports.players:getCharacterID(player)) < 2 then outputChatBox("Necesitas nivel 2 para comprar un vehículo. Usa /objetivos.", player, 255, 0, 0) return end
		if not getElementData(player, "abrirconce") == true then
			if hasObjectPermissionTo(player, 'command.vip', false) then
				triggerClientEvent(player, "abrirconce", player, true)
			else
				triggerClientEvent(player, "abrirconce", player, false)
			end
			setElementData(player, "abrirconce", true)
			setElementData(player, "idplayerventa", tonumber(getElementData(player, "playerid")))
		end
	end
end
addEventHandler("onMarkerHit", markerConce, guiConce)

function comprarVehiculo (comprador, model, precio, model2)
	if client and client == comprador then
		local codigoCompra = tostring(math.random(0,9))..tostring(math.random(0,9))
		if exports.vehicles_auxiliar:isModelVIP(model) and not hasObjectPermissionTo(comprador, 'command.vip', false) then
			outputChatBox("¡Este vehículo es exclusivo para usuarios VIP!", comprador, 180, 0, 255)
			return
		end
		outputChatBox("Has solicitado un/a "..model.." por $"..tostring(precio), comprador, 0, 255, 0)
		outputChatBox("Usa /compra "..tostring(codigoCompra).." para confirmarlo (Tienes 15 segundos para hacerlo)", comprador, 255, 255, 0)
		setElementData(comprador, "codigoCompra", codigoCompra)
		setTimer(function (comprador, model2, precio, codigoCompra)
			if getElementData(comprador, "compra") == tostring(codigoCompra) then 
				if exports.players:takeMoney(comprador, precio) then
					regularObjetivosTrasCompra(comprador, precio)
					triggerEvent("generarVehiculo", comprador, comprador, tonumber(model2))
					exports.items:give( comprador, 1, tonumber(getElementData(comprador, "vehicleIDa")) )
					outputChatBox("Has comprado el vehículo correctamente.", comprador, 0, 255, 0)
					removeElementData(comprador, "compra")
					removeElementData(comprador, "codigoCompra")
					exports.factions:giveFactionPresupuesto(5, precio*0.25)
				else
					outputChatBox( "Se ha producido un error. Comprueba que tienes dinero suficiente.", comprador, 255, 127, 0 )
				end
			else
				outputChatBox("La compra no ha sido autorizada. Usa /compra la próxima vez.", comprador, 255, 0, 0)
			end
		end, 15000, 1, comprador, model2, precio, codigoCompra, tip)
	end
end
addEvent( "comprarVehiculo", true )
addEventHandler( "comprarVehiculo", root, comprarVehiculo )
 
function comprarVehiculoPrestamo (comprador, model, precio, model2)
	if client and client == comprador and precio and model and model2 then
		if exports.vehicles_auxiliar:isModelVIP(model) and not hasObjectPermissionTo(comprador, 'command.vip', false) then
			outputChatBox("¡Este vehículo es exclusivo para usuarios VIP!", comprador, 180, 0, 255)
			return
		end
		local codigoCompra = tostring(math.random(0,9))..tostring(math.random(0,9))
		outputChatBox("Has solicitado un préstamo para comprar un/a "..model.." por $"..tostring(precio), comprador, 0, 255, 0)
		if math.floor(tonumber(precio)/96) > 100 then
			outputChatBox("La cuota de este préstamo es de $"..tostring(math.floor(precio/96)).." durante 96 PayDays.", comprador, 255, 255, 0)
			cuota = math.floor(precio/96)
		else
			outputChatBox("La cuota de este préstamo es de $100 durante "..tostring(precio/100).." PayDays.", comprador, 255, 255, 0)
			cuota = 100
		end
		outputChatBox("Deberás abonar ahora el 30% de su precio como entrada($"..tostring(precio*0.30).."), y puedes elegir cuánto dinero quieres pagar en cada PayDay usando /cuota [cantidad]", comprador, 0, 255, 0)
		outputChatBox("Podrás consultar todos los datos de tu préstamo con /prestamo.", comprador, 255, 255, 0)
		outputChatBox("Usa /compra "..tostring(codigoCompra).." para confirmarlo (Tienes 15 segundos para hacerlo)", comprador, 255, 255, 0)
		setElementData(comprador, "codigoCompra", codigoCompra)
		setTimer(function (comprador, model2, precio, codigoCompra)
			if getElementData(comprador, "compra") == tostring(codigoCompra) then
				if tonumber(getPlayerMoney(comprador)) < tonumber(precio*0.30) then 
					outputChatBox("No tienes el 30% del valor ($"..tostring(precio*0.30)..")", comprador, 255, 0, 0) 
					return
				else
					if exports.prestamos:crearPrestamo(comprador, precio, 1, 0, cuota) and exports.players:takeMoney(comprador, precio*0.30) then
						regularObjetivosTrasCompra(comprador, precio)
						triggerEvent("generarVehiculo", comprador, comprador, tonumber(model2))
						vehiclea = tonumber(getElementData(comprador, "vehicleIDa"))
						local prestamoID = getElementData(comprador, "prestamoID")
						exports.sql:query_free("UPDATE prestamos SET objetoID = "..vehiclea.." WHERE prestamoID = "..prestamoID)
						exports.sql:query_free("UPDATE prestamos SET pagado = "..(precio*0.30).." WHERE prestamoID = "..prestamoID)
						exports.items:give( comprador, 1, vehiclea )
						outputChatBox("Has comprado el vehículo correctamente.", comprador, 0, 255, 0)
						removeElementData(comprador, "compra")
						removeElementData(comprador, "prestamoID")
						exports.factions:giveFactionPresupuesto(5, precio*0.25)
					end
				end
			else
				outputChatBox("La compra no ha sido autorizada. Usa /compra la próxima vez.", comprador, 255, 0, 0)
			end
		end, 15000, 1, comprador, model2, precio, codigoCompra)
	end
end
addEvent( "comprarVehiculoPrestamo", true )
addEventHandler( "comprarVehiculoPrestamo", root, comprarVehiculoPrestamo )

function autorizarCompra(player, cmd, codigo)
	if not codigo then outputChatBox("Debes de poner /compra [2 números que te proporciona el sistema]", player, 255, 0, 0) return end
	local codigoCompra = getElementData(player, "codigoCompra")
	if tostring(codigo) == tostring(codigoCompra) then
		outputChatBox("Ha autorizado la compra del vehículo. Espere por favor...", player, 0, 255, 0)
		setElementData(player, "compra", tostring(codigoCompra))
	else
		outputChatBox("Los dos números del /compra no coinciden. Revisalo y prueba de nuevo.", player, 255, 0, 0)
	end
end
addCommandHandler("compra", autorizarCompra)

function regularObjetivosTrasCompra(player, precio)
	if player and isElement(player) and precio then
		local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
		if nivel == 2 and not exports.objetivos:isObjetivoCompletado(11, exports.players:getCharacterID(player)) then -- Primer vehículo
			exports.objetivos:addObjetivo(11, exports.players:getCharacterID(player), player)
		end
		if nivel == 3 and not exports.objetivos:isObjetivoCompletado(33, exports.players:getCharacterID(player)) then -- Segundo vehículo
			local sql = exports.sql:query_assoc_single("SELECT COUNT(vehicleID) AS vehs FROM vehicles WHERE characterID = "..exports.players:getCharacterID(player))
			if tonumber(sql.vehs) >= 1 then -- Procedemos a dar este objetivo.
				exports.objetivos:addObjetivo(33, exports.players:getCharacterID(player), player)
			end
		end
		if nivel == 4 and not exports.objetivos:isObjetivoCompletado(36, exports.players:getCharacterID(player)) then -- Vehículo de al menos 40.000$
			if tonumber(precio) >= 40000 then
				exports.objetivos:addObjetivo(36, exports.players:getCharacterID(player), player)
			end
		end
	end
end