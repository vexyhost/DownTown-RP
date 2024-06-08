--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown Roleplay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

-- addEventHandler( "onClientPlayerWasted", localPlayer,
	-- function(atacante, weapon, parte)
		-- cancelEvent()
		-- if getPedOccupiedVehicle(source) and getElementHealth(getPedOccupiedVehicle(source)) == 0 then
			-- return
		-- else
			-- triggerServerEvent("onSufrirAtaque", source, atacante, weapon, parte, true)
		-- end
	-- end
-- )
                                           
addEventHandler( "onClientPlayerDamage", localPlayer,
	function(atacante, weapon, parte, loss)
		if weapon and tonumber(weapon) == 37 then 
			if tonumber(getElementHealth(source)) > 3 then
				return
			else
				cancelEvent()
				if not getElementData(getLocalPlayer(), "muertoQuemado") == true then
					setElementData(getLocalPlayer(), "muertoQuemado", true)
					triggerServerEvent("onSufrirAtaque", source, atacante, weapon, parte, true)
					setTimer(setElementData, 5000, 1, getLocalPlayer(), "muertoQuemado", false)
				end
			end                             
		else
			if weapon and tonumber(weapon) == 54 then
				if tostring(loss) == "100" and getElementDimension(getLocalPlayer()) > 0 then
					cancelEvent()
					triggerServerEvent("onDesbugAlCaerINT", source)
					return
				elseif tonumber(loss) > tonumber(getElementHealth(getLocalPlayer())) then
					cancelEvent()
					triggerServerEvent("onSufrirAtaque", source, atacante, weapon, parte, true)
				else
					triggerServerEvent("onSufrirAtaque", source, atacante, weapon, parte, false)
				end
			else
				cancelEvent()
				if weapon and tonumber(weapon) == 53 then 
					-- Muerto por agua.
					if getElementModel(source) ~= 279 and not getElementData(source, "muertoPorAhogamiento") == true then
						setElementData(source, "muertoPorAhogamiento", true)
						triggerServerEvent("onSufrirAtaque", source, atacante, weapon, parte, true)
						setTimer(setElementData, 3000, 1, source, "muertoPorAhogamiento", false)
					end
					return
				end
				triggerServerEvent("onSufrirAtaque", source, atacante, weapon, parte, false)
			end
		end
	end
)
 
addEventHandler("onClientVehicleExplode", getRootElement(), function()
	cancelEvent()
	for seat, player in pairs(getVehicleOccupants(source)) do
		triggerServerEvent("onSolicitarGuardarArmas", player, player)
		removePedFromVehicle(player)
		setTimer(triggerServerEvent, 1500, 1, "onSufrirAtaque", player, player, 51, 3, true)
	end
	triggerServerEvent("onDesvolcarVehiculo", source, getLocalPlayer())
end)

function abortAllStealthKills()
    cancelEvent()
end
addEventHandler("onClientPlayerStealthKill", getLocalPlayer(), abortAllStealthKills)

local respawnKeys = { 'F6' }
local respawnWait = false
local localPlayer = getLocalPlayer( )
local screenX, screenY = guiGetScreenSize( )

function drawRespawnText( )
	local text = "Pulsa '" .. respawnKeys[1] .. "' para reaparecer"
	if respawnWait then
		local diff = respawnWait - getTickCount( )
		if getElementData(getLocalPlayer(), "reduccNOMD") == 1 then
			setElementData(getLocalPlayer(), "reduccNOMD", 2)
			respawnWait = respawnWait - 720000
		end
		if diff >= 0 then
			text = ( "Espera %.1f segundos para reaparecer o avisa y espera a los médicos (/avisarmd)" ):format( diff / 1000 )
		else
			-- check if the player presses a control, wouldn't be caught by SA as the key is down
			for key, value in ipairs( respawnKeys ) do
				if getKeyState( value ) then
					requestRespawn( )
					break
				end
			end
		end
	
		-- draw the text
		dxDrawText( text, 4, 4, screenX, screenY, tocolor( 0, 0, 0, 255 ), 1, "pricedown", "center", "center" )
		dxDrawText( text, 0, 0, screenX, screenY, tocolor( 255, 255, 255, 255 ), 1, "pricedown", "center", "center" )
	end
end
        
addEvent("onClientMuerto", true)
addEventHandler( "onClientMuerto", localPlayer,
	function( )
		-- keep the camera (reset when the player respawns)
		local a, b, c = getCameraMatrix( )
		local d, e, f = getElementPosition( localPlayer )
		setCameraMatrix( a, b, c, d, e, f )
		-- 900000
		respawnWait = getTickCount( ) + 900000
		triggerEvent("onResetAFKTime", getLocalPlayer(), -900)
		addEventHandler( "onClientRender", root, drawRespawnText )
	end
)

addEvent("onClientNoMuerto", true)
addEventHandler( "onClientNoMuerto", localPlayer,
	function( )
		removeEventHandler( "onClientRender", root, drawRespawnText )
	end
)

function requestRespawn( )
	removeEventHandler( "onClientRender", root, drawRespawnText )
	triggerServerEvent( "onPlayerRespawn", localPlayer )
end

function handleVehicleDamage(attacker, weapon, loss, x, y, z, tire)
    if attacker and not tire and source and getElementModel(source) ~= 471 then
        cancelEvent()
		local actualHP = getElementHealth(source)
		setElementHealth(source, actualHP-20)
    end
end
addEventHandler("onClientVehicleDamage", root, handleVehicleDamage)