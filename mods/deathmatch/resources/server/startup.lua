--[[
Copyright (c) 2020 MTA: Paradise y DownTown RolePlay

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

function getVersion( )
	return "2"
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		setGameType( "RolePlay" )
		setRuleValue( "version", getVersion( ) )
		setMapName( "DownTown RP" )
		
		setTimer( 
			function( )

				outputServerLog( "              _                                    _ _" )
				outputServerLog( "             | |                                  | (_)" )
				outputServerLog( "    _ __ ___ | |_ __ _   _ __   __ _ _ __ __ _  __| |_ ___  ___" )
				outputServerLog( "   | '_ ` _ \\| __/ _` | | '_ \\ / _` | '__/ _` |/ _` | / __|/ _ \\" )
				outputServerLog( "   | | | | | | || (_| | | |_) | (_| | | | (_| | (_| | \\__ \\  __/" )
				outputServerLog( "   |_| |_| |_|\\__\\__,_| | .__/ \\__,_|_|  \\__,_|\\__,_|_|___/\\___|" )
				outputServerLog( "                        | |" )
				outputServerLog( "                        |_| v" .. getVersion( ) .. ". DownTown Roleplay " )
				outputServerLog( "      Recuerda estar al tanto de las posibles actualizaciones.                            ")
				outputServerLog( "               https://github.com/javier-es/DownTown-RP                                   ")
				outputServerLog( "      Copyright 2020. Todos los derechos reservados bajo GPL-3.0                          ")
			end, 50, 1
		)
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		removeRuleValue( "version" )
	end
)


			