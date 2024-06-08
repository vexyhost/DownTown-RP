--[[
Copyright (c) 2019 MTA: Paradise y DownTown RolePlay

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

-- Textos de información en pantalla.
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		local screenX, screenY = guiGetScreenSize( )
		-------- Texto en ventana N*1
		local label = guiCreateLabel( 0, 0, screenX, 15, "DTRP - v1.0", false )
		guiSetSize( label, guiLabelGetTextExtent( label ) + 5, 15, false )
		guiSetPosition( label, screenX - guiLabelGetTextExtent( label ) - 215, screenY - 15.5, false )
		guiSetAlpha( label, 0.55 )
		-------- Texto en ventana N*2
		local label2 = guiCreateLabel( 0, 0, screenX, 15, "foro.dt-mta.com", false )
		guiSetSize( label2, guiLabelGetTextExtent( label2 ) + 5, 15, false )
		guiSetPosition( label2, screenX - guiLabelGetTextExtent( label2 ) - 95, screenY - 15.5, false )
		guiSetAlpha( label2, 0.55 )
	end
)