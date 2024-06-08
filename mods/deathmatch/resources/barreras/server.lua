function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

-- Barrera taller mecánico - 1 
b_mecas = createObject ( 9093, 1804.0999755859, -1766.8000488281, 14.300000190735, 0, 0, 270 )
e_mecas = 0

function f_mecanicos (player)
	if exports.factions:isPlayerInFaction( player, 3 ) then
		if not isElementInRange(player, 1804.0999755859, -1766.8000488281, 14.300000190735, 20) then outputChatBox("(( El mando no tiene tanto alcance ))", player, 255, 0, 0) return end
		if e_mecas == 0 then
			e_mecas = 2
			exports.chat:me( player, "presiona el botón y abre el portón." )
			moveObject ( b_mecas, 1500, 1804.0999755859, -1765, 16, 0, 90, 0)
			setTimer( function () 
			e_mecas = 1 end, 2500, 1, player)
		elseif e_mecas == 1 then
			moveObject ( b_mecas, 1500, 1804.0999755859, -1766.8000488281, 14.300000190735, 0, -90, 0)
			exports.chat:me( player, "presiona el botón y cierra el portón." )
			e_mecas = 2
			setTimer( function () 
			e_mecas = 0 end, 2500, 1, player)
		end
	end
end
addCommandHandler( "btaller", f_mecanicos)

b_mecas2 = createObject ( 9093, 1789.6999511719, -1766.8000488281, 14.300000190735, 0, 0, 270 )
e_mecas2 = 0

function f_mecanicos2 (player)
	if exports.factions:isPlayerInFaction( player, 3 ) then
		if not isElementInRange(player, 1789.6999511719, -1766.8000488281, 14.300000190735, 20) then outputChatBox("(( El mando no tiene tanto alcance ))", player, 255, 0, 0) return end
		if e_mecas2 == 0 then
			e_mecas2 = 2
			exports.chat:me( player, "presiona el botón y abre el portón." )
			moveObject ( b_mecas2, 1500, 1789.6999511719, -1765, 16, 0, 90, 0)
			setTimer( function () 
			e_mecas2 = 1 end, 2500, 1, player)
		elseif e_mecas2 == 1 then
			moveObject ( b_mecas2, 1500, 1789.6999511719, -1766.8000488281, 14.300000190735, 0, -90, 0)
			exports.chat:me( player, "presiona el botón y cierra el portón." )
			e_mecas2 = 2
			setTimer( function () 
			e_mecas2 = 0 end, 2500, 1, player)
		end
	end
end
addCommandHandler( "btaller2", f_mecanicos2)


-- Puertas policia
barreraPol = createObject ( 968, 2425.2, 52, 26.2, 0, 90, 0 )
markerPol = createMarker (2428.88, 52.18, 26.45, "cylinder", 6, 255, 0, 0, 0 )
esbarpol = 0

