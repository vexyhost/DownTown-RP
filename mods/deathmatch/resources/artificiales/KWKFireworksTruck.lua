---------------------
-- Fireworks Truck -- -- Makes a truck that launches Fireworks :D
--------- by --------
------- KWKSND ------ -- Makes Multi Theft Auto more fun :D
---------------------

FwTruck = createVehicle(515, -1927.447265625, 581.427734375, 35.171875,0,0,0)

function fireFwork(player)
	triggerClientEvent("ClientCreateFireworks",getRootElement(),FwTruck)
end

function bindTheKey(player)
	outputChatBox("Press vehicle_fire to launch Fireworks!",player,255,255,0)
	bindKey ( player, "vehicle_fire", "down", fireFwork )
end
addEventHandler ( "onVehicleEnter", FwTruck, bindTheKey )

function unbindTheKey(player)
	unbindKey ( player, "vehicle_fire", "down", fireFwork )
end
addEventHandler ( "onVehicleExit", FwTruck, unbindTheKey )

setTimer (function()
	if isVehicleBlown (FwTruck) then
		respawnVehicle (FwTruck)
	end
end,20000,0)