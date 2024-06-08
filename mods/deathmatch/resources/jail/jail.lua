--[[
Copyright (c) 2019 DownTown RolePlay

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

timerjail = setTimer ( 	
function ()	  
	for k, player in ipairs(getElementsByType("player")) do
		local tjail = tonumber(getElementData(player, "tjail"))
		local ajail = tonumber(getElementData(player, "ajail"))
		local tpd = tonumber(getElementData(player, "tpd"))
		if tjail and tjail >= 1 then
			setElementHealth(player, 100)
			setElementData(player, "tjail", tjail-1)
			local userID = exports.players:getUserID(player)
			if userID then
				exports.sql:query_free( "UPDATE wcf1_user SET tjail = "..tonumber(tjail-1).." WHERE userID = " .. userID )
			end
			if tjail == 1 then
				setElementHealth(player, 100)
				triggerEvent("onJailFinalizar", player, player)
			end
		end
		if ajail and (not tjail or tjail == 0) then
			setElementHealth(player, 100)
			if ajail >= 2 then
				setElementData(player, "ajail", getElementData(player, "ajail")-1)
				exports.sql:query_free( "UPDATE characters SET ajail = "..tonumber(ajail-1).." WHERE characterID = " .. exports.players:getCharacterID(player) )
			elseif ajail == 1 then
				removeElementData(player, "ajail")
				exports.sql:query_free( "UPDATE characters SET ajail = 0 WHERE characterID = " .. exports.players:getCharacterID(player) )
				outputChatBox("Tu tiempo de prisión ha finalizado.", player, 0, 255, 0)
				setElementPosition(player, 2408.85, 49.22, 26.48)
				setElementRotation(player, 0, 0, 176.11)
				setElementInterior(player, 0)
				setElementDimension(player, 0)
			end
		end
		if tpd then				
			if tpd == 59 then -- Pasó un minuto y ya hay que dar el PayDay ;D
				exports.payday:darPayday(player)
				setElementData(player, "tpd", 0)
			else
				setElementData(player, "tpd", tonumber(tpd+1))
			end
		end
	end			
end 
, 60000, 0 )
 
function jailPlayer ( player, otro, tiemp, razon )
	local nombre = getPlayerName(otro):gsub("_", " ")
	local tiempo2 = getElementData( otro, "ajail" )
	local tiempoJ = getElementData(otro, "tjail")
	if tiempoJ and tiempoJ > 0 then
		tiempo = tiemp+tiempoJ
		outputChatBox("Se te ha sumado este jail a los minutos que ya tenías.", otro, 255, 0, 0)
	else
		tiempo = tiemp
	end
	if tiempo2 and tiempo2 > 0 then outputChatBox("No puedes dar jail a este jugador porque está arrestado IC.", otro, 255, 0, 0) return end
	if getPedOccupiedVehicle(otro) then 
		removePedFromVehicle(otro)	
	end
	if exports.sql:query_free( "UPDATE wcf1_user SET tjail = "..tiempo.." WHERE userID = " .. exports.players:getUserID(otro)) then
		exports.chat:sendLocalOOC( otro, "[Jail] " .. nombre .. " ha sido jaileado por un staff." )
		setTimer( function (otro)
		setElementPosition(otro, 265.65182495117, 79.20386505127, 1002.6829833984)
		setElementInterior(otro, 6)
		setElementDimension(otro, 35) end, 500, 1, otro )
		setElementData(otro, "tjail", tonumber(tiempo))
		if getElementData(player, "enc") then
			outputChatBox("Has dado jail a " .. nombre .. " correctamente.", player, 255, 0, 0)
			outputChatBox("Razón: " ..razon.. ". Tiempo: " ..tiempo.. " minutos.", player, 255, 0, 0)
		else
			staffMessageJail("El staff " ..getPlayerName(player):gsub("_", " ").. " ha jaileado al jugador " ..nombre.. ".")
			staffMessageJail("Razón: " ..razon.. ". Tiempo: " ..tiempo.. " minutos.")
		end
		outputChatBox("Has sido jaileado por " ..getPlayerName(player):gsub("_", " ").. " durante " ..tiempo.. " minutos. Razón: " ..razon.. ".", otro, 255, 0, 0)
	end
end
  

function serverJail ( player, tiempo, ... )
	local tiempo = tonumber(tiempo)
	local razon = table.concat({...}, " ")
	local cid = exports.players:getCharacterID(player)
	local userID = exports.players:getUserID(player)
	local vehicle = getPedOccupiedVehicle(player)
		if vehicle then 
			removePedFromVehicle(player)
			-- if getElementData(vehicle, "idveh") >= 1 then
				-- exports.vehicles:saveVehicle( vehicle )
				-- respawnVehicle( vehicle ) 	
			-- else
				-- destroyElement( vehicle )
			-- end		
		end	
	if tiempo and razon and cid and player then
		if exports.sql:query_free( "UPDATE wcf1_user SET tjail = "..tiempo.." WHERE userID = " .. userID) then
			setTimer( function (player)
				setElementPosition(player, 265.65182495117, 79.20386505127, 1002.6829833984)
				setElementInterior(player, 6)
				setElementDimension(player, 35) 
			end, 500, 1, player )
			setElementData(player, "tjail", tiempo)
			if tostring(razon) ~= "DM en Jail" then
				staffMessageJail(getPlayerName(player):gsub("_", " ").." ha sido jaileado por el servidor.")
				staffMessageJail("Razón: "..razon..". Tiempo: "..tostring(tiempo).." minutos.")
			end
			outputChatBox("Has sido jaileado durante "..tostring(tiempo).." minutos. Razón: " ..razon.. ".", player, 255, 0, 0)
			return true
		end
	end
end


function tiempoJail ( player )
	local tiempo = getElementData( player, "tjail" )
	if tiempo and tiempo >= 2 then
		outputChatBox("Te quedan " ..tiempo.. " minutos.", player, 255, 0, 0)
	elseif tiempo and tiempo == 1 then
		outputChatBox("Te queda " ..tiempo.. " minuto.", player, 255, 0, 0)
	end
	local tiempo2 = getElementData( player, "ajail" )
	if tiempo2 and tiempo2 >= 2 then
		outputChatBox("Te quedan " ..tiempo2.. " minutos de arresto.", player, 255, 0, 0)
	elseif tiempo2 and tiempo2 == 1 then
		outputChatBox("Te queda " ..tiempo2.. " minuto de arresto.", player, 255, 0, 0)
	end
end
addCommandHandler("tiempo", tiempoJail)

function verJailUsuario ( player, cmd, otherPlayer )
	local other, name = exports.players:getFromName( player, otherPlayer )
	local tiempover1 = getElementData( other, "tjail" )
	local tiempover2 = getElementData( other, "ajail" )
	if hasObjectPermissionTo(player, 'command.modchat', false) then
		if tiempover1 then
			if tiempover1 and tiempover1 >= 2 then
				outputChatBox("INFO: Le quedan " ..tiempover1.. " minutos de sanción OOC a "..tostring(name)..".", player, 255, 0, 0)
			elseif tiempover1 and tiempover1 == 1 then
				outputChatBox("INFO: Le queda " ..tiempover1.. " minuto de sanción OOC a "..tostring(name)..".", player, 255, 0, 0)
			end
		else
			outputChatBox("Este jugador no tiene jail OOC.", player, 255, 0, 0)
		end
		if tiempover2 then
			if tiempover2 and tiempover2 >= 2 then
				outputChatBox("INFO: Le quedan " ..tiempover2.. " minutos de arresto IC a "..tostring(name)..".", player, 255, 0, 0)
			elseif tiempover2 and tiempover2 == 1 then
				outputChatBox("INFO: Le queda " ..tiempover2.. " minuto de arresto IC a "..tostring(name)..".", player, 255, 0, 0)
			end
		else
			outputChatBox("Este jugador no tiene jail IC.", player, 255, 0, 0)
		end
    else
		outputChatBox("Acceso denegado.", player, 0, 255, 0)
	end
end
addCommandHandler("verjailde", verJailUsuario)
addCommandHandler("jailde", verJailUsuario)
addCommandHandler("vertiempode", verJailUsuario)
addCommandHandler("tiempode", verJailUsuario)

function unjail ( player, commandName, idsancion )
	if hasObjectPermissionTo(player, 'command.modchat', false) then
		if not idsancion then
			outputChatBox("Sintaxis: /unjail [ID de sanción]", player, 255, 255, 255)
			return
		end
		local idsancion = tonumber(idsancion)
		if idsancion and idsancion >= 1 then
			local sancion = exports.sql:query_assoc_single("SELECT * FROM sanciones WHERE sancionID = "..idsancion)
			if sancion then
				local staffID = exports.players:getUserID(player)
				local userID = tonumber(sancion.userID)
				if tonumber(sancion.validez) == 1 then -- Si la sanción es válida, NO puede salir de jail.
					outputChatBox("La sanción especificada sigue siendo válida. Usa /sanciones [jugador] y anúlala primero.", player, 255, 0, 0)
					return
				end
				if tonumber(staffID) == tonumber(sancion.staffID) or tonumber(sancion.staffID) == -1 then
					local otro = -1
					for k, v in ipairs(getElementsByType("player")) do
						if exports.players:getUserID(v) == userID then
							otro = v
						end
					end
					if isElement(otro) then
						if getElementData( otro, "tjail") and tonumber(getElementData( otro, "tjail")) >= 1 then
							setElementPosition(otro, 2408.85, 49.22, 26.48)
							outputChatBox('El staff '..getPlayerName(player):gsub("_", " ").. ' te ha liberado del jail.', otro, 0, 255, 0)
							outputChatBox('Has liberado a '..getPlayerName(otro):gsub("_", " ").. ' del jail.', player, 0, 255, 0)
							exports.logs:addLogMessage("unjail", 'El staff '..getPlayerName(player):gsub("_", " ").. ' ha liberado a '..getPlayerName(otro):gsub("_", " ").. ' del jail.' )
							setElementInterior(otro, 0)
							setElementDimension(otro, 0)
							removeElementData(otro, "tjail")
							exports.sql:query_free("UPDATE wcf1_user SET tjail = 0 WHERE userID = " .. userID)
							exports.sql:query_free("UPDATE characters SET interior = 0, dimension = 0, x = 2408.85, y = 49.22, z = 26.48 WHERE userID = "..userID)
							exports.sql:query_insertid( "INSERT INTO sanciones (userID, staffID, regla, validez) VALUES (" .. table.concat( { userID, staffID, -1, idsancion }, ", " ) .. ")" )
						else
							outputChatBox("El jugador seleccionado no está en jail.", player, 0, 255, 0)
						end
					else
						outputChatBox("El jugador de esa sanción no está conectado.", player, 255, 0, 0)
					end
				else
					outputChatBox("¡Esta ID de sanción no ha sido emitida por ti!", player, 255, 0, 0)
				end
			end
		else
			outputChatBox("El ID de sanción debe de ser un número mayor o igual a 1.", player, 255, 0, 0)
		end
	else
		outputChatBox("Acceso denegado.", player, 0, 255, 0)
	end
end
addCommandHandler("unjail", unjail)

function entradaJail ()
	removeElementData(source, "ajail")
	local userID = exports.players:getUserID(source)
	local v = exports.sql:query_assoc_single("SELECT tjail FROM wcf1_user WHERE userID = "..tonumber(userID))
	if v and v.tjail and tonumber(v.tjail) > 1 then
		triggerEvent("onJail", source, source, tonumber(v.tjail), 1)
	end
	local characterID = exports.players:getCharacterID(source)
	local v2 = exports.sql:query_assoc_single("SELECT ajail FROM characters WHERE characterID = "..tonumber(characterID))
	if v2 and v2.ajail and tonumber(v2.ajail) > 1 then
		triggerEvent("onJail", source, source, tonumber(v2.ajail), 2)
	end
end
addEventHandler( "onCharacterLogin", root, entradaJail )

function continuarjail (otro, tiempo, tipo)
	if tipo == 1 then
		setElementPosition(otro, 265.65182495117, 79.20386505127, 1002.6829833984)
		setElementInterior(otro, 6)
		setElementDimension(otro, 35)
		setElementData(otro, "tjail", tonumber(tiempo))
		outputChatBox ("Sigues jaileado, y tienes que cumplir tu tiempo.", otro, 255, 0, 0)
	elseif tipo == 2 then
		setElementPosition(otro, 227.44, 110.82, 999.02)
		setElementInterior(otro, 10)
		setElementDimension(otro, 104)
		setElementData(otro, "ajail", tonumber(tiempo))
		outputChatBox("Sigues arrestado, y tienes que cumplir tu tiempo.", otro, 255, 0, 0)
	end
end
addEvent("onJail", true)
addEventHandler("onJail", root, continuarjail)

function tiempofinal ( otro )
	local userID = getElementData(otro, "data.userid")
    setElementPosition(otro, 2408.85, 49.22, 26.48)
	outputChatBox("Tu tiempo en jail ha finalizado. Esperamos no volver a verte.", otro, 0, 255, 0)
    setElementInterior(otro, 0)
    setElementDimension(otro, 0)
	removeElementData(otro, "tjail")
    exports.sql:query_free("UPDATE wcf1_user SET tjail = 0 WHERE userID = " .. userID)
	exports.sql:query_free("UPDATE characters SET interior = 0, dimension = 0, x = 2408.85, y = 49.22, z = 26.48 WHERE userID = "..userID)
end
addEvent("onJailFinalizar", true)
addEventHandler("onJailFinalizar", root, tiempofinal)

function getStaff( duty )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.modchat", false ) then
			t[ #t + 1 ] = value
		end
	end
	return t
end

function staffMessageJail( message )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, 255, 0, 0 )
	end
end