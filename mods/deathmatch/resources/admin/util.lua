--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2016 DownTown County Roleplay

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

function getPos (player)
	local x,y,z = getElementPosition(player)
	r1,r2,r3 = getElementRotation(player)
	outputChatBox("Tu rotación es: "..tostring(r1)..", "..tostring(r2)..", "..tostring(r3)..".", player, 0, 255, 0)
	outputChatBox("Tus coordenadas son: "..tostring(x)..", "..tostring(y)..", "..tostring(z)..".", player, 0, 255, 0)
	outputChatBox("Tu estás en: "..tostring(getZoneName(x, y, z, false))..", "..tostring(getZoneName(x, y, z, true))..".", player, 0, 255, 0)
	outputChatBox("Estas en el interior: "..tostring(getElementInterior(player)).." y dimension: "..tostring(getElementDimension(player))..".", player, 0, 255, 0)
end
addCommandHandler("getpos", getPos)

function consultarMisHoras(player)
	if player and exports.players:isLoggedIn(player) then
		local sql = exports.sql:query_assoc_single("SELECT horas FROM characters WHERE characterID = "..exports.players:getCharacterID(player))
		if sql then
			outputChatBox("Llevas jugadas "..tostring(sql.horas).." horas en este personaje.", player, 0, 255, 0)
		end
	end
end
addCommandHandler("horas", consultarMisHoras)

function gotopos (player, commandName, x, y, z, dim, int)
	if not hasObjectPermissionTo( player, "command.acceptreport", false ) then return end
	if x and y and z then
		if not dim then dim = 0 end
		if not int then int = 0 end
		setElementPosition(player, x, y, z)
		setElementInterior(player, int)
		setElementDimension(player, dim)
	else
		outputChatBox("Sintaxis: /gotopos [posX, posY, posZ, (Opcional: dimension, interior. 0 por defecto)]", player, 255, 255, 255)
		outputChatBox("posX, posY y posZ separados por espacios, y los decimales con .", player, 255, 255, 0)
	end
end
addCommandHandler("gotopos", gotopos)
 
function elementClicked( theButton, theState, thePlayer )
    if theButton == "left" and theState == "down" and getElementData(thePlayer, "tid") == true then -- if left mouse button was pressed down
        local x, y, z = getElementPosition (source)
		outputChatBox( "ObjectID:"..getElementModel( source )..".", thePlayer, 0, 255, 0)
		outputChatBox("X: "..x..".", thePlayer, 0, 255, 0)
		outputChatBox("Y: "..y..".", thePlayer, 0, 255, 0)
		outputChatBox("Z: "..z..".", thePlayer, 0, 255, 0)
    elseif theButton == "left" and theState == "down" and getElementData(thePlayer, "qid") == true then
		destroyElement(source)
	end
end
addEventHandler( "onElementClicked", getRootElement(), elementClicked )

function toggleObjetos (player)
	if not hasObjectPermissionTo( player, "command.acceptreport", false ) then return end
	if getElementData(player, "tid") == true then
		outputChatBox("Has desactivado el modo para ver IDs de objetos de los mapas.", player, 0, 255, 0)
		setElementData(player, "tid", false)
	else
		outputChatBox("Has activado el modo para ver IDs de objetos de los mapas.", player, 0, 255, 0)
		outputChatBox("Pulsa en cualquier objeto para ver su ID y coordenadas.", player, 0, 255, 0)
		setElementData(player, "tid", true)
	end
end
addCommandHandler("objetos", toggleObjetos)

function toggleObjetos2 (player)
	if not hasObjectPermissionTo( player, "command.acceptreport", false ) then return end
	if getElementData(player, "qid") == true then
		outputChatBox("Has desactivado el modo para quitar objetos de los mapas.", player, 0, 255, 0)
		setElementData(player, "qid", false)
	else
		outputChatBox("Has activado el modo para quitar objetos de los mapas.", player, 0, 255, 0)
		outputChatBox("Pulsa en cualquier objeto para ver su ID y coordenadas.", player, 0, 255, 0)
		setElementData(player, "qid", true)
	end
end
addCommandHandler("dobjetos", toggleObjetos2)

function toggleEncubierto (player)
	if getElementData(player, "enc") == true then
		outputChatBox("Has desactivado el modo encubierto. Ya si apareces en /staff.", player, 0, 255, 0)
		setElementData(player, "enc", false)
	else
		outputChatBox("Has activado el modo encubierto. Ya no apareces en /staff", player, 0, 255, 0)
		setElementData(player, "enc", true)
	end
end
--addCommandHandler("enc4312", toggleEncubierto)

