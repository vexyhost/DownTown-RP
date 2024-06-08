--[[
Copyright (c) 2019 MTA: Paradise & DownTown RolePlay
 
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

-- Events
addEvent( "onCharacterLogin", false )
addEvent( "onCharacterLogout", false )

--

local team = createTeam( "MTA: Paradise" ) -- this is used as a dummy team. We need this for faction chat to work.
 
p = { }

-- Import Groups
-- CONTRA PRIORITY MAS BAJO, QUIERE DECIR QUE TIENE MAS PRIORIDAD
local groups = {
	{ groupName = "Developers", groupID = 1, aclGroup = "Desarrollador", displayName = "Desarrollador", nametagColor = { 0, 255, 60 }, priority = 2 },
	{ groupName = "MTA Administrators", groupID = 2, aclGroup = "Administrador", displayName = "Administrador", nametagColor = { 127, 255, 127 }, priority = 1 },
	{ groupName = "MTA Moderators", groupID = 17, aclGroup = "Moderador", displayName = "Moderador", nametagColor = { 247, 157, 47 }, priority = 4 },
	{ groupName = "GameOperator", groupID = 3, aclGroup = "GameOperator", displayName = "GameOperator", nametagColor = { 255, 71, 71 }, priority = 3 },
	{ groupName = "Helper", groupID = 12, aclGroup = "Helper", displayName = "Helper", nametagColor = { 3, 177, 252 }, priority = 5 },
}

local function updateNametagColor( player )
	local nametagColor = { 127, 127, 127, priority = 100 }
	if p[ player ] and isLoggedIn( player ) then
		nametagColor = { 255, 255, 255, priority = 100 }
		if getOption( player, "staffduty" ) then
			for key, value in ipairs( groups ) do
				if isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( value.aclGroup ) ) and value.nametagColor then
					if value.priority < nametagColor.priority then
						nametagColor = value.nametagColor
						nametagColor.priority = value.priority
					end
				end
			end
		elseif getOption( player, "vip" ) then
			nametagColor = { 180, 0, 255 }
			nametagColor.priority = 50
		end
	end
	setPlayerNametagColor( player, unpack( nametagColor ) )
end

function getGroups( player )
	local g = { }
	if p[ player ] then
		for key, value in ipairs( groups ) do
			if isObjectInACLGroup( "user." .. p[ player ].username, aclGetGroup( value.aclGroup ) ) then
				table.insert( g, value )
			end
		end
		table.sort( g, function( a, b ) return a.priority < b.priority end )
	end
	return g
end

local function aclUpdate( player, saveAclIfChanged )
	local saveAcl = false
	
	if player then
		local info = p[ player ]
		if info and info.username then
			local shouldHaveAccount = false
			local account = getAccount( info.username )
			local groupinfo = exports.sql:query_assoc( "SELECT groupID FROM wcf1_user_to_groups WHERE userID = " .. info.userID )
			local sql = exports.sql:query_assoc_single( "SELECT regSerial, regSerial2 FROM wcf1_user WHERE userID = " .. info.userID )
			if groupinfo then
				-- loop through all retrieved groups
				for key, group in ipairs( groupinfo ) do
					for key2, group2 in ipairs( groups ) do
						-- we have a acl group of interest
						if group.groupID == group2.groupID then
							-- mark as person to have an account
							shouldHaveAccount = true
							
							-- add an account if it doesn't exist
							if not account then
								outputServerLog( tostring( info.username ) .. " " .. tostring( info.mtasalt ) )
								account = addAccount( info.username, info.mtasalt ) -- due to MTA's limitations, the password can't be longer than 30 chars
								if not account then
									outputDebugString( "Account Error for " .. info.username .. " - addAccount failed.", 1 )
								else
									outputDebugString( "Added account " .. info.username, 3 )
								end
							end
							
							if account then
								-- if the player has a different account password, change it
								if not getAccount( info.username, info.mtasalt ) then
									setAccountPassword( account, info.mtasalt )
								end
								
								if isGuestAccount( getPlayerAccount( player ) ) and not logIn( player, account, info.mtasalt ) then
									-- something went wrong here
									outputDebugString( "Account Error for " .. info.username .. " - login failed.", 1 )
								else
									-- show him a message
									outputChatBox( "Te has conectado como " .. group2.displayName .. ".", player, 0, 255, 0 )
									local serial = getPlayerSerial(player)
									if serial ~= sql.regSerial and tostring(serial) ~= tostring(sql.regSerial2) then
										outputChatBox("MODO DE EMERGENCIA: por seguridad sólo se puede acceder desde el PC que registró la cuenta.", player, 255, 0, 0)
										outputChatBox("Sus datos (IP, Serial) serán grabados por seguridad. Su sesión ha sido cerrada. Contacte con Jefferson.", player, 255, 0, 0)
										--outputChatBox("Puede usar /clogin [codigo] para permitir el login desde este PC temporalmente.", player, 0, 255, 0)
										exports.logs:addLogMessage("cuentastaff", "Cuenta: " .. info.username .. " IP:" .. getPlayerIP(player) .. " Serial: " .. getPlayerSerial(player))
										logOut(player)
										triggerEvent( "onCharacterLogout", player )
										setPlayerTeam( player, nil )
										setElementFrozen(player, true)
										setElementDimension(player, 6666)
									end
									local staffd = getOption(player, "staffduty")
									if staffd == true then
										setElementData(player, "account:gmduty", true)
									else
										setElementData(player, "account:gmduty", false)
									end
									if aclGroupAddObject( aclGetGroup( group2.aclGroup ), "user." .. info.username ) then
										saveAcl = true
										outputDebugString( "Added account " .. info.username .. " to " .. group2.aclGroup .. " ACL", 3 )
									end
								end
							end
						end
					end
				end
			end
			if not shouldHaveAccount and account then
				-- remove account from all ACL groups we use
				for key, value in ipairs( groups ) do
					if aclGroupRemoveObject( aclGetGroup( value.aclGroup ), "user." .. info.username ) then
						saveAcl = true
						outputDebugString( "Removed account " .. info.username .. " from " .. value.aclGroup .. " ACL", 3 )
						outputChatBox( "No estás conectado como " .. group.displayName .. ".", player, 255, 0, 0 )
					end
				end
				
				-- remove the account
				removeAccount( account )
				outputDebugString( "Removed account " .. info.username, 3 )
			end
			
			if saveAcl then
				updateNametagColor( player )
			end
		end
	else
		-- verify all accounts and remove invalid ones
		local checkedPlayers = { }
		local accounts = getAccounts( )
		for key, account in ipairs( accounts ) do
			local accountName = getAccountName( account )
			local player = getAccountPlayer( account )
			if player then
				checkedPlayers[ player ] = true
			end
			if accountName ~= "Console" then -- console may exist untouched
				local user = exports.sql:query_assoc_single( "SELECT userID FROM wcf1_user WHERE username = '%s'", accountName )
				if user then
					-- account should be deleted if no group is found
					local shouldBeDeleted = true
					local userChanged = false
					
					if user.userID then -- if this doesn't exist, the user does not exist in the db
						-- fetch all of his groups groups
						local groupinfo = exports.sql:query_assoc( "SELECT groupID FROM wcf1_user_to_groups WHERE userID = " .. user.userID )
						if groupinfo then
							-- look through all of our pre-defined groups
							for key, group in ipairs( groups ) do
								-- user does not have this group
								local hasGroup = false
								
								-- check if he does have it
								for key2, group2 in ipairs( groupinfo ) do
									if group.groupID == group2.groupID then
										-- has the group
										hasGroup = true
										
										-- shouldn't delete his account
										shouldBeDeleted = false
										
										-- make sure acl rights are set correctly
										if aclGroupAddObject( aclGetGroup( group.aclGroup ), "user." .. accountName ) then
											outputDebugString( "Added account " .. accountName .. " to ACL " .. group.aclGroup, 3 )
											saveAcl = true
											userChanged = true
											if player then
												outputChatBox( "Te has conectado como " .. group.displayName .. ".", player, 0, 255, 0 )
											end
										end
									end
								end
								
								-- doesn't have it
								if not hasGroup then
									-- make sure acl rights are removed
									if aclGroupRemoveObject( aclGetGroup( group.aclGroup ), "user." .. accountName ) then
										outputDebugString( "Removed account " .. accountName .. " from ACL " .. group.aclGroup, 3 )
										saveAcl = true
										userChanged = true
										if player then
											outputChatBox( "No estás conectado como " .. group.displayName .. ".", player, 255, 0, 0 )
										end
									end
								end
							end
						end
					end
					
					-- has no relevant group, thus we don't need the MTA account
					if shouldBeDeleted then
						if player then
							logOut( player )
						end
						outputDebugString( "Removed account " .. accountName, 3 )
						removeAccount( account )
					elseif player and isGuestAccount( getPlayerAccount( player ) ) and not logIn( player, account, p[ player ].mtasalt ) then
						-- something went wrong here
						outputDebugString( "Account Error for " .. accountName .. " - login failed.", 1 )
					end
					
					-- update the color since we have none
					if player and ( shouldBeDeleted or userChanged ) then
						updateNametagColor( player )
					end
					-- update permissions
					if userChanged or shouldBeDeleted then
						exports.foro:actualizarPermisosEnForo(user.userID)
					end
				else
					-- remove account from all ACL groups we use
					for key, value in ipairs( groups ) do
						if aclGroupRemoveObject( aclGetGroup( value.aclGroup ), "user." .. accountName ) then
							saveAcl = true
							outputDebugString( "Removed account " .. accountName .. " from " .. value.aclGroup .. " ACL", 3 )
							
							if player then
								outputChatBox( "No estás conectado como " .. group.displayName .. ".", player, 255, 0, 0 )
							end
						end
					end
					
					-- remove the account
					if player then
						logOut( player )
					end
					removeAccount( account )
					outputDebugString( "Removed account " .. accountName, 3 )
				end
			end
		end
		
		-- check all players not found by this for whetever they now have an account
		for key, value in ipairs( getElementsByType( "player" ) ) do
			if not checkedPlayers[ value ] then
				local success, needsAclUpdate = aclUpdate( value, false )
				if needsAclUpdate then
					saveAcl = true
				end
			end
		end
	end
	-- if we should save the acl, do it (permissions changed)
	if saveAclIfChanged and saveAcl then
		aclSave( )
	end
	return true, saveAcl
end

addCommandHandler( "reloadpermissions",
	function( player )
		if aclUpdate( nil, true ) then
			outputServerLog( "Se han reiniciado los permisos. (Iniciado por " .. ( not player and "Console" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
			if player then
				outputChatBox( "Se han reiniciado los permisos.", player, 0, 255, 0 )
			end
		else
			outputServerLog( "Error al reiniciar los permisos. (Iniciado por " .. ( not player and "Console" or getAccountName( getPlayerAccount( player ) ) or getPlayerName(player) ) .. ")" )
			if player then
				outputChatBox( "Error al reiniciar los permisos.", player, 255, 0, 0 )
			end
		end
	end,
	true
)

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local data = exports.sql:query_assoc( "SELECT groupID, groupName FROM wcf1_group" )
		if data then
			for key, value in ipairs( data ) do
				for key2, value2 in ipairs( groups ) do
					if value.groupName == value2.groupName then
						value2.groupID = value.groupID
					end
				end
			end
		end
		
		aclUpdate( nil, true )
	end
)

local function showLoginScreen( player, screenX, screenY, token, ip )	
	if screenX and screenY then
		if screenX < 1024 or screenY < 768 then
			outputChatBox( "ATENCIÓN: intenta utilizar una resolucion de 1024x768 o mayor.", player, 255, 0, 0)
			return
		end
	end
	if isPedInVehicle( player ) then
		removePedFromVehicle( player )
	end
	fadeCamera( player, false, 0 )
	toggleAllControls( player, false, true, false )
	
	
	spawnPlayer( source, 2638.927734375, -23.5126953125, 82.537460327148, 198.10025024414, 0, 0, 1 )
	setElementFrozen( source, true )
	setElementAlpha( source, 0 )
	setCameraInterior( source, 0 )
	setElementDimension( source , 0)

	setCameraMatrix( source, 2638.927734375, -23.5126953125, 82.543014526367, 2546.4130859375, 14.1376953125, 77.696334838867, 0, 70)
	setPlayerNametagColor( source, 127, 127, 127 )
	-- check for ip/serial bans
	if exports.sql:query_assoc_single( "SELECT * FROM wcf1_user WHERE banned = 1 AND ( lastIP = '%s' OR lastSerial = '%s' )", getPlayerIP( player ), getPlayerSerial( player ) ) then
		showChat( player, false )
		setTimer( triggerClientEvent, 300, 1, player, getResourceName( resource ) .. ":loginResult", player, 2 ) -- Banned
		return false
	end
	-- check for ip/serial bans for register
	if exports.sql:query_assoc_single( "SELECT * FROM wcf1_user WHERE banned = 1 AND ( regIP = '%s' OR regSerial = '%s' )", getPlayerIP( player ), getPlayerSerial( player ) ) then
		showChat( player, false )
		setTimer( triggerClientEvent, 300, 1, player, getResourceName( resource ) .. ":loginResult", player, 2 ) -- Banned
		return false
	end
	-- check if an account of that serial is suspended
	if exports.sql:query_assoc_single( "SELECT * FROM wcf1_user WHERE activationCode = 2 AND ( regIP = '%s' OR regSerial = '%s' )", getPlayerIP( player ), getPlayerSerial( player ) ) then
		local info = exports.sql:query_assoc_single( "SELECT * FROM wcf1_user WHERE activationCode = 2 AND ( regIP = '%s' OR regSerial = '%s' )", getPlayerIP( player ), getPlayerSerial( player ) )
		showChat( player, false )
		setElementData(source, "data.userid", tonumber(info.userID))
		setElementData(source, "dcuenta", tostring(info.activationReason))
		--setTimer( triggerClientEvent, 300, 1, player, getResourceName( resource ) .. ":loginResult", player, 6 ) -- Desactivado
		--return false
	end
	triggerClientEvent( player, getResourceName( resource ) .. ":spawnscreen", player )
end

addEvent( getResourceName( resource ) .. ":ready", true )
addEventHandler( getResourceName( resource ) .. ":ready", root,
	function( ... )
		if source == client then
			showLoginScreen( source, ... )
		end
	end
)

--

local loginAttempts = { }
local triedTokenAuth = { }

local function getPlayerHash( player, remoteIP )
	local ip = getPlayerIP( player ) or "255.255.255.0"
	if ip == "127.0.0.1" and remoteIP then -- we don't really care about a provided ip unless we want to connect from localhost
		ip = exports.sql:escape_string( remoteIP )
	end
	return ip:sub(ip:find("%d+%.%d+%.")) .. ( getPlayerSerial( player ) or "R0FLR0FLR0FLR0FLR0FLR0FLR0FLR0FL" ) .. tostring( serverToken )
end

addEvent( getResourceName( resource ) .. ":login", true )
addEventHandler( getResourceName( resource ) .. ":login", root,
	function( username, password )
		if (source == client) or (source and not client) then
			triedTokenAuth[ source ] = true
			if username and password and #username > 0 and #password > 0 then
				local info, error = exports.sql:query_assoc_single( "SELECT CONCAT(SHA1(CONCAT(username, '%s')),SHA1(CONCAT(salt, SHA1(CONCAT('%s',SHA1(CONCAT(salt, SHA1(CONCAT(username, SHA1(password)))))))))) AS token FROM wcf1_user WHERE `username` = '%s' AND password = SHA1(CONCAT(salt, SHA1(CONCAT(salt, '" .. hash("sha1", password) .. "'))))", getPlayerHash( source ), getPlayerHash( source ), username )
				p[ source ] = nil
				if not info then
					triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 1 ) -- Wrong username/password
					loginAttempts[ source ] = ( loginAttempts[ source ] or 0 ) + 1
					if loginAttempts[ source ] >= 30 then
						local serial = getPlayerSerial( source )
						banPlayer( source, true, false, false, root, "Too many login attempts.", 900 )
						if serial then
							addBan( nil, nil, serial, root, "Too many login attempts.", 900 )
						end
					end
				else
					loginAttempts[ source ] = nil
					performLogin( source, info.token, true )
				end
			end
		end
	end
)
-- performLogin( source, token, false, ip )
function performLogin( source, token, isPasswordAuth, ip )
	if source and ( isPasswordAuth or not triedTokenAuth[ source ] ) then
		triedTokenAuth[ source ] = true
		if token then
			if #token == 80 then
				local info = exports.sql:query_assoc_single( "SELECT userID, username, banned, activationCode, activationReason, SUBSTRING(LOWER(SHA1(CONCAT(userName,SHA1(CONCAT(password,salt))))),1,30) AS salts, userOptions FROM wcf1_user WHERE CONCAT(SHA1(CONCAT(username, '%s')),SHA1(CONCAT(salt, SHA1(CONCAT('%s',SHA1(CONCAT(salt, SHA1(CONCAT(username, SHA1(password)))))))))) = '%s' LIMIT 1", getPlayerHash( source, ip ), getPlayerHash( source, ip ), token )
				p[ source ] = nil
				if not info then
					if isPasswordAuth then
						triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 1 ) -- Wrong username/password
					end
					return false
				else
					if info.banned == 1 then
						triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 2 ) -- Banned
						return false
					elseif info.activationCode == 1 then
						if isPasswordAuth then
							triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 3 ) -- Requires activation
						end
						local dat = setElementData(source, "data.userid", tonumber(info.userID))
						return false
					elseif info.activationCode == 2 then
						triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 6 ) -- Cuenta desactivada por un staff.
						setElementData(source, "data.userid", tonumber(info.userID))
						setElementData(source, "dcuenta", tostring(info.activationReason))
						return false	
					else
						-- check if another user is logged in on that account
						for player, data in pairs( p ) do
							if data.userID == info.userID then
								triggerClientEvent( source, getResourceName( resource ) .. ":loginResult", source, 5 ) -- another player with that account found
								return false
							end
						end
						
						local username = info.username
						p[ source ] = { userID = info.userID, username = username, mtasalt = info.salts, options = info.userOptions and fromJSON( info.userOptions ) or { } }
						
						-- check for admin rights
						aclUpdate( source, true )
						
						-- show characters 
						local chars = exports.sql:query_assoc( "SELECT characterID, characterName, genero, edad, CKuIDStaff, lastLogin FROM characters WHERE userID = " .. info.userID .. " ORDER BY lastLogin DESC" )
						if isPasswordAuth then
							triggerClientEvent( source, getResourceName( resource ) .. ":characters", source, chars, true, nil, getPlayerIP( source ) ~= "127.0.0.1" and getPlayerIP( source ) )
						else
							triggerClientEvent( source, getResourceName( resource ) .. ":characters", source, chars, true )
						end
						
						exports.sql:query_free( "UPDATE wcf1_user SET lastIP = '%s', lastSerial = '%s' WHERE userID = " .. tonumber( info.userID ), getPlayerIP( source ), getPlayerSerial( source ) )
						
						return true
					end
				end
			end
		end
	end
	return false
