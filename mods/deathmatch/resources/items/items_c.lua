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

local items = { }
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

addEvent( "items:closegui", true )
addEventHandler( "items:closegui", resourceRoot,
	function( )
		exports.gui:hide( )
	end
)

function onClientPlayerWeaponFireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement )
    if isArmaBalas[weapon] and ammo == 1 then
		outputChatBox("¡No tienes balas para disparar este arma! Pulsa 'R' para recargarla.", 255, 0, 0)
		toggleControl ( "fire", false )
		toggleControl ( "vehicle_fire", false)
    end
end
addEventHandler ( "onClientPlayerWeaponFire", getLocalPlayer(), onClientPlayerWeaponFireFunc )

function desactivarDisparoSinBalas ( prevSlot, newSlot )
	local balasFromArma = getPedTotalAmmo(source, newSlot)
	if isArmaBalas[getPedWeapon(getLocalPlayer(),newSlot)] and balasFromArma == 1 then
		toggleControl ( "fire", false )
		toggleControl ( "vehicle_fire", false)
		outputChatBox("Este arma no tiene balas. Pulsa 'R' para recargarla (debes de tener cargadores en el inventario).", 255, 0, 0)
	else
		toggleControl ( "fire", true )
		toggleControl ( "vehicle_fire", true)
	end
end
addEventHandler ( "onClientPlayerWeaponSwitch", getRootElement(), desactivarDisparoSinBalas )

-- syncing items from the server
addEvent( "syncItems", true )
addEventHandler( "syncItems", root,
	function( item_table )
		items[ source ] = item_table
		if source == getLocalPlayer( ) then
			exports.gui:updateInventory( )
		end
	end
)

addEvent( "items:copy", true )
addEventHandler( "items:copy", localPlayer,
	function( )
		exports.gui:hide()
		exports.gui:updateCopias( )
		exports.gui:show( 'copia', true, false, true )
	end
)

addEvent( "items:give", true )
addEventHandler( "items:give", localPlayer,
	function( )
	    exports.gui:hide()
		exports.gui:updateGive( )
		exports.gui:show( 'give', true, false, true )
	end
)

-- load our stuff when we indicate we're ready, as the resource can be restarted inbetween
addEventHandler( "onClientResourceStart", resourceRoot,
	function( )
		triggerServerEvent( "loadItems", getLocalPlayer( ) )
	end
)

function get( element )
	return items[ element ]
end

function has( element, item, value, name )
	-- we need a base to work on
	if items[ element ] then
		-- at least the item is needed
		if type( item ) == 'number' then
			-- check if he has it
			for key, v in ipairs( items[ element ] ) do
				if v.item == item and ( not value or v.value == value ) and ( not name or v.name == name ) then
					return true, key, v
				end
			end
			return false -- nope, no error either
		end
		return false, "Invalid Parameters"
	end
	return false, "Element not loaded"
end

function abrirMarcador( )
	exports.gui:hide( )
	exports.gui:show( 'cabina_marcador', true )
end
addEvent( "onAbrirMarcador", true )
addEventHandler( "onAbrirMarcador", getRootElement(), abrirMarcador)

function closeGui( )
	exports.gui:hide( )
end
addEvent( "closeGui", true )
addEventHandler( "closeGui", getRootElement(), closeGui)

-- local l_cigar = { }
-- local r_cigar = { }
-- local deagle = { }
-- local isLocalPlayerSmokingBool = false

-- function setSmoking(player, state, hand)
	-- setElementData(player,"smoking",state, false)
	-- if not (hand) or (hand == 0) then
		-- setElementData(player, "smoking:hand", 0, false)
	-- else
		-- setElementData(player, "smoking:hand", 1, false)
	-- end

	-- if (isElement(player)) then
		-- if (state) then
			-- playerExitsVehicle(player)
		-- else
			-- playerEntersVehicle(player)
		-- end
	-- end
-- end

