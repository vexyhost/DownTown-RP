--[[

Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (C) 2016  DownTown County Roleplay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.

]]

local data = { }
local dormirT = { }
local dormirC = { }

local purgaVar = false

function resetPulgaState()
	purgaVar = false
end
addEventHandler("onCharacterLogin", getRootElement(), resetPulgaState)
addEventHandler("onPlayerJoin", getRootElement(), resetPulgaState)

-- function togglepurgaVar(player)
	-- if purgaVar == false then
		-- purgaVar = true
		-- outputChatBox("Modo purgaVar activado.", player, 255, 0, 0)
	-- else
		-- purgaVar = false
		-- outputChatBox("Modo purgaVar desactivado.", player, 255, 0, 0)
	-- end
-- end
-- addCommandHandler("purgaVarS", togglepurgaVar)

local isArmaPolicia =
{
    [ 3 ] = true,
	[ 24 ] = true,
	[ 25 ] = true,
	[ 29 ] = true,
	[ 31 ] = true,
}

local isArmaBalas =
{
    [ 22 ] = true,
    [ 23 ] = true,
	[ 24 ] = true,
	[ 25 ] = true,
	[ 26 ] = true,
	[ 27 ] = true,
	[ 28 ] = true,
	[ 29 ] = true,
	[ 32 ] = true,
	[ 30 ] = true,
	[ 31 ] = true,
	[ 33 ] = true,
	[ 34 ] = true,
}

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

function isTelefonoEncendido(numero)
	if numero then
		local consulta = exports.sql:query_assoc_single("SELECT `apagado` FROM `tlf_data` WHERE `numero` = "..tostring(numero).." AND `estado` = 0")
		if consulta then
			if tonumber(consulta.apagado) == 0 then
				return true
			else
				return false
			end
		else
			return false
		end
	end
end

function devolverArmaCon1Bala(weapon)
	if source and client and client == source and weapon then
		giveWeapon(source, weapon, 1)
	end
end
addEvent("devolverArma1Bala", true)
addEventHandler("devolverArma1Bala", getRootElement(), devolverArmaCon1Bala)

local function notify( element, to )
	if data[ element ] then
		if to then
			to = { [ to ] = true }
		else
			to = data[ element ].subscribers
		end
		local items = data[ element ].items
		for value in pairs( to ) do
			triggerClientEvent( value, "syncItems", value, items )
		end
	else
		triggerClientEvent( to, "syncItems", to )
	end
end

local function getID( element )
	if getElementType( element ) == "player" then
		return exports.players:getCharacterID( element )
	end
end

function load( element, force )
	if isElement( element ) then
		local elementID = getID( element )
		if elementID then
			if force or not data[ element ] or data[ element ].id ~= elementID then
				data[ element ] = {
					['items'] = { },
					['subscribers'] = { },
					id = elementID
				}
				local i = exports.sql:query_assoc( "SELECT `index`, item, value, value2, name FROM items WHERE owner = " .. elementID .. " ORDER BY `index` ASC" )
				for key, value in ipairs( i ) do
					table.insert( data[ element ].items, value )
				end
				if getElementType( element ) == "player" then
					data[ element ].subscribers[ element ] = true
					notify( element, element )
					triggerEvent("onCheckRelojYMochila", element)
				end
				return true
			end
			return true
		end
		return false, "Element has no unique ID"
	end
	return false, tostring( element ) .. " is no element"
end

local function subscribe( element, to )
	if load( to ) then
		data[ to ].subscribers[ element ] = true
		return true
	end
	return false, "Unable to load element"
end

function get( element )
	if load( element ) then
		return data[ element ].items
	end
end
 
function give( element, item, val, name, value2 )
	if load( element ) then
		if type( item ) == 'number' and ( type( val ) == "number" or type( val ) == "string" ) then
			name2 = "NULL"
			if name then
				name2 = "'" .. exports.sql:escape_string( tostring( name ) ) .. "'"
			else
				name = tostring(exports.items:getName(item))
			end
			local value = nil
			if tonumber(item) == 7 then
				value = string.format("%13.0f",val)
			else
				value = val
			end
			local index, error = exports.sql:query_insertid( "INSERT INTO items (owner, item, value, name) VALUES (" .. getID( element ) .. ", " .. item .. ", '%s', " .. name2 .. ")", value )
			if error then outputDebugString(error) return end
			if index then
				-- Parche para sistema de mochilas, registro automático de nuevas mochilas.
				if item == 12 and not value2 then
					value2 = index
				end
				table.insert( data[ element ].items, { index = index, item = item, value = value, value2 = value2, name = name } )
				if value2 then
					exports.sql:query_free("UPDATE items SET value2 = "..tonumber(value2).." WHERE `index` = "..index)
				end
				notify( element )
				return true
			end
			return false, "MySQL Query failed"
		end
		return false, "Invalid Parameters"
	end
	return false, "Unable to load element"
end

function take( element, slot )
	if load( element ) then
		if data[ element ].items[ slot ] then
			local success, error = exports.sql:query_free( "DELETE FROM items WHERE `index` = " .. data[ element ].items[ slot ].index )
			if success then
				table.remove( data[ element ].items, slot )
				notify( element )
				return true
			end
			return false, "MySQL Query failed"
		end
		return false, "No such slot exists"
	end
	return false, "Unable to load element"
end


function take2( element, item, value, onlyOne )
	if load( element ) then
		local success = false
		for key, v in ipairs( get(element) ) do
			if v.item == item and v.value == value then
				if onlyOne and success then
					return success
				else
					take(element, key) 
					success = true
				end
			end
		end
		return success
	end	
end

function take3(element, item)
	if load( element ) then
		for key, v in ipairs( get(element) ) do
			if v.item == item then
				take(element, key)
				take3(element, item)
			end
		end
	end	
end

function hasPhone( element, item, value, name )
	-- we need a base to work on
	if load( element ) then
		-- at least the item is needed
		if type( item ) == 'number' then
			-- check if he has it
			for key, v in ipairs( data[ element ].items ) do
				if v.item == item and ( not value or string.format("%13.0f",v.value) == string.format("%13.0f",value) ) and ( not name or v.name == name ) then
					return true, key, v
				end
			end
			return false -- nope, no error either
		end
		return false, "Invalid Parameters"
	end
	return false, "Unable to load element"
end

function has( element, item, value, name )
	-- we need a base to work on
	if load( element ) then
		-- at least the item is needed
		if type( item ) == 'number' then
			-- check if he has it
			for key, v in ipairs( data[ element ].items ) do
				if v.item == item and ( not value or v.value == value ) and ( not name or v.name == name ) then
					return true, key, v
				end
			end
			return false -- nope, no error either
		end
		return false, "Invalid Parameters"
	end
	return false, "Unable to load element"
end

function unload( element )
	if data[ element ] then
		data[ element ].items = nil
		notify( element )
		data[ element ] = nil
		return true
	end
	return false, "Element has no loaded items"
end

local function unsubscribe( element, from )
	if from then
		if load( from ) then
			data[ from ].subscribers[ element ] = nil
		end
		return true
	else
		for key, value in pairs( data ) do
			if value.subscribers[ element ] then
				value.subscribers[ element ] = nil
			end
		end
	end
end

addEventHandler( "onElementDestroy", root,
	function( )
		unload( source )
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		unload( source )
		unsubscribe( source )
	end
)

addEventHandler( "onCharacterLogin", root,
	function( )
		load( source, true )
	end
)

addEventHandler( "onCharacterLogout", root,
	function( )
		unload( source )
		unsubscribe( source )
	end
)

addEvent( "loadItems", true )
addEventHandler( "loadItems", root,
	function( )
		if source == client then
			if exports.players:isLoggedIn( source ) then
				load( source, true )
			end
		end
	end
)

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		-- Realizar ajustes --
		for k, v in pairs(balasCargador) do
			setWeaponProperty(k, "pro", "maximum_clip_ammo", v+1)
			setWeaponProperty(k, "std", "maximum_clip_ammo", v+1)
			setWeaponProperty(k, "poor", "maximum_clip_ammo", v+1)
		end
	end
)

timer = {}
mochila = {}

timer2 = {}
casco = {}

