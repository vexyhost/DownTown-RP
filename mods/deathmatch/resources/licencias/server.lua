
function darlicenciaArmas ( thePlayer, commandName, otherPlayer, weaponID, cost )
if not exports.factions:isPlayerInFaction(thePlayer, 6) then outputChatBox("No perteneces a la facción de Justicia.", thePlayer, 255, 0, 0) return end
	if weaponID and tonumber(weaponID) and cost and tonumber(cost) and tonumber(cost) >= 0 and tonumber(weaponID) <= 46 and tonumber(weaponID) >= 0 then
		if not otherPlayer then outputChatBox("Sintaxis: /"..commandName.." [jugador] [ID arma] [coste]", thePlayer, 255, 255, 255) return end
		local other, name = exports.players:getFromName( thePlayer, otherPlayer )
		local x1, y1, z1 = getElementPosition ( other )
		local x2, y2, z2 = getElementPosition ( thePlayer )
		if ( getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 ) > 5) then outputChatBox("Estás demasiado lejos.", thePlayer, 255, 0, 0) return end
		if exports.players:takeMoney(other, tonumber(cost) ) then
			local licenciaID, error = exports.sql:query_insertid("INSERT INTO `licencias_armas` (`licenciaID`, `cID`, `cIDJusticia`, `cost`, `weapon`, `status`, `time`) VALUES (NULL, '"..tostring(exports.players:getCharacterID(other)).."', '"..tostring(exports.players:getCharacterID(thePlayer)).."', '"..tostring(cost).."', '"..tostring(weaponID).."', '0', CURRENT_TIMESTAMP);")
			if licenciaID then
				outputChatBox("Has autorizado portar el arma tipo "..tostring(getWeaponNameFromID(tonumber(weaponID)).." - "..tostring(weaponID)).." a #FF0000"..getPlayerName(other):gsub("_", " ").."", thePlayer, 0, 255, 0,true)
				outputChatBox("El departamento de justicia (#FF0000"..getPlayerName(thePlayer):gsub("_", " ").."#00FF00) te ha autorizado a llevar armas tipo "..tostring(getWeaponNameFromID(tonumber(weaponID)).." - "..tostring(weaponID)), other, 0, 255, 0,true)
				outputChatBox("Se te ha entregado un arma de la licencia indicada, acude a la Ammunation para obtener munición.", other, 0, 255, 0)
				exports.items:give(other, 29, tostring(weaponID), "Arma "..tostring(weaponID), 1)
				exports.logs:addLogMessage("licenciaarmas", getPlayerName(thePlayer).." ha autorizado la licencia de armas ("..tostring(getWeaponNameFromID(tonumber(weaponID)).." - "..tostring(weaponID))..") a "..getPlayerName(other)..".")
				exports.factions:giveFactionPresupuesto(6, cost)
			else
				outputChatBox("Se ha producido un error grave, el interesado deberá acudir al CAU.", thePlayer, 255, 0, 0)
				outputChatBox("Se ha producido un error grave, acuda al CAU por favor (c-1-"..tostring(cost)..")", other, 255, 0, 0)
			end
			-- local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(other))
			-- if nivel == 3 and not exports.objetivos:isObjetivoCompletado(30, exports.players:getCharacterID(other)) then
				-- exports.objetivos:addObjetivo(30, exports.players:getCharacterID(other), other)
			-- end
		else
			outputChatBox("El interesado no tiene los "..tostring(cost).." dólares necesarios.", thePlayer, 255, 0, 0)
			outputChatBox("No tienes los "..tostring(cost).." dólares necesarios.", other, 255, 0, 0)
		end
	else
		outputChatBox("Sintaxis: /"..commandName.." [jugador] [ID arma] [coste]", thePlayer, 255, 255, 255)
	end	
end
addCommandHandler ( "darlicenciaarmas", darlicenciaArmas )

function quitarLicenciaArmas ( thePlayer, commandName, licenseID )
if not exports.factions:isPlayerInFaction(thePlayer, 6) then outputChatBox("No perteneces a la facción de Justicia.", thePlayer, 255, 0, 0) return end
	if licenseID and tonumber(licenseID) then
		local sql = exports.sql:query_assoc_single("SELECT licenciaID FROM licencias_armas WHERE status = 0 AND licenciaID = "..tostring(licenseID))
		if sql then
			exports.sql:query_free("UPDATE licencias_armas SET status = 1 WHERE licenciaID = "..tostring(licenseID))
			exports.sql:query_free("UPDATE licencias_armas SET cIDJusticiaNull = "..tostring(exports.players:getCharacterID(thePlayer)).. " WHERE licenciaID = "..tostring(licenseID))
			outputChatBox("Has anulado la licencia Nº "..tostring(licenseID).." correctamente.", thePlayer, 255, 0, 0)
		else
			outputChatBox("Licencia no encontrada. Usa /panel. Sintaxis: /"..commandName.." [ID licencia]", thePlayer, 255, 255, 255)
		end
	else
		outputChatBox("Sintaxis: /"..commandName.." [ID licencia]", thePlayer, 255, 255, 255)
	end	
