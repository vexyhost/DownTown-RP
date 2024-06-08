-- ATENCION PENDIENTE REFORMAR SISTEMA ENTERO
-- HAY MUCHO DESORDEN!!!!
 
local vr = {}
local ir = {}
local altavoces = {}
local localmu = {}
local busqueda = {}
--local url_servicio = "https://www.googleapis.com/youtube/v3/search?part=snippet&safeSearch=none&regionCode=US&key=-TU-TOKEN-API-&type=video&maxResults=1&q="
local url_servicio = "https://invidio.us/api/v1/search?type=video&q="

function urlencode(str)
   if (str) then
      str = string.gsub (str, "ñ", "n")
	  str = string.gsub (str, "á", "a")
	  str = string.gsub (str, "é", "e")
	  str = string.gsub (str, "í", "i")
	  str = string.gsub (str, "ó", "o")
	  str = string.gsub (str, "ú", "u")
	  str = string.gsub (str, "Á", "A")
	  str = string.gsub (str, "É", "E")
	  str = string.gsub (str, "Í", "I")
	  str = string.gsub (str, "Ó", "O")
	  str = string.gsub (str, "Ú", "U")
	  str = string.gsub (str, " ", "_")
   end
   return str    
end

function toggleRadio (player, cmd, ...)
	local queue = 'cola'..tostring(getElementData(player, "playerid"))
	exports.logs:addLogMessage("radiobug/"..tostring(getPlayerName(player)), "-")
	if tostring(cmd) == "radio" then
		local vehicle = getPedOccupiedVehicle ( player )
		local dimension = getElementDimension ( player )
		if vehicle then
			if getElementModel(vehicle) == 539 then outputChatBox("No puedes usar /radio en este vehículo.", player, 255, 0, 0) return end
			if vr[vehicle] and vr[vehicle] == 101 then
				outputChatBox("Hay una búsqueda de canción pendiente, espera por favor.", player, 255, 0, 0)
				--setTimer(function(vehicle) vr[vehicle] = nil end, 60000, 1, vehicle)
				return
			end
			if vr[vehicle] and vr[vehicle] >= 1 then
				if not (...) then
					exports.chat:me(player, "apaga la radio del vehículo.")
					triggerClientEvent ( "onStopPlayVehicleMusic", getRootElement(), vehicle, vr[vehicle] )
					vr[vehicle] = nil
				else
					triggerClientEvent ( "onStopPlayVehicleMusic", getRootElement(), vehicle, vr[vehicle] )
					vr[vehicle] = nil
					local palabras2 = urlencode(tostring(table.concat({...}, "%20")))
					outputChatBox("Estamos buscando la canción, espera por favor.", player, 255, 255, 255)
					vr[vehicle] = 101
					fetchRemote(url_servicio..tostring(palabras2), tostring(queue), 1, 60000, solicitarLink, nil, false, player, vehicle)
				end
			else
				if not (...) then
					exports.chat:me(player, "enciende la radio del vehículo.")
					outputChatBox("Usa /r+ o /r- para ir cambiando la emisora.", player, 0, 255, 0)
					outputChatBox("Tambien puedes usar /radio [artista/cancion] para escucharla.", player, 0, 255, 0)
					vr[vehicle] = 1
					triggerClientEvent ( "onStartPlayVehicleMusic", getRootElement(), vehicle, vr[vehicle], player )
				else
					local palabras2 = urlencode(tostring(table.concat({...}, "%20")))
					exports.chat:me(player, "enciende la radio del vehículo.")
					outputChatBox("Estamos buscando la canción, espera por favor.", player, 255, 255, 255)
					vr[vehicle] = 101
					fetchRemote(url_servicio..tostring(palabras2), tostring(queue), 1, 60000, solicitarLink, nil, false, player, vehicle)
				end
			end
		end
		if dimension > 0 and not vehicle then
			local radio, radioID = exports.muebles:radioCercana(player)
			if not radio then outputChatBox("No estás cerca de una radio.", player, 255, 0, 0) return end
			if ir[dimension] and ir[dimension] == 101 then
				outputChatBox("Hay una búsqueda de canción pendiente, espera por favor.", player, 255, 0, 0)
				--setTimer(function(dimension) ir[dimension] = nil end, 60000, 1, vehicle)
				return
			end
			if ir[dimension] and ir[dimension] >= 1 then
				if not (...) then
					exports.chat:me(player, "apaga la radio.")
					triggerClientEvent ( "onStopPlayInteriorMusic", getRootElement(), dimension, ir[dimension] )
					ir[dimension] = nil
				else
					triggerClientEvent ( "onStopPlayInteriorMusic", getRootElement(), dimension, ir[dimension] )
					ir[dimension] = nil
					local palabras2 = urlencode(tostring(table.concat({...}, "%20")))
					outputChatBox("Estamos buscando la canción, espera por favor.", player, 255, 255, 255)
					ir[dimension] = 101
					fetchRemote(url_servicio..tostring(palabras2), tostring(queue), 1, 60000, solicitarLink, nil, false, player, dimension)
				end
			else
				if not (...) then
					exports.chat:me(player, "enciende la radio y escucha la música.")
					outputChatBox("Usa /r+ o /r- para ir cambiando la emisora.", player, 0, 255, 0)
					outputChatBox("Tambien puedes usar /radio [artista/cancion] para escucharla.", player, 0, 255, 0)
					ir[dimension] = 1
					triggerClientEvent ( "onStartPlayInteriorMusic", getRootElement(), dimension, ir[dimension], player )
				else
					local palabras2 = urlencode(tostring(table.concat({...}, "%20")))
					exports.chat:me(player, "enciende la radio y escucha la música.")
					outputChatBox("Estamos buscando la canción, espera por favor.", player, 255, 255, 255)
					ir[dimension] = 101
					fetchRemote(url_servicio..tostring(palabras2), tostring(queue), 1, 60000, solicitarLink, nil, false, player, dimension)				
				end
			end
		else
			if not vehicle then
				outputChatBox("Debes de estar en un interior o en un vehículo", player, 255, 0, 0)
			end
		end
	elseif tostring(cmd) == "radiostaff" then
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		if altavoces[player] then 
				triggerClientEvent ( "onStopPlayVehicleMusic", getRootElement(), altavoces[player], vr[altavoces[player]] )
				destroyElement(altavoces[player])
				vr[altavoces[player]] = nil
				altavoces[player] = nil
			return
		end
		local x, y, z = getElementPosition ( player )
		altavoces[player] = createObject(2232, x, y-1, z-0.45)
		setElementDimension(altavoces[player],getElementDimension (player))
	    setElementInterior(altavoces[player],getElementInterior (player))
		if vr[altavoces[player]] and vr[altavoces[player]] >= 1 then
			triggerClientEvent ( "onStopPlayVehicleMusic", getRootElement(), altavoces[player], vr[altavoces[player]] )
			vr[altavoces[player]] = nil
		else
			if not (...) then
				outputChatBox("Usa /rs+ o /rs- para ir cambiando la emisora.", player, 0, 255, 0)
				vr[altavoces[player]] = 1
				triggerClientEvent ( "onStartPlayVehicleMusic", getRootElement(), altavoces[player], vr[altavoces[player]], player )
			else
				local palabras2 = urlencode(tostring(table.concat({...}, "%20")))
				outputChatBox("Estamos buscando la canción, espera por favor.", player, 255, 255, 255)
				outputChatBox("Usa /radiostaff para apagar el altavoz staff.", player, 255, 255, 0)
				vr[altavoces[player]] = 101
				fetchRemote(url_servicio..tostring(palabras2), tostring(queue), 1, 60000, solicitarLink, nil, false, player, altavoces[player])
			end
		end
	end
