radares = {
--{x = -820.16015625, y = 1368.88671875, z = 13.609375, vmax = 100},
--{x = -187.9423828125, y = 1058.171875, z = 19.59375, vmax = 60},
--{x = -1810.6, y = 353.84, z = 17.02, vmax = 60},
--{x = -2057.74, y = 1280.54, z = 7.33, vmax = 60},
}

function addZero( number, size )
  local number = tostring( number )
  local number = #number < size and ( ('0'):rep( size - #number )..number ) or number
     return number
end

function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	actualSpeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)         
    mph = math.floor(actualSpeed * 160)
	return mph
end

function aplicarSancion (hitElement, dimension)
	if dimension == true and getElementType(hitElement) == "vehicle" then
		local conductor = getVehicleController(hitElement)
		local model = getElementModel(hitElement)
		if conductor then
			if model == 509 or model == 481 or model == 510 then return end 
			if getVehicleSirensOn(hitElement) == true then return end
			if getElementData(hitElement, "tapada") == true then return end
			if getElementData(conductor, "account:gmduty") == true then return end
			local titular = exports.vehicles:getOwner(hitElement)
			if titular == -1 or titular == -2 or titular == -5 or titular == -10 or titular == -12 then return end
			if getVehicleVelocity(hitElement) >= tonumber(getElementData(source, "vmax") + 11) and tonumber(getElementData(source, "vmax")) > 0 then
				exports.policia:addMulta(tonumber(exports.players:getCharacterID(conductor)), 200, "Radar de Velocidad", 1, tostring(getVehicleVelocity(hitElement)).." km/h en vía de "..tostring(getElementData(source, "vmax")).." km/h. Margen de 10 km considerado.")
				setTimer(outputChatBox, math.random(15000, 50000), 1, "Has recibido una multa por circular a "..tostring(getVehicleVelocity(hitElement)).." km/h en vía de "..tostring(getElementData(source, "vmax")).." km/h.", conductor, 255, 0, 0)
			end
			local rx, ry, rz = getElementRotation(hitElement)
			if tonumber(getElementData(source, "vmax")) == -1 and getTrafficLightState() < 3 and tonumber(rz) < 310 and tonumber(rz) >= 210 then
				outputChatBox("Has recibido una multa de $150 por saltarte un semáforo en rojo.", conductor, 255, 0, 0)
				exports.policia:addMulta(tonumber(exports.players:getCharacterID(conductor)), 150, "Radar #2 de Semáforo", 1, "Saltarse un semáforo en rojo")
			end
		end
	end
end

--[[function crearRadares()
	for k, v in ipairs (radares) do
		local m = createMarker(v.x, v.y, v.z, "cylinder", 12, 0, 0, 255, 0)
		addEventHandler("onMarkerHit", m, aplicarSancion)
		setElementData(m, "vmax", tonumber(v.vmax))
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), crearRadares)]]

local policiaRadar = {}
local vehicleData = {}

function showDetect(car)
	if getElementType(car) == "vehicle" then
		local vehicle = vehicleData[source]
		if vehicle then
			for i = 1, 2 do
				local player = getVehicleOccupant ( vehicle, i - 1 )
				if player then
					local sx, sy, sz = getElementVelocity ( car )
					local speed = (sx^2 + sy^2 + sz^2)^(0.5)
					local kmh = speed * 180
					if getElementData(vehicle, "cepo") == true then return end
					local sql = exports.sql:query_assoc_single("SELECT roboID from robos WHERE tipo = 1 and objetoID = "..tostring(getElementData(car, "idveh")))						
					if (kmh > 20) or (sql and sql.roboID) or getElementData(car, "tapada") == true then
						if getElementData(car, "tapada") == true then
							if (kmh > 5) then
								outputChatBox("¡ATENCIÓN! Vehículo " .. getVehicleNameFromModel ( getElementModel(car) ) .. " con Matricula Tapada a "..getVehicleVelocity(car) .. " KM/H", player, 255, 255, 255)
							else
								outputChatBox("¡ATENCIÓN! Vehículo " .. getVehicleNameFromModel ( getElementModel(car) ) .. " con Matricula Tapada estacionado cerca de usted.", player, 255, 255, 255)
							end
						else
							local sql = exports.sql:query_assoc_single("SELECT roboID from robos WHERE tipo = 1 and objetoID = "..tostring(getElementData(car, "idveh")))
							if sql and sql.roboID then
								if (kmh > 5) then
									outputChatBox("¡VEHÍCULO ROBADO " .. getVehicleNameFromModel ( getElementModel(car) ) .. " ("..tostring(getElementData(car, "idveh"))..") a "..getVehicleVelocity(car) .. " KM/H!", player, 255, 0, 0)
								else
									outputChatBox("¡VEHÍCULO ROBADO ESTACIONADO " .. getVehicleNameFromModel ( getElementModel(car) ) .. " ("..tostring(getElementData(car, "idveh"))..")!", player, 255, 0, 0)
								end
							else
								outputChatBox("Vehículo " .. getVehicleNameFromModel ( getElementModel(car) ) .. "("..tostring(getElementData(car, "idveh"))..") a "..getVehicleVelocity(car) .. " KM/H", player, 255, 255, 255)
							end
						end
					end
				end
			end
		end
	end
end

addCommandHandler("radarp",
function(player)
	local vehicle = getPedOccupiedVehicle ( player )
	if vehicle then
		local model = getElementModel(vehicle)
		if exports.factions:isPlayerInFaction(getVehicleController(vehicle), 1) or getElementData(getVehicleController(vehicle), "enc1") then
			if not policiaRadar[vehicle] or policiaRadar[vehicle] == "nil" or policiaRadar[vehicle] == nil then
				local sx, sy, sz = getElementVelocity ( vehicle )
				local speed = (sx^2 + sy^2 + sz^2)^(0.5)
				if speed < 10 then
					local x, y, z =  getElementPosition(vehicle)
					policiaRadar[vehicle] = createColSphere ( x, y, z, 25 )
					vehicleData[policiaRadar[vehicle]] = vehicle
					outputChatBox("El radar ha sido activado.", player, 75, 255, 75)
					attachElements ( policiaRadar[vehicle], vehicle )
					addEventHandler ( "onColShapeHit", policiaRadar[vehicle], showDetect )
				else
					outputChatBox("El vehiculo tiene que estar parado para activar el radar.", player, 255, 75, 75)
				end
			else
				destroyElement(policiaRadar[vehicle])
				vehicleData[policiaRadar[vehicle]] = nil
				policiaRadar[vehicle] = nil
				outputChatBox("El radar ha sido desactivado.", player, 255, 75, 75)
			end
		end
	end
end)