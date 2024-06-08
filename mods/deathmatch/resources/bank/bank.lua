--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2016 DownTown County Roleplay

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
local banks = { }
local blips = { }

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
					if hasObjectPermissionTo( player, "command." .. commandName[ 1 ], not restricted ) then
						fn( player, ... )
					end
				end
			)
		end
	end
end

local function loadBank( id, x, y, z, rotation, interior, dimension, skin )
	local bank = nil
	if skin == -1 then
		bank = createObject( 2942, x, y, z, 0, 0, rotation )
	else
		bank = createPed( skin, x, y, z, 0, false )
		setPedRotation( bank, rotation )		
		if dimension > 0 and not blips[ dimension ] then
			if getResourceState( getResourceFromName( "interiors" ) ) == "running" then
				local int = exports.interiors:getInterior( dimension )
				if int then
					if getElementDimension( int.outside ) == 0 then
						local x, y, z = getElementPosition( int.outside )
						blips[ dimension ] = createBlip( x, y, z, 52, 2, 255, 255, 255, 255, 0, 50 )
					end
				end
			end
		end
	end
	
	setElementInterior( bank, interior )
	setElementDimension( bank, dimension )
	
	banks[ id ] = { bank = bank }
	banks[ bank ] = id
end

addEventHandler( "onPedWasted", resourceRoot,
	function( )
		local bankID = banks[ source ]
		if bankID then
			local x, y, z = getElementPosition( source )
			bank = createPed( 211, x, y, z, 0, false )
			setPedRotation( bank, getPedRotation( source ) )
			
			setElementInterior( bank, getElementInterior( source ) )
			setElementDimension( bank, getElementDimension( source ) )
			
			banks[ bank ] = bankID
			banks[ bankID ].bank = bank
			
			banks[ source ] = nil
			destroyElement( source )
		end
	end
)

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM banks ORDER BY bankID ASC" )
		if result then
			for key, value in ipairs( result ) do
				loadBank( value.bankID, value.x, value.y, value.z, value.rotation, value.interior, value.dimension, value.skin )
			end
		end
	end
)

addCommandHandler( "createatm",
	function( player )
		local x, y, z = getElementPosition( player )
		z = z - 0.35
		local rotation = ( getPedRotation( player ) + 180 ) % 360
		local interior = getElementInterior( player )
		local dimension = getElementDimension( player )
		
		local bankID = exports.sql:query_insertid( "INSERT INTO banks (x, y, z, rotation, interior, dimension) VALUES (" .. table.concat( { x, y, z, rotation, interior, dimension }, ", " ) .. ")" )
		if bankID then
			loadBank( bankID, x, y, z, rotation, interior, dimension, -1 )
			setElementPosition( player, x, y, z + 1 )
			
			outputChatBox( "Has creado un ATM. ID: " .. bankID .. ".", player, 0, 255, 153 )
		else
			outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
		end
	end,
	true
)

addCommandHandler( "createbank",
	function( player )
		local x, y, z = getElementPosition( player )
		local rotation = getPedRotation( player )
		local interior = getElementInterior( player )
		local dimension = getElementDimension( player )
		
		local bankID = exports.sql:query_insertid( "INSERT INTO banks (x, y, z, rotation, interior, dimension, skin) VALUES (" .. table.concat( { x, y, z, rotation, interior, dimension, 211 }, ", " ) .. ")" )
		if bankID then
			loadBank( bankID, x, y, z, rotation, interior, dimension, 211 )
			setElementPosition( player, x + 0.3, y, z )
			
			outputChatBox( "Has creado un banco. ID: " .. bankID .. ".", player, 0, 255, 153 )
		else
			outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
		end
	end,
	true
)

addCommandHandler( { "nearbyatms", "nearbybanks" },
	function( player, commandName )
		if hasObjectPermissionTo( player, "command.createbank", false ) or hasObjectPermissionTo( player, "command.createatm", false ) then
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			local interior = getElementInterior( player )
			
			outputChatBox( "Bancos/ATM:", player, 255, 255, 0 )
			for key, value in pairs( banks ) do
				if isElement( key ) and getElementDimension( key ) == dimension and getElementInterior( key ) == interior then
					local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( key ) )
					if distance < 5 then
						outputChatBox( "  " .. ( getElementType( key ) == "ped" and "Bank" or "ATM" ) .. " " .. value .. ".", player, 255, 255, 0 )
					end
				end
			end
		end
	end
)

