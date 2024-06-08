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

windows.daritem =
{
	{
		type = "label",
		text = "Dar Item",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "label",
		text = function( ) return "Introduce el nombre del jugador (Nombre_Apellido)." end,
		alignX = "center",
	},
	{
		type = "edit",
		text = "Nombre del jugador:",
		id = "g:dar_item:player",
	},
	{
		type = "button",
		text = "Terminar",
		onClick = function( ) hide( ) showCursor( false ) end,
	},
	onClose = function ( )
	player = getPlayerFromName( guiGetText( destroy[ "g:dar_item:player" ] ) ) or getPlayerFromName( guiGetText( destroy[ "g:dar_item:player" ] ) ):gsub(" ", "_")
	triggerServerEvent( "items:give", getLocalPlayer( ), getElementData(getLocalPlayer(), "data.item"), player )
	end,
}
 	
