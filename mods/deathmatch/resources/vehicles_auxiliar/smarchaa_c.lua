-- sistema de realismo sonido hacia atras de los coches.

local beepTimer = {}

-- Vehículos definidos para el sonido.

local vehiclesBeep = {
    [485] = true,[431] = true,[437] = true,[574] = true,[525] = true,[408] = true,[552] = true,[416] = true,[433] = true,[427] = true,[407] = true,[544] = true,[428] = true,[499] = true,[609] = true,
    [498] = true,[524] = true,[532] = true,[578] = true,[486] = true,[406] = true,[573] = true,[455] = true,[588] = true,[403] = true,[423] = true,[414] = true,[443] = true,[515] = true,[514] = true,
    [456] = true
}





function TruckReverseSound(position)
    local x,y,z = unpack(fromJSON(position))
    local sfx = playSound3D("SFX_REVERSE_BEEP_2.mp3", x, y, z, false) 
    setSoundMaxDistance( sfx, 30 )
end
addEvent ( "doReverseBeep", true )
addEventHandler ( "doReverseBeep", root, TruckReverseSound )

function detectDirection ()
    local theVehicle = getPedOccupiedVehicle (localPlayer)
    if theVehicle then
        local matrix = getElementMatrix ( theVehicle )
        local velocity = Vector3(getElementVelocity(theVehicle))
        local DirectionVector = (velocity.x * matrix[2][1]) + (velocity.y * matrix[2][2]) + (velocity.z * matrix[2][3]) 
        if (DirectionVector < 0) and getVehicleSpeed(getElementVelocity( theVehicle )) > 6 then
            triggerServerEvent ( "onReverseBeep", resourceRoot,theVehicle)
        end
    end 
end

function getVehicleSpeed(x, y, z)
	if x and y and z  then
		return math.floor( math.sqrt( x*x + y*y + z*z ) * 155 )
	else
		return 0
	end
end

function truckSound(thePlayer, seat)
    if thePlayer == localPlayer then
        if(seat == 0) then
            if eventName =="onClientVehicleEnter" then 
                local model = getElementModel(source)
                if vehiclesBeep[model] then
                    beepTimer[source] = setTimer ( detectDirection, 1000, 0 )
                end
            elseif eventName =="onClientVehicleExit" then 
                if isTimer(beepTimer[source]) then 
                    killTimer (beepTimer[source])
                    beepTimer[source] = nil
                end
            end 
        end
    end
end
addEventHandler("onClientVehicleEnter", root,truckSound)
addEventHandler("onClientVehicleExit",root,truckSound)