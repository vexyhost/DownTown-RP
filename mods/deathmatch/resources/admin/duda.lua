dudauto = {
	{pregunta = "foro", respuesta = "La dirección de nuestro foro es https://foro.dt-mta.com"},
	{pregunta = "ts3", respuesta = "La dirección de nuestro TS3 es ts3.dt-mta.com"},
	{pregunta = "ts", respuesta = "La dirección de nuestro TS3 es ts3.dt-mta.com"},
	{pregunta = "teamspeak", respuesta = "La dirección de nuestro TS3 es ts3.dt-mta.com"},
	{pregunta = "login", respuesta = "Intenta iniciar sesión ahora, sino reconecta"},
	{pregunta = "sesion", respuesta = "Intenta iniciar sesión ahora, sino reconecta"},
	{pregunta = "inventario", respuesta = "Prueba ahora, se ha aplicado un arreglo"},
	{pregunta = "items", respuesta = "Prueba ahora, se ha aplicado un arreglo"},
	{pregunta = "volcado", respuesta = "Al bajar del vehículo se desvuelca automáticamente"},
	{pregunta = "volque", respuesta = "Al bajar del vehículo se desvuelca automáticamente"},
	{pregunta = "trabajo", respuesta = "Usa /trabajos y si quieres uno mejor acude al foro http://foro.dt-mta.com"},
}



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
		outputChatBox( message, value, 255, 204, 255,true)
	end
end

