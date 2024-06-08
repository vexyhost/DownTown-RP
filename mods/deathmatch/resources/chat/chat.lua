--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

-- getPlayerName with spaces instead of _ for player names
local _getPlayerName = getPlayerName
local getPlayerName = function( x ) return _getPlayerName( x ):gsub( "_", " " ) end

-- addCommandHandler supporting arrays as command names (multiple commands with the same function)
local addCommandHandler_ = addCommandHandler
      addCommandHandler  = function( commandName, fn, restricted, caseSensitive )
	-- add the default command handlers
	if type( commandName ) ~= "table" then
		commandName = { commandName }
	end
	for key, value in ipairs( commandName ) do
		if key == 1 then
			addCommandHandler_( value, fn, restricted, caseSensitive )
		else
			addCommandHandler_( value,
				function( player, ... )
					-- check if he has permissions to execute the command, default is not restricted (aka if the command is restricted - will default to no permission; otherwise okay)
					if hasObjectPermissionTo( player, "command." .. commandName[ 1 ], not restricted ) or hasObjectPermissionTo( player, "command.kick", not restricted ) then
						fn( player, ... )
					end
				end
			)
		end
	end
end

-- returns all players within <range> units away <from>
local function getPlayersInRange( from, range )
	local x, y, z = getElementPosition( from )
	local dimension = getElementDimension( from )
	local interior = getElementInterior( from )
	
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if getElementDimension( value ) == dimension and getElementInterior( value ) == interior then
			local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( value ) )
			if distance < range then
				t[ value ] = distance
			end
		end
	end
	if getElementType( from ) == "player" then
		local vehicle = getPedOccupiedVehicle( from )
		if vehicle then
			local passengers = getVehicleMaxPassengers( vehicle )
			if type( passengers ) == 'number' then
				for seat = 0, passengers do
					local value = getVehicleOccupant( vehicle, seat )
					if value then
						t[ value ] = 0
					end
				end
			end
		end
	end
	return t
end

-- calculate chat colors based on distance
local function calculateColor( color, color2, distance, range )
	return color - math.floor( ( color - color2 ) * ( distance / range ) )
end

local function calculateColors( r, r2, g, g2, b, b2, distance, range )
	if range <= 0 then
		range = 0.01
	end
	return calculateColor( r, r2, distance, range ), calculateColor( g, g2, distance, range ), calculateColor( b, b2, distance, range )
end

-- sends a ranged message
local function localMessage( from, message, r, g, b, range, r2, g2, b2 )
	range = range or 20
	r2 = r2 or r
	g2 = g2 or g
	b2 = b2 or b
	
	for player, distance in pairs( getPlayersInRange( from, range ) ) do
		local c1, c2, c3 = calculateColors( r, r2, g, g2, b, b2, distance, range )
		outputChatBox( message, player, c1, c2, c3 )
		for k, v in ipairs(getElementsByType("player")) do
			if getElementData(v, "inSpec") and tostring(getElementData(v, "inSpec")) == tostring(getPlayerName(player)) then
				outputChatBox( message, v, c1, c2, c3 )
			end
		end
	end
end

