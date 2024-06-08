function doBeepNextToPlayers (theVehicle)
    if theVehicle then 
        local vehicleX, vehicleY, vehicleZ = getElementPosition (theVehicle)
        local position = toJSON({vehicleX, vehicleY, vehicleZ})
        triggerClientEvent ( root, "doReverseBeep", root, position)
    end 
end
addEvent( "onReverseBeep", true )
addEventHandler( "onReverseBeep", resourceRoot, doBeepNextToPlayers )