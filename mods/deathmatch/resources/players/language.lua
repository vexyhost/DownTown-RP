--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 DownTown Roleplay

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

function saveLanguages( player, languages )
	local characterID = getCharacterID( player )
	if characterID then
		if exports.sql:query_free( "UPDATE characters SET languages = '%s' WHERE characterID = " .. characterID, toJSON( languages ) ) then
			return true
		end
	end
	return false
end

function getCurrentLanguage( player )
	if isLoggedIn( player ) then
		for key, value in pairs( p[ player ].languages ) do
			if value.current then
				return key
			end
		end
	end
end

function getLanguageSkill( player, language )
	return isLoggedIn( player ) and p[ player ].languages and p[ player ].languages[ language ] and p[ player ].languages[ language ].skill or false
end

function increaseLanguageSkill( player, language )
	local skill = getLanguageSkill( player, language )
	if skill and skill < 1000 then
		p[ player ].languages[ language ].skill = skill + 1
		if saveLanguages( player, p[ player ].languages ) then
			triggerClientEvent( player, getResourceName( resource ) .. ":languages", player, p[ player ].languages )
			return true
		else
			p[ player ].languages[ language ].skill = skill - 1
		end
	end
	return false
end

function increaseLanguageSkill2( player, language, skill2 )
	local skill = getLanguageSkill( player, language )
	if skill and skill <= 1000 and ((skill2+skill)<=1000) then
		p[ player ].languages[ language ].skill = skill + skill2
		if saveLanguages( player, p[ player ].languages ) then
			triggerClientEvent( player, getResourceName( resource ) .. ":languages", player, p[ player ].languages )
			return true
		else
			p[ player ].languages[ language ].skill = skill - skill2
		end
	end
	return false
end

local function count( table )
	local counter = 0
	for key, value in pairs( table ) do
		counter = counter + 1
	end
	return counter
end

function learnLanguage( player, language )
	if isValidLanguage( language ) then
		if count( p[ player ].languages ) <= 4 then
			p[ player ].languages[ language ] = { skill = 50 }
			p[ player ].languages[ language ].skill = 50
			if saveLanguages( player, p[ player ].languages ) then
				triggerClientEvent( player, getResourceName( resource ) .. ":languages", player, p[ player ].languages )
				return true
			else
				p[ player ].languages[ language ] = nil
				return false, 4
			end
		else
			return false, 3
		end
	end
end

addEvent( "players:selectLanguage", true )
addEventHandler( "players:selectLanguage", root,
	function( flag )
		if source == client then
			if isLoggedIn( source ) and isValidLanguage( flag ) then
				-- it's valid, if not ignore it
				if p[ source ].languages[ flag ] then
					-- player has the language, if not ignore it
					if getCurrentLanguage( source ) == flag then
						outputChatBox( "Ya estas hablando " .. getLanguageName( flag ) .. ".", source, 0, 255, 0 )
					else
						for key, value in pairs( p[ source ].languages ) do
							if key == flag then
								value.current = true
							else
								value.current = nil
							end
						end
						
						if saveLanguages( source, p[ source ].languages ) then
							triggerClientEvent( source, getResourceName( resource ) .. ":languages", source, p[ source ].languages )
							outputChatBox( "Ahora estas hablando " .. getLanguageName( flag ) .. ".", source, 0, 255, 0 )
						end
					end
				end
			end
		end
	end
)
