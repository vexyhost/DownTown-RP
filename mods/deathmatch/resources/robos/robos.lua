timerRobo = {}
blipPol = {}

function getPolicias()
	n = 0
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 1) then
			n = n + 1
		end
	end
	return n
end

function reguladorRobo(player)
	local time = getRealTime()
	local interiorID = getElementDimension(player)
	local staffN = getElementData(player, "nombreStaff")
	local vehicle = getPedOccupiedVehicle(player)
	if staffN then
		staff = getPlayerFromName(staffN)
	end
	if vehicle then
		local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
		if nivel < 3 then outputChatBox("Necesitas nivel 3 para robar un vehículo. Usa /objetivos.", player, 255, 0, 0) return end
		if not getVehicleController(vehicle) or player ~= getVehicleController(vehicle) then outputChatBox("Necesitas estar subido de conductor.", player, 255, 0, 0) return end
		if getPolicias() < 3 then outputChatBox("Necesitas 3 policias o más conectados y de servicio para robar.", player, 255, 0, 0) return end
		if tonumber(getElementData(vehicle, "idveh")) <= 0 then outputChatBox("El vehículo es temporal y no se puede robar.", player, 255, 0, 0) return end
		local precio = exports.vehicles_auxiliar:getPrecioFromModel(getVehicleName(vehicle))
		if not precio then outputChatBox("No puedes robar este vehículo.", player, 255, 0, 0) return end
		if getPlayerMoney(player) < (precio*0.05) and not getVehicleEngineState(getPedOccupiedVehicle(player)) == true then
			outputChatBox("Necesitas tener el 5% del valor de " .. tostring(getVehicleName(vehicle)) .. " ($"..tostring(precio*0.05)..") para robarlo.", player, 255, 0, 0)
			return
		end
		local sql = exports.sql:query_assoc_single("SELECT fecha FROM robos WHERE tipo = 1 AND objetoID = " .. getElementData(vehicle, "idveh"))
		local sqlU = exports.sql:query_assoc("SELECT characterID FROM characters WHERE userID = " .. exports.players:getUserID(player))
		for k, v in ipairs(sqlU) do
			local sql2 = exports.sql:query_assoc_single("SELECT fecha FROM robos WHERE tipo = 1 AND charIDLadron = " .. v.characterID)
			if sql2 and sql2.fecha and time.timestamp <= (tonumber(sql2.fecha)+259200) then
				outputChatBox("Ya has robado un vehículo en menos de 72 horas. Inténtalo más tarde.", player, 255, 0, 0)
				return
			end
		end
		if sql and sql.fecha then
			outputChatBox("Este vehículo ya ha sido robado. Simplemente usa la tecla J o /toggleengine.", player, 255, 255, 0)
			return
		end
		if getVehicleEngineState(getPedOccupiedVehicle(player)) == true then
			setElementData(player, "veh.apagar", 0)
		else
			setElementData(player, "veh.apagar", tonumber(precio*0.05))
		end
		outputChatBox("Vas a proceder a robar un " .. tostring(getVehicleName(vehicle)) .. " por $"..tostring(getElementData(player, "veh.apagar"))..".", player, 0, 255, 0)
		outputChatBox("En 60 segundos el vehículo va a arrancar automáticamente. Tienes un 50% de posibilidades de conseguirlo.", player, 0, 255, 0)
		outputChatBox("Este robo no puede ser anulado.", player, 255, 255, 0)
		setElementData(player, "robo", true)
		setElementData(player, "veh.robo", tonumber(getElementData(vehicle, "idveh")))
		setTimer(hechoRoboVehiculo, 60000, 1, player, vehicle)
	else
		local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
		if nivel < 4 then outputChatBox("Necesitas nivel 4 para robar una tienda. Usa /objetivos.", player, 255, 0, 0) return end
		if interiorID <= 0 then outputChatBox("No estás en un interior.", player, 255, 0, 0) return end
		if getPolicias() < 6 then outputChatBox("Necesitas 6 policias o más conectados y de servicio para robar.", player, 255, 0, 0) return end
		if not exports.interiors:isTienda(interiorID) == true then outputChatBox("Este interior no es una tienda.", player, 255, 0, 0)	return end
		if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 2) or exports.factions:isPlayerInFaction(player, 5) then outputChatBox("No puedes robar una tienda si perteneces a una facción del Estado.", player, 255, 0, 0) return end
		if not staffN then 
			outputChatBox("Necesitas que un staff te supervise para poder robar una tienda.", player, 255, 0, 0)
			outputChatBox("Puedes pedir uno mediante /duda.", player, 255, 0, 0)	
			return
		else
			local sqlU = exports.sql:query_assoc("SELECT characterID FROM characters WHERE userID = " .. exports.players:getUserID(player))
			for k, v in ipairs(sqlU) do
				local sql2 = exports.sql:query_assoc_single("SELECT fecha FROM robos WHERE tipo = 2 AND charIDLadron = " .. v.characterID)
				if sql2 and sql2.fecha and time.timestamp <= (sql2.fecha+259200) then
					outputChatBox("Ya has robado un interior en menos de 72 horas. Inténtalo más tarde.", player, 255, 0, 0)
					outputChatBox("El jugador ya ha robado un interior en menos de 72 horas. Robo anulado.", player, 255, 0, 0)
					return
				end
			end
			outputChatBox("El robo será supervisado por el staff "..getElementData(player, "nombreStaff"):gsub("_", " ")..".", player, 0, 255, 0)
			outputChatBox("Vas a supervisar un robo de tienda hecho por: "..getPlayerName(player):gsub("_", " ")..". Tus PM's se han desactivado.", staff, 0, 255, 0)
			outputChatBox("El robo va a empezar cuando el staff lo autorice. Usa /anularrobo para anularlo.", player, 255, 255, 0 )
			outputChatBox("Para autorizar y empezar el robo, usa /autorizar. Usa /anularrobostaff [razon] para anularlo.", staff, 255, 255, 0 )
			outputChatBox("ATENCIÓN: asegúrate de que se cumplen los requisitos, revisa en foro para + info.", staff, 255, 255, 0 )
			setElementData(staff, "pm", false )
			setElementData(staff, "ladron", tostring(getPlayerName(player)))
			setElementData(player, "robo", true)
			setElementData(staff, "robo", true)
			setElementData(staff, "int.robo", tonumber(getElementDimension(staff)))
		end
	end
