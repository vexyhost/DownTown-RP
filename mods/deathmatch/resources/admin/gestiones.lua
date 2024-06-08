function getStaff( duty ) 
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.acceptreport", false ) then
			if not duty or exports.players:getOption( value, "staffduty" ) then
				t[ #t + 1 ] = value
			end
		end
	end
	return t
end

function staffMessageAdmin( message )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, 255, 0, 0 )
	end
end 

function aplicarBan(tipo, cadena, horas, razon, banner)
	if tipo == 1 then -- IP
		local sqlr = exports.sql:query_assoc("SELECT * FROM `wcf1_user` WHERE `lastIP` LIKE '"..tostring(cadena).."' OR `regIP` LIKE '"..tostring(cadena).."'")
		for k, v in ipairs (sqlr) do
			ipBanL = false
			ipBanR = false
			serialBanL = false
			serialBanR = false
			for banID, ban in ipairs ( getBans() ) do
				local ip = getBanIP ( ban )
				local serial = getBanSerial ( ban )
				if ip then
					if ip == v.lastIP then
						ipBanL = true
					end
					if ip == v.regIP then
						ipBanR = true
					end
				end
				if serial then
					if serial == v.lastSerial then
						serialBanL = true
					end
					if serial == v.regSerial then
						serialBanR = true
					end
				end
			end
			if ipBanL == false then
				addBan( v.lastIP, nil, nil, banner, razon, math.ceil( horas*60*60 ) )
			end
			if ipBanR == false then
				addBan( v.regIP, nil, nil, banner, razon, math.ceil( horas*60*60 ) )
			end
			if serialBanL == false then
				aplicarBan(2, tostring(v.lastSerial), horas, tostring(razon), banner)
			end
			if serialBanR == false then
				aplicarBan(2, tostring(v.regSerial), horas, tostring(razon), banner)
			end
			exports.sql:query_free("UPDATE `wcf1_user` SET `banned` = '1', `banReason` = '"..tostring(razon).."', `banUser` = '"..tostring(exports.players:getUserID(banner)).."' WHERE `userID` = "..v.userID)
			outputChatBox("Cuenta baneada: "..tostring(v.username), banner, 0, 255, 0)
		end
	elseif tipo == 2 then -- Serial
		local sqlr = exports.sql:query_assoc("SELECT * FROM `wcf1_user` WHERE `lastSerial` LIKE '"..tostring(cadena).."' OR `regSerial` LIKE '"..tostring(cadena).."'")
		for k, v in ipairs (sqlr) do
			ipBanL = false
			ipBanR = false
			serialBanL = false
			serialBanR = false
			for banID, ban in ipairs ( getBans() ) do
				local ip = getBanIP ( ban )
				local serial = getBanSerial ( ban )
				if ip then
					if ip == v.lastIP then
						ipBanL = true
					end
					if ip == v.regIP then
						ipBanR = true
					end
				end
				if serial then
					if serial == v.lastSerial then
						serialBanL = true
					end
					if serial == v.regSerial then
						serialBanR = true
					end
				end
			end
			if ipBanL == false then
				aplicarBan(1, tostring(v.lastIP), horas, tostring(razon), banner)
			end
			if ipBanR == false then
				aplicarBan(1, tostring(v.regIP), horas, tostring(razon), banner)
			end
			if serialBanL == false then
				addBan( nil, nil, v.lastSerial, banner, razon, math.ceil( horas*60*60 ) )
			end
			if serialBanR == false then
				addBan( nil, nil, v.regSerial, banner, razon, math.ceil( horas*60*60 ) )
			end
			exports.sql:query_free("UPDATE `wcf1_user` SET `banned` = '1', `banReason` = '"..tostring(razon).."', `banUser` = '"..tostring(exports.players:getUserID(banner)).."' WHERE `userID` = "..v.userID)
			outputChatBox("Cuenta baneada: "..tostring(v.username), banner, 0, 255, 0)
		end
	end
end

