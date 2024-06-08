local data = { }

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
	
	-- check for alternative handlers, such as createinterior = createint
	for k, v in ipairs( commandName ) do
		if v:find( "interior" ) then
			for key, value in pairs( { "int" } ) do
				local newCommand = v:gsub( "interior", value )
				if newCommand ~= v then
					-- add a second (replaced) command handler
					addCommandHandler_( newCommand,
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
	end
end

local interiors = { }
local colspheres = { }

function getInteriorIDAt( x, y, z, interior )
	for name, i in pairs( interiorPositions ) do
		if interior == i.interior and getDistanceBetweenPoints3D( x, y, z, i.x, i.y, i.z ) < 15 then
			return name, i
		end
	end
end

local function createBlipEx( outside, inside )
	local interior = getElementInterior( inside )
	local x, y, z = getElementPosition( inside )
	
	local name, i = getInteriorIDAt( x, y, z, interior )
	if i and i.blip then
		return createBlipAttachedTo( outside, i.blip, 2, 255, 255, 255, 255, 0, 50 )
	end
end

local function loadInterior( id, outsideX, outsideY, outsideZ, outsideVehRX, outsideVehRY, outsideVehRZ, outsideInterior, outsideDimension, insideX, insideY, insideZ, insideVehRX, insideVehRY, insideVehRZ, insideInterior, interiorName, interiorPrice, interiorPriceCompra, interiorType, characterID, locked, dropoffX, dropoffY, dropoffZ, precintado, idasociado, recaudacion, productos )
	local outside = createColSphere( outsideX, outsideY, outsideZ, 1 )
	local characterName = exports.players:getCharacterName(characterID)
	local idasociado = idasociado or 0
	local precintado = precintado or 0
	setElementInterior( outside, outsideInterior )
	setElementDimension( outside, outsideDimension )
	setElementData( outside, "name", interiorName )
	setElementData( outside, "characterID", characterID )
	setElementData( outside, "characterName", characterName )
	setElementData( outside, "inttype", interiorType )
	setElementData( outside, "interiorID", id )
	setElementData( outside, "precintado", precintado )
	setElementData( outside, "idasociado", idasociado )
	
	setElementData( outside, "outsideVehRX", outsideVehRX )
	setElementData( outside, "outsideVehRY", outsideVehRY )
	setElementData( outside, "outsideVehRZ", outsideVehRZ )
	
	-- we only need it set in case there's really something for sale
	if interiorType ~= 0 and characterID <= 0 then
		setElementData( outside, "type", interiorType )
		setElementData( outside, "price", interiorPrice )
	end
	
	local inside = createColSphere( insideX, insideY, insideZ, 1 )
	setElementInterior( inside, insideInterior )
	setElementDimension( inside, id )
	setElementData( inside, "insideVehRX", insideVehRX )
	setElementData( inside, "insideVehRY", insideVehRY )
	setElementData( inside, "insideVehRZ", insideVehRZ )
	
	colspheres[ outside ] = { id = id, other = inside }
	colspheres[ inside ] = { id = id, other = outside }
	interiors[ id ] = { inside = inside, outside = outside, name = interiorName, type = interiorType, price = interiorPrice, priceCompra = interiorPriceCompra, characterID = characterID, locked = locked, blip = not locked and outsideDimension == 0 and not getElementData( outside, "price" ) and createBlipEx( outside, inside ), dropoffX = dropoffX, dropoffY = dropoffY, dropoffZ = dropoffZ, precintado = precintado, idasociado = idasociado, recaudacion = recaudacion, productos = productos }
	if locked == 1 or (idasociado > 0 and interiorType == 0) then
		interiors [ id ].locked = true
	else
		interiors [ id ].locked = false
	end
	--interiors[ id ] = { inside = inside, outside = outside, name = interiorName, type = interiorType, price = interiorPrice, priceCompra = interiorPriceCompra, characterID = characterID, locked = locked, blip = not locked and outsideDimension == 0 and not getElementData( outside, "price" ) and createBlipEx( outside, inside ), dropoffX = x, dropoffY = y, dropoffZ = z, precintado = precintado, idasociado = idasociado, recaudacion = recaudacion, productos = productos }
	--if type == 0 or type == 2 then
	--	interiors [ id ].locked = 0
	--end
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM interiors ORDER BY interiorID ASC" )
		if result then
			for key, data in ipairs( result ) do
				loadInterior( data.interiorID, data.outsideX, data.outsideY, data.outsideZ, data.outsideVehRX, data.outsideVehRY, data.outsideVehRZ, data.outsideInterior, data.outsideDimension, data.insideX, data.insideY, data.insideZ, data.insideVehRX, data.insideVehRY, data.insideVehRZ, data.insideInterior, data.interiorName, data.interiorPrice, data.interiorPriceCompra, data.interiorType, data.characterID, data.locked, data.dropoffX, data.dropoffY, data.dropoffZ, data.precintado, data.idasociado, data.recaudacion, data.productos )
			end
		end
	end
)

