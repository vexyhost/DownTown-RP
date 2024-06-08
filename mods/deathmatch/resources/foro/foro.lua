--[[
Copyright (c) 2020 DownTown Roleplay

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

local enabled = false -- Poner en true si se utilizará el sistema de vinculación y sincronización con un foro SMF.
   
function checkUsernameForum ()
	if enabled == false then return end
	local userID = exports.players:getUserID(source)
	local sql = exports.sqllogin:query_assoc_single("SELECT userIDForo FROM usuarios WHERE estado = 1 AND userIDIG = " .. tonumber(userID))
	if sql then
		if tonumber(getUserIDForo(userID)) then -- El usuario está activado
			actualizarPermisosEnForo(userID)
		end
	end
end
addEventHandler("onCharacterLogin", getRootElement(), checkUsernameForum)

function recargaPermisosAll ()
	outputDebugString("Recargando...")
	local sqlu = exports.sql:query_assoc("SELECT userID from wcf1_user")
	for k, v in ipairs(sqlu) do
		local sql = exports.sqllogin:query_assoc_single("SELECT userIDForo FROM usuarios WHERE estado = 1 AND userIDIG = " .. tonumber(v.userID))
		if sql then
			if tonumber(getUserIDForo(v.userID)) then -- El usuario está activado
				actualizarPermisosEnForo(v.userID)
			end
		end
	end
	outputDebugString("Recarga de permisos llevada con éxito")
end
--addCommandHandler("rpermf", recargaPermisosAll)

function getUserIDForo(userID)
	local sql = exports.sqllogin:query_assoc_single("SELECT userIDForo FROM usuarios WHERE estado = 1 AND userIDIG = " .. tonumber(userID))
	if sql then
		if tonumber(sql.userIDForo) then -- El usuario está activado
			return tonumber(sql.userIDForo)
		end
	end
end

function tienePJEnEseGrupo(userID, groupID)
	if userID and groupID and groupID > 3 and (groupID < 12 or groupID > 14) then
		local sql = exports.sql:query_assoc_single("SELECT factionID FROM factions WHERE groupID = "..groupID)
		if sql then
			local result = exports.sql:query_assoc_single( "SELECT COUNT(*) AS number FROM character_to_factions cf LEFT JOIN characters c ON c.characterID = cf.characterID WHERE cf.factionID = " .. sql.factionID .. " AND c.userID = " .. userID )
			if result.number == 0 then
				exports.sql:query_free( "DELETE FROM wcf1_user_to_groups WHERE userID = " .. tostring(userID) .. " AND groupID = " .. tostring(groupID) )
				exports.logs:addLogMessage("logFORO2", "AVERIA uID "..tostring(userID).." faction "..tostring(sql.factionID))
				return false
			else
				return true
			end
		else
			return false
		end
	else
		return true
	end
end

function tieneFaccionAsociada(groupID)
	if groupID then
		local sql = exports.sql:query_assoc_single("SELECT groupID FROM wcf1_group WHERE canBeFactioned = 1 AND groupID = "..tostring(groupID))
		if (sql) then
			if tonumber(sql.groupID) == tonumber(groupID) then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

function actualizarPermisosEnForo(userID)
	if enabled == false then return end
	if not userID then return false end
	local userIDForo = getUserIDForo(userID)
	if not userIDForo then return false end
	-- Primero eliminamos sus permisos en foro.
	exports.sqlforo:query_free("UPDATE `smf_members` SET `additional_groups` = '' WHERE `id_member` = "..tonumber(userIDForo))
	-- Después, solicitamos en cuántos grupos está el usuario.
	local c3 = exports.sql:query_assoc("SELECT groupID FROM wcf1_user_to_groups WHERE userID = "..tonumber(userID))
	if c3 then
		grupoStr = ""
		for k, v in ipairs(c3) do
			if tieneFaccionAsociada(tonumber(v.groupID)) then
				if tienePJEnEseGrupo(tonumber(userID), tonumber(v.groupID)) then
					local c4 = exports.sql:query_assoc_single("SELECT groupIDForo FROM wcf1_group WHERE groupID = "..tonumber(v.groupID))
					if c4 and c4.groupIDForo then
						grupoStr = grupoStr..""..tostring(c4.groupIDForo)..","
					end
				else
					exports.logs:addLogMessage("error-foro-permisos", "uID "..tostring(userID).." no se pudo actualizar permisos de foro E1.")
					actualizarPermisosEnForo(userID)
					return
				end
			else
				-- Grupos staff que no tienen facciones
				local c4 = exports.sql:query_assoc_single("SELECT groupIDForo FROM wcf1_group WHERE groupID = "..tonumber(v.groupID))
				if c4 and c4.groupIDForo then
					grupoStr = grupoStr..""..tostring(c4.groupIDForo)..","
				end
			end
		end
		-- Comprobación: ¿es dueño de una facción?
		if exports.factions:isFactionOwner2(userID) then
			grupoStr = grupoStr.."18,"
		end
		-- Fin Comprobación: ¿es dueño de una facción?
		-- Parche , final
		local lastChar = string.sub(grupoStr, -1)
		if lastChar == "," then
			grupoStr = string.sub(grupoStr, 1, string.len(grupoStr)-1)
		end
		-- Fin Parche , final
		exports.sqlforo:query_free("UPDATE smf_members SET `additional_groups` = '%s' WHERE `id_member` = "..tonumber(userIDForo), tostring(grupoStr))
		-- Ahora solicitamos el grupo primario que tiene seleccionado el usuario en foro
		-- Si el grupo que tiene seleccionado no está en grupoStr entonces es que no debería de estar en él
		-- Y como NO debería de ser el principal, solicitamos la eliminación.
		local sql = exports.sqlforo:query_assoc_single("SELECT id_group FROM smf_members WHERE id_member = "..tonumber(userIDForo))
		if tonumber(sql.id_group) then
			if tonumber(sql.id_group) ~= 6 then
				local px = string.find(tostring(grupoStr), tostring(sql.id_group))
				if px and tonumber(px) >= 1 then
					-- Es un poco raro esto, pero es que si string.find no lo encuentra, no devuelve false...
				else
					exports.sqlforo:query_free("UPDATE smf_members SET `id_group` = '6' WHERE `id_member` = "..tonumber(userIDForo))
				end
			end
		else
			exports.logs:addLogMessage("error-foro-permisos", "uID "..tostring(userID).." no se pudo actualizar permisos de foro E2.")
			actualizarPermisosEnForo(userID)
			return
		end
	end
end

function initLinkForum(player)
	if exports.players:isLoggedIn(player) then
		local userID = exports.players:getUserID(player)
		local sql = exports.sqllogin:query_assoc_single("SELECT userIDForo FROM usuarios WHERE estado = 1 AND userIDIG = " .. tonumber(userID))
		if sql then
			if tonumber(getUserIDForo(userID)) then -- El usuario está activado
				local userIDForo = tonumber(getUserIDForo(userID))
				-- Obtenemos el nombre de la cuenta de foro.
				local sql_member_name = exports.sqlforo:query_assoc_single("SELECT member_name FROM smf_members WHERE id_member = "..userIDForo)
				if sql_member_name then
					outputChatBox("Actualmente tu cuenta IG está vinculada a la cuenta de foro: "..tostring(sql_member_name.member_name), player, 0, 255, 0)
					outputChatBox("Si deseas anular dicha vinculación, acude al CAU. (cau.dt-mta.com)", player, 255, 255, 255)
				else
					outputChatBox("Existe un problema grave con tu cuenta, acude al CAU (cau.dt-mta.com)", player, 255, 0, 0)
					outputChatBox("Esto puede pasar, si por ejemplo, has eliminado tu cuenta de foro.", player, 0, 255, 0)
					outputChatBox("Aporta este código de error: LF-"..tostring(userID).."-"..tostring(userIDForo), player, 255, 255, 255)
				end
			end
		else
			triggerClientEvent(player, "onRequestWindowLinkForum", player)
		end
	end
end
addCommandHandler("foro", initLinkForum)

function urlEncode(str) 
    if (str) then 
        str = string.gsub (str, "\n", "\r\n") 
        str = string.gsub (str, "([^%w %-%_%.%~])", 
            function (c) return string.format ("%%%02X", string.byte(c)) end) 
        str = string.gsub (str, " ", "+") 
    end 
    return str 
end 


function linkAccountForum(uForo, cForo)
	if source and client and source == client then
		-- First we need to check if username exists.
		local sql_check = exports.sqlforo:query_assoc_single("SELECT id_member FROM `smf_members` WHERE `member_name` LIKE '%s'", tostring(uForo))
		if sql_check then
			if tonumber(sql_check.id_member) > 0 then
				-- Username exists! Now, we should check if password is correct.
				fetchRemote("https://login.dt-mta.com/activacion_ig.php?usuario_foro="..tostring(urlEncode(uForo)).."&clave_foro="..tostring(cForo).."&uIDIG="..tostring(exports.players:getUserID(client)).."&token=yo5345azxd3ey7unvbapolki1q2wAu7y28jXv790ReqwAZs2Q9iusacVX9o", "q_forum", 1, 10000, resultlinkAccountForum, nil, false, client, uForo, cForo)
			end
		else
			-- Doesn't exist, request to PHP API registration of that username.
			fetchRemote("https://foro.dt-mta.com/register_ig.php?usuario_foro="..tostring(urlEncode(uForo)).."&clave_foro="..tostring(cForo), "q_forumr", 1, 10000, resultCreateAccountForum, nil, false, client, uForo, cForo)
		end
	end	
end
addEvent("onRequestLinkWithAccountForum", true)
addEventHandler("onRequestLinkWithAccountForum", getRootElement(), linkAccountForum)

function resultlinkAccountForum(data, errorCode, player, uForo, cForo)
	if errorCode == 0 and data then
		if tostring(data) == "0" then
			outputChatBox("¡Se ha vinculado la cuenta correctamente!", player, 0, 255, 0)
			outputChatBox("Usuario Foro: "..tostring(uForo), player, 0, 255, 0)
			outputChatBox("Clave Foro: "..tostring(cForo), player, 0, 255, 0)
			outputChatBox("Ya puedes acudir a foro.dt-mta.com e iniciar sesión.", player, 255, 255, 255)
		elseif tostring(data) == "1" then
			outputChatBox("Al parecer la cuenta de foro ("..tostring(uForo)..") ya está vinculada a otra cuenta IG.", player, 255, 0, 0)
			outputChatBox("Contacta con un Desarrollador para obtener más información.", player, 255, 255, 255)
		elseif tostring(data) == "2" then
			outputChatBox("La contraseña que has introducido ("..tostring(cForo)..") no coincide con la de la cuenta "..tostring(uForo)..".", player, 255, 0, 0)
			outputChatBox("Inténtalo de nuevo o visita el CAU (cau.dt-mta.com)", player, 255, 0, 0)
		else
			outputChatBox("Se ha producido un error grave. Inténtalo de nuevo más tarde.", player, 255, 0, 0)
		end
	else
		outputChatBox("Se ha producido un error (código "..tostring(errorCode).."). Inténtalo más tarde.", player, 255, 0, 0)
	end
end

function resultCreateAccountForum(data, errorCode, player, uForo, cForo)
	if errorCode == 0 and data then
		if tostring(data) == "1" then
			outputChatBox("¡Se ha creado la cuenta correctamente!", player, 0, 255, 0)
			outputChatBox("Solicitando vinculación a tu cuenta IG...", player, 255, 255, 255)
			fetchRemote("https://login.dt-mta.com/activacion_ig.php?usuario_foro="..tostring(urlEncode(uForo)).."&clave_foro="..tostring(cForo).."&uIDIG="..tostring(exports.players:getUserID(player)).."&token=yo5345azxd3ey7unvbapolki1q2wAu7y28jXv790ReqwAZs2Q9iusacVX9o", "q_forum", 1, 10000, resultlinkAccountForum, nil, false, player, uForo, cForo)
		else
			outputChatBox("Al parecer la cuenta de foro ("..tostring(uForo)..") ya existe.", player, 255, 0, 0)
			outputChatBox("Prueba con otro nombre de usuario.", player, 255, 255, 255)
		end
	else
		outputChatBox("Se ha producido un error (código "..tostring(errorCode).."). Inténtalo más tarde.", player, 255, 0, 0)
	end
end