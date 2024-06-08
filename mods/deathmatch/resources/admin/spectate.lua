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
					if hasObjectPermissionTo( player, "command." .. commandName[ 1 ], not restricted ) then
						fn( player, ... )
					end
				end
			)
		end
	end
end

addCommandHandler( { "spectate", "spec", "recon" },
	function( player, commandName, other )
		if other then
			other, name = exports.players:getFromName( player, other )
			if not other then
				return
			end
		end	
		if not exports.freecam:isPlayerFreecamEnabled( player ) then
			if isElementAttached( player ) and getElementType( getElementAttachedTo( player ) ) == "player" and type( getElementData( player, "collisionless" ) ) == "table" then
				local x, y, z, dimension, interior = unpack( getElementData( player, "collisionless" ) )
				detachElements( player )
				setElementPosition( player, x, y, z )
				if dimension and interior then
					setElementDimension( player, dimension )
					setElementInterior( player, interior )
				end
				setElementAlpha( player, 255 )
				setCameraTarget( player )
				removeElementData( player, "collisionless" )
				removeElementData( player, "spec" )
				for k, v in ipairs (getElementsByType("player")) do
					if getElementData( v, "nombreStaff" ) == getPlayerName(player) then
						removeElementData( v, "nombreStaff" )
					end
				end	
			else
				if other then
					local x, y, z = getElementPosition( player )
					local interior, dimension = getElementInterior( player ), getElementDimension( player )
					setElementData( player, "collisionless", true ) -- synced to have the player collisionless
					setElementData( player, "collisionless", { x, y, z, dimension, interior }, false ) -- our data only
					local px, py, pz = getElementPosition (other)
					setElementPosition(player, px, py, pz)
					setElementDimension( player, getElementDimension( other ) )
					setElementInterior( player, getElementInterior( other ) )
					if attachElements( player, other, 0, 0, -5 ) then
						setElementData( other, "nombreStaff", getPlayerName(player))
						setElementDimension( player, getElementDimension( other ) )
						setElementInterior( player, getElementInterior( other ) )
						setElementAlpha( player, 0 )
						setCameraTarget( player, other )
						outputChatBox( "Ahora estás viendo a " .. name .. ".", player, 0, 255, 0 )
						setElementData( player, "spec", true )
						if getElementData(other, "enc") == true then outputChatBox("ATENCION: "..getPlayerName( player ):gsub( "_", " " ) .. " te está supervisando.", other, 255, 0, 0 ) end
						if getElementData(player, "enc") == true then outputChatBox("Protección Encubierto Activa.", player, 255, 0, 0) return end
						if hasObjectPermissionTo( player, "command.admin", false ) then outputChatBox("Protección Administrador Activa.", player, 255, 0, 0) return end
						for key, value in ipairs( getElementsByType( "player" ) ) do
							if hasObjectPermissionTo( value, "command.spectate", false ) then
								outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " está ahora viendo a " .. name .. ".", value, 0, 255, 153 )
							end
						end
					else
						outputChatBox( "No se pudo conectar con " .. name .. ".", player, 255, 0, 0 )
						setElementInterior( player, interior )
						setElementDimension( player, dimension )
						removeElementData( other, "nombreStaff" )
					end
				else
					outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
				end
			end
		else
			outputChatBox( "Por favor, antes sal de freecam.", player, 255, 0, 0 )
		end
	end,
	true
)


function specSecundario(player, cmd, otherPlayer)
	if hasObjectPermissionTo( player, "command.spectate" ) then
		if not otherPlayer and not getElementData(player, "inSpec") then
			outputChatBox("Sintaxis: /spec2 [jugador]", player, 255, 255, 255)
			return
		end
		if not getElementData(player, "inSpec") then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				setElementData(player, "inSpec", tostring(name))
				setCameraTarget(player, other)
				setElementData(player, "inSpecINT", getElementInterior(other))
				setElementData(player, "inSpecDIM", getElementDimension(other))
				setElementInterior(player, getElementInterior(other))
				setElementDimension(player, getElementDimension(player))
				outputChatBox("Ahora estás supervisando a "..tostring(name)..".", player, 0, 255, 0)
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if hasObjectPermissionTo( value, "command.spectate", false ) then
						outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " está ahora viendo a " .. name .. ".", value, 0, 255, 153 )
					end
				end
			end
			-- No está en spec
		else
			setCameraTarget(player, player)
			setElementInterior(player, getElementData(player, "inSpecINT"))
			setElementDimension(player, getElementData(player, "inSpecDIM"))
			removeElementData(player, "inSpec")
			removeElementData(player, "inSpecINT")
			removeElementData(player, "inSpecDIM")
			-- Está en spec
		end
	end
