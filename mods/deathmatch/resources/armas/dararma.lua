addCommandHandler ( "dararma",
    function ( player, commandName, otherPlayer )
        local weapon = getPedWeapon ( player )
        local ammo = getPedTotalAmmo ( player )
        if ( otherPlayer and weapon and weapon > 1 ) then
            local other, name = exports.players:getFromName ( player, otherPlayer )
            if ( other ) then
                if ( player ~= other ) then
                    local x, y, z = getElementPosition ( player )
                    if ( getDistanceBetweenPoints3D ( x, y, z, getElementPosition ( other ) ) < 5 ) then
						if getElementData(player, "dararma") == true then outputChatBox("Inténtalo de nuevo más tarde.",player, 255, 0, 0)
						exports.logs:addLogMessage("armabug", getPlayerName(player):gsub("_", " ").." ha intentado duplicar balas dandoselas a "..tostring(name)..".")
						return end
						if takeWeapon ( player, weapon ) then
						exports.items:give( other , 29, tostring(weapon), "Arma " .. tostring(weapon), ammo)
						exports.logs:addLogMessage("dararma", getPlayerName(player):gsub("_", " ") .. " ha dado un arma " .. tostring(weapon) .. " con "..tostring(ammo).." a " .. getPlayerName(other):gsub("_", " "))
						exports.chat:me (player, "entrega un arma disimuladamente", "(/dararma)" )
						setElementData(player, "dararma", true)
						setTimer(function() removeElementData(player, "dararma") end, 5000, 1)
						end
                    else
                        outputChatBox ( "Estas lejos de  " .. name .. ".", player, 255, 0, 0 )
                    end
                else
                    outputChatBox ( "No puedes darte arma a ti mismo.", player, 255, 0, 0 )
                end
            end
        else
            outputChatBox ( "Syntax: /" ..commandName.. " [jugador] [arma]", player, 255, 255, 255 )
        end
    end
)