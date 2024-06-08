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


local function staffMessage( message, r, g, b )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, r, g, b )
	end
end

function precargaCAU ()
	if source and client and source==client then
		local sql = exports.sql:query_assoc_single("SELECT password, salt FROM wcf1_user WHERE userID = "..exports.players:getUserID(source))
		if sql then
			triggerClientEvent(source, "onAbrirPortalCAU", source, tostring(exports.players:getUserID(source)), tostring(sql.password), tostring(sql.salt))
		end
	end
end
addEvent("onPreAbrirPortalCAU", true)
addEventHandler("onPreAbrirPortalCAU", getRootElement(), precargaCAU)
 
--[[function solicitudIncidencia(tipo, texto)
	if source and client and source == client and tipo and texto then
		local username = string.gsub(tostring(exports.players:getUserName(source)),'%W','')
		fetchRemote("https://incidencias.dt-mta.com/checkacc.php?username="..tostring(username).."&secureKey=tcqG0dtYgqm8dNrt1WGd8hSRA1GyCCRa8VCq8hfdKrs36KtK4C6do5kvVJgpre37rvwRMRhCAtkw370WsHepVm2SBAo4RLM8D1vgDcOzM2WPa41u87qiATWvtShFbXaS", recibirRespuesta, "", false, source, tipo, texto)
	end
end
addEvent("onSolicitarIncidencia", true)
addEventHandler("onSolicitarIncidencia", getRootElement(), solicitudIncidencia)


function recibirRespuesta(data, err, player, tipo, texto)
	if err == 0 then
		if tonumber(data) then 
			local uIDBug = tonumber(data)
			local time = getRealTime()
			if tipo == 1 then -- Sugerencia
				local regID = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_text_table` (`id`, `description`, `steps_to_reproduce`, `additional_information`) VALUES (NULL, '%s', '', '')", texto)
				local sql = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_table` (`id`, `project_id`, `reporter_id`, `handler_id`, `duplicate_id`, `priority`, `severity`, `reproducibility`, `status`, `resolution`, `projection`, `eta`, `bug_text_id`, `os`, `os_build`, `platform`, `version`, `fixed_in_version`, `build`, `profile_id`, `view_state`, `summary`, `sponsorship_total`, `sticky`, `target_version`, `category_id`, `date_submitted`, `due_date`, `last_updated`) VALUES ('"..tonumber(regID).."', '1', '"..tonumber(uIDBug).."', '413', '0', '30', '50', '70', '50', '10', '10', '10', '"..tonumber(regID).."', '', '', '', '', '', '', '0', '50', 'Sugerencia', '0', '0', 'MTA 1.5', '0', '"..tonumber(time.timestamp).."', '1', '"..tonumber(time.timestamp).."')")
				if regID and sql then
					exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_monitor_table` (`user_id`, `bug_id`) VALUES ('"..tonumber(uIDBug).."', '"..tonumber(regID).."')")
					outputChatBox("Has añadido correctamente la sugerencia con número "..tostring(regID), player, 0, 255, 0)
					outputChatBox("Puedes usar /sugerencias para ver las de todos y votarlas.", player, 255, 255, 255)
				else
					outputChatBox("Se ha producido un error (código 3). Contacte con el staff.", player, 255, 0, 0)
				end
			elseif tipo == 2 then -- Bug / Fallo
				local regID = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_text_table` (`id`, `description`, `steps_to_reproduce`, `additional_information`) VALUES (NULL, '%s', '', '')", texto)
				local sql = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_table` (`id`, `project_id`, `reporter_id`, `handler_id`, `duplicate_id`, `priority`, `severity`, `reproducibility`, `status`, `resolution`, `projection`, `eta`, `bug_text_id`, `os`, `os_build`, `platform`, `version`, `fixed_in_version`, `build`, `profile_id`, `view_state`, `summary`, `sponsorship_total`, `sticky`, `target_version`, `category_id`, `date_submitted`, `due_date`, `last_updated`) VALUES ('"..tonumber(regID).."', '1', '"..tonumber(uIDBug).."', '0', '0', '60', '50', '70', '10', '10', '10', '10', '"..tonumber(regID).."', '', '', '', '', '', '', '0', '50', 'Bug / Fallo', '0', '0', 'MTA 1.5', '0', '"..tonumber(time.timestamp).."', '1', '"..tonumber(time.timestamp).."')")
				if regID and sql then
					outputChatBox("Incidencia creada correctamente. Tipo: Bug / Fallo Nº "..tostring(regID), player, 0, 255, 0)
					outputChatBox("Puedes acudir a https://incidencias.dt-mta.com para consultar su estado.", player, 255, 255, 255)
					outputChatBox("Es posible que un miembro del staff se ponga en contacto con usted.", player, 255, 255, 255)
				else
					outputChatBox("Se ha producido un error (código 3). Contacte con el staff.", player, 255, 0, 0)
				end
			elseif tipo == 3 then -- Queja
				local regID = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_text_table` (`id`, `description`, `steps_to_reproduce`, `additional_information`) VALUES (NULL, '%s', '', '')", texto)
				local sql = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_table` (`id`, `project_id`, `reporter_id`, `handler_id`, `duplicate_id`, `priority`, `severity`, `reproducibility`, `status`, `resolution`, `projection`, `eta`, `bug_text_id`, `os`, `os_build`, `platform`, `version`, `fixed_in_version`, `build`, `profile_id`, `view_state`, `summary`, `sponsorship_total`, `sticky`, `target_version`, `category_id`, `date_submitted`, `due_date`, `last_updated`) VALUES ('"..tonumber(regID).."', '1', '"..tonumber(uIDBug).."', '0', '0', '50', '50', '70', '10', '10', '10', '10', '"..tonumber(regID).."', '', '', '', '', '', '', '0', '50', 'Queja', '0', '0', 'MTA 1.5', '0', '"..tonumber(time.timestamp).."', '1', '"..tonumber(time.timestamp).."')")
				if regID and sql then
					outputChatBox("Incidencia creada correctamente. Tipo: Queja Nº "..tostring(regID), player, 0, 255, 0)
					outputChatBox("Puede acudir a https://incidencias.dt-mta.com para consultar su estado.", player, 255, 255, 255)
					outputChatBox("Es posible que un miembro del staff se ponga en contacto con usted.", player, 255, 255, 255)
				else
					outputChatBox("Se ha producido un error (código 3). Contacte con el staff.", player, 255, 0, 0)
				end
			elseif tipo == 4 then -- Reporte a staff
				local regID = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_text_table` (`id`, `description`, `steps_to_reproduce`, `additional_information`) VALUES (NULL, '%s', '', '')", texto)
				local sql = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_table` (`id`, `project_id`, `reporter_id`, `handler_id`, `duplicate_id`, `priority`, `severity`, `reproducibility`, `status`, `resolution`, `projection`, `eta`, `bug_text_id`, `os`, `os_build`, `platform`, `version`, `fixed_in_version`, `build`, `profile_id`, `view_state`, `summary`, `sponsorship_total`, `sticky`, `target_version`, `category_id`, `date_submitted`, `due_date`, `last_updated`) VALUES ('"..tonumber(regID).."', '1', '"..tonumber(uIDBug).."', '0', '0', '60', '50', '70', '10', '10', '10', '10', '"..tonumber(regID).."', '', '', '', '', '', '', '0', '50', 'Reporte a staff', '0', '0', 'MTA 1.5', '0', '"..tonumber(time.timestamp).."', '1', '"..tonumber(time.timestamp).."')")
				if regID and sql then
					outputChatBox("Incidencia creada correctamente. Tipo: Reporte a staff Nº "..tostring(regID), player, 0, 255, 0)
					outputChatBox("Puede acudir a https://incidencias.dt-mta.com para consultar su estado.", player, 255, 255, 255)
					outputChatBox("Es posible que un miembro del staff se ponga en contacto con usted.", player, 255, 255, 255)
				else
					outputChatBox("Se ha producido un error (código 3). Contacte con el staff.", player, 255, 0, 0)
				end	
			elseif tipo == 5 then -- Asunto sobre VIP
				local regID = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_text_table` (`id`, `description`, `steps_to_reproduce`, `additional_information`) VALUES (NULL, '%s', '', '')", texto)
				local sql = exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_table` (`id`, `project_id`, `reporter_id`, `handler_id`, `duplicate_id`, `priority`, `severity`, `reproducibility`, `status`, `resolution`, `projection`, `eta`, `bug_text_id`, `os`, `os_build`, `platform`, `version`, `fixed_in_version`, `build`, `profile_id`, `view_state`, `summary`, `sponsorship_total`, `sticky`, `target_version`, `category_id`, `date_submitted`, `due_date`, `last_updated`) VALUES ('"..tonumber(regID).."', '1', '"..tonumber(uIDBug).."', '0', '0', '60', '50', '70', '10', '10', '10', '10', '"..tonumber(regID).."', '', '', '', '', '', '', '0', '50', 'Asunto sobre VIP', '0', '0', 'MTA 1.5', '0', '"..tonumber(time.timestamp).."', '1', '"..tonumber(time.timestamp).."')")
				if regID and sql then
					outputChatBox("Incidencia creada correctamente. Tipo: Asunto sobre VIP Nº "..tostring(regID), player, 0, 255, 0)
					outputChatBox("Puede acudir a https://incidencias.dt-mta.com para consultar su estado.", player, 255, 255, 255)
					outputChatBox("Es posible que un miembro del staff se ponga en contacto con usted.", player, 255, 255, 255)
				else
					outputChatBox("Se ha producido un error (código 3). Contacte con el staff.", player, 255, 0, 0)
				end	
			end
		else
			outputChatBox("Se ha producido un error (código 2). Contacte con el staff.", player, 255, 0, 0)
		end
	else
		outputChatBox("Se ha producido un error (código 1). Contacte con el staff.", player, 255, 0, 0)
	end
end


function solicitarGUISugerencias(player)
	if exports.players:isLoggedIn(player) then
		outputChatBox("Espera por favor, estamos accediendo al Servicio de Incidencias...", player, 255, 255, 0)
		local username = string.gsub(tostring(exports.players:getUserName(player)),'%W','') 
		fetchRemote("https://incidencias.dt-mta.com/checkacc.php?username="..tostring(username).."&secureKey=tcqG0dtYgqm8dNrt1WGd8hSRA1GyCCRa8VCq8hfdKrs36KtK4C6do5kvVJgpre37rvwRMRhCAtkw370WsHepVm2SBAo4RLM8D1vgDcOzM2WPa41u87qiATWvtShFbXaS", recibirRespuestaSug, "", false, player)
	end
end
addCommandHandler("sugerencias", solicitarGUISugerencias)


function recibirRespuestaSug(data, err, player)
	if err == 0 then
		if tonumber(data) then
			local sql = exports.sqlincidencias:query_assoc("SELECT * FROM `mtax_bug_table` WHERE `handler_id` = 413 AND `status` = 50")
			local sql2 = exports.sqlincidencias:query_assoc("SELECT * FROM `mtax_bug_monitor_table`")
			local sql3 = exports.sqlincidencias:query_assoc("SELECT * FROM `mtax_bug_text_table`")
			if hasObjectPermissionTo( player, "command.devduty", false ) then
				triggerClientEvent(player, "onAbrirGuiVotaciones", player, true, sql, sql2, sql3, data)
			else
				triggerClientEvent(player, "onAbrirGuiVotaciones", player, false, sql, sql2, sql3, data)
			end
		else
			outputChatBox("¡Ups! Se ha producido un error grave (código 2)", player, 255, 0, 0)
		end
	else
		outputChatBox("¡Ups! Se ha producido un error grave (código 1)", player, 255, 0, 0)
	end
end


function aplicarVotoASugerencia(IDUser, IDInci)
	if source and client and IDUser and IDInci and source == client then
		local sql = exports.sqlincidencias:query_assoc_single("SELECT * FROM `mtax_bug_monitor_table` WHERE `user_id` = "..tostring(IDUser).." AND `bug_id` = "..tostring(IDInci))
		if sql then
			outputChatBox("¡Ya has dado tu voto a esta sugerencia anteriormente!", source, 255, 0, 0)
			return
		end
	end
	if exports.sqlincidencias:query_insertid("INSERT INTO `mtax_bug_monitor_table` (`user_id`, `bug_id`) VALUES ('"..tostring(IDUser).."', '"..tostring(IDInci).."')") then
		outputChatBox("Hemos registrado tu voto. ¡Gracias por ayudar a mejorar DownTown RolePlay!", source, 0, 255, 0 )
	else
		outputChatBox("¡Ups! Se ha producido un error grave a la hora de emitir tu voto. Inténtalo de nuevo.", source, 255, 0, 0)
	end
end
addEvent("onDarVotoASugerencia", true)
addEventHandler("onDarVotoASugerencia", getRootElement(), aplicarVotoASugerencia)]]

function recibirDudaViaAsistencia(duda)
	executeCommandHandler("duda", source, "[ASISTENCIA] "..tostring(duda))
end
addEvent("onEnviarDudaViaAsistencia", true)
addEventHandler("onEnviarDudaViaAsistencia", getRootElement(), recibirDudaViaAsistencia)

function solicitarLocVehViaAsistencia(vehicleID)
	executeCommandHandler("localizarvehiculo", source, tostring(vehicleID))
end
addEvent("onSolicitarLocVehViaAsistencia", true)
addEventHandler("onSolicitarLocVehViaAsistencia", getRootElement(), solicitarLocVehViaAsistencia)

function solicitarVehiculosViaAsistencia()
	if source then
		local sql = exports.sql:query_assoc("SELECT vehicleID, model FROM vehicles WHERE characterID = "..exports.players:getCharacterID(source))
		if sql then
			triggerClientEvent(source, "onEnviarVehiculosViaAsistencia", source, sql)
		end
	end
end
addEvent("onSolicitarVehiculosViaAsistencia", true)
addEventHandler("onSolicitarVehiculosViaAsistencia", getRootElement(), solicitarVehiculosViaAsistencia)


function solicitarStaffViaAsistencia(tipo)
	if tipo == 1 then
		triggerEvent("onEnviarDudaViaAsistencia", source, "Soy nuevo y necesito ayuda. ¿Puede venir algún staff a enseñarme?")
	elseif tipo == 2 then
		triggerEvent("onEnviarDudaViaAsistencia", source, "Necesito a un staff en mi posición. ¡NO puedo rolear aquí!")
	end
end
addEvent("onSolicitarStaffViaAsistencia", true)
addEventHandler("onSolicitarStaffViaAsistencia", getRootElement(), solicitarStaffViaAsistencia)

function solicitarAnulacionPrestamoViaAsistencia(tipo)
	local sql = exports.sql:query_assoc_single("SELECT * FROM prestamos WHERE cantidad > pagado AND tipo = ".. tonumber(tipo).." AND characterID = "..exports.players:getCharacterID(source))
	if sql and sql.prestamoID then
		if tipo == 1 then
			-- Vehículo
			local vehicle = exports.vehicles:getVehicle(tonumber(sql.objetoID))
			if vehicle then
				destroyElement(vehicle)
			end
			exports.sql:query_free("DELETE FROM vehicles WHERE vehicleID = ".. sql.objetoID)
			outputChatBox("Tu préstamo de vehículo ha sido anulado correctamente.", source, 0, 255, 0)
		elseif tipo == 2 then
			-- Interior
			exports.interiors:solicitarVentaInterior(sql.objetoID)
			outputChatBox("Tu préstamo de interior ha sido anulado correctamente.", source, 0, 255, 0)
		end
		exports.sql:query_free("DELETE FROM prestamos WHERE prestamoID = ".. sql.prestamoID)
	else
		if tipo == 1 then
			t = "vehículo"
		elseif tipo == 2 then
			t = "interior"
		end
		outputChatBox("No tienes ningún préstamo de "..tostring(t).." para anular.", source, 255, 0, 0)
		outputChatBox("Si crees que se ha producido un error, acude a Soporte Técnico.", source, 255, 0, 0)
	end
end
addEvent("onSolicitarAnulacionPrestamoViaAsistencia", true)
addEventHandler("onSolicitarAnulacionPrestamoViaAsistencia", getRootElement(), solicitarAnulacionPrestamoViaAsistencia)

function recibirCUSViaAsistencia(CUS)
	local sql = exports.sql:query_assoc_single("SELECT vipSkin FROM wcf1_user WHERE userID = " .. exports.players:getUserID(source))
	local vipSkin = tonumber(sql.vipSkin)
	if vipSkin > 0 then
		outputChatBox("¡Hola, "..getPlayerName(source).."! Estamos implementando tu skin CUS "..tostring(CUS)..".", source, 0, 255, 0)
		outputChatBox("Por favor, espera un momento...", source, 255, 255, 255)
		fetchRemote("http://dt-mta.com/vip/nozipskin/"..tostring(CUS).."_meta.xml", "1-"..tostring(CUS), 1, 10000, descargarMetaSkinVIP, nil, false, source, CUS, vipSkin)
	else
		outputChatBox("¡Ups! Al parecer no tienes una skin asignada. Utiliza /skinvip y vuelve a intentarlo.", source, 255, 0, 0)
	end
end
addEvent("onEnviarCUSViaAsistencia", true)
addEventHandler("onEnviarCUSViaAsistencia", getRootElement(), recibirCUSViaAsistencia)

function descargarMetaSkinVIP (data, errorCode, player, CUS, vipSkin)
	if errorCode == 0 then
		local nResource = createResource(tostring(CUS), "[vipskin]")
		local newFile = fileCreate(":"..tostring(CUS).."/meta.xml")
		if (newFile) then
			fileWrite(newFile, data)
			fileClose(newFile)
			outputChatBox("Archivo 1/4 implementado. Solicitando 2º archivo...", player, 0, 255, 0)
			fetchRemote("http://dt-mta.com/vip/nozipskin/"..tostring(CUS).."_client.lua", "2-"..tostring(CUS), 1, 10000, descargarClientSkinVIP, nil, false, player, CUS, vipSkin)
		else
			outputChatBox("Se ha producido un error grave con tu skin, error #1", player, 255, 0, 0)
		end
	else
		outputChatBox("Se ha producido un error grave con tu skin, error HTTP-"..tostring(errorCode), player, 255, 0, 0)
	end
end

function descargarClientSkinVIP (data, errorCode, player, CUS, vipSkin)
	if errorCode == 0 then
		local newFile = fileCreate(":"..tostring(CUS).."/client.lua")
		if (newFile) then
			fileWrite(newFile, data)
			fileClose(newFile)
			outputChatBox("Archivo 2/4 implementado. Solicitando 3º archivo...", player, 0, 255, 0)
			fetchRemote("http://dt-mta.com/vip/nozipskin/"..tostring(CUS)..".txd", "3-"..tostring(CUS), 1, 10000, descargarTXDSkinVIP, nil, false, player, CUS, vipSkin)
		else
			outputChatBox("Se ha producido un error grave con tu skin, error #1", player, 255, 0, 0)
		end
	else
		outputChatBox("Se ha producido un error grave con tu skin, error HTTP-"..tostring(errorCode), player, 255, 0, 0)
	end
end

function descargarTXDSkinVIP (data, errorCode, player, CUS, vipSkin)
	if errorCode == 0 then
		local newFile = fileCreate(":"..tostring(CUS).."/skin.txd")
		if (newFile) then
			fileWrite(newFile, data)
			fileClose(newFile)
			outputChatBox("Archivo 3/4 implementado. Solicitando 4º archivo...", player, 0, 255, 0)
			fetchRemote("http://dt-mta.com/vip/nozipskin/"..tostring(CUS)..".dff", "4-"..tostring(CUS), 1, 10000, descargarDFFSkinVIP, nil, false, player, CUS, vipSkin)
		else
			outputChatBox("Se ha producido un error grave con tu skin, error #1", player, 255, 0, 0)
		end
	else
		outputChatBox("Se ha producido un error grave con tu skin, error HTTP-"..tostring(errorCode), player, 255, 0, 0)
	end
end

local resToDelete = {}

function descargarDFFSkinVIP (data, errorCode, player, CUS, vipSkin)
	if errorCode == 0 then
		local newFile = fileCreate(":"..tostring(CUS).."/skin.dff")
		if (newFile) then
			fileWrite(newFile, data)
			fileClose(newFile)
			outputChatBox("Archivo 4/4 implementado. Finalizando implementación...", player, 0, 255, 0)
			refreshResources(true, getResourceFromName(tostring(CUS)))
			if startResource(getResourceFromName(tostring(CUS)), true) then
				setElementModel(player, tonumber(vipSkin))
				outputChatBox("¡Ya hemos terminado y te hemos puesto tu nueva skin vip!", player, 0, 255, 0)
				outputChatBox("Puedes usar /qrt para quitártela y /ponerskinvip para ponértela.", player, 255, 255, 255)
				-- Verificar si el usuario tiene una skin anterior a través del CUS.
				local sql = exports.sql:query_assoc_single("SELECT CUS FROM wcf1_user WHERE userID = "..exports.players:getUserID(player))
				if sql and sql.CUS then
					local res = getResourceFromName(tostring(sql.CUS))
					if res then
						stopResource(res)
						resToDelete[tostring(sql.CUS)] = true
					end
				end
				exports.sql:query_free("UPDATE wcf1_user SET CUS = '%s' WHERE userID = "..exports.players:getUserID(player), tostring(CUS))
				fetchRemote("https://dt-mta.com/vip/delete_skin_uploaded.php?clave_externa=fMoH8K8yD6pa1VjyQfNw6dhbbAGbuMPaJpcQ6Acd1HWuYcBzdrELXtvCd3EpOcuTzE7F4bKAJHWAXhOtEAViG5tDXKeS6CoOJJZnazqcWQRRse4hiCLcAXOze1yGjM9B&CUS="..tostring(CUS), 1, 10000, eliminarSkinSubida, nil, false)
			else
				outputChatBox("Ha ocurrido un error. Acude a un desarrollador.", player, 255, 0, 0)
			end
		else
			outputChatBox("Se ha producido un error grave con tu skin, error #1", player, 255, 0, 0)
		end
	else
		outputChatBox("Se ha producido un error grave con tu skin, error HTTP-"..tostring(errorCode), player, 255, 0, 0)
	end
end

function eliminarSkinSubida(data, error)
	
end

addEventHandler ( "onResourceStop", root, 
    function ( resource )
		if resource then
			if resToDelete[tostring(getResourceName(resource))] == true then
				setTimer(deleteResource, 3000, 1, resource)
			end
        end
   end 
)

function ayudaGeneral (player, cmd, ...)
	if exports.players:isLoggedIn(player) then
		if hasObjectPermissionTo( player, "command.acceptreport", false ) then
			outputChatBox("Has abierto el panel de soporte Administrativo", player, 255, 255, 0)
			outputChatBox("Si necesitas soporte de usuario presiona (F1).", player, 0, 255, 0)
			triggerClientEvent(player, "onAbrirPanelAyudaAdmin", player)
		else
		    outputChatBox("Has abierto el panel de soporte: Usuario", player, 255, 255, 0)
			outputChatBox("Si necesitas soporte usa /duda y un staff te atenderá.", player, 0, 255, 0)
			triggerClientEvent(player, "onAbrirPanelAyuda", player)
		end
	end
end
addCommandHandler("ayuda", ayudaGeneral)


function trabajosUsuario(player, cmd, trabaj)
	if exports.players:isLoggedIn(player) then 
		if not trabaj then
			outputChatBox("Lista de trabajos temporales. Usa /trabajos [nombre] para marcar su posición.", player, 255, 255, 0)
			outputChatBox("Limpiador: súbete a un Sweeper y limpia las calles.", player, 255, 255, 255)
			outputChatBox("Repartidor: si te gusta repartir pizzas, puede que éste sea tu trabajo.", player, 255, 255, 255)
			outputChatBox("Pescador: qué mejor forma de ganar dinero, estando en alta mar.", player, 255, 255, 255)
		else
			local trabajo = string.lower(tostring(trabaj))
			if tostring(trabajo) == "limpiador" then
				x, y, z = 1349.62, 350.19, 20.1
			elseif tostring(trabajo) == "repartidor" then
				x, y, z = 1359.86, 249.03, 19.57
			elseif tostring(trabajo) == "pescador" then
				x, y, z = 2120.17, -92, 2.03
			else
				outputChatBox("Trabajo no válido. Usa /trabajos para verlos y /trabajos [nombre] (ej: /trabajos limpiador)", player, 255, 255, 0)
				return
			end
			createBlip( x, y, z, 46, 2, 0, 0, 255, 255, 0, 99999.0, player )
			outputChatBox("Se ha marcado el trabajo solicitado (una W). ¡Buena suerte "..getPlayerName(player):gsub("_", " ").."!", player, 0, 255, 0)
		end
	end
end
addCommandHandler("trabajos", trabajosUsuario)

function marcarAutoescuela(player)
	outputChatBox("Se ha marcado la posición de la autoescuela con el icono de una bandera de carreras.", player, 0, 255, 0)
	outputChatBox("¡Te deseamos buena suerte y que saques tu carnet a la primera!", player, 0, 255, 0)
	createBlip(2323.03, 187.67, 26.45, 53, 2, 0, 0, 255, 255, 0, 99999.0, player )
end
addCommandHandler("autoescuela", marcarAutoescuela)