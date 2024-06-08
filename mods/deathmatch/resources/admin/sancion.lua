
local sanciones = {
	[-1] = "Liberación de Jail",
	[1] = "#1 DM",
	[2] = "#2 PG / Forzar Rol",
	[3] = "#3 MG",
	[4] = "#4 RK",
	[5] = "#5 Flamming / IOOC / Mentir o ignorar Staff",
	[6] = "#6 Abuso Canal OOC / Cortar Rol",
	[7] = "#7 Troll / BD / CJ",
	[8] = "#8 SPAM (Publicidad)",
	[9] = "#9 BA",
	[10] = "#10 Multicuentas",
	[11] = "#11 NRE / NRH / NRC",
	[12] = "#12 Evasión De Rol",
	[13] = "#13 Reporte Innecesario (Reportante)",
	[14] = "#14 NA",
	[15] = "#15 Mal Uso /AD",
	[16] = "#16 Tener 2 PJ en una facción",
	[17] = "#17 Fuera de Zona de Rol",
	[18] = "#18 Buen rol / buena actuación",
}
--[[
LISTADO DE NORMAS Y SANCIONES.

#1 DM
	1º VEZ: 10 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ: 80 MINUTOS.
	5º VEZ: 120 MINUTOS.
	6º VEZ Y SUCESIVAS: 150 MINUTOS.
#2 PG / Forzar Rol
	1º VEZ: 10 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 60 MINUTOS.
	4º VEZ: 100 MINUTOS.
	5º VEZ: 140 MINUTOS.
	6º VEZ Y SUCESIVAS: 200 MINUTOS.
#3 MG
	1º VEZ: 10 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ: 100 MINUTOS.
	5º VEZ: 150 MINUTOS.
	6º VEZ Y SUCESIVAS: 200 MINUTOS.
#4 RK
	1º VEZ: 30 MINUTOS.
	2º VEZ: 60 MINUTOS.
	3º VEZ: 90 MINUTOS.
	4º VEZ: 140 MINUTOS.
	5º VEZ: 180 MINUTOS.
	6º VEZ Y SUCESIVAS: 300 MINUTOS.
#5 Faltas Respeto / Mentir o ignorar Staff
	1º VEZ: 30 MINUTOS.
	2º VEZ: 60 MINUTOS.
	3º VEZ: 150 MINUTOS.
	4º VEZ: 300 MINUTOS.
	5º VEZ Y SUCESIVAS: BAN DE 1 SEMANA.
#6 Abuso Canal OOC / Cortar Rol
	1º VEZ: 20 MINUTOS.
	2º VEZ: 40 MINUTOS.
	3º VEZ: 120 MINUTOS.
	4º VEZ: 300 MINUTOS.
	5º VEZ Y SUCESIVAS: 500 MINUTOS.
#7 Troll / BD / CJ
	1º VEZ: 5 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ: 80 MINUTOS.
	5º VEZ: 120 MINUTOS.
	6º VEZ Y SUCESIVAS: 300 MINUTOS.
#8 SPAM
	1º VEZ: BAN DE 1 DÍA.
	2º VEZ: BAN DE 5 DÍAS.
	3º VEZ: BAN DE 30 DÍAS.
	4º VEZ Y SUCESIVAS: BAN DE 180 DÍAS.
#9 BA
	// Sólo se aplicará en bugs GRAVES. Además, conllevará CK de todos los PJ de la cuenta.
	1º VEZ: BAN DE 7 DÍAS.
	2º VEZ: BAN DE 15 DÍAS.
	3º VEZ: BAN DE 40 DÍAS.
	4º VEZ Y SUCESIVAS: BAN DE 180 DÍAS.
#10 Multicuentas
	// Sólo se aplicará en multicuentas GRAVES. Además, conllevará CK de todos los PJ de la cuenta.
	1º VEZ: BAN DE 7 DÍAS.
	2º VEZ: BAN DE 15 DÍAS.
	3º VEZ: BAN DE 40 DÍAS.
	4º VEZ Y SUCESIVAS: BAN DE 180 DÍAS.
#11 NRE / NRH / NRC
	1º VEZ: 20 MINUTOS.
	2º VEZ: 40 MINUTOS.
	3º VEZ: 120 MINUTOS.
	4º VEZ: 300 MINUTOS.
	5º VEZ Y SUCESIVAS: 500 MINUTOS.
#12 Evasión de Rol
	//Conllevaria el CK hasta que se reanude el rol.
	1º VEZ: 30 MINUTOS.
	2º VEZ: 60 MINUTOS.
	3º VEZ: 120 MINUTOS.
	4º VEZ: 300 MINUTOS.
	5º VEZ Y SUCESIVAS: 500 MINUTOS.
#13 Reporte Innecesario (Reportante)
	1º VEZ: 5 MINUTOS.
	2º VEZ: 20 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ: 60 MINUTOS.
	5º VEZ Y SUCESIVAS: 80 MINUTOS.
#14 NA
	//Conlleva CK auto a la cuenta.
	1º VEZ: BAN DE 7 DÍAS.
	2º VEZ: BAN DE 15 DÍAS.
	3º VEZ: BAN DE 40 DÍAS.
	4º VEZ Y SUCESIVAS: BAN DE 180 DÍAS.
#15 Mal Uso /AD
	1º VEZ: 5 MINUTOS.
	2º VEZ: 15 MINUTOS.
	3º VEZ: 40 MINUTOS.
	4º VEZ Y SUCESIVAS: 60 MINUTOS.
#16 Tener 2 PJ en una facción
	1º VEZ: 25 MINUTOS.
	2º VEZ: 85 MINUTOS.
	3º VEZ: 300 MINUTOS.
	4º VEZ Y SUCESIVAS: BAN DE 7 DÍAS.
#17 Monopolio
	SANCIÓN FIJA REGULADA POR EL SISTEMA DE ZONA.
]]

