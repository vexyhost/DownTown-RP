--[[
Copyright (c) 2018 DownTown County Roleplay

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

local operativo = false

local objetivosPorNivel =
    {
        [ 1 ] = 1,
		[ 2 ] = 1,
		[ 3 ] = 1,
		[ 4 ] = 1,
		[ 5 ] = 1,
		[ 6 ] = 1,
		[ 7 ] = 1,
		[ 8 ] = 1,
		[ 9 ] = 1,
		[ 10 ] = 1,
		[ 11 ] = 2,
		[ 12 ] = 2,
		[ 13 ] = 2,
		[ 14 ] = 2,
		[ 15 ] = 2,
		[ 16 ] = 2,
		[ 17 ] = 2,
		[ 18 ] = 2,
		[ 19 ] = 2,
		[ 20 ] = 2,
		[ 21 ] = 3,
		[ 22 ] = 3,
		[ 23 ] = 3,
		[ 24 ] = 3,
		[ 25 ] = 3,
		[ 26 ] = 3,
		[ 27 ] = 3,
		[ 28 ] = 3,
		[ 29 ] = 3,
		[ 30 ] = 3,
		[ 31 ] = 3,
		[ 32 ] = 3,
		[ 33 ] = 3,
		[ 34 ] = 4,
		[ 35 ] = 4,
		[ 36 ] = 4,
		[ 37 ] = 4,
		[ 38 ] = 4,
		[ 39 ] = 4,
		[ 40 ] = 4,
		[ 41 ] = 4,
		[ 42 ] = 4,
		[ 43 ] = 4,
		[ 44 ] = 4,
		[ 45 ] = 4,
		[ 46 ] = 4,
    } 

function getObjetivos(characterID)
	local sql = exports.sql:query_assoc_single("SELECT objetivos FROM characters WHERE characterID = "..characterID)
	if not sql then return "" end
	if sql.objetivos then
		return split(tostring(sql.objetivos), ",")
	else
		return false
	end
end

function getNivel(characterID, ignoreOperativo)
	if operativo == false and not ignoreOperativo == true then return 10 end
	local sql = exports.sql:query_assoc_single("SELECT nivel FROM characters WHERE characterID = "..characterID)
	if not sql then return -1 end
	if sql.nivel then
		return tonumber(sql.nivel)
	else
		return -1
	end
end

function getTituloObjetivo(objetivoID)
	local sql = exports.sqlobjetivos:query_assoc_single("SELECT titulo FROM objetivos WHERE objetivoID = "..objetivoID)
	if not sql then return -1 end
	if sql.titulo then
		return tostring(sql.titulo)
	else
		return -1
	end
end

function isObjetivoCompletado(objetivoID, characterID)
	if operativo == false then return true end
	if not characterID or not objetivoID or not tonumber(characterID) or not tonumber(objetivoID) then return false end
	-- Primero obtenemos los objetivos que tiene el characterID especificado
	local objetivos = getObjetivos(characterID)
	if objetivos then
		for k, v in ipairs(objetivos) do
			if tostring(v) == tostring(objetivoID) then
				return true
			end
		end
		return false
	else
		return false
	end
end

function addObjetivo(objetivoID, characterID, player)
	if operativo == false then return true end
	if objetivosPorNivel[objetivoID] == getNivel(characterID) then
		if not characterID or not objetivoID or not tonumber(characterID) or not tonumber(objetivoID) then return false end
		if isObjetivoCompletado(objetivoID, characterID) then return false end
		-- Primero obtenemos los objetivos que tiene el characterID especificado
		local objetivos = getObjetivos(characterID)
		local strObjetivos = ''
		local t = 0
		if objetivos then
			for k, v in ipairs(objetivos) do
				if t == 0 then
					strObjetivos = tostring(v)
				else -- Último slot ()
					strObjetivos = strObjetivos..','..tostring(v)
				end
				t = t + 1
			end
		end
		-- Notificamos al usuario de que ha completado un objetivo (si hay)
		if player then
			local nombreObj = getTituloObjetivo(objetivoID)
			triggerClientEvent( player, "gui:hint", player, "Objetivo completado", "¡Enhorabuena! Has completado el objetivo '"..nombreObj.."'.", 1 )
		end
		-- Ahora añadimos el nuevo objetivo a la cadena, y lo mandamos a SQL.
		if t < 9 and t > 0 then
			local strObjetivos = strObjetivos..','..tostring(objetivoID)
			exports.sql:query_free( "UPDATE characters SET objetivos = '%s' WHERE characterID = " .. characterID, strObjetivos )
		elseif t == 0 then
			local strObjetivos = tostring(objetivoID)
			exports.sql:query_free( "UPDATE characters SET objetivos = '%s' WHERE characterID = " .. characterID, strObjetivos )
		else -- Se ha completado 1 nivel. Solicitamos vaciar objetivos y el aumento de nivel para dicho characterID.
			local strObjetivos = strObjetivos..','..tostring(objetivoID)
			exports.sql:query_free( "UPDATE characters SET nivel = nivel + 1 WHERE characterID = " .. characterID )
			exports.sql:query_free( "UPDATE characters SET objetivos = '' WHERE characterID = " .. characterID )
		end
		return true
	end
end  

function solicitarGUIObjetivos(player)
	if exports.players:isLoggedIn(player) and operativo == true then
		-- Primero obtenemos el nivel del PJ.
		local characterID = exports.players:getCharacterID(player)
		-- Solicitamos su retroactividad
		retroactividadObjetivos(characterID)
		local nivel = getNivel(characterID)
		-- Ahora obtenemos los objetivos del nivel que tiene el usuario y los que ya tiene hechos.
		local sql = exports.sqlobjetivos:query_assoc("SELECT * FROM `objetivos` WHERE `nivel` = "..nivel)
		local sql2 = getObjetivos(characterID)
		-- Por último mandamos estos datos al cliente.
		if tostring(sql2) == "" then
			triggerClientEvent(player, "onAbrirGuiObjetivos", player, sql, false, nivel)
		else
			triggerClientEvent(player, "onAbrirGuiObjetivos", player, sql, sql2, nivel)
		end
	end
end
--addCommandHandler("objetivos", solicitarGUIObjetivos) DESCOMENTAR SI EL SISTEMA SE HABILITA

function retroactividadObjetivos(characterID)
	if characterID then
		local nivel = getNivel(characterID, true)
		if nivel == 1 then
			-- Objetivo 1: carnet de conducir --
			local sql = exports.sql:query_assoc_single("SELECT car_license FROM characters WHERE characterID = "..characterID)
			if sql and sql.car_license then
				if tonumber(sql.car_license) > 1 then -- Tiene licencia
					addObjetivo(1, characterID)
				end
			end
			-- Objetivo 8: teléfono móvil --
			local sql2 = exports.sql:query_assoc_single("SELECT registro_ID FROM tlf_data WHERE titular = "..characterID)
			if sql2 and sql2.registro_ID then
				addObjetivo(8, characterID)
			end
			-- Objetivo 9: reloj --
			local sql3 = exports.sql:query_assoc_single("SELECT index FROM items WHERE item = 9 AND owner = "..characterID)
			if sql3 and sql3.index then 
				addObjetivo(9, characterID)
			end
		elseif nivel == 2 then
			-- Objetivo 12: facción --
			local sql = exports.sql:query_assoc_single("SELECT factionID FROM character_to_factions WHERE characterID = "..characterID)
			if sql and sql.factionID then
				addObjetivo(12, characterID)
			end
		elseif nivel == 3 then
			-- Objetivo 27 (casarse) y 30 (licencia armas)  --
			local sql = exports.sql:query_assoc_single("SELECT gun_license, casadocon FROM characters WHERE characterID = "..characterID)
			if sql and sql.casadocon then
				if tonumber(sql.casadocon) > 1 then
					addObjetivo(27, characterID)
				end
			end
			if sql and sql.gun_license then
				if tonumber(sql.gun_license) >= 1 then -- Tiene licencia
					addObjetivo(30, characterID)
				end
			end
		end
	end
end