addEvent( "items:use", true )
addEventHandler( "items:use", root,
	function( slot )
		if source == client then
			if exports.players:isLoggedIn( source ) then
				local item = get( source )[ slot ]
				if item then
					local id = item.item
					local index = item.index
					local value = item.value
					local value2 = item.value2
					local name = item.name or getName( id )
					if getElementData(source, "jailed") then
						if not string.find(name, "Prision") then
							outputChatBox("No puedes usar este item ahora.", source, 255, 0, 0)
							return
						end
					else
						if string.find(name, "Prision") then
							outputChatBox("Este item es de prisión. No puedes usarlo.", source, 255, 0, 0)
							take( source, slot )
							return
						end
					end
					if id == 1 then
						local vehicle = exports.vehicles:getVehicle( tonumber(value) )
						if vehicle then
							if getPedOccupiedVehicle(source) and getPedOccupiedVehicle(source) == vehicle and getVehicleType(vehicle) == "Bike" then
								outputChatBox("Has intentado bugear el sistema de cierre, intentando cerrar una moto estando subido a ella. Incidente reportado.", source, 255, 0, 0)
								exports.logs:addLogMessage("bugs", "El jugador " .. getPlayerName(source) .. " ha intentado bugear el sistema de cierre de vehículos #3 Cerrar una moto estando subida a ella desde el inventario.")
								return
							end
							local x, y, z = getElementPosition( source )
							if getElementDimension( source ) == getElementDimension( vehicle ) and getDistanceBetweenPoints3D( x, y, z, getElementPosition( vehicle ) ) < 20 then
							    setPedAnimation( source, "ghands", "gsign3lh" )
								exports.vehicles:toggleLock( source, vehicle )
								triggerClientEvent("onSonidoMando", source, x, y, z)
								setVehicleOverrideLights(vehicle, 2)
							else
								outputChatBox( "(( Este vehiculo está muy lejos. ))", source, 255, 0, 0 )
							end
						else
							outputChatBox( "(( Este vehiculo no existe o está inactivo. Usa /misvehs para más info. ))", source, 255, 0, 0 )
						end
					elseif id == 2 then
						local interior = exports.interiors:getInterior( value )
						if interior then
							local dimension = getElementDimension( source )
							local x, y, z = getElementPosition( source )
							if dimension == getElementDimension( interior.inside ) and getDistanceBetweenPoints3D( x, y, z, getElementPosition( interior.inside ) ) < 5 then
								exports.interiors:toggleLock( source, interior.inside )
							elseif dimension == getElementDimension( interior.outside ) and getDistanceBetweenPoints3D( x, y, z, getElementPosition( interior.outside ) ) < 5 then
								exports.interiors:toggleLock( source, interior.outside )
							else
								outputChatBox( "(( Este interior está muy lejos. ))", source, 255, 0, 0 )
							end
						else
							outputChatBox( "(( Este interior no existe. ))", source, 255, 0, 0 )
						end
					elseif id == 3 then
						take( source, slot ) 
						exports.chat:me( source, "se come un/a "..name..".")
						if getElementData(source, "hambre") < 100 then
							setElementData( source, "hambre", getElementData( source, "hambre" ) + math.random(5, 10) )
						end
					    local gordura = getPedStat(source, 21)
						if gordura < 1000 then
							triggerEvent ("onGestionarPeso",source,21,gordura+1) 
						end
						if not getElementData(source, "muerto") then
							setPedAnimation( source, "food", "eat_burger", 3000, false, false, false)
						end
					elseif id == 4 then
						take( source, slot )
						exports.chat:me( source, "coge un/a " .. name .. " y se lo bebe." )
						if getElementData(source, "sed") < 100 then
							setElementData( source, "sed", getElementData( source, "sed" ) + math.random(5, 10) )
						end
						if value == 1001 then
							outputChatBox("Al ser café, has recuperado parte de tu cansancio.", source, 0, 255, 0)
							if getElementData(source, "cansancio") < 60 then
								setElementData( source, "cansancio", getElementData( source, "cansancio" ) + math.random(5, 10) )
							end
						end
						if not getElementData(source, "muerto") then
							setPedAnimation( source, "BAR", "dnk_stndm_loop", 3000, false, false, false)
						end
					elseif id == 5 then -- Skin, ropa
						outputChatBox("En el nuevo sistema, las SKIN están desactivadas. Disculpe las molestias.", source, 255, 0, 0)
						take( source, slot )
					elseif id == 6 then -- Tarjeta antigua
						take ( source, slot )
						outputChatBox("Este item está obsoleto.", source, 255, 0, 0)
					elseif id == 7 then
						local imei = string.format("%13.0f",value)
						if string.len(imei) ~= 15 then outputChatBox("Este teléfono no está registrado. Compra uno nuevo.", source, 255, 0, 0) return end
						local con = exports.sql:query_assoc_single("SELECT `numero` FROM `tlf_data` WHERE `imei` = "..imei)
						if not con then outputChatBox("Este teléfono no está registrado. Compra uno nuevo.", source, 255, 0, 0) return end
						setElementData( source, "numeroTelefono", tonumber(con.numero) )
						if not isTelefonoEncendido(tonumber(con.numero)) then
							outputChatBox("Este teléfono estaba apagado, se ha encendido al darle click.", source, 0, 255, 0)
							triggerEvent("onEncenderTelefono", source)
						end
						triggerClientEvent( source, "onAbrirTelefono", source )
						outputChatBox( "Nº de teléfono: " .. tostring(con.numero) .. ". IMEI: "..tostring(imei)..".", source, 255, 255, 255 )
					elseif id == 8 then
						if exports.players:isValidLanguage( value ) then
							local learned, error = exports.players:learnLanguage( source, value )
							if learned then
								take( source, slot )
								outputChatBox( "Has aprendido lo basico de " .. exports.players:getLanguageName( value ) .. ".", source, 0, 255, 0 )
							elseif error == 1 then
								outputChatBox( "Idioma invalido - " .. value .. ".", source, 255, 0, 0 )
							elseif error == 2 then
								outputChatBox( "Ya estas hablando " .. exports.players:getLanguageName( value ) .. ".", source, 255, 0, 0 )
							elseif error == 3 then
								outputChatBox( "No puedes aprender mas idiomas.", source, 255, 0, 0 )
							else
								outputChatBox( "MySQL-Error.", source, 255, 0, 0 )
							end
						else
							outputChatBox( "Invalid Language code - " .. value .. ".", source, 255, 0, 0 )
						end
					elseif id == 9 then
					    local h, m = getTime()
						exports.chat:me( source, "mira la hora en su reloj." )
						exports.chat:ame( source, "Reloj", "El reloj marca las "..h..":"..m.."")
					elseif id == 10 then
						take( source, slot )
						if getElementData(source, "sed") < 100 then
							setElementData( source, "sed", getElementData( source, "sed" ) + 10 )
						end
						exports.chat:me( source, "coge un/a " .. name .. " y se lo bebe." )
						if not getElementData(source, "muerto") then
							setPedAnimation( source, "BAR", "dnk_stndm_loop", 3000, false, false, false)
						end
						if not getElementData( source, "alcohol" ) then setElementData(source, "alcohol", 0) end
						local alcohol = tonumber(getElementData( source, "alcohol" ))
						if value == 15 then
							if alcohol > 12 then
								setElementData ( source, "alcohol", alcohol + 5 )
								exports.chat:me( source, "se tambalea de un lado a otro por la borrachera." )
							elseif alcohol > 0 then
								setElementData ( source, "alcohol", alcohol + 5 )
							else 
								setElementData ( source, "alcohol", 5 )
							end
						elseif value == 20 then
							if alcohol > 12 then
								setElementData ( source, "alcohol", alcohol + 7 )
								exports.chat:me( source, "se tambalea de un lado a otro por la borrachera." )
							elseif alcohol > 0 then
								setElementData ( source, "alcohol", alcohol + 7 )
							else 
								setElementData ( source, "alcohol", 7 )
							end
						elseif value == 30 then
							if alcohol > 12 then
								setElementData ( source, "alcohol", alcohol + 8 )
								exports.chat:me( source, "se tambalea de un lado a otro por la borrachera." )
							elseif alcohol > 0 then
								setElementData ( source, "alcohol", alcohol + 8 )
							else 
								setElementData ( source, "alcohol", 8 )
							end
						elseif value == 80 or value == 90 or value == 50 then
							if alcohol > 12 then
								setElementData ( source, "alcohol", alcohol + 10 )
								exports.chat:me( source, "se tambalea de un lado a otro por la borrachera." )
							elseif alcohol > 0 then
								setElementData ( source, "alcohol", alcohol + 10 )
							else 
								setElementData ( source, "alcohol", 10 )
							end
						end
					elseif id == 11 then
						if type( value ) == "number" and value ~= 1008 then
							if isElement (casco [source]) or getElementData ( source, "Cascos" ) == 1 then		
								exports.chat:me( source, "se quita el casco." )
								removeElementData ( source, "Cascos" )
								if isElement(casco [source]) then destroyElement (casco [source]) end
							else				
								createHelmet(source,value)
							end
                        end
					elseif id == 12 then 
						if not value2 or tonumber(value) < 5 then
							outputChatBox("¡Ups! Esta mochila es antigua. Ya te la hemos cambiado por una nueva; haz click en ella para usarla.", source, 255, 0, 0)
							if tonumber(value) < 5 then
								give(source, 12, tonumber(value)+2080, name, index)
							else
								give(source, 12, value, name, index)
							end
							take(source, slot)
							return
						end
						local count = 0
						for k, v in ipairs(get(source)) do
							if v.item == 12 then
								count = count + 1
							end
						end
						if count > 1 then outputChatBox("¡Ups! Sólo puedes tener 1 mochila en tu inventario. Borra todas menos 1.", source, 255, 0, 0) return end
						local sql = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM items_mochilas WHERE mochilaID = "..value2)
						setElementData(source, "mochilaID", value2)
						setElementData(source, "mochilaModel", value)
						triggerClientEvent(source, "onAbrirMochila", source, source, value2, 1, sql)
						if not getElementData ( source, "Bags" ) then
							setElementData ( source, "Bags", true )
							setElementData ( source, "BagsModel", tonumber(value))
							local x,y,z = getElementPosition (source)
							local dim = getElementDimension (source)
							local int = getElementInterior (source)
							if isElement (mochila [source]) then destroyElement (mochila [source]) end						 
							mochila [source] = createObject ( value, x, y, z )
							setElementDimension ( mochila [source], dim )
							setElementInterior ( mochila [source], int )
							if tonumber(value) == 2081 then
								exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
							elseif tonumber(value) == 2082 then
								exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
							elseif tonumber(value) == 2083 then
								exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,-90,180,0)
							elseif tonumber(value) == 2084 then 
								exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.14,0,90,0,0)
							end
						end
					elseif id == 13 then
						take(source, slot)
						triggerClientEvent ( "items:copy", source )
					elseif id == 14 then
					    exports.chat:me( source, "abre su caja de cigarrillos." )
				     	take( source, slot )
					    give(source, 15, 20 )
                        outputChatBox("Tienes 20 cigarrillos, cada vez que clickees en el se gastará uno.", source, 0, 255, 0)
					elseif id == 15 then
						if has(source, 26) then
							if getElementData(source, "mechero") == true then
								local value = tonumber(value)
								if value >= 1 then
									local value2 = value-1
									local value2 = tonumber(value2)
									outputChatBox("Estás fumando un cigarrillo, te quedan "..value2..".", source, 0, 255, 0)
									triggerEvent("onFumarCigarro", source, source)
									setElementData(source, "mechero", false)
									take(source, slot)
									give(source, 15, value2)
								else
									outputChatBox("Has gastado tus cigarrillos.", source, 255, 0, 0)
									take(source, slot)
								end
							else
								outputChatBox("Primero saca el mechero y enciendelo", source, 255, 0, 0)
							end
						else
							exports.chat:me(source, "rebusca en su bolsillo pero no encuentra un mechero.")
							outputChatBox("No tienes un mechero con el que encender el cigarro.", source, 255, 0, 0)
						end
					elseif id == 16 then
						local dni = 20000000 + tonumber(exports.players:getCharacterID(source))
						local dni = tonumber(dni)
						exports.chat:me(source, "saca el DNI de su cartera y lo observa")
						outputChatBox( "Tu DNI es ".. tostring(dni) .. ".", source, 0, 255, 0)
					elseif id == 17 then
					    outputChatBox ("Usa esta tarjeta de peajes para pasar por los peajes gratis.", source, 255, 255, 255 )
					elseif id == 18 then
						if not getElementData(source, "muerto") then
							setPedAnimation( source, "gangs", "smkcig_prtl", true, true, true, false)
						end
					    exports.chat:me( source, "se lía un porro y fuma." )
					    take( source, slot )
						triggerClientEvent ( source, "droga.marihuana", source )
						setElementData(source, "droga", "marihuana")
					elseif id == 19 then
				     	exports.chat:me( source, "toma una seta psicodelica." )
					    triggerClientEvent ( source, "droga.seta", source )
				    	take( source, slot )
						setElementData(source, "droga", "seta")
					elseif id == 20 then
				     	exports.chat:me( source, "toma unas pastillas." )
				    	take( source, slot )
					    triggerClientEvent ( source, "droga.extasis", source )
						setElementData(source, "droga", "extasis")
					elseif id == 21 then 
					    exports.chat:me( source, "toma metanfetamina." )
					    take( source, slot )
						triggerClientEvent ( source, "droga.metanfetamina", source )
						setElementData(source, "droga", "metanfetamina.")
					elseif id == 22 then
					    exports.chat:me( source, "saca la marihuana de la bolsita y se lia unos porros." )
					    take( source, slot )
						give ( source, 18, 1 )
						give ( source, 18, 1 )
						give ( source, 18, 1 )
						give ( source, 18, 1 )
						give ( source, 18, 1 )
					elseif id == 23 then
					    exports.chat:me( source, "saca unas rayas de la bolsita." )
					    take( source, slot )
						give ( source, 21, 1 )
						give ( source, 21, 1 )
						give ( source, 21, 1 )
						give ( source, 21, 1 )
						give ( source, 21, 1 )
					elseif id == 24 then
					mascara = getElementData(source, "mascara")
						if mascara == false or nil then
							setElementData(source, "mascara", true)
							exports.chat:me( source, "se pone una bandana." )
						else
							removeElementData(source, "mascara")
							exports.chat:me( source, "se quita su bandana." )
						end						
				    elseif id == 25 then
                        if not getElementData( source, "linterna" ) == true then
                        local x, y, z = getElementPosition ( source )
						local dimension = getElementDimension ( source )
						local interior = getElementInterior ( source )
					    exports.chat:me( source, "coge una linterna del bolsillo." )
                        luz = createMarker ( x + 2, y + 2, z, "corona", 0.29, 255, 255, 255, 170 )
						setElementDimension( luz, dimension )
						setElementInterior( luz, dimension )
                        exports.bone_attach:attachElementToBone(luz,source,12,-0.93,-0.01,0.121,0,45,0)
                        setElementData( source, "linterna", true )
                        else
					    exports.chat:me( source, "guarda su linterna en el bolsillo." )
                        destroyElement( luz )
                        setElementData( source,"linterna", false )
					    end 
                    elseif id == 26 then
					   local value = tonumber(value)
					   setElementData(source, "porcentajeactual", value)
					   exports.chat:me(source, "coge un mechero de su bolsillo.")
					   setElementData(source, "mechero", true)
					   local value2 = getElementData(source, "porcentajeactual")
					   local value2 = tonumber(value2)
					   if value2 >= 1 then
					   local value3 = value2-1
					   local value3 = tonumber(value3)
					   take(source, slot)
					   give(source, 26, value3)
					   porcentaje = value3*2
                       outputChatBox("Te queda de gas un "..porcentaje.."%.", source, 0, 255, 0)
                       else
					   take(source, slot)
					   outputChatBox("Se ha gastado tu mechero.", source, 255, 0, 0)
					   end
					elseif id == 27 then
						outputChatBox("Utiliza /emuebles para poder colocar o vender este mueble.", source, 255, 0, 0)
					elseif id == 28 then -- Caja de teléfono
						local imei = "35"
						for i = 1, 13 do
							local c = tostring(math.random(0, 9))
							imei = imei..c
						end
						local n = "6"
						for i = 1, 6 do
							local c = tostring(math.random(0, 9))
							n = n..c
						end
							local sql = exports.sql:query_assoc_single("SELECT 'registro_ID' FROM 'tlf_data' WHERE 'numero' = '"..tostring(n).."' OR 'imei' = '"..tostring(imei).."'")
							if sql then
								outputChatBox("Ups, ha ocurrido un error. Inténtalo de nuevo.", source, 255, 0, 0)
								return
							else
								take ( source, slot )
								give ( source, 7, imei, "Telefono Movil")
								exports.sql:query_insertid("INSERT INTO `tlf_data` (`registro_ID`, `numero`, `imei`, `titular`, `estado`, `agenda`) VALUES (NULL, '"..tostring(n).."', '"..tostring(imei).."', '"..tostring(exports.players:getCharacterID(source)).."', '0', '');")
								outputChatBox("Has dado de alta tu teléfono móvil. Nº de la línea: "..tostring(n)..".", source, 0, 255, 0)
								outputChatBox("Titular: "..tostring(getPlayerName(source)):gsub("_", " ")..". IMEI del teléfono: "..tostring(imei)..".", source, 0, 255, 0)
								exports.objetivos:addObjetivo(8, exports.players:getCharacterID(source), source)
							end
					elseif id == 29 then -- Armas
						local sql = exports.sql:query_assoc("SELECT * FROM items WHERE item = 29")
						for k, v in ipairs(sql) do
							if exports.players:getCharacterID(source) == tonumber(v.owner) and tonumber(value) == tonumber(v.value) and tonumber(value2) == tonumber(v.value2) then		
								local wSlot = getSlotFromWeapon(value)
								local armaFromSlot = getPedWeapon(source, wSlot)
								local balasFromArma = getPedTotalAmmo(source, wSlot)
								if armaFromSlot and armaFromSlot ~= 0 and balasFromArma ~= 0 then 
									outputChatBox("No puedes sacar dos armas iguales para fusionar balas. Incidente reportado.", source, 255, 0, 0)
									exports.logs:addLogMessage("bugs", "El jugador " .. getPlayerName(source) .. " ha intentado bugear el sistema de armas #4 Fusionar balas de dos pistolas.")
									return
								else
									if purgaVar == false then
										if (value == 32 or value == 26 or value == 33) then
											outputChatBox("Este arma sólo puede ser utilizada en eventos.", source, 255, 0, 0)
											purgaVar = true -- Desbug rapido.
											return
										end
									else
										if (value ~= 32 and value ~= 26 and value ~=33) then
											outputChatBox("Este arma no puede ser utilizada en eventos.", source, 255, 0, 0)
											return
										end
									end
									take(source, slot)
									exports.chat:me(source, "saca su "..getWeaponNameFromID(value).." y le quita el seguro.", "(Arma)")
									if tonumber(v.value2) <= 1 then
										outputChatBox("Has sacado tu "..getWeaponNameFromID(value).." sin balas. Pulsa 'R' para recargarla. Utiliza /guardararma para guardarla.", source, 0, 255, 0)
										giveWeapon(source, tonumber(value), 1)
									else
										outputChatBox("Has sacado tu "..getWeaponNameFromID(value).." con "..tostring(tonumber(v.value2)-1).." balas. Utiliza /guardararma para guardarla.", source, 0, 255, 0)
										giveWeapon(source, tonumber(value), tonumber(v.value2))  
									end
									if tonumber(value) == 41 then
										outputChatBox("Comandos: /pintar /borrar /copiar /tam (sólo facciones oficiales ilegales)", source, 0, 255, 0)
									end
								end
							end
						end	
					elseif id == 30 then -- Kit buceo
						if isElementInWater(source) then outputChatBox("(( No puedes quitarte o ponerte el kit en el agua )).", source, 255, 0, 0) return end
						buzo = getElementData(source, "buzo")
							if buzo == false or nil then
								setElementData(source, "buzo", true)
								exports.chat:me( source, "abre una caja y se coloca el kit de buceo abrochandose todo." )
								setElementModel(source,279)
							else
								removeElementData(source, "buzo")
								exports.chat:me( source, "se quita el kit de buceo y lo mete en una caja." )
								if getElementModel(source) > 0 then setElementModel(source, 0) end
								local s = exports.sql:query_assoc_single("SELECT genero, color, musculatura, gordura FROM characters WHERE characterID = "..exports.players:getCharacterID(source))
								removePedClothes(source, 17)
								if tonumber(s.genero) == 1 and tonumber(s.color) == 1 then
									triggerClientEvent("onSolicitarRopaBlanco", source)
								end
							    setPedStat(source,23,tostring(s.musculatura))
								setPedStat(source,21,tostring(s.gordura))
							end	
					elseif id == 31 then -- Ingrediente
						exports.chat:me( source, "mira su ingrediente y no pasa nada." )						
					elseif id == 32 then -- Walkie talkie
						outputChatBox("Estás en la frecuencia "..tostring(value)..". Puedes cambiarla usando /cambiarfrecuencia [1-9999]", source, 0, 255, 0)
					elseif id == 33 then -- Loteria
						local sql = exports.sql:query_assoc_single("SELECT loteria FROM characters WHERE characterID = "..exports.players:getCharacterID(source))
						if sql.loteria and sql.loteria >= 1 then outputChatBox("Ya tienes un cupón de lotería, debes de esperar al próximo PayDay (Nº "..tostring(sql.loteria)..")", source, 255, 0, 0) return end
						local boleto = math.random(1, 5)
						if exports.sql:query_free("UPDATE characters SET loteria = " .. boleto .. " WHERE characterID = "..exports.players:getCharacterID(source)) then
							exports.factions:giveFactionPresupuesto(5, 40)
							outputChatBox("El número de tu cupón de lotería es el "..tostring(boleto).. ". Espera al PayDay para ver si te toca.", source, 0, 255, 0)
							take(source, slot)
						end
					elseif id == 34 then -- Pieza
						outputChatBox("Tienes un total de "..tostring(value).. " piezas. Pulsa F5 para usarlas en el panel.", source, 0, 255, 0)	
					elseif id == 42 then
						local interiorID = getElementDimension(source)
						if interiorID == 0 then outputChatBox("Debes de estar dentro del interior para usar la cerradura.", source, 255, 0, 0) return end
						local sql = exports.sql:query_assoc_single("SELECT characterID, idasociado FROM interiors WHERE interiorID = "..tostring(interiorID))
						if not sql then 
							outputChatBox("Error grave abre incidencia en el F1 indicando este ID: "..tostring(interiorID), source, 255, 0, 0)
						else
							if tonumber(exports.players:getCharacterID(source)) == tonumber(sql.characterID) then
								exports.admin:anularLlaves(tonumber(interiorID), 2)
								exports.items:give(source, 2, interiorID, "Llaves de propiedad")
								if tonumber(sql.idasociado) > 0 then
									exports.admin:anularLlaves(tonumber(sql.idasociado), 2)
									exports.items:give(source, 2, sql.idasociado, "Llaves de propiedad")
								end
								outputChatBox("Has cambiado correctamente la cerradura de tu interior.", source, 0, 255, 0)
								take(source, slot)
							else
								outputChatBox("No eres el dueño de este interior.", source, 255, 0, 0)
							end
						end
					elseif id == 43 then
						outputChatBox("Saca el arma a recargar y pulsa la tecla R.", source, 255, 0, 0)
					elseif id == 45 then
						if tonumber(value) == 1002 then
							outputChatBox("Esta invitación ha dejado de ser válida.", source, 255, 0, 0)
							return
						end
						outputChatBox("¡Enhorabuena, has encontrado una invitación especial!", source, 0, 255, 0)
						outputChatBox("¿Por qué no vas a los baños del Bar 'General Store'?", source, 0, 255, 0)
						outputChatBox("Se ha marcado su ubicación con las letras 'BS' en el mapa (F11)", source, 0, 255, 0)
						createBlip( 1257.09, 274.75, 19.55, 8, 2, 255, 0, 0, 255, 0, 1000, source)
					elseif id == 46 then
						if getPedArmor(source) >= 1 then
							outputChatBox("No puedes ponerte un chaleco si ya tienes uno, usa /gchaleco.", source, 255, 0, 0)
						else
							take(source, slot)
							exports.chat:me( source, "se pone su chaleco antibalas.")
							setPedArmor(source, tonumber(value))
							outputChatBox("Podrás usar /gchaleco para guardarlo.", source, 0, 255, 0)
						end
					else
						exports.chat:me( source, "mira su " .. name .. ". No pasa nada..." )	
					end
				end
			end
		end
	end
)


