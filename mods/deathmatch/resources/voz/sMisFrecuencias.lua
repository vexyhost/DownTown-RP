local venFrecAb = {}
local tablasBroadcast = {}
local tablas

function abrirMisFrecuencias(player)
	if exports.players:isLoggedIn(player) then
		if not venFrecAb[player] then
			local factions = exports.factions:getPlayerFactions(player)
			triggerClientEvent ( player, "onAbrirMisFrecuencias", player, factions )
			venFrecAb[player] = true
		else
			triggerClientEvent ( player, "onCerrarMisFrecuencias", player )
			venFrecAb[player] = nil
		end
	end
end
addCommandHandler("misf", abrirMisFrecuencias)
addCommandHandler("misfrecuencias", abrirMisFrecuencias)

function conectarAFrecuencia (frecuenciaID, frecuenciaName)
	if source and exports.players:isLoggedIn(source) and frecuenciaID then
		venFrecAb[source] = nil
		if tonumber(frecuenciaID) >= 100 then
			if conectarJugadorAFrecuencia(source, frecuenciaID) then
				outputChatBox("Canal de voz conectado a ["..tostring(frecuenciaID).."] '"..frecuenciaName.."'.", source, 0, 255, 0)
			end
		elseif tonumber(frecuenciaID) == -1 then
			local playerID = getElementData(source, "playerid")
			if conectarJugadorAFrecuencia(source, 2000+playerID) then
				outputChatBox("Te has desconectado del servicio de voz.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("onConectarAFrecuencia", true)
addEventHandler("onConectarAFrecuencia", getRootElement(), conectarAFrecuencia)

function quitarVozAlCambiarPJ()
	triggerEvent("onConectarAFrecuencia", source, -1, "OFFSERVICE")
end
addEventHandler("onCharacterLogout", getRootElement(), quitarVozAlCambiarPJ)

function conectarJugadorAFrecuencia(jugador, frecuencia, ignoreAviso)
	if jugador and tonumber(frecuencia) then
		-- Creamos las tablas pertinentes
		local tablaBroadcast = {}
		local tablaIgnore = {}
		-- Asignamos a ese jugador el elementData con la nueva frecuencia
		local frecuencia_old = getElementData(jugador, "frecuencia.voz")
		setElementData(jugador, "frecuencia.voz", tonumber(frecuencia))
		if frecuencia_old and tonumber(frecuencia_old) and tonumber(frecuencia_old) ~= tonumber(frecuencia) and tonumber(frecuencia_old) ~= -1 then 
			-- Solicitamos reconexión a dicha frecuencia al resto de jugadores para que sepan que uno salió.
			for k, v in ipairs(getElementsByType("player")) do
				if exports.players:isLoggedIn(v) and v~= jugador then
					if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia_old) then
						conectarJugadorAFrecuencia(v, frecuencia_old, true)
						outputChatBox(getPlayerName(jugador):gsub("_", " ").." ha salido de tu frecuencia.", v, 0, 255, 0)
					end
				end
			end
		end
		-- Asignamos también el elementData para whisper
		if tonumber(frecuencia) ~= -1 and tonumber(frecuencia) < 2000 then
			setElementData(jugador, "frecuencia.voz.whisper", math.floor(tonumber(frecuencia)/100))
		else
			removeElementData(jugador, "frecuencia.voz.whisper")
		end
		-- Recomponemos las tablas a partir de un bucle con todos los jugadores
		for k, v in ipairs(getElementsByType("player")) do
			if exports.players:isLoggedIn(v) then
				if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia) then
					table.insert(tablaBroadcast, v)
					if ignoreAviso ~= true and jugador ~= v then
						outputChatBox(getPlayerName(jugador):gsub("_", " ").." se ha unido a tu frecuencia.", v, 0, 255, 0)
					end
				--else
					--table.insert(tablaIgnore, v)
				end
			end
		end
		-- Asignamos las tablas correspondientes a todos los jugadores
		for k, v in ipairs(getElementsByType("player")) do
			if exports.players:isLoggedIn(v) then
				if tonumber(getElementData(v, "frecuencia.voz")) == tonumber(frecuencia) then
					setPlayerVoiceBroadcastTo(v, tablaBroadcast)
					--setPlayerVoiceIgnoreFrom(v, tablaIgnore)
				end
			end
		end
		return true
	end
end

function toggleWhisper(player)
	if player and exports.players:isLoggedIn(player) then
		if getElementData(player, "frecuencia.inWhisper") == true then
			if getElementData(player, "frecuencia.voz.whisper") then
				-- Simplemente solicitamos reconexión a su frecuencia.
				conectarJugadorAFrecuencia(player, tonumber(getElementData(player, "frecuencia.voz")), true)
				outputChatBox("Has desactivado el modo Whisper. Ahora hablas a los de tu frecuencia.", player, 0, 255, 0)
				removeElementData(player, "frecuencia.inWhisper")
			end
		else
			if getElementData(player, "frecuencia.voz.whisper") then
				local frecuencia = getElementData(player, "frecuencia.voz.whisper")
				-- Tenemos que hacer una nueva tabla Broadcast
				local tablaBroadcast2 = {}
				for k, v in ipairs(getElementsByType("player")) do
					local tablaIgnore2 = {}
					-- Y además una nueva tabla ignore para cada jugador.
					if exports.players:isLoggedIn(v) then
						if tonumber(getElementData(v, "frecuencia.voz.whisper")) == tonumber(frecuencia) then
							table.insert(tablaBroadcast2, v)
						end
					end
				end
				setPlayerVoiceBroadcastTo(player, tablaBroadcast2)
				outputChatBox("Has activado el modo Whisper. Ahora hablas a toda tu facción.", player, 255, 255, 0)
				setElementData(player, "frecuencia.inWhisper", true)
			end
		end
	end
end 
addCommandHandler("whisper", toggleWhisper)


function instruccionesSistemaVoz(player)
	outputChatBox("~~ Instrucciones del sistema de voz para facciones ~~", player, 255, 255, 255)
	outputChatBox(" - Presiona 'F6' y selecciona una frecuencia. Después usa 'Conectar a frecuencia'", player, 0, 255, 0)
	outputChatBox(" - Si quieres hablar a los jugadores que estén en tu misma frecuencia > Tecla 'Z' dejándola pulsada.", player, 255, 255, 255)
	outputChatBox(" - Si quieres hablar a todos los jugadores de tu facción (whisper) > Tecla 'X' dándole una vez.", player, 0, 255, 0)
	outputChatBox("Para más información, acude a un staff (/duda, CAU, foro...)", player, 255, 255, 0)
end
addCommandHandler("voz", instruccionesSistemaVoz)
