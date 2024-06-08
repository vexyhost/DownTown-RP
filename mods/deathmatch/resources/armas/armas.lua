local servicioventas = true
local packsolicitado = 0 

function getDatosPack(id)
	if id then
		if id == 1 then -- Colt
			return 22, 140, 13500, 5 
		elseif id == 2 then -- Silenciada
			return 23, 140, 19500, 5
		elseif id == 3 then -- Ak-47
			return 30, 1200, 22500, 1
		elseif id == 4 then -- Uzi
			return 28, 600, 35000, 5
		elseif id == 5 then -- TEC-9
			return 32, 600, 40000, 5
		elseif id == 6 then -- County Rifle
			return 33, 50, 17000, 1
		elseif id == 7 then -- Sniper Rifle
			return 34, 50, 30000, 1
		elseif id == 8 then -- Katana
			return 8, 1, 5500, 5
		elseif id == 9 then -- Escopeta recortada
			return 26, 120, 35000, 5
		elseif id == 10 then -- Molotov
			return 18, 1, 15000, 5
		end
	else
		return nil
	end
end


-- Coordenadas del marker { x = 488.23, y = -82.62, z = 998.76, stop = true },
-- INT: 11 DIM 264

local markerTapadera = createMarker(488.3, -83.06, 998.76, "cylinder", 2, 0, 0, 127, 0)
setElementInterior(markerTapadera, 11)
setElementDimension(markerTapadera, 264)

function checkInvitacion(hitElement, matchingDimension)
	if matchingDimension == true then
		if exports.factions:isPlayerInFaction(hitElement, 101) or exports.factions:isPlayerInFaction(hitElement, 102) or exports.factions:isPlayerInFaction(hitElement, 103) then
			-- Si tiene invitación y coincide la dimensión, entonces debería de tener acceso.
			-- ¿Tiene horas suficientes o está en una facción?
			--local sql = exports.sql:query_assoc_single("SELECT horas FROM characters WHERE characterID = "..exports.players:getCharacterID(hitElement))
			--if sql then
				--if tonumber(sql.horas) >= 100 or exports.factions:isPlayerInFaction(hitElement, 101) or exports.factions:isPlayerInFaction(hitElement, 102) then
					setElementPosition(hitElement, 2282.90, -1140.27, 1050.9)
					setElementInterior(hitElement, 11)
					setElementDimension(hitElement, 264)
					outputChatBox("Bienvenido, disfruta del sistema ;)", hitElement, 0, 255, 0)
					setElementData(hitElement, "dentroArmas", true)
		else
			outputChatBox("Necesitas pertenecer a una facción ilegal oficial.", hitElement, 255, 0, 0)
		end
			--end
		--end
	end
end
addEventHandler("onMarkerHit", markerTapadera, checkInvitacion)

function salidaSecreta(player)
	if player and getElementData(player, "dentroArmas") == true then
		setElementPosition(player, 1264.67, 285.68, 19.55)
		setElementInterior(player, 0)
		setElementDimension(player, 0)
		outputChatBox("¡Hasta pronto!", player, 0, 255, 0)
		removeElementData(player, "dentroArmas")
	end
end
addCommandHandler("salidasec", salidaSecreta)

-- local puntosInvitaciones = {
	-- { x = 1323.41, y = 390.7, z = 19.55 },
	-- { x = 2203.79, y = -139.11, z = 1.1 },
	-- { x = 2422.52, y = 257.98, z = 23.61 },
	-- { x = 2769.09, y = 319.25, z = 2.15 }
-- } 

-- local markerCreado = false
-- function createInvitacionArmas()
	-- local ind = math.random( #puntosInvitaciones )
	-- local myMarker = createMarker(puntosInvitaciones[ind].x, puntosInvitaciones[ind].y, puntosInvitaciones[ind].z, "cylinder", 1.3, 255, 215, 0, 68)
	-- if myMarker then
		-- markerCreado = true
		-- addEventHandler("onMarkerHit", myMarker, encontrarInvitacion)
	-- end
-- end
-- addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), createInvitacionArmas)


-- function encontrarInvitacion(hitElement, matchingDimension)
	-- if hitElement and matchingDimension == true and exports.players:isLoggedIn(hitElement) and markerCreado == true then
		-- markerCreado = false
		-- outputChatBox("Has encontrado una caja con un candado electrónico. Sólo tienes un intento.", hitElement, 0, 255, 0)
		-- outputChatBox("La clave es un número que va del 10 al 29. Si lo adivinas, tendrás tu invitación especial.", hitElement, 0, 255, 0)
		-- outputChatBox("Usa /abrirc [número] para probar suerte. Si reconectas perderás tu oportunidad.", hitElement, 255, 255, 255)
		-- setElementData(hitElement, "cajaEncontrada", true)
		-- destroyElement(source)
		-- setTimer(createInvitacionArmas, 1800000, 1)
	-- end
-- end 

-- function abrirCajaInv (player, cmd, numero)
	-- if player and exports.players:isLoggedIn(player) and getElementData(player, "cajaEncontrada") == true then	
		-- math.randomseed(os.time()+math.random(1,9))
		-- local randomKey = tostring(math.random(1,2))..tostring(math.random(0,9))
		-- if tostring(randomKey) == tostring(numero) then
			-- outputChatBox("¡Enhorabuena! Abres la caja y encuentras una invitación especial v2.", player, 0, 255, 0)
			-- outputChatBox("Ábrela desde tu inventario para obtener más información.", player, 255, 255, 255)
			-- outputChatBox("Te recomendamos que hagas una SS pulsando F12 y la guardes.", player, 2555, 255, 0)
			-- exports.items:give(player, 45, 1004)
		-- else
			-- outputChatBox("¡Ups! No has tenido suerte. Vuelve a intentarlo en otra ocasión.", player, 255, 0, 0)
			-- outputChatBox("Por si te queda la curiosidad, la clave de la caja era "..tostring(randomKey)..".", player, 255, 255, 255)
		-- end
		-- removeElementData(player, "cajaEncontrada")
	-- end
-- end
-- addCommandHandler("abrirc", abrirCajaInv)