-- function playerExitsVehicle(player)
	-- if (getElementData(player, "smoking")) then
		-- playerEntersVehicle(player)
		-- if (getElementData(player, "smoking:hand") == 1) then
			-- r_cigar[player] = createCigarModel(player, 3027)
		-- else
			-- l_cigar[player] = createCigarModel(player, 3027)
		-- end
	-- end
-- end

-- function playerEntersVehicle(player)
	-- if (l_cigar[player]) then
		-- if (isElement( l_cigar[player] )) then
			-- destroyElement( l_cigar[player] )
		-- end
		-- l_cigar[player] = nil
	-- end
	-- if (r_cigar[player]) then
		-- if (isElement( r_cigar[player] )) then
			-- destroyElement( r_cigar[player] )
		-- end
		-- r_cigar[player] = nil
	-- end
-- end

-- function removeSigOnExit()
	-- playerExitsVehicle(source)
-- end
-- addEventHandler("onPlayerQuit", getRootElement(), removeSigOnExit)

-- function syncCigarette(state, hand)
	-- if (isElement(source)) then
		-- if (state) then
			-- setSmoking(source, true, hand)
		-- else
			-- setSmoking(source, false, hand)
		-- end
	-- end
-- end
-- addEvent( "realism:smokingsync", true )
-- addEventHandler( "realism:smokingsync", getRootElement(), syncCigarette, righthand )

-- addEventHandler( "onClientResourceStart", getResourceRootElement(),
	-- function ( startedRes )
		-- triggerServerEvent("realism:smoking.request", getLocalPlayer())
	-- end
-- );

-- function createCigarModel(player, modelid)
	-- if (l_cigar[player] ~= nil) then
		-- local currobject = l_cigar[player]
		-- if (isElement(currobject)) then
			-- destroyElement(currobject)
			-- l_cigar[player] = nil
		-- end
	-- end
	
	-- local object = createObject(modelid, 0,0,0)

	-- setElementCollisionsEnabled(object, false)
	-- return object
-- end

--[[function updateCig()
	isLocalPlayerSmokingBool = false
	-- left hand
	for thePlayer, theObject in pairs(l_cigar) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerSmokingBool = true
			end
			local bx, by, bz = getPedBonePosition(thePlayer, 36)
			local x, y, z = getElementPosition(thePlayer)
			local r = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			local r = r + 170
			if (r > 360) then
				r = r - 360
			end
			
			local ratio = r/360
		
			--moveObject ( theObject, 1, bx, by, bz )
			setElementPosition(theObject, bx, by, bz)
			setElementRotation(theObject, 60, 30, r)
			setElementDimension(theObject, dim)
			setElementInterior(theObject, int)
		end
	end

	-- right hand
	for thePlayer, theObject in pairs(r_cigar) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerSmokingBool = true
			end
			local bx, by, bz = getPedBonePosition(thePlayer, 26)
			local x, y, z = getElementPosition(thePlayer)
			local r = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			local r = r + 100
			if (r > 360) then
				r = r - 360
			end
			
			local ratio = r/360
		
			--moveObject ( theObject, 1, bx, by, bz )
			setElementPosition(theObject, bx, by, bz)
			setElementRotation(theObject, 60, 30, r)
			setElementDimension(theObject, dim)
			setElementInterior(theObject, int)
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), updateCig)]]

-- function isLocalPlayerSmoking()
	-- return isLocalPlayerSmokingBool
-- end

mochilasC = {}

function abrirMochila(player, mochilaID, tipo, sql)
	for k in pairs (mochilasC) do
		mochilasC [k] = nil
	end
	if mochilaID and sql then
		for k, v in ipairs(sql) do
			table.insert(mochilasC, v)
		end
		if tipo == 1 then
			exports.gui:show("mochila")
			triggerEvent("onCursor", getLocalPlayer()) 
		elseif tipo == 2 then
			exports.gui:updateMochila()
		elseif tipo == 3 then
			exports.gui:updateInventarioMochila()
		end
	end
end
addEvent("onAbrirMochila", true)
addEventHandler("onAbrirMochila", getRootElement(), abrirMochila)

function getMochila() 
	return mochilasC
end