addEvent( "items:use2", true )
addEventHandler( "items:use2", root,
	function( slot, otherP )
		if source == client or otherP then
			if exports.players:isLoggedIn( source ) and exports.players:isLoggedIn( otherP ) then
				local item = get( otherP )[ slot ]
				if item then
					local id = item.item
					local index = item.index
					local value = item.value
					local value2 = item.value2
					local name = item.name or getName( id )
					if id == 12 then 
						if not value2 or tonumber(value) < 5 then
							outputChatBox("¡Ups! Esta mochila es antigua, no puede tener nada dentro.", source, 255, 0, 0)
							return
						end
						local sql = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM items_mochilas WHERE mochilaID = "..value2)
						triggerClientEvent(source, "onRequestAnotherMochila", source, sql)
					else
						outputChatBox("No puedes interactuar con este objeto del cacheado.", source, 255, 0, 0)
					end
				end
			end
		end
	end
)


function utilizarCargador (player)
	-- Forzamos recarga 
	load(player, true)
	local arma = getPedWeapon(player)
	local wSlot = getSlotFromWeapon(arma)
	local balasFromArma = getPedTotalAmmo(player, wSlot)
	if arma and arma ~= 0 and balasFromArma ~= 0 then
		if balasFromArma == 1 then
			local i1, slot, t = has(player, 43, tonumber(arma))
			if slot and t then
			--
			value = tonumber(t.value)
			if purgaVar == false then
				if (value == 32 or value == 26 or value == 33) then
					outputChatBox("Este arma sólo puede ser utilizada en eventos.", player, 255, 0, 0)
					return
				end
			else
				if (value ~= 32 and value ~= 26 and value ~=33) then
					outputChatBox("Este arma no puede ser utilizada en eventos.", player, 255, 0, 0)
					return
				end
			end
			--
				if giveWeapon(player, tonumber(t.value), tonumber(t.value2)) then
					reloadPedWeapon(player)
					exports.chat:me(player, "recarga su arma.", "(Cargador)")
					take(player, slot)
					toggleControl (player, "fire", true)
					toggleControl (player, "vehicle_fire", true)
				end
			else
				outputChatBox("No tienes un cargador del arma que llevas equipada.", player, 255, 0, 0)
			end
		else
			outputChatBox("Debes de haber agotado el cargador para recargar el arma.", player, 255, 0 ,0)
		end
	else
		outputChatBox("Saca primero un arma para poder recargarla.", player, 255, 0, 0)
	end
