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

local localPlayer = getLocalPlayer( )
local loggedIn = false
local screenX, screenY = guiGetScreenSize( )
local characters = false
local languages = false
local localIP = nil
setFarClipDistance(6000)

addEvent( getResourceName( resource ) .. ":spawnscreen", true )
addEventHandler( getResourceName( resource ) .. ":spawnscreen", localPlayer,
	function( )
		setTimer(
			function( )
				if not characters then
					setFarClipDistance(2500)
					triggerServerEvent("onRequestLoginPanel",getLocalPlayer())
				end
			end, 300, 1
		)
		
		fadeCamera( true, 1 )
		showChat( false )
		setPlayerHudComponentVisible( "radar", false )
		setPlayerHudComponentVisible( "area_name", false )
		loggedIn = false
		characters = false
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		setPlayerHudComponentVisible( "area_name", false )
	end
)
--

addCommandHandler( "changechar",
	function( )
		if loggedIn then
			local window, forced = exports.gui:getShowing( )
			if not forced then
				if window == 'characters' then
					exports.gui:hide( )
				else
					if getElementData(getLocalPlayer(), "muerto") == true or getElementData(getLocalPlayer(), "tazed") == true or getElementData(getLocalPlayer(), "accidente") == true then 
						outputChatBox("¡Te recordamos que NO puedes evadir rol!", 255, 0, 0)
						triggerServerEvent("onMensajeStaff", getLocalPlayer(), "¡ALERTA URGENTE! POSIBLE EVASIÓN DE ROL DE ["..getElementData(getLocalPlayer(), "playerid").."] "..getPlayerName(getLocalPlayer()):gsub("_", " ").."!", 255, 0, 0)
					else
						exports.gui:show( 'characters', false, false, true )
					end
				end
			end
		end
	end
)
bindKey( "pause", "down", "changechar" )

function selectCharacter( id, name )
	if loggedIn and (getElementData(getLocalPlayer(), "muerto") == true or getElementData(getLocalPlayer(), "tazed") == true or getElementData(getLocalPlayer(), "accidente") == true) then 
		outputChatBox("¡Te recordamos que NO puedes evadir rol!", 255, 0, 0)
		triggerServerEvent("onMensajeStaff", getLocalPlayer(), "¡ALERTA URGENTE! POSIBLE EVASIÓN DE ROL DE ["..getElementData(getLocalPlayer(), "playerid").."] "..getPlayerName(getLocalPlayer()):gsub("_", " ").."!", 255, 0, 0)
	else
		if id == -1 then
			-- new character
			exports.gui:show( 'create_character', true )
		elseif id == -2 then
			-- logout
			exports.gui:hide( )
			triggerServerEvent( getResourceName( resource ) .. ":logout", localPlayer )
		elseif id == -3 then
			-- PJ Ckeado
			showChat(true)
			outputChatBox("Este PJ está bloqueado por un CK. Acude a foro para más información.", 255, 0, 0)
		elseif loggedIn and name == getPlayerName( localPlayer ):gsub( "_", " " ) then
			exports.gui:hide( )
		else
			exports.gui:hide( )
			triggerServerEvent( getResourceName( resource ) .. ":spawn", localPlayer, id )
		end
	end
end

addEvent( getResourceName( resource ) .. ":characters", true )
addEventHandler( getResourceName( resource ) .. ":characters", localPlayer,
	function( chars, spawn, token, ip )
		triggerEvent("onDestroyLoginPanel", localPlayer)
		characters = chars
		exports.gui:updateCharacters( chars )
		isSpawnScreen = spawn
		if isSpawnScreen then
			exports.gui:show( 'characters', true, true, true )
			showChat( false )
			setPlayerHudComponentVisible( "radar", false )
			setPlayerHudComponentVisible( "area_name", false )
			loggedIn = false
		end
	end
)

addEventHandler( "onClientResourceStart", root,
	function( res )
		if getResourceName( res ) == "players" then
			setTimer(
				function( )
					if characters then
						exports.gui:updateCharacters( characters )
						if not loggedIn then
							exports.gui:show( 'characters', true, true, true )
						end
					else
						triggerServerEvent("onRequestLoginPanel",getLocalPlayer())
					end
					
					if languages then
						exports.gui:updateLanguages( languages )
					end
				end,
				150,
				1
			)             
		end
	end
)

addEventHandler( "onClientResourceStop", root,
	function( res )
		exports[ getResourceName( res ) ] = nil
	end
)

addEvent( getResourceName( resource ) .. ":onSpawn", true )
addEventHandler( getResourceName( resource ) .. ":onSpawn", localPlayer,
	function( langs )
		exports.gui:hide( )	
		showChat( true )
		setPlayerHudComponentVisible( "radar", true )
		loggedIn = true
		setElementData(localPlayer, "hud", true)
		exports.gui:updateCharacters( characters )
		languages = langs
		exports.gui:updateLanguages( languages )
		
		outputChatBox( "Ahora estás jugando como " .. getPlayerName( localPlayer ):gsub( "_", " " ) .. ".", 0, 255, 0 )
		setFarClipDistance(1500)
		triggerEvent("onMostrarPuntosCardinales", localPlayer)
		setElementAlpha(localPlayer, 127)
		setTimer(setElementAlpha, 4000, 1, localPlayer, 255)
		
	end
)

addEvent( getResourceName( resource ) .. ":languages", true )
addEventHandler( getResourceName( resource ) .. ":languages", localPlayer,
	function( langs )
		languages = langs
		exports.gui:updateLanguages( languages )
	end
)

function isLoggedIn( )
	return loggedIn
end

addEvent( "updateCharacterName", true )
addEventHandler( "updateCharacterName", localPlayer,
	function( id, name )
		if characters then
			for key, value in ipairs( characters ) do
				if value.characterID == id then
					characters[key].characterName = name
					exports.gui:updateCharacters( characters )
					return
				end
			end
		end
	end
)