function getVecesSancionado(player, norma)
	if player and norma then
		local userID = exports.players:getUserID(player)
		local sql = exports.sql:query_assoc_single("SELECT COUNT(*) AS cuenta FROM sanciones WHERE validez = 1 AND userID = "..userID.." AND regla = "..norma)
		return tonumber(sql.cuenta)
	end
end

--[[

Esta función devuelve el tipo de sanción y el tiempo en minutos.
Tipo 1 = Jail
Tipo 2 = Ban
Tipo 3 = Ban + AutoCK de TODOS los PJ de la cuenta.
Tipo 4 = Punto positivo, sin sancion
]]
function calcularSancion(player, norma)
	local vez = getVecesSancionado(player, norma)+1
	if norma == 1 then -- #1 DM / DMCar
		if vez == 1 then 
			return 1, 10
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 80
		elseif vez == 5 then
			return 1, 120
		elseif vez >= 6 then
			return 1, 150
		end
	elseif norma == 2 then -- #2 PG
		if vez == 1 then 
			return 1, 10
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 60
		elseif vez == 4 then
			return 1, 100
		elseif vez == 5 then
			return 1, 140
		elseif vez >= 6 then
			return 1, 200
		end
	elseif norma == 3 then -- #3 MG / MK
		if vez == 1 then 
			return 1, 10
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 100
		elseif vez == 5 then
			return 1, 150
		elseif vez >= 6 then
			return 1, 200
		end
	elseif norma == 4 then -- #4 RK
		if vez == 1 then 
			return 1, 30
		elseif vez == 2 then
			return 1, 60
		elseif vez == 3 then
			return 1, 90
		elseif vez == 4 then
			return 1, 140
		elseif vez == 5 then
			return 1, 180
		elseif vez >= 6 then
			return 1, 300
		end
	elseif norma == 5 then -- #5 Faltas Respeto / Mentir o ignorar Staff
		if vez == 1 then 
			return 1, 30
		elseif vez == 2 then
			return 1, 60
		elseif vez == 3 then
			return 1, 150
		elseif vez == 4 then
			return 1, 300
		elseif vez >= 5 then
			return 2, 10080
		end
	elseif norma == 6 then -- #6 Abuso Canal OOC / Cortar Rol
		if vez == 1 then 
			return 1, 20
		elseif vez == 2 then
			return 1, 40
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 300
		elseif vez >= 5 then
			return 1, 500
		end
	elseif norma == 7 then -- #7 Troll / BD / CJ
		if vez == 1 then 
			return 1, 5
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 80
		elseif vez == 5 then
			return 1, 120
		elseif vez >= 6 then
			return 1, 300
		end
	elseif norma == 8 then -- #8 SPAM
		if vez == 1 then 
			return 2, 1440
		elseif vez == 2 then
			return 2, 7200
		elseif vez == 3 then
			return 2, 43200
		elseif vez >= 4 then
			return 2, 259200
		end
	elseif norma == 9 then -- #9 BA
		if vez == 1 then 
			return 3, 10080
		elseif vez == 2 then
			return 3, 21600
		elseif vez == 3 then
			return 3, 57600
		elseif vez >= 4 then
			return 3, 259200
		end
	elseif norma == 10 then -- #10 Multicuentas
		if vez == 1 then 
			return 3, 10080
		elseif vez == 2 then
			return 3, 21600
		elseif vez == 3 then
			return 3, 57600
		elseif vez >= 4 then
			return 3, 259200
		end
	elseif norma == 11 then -- #11 NRE / NRH / NRC
		if vez == 1 then 
			return 1, 20
		elseif vez == 2 then
			return 1, 40
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 300
		elseif vez >= 5 then
			return 1, 500
		end
	elseif norma == 12 then -- #12 Evasión de Rol
		if vez == 1 then 
			return 1, 20
		elseif vez == 2 then
			return 1, 40
		elseif vez == 3 then
			return 1, 120
		elseif vez == 4 then
			return 1, 300
		elseif vez >= 5 then
			return 1, 500
		end
	elseif norma == 13 then -- #13 Reporte Innecesario (Reportante)
		if vez == 1 then 
			return 1, 5
		elseif vez == 2 then
			return 1, 20
		elseif vez == 3 then
			return 1, 40
		elseif vez == 4 then
			return 1, 60
		elseif vez >= 5 then
			return 1, 80
		end
	elseif norma == 14 then -- #14 NA
		if vez == 1 then 
			return 3, 10080
		elseif vez == 2 then
			return 3, 21600
		elseif vez == 3 then
			return 3, 57600
		elseif vez >= 4 then
			return 3, 259200
		end
	elseif norma == 15 then -- #15 Mal Uso /AD
		if vez == 1 then 
			return 1, 5
		elseif vez == 2 then
			return 1, 15
		elseif vez == 3 then
			return 1, 40
		elseif vez >= 4 then
			return 1, 60
		end
	elseif norma == 16 then -- #16 Tener 2 PJ en una facción
		if vez == 1 then 
			return 1, 25
		elseif vez == 2 then
			return 1, 85
		elseif vez == 3 then
			return 1, 300
		elseif vez >= 4 then
			return 2, 10080
		end
	elseif norma == 17 then -- #17 Fuera de Zona de Rol
		return 1, 20
	elseif norma == 18 then -- #18 Buen rol / buena actuación
		return 4, 1
	else
		return 0, 0
	end
