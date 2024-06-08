--[[
Copyright (C) 2015  Bone County Roleplay

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

local root = getRootElement()
function getVersion()
	local sql = exports.sql:query_assoc_single("SELECT * FROM `condiciones` ORDER BY `condiciones`.`version` DESC LIMIT 1")
	return tonumber(sql.version)
end

function todo(player)
	local charID = exports.players:getCharacterID(player)
	exports.sql:query_free("UPDATE characters SET condiciones = "..getVersion().." WHERE characterID = "..charID)
	outputChatBox("Has aceptado las condiciones de uso de DownTown RolePlay. ¡Disfruta del servidor!", player, 0, 255, 0)
	outputChatBox("Puedes revisarlas cuando quieras con /condiciones.", player, 0, 255, 0)
	removeElementData ( player, "nogui" )
	local sql = exports.sql:query_assoc_single("SELECT nuevo FROM wcf1_user WHERE userID = " .. tonumber(exports.players:getUserID(player)))
	if sql and sql.nuevo and sql.nuevo == 1 then
			outputChatBox("Bienvenido por primera vez a DownTown RolePlay.", player, 0, 255, 0)
			outputChatBox("Has recibido $4000 dólares extra por entrar por primera vez.", player, 255, 255, 0)
			exports.players:giveMoney(player, 4000)
			exports.sql:query_free("UPDATE dinero_sesiones SET cantidadLogin = 4700 WHERE characterID = "..tostring(charID))
			exports.sql:query_free("UPDATE wcf1_user SET nuevo = 0 WHERE userID = " .. tonumber(exports.players:getUserID(player)))
	end
end
addEvent("onAceptarCondiciones", true)
addEventHandler("onAceptarCondiciones", root, todo)

function nada(player)
outputChatBox("Has rechazado las condiciones. Ve a https://foro.fc-rp.ga para borrar tu cuenta.", player, 255, 0, 0)
outputChatBox("Vamos a proceder a expulsarte en 6 segundos...", player, 255, 0, 0)
setTimer( function () kickPlayer(player, "No has aceptado las condiciones.") end, 6000, 1, player)
end
addEvent("onNoAceptarNada", true)
addEventHandler("onNoAceptarNada", root, nada)

function nuevaVersionCondiciones (player)
	if not hasObjectPermissionTo(player, "command.acceptreport", false) then return end
	local cons = exports.sql:query_assoc_single("SELECT * FROM `condiciones` ORDER BY `condiciones`.`version` DESC LIMIT 1")
	triggerClientEvent("onEditarCondiciones", player, tostring(cons.version), tostring(cons.texto))
	outputChatBox("Estás editando las condiciones versión "..tostring(cons.version), player, 255, 255, 0)
	showCursor(player, true)
	toggleAllControls(player, false)
	setElementData(player, "nogui", true)
end
addCommandHandler("nuevascondiciones", nuevaVersionCondiciones) 

function verCondicionesAceptadas(player)
	local cons = exports.sql:query_assoc_single("SELECT * FROM `condiciones` ORDER BY `condiciones`.`version` DESC LIMIT 1")
	triggerClientEvent("onReMostrarCondiciones", player, tostring(cons.version), tostring(cons.texto))
end
addCommandHandler("condiciones", verCondicionesAceptadas)

function actualizarCondiciones(text)
	if source and text then
		showCursor(source, false)
		toggleAllControls(source, true, true, true)
		removeElementData(source, "nogui")
		local sql, error = exports.sql:query_free("UPDATE condiciones SET texto = '%s' WHERE version = "..getVersion(), tostring(text))
		if sql and not error then 
			outputChatBox("Has actualizado las condiciones correctamente.", source, 0, 255, 0)
		else
			outputChatBox("Ha ocurrido un error, inténtalo de nuevo.", source, 255, 0, 0)
		end	
	end
end	
addEvent("onActualizarCondiciones", true)
addEventHandler("onActualizarCondiciones", getRootElement(), actualizarCondiciones)