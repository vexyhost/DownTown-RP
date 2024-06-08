--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2018 DownTown Roleplay

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

local allowRegistration = true

local function trim( str )
	return str:gsub("^%s*(.-)%s*$", "%1")
end

addEvent( "players:register", true )
addEventHandler( "players:register", root,
	function( username, password )
		if (source == client) or not client then
			if allowRegistration then
				if username and password then
					username = trim( username )
					password = trim( password )
					-- client length checks are the same
					if #username >= 3 and #password >= 8 then
						-- see if that username is free at all
						local info, errTest = exports.sql:query_assoc_single( "SELECT COUNT(userID) AS usercount FROM wcf1_user WHERE username = '%s'", username )
						local info2 = exports.sql:query_assoc( "SELECT regIP, lastIP, regSerial FROM wcf1_user" )
						if not info then
							triggerClientEvent( source, "players:registrationResult", source, 1 )
						elseif info.usercount == 0 then
							ipReg = 0
							for k, v in ipairs(info2) do
								if v.regSerial == getPlayerSerial(source) then triggerClientEvent( source, "players:registrationResult", source, 5 ) return end
								if tostring(v.regIP) == tostring(getPlayerIP(source)) then ipReg = ipReg + 1 end
								if tostring(v.lastIP) == tostring(getPlayerIP(source)) and tostring(v.regIP) ~= tostring(v.lastIP) then ipReg = ipReg + 1 end
							end
							if ipReg >= 2 then 
								triggerClientEvent( source, "players:registrationResult", source, 6 )
								return
							end
							local salt = ''
							local chars = { 'a', 'b', 'c', 'd', 'e', 'f', 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
							for i = 1, 40 do
								salt = salt .. chars[ math.random( 1, #chars ) ]
							end
							local userID, error = exports.sql:query_insertid( "INSERT INTO wcf1_user (username,salt,password) VALUES ('%s', '%s', SHA1(CONCAT('%s', SHA1(CONCAT('%s', '" .. hash("sha1", password) .. "')))))", username, salt, salt, salt )
							if error then
								outputDebugString(error)
								triggerClientEvent( source, "players:registrationResult", source, 4 )
							else
								triggerClientEvent( source, "players:registrationResult", source, 0 ) -- Inicio de sesion automático.
								exports.sql:query_free( "UPDATE wcf1_user SET regIP = '%s' WHERE username = '%s'", getPlayerIP(source), username )
								exports.sql:query_free( "UPDATE wcf1_user SET regSerial = '%s' WHERE username = '%s'", getPlayerSerial(source), username )
								outputChatBox ( "Bienvenido por primera vez a DownTown RolePlay.", source, 0, 255, 0 )
								outputChatBox ( "Te recomendamos que utilices /duda para obtener asistencia", source, 0, 255, 0)
							end 
						else
							triggerClientEvent( source, "players:registrationResult", source, 3 )
						end
					else
						-- shouldn't happen
						triggerClientEvent( source, "players:registrationResult", source, 1 )
					end
				else
					-- can't do much without a username and password
					triggerClientEvent( source, "players:registrationResult", source, 1 )
				end
			else
				triggerClientEvent( source, "players:registrationResult", source, 2, "Registro desactivado" )
			end
		end
	end
)