end
addCommandHandler("rec", utilizarCargador)

function checkRelojYMochila()
	if has(source, 9) then
		setPlayerHudComponentVisible(source, "clock", true)
		setElementData(source, "tieneReloj", true)
	else
		setPlayerHudComponentVisible(source, "clock", false)
		removeElementData(source, "tieneReloj")	
	end
	if has(source, 12) then
		local i1, i2, t = has(source, 12)
		if tonumber(t.value) > 5 then
			if getElementData ( source, "Bags" ) then
				removeElementData ( source, "Bags" )
				removeElementData ( source, "BagsModel" )
				if mochila [source] and isElement(mochila [source]) then
					destroyElement (mochila [source])
				end
			end
			setElementData ( source, "Bags", true )
			setElementData ( source, "BagsModel", tonumber(t.value))
			local x,y,z = getElementPosition (source)
			local dim = getElementDimension (source)
			local int = getElementInterior (source)
			if isElement (mochila [source]) then destroyElement (mochila [source]) end						 
			mochila [source] = createObject ( t.value, x, y, z )
			setElementDimension ( mochila [source], dim )
			setElementInterior ( mochila [source], int )
			if tonumber(t.value) == 2081 then
				exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
			elseif tonumber(t.value) == 2082 then
				exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
			elseif tonumber(t.value) == 2083 then
				exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,-90,180,0)
			elseif tonumber(t.value) == 2084 then
				exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.14,0, 90,0,0)
			end
		else
			outputChatBox("Por favor, usa las mochila/s de tu inventario para actualizarlas al nuevo sistema.", source, 255, 0, 0)
		end
	else
		if getElementData ( source, "Bags" ) then
			removeElementData ( source, "Bags" )
			removeElementData ( source, "BagsModel" )
			destroyElement (mochila [source])
		end
	end
end
addEvent("onCheckRelojYMochila", true)
addEventHandler("onCheckRelojYMochila", getRootElement(), checkRelojYMochila)

function cambiarFrecuencia(player,c,frec)
	if exports.items:has(player, 32) then
		if tonumber(frec) and tonumber(frec) >= 1 and tonumber(frec) <= 9999 then
			take3(player, 32)
			exports.items:give(player, 32, tonumber(frec), "Walkie")
			outputChatBox("Has cambiado la frecuencia de tu Walkie-Talkie a la frecuencia "..tostring(frec)..".", player, 0, 255, 0)
		else
		outputChatBox("Error. /cambiarfrecuencia [1-9999] Ejemplo: /cambiarfrecuencia 2", player, 255, 0, 0)
		end
	else
		outputChatBox("No tienes un Walkie-Talkie.", player, 255, 0, 0)
	end
end 
addCommandHandler("cambiarfrecuencia", cambiarFrecuencia)


function guardarChaleco (player)
	if getPedArmor(player) >= 1 then
		exports.chat:me( source, "guarda su chaleco antibalas.")
		give(player, 46, tonumber(getPedArmor(player)), "Chaleco Antibalas")
		setPedArmor(player, 0)
	else
		outputChatBox("No tienes un chaleco puesto que guardar.", player, 255, 0, 0)
	end
end
addCommandHandler("gchaleco", guardarChaleco)

 
function guardarArma (player)
	local weapon = getPedWeapon(player)
	local ammo = getPedTotalAmmo(player)
	if weapon and weapon >= 1 then
		exports.chat:me(player, "guarda su "..getWeaponNameFromID(weapon)..".", "(/guardararma)")
		outputChatBox("Has guardado tu "..getWeaponNameFromID(weapon).." con "..ammo.." balas.", player, 0, 255, 0)		
		local name = "Arma "..tostring(weapon)
		give(player, 29, tonumber(weapon), tostring(name), tonumber(ammo))
		takeWeapon(player, weapon)
	end
end
addCommandHandler("guardararma", guardarArma)

function guardarArmas (player)
	for i=1,12 do
		local weapon = getPedWeapon(player,i)
		local ammo = getPedTotalAmmo(player, i)
		if weapon and weapon >= 1 then
			local name = "Arma "..tostring(weapon)
			give(player, 29, tonumber(weapon), tostring(name), tonumber(ammo))
			takeWeapon(player, weapon)
		end
	end
	outputChatBox("Se han mandado tus armas al inventario.", player, 255, 0, 0)
end
addEvent("onSolicitarGuardarArmas", true)
addEventHandler("onSolicitarGuardarArmas", getRootElement(), guardarArmas)

function guardarArmas2 (player)
	for i=1,12 do
		local weapon = getPedWeapon(player,i)
		local ammo = getPedTotalAmmo(player, i)
		if weapon and weapon >= 1 then
			exports.chat:me(player, "guarda su "..getWeaponNameFromID(weapon)..".", "(/guardararmas)")
			if tonumber(ammo) > 1 then
				outputChatBox("Has guardado tu "..getWeaponNameFromID(weapon).." con "..(ammo-1).." balas.", player, 0, 255, 0)
			else
				outputChatBox("Has guardado tu "..getWeaponNameFromID(weapon).." sin balas.", player, 0, 255, 0)
			end
			local name = "Arma "..tostring(weapon)
			give(player, 29, tonumber(weapon), tostring(name), tonumber(ammo))
			takeWeapon(player, weapon)
		end
	end
end
addCommandHandler("guardararmas", guardarArmas2)

tabaco = {}
caladas = {}
maxCaladas = 15

function fumar (source)
	if not getElementData(source, "fumandoCigarro") then
		caladas [source] = 0
		startSmoking (source)
		if not getElementData(source, "muerto") then
			setPedAnimation ( source, "SMOKING", "M_smk_in", -1, false, false, false, false)
		end
		exports.chat:me (source, " se enciende un cigarro y empieza a fumar.")
		outputChatBox("Con /tirarc tiras el cigarro y al boton izquierdo del ratón das una calada.", source, 0, 255, 0)
		--outputChatBox("También puedes usar /cambiarmano para cambiar el cigarro de mano.", source, 0, 255, 0)
	end