end
--addCommandHandler("spec2", specSecundario)

timerRobo = {}
blipPol = {}

function actualizarPosicion (other)
	if other then 
		triggerClientEvent("onReconnectRadioInterior", other, other)
		local staffN = getElementData(other, "nombreStaff")
		if staffN and getPlayerFromName(getElementData(other, "nombreStaff")) then -- Hay un staff que está supervisandolo
			staff = getPlayerFromName(getElementData(other, "nombreStaff"))
			outputChatBox("Se ha producido un cambio de interior al ID "..tostring(getElementDimension(other)), staff, 255, 0, 0)
			if getElementData(staff, "ladron") then hechoRobo (staff) end
			detachElements( staff )
			setElementDimension( staff, getElementDimension( other ) )
			setElementInterior( staff, getElementInterior( other ) )
			attachElements( staff, other, 0, 0, -5 )
			setCameraTarget( staff, other )
		else
			if exports.factions:isPlayerInFaction(other, 1) then
				if getElementData(other, "ref") == true then
					outputChatBox("Posición actualizada, reenviando a todas las unidades.", other, 0, 255, 0)
					executeCommandHandler("ref", other, "true")
					executeCommandHandler("ref", other, "true")
				end
				if getElementData(other, "ref2") == true then
					outputChatBox("Posición actualizada, reenviando a todas las unidades.", other, 0, 255, 0)
					executeCommandHandler("pan", other, "true")
					executeCommandHandler("pan", other, "true")
				end
			end
		end
	end 
end

function hechoRobo (staff)
	if not getElementData(staff, "ladron") then outputChatBox("No estás supervisando ningún robo.", staff, 255, 0, 0) return end
	local playerN = getElementData(staff, "ladron")
	local player = getPlayerFromName(playerN)
	local interiorID = tonumber(getElementData(staff, "int.robo"))
	if interiorID == 264 then
		outputChatBox("Este interior no puede ser robado. Robo anulado.", player, 255, 0, 0)
		outputChatBox("Este interior no puede ser robado. Robo anulado.", staff, 255, 0, 0)
		limpiarDatos(player, staff)
		return
	end
	local int = exports.interiors:getInterior(interiorID)
	local dinero = 4000+tonumber(int.recaudacion)
	if not getElementData(player, "robo.enproceso") == true then limpiarDatos(player, staff) return end
	local time = getRealTime()
	local sql, error = exports.sql:query_insertid( "INSERT INTO robos (userIDStaff, charIDLadron, tipo, objetoID, cantidad, fecha) VALUES (" .. table.concat( { exports.players:getUserID(staff), exports.players:getCharacterID(player), 2, tonumber(interiorID), tonumber(dinero), time.timestamp }, ", " ) .. ")" )
	if sql and not error then
		outputChatBox("Has salido y se ha avisado a la policía.", player, 255, 255, 0)
		outputChatBox("Han salido y se ha avisado a la policía.", staff, 255, 255, 0)
		exports.interiors:takeProductos(interiorID, 200)
		outputChatBox("El ladrón ya ha recibido sus $"..tostring(dinero)..". Si anulas el robo, asegúrate de recuperarlo utilizando /pagostaff.", staff, 255, 255, 0)
		outputChatBox("Has ganado en total $"..tostring(dinero).." por el robo.", player, 0, 255, 0)
		exports.players:giveMoney(player, dinero)
		exports.interiors:takeRecaudacion(interiorID, tonumber(int.recaudacion))
		local time = getRealTime()
		local x, y, z = getElementPosition(int.outside)	
		for k, v in ipairs (getElementsByType("player")) do 
			if exports.factions:isPlayerInFaction(v, 1) or getElementData(v, "enc1") == true then
				outputChatBox("¡Se ha producido un robo, acuda urgentemente!", v, 255, 255, 0)
				blipPol[v] = createBlip( x, y, z, 20, 2, 0, 0, 255, 255, 0, 99999.0, v )
			end
		end
		exports.factions:createFactionBlip2(x, y, z, 1, 0, 3)
		limpiarDatos(player, staff)
	end
end

function limpiarDatos (player, staff)
	removeElementData(player, "robo.enproceso")
	removeElementData(player, "robo")
	removeElementData(staff, "robo")
	removeElementData(staff, "ladron")
	removeElementData(staff, "int.robo")
	setElementData(staff, "pm", true)
end