addCommandHandler( { "deletebank", "delbank", "deleteatm", "delatm" },
	function( player, commandName, bankID )
		bankID = tonumber( bankID )
		if bankID then
			local bank = banks[ bankID ]
			if bank then
				if getElementType( bank.bank ) == "ped" or getElementType( bank.bank ) == "object" then
					if exports.sql:query_free( "DELETE FROM banks WHERE bankID = " .. bankID ) then
						outputChatBox( "Has borrado el ATM/NPC del banco ID: " .. bankID .. ".", player, 0, 255, 153 )				
						local dimension = getElementDimension( bank.bank )

						destroyElement( bank.bank )
						banks[ bankID ] = nil
						banks[ bank.bank ] = nil
						
						-- check for other banks in that dimension and destroy a blip if neccessary
						local found = false
						if blips[ dimension ] then
							for key, value in pairs( banks ) do
								if isElement( key ) and getElementType( key ) == "ped" and getElementDimension( key ) == dimension then
									found = true
									break
								end
							end
						end
						
						if not found and blips[ dimension ] then
							destroyElement( blips[ dimension ] )
							blips[ dimension ] = nil
						end
					else
						outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
					end
				else
					outputChatBox( "ATM/NPC del banco no encontrado.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "ATM/NPC del banco no encontrado.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local bankID = banks[ source ]
			if bankID then
				local bank = banks[ bankID ]
				if bank then		
					outputChatBox("Comandos del banco: /retirar /saldo y /ingresar (no se puede ingresar desde cajeros)", player, 0, 255, 0)
				end
			end
		end
	end
)

function getDinero ( player )
	if exports.players:isLoggedIn ( player ) then
		local sql = exports.sql:query_assoc_single("SELECT banco FROM characters WHERE characterID = " .. exports.players:getCharacterID ( player ))
		if sql and sql.banco then
			return tonumber(sql.banco)
		else
			return 0
		end
	else 
		return false 
	end
end

function bancoCercano( player )
	if exports.players:isLoggedIn ( player ) then
		local x, y, z = getElementPosition ( player )
		for key, value in pairs( banks ) do
			if isElement( key ) then
				local x2, y2, z2 = getElementPosition ( key )
				local distance = getDistanceBetweenPoints3D ( x, y, z, x2, y2, z2 )
				if getElementModel (key) <= 300 then
					comp = 10
				else
					comp = 1.5
				end
				if distance <= comp then
					if getElementModel (key) <= 300 then
						return 1
					else
						return 2
					end
				end
			end
		end
		return false
	end
end

function ingresarDinero ( player, cmd, cantidad )
	if exports.players:isLoggedIn( player ) then
		if not bancoCercano( player ) or bancoCercano( player ) > 1 then 
			outputChatBox("No estás cerca de un dependiente del banco.", player, 255, 0, 0) 
			return 
		end
		if not cantidad then outputChatBox("Sintaxis: /"..tostring(cmd).." [cantidad]", player, 255, 255, 255) return end
		local cantidad = tonumber(math.floor(cantidad))
		if cantidad < 1 then outputChatBox("No puedes ingresar esta cantidad de dinero.", player, 255, 0, 0) return end
		if not getDinero( player ) then outputChatBox("Se ha producido un error, inténtalo de nuevo más tarde.", player, 255, 0, 0) return end
		if exports.players:takeMoney( player, cantidad ) then
			if exports.sql:query_free("UPDATE characters SET banco = " .. (getDinero( player ) + cantidad) .. " WHERE characterID = " .. exports.players:getCharacterID ( player )) then
				exports.chat:me(player, "ingresa dinero en su cuenta bancaria.")
				outputChatBox("Has ingresado $" .. tostring ( cantidad ) .. " en tu cuenta.", player, 0, 255, 0)
				outputChatBox("Balance actual: $" .. tostring (getDinero( player )) .. ".", player, 0, 255, 0)
				local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
				local nuevoBalance = tonumber(getDinero(player))
				if nivel < 2 then outputChatBox("No puedes usar el banco porque necesitas nivel 2. Usa /objetivos.", player, 255, 0, 0) return end
				if nivel == 2 and not exports.objetivos:isObjetivoCompletado(15, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(15, exports.players:getCharacterID(player), player)
				end
				if nivel == 2 and nuevoBalance >= 10000 and not exports.objetivos:isObjetivoCompletado(17, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(17, exports.players:getCharacterID(player), player)
				end
				if nivel == 3 and nuevoBalance >= 50000 and not exports.objetivos:isObjetivoCompletado(22, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(22, exports.players:getCharacterID(player), player)
				end
				if nivel == 3 and nuevoBalance >= 100000 and not exports.objetivos:isObjetivoCompletado(31, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(31, exports.players:getCharacterID(player), player)
				end
				if nivel == 4 and nuevoBalance >= 200000 and not exports.objetivos:isObjetivoCompletado(34, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(34, exports.players:getCharacterID(player), player)
				end
				if nivel == 4 and nuevoBalance >= 300000 and not exports.objetivos:isObjetivoCompletado(35, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(35, exports.players:getCharacterID(player), player)
				end
			else
				outputChatBox("Se ha producido un ERROR GRAVE. Pulsa F12 y reclama tus $" .. tostring( cantidad ) .. " perdidos.", player, 255, 0, 0)
			end
		else
			outputChatBox("No tienes tanto dinero para ingresar.", player, 255, 0, 0)
		end
	end
end
addCommandHandler( {"ingresar", "depositar"}, ingresarDinero)

function sacarDinero ( player, cmd, cantidad )
	if exports.players:isLoggedIn( player ) then
		if not bancoCercano( player ) then outputChatBox("No estás cerca de un cajero o de un dependiente del banco.", player, 255, 0, 0) return end
		if not cantidad then outputChatBox("Sintaxis: /"..tostring(cmd).." [cantidad]", player, 255, 255, 255) return end
		local cantidad = tonumber(math.floor(cantidad))
		if cantidad < 1 then outputChatBox("No puedes retirar esta cantidad de dinero.", player, 255, 0, 0) return end
		if not getDinero( player ) then outputChatBox("Se ha producido un error, inténtalo de nuevo más tarde.", player, 255, 0, 0) return end
		if ( getDinero( player ) - cantidad ) < 0 then outputChatBox("No tienes tanto dinero en tu cuenta bancaria.", player, 255, 0, 0) return end
		if exports.sql:query_free("UPDATE characters SET banco = " .. (getDinero( player ) - cantidad) .. " WHERE characterID = " .. exports.players:getCharacterID ( player )) then
			if exports.players:giveMoney( player, cantidad ) then
				exports.chat:me(player, "retira dinero de su cuenta bancaria.")
				outputChatBox("Has retirado $" .. tostring ( cantidad ) .. " de tu cuenta.", player, 0, 255, 0)
				outputChatBox("Balance actual: $" .. tostring (getDinero( player )) .. ".", player, 0, 255, 0)
			else 
				outputChatBox("Se ha producido un ERROR GRAVE. Pulsa F12 y reclama tus $" .. tostring( cantidad ) .. " perdidos.", player, 255, 0, 0)
			end
		else
			outputChatBox("No tienes tanto dinero para ingresar.", player, 255, 0, 0)
		end
	end
end
addCommandHandler( {"retirar", "sacar"}, sacarDinero)

function consultarSaldo ( player )
	if not bancoCercano( player ) then outputChatBox("No estás cerca de un cajero o de un dependiente del banco.", player, 255, 0, 0) return end
	if not getDinero( player ) then outputChatBox("Se ha producido un error, inténtalo de nuevo más tarde.", player, 255, 0, 0) return end
	outputChatBox("El balance de tu cuenta es de $" .. tostring (getDinero( player )) .. ".", player, 0, 255, 0)
end
addCommandHandler( {"saldo", "balance"}, consultarSaldo)



-- checkpoint comprobación armas

local seguridadte = createMarker(-296.76483154297, 1484.5736083984, 1071.004957031, "cylinder",2,0,0,0,0)
setElementInterior(seguridadte, 14)
setElementDimension(seguridadte, 53)

addEventHandler("onMarkerHit",getRootElement(),
function(player)
	local laquiereliar = false
	if (source == seguridadte) then
		if getElementType(player) == "player" and not isPedInVehicle(player) then
			for slot = 0, 6 do
					local weapon = getPedWeapon( player, slot )
					local balas = getPedTotalAmmo( player, slot )
					if weapon ~= 0 and (balas >= 1 and balas) then
						laquiereliar = true
					end
			end
			if exports.factions:isPlayerInFaction(player, 1 ) then outputChatBox("ATENCIÓN: Te has identificado como agente del sheriff.",player, 0, 255, 0) return end
			if laquiereliar == true then
			triggerClientEvent(player,"dispararporllevararmasbanco",player)
		    else
			outputChatBox("ATENCIÓN: Has pasado correctamente el control de metales",player,0,255,0)
			end
		end
	end
end)