end
addCommandHandler ( "quitarlicenciaarmas", quitarLicenciaArmas )

function giveLicense(license, cost)
	if (license==1) then -- Licencia de coche
		exports.sql:query_free("UPDATE characters SET car_license = '15' WHERE characterID = " .. exports.players:getCharacterID(source))
		outputChatBox("Has aprobado la prueba de conducir, así que ya estás capacitado para conducir.", source, 255, 194, 14)
		setElementData(source, "license.car", 15 )
		removeElementData(source, "player.cinturon")
		exports.objetivos:addObjetivo(1, exports.players:getCharacterID(source), source)
	elseif (license==2) then -- Licencia de camión
		exports.sql:query_free("UPDATE characters SET camion_license = '15' WHERE characterID = " .. exports.players:getCharacterID(source))
		outputChatBox("Has aprobado la prueba de conducir camiones, así que ya estás capacitado para conducirlos.", source, 255, 194, 14)
		setElementData(source, "license.camion", 15 )
	end
	local theVehicle = getPedOccupiedVehicle(source)
	removePedFromVehicle(source)
	respawnVehicle(theVehicle)
	setElementFrozen(theVehicle, true)
	exports.players:takeMoney(source, cost)
end
addEvent("acceptLicense", true)
addEventHandler("acceptLicense", getRootElement(), giveLicense)

function payFee(amount)
	exports.players:takeMoney(source, amount)
end
addEvent("payFee", true)
addEventHandler("payFee", getRootElement(), payFee)

function passTheory(licencia)
	if getElementData(source, "autoPractica") == true then return end
	if tonumber(licencia) == 1 then
		exports.sql:query_free("UPDATE characters SET car_license = '16' WHERE characterID = " .. exports.players:getCharacterID(source))
		setElementData(source, "license.car", 16 )
		setElementData(source, "autoPractica", true)
	elseif tonumber(licencia) == 2 then
		exports.sql:query_free("UPDATE characters SET car_license = '-1' WHERE characterID = " .. exports.players:getCharacterID(source))
		setElementData(source, "license.camion", -1 )
	end
end
addEvent("theoryComplete", true)
addEventHandler("theoryComplete", getRootElement(), passTheory)


function showLicenses(thePlayer, commandName, otherPlayer)
	if exports.players:isLoggedIn( thePlayer ) == true then
		local other, name = exports.players:getFromName( thePlayer, otherPlayer )
		local x, y, z = getElementPosition(thePlayer)
		if not thePlayer or not other then return end
		local tx, ty, tz = getElementPosition(other)
		if getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) >=6 then
			outputChatBox("Estás demasiado lejos de '".. name .."'.", thePlayer, 255, 0, 0)
		else
			outputChatBox("Has enseñado tus licencias a " .. name .. ".", thePlayer, 255, 194, 14)
			outputChatBox(getPlayerName(thePlayer):gsub( "_", " " ) .. " te ha enseñado sus licencias", other, 255, 194, 14)
			exports.chat:me(thePlayer,"enseña sus licencias a "..name.. ".")						
			local carlicense = getElementData(thePlayer, "license.car")	
			local camionlicense = getElementData(thePlayer, "license.camion")							
			if (carlicense==0) then
				cars = "No"
			elseif (carlicense==16) then
				cars = "Teórico aprobado, pero no práctico"
			elseif (carlicense>1) then
				cars = carlicense.." puntos."
			elseif (carlicense==1) then 
				cars = carlicense.." punto."
			end
			camion = "No"
			if (camionlicense==0) then
				camion = "No"
			elseif (camionlicense==-1) then
				camion = "Teórico aprobado, pero no práctico"
			elseif (camionlicense>1) then
				camion = carlicense.." puntos."
			elseif (camionlicense==1) then 
				camion = carlicense.." punto."
			end
			local haveLicenciaArmas = false
			local sql = exports.sql:query_assoc("SELECT * FROM licencias_armas WHERE status = 0 AND cID = "..exports.players:getCharacterID(thePlayer))
			outputChatBox("~-~-~-~- Licencias de " .. getPlayerName(thePlayer):gsub( "_", " " ) .. "  -~-~-~-~", other, 255, 194, 14)
			if sql then
				for k, v in ipairs(sql) do
					outputChatBox("        Licencia de armas: Nº "..tostring(v.licenciaID)..", "..tostring(getWeaponNameFromID(tonumber(v.weapon))).." concedida por Justicia.", other, 255, 194, 14)
					haveLicenciaArmas = true
				end
			end
			if not haveLicenciaArmas then
				outputChatBox("        Licencia de armas: no tiene ninguna licencia de armas en vigor.", other, 255, 194, 14)
			end
			outputChatBox("        Licencia de conducir (coches, camiones y motos): " .. cars, other, 255, 194, 14)
			--outputChatBox("        Licencia de conducir (camiones): " .. camion, other, 255, 194, 14)
		end
	end
