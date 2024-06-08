local addCommandHandler_ = addCommandHandler
      addCommandHandler  = function( commandName, fn, restricted, caseSensitive )
	if type( commandName ) ~= "table" then
		commandName = { commandName }
	end
	for key, value in ipairs( commandName ) do
		if key == 1 then
			addCommandHandler_( value, fn, restricted, caseSensitive )
		else
			addCommandHandler_( value,
				function( player, ... )
					if hasObjectPermissionTo( player, "command." .. commandName[ 1 ], not restricted ) then
						fn( player, ... ) 
					end
				end
			)
		end
	end
	
	for k, v in ipairs( commandName ) do
		if v:find( "teleport" ) then
			for key, value in pairs( { "tp" } ) do
				local newCommand = v:gsub( "teleport", value )
				if newCommand ~= v then
					addCommandHandler_( newCommand,
						function( player, ... )
							if hasObjectPermissionTo( player, "command." .. commandName[ 1 ], not restricted ) then
								fn( player, ... )
							end
						end
					)
				end
			end
		end
	end
end

local colspheres = { }
local teleports = { }

local function loadTeleport( id, aX, aY, aZ, aInterior, aDimension, bX, bY, bZ, bInterior, bDimension, name )
	local a = createColSphere( aX, aY, aZ, 1 )
	setElementInterior( a, aInterior )
	setElementDimension( a, aDimension )
	setElementData( a, "name", tostring(name))
	local b = createColSphere( bX, bY, bZ, 1 )
	setElementInterior( b, bInterior )
	setElementDimension( b, bDimension )
	setElementData( b, "name", tostring(name))
	colspheres[ a ] = { id = id, other = b }
	colspheres[ b ] = { id = id, other = a }
	teleports[ id ] = { a = a, b = b }
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM teleports" )
		for key, value in ipairs( result ) do
			loadTeleport( value.teleportID, value.aX, value.aY, value.aZ, value.aInterior, value.aDimension, value.bX, value.bY, value.bZ, value.bInterior, value.bDimension, value.name )
		end
	end
)

local p = { }

addEventHandler( "onPlayerQuit", root,
	function( )
		p[ source ] = nil
	end
)

addCommandHandler( "markteleport",
	function( player )
		if hasObjectPermissionTo( player, "command.createteleport", false ) then
			local x, y, z = getElementPosition( player )
			x = math.ceil( x * 100 ) / 100
			y = math.ceil( y * 100 ) / 100
			z = math.ceil( z * 100 ) / 100
			local interior = getElementInterior( player )
			local dimension = getElementDimension( player )
			if not p[ player ] then
				p[ player ] = { }
			end
			p[ player ].mark = { x = x, y = y, z = z, interior = interior, dimension = dimension }
			outputChatBox( "Marked teleport position. [" .. table.concat( { "x=" .. x, "y=" .. y, "z=" .. z, "i=" .. interior, "d=" .. dimension }, ", " ) .. "]", player, 0, 255, 153 )
		end
	end
)

addCommandHandler( "createteleport",
	function( player, commandName, ... )
	if (...) then
		local name = table.concat( { ... }, " " )
		local a = p[ player ] and p[ player ].mark
		if a then
			local x, y, z = getElementPosition( player )
			x = math.ceil( x * 100 ) / 100
			y = math.ceil( y * 100 ) / 100
			z = math.ceil( z * 100 ) / 100
			local interior = getElementInterior( player )
			local dimension = getElementDimension( player )
			
			local teleportID, e = exports.sql:query_insertid( "INSERT INTO teleports (`aX`, `aY`, `aZ`, `aInterior`, `aDimension`, `bX`, `bY`, `bZ`, `bInterior`, `bDimension`) VALUES (" .. table.concat( { a.x, a.y, a.z, a.interior, a.dimension, x, y, z, interior, dimension }, ", " ) .. ")" )
			if teleportID then
				loadTeleport( teleportID, a.x, a.y, a.z, a.interior, a.dimension, x, y, z, interior, dimension, name)
				outputChatBox( "Has creado un teleport. (ID " .. teleportID .. ")(Nombre: "..name..")", player, 0, 255, 0 )
				exports.sql:query_free( "UPDATE teleports SET name = '%s' WHERE teleportID = "..teleportID, tostring(name))
				p[ player ].mark = nil
			else
				outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Necesitas usar /markteleport para marcar 1 punto del teleport.", player, 255, 0, 0 )
		end
		else
		outputChatBox("Error. Síntaxis: /createteleport [nombre]", player, 255, 255, 0)
	end	
	end,
	true
)

addCommandHandler( { "deleteteleport", "delteleport" },
	function( player, commandName, teleportID )
		teleportID = tonumber( teleportID )
		if teleportID then
			local teleport = teleports[ teleportID ]
			if teleport then
				if exports.sql:query_free( "DELETE FROM teleports WHERE teleportID = " .. teleportID ) then
					outputChatBox( "Has borrado el teleport con el ID " .. teleportID .. ".", player, 0, 255, 153 )
					colspheres[ teleport.a ] = nil
					destroyElement( teleport.a )
					colspheres[ teleport.b ] = nil
					destroyElement( teleport.b )
				else
					outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "Teleport no encontrado.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "nearbyteleports",
	function( player, commandName )
		if hasObjectPermissionTo( player, "command.createteleport", false ) or hasObjectPermissionTo( player, "command.deleteteleport", false ) then
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			local interior = getElementInterior( player )
			
			outputChatBox( "Nearby Teleports:", player, 255, 255, 0 )
			for key, value in pairs( colspheres ) do
				if getElementDimension( key ) == dimension and getElementInterior( key ) == interior then
					local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( key ) )
					if distance < 20 then
						outputChatBox( "  Teleport " .. value.id .. ".", player, 255, 255, 0 )
					end
				end
			end
		end
	end
)

local function useTeleport( player, key, state, colShape )
	local data = colspheres[ colShape ]
	if data then
		local other = data.other
		if other then
			triggerEvent( "onColShapeLeave", colShape, player, true )
			setElementDimension( player, getElementDimension( other ) )
			setElementInterior( player, getElementInterior( other ) )
			setCameraInterior( player, getElementInterior( other ) )
			setElementPosition( player, getElementPosition( other ) )
			setCameraTarget( player, player )
			triggerEvent( "onColShapeHit", other, player, true )
		end
	end
end

addEventHandler( "onColShapeHit", resourceRoot,
	function( element, matching )
		if matching and getElementType( element ) == "player" then
			if not p[ element ] then
				p[ element ] = { }
			elseif p[ element ].tp then
				unbindKey( element, "p", "down", useTeleport, p[ element ].tp )
			end
			
			p[ element ].tp = source
			bindKey( element, "p", "down", useTeleport, p[ element ].tp )
			setElementData( element, "interiorMarker", true, false )
		end
	end
)

addEventHandler( "onColShapeLeave", resourceRoot,
	function( element, matching )
		if element and getElementType( element ) == "player" and p[ element ] and p[ element ].tp then
			unbindKey( element, "p", "down", useTeleport, p[ element ].tp )
			removeElementData( element, "interiorMarker", true, false )
			p[ element ].tp = nil
		end
	end
)