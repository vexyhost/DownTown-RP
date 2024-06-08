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
copias = 0

windows.copia =
{
	{
		type = "label",
		text = "Inventario",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "vpane",
		lines = 4,
		panes = { }
	},
	{
		type = "label",
		text = function( ) return "Presiona una llave para copiar\n Dale a 'Terminar' al hacer la copia para que aparezca." end,
		alignX = "center",
	},
	{
		type = "button",
		text = "Terminar",
		onClick = function( ) hide( ) showCursor( false ) copias = 0 end,
	}
}

function updateCopias( )
	windows.copia[2].panes = { }
	local t = exports.items:get( getLocalPlayer( ) ) 
	if t then
		for k, v in ipairs( t ) do
			if v.item == 1 or v.item == 2 then
				local image = exports.items:getImage( v.item, v.value, v.name )
				table.insert( windows.copia[2].panes,
					{
						image = image or ":players/images/skins/-1.png",
						onHover = function( cursor, pos )
						dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( getKeyState( 'c' ) and { 255, 0, 0, 63 } or { 255, 255, 0, 63 } ) ) )
						dxDrawText( "ID: "..v.value,pos[1], pos[2]-250, pos[3] - pos[1], pos[4] - pos[2], tocolor ( 255, 0, 0, 255 ), 1.02, "pricedown", "left", "top", false,false,true )
							end,
						onClick = function( key )
							if key == 1 then
								copias = copias+1
								triggerServerEvent( "items:copy", getLocalPlayer( ), k, copias )
							end
						end
					}
				)
			end
		end
	end
end
