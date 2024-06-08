--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

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

local engineState = nil
local localPlayer = getLocalPlayer( )
maleterosC = {}

addEventHandler( "onClientVehicleStartEnter", resourceRoot,
	function( player, seat )
		setRadioChannel(0)
		if seat == 0 and player == localPlayer then
			if getElementData(source, "sinGasolina") then
				setVehicleEngineState(source, false)
				outputChatBox("Este vehículo está sin gasolina.", 255, 0, 0)
				engineState = { vehicle = source, state = false }
				setTimer(setVehicleEngineState, 50, 10, source, false)
			else
				setVehicleEngineState(source, false)
				engineState = { vehicle = source, state = getVehicleEngineState( source ) }
			end
		else
			engineState = nil
		end
	end
)
--[[
addEventHandler( "onClientVehicleEnter", resourceRoot,
	function( player, seat )
		-- restore the engine state
		if engineState then
			if seat == 0 and player == localPlayer and engineState.vehicle == source then
				setVehicleEngineState( source, engineState.state )
			end
			engineState = nil
		end
	end
)
]]
function abrirMaletero(player, vehicleID, tipo, sql)
	for k in pairs (maleterosC) do
		maleterosC [k] = nil
	end
	if vehicleID and sql then
		for k, v in ipairs(sql) do
			table.insert(maleterosC, v)
		end
		if tipo == 1 then
			exports.gui:show("maletero")
			triggerEvent("onCursor", getLocalPlayer())
		elseif tipo == 2 then
			exports.gui:updateMaletero()
		elseif tipo == 3 then
			exports.gui:updateInventarioMaletero()
		end  
	end
end
addEvent("onAbrirMaletero", true)
addEventHandler("onAbrirMaletero", getRootElement(), abrirMaletero)

function getMaletero()
	return maleterosC
end

function sonidoMando(x, y, z)
	local sound = playSound3D( "mando.mp3", x, y, z, false )
	setSoundMaxDistance( sound, 16 )
	setSoundVolume( sound, 4 )
end
addEvent("onSonidoMando", true)
addEventHandler("onSonidoMando", getRootElement(), sonidoMando)

function offRadio()
	cancelEvent()
end
addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), offRadio)

function actualizarDanoVehiculo(attacker, weapon, loss, x, y, z, tyre)
	if attacker and isElement(attacker) then
        setElementData(source, "aGolpeador", getPlayerName(localPlayer))
    end
end
addEventHandler("onClientVehicleDamage", root, actualizarDanoVehiculo)