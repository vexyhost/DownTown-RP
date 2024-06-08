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

local avisoExplosion = { }

function hayMedicos()
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 2) then
			return true
		end
	end
end

function avisarMedicos(herido) 
	if getElementDimension(herido) == 0 then
		local x, y, z = getElementPosition(herido)
		exports.factions:createFactionBlip2(x, y, z, 2)
	else
		local x, y, z = exports.interiors:getPos(getElementDimension(herido))
		exports.factions:createFactionBlip2(x, y, z, 2)
	end
	for k, v in ipairs(getElementsByType("player")) do
		if exports.factions:isPlayerInFaction(v, 2) then
		outputChatBox( "SMS de un ciudadano: Hospital: Emergencia - Situacion: Hay un hombre herido, corre riesgo de muerte.", v, 130, 255, 130 )
		triggerClientEvent( v, "gui:hint", v, "Hospital: Emergencia", "Situacion: Hay un hombre herido, corre riesgo de muerte." )
		end
	end
end

local sinMSJ =
    {
		[ 9 ] = true,
        [ 16 ] = true,
		[ 17 ] = true,
		[ 18 ] = true,
		[ 39 ] = true,
		[ 41 ] = true,
		[ 42 ] = true,
		[ 37 ] = true,
		[ 51 ] = true,
		[ 53 ] = true,
    }
	
local isMuertoQuemado = {}

