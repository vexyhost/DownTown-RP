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
windows.characters = { }

function updateCharacters( characters )
	local set = false
	if getWindowTable( ) == windows.characters then
		set = true
	end
	windows.characters = { type = "pane", panes = { } }
	-- helper function
	local function add( title, text, id, characterID )
		table.insert( windows.characters.panes,
			{
				image = "/images/" .. id .. ".png",
				title = title,
				text = text,
				onHover = function( cursor, pos )
						color = { 0, 255, 0, 63 }
						if characterID == -1 then
							color[1] = 255
						elseif characterID == -2 then
							color[1] = 255
							color[2] = 0
						end
						dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( color ) ) )
					end,
				onClick = function( key )
						if key == 1 then
							exports.players:selectCharacter( characterID, title )
						end
					end,
				wordBreak = true
			}
		)
	end                             
	c = 0
	for key, value in ipairs( characters ) do
		local gen = ""
		if tonumber(value.genero) == 1 then
			gen = "Hombre"
		else
			gen = "Mujer"
		end
		if tonumber(value.CKuIDStaff) == 0 then                   
			c = c + 1
			add( value.characterName, "Edad: "..tostring(value.edad)..". Género: "..tostring(gen)..".\nÚltimo login: "..tostring(value.lastLogin), c, value.characterID )	         
		else
			add( "[CK] "..tostring(value.characterName), "Edad: "..tostring(value.edad)..". Género: "..tostring(gen)..".\nFecha del CK: "..tostring(value.lastLogin), "error", -3 )
		end
	end
	
	-- add new char & logout
	if c < 3 then
		add( "Nuevo Personaje", "Seleciona esta opción para crear un nuevo personaje. Máximo 3 por cuenta.", -1, -1 )
	end
	add( "Desconectar", "Esta opción es para desconectarse.\nDeberás de volver a iniciar sesión.", -2, -2 )
	
	if set then
		setWindowTable( windows.characters )
	end
end

