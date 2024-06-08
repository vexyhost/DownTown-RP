--[[
Copyright (c) 2019 MTA: Paradise y DownTown RolePlay

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

addCommandHandler( "pagar",
	function( player, commandName, otherPlayer, amount )
		local amount = tonumber( amount )
		if otherPlayer and amount and math.ceil( amount ) == amount and amount > 0 then
			local other, name = exports.players:getFromName( player, otherPlayer )
			if other then
				if player ~= other then
					local x, y, z = getElementPosition( player )
					if getDistanceBetweenPoints3D( x, y, z, getElementPosition( other ) ) < 5 then
						local sql = exports.sql:query_assoc_single("SELECT DATE(created) AS fecha1 FROM `characters` WHERE characterID = "..exports.players:getCharacterID(player))
						local sql2 = exports.sql:query_assoc_single("SELECT CURRENT_DATE AS fecha2")
						local sql3 = exports.sql:query_assoc_single("SELECT DATEDIFF('"..tostring(sql2.fecha2).."','"..tostring(sql.fecha1).."') AS diferencia")
						if not sql3 then outputChatBox("Se ha producido un error grave.", player, 255, 0, 0) return end
						if tonumber(sql3.diferencia) < 5 then 
							exports.logs:addLogMessage("/pagos_nuevos/"..getPlayerName(player):gsub("_", " "), "Cantidad $"..tostring(amount).." pagado a "..tostring(name)..".")
							outputChatBox("Hola, nuevo. Si te acaban de estafar, usa F1 y abre incidencia para que te devolvamos tu dinero.", player, 0, 255, 0)
							outputChatBox("Has recibido un pago de un nuevo. Si le has estafado, DEVUELVELO O SERÁS BANEADO PERMANENTEMENTE.", other, 255, 0, 0)
						end
						if exports.players:takeMoney( player, amount ) then
						   if not getElementData(other, "mecaduty") == true then
								exports.players:giveMoney( other, amount )
								exports.chat:me( player, "saca unos billetes y se los da a " .. name .. "." )
								setPedAnimation( player, "DEALER", "shop_pay", 3000, false, false, false)
								outputChatBox( "Has dado a " .. name .. " $" .. amount .. ".", player, 0, 255, 0 )
								outputChatBox( getPlayerName( player ):gsub( "_", " " ) .. " te ha dado $" .. amount .. ".", other, 0, 255, 0 )
							else
								outputChatBox( "Para pagar servicios del taller te debe facturar el mecánico", player, 255, 0, 0 )
								outputChatBox( "Debes cobrarle usando /facturar.", other, 255, 0, 0 )
								exports.players:giveMoney( player, amount )
							end
						end
					else
						outputChatBox( "Estas demasiado lejos de " .. name .. ".", player, 255, 0, 0 )
					end
				else
					outputChatBox( "No puedes pagarte a ti mismo.", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [jugador] [cantidad]", player, 255, 255, 255 )
		end
	end
)


-- PCU -- 

function aceptarPCU ( player )
	if player then
		IDa = getElementData(player, "data.userid")
		IDa = tonumber(IDa)
		exports.sql:query_free( "UPDATE wcf1_user SET activationCode = 0 WHERE userID = " .. IDa )
        --redirectPlayer(player,"",0)
	end
end
addEvent( "onPCUAceptada", true )
addEventHandler( "onPCUAceptada", getRootElement(), aceptarPCU )

function rechazarPCU ( player )
	if player then
		kickPlayer(player, "Servicio Test", "Test fallido, visita fc-mta.com y conéctate para inténtarlo de nuevo.")
	end
end
addEvent( "onPCURechazada", true )
addEventHandler( "onPCURechazada", getRootElement(), rechazarPCU )

-- PCU --

function conectarse ()
setElementData ( source, "data.intentos", 0 )
end
addEventHandler ( "onPlayerJoin", root, conectarse )

local function getStaff( duty )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.modchat", false ) then
			if not duty or exports.players:getOption( value, "staffduty" ) or exports.players:getOption( value, "helpduty" ) or getElementData(value, "pm") == true then
				t[ #t + 1 ] = value
			end
		end
	end
	return t
end

local function staffMessage( message )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, 255, 127, 127 )
	end
end

function asignaruserID ()
	setElementData(source, "operador", 2)
	setElementData(source, "data.userid", exports.players:getUserID(source))
	local sql = exports.sql:query_assoc_single("SELECT tjail FROM wcf1_user WHERE userID = "..exports.players:getUserID(source))
	if sql.tjail and sql.tjail > 0 then
		setElementData(source, "tjail", sql.tjail)
	end
	removeElementData(source, "wid")
	for i,wep in ipairs(getPedWeapons(source)) do
		if wep and wep ~= 0 then
			setElementData(source, "wid", true)
		end
	end
	setElementData(source, "pm", true)
	local x, y, z = getElementPosition(source)
	if getElementDimension(source) == 0 then
		setElementPosition(source, x, y, z+2)
	end
	if getElementData(source, "bs") then -- Usuario de BS detectado.
		exports.sql:query_free("UPDATE wcf1_user SET bs = bs + 1 WHERE userID = "..exports.players:getUserID(source))
	end
	local userID = exports.players:getUserID(source)
	local charID = exports.players:getCharacterID(source)
	local sql = exports.sql:query_assoc_single("SELECT edad, genero FROM characters WHERE characterID = " .. charID)
	setPlayerBlurLevel(source, 0)
	if sql.edad == 0 or sql.genero == 0 then
		outputChatBox("¡ALERTA! Su PJ no tiene definido género ni edad.", source, 0, 255, 0)
		outputChatBox("Hemos dado el aviso a un staff de servicio para que lo solucione ;)", source, 0, 255, 0)
		staffMessage("ATENCIÓN: ["..getElementData(source, "playerid").."] "..getPlayerName(source):gsub("_", " ").. " no tiene género ni edad. Use /genero y /edad")
	end
end
addEventHandler ( "onCharacterLogin", root, asignaruserID )

function BarrasUpdate2()
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if exports.players:isLoggedIn(value) and not getElementData(value, "ajail") and not getElementData(value, "tjail") then
			if getElementData(value, "sed") and getElementData(value, "sed") <= 0 then
				if (getElementHealth(value)-5) >= 2 then
					setElementHealth(value, getElementHealth(value)-5)
				else
					triggerEvent("onSufrirAtaque", value, value, 0, 61, true, true)
					outputChatBox("Te has desmayado. ¡Necesitas beber algo!", value, 255, 255, 0)
				end
			else
				setElementData(value, "sed", getElementData(value, "sed")-math.random(2, 8))
			end
			if getElementData(value, "hambre") and getElementData(value, "hambre") <= 0 then
				if (getElementHealth(value)-5) >= 2 then
					setElementHealth(value, getElementHealth(value)-5)
				else
					triggerEvent("onSufrirAtaque", value, value, 0, 61, true, true)
					outputChatBox("Te has desmayado. ¡Necesitas comer algo!", value, 255, 255, 0)
				end
			else
				setElementData(value, "hambre", getElementData(value, "hambre")-math.random(2, 8))
			end
			if getElementData(value, "cansancio") and getElementData(value, "cansancio") <= 0 then
				if (getElementHealth(value)-5) >= 2 then
					setElementHealth(value, getElementHealth(value)-5)
				else
					triggerEvent("onSufrirAtaque", value, value, 0, 61, true, true)
					outputChatBox("Te has desmayado. ¡Tienes que descansar!", value, 255, 255, 0)
				end
			else
				setElementData(value, "cansancio", getElementData(value, "cansancio")-math.random(2, 8))
			end
		end
	end
end
--addCommandHandler("tb", BarrasUpdate2)
setTimer(BarrasUpdate2, 3600000, 0)

--[[addEventHandler( "onPlayerDamage", root, Headshot
	function( attacker, weapon, bodypart, loss )
		if attacker then
			if bodypart == 9 and weapon >= 22 and weapon <= 38 and not getElementData(attacker, "tazerOn") and not getElementData(attacker, "gomaOn") then
				setPedHeadless( source, true )
				killPed( source, attacker, weapon, bodypart )
			end
		end
	end
)]]

addEventHandler( "onPlayerSpawn", root,
	function( )
		if isPedHeadless( source ) then
			setPedHeadless( source, false )
		end
	end
)

function syncTime() -- Hora del server UTC. Sin variación horaria.
    local realTime = getRealTime()
    local hour = realTime.hour
    local minute = realTime.minute
    setMinuteDuration ( 60000 )
	if hour == 24 then
		setTime( 0 , minute )
	else
		setTime( hour , minute )
	end
end
setTimer ( syncTime, 3000000, 0 ) 
function SyncTime2()
	setTimer ( syncTime, 2000, 1 )
end
addEventHandler ( "onResourceStart", getRootElement(), SyncTime2 )

function getPedWeapons(ped) 
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=2,9 do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end

function verYo (thePlayer)
	outputChatBox("Usa /eyo [Nuevo /yo] para editar la descripción física de tu PJ.", thePlayer, 0, 255, 0)
	outputChatBox("/yo actual: "..getElementData(thePlayer, "yo"), thePlayer, 0, 255, 0)
end
addCommandHandler ( "yo", verYo )

function modificarYo(thePlayer, command, ...)
	if ( ... ) then
		if exports.objetivos:getNivel(exports.players:getCharacterID(thePlayer)) < 2 then outputChatBox("Necesitas nivel 2 para utilizar /eyo. Usa /objetivos.", thePlayer, 255, 0, 0) return end
		local yo = table.concat( {...}, " " )
        setElementData ( thePlayer, "yo", yo )
		local sql, error = exports.sql:query_free("UPDATE characters SET yo = '%s' WHERE characterID = "..exports.players:getCharacterID(thePlayer), tostring(yo))
		if sql and not error then
			outputChatBox("/yo actualizado: "..tostring(yo), thePlayer, 0, 255, 0)
			local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(thePlayer))
			if nivel == 2 and not exports.objetivos:isObjetivoCompletado(18, exports.players:getCharacterID(thePlayer)) then
				exports.objetivos:addObjetivo(18, exports.players:getCharacterID(thePlayer), thePlayer)
			end
		else
			outputDebugString(error)
		end
	else
		outputChatBox("Sintaxis: /eyo [Nuevo /yo, descripción física de tu PJ]", thePlayer, 255, 255, 255)
	end	
end
addCommandHandler ( "eyo", modificarYo )

addEventHandler( "onPlayerNetworkStatus", root,
	function( status, ticks )
		if status == 1 then
			if ticks > 3000 then
				outputChatBox("Hemos detectado un problema con tu conexión. Por favor, revísala.", source, 255, 0, 0)
			end
		end
	end
)

--------- Sistema de Gordura ---------------------------------------------------------------------------
function gestionarPeso(gordura,peso) 
	setPedStat (source,gordura,peso)
	-- Hacer que estas stats se guarden vía SQL en cuanto esta función se llame.
end 
addEvent("onGestionarPeso",true) 
addEventHandler("onGestionarPeso",root,gestionarPeso)
---------------------------------------------------------------------------------------------------------

local commandSpam = {}

addEventHandler("onPlayerCommand", root,
	function(cmd)
		if getElementData(source, "muTemp") then
			cancelEvent()
			outputChatBox("Sigues muteado, y no puedes usar este comando.", source, 255, 0, 0)
			return
		end
		if (not commandSpam[source]) then
			commandSpam[source] = 1
		elseif (commandSpam[source] >= 4) and (commandSpam[source] < 8)then
			cancelEvent()
			outputChatBox("Para de hacer flood o serás muteado.", source, 255, 0, 0)
			commandSpam[source] = commandSpam[source]+1
		elseif (commandSpam[source] >= 8) then
			cancelEvent()
			commandSpam[source] = nil
			setElementData(source, "muTemp", true)
			outputChatBox("Has sido muteado durante 15 segundos por flood.", source, 255, 0, 0)
			outputChatBox("Se te notificará cuando puedas volver a usar comandos.", source, 255, 255, 255)
			setTimer(function(source)
				removeElementData(source, "muTemp")
				outputChatBox("Ya puedes volver a hablar. ¡No hagas flood de nuevo!", source, 0, 255, 0)
				end, 15000, 1, source)
		else
			commandSpam[source] = commandSpam[source]+1
		end
	end
)
setTimer(function() commandSpam = {} end, 1000, 0)