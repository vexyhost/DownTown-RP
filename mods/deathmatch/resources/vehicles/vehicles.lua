local models =
    {
        [ 574 ] = true,
		[ 453 ] = true,
		[ 436 ] = true,
		[ 408 ] = true,
		[ 448 ] = true,
    }

function vehtrab()
    for index, vehicle in ipairs ( getElementsByType ( "vehicle" ) ) do
        if ( models [ getElementModel ( vehicle ) ] ) then
			if isVehicleEmpty( vehicle ) then
				respawnVehicle( vehicle )
			end
		end
	end
end
setTimer(vehtrab, 1200000, 0 )

function getVehicleHandlingProperty( vehiculo, property )
    if isElement ( vehiculo ) and getElementType ( vehiculo ) == "vehicle" and type ( property ) == "string" then
		model = getElementModel(vehiculo)
        local handlingTable = getOriginalHandling ( model )
        local value = handlingTable[property]
        if value then
            return value
        end
    end
    return false
end

function getVehicleHandlingActual ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then
        local handlingTable = getVehicleHandling ( element )
        local value = handlingTable[property]
        if value then 
            return value
        end
    end
    return false
end

function addZero( number, size )
  local number = tostring( number )
  local number = #number < size and ( ('0'):rep( size - #number )..number ) or number
     return number
end

function RGB2HEX(r,g,b)
 local hex = string.format("#%02X%02X%02X", r,g,b)
 return hex
end

function HEX2RGB(hextring)
 hextring = tostring(hextring)
 if string.len(hextring) < 4 then return 0,0,0 end
 hextring = string.gsub(hextring,"#","")
 local r,g,b = tonumber("0x"..string.sub(hextring, 1, 2)) or 0, tonumber("0x"..string.sub(hextring, 3, 4)) or 0, tonumber("0x"..string.sub(hextring, 5, 6)) or 0
 return r,g,b
end

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
	
	-- check for alternative handlers, such as gotovehicle = gotoveh, gotocar
	for k, v in ipairs( commandName ) do
		if v:find( "vehicle" ) then
			for key, value in pairs( { "veh", "car" } ) do
				local newCommand = v:gsub( "vehicle", value )
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

--

local p = { }

local getPedOccupiedVehicle_ = getPedOccupiedVehicle
      getPedOccupiedVehicle = function( ped )
	local vehicle = isPedInVehicle( ped ) and getPedOccupiedVehicle_( ped )
	if vehicle and ( p[ ped ] and p[ ped ].vehicle == vehicle or getElementParent( vehicle ) ~= getResourceDynamicElementRoot( resource ) ) then
		return vehicle
	end
	return false
end

local function isPedEnteringVehicle( ped )
	return getPedOccupiedVehicle_( ped ) and not getPedOccupiedVehicle( ped )
end


local vehicleIDs = { }
local vehicles = { }

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		-- load all vehicles
		local result = exports.sql:query_assoc( "SELECT * FROM vehicles ORDER BY vehicleID ASC" )
		if result then
			for key, data in ipairs( result ) do
				if data.inactivo == 0 and data.cepo == 0 then
				local vehicle = createVehicle( data.model, data.posX, data.posY, data.posZ, data.rotX, data.rotY, data.rotZ )
				setElementFrozen(vehicle, true)
				setElementAlpha(vehicle, 127)
				setElementCollisionsEnabled(vehicle, false)
				setTimer(setElementCollisionsEnabled, 2000, 1, vehicle, true)
				setTimer(setElementAlpha, 2000, 1, vehicle, 255)
				-- tables for ID -> vehicle and vehicle -> data
				vehicleIDs[ data.vehicleID ] = vehicle
				vehicles[ vehicle ] = { vehicleID = data.vehicleID, respawnInterior = data.respawnInterior, respawnDimension = data.respawnDimension, characterID = data.characterID, engineState = not doesVehicleHaveEngine( vehicle ) or data.engineState == 1, tintedWindows = data.tintedWindows == 1, fuel = data.fuel, km = data.km, pinturas = data.pinturas, motor = data.motor, mejoramotor = data.mejoramotor, frenos = data.frenos, mejorafrenos = data.mejorafrenos, model = data.model }

				setElementHealth( vehicle, data.health )
				if data.health <= 300 then
					vehicles[ vehicle ].engineState = false
				end
				if data.color1 and data.color2 then
					r, g, b = HEX2RGB(data.color1)
					r2, g2, b2 = HEX2RGB(data.color2)
					setVehicleColor( vehicle, r, g, b, r2, g2, b2 )
				end
				if data.color3 then
					r, g, b = HEX2RGB(data.color3)
					setVehicleHeadLightColor ( vehicle, r, g, b )
				end
				setVehiclePlateText(vehicle, tostring(addZero( data.vehicleID, 4 )))
				setVehicleRespawnPosition( vehicle, data.respawnPosX, data.respawnPosY, data.respawnPosZ, data.respawnRotX, data.respawnRotY, data.respawnRotZ )
				setElementInterior( vehicle, data.interior )
				setElementDimension( vehicle, data.dimension )
				if data.alarma == 1 then
					setElementData(vehicle, "havealarm", true)
				end
				setVehicleLocked( vehicle, true )
				setVehicleEngineState( vehicle, false )
				setVehicleOverrideLights( vehicle, data.lightsState + 1 )
				setElementData( vehicle, "fuel", data.fuel )
				if data.cepo == 1 then setVehicleEngineState( vehicle, false ) setElementData( vehicle, "cepo", 1 ) end
				setVehiclePaintjob ( vehicle, data.pinturas )
				setElementData(vehicle, "km", data.km)
				setElementData(vehicle, "idowner", data.characterID)
				setElementData(vehicle, "idveh", data.vehicleID)
				exports.vehicles_auxiliar:applyTunning(vehicle)
				setElementData(vehicle, "model", data.model)
				setElementData(vehicle, "fasemotor", data.fasemotor)
				setElementData(vehicle, "fasefrenos", data.fasefrenos)
				if data.diasLimpio > 0 then
					-- Solicitamos limpiarlo a todos los conectados y además lo guardamos.
					-- Preparado para una reforma futura
					setElementData(vehicle, "limpio", true)
				end
				if data.marchas == 1 then
					setElementData(vehicle, "marchas", 1)
				end
				if data.marchas == 0 then
					setElementData(vehicle, "marchas", 0)
				end
				if data.fasemotor > 0 then
					exports.vehicles_auxiliar:solicitarMejora(vehicle, 1, data.fasemotor)
				end
				if data.fasefrenos > 0 then
					exports.vehicles_auxiliar:solicitarMejora(vehicle, 2, data.fasefrenos)
				end
				end
			end
		end
		
		-- bind a key for everyone
		for key, value in ipairs( getElementsByType( "player" ) ) do
			bindKey( value, "num_3", "down", "lockvehicle" )
			bindKey( value, "num_1", "down", "toggleengine" )
			bindKey( value, "num_2", "down", "togglelights" )
			bindKey( value, "num_0", "down", toggleFreezeStatus )
			bindKey( value, "n", "down", toggleFreezeStatus )
			bindKey( value, "k", "down", "lockvehicle" )
			bindKey( value, "j", "down", "toggleengine" )
			bindKey( value, "l", "down", "togglelights" )
			bindKey( value, "c", "down", "cinturon" )
		end
		
		--
		
		-- Fuel update
		setTimer(
			function( )
				for vehicle, data in pairs( vehicles ) do
					if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
						vehicles[ vehicle ] = nil
					elseif data.engineState and data.fuel and not isVehicleEmpty( vehicle ) and doesVehicleHaveEngine( vehicle ) and doesVehicleHaveFuel( vehicle ) and not ( models [ getElementModel ( vehicle ) ] ) then
						local vx, vy, vz = getElementVelocity( vehicle )
						local speed = math.sqrt( vx * vx + vy * vy )
						local loss = ( speed > 0.65 and 2 * speed or speed ) * 0.5 + 0.005
						
						data.fuel = math.max( data.fuel - loss, 0 )
						if math.floor( data.fuel + 0.5 ) ~= getElementData( vehicle, "fuel" ) then
							setElementData( vehicle, "fuel", math.floor( data.fuel + 0.5 ) )
						end
						
						if data.fuel == 0 then
							setVehicleEngineState( vehicle, false )
							setElementData (vehicle, "sinGasolina", true)
							for seat = 0, getVehicleMaxPassengers( vehicle ) do
								local player = getVehicleOccupant( vehicle, seat )
								if player then
									triggerClientEvent( player, "gui:hint", player, "Sin gasolina", "Tu " .. getVehicleName( vehicle ) .. " No arranca sin gasolina!\nPara que no te vuelva a pasar esto recarga cada un tiempo.", 3 )
									setVehicleEngineState( vehicle, false )
								end
							end
						end
					end
				end
			end,
			10000,
			0
		)
		-- KM update
		setTimer(
			function( )
				for vehicle, data in pairs( vehicles ) do
					if not isElement( vehicle ) or getElementType( vehicle ) ~= "vehicle" then
						vehicles[ vehicle ] = nil
					elseif data.engineState and not isVehicleEmpty( vehicle ) and doesVehicleHaveEngine( vehicle ) then
						local vx, vy, vz = getElementVelocity( vehicle )
						local speed = math.sqrt( vx * vx + vy * vy )
						local loss = (( speed > 0.65 and 2 * speed or speed ) * 0.8 + 0.005)*15
						if data.km and data.km > 0 then
							data.km = math.max( data.km + loss, 0 )
						else
							data.km = math.max( loss, 0 )
						end
						if math.floor( data.km ) ~= getElementData( vehicle, "km" ) then
							setElementData( vehicle, "km", math.floor( data.km ) )
						end
						
					end
				end
			end,
			10000,
			0
		)
	end
)

