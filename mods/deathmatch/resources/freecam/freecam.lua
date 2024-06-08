--[[
Copyright (c) 2020 MTA: Paradise & DownTown RolePlay

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

addCommandHandler( "freecam",
	function( player, commandName )
  if not hasObjectPermissionTo ( player, "command.freecam", false ) then return end
		if not isPedInVehicle( player ) then
			if isPlayerFreecamEnabled( player ) then
				setPlayerFreecamDisabled( player )
                unbindKey( player, "w", "down", regenerarFreecam )	
                unbindKey( player, "a", "down", regenerarFreecam )	
                unbindKey( player, "s", "down", regenerarFreecam )	
                unbindKey( player, "d", "down", regenerarFreecam )	
				setElementData( player, "spec", false )
				setElementHealth ( player, getElementData( player, "freecam.oldHP" ) )
				removeElementData ( player, "freecam.oldHP" )
			elseif isElementAttached( player ) then
				outputChatBox( "No puedes usar freecam en este momento.", player, 255, 0, 0 )
			else
				setElementData ( player, "freecam.oldHP", getElementHealth(player) )
				setPlayerFreecamEnabled( player )
                setElementHealth ( player, 100)
                bindKey( player, "w", "down", regenerarFreecam )	
                bindKey( player, "a", "down", regenerarFreecam )	
                bindKey( player, "s", "down", regenerarFreecam )	
                bindKey( player, "d", "down", regenerarFreecam )	
                setElementData( player, "spec", true )				
			end
		end
	end
)

addEventHandler( "onCharacterLogout", root,
	function( )
		if isPlayerFreecamEnabled( source ) then
			setPlayerFreecamDisabled( source )
		end
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		if isPlayerFreecamEnabled( source ) then
			setPlayerFreecamDisabled( source )
		end
	end
)

function regenerarFreecam ( player )
	setElementHealth ( player, 100)
	setElementHealth ( player, 100)
	setElementHealth ( player, 100)
	setElementHealth ( player, 100)
end




