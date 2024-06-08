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

addEvent( "gui:createCharacter", true )
addEventHandler( "gui:createCharacter", root,
	function( name, edad, genero, color )
		if source == client and type( edad ) == 'number' and type( genero ) == 'number' and type( color ) == 'number' then
			local error = verifyCharacterName( name )
			if not error then
				exports.players:createCharacter( source, name, edad, genero, color )
			end
		end
	end
)
