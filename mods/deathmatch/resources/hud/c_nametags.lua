local localPlayer = getLocalPlayer()
local show = true
local badges = {}
local masks = {}
local nametags = {}
            
-- settings
--local _max_distance = (5 or (getElementData(localPlayer, "account:gmduty")==true and 120)) -- max. distance it's visible
local _max_distance = 20
local _min_distance = 1.5 -- minimum distance, if a player is nearer his nametag size wont change
local _alpha_distance = 10 -- nametag is faded out after this distance
local _nametag_alpha = 170 -- alpha of the nametag (max.)
local _bar_alpha = 120 -- alpha of the bar (max.)
local _scale = 0.2 -- change this to keep it looking good (proportions)
local _nametag_textsize = 0.6 -- change to increase nametag text
local _chatbubble_size = 5
local _bar_width = 40
local _bar_height = 6
local _bar_border = 1.2
-- adjust settings
local _, screenY = guiGetScreenSize( )
real_scale = screenY / ( _scale * 800 ) 
local _alpha_distance_diff = _max_distance - _alpha_distance

local oldConsoleState = false
local oldInputState = false

addEvent( "nametags:chatbubble", true )
addEventHandler( "nametags:chatbubble", root,
	function( state )
		if nametags[ source ] ~= nil and ( state == true or state == false or state == 1 ) then
			nametags[ source ] = state
		end
	end
)

function startRes()
	for key, value in ipairs(getElementsByType("player")) do
		setPlayerNametagShowing(value, false)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), startRes)

local playerhp = { }
local lasthp = { }

local playerarmor = { }
local lastarmor = { }

function playerQuit()
	if (getElementType(source)=="player") then
		playerhp[source] = nil
		lasthp[source] = nil
		playerarmor[source] = nil
		lastarmor[source] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), playerQuit)
addEventHandler("onClientPlayerQuit", getRootElement(), playerQuit)

function setNametagOnJoin()
	setPlayerNametagShowing(source, false)
end
addEventHandler("onClientPlayerJoin", getRootElement(), setNametagOnJoin)

function streamIn()
	if (getElementType(source)=="player") then
		playerhp[source] = getElementHealth(source)
		lasthp[source] = playerhp[source]
		
		playerarmor[source] = getPedArmor(source)
		lastarmor[source] = playerarmor[source]
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

local lastrot = nil

function aimsSniper()
	return getPedControlState(localPlayer, "aim_weapon") and getPedWeapon(localPlayer) == 34
end

function aimsAt(player)
	return getPedTarget(localPlayer) == player and aimsSniper()
end

function getVehicleVelocity(vehicle)
	speedx, speedy, speedz = getElementVelocity (vehicle)
	actualSpeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)         
    mph = math.floor(actualSpeed * 160)
	return mph
end 

