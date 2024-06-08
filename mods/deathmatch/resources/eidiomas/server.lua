local markerIdiomas = createMarker(-2033.2,-117.31,1034.7, "cylinder", 1.5, 102, 204, 255, 127) 

setElementInterior(markerIdiomas, 3)
setElementDimension(markerIdiomas, 278)

function abrirVentanaMarker(element)
	if isElement(element) and getElementDimension(element) == 278 then
		if not getElementData(element, "GUIeDI") then
		local idiomas = exports.players:getLanguages()
		local idiomas_nivel = {}
		for k, v in ipairs(idiomas) do
			idiomas_nivel[tostring(v[2])] = exports.players:getLanguageSkill(element,tostring(v[2])) or 0
		end
		triggerClientEvent(element, "onSolicitarAbrirVentanaIdioma", element, idiomas, idiomas_nivel)
		setElementData(element, "GUIeDI", true)
		end
	end
end
addEventHandler("onMarkerHit", markerIdiomas, abrirVentanaMarker)

function isIdiomaAprendidoHoy(player)
	local time = getRealTime()
	local ano = (time.year+1900)
	local dia = (time.yearday)
	local nombreArchivo = tostring(ano).."-"..tostring(dia).."-"..tostring(getPlayerName(player))
	if fileExists("registro/"..nombreArchivo) then
		return true
	else
		return false
	end
end

function registrarIdiomaAprendido(player)
	local time = getRealTime()
	local ano = (time.year+1900)
	local dia = (time.yearday)
	local nombreArchivo = tostring(ano).."-"..tostring(dia).."-"..tostring(getPlayerName(player))
	if fileExists("registro/"..nombreArchivo) then
		return false
	else
		local newFile = fileCreate("registro/"..nombreArchivo)
		if (newFile) then
			fileClose(newFile)
			return true
		end
	end
end

function aprenderIdioma(idioma, porcentaje)
	if source and client and source == client and idioma and porcentaje then
		if not isIdiomaAprendidoHoy(source) then
			if exports.players:takeMoney(source, 200) then
				if porcentaje == 0 then -- Idioma no conocido, dar idioma y subir 5%
					if exports.players:learnLanguage(source, tostring(idioma)) then
						outputChatBox("Idioma aprendido correctamente. Usa 'L' para ver los que tienes.", source, 0, 255, 0)
						outputChatBox("Recuerda que hasta que no tengas un % mayor no entenderás bien el idioma.", source, 0, 255, 0)
						registrarIdiomaAprendido(source)
					else
						outputChatBox("Se ha producido un error. Saca F12 y avisa a desarrollador COD.ERR 1-"..tostring(idioma), source, 255, 0, 0)
						exports.players:giveMoney(source, 200)
					end
				else 
					if exports.players:increaseLanguageSkill2(source, tostring(idioma), 50) then
						outputChatBox("Has subido un 5% el nivel del idioma. ¡Enhorabuena, vuelve mañana!", source, 0, 255, 0)
						registrarIdiomaAprendido(source)
					else
						outputChatBox("No se ha podido subir el nivel a este idioma. Saca F12 y avisa a un desarrollador COD.ERR 2-"..tostring(idioma), source, 255, 0, 0)
						exports.players:giveMoney(source, 200)
					end
				end
			else
				outputChatBox("No tienes los 200$ que cuesta la lección diaria de un idioma.", source, 255, 0, 0)
			end
		else
			outputChatBox("¡Ya has aprendido hoy tu lección diaria, vuelve mañana!", source, 255, 0, 0)
		end
	end
end
addEvent("onAprenderIdioma", true)
addEventHandler("onAprenderIdioma", getRootElement(), aprenderIdioma)