end	
addCommandHandler("robar", reguladorRobo)

function autorizarRobo(staff)
	if not getElementData(staff, "ladron") then outputChatBox("No estás supervisando ningún robo.", staff, 255, 0, 0) return end
	local playerN = getElementData(staff, "ladron")
	local player = getPlayerFromName(playerN)
	setElementData(player, "robo.enproceso", true)
	if getElementData(staff, "int.robo") then
		outputChatBox("El robo ha empezado y no lo puedes anular. Se avisará a la policia cuando salgas de la tienda.", player, 0, 255, 0)
		outputChatBox("El robo ha sido autorizado y ha empezado. Se avisará a la policia cuando salga de la tienda.", staff, 255, 0, 0)
		outputChatBox("Por favor, supervisa al ladrón hasta que éste consigua huir definitivamente.", staff, 255, 255, 0)
		local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
		if nivel == 4 and not exports.objetivos:isObjetivoCompletado(44, exports.players:getCharacterID(player)) then
			exports.objetivos:addObjetivo(44, exports.players:getCharacterID(player), player)
		end
	end
end
addCommandHandler("autorizar", autorizarRobo)	
	
function hechoRoboVehiculo (player)
	if not player then return end
	local vehID = getElementData(getPedOccupiedVehicle(player), "idveh")
	local cantidad = tonumber(getElementData(player, "veh.apagar"))
	if vehID and tonumber(vehID) ~= tonumber(getElementData(player, "veh.robo")) then 
		outputChatBox("Has intentado robar un vehículo sin estar dentro de él. Incidente reportado.", player, 255, 0, 0)
		return 
	end
	local vehicle = getPedOccupiedVehicle(player)
	if not getVehicleController(vehicle) or player ~= getVehicleController(vehicle) then outputChatBox("Necesitas estar subido de conductor.", player, 255, 0, 0) limpiarDatos(player) return end
	local numero = math.random(0, 1) 
	if numero == 1 then
		if cantidad == 0 or exports.players:takeMoney(player, cantidad) then
			local time = getRealTime()
			local model = getElementModel(getPedOccupiedVehicle(player))
			local sql, error = exports.sql:query_insertid( "INSERT INTO robos (userIDStaff, charIDLadron, tipo, objetoID, model, cantidad, fecha) VALUES (" .. table.concat( { 0, exports.players:getCharacterID(player), 1, tonumber(getElementData(player, "veh.robo")), tonumber(model), 0, tonumber(time.timestamp) }, ", " ) .. ")" )
			if sql and not error then
				outputChatBox("El vehículo ha sido robado correctamente. Ya puedes arrancarlo.", player, 0, 255, 0)
				outputChatBox("Recuerda que cualquiera podrá abrirlo y arrancarlo.", player, 0, 255, 0)
				outputChatBox("El robo ha sido denunciado automáticamente a la Policía.", player, 255, 0, 0)
				limpiarDatos(player)
			end
		else
			outputChatBox("No tienes el 5% del vehículo. Robo anulado.", player, 255, 0, 0)
			limpiarDatos(player)
		end
	else
		outputChatBox("¡No has conseguido robar el vehículo, y un ciudadano ha avisado a la policía!", player, 255, 255, 0)
		setVehicleEngineState(getPedOccupiedVehicle(player), false)
		local x, y, z = getElementPosition(getPedOccupiedVehicle(player))	
		for k, v in ipairs (getElementsByType("player")) do 
			if exports.factions:isPlayerInFaction(v, 1) then
				outputChatBox("¡Intento de robo de vehículo, acuda! (Bandera Roja)", v, 255, 255, 0)
			end
		end
		exports.factions:createFactionBlip2(x, y, z, 1, getElementDimension(getPedOccupiedVehicle(player)), 2)
		limpiarDatos(player)
	end
