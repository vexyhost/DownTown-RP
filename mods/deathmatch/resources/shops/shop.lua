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

--

local p = { }
local shops = { }
local dimensions = { }

local function createShopPed( shopID )
	local shop = shops[ shopID ]
	if shop then
		if not shop_configurations[ shop.configuration ] then outputDebugString("Error tienda ID "..tostring(shopID).." configuración "..tostring(shop.configuration).." no existe.") return end
		ped = createPed( shop_configurations[ shop.configuration ].skin, shop.x, shop.y, shop.z )
		if ped then
			shops[ ped ] = shopID
			shop.ped = ped
			setElementRotation( ped, 0,0,tonumber(shop.rotation+10) )
			setElementInterior( ped, shop.interior )
			setElementDimension( ped, shop.dimension )
			setElementData( ped, "npcname", "Vendedor" )
			--setTimer(setElementFrozen, 2000, 1, ped, true)
			outputDebugString( "Tienda creada correctamente con ID - " .. tostring( shopID ) )
			return true
		end
	end
	outputDebugString( "Tienda erronea no se ha creado correctamente ID - " .. tostring( shopID ) )
	return false
end

addEventHandler( "onPedWasted", resourceRoot,
	function( )
		local shopID = shops[ source ]
		if shopID then
			shops[ source ] = nil
			destroyElement( source )
			
			createShopPed( shopID )
		end
	end
)

local function loadShop( shopID, x, y, z, rotation, interior, dimension, configuration, skin )
	shops[ shopID ] = { shopID = shopID, x = x, y = y, z = z, rotation = tonumber(rotation), interior = interior, dimension = dimension, configuration = configuration, skin = skin }
	if not createShopPed( shopID ) then
		outputDebugString( "shop creation failed: shop " .. tostring( shopID ) )
	end
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM shops ORDER BY shopID ASC" )
		if result then
			for key, data in ipairs( result ) do
				loadShop( tonumber(data.shopID), tonumber(data.x), tonumber(data.y), tonumber(data.z), tonumber(data.rotation), tonumber(data.interior), tonumber(data.dimension), tostring(data.configuration), tonumber(data.skin) )				
				dimensions[ data.dimension ] = true
			end
		end
	end
)

addCommandHandler( "createshop",
	function( player, commandName, config )
		if config then
			if shop_configurations[ config ] then
				local x, y, z = getElementPosition( player )
				local rx, ry, rotation = getElementRotation( player )
				local interior = getElementInterior( player )
				local dimension = getElementDimension( player )
				local shopID = exports.sql:query_insertid( "INSERT INTO shops (x, y, z, rotation, interior, dimension, configuration) VALUES (" .. table.concat( { x, y, z, rotation, interior, dimension, '"%s"' }, ", " ) .. ")", config )
				if shopID then
					loadShop( shopID, x, y, z, tonumber(rotation), interior, dimension, config, 0 )
					outputChatBox( "Has creado una nueva tienda con el ID " .. shopID .. ", tipo " .. config .. ".", player, 0, 255, 0 )
				else
					outputChatBox( "No se ha podido crear la tienda (SQL-Error).", player, 255, 0, 0 )
				end
			else
				outputChatBox( "No hay ninguna configuración llamada '" .. config .. "'.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Sintaxis: /" .. commandName .. " [tipo]", player, 255, 255, 255 )
		end
	end,
	true
)

local function deleteShop( shopID )
	local shop = shops[ shopID ]
	if shop then
		-- close gui using this shop
		for player, data in pairs( p ) do
			if data.shopID == shopID then
				triggerClientEvent( player, "shops:clear", shop.ped or resourceRoot )
				p[ player ].shopID = nil
			end
		end
		
		-- remove from shops list
		
		-- unset
		shops[ shopID ] = nil
		
		-- check if we still have any shops in this dimension
		local stillHasAShop = false
		local sql = exports.sql:query_assoc("SELECT * FROM shops")
		for key, value in pairs( sql ) do
			if tonumber(value.dimension) == tonumber(getElementDimension(shop.ped)) then
				stillHasAShop = true
				break
			end
		end
		
		if shop.ped then
			destroyElement( shop.ped )
			shops[ shop.ped ] = nil
		end
		
		if not stillHasAShop then
		--if not stillHasAShop and exports['job-carrier'] then
			dimensions[ shop.dimension ] = nil
		--	exports['job-carrier']:removeDropOff( shop.dimension )
		end
	end
