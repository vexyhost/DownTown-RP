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

addCommandHandler( "restartall",
	function( player )
		if not hasObjectPermissionTo( player, "command.modchat", false ) then return end
		for index, resource in ipairs ( getResources ( ) ) do
			if getResourceState ( resource ) == "running" and getResourceName ( resource ) ~= getThisResource ( ) then
				if not restartResource ( resource ) then
					outputServerLog( "restartall: Ha fallado el reinicio de la resource '" .. getResourceName ( resource ) .. "' .Inténtalo manualmente y avisa a Jefferson." )
				end
			end
		end
		outputServerLog( "restartall: Todas las resources han sido reiniciadas" .. " (Solicitado por " .. ( not player and "Consola" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
		if player then
			outputChatBox( "Todos los recursos han sido reiniciados.", player, 0, 255, 153 )
		end
	end,
	true
)


function startAll( player )
	for index, resource in ipairs ( getResources ( ) ) do
		if getResourceState ( resource ) == "loaded" then
			if not startResource ( resource ) then
				outputServerLog( "startall: Ha fallado el inicio de la resource '" .. getResourceName ( resource ) .. "' . Inténtalo manualmente y avisa a Jefferson." )
			end
		end
	end
	--outputServerLog( "startall: Todas las resources han sido iniciadas. " .. " (Solicitado por " .. ( not player and "Consola" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
	if player then
		--outputChatBox ( "Todos los recursos han sido iniciados.", player, 0, 255, 153 )
	end
end
--addCommandHandler("startall", startAll)
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), startAll)