local function getAdmins( duty )
	local t = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.adminchat", false ) then
			if not duty or exports.players:getOption( value, "staffduty" ) or getElementData(value, "pm") == true then
				t[ #t + 1 ] = value
			end
		end
	end
	return t
end

local function adminMessage( message )
	for key, value in ipairs( getAdmins( true ) ) do
		outputChatBox( message, value, 255, 204, 255,true )
	end
end

function reportarUsuario (player, cmd, otherPlayer, ...)
	local razon = table.concat( { ... }, " " )
	local other, name = exports.players:getFromName(player, otherPlayer, true)
	if not other or not razon then outputChatBox("Sintaxis: /"..tostring(cmd).. " [jugador]", player, 255, 255, 255) return end
	outputChatBox("El sistema de reportes IG está obsoleto. Saca fotos al F12 y acude al foro.", player, 255, 0, 0)
end
addCommandHandler("report", reportarUsuario)
addCommandHandler("reportar", reportarUsuario)
	
function preguntarDuda (thePlayer, commandName, ...)
	if thePlayer and ... then
		if not exports.players:isLoggedIn(thePlayer) then showChat(thePlayer, true) end
		local razon = table.concat( { ... }, " " )
		if not getElementData(thePlayer, "laduda") then
			setElementData(thePlayer, "laduda", tostring(razon))
			-- Procedemos a abrir la duda en SQL
			if not razon or not (...) then return outputChatBox("[DUDA] Error. No has puesto tu duda. Tienes que poner /duda [duda que tengas].", thePlayer, 255, 0, 0) end
			local dudaID = exports.sql:query_insertid("INSERT INTO `dudas` (`dudaID`, `userIDStaff`, `userIDUsuario`, `charIDUsuario`, `dudaPregunta`, `dudaRespuesta`, `valoracion`, `codigoIncidencia`) VALUES (NULL, '-1', '"..exports.players:getUserID(thePlayer).."', '"..exports.players:getCharacterID(thePlayer).."', '"..tostring(razon).."', 'Sin Respuesta', '-1', '-1')")
			setElementData(thePlayer, "dudaID", tostring(dudaID))
			-- Informar al jugador --
			outputChatBox("[DUDA] Has preguntado: " ..tostring(razon), thePlayer, 0, 255, 0)
			outputChatBox("[DUDA] Nº Duda: "..tostring(dudaID)..".", thePlayer, 0, 255, 0)
			outputChatBox("[DUDA] Espera a que un staff te responda. Puedes usar /aduda para anularla.", thePlayer, 0, 255, 0)
			for k, v in ipairs(dudauto) do
				if string.find(string.lower(razon), tostring(v.pregunta)) then
					outputChatBox("[DUDA] Respuesta: " ..tostring(v.respuesta)..".", thePlayer, 0, 255, 0)
					outputChatBox("[DUDA] Staff que te atendió: Sistema Automático de Resolución de Dudas.", thePlayer, 0, 255, 0)
					if tostring(v.respuesta) == "Intenta iniciar sesión ahora, sino reconecta" or tostring(v.respuesta) == "Prueba ahora, se ha aplicado un arreglo" then
						executeCommandHandler("dgui", thePlayer)
					end
					removeElementData(thePlayer, "laduda")
					exports.sql:query_free("UPDATE `dudas` SET `userIDStaff` = '-2',`dudaRespuesta` = '"..tostring(v.respuesta).."' WHERE `dudaID` = "..tostring(dudaID))
				return
				end
			end
			-- Informar al staff disponible y de servicio --
			staffMessage( "[DUDA] El jugador [" .. exports.players:getID( thePlayer ) .. "] "  .. getPlayerName( thePlayer ):gsub( "_", " " ) .. " tiene una duda. Pon /resolverduda o /rd ".. exports.players:getID( thePlayer ) .." [respuesta] " )
			staffMessage( "[DUDA] ID [" .. exports.players:getID( thePlayer ) .. "] pregunta: ".. razon )
			if hasObjectPermissionTo(thePlayer, 'command.vip', false) and not getElementData(thePlayer, "enc") then -- Es VIP
				staffMessage("[DUDA] ATENCIÓN: USUARIO VIP.")
			end
		else
			outputChatBox("[DUDA] Tienes una duda pendiente. Espera a que sea resuelta para volver a preguntar", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("[DUDA] Error. No has puesto tu duda. Tienes que poner /duda [duda que tengas].", thePlayer, 255, 0, 0)
	end
end

addCommandHandler("duda", preguntarDuda)

function resolverDuda(thePlayer, commandName, otherPlayer, ...)
	if hasObjectPermissionTo( thePlayer, "command.acceptreport", false ) then
		local other, name = exports.players:getFromName(thePlayer, otherPlayer, true)
		if ... and other then
			local respuesta = table.concat( { ... }, " " )
			if getElementData(other, "laduda") then
				-- Informar al usuario --
				outputChatBox("[DUDA] Respuesta: " ..respuesta, other, 0, 255, 0)
				if getElementData(thePlayer, "enc") == true then
					outputChatBox("[DUDA] Staff que te atendió: Desconocido. Usa /valorar [nota del 1 al 10] para ayudarnos a mejorar.", other, 0, 255, 0)
				else
					outputChatBox("[DUDA] Staff que te atendió: "..getPlayerName(thePlayer):gsub("_", " ")..". Usa /valorar [nota del 1 al 10] para ayudarnos a mejorar.", other, 0, 255, 0)
				end
				removeElementData(other, "laduda")
				-- Informar al staff que responde --
				outputChatBox("[DUDA] Has respondido la duda de: " ..name..".", thePlayer, 0, 255, 0)
				outputChatBox("[DUDA] Respuesta dada: " ..respuesta, thePlayer, 0, 255, 0)
				-- Informar a todo el staff duty --
				if getElementData(thePlayer, "enc") == true then
					outputChatBox("[DUDA] Protección al staff Encubierto activa.", thePlayer, 0, 255, 0)
					--staffMessage("[DUDA] Un staff desde el servicio web ha resuelto la duda de [" .. exports.players:getID( other ) .. "] "  .. name .. ".")
					--adminMessage("[DUDA_ADMIN] Respuesta dada: " .. respuesta)
				else
					staffMessage("[DUDA] El staff "..getPlayerName(thePlayer):gsub("_", " ").." ha resuelto la duda de [" .. exports.players:getID( other ) .. "] "  .. name .. ".")
					adminMessage("[DUDA_ADMIN] Respuesta dada: " .. respuesta)
				end
				-- Sistema AntiAbsusos de Dudas
				if other == thePlayer then
					banPlayer(thePlayer, true, true, true, "AntiAbuso DTRP", "Seteo de Dudas Resueltas", 0)
				end
				local dudaID = getElementData(other, "dudaID")
				exports.sql:query_free("UPDATE `dudas` SET `userIDStaff` = '"..exports.players:getUserID(thePlayer).."',`dudaRespuesta` = '"..tostring(respuesta).."' WHERE `dudaID` = "..tostring(dudaID))
				setElementData(other, "valorarDuda", tostring(dudaID))
				removeElementData(other, "dudaID")
			else
				outputChatBox("[DUDA] El jugador seleccionado no tiene una duda pendiente. Se la habrá resuelto otro staff.", thePlayer, 0, 200, 0)
			end
		else
			outputChatBox("Síntaxis: /resolverduda [id] [respuesta]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("Acceso denegado", thePlayer, 255, 0, 0)
	end
end

addCommandHandler("resolverduda", resolverDuda)
addCommandHandler("rd", resolverDuda)

function gestionDudas(source)
	if hasObjectPermissionTo( source, "command.acceptreport", false ) then
		hd = false
		for key2, value2 in ipairs( getElementsByType("player") ) do
			if getElementData(value2, "laduda") then
				hd = true
				outputChatBox("[DUDA] [" .. exports.players:getID( value2 ) .. "] "  .. getPlayerName( value2 ):gsub( "_", " " ) .. " tiene una duda pendiente. Usa /gd " .. exports.players:getID( value2 ) .. " para saber qué pregunta.", source, 255, 204, 255)
			end
		end
		if hd == false then
			outputChatBox("[DUDA] No hay dudas pendientes.",source, 255, 204, 255)
		end
	else
		outputChatBox("(( Acceso Denegado ))", source, 255, 0, 0)
	end
end
addCommandHandler("dudas", gestionDudas)


function gestionarDuda (thePlayer, commandName, otherPlayer)
	if hasObjectPermissionTo( thePlayer, "command.acceptreport", false ) then
		local other, name = exports.players:getFromName(thePlayer, otherPlayer, true)
		if other and thePlayer then
			if getElementData(other, "laduda") then
				outputChatBox("[DUDA] ID [" .. exports.players:getID( other ) .. "] pregunta: ".. tostring(getElementData(other, "laduda")), thePlayer, 255, 204, 255)
			else
				outputChatBox("[DUDA] Este jugador no tiene una duda pendiente.",thePlayer, 255, 204, 255)
			end
		end
	else
		outputChatBox("(( Acceso Denegado ))", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("gd", gestionarDuda)

function anularDuda (thePlayer)
	if thePlayer then
		if getElementData(thePlayer, "laduda") then
			removeElementData(thePlayer, "laduda")
			local dudaID = getElementData(thePlayer, "dudaID")
			exports.sql:query_free("UPDATE `dudas` SET `userIDStaff` = '-3',`dudaRespuesta` = 'Duda anulada por el usuario.' WHERE `dudaID` = "..tostring(dudaID))
			staffMessage( "[DUDA] El jugador [" .. exports.players:getID( thePlayer ) .. "] "  .. getPlayerName( thePlayer ):gsub( "_", " " ) .. " ha anulado su duda." )
			outputChatBox("[DUDA] Has anulado tu duda correctamente. Puedes volver a utilizar el /duda.", thePlayer, 0, 255, 0)
			removeElementData(thePlayer, "dudaID")
		else
			outputChatBox("[DUDA] No tienes ninguna duda pendiente para anular.", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("aduda", anularDuda)

function onDuty (thePlayer)
	if hasObjectPermissionTo( thePlayer, "command.acceptreport", false ) then
		if exports.players:getOption(thePlayer, "staffduty") == true or exports.players:getOption(thePlayer, "helpduty") == true then
		local nndudas = recuentoEmergencia()
		outputChatBox("Bienvenido, "..getPlayerName(thePlayer):gsub("_", " ")..". Actualmente hay:",thePlayer,0,255,0)
			if nndudas == 0 then
				outputChatBox("No hay ninguna duda sin resolver.",thePlayer,0,255,0)
			elseif nndudas == 1 then
				outputChatBox("- 1 duda sin resolver.",thePlayer,0,255,0)
			elseif nndudas >= 2 then
				outputChatBox("- "..tostring(nndudas).." dudas sin resolver.",thePlayer,0,255,0)
			end
		else
			outputChatBox("Hasta luego "..getPlayerName(thePlayer):gsub("_", " ")..". Recuerda usar /dudas de vez en cuando.",thePlayer,0,255,0)
		end	
	else return end
end
addEvent("onAvisarDudas", true)
addEventHandler("onAvisarDudas", getRootElement(), onDuty)


function recuentoEmergencia()
	recuento = 0
	for k, v in ipairs (getElementsByType("player")) do
		if getElementData(v, "laduda") then
			recuento = recuento + 1
		end
	end
	return tonumber(recuento)
end
addEventHandler("onResourceStart", getResourceRootElement(), recuentoEmergencia)
addEventHandler("onResourceRestart", getResourceRootElement(), recuentoEmergencia)

function consultarMisDudas (player)
	if player and hasObjectPermissionTo( player, "command.acceptreport", false ) then
		local sql1 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasResueltas FROM dudas WHERE userIDStaff = "..exports.players:getUserID(player))
		local sql2 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasValoradas FROM dudas WHERE valoracion > -1 AND userIDStaff = "..exports.players:getUserID(player))
		local sql3 = exports.sql:query_assoc_single("SELECT SUM(valoracion) AS puntosDudas FROM dudas WHERE valoracion > -1 AND userIDStaff = "..exports.players:getUserID(player))
		outputChatBox("Has resuelto un total de "..tostring(sql1.dudasResueltas)..", de las cuales te han valorado "..tostring(sql2.dudasValoradas)..".", player, 0, 255, 0)
		if tonumber(sql2.dudasValoradas) > 0 then
			outputChatBox("Nota media de las dudas resueltas: "..tostring(sql3.puntosDudas/sql2.dudasValoradas)..".", player, 0, 255, 0)
		end
	end
	outputChatBox("~~Estadísticas Generales~~", player, 255, 255, 255)
	local sql4 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasTotales FROM dudas")
	local sql5 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasAnuladas FROM dudas WHERE userIDStaff = -3")
	local sql6 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasAuto FROM dudas WHERE userIDStaff = -2")
	local sql7 = exports.sql:query_assoc_single("SELECT SUM(valoracion) AS puntosDudasTotales FROM dudas WHERE valoracion > -1")
	local sql8 = exports.sql:query_assoc_single("SELECT COUNT(dudaID) AS dudasTotalesValoradas FROM dudas WHERE valoracion > -1")
	outputChatBox("Hay un total de "..tostring(sql4.dudasTotales).." dudas emitidas por usuarios.", player, 0, 255, 0)
	outputChatBox("Se han anulado "..tostring(sql5.dudasAnuladas).." dudas y el Sistema Automático ha resuelto "..tostring(sql6.dudasAuto).." dudas.", player, 0, 255, 0)
	outputChatBox("Valoración Global del Staff: "..sql7.puntosDudasTotales/sql8.dudasTotalesValoradas, player, 255, 255, 255)
end
addCommandHandler("misdudas", consultarMisDudas)
addCommandHandler("edudas", consultarMisDudas)

function valorarStaff (player, cmd, nota)
	if player and nota and tonumber(nota) and tonumber(nota) >= 0 and tonumber(nota) <= 10 then
		local dudaID = getElementData(player, "valorarDuda")
		if dudaID then
			exports.sql:query_free("UPDATE `dudas` SET `valoracion` = '"..tostring(nota).."' WHERE `dudaID` = "..tostring(dudaID))
			outputChatBox("Has dado "..tostring(nota).." puntos al staff que te atendió. ¡Gracias por ayudarnos a mejorar!", player, 0, 255, 0)
			removeElementData(player, "valorarDuda")
		else
			outputChatBox("Se ha producido un error grave, notifica a un Desarrollador.", player, 255, 0, 0)
		end
	end
end
addCommandHandler("valorar", valorarStaff)