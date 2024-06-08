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

function verifyCharacterName( name )
	if not name then
		return "No name given."
	elseif #name < 5 then
		return "El nombre debe de tener 5 carácteres."
	elseif #name >= 22 then
		return "El nombre no puede superar los 22 carácteres."
	else
		local foundSpace = false
		
		local lastChar = ' '
		local currentPart = ''
		
		for i = 1, #name do
			local currentChar = name:sub( i, i )
			if currentChar == ' ' then
				if i == 1 then
					return "El nombre no puede empezar con un espacio"
				elseif i == #name then
					return "El nombre no puede acabar con un espacio."
				elseif lastChar == ' ' then
					return "El nombre no puede tener dos espacios consecutivos."
				else
					foundSpace = true
					
					if #currentPart < 2 then
						return "Todas las partes del nombre deben tener como mínimo dos caracteres."
					else
						currentPart = ""
					end
				end
			elseif lastChar == ' ' then -- need a capital letter at the start
				if currentChar < 'A' or currentChar > 'Z' then
					return "Nombre invalido - Formato: Nombre Apellido."
				end
				currentPart = currentPart .. currentChar
			elseif ( currentChar >= 'a' and currentChar <= 'z' ) or ( currentChar >= 'A' and currentChar <= 'Z' ) then
				currentPart = currentPart .. currentChar
			else
				return "Tu nombre contiene caracteres invalidos."
			end
			lastChar = currentChar
		end
		
		if not foundSpace then
			return "El nombre debe tener mínimo dos partes."
		elseif #currentPart < 2 then
			return "Todas las partes del nombre deben tener como mínimo dos caracteres."
		end
	end
end