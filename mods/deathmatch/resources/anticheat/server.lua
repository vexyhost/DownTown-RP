-- Sistema avanzado anticheat de dinero. DownTown 2019.

function onIniciarSesion()
	if source then
		local characterID = exports.players:getCharacterID(source)
		if characterID then
			local sql_check = exports.sql:query_assoc("SELECT sesionID, estadoSesion FROM dinero_sesiones WHERE (estadoSesion = 1 OR estadoSesion = 2 OR estadoSesion = 4) AND userID = "..tostring(exports.players:getUserID(source)))
			local checker = 0
			local sesionProblem = -1
			for k, v in ipairs(sql_check) do
				if tonumber(v.estadoSesion) == 1 and checker == 0 then
					checker = 1
					sesionProblem = tonumber(v.sesionID)
				elseif tonumber(v.estadoSesion) == 2 then
					checker = 2
					sesionProblem = tonumber(v.sesionID)
				elseif tonumber(v.estadoSesion) == 4 then
					checker = 4
					sesionProblem = tonumber(v.sesionID)
				end
			end
			if checker == 1 then
				outputChatBox("Hemos detectado movimientos extraños en tu cuenta (sesión Nº "..tostring(sesionProblem)..")", source, 255, 255, 0)
				outputChatBox("Te informamos de que puede que te pidamos logs.", source, 0, 255, 0)
				outputChatBox("Para más información, contacta con un administrador o desarrollador.", source, 0, 255, 0)
			elseif checker == 2 then
				kickPlayer(source, "Cuenta bloqueada (sesión Nº "..tostring(sesionProblem).."), acude a foro o CAU para + info.")
				return
			elseif checker == 4 then
				outputChatBox("¡ATENCIÓN! Se ha abierto una investigación en tu cuenta por movimientos extraños.", source, 255, 255, 0)
				outputChatBox("Tienes 7 días para acudir CAU y aportar logs de la sesión Nº "..tostring(sesionProblem)..".", source, 255, 255, 255)
				outputChatBox("El CAU se encuentra en cau.dt-mta.com y si no aportas logs, tu cuenta será BLOQUEADA.", source, 255, 0, 0)
				outputChatBox("Si necesitas ayuda o tienes dudas, acude a un staff IG, al foro, o al CAU.", source, 0, 255, 0)
			end
			local costeLogin = calcularCoste(characterID)
			local sesionID = exports.sql:query_insertid("INSERT INTO `dinero_sesiones` (`characterID`, `userID`, `cantidadLogin`, `timestampLogin`) VALUES ('"..tostring(characterID).."', '"..tostring(exports.players:getUserID(source)).."', '"..tostring(costeLogin).."', CURRENT_TIMESTAMP);")
			if sesionID then
				setElementData(source, "AC_sesionID", tonumber(sesionID))
				setElementData(source, "AC_charID", tonumber(characterID))
			end
		end
		outputChatBox("Sesión Nº ["..tostring(getElementData(source, "AC_sesionID")).."] iniciada.", source, 255, 255, 255)
	end
end
addEventHandler("onCharacterLogin", getRootElement(), onIniciarSesion)
 
function onCerrarSesion()
	local characterID = getElementData(source, "AC_charID")
	local sesionID = getElementData(source, "AC_sesionID")
	if characterID and sesionID then
		local sql2, e = exports.sql:query_assoc_single("SELECT cantidadLogin FROM dinero_sesiones WHERE sesionID = " .. tostring(sesionID))
		if (e) or not sql2 then
			exports.logs:addLogMessage("error-anticheat2", tostring(e).." - sesionID "..tostring(sesionID))
			outputDebugString(tostring(e))
		end
		local costeLogin = tonumber(sql2.cantidadLogin)
		local costeLogout = calcularCoste(characterID)
		local diferencia = tonumber(costeLogout) - tonumber(costeLogin)
		local estado = 0
		if tonumber(diferencia) > 0 then
			if (tonumber(diferencia) >= 3500) and (tonumber(diferencia) < 9999) then
				estado = 1 -- Advertencia sobre pedir info
			elseif (tonumber(diferencia) >= 10000) then
				estado = 2 -- Bloqueo de cuenta por seguridad
			end
			local sql_diff, err = exports.sql:query_assoc_single("SELECT TIME_TO_SEC(TIMEDIFF(CURRENT_TIMESTAMP(),`timestampLogin`)) AS `dtiempo` FROM `dinero_sesiones` WHERE `sesionID` = "..tostring(sesionID))
			if (err) then
				exports.logs:addLogMessage("error-anticheat", tostring(err).." - sesionID "..tostring(sesionID))
				outputDebugString(tostring(err))
			end
			local duracion_sesion = tonumber(tonumber(sql_diff.dtiempo)/3600)
			local ratio = tonumber(diferencia/duracion_sesion)
			if ratio and tonumber(ratio) ~= nil then
				if (tonumber(ratio) >= 8000) and (tonumber(ratio) < 18999) then 
					estado = 4 -- Pedimos logs directamente, no es normal ganar + de 8000 / hora
				elseif ((tonumber(ratio) >= 19000) and (tonumber(diferencia)>2000)) then
					estado = 2 -- Bloqueo de cuenta por seguridad
				elseif (((estado == 1) or (estado == 2) or (estado == 0)) and (tonumber(ratio) < 2500)) then
					estado = 0 -- Habrá ganado mucho dinero pero en mucho tiempo, no requiere investigación.
				end
			else
				exports.logs:addLogMessage("error-anticheat", "ratio error - sesionID "..tostring(sesionID))
			end
		end
		exports.sql:query_free("UPDATE dinero_sesiones SET cantidadLogout = '"..tostring(costeLogout).."' WHERE sesionID = "..tostring(sesionID))
		exports.sql:query_free("UPDATE dinero_sesiones SET estadoSesion = '"..tostring(estado).."' WHERE sesionID = "..tostring(sesionID))
		exports.sql:query_free("UPDATE dinero_sesiones SET timestampLogout = CURRENT_TIMESTAMP() WHERE sesionID = "..tostring(sesionID))
		removeElementData(source, "AC_sesionID")
		if source then
			outputChatBox("Sesión Nº ["..tostring(sesionID).."] cerrada.", source, 255, 255, 255)
		end
	end
