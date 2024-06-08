--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown RolePlay

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




local localPlayer = getLocalPlayer( )
local pickups = { }
local pickupsT = { }

function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	actualSpeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)         
    mph = math.floor(actualSpeed * 160)
	return mph
end    

local function destroy( element )
	if pickups[ element ] then
		destroyElement( pickups[ element ].pickup )
		pickups[ element ] = nil
	end
end
 
addEventHandler( "onClientRender", getRootElement( ),
	function( )
		if getElementData(localPlayer, "nohud") then return end
		if getPedOccupiedVehicle(localPlayer) and getVehicleVelocity(getPedOccupiedVehicle(localPlayer)) >= 20 then return end
		local cx, cy, cz = getCameraMatrix( )
		local interior = getElementInterior( localPlayer )
		local dimension = getElementDimension( localPlayer )
		for key, element in ipairs ( pickupsT ) do
			local px, py, pz = getElementPosition( element )
			local distance = getDistanceBetweenPoints3D( px, py, pz, cx, cy, cz )
			if distance <= 15 then   
				local text = getElementData( element, "text" )
				if not pickups[ element ] then
					pickup = createPickup( px, py, pz, 3, 1239 )
					setElementInterior( pickup, interior )
					setElementDimension( pickup, dimension )
						
					pickups[ element ] = { pickup = pickup }
				end
				if isLineOfSightClear( cx, cy, cz, px, py, pz + 0.5, true, true, true, true, false, false, true, localPlayer ) then
					local sx, sy = getScreenFromWorldPosition( px, py, pz + 0.5 )
					if sx and sy then
						dxDrawText( tostring( text ), sx + 2, sy + 2, sx, sy, tocolor( 0, 0, 0, 255 ), 1, "default", "center", "center" )
						dxDrawText( tostring( text ), sx, sy, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
					end
				end
			else
				destroy( element )
			end
		end
	end
)

function sendTablePickup3DText(tabl)
	pickupsT = tabl
end                                              
addEvent("onSendTablePickup3DText", true)
addEventHandler("onSendTablePickup3DText", getRootElement(), sendTablePickup3DText)

addEventHandler( "onClientElementDestroy", resourceRoot,
	function( )
		destroy( source )
	end
)