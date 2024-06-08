function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false  
end

local models =
    {
        [ 574 ] = true,
		[ 478 ] = true,
		[ 436 ] = true,
		[ 453 ] = true,
		[ 431 ] = true,
		[ 440 ] = true,
		[ 408 ] = true,
    }

function taparMatricula(player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then outputChatBox("No estás en un vehículo.", player, 255, 0, 0) return end
	if ( models [ getElementModel ( vehicle ) ] ) then outputChatBox("No puedes tapar la matrícula en este vehículo.", player, 255, 0, 0) return end
	if isVehicleLocked(vehicle) then outputChatBox("El vehículo debe de estar abierto.", player, 255, 0, 0) return end
	local speedx, speedy, speedz = getElementVelocity ( vehicle )
	local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
	if actualspeed > 0 then outputChatBox("El vehículo debe de estar parado completamente.", player, 255, 0, 0) return end
	setElementData(vehicle, "tapada", true)
	exports.chat:me(player, "pone un trapo en la matrícula.")
	exports.chat:ame("La matrícula quedaría totalmente tapada, no se vería nada.", "Vehículo")
	setVehiclePlateText(vehicle, "TAPADA")
end
addCommandHandler("taparmatricula", taparMatricula)

function destaparMatricula(player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then outputChatBox("No estás en un vehículo.", player, 255, 0, 0) return end
	if isVehicleLocked(vehicle) then outputChatBox("El vehículo debe de estar abierto.", player, 255, 0, 0) return end
	local speedx, speedy, speedz = getElementVelocity ( vehicle )
	local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
	if actualspeed > 0 then outputChatBox("El vehículo debe de estar parado completamente.", player, 255, 0, 0) return end
	setElementData(vehicle, "tapada", false)
	exports.chat:me(player, "quita el trapo de la matrícula.")
	exports.chat:ame("La matrícula quedaría totalmente legible.", "Vehículo")
	setVehiclePlateText(vehicle, tostring(getElementData(vehicle, "idveh")))
end
addCommandHandler("destaparmatricula", destaparMatricula)

function comprobarMatricula(player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then outputChatBox("No estás en un vehículo.", player, 255, 0, 0) return end
	outputChatBox("La matrícula de este vehículo es: "..tostring(getVehiclePlateText(vehicle)), player, 0, 255, 0)
end
addCommandHandler("matricula", comprobarMatricula)

local blipLocalizado = {}

function getElementPositionLocalizadoVeh (element)
	if element then
		if getElementDimension(element) == 0 then
			return getElementPosition(element)
		else
			return exports.interiors:getPos(getElementDimension(element))
		end
	else
		return false
	end
end

function localizarVehiculo ( player, commandName, vehID )
	if client then player = client end
	if exports.players:isLoggedIn(player)then
		local inactivo = false
		if not vehID then 
			outputChatBox("Sintaxis: /"..tostring(commandName).." [ID del vehículo]", player, 255, 255, 255)
			outputChatBox("Usa /misvehs para saber las IDs de tus vehículos.", player, 255, 255, 255)
		else
			local sql = exports.sql:query_assoc_single("SELECT inactivo, cepo, vehicleID, characterID FROM vehicles WHERE vehicleID = "..vehID)
			if not sql or not sql.vehicleID then 
				outputChatBox("El ID especificado no existe. Comprueba el ID y avisa a un staff.", player, 255, 0, 0) 
				return 
			end
			local cIDOwner = tonumber(sql.characterID)
			if cIDOwner ~= exports.players:getCharacterID(player) and (cIDOwner < 0 and not exports.factions:isPlayerInFaction(player, math.abs(cIDOwner))) then
				outputChatBox("No puedes localizar un vehículo que no es ni tuyo ni de tu empresa.", player, 255, 0, 0)
				return
			end
			if sql.cepo == 1 then
				outputChatBox("Este vehículo tiene cepo policial. Acude a la policía para retirarlo.", player, 255, 0, 0)
				--createBlip( 1541, -1620.72, 13.55, 0, 2, 0, 0, 255, 255, 0, 99999.0, player )
				return
			elseif sql.inactivo == 1 then
				outputChatBox("Este vehículo está embargado por no renovarlo.", player, 255, 0, 0)
				--outputChatBox("Puedes recuperarlo pagando 10.000$ y acudiendo a Soporte Técnico.", player, 255, 0, 0)
				--[[outputChatBox("Este vehículo está en manos de los concesionarios por no renovarlo.", player, 255, 0, 0)
				outputChatBox("La única forma de recuperarlo es volver a comprarlo a algún concesionario.", player, 255, 0, 0)
				outputChatBox("Ten en cuenta que el concesionario no tiene la obligación de vendértelo.", player, 255, 0, 0)]]
				return
			end
			local vehicle = exports.vehicles:getVehicle(tonumber(vehID))
			local sql_robo = exports.sql:query_assoc_single("SELECT roboID from robos WHERE tipo = 1 and objetoID = "..tostring(vehID))	
			if sql_robo then outputChatBox("Este vehículo ha sido robado. Avisa a la policía por si lo han recuperado.", player, 255, 0, 0) return end
			if hasObjectPermissionTo(player, 'command.vip', false) then
				outputChatBox("Coste de la Localización: #00FF000$ ##B400FF(Usuario V.I.P.)", player, 255, 255, 255, true)
			else
				if exports.players:takeMoney(player, 50) then
					outputChatBox("Coste de la Localización: #FF000050$", player, 255, 255, 255, true)
				else
					outputChatBox("No tienes los 50$ que cuesta la Localización.", player, 255, 0, 0)
					return
				end
			end
			local posX, posY, posZ = getElementPositionLocalizadoVeh(vehicle)
			blipLocalizado[vehicle] = createBlip( posX, posY, posZ, 0, 2, 0, 0, 255, 255, 0, 99999.0, player )
			outputChatBox("Se ha localizado el vehículo con ID " ..tostring(vehID).." (Cuadrado/Triángulo Azul).", player, 0, 255, 0)
		end
	end
end
addCommandHandler("localizarvehiculo", localizarVehiculo)
addCommandHandler("lveh", localizarVehiculo)
addEvent("onLocalizarVehiculo", true)
addEventHandler("onLocalizarVehiculo", getRootElement(), localizarVehiculo)

function matriculasCercanas (player)
	exports.chat:me(player, "mira las matrículas de los vehículos cercanos.")
	outputChatBox("Vehículos cercanos", player, 255, 0, 0)
	for k, v in ipairs(getElementsByType("vehicle")) do
		local x1, y1, z1 = getElementPosition ( player )
		x2, y2, z2 = getElementPosition ( v )
		local distance = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )
		if distance <= 5 and getElementDimension(player) == getElementDimension(v) then
			if getElementData(v, "tapada") == true then
				outputChatBox(getVehicleName(v).. " - ID "..tostring(getElementData(v, "idveh")).."(TAPADA)", player, 0, 255, 0)
			else
				outputChatBox(getVehicleName(v).. " - ID "..tostring(getElementData(v, "idveh")), player, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("matriculas", matriculasCercanas)

function desvolcarVehiculo (player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then return end
	local rx, ry, rz = getElementRotation(vehicle)
	if not vehicle or not rx or not ry or not rz then return end
	if ((90<ry) and (ry<270)) or (90<rx) and (rx<270) then
		setElementHealth(vehicle, 255)
		setVehicleEngineState(vehicle, false)
		outputChatBox("Vehículo desvolcado. Avisa a un taller mecánico.", player, 0, 255, 0)
		setElementRotation(vehicle, 0, 0, rz)
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), desvolcarVehiculo)
addEvent("onDesvolcarVehiculo", true)
addEventHandler("onDesvolcarVehiculo", getRootElement(), desvolcarVehiculo)

------------------------------------
-- QUANTUMZ - QUANTUMZ - QUANTUMZ --
------------------------------------
--         2011 - Romania	  	  -- 	    
------------------------------------
-- You can modify this file but   --
-- don't change the credits.      --
------------------------------------
------------------------------------
--  VEHICLECONTROL v1.0 for MTA   --
------------------------------------

function openDoor(door, position)
	local vehicle = getPedOccupiedVehicle(source)
	if getPedOccupiedVehicleSeat(source) == 0 then
		if door == 0 then
			if position==0 then
				setVehicleDoorOpenRatio(vehicle, 0, 0, 0.5)
			end
			if position==100 then
				setVehicleDoorOpenRatio(vehicle, 0, 1, 0.5)
			end
			if position>0 and position<100 then
				setVehicleDoorOpenRatio(vehicle, 0, position/100, 0.5)
			end
		end
		if door == 1 then
			if position==0 then
				setVehicleDoorOpenRatio(vehicle, 1, 0, 0.5)
			end
			if position==100 then
				setVehicleDoorOpenRatio(vehicle, 1, 1, 0.5)
			end
			if position>0 and position<100 then
				setVehicleDoorOpenRatio(vehicle, 1, position/100, 0.5)
			end
		end
		if door == 2 then
			if position==0 then
				setVehicleDoorOpenRatio(vehicle, 2, 0, 0.5)
			end
			if position==100 then
				setVehicleDoorOpenRatio(vehicle, 2, 1, 0.5)
			end
			if position>0 and position<100 then
				setVehicleDoorOpenRatio(vehicle, 2, position/100, 0.5)
			end
		end
		if door == 3 then
			if position==0 then
				setVehicleDoorOpenRatio(vehicle, 3, 0, 0.5)
			end
			if position==100 then
				setVehicleDoorOpenRatio(vehicle, 3, 1, 0.5)
			end
			if position>0 and position<100 then
				setVehicleDoorOpenRatio(vehicle, 3, position/100, 0.5)
			end
		end
		if door == 4 then
			if position==0 then
				setVehicleDoorOpenRatio(vehicle, 4, 0, 0.5)
			end
			if position==100 then
				setVehicleDoorOpenRatio(vehicle, 4, 1, 0.5)
			end
			if position>0 and position<100 then
				setVehicleDoorOpenRatio(vehicle, 4, position/100, 0.5)
			end
		end
		if door == 5 then
			if position==0 then
				setVehicleDoorOpenRatio(vehicle, 5, 0, 0.5)
			end
			if position==100 then
				setVehicleDoorOpenRatio(vehicle, 5, 1, 0.5)
			end
			if position>0 and position<100 then
				setVehicleDoorOpenRatio(vehicle, 5, position/100, 0.5)
			end
		end
	end
end		
addEvent("moveThisShit", true)
addEventHandler("moveThisShit", getRootElement(), openDoor)

function miDeposito (player)
	if not isElementInRange(player, 2424.62, 48.5, 26.48, 10) then outputChatBox("Acude a la puerta del parking de policía para usar este comando.", player, 255, 0, 0) return end
	local sql = exports.sql:query_assoc("SELECT * FROM vehicles WHERE characterID = "..exports.players:getCharacterID(player))
	outputChatBox("~~~~ Vehículos que tienes en el depósito ~~~~", player, 255, 255, 255)
	local depo = false
	for k, v in ipairs(sql) do
		if tonumber(v.cepo) == 1 then
			depo = true
			outputChatBox("ID "..tostring(v.vehicleID).." - "..tostring(getVehicleNameFromModel(v.model)).. ".", player, 255, 0, 0)
		end
	end
	if depo == false then
		outputChatBox("Actualmente no hay ningún vehículo tuyo en el depósito.", player, 0, 255, 0)
	else
		--outputChatBox("Utiliza /retirardepo [ID de vehículo] para retirarlo.", player, 0, 255, 0)
		outputChatBox("Acude a la policía para retirarlo.", player, 0, 255, 0)
	end
	for k2, v2 in ipairs(exports.factions:getPlayerFactions(player)) do
		if exports.factions:isFactionOwner(player, v2) then
			outputChatBox("~~~~ Vehículos que tiene "..tostring(exports.factions:getFactionName(v2)).." en el depósito ~~~~", player, 255, 255, 255)
			local sql2 = exports.sql:query_assoc("SELECT * FROM vehicles WHERE characterID = -"..v2)
			local depof = false
			for k, v in ipairs(sql2) do
				if tonumber(v.cepo) == 1 then
					depof = true
					outputChatBox("ID "..tostring(v.vehicleID).." - "..tostring(getVehicleNameFromModel(v.model)).. ".", player, 255, 0, 0)
				end
			end
			if depof == false then
				outputChatBox("Actualmente no hay ningún vehículo de "..tostring(exports.factions:getFactionName(v2)).." en el depósito.", player, 0, 255, 0)
			else
				--outputChatBox("Utiliza /retirardepo [ID de vehículo] para retirarlo.", player, 0, 255, 0)
				outputChatBox("Acude a la policía para retirarlo.", player, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("mideposito", miDeposito)


local markerDeposito = createMarker(2422.62, 48.8, 25.7, "cylinder", 2, 102, 204, 255, 255)

function retirarDeposito (player, cmd, id)
	if not isElementInRange(player, 2422.62, 48.8, 26.48, 10) then outputChatBox("Acude al punto azul del parking de policía para retirarlo.", player, 255, 0, 0) return end
	if tonumber(id) then
		local sql = exports.sql:query_assoc_single("SELECT * FROM vehicles WHERE vehicleID = "..tostring(id))
		if tonumber(sql.characterID) == exports.players:getCharacterID(player) or exports.factions:isFactionOwner(player, tonumber(sql.characterID)*-1)  then
			if tonumber(sql.cepo) == 1 or tonumber(sql.cepo) == 2 then
				local sql3 = exports.sql:query_assoc_single("SELECT roboID FROM robos WHERE tipo = 1 AND objetoID = "..id)
				if not sql3 and tonumber(sql.cepo) == 1 then
					if tonumber(sql.characterID) > 0 then
						exports.policia:addMulta(sql.characterID, 200, "Retirada Deposito", 1, "Retirada Deposito (vID "..tostring(id)..")")
						outputChatBox("Se te ha puesto una multa de 200$ por retirar el vehículo.", player, 255, 0, 0)
					else
						if exports.factions:takeFactionPresupuesto(tonumber(sql.characterID)*-1, 200) ~= true then outputChatBox("El F3 no tiene suficiente presupuesto (200$)", player, 255, 0, 0) return end
						outputChatBox("Se ha retirado 200$ al presupuesto de la facción.", player, 255, 0, 0)
						exports.factions:giveFactionPresupuesto(1, 200)
					end
				else
					if tonumber(sql.cepo) == 1 then
						exports.sql:query_free("DELETE FROM robos WHERE roboID = "..sql3.roboID)
						outputChatBox("No se te ha puesto ninguna multa; el vehículo tenía denuncia por robo.", player, 0, 255, 0)
					else
						outputChatBox("No se te ha puesto ninguna multa; vehículo transladado desde Los Santos.", player, 0, 255, 0)
					end
				end
				if tonumber(sql.cepo) == 1 then
					local sql, error = exports.sql:query_free("UPDATE `deposito` SET `estado` = '%s' WHERE `vehicleID` = "..id, "Retirado (Sistema /mideposito)") -- Por seguridad, NO se borrará ninguna orden emitida.
				end
				exports.sql:query_free("UPDATE vehicles SET cepo = 0 WHERE vehicleID = "..id)
				exports.vehicles:reloadVehicle(tonumber(id))
				local vehicle = exports.vehicles:getVehicle(tonumber(id))
				setElementPosition(vehicle, 2436.7578125, 46.31640625, 26.1005859375)
				setElementRotation(vehicle, 359.11010742188, 355.69885253906, 90.340576171875)
				fixVehicle(vehicle)
				setElementFrozen(vehicle, false)
				setTimer(setElementFrozen, 3000, 1, vehicle, true)
				fixVehicle(vehicle)
				outputChatBox("Has retirado tu vehículo correctamente.", player, 0, 255, 0)
				local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
				if nivel == 3 and not exports.objetivos:isObjetivoCompletado(26, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(26, exports.players:getCharacterID(player), player)
				end
			else
				outputChatBox("¡Ups! Este vehículo no está en el depósito policial.", player, 255, 0, 0)
			end
		else
			outputChatBox("¡Ups! Este vehículo no es tuyo. Revisa el ID especificado.", player, 255, 0, 0)
		end
	else
		outputChatBox("ID inválido. Usa /retirardepo [ID del vehículo].", player, 255, 0, 0)
	end
end
--addCommandHandler("retirardepo", retirarDeposito)
--addEvent("onRetirarDepo", true)
--addEventHandler("onRetirarDepo", getRootElement(), retirarDeposito)

function regulacionSemaforos(tipo)
	-- Primero desactivamos el control automático y todos rojos.
	if not tonumber(tipo) then
		setTrafficLightsLocked(true)
		setTrafficLightState(2) -- Todos rojos
		setTimer(regulacionSemaforos, 5000, 1, 1) -- En 5 segundos que se pongan en verde.
	elseif tipo == 1 then
		setTrafficLightState(0) -- X verdes
		setTimer(regulacionSemaforos, 10000, 1, 2) -- En 10 segundos que se pongan en amarillo los verdes.
	elseif tipo == 2 then
		setTrafficLightState(1)
		setTimer(regulacionSemaforos, 3000, 1, 3) -- En 3 segundos que se pongan en rojo los amarillos.
	elseif tipo == 3 then
		setTrafficLightState(2)
		setTimer(regulacionSemaforos, 2000, 1, 4) -- En 2 segundos que se pongan en verde los otros rojos.
	elseif tipo == 4 then
		setTrafficLightState(3)
		setTimer(regulacionSemaforos, 10000, 1, 5) -- En 10 segundos que se pongan en amarillo los verdes.
	elseif tipo == 5 then
		setTrafficLightState(4)
		setTimer(regulacionSemaforos, 3000, 1, 6) -- En 3 segundos que se pongan en rojo los amarillos.
	elseif tipo == 6 then
		setTrafficLightState(2)
		setTimer(regulacionSemaforos, 2000, 1, 1) -- En 2 segundos que se pongan en verde los otros
	end
end

function iniciarRegulacion()
	regulacionSemaforos()
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), iniciarRegulacion)

function solicitarAperturaGUIVehs (player)
	if exports.players:isLoggedIn(player) and not getElementData(player, "GUIVehs") then
		local sql = exports.sql:query_assoc("SELECT * FROM vehicles WHERE inactivo = 0 AND characterID = "..exports.players:getCharacterID(player))
		triggerClientEvent(player, "onAbrirGUIGestVehs", player, sql)
		setElementData(player, "GUIVehs", true)
	end
end
addCommandHandler("misvehs", solicitarAperturaGUIVehs)
addCommandHandler("misvehiculos", solicitarAperturaGUIVehs)
addCommandHandler("miscoches", solicitarAperturaGUIVehs)
addEventHandler("onMarkerHit", markerDeposito, solicitarAperturaGUIVehs)

function calcularPrecioVenta(modelo, fmotor, ffrenos)
	if modelo and fmotor and ffrenos then
		--[[ 40% del precio del vehículo + 50% del coste de las fases. El tunning no vale nada, porque no
		se sabe si el que lo compre lo quiere modificar o le gusta así.]]
		local precioVeh = 0
		local precioVehOriginal = tonumber(exports.vehicles_auxiliar:getPrecioFromModel(getVehicleNameFromModel(modelo)))*0.40
		local faseMotor = 6000
		local faseFrenos = 5000
		if fmotor > 0 then
			costeFasesMotor = (fmotor*faseMotor)+((fmotor-1)*faseMotor)
		else
			costeFasesMotor = 0
		end
		if ffrenos > 0 then
			costeFasesFrenos = (ffrenos*faseFrenos)+((ffrenos-1)*faseFrenos)
		else
			costeFasesFrenos = 0
		end
		local costeDosFases = costeFasesMotor+costeFasesFrenos
		local precioVeh = (costeDosFases*0.5)+precioVehOriginal
		return precioVeh
	end
end