function localizedMessage( from, prefix, message, r, g, b, range, r2, g2, b2 )
	if type( range ) == 'table' then
		r2 = r
		g2 = g
		b2 = b
	else
		range = range or 20
		r2 = r2 or r
		g2 = g2 or g
		b2 = b2 or b
	end
	
	local language = exports.players:getCurrentLanguage( from )
	local skill = exports.players:getLanguageSkill( from, language )
	if language and skill then
		if #message >= 4 and message:sub( 1, 1 ) == "#" and exports.players:isValidLanguage( message:sub( 2, 3 ) ) and message:sub( 4, 4 ) == " " then
			language = message:sub( 2, 3 )
			skill = exports.players:getLanguageSkill( from, language )
			if not skill then
				outputChatBox( "(( Tu no hablas " .. exports.players:getLanguageName( language ) .. ". ))", from, 255, 0, 0 )
				return
			else
				-- it's a language the player speaks!
				message = message:sub( 5 )
			end
		end
		prefix = " [" .. exports.players:getLanguageName( language ) .. "]" .. prefix
		if not isPedInVehicle(from) and not getElementData(from, "anim") == true and not getElementData(from, "sentado") and not getElementData(from, "muerto") and not (getElementData(from, "sexbot")) then
			setPedAnimation( from, "gangs", "prtial_gngtlkb", #message*500, false)
		end
		for player, distance in pairs( type( range ) == "table" and range or getPlayersInRange( from, range ) ) do
			if type( range ) == "table" then
				player = distance
				distance = 0
			end
			local new = message
			if from ~= player then
				-- check how much the player should understand
				local playerSkill = exports.players:getLanguageSkill( player, language )
				if not playerSkill then
					playerSkill = 0
				else
					if playerSkill < 1000 then
						-- increase skill - long messages give more skill!
						if math.random( math.max( 1, math.ceil( playerSkill * 30 / #message ) ) ) == 1 then
							if exports.players:increaseLanguageSkill( player, language ) then
								playerSkill = playerSkill + 1
							end
						end
					end
					playerSkill = math.floor( ( 2 * playerSkill + skill ) / 3 ) 
				end
				if getElementData( player, "account:gmduty" ) then
					playerSkill = 1000
				end
				-- make a part not understandable
				local scramble = #message - math.floor( #message * playerSkill / 875 ) -- a bit tolerancy - max is 1000 actually, but we want people with pretty good languages to understand us fully
				if scramble > 0 then
					new = ""
					for i = 1, scramble do
						local char = message:sub( i, i )
						if char >= "a" and char <= "z" then
							new = new .. string.char( math.random( string.byte( "a" ), string.byte( "z" ) ) )
						elseif char >= "A" and char <= "Z" then
							new = new .. string.char( math.random( string.byte( "A" ), string.byte( "Z" ) ) )
						else
							new = new .. char
						end
					end
					
					new = new .. message:sub( scramble + 1 )
				end
			end
			outputChatBox( prefix .. new, player, calculateColors( r, r2, g, g2, b, b2, distance, type( range ) == "table" and 1 or range ) )
			for k, v in ipairs(getElementsByType("player")) do
				if getElementData(v, "inSpec") and tostring(getElementData(v, "inSpec")) == tostring(getPlayerName(player)) then
					outputChatBox( prefix .. new, v, calculateColors( r, r2, g, g2, b, b2, distance, type( range ) == "table" and 1 or range ) )
				end
			end
		end
	else 
		outputChatBox( "(( Presiona 'L' para seleccionar un idioma. ))", from, 255, 0, 0 )
	end
end

-- función exportada para enviar ame's.
function ame (source, causante, ...)
		if source and ... and causante then
			local message = table.concat( { ... }, " " )
			if #message > 0 then
				localMessage( source, " *" .. message .. " ((" .. causante .. "))", 255, 255, 0 )
				return true
			else
			   return false
			end
		end
	end
addEvent("onAme", true)
addEventHandler("onAme", getRootElement(), ame)

-- función exportada para enviar me's
function me( source, message, prefix )
	if isElement( source ) and getElementType( source ) == "player" and type( message ) == "string" then
		if prefix then
			local message = prefix .. " " .. getPlayerName( source ) .. " " .. message
			localMessage( source, message, 255, 40, 80 )	
		else
			local message = getPlayerName( source ) .. " " .. message
			localMessage( source, message, 255, 40, 80 )	
		end	
		return true
	else
		return false
	end
end
 
-- faction chat
local function faction( player, factionID, message )
	if factionID then
		if message:sub(0, 2) == "//" or message:sub(0, 2) == "((" or message:sub(0, 2) == "./" or message:sub(0, 1) == "/" or message:sub(0, 2) == "OO" then outputChatBox("Te recordamos que NO está permitido hablar OOC mediante la radio IC.", player, 255, 0, 0) return end
		localizedMessage( player, " " .. getPlayerName( player ) .. " dice por su radio: ", message, 230, 230, 230, false, 127, 127, 127 )
		local tag = exports.factions:getFactionTag( factionID )
		exports.factions:sendMessageToFaction( factionID, "(( Radio: " .. tag .. " )) " .. getPlayerName( player ) .. ": " .. message, 127, 127, 255 )
	end
end

-- overwrite MTA's default chat events
addEventHandler( "onPlayerChat", getRootElement( ),
	function( message, type )
		cancelEvent( )	
		if exports.players:isLoggedIn( source ) and not isPedDead( source ) and not getElementData(source, "nogui") == true then
			if type == 0 then
				local pletra = string.upper(string.sub(message, 1, 1))
				local resto = string.sub(message, 2)
				local mensaje = tostring(pletra..resto)
				localizedMessage( source, " " .. getPlayerName( source ) .. " dice: ", mensaje, 230, 230, 230, false, 127, 127, 127 )
				exports.objetivos:addObjetivo(6, exports.players:getCharacterID(source), source)
			elseif type == 1 then
				me( source, message )
			elseif type == 2 then
				local pletra = string.upper(string.sub(message, 1, 1))
				local resto = string.sub(message, 2)
				local mensaje = tostring(pletra..resto)
				faction( source, exports.factions:getPlayerFactions( source )[ 1 ], mensaje )
			end
		end
	end
)

for i = 1, 10 do
	addCommandHandler( "f" .. ( i > 1 and i or "" ),
		function( thePlayer, commandName, ... )
			if exports.players:isLoggedIn( thePlayer ) then
				local factionID = exports.factions:getPlayerFactions( thePlayer )[ i ]
				if factionID then
					local message = table.concat( { ... }, " " )
					if #message > 0 then
						faction( thePlayer, factionID, message )
					else
						outputChatBox( "Syntax: /" .. commandName .. " [facción IC]", thePlayer, 255, 255, 255 )
					end
				end
			end
		end
	)
end

-- /do
addCommandHandler( "do", 
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			local message = table.concat( { ... }, " " )
			if #message > 0 then
				local pletra = string.upper(string.sub(message, 1, 1))
				local resto = string.sub(message, 2)
				local mensaje = tostring(pletra..resto)
				localMessage( thePlayer, " *" .. mensaje .. " ((" .. getPlayerName( thePlayer ) .. "))", 255, 255, 0 )
			else
				outputChatBox( "Syntax: /" .. commandName .. " [Entorno IC]", thePlayer, 255, 255, 255 )
			end
		end
	end
)

-- /susurrar
addCommandHandler( { "susurrar" }, 
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) and not isPedDead( thePlayer ) then
			local message = table.concat( { ... }, " " )
			if #message > 0 then
				local pletra = string.upper(string.sub(message, 1, 1))
				local resto = string.sub(message, 2)
				local mensaje = tostring(pletra..resto)
				localizedMessage( thePlayer, " " .. getPlayerName( thePlayer ) .. " susurra: ", mensaje, 255, 255, 255, 6 )
			else
				outputChatBox( "Syntax: /" .. commandName .. " [Susurro IC]", thePlayer, 255, 255, 255 )
			end
		end
	end
)

-- /gritar
addCommandHandler( { "gritar" }, 
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) and not isPedDead( thePlayer ) then
			local message = table.concat( { ... }, " " )
			if #message > 0 then
				local pletra = string.upper(string.sub(message, 1, 1))
				local resto = string.sub(message, 2)
				local mensaje = tostring(pletra..resto)
				localizedMessage( thePlayer, " " .. getPlayerName( thePlayer ) .. " grita: ", mensaje .. ( mensaje:sub( #mensaje ) ~= "." and mensaje:sub( #mensaje ) ~= "!" and mensaje:sub( #mensaje ) ~= "?" and "!" or "" ), 255, 255, 255, 40 )
			else
				outputChatBox( "Syntax: /" .. commandName .. " [texto ic]", thePlayer, 255, 255, 255 )
			end
		end
	end
)

-- /megafono
addCommandHandler( { "meg", "megafono" }, 
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) and not isPedDead( thePlayer ) then
			if exports.factions:isPlayerInFaction ( thePlayer, 1) or exports.factions:isPlayerInFaction ( thePlayer, 2) then 
				local message = table.concat( { ... }, " " )
				if #message > 0 and not getElementData(thePlayer, "nogui") == true then
					local pletra = string.upper(string.sub(message, 1, 1))
					local resto = string.sub(message, 2)
					local mensaje = tostring(pletra..resto)
					localizedMessage( thePlayer, " [" .. getPlayerName( thePlayer ) .. "] [Megáfono]: ", mensaje .. ( mensaje:sub( #mensaje ) ~= "." and mensaje:sub( #mensaje ) ~= "!" and mensaje:sub( #mensaje ) ~= "?" and "!" or "" ), 255, 255, 0, 130 )
				end
			end
		end
	end
)

-- /b; bound to 'b' client-side
addCommandHandler( { "b", "LocalOOC" },
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) and not isPedDead( thePlayer ) then
			local message = table.concat( { ... }, " " )
			if #message > 0 and not getElementData(thePlayer, "nogui") == true then
				if getElementData(thePlayer, "nOOC") and not hasObjectPermissionTo( thePlayer, "command.modchat", false )  then
					outputChatBox("Sólo se permite un mensaje cada 3 segundos.", thePlayer, 255, 0, 0)
				elseif getElementData(thePlayer, "qOOC") then
					outputChatBox("Un staff te ha retirado el uso del /b. Reconectando lo tendrás de nuevo.", thePlayer, 255, 0, 0)
				else
					if getElementData(thePlayer, "account:gmduty") == true then
						localMessage( thePlayer, "[STAFF - OOC - " .. exports.players:getID( thePlayer ) .. "] " .. getPlayerName( thePlayer ) ..  ": (( " .. message .. " ))", 196, 255, 255 )
					else
						localMessage( thePlayer, "[OOC - " .. exports.players:getID( thePlayer ) .. "] " .. getPlayerName( thePlayer ) ..  ": (( " .. message .. " ))", 196, 255, 255 )
						setElementData( thePlayer, "nOOC", true )
						setTimer( removeElementData, 3000, 1, thePlayer, "nOOC" )
						exports.objetivos:addObjetivo(7, exports.players:getCharacterID(thePlayer), thePlayer)
					end
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " [Canal OOC]", thePlayer, 255, 255, 255 )
			end
		end
	end
)

function sendLocalOOC( player, text )
	if player and text then
		localMessage( player, text, 196, 255, 255 )
	end
end

-- /o; bound to 'o' client-side
addCommandHandler( { "o", "GlobalOOC" },
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			if getElementData( root, "ooc" ) == 1 or hasObjectPermissionTo( thePlayer, "command.toggleooc", false ) then
				local message = table.concat( { ... }, " " )
				if #message > 0 and not getElementData(thePlayer, "nogui") == true then
					for k, v in ipairs(getElementsByType("player")) do
						--if hasObjectPermissionTo( v, "command.modchat", false ) then
							outputChatBox( "[STAFF - OOC GLOBAL] ((" .. getPlayerName( thePlayer ) ..  ")) " .. message .. " ", v, 3, 255, 104 )
						--else
							--outputChatBox( "[Administración] " .. message .. " ", v, 3, 255, 104 )
						--end
					end
				else
					outputChatBox( "Syntax: /" .. commandName .. " [Canal OOC]", thePlayer, 255, 255, 255 )
				end
			else
				outputChatBox( "El Global OOC está deshabilitado.", thePlayer, 255, 0, 0 )
			end
		end
	end
)

-- /w; bound to 'WalkieTalkie' client-side
addCommandHandler( { "w", "WalkieTalkie" },
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			if getElementData(thePlayer, "jailed") then outputChatBox("No puedes usar el Walkie en este momento.", thePlayer, 255, 0, 0) return end
			local has, key, item = exports.items:has( thePlayer, 32 )
			if has then
				local frec = item.value
				if frec == 0 then outputChatBox("Necesitas elegir una frecuencia con /cambiarfrecuencia [1-9999]", thePlayer, 255, 0, 0) return end
				local message = table.concat( { ... }, " " )
				if #message > 0 and not getElementData(thePlayer, "nogui") == true then
					for k, v in ipairs (getElementsByType("player")) do
						local has2, key2, item2 = exports.items:has( v, 32 )
						if (has2 and item2.value == frec) or hasObjectPermissionTo(v, "command.encubierto", false) then
							local pletra = string.upper(string.sub(message, 1, 1))
							local resto = string.sub(message, 2)
							local mensaje = tostring(pletra..resto)
							outputChatBox( "(Walkie-Talkie.F"..tostring(frec)..") " .. getPlayerName( thePlayer ) ..  ": " .. mensaje, v, 7, 232, 176 )
						end
					end
					local pletra = string.upper(string.sub(message, 1, 1))
					local resto = string.sub(message, 2)
					local mensaje = tostring(pletra..resto)
					localizedMessage( thePlayer, " " .. getPlayerName( thePlayer ) .. " dice por su walkie: ", mensaje, 230, 230, 230, false, 127, 127, 127 )
				else
					outputChatBox( "Syntax: /" .. commandName .. " [local ic text]", thePlayer, 255, 255, 255 )
				end
			else
				outputChatBox( "No tienes un Walkie-Talkie.", thePlayer, 255, 0, 0 )
			end
		end
	end
)

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		setElementData( root, "ooc", 0, false )
	end
)

-- /announce
addCommandHandler( { "announce", "ann" },
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			local message = table.concat( { ... }, " " )
			if #message > 0 then
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if hasObjectPermissionTo( value, "command.announce", false ) then
						outputChatBox( "*** " .. getPlayerName( thePlayer ):gsub( "_", " " ) .. ": " .. message .. " ***", value, 0, 255, 153 )
					elseif not silent then
						outputChatBox( "*** " .. message .. " ***", value, 0, 255, 153 )
					end
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " [text]", thePlayer, 255, 255, 255 )
			end
		end
	end,
	true
)

-- /a
addCommandHandler( { "adminchat", "a" },
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) and hasObjectPermissionTo( thePlayer, "command.adminchat", false ) then
			local message = table.concat( { ... }, " " )
			if #message > 0 and not getElementData(thePlayer, "nogui") == true then
				message = getPlayerName( thePlayer ) .. ": " .. message
				local groups = exports.players:getGroups( thePlayer )
				if groups and #groups >= 1 then
					message = "[#05A6EEAdminchat#97C8AD] "..groups[1].displayName .. " " .. message
				end
				
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if hasObjectPermissionTo( value, "command.adminchat", false ) then
						outputChatBox( message, value, 151,200,173 ,true )
					end
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " [Mensaje]", thePlayer, 255, 255, 255 )
			end
		end
	end,
	true
)

-- /m
addCommandHandler( { "modchat", "m" },
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			local message = table.concat( { ... }, " " )
			if #message > 0 and not getElementData(thePlayer, "nogui") == true then
				message = getPlayerName( thePlayer ) .. ": " .. message
				local groups = exports.players:getGroups( thePlayer )
				if groups and #groups >= 1 then
					message = "[#05A6EEModchat#CDF213] "..groups[1].displayName .. " " .. message
				end
				if getElementData(thePlayer, "modchat") == true then setElementData(thePlayer, "modchat", false) outputChatBox("Se te ha activado automáticamente el Modchat por usarlo.", thePlayer, 0, 255, 0) end
				if hasObjectPermissionTo( thePlayer, "command.encubierto", false ) and not getElementData(thePlayer, "account:gmduty") == true then outputChatBox("Seguridad de Encubierto. Debes de estar en duty para utilizar Modchat o usar /md.", thePlayer, 255, 255, 0) return end
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if hasObjectPermissionTo( value, "command.modchat", false ) and not getElementData(value, "modchat") == true then
						outputChatBox( message, value, 205, 242, 19,true )
					end
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " [Mensaje]", thePlayer, 255, 255, 255 )
			end
		end
	end,
	true
)

