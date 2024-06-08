local c_root = getRootElement()
local c_player = localPlayer
local c_lastspeed = 0
local c_speed = 0
local isplayernotjumpaway = true

-----------------------------
function getActualVelocity( element, x, y, z )
	return (x^2 + y^2 + z^2) ^ 0.5
end

-----------------------------
function updateDamage()
	c_speed = getActualVelocity( c_veh, getElementVelocity( c_veh ) )	
	--if c_lastspeed - c_speed >= 0.05 and not isElementFrozen( c_veh ) and getElementModel(vehicle) == 420 then
	local lim1, lim2, lim3
	if getVehicleType(c_veh) == "Bike" or getVehicleType(c_veh) == "BMX" then
		lim1 = 0.1
		lim2 = 0.25
		lim3 = 240
		
	else
		lim1 = 0.3
		lim2 = 0.4
		lim3 = 160
	end
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	local x, y, z = getElementPosition(getLocalPlayer())
	local nx, ny, nz
	local rz = getPedRotation(getLocalPlayer())

	nx = x + math.sin( math.rad( rz )) * 2
	ny = y + math.cos( math.rad( rz )) * 2
	nz = getGroundPosition(nx, ny, z)
	if c_lastspeed - c_speed >= lim1 and not isElementFrozen( c_veh ) then
		--outputChatBox(tostring(c_lastspeed - c_speed))
		if (c_lastspeed - c_speed >= lim2) and math.floor(c_lastspeed*lim3) >= 50 then -- trigger throwing out of the vehicle

			nx = x + math.sin( math.rad( rz )) * 2
			ny = y + math.cos( math.rad( rz )) * 2
			nz = getGroundPosition(nx, ny, z)
			if getVehicleType(vehicle) == "Boat" then return end
			local bcollision, ex, ey, ez, element = processLineOfSight(x, y, z+1, nx, ny, nz+1, true, true, true, true, true, false, false, false, vehicle)
			if (bcollision) then
				ez = getGroundPosition(ex, ey, ez)
				triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, ex, ey, ez+1, vehicle)
			else
				triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, nx, ny, nz+1, vehicle)
			end
		end    
	
		c_lasthealth = getElementHealth(c_player) - 15*(c_lastspeed)
		if 20*(c_lastspeed) > 5 and (getVehicleType(c_veh) == "Bike" or getVehicleType(c_veh) == "BMX") then
			if getElementData(getLocalPlayer(), "antiSPAMCaida") == true then return end
			outputChatBox("Has sufrido daños por la colisión. ¡Ten cuidado!", 255, 0, 0)
			setElementData(getLocalPlayer(), "antiSPAMCaida", true)
			setTimer(setElementData, 750, 1, getLocalPlayer(), "antiSPAMCaida", false)
			local hp = getElementHealth(c_player)
			if (hp-30) > 1 then
				setElementHealth(c_player , getElementHealth(c_player)-30)
			else
				local bcollision, ex, ey, ez, element = processLineOfSight(x, y, z+1, nx, ny, nz+1, true, true, true, true, true, false, false, false, vehicle)
				if (bcollision) then
					ez = getGroundPosition(ex, ey, ez)
					triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, ex, ey, ez+1, vehicle)
				else
					triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, nx, ny, nz+1, vehicle)
				end
			end
		else
			if 10*(c_lastspeed) > 5 and not getElementData(c_player, "player.cinturon") == true then 
				outputChatBox("Has sufrido daños por la colisión. ¡Abróchate el cinturón!", 255, 0, 0)
				local hp = getElementHealth(c_player)
				if (hp-30) > 1 then
					setElementHealth(c_player , getElementHealth(c_player)-30)
				else
					local bcollision, ex, ey, ez, element = processLineOfSight(x, y, z+1, nx, ny, nz+1, true, true, true, true, true, false, false, false, vehicle)
					if (bcollision) then
						ez = getGroundPosition(ex, ey, ez)
						triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, ex, ey, ez+1, vehicle)
					else
						triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, nx, ny, nz+1, vehicle)
					end
				end
			end
			if c_lasthealth <= 0 then
				c_lasthealth = 0
			end
		end
	end
	c_lastspeed = c_speed

end

function onJumpOut()
	isplayernotjumpaway = false
end

function onJumpFinished()
	isplayernotjumpaway = true   
end
   
-----------------------------
addEventHandler( "onClientVehicleStartExit", c_root,onJumpOut)
addEventHandler( "onClientVehicleExit", c_root,onJumpFinished)
addEventHandler( "onClientRender", c_root,function  ( )
	if isplayernotjumpaway and isPedInVehicle(c_player) then
		c_veh = getPedOccupiedVehicle(c_player)
		if c_veh then
			local c_veh_driver = getVehicleOccupant ( c_veh, 0 )
			if c_veh_driver == c_player then
				updateDamage()
			end
		end
	else
		c_speed = 0
		c_lastspeed = 0
	end
end
)