end	

function GUIsancionarUsuario(player, cmd, otherPlayer)
	if hasObjectPermissionTo( player, "command.modchat", false ) then
		if otherPlayer then
			local other, name = exports.players:getFromName(player, otherPlayer)
			if other then
				triggerClientEvent(player, "onAbrirGUISancionar", player, getPlayerName(other))
			end
		else
			outputChatBox("Sintaxis: /sancionar [jugador]", player, 255, 255, 255)
		end
	else
		outputChatBox("Acceso denegado.", player, 255, 0, 0)
	end
end
addCommandHandler("sancionar", GUIsancionarUsuario)

function GUIsancionesUsuario(player, cmd, otherPlayer)
	if otherPlayer then
		local other, name = exports.players:getFromName(player, otherPlayer)
		if other then
			local sql = exports.sql:query_assoc("SELECT * FROM sanciones WHERE userID = "..exports.players:getUserID(other))
			if hasObjectPermissionTo( player, "command.modchat", false ) then
				triggerClientEvent(player, "onAbrirGUIVerSanciones", player, sql, name, true)
			else
				triggerClientEvent(player, "onAbrirGUIVerSanciones", player, sql, name, false)
			end
		end
	else
		outputChatBox("Sintaxis: /sanciones [jugador]", player, 255, 255, 255)
	end