addCommandHandler( "md",
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			local message = table.concat( { ... }, " " )
			if #message > 0 and not getElementData(thePlayer, "nogui") == true then
				message = getPlayerName( thePlayer ) .. ": " .. message
				local groups = exports.players:getGroups( thePlayer )
				if groups and #groups >= 1 then
					message = groups[1].displayName .. " " .. message
				end
				if getElementData(thePlayer, "modchat") == true then setElementData(thePlayer, "modchat", false) outputChatBox("Se te ha activado automáticamente el Modchat por usarlo.", thePlayer, 0, 255, 0) end
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if hasObjectPermissionTo( value, "command.modchat", false ) and not getElementData(value, "modchat") == true then
						outputChatBox( message, value, 255, 255, 191 )
					end
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " [text]", thePlayer, 255, 255, 255 )
			end
		end
	end,
	true
)

-- /d for department radio
addCommandHandler( { "department", "d", "dept" },
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			if exports.factions:isPlayerInFactionType( thePlayer, 1 ) then		
				local message = table.concat( { ... }, " " )
				if #message > 0 then
					local players = { }
					for key, value in ipairs( getElementsByType( "player" ) ) do
						if exports.factions:isPlayerInFactionType( value, 1 ) then
							table.insert( players, value )
						end
					end
					local pletra = string.upper(string.sub(message, 1, 1))
					local resto = string.sub(message, 2)
					local mensaje = tostring(pletra..resto)
					localizedMessage( thePlayer, " [DEPARTMENTO] " .. getPlayerName( thePlayer ) ..  " dice: ", mensaje, 244, 155, 66, players )
					localizedMessage( thePlayer, " " .. getPlayerName( thePlayer ) .. " dice por su radio: ", mensaje, 230, 230, 230, false, 127, 127, 127 )
				else
					outputChatBox( "Syntax: /" .. commandName .. " [departamento]", thePlayer, 255, 255, 255 )
				end
			end
		end
	end
)

