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
local periodicos = { }

local addCommandHandler_ = addCommandHandler
      addCommandHandler  = function( commandName, fn, restricted, caseSensitive )
	-- add the default command handlers
	if type( commandName ) ~= "table" then
		commandName = { commandName }
	end
	for key, value in ipairs( commandName ) do
		if key == 1 then
			addCommandHandler_( value, fn, restricted, caseSensitive )
		else
			addCommandHandler_( value,
				function( player, ... )
					-- check if he has permissions to execute the command, default is not restricted (aka if the command is restricted - will default to no permission; otherwise okay)
					if hasObjectPermissionTo( player, "command." .. commandName[ 1 ], not restricted ) then
						fn( player, ... )
					end
				end
			)
		end
	end
end

local function loadperiodico( id, x, y, z, rotation, interior, dimension, skin, operativa )
	local periodico = nil
	if skin == -1 then
		periodico = createObject( 1285, x, y, z, 0, 0, rotation )
		setElementDoubleSided( periodico, true )
		setElementData(periodico, "operativa", operativa)
	end


	setElementInterior( periodico, interior )
	setElementDimension( periodico, dimension )

	periodicos[ id ] = { periodico = periodico, skin = -1 }
	periodicos[ periodico ] = id
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM periodicos ORDER BY periodicoID ASC" )
		if result then
			for key, value in ipairs( result ) do
				loadperiodico( value.periodicoID, value.x, value.y, value.z, value.rotation, value.interior, value.dimension, value.skin, value.operativa )
			end
		end
	end
)

function createperiodico( player )
	if hasObjectPermissionTo( player, "command.kick", false ) then
		local x, y, z = getElementPosition( player )
		z = z - 0.35
		local rotation = ( getPedRotation( player ) + 180 ) % 360
		local interior = getElementInterior( player )
		local dimension = getElementDimension( player )

		local periodicoID = exports.sql:query_insertid( "INSERT INTO periodicos (x, y, z, rotation, interior, dimension) VALUES (" .. table.concat( { x, y, z, rotation, interior, dimension }, ", " ) .. ")" )
		if periodicoID then
			loadperiodico( periodicoID, x, y, z, rotation, interior, dimension, -1, 1 )
			setElementPosition( player, x, y, z + 1 )

			outputChatBox( "Has creado un periodico. ID: " .. periodicoID .. ".", player, 0, 255, 153 )
		else
			outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
		end
	end
end

addCommandHandler("createperiodico", createperiodico)



addCommandHandler( { "nearbyatms", "nearbyperiodicos" },
	function( player, commandName )
		if hasObjectPermissionTo( player, "command.kick", false ) then
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			local interior = getElementInterior( player )

			outputChatBox( "periodicos:", player, 255, 255, 0 )
			for key, value in pairs( periodicos ) do
				if isElement( key ) and getElementDimension( key ) == dimension and getElementInterior( key ) == interior then
					local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( key ) )
					if distance < 5 then
						outputChatBox( "Periodico ID " .. value .. ".", player, 255, 255, 0 )
					end
				end
			end
		end
	end
)


function deleteperiodico ( player, commandName, periodicoID )
	if hasObjectPermissionTo( player, "command.kick", false ) then
		periodicoID = tonumber( periodicoID )
		if periodicoID then
			local periodico = periodicos[ periodicoID ]
			if periodico then
				if getElementType( periodico.periodico ) == "object" then
					if exports.sql:query_free( "DELETE FROM periodicos WHERE periodicoID = " .. periodicoID ) then
						outputChatBox( "El periódico con el ID " .. periodicoID .. " ha sido borrado.", player, 0, 255, 153 )

						destroyElement( periodico.periodico )
						periodicos[ periodicoID ] = nil
						periodicos[ periodico.periodico ] = nil
					else
						outputChatBox( "Se ha producido un error al intentar borrarla.", player, 255, 0, 0 )
					end
				else
					outputChatBox( "Periódico no encontrado.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "Periódico no encontrado.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end
end

addCommandHandler("deleteperiodico", deleteperiodico)

--

function addZero( number, size )
  local number = tostring( number )
  local number = #number < size and ( ('0'):rep( size - #number )..number ) or number
     return number
end

addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if not isElementFrozen(player) and button == "left" and state == "up" then
			local periodicoID = periodicos[ source ]
			if periodicoID then
				local periodico = periodicos[ periodicoID ]
				if periodico then
					local x, y, z = getElementPosition( player )
					if getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) ) < 5 and getElementDimension( player ) == getElementDimension( source ) then
						if getElementType( periodico.periodico ) == "object" then
							if getElementData(periodico.periodico, "operativa") == 1 then
								if not getElementData(player, "newspaper") == false then outputChatBox("Ya tienes un periodico! Usa: /leerperiodico para leerlo o /tirarperiodico para tirarlo.", player, 0, 255, 0) return end
								if not exports.players:takeMoney(player, 4) then outputChatBox("(( No te puedes permitir un periodico. Cuesta 4$. ))", player, 255, 0, 0) return end
								local textFile = fileOpen("text.txt", true)
								local text = fileRead(textFile, 500)
								exports.chat:me(player, "mete 4$ y saca un periódico.")
								exports.factions:giveFactionPresupuesto(4, 4)
								triggerClientEvent(player, "showStandGUI", player, text)
								fileClose(textFile)
							else
								exports.chat:me(player, "se acerca al stand de periódico y ve que está vacio.")
							end
						end
					end
				end
			end
		end
	end
)

function getPos(periodicoID)
	if periodicoID then
		local periodico = periodicos[ periodicoID ]
		local x, y, z = getElementPosition(periodico.periodico)
		return x, y, z
	end
end