function renderNametags()
	if (show) then
		if getElementData(localPlayer, "nohud") then return end
		if getPedOccupiedVehicle(localPlayer) and getVehicleVelocity(getPedOccupiedVehicle(localPlayer)) >= 60 then return end
		local newConsoleState = isConsoleActive( )
		if newConsoleState ~= oldConsoleState then
			triggerServerEvent( "nametags:chatbubble", localPlayer, newConsoleState and 1 or false )
			oldConsoleState = newConsoleState
		else
			local newInputState = isChatBoxInputActive( )
			if newInputState ~= oldInputState then
				triggerServerEvent( "nametags:chatbubble", localPlayer, newInputState )
				oldInputState = newInputState
			end
		end
		local players = { }
		local distances = { }
		--local lx, ly, lz = getCameraMatrix()
		local lx, ly, lz = getElementPosition(localPlayer)
		local dim = getElementDimension(localPlayer)
		-- CHATICONS
		local cx, cy, cz = getCameraMatrix( )
		local interior = getElementInterior( localPlayer )
		-- loop through all players
		for player, chaticon in pairs( nametags ) do
			if isElement( player ) then
				if getElementDimension( player ) == dim and getElementInterior( player ) == interior and isElementOnScreen( player ) then
					local px, py, pz = getElementPosition( player )
					local distance = getDistanceBetweenPoints3D( px, py, pz, cx, cy, cz )
					if distance <= _max_distance and ( getElementData( localPlayer, "collisionless" ) or isLineOfSightClear( cx, cy, cz, px, py, pz, true, false, false, true, false, false, true ) ) then
						local dz = 1 + 2 * math.min( 1, distance / _min_distance ) * _scale
						if isPedDucked( player ) then
							dz = dz / 2
						end
						pz = pz + dz
						local sx, sy = getScreenFromWorldPosition( px, py, pz )
						if sx and sy then
							local cx = sx
							local scale = _max_distance / ( real_scale * distance )
							local health = math.min( 100, getElementHealth( player ) )
							if chaticon then
								local square = math.ceil( _chatbubble_size * scale )
								local sy = sy + square / 1.9
								local r, g, b = 255 - 128 * health / 100, 127 + 128 * health / 100, 127
								dxDrawImage( cx, sy, square, square, chaticon == true and "images/hud/chat.png" or "images/hud/console.png", 0, 0, 0, tocolor( r, g, b, nametag_alpha ) )
							end
						end
					end
				end
			end
		end
		-- FIN CHATICONS
		for key, player in ipairs(getElementsByType("player")) do
			if (isElement(player)) and getElementDimension(player) == dim then
				local rx, ry, rz = getElementPosition(player)
				local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
				local limitdistance
				if getElementData(localPlayer, "account:gmduty") == true then
					limitdistance = 30
				else
					limitdistance = 5
				end
				if ((player~=localPlayer) and isElementOnScreen(player)) then
					if (aimsAt(player) or distance<limitdistance or reconx) then
						if not getElementData(player, "reconx") and not getElementData(player, "freecam:state") and not (getElementAlpha(player) < 255) then
							--local lx, ly, lz = getPedBonePosition(localPlayer, 7)
							local lx, ly, lz = getCameraMatrix()
							local vehicle = getPedOccupiedVehicle(player) or nil
							local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, vehicle)
							if not (collision) or aimsSniper() or (reconx) then
								local x, y, z = getElementPosition(player)
								if not (isPedDucked(player)) then
									z = z + 1
								else
									z = z + 0.5
								end
								local sx, sy = getScreenFromWorldPosition(x, y, z+0.30, 100, false)
								local oldsy = nil
								local badge = false
								local tinted = false
								local name = getPlayerName(player):gsub("_", " ")
								if (sx) and (sy) then
									distance = distance / 5	
									if (reconx or aimsAt(player)) then distance = 1
									elseif (distance<1) then distance = 1
									elseif (distance>2) then distance = 2 end	
									local offset = 60 / distance
									oldsy = sy 
									local picxsize = 32 / 1.3 /distance
									local picysize = 37 / 1.3 /distance
									local xpos = 0
									local isGM = getElementData(player,"account:gmduty")
									if isGM  then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/gm.png")
										xpos = xpos + picxsize 
									end	
								     local isHelper = getElementData(player,"account:helpduty")
									if isHelper  then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/helper.png")
										xpos = xpos + picxsize 
									end	
									local poli = getElementData(player, "duty")
									if poli == true then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/badge2.png")
										xpos = xpos + picxsize
									end
									local cinturon = getElementData(player, "player.cinturon")
									if cinturon == true then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/cinturon.png")
										xpos = xpos + picxsize
									end	
									local masked = false
									if getElementData(player, "mascara") == true then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/mask.png")
										xpos = xpos + picxsize
										masked = true
									end												
                                    local buzoloco = false
									if getElementData(player, "buzo") == true then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/scuba.png")
										xpos = xpos + picxsize
										buzoloco = true
									end
									local developer = false
									if getElementData(player, "programandos") == true then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/dev.png")
										xpos = xpos + picxsize
										developer = true
									end	
									if getElementData( player,"Cascos") == 1 then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/helmet.png")
										xpos = xpos + picxsize
										masked = true
                                    end
									local vehicle = getPedOccupiedVehicle( player )
									local windowsDown = false
									if vehicle then
										if (getElementData(vehicle, "vehicle:windowstat") == 1) then
											windowsDown = true
										end
												
										if not windowsDown and vehicle ~= getPedOccupiedVehicle(localPlayer) and getElementData(vehicle, "tinted") then
											name = "Unknown Person (Tint)"
											tinted = true
										end
									end	
									if not tinted then
										if masked then
											name = "Persona Desconocida"
										end
										local vehicle = getPedOccupiedVehicle( player )
										if vehicle and getElementData(vehicle, "ventanas") then
											name = "Ventanas tintadas"
										end
										for k, v in pairs(badges) do
											local title = getElementData(player, k)
											if title then
												dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/badge" .. tostring(v[4] or 1) .. ".png")
												xpos = xpos + picxsize 
												name = title .. "\n" .. name
												badge = true
												break
											end
										end
									end
									local health = getElementHealth( player )
									if (health <= 30) then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/lowhp.png")
										xpos = xpos + picxsize 
									end	
									local armour = getPedArmor( player )
									if armour > 50 then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/armour.png")
										xpos = xpos + picxsize 
									end
									if windowsDown then
										dxDrawImage(sx-offset+xpos,oldsy,picxsize,picysize,"images/hud/window.png")
										xpos = xpos + picxsize 
									end
								end
								if (sx) and (sy) then
									if (distance<=2) then
										sy = math.ceil( sy + ( 2 - distance ) * 20 )
									end
									sy = sy + 10
									if (sx) and (sy) then
										local offset = 45 / distance
									end								
									if (distance<=2) then
										sy = math.ceil( sy - ( 2 - distance ) * 40 )
									end
									sy = sy - 20
									if (sx) and (sy) and oldsy then
										if (distance < 1) then distance = 1 end
										if (distance > 2) then distance = 2 end
										local offset = 75 / distance
										local scale = 0.6 / distance
										local font = "bankgothic"
										local id = getElementData(player, "playerid")
										if badge then
											sy = sy - dxGetFontHeight(scale, font) * scale + 2.5
										end
										local r, g, b = getPlayerNametagColor (player)
										name = name .. " (" .. tostring(id) .. ")"
										yo = getElementData(player, "yo")
										if yo == "nil" then
											yo2 = "((Sin /yo asignado.))"
										else
											yo2 = yo
										end
										dxDrawText(tostring(yo2), sx-offset+2, sy+2, (sx-offset)+130 / distance, sy+70 / distance, tocolor(0, 0, 0, 220), scale*1.8, "clear-normal", "center", "center", false, false, false)
										dxDrawText(tostring(yo2), sx-offset, sy, (sx-offset)+130 / distance, sy+70 / distance, tocolor( 127, 255, 127 , 220), scale*1.8, "clear-normal", "center", "center", false, false, false)
										dxDrawText(name, sx-offset+2, sy+2, (sx-offset)+130 / distance, sy+20 / distance, tocolor(0, 0, 0, 220), scale, font, "center", "center", false, false, false)
										dxDrawText(name, sx-offset, sy, (sx-offset)+130 / distance, sy+20 / distance, tocolor(r, g, b, 220), scale, font, "center", "center", false, false, false)
									end
								end
							end
						end
					end
				end
			end
		end
		for key, player in ipairs(getElementsByType("ped")) do
			if (isElement(player) and  (player~=localPlayer) and (isElementOnScreen(player)))then
				local lx, ly, lz = getElementPosition(localPlayer)
				local rx, ry, rz = getElementPosition(player)
				local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
				local limitdistance = 20
				local reconx = getElementData(localPlayer, "spec")
				playerhp[player] = getElementHealth(player)
				if (lasthp[player] == nil) then
					lasthp[player] = playerhp[player]
				end
				playerarmor[player] = getPedArmor(player)
				if (lastarmor[player] == nil) then
					lastarmor[player] = playerarmor[player]
				end
				if (aimsAt(player) or distance<limitdistance or reconx) then
					if not getElementData(player, "spec") == true and not getElementData(player, "freecam:state") then
						local lx, ly, lz = getCameraMatrix()
						local vehicle = getPedOccupiedVehicle(player) or nil
						local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, vehicle)
						if not (collision) or aimsSniper() or (reconx) then
							local x, y, z = getElementPosition(player)
							if not (isPedDucked(player)) then
								z = z + 1
							else
								z = z + 0.5
							end
							local sx, sy = getScreenFromWorldPosition(x, y, z+0.1, 100, false)
							local oldsy = nil
							if (sx) and (sy) then									
								distance = distance / 5
								if (reconx or aimsAt(player)) then distance = 1
								elseif (distance<1) then distance = 1
								elseif (distance>2) then distance = 2 end
								local offset = 45 / distance
								oldsy = sy 
								if (distance<=2) then
									sy = math.ceil( sy + ( 2 - distance ) * 20 )
								end
								sy = sy + 10
								if (distance<=2) then
									sy = math.ceil( sy - ( 2 - distance ) * 40 )
								end
								sy = sy - 20	
								if (sx) and (sy) then
									if (distance < 1) then distance = 1 end
									if (distance > 2) then distance = 2 end
									local offset = 75 / distance
									local scale = 0.6 / distance
									local font = "bankgothic"
									local r = 255
									local g = 255
									local b = 255--getPlayerNametagColor(player)
									local offset = 65 / distance
									local id = getElementData(player, "npcid") or 999
									if (oldsy) and (id) then
										if (id<100 and id>9) then -- 2 digits
											dxDrawRectangle(sx-offset-15, oldsy, 30 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
											dxDrawText(tostring(id), sx-offset-22.5, oldsy, (sx-offset)+26 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), scale, font, "center", "center", false, false, false)
										elseif (id<=9) then -- 1 digit
											dxDrawRectangle(sx-offset-5, oldsy, 20 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
											dxDrawText(tostring(id), sx-offset-12.5, oldsy, (sx-offset)+26 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), scale, font, "center", "center", false, false, false)
										elseif (id>=100) then -- 3 digits
											if (id == 999) then
												id = "NPC"
												dxDrawRectangle(sx-offset-25, oldsy, 40 / distance, 20 / distance, tocolor(0, 0, 0, 100), false)
												dxDrawText(tostring(id), sx-offset-32.5, oldsy, (sx-offset)+26 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), scale, font, "center", "center", false, false, false)
											end
										end
										local name = getElementData(player, "npcname") or "NPC"
										if (oldsy) and (name) then
											dxDrawText(tostring(name), sx-offset+115, oldsy+25, (sx-offset)+26 / distance, sy+20 / distance, tocolor(255, 255, 255, 220), scale, font, "center", "center", false, false, false)
										end
									end
								end
							end
						end	
					end
				end
			end
		end
	end
