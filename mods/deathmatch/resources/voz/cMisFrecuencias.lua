local frecuenciasPolicia = {[100] = "Frecuencia General", [101] = "Frecuencia 1", [102] = "Frecuencia 2", [103] = "Frecuencia 3", [104] = "Frecuencia SWAT", [105] = "Frecuencia DIC", [106] = "ADAM/UNION-11", [107] = "ADAM/UNION-12", [108] = "ADAM/UNION-13", [109] = "ADAM/UNION-14", [110] = "ADAM/UNION-15", [111] = "ADAM/UNION-16", [112] = "ADAM/UNION-18", [113] = "RANGER-19", [114] = "RANGER-20", [115] = "MARY-22", [116] = "MARY-23", [117] = "MARY-24", [118] = "MARY-25", [119] = "JOHN-40", [120] = "ENFORCER-21"}
local frecuenciasMedicos = {[200] = "Frecuencia General", [201] = "Entrevistas / Exámenes", [202] = "Médicos de servicio", [203] = "Médicos fuera de servicio", [204] = "Bomberos de servicio", [205] = "Bomberos fuera de servicio", [206] = "Quirófano", [207] = "Rayos X", [208] = "USVA-1", [209] = "USVA-2", [210] = "USVA-3", [211] = "USVA-4", [212] = "RANGER-1", [213] = "AIRE-1", [214] = "US-1"}
local frecuenciasTaller = {[300] = "Frecuencia General", [301] = "Frecuencia 1", [302] = "Frecuencia 2", [303] = "Frecuencia 3", [304] = "Reparación", [305] = "Grúas", [306] = "Eventos", [307] = "Reunión", [308] = "Descanso"}
local frecuenciasNoticias = {[400] = "Frecuencia General", [401] = "Frecuencia 1", [402] = "Frecuencia 2", [403] = "Frecuencia 3", [404] = "Entrevistas", [405] = "Estudio de Grabación", [406] = "Retransmisión 1", [407] = "Retransmisión 2"}
local frecuenciasGobierno = {[500] = "Frecuencia General", [501] = "Frecuencia 1", [502] = "Frecuencia 2", [503] = "Frecuencia 3", [504] = "Entrevistas", [505] = "Despacho del Alcalde", [506] = "Seguridad 1", [507] = "Seguridad 2"}
local frecuenciasJusticia = {[600] = "Frecuencia General", [601] = "Frecuencia 1", [602] = "Frecuencia 2", [603] = "Frecuencia 3", [604] = "Entrevistas", [605] = "Sala Juzgado 1", [606] = "Sala Juzgado 2", [607] = "Sala Juzgado 3"}
local frecuenciasTTL = {[700] = "Frecuencia General", [701] = "Camión 1", [702] = "Camión 2", [703] = "Camión 3", [704] = "Camión 4", [705] = "Camión 5", [706] = "Camión 6", [707] = "Camión 7", [708] = "Camión 8", [709] = "Camión 9", [710] = "Camión 10", [711] = "Directiva", [712] = "Reuniones"}
local frecuenciasAutobuses = {[800] = "Frecuencia General", [801] = "Frecuencia Ruta 1", [802] = "Frecuencia Ruta 2", [803] = "Reunión", [804] = "Descanso" }
 
local px, py = guiGetScreenSize()