-- /pm to message other players
local function pm( player, target, message, enc )
    outputChatBox( "[Mensaje enviado - ID:" .. exports.players:getID( target ) .. "] " .. getPlayerName( target ) .. ": " .. message, player, 197, 225, 7,true )
    if getElementData(target, "minpa") then
		triggerClientEvent(target, "onSendNotification", target, getPlayerName(player).." te ha enviado un PM en DownTown. ¡Vuelve para leerlo!")
	end
	if enc then
		outputChatBox( "PM de Desconocido: " .. message, target, 0, 255, 255 )
	else
		outputChatBox( "[Mensaje recibido - ID:" .. exports.players:getID( player ) .. "] " .. getPlayerName( player ) .. ": " .. message, target, 1, 243, 255,true )
	end
end
 
function sendMP( thePlayer, commandName, otherPlayer, ... )
    if exports.players:isLoggedIn( thePlayer ) then
        if otherPlayer and ( ... ) then
            local message = table.concat( { ... }, " " )
            local other, name = exports.players:getFromName( thePlayer, otherPlayer )
            if other then
				if not hasObjectPermissionTo( thePlayer, "command.modchat", false ) and not hasObjectPermissionTo( other, "command.modchat", false ) then
					outputChatBox("Sólo puedes enviar PM a staff (/staff)", thePlayer, 255, 0, 0)
					return
				end
				if getElementData(thePlayer, "mutepm") == true then outputChatBox("Tus PM's están desactivados por un staff.", thePlayer, 255, 0, 0) return end
				if getElementData( other, "pm" ) == true or hasObjectPermissionTo( thePlayer, "command.modchat", false ) then
					if not getElementData(thePlayer, "pm") == true then
						outputChatBox("Para enviar PM's tienes primero que activarlos.", thePlayer, 255, 0, 0)
					else
						local pletra = string.upper(string.sub(message, 1, 1))
						local resto = string.sub(message, 2)
						local mensaje = tostring(pletra..resto)
						pm( thePlayer, other, mensaje )
						exports.objetivos:addObjetivo(5, exports.players:getCharacterID(thePlayer), thePlayer)
					end
				else
					outputChatBox( "Este usuario tiene los PM's deshabilitados.", thePlayer, 255, 0, 0 )
				end
			end
        else
            outputChatBox( "Syntax: /" .. commandName .. " [player] [texto ooc]", thePlayer, 255, 255, 255 )
        end
    end