end
	
function anularRobo(player)
	if getElementData(player, "robo") == true then
		if getElementData(player, "robo.enproceso") == true then
			outputChatBox("El robo está en proceso y no puedes anularlo. Si lo necesitas, pídeselo al staff que te supervisa.", player, 255, 0, 0)
		else
			outputChatBox("Has anulado el robo correctamente.", player, 255, 0, 0)
			if getElementData(player, "nombreStaff") and getPlayerFromName(getElementData(player, "nombreStaff")) then
				local staff = getPlayerFromName(getElementData(player, "nombreStaff"))
				outputChatBox(getPlayerName(player):gsub("_", " ").." ha anulado el robo. Tus PM's se han activado", staff, 255, 255, 0)
				limpiarDatos(player, staff)
			else
				limpiarDatos(player)
			end
		end
	end
end
addCommandHandler("anularrobo", anularRobo)
 
function anularRoboStaff(staff, cmd, ...)
	if not getElementData(staff, "ladron") then outputChatBox("No estás supervisando ningún robo.", staff, 255, 0, 0) return end
	if (...) then
		razon = table.concat( { ... }, " " )
	else
		razon = "Razón no específicada"
	end
	local playerN = getElementData(staff, "ladron")
	local player = getPlayerFromName(playerN)
	outputChatBox("Has anulado el robo de "..playerN:gsub("_", " ").." ("..razon..")", staff, 255, 0, 0)
	outputChatBox("El staff "..getPlayerName(staff):gsub("_", " ").. " ha anulado el robo ("..razon..")", player, 255, 255, 0)
	limpiarDatos(player, staff)
end	
addCommandHandler("anularrobostaff", anularRoboStaff)

function limpiarDatos (player, staff)
	removeElementData(player, "robo.enproceso")
	removeElementData(player, "robo")
	removeElementData(player, "veh.robo")
	removeElementData(player, "veh.apagar")
	if staff then
		removeElementData(staff, "robo")
		removeElementData(staff, "ladron")
		removeElementData(staff, "int.robo")
		setElementData(staff, "pm", true)
	end
end