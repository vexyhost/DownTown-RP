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

local afkTime = 0
timer = setTimer(
	function( )
		if exports.players:isLoggedIn( ) then
			-- this runs once every 10 seconds, thus might not be completely accurate
			afkTime = afkTime + 20
			if afkTime > 300 then
				triggerServerEvent( getResourceName( resource ) .. ":afk", getLocalPlayer( ) )
			end
		else
			afkTime = 0
		end
	end,
	20000,
	0
)

local function reset( time_sec )
	if time_sec and tonumber(time_sec) then
		afkTime = time_sec
	else
		afkTime = 0
	end
end
addEvent("onResetAFKTime", true)
addEventHandler("onResetAFKTime", getRootElement(), reset)

addEventHandler( "onClientResourceStart", resourceRoot,
	function( )		
		local controls = { 'fire', 'next_weapon', 'previous_weapon', 'forwards', 'backwards', 'left', 'right', 'zoom_in', 'zoom_out', 'change_camera', 'jump', 'sprint', 'look_behind', 'crouch', 'walk', 'aim_weapon', 'enter_exit', 'vehicle_fire', 'vehicle_secondary_fire', 'vehicle_left', 'vehicle_right', 'steer_forward', 'steer_back', 'accelerate', 'brake_reverse', 'horn', 'sub_mission', 'vehicle_look_left', 'vehicle_look_right', 'vehicle_look_behind', 'vehicle_mouse_look' }
		for key, value in ipairs( controls ) do
			bindKey( value, "down", reset )
		end		
		addEventHandler( "onClientConsole", root, reset )
		addEventHandler( "onClientChatMessage", root, reset )
	end
)