end
addCommandHandler("radio", toggleRadio)
addCommandHandler("radiostaff", toggleRadio)

function toggleRadioLocal (player, cmd, ...)
	local queue = 'cola'..tostring(getElementData(player, "playerid"))
	if localmu[player] then 
		triggerClientEvent ( player, "onStopPlayLocalMusic", player )
		vr[localmu[player]] = nil
		localmu[player] = nil
		return
	end
	if not (...) then
		outputChatBox("Usa /radiolocal [artista/cancion].", player, 0, 255, 0)
	else
		local palabras2 = urlencode(tostring(table.concat({...}, "%20")))
		outputChatBox("Estamos buscando la canción, espera por favor.", player, 255, 255, 255)
		fetchRemote(url_servicio..tostring(palabras2), tostring(queue), 1, 60000, solicitarLink, nil, false, player, player)
	end
end
addCommandHandler("radiolocal", toggleRadioLocal)

function toggleRadioLocalCac (player, cmd, ...)
	local queue = 'cola'..tostring(getElementData(player, "playerid"))
	if not (...) then
		outputChatBox("Usa /radiolocal [artista/cancion].", player, 0, 255, 0)
	else
		local palabras2 = urlencode(tostring(table.concat({...}, "%20")))
		outputChatBox("Estamos buscando la canción, espera por favor.", player, 255, 255, 255)
		fetchRemote(url_servicio..tostring(palabras2), tostring(queue), 1, 60000, solicitarLink, nil, false, player, player)
	end
