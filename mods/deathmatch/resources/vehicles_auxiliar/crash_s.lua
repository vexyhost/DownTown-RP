function throwPlayerThroughWindow(x, y, z)	
	if source then
		local occupants = getVehicleOccupants ( source )
		local seats = getVehicleMaxPassengers( source )
		if occupants[0] == client then
			for seat = 0, seats do			
				local occupant = occupants[seat] -- Get the occupant
				if occupant and getElementType(occupant) == "player" and source then -- If the seat is occupied by a player...
					if getElementData(occupant, "player.cinturon") ~= true and not getElementData(occupant, "eINT") and not getElementData(occupant, "duty") == true then
					exports.chat:me(occupant, "sale disparado de su "..tostring(getVehicleNameFromModel(getElementModel(source))))
					warpPedIntoVehicle(occupant, source, getPedOccupiedVehicleSeat(occupant))
					removePedFromVehicle(occupant, source)
					setTimer(setElementPosition, 500, 1, occupant, x + math.random(1, 3), y + math.random(1, 3), z)
					setTimer(function (occupant) 
					if isPedDead(occupant) then
						local x, y, z = getElementPosition(occupant)
						spawnPlayer( occupant, x, y, z, 0, getElementModel( occupant ), 0, 0 )
						fadeCamera( occupant, true )
						setCameraTarget( occupant, occupant )
					end
					setPedAnimation(occupant, "crack", "crckidle2", -1, true, false, false)
					outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", occupant, 255, 0, 0)
					outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", occupant, 255, 0, 0)
					setElementHealth(occupant, 1)
					setElementData(occupant, "muerto", true)
					setPedAnimation(occupant, "CRACK", "crckdeth2", 10000, true, false, false)
					setElementData(occupant, "accidente", true)
					triggerEvent("onSufrirAtaque", occupant, nil, nil, 3, true)
					end, 550, 1, occupant)
					end
				end
			end
		end
	end
end
addEvent("crashThrowPlayerFromVehicle", true)
addEventHandler("crashThrowPlayerFromVehicle", getRootElement(), throwPlayerThroughWindow)