function crearPrestamo (player, cantidad, tipo, objetoID, cuota, entrada)
	if player and cantidad and tipo and objetoID and cuota then
		if tienePrestamos(player, tipo) == true then outputChatBox("Solo se permite un préstamo por cuenta. Préstamo denegado.", player, 255, 0, 0) return false end
		if not entrada and cantidad <= 2000 then outputChatBox("La cantidad mínima son 2000$. Préstamo denegado.", player, 255, 0, 0) return false end
		if entrada then
			if not exports.players:takeMoney(player, tonumber(entrada)) then
				outputChatBox("Para pedir el préstamo tienes que pagar una entrada de $"..tostring(entrada)..". Préstamo denegado.", player, 255, 0, 0)
				return false
			end
		end
		timepr = getRealTime()
		if hasObjectPermissionTo( player, "command.vip", false ) then
			if tonumber(tipo) == 1 then
				flimite = tonumber(timepr.timestamp)+3470400
				outputChatBox("Se te ha ampliado a 40 días el pago de tu préstamo por ser VIP.", player, 0, 255, 0)
			elseif tonumber(tipo) == 2 then
				flimite = tonumber(timepr.timestamp)+10713600
				outputChatBox("Se te ha ampliado a 120 días el pago de tu préstamo por ser VIP.", player, 0, 255, 0)
			end
		else
			if tonumber(tipo) == 1 then
				flimite = tonumber(timepr.timestamp)+8035200
			elseif tonumber(tipo) == 2 then -- 90 dias
				flimite = tonumber(timepr.timestamp)+8035200
			end
		end
		local sql, error = exports.sql:query_insertid("INSERT INTO `prestamos` (`tipo`, `objetoID`, `cantidad`, `pagado`, `characterID`, `cuota`, `flimite`) VALUES ('"..tonumber(tipo).."', '"..tonumber(objetoID).."', '"..tonumber(cantidad).."', '"..tonumber(0).."', '"..exports.players:getCharacterID(player).."', '"..tonumber(cuota).."', '"..tonumber(flimite).."');")
		if not error and sql then
			local time2 = getRealTime(flimite)
			local fecha = tostring(time2.monthday).."-"..tostring(time2.month+1).."-"..tostring(time2.year+1900).." Hora: "..tostring(time2.hour)..":"..tostring(time2.minute)..":"..tostring(time2.second)
			outputChatBox("Su préstamo de $"..tostring(cantidad).." ha sido concedido.", player, 0, 255, 0)
			outputChatBox("Fecha límite de pago: "..tostring(fecha), player, 255, 255, 0)
			outputChatBox("Para más información sobre su préstamo, escriba /prestamo", player, 255, 255, 0)
			setElementData(player, "prestamoID", tonumber(sql))
			return true
		else
			outputChatBox("Ha ocurrido un error al solicitar el préstamo. Inténtelo de nuevo más tarde.", player, 255, 0, 0)
			return false
		end
	end
end

function tienePrestamos (player, tipo)
	if player and tipo then
		local userID = exports.players:getUserID(player)
		for k, v in ipairs(exports.sql:query_assoc("SELECT characterID FROM characters WHERE CKuIDStaff = 0 AND userID = "..userID)) do
			if tipo == 1 then
				local sql = exports.sql:query_assoc_single("SELECT prestamoID FROM prestamos WHERE cantidad > pagado AND tipo = 1 AND characterID = "..v.characterID)
				if sql and sql.prestamoID then return true end
			elseif tipo == 2 then
				local sql = exports.sql:query_assoc_single("SELECT prestamoID FROM prestamos WHERE cantidad > pagado AND tipo = 2 AND characterID = "..v.characterID)
				if sql and sql.prestamoID then return true end
			else
				return false
			end
		end
	end
end

function tienePrestamosPersonaje (player)
	if player then
		local sql = exports.sql:query_assoc_single("SELECT prestamoID FROM prestamos WHERE cantidad > pagado AND characterID = "..exports.players:getCharacterID(player))
		if sql and sql.prestamoID then return true end		
	end
end

