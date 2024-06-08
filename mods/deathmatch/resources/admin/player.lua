local anuncios = { "Recuerda usar /duda antes de /pm. ¡Por una atención rápida y eficaz!", 
"¡Visita el foro en foro.dt-mta.com para enterarte de todo!", 
"Si observas algún bug, o tienes algún problema, pulsa F1.", 
"¿Aún no sabes que tenemos servidor de TS3? IP: ts3.dt-mta.com",
"¿Necesitas ayuda sobre el servidor? Pulsa F1 o avisanos con /duda ;)", 
"¿Cansado de tu personaje? Usa /borrarmipj para informarte sobre cómo borrarlo.",
"¿Harto de trabajar mucho y ganar poco? ¡Ve a foro.dt-mta.com para entrar en una empresa!",
"¿Sabes que tenemos navegador?, podrás acceder a foro y youtube usa (/web)!",
"Recuerda: el F1 es sólo para problemas graves o sugerencias. ¡Usa /duda primero!",
"Recuerda: las multicuentas, el pasar un vehículo a otro de tus PJ... ¡Es Sancionable!",
"Recuerda: respetar los entornos de los lugares y tener un rol adecuado del personaje.",
"¿Nos necesitas? Utiliza /duda para cualquier problema ;)"}

function mensajeAleatorio()
	outputChatBox(anuncios[math.random(1, #anuncios)], root, 127, 255, 127)
end
setTimer(mensajeAleatorio, 10000, 1)
setTimer(mensajeAleatorio, 900000, 0)
--addCommandHandler("mst", mensajeAleatorio)

-- addCommandHandler supporting arrays as command names (multiple commands with the same function)
local addCommandHandler_ = addCommandHandler
      addCommandHandler  = function( commandName, fn, restricted, caseSensitive )
	-- add the default command handlers
	if type( commandName ) ~= "table" then
		commandName = { commandName }
	end
	for key, value in ipairs( commandName ) do
		if key == 1 then
			if value and not fn then
				outputDebugString(tostring(value))
			end
			addCommandHandler_( value, fn, restricted, caseSensitive )
		else
			addCommandHandler_( value,
				function( player, ... )
					-- check if he has permissions to execute the command, default is not restricted (aka if the command is restricted - will default to no permission; otherwise okay)
					if hasObjectPermissionTo( player, "command." .. commandName[ 1 ], not restricted ) or hasObjectPermissionTo( player, "command.modchat", not restricted ) then
						fn( player, ... )
					end
				end
			)
		end
	end
end

function consultarLowPlayers(player)
	if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
	outputChatBox("~~Jugadores que están en LOW-HP~~", player, 255, 255, 255)
	for k, v in ipairs(getElementsByType("player")) do
		if getElementHealth(v) <= 30 then
			outputChatBox("Nombre: "..tostring(getPlayerName(v):gsub("_", " "))..". HP: "..tostring(getElementHealth(v))..".", player, 255, 255, 0)
		end
	end
end
addCommandHandler("low", consultarLowPlayers)

addCommandHandler( "genero",
	function( player, commandName, otherPlayer, genero )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if otherPlayer and genero then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local characterID = exports.players:getCharacterID( other )
				if string.lower(genero) == "hombre" then 
					generoID = 1
				elseif string.lower(genero) == "mujer" then
					generoID = 2
				else
					outputChatBox("Género inválido ("..tostring(genero).."). Usa hombre o mujer.", player, 255, 0, 0)
					return
				end
				if characterID then
					if exports.sql:query_free( "UPDATE characters SET genero = " .. generoID .. " WHERE characterID = " .. characterID ) then
						outputChatBox( "Has cambiado el género de " .. name .. " a " .. tostring(genero), player, 0, 255, 153 )
					else
						outputChatBox( "No se ha podido cambiar el género de "..tostring(name), player, 255, 0, 0 )
					end
				end
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [jugador] [hombre o mujer]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "color",
	function( player, commandName, otherPlayer, color )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if otherPlayer and color then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local characterID = exports.players:getCharacterID( other )
				if string.lower(color) == "blanco" then 
					colorID = 1
				elseif string.lower(color) == "negro" then
					colorID = 0
				else
					outputChatBox("Color inválido ("..tostring(color).."). Usa blanco o negro.", player, 255, 0, 0)
					return
				end
				if characterID then
					if exports.sql:query_free( "UPDATE characters SET color = " .. colorID .. " WHERE characterID = " .. characterID ) then
						outputChatBox( "Has cambiado el color de " .. name .. " a " .. tostring(color), player, 0, 255, 153 )
					else
						outputChatBox( "No se ha podido cambiar el color de "..tostring(name), player, 255, 0, 0 )
					end
				end
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [jugador] [blanco o negro]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "edad",
	function( player, commandName, otherPlayer, edad )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if otherPlayer and edad and tonumber(edad) then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local characterID = exports.players:getCharacterID( other )
				if characterID then
					if exports.sql:query_free( "UPDATE characters SET edad = " .. tonumber(edad) .. " WHERE characterID = " .. characterID ) then
						outputChatBox( "Has cambiado la edad de " .. name .. " a " .. tostring(edad), player, 0, 255, 153 )
					else
						outputChatBox( "No se ha podido cambiar la edad de "..tostring(name), player, 255, 0, 0 )
					end
				end
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [jugador] [edad]", player, 255, 255, 255 )
		end
	end,
	true
)

local function teleport( player, x, y, z, interior, dimension )
	if isPedInVehicle( player ) and getPedOccupiedVehicleSeat( player ) == 0 then
		local vehicle = getPedOccupiedVehicle( player )
		setElementPosition( vehicle, x, y, z )
		setElementInterior( vehicle, interior )
		setElementDimension( vehicle, dimension )
		
		for i = 0, getVehicleMaxPassengers( vehicle ) do
			local p = getVehicleOccupant( vehicle, i )
			if p then
				setElementInterior( p, interior )
				setElementDimension( p, dimension )
			end
		end
		
		setElementAngularVelocity( vehicle, 0, 0, 0 )
		setElementVelocity( vehicle, 0, 0, 0 )
		return true
	else
		if isPedInVehicle( player ) then
			removePedFromVehicle( player )
		end
		setElementPosition( player, x, y, z )
		setElementInterior( player, interior )
		setElementDimension( player, dimension )
		return true
	end
end

addCommandHandler( "revivir",
	function( player, commandName, otherPlayer, health )
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then	
				local x, y, z = getElementPosition( other )
				local rot = getElementRotation( other )
				local skin = getElementModel( other )
				local dim = getElementDimension( other )
				local int = getElementInterior( other )			
				outputChatBox( "Has revivido a " .. name .. ".", player, 0, 255, 153 )
				if getElementData(player, "enc") then
					outputChatBox( "Alguien te ha revivido.", other, 0, 255, 153 )
				else
					outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha revivido.", other, 0, 255, 153 )
				   -- staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha revivido administrativamente a "..getPlayerName( other ):gsub( "_", " " ) ..".")
				end
				for i = 3, 9 do
					removeElementData(other, "herida"..tostring(i))
					i = i+1
				end
				triggerClientEvent(other, "onClientNoMuerto", other)
				exports.medico:anularLlevarse(other)
				removeElementData(other, "muerto")
				removeElementData(other, "accidente")
				exports.items:guardarArmas(other, true)
				spawnPlayer( other, x, y, z, rot, skin, int, dim )
				fadeCamera( other, true )
				setCameraTarget( other, other )
				setCameraInterior( other, int )
				if health then
					setElementHealth(other, tonumber(health))
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [(optional) health]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "reconectar",
	function( player, commandName, otherPlayer )
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then	
				local x, y, z = getElementPosition( other )
				local rot = getElementRotation( other )
				local skin = getElementModel( other )
				local dim = getElementDimension( other )
				local int = getElementInterior( other )			
				outputChatBox( "Has reconectado a " .. name .. ".", player, 0, 255, 153 )
				if getElementData(player, "enc") then
					outputChatBox( "Alguien te ha reconectado.", other, 0, 255, 153 )
				else
					outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha reconectado.", other, 0, 255, 153 )	
				end
				outputChatBox(" En 5 segundos reconectarás automáticamente al servidor.", other, 0, 255, 153 )
				setTimer(redirectPlayer, 5000, 1, other, "", 0)
				exports.items:guardarArmas(other, true)
				spawnPlayer( other, x, y, z, rot, skin, int, dim )
				fadeCamera( other, true )
				setCameraTarget( other, other )
				setCameraInterior( other, int )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "desbug",
	function( player, commandName, otherPlayer )
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then	
				local x, y, z = getElementPosition( other )
				local rot = getElementRotation( other )
				local skin = getElementModel( other )
				local dim = getElementDimension( other )
				local int = getElementInterior( other )			
				outputChatBox( "Has desbugeado a " .. name .. ".", player, 0, 255, 153 )
				if getElementData(player, "enc") then
					outputChatBox( "Alguien te ha desbugeado.", other, 0, 255, 153 )
				else
					outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha desbugeado.", other, 0, 255, 153 )	
				end
				exports.items:guardarArmas(other, true)
				if dim > 0 then
					local px, py, pz, pdim, pint = exports.interiors:getPos(dim)
					spawnPlayer( other, px, py, pz, rot, skin, pint, pdim )
				else
					spawnPlayer( other, x, y, z, rot, skin, pint, pdim )
				end
				fadeCamera( other, true )
				setCameraTarget( other, other )
				setCameraInterior( other, int )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

-- addCommandHandler( "forzarpcu",
	-- function( player, commandName, otherPlayer )
		-- if otherPlayer then
			-- local other, name = exports.players:getFromName( player, otherPlayer )
			-- if other then
				-- local userID = exports.players:getUserID(other)
				-- exports.sql:query_free( "UPDATE wcf1_user SET activationCode = 1 WHERE userID = " .. userID )
				-- triggerEvent( getResourceName( resource ) .. ":logout", other )
				-- outputChatBox( "Has forzado a realizar el test de rol a " .. name .. ".", player, 0, 255, 153 )
				-- staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha forzado el test de rol a "..getPlayerName( other ):gsub( "_", " " ) ..".")
				-- exports.logs:addLogMessage("forzarpcustaff", "El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha forzado el test de rol a "..getPlayerName( other ):gsub( "_", " " ) ..".")
				-- outputChatBox("El staff "..getPlayerName( player ):gsub( "_", " " ) .." te ha forzado el test de rol.", player, 255, 0, 0)
				-- setTimer(redirectPlayer, 4000, 1,  other, "", 0 )
			-- end
		-- else
			-- outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		-- end
	-- end,
	-- true
-- )

addCommandHandler( "mandarls",
	function( player, commandName, otherPlayer )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if getElementData(other, "tjail") and getElementData(other, "tjail") >= 1 then outputChatBox("Este jugador está en jail administrativo.", player, 255, 0, 0) return end
				if getElementData(other, "ajail") and getElementData(other, "ajail") >= 1 then outputChatBox("Este jugador está arrestado en la comisaria.", player, 255, 0, 0) return end
				outputChatBox( "Has mandado a Los Santos a " .. name .. ".", player, 0, 255, 153 )
				staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha mandado a Los Santos a "..getPlayerName( other ):gsub( "_", " " ) ..".")
				outputChatBox( "El Staff "..getPlayerName( player ):gsub( "_", " " ) .. " te ha mandado a Los Santos.", other, 0, 255, 153 )
				removePedFromVehicle ( other ) 
				setElementPosition(other, 1496.6, -1649.43, 14.05 )
				setElementDimension(other,0)
				setElementInterior(other,0)
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "get",
	function( player, commandName, otherPlayer )
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local x, y, z = getElementPosition( player )
				if other ~= player then
					if getElementData(other, "spec") == true then outputChatBox("Este jugador está en spec. No puedes darle TP.", player, 255, 0, 0) return end
					if exports.freecam:isPlayerFreecamEnabled( other ) then outputChatBox("Este jugador está en freecam. No puedes darle TP.", player, 255, 0, 0) return end
					if getElementData(other, "tjail") and getElementData(other, "tjail") >= 1 then outputChatBox("Este jugador está en jail administrativo.", player, 255, 0, 0) return end
					if getElementData(other, "ajail") and getElementData(other, "ajail") >= 1 then outputChatBox("Este jugador está arrestado en la comisaria.", player, 255, 0, 0) return end
					local teleported = false
					local vehicle = getPedOccupiedVehicle( player )
					if vehicle then
						if isVehicleLocked(vehicle) then setVehicleLocked ( vehicle, false ) end
						for i = 0, getVehicleMaxPassengers( vehicle ) do
							local p = getVehicleOccupant( vehicle, i )
							if not p then
								setElementPosition( other, x, y, z + 3)
								setElementInterior( other, getElementInterior( vehicle ) )
								setElementDimension( other, getElementDimension( vehicle ) )
								warpPedIntoVehicle( other, vehicle, i )
								teleported = true
								break
							end
						end
						if not teleported then
							teleport( other, x + 1, y, z, getElementInterior( player ), getElementDimension( player ) )
							outputChatBox( "Has transportado a " .. name .. " hacia ti.", player, 0, 255, 153 )
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha transportado hacia él.", other, 0, 255, 153 )
						end
					else
						if teleported or teleport( other, x + 1, y, z, getElementInterior( player ), getElementDimension( player ) ) then
							outputChatBox( "Has transportado a " .. name .. " hacia ti.", player, 0, 255, 153 )
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha transportado hacia él.", other, 0, 255, 153 )
						end
					end
				else
					outputChatBox( "(( No te puedes teletransportar a ti mismo. ))", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "goto",
	function( player, commandName, otherPlayer )
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local x, y, z = getElementPosition( other )
				if other ~= player then
					if getElementData(other, "spec") == true then outputChatBox("Este jugador está en spec. No puedes darte TP.", player, 255, 0, 0) return end
					local teleported = false
					local vehicle = getPedOccupiedVehicle( other )
					if vehicle then
						if isVehicleLocked(vehicle) then setVehicleLocked ( vehicle, false ) end
						for i = 0, getVehicleMaxPassengers( vehicle ) do
							local p = getVehicleOccupant( vehicle, i )
							if not p then		
								setElementPosition( player, x, y, z + 3)
								setElementInterior( player, getElementInterior( vehicle ) )
								setElementDimension( player, getElementDimension( vehicle ) )
								warpPedIntoVehicle( player, vehicle, i )
								teleported = true
								break
							end
						end
						if not teleported then
							teleport( player, x + 1, y, z, getElementInterior( other ), getElementDimension( other ) )
							outputChatBox( "Te has transportado a " .. name .. ".", player, 0, 255, 153 )
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " se ha transportado hacia ti.", other, 0, 255, 153 )
						end
					else	
						if teleported or teleport( player, x + 1, y, z, getElementInterior( other ), getElementDimension( other ) ) then
							outputChatBox("Te has transportado a " .. name .. ".", player, 0, 255, 153 )
							outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " se ha transportado hacia ti.", other, 0, 255, 153 )
						end
					end
				else
					outputChatBox( "(( No te puedes teletransportar hacia ti mismo ))", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "setname",
	function( player, commandName, otherPlayer, ... )
		if otherPlayer and ( ... ) then
			local newName = table.concat( { ... }, " " ):gsub( "_", " " )
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if name == newName then
					outputChatBox( name .. " ya está utilizando ese nombre.", player, 255, 0, 0 )
				elseif newName:lower( ) == name:lower( ) or not exports.sql:query_assoc_single( "SELECT characterID FROM characters WHERE characterName = '%s'", newName ) then
						if exports.sql:query_free( "UPDATE characters SET characterName = '%s' WHERE characterID = " .. exports.players:getCharacterID( other ), newName ) and setPlayerName( other, newName:gsub( " ", "_" ) ) then
							exports.players:updateNametag( other )
							triggerClientEvent( other, "updateCharacterName", other, exports.players:getCharacterID( other ), newName )
							outputChatBox( "Has cambiado el nombre de " .. name .. " a " .. newName .. ". Recuerda el cobro por el cambio.", player, 0, 255, 0 )
						    staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha cambiado el nombre de " .. name .. " a " .. newName .. ".")
						    exports.logs:addLogMessage("setnamestaff", "El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha cambiado el nombre de " .. name .. " a " .. newName .. ".")
						else
							outputChatBox( "Error al cambiar el nombre " .. name .. " a " .. newName .. ".", player, 255, 0, 0 )
						end
				else
					outputChatBox( "Otro jugador ya está utilizando ese nombre.", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [nombre nuevo]", player, 255, 255, 255 )
		end
	end,
	true
)
 
addCommandHandler( "pagostaff",
	function( player, commandName, otherPlayer, cantidad, ... )
		if otherPlayer and cantidad and ( ... ) then
			local razon = table.concat( { ... }, " " ):gsub( "_", " " )
			local cantidad = tonumber(cantidad)
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if exports.players:takeMoney(other, cantidad) then
					outputChatBox("Has cobrado a " ..tostring(name).. " " ..tostring(cantidad).. "$ por '"..tostring(razon).."'.", player, 0, 255, 0)
					outputChatBox("El staff " ..tostring(getPlayerName(player):gsub("_", " ")).. " te ha cobrado " ..tostring(cantidad).. "$ por '"..tostring(razon).."'.", other, 255, 255, 0)
					outputChatBox("Por seguridad, te recomendamos que tomes una SS (foto) pulsando al F12.", other, 255, 255, 0)
					exports.logs:addLogMessage("pagostaff", "Nombre del afectado: "..tostring(name)..". $"..tostring(cantidad)..". Staff: "..getPlayerName(player)..". Razón: "..tostring(razon)..". \n")
				else
					outputChatBox( "Error al realizar el pago. Comprueba que tenga "..tostring(cantidad).."$ el jugador.", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [jugador] [cantidad] [razon]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( { "freeze", "unfreeze" },
	function( player, commandName, otherPlayer )
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if player and other then
					local frozen = isElementFrozen( other )
					if frozen then
						outputChatBox( "Has descongelado a " .. name .. ".", player, 0, 255, 153 )
						if player ~= other then
							outputChatBox( "Has sido descongelado por " .. getPlayerName( player ):gsub("_", " ") .. ".", other, 0, 255, 153 )
						end
					else
						outputChatBox( "Has congelado a " .. name .. ".", player, 0, 255, 153 )
						if player ~= other then
							outputChatBox( "Has sido congelado por " .. getPlayerName( player ):gsub("_", " ") .. ".", other, 0, 255, 153 )
						end
					end
					toggleAllControls( other, frozen, true, false )
					setElementFrozen( other, not frozen )
					local vehicle = getPedOccupiedVehicle( other )
					if vehicle then
						setElementFrozen( vehicle, not frozen )
					end
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( { "sethealth", "sethp" },
	function( player, commandName, otherPlayer, health )
		local health = tonumber( health )
		if otherPlayer and health and health >= 0 and health <= 100 then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				local oldHealth = getElementHealth( other )
				if health < 1 then
					if triggerEvent("onSufrirAtaque", other, player, 0, 60, true) then
						outputChatBox( "Has matado a " .. name .. ".", player, 0, 255, 153 )
						outputChatBox( "El staff " .. getPlayerName(player):gsub("_", " ") .. " te ha matado.", other, 0, 255, 153 )
					end
				elseif setElementHealth( other, health ) then
					removeElementData(other, "muerto")
					outputChatBox( "Has cambiado la vida de " .. name .. " a " .. health .. ".", player, 0, 255, 153 )
					if getElementData(player, "enc") then
						outputChatBox( "Alguien te ha cambiado la vida a "..health.. ".", other, 0, 255, 153 )
					else
						outputChatBox( "El staff " .. getPlayerName(player):gsub("_", " ") .. " te ha cambiado la vida a "..health.. ".", other, 0, 255, 153 )
					    staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha cambiado la vida ("..health.. ") al usuario "..getPlayerName( other ):gsub( "_", " " ) ..".")
					end
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [health]", player, 255, 255, 255 )
		end
	end,
	true
)

addEventHandler( "onPlayerQuit", root,
	function( type, reason, player )
	if reason == "Test fallido, visita dt-mta.com y conéctate para inténtarlo..." then return end
	if type == "Kicked" then
	      tiposan = "ha kickeado a"
	elseif type == "Banned" then
		  tiposan = "ha baneado a"
		  end
		if type == "Kicked" or type == "Banned" then
			outputChatBox( ( isElement( player ) and getElementType( player ) == "player" and getPlayerName( player ):gsub( "_", " " ) or "Consola" ) .. " " .. tiposan .. " " .. getPlayerName( source ):gsub( "_", " " ) .. "." .. ( reason and #reason > 0 and ( " Razón: " .. reason ) or "" ), root, 255, 0, 0 )
		end
	end
)

addCommandHandler( "kick",
	function( player, commandName, otherPlayer, ... )
		if otherPlayer then
			local other, name = exports.players:getFromName( player, otherPlayer, true )
			if other then
				if name then
					local reason = table.concat( { ... }, " " )
					local serial = getPlayerSerial( other )
					kickPlayer( other, player, #reason > 0 and reason )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [motivo]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "ban",
	function( player, commandName, otherPlayer, hours, ... )
		hours = tonumber( hours )
		if otherPlayer and hours and hours >= 0 and ( ... ) then
			local other, name = exports.players:getFromName( player, otherPlayer, true )
			if other then
				local serial = getPlayerSerial( other )
				local reason = table.concat( { ... }, " " ) .. " (" .. ( hours == 0 and "Permanente" or ( hours < 1 and ( math.ceil( hours * 60 ) .. " minutos" ) or ( hours .. " horas" ) ) ) .. ")"		
				if exports.sql:query_free( "UPDATE wcf1_user SET banned = 1, banReason = '%s', banUser = " .. exports.players:getUserID( player ) .. " WHERE userID = " .. exports.players:getUserID( other ), reason ) then 				
					banPlayer( other, true, false, false, player, reason, math.ceil( hours * 60 * 60 ) )
					if serial then
						addBan( nil, nil, serial, player, reason .. " (" .. name .. ")", math.ceil( hours * 60 * 60 ) )
					end
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [tiempo en horas, 0 = Permanente] [motivo]", player, 255, 255, 255 )
		end
	end,
	true
)

addEventHandler( "onUnban", root,
	function( ban )
		if getBanReason( ban ) ~= "Maximos intentos de logueo." then -- that certainly qualifies as nice try.
			local ip = getBanIP( ban )
			if ip then
				outputDebugString( "La IP " .. ip .. " ha sido desbaneada por el sistema o algún administrador." )
				exports.sql:query_free( "UPDATE wcf1_user SET banned = 0 WHERE lastIP = '%s'", ip )
			end
			
			local serial = getBanIP( ban )
			if serial then
				outputDebugString( "La Serial " .. serial .. " Ha sido desbaneada por el sistema o algún administrador." )
				exports.sql:query_free( "UPDATE wcf1_user SET banned = 0 WHERE lastSerial = '%s'", serial )
			end
		end
	end
)

local function containsRank( t, s )
	for key, value in pairs( t ) do
		if value.displayName == s then
			return s
		end
	end
	return false
end
 
 

addCommandHandler( { "staff", "admins" },
	function( player, commandName, ... )
		if exports.players:isLoggedIn( player ) then
			local devs = {}
			outputChatBox( "Equipo Administrativo en línea: ", player, 0, 255, 255 )
			local count = 0
			for key, value in ipairs( getElementsByType( "player" ) ) do
				local groups = exports.players:getGroups( value )
				if groups and #groups >= 1 then
					local title = groups[1].displayName
					if title and title ~= "VIP" and title ~= "Encubierto" and title ~= "Desarrollador" and title ~= "Administrador" and not getElementData(value, "enc") and exports.players:isLoggedIn(value) then
						local duty = exports.players:getOption( value, "staffduty" )
						local pm = getElementData(value, "pm", true)
						outputChatBox( " [" .. exports.players:getID( value ) .. "] " .. title .. " ["..tostring(exports.players:getUserName(value)).."] " .. getPlayerName( value ):gsub( "_", " " ) .. ( duty and " - #00FF00De servicio" or " - Fuera de servicio" ) .. ( pm and " - #00FF00PM On" or " #FFFFFF- PM Off" ) , player, 255, 255, 255, true )
						count = count + 1
					else
						if title == "Desarrollador" or title == "Administrador" then
							table.insert(devs, value)
						end
					end
				end
			end
			
			if count == 0 then
				local count = 0
				for key, value in ipairs(devs) do
					local duty = exports.players:getOption( value, "staffduty" )
					local pm = getElementData(value, "pm", true)
					outputChatBox( " [" .. exports.players:getID( value ) .. "] Auxiliar ["..tostring(exports.players:getUserName(value)).."] " .. getPlayerName( value ):gsub( "_", " " ) .. ( duty and " - #00FF00De servicio" or " - Fuera de servicio" ) .. ( pm and " - #00FF00PM On" or " #FFFFFF- PM Off" ) , player, 255, 255, 255, true )
					count = count + 1
				end
				if count == 0 then
					outputChatBox( "  Nadie.", player, 117, 115, 0 )
					outputChatBox( "  Recuerda tomar fotos al F12 para reportar en el foro.", player, 255, 255, 0)
				else
					outputChatBox("Los Auxiliar no son staff, pero al no haber staff online, podrán actuar como tal.", player, 255, 255, 255)
				end
			end
		end
	end
)

function checkAlEntrar()
	setPedStat(source, 71, 900)
	setPedStat(source, 72, 900)
	setPedStat(source, 76, 900)
	setPedStat(source, 77, 900)
	setPedStat(source, 78, 900)
	setPlayerHudComponentVisible(source, "vehicle_name", false)
	setPlayerHudComponentVisible(source, "radio", false)
end
addEventHandler("onCharacterLogin", getRootElement(), checkAlEntrar)

addCommandHandler( { "staffduty", "adminduty", "modduty", "helperduty" },
	function( player, commandName )
		local old = exports.players:getOption( player, "staffduty" )
		if hasObjectPermissionTo(player, 'command.modchat', false) then
		if exports.players:setOption( player, "staffduty", old ~= true or nil ) then
			exports.players:updateNametag( player )
			local message = getPlayerName( player ):gsub( "_", " " ) .. " " .. ( old and "está ahora fuera" or "está ahora" ) .. " de servicio (" .. exports.players:getID( player ) .. ")."
			local groups = exports.players:getGroups( player )
			triggerEvent("onAvisarDudas", player, player)
			if groups and #groups >= 1 then
				message = groups[1].displayName .. " " .. message
			end
			if exports.players:getOption( player, "staffduty" ) == true then
				setElementData(player,"account:gmduty", true)
			else
				setElementData(player,"account:gmduty", false)
			end	
			for key, value in ipairs( getElementsByType( "player" ) ) do
				if value ~= player and groups[1].displayName ~= "Encubierto" and groups[1].displayName ~= "Desarrollador" and groups[1].displayName ~= "Administrador" then
					outputChatBox( message, value, old and 255 or 0, old and 191 or 255, 0 )
				end
			end
		end
		end
	end,
	true
)

-- addCommandHandler( "vip",
	-- function( player, commandName )
		-- local old = exports.players:getOption( player, "vip" )
		-- if hasObjectPermissionTo(player, 'command.vip', false) then
		-- if exports.players:setOption( player, "vip", old ~= true or false ) then
			-- exports.players:updateNametag( player )
		    -- if exports.players:getOption( player, "vip" ) == true then
			-- outputChatBox("Has #33cc33activado#ff00ff el color vip en el tabulador", player, 255, 0, 255,true)
			-- outputChatBox("Si necesitas soporte VIP presiona (F1) o usa /ayudavip.", player, 255, 255, 0)
		    -- outputDebugString( "El usuario " .. getPlayerName(player):gsub("_", " ") .. " se ha colocado el color VIP." )
			-- else
			-- outputChatBox("Has #ff3300desactivado#ff00ff el color vip en el tabulador", player, 255, 0, 255,true)
			-- outputChatBox("Si necesitas soporte VIP presiona (F1) o usa /ayudavip.", player, 255, 255, 0)
			-- outputDebugString( "El usuario " .. getPlayerName(player):gsub("_", " ") .. " se ha quitado el color VIP." )
			-- end	
		-- end
		-- end
	-- end,
	-- true
-- )

function obtenerDatos ( p, c, op )
   if hasObjectPermissionTo(p, 'command.kick', false) then
    local o, n = exports.players:getFromName ( p, op, true )
	local nivel = exports.players:getCharacterID(o)
	if o then
		if exports.players:isLoggedIn(o) then
			local sqlh = exports.sql:query_assoc_single("SELECT horas FROM characters WHERE characterID = " ..tostring(exports.players:getCharacterID(o)))
			outputChatBox("Nombre: "..tostring(n)..".Cuenta: "..tostring(exports.players:getUserName(o)).." . IP:"..tostring(getPlayerIP(o)).." . Nivel:"..tostring(exports.objetivos:getNivel(nivel))..".", p, 0, 255, 0)
			outputChatBox("Serial: "..tostring(getPlayerSerial(o))..".cID: "..tostring(exports.players:getCharacterID(o)).." . uID:"..tostring(exports.players:getUserID(o))..".", p, 0, 255, 0)
			outputChatBox("Horas jugadas (por personaje): "..tostring(sqlh.horas).." horas jugadas.", p, 0, 255, 0)
		else
			outputChatBox("Nombre: "..tostring(n)..".Serial: "..tostring(getPlayerSerial(o)).." . IP:"..tostring(getPlayerIP(o))..".", p, 0, 255, 0)
		end
	end
	end
end
addCommandHandler("datos", obtenerDatos)

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

function fecha( player, commandName, ... )
	if (...) then
		local nombre = table.concat( { ... }, " " )
		local f = exports.sql:query_assoc_single( "SELECT lastLogin FROM characters WHERE characterName = '%s'", nombre )
		if f then 
			outputChatBox(tostring(nombre).." se conectó la última vez el "..tostring(f.lastLogin), player, 0, 255, 0) 
		else
			outputChatBox("El nombre introducido es incorrecto o no existe.", player, 255, 0, 0)
			outputChatBox( "Syntax: /" .. commandName .. " [nombre del personaje a consultar sin la _]", player, 255, 255, 255 )
		end
	else
		outputChatBox( "Syntax: /" .. commandName .. " [nombre del personaje a consultar sin la _]", player, 255, 255, 255 )
	end
end 
addCommandHandler("fecha", fecha)
	
function cambiarClave(player, cmd, nuevapassword)
	if not player or not nuevapassword then outputChatBox("Syntax: /cambiarclave [nueva clave]", player, 255, 255, 255) return end
	if exports.players:isLoggedIn(player) then
		if exports.admin:setPassword(exports.players:getUserName(player), tostring(nuevapassword)) == true then
			outputChatBox("Tu nueva clave es "..tostring(nuevapassword)..".", player, 0, 255, 0)
		else
			outputChatBox("No se ha podido cambiar tu clave. Contacta con un staff.", player, 255, 0, 0)
		end
	end
end
addCommandHandler("cambiarclave", cambiarClave)

function consultaIdiomas(player)
	outputChatBox("~~Lista de idiomas~~", player, 255, 255, 0)
	idi = 0
	for k, v in ipairs(exports.players:getLanguages()) do
		if idi == 0 then
			mens = v[1] .. " - " .. v[2]
			idi = 1
		else
			outputChatBox(mens .. " - " .. v[1] .. " - " .. v[2], player, 0, 255, 0)
			idi = 0
		end
	end
end
addCommandHandler("idiomas", consultaIdiomas)
	
-- function darIdioma(player, cmd, otherPlayer, codigo)
	-- if player and hasObjectPermissionTo(player, "command.kick", false) then
		-- if not otherPlayer or not codigo then outputChatBox("Sintaxis: /daridioma [jugador] [código de idioma de 2 letras]", player, 255, 255, 255) return end
		-- local other, name = exports.players:getFromName(player, otherPlayer)
		-- if other then
			-- if exports.players:isValidLanguage(tostring(codigo)) and exports.players:learnLanguage(other, tostring(codigo)) then
				-- outputChatBox("Has dado correctamente a " .. name .. " el idioma código " .. tostring(codigo), player, 0, 255, 0 )
				-- outputChatBox("El staff " .. getPlayerName(player):gsub("_", " ") .. " te ha dado un idioma (Tecla L)", other, 0, 255, 0)
				-- exports.logs:addLogMessage("daridioma", "El staff " .. getPlayerName(player):gsub("_", " ") .. " ha dado a " .. name .. " el idioma código " .. tostring(codigo) )
			-- else
				-- outputChatBox("Se ha producido un error. Revisa que el código del idioma sea el correcto.", player, 255, 0, 0)
			-- end
		-- end
	-- else
		-- outputChatBox("(( Acceso denegado ))", player, 255, 0, 0)
	-- end
-- end
-- addCommandHandler("daridioma", darIdioma)