end


local function getWeaponString( player )
	local weapons = { }
	local hasAnyWeapons = false
	for slot = 0, 12 do
		local weapon = getPedWeapon( player, slot )
		if weapon > 0 then
			local ammo = getPedTotalAmmo( player, slot )
			if ammo > 0 then
				weapons[weapon] = ammo
				hasAnyWeapons = true
			end
		end
	end
	if hasAnyWeapons then
		return "'" .. exports.sql:escape_string( toJSON( weapons ):gsub( " ", "" ) ) .. "'"
	else
		return "NULL"
	end
end
 
local function savePlayer( player )
	if not player then
		for key, value in ipairs( getElementsByType( "player" ) ) do
			savePlayer( value )
		end
	else
		if isLoggedIn( player ) then
			-- save character since it's logged in
			local x, y, z = getElementPosition( player )
			local dimension = getElementDimension( player )
			local interior = getElementInterior( player )
			local sed = tonumber(getElementData(player, "sed"))
			local cansancio = tonumber(getElementData(player, "cansancio"))
			local hambre = tonumber(getElementData(player, "hambre"))
			local gordura = tonumber(getElementData(player, "gordura"))
			local musculatura = tonumber(getElementData(player, "musculatura"))
			local tpd = tonumber(getElementData(player, "tpd"))
			-- Evitar valores negativos que provocan errores al guardarse.
			if sed < 0 then sed = 0 end
			if cansancio < 0 then cansancio = 0 end
			if hambre < 0 then hambre = 0 end
			if gordura < 0 then gordura = 0 end
			if musculatura < 0 then musculatura = 0 end
			if tpd < 0 then tpd = 0 end
			local sql, error = exports.sql:query_free( "UPDATE characters SET musculatura = " ..musculatura.. ", gordura = " .. gordura .. ", cansancio = " .. cansancio .. ", sed = " .. sed .. ", hambre = " .. hambre .. ", tpd = " .. tpd .. ", x = " .. x .. ", y = " .. y .. ", z = " .. z .. ", dimension = " .. dimension .. ", interior = " .. interior .. ", rotation = " .. getPedRotation( player ) .. ", health = " .. math.floor( getElementHealth( player ) ) .. ", armor = " .. math.floor( getPedArmor( player ) ) .. ", weapons = " .. getWeaponString( player ) .. ", lastLogin = NOW() WHERE characterID = " .. tonumber( getCharacterID( player ) ) )
		end
	end