function sufrirAtaque (atacante, arma, parte, muerto, staff)
	if getElementModel(source) == 279 and getWeaponNameFromID(arma) == "Drowned" then return end
	if isMuertoQuemado[source] then return end
	local duty = exports.players:getOption(source, "staffduty")
	if atacante and (duty == false or not duty) then
		if getElementData(atacante, "tjail") and getElementData(atacante, "tjail") >= 1 and getElementData(atacante, "tjail") <= 80 then exports.jail:serverJail(atacante, tonumber(getElementData(atacante, "tjail")+5), "DM en Jail") return end
		local tipo = getElementType(atacante)
		if tipo == "player" then
			if not staff then
				setElementData(source, "herida"..tostring(parte), true)
			end
			if arma == 0 then
				if muerto == true then
					if not staff then
						outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado a puño.", source, 177, 177, 177)
						outputChatBox("Has matado a golpes a "..getPlayerName(source):gsub("_", " ")..".", atacante, 177, 177, 177)
						outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
					end
					if isPedInVehicle(source) then removePedFromVehicle(source) end
					if isPedDead(source) then
						local x, y, z = getElementPosition(source)
						spawnPlayer( source, x, y, z, 0, getElementModel( source ), 0, 0 )
						fadeCamera( source, true )
						setCameraTarget( source, source )
					end
					setPedAnimation(source, "crack", "crckidle2", -1, true, false, false)
					outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", source, 255, 0, 0)
					outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", source, 255, 0, 0)
					setElementHealth(source, 1)
					setElementData(source, "muerto", true)
					--triggerClientEvent(source, "onClientMuerto", source)
				else
					if not staff then
						if getElementHealth(source) > 5 then
							setElementHealth(source, getElementHealth(source)-5)
							outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado a puño.", source, 177, 177, 177)
							outputChatBox("Has golpeado a "..getPlayerName(source):gsub("_", " ")..".", atacante, 177, 177, 177)
						else -- El jugador ha muerto
							outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado a puño.", source, 177, 177, 177)
							outputChatBox("Has matado a golpes a "..getPlayerName(source):gsub("_", " ")..".", atacante, 177, 177, 177)
							outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
							setPedAnimation(source, "crack", "crckidle2", -1, true, false, false)
							outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", source, 255, 0, 0)
							outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", source, 255, 0, 0)
							setElementHealth(source, 1)
							setElementData(source, "muerto", true)
							--triggerClientEvent(source, "onClientMuerto", source)
						end
					end 
				end
			elseif arma >= 1 then
				if muerto == true then
					if not staff then
						outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
						outputChatBox("Has matado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
						outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
					end
					if isPedInVehicle(source) then removePedFromVehicle(source) end
					if isPedDead(source) then
						local x, y, z = getElementPosition(source)
						spawnPlayer( source, x, y, z, 0, getElementModel( source ), 0, 0 )
						fadeCamera( source, true )
						setCameraTarget( source, source )
					end
					setPedAnimation(source, "crack", "crckidle2", -1, true, false, false)
					outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", source, 255, 0, 0)
					outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", source, 255, 0, 0)
					setElementHealth(source, 1)
					setElementData(source, "muerto", true)
					--triggerClientEvent(source, "onClientMuerto", source)
				else
					if not staff then
						if arma == 24 and getElementData(atacante, "tazerOn") then
							outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha tazeado con su Deagle.", source, 177, 177, 177)
							outputChatBox("Has tazeado a "..getPlayerName(source):gsub("_", " ").." con tu Deagle.", atacante, 177, 177, 177)
							triggerEvent("onPlayerTazed", source, atacante, 24, parte)
						elseif arma == 25 and getElementData(atacante, "gomaOn") then
							outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado con un cartucho de goma.", source, 177, 177, 177)
							outputChatBox("Has atacado a "..getPlayerName(source):gsub("_", " ").." con un cartucho de goma.", atacante, 177, 177, 177)
							triggerEvent("onPlayerTazed", source, atacante, 25, parte)
						else
							hpq = 0
							if arma == 1 then
								hpq = 5								
							elseif arma == 4 or arma == 8 or arma == 30 or arma == 31 then
								hpq = 20
							elseif arma == 2 or arma == 3 or arma == 5 or arma == 6 or arma == 7 then
								hpq = 10
							elseif arma == 22 or arma == 26 then
								hpq = 25
							elseif arma == 23 or arma == 27 or arma == 33 then
								hpq = 30
							elseif arma == 24 then
								hpq = 45
							elseif arma == 25 then
								hpq = 55
							elseif arma == 28 or arma == 29 or arma == 32 then
								hpq = 10
							elseif arma == 16 then
								hpq = 60
							elseif arma == 34 then
								hpq = 70
							else
								hpq = 0
							end
							if getPedArmor(source) > 0 and tonumber(parte) == 3 then -- Tiene chaleco y va al torso.
								if getPedArmor(source) >= hpq then -- Con el chaleco tiene bastante.
									setPedArmor(source, tonumber(getPedArmor(source)-hpq))
									if not sinMSJ [arma] then
										outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
										outputChatBox("Has atacado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
									end
								else -- Pues calculamos la diferencia, y lo que le falte se lo quitamos de vida.
									dif = hpq-getPedArmor(source)
									setPedArmor(source, 0)
									if dif < tonumber(getElementHealth(source)) then 
										setElementHealth(source, tonumber(getElementHealth(source)-dif))
										if not sinMSJ [arma] then
											outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
											outputChatBox("Has atacado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
										end
									else -- Ha muerto
										outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
										outputChatBox("Has matado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
										outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
										setPedAnimation(source, "crack", "crckidle2", -1, true, false, false)
										outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", source, 255, 0, 0)
										outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", source, 255, 0, 0)
										setElementHealth(source, 1)
										setElementData(source, "muerto", true)
										--triggerClientEvent(source, "onClientMuerto", source)
									end
								end
							elseif hpq < tonumber(getElementHealth(source)) then 
								setElementHealth(source, tonumber(getElementHealth(source)-hpq))
								if not sinMSJ [arma] then
									outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha atacado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
									outputChatBox("Has atacado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
								end
							else -- Ha muerto
								outputChatBox("El jugador "..getPlayerName(atacante):gsub("_", " ").." te ha matado con un/una "..getWeaponNameFromID(arma)..".", source, 177, 177, 177)
								outputChatBox("Has matado a "..getPlayerName(source):gsub("_", " ").." con un/una "..getWeaponNameFromID(arma)..".", atacante, 177, 177, 177)
								outputChatBox("Usa /llevarse [jugador] para llevartelo (DEBES DE ROLEARLO)", atacante, 255, 255, 0)
								setPedAnimation(source, "crack", "crckidle2", -1, true, false, false)
								outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", source, 255, 0, 0)
								outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", source, 255, 0, 0)
								setElementHealth(source, 1)
								setElementData(source, "muerto", true)
								--triggerClientEvent(source, "onClientMuerto", source)
							end
						end
					end
				end
			end
		elseif tipo == "vehicle" and atacante and getVehicleController(atacante) then
			outputChatBox("El jugador " ..getPlayerName(getVehicleController(atacante)):gsub("_", " ").." te ha atropellado.", source, 177, 177, 177)
			outputChatBox("Has atropellado al jugador "..getPlayerName(source):gsub("_", " ")..".", getVehicleController(atacante), 177, 177, 177)
		end
	else
		if not duty or duty == false then
			if muerto == true then
				if isPedDead(source) then
					local x, y, z = getElementPosition(source)
					spawnPlayer( source, x, y, z, 0, getElementModel( source ), 0, 0 )
					fadeCamera( source, true )
					setCameraTarget( source, source )
				end
				setPedAnimation(source, "crack", "crckidle2", -1, true, false, false)
				outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", source, 255, 0, 0)
				outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", source, 255, 0, 0)
				setElementHealth(source, 1)
				setElementData(source, "muerto", true)
				--triggerClientEvent(source, "onClientMuerto", source)
			else
				outputChatBox("Te has hecho daño tú mismo.", source, 177, 177, 177)
				if muerto == true then
					setPedAnimation(source, "crack", "crckidle2", -1, true, false, false)
					outputChatBox("Estás GRAVEMENTE herido o MUERTO. Debes de rolear heridas.", source, 255, 0, 0)
					outputChatBox("Puedes usar /avisarmd si según el rol alguien puede avisar a los médicos.", source, 255, 0, 0)
					setElementHealth(source, 1)
					setElementData(source, "muerto", true)
					--triggerClientEvent(source, "onClientMuerto", source)
				end
			end
		end
	end
	if duty and atacante and not getElementData(atacante, "account:gmduty") == true and not sinMSJ [arma] then
		outputChatBox("Deja de atacar a un staff de servicio.", atacante, 255, 0, 0)
	end
	if arma and getWeaponNameFromID(arma) == "Explosion" and atacante then
		if not avisoExplosion[atacante] then
			avisoExplosion[atacante] = true
			outputChatBox("Por la zona del jugador "..getPlayerName(atacante):gsub("_", " ").. " ha habido una explosión.", getRootElement(), 255, 255, 0)
			setTimer(function() avisoExplosion[atacante] = nil end, 10000, 1)
		end
	end
end
addEvent("onSufrirAtaque", true)
addEventHandler("onSufrirAtaque", getRootElement(), sufrirAtaque)

function forzarRolHeridas()
	if tonumber(getElementHealth(source)) <= 1 then
		sufrirAtaque(source, 0, 60, true, true)
	end
end
addEventHandler("onCharacterLogin", getRootElement(), forzarRolHeridas)

function avisarMD (player)
	if player and getElementData(player, "muerto") == true then
		if hayMedicos() then
			if getElementData(player, "MDavisado") == true then
				outputChatBox("¡Ten paciencia! Sólo puedes dar el aviso a MD cada 60 segundos.", player, 255, 0, 0)
				return
			end
			avisarMedicos(player)
			outputChatBox("Se ha avisado a los médicos por entorno. Ten paciencia.", player, 255, 255, 0)
			setElementData(player, "MDavisado", true)
			setTimer(removeElementData, 60000, 1, player, "MDavisado")
		else
			if not getElementData(player, "reduccNOMD") or getElementData(player, "reduccNOMD") ~= 2 then
				triggerClientEvent(player, "onClientMuerto", player)
				outputChatBox("No hay médicos disponibles. Se ha reducido la espera a 3 minutos.", player, 255, 0, 0)
				setElementData(player, "reduccNOMD", 1)
			end
		end
	end
end
addCommandHandler("avisarmd", avisarMD)

addEvent( "onPlayerRespawn", true )
addEventHandler( "onPlayerRespawn", root,
	function( )
		if source == client then
			-- we only want players who're actually dead and logged in
			if exports.players:isLoggedIn( source ) then
				-- check if we can already respawn
				if source == client then
					-- hide the screen
					fadeCamera( source, false, 1 )				
					-- spawn him at the hospital
					for i = 3, 9 do
						removeElementData(source, "herida"..tostring(i))
						i = i+1
					end
					exports.medico:anularLlevarse(source)
					removeElementData(source, "muerto")
					removeElementData(source, "accidente")
					removeElementData(source, "reduccNOMD")
					exports.items:guardarArmas(source, true)
					local x, y, z = getElementPosition(source)
					setElementData(source, "mPosX", x)
					setElementData(source, "mPosY", y)
					setElementData(source, "mPosZ", z)
					setElementData(source, "mDim", getElementDimension(source))
					setElementData(source, "mInt", getElementInterior(source))
					setTimer(
						function( source )
							if isElement( source ) and exports.players:isLoggedIn( source ) then
								spawnPlayer( source, 1245.86, 334.74, 19.55, 336.32, getElementModel( source ), 0, 0 )
								fadeCamera( source, true )
								setCameraTarget( source, source )
								setCameraInterior( source, 0 )
								outputChatBox("Por favor, rolea por entorno la atención y el traslado al hospital.", source, 255, 255, 255)
								outputChatBox("Además, ten en cuenta si ha sido un PK, un CK, etcétera.", source, 255, 0, 0)
								outputChatBox("Tienes 10 segundos para usar /volver y volver al sitio al que estabas muerto.", source, 255, 0, 0)
							end
						end,
						1200,
						1,
						source
					)
					setTimer(function(source)
						removeElementData(source, "mPosX")
						removeElementData(source, "mPosY")
						removeElementData(source, "mPosZ")
						removeElementData(source, "mDim")
						removeElementData(source, "mInt")
						end, 10000, 1, source)
				end
			end
		end
	end
)

function volverAnterior(player)
	if player and exports.players:isLoggedIn(player) and getElementData(player, "mPosX") then
		local x = getElementData(player, "mPosX")
		local y = getElementData(player, "mPosY")
		local z = getElementData(player, "mPosZ")
		local dim = getElementData(player, "mDim")
		local int = getElementData(player, "mInt")
		setElementPosition(player, x, y, z)
		setElementDimension(player, dim)
		setElementInterior(player, int)
		setElementHealth(player, 1)
		setElementData(player, "muerto", true)
		outputChatBox("Has vuelto a la zona donde estabas, por rol estás muerto o gravemente herido.", player, 255, 0, 0)
	end
end
addCommandHandler("volver", volverAnterior)