function verMiPrestamo (player, comando, tipo)
	if not tipo or not tonumber(tipo) then outputChatBox("Sintaxis: /prestamo [tipo, 1 (vehiculo) o 2 (interior)]", player, 255, 255, 255) return end
	if tienePrestamos(player, tonumber(tipo)) == true then
		if tienePrestamosPersonaje(player) == true then
			local sql = exports.sql:query_assoc_single("SELECT * FROM prestamos WHERE cantidad > pagado AND tipo = ".. tonumber(tipo).." AND characterID = "..exports.players:getCharacterID(player))
			outputChatBox("~~Datos de préstamos - DownTown RolePlay~~", player, 255, 255, 255)
			outputChatBox("Nº del préstamo: #FFFF00"..tostring(sql.prestamoID), player, 255, 255, 255, true)
			outputChatBox("Titular del préstamo: #FFFF00"..tostring(getPlayerName(player):gsub("_", " ")), player, 255, 255, 255, true)
			outputChatBox("Cantidad prestada: #00FF00$"..tostring(sql.cantidad), player, 255, 255, 255, true)
			outputChatBox("Cantidad pendiente: #FF0000$"..tostring(sql.cantidad-sql.pagado), player, 255, 255, 255, true)
			outputChatBox("Cuota por PayDay: #FF0000$"..tostring(sql.cuota), player, 255, 255, 255, true)
			if sql.tipo == 1 then
				tipo1 = "préstamo de vehículo"
			elseif sql.tipo == 2 then
				tipo1 = "préstamo de vivienda"
			end
			outputChatBox("Tipo de préstamo: #FFFF00"..tostring(tipo1), player, 255, 255, 255, true)
			outputChatBox("ID asociado: #FFFF00"..tostring(sql.objetoID), player, 255, 255, 255, true)
			local time2 = getRealTime(sql.flimite)
			local fecha = tostring(time2.monthday).."-"..tostring(time2.month+1).."-"..tostring(time2.year+1900).." Hora: "..tostring(time2.hour)..":"..tostring(time2.minute)..":"..tostring(time2.second)
			outputChatBox("Fecha límite de pago: #FF0000"..tostring(fecha), player, 255, 255, 255, true)
			outputChatBox("Usa /comandos prestamo para ver todos los comandos disponibles.", player, 255, 0, 0)
		else
			outputChatBox("Debes de utilizar este comando con el personaje que solicitó el préstamo.", player, 255, 0, 0)
		end
	else
		outputChatBox("Ninguno de tus personajes tiene un préstamo concedido, o el tipo es incorrecto.", player, 255, 0, 0)
	end
end
addCommandHandler("prestamo", verMiPrestamo)

function infoImpago (player)
	outputChatBox("En caso de que superes la fecha límite y no hayas pagado el préstamo, sucederá lo siguiente:", player, 255, 255, 255)
	outputChatBox("- Orden de embargo del vehículo/vivienda al departamento de policía.", player, 255, 0, 0)
	outputChatBox("- Inscripcción en fichero de morosos. No podrás solicitar más préstamos.", player, 255, 0, 0)
	outputChatBox("- Denuncia ante la Corte, con posible embargo de la nómina.", player, 255, 0, 0)
	outputChatBox("Una vez pagado el préstamo, se desembargará el vehículo/vivienda y se retirarán todas las medidas.", player, 255, 255, 0)
end
addCommandHandler("impago", infoImpago)

function pagarPrestamo (player, cmd, tipo, cantidad)
	if not cantidad or not tipo or not tonumber(cantidad) then outputChatBox("Syntax: /"..tostring(cmd).." [tipo, 1 (vehiculo) o 2 (interior)] [cantidad a pagar]", player, 255, 255, 255) return end
	local cantidad = tonumber(math.floor(cantidad))
	if cantidad < 1 then outputChatBox("Has intentado bugear el sistema de préstamos. Incidente reportado.", player, 255, 0, 0) 
	exports.logs:addLogMessage("bugs", "El jugador " .. getPlayerName(player) .. " ha intentado bugear los préstamos #1 Cantidad cuota negativa.")
	return end
	if tienePrestamosPersonaje(player) == true then
		local sql = exports.sql:query_assoc_single("SELECT * FROM prestamos WHERE cantidad > pagado AND tipo = "..tipo.." AND characterID = "..exports.players:getCharacterID(player))
		if sql and sql.cantidad > sql.pagado then
			if sql.pagado+tonumber(cantidad) > sql.cantidad then outputChatBox("No puedes pagar más dinero del que debes. Usa /prestamo para saber cuánto debes.", player, 255, 0, 0) return end
			if exports.players:takeMoney(player, cantidad) then
				exports.sql:query_free("UPDATE prestamos SET pagado = "..sql.pagado+cantidad.." WHERE prestamoID = "..sql.prestamoID)
				outputChatBox("Has pagado correctamente $"..tostring(cantidad).." para tu préstamo. /prestamo para más info.", player, 0, 255, 0)
			end
		end
	else
		outputChatBox("Este personaje no tiene un préstamo pendiente.", player, 255, 0, 0)
	end