end

addCommandHandler( { "deleteshop", "delshop" },
	function( player, commandName, shopID )
		shopID = tonumber( shopID )
		if shopID then
			local shop = shops[ shopID ]
			if shop then
				if exports.sql:query_free( "DELETE FROM shops WHERE shopID = " .. shopID ) then
					outputChatBox( "Has borrado la tienda con el ID " .. shopID .. ".", player, 0, 255, 153 )
					deleteShop( shopID )
				else
					outputChatBox( "MySQL-Query failed.", player, 255, 0, 0 )
				end
			else
				outputChatBox( "Tienda no encontrada.", player, 255, 0, 0 )
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [id]", player, 255, 255, 255 )
		end
	end,
	true
)

addCommandHandler( "nearbyshops",
	function( player, commandName )
		if hasObjectPermissionTo( player, "command.createshop", false ) or hasObjectPermissionTo( player, "command.deleteshop", false ) then
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			local interior = getElementInterior( player )
			
			outputChatBox( "Nearby Shops:", player, 255, 255, 0 )
			for key, value in pairs( shops ) do
				if isElement( key ) and getElementDimension( key ) == dimension and getElementInterior( key ) == interior then
					local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( key ) )
					if distance < 20 then
						outputChatBox( "  Shop " .. value .. " - Tipo: " .. tostring( shops[ value ].configuration ) .. ".", player, 255, 255, 0 )
					end
				end
			end
		end
	end
)

-- client interaction

addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local shopID = shops[ source ]
			if getElementData(player, "inTienda") then return end
			if shopID then
				local shop = shops[ shopID ]
				if shop then
					local x, y, z = getElementPosition( player )
					if getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) ) < 5 and getElementDimension( player ) == getElementDimension( source ) then
						if not p[ player ] then
							p[ player ] = { synched = { } }
						end
						p[ player ].shopID = shopID
						if shop.items then -- custom items
							-- these are manually synched if not sent yet
							if not p[ player ].synched[ shopID ] then
								triggerClientEvent( player, "shops:sync", source, shopID, shop.items )
								p[ player ].synched[ shopID ] = true
							end
						
							triggerClientEvent( player, "shops:open", source, shopID )
						elseif shop_configurations[ shop.configuration ] then
							if shop_configurations[ shop.configuration ].factionID and not exports.factions:isPlayerInFaction(player, shop_configurations[ shop.configuration ].factionID) then
								outputChatBox("No perteneces a la facción "..exports.factions:getFactionName(shop_configurations[ shop.configuration ].factionID)..".", player, 255, 0, 0)
							else
								local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
								local nivelNec = shop_configurations[ shop.configuration ].nivel
								if nivelNec == 14 then
									-- Requiere invitación y comprobamos dimension
									if getElementDimension(player) == 264 and getElementData(player, "dentroArmas") == true then
										triggerClientEvent( player, "shops:open", source, shop.configuration )
										setElementData( player, "inTienda", true )
									end
								elseif (nivelNec and nivel < nivelNec) then 
									outputChatBox("Necesitas nivel "..tostring(nivelNec).." para usar esta tienda. Usa /objetivos.", player, 255, 0, 0)
								else
									triggerClientEvent( player, "shops:open", source, shop.configuration )
									setElementData( player, "inTienda", true )
								end
							end
						end
					end
				end
			end
		end
	end
)

addEventHandler( "onCharacterLogout", root,
	function( )
		if p[ source ] then
			p[ source ].shopID = nil
		end
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		p[ source ] = nil
	end
)

addEvent( "shops:close", true )
addEventHandler( "shop:close", root,
	function( )
		if source == client then
			p[ source ].shopID = nil
		end
	end
)

local balasCargador =
{
    [ 22 ] = 12,
    [ 23 ] = 12,
	[ 24 ] = 7,
	[ 25 ] = 1,
	[ 26 ] = 2,
	[ 27 ] = 4,
	[ 28 ] = 50,
	[ 29 ] = 45,
	[ 32 ] = 50,
	[ 30 ] = 30,
	[ 31 ] = 30,
	[ 33 ] = 1,
	[ 34 ] = 1,
}

