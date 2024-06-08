function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false  
end
 
function bindGeneral(player)
	if exports.factions:isPlayerInFaction(player, 3) then
		if isPedInVehicle(player) then
			local vehicle = getPedOccupiedVehicle(player)
			if getElementData(vehicle, "inTunning") then
				exports.vehicles_auxiliar:applyTunning(vehicle)
				removeElementData(vehicle, "inTunning")
			end
			if getVehicleController(vehicle) == player then
				local sx, sy, sz = getElementVelocity (vehicle)
				local velocidad = (sx^2 + sy^2 + sz^2)^(0.5) 
				if tonumber(velocidad*180) <= 2 then
					setVehicleEngineState( vehicle, false )
					triggerClientEvent(player, "onPlayerOpenMecanico", player)
				end
			else
				outputChatBox("Debes de estar subido como conductor para abrir el panel mecánico.", player, 255, 0, 0)
			end
		else
			outputChatBox("No estás en un vehículo.", player, 255, 0, 0)
		end
	end
end

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()),
function()
	for i, k in ipairs(getElementsByType("player")) do
		bindKey ( k, "F5", "down", bindGeneral )
	end
end)

addEventHandler("onPlayerJoin", root,
function()
	bindKey ( source, "F5", "down", bindGeneral )
end)

function getVehicleHandlingProperty( vehiculo, property )
    if isElement ( vehiculo ) and getElementType ( vehiculo ) == "vehicle" and type ( property ) == "string" then
		model = getElementModel(vehiculo)
        local handlingTable = getOriginalHandling ( model )
        local value = handlingTable[property]
        if value then
            return value
        end
    end
    return false
end

function quitarPiezas(player, numPiezas)
	if player and numPiezas and (exports.factions:isPlayerInFaction(player, 3))then
		local piezas, slot, v = exports.items:has(player, 34)
		if piezas then
			if numPiezas > v.value then 
				return false
			elseif numPiezas == v.value then
				exports.items:take(player, slot)
				return true
			elseif numPiezas < v.value then
				local value2 = v.value-numPiezas
				exports.items:take(player, slot)
				exports.items:give(player, 34, tonumber(value2))
				return true
			end
		else 
			return false
		end
	else
		return false
	end
end

addEvent("mecanico:repair", true)
addEventHandler("mecanico:repair", root,
function(state)
	local vehicle = getPedOccupiedVehicle( source )
	if vehicle then
		local owner = tonumber(exports.vehicles:getOwner(vehicle))
		if owner == -1 or owner == -2 or owner == -5 or owner == -6 or owner == -8 then
			if state == 1 then
				local r1, r2, r3, r4 = getVehicleWheelStates ( vehicle )
				local hp = getElementHealth(vehicle)
				fixVehicle(vehicle)
				setVehicleWheelStates ( vehicle, r1, r2, r3, r4 )
				setElementHealth(vehicle, hp)
				outputChatBox("Has reparado el chasis del vehículo sin coste de piezas.", source, 75, 255, 75)
				outputChatBox("Debes cobrar 50$ por la reparación de chasis al conductor.", source, 255, 255, 255)
				outputChatBox("Reparación a vehículos estatales subvencionada por el Gobierno de Red County.", source, 0, 255, 0)
				playSoundFrontEnd ( source, 46 )
			elseif state == 2 then
				setElementHealth(vehicle, 1000)
				outputChatBox("Has reparado el motor del vehículo sin coste de piezas.", source, 75, 255, 75)
				outputChatBox("Debes cobrar 50$ por la reparación de motor al conductor.", source, 255, 255, 255)
				outputChatBox("Reparación a vehículos estatales subvencionada por el Gobierno de Red County.", source, 0, 255, 0)
				if isVehicleDamageProof( vehicle ) then
					setVehicleDamageProof( vehicle, false )
				end
				playSoundFrontEnd ( source, 46 )
			end
		else
			if state == 1 then
				if quitarPiezas(source, 2) then
					local r1, r2, r3, r4 = getVehicleWheelStates ( vehicle )
					local hp = getElementHealth(vehicle)
					fixVehicle(vehicle)
					setVehicleWheelStates ( vehicle, r1, r2, r3, r4 )
					setElementHealth(vehicle, hp)
					outputChatBox("Has reparado el chasis del vehículo por 2 piezas.", source, 75, 255, 75)
					playSoundFrontEnd ( source, 46 )
				else
					outputChatBox("No tienes las 2 piezas necesarias. Utiliza /comprarpiezas", source, 255, 0, 0)
				end
			elseif state == 2 then
				if quitarPiezas(source, 3) then
					setElementHealth(vehicle, 1000)
					outputChatBox("Has reparado el motor del vehículo por 3 piezas.", source, 75, 255, 75)
					if isVehicleDamageProof( vehicle ) then
						setVehicleDamageProof( vehicle, false )
					end
					playSoundFrontEnd ( source, 46 )
				else
					outputChatBox("No tienes las 3 piezas necesarias. Utiliza /comprarpiezas", source, 255, 0, 0)
				end
			end
		end
	end
end)

