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
windows.inventory =
{
	{
		type = "label",
		text = "Inventario",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "vpane",
		lines = 7,
		panes = { }
	},
	{
		type = "label",
		text = function( ) return getKeyState( 's' ) and "Click en un item para borrarlo." or getKeyState( 'c' ) and "Click en un item para dárselo a otro." or "Presiona 'C', y haz click sobre un item para darlo a alguien.\nPresiona 'S', y haz click sobre un item para borrarlo." end,
		onRender = function( pos ) if getKeyState( 's' ) then dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 255, 255, 63 } ) ) ) end end,
		alignX = "center",
	},
	{
		type = "button",
		text = "Cerrar",
		id = "inventarioboton",
		onClick = function( ) hide( ) triggerEvent("offCursor", getLocalPlayer()) end,
	},
}

function updateInventory( )
	windows.inventory[2].panes = { }
	local t = exports.items:get( getLocalPlayer( ) )  
	if t then                                                                                 
		for k, v in ipairs( t ) do
			local nItem = nil
			if v and v.item and v.item == 27 then 
				nItem = exports.muebles:getNombreMueble(v.value)
			else
				if v.name and tostring(v.name) and tostring(v.name) ~= "" then 
					nItem = v.name
				else 
					nItem = exports.items:getName(v.item)	
				end
			end
			local image = exports.items:getImage( v.item, v.value, nItem )
			local width = dxGetTextWidth( nItem, 1, "default-bold" )
			local height = 10 * ( 5 )
			table.insert( windows.inventory[2].panes,
				{
						onHover = function( cursor, pos )
						local width2 = dxGetTextWidth( nItem, 1, "default-bold" ) + 50
						dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( getKeyState( 'c' ) and { 255, 0, 0, 63 } or { 255, 255, 0, 63 } ) ) )
						dxDrawRectangle( pos[1] + 64, pos[2] - 52, width2, height, tocolor( 0, 0, 0, 255 ), true )
						dxDrawText( "ID: "..(string.len(tostring(v.value)) < 15 and tostring(v.value) or "Pulsa para más info."), pos[1] + 180, pos[2]+20 , pos[1] + width, pos[2] - height, tocolor( 160, 94, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )
						dxDrawText( nItem, pos[1] + 180, pos[2]-25 , pos[1] + width, pos[2] - height, tocolor( 255, 255, 255, 255 ), 1, "default-bold", "center", "center", false, false, true )
						end,
						image = image or ":players/images/skins/-1.png",
						
					onClick = function( key )
							if key == 1 then
								if getKeyState( 's' ) then
									triggerServerEvent( "items:destroy", getLocalPlayer( ), k )
								elseif getKeyState( 'c' ) then
									triggerServerEvent( "items:give", getLocalPlayer( ), k )
								else
									triggerServerEvent( "items:use", getLocalPlayer( ), k )
								end
							end
						end
				}
			)
		end
	end
end
setTimer( updateInventory, 500, 1 )

-- Cachear / Ver Inventario de Otra Persona --

windows.inventory_other =
{
	{
		type = "label",
		text = "Inventario (Otro)",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "vpane",
		lines = 7,
		panes = { }
	},
	{
		type = "button",
		text = "Cerrar",
		id = "inventarioboton",
		onClick = function( ) hide( ) triggerEvent("offCursor", getLocalPlayer()) end,
	},
}
 
function updateInventory2(t, otherP)
	windows.inventory_other[2].panes = { }
	if t and otherP then
		for k, v in ipairs( t ) do
			local nItem = nil
			if v and v.item and v.item == 27 then 
				nItem = exports.muebles:getNombreMueble(v.value)
			else
				if v.name and tostring(v.name) and tostring(v.name) ~= "" then 
					nItem = v.name
				else 
					nItem = exports.items:getName(v.item)	
				end
			end
			local image = exports.items:getImage( v.item, v.value, nItem )
			local width = dxGetTextWidth( nItem, 1, "default-bold" )
			local height = 10 * ( 5 )
			table.insert( windows.inventory_other[2].panes,
				{
					onHover = function( cursor, pos )
					local width2 = dxGetTextWidth( nItem, 1, "default-bold" ) + 50
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( getKeyState( 'c' ) and { 255, 0, 0, 63 } or { 255, 255, 0, 63 } ) ) )
					dxDrawRectangle( pos[1] + 64, pos[2] - 52, width2, height, tocolor( 0, 0, 0, 255 ), true )
					dxDrawText( "ID: "..tostring(v.value), pos[1] + 180, pos[2]+20 , pos[1] + width, pos[2] - height, tocolor( 160, 94, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )
					dxDrawText( nItem, pos[1] + 180, pos[2]-25 , pos[1] + width, pos[2] - height, tocolor( 255, 255, 255, 255 ), 1, "default-bold", "center", "center", false, false, true )
					end,
					image = image or ":players/images/skins/-1.png",
					onClick = function( key )
							if key == 1 then
								triggerServerEvent( "items:use2", getLocalPlayer( ), k, otherP)
							end
						end
				}
			)
		end
	end
	triggerEvent("onCursor", getLocalPlayer())
	show("inventory_other")
end
addEvent("onRequestAnotherInventory", true)
addEventHandler("onRequestAnotherInventory", getRootElement(), updateInventory2)