function quitPlayer ( quitType )
	if source and quitType then
		if quitType == "Quit" then
			exports.chat:sendLocalOOC( source, "[Conexión] " .. getPlayerName(source):gsub("_", " ") .. " se ha desconectado por su propia decisión." )
		elseif quitType == "Kicked" then
			exports.chat:sendLocalOOC( source, "[Conexión] " .. getPlayerName(source):gsub("_", " ") .. " se ha desconectado forzosamente por un kick de un staff." )
		elseif quitType == "Banned" then
			exports.chat:sendLocalOOC( source, "[Conexión] " .. getPlayerName(source):gsub("_", " ") .. " se ha desconectado forzosamente por un ban de un staff." )
		elseif quitType == "Bad Connection" or quitType == "Timed out" then
			exports.chat:sendLocalOOC( source, "[Conexión] " .. getPlayerName(source):gsub("_", " ") .. " se ha desconectado forzosamente por su conexión." )
		else
			exports.chat:sendLocalOOC( source, "[Conexión] " .. getPlayerName(source):gsub("_", " ") .. " se ha desconectado por una razón desconocida." )
		end
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )

function ayudavips(player)
	if exports.players:isLoggedIn(player) and hasObjectPermissionTo( player, "command.vip", false ) then
    outputChatBox("~~~~~~ Ayuda usuario VIP Downtown Roleplay ~~~~~~", player, 180, 0, 255)
	outputChatBox("/mivip (Consultar Info) /vip (Poner/Quitar) Color", player, 0, 255, 0)
	outputChatBox("/ponerskinvip (Vestir Ropa Premium) /soportevip (OFF)", player, 0, 255, 0)
	else
		outputChatBox("(( No eres usuario VIP ))", player, 255, 0, 0)
	end
end
--addCommandHandler("ayudavip",ayudavips)

function solicitarSkinLibre()
	local sql2 = exports.sql:query_assoc("SELECT vipSkin FROM wcf1_user WHERE vipSkin > 0")
	local idSkinVIP ={
	[ 21 ] = true,
	[ 22 ] = true,
	[ 23 ] = true, 
	[ 24 ] = true,
	[ 26 ] = true,
	[ 27 ] = true,
	[ 28 ] = true,
	[ 29 ] = true,
	[ 64 ] = true,
	[ 75 ] = true,
    [ 87 ] = true,
	[ 92 ] = true,
	[ 136 ] = true,
	[ 166 ] = true,
	[ 176 ] = true,
	[ 204 ] = true,
	[ 207 ] = true,
	[ 246 ] = true,
	[ 311 ] = true}
	local skinDevolver = -1
	for k, v in ipairs(sql2) do
		if idSkinVIP[tonumber(v.vipSkin)] == true then	
			idSkinVIP[tonumber(v.vipSkin)] = false
		end
	end
	for k, v in pairs(idSkinVIP) do
		if idSkinVIP[tonumber(k)] == true then	
			skinDevolver = tonumber(k)
			break
		end
	end
	return skinDevolver
end

function asignameSkinVIP(player)
	--if exports.players:isLoggedIn(player) and hasObjectPermissionTo( player, "command.vip", false ) then
		local sql = exports.sql:query_assoc_single("SELECT vipSkin FROM wcf1_user WHERE userID = " .. exports.players:getUserID(player))
		if tonumber(sql.vipSkin) > 0 then outputChatBox("Ya tienes una skin asignada. Utiliza /ponerskinvip", player, 255, 0, 0) return end
		local nuevaSkin = solicitarSkinLibre()
		if nuevaSkin > 0 then
			exports.sql:query_free("UPDATE wcf1_user SET vipSkin = "..tostring(nuevaSkin).." WHERE userID = " .. exports.players:getUserID(player))
			outputChatBox("Acabamos de asignarte una skin, con el ID "..tostring(nuevaSkin), player, 0, 255, 0)
			outputChatBox("Ya puedes usar F1 para subir la skin que más te guste.", player, 0, 255, 0)
		else
			outputChatBox("Actualmente no hay skins libre para VIP. Avisa a un desarrollador.", player, 255, 0, 0)
		end
	--else
		--outputChatBox("No eres usuario VIP.", player, 255, 0, 0)
	--end
end
--addCommandHandler("skinvip", asignameSkinVIP)

function ponerskinvip1(player)
	if exports.players:isLoggedIn(player) and hasObjectPermissionTo( player, "command.vip", false ) then
    local sql = exports.sql:query_assoc_single("SELECT vipSkin FROM wcf1_user WHERE userID = " .. exports.players:getUserID(player))
		if tonumber(sql.vipSkin) and tonumber(sql.vipSkin) > 0 then	
		outputChatBox("Te has colocado tu skin VIP (ID:".. tostring(sql.vipSkin) ..")", player, 180, 0, 255)
		outputChatBox("Para volver a usar ropa de pj usa /qrt", player, 0, 255, 0)
		setElementModel(player,tostring(sql.vipSkin))
		else
			outputChatBox("(( Actualmente no tienes un Skin VIP Asignado ))", player, 255, 0, 0)
			outputChatBox("Usa /skinvip para que te asignemos una de las libres.", player, 255, 255, 255)
		end
    else
	outputChatBox("(( No eres usuario VIP ))", player, 255, 0, 0)
	end