addEvent("mecanico:cerradura", true)
addEventHandler("mecanico:cerradura", root,
function(tipo)
	local vehicle = getPedOccupiedVehicle( source )
	if vehicle then
		local vehID = getElementData(vehicle, "idveh")
		if vehID then
			if tonumber(tipo) == 0 then
				local sql = exports.sql:query_assoc_single("SELECT characterID FROM vehicles WHERE vehicleID = " .. vehID )
				local sql2 = exports.sql:query_assoc_single("SELECT characterName FROM characters WHERE characterID = " .. sql.characterID )
				local player = getPlayerFromName(sql2.characterName:gsub(" ", "_"))
				if not player then outputChatBox("El titular del vehículo no está conectado.", source, 255, 0, 0) return end
				exports.admin:anularLlaves(tonumber(vehID), 1)
				exports.items:give(player, 1, vehID)
			elseif not tipo then
				if quitarPiezas(source, 4) then
					local sql = exports.sql:query_assoc_single("SELECT characterID FROM vehicles WHERE vehicleID = " .. vehID )
					if not sql then outputChatBox("Este vehículo no tiene dueño. Avisa a un staff URGENTE.", source, 255, 0, 0) return end
					local sql2 = exports.sql:query_assoc_single("SELECT characterName FROM characters WHERE characterID = " .. sql.characterID )
					local player = getPlayerFromName(sql2.characterName:gsub(" ", "_"))
					if not player then outputChatBox("El titular del vehículo no está conectado.", source, 255, 0, 0) return end
					outputChatBox("Has cambiado la cerradura por 2 piezas.", source, 0, 255, 0)
					exports.admin:anularLlaves(tonumber(vehID), 1)
					exports.items:give(player, 1, vehID)
				else
					outputChatBox("No tienes las piezas necesarias para hacer la operación.", source, 255, 0, 0)
				end
			end
		end
	end
end) 

addEvent("mecanico:alarma", true)
addEventHandler("mecanico:alarma", root,
function ()
	local vehicle = getPedOccupiedVehicle(source)
	if getElementData(vehicle, "havealarm") then outputChatBox("Este vehículo tiene ya una alarma puesta.", source, 255, 0, 0) return end
	if quitarPiezas(source, 5) then
		local vehicleID = getElementData(vehicle, "idveh")
		setElementData(vehicle, "havealarm", true)
		exports.sql:query_free("UPDATE vehicles SET alarma = 1 WHERE vehicleID = " .. vehicleID)
		outputChatBox("Has instalado la alarma por 4 piezas.", source, 0, 255, 0)
	else
		outputChatBox("No tienes las 5 piezas necesarias. Utiliza /comprarpiezas", source, 255, 0, 0)
	end
end)



function instalarVinilos2 (tipo)
	local vehicle = getPedOccupiedVehicle( source )
    if vehicle then
		if tipo then
			setElementData(vehicle, "inVinilos", true)
			setVehiclePaintjob ( vehicle, tipo )
			outputChatBox("Estás previsualizando el vinilo "..tostring(tipo+1)..". Usa /cvinilo para confirmarlo.", source, 255, 0, 0)
		end
	end 
end
addEvent( "mecanico:vinilos2", true )
addEventHandler( "mecanico:vinilos2", getRootElement(), instalarVinilos2)