end
addCommandHandler("sanciones", GUIsancionesUsuario)

function aplicarSancion(nplayer, norma, textonorma)
	if source and client and source == client and hasObjectPermissionTo( source, "command.modchat", false ) and nplayer and norma and textonorma then
		local player = getPlayerFromName(nplayer)
		if not player then 
			outputDebugString("NO SE HA DETECTADO EL JUGADOR!!!!")
			-- Hacer que el staff pueda dar ban de 2 semanas en caso de evadir sanción.
		else
			local userID = exports.players:getUserID(player)
			local userIDStaff = exports.players:getUserID(source)
			local tipoSancion, minutos = calcularSancion(player, tonumber(norma))
			if tipoSancion == 0 then
				outputChatBox("Se ha detectado avería interna. Avisa a un desarrollador.", source,  255, 0, 0)
			elseif tipoSancion == 1 then -- Jail
				exports.jail:jailPlayer(source, player, minutos, tostring(textonorma))
			elseif tipoSancion == 2 then -- Ban
				exports.admin:aplicarBan(2, tostring(getPlayerSerial(player)), (minutos/60), tostring(textonorma), thePlayer)
			elseif tipoSancion == 3 then -- Ban + AutoCK
				local characters = exports.sql:query_assoc("SELECT * FROM characters WHERE CKuIDStaff = 0 AND userID = "..userID)
				for k, v in ipairs(characters) do
					exports.sql:query_free("UPDATE `characters` SET `CKuIDStaff` = 99999999 WHERE `characterID` = "..tostring(v.characterID))
				end
				exports.admin:aplicarBan(2, tostring(getPlayerSerial(player)), (minutos/60), tostring(textonorma), thePlayer)
			elseif tipoSancion == 4 then
				outputChatBox("Has dado un toque positivo correctamente.", source, 255, 0, 0 )
			end
			local sancionID = exports.sql:query_insertid( "INSERT INTO sanciones (userID, staffID, regla, validez) VALUES (" .. table.concat( { userID, userIDStaff, norma, 1 }, ", " ) .. ")" )
		end
	end
end
addEvent("onAplicarSancionAUsuario", true)
addEventHandler("onAplicarSancionAUsuario", getRootElement(), aplicarSancion)

function removerSancion(nplayer, idsancion)
	if source and client and source == client and hasObjectPermissionTo( source, "command.modchat", false ) and nplayer and idsancion then
		local player = getPlayerFromName(nplayer:gsub(" ", "_"))
		if not player then 
			outputChatBox("No puedes remover una sanción de alguien que no está conectado.", source, 255, 0, 0)
			return
		else
			local sql = exports.sql:query_assoc_single("SELECT * FROM sanciones WHERE sancionID = "..idsancion)
			if sql then
				local staffID = exports.players:getUserID(source)
				local staffIDSancionador = sql.staffID
				if tonumber(staffID) == tonumber(staffIDSancionador) or tonumber(sql.regla) == 17 then
					exports.sql:query_free("UPDATE sanciones SET validez = 0 WHERE sancionID = "..idsancion)
					outputChatBox("Has anulado correctamente la sanción.", source, 0, 255, 0)
					if getElementData(player, "tjail") and getElementData(player, "tjail") >= 0 then -- Eliminar jail.
						outputChatBox("El jugador sigue en jail. Usa /unjail "..tostring(idsancion).." para sacarlo.", source, 255, 0, 0)
					end
				else
					outputChatBox("¡No puedes anular una sanción que no has dado tú!", source,  255, 0, 0)
					return
				end
			else
				outputChatBox("Esta sanción ya ha sido anulada.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("onRemoverSancionAUsuario", true)
addEventHandler("onRemoverSancionAUsuario", getRootElement(), removerSancion)