end
setTimer( savePlayer, 300000, 0 ) -- Auto-Save every five minutes


addEventHandler( "onResourceStop", resourceRoot,
	function( )
		-- logout all players
		for key, value in ipairs( getElementsByType( "player" ) ) do
			savePlayer( value )
			
			if p[ value ] and p[ value ].charID then
				triggerEvent( "onCharacterLogout", value )
				setPlayerTeam( value, nil )
				takeAllWeapons( value )
			end
			
			if not isGuestAccount( getPlayerAccount( value ) ) then
				logOut( value )
			end
		end
	end
)

addEvent( getResourceName( resource ) .. ":logout", true )
addEventHandler( getResourceName( resource ) .. ":logout", root,
	function( )
		if source == client then
			savePlayer( source )
			if p[ source ].charID then
				triggerEvent( "onCharacterLogout", source )
				setPlayerTeam( source, nil )
				takeAllWeapons( source )
				local staffd = getOption(source, "staffduty")
				if staffd == true then
					setElementData(source, "account:gmduty", true)
				end
			end
			p[ source ] = nil
			showLoginScreen( source )
			
			if not isGuestAccount( getPlayerAccount( source ) ) then
				logOut( source )
			end
		end
	end
)

addEventHandler( "onPlayerJoin", root,
	function( )
		setPlayerNametagColor( source, 127, 127, 127 )
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		if p[ source ] then
			savePlayer( source )
			if p[ source ].charID then
				triggerEvent( "onCharacterLogout", source )
			end
			p[ source ] = nil
			loginAttempts[ source ] = nil
			triedTokenAuth[ source ] = nil
		end
	end
)

