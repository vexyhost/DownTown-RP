--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2016 DownTown County Roleplay

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

local elements = { }

local function loadText( id, text, x, y, z, interior, dimension  )
	local element = createElement( "3dtext" )
	setElementPosition( element, x, y, z )
	setElementInterior( element, interior )
	setElementDimension( element, dimension )
	setElementData( element, "text", tostring( text ) )
	
	elements[ id ] = element
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )		
		local result = exports.sql:query_assoc( "SELECT * FROM 3dtext ORDER BY textID ASC" )
		if result then
			for key, data in ipairs( result ) do
				loadText( data.textID, data.text, data.x, data.y, data.z, data.interior, data.dimension )
			end
		end
	end
)

addCommandHandler( "createtext",
	function( player, commandName, ... )
		if ( ... ) then
			local text = table.concat( { ... }, " " )
			local x, y, z = getElementPosition( player )
			local insertid,e = exports.sql:query_insertid( "INSERT INTO 3dtext (`text`, x, y, z, interior, dimension) VALUES (" .. table.concat( { "'%s'", x, y, z, getElementInterior( player ), getElementDimension( player ) }, ", " ) .. ")", text )
			if insertid then
				loadText( insertid, text, x, y, z, getElementInterior( player ), getElementDimension( player ) )
				outputChatBox( "Texto creado. (ID " .. insertid .. ")", player, 0, 255, 0 )
			else
				outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [texto]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "deletetext",
	function( player, commandName, textID )
		textID = tonumber( textID )
		if textID then
			local element = elements[ textID ]
			if element then
				if exports.sql:query_free( "DELETE FROM 3dtext WHERE textID = " .. textID ) then
					outputChatBox( "Has eliminado el texto con ID " .. textID .. ".", player, 0, 255, 153 )
					destroyElement( element )
					
					-- remove the reference
					elements[ textID ] = nil
				else
					outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "El texto no ha sido encontrado.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "nearbytexts",
	function( player, commandName )
		if hasObjectPermissionTo( player, "command.createtext", false ) or hasObjectPermissionTo( player, "command.modchat", false ) then
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			local interior = getElementInterior( player )
			
			outputChatBox( "Textos cercanos:", player, 255, 255, 0 )
			for key, element in pairs( elements ) do
				if getElementDimension( element ) == dimension and getElementInterior( element ) == interior then
					local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( element ) )
					if distance < 20 then
						outputChatBox( "  Texto " .. key .. ": " .. tostring( getElementData( element, "text" ) ), player, 255, 255, 0 )
					end
				end
			end
		end
	end
)

function createTableAndSend3DText()
	for k, v in ipairs(getElementsByType("player")) do
		local x, y, z = getElementPosition( v )
		local dimension = getElementDimension( v )
		local interior = getElementInterior( v )
		local elementsToSend = {}
		for key, element in pairs( getElementsByType( "3dtext", resourceRoot ) ) do
			if getElementDimension( element ) == dimension and getElementInterior( element ) == interior then
				local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( element ) )
				if distance <= 15 then
					table.insert(elementsToSend, element)
				end
			end
		end
		if #elementsToSend > 0 then
			triggerClientEvent(v, "onSendTablePickup3DText", v, elementsToSend)
		end
	end
end
setTimer(createTableAndSend3DText, 2500, 0)