end
addEventHandler('onClientRender', getRootElement(), renderNametags)
--
addEventHandler( 'onClientResourceStart', getResourceRootElement( ),
	function( )
		for _, player in pairs( getElementsByType( 'player' ) ) do
			if player ~= localPlayer then
				setPlayerNametagShowing( player, false )
				if isElementStreamedIn( player ) then
					nametags[ player ] = false
				end
			end
		end
	end
)

addEventHandler( 'onClientResourceStop', getResourceRootElement( ),
	function( )
		for player in pairs( nametags ) do
			setPlayerNametagShowing( player, true )
			nametags[ player ] = nil
		end
	end
)

addEventHandler ( 'onClientPlayerJoin', root,
	function( )
		setPlayerNametagShowing( source, false )
	end
)

addEventHandler ( 'onClientElementStreamIn', root,
	function( )
		if source ~= localPlayer and getElementType( source ) == "player" then
			nametags[ source ] = false
			triggerServerEvent( "nametags:chatbubble", source )
		end
	end
)

addEventHandler ( 'onClientElementStreamOut', root,
	function( )
		if nametags[ source ] then
			nametags[ source ] = nil
		end
	end
)

addEventHandler ( 'onClientPlayerQuit', root,
	function( )
		if nametags[ source ] then
			nametags[ source ] = nil
		end
	end
)