addEvent( getResourceName( resource ) .. ":spawn", true )
addEventHandler( getResourceName( resource ) .. ":spawn", root, 
	function( charID )
		if source == client and ( not isPedDead( source ) or not isLoggedIn( source ) ) then
			local userID = p[ source ] and p[ source ].userID
			if tonumber( userID ) and tonumber( charID ) then
				-- if the player is logged in, save him
				savePlayer( source )
				if p[ source ].charID then
					triggerEvent( "onCharacterLogout", source )
					setPlayerTeam( source, nil )
					takeAllWeapons( source )
					local data = getAllElementData(source)
					for k, v in ipairs(data) do
						removeElementData(source, k)
					end
					local staffd = getOption(source, "staffduty")
					if staffd == true then
						setElementData(source, "account:gmduty", true)
					end
					p[ source ].charID = nil
					p[ source ].money = nil
					p[ source ].job = nil
				end
			 
				local char = exports.sql:query_assoc_single( "SELECT * FROM characters WHERE userID = " .. tonumber( userID ) .. " AND characterID = " .. tonumber( charID ) )
				if char then
					local mtaCharName = char.characterName:gsub( " ", "_" )
					local otherPlayer = getPlayerFromName( mtaCharName )
					if otherPlayer and otherPlayer ~= source then
						kickPlayer( otherPlayer )
					end
					setPlayerName( source, mtaCharName )
					
					-- spawn the player, as it's a valid char
					if char.nuevo == 0 then
						spawnPlayer( source, char.x, char.y, char.z, char.rotation, 0, char.interior, char.dimension )
						fadeCamera( source, true )
						setCameraTarget( source, source )
						setCameraInterior( source, char.interior )
					end 
					if char.nuevo == 1 then
						spawnPlayer( source, 2260.63, -87.93, 26.45, 179.428710937, 0, 0, 0 )
						fadeCamera( source, true )
						setCameraTarget( source, source )
						setCameraInterior( source, 0 )
						exports.sql:query_free( "UPDATE characters SET nuevo = 0 WHERE characterID = " .. tonumber( charID ) )
						-- Si es una chica, le asignamos aquí una skin femenina por defecto.
						-- Chica negra, skin ID 69
						-- Chica blanca, skin ID 55
						if char.genero == 2 then
							if char.color == 1 then -- Blanco
								exports.sql:query_free( "UPDATE characters SET skin = 55 WHERE characterID = " .. tonumber( charID ) )
							else -- Negro
								exports.sql:query_free( "UPDATE characters SET skin = 69 WHERE characterID = " .. tonumber( charID ) )
							end
						end
					end 
					toggleAllControls( source, true, true, false )
					setElementFrozen( source, false )
					setElementAlpha( source, 255 )
					
					setElementHealth( source, char.health )
					setPedArmor( source, char.armor )
					if char.sed then
						setElementData(source, "sed", char.sed)
					else
						setElementData(source, "sed", 0)
					end
					if char.hambre then
						setElementData(source, "hambre", char.hambre)
					else
						setElementData(source, "hambre", 0)
					end
					if char.cansancio then
						setElementData(source, "cansancio", char.cansancio)
					else
						setElementData(source, "cansancio", 0)
					end
					if char.tpd then
						setElementData(source, "tpd", char.tpd)
					else
						setElementData(source, "tpd", 0)
					end
					if char.gordura then
						setElementData(source, "gordura", tonumber(char.gordura))
						setTimer(setPedStat, 3000, 1, source, 21, tonumber(char.gordura))
					else
						setElementData(source, "gordura", 0)
					end
					if char.musculatura then
						setElementData(source, "musculatura", tonumber(char.musculatura))
						setTimer(setPedStat, 3000, 1, source, 23, tonumber(char.musculatura))
					else
						setElementData(source, "musculatura", 0)
					end
					
					p[ source ].money = char.money
					setPlayerMoney( source, char.money )
					setElementData(source, "license.car", char.car_license)
					setElementData(source, "license.gun", char.gun_license)
					setElementData(source, "license.barco", char.boat_license)
					setElementData(source, "license.camion", char.camion_license)
					if char.yo then
						setElementData(source, "yo", tostring(char.yo))
					else
						setElementData(source, "yo", "((Sin /yo asignado))")
					end
					
					p[ source ].charID = tonumber( charID )
					p[ source ].characterName = char.characterName
					updateNametag( source )
					
					-- restore weapons
					if char.weapons then
						local weapons = fromJSON( char.weapons )
						if weapons then
							for weapon, ammo in pairs( weapons ) do
								giveWeapon( source, weapon, ammo )
							end
						end
					end
					
					p[ source ].job = char.job
					
					-- restore the player's languages, remove invalid ones
					if not char.languages then
						-- default is English with full skill
						p[ source ].languages = { en = { skill = 1000, current = true } }
						saveLanguages( source, p[ source ].languages )
					else
						p[ source ].languages = fromJSON( char.languages )
						local changed = false
						local languages = 0
						for key, value in pairs( p[ source ].languages ) do
							if isValidLanguage( "en" ) then
								changed = true
								languages = languages + 1
								if not isValidLanguage( key ) then
									p[ source ].languages[ key ] = nil
									languages = languages - 1
								elseif type( value.skill ) ~= 'number' then
									value.skill = 0
								elseif value.skill < 0 then
									value.skill = 0
								elseif value.skill > 1000 then
									value.skill = 1000
								else
									changed = false
								end
							else
								languages = languages + 1
							end
						end
						
						if languages == 0 then
							-- player has no language at all
							p[ source ].languages = { en = { skill = 1000, current = true } }
							changed = true
						end
						
						if changed then
							saveLanguages( source, p[ source ].languages )
						end
					end
					
					setPlayerTeam( source, team )
					triggerClientEvent( source, getResourceName( resource ) .. ":onSpawn", source, p[ source ].languages )
					triggerEvent( "onCharacterLogin", source )
					
					showCursor( source, false )
					
					-- set last login to now
					exports.sql:query_free( "UPDATE characters SET lastLogin = NOW() WHERE characterID = " .. tonumber( charID ) )
					exports.logs:addLogMessage("login", char.characterName.. " ha logueado. IP: "..getPlayerIP(source)..". Serial: "..getPlayerSerial(source)..".\n")
					if char.condiciones < exports.condiciones:getVersion() then
						local cons = exports.sql:query_assoc_single("SELECT * FROM `condiciones` ORDER BY `condiciones`.`version` DESC LIMIT 1")
						triggerClientEvent("onMostrarCondiciones", source, tostring(cons.version), tostring(cons.texto))
                    end
				end
			end
		end
	end
)