function confirmarInstalacionVinilos(player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then
		if quitarPiezas(player, 200) then
			removeElementData(vehicle, "inVinilos")
			exports.vehicles_auxiliar:saveVinilos(vehicle)
			outputChatBox("Has confirmado la instalación del vinilo por 200 piezas.", player, 255, 0, 0)
		else
			outputChatBox("No tienes las 200 piezas necesarias. Utiliza /comprarpiezas", player, 255, 0, 0)
		end
	end
end
addCommandHandler("cvinilo", confirmarInstalacionVinilos)

function quitarlosvinilospuestos()
	local vehicle = getPedOccupiedVehicle(source)
	if vehicle then
		if quitarPiezas(source, 50) then
			setVehiclePaintjob(vehicle, 3)
			exports.vehicles_auxiliar:saveVinilos(vehicle)
			outputChatBox("INFO: Has quitado el vinilo que tenía el vehículo",source,255,0,0)
		else
			outputChatBox("(( No tienes las 50 piezas necesarias. Utiliza /comprarpiezas ))",source, 255, 0, 0)
		end
	end
end
addEvent( "mecanico:quitarviniloS",true)
addEventHandler( "mecanico:quitarviniloS", getRootElement(),quitarlosvinilospuestos)

			
function aUpgrades ( upgrade )
    if upgrade then
		local vehicle = getPedOccupiedVehicle ( source )
		if vehicle then
			addVehicleUpgrade ( vehicle, upgrade )
			playSoundFrontEnd ( source, 46 )
		end
	end
end
addEvent( "onChangeUpgrade", true )
addEventHandler( "onChangeUpgrade", root, aUpgrades )

function rUpgrades ( upgrade )
    if upgrade then
		local vehicle = getPedOccupiedVehicle ( source )
		if vehicle then
			removeVehicleUpgrade ( vehicle, upgrade )
			playSoundFrontEnd ( source, 46 )
		end
	end
end
addEvent( "onRemoveUpgrade", true )
addEventHandler( "onRemoveUpgrade", root, rUpgrades )

function ColorChanger ( color, r, g, b )
    if color and r and g and b then
		local vehicle = getPedOccupiedVehicle ( source )
		if vehicle then
			if color == 1 then
				if quitarPiezas(source, 4) then
					_,_,_, r2, g2, b2 = getVehicleColor ( vehicle, true )
					setVehicleColor( vehicle, r, g, b, r2, g2, b2 )
					outputChatBox("Has cambiado el color primario por 4 piezas.", source, 0, 255, 0)
					exports.vehicles_auxiliar:saveColors(vehicle)
				else
					outputChatBox("No tienes las 4 piezas necesarias. Utiliza /comprarpiezas", source, 255, 0, 0)
					exports.vehicles_auxiliar:applyColors(vehicle)
				end
			elseif color == 2 then
				if quitarPiezas(source, 3) then
					r2, g2, b2 = getVehicleColor ( vehicle, true )
					setVehicleColor( vehicle, r2, g2, b2, r, g, b )
					outputChatBox("Has cambiado el color secundario por 3 piezas.", source, 0, 255, 0)
					exports.vehicles_auxiliar:saveColors(vehicle)
				else
					outputChatBox("No tienes las 3 piezas necesarias. Utiliza /comprarpiezas", source, 255, 0, 0)
					exports.vehicles_auxiliar:applyColors(vehicle)
				end
			elseif color == 3 then
				if quitarPiezas(source, 2) then
					setVehicleHeadLightColor ( vehicle, r, g, b )
					outputChatBox("Has cambiado el color de los faros por 2 piezas.", source, 0, 255, 0)
					exports.vehicles_auxiliar:saveColors(vehicle)
				else
					outputChatBox("No tienes las 2 piezas necesarias. Utiliza /comprarpiezas", source, 255, 0, 0)
					exports.vehicles_auxiliar:applyColors(vehicle)
				end
			end
		end
	end
end
addEvent( "onChangeVehicleColor", true )
addEventHandler( "onChangeVehicleColor", root, ColorChanger )

function ColorViewer ( color, r, g, b )
    if color and r and g and b then
		local vehicle = getPedOccupiedVehicle ( source )
		if vehicle then
			if color == 1 then
				_,_,_, r2, g2, b2 = getVehicleColor ( vehicle, true )
				setVehicleColor( vehicle, r, g, b, r2, g2, b2 )
			elseif color == 2 then
				r2, g2, b2 = getVehicleColor ( vehicle, true )
				setVehicleColor ( vehicle, r2, g2, b2, r, g, b )
			elseif color == 3 then
				setVehicleHeadLightColor ( vehicle, r, g, b )
			end
		end
	end
end
addEvent( "onViewVehicleColor", true )
addEventHandler( "onViewVehicleColor", root, ColorViewer )

function rRuedas ( rueda )
	local vehicle = getPedOccupiedVehicle ( source )
    if rueda and vehicle then
		if quitarPiezas(source, 4) then
			setVehicleHandling(vehicle, "maxVelocity", getVehicleHandlingProperty(vehicle, "maxVelocity"))
			setVehicleHandling(vehicle, "engineAcceleration", getVehicleHandlingProperty(vehicle, "engineAcceleration"))
			removeElementData(vehicle, "pinchado")
			if rueda == 1 then 
			setVehicleWheelStates(vehicle, -1, -1, 0, -1)
			elseif rueda == 2 then
			setVehicleWheelStates(vehicle, 0, -1, -1, -1)
			elseif rueda == 3 then
			setVehicleWheelStates(vehicle, -1, -1, -1, 0)	
			elseif rueda == 4 then
			setVehicleWheelStates(vehicle, -1, 0, -1, -1)	
			end
			playSoundFrontEnd ( source, 46 )
		else
			outputChatBox("No tienes las 4 piezas necesarias. Utiliza /comprarpiezas", source, 255, 0, 0)
		end
	end
end
addEvent( "mecanico:repair_rueda", true )
addEventHandler( "mecanico:repair_rueda", root, rRuedas )

function mejoras ( tipo )
	local vehicle = getPedOccupiedVehicle (source)
	if not vehicle then outputChatBox("No estás en un vehículo", source, 255, 0, 0) return end
	if tipo == 1 then -- Motor
		local faseActual = tonumber(getElementData(vehicle, "fasemotor"))
		if not faseActual then outputChatBox("No puedes fasear un vehículo con ID negativa.", source, 255, 0, 0) return end
		if faseActual == 3 then outputChatBox("El motor ya está en la Fase Nº3, que es la máxima.", source, 255, 0, 0) return end
		local precioFase = 6000
		local precioFinal = (faseActual+1)*precioFase
		setElementData(vehicle, "mecanico.precioFinal", tonumber(precioFinal))
		setElementData(vehicle, "mecanico.nuevaFase", tonumber(faseActual+1))
		setElementData(vehicle, "mecanico.tipoFase", 1)
		outputChatBox("Para subir el motor a Fase Nº"..tostring(faseActual+1).." por "..tostring(precioFinal).."$ usa /aceptarfase.", source, 0, 255, 0)
	elseif tipo == 2 then -- Frenos
		local faseActual = tonumber(getElementData(vehicle, "fasefrenos"))
		if not faseActual then outputChatBox("No puedes fasear un vehículo con ID negativa.", source, 255, 0, 0) return end
		if faseActual == 3 then outputChatBox("Los frenos ya están en la Fase Nº3, que es la máxima.", source, 255, 0, 0) return end
		local precioFase = 5000
		local precioFinal = (faseActual+1)*precioFase
		setElementData(vehicle, "mecanico.precioFinal", tonumber(precioFinal))
		setElementData(vehicle, "mecanico.nuevaFase", tonumber(faseActual+1))
		setElementData(vehicle, "mecanico.tipoFase", 2)	
		outputChatBox("Para subir los frenos a Fase Nº"..tostring(faseActual+1).." por "..tostring(precioFinal).."$ usa /aceptarfase.", source, 0, 255, 0)
	end
end
addEvent( "mecanico:mejora", true )
addEventHandler( "mecanico:mejora", root, mejoras )

function marchas ( tipo )
	local vehicle = getPedOccupiedVehicle (source)
	if not vehicle then outputChatBox("(( No estás en un vehículo ))", source, 255, 0, 0) return end
	if tipo == 1 then -- Modo automático
		if quitarPiezas(source, 100) then
			setElementData(vehicle, "marchas", 0)
			exports.sql:query_free("UPDATE vehicles SET marchas = 0 WHERE vehicleID = "..tonumber(getElementData(vehicle, "idveh")))
			outputChatBox("Has puesto las marchas de este vehículo en modo automático.", source, 0, 255, 0)
			outputChatBox("INFO: Ahora podrás conducir el vehículo sin necesidad de reducir ni subir.", source, 255, 255, 0)
			playSoundFrontEnd ( source, 46 )
		else
		outputChatBox("(( No tienes las 100 piezas necesarias. Utiliza /comprarpiezas ))", source, 255, 0, 0)
		end
	elseif tipo == 0 then -- Modo manual
		if quitarPiezas(source, 100) then
			setElementData(vehicle, "marchas", 1)
			outputChatBox("Has puesto las marchas de este vehículo en modo manual.", source, 0, 255, 0)
			outputChatBox("USO: (+) y (-) del numpad para subir y reducir marchas", source, 255, 255, 0)
			exports.sql:query_free("UPDATE vehicles SET marchas = 1 WHERE vehicleID = "..tonumber(getElementData(vehicle, "idveh")))
			playSoundFrontEnd ( source, 46 )
		else
		outputChatBox("(( No tienes las 100 piezas necesarias. Utiliza /comprarpiezas ))", source, 255, 0, 0)
		end
	end
end
addEvent( "mecanico:marchas", true )
addEventHandler( "mecanico:marchas", root, marchas )

function aceptarFase (player)
	if exports.factions:isPlayerInFaction(player, 3) then
		local vehicle = getPedOccupiedVehicle(player)
		if not vehicle then outputChatBox("No estás en un vehículo", player, 255, 0, 0) return end
		local precioFinal = getElementData(vehicle, "mecanico.precioFinal")
		local nuevaFase = getElementData(vehicle, "mecanico.nuevaFase")
		local tipoFase = getElementData(vehicle, "mecanico.tipoFase")
		if tipoFase == 1 then
			if exports.players:takeMoney(player, precioFinal) then
				outputChatBox("Ahora el motor está en Fase Nº"..tostring(nuevaFase)..".", player, 0, 255, 0)
				exports.sql:query_free("UPDATE vehicles SET fasemotor = "..tonumber(nuevaFase).." WHERE vehicleID = "..tonumber(getElementData(vehicle, "idveh")))
				exports.vehicles_auxiliar:solicitarMejora(vehicle, 1, nuevaFase)
				setElementData(vehicle, "fasemotor", nuevaFase)
				removeElementData(vehicle, "mecanico.precioFinal")
				removeElementData(vehicle, "mecanico.nuevaFase")
				removeElementData(vehicle, "mecanico.tipoFase")	
			else
				outputChatBox("No tienes dinero suficiente. Dí que te pague el cliente y usa de nuevo /aceptarfase.", player, 255, 0, 0)
			end
		elseif tipoFase == 2 then
			if exports.players:takeMoney(player, precioFinal) then
				outputChatBox("Ahora los frenos están en Fase Nº"..tostring(nuevaFase)..".", player, 0, 255, 0)
				exports.sql:query_free("UPDATE vehicles SET fasefrenos = "..tonumber(nuevaFase).." WHERE vehicleID = "..tonumber(getElementData(vehicle, "idveh")))
				exports.vehicles_auxiliar:solicitarMejora(vehicle, 2, nuevaFase)
				setElementData(vehicle, "fasefrenos", nuevaFase)
				removeElementData(vehicle, "mecanico.precioFinal")
				removeElementData(vehicle, "mecanico.nuevaFase")
				removeElementData(vehicle, "mecanico.tipoFase")
			else
				outputChatBox("No tienes dinero suficiente. Dí que te pague el cliente y usa de nuevo /aceptarfase.", player, 255, 0, 0)
			end
		end
	else
		outputChatBox("(( No eres mecánico ))", player, 255, 0, 0)
	end
end
addCommandHandler("aceptarfase", aceptarFase)

function comprarPiezas(player, cmd, cantida)
	if exports.factions:isPlayerInFaction(player, 3) then
		if not cantida then outputChatBox ("Sintaxis: /comprarpiezas [cantidad]", player, 255, 255, 255) return end
		local cantidad = math.floor(cantida)
		if exports.factions:isPlayerInFaction(player, 3) and not isElementInRange(player, 2304.76, -125.22, 26.45, 5) then outputChatBox("(( No estás en el taller. ))", player, 255, 0, 0) return end
		if cantidad and cantidad > 0 then
			if exports.players:takeMoney(player, tonumber(cantidad*50)) then
				if exports.factions:isPlayerInFaction(player, 3) then
					exports.factions:giveFactionPresupuesto(3, tonumber(cantidad*50))
				end
				local sitem, slot, item = exports.items:has(player, 34)
					if sitem then
						exports.items:give(player, 34, tonumber (item.value+cantidad))
						exports.items:take(player, slot)
					else
						exports.items:give(player, 34, tonumber (cantidad))
					end
				outputChatBox ("Has comprado "..tostring (cantidad).." piezas por $"..tostring(cantidad*50)..",recuerda trabajar y atender clientes.", player, 0, 255, 0)
				outputChatBox ("Recuerda que para poder reparar y trabajar siempre necesitarás piezas.", player, 255, 255, 0)
			else
				outputChatBox ("¡No tienes suficiente dinero! Cada pieza vale $50 dólares.", player, 255, 0, 0)
			end
		else
			outputChatBox ("Sintaxis: /comprarpiezas [cantidad]", player, 255, 255, 255)
		end
	else
		outputChatBox ("(( No eres mecánico ))", player, 255, 0, 0)
	end
end
addCommandHandler ("comprarpiezas", comprarPiezas)

local upgradeNames = 
{
	[1000] = "Pro",
	[1001] = "Win",
	[1002] = "Drag",
	[1003] = "Alpha",
	[1004] = "Champ Scoop",
	[1005] = "Fury Scoop",
	[1006] = "Roof Scoop",
	[1007] = "Right Sideskirt",
	[1008] = "Nitro x5",
	[1009] = "Nitro x2",
	[1010] = "Nitro x10",
	[1011] = "Race Scoop",
	[1012] = "Worx Scoop",
	[1013] = "Round Fog",
	[1014] = "Champ",
	[1015] = "Race",
	[1016] = "Worx",
	[1017] = "Left Sideskirt",
	[1018] = "Upswept",
	[1019] = "Twin",
	[1020] = "Large",
	[1021] = "Medium",
	[1022] = "Small",
	[1023] = "Fury",
	[1024] = "Square Fog",
	[1025] = "Offroad",
	[1026] = "Right Alien Sideskirt",
	[1027] = "Left Alien Sideskirt",
	[1028] = "Alien",
	[1029] = "X-Flow",
	[1030] = "Left X-Flow Sideskirt",
	[1031] = "Right X-Flow Sideskirt",
	[1032] = "Alien Roof Vent",
	[1033] = "X-Flow Roof Vent",
	[1034] = "Alien",
	[1035] = "X-Flow Roof Vent",
	[1036] = "Right Alien Sideskirt",
	[1037] = "X-Flow",
	[1038] = "Alien Roof Vent",
	[1039] = "Left X-Flow Sideskirt",
	[1040] = "Left Alien Sideskirt",
	[1041] = "Right X-Flow Sideskirt",
	[1042] = "Right Chrome Sideskirt",
	[1043] = "Slamin",
	[1044] = "Chrome",
	[1045] = "X-Flow",
	[1046] = "Alien",
	[1047] = "Right Alien Sideskirt",
	[1048] = "Right X-Flow Sideskirt",
	[1049] = "Alien",
	[1050] = "X-Flow",
	[1051] = "Left Alien Sideskirt",
	[1052] = "Left X-Flow Sideskirt",
	[1053] = "X-Flow",
	[1054] = "Alien",
	[1055] = "Alien",
	[1056] = "Right Alien Sideskirt",
	[1057] = "ight X-Flow Sideskirt",
	[1058] = "Alien",
	[1059] = "X-Flow",
	[1060] = "X-Flow",
	[1061] = "X-Flow",
	[1062] = "Left Alien Sideskirt",
	[1063] = "Left X-Flow Sideskirt",
	[1064] = "Alien",
	[1065] = "Alien",
	[1066] = "X-Flow",
	[1067] = "Alien",
	[1068] = "X-Flow",
	[1069] = "Right Alien Sideskirt",
	[1070] = "Right X-Flow Sideskirt",
	[1071] = "Left Alien Sideskirt",
	[1072] = "Left X-Flow Sideskirt",
	[1073] = "Shadow",
	[1074] = "Mega",
	[1075] = "Rimshine",
	[1076] = "Wires",
	[1077] = "Classic",
	[1078] = "Twist",
	[1079] = "Cutter",
	[1080] = "Switch",
	[1081] = "Grove",
	[1082] = "Import",
	[1083] = "Dollar",
	[1084] = "Trance",
	[1085] = "Atomic",
	[1086] = "Stereo",
	[1087] = "Hydraulics",
	[1088] = "Alien",
	[1089] = "X-Flow",
	[1090] = "Right Alien Sideskirt",
	[1091] = "X-Flow",
	[1092] = "Alien",
	[1093] = "Right X-Flow Sideskirt",
	[1094] = "Left Alien Sideskirt",
	[1095] = "Right X-Flow Sideskirt",
	[1096] = "Ahab",
	[1097] = "Virtual",
	[1098] = "Access",
	[1099] = "Left Chrome Sideskirt",
	[1100] = "Chrome Grill",
	[1101] = "Left `Chrome Flames` Sideskirt",
	[1102] = "Left `Chrome Strip` Sideskirt",
	[1103] = "Covertible",
	[1104] = "Chrome",
	[1105] = "Slamin",
	[1106] = "Right `Chrome Arches`",
	[1107] = "Left `Chrome Strip` Sideskirt",
	[1108] = "`Chrome Strip` Sideskirt",
	[1109] = "Chrome",
	[1110] = "Slamin",
	[1111] = "Little Sign?",
	[1112] = "Little Sign?",
	[1113] = "Chrome",
	[1114] = "Slamin",
	[1115] = "Chrome",
	[1116] = "Slamin",
	[1117] = "Chrome",
	[1118] = "Right `Chrome Trim` Sideskirt",
	[1119] = "Right `Wheelcovers` Sideskirt",
	[1120] = "Left `Chrome Trim` Sideskirt",
	[1121] = "Left `Wheelcovers` Sideskirt",
	[1122] = "Right `Chrome Flames` Sideskirt",
	[1123] = "Bullbar Chrome Bars",
	[1124] = "Left `Chrome Arches` Sideskirt",
	[1125] = "Bullbar Chrome Lights",
	[1126] = "Chrome Exhaust",
	[1127] = "Slamin Exhaust",
	[1128] = "Vinyl Hardtop",
	[1129] = "Chrome",
	[1130] = "Hardtop",
	[1131] = "Softtop",
	[1132] = "Slamin",
	[1133] = "Right `Chrome Strip` Sideskirt",
	[1134] = "Right `Chrome Strip` Sideskirt",
	[1135] = "Slamin",
	[1136] = "Chrome",
	[1137] = "Left `Chrome Strip` Sideskirt",
	[1138] = "Alien",
	[1139] = "X-Flow",
	[1140] = "X-Flow",
	[1141] = "Alien",
	[1142] = "Left Oval Vents",
	[1143] = "Right Oval Vents",
	[1144] = "Left Square Vents",
	[1145] = "Right Square Vents",
	[1146] = "X-Flow",
	[1147] = "Alien",
	[1148] = "X-Flow",
	[1149] = "Alien",
	[1150] = "Alien",
	[1151] = "X-Flow",
	[1152] = "X-Flow",
	[1153] = "Alien",
	[1154] = "Alien",
	[1155] = "Alien",
	[1156] = "X-Flow",
	[1157] = "X-Flow",
	[1158] = "X-Flow",
	[1159] = "Alien",
	[1160] = "Alien",
	[1161] = "X-Flow",
	[1162] = "Alien",
	[1163] = "X-Flow",
	[1164] = "Alien",
	[1165] = "X-Flow",
	[1166] = "Alien",
	[1167] = "X-Flow",
	[1168] = "Alien",
	[1169] = "Alien",
	[1170] = "X-Flow",
	[1171] = "Alien",
	[1172] = "X-Flow",
	[1173] = "X-Flow",
	[1174] = "Chrome",
	[1175] = "Slamin",
	[1176] = "Chrome",
	[1177] = "Slamin",
	[1178] = "Slamin",
	[1179] = "Chrome",
	[1180] = "Chrome",
	[1181] = "Slamin",
	[1182] = "Chrome",
	[1183] = "Slamin",
	[1184] = "Chrome",
	[1185] = "Slamin",
	[1186] = "Slamin",
	[1187] = "Chrome",
	[1188] = "Slamin",
	[1189] = "Chrome",
	[1190] = "Slamin",
	[1191] = "Chrome",
	[1192] = "Chrome",
	[1193] = "Slamin"
}

function modificacionVehiculo (vehicle, pInstalada, pQuitada, nPiezas)
	if source and client and client == source and vehicle and nPiezas then
		outputChatBox("ATENCIÓN "..getPlayerName(source):gsub("_", " ")..". Está usted a punto de modificar el vehículo:", source, 255, 255, 0)
		outputChatBox("Vehículo ID "..tostring(getElementData(vehicle, "idveh")).." Modelo "..tostring(getVehicleNameFromModel(getElementModel(vehicle))), source, 255, 255, 255)
		outputChatBox("Piezas que serán instaladas:", source, 0, 255, 0)
		for k, v in ipairs(getVehicleUpgrades(vehicle)) do
			if pInstalada[v] == true and not pQuitada [v] == true then
				outputChatBox("ID "..tostring(v).. " - "..tostring(upgradeNames[v]), source, 0, 255, 0)
			end
		end
		outputChatBox("Piezas que serán desinstaladas:", source, 255, 0, 0)
		for i = 1000, 1193 do
			if pQuitada[i] == true then
				if pInstalada[i] == true then
					nPiezas = nPiezas - 4
				else
					outputChatBox("ID "..tostring(i).. " - "..tostring(upgradeNames[i]), source, 255, 0, 0)
				end
			end
		end
		setElementData(vehicle, "nPiezas", tonumber(nPiezas))
		outputChatBox("Coste TOTAL de piezas para la modificación: "..tostring(nPiezas), source, 255, 255, 0)
		outputChatBox("Usa /confirmar para que se aplique la modificación permanentemente.", source, 255, 255, 255)
	end
end
addEvent("mecanico:savetunning", true)
addEventHandler("mecanico:savetunning", getRootElement(), modificacionVehiculo)

function anularModificacionVehiculo (vehicle)
	if vehicle then
		exports.vehicles_auxiliar:applyTunning(vehicle)
		outputChatBox("Tunning sin confirmar, modificaciones eliminadas.", source, 255, 0, 0)
	end
end
addEvent("mecanico:canceltunning", true)
addEventHandler("mecanico:canceltunning", getRootElement(), anularModificacionVehiculo)

function confirmarModificacionVehiculo(player)
	if exports.factions:isPlayerInFaction(player, 3) then
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle and tonumber(getElementData(vehicle, "nPiezas")) >= 0 then
			if exports.items:has(player, 34) or tonumber(getElementData(vehicle, "nPiezas")) == 0 then
				local item, slot, v = exports.items:has(player, 34)
				local valueAQuitar = tonumber(getElementData(vehicle, "nPiezas"))
				if valueAQuitar > 0 then
					if valueAQuitar > v.value then
						outputChatBox("¡No tienes suficientes piezas! Tunning cancelado.", player, 255, 0, 0)
					elseif valueAQuitar == v.value then
						exports.items:take(player, slot)
						removeElementData(vehicle, "inTunning")
						removeElementData(vehicle, "nPiezas")
						exports.vehicles_auxiliar:saveTunning(vehicle)
						outputChatBox("Has confirmado la modificación descrita. Coste: "..tostring(valueAQuitar).." piezas.", player, 0, 255, 0)
					elseif valueAQuitar < v.value then
						local valueADevolver = v.value-valueAQuitar
						exports.items:take(player, slot)
						exports.items:give(player, 34, tonumber(valueADevolver))
						removeElementData(vehicle, "inTunning")
						removeElementData(vehicle, "nPiezas")
						exports.vehicles_auxiliar:saveTunning(vehicle)
						outputChatBox("Has confirmado la modificación descrita. Coste: "..tostring(valueAQuitar).." piezas.", player, 0, 255, 0)
					end
				else
					removeElementData(vehicle, "inTunning")
					removeElementData(vehicle, "nPiezas")
					exports.vehicles_auxiliar:saveTunning(vehicle)
					outputChatBox("Has confirmado la modificación descrita. Coste: 0 piezas.", player, 0, 255, 0)
				end
			else
				outputChatBox("¡No tienes suficientes piezas! Revisión cancelada.", player, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("confirmar", confirmarModificacionVehiculo)


function cancelacionModificacion(player)
	if source and isElement(source) then
		if getElementData(source, "inTunning") then -- No se ha confirmado el tunning. Recargando tunning.
			exports.vehicles_auxiliar:applyTunning(source)
			if player then
				outputChatBox("Tunning sin confirmar, modificaciones eliminadas.", player, 255, 0, 0)
			end
			removeElementData(source, "inTunning")
		end
		if getElementData(source, "inVinilos") then -- No se han confirmado los vinilos. Recargando vinilos.
			exports.vehicles_auxiliar:applyTunning(source)
			if player then
				outputChatBox("Vinilos sin confirmar, modificaciones eliminadas.", player, 255, 0, 0)
			end
			removeElementData(source, "inVinilos")
		end
		exports.vehicles_auxiliar:applyColors(source)
	end
end
addEventHandler("onVehicleExit", getRootElement(), cancelacionModificacion)

local revisionesNombre = {
	[1] = "Cambio de aceite",
	[2] = "Cambio de neumáticos",
	[3] = "Cambio de filtro de aceite",
	[4] = "Cambio de filtro de aire",
	[5] = "Cambio de filtro de combustible",
	[6] = "Cambio de pastillas de freno",
	[7] = "Cambio de discos de freno",
	[8] = "Cambio de amortiguadores",
	[9] = "Cambio de distribución",
}

local revisionesPiezas = {
	[1] = 4,
	[2] = 8,
	[3] = 4,
	[4] = 4,
	[5] = 4,
	[6] = 6,
	[7] = 6,
	[8] = 8,
	[9] = 12,
}


addEvent("mecanico:revision", true)
addEventHandler("mecanico:revision", root,
function(state)
	local vehicle = getPedOccupiedVehicle( source )
	if vehicle then
		local vehicleID = getElementData(vehicle, "idveh")
		local sumaPiezas = 0
		outputChatBox("~~Operaciones a realizar en el vehículo~~", source, 0, 255, 0)
		for i=1, 9 do
			if (exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i) == 1) or (exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i) == 2) then
				local tipo = exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i)
				outputChatBox("Operación: "..revisionesNombre[i].." - Piezas: "..tostring(revisionesPiezas[i]).." piezas.", source, 255, 255, 255)
				sumaPiezas = sumaPiezas+revisionesPiezas[i]
			end
		end
		if sumaPiezas == 0 then
			outputChatBox("Este vehículo no tiene ninguna operación de mantenimiento pendiente.", source, 255, 0, 0)
			return
		end
		outputChatBox("Número total de piezas: "..tostring(sumaPiezas)..". Usa /crevision para confirmar la revisión y descontar las piezas.", source, 0, 255, 0)
		setElementData(vehicle, "costeRevisionPiezas", tonumber(sumaPiezas))
		sumaPiezas = 0
	end