end
--addCommandHandler("ponerskinvip",ponerskinvip1)


function miVIP(player)
	if exports.players:isLoggedIn(player) and hasObjectPermissionTo( player, "command.vip", false ) then
		local sql = exports.sql:query_assoc_single("SELECT vipDays, vipSkin, vipSkinAdic FROM wcf1_user WHERE userID = " .. exports.players:getUserID(player))
		local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
		if nivel == 3 and not exports.objetivos:isObjetivoCompletado(31, exports.players:getCharacterID(player)) then
			exports.objetivos:addObjetivo(31, exports.players:getCharacterID(player), player)
		end
		outputChatBox(" ~~~~~~ Estado de V-I-P ~~~~~~", player, 180, 0, 255)
		outputChatBox("Días restantes de tu VIP: ".. tostring(sql.vipDays) ..".", player, 0, 255, 0)
		if tonumber(sql.vipSkin) and tonumber(sql.vipSkin) > 0 then
			outputChatBox("Skin asignada a tu VIP: ".. tostring(sql.vipSkin) ..".", player, 0, 255, 0)
		else
			outputChatBox("Skin asignada a tu VIP: No asignada. Usa /skinvip.", player, 0, 255, 0)
		end
		--[[if tonumber(sql.vipSkinAdic) and tonumber(sql.vipSkinAdic) > 0 then
			outputChatBox("Skin adiccional asignada a tu VIP: ".. tostring(sql.vipSkinAdic) ..".", player, 0, 255, 0)
		else
			outputChatBox("Sin skin adiccional. Puedes solicitarla por 3 euros.", player, 0, 255, 0)
		end]]
	else
		outputChatBox("(( No eres usuario VIP ))", player, 255, 0, 0)
	end
end
--addCommandHandler("mivip", miVIP)

function mediaPing(player)
	if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
	nPing = 0
	nPing2 = 0
	for k, v in ipairs(getElementsByType("player")) do
		nPing = nPing+getPlayerPing(v)
		nPing2 = nPing2+1
	end
	outputChatBox("La media de ping del servidor es de "..tostring(math.floor(nPing/nPing2)).." ms.", player, 0, 255, 0)
end
addCommandHandler("mping", mediaPing)

function miID (player, cmd, otherPlayer)
	if exports.players:isLoggedIn(player) and not (otherPlayer) then
		outputChatBox("Tu ID es el "..tostring(getElementData(player, "playerid"))..".", player, 255, 255, 255)
		outputChatBox("También puedes usar /id [parte del nombre] para saber su ID.", player, 255, 255, 0)
	else
		local other, name = exports.players:getFromName( player, otherPlayer )
		if other then
			outputChatBox("El ID de "..tostring(name).." es el "..getElementData(other, "playerid")..".", player, 255, 255, 255)
		end
	end
end
addCommandHandler("id", miID)
 
function toggleJetPack (player)
	if exports.players:isLoggedIn(player) and hasObjectPermissionTo( player, "command.modchat", false ) then
		if doesPedHaveJetPack(player) then -- Tiene, se lo quitamos
			removePedJetPack(player)
			outputChatBox("JetPack quitado. Usa /jp para ponértelo de nuevo.", player, 0, 255, 0)
		else
			givePedJetPack(player)
			outputChatBox("JetPack instalado. Usa /jp para quitártelo.", player, 0, 255, 0)
		end
	else
		outputChatBox("Acceso denegado.", player, 255, 0, 0)
	end
end
addCommandHandler("jp", toggleJetPack)

function usersDeBS (player)
	if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
	if exports.players:isLoggedIn(player) then
		outputChatBox("~~ Usuarios ON de BS ~~", player, 255, 255, 255)
		for k, v in ipairs(getElementsByType("player")) do
			if exports.players:isLoggedIn(v) then
				local sql = exports.sql:query_assoc_single("SELECT bs FROM wcf1_user WHERE userID = "..exports.players:getUserID(v))
				if tonumber(sql.bs) > 0 then
					outputChatBox("["..getElementData(v, "playerid").."] - "..getPlayerName(v):gsub("_", " ").." N: "..tostring(sql.bs)..".", player, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("bs81", usersDeBS )

function usersDeBS2 (player)
	if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
	if exports.players:isLoggedIn(player) then
		outputChatBox("~~ Usuarios ON de BS (+1) ~~", player, 255, 255, 255)
		for k, v in ipairs(getElementsByType("player")) do
			if exports.players:isLoggedIn(v) then
				local sql = exports.sql:query_assoc_single("SELECT bs FROM wcf1_user WHERE userID = "..exports.players:getUserID(v))
				if tonumber(sql.bs) > 1 then
					outputChatBox("["..getElementData(v, "playerid").."] - "..getPlayerName(v):gsub("_", " ").." N: "..tostring(sql.bs)..".", player, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("bs82", usersDeBS2 )