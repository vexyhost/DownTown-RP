--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown County Roleplay

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

function getClothes(player)
	if exports.players:isLoggedIn(player) then
		local sql = exports.sql:query_assoc_single("SELECT clothes FROM characters WHERE characterID = "..exports.players:getCharacterID(player))
		if sql.clothes and tostring(sql.clothes) ~= "" then
			return split(tostring(sql.clothes), ",")
		else 
			return split(tostring("8,110,154"), ",")
		end
	else
		return split(tostring("8,110,154"), ",")
	end
end

function saveClothes (player)
	local skin = getElementModel(player)
	if skin == 0 then
		local strClothes = ''
		local t = 0
		for i = 0, 16 do
			local textura = getPedClothes(player, i)
			if textura then
				local idUnico = exports.ropas:getIdUnico(tostring(textura))
				if idUnico then
					if t == 0 then
						t = 1
						strClothes = tostring(idUnico)
					else
						strClothes = strClothes..","..tostring(idUnico)
					end
				end
			end
		end
		if getElementData(player, "tropa") then
			outputChatBox("SaveClothes (cID"..exports.players:getCharacterID(player).."): "..tostring(strClothes), player, 255, 255, 255)
		end
		exports.sql:query_free( "UPDATE characters SET clothes = '%s' WHERE characterID = " .. exports.players:getCharacterID(player), strClothes )
		exports.sql:query_free( "UPDATE characters SET skin = 0 WHERE characterID = " .. exports.players:getCharacterID(player) )
	else -- Otra skin
		exports.sql:query_free( "UPDATE characters SET skin = "..skin.." WHERE characterID = " .. exports.players:getCharacterID(player) )
	end
end
 
function applyClothes (player)
	if not exports.players:isLoggedIn(player) then return end
	local clothes = getClothes(player)
	if clothes then
		-- Primero eliminamos toda la ropa del PJ.
		triggerClientEvent("onResetRopaBlanco", player)
		for i = 0, 16 do
			removePedClothes(player, i)
		end 
		-- Ahora sí añadimos lo que tenga el PJ.
		for k, v in ipairs(clothes) do
			local textura, modelo, tipo = exports.ropas:getInfoRopa(v)
			if not textura then
				exports.logs:addLogMessage("ropabug", getPlayerName(player).." - Código Ropa: "..tostring(v)..".")
			else
				addPedClothes(player,textura,modelo,tipo)
			end
		end
		-- Por último, solicitamos que a él se le apliquen las ropas de todos
		local sql2 = exports.sql:query_assoc_single("SELECT genero, color FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(player)))
		local micolor = tonumber(sql2.color)
		local migenero = tonumber(sql2.genero)
		for k, v in ipairs(getElementsByType("player")) do
			if exports.players:isLoggedIn(v) then
				local sql3 = exports.sql:query_assoc_single("SELECT genero, color FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(v)))
				local color = tonumber(sql3.color)
				local genero = tonumber(sql3.genero)
				if genero == 1 and color == 1 and getElementModel(v) == 0 then -- Hombre blanco
					triggerClientEvent(player, "onSolicitarRopaBlanco", v)
				end
				if migenero == 1 and micolor == 1 and v ~= player and getElementModel(player) == 0 then -- Soy blanco, que los demás me vean blanco :D
					triggerClientEvent(v, "onSolicitarRopaBlanco", player)
				end
			end
		end
		return true
	else
		return false
	end
end
addEvent("onAplicarRopaAlIniciar", true)
addEventHandler("onAplicarRopaAlIniciar", getRootElement(), applyClothes)

function applyClothesOnLogin2(source)
	setElementModel(source, 2)
	setElementModel(source, 0)
	for i = 0, 17 do
		removePedClothes(source, i)
	end 
	local sql = exports.sql:query_assoc_single("SELECT skin FROM characters WHERE characterID = "..exports.players:getCharacterID(source))
	if sql.skin then
		if tonumber(sql.skin) > 0 then -- Tiene skin, no cargamos ropa de este PJ.
			setElementModel(source, tonumber(sql.skin))
			--Solicitamos que a él se le apliquen las ropas de todos
			for k, v in ipairs(getElementsByType("player")) do
				if exports.players:isLoggedIn(v) and v ~= source and getElementModel(v) == 0 then
					local sql3 = exports.sql:query_assoc_single("SELECT genero, color FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(v)))
					local color = tonumber(sql3.color)
					local genero = tonumber(sql3.genero)
					if genero == 1 and color == 1 then -- Hombre blanco
						triggerClientEvent(source, "onSolicitarRopaBlanco", v)
					end
				end
			end
			return
		end
	end
	applyClothes(source)
end

function applyClothesOnLogin()
	setTimer(applyClothesOnLogin2, 1500, 1, source)
end
addEventHandler ( "onCharacterLogin", getRootElement(), applyClothesOnLogin )