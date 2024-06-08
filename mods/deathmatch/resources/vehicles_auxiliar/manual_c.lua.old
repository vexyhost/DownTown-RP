--------- Sistema de cambio manual y automatico del coche.

local sx, sy = guiGetScreenSize()
local gearboxViewOn = false
local vehicleCurrentGear = 0
-- Vehiculos autorizados al sistema de cambio "true" desactivado "false" activado.
local vehicleTypes = {["Plane"]=true,["Monster Truck"]=true,["Bike"]=true, ["Automobile"]=false,["Helicopter"]=true, ["Boat"]=true, ["Trailer"]=true, ["Train"]=true, ["BMX"]=true}
local bike = {[581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true}
local motorbike = {[581]=true, [462]=true, [521]=true, [463]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true}
local postGUI = false

------------ Actualizar cambio
local function updateGear(state)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) or (getVehicleController(vehicle) ~= localPlayer) then return end
	local gearType = getElementData(vehicle, "marchas") or 1
	if (not gearType) then
		toggleControl("accelerate", true)
		toggleControl("brake_reverse", true)
	end
	if (state == 1) then
		if (gearType == 1) then
			if (vehicleCurrentGear < 5) then
				vehicleCurrentGear = vehicleCurrentGear+1
				setElementData(vehicle, "ActualizarMarchasCoche", vehicleCurrentGear, true)
			else
				return
			end
		else
			if (vehicleCurrentGear < 1) then
				vehicleCurrentGear = vehicleCurrentGear+1
				setElementData(vehicle, "ActualizarMarchasCoche", vehicleCurrentGear, true)
			else
				return
			end
		end
	elseif (state == -1) then
		if (vehicleCurrentGear > -1) then
			if (vehicleCurrentGear == 0) then
				if (bike[getElementModel(vehicle)]) then
					return
				end
			end
			
			vehicleCurrentGear = vehicleCurrentGear-1
			setElementData(vehicle, "ActualizarMarchasCoche", vehicleCurrentGear, true)
		else
			return
		end
	elseif (state == -2) then
		if (vehicleCurrentGear ~= 0) then
			vehicleCurrentGear = 0
			setElementData(vehicle, "ActualizarMarchasCoche", 0, true)
		else
			return
		end
	else
		if (state == "num_add") then
			updateGear(1)
		elseif (state == "num_sub") then
			updateGear(-1)
		end
		return
	end
	
	playSoundFrontEnd(4)
end

