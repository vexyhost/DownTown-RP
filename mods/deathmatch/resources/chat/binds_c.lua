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

-- Bind to toggle the cursor from showing
addCommandHandler( "togglecursor",
	function( )
		if exports.players:isLoggedIn( ) and not getElementData(getLocalPlayer(), "nocursor") == true then
			showCursor( not isCursorShowing( ) )
		end
	end
)
bindKey( "m", "down", "togglecursor" )
          
function offCursor()
	showCursor(false)
end
addEvent("offCursor", true)
addEventHandler("offCursor", getRootElement(), offCursor)

function onCursor()
	showCursor(true)
end
addEvent("onCursor", true)
addEventHandler("onCursor", getRootElement(), onCursor)

-- Local OOC bind
bindKey( "b", "down", "chatbox", "LocalOOC" )

-- Global OOC bind
bindKey( "o", "down", "chatbox", "GlobalOOC" )

bindKey( "u", "down", "chatbox", "WalkieTalkie" )

-- Facción OOC
--bindKey( "z", "down", "chatbox", "FaccionOOC" )
bindKey( "F6", "down", "misf" )
unbindKey( "z", "down", "voiceptt" )
bindKey( "z", "down", "voiceptt" )
bindKey( "x", "down", "voiceptt" )
bindKey( "x", "down", "whisper" )
bindKey( "x", "up", "whisper" )
bindKey( "r", "down", "rec" )   
bindKey( "F12", "down", "ss" )   