function reloadVehicle(vehicleID)
	if vehicleID then
		if getVehicle(tonumber(vehicleID)) then destroyElement(getVehicle(tonumber(vehicleID))) end
		local data = exports.sql:query_assoc_single("SELECT * FROM vehicles WHERE vehicleID = "..vehicleID)
		if not data then return false end
		if data.inactivo == 0 then
			local vehicle = createVehicle( data.model, data.posX, data.posY, data.posZ, data.rotX, data.rotY, data.rotZ )
			setElementFrozen(vehicle, true)
			setElementAlpha(vehicle, 127)
			setElementCollisionsEnabled(vehicle, false)
			setTimer(setElementCollisionsEnabled, 2000, 1, vehicle, true)
			setTimer(setElementAlpha, 2000, 1, vehicle, 255)
			-- tables for ID -> vehicle and vehicle -> data
			vehicleIDs[ data.vehicleID ] = vehicle
			vehicles[ vehicle ] = { vehicleID = data.vehicleID, respawnInterior = data.respawnInterior, respawnDimension = data.respawnDimension, characterID = data.characterID, engineState = not doesVehicleHaveEngine( vehicle ) or data.engineState == 1, tintedWindows = data.tintedWindows == 1, fuel = data.fuel, km = data.km, pinturas = data.pinturas, motor = data.motor, mejoramotor = data.mejoramotor, frenos = data.frenos, mejorafrenos = data.mejorafrenos, model = data.model }

			setElementHealth( vehicle, data.health )
			if data.health <= 300 then
				vehicles[ vehicle ].engineState = false
			end
			if data.color1 and data.color2 then
				r, g, b = HEX2RGB(data.color1)
				r2, g2, b2 = HEX2RGB(data.color2)
				setVehicleColor( vehicle, r, g, b, r2, g2, b2 )
			end
			if data.color3 then
				r, g, b = HEX2RGB(data.color3)
				setVehicleHeadLightColor ( vehicle, r, g, b )
			end
			setVehiclePlateText(vehicle, tostring(addZero( data.vehicleID, 4 )))
			setVehicleRespawnPosition( vehicle, data.respawnPosX, data.respawnPosY, data.respawnPosZ, data.respawnRotX, data.respawnRotY, data.respawnRotZ )
			setElementInterior( vehicle, data.interior )
			setElementDimension( vehicle, data.dimension )
			if data.alarma == 1 then
				setElementData(vehicle, "havealarm", true)
			end
			setVehicleLocked( vehicle, true )
			setVehicleEngineState( vehicle, false )
			setVehicleOverrideLights( vehicle, data.lightsState + 1 )
			setElementData( vehicle, "fuel", data.fuel )
			if data.cepo == 1 then setVehicleEngineState( vehicle, false ) setElementData( vehicle, "cepo", 1 ) end
			setVehiclePaintjob ( vehicle, data.pinturas )
			setElementData(vehicle, "km", data.km)
			setElementData(vehicle, "idowner", data.characterID)
			setElementData(vehicle, "idveh", data.vehicleID)
			exports.vehicles_auxiliar:applyTunning(vehicle)
			setElementData(vehicle, "model", data.model)
			setElementData(vehicle, "fasemotor", data.fasemotor)
			setElementData(vehicle, "fasefrenos", data.fasefrenos)
			if data.marchas == 1 then
				setElementData(vehicle, "marchas", 1)
			end
			if data.marchas == 0 then
				setElementData(vehicle, "marchas", 0)
			end
			if data.fasemotor > 0 then
				exports.vehicles_auxiliar:solicitarMejora(vehicle, 1, data.fasemotor)
			end
			if data.fasefrenos > 0 then
				exports.vehicles_auxiliar:solicitarMejora(vehicle, 2, data.fasefrenos)
			end
			return true
		end
	end
end

addCommandHandler( { "createvehicle", "makevehicle" },
	function( player, commandName, ... )
		model = table.concat( { ... }, " " )
		model = getVehicleModelFromName( model ) or tonumber( model )
		if model then
			local x, y, z, rz = getPositionInFrontOf( player )
			local vehicle = createVehicle( model, x, y, z, 0, 0, rz )
			if vehicle then
				local r,g,b,r2,g2,b2 = getVehicleColor( vehicle )
				local luz1, luz2, luz3 = getVehicleHeadLightColor ( vehicle )
				local c1 = RGB2HEX (r or 255, g or 255, b or 255)
				local c2 = RGB2HEX (r2 or 255, g2 or 255, b2 or 255)
				local c3 = RGB2HEX (luz1 or 255, luz2 or 255, luz3 or 255)			
				local vehicleID, error = exports.sql:query_insertid("INSERT INTO vehicles (model, posX, posY, posZ, rotX, rotY, rotZ, color1, color2, color3, respawnPosX, respawnPosY, respawnPosZ, respawnRotX, respawnRotY, respawnRotZ, interior, dimension, respawnInterior, respawnDimension, numberplate) VALUES (" .. table.concat( { model, x, y, z, 0, 0, rz,"'".. c1 .."'", "'".. c2 .."'", "'".. c3 .."'", x, y, z, 0, 0, rz, getElementInterior( player ), getElementDimension( player ), getElementInterior( player ), getElementDimension( player ), "'".. getVehiclePlateText( vehicle ) .."'" }, ", " ) .. ")" )
				if vehicleID then
					-- tables for ID -> vehicle and vehicle -> data
					vehicleIDs[ vehicleID ] = vehicle
					vehicles[ vehicle ] = { vehicleID = vehicleID, respawnInterior = getElementInterior( player ), respawnDimension = getElementDimension( player ), characterID = 0, engineState = false, tintedWindows = false, fuel = 100 }				
					-- some properties
					setElementInterior( vehicle, getElementInterior( player ) )
					setElementDimension( vehicle, getElementDimension( player ) )
					setVehicleEngineState( vehicle, false )
					setVehicleOverrideLights( vehicle, 1 )
				    setElementData(vehicle, "idveh", vehicleID)						
					setElementData( vehicle, "fuel", 100 )
					setElementData( vehicle, "km", 0 )
					setElementData( vehicle, "marchas", 0 )
					setVehiclePlateText(vehicle, vehicleID)
					
					exports.vehicles_auxiliar:saveColors(vehicle)
					-- success message
					outputChatBox( "Has creado un " .. getVehicleName( vehicle ) .. " con el ID " .. vehicleID .. ".", player, 0, 255, 0 )
				else
					destroyElement( vehicle )
					outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "El nombre del vehículo es incorrecto. Vuelve a intentarlo.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [modelo]", player, 255, 255, 255 )
		end
	end,
	true
)

function createVehicleFromConce( player, model2 )
	if isElement( player ) then
		local characterID = exports.players:getCharacterID( player )
		if characterID then
		    local vehicle = createVehicle(tonumber(model2), 1779.1943359375, 112.126953125, 34.458763122559, 359.8681640625, 359.99450683594, 159.97192382812)
			local model = getElementModel( vehicle )
			local x, y, z = getElementPosition( vehicle )
			local rx, ry, rz = getVehicleRotation( vehicle )
			local interior = getElementInterior( vehicle )
			local dimension = getElementDimension( vehicle )
			local r,g,b,r2,g2,b2 = getVehicleColor( vehicle )
			local luz1, luz2, luz3 = getVehicleHeadLightColor ( vehicle )
			local c1 = RGB2HEX (r or 255, g or 255, b or 255)
			local c2 = RGB2HEX (r2 or 255, g2 or 255, b2 or 255)
			local c3 = RGB2HEX (luz1 or 255, luz2 or 255, luz3 or 255)
			local vehicleID, error = exports.sql:query_insertid("INSERT INTO vehicles (model, posX, posY, posZ, rotX, rotY, rotZ, color1, color2, color3, respawnPosX, respawnPosY, respawnPosZ, respawnRotX, respawnRotY, respawnRotZ, interior, dimension, respawnInterior, respawnDimension, numberplate, characterID) VALUES (" .. table.concat( { model, x, y, z, 0, 0, rz,"'".. c1 .."'", "'".. c2 .."'", "'".. c3 .."'", x, y, z, 0, 0, rz, getElementInterior( player ), getElementDimension( player ), getElementInterior( player ), getElementDimension( player ), "'".. getVehiclePlateText( vehicle ) .."'", characterID }, ", " ) .. ")" )
			if vehicleID then
				local newVehicle = createVehicle( model, x, y, z, rx, ry, rz, getVehiclePlateText( vehicle ) )
				setElementFrozen(newVehicle, true)
				setElementData( player, "vehicleIDa", vehicleID )
				destroyElement ( vehicle )
				-- tables for ID -> vehicle and vehicle -> data
				vehicleIDs[ vehicleID ] = newVehicle
				vehicles[ newVehicle ] = { vehicleID = vehicleID, respawnInterior = interior, respawnDimension = dimension, characterID = characterID, engineState = false, tintedWindows = false, fuel = 100 }
				
				-- some properties
				setVehicleColor( newVehicle, r,g,b,r2,g2,b2 ) -- most vehicles don't use second/third color anyway
				setVehicleHeadLightColor ( newVehicle, luz1,luz2,luz3 )
				setVehicleRespawnPosition( newVehicle, x, y, z, rx, ry, rz )
				setElementInterior( newVehicle, interior )
				setElementDimension( newVehicle, dimension )
				setVehicleEngineState( newVehicle, false )
				setVehicleOverrideLights( newVehicle, 1 )			
				setElementData(newVehicle, "fuel", 100 )
				setElementData(newVehicle, "km", 0 )
				setElementData(newVehicle, "fasemotor", 0 )
				setElementData(newVehicle, "fasefrenos", 0 )
				setElementData(newVehicle, "marchas", 0 )
				setElementData(newVehicle, "idveh", vehicleID)
				setElementData(newVehicle, "idowner", characterID)
				setVehiclePlateText(newVehicle, vehicleID)
				exports.vehicles_auxiliar:saveColors(newVehicle)
				return newVehicle, vehicleID
			end
		end
	end
end
addEvent("generarVehiculo", true)
addEventHandler("generarVehiculo", root, createVehicleFromConce)

addCommandHandler( { "deletevehicle", "delvehicle" },
	function( player, commandName, vehicleID )
		if hasObjectPermissionTo( player, "command.createvehicle", false ) or hasObjectPermissionTo( player, "command.temporaryvehicle", false ) then
			vehicleID = tonumber( vehicleID )
			if vehicleID and vehicleID ~= 0 then
				if ( vehicleID >= 0 and not hasObjectPermissionTo( player, "command.createvehicle", false ) ) or ( vehicleID < 0 and not hasObjectPermissionTo( player, "command.temporaryvehicle", false ) ) then
					outputChatBox( "No puedes borrar este vehículo.", player, 255, 0, 0 )
				else
					local vehicle = vehicleIDs[ vehicleID ]
					if vehicle then
						if vehicleID < 0 or exports.sql:query_free( "DELETE FROM vehicles WHERE vehicleID = " .. vehicleID ) then
							outputChatBox( "Has borrado el vehículo con ID " .. vehicleID .. " (" .. getVehicleName( vehicle ) .. ").", player, 0, 255, 153 )
							if vehicleID > 0 then
								exports.logs:addLogMessage("delveh", "Vehículo ID "..vehicleID.. ", borrado por "..getPlayerName(player)..".\n")
							end
							-- remove from vehicles list
							vehicleIDs[ vehicleID ] = nil
							vehicles[ vehicle ] = nil
							
							destroyElement( vehicle )
						else
							outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
						end
					else
						outputChatBox( "Vehículo no encontrado.", player, 255, 0, 0 )
					end
				end
			else
				outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
			end
		end
	end
)