end
addCommandHandler("pm", sendMP)
addCommandHandler("mp", sendMP)
 
addEventHandler( "onPlayerPrivateMessage", root,
    function( message, recipent )
        if exports.players:isLoggedIn( thePlayer ) and exports.players:isLoggedIn( recipent ) then
                pm( source, recipent, message )
        end
        cancelEvent( )
    end
)
 
function togglePM (player)
    if exports.players:isLoggedIn(player) then
        if not getElementData( player, "pm" ) then
			setElementData( player, "pm", true)
			outputChatBox( "Has activado la recepción de PM.", player, 0, 255, 0 )
		else
			removeElementData( player, "pm" )
			outputChatBox( "Has desactivado la recepción de PM.", player, 255, 0, 0 )
		end
    else
        outputChatBox( "No has iniciado sesión.", player, 255, 0, 0 )
    end
end
addCommandHandler( "togglepm", togglePM )

function toggleRadio (player)
	if getElementData( player, "radio" ) or getElementData( player, "radio" ) == true then
		setElementData( player, "radio", false )
		outputChatBox( "Has encendido la retransmisión de la radio.", player, 0, 255, 0 )
	else
		setElementData( player, "radio", true )
		outputChatBox( "Has apagado la retransmisión de la radio.", player, 255, 0, 0 )
	end