end
addEventHandler("onCharacterLogout", getRootElement(), onCerrarSesion)

function calcularCoste(characterID)
	if characterID then
		local coste = 0
		-- Dinero en mano y en banco
		local sql = exports.sql:query_assoc_single("SELECT money, banco FROM characters WHERE characterID = " .. characterID)
		coste = coste + tonumber(sql.money)
		coste = coste + tonumber(sql.banco)
		-- Dinero en propiedades
		local ints = exports.sql:query_assoc("SELECT interiorID, interiorPriceCompra, recaudacion FROM interiors WHERE characterID = " .. characterID)
		for k, v in ipairs(ints) do
			coste = coste + tonumber(v.interiorPriceCompra)
			coste = coste + tonumber(v.recaudacion)
			local cajas_fuertes = exports.sql:query_assoc("SELECT extra FROM muebles WHERE skin = 2332 AND dimension = " .. tostring(v.interiorID))
			for k2, v2 in ipairs(cajas_fuertes) do
				coste = coste + tonumber(v2.extra)
			end
		end
		-- Dinero en vehículos
		local vehs = exports.sql:query_assoc("SELECT vehicleID, model, pinturas, tunning, fasemotor, fasefrenos FROM vehicles WHERE characterID = " .. characterID)
		for k, v in ipairs(vehs) do
			local precioVehOriginal = tonumber(exports.vehicles_auxiliar:getPrecioFromModel(getVehicleNameFromModel(tonumber(v.model))) or 0)
			local faseMotor = 6000
			local faseFrenos = 5000
			local fmotor = tonumber(v.fasemotor)
			local ffrenos = tonumber(v.fasefrenos)
			if fmotor > 0 then
				costeFasesMotor = (fmotor*faseMotor)+((fmotor-1)*faseMotor)
			else
				costeFasesMotor = 0
			end
			if ffrenos > 0 then
				costeFasesFrenos = (ffrenos*faseFrenos)+((ffrenos-1)*faseFrenos)
			else
				costeFasesFrenos = 0
			end
			local costeDosFases = costeFasesMotor+costeFasesFrenos
			local precioVeh = costeDosFases+precioVehOriginal
			coste = coste + tonumber(precioVeh)
			-- Coste tunning
			local tunning = split(tostring(v.tunning), ",")
			if tostring(tunning) ~= "" then
				for k2, v2 in ipairs(tunning) do
					-- 4 piezas por cada pieza de tunning, * 50 cada pieza.
					coste = coste + 200
				end
			end
			if (tonumber(v.pinturas) < 3) then
				-- Vinilo instalado, cuesta 10.000 mínimo según coste piezas.
				coste = coste + 10000
			end
		end
		-- Reajuste sobre préstamos.
		-- El tema es, cuando alguien pide un préstamo se le da un dinero que no tiene.
		-- Por tanto se generan costes y ganancias que en verdad no son reales.
		local prestamos = exports.sql:query_assoc("SELECT cantidad, pagado FROM prestamos WHERE characterID = "..characterID)
		for k, v in ipairs(prestamos) do
			coste = coste-tonumber(v.cantidad)
			coste = coste+tonumber(v.pagado)
		end
		return (tonumber(coste))
	end
end