end
addEvent("onFumarCigarro", true)
addEventHandler("onFumarCigarro", root, fumar)

function startSmoking (source)
	toggleControl (source,"fire",false)
	if isElement (tabaco [source]) then destroyElement (tabaco [source]) end
	tabaco [source] = createObject ( 3044, 0, 0, -1000 )
	setElementData ( source, "fumandoCigarro", true )
	actualizarPosicion ( source )
	exports.bone_attach:attachElementToBone(tabaco [source],source,12,-0.1,-0.01,0.121,0,0,80)
	bindKey (source, "mouse1", "down", calada)
end

function calada (source)
	if getElementData(source, "fumandoCigarro") then
		if caladas [source] ~= maxCaladas then
			caladas [source] = caladas [source] + 1
			if not getElementData(source, "muerto") then
				setPedAnimation ( source, "SMOKING", "M_smk_drag", 3000, false, false, false, false)
			end
		elseif caladas [source] == maxCaladas then
			caladas [source] = nil
			removeElementData ( source, "fumandoCigarro" )
			removeElementData ( source, "realism:smoking" )
			if not getElementData(source, "muerto") then
				setPedAnimation ( source, "SMOKING", "M_smk_out", 3500, false, false, false, false)
			end
			destroyElement( tabaco [source] )
			unbindKey (source, "mouse1", "down", calada)
			unbindKey (source, "space", "down", tirarCigarro)
			exports.chat:me (source, " tira su cigarro consumido al suelo.")
			toggleControl (source,"fire",true)
		end
	end
end

function tirarCigarro (thePlayer)
	if getElementData(thePlayer, "fumandoCigarro") then
		toggleControl (thePlayer,"fire",true)
		if not getElementData(thePlayer, "muerto") then
			setPedAnimation ( thePlayer, "SMOKING", "M_smk_out", 3500, false, false, false, false)
		end
		destroyElement( tabaco [thePlayer] )
		unbindKey (thePlayer, "mouse1", "down", calada)
		exports.chat:me (thePlayer, " tira su cigarro a medias al suelo.")
		removeElementData ( thePlayer, "fumandoCigarro" )
		--stopSmoking(thePlayer)
	end
end
addCommandHandler("tirarc", tirarCigarro)
addCommandHandler("tirarcigarro", tirarCigarro)

-- addEvent("realism:startsmoking", true)
-- addEventHandler("realism:startsmoking", getRootElement(),
	-- function(hand)
		-- if not (hand) then
			-- hand = 0
		-- else
			-- hand = tonumber(hand)
		-- end
		-- triggerClientEvent("realism:smokingsync", source, true, hand)
	-- end
-- )

-- function stopSmoking(thePlayer)
	-- if not thePlayer then
		-- thePlayer = source
	-- end
	-- if (isElement(thePlayer)) then	
		-- local isSmoking = getElementData(thePlayer, "realism:smoking")
		-- if (isSmoking) then
			-- triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
		-- end
	-- end
-- end
-- addEvent("realism:stopsmoking", true)
-- addEventHandler("realism:stopsmoking", getRootElement(), stopSmoking)

-- function changeSmokehand(thePlayer)
	-- local isSmoking = getElementData(thePlayer, "realism:smoking")
	-- if (isSmoking) then
		-- local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
		-- triggerClientEvent("realism:smokingsync", thePlayer, true, 1-smokingHand)
	-- end
-- end
-- addCommandHandler("cambiarmano", changeSmokehand)

-- Sync to new players
-- addEvent("realism:smoking.request", true)
-- addEventHandler("realism:smoking.request", getRootElement(), 
	-- function ()
		-- local players = getElementsByType("player")
		-- for key, thePlayer in ipairs(players) do
			-- local isSmoking = getElementData(thePlayer, "realism:smoking")
			-- if (isSmoking) then
				-- local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
				-- triggerClientEvent(source, "realism:smokingsync", thePlayer, isSmoking, smokingHand)
			-- end
		-- end
	-- end
-- );

function createHelmet (s,m)
	local x,y,z = getElementPosition (s)
	local dim = getElementDimension (s)
	local int = getElementInterior (s)
	if isElement (casco [s]) then destroyElement (casco [s]) end
	casco [s] = createObject ( m, x, y, z )
	setObjectScale ( casco [s], 1.3 )
	setElementData ( s, "Cascos", true )
	setElementDimension ( casco [s], dim )
	setElementInterior ( casco [s], int )
	exports.bone_attach:attachElementToBone(casco [s],s,1,0,-0.015,-0.82,0,0,90)
	exports.chat:me (s, "se pone el casco.")
end

function actualizarPosicion (player)
	if isElement (tabaco [player]) then
		setElementDimension ( tabaco [player], getElementDimension(player) )
		setElementInterior ( tabaco [player], getElementInterior(player) )
	end
	if isElement (casco [player]) then
		setElementDimension ( casco [player], getElementDimension(player) )
		setElementInterior ( casco [player], getElementInterior(player) )
	end
	if isElement (mochila [player]) then
		setElementDimension ( mochila [player], getElementDimension(player) )
		setElementInterior ( mochila [player], getElementInterior(player) )
	end
end

function onLogout ()
	if isElement (mochila [source]) then destroyElement (mochila [source]) end
	if isElement (casco [source]) then removeElementData(source, "Cascos") destroyElement (casco [source]) end
	if isElement (tabaco [source]) then destroyElement (tabaco [source]) end
end
addEventHandler ("onCharacterLogout", getRootElement(),onLogout) 
addEventHandler ("onPlayerQuit", getRootElement(),onLogout) 
							
addEvent( "items:copy", true )
addEventHandler( "items:copy", root,
	function( slot, copias )
		if source == client then
			if exports.players:isLoggedIn( source ) then
				local c = get( source )[ slot ]
				if c then
					local id = c.item
					local value = c.value
					local name = c.name or getName( id )
					if copias == 1 then
						if id == 2 and exports.interiors:isInteriorAlquiler(value) then
							outputChatBox("No puedes copiar llaves de alquileres.", source, 255, 0, 0)
							return
						end
						give( source, id, value, name )
						exports.chat:me( source, "hace una copia de las llaves." )
					else
						outputChatBox( "El ticket solo vale para una copia.", source, 255, 0, 0 )
					end
				end
			end
		end
	end
)

addEvent( "items:give", true )
addEventHandler( "items:give", root,
	function( slot )
		if source == client then
			if exports.players:isLoggedIn( source ) then
				local c = get( source )[ slot ]
				if c then
					local id = c.item
					local value = c.value
					local value2 = c.value2
					local name = c.name or getName( id )
					if getElementData(source, "daritem.id") then outputChatBox("¡Da o guarda el item antes de dar otro!",source, 255, 0, 0) return end
					setElementData(source, "daritem.id", id)
					setElementData(source, "daritem.value", value)
					setElementData(source, "daritem.name", tostring(name))
					if value2 then
						setElementData(source, "daritem.value2", tonumber(value2))
					end
					if id == 29 then
						outputChatBox("Para dar un arma debes de sacarla y usar /dararma [jugador].",source, 255, 0, 0)
						removeElementData(source, "daritem.id")
						removeElementData(source, "daritem.value")
						removeElementData(source, "daritem.name")
						removeElementData(source, "daritem.value2")
						return			
					end
					outputChatBox("Pon /daritem [id] para dar un/a "..tostring(name)..".",source, 0, 255, 0)
				end
			end
		end
	end
)

function darItemAUsuario(player,cmd,id)
	local otro, nombre = exports.players:getFromName(player, id)
	if not otro then outputChatBox("Jugador no encontrado.",player, 255, 0, 0) return end
	if player == otro then
		outputChatBox("¿Por qué ibas a querer darte un item a ti mismo?", player, 255, 0, 0)
		exports.logs:addLogMessage("bug-daritem", tostring(getPlayerName(player)))
		return
	end
	local x, y, z = getElementPosition(player)
	local x2, y2, z2 = getElementPosition(otro)
	local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
	if distance > 3 then outputChatBox("El jugador seleccionado está demasiado lejos.", player, 255, 0, 0) return end
	if not getElementData(player, "daritem.id") then outputChatBox("Selecciona primero un item desde el inventario", player, 255, 0, 0) return end
	if take2( player, getElementData(player, "daritem.id"), getElementData(player, "daritem.value"), true) then
		if getElementData(player, "daritem.value2") then
			give( otro, getElementData(player, "daritem.id"), getElementData(player, "daritem.value"), tostring(getElementData(player, "daritem.name")), tonumber(getElementData(player, "daritem.value2")) )
		else
			if tonumber(getElementData(player, "daritem.id")) == 7 then
				local val = string.format("%13.0f",getElementData(player, "daritem.value"))
				give( otro, getElementData(player, "daritem.id"), val, tostring(getElementData(player, "daritem.name")) )
			else
				give( otro, getElementData(player, "daritem.id"), getElementData(player, "daritem.value"), tostring(getElementData(player, "daritem.name")) )
			end
		end
		exports.chat:me( player, "entrega un/a "..tostring(getElementData(player, "daritem.name")).." a "..getPlayerName(otro):gsub("_", " "), "(Dar Item)" )
		exports.chat:me( otro, "coge el/la "..tostring(getElementData(player, "daritem.name")).." que le ha dado "..getPlayerName(player):gsub("_", " "), "(Dar Item)")
		-- Now, we should check if player has clock and bag to render it or not.
		if has(player, 9) then
			setPlayerHudComponentVisible(player, "clock", true)
			setElementData(player, "tieneReloj", true)
		else
			setPlayerHudComponentVisible(player, "clock", false)
			removeElementData(player, "tieneReloj")	
		end
		if has(player, 12) then
			local i1, i2, t = has(player, 12)
			if getElementData ( player, "Bags" ) then
				removeElementData ( player, "Bags" )
				removeElementData ( player, "BagsModel" )
				destroyElement (mochila [player])
			end
			setElementData ( player, "Bags", true )
			setElementData ( player, "BagsModel", tonumber(t.value))
			local x,y,z = getElementPosition (player)
			local dim = getElementDimension (player)
			local int = getElementInterior (player)
			if isElement (mochila [player]) then destroyElement (mochila [player]) end						 
			mochila [player] = createObject ( t.value, x, y, z )
			setElementDimension ( mochila [player], dim )
			setElementInterior ( mochila [player], int )
			if tonumber(t.value) == 2081 then
				exports.bone_attach:attachElementToBone(mochila [player],player,3,0,-0.2,0,90,0,0)
			elseif tonumber(t.value) == 2082 then
				exports.bone_attach:attachElementToBone(mochila [player],player,3,0,-0.2,0,90,0,0)
			elseif tonumber(t.value) == 2083 then
				exports.bone_attach:attachElementToBone(mochila [player],player,3,0,-0.2,0,-90,180,0)
			elseif tonumber(t.value) == 2084 then
				exports.bone_attach:attachElementToBone(mochila [player],player,3,0,-0.14,0, 90,0,0)
			end
		else	
			if getElementData ( player, "Bags" ) or isElement (mochila [player]) then
				removeElementData ( player, "Bags" )
				removeElementData ( player, "BagsModel" )
				destroyElement (mochila [player])
			end
		end
		-- End check
		removeElementData(player, "daritem.id")
		removeElementData(player, "daritem.value")
		removeElementData(player, "daritem.name")
		removeElementData(player, "daritem.value2")
	else
		outputChatBox("No puedes dar un item que no tienes.", player, 255, 0, 0)
	end
