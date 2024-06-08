--[[
Copyright (C) 2020  Bone County Roleplay, DownTown RolePlay & MTA:Paradise

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

setOcclusionsEnabled( false ) -- Parche para los mapas bugs
function dgui ( player )
	restartResource ( resource, gui )
end
--addCommandHandler ( "Dgui", dgui )

function restartAllResources ()
	local allResources = getResources()
	for index, res in ipairs(allResources) do
		restartResource(res)
	end
end
--addCommandHandler("Dtodo", restartAllResources)

function startAllResources ()
	local allResources = getResources()
	for index, res in ipairs(allResources) do
		startResource(res)
	end
end
--addCommandHandler("Dtodo2", startAllResources)

function restartPlayers ()
	local allResources = getResources()
	for index, res in ipairs(allResources) do
		if getResourceName(res) == "players" then
			restartResource(res)
		end
	end
end
--addCommandHandler("Dplayers", restartPlayers)

function anularComando ()
	if getElementData(source, "nogui") == true then
		cancelEvent()
	end	
end
addEventHandler("onPlayerCommand", getRootElement(), anularComando)

function actualizarDatosTab ()
	triggerClientEvent(source, "onActualizarDatosTab", source)
end
addEventHandler("onCharacterLogin", getRootElement(), actualizarDatosTab)
