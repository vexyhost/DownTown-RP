--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown Roleplay

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

addEvent( getResourceName( resource ) .. ":afk", true )
addEventHandler( getResourceName( resource ) .. ":afk", root,
	function( )
		if source == client then
			if hasObjectPermissionTo( source, "command.admin", false ) then
				return
			end
			--setElementData(source, "yo", "((Jugador A.F.K.))")
			kickPlayer(source, "Anti AFK", "Has sido kickeado por estar A.F.K.")
		end
	end
)