end
addCommandHandler( "toggleradio", toggleRadio )

function forzarModchat (player)
    if hasObjectPermissionTo( player, "command.modchat", false ) then
        for key, value in ipairs( getElementsByType( "player" ) ) do
			if hasObjectPermissionTo( value, "command.modchat", false ) and getElementData(value, "modchat") == false then
				outputChatBox( getPlayerName(player):gsub("_", " ").." ha forzado la activación del Modchat.", value, 255, 255, 0 )
				setElementData(value, "modchat", true)
			end
		end
		outputChatBox("Has forzado la activación del Modchat a todos los staff.", player, 0, 255, 0)
    else
        outputChatBox( "No eres staff.", player, 255, 0, 0 )
    end
end
addCommandHandler( "forzarmodchat", forzarModchat )

function toggleModchat (player)
    if hasObjectPermissionTo( player, "command.modchat", false ) then
        if not getElementData( player, "modchat" ) == true then
			setElementData( player, "modchat", true )
			outputChatBox( "Has desactivado la recepción de mensajes de Modchat", player, 255, 0, 0 )	
		else
			setElementData( player, "modchat", false)
			outputChatBox( "Has activado la recepción de mensajes de Modchat", player, 0, 255, 0 )
		end
    else
        outputChatBox( "No eres staff.", player, 255, 0, 0 )
    end
end
addCommandHandler( "togglemodchat", toggleModchat )

function mutePM (player, cmd, otherPlayer)
    if hasObjectPermissionTo( player, "command.modchat", false ) then
		 local other, name = exports.players:getFromName( thePlayer, otherPlayer )
        if not getElementData( other, "mutepm" ) == true then
			setElementData( other, "mutepm", true )
			outputChatBox( "Has desactivado los PM's a "..name..".", player, 0, 255, 0 )
			outputChatBox( "El staff "..getPlayerName(player):gsub("_", " ").." te ha desactivado los PM's.", other, 255, 0, 0 )
		else
			removeElementData(other, "mutepm")
			outputChatBox( "Has activado los PM's a "..name..".", player, 0, 255, 0 )
			outputChatBox( "El staff "..getPlayerName(player):gsub("_", " ").." te ha activado los PM's.", other, 255, 0, 0 )
		end
    else
        outputChatBox( "No eres staff.", player, 255, 0, 0 )
    end
end
addCommandHandler( "mutepm", mutePM )