end
addCommandHandler("daritem",darItemAUsuario)

-- function alDesconectarse ()
	-- if source and getElementData(source, "daritem.id") then
		-- guardarItemUsuario(source)
	-- end
-- end
-- addEventHandler("onCharacterLogout", getRootElement(), alDesconectarse)
-- addEventHandler("onPlayerQuit", getRootElement(), alDesconectarse)

-- function guardarItemUsuario(player)
	-- if not getElementData(player, "daritem.id") then outputChatBox("Selecciona primero un item desde el inventario.", player, 255, 0, 0) return end
	-- if getElementData(player, "daritem.value2") then
		-- give( player, getElementData(player, "daritem.id"), getElementData(player, "daritem.value"), tostring(getElementData(player, "daritem.name")), tonumber(getElementData(player, "daritem.value2")) )
	-- else
		-- give( player, getElementData(player, "daritem.id"), getElementData(player, "daritem.value"), tostring(getElementData(player, "daritem.name")) )
	-- end
	-- outputChatBox("Has guardado tu item correctamente.", player, 0, 255, 0)
	-- removeElementData(player, "daritem.id")
	-- removeElementData(player, "daritem.value")
	-- removeElementData(player, "daritem.name")
	-- removeElementData(player, "daritem.value2")
-- end
--addCommandHandler("guardaritem",guardarItemUsuario)
 
function quitarCasco(source)
	if isElement (casco [source]) or getElementData ( source, "Cascos" ) == 1 then		
		exports.chat:me( source, "se quita el casco." )
		removeElementData ( source, "Cascos" )
		if isElement(casco [source]) then destroyElement (casco [source]) end
    end
end 
 
addEvent( "items:getFromMaletero", true )
addEventHandler( "items:getFromMaletero", root,
	function( slot )
		if source and exports.players:isLoggedIn( source ) and client == source and slot then
			local sql = exports.sql:query_assoc("SELECT * FROM maleteros WHERE `index` = "..slot)
			for k, v in ipairs(sql) do
				-- PARCHE SISTEMA MÓVIL --
				if v.item == 7 then
					give( source, v.item, string.format("%13.0f",v.value), (tostring(v.name) or exports.items:getName( v.item )), tonumber(v.value2))
				else
					if tonumber(v.value) ~= nil then
						give( source, v.item, tonumber(v.value), (tostring(v.name) or exports.items:getName( v.item )), tonumber(v.value2))
					else
						give( source, v.item, tostring(v.value), (tostring(v.name) or exports.items:getName( v.item )), tonumber(v.value2))
					end
				end
				-- FIN PARCHE --
				exports.chat:me(source, "saca un/a "..(v.name or exports.items:getName( v.item )).." del maletero.")
				exports.sql:query_free("DELETE FROM maleteros WHERE `index` = "..slot)
			end
			local sql2 = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM maleteros WHERE vehicleID = "..getElementData(source, "mid"))
			triggerClientEvent(source, "onAbrirMaletero", source, source, getElementData(source, "mid"), 2, sql2)
		end
	end
)

addEvent( "items:giveToMaletero", true )
addEventHandler( "items:giveToMaletero", root,
	function( slot )
		if source == client and slot then
			if exports.players:isLoggedIn( source ) then
				local item = get( source )[ slot ]
				if item then
					local id = item.item
					local value = item.value
					local value2 = item.value2
					local name = item.name or exports.items:getName( id )
					local vehicleID = getElementData(source, "mid")
					local vehicleID = tonumber(vehicleID)
					if not vehicleID or tonumber(vehicleID) == nil then outputChatBox("Error grave. Inténtalo mas tarde.", source, 255, 0, 0) return end
					name2 = "NULL"
					if name then 
						name2 = "'" .. exports.sql:escape_string( tostring( name ) ) .. "'"
					else
						name = nil 
					end
					-- PARCHE PARA NUEVO SISTEMA MÓVIL --
					if id == 7 then
						-- Realizamos un fix ahora mismo --
						value = string.format("%13.0f",value)
					end	
					-- FIN PARCHE --
					local index, error = exports.sql:query_insertid( "INSERT INTO maleteros (vehicleID, item, value, name) VALUES (" .. vehicleID .. ", " .. id .. ", '%s', " .. name2 .. ")", value )
					if index and not error then
						take( source, slot )
						if value2 then
							exports.sql:query_free("UPDATE maleteros SET value2 = "..tonumber(value2).." WHERE `index` = "..index)
						end
						exports.chat:me( source, "guarda un/a "..(name or exports.items:getName( id )).." en el maletero." )
						if id == 9 then
							if has(source, 9) then
								setPlayerHudComponentVisible(source, "clock", true)
								setElementData(source, "tieneReloj", true)
							else
								setPlayerHudComponentVisible(source, "clock", false)
								removeElementData(source, "tieneReloj")
							end
						elseif id == 12 then
							if has(source, 12) then
								local i1, i2, t = has(source, 12)
								if tonumber(t.value) > 5 then
									if getElementData ( source, "Bags" ) then
										removeElementData ( source, "Bags" )
										removeElementData ( source, "BagsModel" )
										destroyElement (mochila [source])
									end
									setElementData ( source, "Bags", true )
									setElementData ( source, "BagsModel", tonumber(t.value) )
									local x,y,z = getElementPosition (source)
									local dim = getElementDimension (source)
									local int = getElementInterior (source)
									if isElement (mochila [source]) then destroyElement (mochila [source]) end						 
									mochila [source] = createObject ( t.value, x, y, z )
									setElementDimension ( mochila [source], dim )
									setElementInterior ( mochila [source], int )
									if tonumber(t.value) == 2081 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
									elseif tonumber(t.value) == 2082 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
									elseif tonumber(t.value) == 2083 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,-90,180,0)
									elseif tonumber(t.value) == 2084 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.14,0, 90,0,0)
									end
								else
									outputChatBox("Por favor, usa las mochila/s de tu inventario para actualizarlas al nuevo sistema.", source, 255, 0, 0)
								end
							else
								if getElementData ( source, "Bags" ) then
									removeElementData ( source, "Bags" )
									removeElementData ( source, "BagsModel" )
									destroyElement (mochila [source])
								end
							end
						end
					else
						outputDebugString(error)
					end
					local sql2 = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM maleteros WHERE vehicleID = "..getElementData(source, "mid"))
					triggerClientEvent(source, "onAbrirMaletero", source, source, getElementData(source, "mid"), 3, sql2)
				end
			end
		end
	end
)

addEvent( "items:getFromMueble", true )
addEventHandler( "items:getFromMueble", root,
	function( slot )
		if source and exports.players:isLoggedIn( source ) and client == source and slot then
			local sql = exports.sql:query_assoc("SELECT * FROM items_muebles WHERE `index` = "..slot)
			for k, v in ipairs(sql) do
				-- PARCHE SISTEMA MÓVIL --
				if v.item == 7 then
					give( source, v.item, string.format("%13.0f",v.value), (tostring(v.name) or exports.items:getName( v.item )), tonumber(v.value2))
				else
					if tonumber(v.value) ~= nil then
						give( source, v.item, tonumber(v.value), (tostring(v.name) or exports.items:getName( v.item )), tonumber(v.value2))
					else
						give( source, v.item, tostring(v.value), (tostring(v.name) or exports.items:getName( v.item )), tonumber(v.value2))
					end
				end
				-- FIN PARCHE --
				exports.chat:me(source, "coge un/a "..(v.name or exports.items:getName( v.item )).." del mueble.")
				exports.sql:query_free("DELETE FROM items_muebles WHERE `index` = "..slot)
			end
			local sql2 = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM items_muebles WHERE muebleID = "..getElementData(source, "muebleID"))
			triggerClientEvent(source, "onAbrirMueble", source, source, getElementData(source, "muebleID"), 2, sql2)
		end
	end
)
 
