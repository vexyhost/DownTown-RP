--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2016 DownTown County Roleplay

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

function recibirDatosRecuperacion ( username, player )
	if source and client and source == client and player == source then
		local sql = exports.sql:query_assoc_single( "SELECT regSerial FROM wcf1_user WHERE username = '%s'", username )
		showChat(player, true)
		if not sql then outputChatBox("El usuario no existe.", player, 255, 0, 0) return end
		if sql.regSerial == getPlayerSerial(player) then
			outputChatBox ( "La identidad de tu cuenta ha sido verificada.", player, 0, 255, 0 )
			local salt = ''
			local chars = { 'a', 'b', 'c', 'd', 'e', 'f', 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
			for i = 1, 10 do
				salt = salt .. chars[ math.random( 1, #chars ) ]
			end		
			if exports.admin:setPassword(tostring(username), tostring(salt)) == true then
				outputChatBox("Tu nueva clave es: "..tostring(salt)..". Usa /cambiarclave [nueva clave] para cambiarla.", player, 0, 255, 0)
				triggerEvent( "players:login", player, tostring(username), tostring(salt) )
			end
		else
			outputChatBox ( "El serial de este PC no coincide con el PC que registró la cuenta.", player, 255, 0, 0 )
			local intentos = tonumber(getElementData ( player, "data.intentos" ))
			if intentos < 4 then
				outputChatBox ( "Intento "..tostring(intentos+1).."/5.", player, 255, 0, 0 )
				setElementData ( player, "data.intentos", intentos+1 )
			elseif intentos == 4 then
				banPlayer ( player, true, true, true, nil, "Demasiados intentos de restablecimiento.", 7200 )
			end
		end
	end
end
addEvent( "onEnviarDatosRecuperacion", true )
addEventHandler( "onEnviarDatosRecuperacion", getRootElement(), recibirDatosRecuperacion ) 