addEventHandler( "onPlayerChangeNick", root,
	function( )
		if isLoggedIn( source ) then
			cancelEvent( )
		end
	end
)

function getCharacterID( player )
	return player and p[ player ] and p[ player ].charID or false
end

function isLoggedIn( player )
	return getCharacterID( player ) and true or false
end

function getUserID( player )
	return player and p[ player ] and p[ player ].userID or false
end

function getUserName( player )
	return player and p[ player ] and p[ player ].username or false
end

function getCharacterName( characterID )
	if type( characterID ) == "number" then
		for player, data in pairs( p ) do
			if data.charID == characterID then
				local name = getPlayerName( player ):gsub( "_", " " )
				return name
			end
		end
		
		local data = exports.sql:query_assoc_single( "SELECT characterName FROM characters WHERE characterID = " .. characterID )
		if data then
			return data.characterName
		end
	end
	return false
end

function setMoney( player, amount )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	amount = tonumber( amount )
	if amount >= 0 and isLoggedIn( player ) then
		if exports.sql:query_free( "UPDATE characters SET money = " .. amount .. " WHERE characterID = " .. p[ player ].charID ) then
			p[ player ].money = amount
			setPlayerMoney( player, amount )
			return true
		end
	end
	return false
end

function giveMoney( player, amount )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	return tonumber(amount) >= 0 and setMoney( player, getMoney( player ) + amount )
end