function toggleBarreraPol(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		player = element
	end
	if exports.factions:isPlayerInFaction( player, 1 ) then
		if esbarpol == 0 then
			exports.chat:me( player, "presiona el botón y sube la barrera policial." )
			moveObject ( barreraPol, 1200, 2425.2, 52, 26.2, 0, -90, 0)
			esbarpol = 1
			setTimer( function () 
			moveObject ( barreraPol, 1200, 2425.2, 52, 26.2, 0, 90, 0)
			end, 5000, 1, player)
			setTimer( function () 
			esbarpol = 0 end, 6300, 1, player)
		end
	end
end
addEventHandler("onMarkerHit", markerPol, toggleBarreraPol)


-- barreraMD = createObject ( 968, 2293.1, -108.3, 26.2, 0, 270, 0 )
-- markerMD = createMarker ( 2289.9, -108.52, 26.45, "cylinder", 7, 255, 0, 0, 0 )
-- esbarmd = 0

-- function toggleBarreraMD(element)
	-- if getElementType(element) == "vehicle" then
		-- player = getVehicleController(element)
	-- else
		-- player = element
	-- end
	-- if exports.factions:isPlayerInFaction( player, 2 ) then
		-- if esbarmd == 0 then
			-- exports.chat:me( player, "presiona el botón y sube la barrera." )
			-- moveObject ( barreraMD, 1200, 2293.1, -108.3, 26.2, 0, 90, 0)
			-- esbarmd = 1
			-- setTimer( function () 
			-- moveObject ( barreraMD, 1200, 2293.1, -108.3, 26.2, 0, -90, 0)
			-- end, 5000, 1, player)
			-- setTimer( function () 
			-- esbarmd = 0 end, 6300, 1, player)
		-- end
	-- end
-- end
-- addEventHandler("onMarkerHit", markerMD, toggleBarreraMD)

barreraGOB = createObject ( 968, 2248.5, -87.6, 26.2, 0, 90, 0 )
markerGOB = createMarker ( 2251.57, -88.29, 26.45, "cylinder", 7, 255, 0, 0, 0 )
esbargob = 0

function toggleBarreraGOB(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		player = element
	end
	if exports.factions:isPlayerInFaction( player, 5 ) then
		if esbargob == 0 then
			exports.chat:me( player, "presiona el botón y sube la barrera." )
			moveObject ( barreraGOB, 1200, 2248.5, -87.6, 26.2, 0, -90, 0)
			esbargob = 1
			setTimer( function () 
			moveObject ( barreraGOB, 1200, 2248.5, -87.6, 26.2, 0, 90, 0)
			end, 5000, 1, player)
			setTimer( function () 
			esbargob = 0 end, 6300, 1, player)
		end
	end
end
addEventHandler("onMarkerHit", markerGOB, toggleBarreraGOB)

barreraJUS = createObject ( 968, 1207.6, 223.4, 19.2, 0, 90, 64.5 )
markerJUS = createMarker ( 1209.13, 226.58, 19.55, "cylinder", 7, 255, 0, 0, 0 )
esbarjus = 0

function toggleBarreraJUS(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		player = element
	end
	if exports.factions:isPlayerInFaction( player, 6 ) then
		if esbarjus == 0 then
			exports.chat:me( player, "presiona el botón y sube la barrera." )
			moveObject ( barreraJUS, 1200, 1207.6, 223.4, 19.2, 0, -90, 0)
			esbarjus = 1
			setTimer( function () 
			moveObject ( barreraJUS, 1200, 1207.6, 223.4, 19.2, 0, 90, 0)
			end, 5000, 1, player)
			setTimer( function () 
			esbarjus = 0 end, 6300, 1, player)
		end
	end
end
addEventHandler("onMarkerHit", markerJUS, toggleBarreraJUS)

barreraPT = createObject ( 968, 1415.7, 420.1, 19.6, 0, 270, 334.5 )
markerPT = createMarker ( 1412.66, 421.68, 19.85, "cylinder", 7, 255, 0, 0, 0 )
esbarpt = 0

function toggleBarreraPT(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		player = element
	end
	if exports.factions:isPlayerInFaction( player, 8 ) then
		if esbarpt == 0 then
			exports.chat:me( player, "presiona el botón y sube la barrera." )
			moveObject ( barreraPT, 1200, 1415.7, 420.1, 19.6, 0, 90, 0)
			esbarpt = 1
			setTimer( function () 
			moveObject ( barreraPT, 1200, 1415.7, 420.1, 19.6, 0, -90, 0)
			end, 5000, 1, player)
			setTimer( function () 
			esbarpt = 0 end, 6300, 1, player)
		end
	end
end
addEventHandler("onMarkerHit", markerPT, toggleBarreraPT)
 
barreraTTL = createObject ( 968, 1346.9, 280.9, 19.4, 0, 270, 246.47 )
markerTTL = createMarker ( 1348.32, 283.76, 19.56, "cylinder", 7.5, 255, 0, 0, 0 )
esbarttl = 0

function openBarreraTTL(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		player = element
	end
	if exports.factions:isPlayerInFaction( player, 7 ) then
		if esbarttl == 0 then
			local rx, ry, rz = getElementRotation(barreraTTL)
			setElementRotation(barreraTTL, rx, 270, rz)
			exports.chat:me( player, "presiona el botón y sube la barrera." )
			moveObject ( barreraTTL, 1200, 1346.9, 280.9, 19.4, 0, 90, 0)
			--moveObject ( barreraTTL, 1200, 1913, 363.8, 20.8, 0, 90, 0)
			esbarttl = 4
			setTimer( function ()
			esbarttl = 1 end, 1200, 1 )
		elseif esbarttl == 2 then
			-- Estará cerrando, por lo que la rotación estará yendo a 270.
			local rx, ry, rz = getElementRotation(barreraTTL)
			local diff = 360-ry
			exports.chat:me( player, "presiona el botón y sube la barrera." )
			moveObject ( barreraTTL, 1200, 1346.9, 280.9, 19.4, 0, diff, 0)
			esbarttl = 3
			setTimer( function ()
			esbarttl = 1 end, 1200, 1 )
		end
	end
end
addEventHandler("onMarkerHit", markerTTL, openBarreraTTL)

function closeBarreraTTL(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		player = element
	end 
	if esbarttl == 1 or esbarttl == 4 then
		local hayAlguien = false
		for k, v in ipairs(getElementsByType("player")) do
			if isElementWithinMarker(v, source) and v ~= player then
				hayAlguien = true
			end
		end
		if hayAlguien == false then
			if esbarttl == 1 then
				moveObject ( barreraTTL, 1200, 1346.9, 280.9, 19.4, 0, -90, 0)
				esbarttl = 2
				setTimer( function ()
				esbarttl = 0 end, 1200, 1, player )
			elseif esbarttl == 4 then
				-- Está abriendo y solicitamos cierre antes de que llegue arriba.
				local rx, ry, rz = getElementRotation(barreraTTL)
				local diff = -(ry-270)
				moveObject ( barreraTTL, 1200, 1346.9, 280.9, 19.4, 0, diff, 0)
				esbarttl = 2
				setTimer( function ()
				esbarttl = 0 end, 1200, 1, player )
			end
		end
	end
end
addEventHandler("onMarkerLeave", markerTTL, closeBarreraTTL)

-- Barrera depósito 1

barreraDepo1 = createObject ( 968, 1400, 443.8, 20, 0, 270, 146.47 )
markerDepo1 = createMarker ( 1402.15, 441.77, 20.13, "cylinder", 7.5, 255, 0, 0, 0 )
esBarDepo1 = 0

function openBarreraDepo1(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		player = element
	end
	if exports.factions:isPlayerInFaction( player, 1 ) then
		if esBarDepo1 == 0 then
			local rx, ry, rz = getElementRotation(barreraDepo1)
			setElementRotation(barreraDepo1, rx, 270, rz)
			exports.chat:me( player, "presiona el botón y sube la barrera." )
			moveObject ( barreraDepo1, 1200, 1400, 443.8, 20, 0, 90, 0)
			esBarDepo1 = 4
			setTimer( function ()
			esBarDepo1 = 1 end, 1200, 1 )
		elseif esBarDepo1 == 2 then
			-- Estará cerrando, por lo que la rotación estará yendo a 270.
			local rx, ry, rz = getElementRotation(barreraDepo1)
			local diff = 360-ry
			exports.chat:me( player, "presiona el botón y sube la barrera." )
			moveObject ( barreraDepo1, 1200, 1400, 443.8, 20, 0, diff, 0)
			esBarDepo1 = 3
			setTimer( function ()
			esBarDepo1 = 1 end, 1200, 1 )
		end
	end
end
addEventHandler("onMarkerHit", markerDepo1, openBarreraDepo1)

function closeBarreraDepo1(element)
	if getElementType(element) == "vehicle" then
		player = getVehicleController(element)
	else
		player = element
	end 
	if esBarDepo1 == 1 or esBarDepo1 == 4 then
		local hayAlguien = false
		for k, v in ipairs(getElementsByType("player")) do
			if isElementWithinMarker(v, source) and v ~= player then
				hayAlguien = true
			end
		end
		if hayAlguien == false then
			if esBarDepo1 == 1 then
				moveObject ( barreraDepo1, 1200, 1400, 443.8, 20, 0, -90, 0)
				esBarDepo1 = 2
				setTimer( function ()
				esBarDepo1 = 0 end, 1200, 1, player )
			elseif esBarDepo1 == 4 then
				-- Está abriendo y solicitamos cierre antes de que llegue arriba.
				local rx, ry, rz = getElementRotation(barreraDepo1)
				local diff = -(ry-270)
				moveObject ( barreraDepo1, 1200, 1400, 443.8, 20, 0, diff, 0)
				esBarDepo1 = 2
				setTimer( function ()
				esBarDepo1 = 0 end, 1200, 1, player )
			end
		end
	end
end
addEventHandler("onMarkerLeave", markerDepo1, closeBarreraDepo1)

barreraRadio = createObject ( 968, 2413, -38.8, 26.2, 0, 270, 0)
markerRadio = createMarker ( 2409.42, -38.55, 26.45, "cylinder", 5.5, 255, 0, 0, 0 )
esbarrad = 0

function toggleBarreraRad(player)
	if exports.factions:isPlayerInFaction( player, 4 ) then
		if esbarrad == 0 then
			exports.chat:me( player, "presiona el botón y abre la barrera del parking." )
			moveObject ( barreraRadio, 1500, 2413, -38.8, 26.2, 0, 90, 0)
			esbarrad = 1
			setTimer( function () 
			moveObject ( barreraRadio, 1500, 2413, -38.8, 26.2, 0, -90, 0)
			end, 5000, 1, player)
			setTimer( function () 
			esbarrad = 0 end, 67000, 1, player)
		end
	end
end
addEventHandler("onMarkerHit", markerRadio, toggleBarreraRad)