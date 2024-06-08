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

local fuelRoot = createElement( "fuelpoint" )

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM fuelpoints ORDER BY fuelpointID ASC" )
		if result then
			for key, data in ipairs( result ) do
				local colshape = createColSphere( data.posX, data.posY, data.posZ, 3.5 )
				setElementParent( colshape, fuelRoot )
				setElementData( colshape, "name", tonumber( data.name ) or data.name )
			end
		end
	end
)

addCommandHandler( "createfuelpoint",
	function( player, commandName, ... )
		if ( ... ) then
			local name = table.concat( { ... }, " " )
			local x, y, z = getElementPosition( player )
			if exports.sql:query_free( "INSERT INTO fuelpoints (posX, posY, posZ, name) VALUES(" .. table.concat( { x, y, z, '"%s"' }, ", " ) .. ")", name ) then
				local colshape = createColSphere( x, y, z+1, 3.5 )
				setElementParent( colshape, fuelRoot )
				setElementData( colshape, "name", tonumber( name ) or name )
				outputChatBox( "Created fuelpoint '" .. name .. "'.", player, 0, 255, 0 )
			else
				outputChatBox( "Fuelpoint creation failed.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [name]", player, 255, 255, 255 )
		end
	end,
	true
)

addEvent( "vehicles:fill", true )
addEventHandler( "vehicles:fill", fuelRoot,
	function( amount )
		if client and isElementWithinColShape( client, source ) and type( amount ) == 'number' and amount == math.ceil( amount ) and amount > 0 then
			local vehicle = getPedOccupiedVehicle( client )
			if vehicle and getVehicleOccupant( vehicle ) == client and doesVehicleHaveFuel( vehicle ) and not getVehicleEngineState( vehicle ) then
				local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(client))
				if nivel < 2 then outputChatBox("No puedes repostar porque necesitas nivel 2. Usa /objetivos.", client, 255, 0, 0) return end
				if exports.players:takeMoney( client, math.ceil( amount * 1.2 ) ) then
					increaseFuel( vehicle, amount )
					removeElementData(vehicle, "sinGasolina")
					if nivel == 2 and not exports.objetivos:isObjetivoCompletado(16, exports.players:getCharacterID(client)) then
						exports.objetivos:addObjetivo(16, exports.players:getCharacterID(client), client)
					end 
				end
			end
		end
	end
)