addEventHandler( "onPlayerPrivateMessage", root,
	function( message, recipent )
		if exports.players:isLoggedIn( thePlayer ) and exports.players:isLoggedIn( recipent ) then
			pm( source, recipent, message )
		end
		cancelEvent( )
	end
)


-- /tirarmoneda - /moneda
function monedaloca( thePlayer, commandName )
	if exports.players:isLoggedIn( thePlayer ) and not isPedDead( thePlayer ) then
		if exports.players:getMoney( thePlayer ) >= 1 then
			me( thePlayer, "tira una moneda y cae en " .. ( math.random( 2 ) == 1 and "cara" or "cruz" ) .. ".", "(Moneda)" )
		else
			outputChatBox( "No tienes una moneda (( No tienes 1$)).", thePlayer, 255, 0, 0 )
		end
	end
end

addCommandHandler( "moneda", monedaloca )
addCommandHandler( "tirarmoneda", monedaloca )


-- /intentar
addCommandHandler( "intentar", 
	function( thePlayer, commandName, ... )
	if ( ... ) then
	 local text = table.concat( { ... }, " " )
		if exports.players:isLoggedIn( thePlayer ) and not isPedDead( thePlayer ) then
			me( thePlayer, "intenta " .. text .. " y " .. ( math.random( 2 ) == 1 and "no consigue hacerlo." or "consigue hacerlo." ) .. "", "(/intentar)" )
		else
			outputChatBox( "No has iniciado sesión, o estás muerto.", thePlayer, 255, 0, 0 )
		end
	end
 end
)

-- /tirardado - /dado

function tirarDado( thePlayer, commandName )
	if exports.players:isLoggedIn( thePlayer ) and not isPedDead( thePlayer ) then
		me( thePlayer, "tira un dado y sale " .. math.random( 6 ) .. ".", "(/tirardado - /dado)" )
	end
end
	
addCommandHandler( "dado", tirarDado )
addCommandHandler( "tirardado", tirarDado )


-- /ad to send a global advertisement
addCommandHandler("ad",
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			if exports.objetivos:getNivel(exports.players:getCharacterID(thePlayer)) < 2 then outputChatBox("Necesitas nivel 2 para enviar un anuncio (ad). Usa /objetivos.", thePlayer, 255, 0, 0) return end
			local message = table.concat( { ... }, " " )
			if #message > 0 and not getElementData(thePlayer, "nogui") == true then
				if getElementDimension(thePlayer) ~= 6 then outputChatBox("(( Debes de ir a una radio o enviar un SMS al 444 con el anuncio. ))", thePlayer, 255, 0, 0) return end
				if #message > 150 then outputChatBox("Anuncio no permitido, máximo 150 carácteres.", thePlayer, 255, 0, 0) return end
				if getElementData(thePlayer, "tjail") and getElementData(thePlayer, "tjail") >= 1 then outputChatBox("No puedes mandar un AD desde jail!", thePlayer, 255, 0, 0) return end
				if exports.players:takeMoney( thePlayer, 20 ) then
				exports.factions:giveFactionPresupuesto( 4, 60 )
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if hasObjectPermissionTo( value, "command.modchat", false ) then
						outputChatBox( "[Anuncio PCND] ((["..getPlayerName(thePlayer):gsub("_"," ").."])) " .. message, value, 106, 255, 255 )
					else
						outputChatBox( "[Anuncio PCND] " .. message .. ".", value, 106, 255, 255 )
					end				
				end
					local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(thePlayer))
					if nivel == 2 and not exports.objetivos:isObjetivoCompletado(13, exports.players:getCharacterID(thePlayer)) then
						exports.objetivos:addObjetivo(13, exports.players:getCharacterID(thePlayer), thePlayer)
					end
					outputChatBox( "Se te ha cobrado 20 dólares por el envío del anuncio.", thePlayer, 0, 255, 0 )
					exports.logs:addLogMessage("anuncio", getPlayerName(thePlayer).." ha puesto un AD que dice: "..message.." .\n")
				else
					outputChatBox( "No tienes dinero suficiente para enviar un anuncio. Cuesta 20 dólares.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " [anuncio]", thePlayer, 255, 255, 255 )
			end
		end
	end
)

-- /sr SAN radio chat
addCommandHandler("n",
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
			if exports.factions:isPlayerInFaction( thePlayer, 4 ) then
				local message = table.concat( { ... }, " " )
				if #message > 0 and not getElementData(thePlayer, "nogui") == true then
					exports.factions:giveFactionPresupuesto( 4, 10 )
					for k, v in ipairs(getElementsByType("player")) do
						if not getElementData(v, "radio") or getElementData(v, "radio") ~= true then
							outputChatBox("[Inglés] [PCND] "..getPlayerName(thePlayer):gsub("_", " ").." dice: "..tostring(message), v, 62, 184, 255)
						end
					end
				else
					outputChatBox( "Syntax: /" .. commandName .. " [mensaje de radio]", thePlayer, 255, 255, 255 )
				end
			else
				outputChatBox( "(( No estás en la facción de noticias. ))", thePlayer, 255, 0, 0 )
			end
		end
	end
)	
	
