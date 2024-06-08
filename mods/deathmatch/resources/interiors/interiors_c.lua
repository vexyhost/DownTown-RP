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

local localPlayer = getLocalPlayer( )
local pickups = { }
local pickupsI = { }
local ownageblip = { }

function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	actualSpeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)         
    mph = math.floor(actualSpeed * 160)
	return mph
end    

local function destroy( colshape )
	if pickups[ colshape ] then
		destroyElement( pickups[ colshape ].pickup )
		pickups[ colshape ] = nil
	end
end

function propicons()
	local dimension = getElementDimension( localPlayer )
	for key, colshape in ipairs ( getElementsByType( "colshape", resourceRoot ) ) do
		if getElementDimension( colshape ) == dimension then
			local px, py, pz = getElementPosition( colshape )
			local ownername = getElementData( colshape, "characterName" )
			local localname = getPlayerName( localPlayer ):gsub( "_", " " )
			local type = tonumber(getElementData( colshape, "inttype" ))
			local id = tonumber(getElementData( colshape, "interiorID" ))
			if(ownername == localname) and not ownageblip[ id ] and (type == 1) then
				ownageblip[ id ] = createBlip(px, py, pz, 31, 2, 255, 255, 255, 255, 0, 50)
			elseif(ownername == localname) and not ownageblip[ id ] and (type == 2) then 
				ownageblip[ id ] = createBlip(px, py, pz, 32, 2, 255, 255, 255, 255, 0, 50)
			elseif(ownername == localname) and not ownageblip[ id ] and (type == 3) then 
				ownageblip[ id ] = createBlip(px, py, pz, 31, 2, 255, 255, 255, 255, 0, 50)
			elseif not (ownername == localname) and isElement( ownageblip[ id ] ) then 
				destroyElement( ownageblip[ id ] )
			end
		end
	end
end

-- retrieves a character name from the database id
function getCharacterName( characterID )
	if type( characterID ) == "number" then
		-- check if the player is online, if so we don't need to query
		for player, data in pairs( p ) do
			if data.charID == characterID then
				local name = getPlayerName( player ):gsub( "_", " " )
				return name
			end
		end
		
		local data = exports.sql:query_assoc_single( "SELECT characterName FROM characters WHERE characterID = " .. characterID )
		if data then
			return data.characterName
		end
	end
	return false
end

addEventHandler( "onClientRender", getRootElement( ),
	function( )
		if getPedOccupiedVehicle(localPlayer) and getVehicleVelocity(getPedOccupiedVehicle(localPlayer)) >= 20 then return end
		local cx, cy, cz = getCameraMatrix( )
		local dimension = getElementDimension( localPlayer )
		for key, colshape in ipairs ( pickupsI ) do
			if not colshape then return end
			local px, py, pz = getElementPosition( colshape )
			local distance = getDistanceBetweenPoints3D( px, py, pz, cx, cy, cz )
			if distance <= 20 then
				local type = getElementData( colshape, "type" )
				if pickups[ colshape ] and pickups[ colshape ].type ~= type then
					destroy( colshape )
				end
					
				if not pickups[ colshape ] then
					pickup = createPickup( px, py, pz, 3, type == 1 and 1273 or type == 2 and 1272 or type == 3 and 1273 or 1318  )
					setElementInterior( pickup, getElementInterior( localPlayer ) )
					setElementDimension( pickup, dimension )
						
					pickups[ colshape ] = { type = type, pickup = pickup }
				end
					
				-- name
				local text = getElementData( colshape, "name" )	
				local owner = getElementData( colshape, "characterName" )
                local id = getElementData ( colshape, "interiorID" )
				local duty = getElementData(getLocalPlayer(), "account:gmduty")
				if(owner == false) and id and (type == 1 or type == 2) then
					ownertext = "Sin dueño. Está a la venta. ( ID: " .. id .. " )" 
				elseif(owner == false) and id and type == 0 then
					ownertext = "Dueño: desconocido ( ID: " .. id .. " )" 
				elseif (owner == false) and type == 3 and not id then
					ownertext = "(Alquiler) Dueño: Motel Renta."
				elseif (owner == false) and type == 3 and id then
					ownertext = "(Alquiler) Dueño: Motel Renta ( ID: " .. id .. " )"
					else
					if duty == true and owner then
						ownertext = "Dueño: " .. owner .. "( ID: " .. id .. " )" 
					else
						if id then
							ownertext = "Dueño: desconocido ( ID: " .. id .. " )"
						else
							ownertext = "Dueño: desconocido"
						end							
					end
				end
					
				if text and ( distance < 2 or isLineOfSightClear( cx, cy, cz, px, py, pz + 0.5, true, true, true, true, false, false, true, localPlayer ) ) then
					local sx, sy = getScreenFromWorldPosition( px, py, pz + 0.6 )
					if sx and sy then
						local price = getElementData( colshape, "price" )
						if price and type ~= 3 then
							text = text .. "\nPresiona 'P' para obtener más información sobre su compra."
						elseif price and type == 3 then
							text = text .. "\nPresiona 'P' para alquilar por $" .. price .. " cada payday."
						end
							
						-- background
						local ownerwidth = dxGetTextWidth( tostring( ownertext ) )
						local textwidth = dxGetTextWidth( tostring( text ) )
						local width = math.max (ownerwidth, textwidth)
						local height = ( price and 2 or 1 ) * dxGetFontHeight( )
						dxDrawRectangle( sx - width, sy - height - 4.8, width * 2, height + 20, tocolor( 0, 0, 0, 200 ) )
							
						-- text
						dxDrawText( tostring( text ), sx, sy - 27, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
						dxDrawText( tostring( ownertext ), sx, sy + 16, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
					end
				end
			else
				destroy( colshape )
			end
		end
	end
)

function sendTablePickupInts(tabl)
	pickupsI = tabl
end
addEvent("onSendTablePickupInts", true)
addEventHandler("onSendTablePickupInts", getRootElement(), sendTablePickupInts)

addEventHandler( "onClientElementDestroy", resourceRoot,
	function( )
		destroy( source ) 
	end
)

--[[addEventHandler( "onClientResourceStart", getRootElement( ),
function( )
setTimer ( propicons, 20000, 0 )
end
)]]