end
addCommandHandler("radioc", toggleRadioLocalCac)

function radioMovil(palabras)
	if client then
		local palabras2 = urlencode(tostring(palabras))
		local queue = 'cola'..tostring(getElementData(client, "playerid"))
		outputChatBox("Estamos buscando la canción, espera por favor.", client, 255, 255, 255)
		fetchRemote(url_servicio..tostring(palabras2), tostring(queue), 1, 60000, solicitarLink, nil, false, client, client)
	end
end
addEvent("onRadioLocal", true)
addEventHandler("onRadioLocal", getRootElement(), radioMovil)
  
function solicitarLink (data, errorCode, player, objeto)
	if tonumber(errorCode) and tonumber(errorCode) == 0 and data and fromJSON(data) then
		local tabla = fromJSON(data)
		codYT = tabla["videoId"]
		titYT = tostring(tabla["title"])
		duration = tonumber(tabla["lengthSeconds"]) -- lengthSeconds
		if duration > 480 then
			outputChatBox("La canción encontrada supera los 8 minutos. Busca una más corta.", player, 255, 0, 0)
			vr[objeto] = nil
			ir[objeto] = nil
			return
		end
		local queue = 'cola'..tostring(getElementData(player, "playerid"))
		fetchRemote("http://IP-DESCARGADOR-YT-A-MP3/yt.php?codigoYT="..tostring(codYT), tostring(queue), 1, 60000, solicitarLink2, nil, false, player, objeto, titYT, tostring(codYT))
		outputDebugString("Solicitarlink2 en curso..")
	else
		outputChatBox("Se ha producido un error. Inténtalo de nuevo.", player, 255, 0, 0)
		outputChatBox("Error: "..tostring(errorCode), player, 255, 0, 0)
		outputChatBox("Te informamos que hemos abierto incidencia sobre este error con el fin de solucionarlo.", player, 255, 0, 0)
		exports.logs:addLogMessage("averiaradio", "Cod error:1-"..tostring(errorCode).." - Jugador: "..getPlayerName(player).." - Respuesta:"..tostring(data))
		vr[objeto] = nil
		ir[objeto] = nil
	end 
end