addCommandHandler("entrevista",
function(player, cmd, other)
	if not other then outputChatBox("Sintaxis: /entrevista [jugador]", player, 255, 255, 255) return end
	if exports.factions:isPlayerInFaction( player, 4 ) then
		if exports.factions:isPlayerInFaction(player, 4) then
			fID = 4
		end
		local player2, name = exports.players:getFromName( player, other )
		if player2 then
		local entrevistado = getElementData( player2, "entrevistado" )
			if not entrevistado == true then
				outputChatBox("Pon /entrevista [id] para finalizar la entrevista", player, 0, 255, 0)
				setElementData ( player2, "entrevistado", true )
				outputChatBox("Estas siendo entrevistado. Usa /en texto para hablar", player2, 0, 255, 0)
				outputChatBox("Estas entrevistando a: ".. name , player, 0, 255, 0)
				setElementData(player2, "frID", tonumber(fID))
			else
				removeElementData ( player2, "entrevistado" )
				outputChatBox("Ya no estas en la entrevista", player2, 255, 0, 0)
				outputChatBox("Dejaste de entrevistar a: ".. name , player, 255, 0, 0)
				removeElementData(player2, "frID")
			end
		end
	end
end
)
   
addCommandHandler("en",
	function( thePlayer, commandName, ... )
		if exports.players:isLoggedIn( thePlayer ) then
              if getElementData( thePlayer, "entrevistado" ) == true then
				local message = table.concat( { ... }, " " )
				if #message > 0 then
					exports.factions:giveFactionPresupuesto( tonumber(getElementData(thePlayer, "frID")), 50 )
					for k, v in ipairs(getElementsByType("player")) do
						if not getElementData(v, "radio") or getElementData(v, "radio") ~= true then
							outputChatBox("[Entrevistado] [Inglés] [PCND] "..getPlayerName(thePlayer):gsub("_", " ").." dice: "..tostring(message), v, 113, 237, 31)
						end
					end
				else
					outputChatBox( "Syntax: /" .. commandName .. " [mensaje por entrevista]", thePlayer, 255, 255, 255 )
				end
			else
				outputChatBox( "(( No estás siendo entrevistado. ))", thePlayer, 255, 0, 0 )
			end
		end
	end
)

addCommandHandler("camara",
function(player)
	if exports.factions:isPlayerInFaction(player, 4) then
		if exports.players:takeMoney(player, 150) then
			giveWeapon(player, 43, 100)
			exports.factions:giveFactionPresupuesto(4, 100)
			outputChatBox("Has cogido una cámara para poder hacer un máximo de 100 fotos.", player, 0, 255, 0)
		else
			outputChatBox("No tienes 200 dólares para comprar la cámara.", player, 255, 0, 0)
		end	
	else
		outputChatBox("No perteneces a la facción de PCND.", player, 255, 0, 0)
	end
end
)

-- /toggleooc
addCommandHandler( { "toggleooc", "disableooc", "enableooc", "togooc" },
	function( player, commandName, silent )
		silent = silent == "silent"
		if getElementData( root, "ooc" ) == 0 then
			if commandName == "disableooc" then
				outputChatBox( "El Global OOC ya esta deshabilitado.", player, 255, 0, 0 )
			else
				setElementData( root, "ooc", 1, false )
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if hasObjectPermissionTo( value, "command.toggleooc", false ) then
						outputChatBox( "[Administración]: " .. getPlayerName( player ):gsub( "_", " " ) .. " ha habilitado el Global OOC.", value, 0, 255, 153)
					elseif not silent then
						outputChatBox( "[Administración]: Global OOC desactivado.", value, 0, 255, 153)
					end
				end
			end
		else
			if commandName == "enableooc" then
				outputChatBox( "Global OOC está activado.", player, 255, 0, 0 )
			else
				setElementData( root, "ooc", 0, false )
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if hasObjectPermissionTo( value, "command.toggleooc", false ) then
						outputChatBox( "[Administración]: " .. getPlayerName( player ):gsub( "_", " " ) .. " ha deshabilitado el Global OOC.", value, 0, 255, 153)
					elseif not silent then
						outputChatBox( "[Administración]: Global OOC desactivado.", value, 0, 255, 153)
					end
				end
			end
		end
	end,
	true
)