addEvent( "items:giveToMueble", true )
addEventHandler( "items:giveToMueble", root,
	function( slot )
		if source == client and slot then
			if exports.players:isLoggedIn( source ) then
				local item = get( source )[ slot ]
				if item then
					local id = item.item
					local value = item.value
					local value2 = item.value2
					local name = item.name or exports.items:getName( id )
					local muebleID = tonumber(getElementData(source, "muebleID"))
					name2 = "NULL"
					if name then
						name2 = "'" .. exports.sql:escape_string( tostring( name ) ) .. "'"
					else
						name = nil
					end
					-- PARCHE PARA NUEVO SISTEMA MÓVIL --
					if id == 7 then
						-- Realizamos un fix ahora mismo --
						value = string.format("%13.0f",value)
					end	
					-- FIN PARCHE --					
					local index, error = exports.sql:query_insertid( "INSERT INTO items_muebles (muebleID, item, value, name) VALUES (" .. muebleID .. ", " .. id .. ", '%s', " .. name2 .. ")", value )
					if index and not error then
						take( source, slot )
						if value2 then			
							exports.sql:query_free("UPDATE items_muebles SET value2 = "..tonumber(value2).." WHERE `index` = "..index)
						end
						exports.chat:me( source, "guarda un/a "..(name or exports.items:getName( id )).." en el mueble." )
						if id == 9 then
							if has(source, 9) then
								setPlayerHudComponentVisible(source, "clock", true)
								setElementData(source, "tieneReloj", true)
							else
								setPlayerHudComponentVisible(source, "clock", false)
								removeElementData(source, "tieneReloj")
							end
						elseif id == 12 then
							if has(source, 12) then
								local i1, i2, t = has(source, 12)
								if tonumber(t.value) > 5 then
									if getElementData ( source, "Bags" ) then
										removeElementData ( source, "Bags" )
										removeElementData ( source, "BagsModel" )
										destroyElement (mochila [source])
									end
									setElementData ( source, "Bags", true )
									setElementData ( source, "BagsModel", tonumber(value) )
									local x,y,z = getElementPosition (source)
									local dim = getElementDimension (source)
									local int = getElementInterior (source)
									if isElement (mochila [source]) then destroyElement (mochila [source]) end						 
									mochila [source] = createObject ( t.value, x, y, z )
									setElementDimension ( mochila [source], dim )
									setElementInterior ( mochila [source], int )
									if tonumber(t.value) == 2081 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
									elseif tonumber(t.value) == 2082 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
									elseif tonumber(t.value) == 2083 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,-90,180,0)
									elseif tonumber(t.value) == 2084 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.14,0, 90,0,0)
									end
								else
									outputChatBox("Por favor, usa las mochila/s de tu inventario para actualizarlas al nuevo sistema.", source, 255, 0, 0)
								end
							else
								if getElementData ( source, "Bags" ) then
									removeElementData ( source, "Bags" )
									removeElementData ( source, "BagsModel")
									destroyElement (mochila [source])
								end
							end
						end
					else
						outputDebugString(error)
					end
					local sql2 = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM items_muebles WHERE muebleID = "..getElementData(source, "muebleID"))
					triggerClientEvent(source, "onAbrirMueble", source, source, getElementData(source, "muebleID"), 3, sql2)
				end
			end
		end
	end
)


addEvent( "items:getFromMochila", true )
addEventHandler( "items:getFromMochila", root,
	function( slot )
		if source and exports.players:isLoggedIn( source ) and client == source and slot then
			local sql = exports.sql:query_assoc("SELECT * FROM items_mochilas WHERE `index` = "..slot)
			for k, v in ipairs(sql) do
				-- PARCHE SISTEMA MÓVIL --
				if v.item == 7 then
					give( source, v.item, string.format("%13.0f",v.value), (tostring(v.name) or exports.items:getName( v.item )), tonumber(v.value2))
				else
					give( source, v.item, tostring(v.value), (tostring(v.name) or exports.items:getName( v.item )), tonumber(v.value2))
				end
				-- FIN PARCHE --
				exports.chat:me(source, "saca un/a "..(v.name or exports.items:getName( v.item )).." de la mochila.")
				exports.sql:query_free("DELETE FROM items_mochilas WHERE `index` = "..slot)
			end
			local sql2 = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM items_mochilas WHERE mochilaID = "..getElementData(source, "mochilaID"))
			triggerClientEvent(source, "onAbrirMochila", source, source, getElementData(source, "mochilaID"), 2, sql2) 
		end
	end
)
 
 
addEvent( "items:giveToMochila", true )
addEventHandler( "items:giveToMochila", root,
	function( slot )
		if source == client and slot then
			if exports.players:isLoggedIn( source ) then
				local item = get( source )[ slot ]
				if item then
					local id = item.item
					local value = item.value
					local value2 = item.value2
					local name = item.name or exports.items:getName( id )
					local mochilaID = tonumber(getElementData(source, "mochilaID"))
					name2 = "NULL"
					if id == 12 then return end
					if name then
						name2 = "'" .. exports.sql:escape_string( tostring( name ) ) .. "'"
					else
						name = nil
					end
					-- PARCHE PARA NUEVO SISTEMA MÓVIL --
					if id == 7 then
						value = string.format("%13.0f",value)
					end	
					-- FIN PARCHE --
					local index, error = exports.sql:query_insertid( "INSERT INTO items_mochilas (mochilaID, item, value, name) VALUES (" .. mochilaID .. ", " .. id .. ", '%s', " .. name2 .. ")", value )
					if index and not error then
						take( source, slot )
						if value2 then			
							exports.sql:query_free("UPDATE items_mochilas SET value2 = "..tonumber(value2).." WHERE `index` = "..index)
						end
						exports.chat:me( source, "guarda un/a "..(name or exports.items:getName( id )).." en la mochila." )
						if id == 9 then
							if has(source, 9) then
								setPlayerHudComponentVisible(source, "clock", true)
								setElementData(source, "tieneReloj", true)
							else
								setPlayerHudComponentVisible(source, "clock", false)
								removeElementData(source, "tieneReloj")
							end
						elseif id == 12 then
							if has(source, 12) then
								local i1, i2, t = has(source, 12)
								if tonumber(t.value) > 5 then
									if getElementData ( source, "Bags" ) then
										removeElementData ( source, "Bags" )
										removeElementData ( source, "BagsModel" )
										destroyElement (mochila [source])
									end
									setElementData ( source, "Bags", true )
									setElementData ( source, "BagsModel", tonumber(t.value))
									local x,y,z = getElementPosition (source)
									local dim = getElementDimension (source)
									local int = getElementInterior (source)
									if isElement (mochila [source]) then destroyElement (mochila [source]) end						 
									mochila [source] = createObject ( t.value, x, y, z )
									setElementDimension ( mochila [source], dim )
									setElementInterior ( mochila [source], int )
									if tonumber(t.value) == 2081 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
									elseif tonumber(t.value) == 2082 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
									elseif tonumber(t.value) == 2083 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,-90,180,0)
									elseif tonumber(t.value) == 2084 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.14,0, 90,0,0)
									end
								else
									outputChatBox("Por favor, usa las mochila/s de tu inventario para actualizarlas al nuevo sistema.", source, 255, 0, 0)
								end
							else
								if getElementData ( source, "Bags" ) then
									removeElementData ( source, "Bags" )
									removeElementData ( source, "BagsModel" )
									destroyElement (mochila [source])
								end
							end
						end
					else
						outputDebugString(error)
					end
					local sql2 = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM items_mochilas WHERE mochilaID = "..getElementData(source, "mochilaID"))
					triggerClientEvent(source, "onAbrirMochila", source, source, getElementData(source, "mochilaID"), 3, sql2)
				end
			end
		end
	end
)


function cerrarMochila()
	exports.chat:me(source, "cierra la mochila.", "(Mochila)")
	removeElementData(source, "nogui")
	removeElementData(source, "mochilaID")
end 
addEvent("onCerrarMochila", true)
addEventHandler("onCerrarMochila", getRootElement(), cerrarMochila)


addEvent( "items:destroy", true )
addEventHandler( "items:destroy", root,
	function( slot )
		if source == client then
			if exports.players:isLoggedIn( source ) then
				local item = get( source )[ slot ]
				if item then
					local id = item.item
					local value = item.value
					local name = item.name or getName( id )
					take( source, slot )
					if id == 27 then
						exports.chat:me( source, "se deshizo de un/a " .. exports.muebles:getNombreMueble(value) .. "." )
					else
						if id == 9 then
							if has(source, 9) then
								setPlayerHudComponentVisible(source, "clock", true)
								setElementData(source, "tieneReloj", true)
							else
								setPlayerHudComponentVisible(source, "clock", false)
								removeElementData(source, "tieneReloj")
							end
						elseif id == 12 then
							if has(source, 12) then
								local i1, i2, t = has(source, 12)
								if tonumber(t.value) > 5 then
									if getElementData ( source, "Bags" ) then
										removeElementData ( source, "Bags" )
										removeElementData ( source, "BagsModel" )
										destroyElement (mochila [source])
									end
									setElementData ( source, "Bags", true )
									setElementData ( source, "BagsModel", tonumber(t.value))
									local x,y,z = getElementPosition (source)
									local dim = getElementDimension (source)
									local int = getElementInterior (source)
									if isElement (mochila [source]) then destroyElement (mochila [source]) end						 
									mochila [source] = createObject ( t.value, x, y, z )
									setElementDimension ( mochila [source], dim )
									setElementInterior ( mochila [source], int )
									if tonumber(t.value) == 2081 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
									elseif tonumber(t.value) == 2082 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,90,0,0)
									elseif tonumber(t.value) == 2083 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.2,0,-90,180,0)
									elseif tonumber(t.value) == 2084 then
										exports.bone_attach:attachElementToBone(mochila [source],source,3,0,-0.14,0, 90,0,0)
									end
								else
									outputChatBox("Por favor, usa las mochila/s de tu inventario para actualizarlas al nuevo sistema.", source, 255, 0, 0)
								end
							else
								if getElementData ( source, "Bags" ) then
									removeElementData ( source, "Bags" )
									removeElementData ( source, "BagsModel" )
									destroyElement (mochila [source])
								end
							end
						end
						exports.chat:me( source, "se deshizo de un/a " .. name .. "." )
					end
				end
			end
		end
	end
)