function takeMoney( player, amount )
	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end
	return amount >= 0 and setMoney( player, getMoney( player ) - amount )
end

function getMoney( player, amount )
	return isLoggedIn( player ) and p[ player ].money or 0
end

function updateCharacters( player )
	if player and p[ player ].userID then
		local chars = exports.sql:query_assoc( "SELECT characterID, characterName, genero, edad, lastLogin, CKuIDStaff FROM characters WHERE userID = " .. p[ player ].userID .. " ORDER BY lastLogin DESC" )
		triggerClientEvent( player, getResourceName( resource ) .. ":characters", player, chars, false )
		return true
	end
	return false
end

function createCharacter( player, name, edad, genero, color )
	if player and p[ player ].userID then
		if exports.sql:query_assoc_single( "SELECT characterID FROM characters WHERE characterName = '%s'", name ) then
			triggerClientEvent( player, "players:characterCreationResult", player, 1 )
		elseif exports.sql:query_free( "INSERT INTO characters (characterName, userID, x, y, z, edad, genero, color, interior, dimension, rotation) VALUES ('%s', " .. p[ player ].userID .. ", 2216.27, 137.76, 26.48, "..tonumber(edad)..", "..tonumber(genero)..", "..tonumber(color)..", 0, 0, 270)", name ) then
			updateCharacters( player )
			triggerClientEvent( player, "players:characterCreationResult", player, 0 )
			
			return true
		end
	end
	return false