end
addCommandHandler("pagarprestamo", pagarPrestamo)
addCommandHandler("pagarcuota", pagarPrestamo)

-- A esta función la llamaran el sistema de renovaciones
-- Si un jugador paga impuestos para renovar su vehículo y 
-- tiene préstamo, que ese dinero vaya también para pagar el préstamo.

function pagarPrestamoSinQuitarDinero (player, tipo, cantidad)
	if not cantidad or not tipo then return false end
	local cantidad = tonumber(math.floor(cantidad))
	if tienePrestamosPersonaje(player) == true then
		local sql = exports.sql:query_assoc_single("SELECT * FROM prestamos WHERE cantidad > pagado AND tipo = "..tipo.." AND characterID = "..exports.players:getCharacterID(player))
		if sql and sql.cantidad > sql.pagado then
			if sql.pagado+tonumber(cantidad) > sql.cantidad then 
				cantidad = tonumber(sql.pagado)-tonumber(sql.cantidad)
			end
			exports.sql:query_free("UPDATE prestamos SET pagado = "..sql.pagado+cantidad.." WHERE prestamoID = "..sql.prestamoID)
			if tipo == 1 then -- vehiculo
				outputChatBox("Un sistema externo ha solicitado el pago de tu préstamo de vehículo.", player, 0, 255, 0)
			elseif tipo == 2 then --interior
				outputChatBox("Un sistema externo ha solicitado el pago de tu préstamo de interior.", player, 0, 255, 0)
			end
			outputChatBox("Se ha pagado correctamente $"..tostring(cantidad).." de tu préstamo. /prestamo para más info.", player, 0, 255, 0)
		end
	end
end


function cambiarCuota (player, cmd, tipo, cantidad)
	if not cantidad or not tipo then outputChatBox("Syntax: /"..tostring(cmd).." [tipo, 1 (vehiculo) o 2 (interior)] [cantidad a pagar en cada cuota, máximo 1000 dólares]", player, 255, 255, 255) return end
	local cantidad = tonumber(math.floor(cantidad))
	if tonumber(tipo) == 2 then outputChatBox("No puedes cambiar la cuota de un préstamo de un interior.", player, 255, 0, 0) return end
	if cantidad < 1 then outputChatBox("Has intentado bugear el sistema de préstamos. Incidente reportado.", player, 255, 0, 0) 
	exports.logs:addLogMessage("bugs", "El jugador " .. getPlayerName(player) .. " ha intentado bugear los préstamos #1 Cantidad cuota negativa.")
	return end
	if cantidad < 100 then outputChatBox("La cuota mínima es de 100$.", player, 255, 0, 0) return end
	if cantidad > 1000 then outputChatBox("Has intentado bugear el sistema de préstamos. Incidente reportado.", player, 255, 0, 0) 
	exports.logs:addLogMessage("bugs", "El jugador " .. getPlayerName(player) .. " ha intentado bugear los préstamos #2 Cantidad superior de 1000$")
	return end
	if tienePrestamosPersonaje(player) == true then
		local sql = exports.sql:query_assoc_single("SELECT * FROM prestamos WHERE tipo = "..tonumber(tipo).." AND cantidad > pagado AND characterID = "..exports.players:getCharacterID(player))
		if sql and sql.cantidad > sql.pagado then
			exports.sql:query_free("UPDATE prestamos SET cuota = "..cantidad.." WHERE prestamoID = "..sql.prestamoID)
			outputChatBox("Has cambiado la cuota a $"..tostring(cantidad).." para tu préstamo. /prestamo para más info.", player, 0, 255, 0)
		end
	else
		outputChatBox("Este personaje no tiene un préstamo pendiente.", player, 255, 0, 0)
	end
end
addCommandHandler("cuota", cambiarCuota)

function checkPrestamoAlEntrar ( thePlayer, seat, jacked )
	if not getElementData(source, "idveh") then return end
    local sql = exports.sql:query_assoc_single("SELECT * FROM prestamos WHERE tipo = 1 AND objetoID = " .. getElementData(source, "idveh"))
	if sql and sql.flimite and sql.pagado < sql.cantidad then
		local time = getRealTime()
		if time.timestamp > sql.flimite then	
			if not getElementData(thePlayer, "account:gmduty") == true then
				outputChatBox("Este vehículo está embargado por impago de préstamo. Sólo puedes subir de acompañante.", thePlayer, 255, 0, 0)
				if seat == 0 then
					removePedFromVehicle(thePlayer)
				end	
			else
				outputChatBox("ATENCIÓN STAFF: vehículo embargado por impago de préstamo.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addEventHandler ( "onVehicleEnter", getRootElement(), checkPrestamoAlEntrar )