function abrirMisFrecuencias(datosF)
		triggerEvent("onCursor", getLocalPlayer())
        vMisFrecuencias = guiCreateWindow((px/2)-(386/2), (py/2)-(457/2), 386, 457, "Mis frecuencias disponibles", false)
        guiWindowSetSizable(vMisFrecuencias, false)
        bConectarFrecuencias = guiCreateButton(223, 396, 153, 51, "Conectar a frecuencia", false, vMisFrecuencias)
        bCerrarFrecuencias = guiCreateButton(10, 399, 153, 48, "Cerrar", false, vMisFrecuencias)
		addEventHandler("onClientGUIClick", bConectarFrecuencias, botonPulsadoMisFrecuencias)
		addEventHandler("onClientGUIClick", bCerrarFrecuencias, botonPulsadoMisFrecuencias)
        gridlistFrecuencias = guiCreateGridList(10, 36, 366, 340, false, vMisFrecuencias)
        guiGridListAddColumn(gridlistFrecuencias, "ID frecuencia", 0.2)
        guiGridListAddColumn(gridlistFrecuencias, "Nombre frecuencia", 0.75)
		local filaID = 0
		guiGridListAddRow(gridlistFrecuencias)
		guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-1", false, false)
		guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Apagar canal de voz", false, false)
		filaID = filaID + 1
		for key, fID in ipairs(datosF) do
			if fID == 1 then -- Palomino Creek Sheriff Dept.
			    guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Palomino Creek Sheriff Dept.", false, false)
				filaID = filaID + 1
				for k, v in pairs(frecuenciasPolicia) do
					guiGridListAddRow(gridlistFrecuencias)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
					filaID = filaID + 1
				end
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "-----------------------", false, false)
				filaID = filaID + 1	
			elseif fID == 2 then -- Palomino Creek Medical Dept.
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Palomino Creek Medical Dept.", false, false)
				filaID = filaID + 1
				for k, v in pairs(frecuenciasMedicos) do
					guiGridListAddRow(gridlistFrecuencias)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
					filaID = filaID + 1
				end
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "-----------------------", false, false)
				filaID = filaID + 1
			elseif fID == 3 then -- Palomino Creek Motor Workshop.
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Palomino Creek Motor Workshop", false, false)
				filaID = filaID + 1
				for k, v in pairs(frecuenciasTaller) do
					guiGridListAddRow(gridlistFrecuencias)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
					filaID = filaID + 1
				end
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "-----------------------", false, false)
				filaID = filaID + 1
			elseif fID == 4 then -- Palomino Creek FM.
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Palomino Creek FM", false, false)
				filaID = filaID + 1
				for k, v in pairs(frecuenciasNoticias) do
					guiGridListAddRow(gridlistFrecuencias)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
					filaID = filaID + 1
				end
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "-----------------------", false, false)
				filaID = filaID + 1
			elseif fID == 5 then -- Red County Govern.
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Red County Govern", false, false)
				filaID = filaID + 1
				for k, v in pairs(frecuenciasGobierno) do
					guiGridListAddRow(gridlistFrecuencias)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
					filaID = filaID + 1
				end
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "-----------------------", false, false)
				filaID = filaID + 1
			elseif fID == 6 then -- Montgomery Court and Justice Dept.
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Montgomery Court and Justice Dept.", false, false)
				filaID = filaID + 1
				for k, v in pairs(frecuenciasJusticia) do
					guiGridListAddRow(gridlistFrecuencias)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
					filaID = filaID + 1
				end
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "-----------------------", false, false)
				filaID = filaID + 1
			elseif fID == 7 then -- Turbo Trans Logistics.
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Turbo Trans Logistics", false, false)
				filaID = filaID + 1
				for k, v in pairs(frecuenciasTTL) do
					guiGridListAddRow(gridlistFrecuencias)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
					filaID = filaID + 1
				end
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "-----------------------", false, false)
				filaID = filaID + 1
			elseif fID == 8 then -- Montgomery Public Transport.
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "Montgomery Public Transport", false, false)
				filaID = filaID + 1
				for k, v in pairs(frecuenciasAutobuses) do
					guiGridListAddRow(gridlistFrecuencias)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 1, tostring(k), false, false)
					guiGridListSetItemText(gridlistFrecuencias, filaID, 2, tostring(v), false, false)
					filaID = filaID + 1
				end
				guiGridListAddRow(gridlistFrecuencias)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 1, "-", false, false)
				guiGridListSetItemText(gridlistFrecuencias, filaID, 2, "-----------------------", false, false)
				filaID = filaID + 1
			end
		end
		--fixMyVolume()
end
addEvent("onAbrirMisFrecuencias", true)
addEventHandler("onAbrirMisFrecuencias", getRootElement(), abrirMisFrecuencias)

function cerrarMisFrecuencias()
	if (vMisFrecuencias) and isElement(vMisFrecuencias) then
		destroyElement(vMisFrecuencias)
		triggerEvent("offCursor", getLocalPlayer())
	end
end
addEvent("onCerrarMisFrecuencias", true)
addEventHandler("onCerrarMisFrecuencias", getRootElement(), cerrarMisFrecuencias)
 
function botonPulsadoMisFrecuencias()
	if source == bCerrarFrecuencias then
		destroyElement(vMisFrecuencias)
		triggerEvent("offCursor", getLocalPlayer())
	elseif source == bConectarFrecuencias then
		local row = guiGridListGetSelectedItem ( gridlistFrecuencias )
		local frecuenciaID = guiGridListGetItemText ( gridlistFrecuencias, row, 1 )
		local frecuenciaName = guiGridListGetItemText ( gridlistFrecuencias, row, 2 )
		if tonumber(frecuenciaID) and tostring(frecuenciaName) then
			triggerEvent("offCursor", getLocalPlayer())
			triggerServerEvent("onConectarAFrecuencia", getLocalPlayer(), tonumber(frecuenciaID), tostring(frecuenciaName))
			--fixMyVolume()
			destroyElement(vMisFrecuencias)
		else
			outputChatBox("Selecciona una frecuencia válida.", 255, 0, 0)
		end
	end
end

-- function fixMyVolume()
	-- for k, v in ipairs (getElementsByType("player")) do 
		-- setSoundVolume(v, 2.0)
	-- end
-- end
-- setTimer(fixMyVolume, 60000, 0)


addEventHandler("onClientPlayerVoiceStart", getRootElement(), function()
	for k, v in ipairs (getElementsByType("sound")) do
		if getElementData(v, "radioSystem") == true then
			setSoundVolume(v, 0)
		end                 
	end               
	setSoundVolume(source, 25.0)
end)

addEventHandler("onClientPlayerVoiceStop", getRootElement(), function()
	for k, v in ipairs (getElementsByType("sound")) do
		if getElementData(v, "radioSystem") == true then
			setSoundVolume(v, 1)
		end
	end
end)