end)

function confirmarRevisionVehiculo(player)
	if exports.factions:isPlayerInFaction(player, 3) then
		local vehicle = getPedOccupiedVehicle(player)
		if vehicle and tonumber(getElementData(vehicle, "costeRevisionPiezas")) >= 0 then
			if exports.items:has(player, 34) then
				local item, slot, v = exports.items:has(player, 34)
				local valueAQuitar = tonumber(getElementData(vehicle, "costeRevisionPiezas"))
				local vehicleID = getElementData(vehicle, "idveh")
				if valueAQuitar > 0 then
					if valueAQuitar > v.value then
						outputChatBox("¡No tienes suficientes piezas! Revisión cancelada.", player, 255, 0, 0)
					elseif valueAQuitar == v.value then
						exports.items:take(player, slot)
						removeElementData(vehicle, "costeRevisionPiezas")
						for i=1, 9 do
							if (exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i) == 1) or (exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i) == 2) then
								local tipo = exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i)
								exports.sql:query_insertid("INSERT INTO `vehicles_averias` (`registroID`, `vehicleID`, `operacionID`, `mecanicoID`, `fecha`) VALUES (NULL, '"..vehicleID.."', '"..i.."', '"..exports.players:getCharacterID(player).."', CURRENT_TIMESTAMP)")
							end
						end
						removeElementData(vehicle, "averiado")
						removeElementData(vehicle, "chivato")
						outputChatBox("Has confirmado la revision descrita. Coste: "..tostring(valueAQuitar).." piezas.", player, 0, 255, 0)
					elseif valueAQuitar < v.value then
						local valueADevolver = v.value-valueAQuitar
						exports.items:take(player, slot)
						exports.items:give(player, 34, tonumber(valueADevolver))
						for i=1, 8 do
							if (exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i) == 1) or (exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i) == 2) then
								local tipo = exports.vehicles_auxiliar:isRevisionPendiente(vehicleID, i)
								exports.sql:query_insertid("INSERT INTO `vehicles_averias` (`registroID`, `vehicleID`, `operacionID`, `mecanicoID`, `fecha`) VALUES (NULL, '"..vehicleID.."', '"..i.."', '"..exports.players:getCharacterID(player).."', CURRENT_TIMESTAMP)")
							end
						end
						removeElementData(vehicle, "costeRevisionPiezas")
						removeElementData(vehicle, "averiado")
						removeElementData(vehicle, "chivato")
						outputChatBox("Has confirmado la revision descrita. Coste: "..tostring(valueAQuitar).." piezas.", player, 0, 255, 0)
					end
				end
			else
				outputChatBox("¡No tienes suficientes piezas! Revisión cancelada.", player, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("crevision", confirmarRevisionVehiculo)