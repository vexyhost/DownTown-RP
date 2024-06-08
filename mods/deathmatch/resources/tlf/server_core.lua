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
function addZero( number, size )
  local number = tostring( number )
  local number = #number < size and ( ('0'):rep( size - #number )..number ) or number
     return number
end

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

function IMEIConLinea(numero)
	if numero then
		local consulta = exports.sql:query_assoc_single("SELECT `imei` FROM `tlf_data` WHERE `numero` = "..tostring(numero).." AND `estado` = 0")
		if consulta then
			return string.format("%13.0f",consulta.imei)
		else
			return -1
		end
	end
end

function isTelefonoEncendido(numero)
	if numero then
		local consulta = exports.sql:query_assoc_single("SELECT `apagado` FROM `tlf_data` WHERE `numero` = "..tostring(numero).." AND `estado` = 0")
		if consulta then
			if tonumber(consulta.apagado) == 0 then
				return true
			else
				return false
			end
		else
			return false
		end
	end
end
--
local p = { }
local sElegido = { }
local avisoFinal = { }

local function getJugadoresFaccion( factionID )
	local p = { }
	for index,value in ipairs(getElementsByType("player")) do 
		if exports.factions:isPlayerInFaction( value, factionID ) or getElementData(value, "enc"..tostring(factionID)) then 
			table.insert( p, value )
		end 
	end 
	return p
end

local function getJugadores2Faccion( factionID1, factionID2 )
	local p = { }
	for index,value in ipairs(getElementsByType("player")) do 
		if exports.factions:isPlayerInFaction( value, factionID1 ) or exports.factions:isPlayerInFaction( value, factionID2 ) then 
			table.insert( p, value )
		end 
	end 
	return p
end