addEvent( "shops:buy", true )
addEventHandler( "shops:buy", root,
	function( key )
		if source == client and type( key ) == "number" then
			-- check if the player is even meant to shop, if so only the index is transferred so we need to know where
			if p[ source ] then 
				local shop = shops[ p[ source ].shopID ]
				if shop then
					-- check if it's a valid item
					local item = shop.items and shop.items[ key ] or shop_configurations[ shop.configuration ][ key ]
					if item then
						if (getElementDimension(source) == 0) or (exports.interiors:getProductos(getElementDimension(source)) >= (item.price/2)) then
							if exports.players:takeMoney( source, item.price ) then
								if getElementDimension(source) > 0 then
									exports.interiors:giveRecaudacion(getElementDimension(source), math.ceil(item.price*0.5))
									exports.interiors:takeProductos(getElementDimension(source), math.ceil(item.price*0.5))
								end
								local value = item.itemValue     
								if item.itemID == 29 then -- Armas
									local arma = item.itemValue
									local balas = item.itemValue2
									local name = "Arma "..tostring(arma)
									if exports.items:give(source, 29, tostring(arma), tostring(name), tonumber(balas)) then
										outputChatBox( "Has comprado un/a " .. tostring(name) .. " por $" .. item.price .. ".", source, 0, 255, 0 )
										exports.factions:giveFactionPresupuesto(5, tonumber(item.price*0.25))
									end
								elseif item.itemID == 43 then -- Cargadores Armas
									local arma = item.itemValue
									local balas = item.itemValue2
									local name = "Arma "..tostring(arma)
									if exports.items:give(source, 43, tostring(arma), tostring(name), tonumber(balasCargador[arma])) then
										outputChatBox( "Has comprado un/a Cargador " .. tostring(name) .. " por $" .. item.price .. ".", source, 0, 255, 0 )
										exports.factions:giveFactionPresupuesto(5, tonumber(item.price*0.25))
									end
								else
									if exports.items:give( source, item.itemID, value, item.name ) then
										outputChatBox( "Has comprado un/a " .. ( item.name or exports.items:getName( item.itemID ) ) .. " por $" .. item.price .. ".", source, 0, 255, 0 )
										exports.factions:giveFactionPresupuesto(5, tonumber(item.price*0.25))
										if item.itemID == 9 then -- Es un reloj
											setElementData(source, "tieneReloj", true)
											setPlayerHudComponentVisible(source, "clock", true)
											exports.objetivos:addObjetivo(9, exports.players:getCharacterID(source), source)
										elseif item.itemID == 12 then -- Es una mochila
											triggerEvent("onCheckRelojYMochila", source)
										end
									end
								end
								local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(source))
								if nivel == 3 and not exports.objetivos:isObjetivoCompletado(23, exports.players:getCharacterID(source)) and shop_configurations[ shop.configuration ].name == "Vendedor Callejero" then
									exports.objetivos:addObjetivo(23, exports.players:getCharacterID(source), source)
								end
							else
								if item.itemID == 29 then
									local arma = item.itemValue
									local name = "Arma "..tostring(arma)
									outputChatBox( "No puedes permitirte un/a " .. tostring(name) .. ".", source, 0, 255, 0 )
								else
									outputChatBox( "No puedes permitirte un/a " .. ( item.name or exports.items:getName( item.itemID ) ) .. ".", source, 0, 255, 0 )
								end
							end
						else
							outputChatBox("Esta tienda no tiene ese producto. Inténtalo más tarde.", source, 255, 0, 0)
						end
					end
				end
			end
		end
	end	
)

-- 

function clearDimension( dimension )
	if dimension then
		for key, value in pairs( shops ) do
			if type( value ) == "table" then
				if value.dimension == dimension then
					if exports.sql:query_free( "DELETE FROM shops WHERE shopID = " .. value.shopID ) then
						deleteShop( value.shopID )
					end
				end
			end
		end
	end
end

function getAllDimensions( )
	return dimensions
end
