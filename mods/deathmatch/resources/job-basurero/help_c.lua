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

local blip, sphere

addEvent( getResourceName( resource ) .. ":introduce", true )
addEventHandler( getResourceName( resource ) .. ":introduce", root,
	function( )
		exports.gui:hint( "Tu trabajo: Basurero", "Es fácil, sigue la ruta y párate en los puntos verdes.", 1 )
		
		if not blip and not sphere then
			sphere = createColSphere( -2064.2470703125, -2448.9345703125, 30.625, 50 )
			blip = createBlipAttachedTo( sphere, 0, 3, 0, 255, 0, 127 )
			
			addEventHandler( "onClientColShapeHit", sphere,
				function( element )
					if element == getLocalPlayer( ) then
						destroyElement( blip )
						destroyElement( sphere )
						
						sphere = nil
						blip = nil
						
						exports.gui:hint( "Tu trabajo: Basurero", "Sube a un camión de la basura." )
					end
				end
			)
		end
	end
)