addCommandHandler( "createinterior",
	function( player, commandName, id, price, type, ... )
		if id and tonumber( price ) and tonumber( type ) and ( ... ) then
			local name = table.concat( { ... }, " " )
			local interior = interiorPositions[ id:lower( ) ]
			if interior then
				local x, y, z = getElementPosition( player )
				local insertid = exports.sql:query_insertid( "INSERT INTO interiors (outsideX, outsideY, outsideZ, outsideInterior, outsideDimension, insideX, insideY, insideZ, insideInterior, interiorName, interiorType, interiorPrice, dropoffX, dropoffY, dropoffZ) VALUES (" .. table.concat( { x, y, z, getElementInterior( player ), getElementDimension( player ), interior.x, interior.y, interior.z, interior.interior, '"%s"', tonumber( type ), tonumber( price ), x, y, z }, ", " ) .. ")", name )
				if insertid then
					loadInterior( insertid, x, y, z, 0, 0, 0, getElementInterior( player ), getElementDimension( player ), interior.x, interior.y, interior.z, 0, 0, 0, interior.interior, name, tonumber( price ), 0, tonumber( type ), 0, false, x, y, z, 0, 0, 0, 0)
					outputChatBox( "Interior creado. (ID " .. insertid .. ")", player, 0, 255, 0 )
				else
					outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "El interior " .. id:lower( ) .. " no existe.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id] [precio] [tipo 0=Generico 1=Casa 2=Negocio 3=Alquiler] [Nombre]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( { "deleteinterior", "delinterior" },
	function( player, commandName, interiorID )
		interiorID = tonumber( interiorID )
		if interiorID then
			local interior = interiors[ interiorID ]
			if interior then
				if exports.sql:query_free( "DELETE FROM interiors WHERE interiorID = " .. interiorID ) then
					outputChatBox( "Has borrado el interior " .. interiorID .. ".", player, 0, 255, 153 )
					exports.logs:addLogMessage("delint", "El staff "..getPlayerName(player).." ha eliminado el interior ID "..tostring(interiorID))
					-- teleport all players who're inside to the exit
					for key, value in ipairs( getElementsByType( "player" ) ) do
						if exports.players:isLoggedIn( value ) and getElementDimension( value ) == interiorID then
							setElementPosition( value, getElementPosition( interior.outside ) )
							setElementInterior( value, getElementInterior( interior.outside ) )
							setElementDimension( value, getElementDimension( interior.outside ) )
						end
					end
					
					-- cleanup now unused shops
					exports.shops:clearDimension( interiorID )
					
					-- delete the markers
					colspheres[ interior.outside ] = nil
					destroyElement( interior.outside )
					colspheres[ interior.inside ] = nil
					destroyElement( interior.inside )
					if interior.blip then
						destroyElement( interior.blip )
					end
					
					-- remove the reference
					interiors[ interiorID ] = nil
				else
					outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "Interior no encontrado.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "setinterior",
	function( player, commandName, id )
		if id then
			local int = interiors[ getElementDimension( player ) ]
			if int then
				interior = interiorPositions[ id:lower( ) ]
				if interior then
					if exports.sql:query_free( "UPDATE interiors SET insideX = " .. interior.x .. ", insideY = " .. interior.y .. ", insideZ = " .. interior.z .. " , insideInterior = " .. interior.interior .. " WHERE interiorID = " .. getElementDimension( player ) ) then
						-- move the colshape
						setElementPosition( int.inside, interior.x, interior.y, interior.z )
						setElementInterior( int.inside, interior.interior )
						
						-- teleport all players to the new point
						for key, value in ipairs( getElementsByType( "player" ) ) do
							if exports.players:isLoggedIn( value ) and getElementDimension( value ) == getElementDimension( player ) then
								setElementPosition( value, interior.x, interior.y, interior.z )
								setElementInterior( value, interior.interior )
							end
						end
						
						-- create a blip if used
						if int.blip then
							destroyElement( int.blip )
							int.blip = nil
						end
						int.blip = not int.locked and getElementDimension( int.outside ) == 0 and not getElementData( int.outside, "price" ) and createBlipEx( int.outside, int.inside )
						
						-- show a message
						outputChatBox( "Interior actualizado - nueva ID: " .. id:lower( ) .. ".", player, 0, 255, 0 )
					else
						outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
					end
				else
					outputChatBox( "Interior " .. id .. " no existe.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "No estas en un interior", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

function setInteriorFromRemote( interiorID, id, temporal )
	if interiorID and id then
		local int = interiors[ interiorID ]
		if int then
			interior = interiorPositions[ id:lower( ) ]
			if interior then
				-- Obtenemos el interior antiguo por si nos hace falta.
				local interior_old = getElementInterior( int.inside )
				local x_old, y_old, z_old = getElementPosition( int.inside )
				local id_old = getInteriorIDAt( x_old, y_old, z_old, interior_old )
				
				-- move the colshape
				setElementPosition( int.inside, interior.x, interior.y, interior.z )
				setElementInterior( int.inside, interior.interior )
						
				-- teleport all players to the new point
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if exports.players:isLoggedIn( value ) and getElementDimension( value ) == interiorID then
						outputChatBox("Estás previsualizando el interior '"..tostring(id).."' durante 60 segundos.", value, 0, 255, 0)
						setElementPosition( value, interior.x, interior.y, interior.z )
						setElementInterior( value, interior.interior )
					end
				end
						
				-- create a blip if used
				if int.blip then
					destroyElement( int.blip )
					int.blip = nil
				end
				
				int.blip = not int.locked and getElementDimension( int.outside ) == 0 and not getElementData( int.outside, "price" ) and createBlipEx( int.outside, int.inside )
						
				if temporal == 0 then
					-- Almacenamos el cambio en la base de datos.
					exports.sql:query_free( "UPDATE interiors SET insideX = " .. interior.x .. ", insideY = " .. interior.y .. ", insideZ = " .. interior.z .. " , insideInterior = " .. interior.interior .. " WHERE interiorID = " .. interiorID )
				elseif temporal == 1 then
					-- Programamos que en 1 minuto se vuelva a restaurar el interior que corresponde.
					setTimer(setInteriorFromRemote, 60000, 1, interiorID, tostring(id_old), 0)
				end
			end
		end
	end
end
addEvent("setInteriorRemote", true)
addEventHandler("setInteriorRemote", getRootElement(), setInteriorFromRemote)

addCommandHandler( "setinteriorinside",
	function( player, commandName )
		local int = interiors[ getElementDimension( player ) ]
		if int then
			local x, y, z = getElementPosition( player )
			local interior = getElementInterior( player )
			if exports.sql:query_free( "UPDATE interiors SET insideX = " .. x .. ", insideY = " .. y .. ", insideZ = " .. z .. " , insideInterior = " .. interior .. " WHERE interiorID = " .. getElementDimension( player ) ) then
				setElementPosition( int.inside, x, y, z )
				setElementInterior( int.inside, interior )
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if exports.players:isLoggedIn( value ) and getElementDimension( value ) == getElementDimension( player ) then
						setElementPosition( value, x, y, z )
						setElementInterior( value, interior )
					end
				end
				if int.blip then
					destroyElement( int.blip )
					int.blip = nil
				end
				int.blip = not int.locked and getElementDimension( int.outside ) == 0 and not getElementData( int.outside, "price" ) and createBlipEx( int.outside, int.inside )
				outputChatBox( "Interior actualizado.", player, 0, 255, 0 )
			else
				outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "No estas en un interior.", player, 255, 0, 0 )
		end
	end,
	true
)

addCommandHandler( "setinteriorinsideveh",
	function( player, commandName, id )
		local int = interiors[ getElementDimension( player ) ]
		local vehicle = getPedOccupiedVehicle( player )
		if int and vehicle then
			local rx, ry, rz = getElementRotation( vehicle )
			if exports.sql:query_free( "UPDATE interiors SET insideVehRX = " .. rx .. ", insideVehRY = " .. ry .. ", insideVehRZ = " .. rz .. " WHERE interiorID = " .. getElementDimension( player ) ) then
				setElementData(int.inside, "insideVehRX", rx)
				setElementData(int.inside, "insideVehRY", ry)
				setElementData(int.inside, "insideVehRZ", rz)
				outputChatBox( "Interior actualizado. Al entrar, los vehículos quedarán tal cual está el tuyo (de rotación)", player, 0, 255, 0 )
			else
				outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Debes de estar en un interior y en un vehículo.", player, 255, 0, 0 )
		end
	end,
	true
)

addCommandHandler( "setinterioroutsideveh",
	function( player, commandName, id )
		local int = interiors[ tonumber(id) ]
		local vehicle = getPedOccupiedVehicle( player )
		if int and vehicle then
			local rx, ry, rz = getElementRotation( vehicle )
			if exports.sql:query_free( "UPDATE interiors SET outsideVehRX = " .. rx .. ", outsideVehRY = " .. ry .. ", outsideVehRZ = " .. rz .. " WHERE interiorID = " .. tonumber(id) ) then
				setElementData(int.outside, "outsideVehRX", rx)
				setElementData(int.outside, "outsideVehRY", ry)
				setElementData(int.outside, "outsideVehRZ", rz)
				outputChatBox( "Interior actualizado. Al salir, los vehículos quedarán tal cual está el tuyo (de rotación)", player, 0, 255, 0 )
			else
				outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Sintaxis: /setinterioroutsideveh [interior ID] (debes de estar en un vehículo)", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "setinteriorprice",
	function( player, commandName, price )
		price = math.ceil( tonumber( price ) or -1 )
		if price and price >= 0 then
			local int = interiors[ getElementDimension( player ) ]
			if int then
				-- change the price in the db
				if exports.sql:query_free( "UPDATE interiors SET interiorPrice = " .. price .. " WHERE interiorID = " .. getElementDimension( player ) ) then
					if getElementData( int.outside, "price" ) then
						setElementData( int.outside, "price", price )
					end
					
					-- update the price
					int.price = price
					
					-- show a message
					outputChatBox( "Interior actualizado - nuevo precio: $" .. price .. ".", player, 0, 255, 0 )
				else
					outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "No estas en un interior.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [precio]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "setinteriorname",
	function( player, commandName, ... )
		local name = table.concat( { ... }, " " )
		if #name > 0 then
			local int = interiors[ getElementDimension( player ) ]
			if int then
				-- change the price in the db
				if exports.sql:query_free( "UPDATE interiors SET interiorName = '%s' WHERE interiorID = " .. getElementDimension( player ), name ) then
					-- update the name
					int.name = name
					setElementData( int.outside, "name", name )
					
					-- show a message
					outputChatBox( "Interior actualizado - Nuevo nombre: " .. name .. ".", player, 0, 255, 0 )
				else
					outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "No estas en un interior.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [nombre]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "setinteriorowner",
	function( player, commandName, otherplayer )
		if hasObjectPermissionTo( player, "command.createinterior", false ) then
		if otherplayer then
		local interiorID = getElementDimension( player )
		local interior = interiors[ interiorID ]
		local other, name = exports.players:getFromName( player, otherplayer )
		local otherID = exports.players:getCharacterID( other )
		local othername = getPlayerName( other ):gsub( "_", " " )
		if interior then
			-- we can only sell owned houses
			if not isPedInVehicle ( player ) then
				-- update the sql before anything else
				if exports.sql:query_free( "UPDATE interiors SET characterID = " .. otherID .. " WHERE interiorID = " .. interiorID ) then
					interior.characterID = otherID
					
					-- restore the element data which shows it as not sold
					setElementData( interior.outside, "characterID", otherID )
					setElementData( interior.outside, "characterName", othername )
					
					-- TODO: destroy all house keys
					-- for now: destroy the person's key
					exports.items:give( other, 2, interiorID, "House Keys" )
					
					-- destroy a blip if there was one
					if isElement( interior.blip ) then
						destroyElement( interior.blip )
						interior.blip = nil
					end
					
					-- teleport all players who're inside to the exit
					for key, value in ipairs( getElementsByType( "player" ) ) do
						if exports.players:isLoggedIn( value ) and getElementDimension( value ) == interiorID then
							setElementPosition( value, getElementPosition( interior.outside ) )
							setElementInterior( value, getElementInterior( interior.outside ) )
							setElementDimension( value, getElementDimension( interior.outside ) )
						end
					end
					
					-- show a message
					outputChatBox( "Has transpasado la propiedad a " .. othername .. ".", player, 0, 255, 0 )
					outputChatBox( "".. getPlayerName( player ):gsub( "_", " " ) .." te ha transpasado una propiedad.", other, 0, 255, 0 )
				else
					outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
				end
			else
			end
		else 
		end
		else outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
	end
	end
	end
)

addCommandHandler( "getinterior",
	function( player, ... )
		-- check if he has permissions to see at least one prop
		local int = interiors[ getElementDimension( player ) ]
		if int then
			if hasObjectPermissionTo( player, "command.modchat", false ) then
				local interior = getElementInterior( int.inside )
				local x, y, z = getElementPosition( int.inside )
				local name, i = getInteriorIDAt( x, y, z, interior )
				outputChatBox( "-- Datos del Interior --", player, 255, 255, 255 )	
				outputChatBox( "Nombre: " .. int.name, player, 255, 255, 255 )
				outputChatBox( "Espacio: " .. name, player, 255, 255, 255 )
				outputChatBox( "Tipo: " .. int.type, player, 255, 255, 255 )
				if exports.players:getCharacterName(int.characterID) then
					outputChatBox( "Titular: " .. exports.players:getCharacterName(int.characterID), player, 255, 255, 255 )
				end
				outputChatBox( "Precio: " .. int.price, player, 255, 255, 255 )
				if tonumber(int.idasociado) >= 1 then
					outputChatBox( "ID del interior asociado: " .. int.idasociado, player, 255, 255, 255 )
				else
					outputChatBox( "No tiene ningún interior asociado.", player, 255, 255, 255 )
				end
			end
		else
			outputChatBox( "No estás en un interior.", player, 255, 0, 0 )
		end
	end
)
--[[
addCommandHandler( "vendera",
	function( player, commandName, otherplayer )
		if otherplayer then
		local interiorID = getElementDimension( player )
		local interior = interiors[ interiorID ]
		local other, name = exports.players:getFromName( player, otherplayer )
		local otherID = exports.players:getCharacterID( other )
		local othername = getPlayerName( other ):gsub( "_", " " )
		if interior then
			-- we can only sell owned houses
			if interior.type > 0 and interior.characterID == exports.players:getCharacterID( player ) and not isPedInVehicle ( player ) then
				-- update the sql before anything else
				if exports.sql:query_free( "UPDATE interiors SET characterID = " .. otherID .. " WHERE interiorID = " .. interiorID ) then
					interior.characterID = otherID
					
					-- restore the element data which shows it as not sold
					setElementData( interior.outside, "characterID", otherID )
					setElementData( interior.outside, "characterName", othername )
					
					-- TODO: destroy all house keys
					-- for now: destroy the person's key
					exports.items:takeid( player, 2, interiorID )
					exports.items:give( other, 2, interiorID, "Llaves de casa" )
					
					-- destroy a blip if there was one
					if isElement( interior.blip ) then
						destroyElement( interior.blip )
						interior.blip = nil
					end
					
					-- teleport all players who're inside to the exit
					for key, value in ipairs( getElementsByType( "player" ) ) do
						if exports.players:isLoggedIn( value ) and getElementDimension( value ) == interiorID then
							setElementPosition( value, getElementPosition( interior.outside ) )
							setElementInterior( value, getElementInterior( interior.outside ) )
							setElementDimension( value, getElementDimension( interior.outside ) )
						end
					end
					
					-- show a message
					outputChatBox( "Has vendido esta propiedad a " .. othername .. ".", player, 0, 255, 0 )
					outputChatBox( "".. getPlayerName( player ):gsub( "_", " " ) .." te ha vendido una propiedad", other, 0, 255, 0 )
				else
					outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
				end
			elseif isPedInVehicle ( player ) then 
				else outputChatBox( "Esta propiedad no te pertenece.", player, 255, 0, 0 )
			end
		else 
		end
		else outputChatBox( "Syntax: /" .. commandName .. " [player]", player, 255, 255, 255 )
	end
	end
)
]]
--

addCommandHandler( { "sellinterior", "venderpropiedad" , "venderint" },
	function( player , cmd )
		local interiorID = getElementDimension( player )
		local interior = interiors[ interiorID ]
		if interior then
			local confirm = getElementData(player, "ventaconf")
			if not confirm then
				setElementData(player, "ventaconf", true)
				outputChatBox("Estás a punto de vender tu "..tostring(interior.name), player, 255, 0, 0)
				outputChatBox("Cantidad que recibirás si lo vendes: "..tostring(interior.priceCompra).." dólares.", player, 255, 255, 0)
				outputChatBox("Usa /"..tostring(cmd).." de nuevo para confirmar la venta.", player, 255, 255, 255)
				return
			end
			removeElementData(player, "ventaconf")
			-- we can only sell owned houses
			if interior.characterID == exports.players:getCharacterID( player ) then
				-- update the sql before anything else
				local sql = exports.sql:query_assoc_single("SELECT prestamoID FROM prestamos WHERE tipo = 2 AND pagado < cantidad AND objetoID = "..interiorID)
				if sql and sql.prestamoID then 
					outputChatBox("No puedes vender un interior con préstamo. Puedes anular el préstamo en F1.", player, 255, 0, 0) 
					outputChatBox("También puedes pagar el préstamo y posteriormente vender el interior por "..tostring(interior.priceCompra).."$", player, 255, 255, 255)
					return
				end
				triggerEvent("onGuardarMuebles", player, player)
				if exports.sql:query_free( "UPDATE interiors SET characterID = 0 WHERE interiorID = " .. interiorID ) then
					interior.characterID = 0
					-- restore the element data which shows it as not sold
					setElementData( interior.outside, "type", interior.type )
					setElementData( interior.outside, "price", interior.price ) 
					setElementData( interior.outside, "characterID", 0 )
					removeElementData( interior.outside, "characterName" )
					exports.logs:addLogMessage("sellint", "Interior ID "..tostring(interiorID).. " vendido ("..getPlayerName(player)..")")
					-- for now: destroy the person's key
					local result = exports.sql:query_assoc("SELECT interiorID, idasociado FROM interiors WHERE idasociado = "..interiorID)
					for key2, value2 in ipairs (result) do
						if value2.idasociado >= 1 and value2.interiorID ~= interiorID then
							outputChatBox("Se te ha quitado la llave del interior "..value2.interiorID.." por estar asociado al que has vendido.", player, 0, 255, 0)
							exports.items:take2( player, 2, value2.interiorID )
							exports.admin:anularLlaves(tonumber(value2.interiorID), 2)
						end
					end
					exports.items:take2( player, 2, interiorID )
					exports.admin:anularLlaves(tonumber(interiorID), 2)
					-- destroy a blip if there was one
					if isElement( interior.blip ) then
						destroyElement( interior.blip )
						interior.blip = nil
					end
					
					-- teleport all players who're inside to the exit
					for key, value in ipairs( getElementsByType( "player" ) ) do
						if exports.players:isLoggedIn( value ) and getElementDimension( value ) == interiorID then
							setElementPosition( value, getElementPosition( interior.outside ) )
							setElementInterior( value, getElementInterior( interior.outside ) )
							setElementDimension( value, getElementDimension( interior.outside ) )
						end
					end
					exports.shops:clearDimension(interiorID)					
					-- show a message
					exports.players:giveMoney( player, math.floor( interior.priceCompra ) )
					outputChatBox( "Has vendido el interior por $" .. math.floor( interior.priceCompra ) .. ".", player, 0, 255, 0 )
				else
					outputChatBox( "MySQL-Query error.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "Este interior no te pertenece.", player, 255, 0, 0 )
			end
		else
		end
	end
)

function solicitarVentaInterior ( interiorID )
	local interior = interiors[ interiorID ]
	if interior then
		if interior.characterID then
			if exports.sql:query_free( "UPDATE interiors SET characterID = 0 WHERE interiorID = " .. interiorID ) then
				local sql2p = exports.sql:query_assoc_single("SELECT prestamoID FROM prestamos WHERE tipo = 2 AND objetoID = " .. tostring(interiorID) )
				if sql2p and sql2p.prestamoID then exports.sql:query_free("DELETE FROM `prestamos` WHERE `prestamoID` = "..tostring(sql2p.prestamoID)) end
				interior.characterID = 0
				setElementData( interior.outside, "type", interior.type )
				setElementData( interior.outside, "price", interior.price )
				setElementData( interior.outside, "characterID", 0 )
				removeElementData( interior.outside, "characterName" )
				-- destroy a blip if there was one
				if isElement( interior.blip ) then
					destroyElement( interior.blip )
					interior.blip = nil
				end
				-- teleport all players who're inside to the exit
				for key, value in ipairs( getElementsByType( "player" ) ) do
					if exports.players:isLoggedIn( value ) and getElementDimension( value ) == interiorID then
						setElementPosition( value, getElementPosition( interior.outside ) )
						setElementInterior( value, getElementInterior( interior.outside ) )
						setElementDimension( value, getElementDimension( interior.outside ) )
					end
				end
				exports.shops:clearDimension(interiorID)
				exports.admin:anularLlaves(tonumber(interiorID), 2)
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

--

local p = { }

local function enterInterior( player, key, state, colShape )
	local data = colspheres[ colShape ]
	if data then
		local interior = interiors[ data.id ]
		if interior.type > 0 and interior.characterID == 0 then
			outputChatBox("Estás intentando comprar el Interior "..tostring(interior.name), player, 255, 255, 0)
			outputChatBox("Precio del Interior: $"..tostring(interior.price)..". ID del Interior: "..tostring(data.id)..".", player, 255, 255, 255)
			if interior.type == 1 then -- Interior CASA
				outputChatBox("Puedes comprarlo en efectivo (/comprarint 1) o con hipoteca (/comprarint 2).", player, 255, 255, 255)
				outputChatBox("Si lo pides con Hipoteca, estas son las condiciones:", player, 255, 255, 255)
				local costeINT = 0
				if hasObjectPermissionTo(player, 'command.vip', false) then
					costeINT = interior.price*0.75
				else
					costeINT = interior.price
				end
				local prestamo = math.floor(costeINT*0.7)
				local cuota = math.floor(prestamo*0.004)
				local ncuota = math.floor(prestamo/cuota)
				outputChatBox("Cuota por payday: $"..tostring(cuota)..". Nº de cuotas: "..tostring(ncuota)..".", player, 0, 255, 0)
				outputChatBox("Con /pagarprestamo podrás pagarlo antes de la fecha límite.", player, 0, 255, 0)
				outputChatBox("Entrada (pago 1º vez, en el acto): "..tostring(math.floor(costeINT*0.3))..".", player, 255, 255, 0)
				outputChatBox("Deberás de pagarlo en 90 días. Sino, se podrán tomar acciones judiciales.", player, 0, 255, 0)
			elseif interior.type == 2 then -- Interior NEGOCIO
				local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
				if nivel < 4 then outputChatBox("No tienes el nivel necesario (4) para comprar un negocio. Usa /objetivos.", player, 255, 0, 0) return end
				outputChatBox("Puedes comprarlo únicamente en efectivo (/comprarint 1).", player, 255, 255, 255)
				outputChatBox("Los negocios no admiten compra mediante hipoteca.", player, 255, 255, 255)
				outputChatBox("Ganarás cada PayDay "..tostring(interior.price*0.003).." dólares con este negocio.", player, 0, 255, 0)
			elseif interior.type == 3 then -- Interior ALQUILER
				outputChatBox("Utiliza /comprarint 1 para alquilar este interior.", player, 0, 255, 0)
				outputChatBox("Coste por PayDay: "..tostring(interior.price).." dólares.", player, 0, 255, 0)
				outputChatBox("Esta cuota tendrás que pagarla ahora en concepto de señal.", player, 255, 255, 0)
			end
			setElementData(player, "IDCompra", tonumber(data.id))
		else
			if getElementData(player, "muebleintID") then
				removeElementData(player, "muebleintID")
			end
			if (interior.type > 0 or (interior.type == 0 and interior.idasociado and tonumber(interior.idasociado) > 0)) and interior.locked and not getElementData(player, "account:gmduty") then
				exports.chat:me( player, "intenta abrir la puerta, pero no puede." )
			elseif interior.type >= 0 and interior.precintado == 1 and not getElementData(player, "account:gmduty") then
				exports.chat:me( player, "observa la cinta que dice: Policia. No pasar." )
			else
				if interior.type > 0 and interior.locked and getElementData(player, "account:gmduty") then
					outputChatBox("ATENCIÓN: este interior está cerrado.", player, 255, 0, 0)
				elseif interior.type > 0 and interior.precintado == 1 and getElementData(player, "account:gmduty") then
					outputChatBox("ATENCIÓN: este interior está precintado por la policía.", player, 255, 0, 0)
				end
				local other = data.other
				if other then
					--triggerEvent( "onColShapeLeave", colShape, player, true )
					local x, y, z = getElementPosition(other)
					local dim = getElementDimension(other)
					local int = getElementInterior(other)
					if not isPedInVehicle(player) then
						setElementPosition(player, x, y, z)
						setElementDimension(player, dim)
						setElementInterior(player, int)
						setCameraInterior(player, int)
					else
						local vehicle = getPedOccupiedVehicle(player)
						setVehicleDamageProof(vehicle, true)
						if isVehicleLocked(vehicle) then
							setVehicleLocked(vehicle, false)
							setTimer(setVehicleLocked, 6000, 1, vehicle, true)
						end
						setElementPosition(vehicle, x, y, z)
						if getElementDimension(player) > 0 and getElementData(interior.outside, "outsideVehRX") ~= 0 then
							local rx = getElementData(interior.outside, "outsideVehRX")
							local ry = getElementData(interior.outside, "outsideVehRY")
							local rz = getElementData(interior.outside, "outsideVehRZ")
							setElementRotation(vehicle, rx, ry, rz)
						end
						setElementDimension(vehicle, dim)
						setElementInterior(vehicle, int)
						for k, v in ipairs(getElementsByType("player")) do
							if vehicle == getPedOccupiedVehicle(v) then
								if getElementData(v, "muebleintID") then
									removeElementData(v, "muebleintID")
								end
								setElementDimension(v, dim)
								setElementInterior(v, int)
								setCameraInterior(v, int)
								setElementInterior(vehicle, int)
								local tipo = getVehicleType(vehicle)
								if tipo == "Bike" or tipo == "BMX" then -- Aplicar diversos parches para las motos y bicicletas.
									local sitio = getPedOccupiedVehicleSeat(v)
									setElementPosition(vehicle, x, y, z+0.5)
									removePedFromVehicle(v)
									setTimer(function(sitio) 
										warpPedIntoVehicle(v, vehicle, sitio)
									end, 500, 10, sitio)
									-- 300 y 6 funcionaba OK
								end
							end
						end
						setTimer(setVehicleDamageProof, 750, 1, vehicle, false)
					end
					--triggerEvent( "onColShapeHit", other, player, true )
				end
				exports.items:actualizarPosicion(player)
				exports.admin:actualizarPosicion(player)
				if getElementData(player, "fijo") then
					removeElementData(player, "fijo")
					executeCommandHandler("colgar", player)
				end
			end
		end
	end
end

local function lockInterior( player, key, state, colShape )
	local data = colspheres[ colShape ]
	if data then
		if exports.items:has( player, 2, data.id ) then
			if exports.sql:query_free( "UPDATE interiors SET locked = 1 - locked WHERE interiorID = " .. data.id ) then
				local interior = interiors[ data.id ]
				exports.chat:me( player, "introduce las llaves en la cerradura y " .. ( interior.locked and "abre" or "cierra" ) .. " la puerta. ((" .. interior.name .. "))" )
				interior.locked = not interior.locked
				
				if interior.locked and interior.blip then
					destroyElement( interior.blip )
					interior.blip = nil
				elseif not interior.locked and getElementDimension( interior.outside ) == 0 and not getElementData( interior.outside, "price" ) then
					interior.blip = createBlipEx( interior.outside, interior.inside )
				end
				return true
			end
		end
	end
	return false
end

addEventHandler( "onColShapeHit", resourceRoot,
	function( element, matching )
		if matching and getElementType( element ) == "player" then
			if p[ element ] then
				unbindKey( element, "p", "down", enterInterior, p[ element ] )
				unbindKey( element, "k", "down", lockInterior, p[ element ] )
				
			end
			
			p[ element ] = source
			bindKey( element, "p", "down", enterInterior, p[ element ] )
			bindKey( element, "k", "down", lockInterior, p[ element ] )
			setElementData( element, "interiorMarker", true, false )
		end
	end
)

addEventHandler( "onColShapeLeave", resourceRoot,
	function( element, matching )
		if getElementType( element ) == "player" and p[ element ] then
			unbindKey( element, "p", "down", enterInterior, p[ element ] )
			unbindKey( element, "k", "down", lockInterior, p[ element ] )
			removeElementData( element, "interiorMarker", true, false )
			p[ element ] = nil
		end
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		p[ source ] = nil
	end
)

addEventHandler( "onVehicleStartEnter", root,
	function( player )
		if p[ player ] then
			cancelEvent( )
		end
	end
)

--

function getInterior( id )
	return interiors[ id ]
end

function setDropOff( id, x, y, z )
	if interiors[ id ] and type( x ) == "number" and type( y ) == "number" and type( z ) == "number" then
		if exports.sql:query_free( "UPDATE interiors SET dropoffX = " .. x .. ", dropoffY = " .. y .. ", dropoffZ = " .. z .. " WHERE interiorID = " .. id ) then
			interiors[ id ].dropoff = { x, y, z }
			return true
		end
	end
	return false
end

function toggleLock( player, colShape )
	return getElementType( player ) == "player" and isElement( colShape ) and lockInterior( player, "k", "down", colShape ) or false
end

addCommandHandler( "nearbyints",
	function( player, commandName )
		if hasObjectPermissionTo( player, "command.createshop", false ) or hasObjectPermissionTo( player, "command.deleteshop", false ) then
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			local interior = getElementInterior( player )
			outputChatBox( "Interiores cercanos:", player, 0, 255, 0 )
			for key, colshape in ipairs ( getElementsByType( "colshape", resourceRoot ) ) do
			local px, py, pz = getElementPosition( colshape )
					local distance = getDistanceBetweenPoints3D( x, y, z, px, py, pz )
					if distance < 5 then
					local idint = getElementData ( colshape, "interiorID" )
					local nombreint = getElementData( colshape, "name" )
						outputChatBox( "  Interior ID " .. idint .. " nombre " .. nombreint .. " .", player, 0, 255, 127 )
					end
				end
			end
		end

)

function trasladarinterior ( thePlayer, commandName, id )
	if hasObjectPermissionTo( thePlayer, "command.modchat", false ) then
		local interior = interiors[ tonumber(id) ]
		if id and interior then
			local x, y, z = getElementPosition( thePlayer )
			local dim = getElementDimension ( thePlayer )
			local int = getElementInterior ( thePlayer )
			if exports.sql:query_free( "UPDATE interiors SET outsideX = " .. x .. ", outsideY = " .. y .. ", outsideZ = " .. z .. ", outsideInterior = " .. int .. ", outsideDimension = " .. dim .. " WHERE interiorID = " .. id ) then
				outputChatBox ( "Has cambiado de posición el interior con ID "..id..".", thePlayer, 0, 255, 0 )
				setElementPosition(interior.outside, x, y, z)
				setElementDimension(interior.outside, dim)
				setElementInterior(interior.outside, int)
				interior = { dropoffX = x, dropoffY = y, dropoffZ = z }
			else
				outputChatBox ( "Se ha producido un error con la base de datos. Inténtalo más tarde.", thePlayer, 0, 255, 0 )
			end
		else
			outputChatBox ( "Síntaxis: /"..tostring(commandName).." [id]", thePlayer, 255, 255, 255 )
		end
	end
end
addCommandHandler("trasladarinterior", trasladarinterior)

function gotoInterior ( thePlayer, commandName, id )
	local id = tonumber(id)
	if hasObjectPermissionTo( thePlayer, "command.modchat", false ) or hasObjectPermissionTo( thePlayer, "command.restart", false ) then
		if id then
			local value = exports.sql:query_assoc_single( "SELECT interiorID, outsideX, outsideY, outsideZ, outsideDimension, outsideInterior FROM interiors WHERE interiorID = "..id )
			if not value then
				outputChatBox ( "El interior con ID "..id.." no existe.", thePlayer, 255, 0, 0 )
			else
				setElementPosition ( thePlayer, value.outsideX, value.outsideY, value.outsideZ )
				setElementInterior ( thePlayer, value.outsideInterior )
				setElementDimension ( thePlayer, value.outsideDimension )
				outputChatBox ( "Te has teletransportado al interior con ID "..id..".", thePlayer, 0, 255, 0 )
			end
		else
			outputChatBox("Sintaxis: /"..tostring(commandName).." [interiorID]", thePlayer, 255, 255, 255)
		end
	end
end

addCommandHandler( "gotointerior", gotoInterior )

function precintarInterior (thePlayer, commandName, id)
	local id = tonumber(id)
	local interior = interiors[ id ]
	if exports.factions:isPlayerInFaction(thePlayer, 1) or exports.factions:isPlayerInFaction(thePlayer, 6) then
		if id and interior then
			exports.sql:query_free("UPDATE interiors SET precintado = 1 WHERE interiorID = "..id)
			outputChatBox ( "Has precintado el interior con ID "..id..".", thePlayer, 0, 255, 0 )
			interior.precintado = 1
			exports.logs:addLogMessage("int_precintos", "Interior ID "..tostring(id).." precintado por "..getPlayerName(thePlayer)..".")
		else
			outputChatBox("Síntaxis: /"..tostring(commandName).." [interiorID]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("¡No eres policía ni miembro de justicia!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler( "precintarinterior", precintarInterior )

function quitarPrecintoInterior (thePlayer, commandName, id)
	local id = tonumber(id)
	local interior = interiors[ id ]
	if exports.factions:isPlayerInFaction(thePlayer, 1) or exports.factions:isPlayerInFaction(thePlayer, 6) then
		if id and interior then
			exports.sql:query_free("UPDATE interiors SET precintado = 0 WHERE interiorID = "..tonumber(id))
			outputChatBox ( "Has quitado el precinto del interior con ID "..id..".", thePlayer, 0, 255, 0 )
			exports.logs:addLogMessage("int_precintos", "Interior ID "..tostring(id).." desprecintado por "..getPlayerName(thePlayer)..".")
			interior.precintado = 0
		else
			outputChatBox("Síntaxis: /quitarprecinto [interiorID]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("¡No eres policía ni miembro de justicia!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("quitarprecinto", quitarPrecintoInterior)


function timbreInterior (thePlayer, commandName, id)
	local id = tonumber(id)
	local interior = interiors[ id ]
	if exports.players:isLoggedIn(thePlayer) then
		if id and interior then
			local x, y, z = getElementPosition(thePlayer)
			local px, py, pz = getElementPosition(interior.outside)
			local distancia = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
			if distancia <= 10 then
				exports.chat:me(thePlayer, "se acerca a la puerta y llama al timbre.")
				outputChatBox ("Has llamado al timbre del interior con ID "..id..".", thePlayer, 0, 255, 0)
				for key, value in ipairs( getElementsByType("player") ) do
					local dimension = getElementDimension(value)
					if dimension == id then
						outputChatBox("Alguien está llamando al timbre.", value, 0, 255, 0)
						outputChatBox("Acércate a la puerta y usa /mirilla.", value, 255, 255, 255)
					end
				end
			else
				outputChatBox("No estás lo suficientemente cerca como para llamar al interior ID "..tostring(id)..".", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Síntaxis: /timbre [interiorID]", thePlayer, 255, 255, 255)
		end
	end
end
addCommandHandler("timbre", timbreInterior )

function mirillaInterior (thePlayer)
	if exports.players:isLoggedIn(thePlayer) then
		local id = getElementDimension(thePlayer)
		local interior = interiors[ id ]
		if id and id > 0 and interior then
			local x, y, z = getElementPosition(thePlayer)
			local px, py, pz = getElementPosition(interior.inside)
			local distancia = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
			if distancia <= 1 then
				exports.chat:me(thePlayer, "se acerca a la puerta y mira por la mirilla.")
				outputChatBox("Jugadores que se ven por la mirilla:", thePlayer, 0, 255, 0)
				local hayAlguien = false
				for key, value in ipairs( getElementsByType("player") ) do
					local x2, y2, z2 = getElementPosition(value)
					local ox, oy, oz = getElementPosition(interior.outside)
					local distancia2 = getDistanceBetweenPoints3D(x2, y2, z2, ox, oy, oz)
					if distancia2 <= 10 then
						outputChatBox(" - "..getPlayerName(value):gsub("_", " ")..".", thePlayer, 255, 255, 255)
						hayAlguien = true
					end
				end
				if hayAlguien == false then
					outputChatBox("No hay nadie al otro lado.", thePlayer, 255, 255, 255)
				end
			else
				outputChatBox("No estás lo suficientemente cerca de la puerta como para mirar por la mirilla.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("No estás en un interior.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("mirilla", mirillaInterior )

function asociarInteriores (thePlayer, commandName, id1, id2)
	local id1 = tonumber(id1)
	local id2 = tonumber(id2)
	if hasObjectPermissionTo( thePlayer, "command.modchat", false ) then
		if id1 and id2 then
			exports.sql:query_free("UPDATE interiors SET asociado = 1 WHERE interiorID = "..id1)
			exports.sql:query_free("UPDATE interiors SET asociado = 1 WHERE interiorID = "..id2)
			exports.sql:query_free("UPDATE interiors SET idasociado = "..id1.." WHERE interiorID = "..id2)
			exports.sql:query_free("UPDATE interiors SET idasociado = "..id2.." WHERE interiorID = "..id1)
			outputChatBox("Has asociado los interiores "..id1.." y "..id2..".", thePlayer, 0, 255, 0)
			-- TODO: evitar reinicio por una simple vinculación de interiores, esto es una chapuza.
			restartResource(getResourceFromName("interiors"))
		else
			outputChatBox("Síntaxis: /"..tostring(commandName).." [interiorID1] [interiorID2]", thePlayer, 255, 255, 0)
		end
	else
		outputChatBox("Acceso denegado.", thePlayer, 255, 0, 0)
	end
end

addCommandHandler("asociarinteriores", asociarInteriores)

function intGenerico (thePlayer, commandName, interiorID)
	local interiorID = tonumber(interiorID)
	local interior = interiors[ interiorID ]
	if hasObjectPermissionTo( thePlayer, "command.modchat", false ) then
		if interior then
			exports.sql:query_free("UPDATE interiors SET interiorType = 0 WHERE interiorID = "..interiorID)
			exports.sql:query_free("UPDATE interiors SET characterID = 0 WHERE interiorID = "..interiorID)
			outputChatBox("Has cambiado el interior con el ID "..interiorID.." al tipo 0 (generico).", thePlayer, 0, 255, 0)
			exports.logs:addLogMessage("intgenerico", getPlayerName(thePlayer).." ha cambiado a genérico el interior ID "..tostring(interiorID)..". Antiguo cID del titular: "..tostring(interior.characterID))
			interior.characterID = 0
			interior.type = 0
		else
			outputChatBox("Síntaxis: /intgenerico [interiorID]", thePlayer, 255, 255, 255)
			outputChatBox("Si lo has escrito bien, revisa el ID del interior.", thePlayer, 255, 255, 255)
		end
	end
end
addCommandHandler("intgenerico", intGenerico)
--

function getInteriors(source)
	local characterID = exports.players:getCharacterID(source)
	local result = exports.sql:query_assoc("SELECT * FROM interiors WHERE characterID = "..characterID)
	for key, value in ipairs (result) do
		return value
	end
end

function getInteriorType (interiorID)
	local interior = interiors[ interiorID ]
	if interior then
		return interior.type
	else
		return false
	end
end	

function getPos(interiorID)
	if interiorID then
		local interior = interiors[ interiorID ]
		local x, y, z = getElementPosition(interior.outside)
		local dim = getElementDimension(interior.outside)
		local int = getElementInterior(interior.outside)
		return x, y, z, dim, int
	end
end

function getInteriorsTipo(source, tipo)
	if not source or not tipo then return nil end
	local characterID = exports.players:getCharacterID(source)
	local result = exports.sql:query_assoc("SELECT * FROM interiors WHERE interiorType = "..tipo.." AND characterID = "..characterID)
	return result
end

function isTienda(interiorID)
	local tienda = false
	if interiorID then
		local sql = exports.sql:query_assoc("SELECT shopID FROM shops WHERE dimension = "..tonumber(interiorID))
		for k, v in ipairs(sql) do
			if v and v.shopID then
				tienda = true
			end
		end
	end
	return tienda
end

function getProductos(interiorID)
	if isTienda(interiorID) == true then
		local interior = interiors[ interiorID ]
		if interior then
			return interior.productos
		else
			return false
		end
	end
end

function giveProductos(interiorID, productos)
	if isTienda(interiorID) == true then
		local interior = interiors[ interiorID ]
		if interior then
			if exports.sql:query_free("UPDATE interiors SET productos = "..(productos+interior.productos).." WHERE interiorID = "..interiorID) then
				interior.productos = interior.productos+productos
				return true
			else
				return false
			end
		end
	end
end

function takeProductos(interiorID, productos)
	if isTienda(interiorID) == true then
		local interior = interiors[ interiorID ]
		if interior then
			if exports.sql:query_free("UPDATE interiors SET productos = "..(productos-interior.productos).." WHERE interiorID = "..interiorID) then
				interior.productos = interior.productos-productos
				return true
			else
				return false
			end
		end
	end
end
	
function getRecaudacion(interiorID)
	if isTienda(interiorID) == true then
		local interior = interiors[ interiorID ]
		if interior then
			return interior.recaudacion
		else
			return false
		end
	end
end

function giveRecaudacion(interiorID, cantidad)
	if isTienda(interiorID) == true then
		local interior = interiors[ interiorID ]
		if interior then
			if exports.sql:query_free("UPDATE interiors SET recaudacion = "..(cantidad+interior.recaudacion).." WHERE interiorID = "..interiorID) then
				interior.recaudacion = interior.recaudacion+cantidad
				return true
			else
				return false
			end
		end
	end
end

function takeRecaudacion(interiorID, cantidad)
	if isTienda(interiorID) == true then
		local interior = interiors[ interiorID ]
		if interior then
			if exports.sql:query_free("UPDATE interiors SET recaudacion = "..(cantidad-interior.recaudacion).." WHERE interiorID = "..interiorID) then
				interior.recaudacion = interior.recaudacion-cantidad
				return true
			else
				return false
			end
		end
	end
end
		
function actualizarRecaudacion ()
	for k, v in ipairs(exports.sql:query_assoc("SELECT interiorID, recaudacion FROM `interiors` WHERE `interiorType` = 2")) do
		local interior = interiors[ v.interiorID ]
		if interior then
			interior.recaudacion = v.recaudacion
		end
	end
end

function solicitarRecaudacion (player)
	local interiorID = getElementDimension(player)
	if interiorID == 0 then outputChatBox("No estás en un interior.", player, 255, 0, 0) return end
	local interior = interiors[ interiorID ]
	if interior then
		if exports.players:getCharacterID(player) ~= interior.characterID then outputChatBox("Este interior no es tuyo.", player, 255, 0, 0) return end
		if interior.type ~= 2 or not isTienda(interiorID) then outputChatBox("Este interior no es un local.", player, 255, 0, 0) return end
		local rec = interior.recaudacion
		if rec >= 240 then
			if exports.players:giveMoney(player, rec) and exports.sql:query_free("UPDATE interiors SET recaudacion = 0 WHERE interiorID = "..interiorID) then
				interior.recaudacion = 0
				outputChatBox("Has recogido $"..tostring(rec).." de los bots y de la recaudación diaria.", player, 0, 255, 0)
				if tonumber(rec) >= 2000 then
					local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
					if nivel == 4 and not exports.objetivos:isObjetivoCompletado(38, exports.players:getCharacterID(player)) then
						exports.objetivos:addObjetivo(38, exports.players:getCharacterID(player), player)
					end
				end
			end
		else
			outputChatBox("La recaudación es inferior a 240$.", player, 255, 0, 0)
		end
	end
end	
--addCommandHandler("recoger", solicitarRecaudacion)
--addCommandHandler("recaudar", solicitarRecaudacion)
-- Ojo con habilitar esto, porque un trabajador de la empresa de repartos podría comprarse a sí mismo infinitamente, y se sacaría un dineral.


function puntoReparto (player, cmd, intID)
	if hasObjectPermissionTo(player, "command.modchat", false) then
		if intID then
			local x, y, z = getElementPosition(player)
			setDropOff(tonumber(intID), x, y, z)
			outputChatBox("Has cambiado correctamente el punto de reparto del interior "..tostring(intID)..".", player, 0, 255, 0)
		else
			outputChatBox("Sintaxis: /puntoreparto [interiorID]", player, 255, 255, 255)
		end
	end
end
addCommandHandler("puntoreparto", puntoReparto)

function realizarCompra(player, interiorID, costeINT)
	local interior = interiors[ interiorID ]
	local characterID = exports.players:getCharacterID( player )
	if characterID then
		if exports.sql:query_free( "UPDATE interiors SET characterID = " .. characterID .. " WHERE interiorID = " .. interiorID ) then
			interior.characterID = characterID
			setElementData( interior.outside, "characterID", characterID )
			setElementData( interior.outside, "characterName", exports.players:getCharacterName ( characterID ) )
			removeElementData( interior.outside, "type" )
			removeElementData( interior.outside, "price" )
			exports.admin:anularLlaves(tonumber(interiorID), 2)
			if tonumber(interior.idasociado) >= 1 then
				exports.admin:anularLlaves(tonumber(interior.idasociado), 2)
				exports.items:give( player, 2, interior.idasociado, "Llaves de propiedad" )
				outputChatBox("Has recibido llaves del interior con ID "..interior.idasociado.." por estar asociado con el que has comprado.", player, 0, 255, 0)
			end
			exports.items:give( player, 2, interiorID, "Llaves de propiedad" )
			interior.blip = not interior.locked and interior.outsideDimension == 0 and createBlipEx( interior.outside, interior.inside )
			if hasObjectPermissionTo(player, 'command.vip', false) then
				outputChatBox( "Enhorabuena, has comprado " .. interior.name .. " por $" .. tostring(costeINT) .. "(25% aplicado por ser VIP)", player, 0, 255, 0 )
			else
				outputChatBox( "Enhorabuena, has comprado " .. interior.name .. " por $" .. tostring(costeINT) .. "!", player, 0, 255, 0 )
			end
			outputChatBox("Si vendes este Interior en el futuro, se te devolverá $"..tostring(costeINT*0.8)..".", player, 255, 0, 0)
			exports.factions:giveFactionPresupuesto(5, tonumber(costeINT*0.2))
			removeElementData(player, "IDCompra")
			exports.sql:query_free( "UPDATE interiors SET interiorPriceCompra = " .. tonumber(costeINT*0.8) .. " WHERE interiorID = " .. interiorID )
			interior.priceCompra = tonumber(costeINT*0.8)
			local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
			if interior.type == 1 and nivel == 3 and not exports.objetivos:isObjetivoCompletado(21, exports.players:getCharacterID(player)) then
				exports.objetivos:addObjetivo(21, exports.players:getCharacterID(player), player)
			end
			if interior.type == 2 and costeINT >= 60000 then -- Negocio
				if nivel == 4 and not exports.objetivos:isObjetivoCompletado(37, exports.players:getCharacterID(player)) then
					exports.objetivos:addObjetivo(37, exports.players:getCharacterID(player), player)
				end
			end
		else
			outputChatBox( "Se ha producido un error grave. Avisa a un Desarrollador.", player, 255, 0, 0 )
			exports.players:giveMoney( player, costeINT )
			removeElementData(player, "IDCompra")
		end
	end
end

function ejecutarCompra (player, cmd, tipo)
	if player and tipo then
		local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
		if nivel < 3 then 
			if tipo == 1 or tipo == 2 then
			outputChatBox("No puedes comprar este interior hasta que no tengas el nivel 3. Usa /objetivos.", player, 255, 0, 0) 
			return
			end
		end
		if not getElementData(player, "IDCompra") then outputChatBox("No estás comprando un Interior.", player, 255, 0, 0) return end
		local idInt = getElementData(player, "IDCompra")
		local sql = exports.sql:query_assoc_single("SELECT * FROM interiors WHERE interiorID = "..tostring(idInt))
		if sql then
			if sql.characterID and tonumber(sql.characterID) == 0 then
				local costeINT = 0
				if hasObjectPermissionTo(player, 'command.vip', false) then
					costeINT = sql.interiorPrice*0.75
				else
					costeINT = sql.interiorPrice
				end
				if tonumber(tipo) == 1 then -- Compra en efectivo
					if exports.players:takeMoney( player, costeINT ) then
						-- DERIVACIÓN AL SISTEMA DE INTERIORES
						realizarCompra(player, tonumber(idInt), tonumber(costeINT))
					else
						outputChatBox("No tienes dinero suficiente para comprar el Interior.", player, 255, 0, 0)
					end
				elseif tonumber(tipo) == 2 then -- Compra mediante Hipoteca
					if sql.interiorType == 1 then
						local prestamo = math.floor(costeINT*0.7)
						local cuota = math.floor(prestamo*0.004)
						local ncuota = math.floor(prestamo/cuota)
						local entrada = math.floor(costeINT*0.3)
						if exports.prestamos:crearPrestamo(player, tonumber(prestamo), 2, tonumber(idInt), tonumber(cuota), tonumber(entrada)) then -- Solicitud PRESTAMO
							-- DERIVACIÓN AL SISTEMA DE INTERIORES
							realizarCompra(player, tonumber(idInt), tonumber(costeINT))
						else
							outputChatBox("Puedes continuar la compra en efectivo con /comprar 1", player, 255, 255, 255)
						end
					else
						outputChatBox("Este Interior no admite la compra mediante Hipoteca.", player, 255, 0, 0)
					end
				else
					outputChatBox("Sintaxis: /comprarint [1 para pagar en efectivo, 2 para pedir un préstamo]", player, 255, 255, 255)
				end
			else
				outputChatBox("¡Ups! Este Interior acaba de ser vendido.", player, 255, 0, 0)
				removeElementData(player, "IDCompra")
			end
		else
			outputChatBox("¡Ups! Este Interior no existe.", player, 255, 0, 0)
			removeElementData(player, "IDCompra")
		end
	else
		outputChatBox("Sintaxis: /comprarint [1 para pagar en efectivo, 2 para pedir un préstamo]", player, 255, 255, 255)
	end
end
addCommandHandler("comprarint", ejecutarCompra)
 
function createTableAndSendInts()
	for k, v in ipairs(getElementsByType("player")) do
		local x, y, z = getElementPosition( v )
		local dimension = getElementDimension( v )
		local interior = getElementInterior( v )
		local elementsToSend = {}
		for key, element in pairs( getElementsByType( "colshape", resourceRoot ) ) do
			if getElementDimension( element ) == dimension and getElementInterior( element ) == interior then
				local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( element ) )
				if distance <= 20 then
					table.insert(elementsToSend, element)
				end
			end
		end
		if #elementsToSend > 0 then
			triggerClientEvent(v, "onSendTablePickupInts", v, elementsToSend)
		end
	end
end
setTimer(createTableAndSendInts, 2500, 0)

function isInteriorAlquiler(interiorID)
	local interior = interiors[ interiorID ]
	if interior then
		if interior.type == 3 then
			return true
		else
			return false
		end
	end
end

function desbugAlCaer ()
	if source and client and source == client then
		local interiorID = getElementDimension(source)
		local interior = interiors[ interiorID ]
		if interior then
			local x, y, z = getElementPosition(interior.inside)
			setElementPosition(source, x, y, z)
			outputChatBox("Has sido desbugeado automáticamente.", source, 0, 255, 0)
		end
	end
end
addEvent("onDesbugAlCaerINT", true)
addEventHandler("onDesbugAlCaerINT", getRootElement(), desbugAlCaer)

function getInteriorPositions()
	return interiorPositions
end

-- function reparacionInterioresID(player)
	-- if player then
		-- local sqlC = exports.sql:query_assoc("SELECT interiorID FROM interiors ORDER BY interiorID ASC")
		-- local intIDActual = 1 -- Empezaremos en el 1.
		-- for k, sql in ipairs(sqlC) do
			-- if tonumber(sql.interiorID) then
				-- exports.sql:query_free("UPDATE `armas_suelo` SET `dimension` = '"..tostring(intIDActual).."' WHERE `dimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `banks` SET `dimension` = '"..tostring(intIDActual).."' WHERE `dimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `characters` SET `dimension` = '"..tostring(intIDActual).."' WHERE `dimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `items` SET `value` = '"..tostring(intIDActual).."' WHERE `item` = '2' AND `value` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `items_mochilas` SET `value` = '"..tostring(intIDActual).."' WHERE `item` = '2' AND `value` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `items_muebles` SET `value` = '"..tostring(intIDActual).."' WHERE `item` = '2' AND `value` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `maleteros` SET `value` = '"..tostring(intIDActual).."' WHERE `item` = '2' AND `value` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `mochilas_suelo` SET `dimension` = '"..tostring(intIDActual).."' WHERE `dimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `muebles` SET `dimension` = '"..tostring(intIDActual).."' WHERE `dimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `prestamos` SET `objetoID` = '"..tostring(intIDActual).."' WHERE `tipo` = '2' AND `objetoID` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `shops` SET `dimension` = '"..tostring(intIDActual).."' WHERE `dimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `vehicles` SET `dimension` = '"..tostring(intIDActual).."' WHERE `dimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `vehicles` SET `respawnDimension` = '"..tostring(intIDActual).."' WHERE `respawnDimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `interiors` SET `outsideDimension` = '"..tostring(intIDActual).."' WHERE `outsideDimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `interiors` SET `insideDimension` = '"..tostring(intIDActual).."' WHERE `insideDimension` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `interiors` SET `idasociado` = '"..tostring(intIDActual).."' WHERE `idasociado` = "..tostring(sql.interiorID))
				-- exports.sql:query_free("UPDATE `interiors` SET `interiorID` = '"..tostring(intIDActual).."' WHERE `interiorID` = "..tostring(sql.interiorID))
				-- exports.logs:addLogMessage("recolocacion-ints", "Viejo ID: "..tostring(sql.interiorID).. " - Nuevo ID: "..tostring(intIDActual))
				-- intIDActual = intIDActual+1
			-- end
		-- end
		-- outputChatBox("Se han reparado correctamente "..tostring(intIDActual).. " interiores.", player, 0, 255, 0)
	-- end
-- end
-- addCommandHandler("fixints", reparacionInterioresID)