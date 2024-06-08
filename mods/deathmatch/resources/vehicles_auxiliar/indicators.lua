function intLeft(player)
	if player and getPedOccupiedVehicle(player) and getVehicleController(getPedOccupiedVehicle(player)) == player then
		local vehicle = getPedOccupiedVehicle(player)
		local state = getElementData(vehicle, "i:left")
		if not state then 
			setElementData( vehicle, "i:left", true )
		else
			removeElementData( vehicle, "i:left" )
		end
	end
end
addCommandHandler("il", intLeft)

function intRight(player)
	if player and getPedOccupiedVehicle(player) and getVehicleController(getPedOccupiedVehicle(player)) == player then
		local vehicle = getPedOccupiedVehicle(player)
		local state = getElementData(vehicle, "i:right")
		if not state then 
			setElementData( vehicle, "i:right", true )
		else
			removeElementData( vehicle, "i:right" )
		end
	end
end
addCommandHandler("ir", intRight)

function bindInt ()
	bindKey (source, "arrow_r","down", intRight)
	bindKey (source, "arrow_l","down", intLeft)
	bindKey (source, "num_4","down", intLeft)
	bindKey (source, "num_6","down", intRight)
	bindKey (source, "mouse1", "down", intLeft)
	bindKey (source, "mouse2", "down", intRight)
end
addEventHandler ("onCharacterLogin",getRootElement(), bindInt)

function bindInt2 ()
	for k, v in ipairs (getElementsByType("player")) do
		bindKey (v, "arrow_r","down", intRight)
		bindKey (v, "arrow_l","down", intLeft)
		bindKey (v, "num_4","down", intLeft)
		bindKey (v, "num_6","down", intRight)
		bindKey (v, "mouse1", "down", intLeft)
		bindKey (v, "mouse2", "down", intRight)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), bindInt2)