local function getElementSpeed(element, unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x, y, z = getElementVelocity(element)
		if (unit == "mph") or (unit == 1) or (unit == "1") then
			return (x^2+y^2+z^2)^0.5*100
		else
			return (x^2+y^2+z^2)^0.5*1.8*100
		end
	else
		return false
	end
end

local function updateGearbox()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if (not vehicle) or (getVehicleController(vehicle) ~= localPlayer) then return end
	local gearType = getElementData(vehicle, "marchas") or 0 -- Si no obtenemos, será mejor que le meta un cerapio (auto)
	--[[if (not gearType) then
		toggleControl("accelerate", true)
		toggleControl("brake_reverse", true)
		return
	end]]
	
	local vehicleGear = getVehicleCurrentGear(vehicle)
	local velX, velY, velZ = getElementVelocity(vehicle)
	local type = getVehicleType(vehicle)
	
	local velX2 = math.abs(velX)
	local velY2 = math.abs(velY)
	local velZ2 = math.abs(velZ)
	
	local visible
	local velocityActor
	
	if (vehicleCurrentGear == 1) then
		velocityActor = 1.055
	elseif (vehicleCurrentGear == 2) then
		velocityActor = 1.012
	elseif (vehicleCurrentGear == 3) then
		velocityActor = 1.005
	elseif (vehicleCurrentGear == 4) then
		velocityActor = 1.0025
	else
		velocityActor = 1.002
	end
	
	if (not vehicleTypes[type]) and tonumber(gearType) == 1 then -- Está activado para ese tipo y además tiene cambio manual.
		if (vehicleCurrentGear > 0) then
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			
			if (bike[getElementModel(vehicle)]) then
				toggleControl("accelerate", true)
				toggleControl("brake_reverse", true)
			else
				toggleControl("accelerate", true)
				toggleControl("brake_reverse", false)
				
				if (getElementSpeed(vehicle) > 6) then
					toggleControl("brake_reverse", true)
				else
					toggleControl("brake_reverse", false)
					setControlState("brake_reverse", false)
				end
			end
			
			if (gearType == 1) then
				if (vehicleCurrentGear < vehicleGear) then
					if (math.max(velX2, velY2, velZ2) ~= velZ2) then
						local x, y = velX/velocityActor, velY/velocityActor
						setElementVelocity(vehicle, x, y, velZ)
						-- Linea Roja de indicación de cambio o lo calas XD.
						dxDrawLine((sx-102*2)+32, sy-21, sx-2, sy-21, tocolor(255, 25, 25, 255), 4, postGUI)
					end
				end
			end
		elseif (vehicleCurrentGear == 0) then
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			
			if (bike[getElementModel(vehicle)]) then
				if (motorbike[getElementModel(vehicle)]) then
					toggleControl("accelerate", false)
					toggleControl("brake_reverse", true)
				else
					toggleControl("accelerate", true)
					toggleControl("brake_reverse", true)
				end
			else
				toggleControl("accelerate", false)
				toggleControl("brake_reverse", false)
			end
		elseif (vehicleCurrentGear == -1) then
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			
			if (bike[getElementModel(vehicle)]) then
				toggleControl("accelerate", false)
				toggleControl("brake_reverse", true)
			else
				toggleControl("accelerate", true)
				toggleControl("brake_reverse", true)
			end
			
			if (getElementSpeed(vehicle) > 6) then
				toggleControl("accelerate", false)
			else
				toggleControl("accelerate", false)
				setControlState("accelerate", false)
			end
		end
		if (vehicleGear < vehicleCurrentGear) then
			if (math.max(velX2, velY2, velZ2) ~= velZ2) then
				local s = (((vehicleCurrentGear-vehicleGear)/100)+1)
				s = s*(((vehicleCurrentGear-vehicleGear)/120)+1)
				local x, y = velX/s, velY/s
				setElementVelocity(vehicle, x, y, velZ)
			end
		end
	-- Marcha metida en el momento
		_vehicleCurrentGear = "A"
		if (vehicleCurrentGear == 0) then
			_vehicleCurrentGear = "P"
		elseif (vehicleCurrentGear == -1) then
			_vehicleCurrentGear = "R"
		else
			if (gearType == 1) then
				_vehicleCurrentGear = vehicleCurrentGear
			end
		end
		if (isChatBoxInputActive()) then
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			toggleControl("accelerate", false)
			toggleControl("brake_reverse", false)
		end
	else
		toggleControl("accelerate", true)
		toggleControl("brake_reverse", true)
	end
	-- Información del tipo de cambio en el dx XD franki manda xd
	local tipodecambio = getElementData(vehicle,"marchas")
	-- Cuadro bajo el velocimetro
	dxDrawImage((1134/1366)*sx, (675/768)*sy, (232/1366)*sx, (75/768)*sy, "img/background.png", 0, 0, 0, tocolor(0, 0, 0, 200), true)
	if (tipodecambio == 1) then
		dxDrawText("Cambio: Manual", (1134/1366)*sx, (785/768)*sy, (1368/1366)*sx, (584/768)*sy, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, true, false, false)
		dxDrawImage((1257/1366)*sx, (700/768)*sy, (70/1366)*sx, (40/768)*sy, "img/manual.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText(_vehicleCurrentGear, (1050/1366)*sx, (850/768)*sy, (1368/1366)*sx, (584/768)*sy, (vehicleCurrentGear == -1 and tocolor(200, 25, 25, 0.8*255) or tocolor(255, 255, 255, 0.8*255)), 2, "default-bold", "center", "center", false, false, true, false, false)
		dxDrawText(_vehicleCurrentGear, (1050/1366)*sx, (850/768)*sy, (1368/1366)*sx, (584/768)*sy, tocolor(0, 0, 0, 0.5*255), 2, "default-bold", "center", "center", false, false, true, false, false)
	elseif (tipodecambio == 0) then
		dxDrawText("Cambio: Automatico", (1134/1366)*sx, (785/768)*sy, (1368/1366)*sx, (584/768)*sy, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, true, false, false)
		dxDrawImage((1257/1366)*sx, (700/768)*sy, (70/1366)*sx, (40/768)*sy, "img/automatico.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText("A", (1050/1366)*sx, (850/768)*sy, (1368/1366)*sx, (584/768)*sy, tocolor(255, 255, 255, 0.8*255), 2, "default-bold", "center", "center", false, false, true, false, false)
		dxDrawText("A", (1050/1366)*sx, (850/768)*sy, (1368/1366)*sx, (584/768)*sy, tocolor(0, 0, 0, 0.5*255), 2, "default-bold", "center", "center", false, false, true, false, false)
	end
end

addEventHandler("onClientVehicleEnter", root,
	function(player, seat)
		if (player ~= localPlayer) or (seat ~= 0) then return end
		if not getElementData(source, "marchas") == 1 then return end
		addEventHandler("onClientRender", root, updateGearbox)
		gearboxViewOn = true
		vehicleCurrentGear = tonumber(getElementData(source, "ActualizarMarchasCoche")) or 0
	end
)

addEventHandler("onClientVehicleExit", root,
	function(player, seat)
		if (player ~= localPlayer) or (seat ~= 0) then return end
		removeEventHandler("onClientRender", root, updateGearbox)
		gearboxViewOn = true
		setElementData(source, "ActualizarMarchasCoche", vehicleCurrentGear, true)
		vehicleCurrentGear = 0
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (vehicle) and (getVehicleController(vehicle) == localPlayer) then
			if not getElementData(vehicle, "marchas") == 1 then return end
			addEventHandler("onClientRender", root, updateGearbox)
			gearboxViewOn = true
			vehicleCurrentGear = tonumber(getElementData(vehicle, "ActualizarMarchasCoche")) or 0
		end
		bindKey("num_mul", "down", "gear_neutralize")
		bindKey("num_sub", "down", updateGear, -1)
		bindKey("num_add", "down", updateGear, 1)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if (gearboxViewOn) then
			toggleControl("accelerate", true)
			toggleControl("brake_reverse", true)
			setControlState("accelerate", false)
			setControlState("brake_reverse", false)
			setElementData(getPedOccupiedVehicle(localPlayer), "ActualizarMarchasCoche", vehicleCurrentGear, true)
		end
	end
)

-- Commands
local addCommandHandler_ = addCommandHandler
	addCommandHandler  = function(commandName, fn, restricted, caseSensitive)
	if (type(commandName) ~= "table") then
		commandName = {commandName}
	end
	for key, value in ipairs(commandName) do
		if (key == 1) then
			addCommandHandler_(value, fn, restricted, caseSensitive)
		else
			addCommandHandler_(value,
				function(player, ...)
					fn(player, ...)
				end
			)
		end
	end
end

addCommandHandler({"gear_up", "gear_down", "gear_n", "gear_neutral", "gear_neutralize"},
	function(cmd)
		if (cmd == "gear_n") or (cmd == "gear_neutral") or (cmd == "gear_neutralize") then
			updateGear(-2)
		else
			updateGear((cmd == "gear_up" and 1 or -1))
		end
	end
)
