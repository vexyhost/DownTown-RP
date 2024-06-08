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

local root = getRootElement()
local player = getLocalPlayer()
local counter = 0
local starttick
local currenttick
addEventHandler("onClientRender",root,
	function()
		if not starttick then
			starttick = getTickCount()
		end
		counter = counter + 1
		currenttick = getTickCount()
		if currenttick - starttick >= 1000 then
			setElementData(player,"FPS",tonumber(counter-1))
			counter = 0
			starttick = false
		end
	end
)

windows.scoreboard =
{ 
	{
		type = "label",
		text = "",
		font = "default-bold",
		alignX = "center"--,
		--color = {255, 0, 0}
	},
	{
		type = "grid",
		columns =
		{
			{ name = "ID", width = 0.1, alignX = "center" },    
			{ name = "Nombre", width = 0.6 },
			{ name = "Ping", width = 0.15, alignX = "center" },
			{ name = "FPS", width = 0.15, alignX = "center" }
		},
		content = function( )
				local t = { }
				for key, value in ipairs( getElementsByType( "player" ) ) do
					local name = getPlayerName( value )
					local ping = getPlayerPing ( value )
					if name then
						table.insert( t,
							{
								getElementData( value, "playerid" ) or 0,
								name and name:gsub( "_", " " ),
								ping,
								getElementData(value, "FPS") or 0,
								color = { getPlayerNametagColor( value ) },
							}
						)
					end
				end
				table.sort( t, function( a, b ) return a[1] < b[1] end )
				return t
			end
	},
}
    
function aplicarDatosTab ()
	if getElementData(getLocalPlayer(), "playerid") and getPlayerName(getLocalPlayer()):gsub("_", " ") then
		windows.scoreboard[1].text = "DownTown RolePlay 1.0\nID > "..getElementData(getLocalPlayer(), "playerid").." - Nombre > "..getPlayerName(getLocalPlayer()):gsub("_", " ").."\n"
	else
		setTimer(aplicarDatosTab, 1000, 1)
	end
end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), aplicarDatosTab)
addEvent("onActualizarDatosTab", true)
addEventHandler("onActualizarDatosTab", getRootElement(), aplicarDatosTab)