function deleteVehicle ( vehicle )
	if not vehicle then return end
	local data = vehicles[ vehicle ]
	vehicleID = tonumber( data.vehicleID )
	if vehicleID then
		if vehicleID < 0 or exports.sql:query_free( "DELETE FROM vehicles WHERE vehicleID = " .. vehicleID ) then
			vehicleIDs[ vehicleID ] = nil
			vehicles[ vehicle ] = nil	
			destroyElement( vehicle )
			return true
		else
			return false
		end
	else
		return false
	end
end

function isVehiculoRobado(vehicle)
	local vehicleID = getElementData(vehicle, "idveh")
	local sql = exports.sql:query_assoc("SELECT fecha FROM robos WHERE tipo = 1 AND objetoID = " .. vehicleID )
	local time = getRealTime()
	for k, v in ipairs(sql) do
		if v and v.fecha then
			return true
		end
	end
end

addCommandHandler( { "repairvehicle", "fixvehicle" },
	function( player, commandName, otherPlayer )
		if otherPlayer then
			target, targetName = exports.players:getFromName( player, otherPlayer )
		else
			target = player
			targetName = getPlayerName( player ):gsub( "_", " " )
		end
		if exports.players:getOption( player, "staffduty" ) == true then
			if target then
				local vehicle = getPedOccupiedVehicle( target )
				if vehicle then			
					if getElementData(vehicle, "cepo") and getElementData(vehicle, "cepo") == 1 then outputChatBox("No puedes reparar un vehículo que tiene un cepo.", player, 255, 0, 0) return end
					fixVehicle( vehicle )
					exports.vehicles_auxiliar:resolicitarMejora( vehicle, true )
					removeElementData( vehicle, "pinchado" )
					outputChatBox( "Has reparado el vehículo de  " .. targetName .. ".", player, 0, 255, 153 )
					outputChatBox( "Tu vehículo ha sido reparado por " .. getPlayerName( player ):gsub( "_", " " ) .. ".", target, 0, 255, 153 )
				    --staffMessageAdmin("El Staff "..getPlayerName( player ):gsub( "_", " " ) .." ha reparado administrativamente el coche de "..getPlayerName( target ):gsub( "_", " " ) ..".")
				else
					outputChatBox( targetName .. " no esta en un vehículo.", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox("Para poder reparar un vehículo debes de estar en servicio (/staffduty)", player, 255, 0, 0)
		end
	end,
	true
)

addCommandHandler( { "repairvehicles", "fixvehicles" },
	function( player, commandName )
		for k, vehicle in pairs( getElementsByType("vehicle") ) do
			if not getElementData(vehicle, "cepo") then
				fixVehicle( vehicle )
			end
		end
		outputChatBox( "[Administración] " .. getPlayerName( player ):gsub( "_", " " ) .. " ha reparado todos los vehículos.", root, 0, 255, 153 )
	end,
	true
)

addCommandHandler( { "fillvehicles", "fuelvehicles", "refillvehicles" },
	function( player, commandName )
		for vehicle, data in pairs( vehicles ) do
			if doesVehicleHaveFuel( vehicle ) and getElementData( vehicle, "fuel" ) < 100 then
				data.fuel = 100
				setElementData( vehicle, "fuel", data.fuel )
			end
		end
		outputChatBox( "[Administración]: " .. getPlayerName( player ):gsub( "_", " " ) .. " ha rellenado todos los vehículos.", root, 0, 255, 153 )
	end,
	true
)
 
addCommandHandler( { "respawnvehicle", "regenerarvehicle", "rv" },
	function( player, commandName, vehicleID )
		vehicleID = tonumber( vehicleID )
		if vehicleID then
			local vehicle = vehicleIDs[ vehicleID ]
			if vehicle then
				if vehicleID > 0 then
					if getElementData(vehicle, "cepo") then
						outputChatBox("El vehículo tiene un cepo puesto, vehículo regenerado en depósito (o donde estaba).", player, 255, 0, 0)
						fixVehicle(vehicle)
						return
					else
						respawnVehicle( vehicle )
						if not getElementData(vehicle, "tapada") == true then
							setVehiclePlateText(vehicle, tostring(addZero(tostring(vehicleID), 4)))
						else
							setVehiclePlateText(vehicle, "TAPADA")
						end
						saveVehicle( vehicle )
						setElementFrozen( vehicle, true )
						for seat, occupant in pairs(getVehicleOccupants(vehicle)) do
							setElementDimension(occupant, getElementDimension(vehicle))
							setElementInterior(occupant, getElementInterior(vehicle))
						end
					end
				end
				outputChatBox( "Regenerastes el vehiculo con el ID " .. vehicleID .. " (" .. getVehicleName( vehicle ) .. ").", player, 0, 255, 153 )
			else
				local sql = exports.sql:query_assoc_single("SELECT vehicleID FROM vehicles WHERE vehicleID = "..vehicleID)
				if sql and tonumber(sql.vehicleID) then
					outputChatBox("Este vehículo está marcado como inactivo. Usa /activo.", player, 255, 0, 0)
				else
					outputChatBox("Este vehículo no existe.", player, 255, 0, 0)
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( { "respawnvehicles", "regenerarvehicles", "rvs" },
	function( player, commandName )
	setTimer (
    function ( )
		outputChatBox( "[Administración]: Todos los vehículos se regeneraron con éxito.", root, 0, 255, 153 )
		for vehicle, data in pairs( vehicles ) do
			if isVehicleEmpty( vehicle ) then
				if data.vehicleID < 0 then
					vehicleIDs[ data.vehicleID ] = nil
					vehicles[ vehicle ] = nil					
					destroyElement( vehicle )
				else
					if not getElementData(vehicle, "cepo") then
						respawnVehicle( vehicle )
						setElementFrozen( vehicle, true )
						for seat, occupant in pairs(getVehicleOccupants(vehicle)) do
							setElementDimension(occupant, getElementDimension(vehicle))
							setElementInterior(occupant, getElementInterior(vehicle))
						end
					end
				end
			end
		end
	 end
    ,10000, 1
    )

		outputChatBox( "[Administración]: " .. getPlayerName( player ):gsub( "_", " " ) .. " ha activado la regeneración.", root, 0, 255, 153 )
		outputChatBox( "[Administración]: Todos los vehiculos reaparecerán en 10 segundos.", root, 0, 255, 153 )
	end,
	true
)

function aparcarVehiculo ( player, seat, jack )
	if source and player and seat == 0 and not jack then
	local vehicle = source
	if vehicle then
		local data = vehicles[ vehicle ]
		if data then
			if data.characterID > 0 and not ( models [ getElementModel ( vehicle ) ] ) then
				local x, y, z = getElementPosition( vehicle )
				local rx, ry, rz = getVehicleRotation( vehicle )
				local success, error = exports.sql:query_free( "UPDATE vehicles SET respawnPosX = " .. x .. ", respawnPosY = " .. y .. ", respawnPosZ = " .. z .. ", respawnRotX = " .. rx .. ", respawnRotY = " .. ry .. ", respawnRotZ = " .. rz .. ", respawnInterior = " .. getElementInterior( vehicle ) .. ", respawnDimension = " .. getElementDimension( vehicle ) .. " WHERE vehicleID = " .. data.vehicleID )
				if success then
					setVehicleRespawnPosition( vehicle, x, y, z, rx, ry, rz )
					data.respawnInterior = getElementInterior( vehicle )
					data.respawnDimension = getElementDimension( vehicle )
					saveVehicle( vehicle )
				end
			end
		end
	end
	end
end
addEventHandler ( "onVehicleExit", getRootElement(), aparcarVehiculo )

function aparcarAlIrse(tipo, razon, source)		
	if source and getPedOccupiedVehicle(source) and getPedOccupiedVehicleSeat(source) == 0 then
	local vehicle = getPedOccupiedVehicle(source)
	local data = vehicles[ vehicle ]
		if data then
			if data.characterID > 0  and not ( models [ getElementModel ( vehicle ) ] ) then
				local x, y, z = getElementPosition( vehicle )
				local rx, ry, rz = getVehicleRotation( vehicle )
				local success, error = exports.sql:query_free( "UPDATE vehicles SET respawnPosX = " .. x .. ", respawnPosY = " .. y .. ", respawnPosZ = " .. z .. ", respawnRotX = " .. rx .. ", respawnRotY = " .. ry .. ", respawnRotZ = " .. rz .. ", respawnInterior = " .. getElementInterior( vehicle ) .. ", respawnDimension = " .. getElementDimension( vehicle ) .. " WHERE vehicleID = " .. data.vehicleID )
				if success then
					setVehicleRespawnPosition( vehicle, x, y, z, rx, ry, rz )
					data.respawnInterior = getElementInterior( vehicle )
					data.respawnDimension = getElementDimension( vehicle )
					saveVehicle( vehicle )
				end
			end
		end		
	end
	if p[ source ] then
		p[ source ].vehicle = nil
	end
end
addEventHandler("onPlayerQuit", getRootElement(), aparcarAlIrse)

function parkStaff (player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle and getPedOccupiedVehicleSeat(player) == 0 then
	local data = vehicles[ vehicle ]
		if data then
			if hasObjectPermissionTo( player, "command.modchat", false ) then
				local x, y, z = getElementPosition( vehicle )
				local rx, ry, rz = getVehicleRotation( vehicle )
				local success, error = exports.sql:query_free( "UPDATE vehicles SET respawnPosX = " .. x .. ", respawnPosY = " .. y .. ", respawnPosZ = " .. z .. ", respawnRotX = " .. rx .. ", respawnRotY = " .. ry .. ", respawnRotZ = " .. rz .. ", respawnInterior = " .. getElementInterior( vehicle ) .. ", respawnDimension = " .. getElementDimension( vehicle ) .. " WHERE vehicleID = " .. data.vehicleID )
				if success then
					setVehicleRespawnPosition( vehicle, x, y, z, rx, ry, rz )
					data.respawnInterior = getElementInterior( vehicle )
					data.respawnDimension = getElementDimension( vehicle )
					saveVehicle( vehicle, true ) 
					outputChatBox("Has dado park al vehículo correctamente.", player, 0, 255, 0)
				end
			end 
		end		
	end
end
addCommandHandler("parkstaff", parkStaff)
 
addCommandHandler( "getvehicle",
	function( player, commandName, vehicleID )
		vehicleID = tonumber( vehicleID )
		if vehicleID then
			local vehicle = vehicleIDs[ vehicleID ]
			if vehicle then
				local x, y, z, rz = getPositionInFrontOf( player )
				setElementPosition( vehicle, x, y, z )
				setElementDimension( vehicle, getElementDimension( player ) )
				setElementInterior( vehicle, getElementInterior( player ) )
				setVehicleRotation( vehicle, 0, 0, rz )
				outputChatBox( "Has teletransportado el vehiculo " .. vehicleID .. " (" .. getVehicleName( vehicle ) .. ") hacia ti.", player, 0, 255, 153 )
				-- Un /getveh no debería de solicitar un park automático...
				-- save the vehicle delayed since it might fall down/position might be adjusted to ground position
				--if vehicleID > 0 then
					--setTimer( saveVehicle, 2000, 1, vehicle )
				--end
			else
				local sql = exports.sql:query_assoc_single("SELECT inactivo, cepo FROM vehicles WHERE vehicleID = "..vehicleID)
				if sql then
					if tonumber(sql.cepo) == 1 then
						outputChatBox("Este vehículo tiene un cepo policial.", player, 255, 0, 0)
					elseif tonumber(sql.inactivo) == 1 then
						outputChatBox("Este vehículo está marcado como inactivo. Usa /activo.", player, 255, 0, 0)
					end
				else
					outputChatBox("Este vehículo no existe.", player, 255, 0, 0)
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "gotovehicle",
	function( player, commandName, vehicleID )
		vehicleID = tonumber( vehicleID )
		if vehicleID then
			local vehicle = vehicleIDs[ vehicleID ]
			if vehicle then
				local x, y, z, rz = getPositionInFrontOf( vehicle )
				setElementPosition( player, x, y, z )
				setElementDimension( player, getElementDimension( vehicle ) )
				setElementInterior( player, getElementInterior( vehicle ) )
				outputChatBox( "Te has teletransportado a " .. vehicleID .. " (" .. getVehicleName( vehicle ) .. ").", player, 0, 255, 153 )
				
				-- save the vehicle delayed since it might fall down/position might be adjusted to ground position
				if vehicleID > 0 then
					setTimer( saveVehicle, 2000, 1, vehicle )
				end
			else
				local sql = exports.sql:query_assoc_single("SELECT inactivo, cepo FROM vehicles WHERE vehicleID = "..vehicleID)
				if sql then
					if tonumber(sql.cepo) == 1 then
						outputChatBox("Este vehículo tiene un cepo policial.", player, 255, 0, 0)
					elseif tonumber(sql.inactivo) == 1 then
						outputChatBox("Este vehículo está marcado como inactivo. Usa /activo.", player, 255, 0, 0)
					end
				else
					outputChatBox("Este vehículo no existe.", player, 255, 0, 0)
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( { "vehicleid", "thisvehicle" },
	function( player, commandName )
		local vehicle = getPedOccupiedVehicle( player )
		if vehicle then
			local vehicleID = vehicles[ vehicle ] and vehicles[ vehicle ].vehicleID
			if vehicleID then
				outputChatBox( "El ID de este " .. getVehicleName( vehicle ) .. " es " .. vehicleID .. ".", player, 0, 255, 0 )
			else
				outputChatBox( "Este " .. getVehicleName( vehicle ) .. " no tiene ID.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "No estas en ningún vehiculo.", player, 255, 0, 0 )
		end
	end
)

addCommandHandler( { "oldvehicleid", "oldvehicle" },
	function( player, commandName )
		local vehicleID = getElementData(player, "aVehiculo")
		if vehicleID then
			if getVehicle(vehicleID) then
				outputChatBox( "El ID de tu anterior " .. getVehicleName( getVehicle(vehicleID) ) .. " es " .. tostring(vehicleID) .. ".", player, 0, 255, 0 )
			else
				outputChatBox( "El ID de tu anterior vehículo es " .. tostring(vehicleID) .. ".", player, 0, 255, 0 )
			end
		else
			outputChatBox( "No se ha podido encontrar el ID de tu anterior vehículo.", player, 255, 0, 0 )
		end
	end
)

addCommandHandler( { "setvehiclecolor", "setcolor" },
    function( player, commandName, other, r, g, b, r2, g2, b2 )
        if ( other and r and g and b and r2 and g2 and b2 ) then
            local other, name = exports.players:getFromName( player, other )
			if other then
				local vehicle = getPedOccupiedVehicle( other )
				if vehicle then
                    local data = vehicles [ vehicle ]
                    if ( data ) then
                        setVehicleColor ( vehicle, r, g, b, r2, g2, b2 )
                        outputChatBox ( "Cambiaste el color de " .. name .. " al vehiculo: " .. getVehicleName ( vehicle ) .. ".", player, 0, 255, 153 )
						exports.vehicles_auxiliar:saveColors(vehicle)
					else
                        outputChatBox ( "El vehículo no existe.", player, 255, 0, 0 )
                    end
                else
                    outputChatBox ( name .. " no está en un vehículo.", player, 255, 0, 0 )
                end
            end
        else
            outputChatBox ( "Syntax: /" .. commandName .. " [player] [r] [g] [b] [r2] [g2] [b2]", player, 255, 255, 255 )
        end
    end,
    true
)

addCommandHandler( "setvehiclefaction",
	function( player, commandName, other, faction )
		local faction = tonumber( faction )
		if other and faction and ( faction == 0 or exports.factions:getFactionName( faction ) ) then
			local other, name = exports.players:getFromName( player, other )
			if other then
				local vehicle = getPedOccupiedVehicle( other )
				if vehicle then
					local data = vehicles[ vehicle ]
					if data then
						if data.vehicleID > 0 then
							if exports.sql:query_free( "UPDATE vehicles SET characterID = " .. -faction .. " WHERE vehicleID = " .. data.vehicleID ) then
								data.characterID = -faction
								outputChatBox( "El " .. getVehicleName( vehicle ) .. " de "..name.." ahora pertenece a " .. ( faction == 0 and "ninguna faction" or exports.factions:getFactionName( faction ) ) .. ".", player, 0, 255, 153 )
							else
								outputChatBox( "Error en la base de datos.", player, 255, 0, 0 )
							end
						end
					else
						outputChatBox( "Se ha producido un error. Contacta con un Developer.", player, 255, 0, 0 )
					end
				else
					outputChatBox( name .. " no está en un vehículo.", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [faction or 0 for no faction]", player, 255, 255, 255 )
		end
	end,
	true
)

function saveVehicle( vehicle, force )
	if vehicle then
		if models [getElementModel(vehicle)] and not force then return false end
		if getOwner(vehicle) and getOwner(vehicle) <= -1 and not force then return end
		local data = vehicles[ vehicle ]
		if data and data.vehicleID > 0 then
			local x, y, z = getElementPosition( vehicle )
			local rx, ry, rz = getVehicleRotation( vehicle )
			local km = getElementData(vehicle, "km")
			local success, error = exports.sql:query_free( "UPDATE vehicles SET respawnPosX = " .. x .. ", respawnPosY = " .. y .. ", respawnPosZ = " .. z .. ", respawnRotX = " .. rx .. ", respawnRotY = " .. ry .. ", respawnRotZ = " .. rz .. ", respawnInterior = " .. getElementInterior( vehicle ) .. ", respawnDimension = " .. getElementDimension( vehicle ) .. ", posX = " .. x .. ", km = " .. km .. ", posY = " .. y .. ", posZ = " .. z .. ", rotX = " .. rx .. ", rotY = " .. ry .. ", rotZ = " .. rz .. ", health = " .. math.min( 1000, math.ceil( getElementHealth( vehicle ) ) ) .. ", interior = " .. getElementInterior( vehicle ) .. ", dimension = " .. getElementDimension( vehicle ) .. ", fuel = " .. data.fuel .. " WHERE vehicleID = " .. data.vehicleID )	
		end  
	end
end

addEventHandler( "onResourceStop", resourceRoot,
	function( )	
		for k, v in pairs( getElementsByType("vehicle") ) do
			saveVehicle( v )
		end
		vehicles = { }
		vehicleIDs = { }
	end
)

addEventHandler( "onVehicleRespawn", resourceRoot,
	function( )
		local data = vehicles[ source ]
		if data and data.vehicleID > 0 then
			setElementInterior( source, data.respawnInterior )
			setElementDimension( source, data.respawnDimension )
			saveVehicle( source )
		end
	end
)

addEventHandler( "onPlayerJoin", root,
	function( )
		bindKey( source, "num_3", "down", "lockvehicle" )
		bindKey( source, "num_1", "down", "toggleengine" )
		bindKey( source, "num_2", "down", "togglelights" )
		bindKey( source, "num_0", "down", toggleFreezeStatus )
		bindKey( source, "n", "down", toggleFreezeStatus )
		bindKey( source, "k", "down", "lockvehicle" )
		bindKey( source, "j", "down", "toggleengine" )
		bindKey( source, "l", "down", "togglelights" )
		bindKey( source, "c", "down", "cinturon" )
	end
)

addEventHandler( "onElementDestroy", resourceRoot,
	function( )
		if vehicles[ source ] then
			vehicleIDs[ vehicles[ source ].vehicleID ] = nil
			vehicles[ source ] = nil
		end
	end
)

addEventHandler( "onVehicleStartEnter", resourceRoot,
	function( player )
		if isVehicleLocked( source ) then
		  if getVehicleType(source) == "Automobile" then
			exports.chat:me( player, "intenta abrir la puerta del " ..getVehicleName ( source ).. " y no puede porque está cerrada." )
		  elseif getVehicleType(source) == "Bike" or getVehicleType(source) == "BMX" then
			exports.chat:me( player, "intenta subirse a la " ..getVehicleName ( source ).. " y no puede porque tiene la funda puesta." )
		  elseif getVehicleType(source) == "Boat" then
			exports.chat:me( player, "intenta entrar en la cabina del " ..getVehicleName ( source ).. " y no puede porque está cerrada." )
		  end
		  cancelEvent( )
		end
	end
)

addEventHandler( "onVehicleEnter", resourceRoot,
	function( player )
		if isVehicleLocked( source ) then
			cancelEvent( )
			removePedFromVehicle( player )
			setElementFrozen(source, true)
			if getVehicleType(source) == "Automobile" then
				outputChatBox( "(( Este " .. getVehicleName( source ) .. " está cerrado. ))", player, 255, 0, 0 )
			elseif getVehicleType(source) == "BMX" or getVehicleType(source) == "Bike" then
				outputChatBox( "(( Esta " .. getVehicleName( source ) .. " está cerrada. ))", player, 255, 0, 0 )
			end
		else
			--triggerEvent("onStopAlarm", source, source)
			local data = vehicles[ source ]
			if data then
				exports.vehicles_auxiliar:resolicitarMejora(source)
				if data.characterID > 0 then
					local name = exports.players:getCharacterName( data.characterID )
					if name then
						--setTimer(triggerClientEvent, 2500, 1, player, "gui:hint", player, "         Este  "..getVehicleName(source), "          Pertenece a " .. name .. ".", 1 )
						triggerClientEvent( player, "gui:hint", player, "         Este  "..getVehicleName(source), "          Pertenece a " .. name .. ".", 4 )
					else
						outputDebugString( "Vehiculo con ID " .. data.vehicleID .. " (" .. getVehicleName( source ) .. ") pertenece a un personaje borrado.", 3 )
					end
				elseif data.characterID < 0 then
					triggerClientEvent( player, "gui:hint", player, "          Este "..getVehicleName(source), "          Pertenece a " .. tostring( exports.factions:getFactionName( -data.characterID ) )..".", 1 )
				end
				if not p[ player ] then
					p[ player ] = { }
				end
				p[ player ].vehicle = source
				setVehicleEngineState( source, not doesVehicleHaveEngine( source ) or data.engineState )
			end
			if getVehicleType(source) == "BMX" or getVehicleType(source) == "Bike" and player then
					toggleControl(player, "vehicle_secondary_fire", false)
					toggleControl(player, "steer_forward", false)
			else
				if player and getElementType(player) == "player" then
					toggleControl(player, "vehicle_secondary_fire", true)
					toggleControl(player, "steer_forward", true)
				end
			end
			setElementData(player, "inVehicle", true)
		end
	end
)

addEventHandler( "onVehicleExit", resourceRoot,
	function( player, seat )
		if source then
			if seat and seat == 0 then
				setElementData(source, "aConductor", getPlayerName(player))
			end
			setElementData(player, "aVehiculo", getElementData(source, "idveh"))
		end
		if p[ source ] then
			p[ source ].vehicle = nil
		end
		removeElementData(player, "inVehicle")
	end
)

function ultimoConductor (player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then outputChatBox("Debes de estar subido en un vehículo.", player, 255, 0, 0) return end
	if not getElementData(vehicle, "aConductor") then outputChatBox("No hay datos registrados del último conductor de este vehículo.", player, 255, 0, 0) return end
	local name = getElementData(vehicle, "aConductor"):gsub("_", " ")
	if name then
		outputChatBox("El último conductor de este vehículo fue: "..name, player, 0, 255, 0)
	else
		outputChatBox("No hay datos registrados del último conductor de este vehículo.", player, 255, 0, 0)
	end
end
addCommandHandler("ultimoconductor", ultimoConductor)
addCommandHandler("uc", ultimoConductor)

function ultimoGolpeador (player)
	local vehicle = getPedOccupiedVehicle(player)
	if not vehicle then outputChatBox("Debes de estar subido en un vehículo.", player, 255, 0, 0) return end
	if not getElementData(vehicle, "aGolpeador") then outputChatBox("No hay datos registrados del último conductor de este vehículo.", player, 255, 0, 0) return end
	local name = getElementData(vehicle, "aGolpeador"):gsub("_", " ")
	if name then
		outputChatBox("El último que golpeó este vehículo fue: "..name, player, 0, 255, 0)
	else
		outputChatBox("No hay datos registrados del último que golpeó este vehículo.", player, 255, 0, 0)
	end
end
addCommandHandler("ultimogolpe", ultimoGolpeador)
addCommandHandler("ug", ultimoGolpeador)

addEventHandler( "onPlayerWasted", root,
	function( )
		if p[ source ] then
			p[ source ].vehicle = nil
		end
	end
)

local function lockVehicle( player, vehicle, driver )
	local vehicleID = vehicles[ vehicle ] and vehicles[ vehicle ].vehicleID
	if vehicleID and ( vehicleID < 0 or exports.sql:query_free( "UPDATE vehicles SET locked = 1 - locked WHERE vehicleID = " .. vehicleID ) ) then
		triggerEvent("onStopAlarm", vehicle, vehicle)
		if getElementData(vehicle, "forcelock") then
			outputChatBox("Por alguna razón, este vehículo tiene forzado el cierre.", player, 255, 0, 0)
			return
		end
		if driver then
			if getVehicleType(vehicle) == "Bike" or getVehicleType(vehicle) == "BMX" or getVehicleType(vehicle) == "Quad" then
				outputChatBox("No puedes poner una funda a este vehículo estando subido a él", player, 255, 0, 0)
				return false
			elseif getVehicleType(vehicle) == "Automobile" then
				exports.chat:me( player, ( isVehicleLocked( vehicle ) and "abre" or "cierra" ) .. " las puertas del vehículo." )
			elseif getVehicleType(vehicle) == "Helicopter" then
				exports.chat:me( player, ( isVehicleLocked( vehicle ) and "abre" or "cierra" ) .. " el helicóptero." )
			elseif getVehicleType(vehicle) == "Boat" then
				exports.chat:me( player, ( isVehicleLocked( vehicle ) and "abre" or "cierra" ) .. " la cabina del barco." )
			elseif getVehicleType(vehicle) == "Monster Truck" then
				exports.chat:me( player, ( isVehicleLocked( vehicle ) and "abre" or "cierra" ) .. " la cabina del camión." )
			end
		else
			if getVehicleType(vehicle) == "Bike" or getVehicleType(vehicle) == "BMX" or getVehicleType(vehicle) == "Quad" then
				exports.chat:me( player, "coge la funda y la " .. ( isVehicleLocked( vehicle ) and "quita de" or "pone en" ) .. " su " .. getVehicleName( vehicle ) .. "." )
			elseif getVehicleType(vehicle) == "Automobile" then
				exports.chat:me( player, "presiona el boton de sus llaves y " .. ( isVehicleLocked( vehicle ) and "abre" or "cierra" ) .. " su " .. getVehicleName( vehicle ) .. "." )
			elseif getVehicleType(vehicle) == "Helicopter" then
				exports.chat:me( player, ( isVehicleLocked( vehicle ) and "abre" or "cierra" ) .. " el helicóptero." )
			elseif getVehicleType(vehicle) == "Boat" then
				exports.chat:me( player, ( isVehicleLocked( vehicle ) and "abre" or "cierra" ) .. " la cabina del barco." )
			elseif getVehicleType(vehicle) == "Monster Truck" then
				exports.chat:me( player, ( isVehicleLocked( vehicle ) and "abre" or "cierra" ) .. " la cabina del camión." )
			end
		end
		setVehicleLocked( vehicle, not isVehicleLocked( vehicle ) )
		return true
	end
	return false
end

addCommandHandler( "lockvehicle",
	function( player, commandName )
		if exports.players:isLoggedIn( player ) then
			if getElementData( player, "interiorMarker" ) then
				return
			end		
			if isPedEnteringVehicle( player ) then
				return
			end	
			local vehicle = getPedOccupiedVehicle( player )
			local vehicleID = vehicle and vehicles[ vehicle ] and vehicles[ vehicle ].vehicleID
			if vehicleID then
				local driver = getVehicleOccupant( vehicle ) == player
				local pas1 = getVehicleOccupant( vehicle, 1 ) == player
				local pas2 = getVehicleOccupant( vehicle, 2 ) == player
				local pas3 = getVehicleOccupant( vehicle, 3 ) == player
				local pas4 = getVehicleOccupant( vehicle, 4 ) == player
				if (driver or pas1 or pas2 or pas3 or pas4 or exports.items:has( player, 1, vehicleID )) or getElementData(player,"account:gmduty") == true or isVehiculoRobado(vehicle) == true then
					lockVehicle( player, vehicle, driver )
					local x, y, z = getElementPosition(vehicle)
				end
			else
				local dimension = getElementDimension( player )
				local minDistance = 20
				local vehicle = nil
				local x, y, z = getElementPosition( player )
				for key, value in pairs( vehicles ) do
					if dimension == getElementDimension( key ) then
						local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( key ) )
						if distance < minDistance then
							if exports.items:has( player, 1, value.vehicleID ) or ( value.characterID < 0 and exports.factions:isPlayerInFaction( player, -value.characterID ) ) or ( models [ getElementModel ( key ) ] ) or getElementData(player,"account:gmduty") == true then
								minDistance = distance
								vehicle = key
							end
						end
					end
				end
				if vehicle then
					lockVehicle( player, vehicle )
					triggerClientEvent("onSonidoMando", player, x, y, z)
					setVehicleOverrideLights(vehicle, 2)
					setTimer(function () setVehicleOverrideLights(vehicle, 1) end, 200, 1)
				end
			end
		end
	end
)

function toggleFreezeStatus ( thePlayer )
	local playerVehicle = getPedOccupiedVehicle ( thePlayer )
	if playerVehicle then
		local playerVehicle = getPedOccupiedVehicle ( thePlayer )
		local sx, sy, sz = getElementVelocity (playerVehicle)
		local velocidad = (sx^2 + sy^2 + sz^2)^(0.5) 
		if tonumber(velocidad*180) <= 2 then
			local currentFreezeStatus = isElementFrozen ( playerVehicle )
			local newFreezeStatus = not currentFreezeStatus
			if getVehicleType(playerVehicle) == "Automobile" then
				if getPedOccupiedVehicleSeat(thePlayer) == 0 or getPedOccupiedVehicleSeat(thePlayer) == 1 then
					if isVehicleOnGround(playerVehicle) then
						exports.chat:me( thePlayer, ( isElementFrozen( playerVehicle ) and "quita" or "pone" ) .. " el freno de mano." )
						setElementFrozen ( playerVehicle, newFreezeStatus )
					else
						outputChatBox("¡No puedes poner el freno de mano si no estás en el suelo!", thePlayer, 255, 0, 0)
					end
				end
			elseif getVehicleType(playerVehicle) == "BMX" or getVehicleType(playerVehicle) == "Bike" then
				exports.chat:me( thePlayer, ( isElementFrozen( playerVehicle ) and "quita" or "pone" ) .. " la pata de cabra." )
				setElementFrozen ( playerVehicle, newFreezeStatus )
			elseif getVehicleType(playerVehicle) == "Boat" then
				exports.chat:me( thePlayer, ( isElementFrozen( playerVehicle ) and "recoge" or "tira" ) .. " el ancla del barco." )
				setElementFrozen ( playerVehicle, newFreezeStatus )
			elseif getVehicleType(playerVehicle) == "Plane" or getVehicleType(playerVehicle) == "Helicopter" then
				exports.chat:me( thePlayer, ( isElementFrozen( playerVehicle ) and "quita" or "pone" ) .. " el seguro anti-despegue." )
				setElementFrozen ( playerVehicle, newFreezeStatus )
			else
				exports.chat:me( thePlayer, ( isElementFrozen( playerVehicle ) and "quita" or "pone" ) .. " el freno de mano." )
				setElementFrozen ( playerVehicle, newFreezeStatus )
			end
		end
	end
end

addCommandHandler( "toggleengine",
	function( player, commandName )
		if exports.players:isLoggedIn( player ) then
			local vehicle = getPedOccupiedVehicle( player )
			if not vehicle then return end
			if getElementData(vehicle, "inTunning") then -- No se ha confirmado el tunning. Recargando tunning.
				exports.vehicles_auxiliar:applyTunning(vehicle)
				outputChatBox("Tunning sin confirmar, modificaciones eliminadas.", player, 255, 0, 0)
				removeElementData(vehicle, "inTunning")
			end
			if getElementData(vehicle, "inVinilos") then -- No se han confirmado los vinilos. Recargando tunning.
				exports.vehicles_auxiliar:applyTunning(vehicle)
				outputChatBox("Vinilos sin confirmar, modificaciones eliminadas.", player, 255, 0, 0)
				removeElementData(vehicle, "inVinilos")
			end
			if vehicle and getVehicleOccupant( vehicle ) == player and doesVehicleHaveEngine( vehicle ) then
				local data = vehicles[ vehicle ]
				if data then
					if data.vehicleID < 0 or exports.sql:query_free( "UPDATE vehicles SET engineState = 1 - engineState WHERE vehicleID = " .. data.vehicleID ) then
						if exports.items:has ( player, 1, data.vehicleID ) or data.vehicleID < 0 or ( data.characterID < 0 and exports.factions:isPlayerInFaction( player, -data.characterID ) ) or ( models [ getElementModel ( vehicle ) ] ) or getElementData(player,"account:gmduty") == true or isVehiculoRobado(vehicle) == true then
							if math.floor( getElementHealth( vehicle ) + 0.5 ) > 359 then
								if data.fuel <= 0 then setVehicleEngineState( vehicle, false ) triggerClientEvent( player, "gui:hint", player, "Sin gasolina", "Tu " .. getVehicleName( vehicle ) .. " No arranca sin gasolina!\nPara que no te vuelva a pasar esto recarga cada un tiempo.", 3 ) return end
								if getElementData( vehicle, "cepo" ) then exports.chat:ame(player, "Vehículo", "Podrias ver que tiene un cepo policial en la rueda.") exports.chat:me( player, "intenta arrancar pero no puede." ) return end
								if getElementData( vehicle, "averiado" ) then exports.chat:ame(player, "Vehículo", "Podrias ver que el motor hace ruidos extraños.") exports.chat:me( player, "intenta arrancar pero no puede." ) return end
								setVehicleEngineState( vehicle, not data.engineState )
								data.engineState = not data.engineState
								exports.chat:me( player, ( data.engineState and "enciende" or "apaga" ) .. " el motor." )
							else
								outputChatBox( "El motor ha reventado.", player, 255, 0, 0 )
							end
						else
							outputChatBox( "No tienes llaves para arrancar este vehículo.", player, 255, 0, 0 )
						end
					end
				end
			end
		end
	end
)

addCommandHandler( "togglelights",
	function( player, commandName )
		if exports.players:isLoggedIn( player ) then
			local vehicle = getPedOccupiedVehicle( player )
			if vehicle and getVehicleOccupant( vehicle ) == player then
				local data = vehicles[ vehicle ]
				if data then
					if data.vehicleID < 0 or exports.sql:query_free( "UPDATE vehicles SET lightsState = 1 - lightsState WHERE vehicleID = " .. data.vehicleID ) then
						setVehicleOverrideLights( vehicle, getVehicleOverrideLights( vehicle ) == 2 and 1 or 2 )
						exports.chat:me( player, ( getVehicleOverrideLights( vehicle ) == 2 and 1 and "enciende" or "apaga" ) .. " las luces." )
					end
				end
			end
		end
	end
)


function getVehicle( vehicleID )
	return vehicleIDs[ vehicleID ] or false
end

function getIDFromVehicle( vehicle )
	return vehicles[ vehicle ] and vehicles[ vehicle ].vehicleID or false
end

function getOwner( vehicle )
	if vehicles[ vehicle ] then
		local owner = vehicles[ vehicle ].characterID
		return owner ~= 0 and owner or false -- false is in that case civilian
	end
end

function toggleLock( player, vehicle )
	return getElementType( player ) == "player" and isElement( vehicle ) and lockVehicle( player, vehicle, false ) or false
end

--
local tempIDCounter = 0
addCommandHandler( { "temporaryvehicle", "tempvehicle", "vehicle" },
	function( player, commandName, ... )
		model = table.concat( { ... }, " " )
		model = getVehicleModelFromName( model ) or tonumber( model )
		if model then
			local x, y, z, rz = getPositionInFrontOf( player )
			
			local vehicle = createVehicle( model, x, y, z, 0, 0, rz )
			if vehicle then
				tempIDCounter = tempIDCounter - 1
				local vehicleID = tempIDCounter
				
				-- tables for ID -> vehicle and vehicle -> data
				vehicleIDs[ vehicleID ] = vehicle
				vehicles[ vehicle ] = { vehicleID = vehicleID, characterID = 0, engineState = true, tintedWindows = false, fuel = 100 }
				
				-- some properties
				setElementInterior(vehicle, getElementInterior( player ) )
				setElementDimension(vehicle, getElementDimension( player ) )
				setVehicleEngineState(vehicle, true )
				setVehicleOverrideLights(vehicle, 1 )
				setElementData(vehicle, "fuel", 100 )
				setElementData(vehicle, "idveh", vehicleID)
		        setElementData(vehicle, "motor", 0 )
		        setElementData(vehicle, "frenos", 0 )
				setElementData(vehicle, "seguro", 0 )
				setElementData(vehicle, "marchas", 0 )
				setElementData(vehicle, "km", 0 )					
				outputChatBox( "Has creado un " .. getVehicleName( vehicle ) .. " temporal con ID " .. vehicleID .. ".", player, 0, 255, 0 )
			else
				outputChatBox( "Modelo incorrecto.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [modelo]", player, 255, 255, 255 )
		end
	end,
	true
)

function increaseFuel( vehicle, amount )
	local data = vehicles[ vehicle ]
	if data and doesVehicleHaveFuel( vehicle ) then
		if data.fuel + amount <= 101 then
			data.fuel = data.fuel + amount
			setElementData( vehicle, "fuel", math.floor( data.fuel + 0.5 ) )
		end
	end
end

local function getStaff( )
	local t = { }
	local r = { }
	for key, value in ipairs( getElementsByType( "player" ) ) do
		if hasObjectPermissionTo( value, "command.modchat", false ) then
			if getElementData(value, "account:gmduty") or getElementData(value, "account:helpduty") then
				t[ #t + 1 ] = value
			end
			r[ #r + 1 ] = value
		end
	end
	if #t and #t > 0 then
		return t
	else
		return r
	end
end

local function staffMessage( message )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, 0, 255, 255 )
	end
end

function staffMessageAdmin( message )
	for key, value in ipairs( getStaff( true ) ) do
		outputChatBox( message, value, 255, 0, 0 )
	end
end

addEventHandler( "onVehicleDamage", root,
	function( loss )
		if getElementHealth( source ) <= 360 then
			setElementHealth( source, 305 )
			setVehicleEngineState( source, false )
			if vehicles[ source ] then
				vehicles[ source ].engineState = false
				if getVehicleOccupant( source ) then
					outputChatBox( "(( El motor ha reventado. ))", getVehicleOccupant( source ), 255, 204, 0 )
				end
			end
		end
	end
)

addEvent("onTakeSS", true)
addEventHandler( "onTakeSS", root,
	function( sX, sY, idv, player )
		if sX and sY and idv and player and not getElementData(player, "ss") == true and idv >= 1 and getElementType(player) == "player" then
			--takePlayerScreenShot(player, sX, sY, tostring(idv).." - "..getPlayerName(player):gsub("_", " "), 30)
			setElementData(player, "ss", true)
			setElementData(getVehicle(idv), "aGolpeador", getPlayerName(player))
			staffMessage("DMCAR: ["..tostring(getElementData(player, "playerid")).."]"..getPlayerName(player):gsub("_", " ").. " ha dañado el vehículo con el ID "..tostring(idv))
			setTimer(function () removeElementData(player, "ss") end, 5000, 1, player)	
		end
	end
)
 
--[[addEventHandler( "onPlayerScreenShot", root,
	function( resource, status, imagen, timestamp, tag )
		if status == "ok" then
		img = fileCreate("/dm/"..tostring(tag).." - "..tostring(timestamp)..".jpg")
		fileWrite(img, imagen)
		fileClose(img)
		end
	end
)]]

addCommandHandler( { "setowner", "cambiarpropietario" },
	function( player, commandName, otherPlayer )
		if exports.players:isLoggedIn( player ) and hasObjectPermissionTo( player, "command.adminchat", false ) then
			local vehicle = getPedOccupiedVehicle( player )
			if vehicle then
				local other, name = exports.players:getFromName( player, otherPlayer )
				local vehicleID = vehicles[ vehicle ] and vehicles[ vehicle ].vehicleID
				local data = vehicles[ vehicle ]
				local characterID = exports.players:getCharacterID( other )
				local characterID = tonumber(characterID)
				if other and vehicleID then
					if data.vehicleID < 0 then 
						outputChatBox( "Error. El vehículo es temporal.", player, 255, 0, 0 )  
					else
						exports.sql:query_free( "UPDATE vehicles SET characterID = " .. characterID .. " WHERE vehicleID = " .. vehicleID )
						exports.items:give( other, 1, vehicleID )
						data.characterID = characterID
						outputChatBox( "El vehiculo " .. getVehicleName( vehicle ) .. " con el ID " .. vehicleID .. " pertenece ahora a " ..getPlayerName( other ):gsub( "_", " " ).. ".", player, 0, 255, 153 )
						setElementData(vehicle, "idowner", tonumber(characterID))
					end
				end
				else
				outputChatBox("No estás en un vehículo", player, 255, 0, 0)
			end
		end
	end
)

function darPapelesOff(player)
	outputChatBox("Comando desactivado. A partir de ahora, deberás de usar /venderveh [jugador] [precio]", player, 255, 255, 255)
end
addCommandHandler("darpapeles", darPapelesOff)
          
addCommandHandler( "vendervehicle",
function( thePlayer, commandName, otherPlayer, cantidad )
	if exports.players:isLoggedIn( thePlayer ) then
	local vehicle = getPedOccupiedVehicle( thePlayer )
	local vehicleID = vehicles[ vehicle ] and vehicles[ vehicle ].vehicleID
	local data = vehicles[ vehicle ]
		if otherPlayer and cantidad and vehicleID and math.ceil( vehicleID ) == vehicleID and vehicleID > 0 then
		local other, name = exports.players:getFromName( thePlayer, otherPlayer )
		local playerID = exports.players:getCharacterID( thePlayer )
			if other then
	 			if player ~= other then
				local otherID = exports.players:getCharacterID( other )
				local x, y, z = getElementPosition( thePlayer )
					if getDistanceBetweenPoints3D( x, y, z, getElementPosition( other ) ) < 25 then
						local owner = exports.vehicles:getOwner( vehicle )
						local ownername = exports.players:getCharacterName( owner )
						if (playerID == owner) or (tonumber(owner)< 0 and exports.factions:isFactionOwner(thePlayer, -1*tonumber(owner))) then
							if tonumber(owner) < 0 and tonumber(owner) ~= -11 and tonumber(owner) ~= -13 and tonumber(owner) ~= -12 then
								outputChatBox( "No eres el propietario del vehículo.", thePlayer, 255, 0, 0 )
								return
							end
							local sql = exports.sql:query_assoc_single("SELECT * FROM prestamos WHERE tipo = 1 AND cantidad > pagado AND objetoID = " .. vehicleID )
							if sql and sql.prestamoID then outputChatBox("¡No puedes vender un vehículo que tiene un préstamo pendiente de pago!", thePlayer, 255, 0, 0) return end
							if exports.vehicles_auxiliar:isModelVIP(getVehicleName(vehicle)) and not hasObjectPermissionTo(other, 'command.vip', false) then
								outputChatBox("¡Este vehículo es VIP, y solo puedes venderlo a otro usuario VIP!", thePlayer, 180, 0, 255)
								return
							end
							if tonumber(cantidad) < 1000 then
								outputChatBox("¡Debes de vender tu vehículo al menos por $1000!", thePlayer, 255, 0, 0)
								return
							end
							local vehicleOther = getPedOccupiedVehicle(other)
							if not vehicleOther or vehicle ~= vehicleOther then outputChatBox("¡El comprador debe de estar subido en el vehículo!", thePlayer, 255, 0, 0) return end
							local dineroActual = exports.bank:getDinero(other)
							if tonumber(dineroActual) < tonumber(cantidad) then
								outputChatBox("¡El comprador no tiene tanto dinero en su cuenta bancaria!", thePlayer, 255, 0, 0)
								outputChatBox("¡No tienes tanto dinero en tu cuenta bancaria!", other, 255, 0, 0)
								return
							end
							outputChatBox( "Has ofrecido tu "..getVehicleName(vehicle).." con matrícula " .. vehicleID .. " a " .. name .. " por $"..tostring(cantidad)..". Espera a que acepte la compra.", thePlayer, 0, 255, 0 )
							outputChatBox( getPlayerName( thePlayer ):gsub( "_", " " ) .. " te ha ofrecido su "..getVehicleName(vehicle).." con matrícula " .. vehicleID .. " por $"..tostring(cantidad)..". Utiliza /comprarveh para autorizar la compra.", other, 0, 255, 0 )
							setElementData(vehicle, "precioVenta", tonumber(cantidad))
							setElementData(vehicle, "playerVendedor", tostring(getPlayerName(thePlayer)))
						else
							outputChatBox( "No eres el propietario del vehículo.", thePlayer, 255, 0, 0 )
						end
					else
						outputChatBox( "Estas demasiado lejos de " .. name .. ".", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "No puedes venderte un vehículo a ti mismo.", thePlayer, 255, 0, 0 )
				end
			end
		else
				outputChatBox( "Syntax: /" .. commandName .. " [jugador] [precio]", thePlayer, 255, 255, 255 )
		end
	end
end)

function aceptarCompra (comprador)
	local vehicle = getPedOccupiedVehicle(comprador)
	if not vehicle then outputChatBox("No estás subido a un vehículo.", comprador, 255, 0, 0) return end
	if not getElementData(vehicle, "precioVenta") then outputChatBox("Este vehículo no está a la venta.", comprador, 255, 0, 0) return end
	local data = vehicles[ vehicle ]
	local vehicleID = vehicles[ vehicle ] and vehicles[ vehicle ].vehicleID
	local vendedor = getPlayerFromName(tostring(getElementData(vehicle, "playerVendedor")))
	local dineroActual = exports.bank:getDinero(comprador)
	local cantidad = getElementData(vehicle, "precioVenta")
	if tonumber(dineroActual) < tonumber(cantidad) then
		outputChatBox("¡El comprador no tiene tanto dinero en su cuenta bancaria!", vendedor, 255, 0, 0)
		outputChatBox("¡No tienes tanto dinero en tu cuenta bancaria!", comprador, 255, 0, 0)
		return
	end
	if comprador == vendedor then
		outputChatBox("¡No puedes comprarte un coche a ti mismo!",comprador, 255, 0, 0)
		return
	end	
	local dineroActual2 = exports.bank:getDinero(vendedor)
	local otherID = exports.players:getCharacterID(comprador)
	exports.sql:query_free( "UPDATE characters SET banco = "..(dineroActual-tonumber(cantidad)).." WHERE characterID = " .. otherID)
	exports.sql:query_free( "UPDATE characters SET banco = "..(dineroActual2+tonumber(cantidad)).." WHERE characterID = " .. exports.players:getCharacterID(vendedor))
	exports.sql:query_free( "UPDATE vehicles SET characterID = " .. otherID .. " WHERE vehicleID = " .. vehicleID )
	data.characterID = otherID
	outputChatBox( "Has vendido tu "..getVehicleName(vehicle).." con matrícula " .. vehicleID .. " a " .. getPlayerName(comprador):gsub("_", " ") .. " por $"..tostring(cantidad)..".", vendedor, 0, 255, 0 )
	outputChatBox("El dinero de la transación ha sido transferido a tu cuenta bancaria.", vendedor, 0, 255, 0)
	outputChatBox( getPlayerName( vendedor ):gsub( "_", " " ) .. " te ha vendido su "..getVehicleName(vehicle).." con matrícula " .. vehicleID .. " por $"..tostring(cantidad)..".", comprador, 0, 255, 0 )
	triggerEvent("mecanico:cerradura", comprador, 0)
	removeElementData(vehicle, "precioVenta")
	removeElementData(vehicle, "playerVendedor")
end
addCommandHandler("comprarveh", aceptarCompra)

function toggleCinturon (player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle then
		if not getElementData(player, "inVehicle") == true then return end
		if getVehicleType(vehicle) == "BMX" or getVehicleType(vehicle) == "Bike" then
			if getElementData ( player, "Cascos" ) == true then
				exports.items:quitarCasco(player)
			else
				local t1c, t2c, tCasco = exports.items:has(player, 11)
				if tCasco then
					exports.items:createHelmet(player, tCasco.value)
				else
					outputChatBox("¡No tienes un casco! Acude a una tienda de ropa para comprar uno.", player, 255, 0, 0)
				end
			end
		else
			local sicinturon = getElementData(player, "player.cinturon")
			if sicinturon == false or sicinturon == nil then
				setElementData(player, "player.cinturon", true)
				exports.chat:me(player, "se abrocha el cinturón.", "(/cinturon)")
			else
				removeElementData(player, "player.cinturon")
				exports.chat:me(player, "se quita el cinturón.", "(/cinturon)")
			end
		end
	end
end
addCommandHandler( "cinturon", toggleCinturon )

addEventHandler( "onVehicleStartExit", resourceRoot,
function( player, seat, jack )
	if jack then removeElementData(player, "player.cinturon") p[ player ].oldVehicle = p[ player ].vehicle p[ player ].vehicle = nil return end
	if getElementData(player, "player.cinturon") == true and not isVehicleLocked(source) then
		exports.chat:me(player, "se quita el cinturón.", "(Salida Automática)")
		removeElementData(player, "player.cinturon")
		p[ player ].oldVehicle = p[ player ].vehicle
		p[ player ].vehicle = nil
		removeElementData(player, "inVehicle")
    end
	if isVehicleLocked(source) then
		outputChatBox("Las puertas del vehículo están cerradas. Ábrelas para poder salir.", player, 255, 0, 0)
		cancelEvent()
	end
end
) 

addCommandHandler( "nearbyvehicles",
	function( player )
		if hasObjectPermissionTo( player, "command.modchat", false ) then
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			outputChatBox( "Vehículos cercanos:", player, 0, 255, 0 )
		    for index, vehicle in ipairs ( getElementsByType ( "vehicle" ) ) do
				local px, py, pz = getElementPosition( vehicle )
				local dimension2 = getElementDimension( vehicle )
				if getDistanceBetweenPoints3D( x, y, z, px, py, pz ) <= 5 and dimension2==dimension then
					local idveh = tonumber(getElementData ( vehicle, "idveh" ))
					local nombreveh = getVehicleName ( vehicle )
					outputChatBox( "Vehículo ID " .. tostring(idveh) .. " con nombre " .. nombreveh .. " .", player, 0, 255, 127 )
				end
			end
		end
	end

)

idi = 0
function solicitarnuevoid (player)
local vehicle = getPedOccupiedVehicle(player)
  	if vehicle then
		local data = vehicles[ vehicle ]
		if data and data.vehicleID > 0 then
			local sql = exports.sql:query_assoc_single("SELECT vehicleID FROM vehicles ORDER BY vehicleID DESC LIMIT 1")
			idi = sql.vehicleID+1
			exports.sql:query_free("UPDATE vehicles SET vehicleID = "..idi.." WHERE vehicleID = "..data.vehicleID)
			outputChatBox("Solicitud realizada correctamente. Ha pasado del ID " ..data.vehicleID.. " al ID "..idi..".", player, 0, 255, 0)
			setElementData(vehicle, "idv", idi)
			vehicleIDs[ idi ] = vehicle
			vehicles[ vehicle ] = { vehicleID = idi, respawnInterior = data.respawnInterior, respawnDimension = data.respawnDimension, characterID = data.characterID, engineState = not doesVehicleHaveEngine( vehicle ) or data.engineState == 1, tintedWindows = data.tintedWindows == 1, fuel = data.fuel, km = data.km, pinturas = data.pinturas, motor = data.motor, mejoramotor = data.mejoramotor, frenos = data.frenos, mejorafrenos = data.mejorafrenos, model = data.model }
			saveVehicle(vehicle)
			idi = 0
		end
	end
end
--addCommandHandler("solicitarnuevoid", solicitarnuevoid)


addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			local ox, oy, oz = getElementPosition( source )
			if getDistanceBetweenPoints3D( x, y, z, ox, oy, oz ) <= 8 and getElementDimension( player ) == getElementDimension( source ) then				
			if getElementData(player, "mid") then outputChatBox("Hemos detectado que has estado abriendo el maletero de un coche. Usa /dmal.", player, 255, 0, 0) return end
				if getElementType( source ) == "vehicle" and not getElementData(player, "mid") and not isPedInVehicle(player) then
					local vehicleID = getElementData(source, "idveh")
					local vehicleID = tonumber(vehicleID)
					local characterID = getElementData(source, "idowner")
					local characterID = tonumber(characterID)
					if not getElementData(source, "idowner") then outputChatBox("Se ha producido un error. Contacta con un staff.", player, 255, 0, 0) return end
					local sql = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM maleteros WHERE vehicleID = "..vehicleID)
					if exports.items:has ( player, 1, vehicleID ) or vehicleID < 0 or ( characterID < 0 and exports.factions:isPlayerInFaction( player, -characterID ) ) or getElementData(player, "account:gmduty") == true then -- Revisar esta linea, puede haber ciertos errores.
						-- Tiene llave. ¿Es PD?
						if exports.factions:isPlayerInFaction(player, 1) then
							if isVehicleLocked(source) then 
								outputChatBox("El vehículo está cerrado.", player, 255, 0, 0)
								--[[triggerClientEvent(player, "onAbrirMaletero", player, player, vehicleID, 1, sql)
								triggerClientEvent(player, "onGUIVehiculo", player, 4) -- Solo salir y abrir panel PD
								setElementData(player, "mid", vehicleID)]]
							else
								triggerClientEvent(player, "onAbrirMaletero", player, player, vehicleID, 1, sql)
								triggerClientEvent(player, "onGUIVehiculo", player, 1) -- Todas las opciones
								setElementData(player, "mid", vehicleID)
							end
						else
							if isVehicleLocked(source) then 
								outputChatBox("El vehículo está cerrado.", player, 255, 0, 0)
							else
								triggerClientEvent(player, "onAbrirMaletero", player, player, vehicleID, 1, sql)
								triggerClientEvent(player, "onGUIVehiculo", player, 0) -- Todas las opciones menos PD
								setElementData(player, "mid", vehicleID)
							end
						end
					else
						-- El tío no es dueño. ¿Pero es PD?
						if exports.factions:isPlayerInFaction(player, 1) then
							if isVehicleLocked(source) then
								outputChatBox("El vehículo está cerrado.", player, 255, 0, 0)
								--[[triggerClientEvent(player, "onAbrirMaletero", player, player, vehicleID, 1, sql)
								triggerClientEvent(player, "onGUIVehiculo", player, 4) -- Solo salir y abrir panel PD
								setElementData(player, "mid", vehicleID)]]
							else
								triggerClientEvent(player, "onAbrirMaletero", player, player, vehicleID, 1, sql)
								triggerClientEvent(player, "onGUIVehiculo", player, 3) -- Menos maletero, todo.
								setElementData(player, "mid", vehicleID)
							end
						else
							if isVehicleLocked(source) then 
								outputChatBox("El vehículo está cerrado.", player, 255, 0, 0)
							else
								triggerClientEvent(player, "onAbrirMaletero", player, player, vehicleID, 1, sql)
								triggerClientEvent(player, "onGUIVehiculo", player, 2) -- No es PD. Capo solo.
								setElementData(player, "mid", vehicleID)
							end
						end
					end
                end
            end
        end 
    end
)

function desbugMaletero(player)
	if getElementData(player, "mid") then
		outputChatBox("Has sido desbugeado, lo sentimos. Ya puedes abrir de nuevo cualquier maletero.", player, 255, 0, 0)
		removeElementData(player, "mid")
	end
end
addCommandHandler("dmal", desbugMaletero)

function rolAbrirMaletero()
	if source then
		local vehicle = getVehicle(getElementData(source, "mid"))
		setVehicleDoorOpenRatio(vehicle, 1, 1, 2500)
		exports.chat:me(source, "abre el maletero del vehículo.")
	end
end
addEvent("onRolDeAbrirMaletero", true)
addEventHandler("onRolDeAbrirMaletero", getRootElement(), rolAbrirMaletero)

function rolCerrarMaletero()
	if source then
		local vehicle = getVehicle(getElementData(source, "mid"))
		setVehicleDoorOpenRatio(vehicle, 1, 0, 2500)
		exports.chat:me(source, "cierra el maletero del vehículo.")
	end
end
addEvent("onRolDeCerrarMaletero", true)
addEventHandler("onRolDeCerrarMaletero", getRootElement(), rolCerrarMaletero)

function cerrarMaletero()
	setTimer(function(source) removeElementData(source, "mid") end, 1500, 1, source)
end
addEvent("onCerrarMaletero", true)
addEventHandler("onCerrarMaletero", getRootElement(), cerrarMaletero)

function cerrarPuertas ( vehicle )
	if vehicle then
		-- local player = getVehicleController(vehicle)
		-- if not player then
			-- if getVehicleEngineState(vehicle) == false then 
				-- setElementFrozen ( vehicle, true ) 
			-- end 
		-- else 
			-- setElementFrozen ( vehicle, false ) 
		-- end
		if getElementData( vehicle, "cepo" ) then setTimer(function (vehicle) setVehicleEngineState( vehicle, false ) end, 2000, 1, vehicle ) end 
		-- for i=0,5 do
			-- setVehicleDoorOpenRatio ( vehicle, i, 0 - getVehicleDoorOpenRatio ( vehicle, i ), 0 )
		-- end
	end
end
addEventHandler("onPlayerVehicleEnter", getRootElement(), cerrarPuertas)
addEventHandler("onPlayerVehicleExit", getRootElement(), cerrarPuertas)


function getVehicleOwner(vehicleID, type)
	if vehicleID then
		local vehicle = getVehicle(vehicleID)
		if not vehicle then return nil end
		local data = vehicles[ vehicle ]
		if data and data.characterID then -- Existe, no es temporal
			if type == 1 then -- Devolver cID del dueño
				return data.characterID
			elseif type == 2 then
				if data.characterID >= 1 then -- Jugador
					local name = exports.players:getCharacterName(data.characterID)
					return name
				elseif data.characterID < 0 then -- Faccion.
					local name = exports.factions:getFactionName(math.abs(data.characterID))
					return name
				end
			end
		else return nil end
	end
end

function toggleCepo(player, commandName, id, ...)
	if exports.factions:isPlayerInFaction(player, 1) then
		if getElementData(player, "duty") == true then
			local razon = table.concat({...}, " ")
			if (...) and razon and tonumber(id) then
				local id = tonumber(id)
				local vehicle = getVehicle(id)
				local px, py, pz = getElementPosition(player)
				local vx, vy, vz = getElementPosition(vehicle)
				if getElementData( vehicle, "cepo") == 1 then outputChatBox("Este vehículo ya tiene un cepo puesto.", player, 255, 0, 0) return end
				if not vehicle then outputChatBox("No existe ningún vehículo con ID "..tostring(id), player, 255, 0, 0) return end
				if getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz) > 3 then outputChatBox("Estás demasiado lejos de este vehículo.", player, 255, 0, 0) return end
				setElementData( vehicle, "cepo", 1 )
				exports.sql:query_free("UPDATE vehicles SET cepo = 1 WHERE vehicleID = "..id)
				setVehicleEngineState( vehicle, false )
				local sql, error = exports.sql:query_insertid("INSERT INTO `deposito` (`depositoID`, `vehicleID`, `modelo`, `color`, `propietario`, `razon`, `agente`, `fecha`, `estado`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', '%s', CURRENT_TIMESTAMP, 'En deposito');", id, getVehicleName(vehicle), "-", getVehicleOwner(id, 2), razon, tostring(getPlayerName(player):gsub("_", " ")))
				outputChatBox("Has puesto cepo al vehículo "..tostring(getVehicleName(vehicle)).. " (ID "..tostring(id)..") y se ha realizado el informe (/panel).", player, 0, 255, 0)
				outputChatBox("Recuerda que deberás de trasladarlo al depósito.", player, 255, 255, 255)
			else
				outputChatBox("Sintaxis: /cepo [ID del Vehículo] [Razón]", player, 255, 255, 255)
				outputChatBox("Tip: usa /matriculas para ver la ID.", player, 255, 255, 255)
			end
		else	
		outputChatBox("¡No estás de servicio!", player, 255, 0, 0)
		end
	else
	outputChatBox("¡No eres policia!", player, 255, 0, 0)
	end
end	
addCommandHandler("cepo", toggleCepo)

function capo (player)
	if player then
	local vehicleID = getElementData(player, "mid")
	local vehicle = getVehicle(tonumber(vehicleID))
		if vehicle then
			local s = getVehicleDoorOpenRatio(vehicle, 0)
			if s == 0 then -- Esta cerrado
				setVehicleDoorOpenRatio(vehicle, 0, 1, 2500)
				exports.chat:me(player, "abre el capó del vehículo y lo observa.")
				outputChatBox("~~~~ Capó del vehículo #00FF00ID "..tostring(vehicleID).."#FFFFFF ~~~~:",player, 255, 255, 255, true)
				outputChatBox("Fase del motor: #00FF00Fase Nº"..tostring(getElementData(vehicle, "fasemotor")), player, 255, 255, 255, true)
				outputChatBox("Fase de los frenos: #00FF00Fase Nº"..tostring(getElementData(vehicle, "fasefrenos")), player, 255, 255, 255, true)
			    -- Tipo de cambio que tiene el vehículo.
				if getElementData(vehicle,"marchas") == 1 then
				outputChatBox("Tipo de cambio: #00FF00Manual", player, 255, 255, 255, true)
				end
				if getElementData(vehicle,"marchas") == 0 then
				outputChatBox("Tipo de cambio: #00FF00Automatico",player,255,255,255,true)
				end
			else
				exports.chat:me(player, "cierra el capó del vehículo.")
				setVehicleDoorOpenRatio(vehicle, 0, 0, 2500)
			end
			removeElementData(player, "mid")
		end
	end
end
addEvent("onCapo", true)
addEventHandler("onCapo", getRootElement(), capo )