end

--

function updateNametag( player )
	if player then
		local text = "[" .. getID( player ) .. "] " .. ( p[ player ] and p[ player ].characterName or getPlayerName( player ):gsub( "_", " " ) )
		if getPlayerNametagText( player ) ~= tostring( text ) then
			setPlayerNametagText( player, tostring( text ) )
		end
		updateNametagColor( player )
		return true
	end
	return false
end

addEventHandler( "onPlayerSpawn", root,
	function( )
		updateNametag( source )
	end
)

setTimer(
	function( )
		for player in pairs( p ) do
			updateNametag( player )
		end
	end,
	15000,
	0
)

function getJob( player )
	return isLoggedIn( player ) and p[ player ].job or nil
end

function setJob( player, job )
	local charID = getCharacterID( player )
	if charID and exports.sql:query_free( "UPDATE characters SET job = '%s' WHERE characterID = " .. charID, job ) then
		p[ player ].job = job
		return true
	end
	return false
end

function getOption( player, key )
	return player and p[ player ] and p[ player ].options and key and p[ player ].options[ key ] or nil
end

function setOption( player, key, value )
	if player and p[ player ] and p[ player ].options and type( key ) == 'string' then
		local oldValue = p[ player ].options[ key ]
		p[ player ].options[ key ] = value
		
		
		local str = toJSON( p[ player ].options )
		if str then
			if str == toJSON( { } ) then
				local success = exports.sql:query_free( "UPDATE wcf1_user SET userOptions = NULL WHERE userID = " .. getUserID( player ) )
				return success
			elseif exports.sql:query_free( "UPDATE wcf1_user SET userOptions = '%s' WHERE userID = " .. getUserID( player ), str ) then
				return true
			end
		end
		p[ player ].options[ key ] = oldValue
	end
	return false
end