function banearSerial ( thePlayer, commandName, serial, horas, ... )
	if hasObjectPermissionTo(thePlayer, 'command.ban', false) then
		if ( serial ) and ( horas ) and ( ... ) then
			local horas = tonumber(horas)
			local razon = table.concat( { ... }, " " )
			if horas == 0 then
				staffMessageAdmin(getPlayerName(thePlayer):gsub("_", " ")..  " ha baneado el serial " ..serial.. " permanentemente.")
			else
				staffMessageAdmin(getPlayerName(thePlayer):gsub("_", " ")..  " ha baneado el serial " ..serial.. " durante "..tostring(horas).." horas.")
			end
			staffMessageAdmin("Razón: "..razon)
			aplicarBan(2, tostring(serial), horas, tostring(razon), thePlayer)
		else
			outputChatBox("Síntaxis: /banserial [serial] [horas] [razón]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("Acceso denegado.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler ("banserial", banearSerial)

function banearIP ( thePlayer, commandName, ip, horas, ... )
	if hasObjectPermissionTo(thePlayer, 'command.ban', false) then
		if ( ip ) and ( horas ) and ( ... ) then
			local horas = tonumber(horas)
			local razon = table.concat( { ... }, " " )
			if horas == 0 then
				staffMessageAdmin(getPlayerName(thePlayer):gsub("_", " ")..  " ha baneado la IP " ..ip.. " permanentemente.")
			else
				staffMessageAdmin(getPlayerName(thePlayer):gsub("_", " ")..  " ha baneado la IP " ..ip.. " durante "..tostring(horas).." horas.")
			end
			staffMessageAdmin("Razón: "..razon)
			aplicarBan(1, tostring(ip), horas, tostring(razon), thePlayer)
		else
			outputChatBox("Síntaxis: /banip [ip] [horas] [razón]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("Acceso denegado.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler ( "banip", banearIP )

function removeBanSerial (player, cmd, serial)
	local serial = tostring(serial)
	if hasObjectPermissionTo(player, 'command.adminchat', false) then
		for k, v in ipairs(getBans()) do
			if getBanSerial(v) == serial then
				removeBan(v)
				banquitado = true
				outputChatBox("Has removido el ban al serial "..getBanSerial(v)..".", player, 0, 255, 0)
			end
		end
		if banquitado == true then
			local sqlr = exports.sql:query_assoc("SELECT username, lastSerial, regSerial, userID FROM wcf1_user")
			for k, v in ipairs (sqlr) do
				if v.regSerial == serial or v.lastSerial == serial then
					exports.sql:query_free("UPDATE wcf1_user SET banned = 0 WHERE userID = "..v.userID)
					outputChatBox("Has removido el ban a la cuenta "..tostring(v.username)..".", player, 0, 255, 0)
				end
			end	
		end
	else
		outputChatBox("Acceso denegado.", player, 255, 0, 0)
	end
end
addCommandHandler("rbs", removeBanSerial)	

function removeBanIP (player, cmd, ip)
	local ip = tostring(ip)
	if hasObjectPermissionTo(player, 'command.adminchat', false) then
		for k, v in ipairs(getBans()) do
			if getBanIP(v) == ip then
				removeBan(v)
				banquitado = true
				outputChatBox("Has removido el ban a la IP "..getBanIP(v)..".", player, 0, 255, 0)
			end
		end
		if banquitado == true then
			local sqlr = exports.sql:query_assoc("SELECT username, lastIP, regIP, userID FROM wcf1_user")
			for k, v in ipairs (sqlr) do
				if v.regIP == ip or v.lastIP == ip then
					exports.sql:query_free("UPDATE wcf1_user SET banned = 0 WHERE userID = "..v.userID)
					outputChatBox("Has removido el ban a la cuenta "..tostring(v.username)..".", player, 0, 255, 0)
				end
			end	
		end
	else
		outputChatBox("Acceso denegado.", player, 255, 0, 0)
	end
end
addCommandHandler("rbip", removeBanIP)

function obtenerVehiculos(player, cmd, other)
	if hasObjectPermissionTo(player, "command.acceptreport", false) then
	--if not other then outputChatBox("Síntaxis: /"..tostring(cmd).." [jugador]", player, 255, 255, 255) return end
		local otro, nombre = exports.players:getFromName(player, other)
		if otro then
			outputChatBox("Vehículos de "..nombre, player, 0, 255, 0)
			local sql = exports.sql:query_assoc("SELECT vehicleID, model, color1, color2, inactivo, cepo FROM vehicles WHERE characterID = "..exports.players:getCharacterID(otro))
			for k, v in ipairs(sql) do
				if v.inactivo == 0 then inactivo = "#FFFFFFN/A" else inactivo = "#FF0000Embargado, en mano de concesionarios por no renovar el vehículo." end
				if v.cepo == 1 then inactivo = "#FF0000Tiene cepo." end
				outputChatBox("ID "..tostring(v.vehicleID).." - "..getVehicleNameFromModel(v.model).." - Color 1: "..tostring(v.color1).."###### - #00FF00Color 2:"..tostring(v.color2).."###### - #00FF00Llave: ".. ( exports.items:has(otro, 1, tonumber(v.vehicleID)) and "#00FF00Sí" or "#FF0000NO" ) .. " - #00FF00Otro: " ..tostring(inactivo), player, 0, 255, 0, true)
			end
		end
	end
end
addCommandHandler("vehs", obtenerVehiculos)
addCommandHandler("vehiculos", obtenerVehiculos)

function obtenerInteriores(player, cmd, other)
	if hasObjectPermissionTo(player, "command.acceptreport", false) then
	if not other then outputChatBox("Síntaxis: /"..tostring(cmd).." [jugador]", player, 255, 255, 255) return end
		local otro, nombre = exports.players:getFromName(player, other)
		if otro then
			outputChatBox("Interiores de "..nombre, player, 0, 255, 0)
			local sql = exports.sql:query_assoc("SELECT interiorID, interiorName, interiorType FROM interiors WHERE characterID = "..exports.players:getCharacterID(otro))
			for k, v in ipairs(sql) do
				outputChatBox("ID "..tostring(v.interiorID).." - Nombre: "..tostring(v.interiorName).." - #00FF00Llave: ".. ( exports.items:has(otro, 2, tonumber(v.interiorID)) and "#00FF00Sí" or "#FF0000NO" ), player, 0, 255, 0, true)
			end
		end
	end
end
addCommandHandler("ints", obtenerInteriores)
addCommandHandler("interiores", obtenerInteriores)

function LineaConIMEI(imei)
	if imei then
		local imeiok = string.format("%13.0f",imei)
		local consulta = exports.sql:query_assoc_single("SELECT `numero` FROM `tlf_data` WHERE `estado` = 0 AND `imei` = "..tostring(imeiok))
		if consulta then
			return consulta.numero
		else
			return -1
		end
	end
end

function obtenerTitular(player, cmd, id, tipo)
	if hasObjectPermissionTo(player, "command.acceptreport", false) or exports.factions:isPlayerInFaction(player, 1) then
	if not id or not tipo then outputChatBox("Síntaxis: /"..tostring(cmd).." [ID/numero] [1=vehiculo, 2=interior, 3=numero telefono]", player, 255, 255, 255) return end
		local tipo = tonumber(tipo)
		if tipo == 1 then
			local sql = exports.sql:query_assoc_single("SELECT characterID FROM vehicles WHERE vehicleID = " .. tostring(id))
			if not sql or not sql.characterID then outputChatBox("Este ID de vehículo no tiene ningún titular o no existe.", player, 255, 0, 0) return end
			if sql.characterID > 0 then
				local sql2 = exports.sql:query_assoc_single("SELECT characterName FROM characters WHERE characterID = " .. tostring(sql.characterID))
				if sql2 and sql2.characterName then
					titular = sql2.characterName
				else
					titular = "(( Error Grave. Revisa el ID ))"
				end
			else
				titular = exports.factions:getFactionName(math.abs(sql.characterID))
			end
			if exports.factions:isPlayerInFaction(player, 1) and not exports.players:getOption(player, "staffduty") == true then
				local message = "Aquí "..getPlayerName(player):gsub("_", " ")..", solicito el propietario del vehículo con matrícula "..tostring(id).."."
				exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) " .. getPlayerName( player ):gsub("_", " ") .. ": " .. message, 127, 127, 255 )
				exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) Central: Central para Agente " .. getPlayerName( player ):gsub("_", " ") .. ", el titular con matrícula "..tostring(id).." es "..tostring(titular)..".", 127, 127, 255 )
			else
				outputChatBox("El dueño del vehículo con el ID " .. id .. " es " ..tostring(titular), player, 0, 255, 0)
			end
		elseif tipo == 2 then
			local sql = exports.sql:query_assoc_single("SELECT characterID FROM interiors WHERE interiorID = " .. tostring(id))
			if not sql or not sql.characterID then outputChatBox("Este ID de interior no tiene ningún titular o no existe.", player, 255, 0, 0) return end
			if sql.characterID > 0 then
				local sql2 = exports.sql:query_assoc_single("SELECT characterName FROM characters WHERE characterID = " .. tostring(sql.characterID))
				if not sql2 then titular = "((PJ borrado))" end
				titular = sql2.characterName
			else
				titular = exports.factions:getFactionName(math.abs(sql.characterID))
			end
			if exports.factions:isPlayerInFaction(player, 1) and not exports.players:getOption(player, "staffduty") == true then
				local message = "Aquí "..getPlayerName(player):gsub("_", " ")..", solicito el propietario del interior ID "..tostring(id).."."
				exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) " .. getPlayerName( player ):gsub("_", " ") .. ": " .. message, 127, 127, 255 )
				exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) Central: Central para Agente " .. getPlayerName( player ):gsub("_", " ") .. ", el titular del interior "..tostring(id).." es "..tostring(titular)..".", 127, 127, 255 )
			else
				outputChatBox("El dueño del interior con el ID " .. id .. " es " ..tostring(titular), player, 0, 255, 0)
			end
		elseif tipo == 3 then
			local sql = exports.sql:query_assoc_single("SELECT titular FROM tlf_data WHERE numero = " .. id)
			if not sql or not sql.titular then outputChatBox("Este ID de interior no tiene ningún titular o no existe.", player, 255, 0, 0) return end
			if sql.titular > 0 then
				local sql2 = exports.sql:query_assoc_single("SELECT characterName FROM characters WHERE characterID = " .. tostring(sql.titular))
				titular = sql2.characterName
			else
				titular = exports.factions:getFactionName(math.abs(sql.titular))
			end
			if exports.factions:isPlayerInFaction(player, 1) and not exports.players:getOption(player, "staffduty") == true then
				local message = "Aquí "..getPlayerName(player):gsub("_", " ")..", solicito el propietario del número "..tostring(id).."."
				exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) " .. getPlayerName( player ):gsub("_", " ") .. ": " .. message, 127, 127, 255 )
				exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) Central: Central para Agente " .. getPlayerName( player ):gsub("_", " ") .. ", el titular del número "..tostring(id).." es "..tostring(titular)..".", 127, 127, 255 )
			else
				outputChatBox("El dueño del número " .. id .. " es " ..tostring(titular), player, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("titular", obtenerTitular)

function obtenerTitularFac(player, cmd, fac)
	if hasObjectPermissionTo(player, "command.acceptreport", false) then
	if not fac then outputChatBox("Síntaxis: /"..tostring(cmd).." [factionID]", player, 255, 255, 255) return end
		local titular = exports.sql:query_assoc("SELECT vehicleID, model FROM vehicles WHERE characterID = -"..tonumber(fac))
		for k, v in ipairs(titular) do
			if v then
			outputChatBox("Vehiculo ID "..tostring(v.vehicleID)..". Modelo:"..getVehicleNameFromModel(v.model)..".",player, 0, 255, 0)	
			end
		end
	end
end
addCommandHandler("vehsf", obtenerTitularFac)

function setPassword(username, password)
	local username = tostring(username)
	local password = tostring(password)
	if username and password then
		local salt = ''
		local chars = { 'a', 'b', 'c', 'd', 'e', 'f', 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
		for i = 1, 40 do
			salt = salt .. chars[ math.random( 1, #chars ) ]
		end
		local d = exports.sql:query_assoc_single( "SELECT userID FROM wcf1_user WHERE userName = '%s'", username )
		local newpass = hash("sha1", tostring(salt)..tostring(hash("sha1", tostring(salt)..tostring(hash("sha1", password)))))
		local sql, error = exports.sql:query_free( "UPDATE wcf1_user SET salt = '%s' WHERE userID = " .. d.userID, salt )
		local sql2, error2 = exports.sql:query_free( "UPDATE wcf1_user SET password = '%s' WHERE userID = " .. d.userID, newpass )
		if sql and sql2 and not error and not error2 then
			return true
		else
			return false
		end
	end
end

function borrarMiPJ(player, cmd, con)
	if not con or tostring(con) ~= "ok" then
		outputChatBox("Estás a punto de eliminar tu personaje "..getPlayerName(player):gsub("_", " ")..".Ten en cuenta:", player, 255, 255, 255)
		outputChatBox("- Todas tus pertenencias serán eliminadas. No se podrán recuperar.", player, 0, 255, 0)
		outputChatBox("- El coste es de 700$, que deberás de tener encima.", player, 0, 255, 0)
		outputChatBox("- Si tienes un vehículo/interior asociado a un préstamo, se eliminará.", player, 0, 255, 0)
		outputChatBox("- Si tienes condena IC, NO puedes eliminar tu personaje.", player, 0, 255, 0)
		outputChatBox("- Por seguridad, quedará registrada IP, serial, nombre del PJ, fecha y hora.", player, 0, 255, 0)
		outputChatBox("Usa /borrarmipj ok para borrar definitivamente tu personaje.", player, 255, 255, 0)
	else
		-- Primero, realizar comprobaciones de seguridad para evitar malentendidos.
		local datos = exports.sql:query_assoc_single("SELECT regSerial FROM wcf1_user WHERE userID = ".. exports.players:getUserID(player))
		if datos and datos.regSerial then
			if tostring(datos.regSerial) ~= getPlayerSerial(player) then
				outputChatBox("No se ha podido eliminar este personaje. Estás desde un PC distinto del que registró la cuenta.", player, 255, 0, 0)
				return
			end
		else
			outputChatBox("Se ha producido un error grave. Inténtalo de nuevo más tarde.", player, 255, 0, 0)
			return
		end
		local ajail = tonumber(getElementData(player, "ajail"))
		if ajail and ajail >= 1 then outputChatBox("Estás cumpliendo condena IC. Eliminación cancelada.", player, 255, 0, 0) return end
		if not exports.players:takeMoney(player, 700) then
			outputChatBox("No tienes encima los 700$ necesarios. Eliminación cancelada.", player, 255, 0, 0)
			return
		end
		-- Segundo, solicitar datos de los interiores/vehículos con prestamos, para proceder a su eliminación.
		local prestamos = exports.sql:query_assoc("SELECT * FROM prestamos WHERE characterID = "..exports.players:getCharacterID(player))
		for k, v in ipairs(prestamos) do
			if tonumber(v.tipo) == 1 then -- Es un vehículo
				--local vehicle = exports.vehicles:getVehicle(tonumber(v.objetoID))
				--if vehicle then
					--exports.vehicles:deleteVehicle(vehicle)
				--end
			elseif tonumber(v.tipo) == 2 then -- Es un interior
				exports.interiors:solicitarVentaInterior(v.objetoID)
			end
		end
		local charID = tonumber(exports.players:getCharacterID(player))
		outputChatBox("Tu personaje "..getPlayerName(player):gsub("_", " ").. " ha sido eliminado. Reconexión en 5 segundos.", player, 0, 255, 0)
		exports.logs:addLogMessage("/pj/"..getPlayerName(player):gsub("_", " "), "PJ Eliminado - cID: "..tostring(exports.players:getCharacterID(player)).." - IP: "..tostring(getPlayerIP(player)).." - Serial: "..tostring(getPlayerSerial(player))..".")
		setTimer(redirectPlayer, 5000, 1, player, "", 0)
		setTimer(function ()
		exports.sql:query_free("DELETE FROM prestamos WHERE characterID = "..charID)
		exports.sql:query_free("DELETE FROM characters WHERE characterID = "..charID)
		exports.sql:query_free("DELETE FROM armas_suelo WHERE characterID = "..charID)
		exports.sql:query_free("DELETE FROM items WHERE owner = "..charID)
		exports.sql:query_free("DELETE FROM multas WHERE characterID = "..charID)
		end, 7000, 1, charID)
	end
end
addCommandHandler("borrarmipj", borrarMiPJ)

function inactivoVehiculo(player, c, vehicleID)
	--[[if hasObjectPermissionTo(player, "command.modchat", false) then
		if not vehicleID then outputChatBox("Sintaxis: /inactivo [vehicleID]", player, 255, 255, 255) return end
		local vehicle = exports.vehicles:getVehicle(tonumber(vehicleID))
		if vehicle then
			outputChatBox("Has marcado como inactivo el vehículo con ID "..tostring(vehicleID), player, 255, 0, 0)
			exports.sql:query_free("UPDATE vehicles SET inactivo = 1 WHERE vehicleID = ".. vehicleID)
			destroyElement(vehicle)
		end
	else
		outputChatBox("Acceso denegado.", player, 255, 0, 0)
	end]]
	outputChatBox("Comando desactivado, el sistema ha sido removido.", player, 255, 0, 0)
end
addCommandHandler("inactivo", inactivoVehiculo)

function activoVehiculo(player, c, vehicleID)
	--[[if hasObjectPermissionTo(player, "command.modchat", false) then
		if not vehicleID then outputChatBox("Sintaxis: /activo [vehicleID]", player, 255, 255, 255) return end
		local vehicle = exports.vehicles:getVehicle(tonumber(vehicleID))
		if not vehicle then
			local sql = exports.sql:query_assoc_single("SELECT cepo FROM vehicles WHERE vehicleID = "..tostring(vehicleID))
			if sql then
				if tonumber(sql.cepo) == 1 then outputChatBox("¡Ups! Este vehículo tiene cepo. Avisa al usuario.", player, 255, 0, 0) return end
				outputChatBox("Has marcado como activo el vehículo con ID "..tostring(vehicleID), player, 0, 255, 0)
				exports.sql:query_free("UPDATE vehicles SET inactivo = 0 WHERE vehicleID = ".. vehicleID)
				exports.vehicles:reloadVehicle(tonumber(vehicleID))
			else
				outputChatBox("¡Ups! Este vehículo no existe. Revisa el ID especificado.", player, 255, 0, 0)
			end
		end
	else
		outputChatBox("Acceso denegado.", player, 255, 0, 0)
	end]]
	outputChatBox("Comando desactivado, el sistema ha sido removido.", player, 255, 0, 0)
end
addCommandHandler("activo", activoVehiculo)

function avisoATitulares()
	local charID = exports.players:getCharacterID(source)
	if charID then
		local sql = exports.sql:query_assoc("SELECT vehicleID FROM vehicles WHERE inactivo = 1 AND characterID = "..charID)
		for k, v in ipairs(sql) do
			outputChatBox("Tu vehículo ID "..tostring(v.vehicleID).." ha sido embargado por impago de impuestos.", source, 255, 0, 0)
		end
	end
end
addEventHandler("onCharacterLogin", getRootElement(), avisoATitulares)

function inactivoMasivo ( player, c )
	if hasObjectPermissionTo( player, "command.modchat", false ) then
		local x, y, z = getElementPosition( player )
		local dimension = getElementDimension( player )
		local interior = getElementInterior( player )
		for index, vehicle in ipairs ( getElementsByType ( "vehicle" ) ) do
			local px, py, pz = getElementPosition( vehicle )
			if getDistanceBetweenPoints3D( x, y, z, px, py, pz ) <= 5 then
				local idveh = tonumber(getElementData ( vehicle, "idveh" ))
				inactivoVehiculo(player, c, idveh)
			end
		end
	end
end
--addCommandHandler("inactivoMasivo", inactivoMasivo)

local function getJugadoresFaccion( factionID )
	local p = { }
	for index,value in ipairs(getElementsByType("player")) do 
		if exports.factions:isPlayerInFaction( value, factionID ) or getElementData(value, "enc"..tostring(factionID)) then 
			table.insert( p, value )
		end 
	end 
	return p
end

function utilesDeServicio(player)
	if hasObjectPermissionTo( player, "command.modchat", false ) then
		outputChatBox("~~Listado de Agentes/Médicos y demás conectados~~", player, 255, 0, 0)
		outputChatBox("Agentes de Policía: "..tostring(#getJugadoresFaccion(1))..".", player, 0, 255, 0)
		outputChatBox("Médicos/Bomberos: "..tostring(#getJugadoresFaccion(2))..".", player, 0, 255, 0)
		local m1 = getJugadoresFaccion(3)
		local m2 = getJugadoresFaccion(11)
		local m3 = getJugadoresFaccion(14)
		local m4 = getJugadoresFaccion(12)
		outputChatBox("Mecánicos: "..tostring(#m1+#m2+#m3+#m4)..".", player, 0, 255, 0)
		outputChatBox("Gobierno: "..tostring(#getJugadoresFaccion(5))..".", player, 0, 255, 0)
	end
end
addCommandHandler("conectados", utilesDeServicio)
addCommandHandler("agentes", utilesDeServicio)
addCommandHandler("medicos", utilesDeServicio)
addCommandHandler("mecanicos", utilesDeServicio)
addCommandHandler("operativos", utilesDeServicio)

function aplicarCK(player, cmd, otherPlayer, ...)
	if hasObjectPermissionTo( player, "command.modchat", false ) then
		if otherPlayer and (...) then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local razon = table.concat( { ... }, " " ):gsub( "_", " " )
				local charID = exports.players:getCharacterID(other)
				exports.sql:query_free("UPDATE `characters` SET `CKuIDStaff` = '"..tostring(exports.players:getUserID(player)).."' WHERE `characterID` = "..tostring(charID))
				outputChatBox("Has aplicado el CK a "..name..".", player, 0, 255, 0)
				outputChatBox("Razón: "..tostring(razon), player, 0, 255, 0)
				outputChatBox("El staff "..tostring(getPlayerName(player):gsub("_", " ")).." te ha aplicado CK a tu personaje.", other, 0, 255, 0)
				outputChatBox("Razón: "..tostring(razon), other, 0, 255, 0)
				outputChatBox("Puedes acudir al foro si no estás de acuerdo. Reconexión en 5 segundos.", other, 0, 255, 0)
				exports.logs:addLogMessage("listado_ck", "PJ Ckeado: "..name..". Staff: "..exports.players:getUserName(player)..". Razón: "..tostring(razon))
				setTimer(redirectPlayer, 5000, 1, other, "", 0)
			end
		else
			outputChatBox("Sintaxis: /aplicarck [jugador] [razón]", player, 255, 255, 255)
		end
	end
end
addCommandHandler("aplicarck", aplicarCK)