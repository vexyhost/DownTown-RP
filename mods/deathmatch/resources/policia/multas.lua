function multar ( thePlayer, commandName, otherPlayer, precio, ... )
 if exports.factions:isPlayerInFaction( thePlayer, 1 ) or (exports.factions:isPlayerInFaction( thePlayer, 6 ) and getElementDimension( thePlayer ) == 93 ) then
     if thePlayer and otherPlayer and precio and ... then
     local razon = table.concat({...}, " ")
     local otro, nombre = exports.players:getFromName(thePlayer, otherPlayer)
	 if not otro then return end
	 local characterID = exports.players:getCharacterID(otro)
	 local precio = tonumber(precio)
	 local agente = tostring(getPlayerName(thePlayer):gsub("_", " "))
	 local x, y, z = getElementPosition(thePlayer)
	 local x2, y2, z2 = getElementPosition(otro)
	-- if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) > 10 then outputChatBox("Estás demasiado lejos para multar a " .. nombre, thePlayer, 255, 0, 0) return end
	 outputChatBox("Has multado a " ..nombre.. " la cantidad de " ..tostring(precio).. "$.", thePlayer, 0, 255, 0)
	 outputChatBox("Razón: "..razon..".", thePlayer, 0, 255, 0)
	 exports.chat:me(thePlayer, "redacta una multa y se la entrega al sujeto", "(/multar)")
	 outputChatBox("El agente "..agente.." te ha multado con la cantidad de "..precio.."$.", otro, 0, 255, 0)
	 outputChatBox("Razón: "..razon..".", otro, 0, 255, 0)
	 local sql, error = exports.sql:query_insertid( "INSERT INTO multas (characterID, cantidad, agente, estado, razon) VALUES (" .. table.concat( { characterID, precio, '"%s"', 1, '"%s"' }, ", " ) .. ")", agente, razon )
	 if error then
	 outputDebugString(error)
	 end
	 else
	 outputChatBox("Síntaxis: /multar [id] [cantidad] [razon]", thePlayer, 255, 255, 255)
	 end
 else
    outputChatBox("No eres policia ni miembro de justicia estando en el juzgado.", thePlayer, 255, 0, 0)
 end
end

addCommandHandler("multar", multar)

function multar2 ( thePlayer, commandName, otherPlayer, precio, ... )
 if exports.factions:isPlayerInFaction( thePlayer, 1 ) or getElementData(thePlayer, "enc1") == true then
     if thePlayer and otherPlayer and precio and ... then
     local razon = table.concat({...}, " ")
     local otro, nombre = exports.players:getFromName(thePlayer, otherPlayer)
	 if not otro then return end
	 local characterID = exports.players:getCharacterID(otro)
	 local precio = tonumber(precio)
	 local agente = tostring(getPlayerName(thePlayer):gsub("_", " "))
	 local x, y, z = getElementPosition(thePlayer)
	 local x2, y2, z2 = getElementPosition(otro)
	-- if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) > 10 then outputChatBox("Estás demasiado lejos para multar a " .. nombre, thePlayer, 255, 0, 0) return end
	 outputChatBox("Has multado a " ..nombre.. " la cantidad de " ..tostring(precio).. "$.", thePlayer, 0, 255, 0)
	 outputChatBox("Razón: "..razon..".", thePlayer, 0, 255, 0)
	 local sql, error = exports.sql:query_insertid( "INSERT INTO multas (characterID, cantidad, agente, estado, razon) VALUES (" .. table.concat( { characterID, precio, '"%s"', 1, '"%s"' }, ", " ) .. ")", agente, razon )
	 if error then
	 outputDebugString(error)
	 end
	 else
	 outputChatBox("Síntaxis: /multar2 [id] [cantidad] [razon]", thePlayer, 255, 255, 255)
	 end
 else
    outputChatBox("No eres policia!.", thePlayer, 255, 0, 0)
 end
end

addCommandHandler("multar2", multar2)

function addMulta (characterID, cantidad, agente, estado, razon)
	if characterID and cantidad and agente and estado and razon then
		local sql, error = exports.sql:query_insertid( "INSERT INTO multas (characterID, cantidad, agente, estado, razon) VALUES (" .. table.concat( { characterID, cantidad, '"%s"', estado, '"%s"' }, ", " ) .. ")", agente, razon )
		if sql and not error then
			return true
		else
			return false
		end	
	end	
end	
	
function multarveh ( thePlayer, commandName, idveh, precio, ... )
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) or getElementData(thePlayer, "enc1") == true then
		if thePlayer and idveh and precio and (...) then
			local razon = table.concat({...}, " ")
			local vehicle = exports.vehicles:getVehicle(tonumber(idveh))
			local characterID = exports.vehicles:getOwner(vehicle)
			local precio = tonumber(precio)
			local agente = tostring(getPlayerName(thePlayer):gsub("_", " "))
			if tostring(characterID) == "nil" then outputChatBox("ID del vehículo incorrecto, o el vehículo ha sido desguazado.", thePlayer, 255, 0, 0) return end
			outputChatBox("Has multado al titular del vehículo " ..tostring(idveh).. " la cantidad de " ..precio.. "$.", thePlayer, 0, 255, 0)
			outputChatBox("Razón: "..razon..".", thePlayer, 0, 255, 0)
			exports.sql:query_insertid( "INSERT INTO multas (characterID, cantidad, agente, estado, razon) VALUES (" .. table.concat( { characterID, precio, '"%s"', 1, '"%s"' }, ", " ) .. ")", agente, razon )
		else
			outputChatBox("Síntaxis: /multarveh [idveh] [cantidad] [razon]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("¡No eres policia!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("multarveh", multarveh)

function cms (thePlayer)
	outputChatBox("~~~~~Servicio de consulta de las últimas 5 multas~~~~~", thePlayer, 127, 255, 127)
	local charID = exports.players:getCharacterID(thePlayer)
	local multas = exports.sql:query_assoc( "SELECT * FROM multas WHERE characterID = " .. charID .." ORDER BY ind DESC LIMIT 5" )
	if not multas then outputChatBox("No tienes ninguna multa.", thePlayer, 255, 0, 0) return end
	for key, value in ipairs (multas) do
		if value.estado == 1 then
			estado2 = "Impagada. Faltan "..value.cantidad-value.pagado.."$"
		elseif value.estado == 0 then
			estado2 = "Pagada" 
		end
		outputChatBox("-------------------------------------------------------------------------------------------------------", thePlayer, 255, 255, 255)
		outputChatBox("MID "..tonumber(value.ind).." - "..tonumber(value.cantidad).."$. Agente: "..tostring(value.agente)..". Fecha: "..value.fecha..".", thePlayer, 127, 255, 0)
		outputChatBox("MID "..tonumber(value.ind)..". Razón: "..tostring(value.razon)..". Estado: "..tostring(estado2)..".", thePlayer, 127, 255, 0)
	end
end
addCommandHandler("consultarmultas", cms)