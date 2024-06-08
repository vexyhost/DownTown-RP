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

local closeButton =
{
	type = "button",
	text = "Cerrar",
	onClick = function( key )
			if key == 1 then
				hide( )
				--setTimer(setElementData, 1000, 1, getLocalPlayer(), "inTienda", nil)
				windows.shop = { closeButton }
			end
		end,
}

windows.shop = { closeButton }

function updateShopContent( content, name )
	-- scrap what we had before
	windows.shop = {
		onClose = function( )
				--triggerServerEvent( "shops:close", getLocalPlayer( ) )
				--windows.shop = { closeButton }
			end,
		{
			type = "label",
			text = name,
			font = "bankgothic",
			alignX = "center",
		},
		{
			type = "pane",
			panes = { }
		}
	}
	-- let's add all items
	for k, value in ipairs( content ) do
		local description = value.description or exports.items:getDescription( value.itemID )
		if value.itemID and tonumber(value.itemID) == 29 then
			table.insert( windows.shop[2].panes,
				{
					image = ":items/images/w"..tostring(value.itemValue)..".png",
					title = getWeaponNameFromID(value.itemValue),
					text = "Cuesta $" .. value.price .. ( description and description ~= "" and ( " - " .. description ) or "" ),
					onHover = function( cursor, pos )
							dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 31 } ) ) )
						end,
					onClick = function( key )
							if key == 1 then
								triggerServerEvent( "shops:buy", getLocalPlayer( ), k )
							end
						end,
					wordBreak = true,
				}
			)
		else
			table.insert( windows.shop[2].panes,
				{
					image = exports.items:getImage( value.itemID, value.itemValue, value.name ) or ":players/images/skins/-1.png",
					title = value.name or exports.items:getName( value.itemID ),
					text = "Cuesta $" .. value.price .. ( description and description ~= "" and ( " - " .. description ) or "" ),
					onHover = function( cursor, pos )
							dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 31 } ) ) )
						end,
					onClick = function( key )
							if key == 1 then
								triggerServerEvent( "shops:buy", getLocalPlayer( ), k )
							end
						end,
					wordBreak = true,
				}
			)
		end
	end	
	-- add a close button as well
	table.insert( windows.shop, closeButton )
end