end
addCommandHandler("licencias", showLicenses)

function checkDMVCars(player, seat)
	if exports.vehicles:getOwner( source ) == false and getElementModel(source) == 436 then
		if getElementData(player,"license.car") == 16 and getElementData(player, "tryPractico") == true then
			if getElementData(player, "autoPractica") == true then
				fixVehicle(source)
				setElementHealth(source, 1000)
				removeElementData(player, "autoPractica")
			end
			outputChatBox("Usa la tecla  J para arrancar el motor y N para quitar o poner el freno de mano.", player, 255, 255, 255)
			outputChatBox("¡Recuerda usar /cinturon o tecla C para ponerte el cinturón o suspenderás!", player, 255, 255, 255)
		else
			if not getElementData(player, "account:gmduty") == true then
				outputChatBox("(( Este vehículo es sólo para el examen práctico ))", player, 255, 0, 0)
				if getElementData(player,"license.car") == 16 then
					outputChatBox("Acude dentro de la autoescuela para solicitar un nuevo exámen práctico.", player, 255, 255, 255)
				end
				cancelEvent()
			end
		end
	end
end
addEventHandler( "onVehicleStartEnter", getRootElement(), checkDMVCars)

addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			local distance = getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) )
			local minDistance = 5
			if distance < minDistance and not getElementData(player, "vlicencia") == true then
				if getElementData(player, "license.car") and getElementData(player, "license.car") > 2 and getElementData(player, "license.car") ~= 16 then outputChatBox("No hay licencias disponibles para ti.", player, 255, 0, 0) return end
				triggerClientEvent ( player, "onLicense", player )
				setElementData(player, "vlicencia", true)
			end
		end
	end
)


-- El comando de dar licencias de armas a una persona estába obsoleto y no realizaba el guardado , lo he fixeado con nuevas funciones
-- Cobro del dinero , directamente en el cmd y al presupuesto
-- Log registro de quien da las licencias a quien para evitar problemas que ya nos conocemos
-- Fixeado el guardado de la consulta anteriormente no realizaba la consulta.

-- COMANDO PARA LICENCIAR UNA PERSONA CON LICENCIA DE ARMAS


function retirarpuntos ( thePlayer, commandName, otherPlayer, puntos )
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
		if not puntos then outputChatBox("Sintaxis: /"..commandName.." [jugador] [puntos]", thePlayer, 255, 255, 255) return end
		local other, name = exports.players:getFromName( thePlayer, otherPlayer )
		if not other then return end
		local puntosActual = tonumber(getElementData(other, "license.car"))
		outputChatBox("El agente "..getPlayerName(thePlayer):gsub("_", " ").." te ha retirado "..tostring(puntos).." puntos de la licencia de conducir.", other, 255, 0, 0)
		outputChatBox("Has retirado "..tostring(puntos).." puntos de la licencia de conducir a "..name..".", thePlayer, 255, 0, 0)
		if (puntosActual-puntos) > 0 then
			exports.sql:query_free("UPDATE characters SET car_license = '" .. tonumber(puntosActual-tonumber(puntos)) .. "' WHERE characterID = " .. exports.players:getCharacterID(other))
			setElementData(other, "license.car", puntosActual-puntos )
		else
			exports.sql:query_free("UPDATE characters SET car_license = 0 WHERE characterID = " .. exports.players:getCharacterID(other))
			setElementData(other, "license.car", 0 )
			outputChatBox("Has perdido la licencia de conducir debido a que te has quedado sin puntos. Sácala de nuevo.", other, 255, 0, 0)
		end
	else
		outputChatBox("¡No perteneces al cuerpo de policía!", thePlayer, 255, 0, 0)
	end
end
addCommandHandler ( "retirarpuntos", retirarpuntos )
addCommandHandler ( "rp", retirarpuntos )