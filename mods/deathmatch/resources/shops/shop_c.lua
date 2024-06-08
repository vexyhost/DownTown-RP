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

-- we don't want our shops to die, do we?

--

-- function createAndFire()
	-- local x, y, z = getElementPosition(getLocalPlayer())
    -- local weapon = createWeapon("mp5", x+3, y+3, z+3)
	-- setWeaponTarget(weapon, getLocalPlayer())
	-- setTimer(function(weapon)  fireWeapon(weapon) end, 50, 1000, weapon)
-- end
-- addCommandHandler("disparame", createAndFire)

local currentShop = false
local shopCache = { }

addEvent( "shops:sync", true )
addEventHandler( "shops:sync", resourceRoot,
	function( id, content )
		shopCache[ id ] = content
	end
)

-- if the shop is edited, we should trigger that
addEvent( "shops:clear", true )
addEventHandler( "shops:clear", resourceRoot,
	function( id )
		if id then
			shopCache[ id ] = nil
		end
		
		if ( not id or currentShop == id ) and exports.gui:getShowing( ) == 'shop' then
			exports.gui:hide( )
		end
	end
)

--

addEvent( "shops:open", true )
addEventHandler( "shops:open", resourceRoot,
	function( configuration )
		local c = shopCache[ configuration ] or shop_configurations[ configuration ] or { }
		local items = { }
		for key, value in ipairs( c ) do
			table.insert( items, value )
		end
		
		exports.gui:updateShopContent( items, c.name or "" )
		exports.gui:show( 'shop' )
		
		currentShop = configuration
	end
)

addEventHandler( "onClientResourceStop", resourceRoot,
	function( )
		if exports.gui:getShowing( ) == "shop" then
			exports.gui:hide( )
		end
	end
)