addCommandHandler( "giveitem",
	function( player, commandName, other, id, ... )
		local id = tonumber( id )
		if other and id and ( ... ) then
			local other, pname = exports.players:getFromName( player, other )
			if other then
				-- check if it's a valid item id
				if id >= 0 and id <= #item_list then
					-- we need to split our name and value apart
					local arguments = { ... }
					local value = { }
					local name
					for k, v in ipairs( arguments ) do
						if not name then
							if v == "--" then
								name = { }
							else
								table.insert( value, v )
							end
						else
							table.insert( name, v )
						end
					end
					
					-- get nicer values
					value = table.concat( value, " " )
					value = tonumber( value ) or value
					if name then
						name = table.concat( name, " " )
						if #name == 0 then
							name = nil
						end
					end
					
					-- phone workaround: we need at this point make sure we have a unique phone with a non-arbitrary number
					if id == 7 then
						outputChatBox("Error. Usa /giveitem [id] 28 2 para dar un teléfono.", player, 255, 0, 0)
						return false
					elseif id == 29 then
						outputChatBox("Error. No puedes dar armas usando /giveitem.", player, 255, 0, 0)
					    outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
						return false
					elseif id == 34 then
						outputChatBox("Error. No puedes dar piezas usando /giveitem.", player, 255, 0, 0)
						outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
						return false
					elseif id == 18 then
						outputChatBox("Error. No puedes dar drogas usando /giveitem.", player, 255, 0, 0)
						outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
						return false
					elseif id == 19 then
						outputChatBox("Error. No puedes dar drogas usando /giveitem.", player, 255, 0, 0)
						outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
						return false
                    elseif id == 20 then
						outputChatBox("Error. No puedes dar drogas usando /giveitem.", player, 255, 0, 0)
						outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
						return false
                    elseif id == 21 then
						outputChatBox("Error. No puedes dar drogas usando /giveitem.", player, 255, 0, 0)
						outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
						return false
					elseif id == 22 then
						outputChatBox("Error. No puedes dar drogas usando /giveitem.", player, 255, 0, 0)
						outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
						return false
					elseif id == 23 then
						outputChatBox("Error. No puedes dar drogas usando /giveitem.", player, 255, 0, 0)
						outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
						return false
					elseif id == 45 then
						outputChatBox("Error. No puedes dar invitaciones especiales usando /giveitem.", player, 255, 0, 0)
						outputChatBox("Tu acción ha sido reportada al sistema.", player, 255, 0, 0)
					end
					-- give the item
					if give( other, id, value, name ) then
						outputChatBox( "Has dado a " .. pname .. " el item con " .. id .. " con el value = " .. value .. ( name and ( " (nombre = " .. name .. ")" ) or "" ) .. ".", player, 0, 255, 153 )
					    exports.logs:addLogMessage("giveitemstaff", "El Staff "..getPlayerName(player).." ha seteado a "..getPlayerName(other).." el item con id - " .. id .. " con el valor " .. value .. ( name and ( " (nombre = " .. name .. ")" ) or "" ) .. ".")
					else
						outputChatBox( "(( Fallo al dar el item ))", player, 255, 0, 0 )
					end
				else
					outputChatBox( "(( Item Invalido ))", player, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "Syntax: /" .. commandName .. " [player] [id] [value]", player, 255, 255, 255 )
		end
	end,
	true
)

function darCargadorStaff (player, cmd, otherPlayer, idArma)
	if not hasObjectPermissionTo( player, "command.adminchat", false ) then return end
	if otherPlayer and idArma then
		local balas = balasCargador[tonumber(idArma)]
		if not balas then 
			outputChatBox("Error grave avisa a un desarrollador.", player, 255, 0, 0)
		end
		local other, name = exports.players:getFromName(player, otherPlayer)
		if other then
			if give( other, 43, tonumber(idArma), "Cargador Arma", tonumber(balas) ) then
				outputChatBox("Has dado un cargador a "..name.. " con "..tostring(balas).." balas de un arma ID "..tostring(idArma)..".", player, 0, 255, 0)
			else
				return outputChatBox("Error grave avisa a un desarrollador.", player, 255, 0, 0)
			end
		end
	else
		outputChatBox("Sintaxis: /givecargador [jugador] [ID arma]", player, 255, 255, 255)
	end
end
addCommandHandler("givecargador", darCargadorStaff)
         
function dormirCoche (player)
	if getPedOccupiedVehicle(player) and getVehicleType(getPedOccupiedVehicle(player)) == "Automobile" then
		if getVehicleController(getPedOccupiedVehicle(player)) == player then outputChatBox("No puedes dormir si eres el conductor.", player, 255, 0, 0) return end
		setVehicleLocked(player, true)
		dormirT[player] = setTimer(
		function(player)
			if player and isElement(player) and getPedOccupiedVehicle(player) then
				local model = getElementModel(getPedOccupiedVehicle(player))
				if model == 508 then
					if getElementData(player, "cansancio") <= 85 then
						setElementData(player, "cansancio", getElementData(player, "cansancio")+15)
					else
						setElementData(player, "cansancio", 100)
					end
				else
					if getElementData(player, "cansancio") <= 95 then
						setElementData(player, "cansancio", getElementData(player, "cansancio")+5)
					else
						setElementData(player, "cansancio", 100)
					end
				end
			else
				standUpCoche(player)
			end
		end, 30000, 0, player)
		exports.chat:me(player, "echa el asiento para atrás y se duerme.")
		setElementData(player, "tumbado", true)
		bindKey(player, "space", "down", standUpCoche)
	elseif getElementDimension(player) == 1251 then
		dormirC[player] = setTimer(
		function(player)
			if player and isElement(player) and getPedOccupiedVehicle(player) then
				if getElementData(player, "cansancio") <= 95 then
					setElementData(player, "cansancio", getElementData(player, "cansancio")+5)
				else
					setElementData(player, "cansancio", 100)
				end
			else
				standUpCoche(player)
			end
		end, 15000, 0, player)
		exports.chat:me(player, "se tumba en la cama de su celda.")
		setPedAnimation(player, "int_house", "bed_loop_l", -1, true, false, true)
		outputChatBox("Usa 'espacio' para despertarte.", player, 255, 0, 0)
		bindKey(player, "space", "down", standUpCoche)
	else
		outputChatBox("Sólo puedes usar /dormir si estás en un coche o camión.", player, 255, 0, 0)
	end
end
addCommandHandler("dormir", dormirCoche)  

function standUpCoche(player)
	if dormirT[player] then
		killTimer(dormirT[player])
		dormirT[player] = nil
		exports.chat:me(player, "pone el asiento para delante y se despierta.")
	elseif dormirC[player] then
		killTimer(dormirC[player])
		dormirC[player] = nil
		exports.chat:me(player, "se despierta y se levanta de su cama.")
	end
end
addEventHandler("onVehicleExit", root, standUpCoche)

function mostrarDNI( player, commandName, otherPlayer )
    if player then
		if exports.items:has(player,16,1) then
		if otherPlayer then
			local target, targetName = exports.players:getFromName( player, otherPlayer )
			if target and player ~= target then
				x1, y1, z1 = getElementPosition ( player )
				x2, y2, z2 = getElementPosition ( target )
				distance = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )
				if ( distance < 4) then
					local job = exports.players:getJob(player)
					local dni = 20000000 + tonumber(exports.players:getCharacterID(player))
					local dni = tonumber(dni)
					local sql = exports.sql:query_assoc_single("SELECT edad, genero, casadocon FROM characters WHERE characterID = " .. exports.players:getCharacterID(player))
						local nameesposo = exports.players:getCharacterName( sql.casadocon )
						exports.chat:me( player, "le enseña su D.N.I a " .. targetName )
						outputChatBox( "--- DOCUMENTO NACIONAL DE IDENTIDAD ---", target, 255, 150, 0 )
						outputChatBox( "D.N.I a nombre de: " .. getPlayerName( player ):gsub( "_", " " ) .. ".", target, 255, 150, 0 )
						outputChatBox( "Edad: "..tostring(sql.edad).. " años.", target, 255, 150, 0 )
						if tonumber(sql.casadocon) == 0 then
						outputChatBox( "Estado Civil: Soltero",target,255,150,0)
						end
						if tonumber(sql.casadocon) == 1 then
						outputChatBox( "Estado Civil: Divorciado",target,255,150,0)
						end
						if tonumber(sql.casadocon) > 3 then
						outputChatBox( "Estado Civil: Matrimonio con " .. nameesposo .. "",target,255,150,0)
						end
						if sql.genero == 1 then gen = "Hombre" else gen = "Mujer" end
						outputChatBox( "Género: "..tostring(gen), target, 255, 150, 0 )
						local factions = exports.factions:getPlayerFactions(player)
						for k, v in ipairs(factions) do
							if tonumber(v) < 100 then
								factionName = exports.factions:getFactionName(v)
								outputChatBox( "Pertenece a : " ..factionName.. ".", target, 255, 150, 0 )
							end
						end
						if job and not factionName then
							outputChatBox( "Trabaja en : " ..job.. ".", target, 255, 150, 0 )
						elseif not factionName then
							outputChatBox( "No tiene trabajo.", target, 255, 150, 0 )
						end
						outputChatBox( "Número de D.N.I :"..tostring(dni), target, 255, 150, 0 )
				else
					outputChatBox( "(( Estas muy lejos para enseñarle tu DNI ))", player, 255, 50, 0 )
				end
			else
				if not otherPlayer then return end
					local target = player
					local job = exports.players:getJob(player)
					local dni = 20000000 + tonumber(exports.players:getCharacterID(player))
					local dni = tonumber(dni)
					local sql = exports.sql:query_assoc_single("SELECT edad, genero, casadocon FROM characters WHERE characterID = " .. exports.players:getCharacterID(player))
					local nameesposo = exports.players:getCharacterName( sql.casadocon )
					exports.chat:me( player, "saca su D.N.I de su cartera y lo observa" )
					outputChatBox( "--- DOCUMENTO NACIONAL DE IDENTIDAD ---", target, 255, 150, 0 )
					outputChatBox( "D.N.I a nombre de: " .. getPlayerName( player ):gsub( "_", " " ) .. ".", target, 255, 150, 0 )
					outputChatBox( "Edad: "..tostring(sql.edad).. " años.", target, 255, 150, 0 )
					if tonumber(sql.casadocon) == 0 then
					outputChatBox( "Estado Civil: Soltero",target,255,150,0)
					end
					if tonumber(sql.casadocon) == 1 then
					outputChatBox( "Estado Civil: Divorciado",target,255,150,0)
					end
					if tonumber(sql.casadocon) > 3 then
					outputChatBox( "Estado Civil: Matrimonio con " .. nameesposo .. "",target,255,150,0)
					end
					if sql.genero == 1 then gen = "Hombre" else gen = "Mujer" end
					outputChatBox( "Género: "..tostring(gen), target, 255, 150, 0 )
					local factions = exports.factions:getPlayerFactions(player)
					for k, v in ipairs(factions) do
						if tonumber(v) < 100 then
							factionName = exports.factions:getFactionName(v)
							outputChatBox( "Pertenece a : " ..factionName.. ".", target, 255, 150, 0 )
						end
					end
					if job and not factionName then
						outputChatBox( "Trabaja en : " ..job.. ".", target, 255, 150, 0 )
					elseif not factionName then
						outputChatBox( "No tiene trabajo.", target, 255, 150, 0 )
					end
					outputChatBox( "Número de D.N.I :"..tostring(dni), target, 255, 150, 0 )
			end
		else
			outputChatBox ( "Sintaxis: /dni [id], pon tu id ("..tostring(getElementData(player, "playerid"))..") para ver tu propio DNI", player, 255, 255, 255 )
		end
	    else
		outputChatBox("(( No llevas tu DNI encima ))",player,255,0,0)
		end
	end
end
addCommandHandler( "dni", mostrarDNI )