local services =
{
	[112] =
	{
		function( player, phoneNumber, input )
			if player then
				local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
				if nivel == 2 and not exports.objetivos:isObjetivoCompletado(19, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(19, exports.players:getCharacterID(player), player)
				end
				return true, "Emergencias: Especifique si necesita si necesita policias ((/p 1)), si necesita médicos ((/p 2)) o si necesita bomberos ((/p 3))"
			end
		end,
		true,
		function( player, phoneNumber, input )
			if input[1] == "1" or string.lower(input[1]) == "uno" then
				local policias = getJugadoresFaccion ( 1 )
				if #policias > 0 then
					sElegido[player] = 1
					return true, "Emergencias: Los Santos Police Department, indique el motivo de su emergencia"
				else
					return false, "Emergencias: En este momento todos nuestros agentes están ocupados, ¡llame mas tarde!"
				end
			elseif input[1] == "2" or string.lower(input[1]) == "dos" then
				local medicos = getJugadoresFaccion ( 2 )
				if #medicos > 0 then
					sElegido[player] = 2
					return true, "Emergencias: Los Santos Medical Department, indique el motivo de su emergencia"
				else
					return false, "Emergencias: En este momento no hay ningun médico disponible, ¡llame mas tarde!"
				end
			elseif input[1] == "3" or string.lower(input[1]) == "tres" then
				local bomberos = getJugadoresFaccion ( 2 )
				if #bomberos > 0 then
					sElegido[player] = 3
					return true, "Emergencias: Los Santos Fire Department, indique el motivo de su emergencia"
				else
					return false, "Emergencias: En este momento no hay ninguna unidad de bomberos disponible, ¡llame mas tarde!"
				end
			else
				return false, "Emergencias: No ha especificado el servicio, llame de nuevo al 112."
			end
		end,
		true,
		function( player, phoneNumber, input )
			if getElementDimension(player) == 0 then
				x, y, z = getElementPosition(player)					
			else
				x, y, z = exports.interiors:getPos(getElementDimension(player))
			end
			if sElegido[player] == 1 then
				local policias = getJugadoresFaccion ( 1 )
				for key, value in ipairs( policias ) do
					outputChatBox( "Emergencia - Telefono " .. phoneNumber .. " - Situacion: "..tostring(input[2])..".", value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Emergencia", "\nTelefono: " .. phoneNumber .. " \nSituacion: "..tostring(input[2]).."." )
					exports.factions:createFactionBlip2(x, y, z, 1)
				end
				return false, "Emergencias: Recibido, enseguida mandamos un patrulla a su posición. Mantenga la calma."
			elseif sElegido[player] == 2 then
				local medicos = getJugadoresFaccion ( 2 )
				for key, value in ipairs( medicos ) do
					outputChatBox( "Emergencia - Telefono -" .. phoneNumber .. " - Situacion: "..tostring(input[2])..".", value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Emergencia", "\nTelefono: " .. phoneNumber .. " \nSituacion: "..tostring(input[2]).."." )
					exports.factions:createFactionBlip2(x, y, z, 2)
				end
				return false, "Emergencias: Una ambulancia se dirige a su posicion, mantenga la calma."
			elseif sElegido[player] == 3 then
				local bomberos = getJugadoresFaccion ( 2 )
				for key, value in ipairs( bomberos ) do
					outputChatBox( "Emergencia - Telefono " .. phoneNumber .. " - Situacion: "..tostring(input[2])..".", value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Emergencia", "\nTelefono: " .. phoneNumber .. " \nSituacion: "..tostring(input[2]).."." )
					exports.factions:createFactionBlip2(x, y, z, 2)
				end
				colgarLlamada(player)
				return false, "Emergencias: Un equipo de bomberos se dirige a su posicion, mantenga la calma."
			end
		end
	},
	[911] =
	{
		function( player, phoneNumber, input )
			if player then
				local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
				if nivel == 2 and not exports.objetivos:isObjetivoCompletado(19, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(19, exports.players:getCharacterID(player), player)
				end
				return true, "Emergencias: Especifique si necesita si necesita policias ((/p 1)), si necesita médicos ((/p 2)) o si necesita bomberos ((/p 3))"
			end
		end,
		true,
		function( player, phoneNumber, input )
			if input[1] == "1" or string.lower(input[1]) == "uno" then
				local policias = getJugadoresFaccion ( 1 )
				if #policias > 0 then
					sElegido[player] = 1
					return true, "Emergencias: Los Santos Police Department, indique el motivo de su emergencia"
				else
					return false, "Emergencias: En este momento todos nuestros agentes están ocupados, ¡llame mas tarde!"
				end
			elseif input[1] == "2" or string.lower(input[1]) == "dos" then
				local medicos = getJugadoresFaccion ( 2 )
				if #medicos > 0 then
					sElegido[player] = 2
					return true, "Emergencias: Los Santos Medical Department, indique el motivo de su emergencia"
				else
					return false, "Emergencias: En este momento no hay ningun médico disponible, ¡llame mas tarde!"
				end
			elseif input[1] == "3" or string.lower(input[1]) == "tres" then
				local bomberos = getJugadoresFaccion ( 2 )
				if #bomberos > 0 then
					sElegido[player] = 3
					return true, "Emergencias: Los Santos Fire Department, indique el motivo de su emergencia"
				else
					return false, "Emergencias: En este momento no hay ninguna unidad de bomberos disponible, ¡llame mas tarde!"
				end
			else
				return false, "Emergencias: No ha especificado el servicio, llame de nuevo al 112."
			end
		end,
		true,
		function( player, phoneNumber, input )
			if getElementDimension(player) == 0 then
				x, y, z = getElementPosition(player)					
			else
				x, y, z = exports.interiors:getPos(getElementDimension(player))
			end
			if sElegido[player] == 1 then
				local policias = getJugadoresFaccion ( 1 )
				for key, value in ipairs( policias ) do
					outputChatBox( "Emergencia - Telefono " .. phoneNumber .. " - Situacion: "..tostring(input[2])..".", value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Emergencia", "\nTelefono: " .. phoneNumber .. " \nSituacion: "..tostring(input[2]).."." )
					exports.factions:createFactionBlip2(x, y, z, 1)
				end
				return false, "Emergencias: Recibido, enseguida mandamos un patrulla a su posición. Mantenga la calma."
			elseif sElegido[player] == 2 then
				local medicos = getJugadoresFaccion ( 2 )
				for key, value in ipairs( medicos ) do
					outputChatBox( "Emergencia - Telefono -" .. phoneNumber .. " - Situacion: "..tostring(input[2])..".", value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Emergencia", "\nTelefono: " .. phoneNumber .. " \nSituacion: "..tostring(input[2]).."." )
					exports.factions:createFactionBlip2(x, y, z, 2)
				end
				return false, "Emergencias: Una ambulancia se dirige a su posicion, mantenga la calma."
			elseif sElegido[player] == 3 then
				local bomberos = getJugadoresFaccion ( 2 )
				for key, value in ipairs( bomberos ) do
					outputChatBox( "Emergencia - Telefono " .. phoneNumber .. " - Situacion: "..tostring(input[2])..".", value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Emergencia", "\nTelefono: " .. phoneNumber .. " \nSituacion: "..tostring(input[2]).."." )
					exports.factions:createFactionBlip2(x, y, z, 2)
				end
				colgarLlamada(player)
				return false, "Emergencias: Un equipo de bomberos se dirige a su posicion, mantenga la calma."
			end
		end
	},
	[555] =
	{
		function( player, phoneNumber, input )
			local mecanicos = getJugadoresFaccion ( 3 )
			if #mecanicos > 0 then
				return true, "LSMW operador dice: Ha llamado usted al servicio de talleres, explique brevemente el motivo de su llamada."
			else
				colgarLlamada(player)
				return false, "LSMW operador dice: En este momento no hay ningun mecanico disponible, ¡llame mas tarde!"
			end	
		end,
		true,
		function( player, phoneNumber, input )
			local mecanicos = getJugadoresFaccion ( 3 )
			if #mecanicos > 0 then
				for key, value in ipairs( mecanicos ) do
					outputChatBox( "Aviso del Taller - Telefono " .. phoneNumber .. " - Situacion: " .. input[1], value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Aviso del Taller", "\nTelefono: " .. phoneNumber .. " \nSituacion: " .. input[1] )
					x, y, z = getElementPosition(player)
					exports.factions:createFactionBlip2(x, y, z, 3)
				end
				colgarLlamada(player)
				return false, "LSMW Operador dice: Un asistente de grua se dirige a su posicion, permanezca alli."
			else
				colgarLlamada(player)
				return false, "LSMW Operador dice: En estos momentos no hay ningun mecanico disponible, ¡llame mas tarde!"
			end
		end
	},
	[666] =
	{
		function( player, phoneNumber, input )
			local juzgados = getJugadoresFaccion ( 5 )
			if #juzgados > 0 then
				return true, "Operador dice: Ha llamado usted al Gobierno de Los Santos , explique brevemente el motivo de su llamada."
			else
				colgarLlamada(player)
				return false, "Operador dice: En este momento desde el Gobierno no podemos atenderle, ¡llame mas tarde!"
			end	
		end,
		true,
		function( player, phoneNumber, input )
			local juzgados = getJugadoresFaccion ( 5 )
			if #juzgados > 0 then
				for key, value in ipairs( juzgados ) do
					outputChatBox( "Aviso de Gobierno: Telefono " .. phoneNumber .. " - Situacion: " .. input[1], value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Aviso de Gobierno", "\nTelefono: " .. phoneNumber .. " \nSituacion: " .. input[1] )
					x, y, z = getElementPosition(player)
					exports.factions:createFactionBlip2(x, y, z, 5)
				end
				colgarLlamada(player)
				return false, "Operador dice: De acuerdo, enseguida mandamos a quien corresponda del Gobierno"
			else
				colgarLlamada(player)
				return false, "Operador dice: En este momento desde el Gobierno no podemos atenderle, ¡llame mas tarde!"
			end
		end
	},
	[333] =
	{
		function( player, phoneNumber, input )
			local juzgados = getJugadoresFaccion ( 8 )
			if #juzgados > 0 then
				return true, "Operador dice: Ha llamado usted al Departamento de Justicia de Los Santos, explique brevemente el motivo de su llamada."
			else
				colgarLlamada(player)
				return false, "Operador dice: En este momento desde el Departamento de Justicia de Los Santos no podemos atenderle, ¡llame mas tarde!"
			end	
		end,
		true,
		function( player, phoneNumber, input )
			local juzgados = getJugadoresFaccion ( 8 )
			if #juzgados > 0 then
				for key, value in ipairs( juzgados ) do
					outputChatBox( "Aviso de Justicia: Telefono " .. phoneNumber .. " - Situacion: " .. input[1], value, 130, 255, 130 )
					triggerClientEvent( value, "gui:hint", value, "Aviso de Justicia", "\nTelefono: " .. phoneNumber .. " \nSituacion: " .. input[1] )
					x, y, z = getElementPosition(player)
					exports.factions:createFactionBlip2(x, y, z, 8)
				end
				colgarLlamada(player)
				return false, "Operador dice: De acuerdo, enseguida mandamos a quien corresponda del Departamento de Justicia de Los Santos"
			else
				colgarLlamada(player)
				return false, "Operador dice: En este momento desde el Departamento de Justicia de Los Santos no podemos atenderle, ¡llame mas tarde!"
			end
		end
	}
	--[[[223] = -- EJEMPLO DE FUNCION CON DOS VECES PARA PODER HABLAR. APLICAR AL 112.
	{
		function( player, phoneNumber, input )
			return true, "TEL operador dice: Ha llamado usted a Taxis El Lobo, explique brevemente el motivo de su llamada."
		end,
		true,
		function( player, phoneNumber, input )
			return true, "TEL operador dice: Repita su motivo."
		end,
		true,
		function( player, phoneNumber, input )
			outputChatBox( "SMS de ((" .. getPlayerName( player ):gsub( "_", " " ) .. ")) Taxi: Solicita un taxi - Telefono " .. phoneNumber .. " - Situacion: " .. input[2], player, 130, 255, 130 )
			return false, "TEL Operador dice: Un taxi se dirige a su posicion, permanezca alli."
		end
	}]] 
	-- [222] =
	-- {
		-- function( player, phoneNumber, input )
			-- if not getElementData(player, "llamadaATaxi") then
				-- setElementData(player, "llamadaATaxi", true)
				-- triggerEvent("onSolicitarNuevoTaxi", player)
				-- colgarLlamada(player)
				-- return false, "Operador dice: Ha llamado usted a Taxi de Fort Carson. Enseguida mandamos un taxi a su posición. ¡Espere ahí!"
			-- else
				-- colgarLlamada(player)
				-- return false, "Operador dice: Ya ha llamado hace poco a un taxi, ¡Espere ahí!"
			-- end
		-- end
	-- }
}

local function advanceService( player, text )
	local call = p[ player ]
	if call.service then
		local state = services[ call.service ][ call.serviceState ]
		if state then
			if text then
				if type( state ) == "boolean" then
					table.insert( call.input, text )
					call.serviceState = call.serviceState + 1
					advanceService( player )
				end
			else
				if type( state ) == "function" then
					local ret = { state( player, call.number, call.input ) }
					if #ret >= 2 then
						for i = 2, #ret do
							outputChatBox( ret[ i ], player, 180, 255, 180 )
						end
					end
					if ( #ret >= 1 and ret[1] == false ) or #ret == 0 then
						outputChatBox( "Ellos colgaron.", player, 180, 255, 180 )
						triggerClientEvent(player, "reproducirSonidoTLF", player, 7)
						if getElementData(player, "cabina") then
							removeElementData(player, "cabina")
							removeElementData(player, "numeroCabina")
							setElementFrozen(player, false)
						end
						p[ player ] = nil
						return
					end
				elseif type( state ) == "string" then
					outputChatBox( state, player, 180, 255, 180 )
				elseif type( state ) == "boolean" then
					return -- we need to stop here to prevent us from getting too far.
				end
				call.serviceState = call.serviceState + 1
				advanceService( player )
			end
		else
			outputChatBox( "La llamada ha finalizado.", player, 180, 255, 180 )
			p[ player ] = nil
			return
		end
	end
end

function comandoAntiguo (player, cmd)
	outputChatBox("¡Ups! /"..tostring(cmd).." es un comando antiguo de teléfono.", player, 255, 0, 0)
	outputChatBox("Abre tu Inventario y pulsa en tu teléfono móvil.", player, 255, 255, 255)
	outputChatBox("DownTown RP, innovando y renovando día tras día ;)", player, 0, 255, 0)
end
addCommandHandler("contestar", comandoAntiguo)
addCommandHandler("colgar", comandoAntiguo)

function iniciarLlamada(player, cmd, ownNumber, otherNumber)
	if exports.players:isLoggedIn(player) then
		if not ownNumber then
			outputChatBox("Sintaxis: /"..tostring(cmd).." [otro número] o /"..tostring(cmd).." [tu número] [otro número]", player, 255, 255, 255)
			return
		end
		if not otherNumber then
			otherNumber = ownNumber
			ownNumber = nil
		end
		if ownNumber then -- Número especificado del dueño, comprobar si lo tiene y realizar llamada. 
			local itemOwner, _, tableItemOwner = exports.items:has(player, 7, IMEIConLinea(tonumber(ownNumber)))
			if itemOwner then
				setElementData( player, "numeroTelefono", tonumber(ownNumber))
				if not isTelefonoEncendido(tonumber(ownNumber)) then
					outputChatBox("Este teléfono estaba apagado, se ha encendido para realizar la llamada.", player, 0, 255, 0)
					triggerEvent("onEncenderTelefono", player)
				end
				triggerClientEvent( player, "onRealizarLlamadaGUIEXT", player, otherNumber ) -- Abrimos y llamamos
				
			else
				outputChatBox("¡El número que has puesto no es tuyo! Usa /"..tostring(cmd).." para saber cómo ponerlo.", player, 255, 0, 0)
			end
		else -- Número dueño no especificado, solicitamos uno al sistema.
			local itemOwner, _, tableItemOwner = exports.items:has(player, 7)
			if itemOwner then
				ownNumber = LineaConIMEI(tableItemOwner.value)
				if ownNumber then
					setElementData( player, "numeroTelefono", tonumber(ownNumber))
					if not isTelefonoEncendido(tonumber(ownNumber)) then
						outputChatBox("Este teléfono estaba apagado, se ha encendido para realizar la llamada.", player, 0, 255, 0)
						triggerEvent("onEncenderTelefono", player)
					end
					triggerClientEvent( player, "onRealizarLlamadaGUIEXT", player, otherNumber ) -- Abrimos y llamamos
				else
					outputChatBox("Error grave, notifica a un desarrollador.", player, 255, 0, 0)
				end
			else
				outputChatBox("¡El número que has puesto no es tuyo! Usa /"..tostring(cmd).." para saber cómo ponerlo.", player, 255, 0, 0)
			end 
		end
	end
end
addCommandHandler("llamar", iniciarLlamada)
addCommandHandler("call", iniciarLlamada)

function iniciarSMS(player, cmd, otherNumber, ...)
	if exports.players:isLoggedIn(player) then
		local ownNumber
		local args = { ... }
		if not otherNumber then
			outputChatBox("Sintaxis: /"..tostring(cmd).." [otro número] [mensaje] o /"..tostring(cmd).." [otro número] [mensaje] [tu número]", player, 255, 255, 255)
			return
		end
		local posibleOwnNumber = args[#args]
		if tonumber(posibleOwnNumber) and string.len(tostring(posibleOwnNumber)) == 7 then
			if tonumber(otherNumber) ~= 112 and tonumber(otherNumber) ~= 911 and tonumber(otherNumber) ~= 444 then
				if tonumber(IMEIConLinea(tonumber(posibleOwnNumber))) > 0 then
					ownNumber = tonumber(posibleOwnNumber)
					table.remove(args)
				else
					ownNumber = nil
				end
			end
		end
		local message = table.concat( args, " " )
		if ownNumber then -- Número especificado del dueño, comprobar si lo tiene y enviar SMS.
			local itemOwner, _, tableItemOwner = exports.items:hasPhone(player, 7, IMEIConLinea(tonumber(ownNumber)))
			if itemOwner then
				setElementData( player, "numeroTelefono", tonumber(ownNumber))
				if not isTelefonoEncendido(tonumber(ownNumber)) then
					outputChatBox("Este teléfono estaba apagado, se ha encendido para enviar el SMS.", player, 0, 255, 0)
					triggerEvent("onEncenderTelefono", player)
				end
				enrutarSMS ( player, tonumber(ownNumber), tonumber(otherNumber), message, false ) -- Enviamos el SMS
			else
				outputChatBox("¡El número que has puesto no es tuyo! Usa /"..tostring(cmd).." para saber cómo ponerlo.", player, 255, 0, 0)
			end
		else -- Número dueño no especificado, solicitamos uno al sistema.
			local itemOwner, _, tableItemOwner = exports.items:has(player, 7)
			if itemOwner then
				ownNumber = LineaConIMEI(tableItemOwner.value)
				if ownNumber then
					setElementData( player, "numeroTelefono", tonumber(ownNumber))
					if not isTelefonoEncendido(tonumber(ownNumber)) then
						outputChatBox("Este teléfono estaba apagado, se ha encendido para enviar el SMS.", player, 0, 255, 0)
						triggerEvent("onEncenderTelefono", player)
					end
					enrutarSMS ( player, tonumber(ownNumber), tonumber(otherNumber), message, false ) -- Enviamos el SMS
				else
					outputChatBox("Error grave, notifica a un desarrollador.", player, 255, 0, 0)
				end
			else
				outputChatBox("¡El número que has puesto no es tuyo! Usa /"..tostring(cmd).." para saber cómo ponerlo.", player, 255, 0, 0)
			end 
		end
	end
end
addCommandHandler("sms", iniciarSMS)

--[[ 
	
	TIPOS DE LLAMADAS

	- 1 TELEFONO MÓVIL
	- 2 TELÉFONO FIJO
	- 3 TELÉFONO FIJO PÚBLICO / CABINA
	- 4 SERVICIOS ESPECIALES (EJ LLAMADA DESDE 112)
	
]]

--[[
	
	NUMEROS DE SERVICIO
	- 100 > AVISO DE LLAMADAS PERDIDAS
	- 444 > ANUNCIO DE RADIO (( /AD ))

]]
function enrutarLlamada (player, ownNumber, otherNumber, tipoLlamada)
	if exports.players:isLoggedIn( player ) then
		local otherIMEI = IMEIConLinea(otherNumber)
		if tostring(ownNumber) == tostring(otherNumber):gsub("#31#", "") then
			outputChatBox( "No puedes llamarte a ti mismo.", player, 255, 0, 0 )
			triggerClientEvent(player, "reproducirSonidoTLF", player, 7)
		else
			if services[ tonumber(otherNumber) ] then
				p[ player ] = { other = false, service = tonumber(otherNumber), number = ownNumber, state = 2, input = { }, serviceState = 1 }
				outputChatBox( "Descolgaron el teléfono.", player, 180, 255, 180 )
				advanceService( player )
				triggerClientEvent(player, "pararSonidoTLF", player)
				return
			else
				local nfijo = string.upper(string.sub(tostring(otherNumber), 1, 1))
				if nfijo and nfijo == "8" then -- La llamada es hacia una cabina.
					outputChatBox( "Lo sentimos, el número al que llama tiene restringidas las llamadas entrantes. Inténtelo más tarde.", player, 180, 255, 180 )
					triggerClientEvent(player, "reproducirSonidoTLF", player, 5)
					avisoFinal[player] = setTimer(triggerClientEvent, 7000, 1, player, "reproducirSonidoTLF", player, 7)
					return
				end
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if value ~= player then
						local noculto = string.upper(string.sub(tostring(otherNumber), 1, 4))
						if noculto and noculto == "#31#" then
							otherNumber = tonumber(string.sub(tostring(otherNumber), 5))
							if ownNumber == otherNumber then
								outputChatBox( "No puedes llamarte a ti mismo.", player, 255, 0, 0 )
								triggerClientEvent(player, "reproducirSonidoTLF", player, 7)
								return
							end
							outputChatBox( "ATENCIÓN: usted está llamando con número oculto.", player, 180, 255, 180 )
							ownNumber = "N.Privado"
							otherIMEI = IMEIConLinea(otherNumber)
						end
						if nfijo and nfijo == "7" then -- La llamada es hacia un interior, espera a que lo cojan.
							if tonumber(getElementDimension(value)) == tonumber(string.sub(tostring(otherNumber), 1)) then
								if p[player] then
									outputChatBox("Ya estás en una llamada. Usa /colgar primero.", player, 255, 0, 0)
									return
								elseif p[value] then
									outputChatBox( "Lo sentimos, el número al que llama está comunicando. Inténtelo más tarde.", player, 180, 255, 180 )
									enrutarSMS ( player, 100, otherNumber, "Aviso de Llamadas perdidas. El número "..tostring(ownNumber).." le ha llamado a la fecha que indica este SMS.", true )
									triggerClientEvent(player, "reproducirSonidoTLF", player, 6)
									return
								else
									p[ player ] = { other = value, number = ownNumber, state = 0 }
									p[ value ] = { other = player, number = otherNumber, state = 0 }
									exports.chat:me( value, "escucha el sonido del teléfono fijo y se acerca." )
									if getElementData(value, "minpa") then
										triggerClientEvent(value, "onSendNotification", value, "¡Tu teléfono móvil está sonando, vuelve a Fort Carson para contestarlo!")
									end
									outputChatBox( "El teléfono muestra en pantalla el número " .. ownNumber .. ". (( /contestar. ))", value, 180, 255, 180 )
								return
								end
							end
						else
							local otherNumber = tonumber(otherNumber)
							local otherPhone = { exports.items:hasPhone( value, 7, otherIMEI ) }
							if otherNumber and otherPhone and otherPhone[1] and isTelefonoEncendido(otherNumber) then
								if p[player] then
									outputChatBox("Ya estás en una llamada. Usa /colgar primero.", player, 255, 0, 0)
									return
								elseif p[value] then
									outputChatBox( "Lo sentimos, el número al que llama está comunicando. Inténtelo más tarde.", player, 180, 255, 180 )
									enrutarSMS ( player, 100, otherNumber, "Aviso de Llamadas perdidas. El número "..tostring(ownNumber).." le ha llamado a la fecha que indica este SMS.", true )
									triggerClientEvent(player, "reproducirSonidoTLF", player, 6)
									return
								else
									p[ player ] = { other = value, number = ownNumber, state = 0 }
									p[ value ] = { other = player, number = otherNumber, state = 0 }
									if getElementData(value, "minpa") then
										triggerClientEvent(value, "onSendNotification", value, "¡Tu teléfono móvil está sonando, vuelve a Fort Carson para contestarlo!")
									end
									exports.chat:me( value, "escucha el sonido de su teléfono móvil." )
									triggerClientEvent(value, "onRecibirLlamada", value, ownNumber)
									avisoFinal[player] = setTimer(colgarTrasEspera, 25000, 1, value, tonumber(otherNumber), tonumber(ownNumber))
									--avisoFinal[player] = setTimer(triggerClientEvent, 25000, 1, player, "reproducirSonidoTLF", player, 7)
									--outputChatBox( "El teléfono muestra en pantalla el número " .. ownNumber .. ". (( /contestar. ))", value, 180, 255, 180 )
								return
								end
							end
						end
					end
				end
			end	
			local sql = exports.sql:query_assoc_single("SELECT `registro_ID` FROM `tlf_data` WHERE `estado` = 0 AND `numero` = '"..tostring(otherNumber):gsub("#31#", "").."'")
			if sql then -- El número existe; está apagado.
				triggerClientEvent(player, "reproducirSonidoTLF", player, 3)
				outputChatBox( "Lo sentimos, el número al que llama está apagado o fuera de cobertura.", player, 180, 255, 180 )
				enrutarSMS ( player, 100, otherNumber, "Aviso de Llamadas perdidas. El número "..tostring(ownNumber).." le ha llamado a la fecha que indica este SMS.", true )
				avisoFinal[player] = setTimer(triggerClientEvent, 6000, 1, player, "reproducirSonidoTLF", player, 7)
			else -- El número no existe, se supone.
				local nfijo = string.upper(string.sub(tostring(otherNumber), 1, 1))
				if nfijo and nfijo == "7" then -- Pues sí existe, es de una casa. Que siga sonando, aunque nadie conteste.
					avisoFinal[player] = setTimer(triggerClientEvent, 25000, 1, player, "reproducirSonidoTLF", player, 7)
				else -- No existe definitivamente.
					triggerClientEvent(player, "reproducirSonidoTLF", player, 2)
					outputChatBox( "Lo sentimos, el número al que llama no existe.", player, 180, 255, 180 )
					avisoFinal[player] = setTimer(triggerClientEvent, 5000, 1, player, "reproducirSonidoTLF", player, 7)
				end
			end
		end
	end
end 
addEvent("onRealizarLlamada", true)
addEventHandler("onRealizarLlamada", getRootElement(), enrutarLlamada)

function colgarTrasEspera (player, otherNumber, ownNumber)
	if player and otherNumber and ownNumber then
		triggerClientEvent(player, "reproducirSonidoTLF", player, 7)
		enrutarSMS ( player, 100, otherNumber, "Aviso de Llamadas perdidas. El número "..tostring(ownNumber).." le ha llamado a la fecha que indica este SMS.", true )
	end
end

function enrutarSMS ( player, ownNumber, otherNumber, message, ignore )
	if exports.players:isLoggedIn( player ) then
		local ownNumber = tonumber( ownNumber )
		local otherNumber = tonumber( otherNumber )
		local otherIMEI = IMEIConLinea(otherNumber)
		-- TODO QUE NO SE PUEDA ENVIAR SMS A NUMEROS INEXISTENTES
		if ownNumber and otherNumber and message then
			if otherNumber ~= 112 and otherNumber ~= 911 and otherNumber ~= 444 then
				if not ignore then
					exports.chat:me( player, "escribe un SMS desde su teléfono móvil." )
					outputChatBox( "SMS para " .. otherNumber .. ": " .. message, player, 130, 255, 130 )
				end
				exports.sql:query_insertid("INSERT INTO `tlf_sms` (`sms_ID`, `tlf_receptor`, `tlf_emisor`, `msg`) VALUES (NULL, '"..tostring(otherNumber).."', '"..tostring(ownNumber).."', '"..tostring(message).."');")
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if exports.items:hasPhone(value, 7, otherIMEI) then
						local numero = LineaConIMEI(otherIMEI)
						if isTelefonoEncendido(tonumber(numero)) then
							exports.chat:me( value, "recibe un mensaje de texto." )
							triggerClientEvent( value, "gui:hint", value, "Teléfono: SMS recibido", "Usa tu teléfono móvil para poder ver el SMS.", 4 )
							if getElementData(value, "minpa") then
								triggerClientEvent(value, "onSendNotification", value, "Acabas de recibir un SMS en DownTown. ¡Vuelve para leerlo!")
							end
						end
					return
					end
				end
			else
				if otherNumber == 444 then
					exports.chat:me( player, "escribe un SMS desde su teléfono móvil." )
					outputChatBox( "Anuncio para Radio: " .. message, player, 130, 255, 130 )
					if exports.players:takeMoney( player, 30 ) then
						exports.factions:giveFactionPresupuesto( 4, 60 )
						for key, value in ipairs( getElementsByType( "player" ) ) do
							if hasObjectPermissionTo( value, "command.modchat", false ) then
								outputChatBox( "[Anuncio Radio] ["..getPlayerName(player):gsub("_"," ").."] " .. message, value, 106, 255, 255 )
							else
								outputChatBox( "[Anuncio Radio] " .. message .. ".", value, 106, 255, 255 )
							end				
						end
							outputChatBox( "Se te ha cobrado 30 dólares por el envío del anuncio.", player, 0, 255, 0 )
							exports.logs:addLogMessage("anuncio", getPlayerName(player).." ha puesto un AD que dice: "..message.." .\n")
					else
						outputChatBox( "No tienes dinero suficiente para enviar un anuncio. Cuesta 30 dólares.", player, 255, 0, 0 )
					end
				else
					for key, value in ipairs( getJugadoresFaccion ( 1 ) ) do
						local x, y, z
						if getElementDimension(player) == 0 then
							x, y, z = getElementPosition(player)					
						else
							x, y, z = exports.interiors:getPos(getElementDimension(player))
						end
						outputChatBox( "Emergencia - Telefono " .. ownNumber .. " - Situacion: "..tostring(message)..".", value, 130, 255, 130 )
						triggerClientEvent( value, "gui:hint", value, "Emergencia", "\nTelefono: " .. ownNumber .. " (( " .. getPlayerName( player ):gsub( "_", " " ) .. " ))\nSituacion: "..tostring(message).."." )
						exports.factions:createFactionBlip2(x, y, z, 1)
					end
					exports.chat:me( value, "escribe un SMS desde su teléfono móvil." )
					enrutarSMS ( player, 112, ownNumber, "Emergencia Recibida. Le informamos que hemos mandado un patrulla a su posición.", true )
				end
			end
		end
	end
end
addEvent("onRealizarSMS", true)
addEventHandler("onRealizarSMS", getRootElement(), enrutarSMS)


function realizarLlamadaFijo ( player, commandName, otherNumber )
	if exports.players:isLoggedIn( player ) then
		local interiorID = getElementDimension(player)
		if not exports.items:has(player, 2, interiorID) then outputChatBox("No tienes llave de este interior.", player, 255, 0, 0) return end
		local ownNumber = tonumber("7"..tostring(addZero(interiorID, 6)))
		if otherNumber then
			enrutarLlamada(player, ownNumber, otherNumber, 2)
		else
			outputChatBox( "Sintaxis: /".. commandName .." [número]", player, 255, 255, 255 )
		end
	end
end
addCommandHandler("llamarfijo", realizarLlamadaFijo)
addCommandHandler("llamarint", realizarLlamadaFijo)


function realizarLlamadaFijoCabina ( player, otherNumber )
	ownNumber = tonumber(getElementData(player, "numeroCabina"))
	enrutarLlamada(player, ownNumber, otherNumber, 3)
end
addEvent("llamadaCabina", true)
addEventHandler("llamadaCabina", root, realizarLlamadaFijoCabina)


function contestarLlamada( player )
	if isTimer(avisoFinal[player]) then killTimer(avisoFinal[player]) avisoFinal[player] = nil end
	if isTimer(avisoFinal[p[ player ].other]) then killTimer(avisoFinal[p[ player ].other]) avisoFinal[p[ player ].other] = nil end
	if p[ player ] and p[ player ].state == 0 then
		exports.chat:me( player, "contesta la llamada." )
		triggerClientEvent(p[ player ].other, "pararSonidoTLF", p[ player ].other)
		outputChatBox( "Llamada activa. (( /p para hablar ))", p[ player ].other, 180, 255, 180 )
			
		p[ p[ player ].other ].state = 1
		p[ player ].state = 1
	end
end
addEvent("onContestarLlamada", true)
addEventHandler("onContestarLlamada", getRootElement(), contestarLlamada)

 
addCommandHandler( "p" ,
	function( player, commandName, ... )
		if ( ... ) then
			if p[ player ] then
				local message = table.concat( { ... }, " " )
				if not p[ player ].state then return end
				if p[ player ].state == 1 then
					outputChatBox( "-" .. p[ player ].number .. " dice: " .. message, p[ player ].other, 180, 255, 180 )				
					exports.chat:localizedMessage( player, " " .. getPlayerName( player ):gsub("_", " ") .. " dice por teléfono: ", message, 230, 230, 230, false, 127, 127, 127 )
				elseif p[ player ].state == 2 then
					advanceService( player, message )
					exports.chat:localizedMessage( player, " " .. getPlayerName( player ):gsub("_", " ") .. " dice por teléfono: ", message, 230, 230, 230, false, 127, 127, 127 )
				end
			else
				outputChatBox( "No estás en una llamada.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [decir por teléfono]", player, 255, 255, 255 )
		end
	end
)


function colgarLlamada( player, tipo )
	if isTimer(avisoFinal[player]) then killTimer(avisoFinal[player]) avisoFinal[player] = nil end
	if p[ player ] then
		if not tipo then
			triggerClientEvent(player, "pararSonidoTLF", player)
		end
		if getElementData(player, "cabina") then
			removeElementData(player, "cabina")
			removeElementData(player, "numeroCabina")
			setElementFrozen(player, false)
		end
		if p[ player ] and p[ player ].other then
			if not tipo then
				triggerClientEvent(p[ player ].other, "reproducirSonidoTLF", p[ player ].other, 7)
			else
				triggerClientEvent(p[ player ].other, "onCerrarTelefono", p[ player ].other)
			end
			if getElementData(p[ player ].other, "cabina") then
				removeElementData(p[ player ].other, "cabina")
				removeElementData(p[ player ].other, "numeroCabina")
				setElementFrozen(p[ player ].other, false)
			end
		end
		p[ p[ player ].other ] = nil
		p[ player ] = nil
	end
end
addEvent("onColgarLlamada", true)
addEventHandler("onColgarLlamada", getRootElement(), colgarLlamada)
 

function llamadaCaida( )
	if p[ source ] then
		outputChatBox( "El teléfono perdió la conexión...", source, 255, 0, 0 )
		colgarLlamada(source)
			
	end
	triggerClientEvent(source, "onCerrarTelefono", source)
end
addEventHandler( "onPlayerQuit", root, llamadaCaida)
addEventHandler( "onCharacterLogin", root, llamadaCaida)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		for player, data in pairs( p ) do
			if data.state == 1 or data.state == 2 then -- on a call
				outputChatBox( "El teléfono perdió la conexión...", player, 255, 0, 0 )
				colgarLlamada(player)
			end
		end
		p = { }
	end
)

function llamarDesdeFaccion ( player, commandName, otherNumber )
	if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 2) then -- 112 PD
		ownNumber = 112
		ownNumber = tonumber(ownNumber)
	elseif exports.factions:isPlayerInFaction(player, 3) then -- 555 TALLER
		ownNumber = 555
		ownNumber = tonumber(ownNumber)
	elseif exports.factions:isPlayerInFaction(player, 4) then -- 444 NOTICIAS
		ownNumber = 444
		ownNumber = tonumber(ownNumber)
	elseif exports.factions:isPlayerInFaction(player, 5) then -- 666 GOBIERNO
		ownNumber = 666
		ownNumber = tonumber(ownNumber)
	elseif exports.factions:isPlayerInFaction(player, 8) then -- 333 JUSTICIA
		ownNumber = 333
		ownNumber = tonumber(ownNumber)
	else
		outputChatBox("Tu facción no tiene ningún número asignado. Contacta con un staff.", player, 255, 0, 0)
		return
	end
	if otherNumber and tonumber(otherNumber) then
		enrutarLlamada(player, ownNumber, otherNumber, 4)
	else
		outputChatBox("Sintaxis: /llamarf [otro número]", player, 255, 255, 255)
	end
end
addCommandHandler("llamarf", llamarDesdeFaccion)
 
function numerosDeServicio(player)
	outputChatBox("Servicios de Emergencias/Policia/Médicos/Bomberos: 112 o 911", player, 0, 255, 0)
	outputChatBox("Los Santos Motor Workshop: 555", player, 0, 255, 0)
	outputChatBox("Los Santos News Department: 444", player, 0, 255, 0)
	outputChatBox("Gobierno de Los Santos: 666", player, 0, 255, 0)
	outputChatBox("Justicia de Los Santos: 333", player, 0, 255, 0)
end
addCommandHandler("servicios", numerosDeServicio)
addCommandHandler("numeros", numerosDeServicio)

function localizarNumero (player, cmd, otherNumber)
	if exports.factions:isPlayerInFaction(player, 1) and otherNumber then
		encontrado = false
		local message = "Aquí "..getPlayerName(player):gsub("_", " ")..", solicito la posición del número "..tostring(otherNumber).."."
		exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) " .. getPlayerName( player ):gsub("_", " ") .. ": " .. message, 127, 127, 255 )
			for key, value in ipairs( getElementsByType( "player" ) ) do
				if value ~= player then
					local nfijo = string.upper(string.sub(tostring(otherNumber), 1, 5))
					if nfijo and nfijo == "7" then -- Localizando un interior.
						encontrado = true
						local interiorID = tonumber(string.sub(tostring(otherNumber), 1))
						local x, y, z = exports.interiors:getPos(interiorID)
						exports.factions:createFactionBlip2( x, y, z, 1 )
						exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) Central: Recibido " .. getPlayerName( player ):gsub("_", " ") .. ", enseguida le mando la posición a su GPS.", 127, 127, 255 )
						return
					elseif nfijo and nfijo == "8" then -- Localizando una cabina.
						local cabinaID = tonumber(string.sub(tostring(otherNumber), 1))
						local x, y, z = exports.cabinas:getPos(cabinaID)
						exports.factions:createFactionBlip2( x, y, z, 1 )
						exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) Central: Recibido " .. getPlayerName( player ):gsub("_", " ") .. ", enseguida le mando la posición a su GPS.", 127, 127, 255 )
						return
					else
						local otherIMEI = IMEIConLinea(tonumber(otherNumber))
						local otherPhone = { exports.items:hasPhone( value, 7, otherIMEI ) }
						if otherPhone and otherPhone[1] and isTelefonoEncendido(tonumber(otherNumber)) then
							encontrado = true
							if getElementDimension(value) == 0 then
								x, y, z = getElementPosition(value)
							else
								x, y, z = exports.interiors:getPos(getElementDimension(value))
							end
							exports.factions:createFactionBlip( value, x, y, z, 1 )
							exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) Central: Recibido " .. getPlayerName( player ):gsub("_", " ") .. ", enseguida le mando la posición a su GPS.", 127, 127, 255 )
							return
						end
					end
				end
			end
		if encontrado == false then
			exports.factions:sendMessageToFaction( 1, "(( " .. exports.factions:getFactionTag( 1 ) .. " )) Central: Negativo " .. getPlayerName( player ):gsub("_", " ") .. ", no he podido obtener la posición del número solicitado.", 127, 127, 255 )
		end
	else
		outputChatBox("No eres policía.", player, 255, 0, 0)
	end
end	
addCommandHandler("localizarnumero", localizarNumero)

function avisoTaxis(player)
	if player then
		if not getElementData(player, "llamadaATaxi") then
			setElementData(player, "llamadaATaxi", true)
			triggerEvent("onSolicitarNuevoTaxi", player)
			outputChatBox("Acabas de pedir un taxi en tu posición, enseguida llega.", player, 0, 255, 0)
		else
			outputChatBox("Por favor, espera a que llegue el taxi pedido.", player, 255, 0, 0)
		end
	end
end
addCommandHandler("taxi", avisoTaxis)

function solicitarTablasNecesarias ()
	if source then
		local numero = getElementData(source, "numeroTelefono")
		if numero then
			local tabla_sms = exports.sql:query_assoc("SELECT * FROM tlf_sms WHERE tlf_receptor = "..tostring(numero))
			local tabla_contactos = exports.sql:query_assoc("SELECT * FROM tlf_contactos WHERE tlf_titular = "..tostring(numero))
			local tabla_vehiculos = exports.sql:query_assoc("SELECT vehicleID, model FROM vehicles WHERE characterID = "..exports.players:getCharacterID(source))
			local saldo_bancario = exports.sql:query_assoc_single("SELECT banco FROM characters WHERE characterID = "..exports.players:getCharacterID(source))
			local agenda = exports.sql:query_assoc_single("SELECT agenda FROM tlf_data WHERE numero = "..tostring(numero))
			triggerClientEvent(source, "onEnviarTablasNecesarias", source, tabla_sms, tabla_contactos, tabla_vehiculos, tonumber(saldo_bancario.banco), tostring(agenda.agenda))
		end
	end
end
addEvent("onSoliciarTablasNecesarias", true)
addEventHandler("onSoliciarTablasNecesarias", getRootElement(), solicitarTablasNecesarias)

function anadirContacto (nombre, telefono)
	if source then
		local numero = getElementData(source, "numeroTelefono")
		if numero then
			exports.sql:query_insertid("INSERT INTO `tlf_contactos` (`contacto_ID`, `tlf_titular`, `nombre`, `tlf_contacto`) VALUES (NULL, '"..tostring(numero).."', '"..tostring(nombre).."', '"..tostring(telefono).."');")
		end
	end
end
addEvent("onAñadirContacto", true)
addEventHandler("onAñadirContacto", getRootElement(), anadirContacto)

function eliminarContacto (contactoID)
	if source then
		if contactoID then
			exports.sql:query_free("DELETE FROM `tlf_contactos` WHERE `contacto_ID` = "..tostring(contactoID))
		end
	end
end
addEvent("onEliminarContacto", true)
addEventHandler("onEliminarContacto", getRootElement(), eliminarContacto)

function eliminarSMS (smsID)
	if source then
		if smsID then
			exports.sql:query_free("DELETE FROM `tlf_sms` WHERE `sms_ID` = "..tostring(smsID))
		end
	end
end
addEvent("onEliminarSMS", true)
addEventHandler("onEliminarSMS", getRootElement(), eliminarSMS)

function actualizarAgendaTLF (texto)
	local numero = getElementData(source, "numeroTelefono")
	if source and texto and numero then
		exports.sql:query_free("UPDATE `tlf_data` SET `agenda` = '"..tostring(texto).."' WHERE `numero` = "..tostring(numero))
		outputChatBox("Has actualizado tu agenda correctamente.", source, 0, 255, 0)
	else
		outputChatBox("Se ha producido un error grave al actualizar tu agenda.", source, 255, 0, 0)
	end
end
addEvent("onActualizarAgendaMovil", true)
addEventHandler("onActualizarAgendaMovil", getRootElement(), actualizarAgendaTLF)        
 
function apagarTelefono ()
	if source then
		local numero = getElementData(source, "numeroTelefono")
		if numero then
			exports.sql:query_free("UPDATE `tlf_data` SET `apagado` = 1 WHERE `numero` = "..tostring(numero))
		end
	end
end
addEvent("onApagarTelefono", true)
addEventHandler("onApagarTelefono", getRootElement(), apagarTelefono)

function encenderTelefono ()
	if source then
		local numero = getElementData(source, "numeroTelefono")
		if numero then
			exports.sql:query_free("UPDATE `tlf_data` SET `apagado` = 0 WHERE `numero` = "..tostring(numero))
		end
	end
end
addEvent("onEncenderTelefono", true) 
addEventHandler("onEncenderTelefono", getRootElement(), encenderTelefono)

function reguladorObjetivosFB(score)
	if source and score then
		local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(source))
		if nivel == 3 and score == 10 and not exports.objetivos:isObjetivoCompletado(24, exports.players:getCharacterID(source)) then
			exports.objetivos:addObjetivo(24, exports.players:getCharacterID(source), source)
		end
		if nivel == 3 and score == 20 and not exports.objetivos:isObjetivoCompletado(25, exports.players:getCharacterID(source)) then
			exports.objetivos:addObjetivo(25, exports.players:getCharacterID(source), source)
		end
		if nivel == 4 and score == 30 and not exports.objetivos:isObjetivoCompletado(41, exports.players:getCharacterID(source)) then
			exports.objetivos:addObjetivo(41, exports.players:getCharacterID(source), source)
		end
		if nivel == 4 and score == 50 and not exports.objetivos:isObjetivoCompletado(42, exports.players:getCharacterID(source)) then
			exports.objetivos:addObjetivo(42, exports.players:getCharacterID(source), source)
		end
	end
end
addEvent("regulaObjetivoFB", true)
addEventHandler("regulaObjetivoFB", getRootElement(), reguladorObjetivosFB)