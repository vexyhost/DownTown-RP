--[[ 
Copyright (C) 2016  DownTown County Roleplay

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]
 
function getFactions (player)
	if exports.factions:isPlayerInFaction(player, 5) or hasObjectPermissionTo(player, "command.acceptreport", false) then
		outputChatBox("~~Lista de Empresas~~", player, 255, 255, 255)
		for k, v in ipairs(exports.sql:query_assoc("SELECT factionID FROM factions")) do
			outputChatBox("Nº"..tostring(v.factionID).." Nombre: "..tostring(exports.factions:getFactionName(v.factionID))..".", player, 0, 255, 0)
		end
		outputChatBox("Utiliza /empresa [factionID] para obtener datos de dicha empresa.", player, 255, 255, 255)
	end
end
addCommandHandler("factions", getFactions)
addCommandHandler("empresas", getFactions)

function darPresupuesto (player, cmd, facID, cantidad)
	if not exports.factions:isFactionOwner(player, 5) == true then return end
	if facID and cantidad then
		if exports.factions:takeFactionPresupuesto(5, tonumber(cantidad)) == true then
			exports.factions:giveFactionPresupuesto(tonumber(facID), cantidad)
			outputChatBox("Has dado correctamente $"..tostring(cantidad).." a la empresa "..exports.factions:getFactionName(tonumber(facID))..".", player, 0, 255, 0)
			exports.logs:addLogMessage("gobierno", getPlayerName(player).." dió a la empresa "..tostring(exports.factions:getFactionName(tonumber(facID))).." $"..tostring(cantidad))
		else
			outputChatBox("Se ha producido un error. Comprueba que la facción existe y que el Gobierno tiene suficiente presupuesto.", player, 255, 0, 0)
		end
	else
		outputChatBox("Sintaxis: /darpresupuesto [faccion ID] [cantidad]", player, 255, 255, 255)
	end
end
addCommandHandler("darpresupuesto", darPresupuesto)

function takePresupuesto (player, cmd, facID, cantidad)
	if not exports.factions:isFactionOwner(player, 5) == true then return end
	if facID and cantidad then
		if exports.factions:takeFactionPresupuesto(tonumber(facID), tonumber(cantidad)) == true then
			exports.factions:giveFactionPresupuesto(5, cantidad)
			outputChatBox("Has quitado correctamente $"..tostring(cantidad).." a la empresa "..tostring(exports.factions:getFactionName(tonumber(facID)))..".", player, 0, 255, 0)
			exports.logs:addLogMessage("gobierno", getPlayerName(player).." quitó a la empresa "..tostring(exports.factions:getFactionName(tonumber(facID))).." $"..tostring(cantidad))
		else
			outputChatBox("Se ha producido un error. Comprueba que la facción existe y que tiene suficiente presupuesto.", player, 255, 0, 0)
		end
	else
		outputChatBox("Sintaxis: /quitarpresupuesto [faccion ID] [cantidad]", player, 255, 255, 255)
	end
end
addCommandHandler("quitarpresupuesto", takePresupuesto)

function solicitarDatosFaccion (player, cmd, facID)
	if exports.factions:isPlayerInFaction(player, 5) or hasObjectPermissionTo(player, "command.acceptreport", false) then
		if facID then
			outputChatBox("~~Datos de la Empresa ID "..tostring(facID).."~~", player, 255, 255, 255)
			outputChatBox("Nombre: "..exports.factions:getFactionName(tonumber(facID))..".", player, 0, 255, 0)
			outputChatBox("Presupuesto: $"..tostring(exports.factions:getFactionPresupuesto(tonumber(facID)))..".", player, 0, 255, 0)
		end
	end
end

addCommandHandler("empresa", solicitarDatosFaccion)
addCommandHandler("faction", solicitarDatosFaccion)


-- tendido electrico de fort carson.
electricidadFC = 0

function electricidadfc(player)
	if exports.factions:isFactionOwner(player, 5) then
		if electricidadFC == 0 then
			exports.chat:me( player, "introduce los codigos de la central y manda el encendido del tendido eléctrico." )
			outputChatBox( "[Anuncio FCND]: La planta eléctrica ha ordenado el encendido del tendido eléctrico.", root, 106, 255, 255 )
			objeto1es = createObject(3472, 27.85851, 1190.90161, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto2es = createObject(3472, 1.47285, 1205.95190, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto3es = createObject(3472, -48.27672, 1190.84595, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto4es = createObject(3472, -87.60497, 1205.94604, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto5es = createObject(3472, -164.59119, 1190.77844, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto6es = createObject(3472, -244.08670, 1205.97791, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto7es = createObject(3472, -283.10394, 1176.17371, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto8es = createObject(3472, -267.91699, 1128.57239, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto9es = createObject(3472, -301.25626, 1140.79895, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto10es = createObject(3472, -353.16400, 1135.79980, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto11es = createObject(3472, -325.68665, 1090.13428, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto12es = createObject(3472, -305.03214, 1071.10522, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto13es = createObject(3472, -285.61743, 1038.92175, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto14es = createObject(3472, -250.58223, 1025.97229, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto15es = createObject(3472, -210.97462, 1010.81256, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto16es = createObject(3472, -207.27350, 906.21118, 9.68130,   0.00000, 0.00000, 0.00000)
			objeto17es = createObject(3472, -200.70842, 959.38208, 15.61604,   0.00000, 0.00000, 0.00000)
			objeto18es = createObject(3472, -231.77538, 866.66138, 9.68130,   0.00000, 0.00000, 0.00000)
			objeto19es = createObject(3472, -259.39124, 841.72449, 9.68130,   0.00000, 0.00000, 0.00000)
			objeto20es = createObject(3472, -287.15881, 827.47321, 11.91998,   0.00000, 0.00000, 0.00000)
			objeto21es = createObject(3472, -275.23349, 807.43311, 11.91998,   0.00000, 0.00000, 0.00000)
			objeto22es = createObject(3472, -250.49338, 823.04254, 11.91998,   0.00000, 0.00000, 0.00000)
			objeto23es = createObject(3472, -216.58951, 852.07184, 9.68130,   0.00000, 0.00000, 0.00000)
			objeto24es = createObject(3472, -188.72118, 899.83362, 9.68130,   0.00000, 0.00000, 0.00000)
			objeto25es = createObject(3472, -185.58015, 961.47034, 15.61604,   0.00000, 0.00000, 0.00000)
			objeto26es = createObject(3472, -182.95609, 1027.27686, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto27es = createObject(3472, -203.08511, 1150.43628, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto28es = createObject(3472, -182.96559, 1182.27527, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto29es = createObject(3472, -182.91779, 1125.32104, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto30es = createObject(3472, -182.91783, 1057.20288, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto31es = createObject(3472, -150.73738, 1091.02100, 17.67500,   0.00000, 0.00000, 0.00000)
			objeto32es = createObject(3472, -124.58794, 1105.88635, 17.67500,   0.00000, 0.00000, 0.00000)
			electricidadFC = 1
		elseif electricidadFC == 1 then
			exports.chat:me( player, "introdúce los codigos de la central y manda el apagado del tendido eléctrico." )
			outputChatBox( "[Anuncio FCND]: La planta eléctrica ha ordenado el apagado del tendido eléctrico.", root, 106, 255, 255 )
			destroyElement ( objeto1es )
			destroyElement ( objeto2es )
			destroyElement ( objeto3es )
			destroyElement ( objeto4es )
			destroyElement ( objeto5es )
			destroyElement ( objeto6es )
			destroyElement ( objeto7es )
			destroyElement ( objeto8es )
			destroyElement ( objeto9es )
			destroyElement ( objeto10es )
			destroyElement ( objeto11es )
			destroyElement ( objeto12es )
			destroyElement ( objeto13es )
			destroyElement ( objeto14es )
			destroyElement ( objeto15es )
			destroyElement ( objeto16es )
			destroyElement ( objeto17es )
			destroyElement ( objeto18es )
			destroyElement ( objeto19es )
			destroyElement ( objeto20es )
			destroyElement ( objeto21es )
			destroyElement ( objeto22es )
			destroyElement ( objeto23es )
			destroyElement ( objeto24es )
			destroyElement ( objeto25es )
			destroyElement ( objeto26es )
			destroyElement ( objeto27es )
			destroyElement ( objeto28es )
			destroyElement ( objeto29es )
			destroyElement ( objeto30es )
			destroyElement ( objeto31es )
			destroyElement ( objeto32es )
			electricidadFC = 0
		end
	else
	outputChatBox("(( No eres de la alcaldía ))", player , 255, 0, 0)
	end
end
addCommandHandler("electricidad", electricidadfc)