function solicitarLink2 (data, errorCode, player, objeto, tit, codYT)
	if errorCode == 0 and data and fromJSON(data) then
		local tabla = fromJSON(data)
		local rutaFile = tostring(tabla["link"])
		outputDebugString(getPlayerName(player).." - "..tostring(tit))
		if isElement(objeto) and getElementType(objeto) == "vehicle" and tabla then
			vr[objeto] = 100
			triggerClientEvent ( "onStartPlayVehicleMusic", getRootElement(), objeto, rutaFile, player , tostring(tit))
		elseif isElement(objeto) and getElementType(objeto) == "object" and tabla then -- Radiostaff
			vr[objeto] = 100
			triggerClientEvent ( "onStartPlayVehicleMusic", getRootElement(), objeto, rutaFile, player , tostring(tit))
		elseif isElement(objeto) and getElementType(objeto) == "player" and tabla then -- RadioLocal
			vr[objeto] = 100
			triggerClientEvent ( player, "onStartPlayLocalMusic", player, objeto, rutaFile, player , tostring(tit))
		else -- Interior
			if tabla then
				ir[objeto] = 100
				triggerClientEvent ( "onStartPlayInteriorMusic", getRootElement(), objeto, rutaFile, player , tostring(tit))
			end
		end
	else
		if errorCode == 28 then
			outputChatBox("Fix temporal error 28 en marcha.", player, 255, 0, 0)
			vr[objeto] = nil
			ir[objeto] = nil
			executeCommandHandler("radio", player, tostring(codYT))
		else
			outputChatBox("Se ha producido un error. Inténtalo de nuevo.", player, 255, 0, 0)
			outputChatBox("Error: "..tostring(errorCode), player, 255, 0, 0)
			outputChatBox("Te informamos que hemos abierto incidencia sobre este error con el fin de solucionarlo.", player, 255, 0, 0)
			exports.logs:addLogMessage("averiaradio", "Cod error:2-"..tostring(errorCode).." - Jugador: "..getPlayerName(player).." - Respuesta:"..tostring(data))
			vr[objeto] = nil
			ir[objeto] = nil
		end
	end
end

function radioMas ( player, cmd )
	if altavoces[player] and tostring(cmd) == "rs+" then
		vehicle = altavoces[player]
	else
		vehicle = getPedOccupiedVehicle ( player )
	end
	local dimension = getElementDimension ( player )
	if vehicle then
		local old = vr[vehicle]
		if type(old) == "number" then
			if old <= 22 then
				vr[vehicle] = old + 1
			else
				vr[vehicle] = 1
			end
		else
			vr[vehicle] = 1
		end
		triggerClientEvent ( "onChangeVehicleMusic", getRootElement(), vehicle, vr[vehicle] )
	end
	if dimension > 0 and not vehicle then
		local old = ir[dimension]
		if type(old) == "number" then
			if old <= 22 then
				ir[dimension] = old + 1
			else
				ir[dimension] = 1
			end
		else
			ir[dimension] = 1
		end
		triggerClientEvent ( "onChangeInteriorMusic", getRootElement(), dimension, ir[dimension], player )
	else
		if not vehicle then
			outputChatBox("Debes de estar en un interior o en un vehículo", player, 255, 0, 0)
		end
	end
end
addCommandHandler("r+", radioMas)
addCommandHandler("rs+", radioMas)

function radioMenos ( player, cmd )
	if altavoces[player] and tostring(cmd) == "rs-" then
		vehicle = altavoces[player]
	else
		vehicle = getPedOccupiedVehicle ( player )
	end
	local dimension = getElementDimension ( player )
	if vehicle then
		local old = vr[vehicle]
		if type(old) == "number" then
			if old > 2 then
				vr[vehicle] = old - 1
			else
				vr[vehicle] = 23
			end
		else
			vr[vehicle] = 1
		end
		triggerClientEvent ( "onChangeVehicleMusic", getRootElement(), vehicle, vr[vehicle] )
	end
	if dimension > 0 and not vehicle then
		local old = ir[dimension]
		if type(old) == "number" then
			if old > 2 then
				ir[dimension] = old - 1
			else
				ir[dimension] = 23
			end
		else
			ir[dimension] = 1
		end
		triggerClientEvent ( "onChangeInteriorMusic", getRootElement(), dimension, ir[dimension], player )
	else
		if not vehicle then
			outputChatBox("Debes de estar en un interior o en un vehículo", player, 255, 0, 0)
		end
	end
end
addCommandHandler("r-", radioMenos)
addCommandHandler("rs-", radioMenos)

function ytQuitado(player)
	outputChatBox("El comando /youtube ha sido eliminado. Nuevo sistema:", player, 255, 255, 255)
	outputChatBox("/radio [artista/cancion]. No importa el orden. También puedes usar parte de la letra.", player, 255, 255, 255)
end
addCommandHandler("yt", ytQuitado)
addCommandHandler("youtube", ytQuitado)