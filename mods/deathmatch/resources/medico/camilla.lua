camilla = {}
camillaobjeto = {}
tm1 = {}
tm2 = {}
addCommandHandler ( "camilla",
function ( player, commandName, otherPlayer )
	if exports.factions:isPlayerInFaction ( player, 2) then
		if not camillaobjeto [player] then outputChatBox("Usa primero /sacarcamilla.", player, 255, 0, 0) return end
        if ( otherPlayer ) then
            local other, name = exports.players:getFromName ( player, otherPlayer )
            if ( other ) then
                if ( player ~= other ) then
                    local x, y, z = getElementPosition ( player )
					local xr, xy, xz = getElementRotation ( player )
                    if ( getDistanceBetweenPoints3D ( x, y, z, getElementPosition ( other ) ) < 5 ) then
						if not camilla [player] then
							camilla [player] = other
							attachElements(other, camillaobjeto [player], 0, 0, 1.5)
							setPedAnimation( other, "crack", "crckidle2")
							setElementCollisionsEnabled(other, false)
							setElementRotation(other, xr, xy, xz+90)
							exports.chat:me( player, "pone a " .. name .. " en la camilla." )
							tm1[player] = setTimer(
							function()
								local xr, xy, xz = getElementRotation ( player )
								setElementRotation(other, xr, xy, xz+90)
								if other and getElementDimension(player) ~= getElementDimension(other) then
									if other then
										detachElements(other)
										setPedAnimation(other,false)
										local x, y, z = getElementPosition(player)
										setElementPosition(other, x, y, z)
										setElementDimension(other, getElementDimension(player))
										setElementInterior(other, getElementInterior(player))
										setCameraInterior(other, getElementInterior(player))
										setTimer(
										function ()
											attachElements(other, camillaobjeto [player], 0, 0, 1.5)
											setPedAnimation( other, "crack", "crckidle2")	
										end, 1000, 2)	 						
									end
								end
							end, 500, 0)
						else
							detachElements ( camilla [player] )
							setElementCollisionsEnabled(camilla [player], true)
							if isTimer(tm1[player]) then killTimer(tm1[player]) end
							exports.chat:me( player, "quita a " ..name.. " de la camilla." )
							if getElementDimension(player) == 10 then -- Están en el hospital. Quitar camilla AUTO.
								setPedAnimation(camilla [player],false)
								destroyElement ( camillaobjeto [player] )
								camillaobjeto [player] = nil
								if isTimer(tm2[player]) then killTimer(tm2[player]) end
							end
							camilla [player] = nil
						end
                    else
                        outputChatBox ( "Estas demasiado lejos de "..name..".", player, 255, 0, 0 )
                    end
                else
                    outputChatBox ( "No puedes subirte a la camilla tú mismo.", player, 255, 0, 0 )
                end
            end
        else
            outputChatBox ( "Syntax: /" .. commandName .. " [jugador/ID]", player, 255, 255, 255 )
        end
	end
end
)

addCommandHandler("sacarcamilla",
function (player, commandName)
	if exports.factions:isPlayerInFaction ( player, 2) then  
		local x, y, z = getElementPosition(player)
		for index,veh in ipairs(getElementsByType("vehicle")) do
			if getElementModel(veh) == 416 and not camillaobjeto [player] then
				if ( getDistanceBetweenPoints3D ( x, y, z, getElementPosition ( veh ) ) < 10 ) then
					camillaobjeto [player] = createObject (2146, x, y, z, 0, 0, 0)
                    if ( camillaobjeto [player] ) then
						attachElements (camillaobjeto [player], player, 0, 1.4, -0.5)
						setElementCollisionsEnabled ( camillaobjeto [player], false )
						exports.chat:me (player, "saca una camilla de la ambulancia." )
						tm2[player] = setTimer(
						function()
							if not player or not isElement(player) or not camillaobjeto[player] or not isElement(camillaobjeto[player]) then killTimer(tm2[player]) return end
							if getElementDimension(player) ~= getElementDimension(camillaobjeto [player]) then
								setElementDimension(camillaobjeto [player], getElementDimension(player))
								setElementInterior(camillaobjeto [player], getElementInterior(player))
							end
						end, 1000, 0)
					end
				end
			end
		end
	end
end	
)

function quitarCamillaAlSubir ( thePlayer, seat )
    if exports.factions:isPlayerInFaction(thePlayer, 2) and getElementModel(source) == 416 and camillaobjeto[thePlayer] then -- Camilla sacada
		nombre = nil
		if camilla [thePlayer] then
			detachElements(camilla[thePlayer])
			setElementCollisionsEnabled(camilla[thePlayer], true)
			if getVehicleOccupant(source, 3) then
				warpPedIntoVehicle(camilla[thePlayer], source, 2)
			else
				warpPedIntoVehicle(camilla[thePlayer], source, 3)
			end
			if isTimer(tm1[thePlayer]) then killTimer(tm1[thePlayer]) end
			nombre = getPlayerName(camilla[thePlayer]):gsub("_", " ")
			camilla [thePlayer] = nil
		end
		-- Destrucción camilla
		destroyElement ( camillaobjeto [thePlayer] )
		camillaobjeto [thePlayer] = nil
		if isTimer(tm2[thePlayer]) then killTimer(tm2[thePlayer]) end
		if nombre then
			exports.chat:me (thePlayer, "mete a "..nombre.." en la ambulancia con la camilla." )
		else
			exports.chat:me (thePlayer, "deja la camilla en la ambulancia." )
		end
    end
end
addEventHandler ( "onVehicleEnter", getRootElement(), quitarCamillaAlSubir )
