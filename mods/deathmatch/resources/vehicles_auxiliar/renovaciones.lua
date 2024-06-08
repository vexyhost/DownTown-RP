-- ATENCIÓN SISTEMA INACTIVO, NO ESTÁ INCLUIDO EN EL META.XML

function pasarDia()
	local time = getRealTime()
	local ano = (time.year+1900)
	local dia = (time.yearday)
	local nombreArchivo = tostring(ano).."-"..tostring(dia)
	if fileExists("renovaciones/"..nombreArchivo) then
		return false
	else
		local newFile = fileCreate("renovaciones/"..nombreArchivo)
		if (newFile) then
			fileClose(newFile)
			return true
		end
	end
end

function reguladorRenovaciones()
	if pasarDia() then
		exports.sql:query_free("UPDATE vehicles SET dias = dias - 1")
		local sql = exports.sql:query_assoc("SELECT vehicleID FROM vehicles WHERE dias < 0 AND characterID > 0")
		for k, v in ipairs(sql) do
			-- Solicitamos que desaparezca el vehículo IG, si es que está.
			local vehicle = exports.vehicles:getVehicle(tonumber(v.vehicleID))
			if vehicle then
				destroyElement(vehicle)
			end
			exports.sql:query_free("UPDATE vehicles SET inactivo = 1 WHERE vehicleID = "..tonumber(v.vehicleID))
		end
	end
end
--addCommandHandler("reno", reguladorRenovaciones)
setTimer(reguladorRenovaciones, 3000, 1)
setTimer(reguladorRenovaciones, 28800000, 0)

function renovarVehiculo(vehicleID, modelo)
	if vehicleID and modelo then
		local sql = exports.sql:query_assoc_single("SELECT dias FROM vehicles WHERE vehicleID = "..tostring(vehicleID))
		if tonumber(sql.dias) > 15 then 
			outputChatBox("Sólo puedes renovar un vehículo cuando tenga igual o menos de 15 días.", source, 255, 0, 0)
			return
		end
		local costeRenovacion = exports.vehicles_auxiliar:getCosteRenovacionFromModel(modelo)
		if costeRenovacion then
			if exports.players:takeMoney(source, tonumber(costeRenovacion)) then
				local time = getRealTime()
				local ano = (time.year+1900)
				local dia = (time.yearday)
				local nombreArchivo = tostring(ano).."-"..tostring(dia)
				outputChatBox("["..tostring(nombreArchivo).."] Has renovado correctamente tu "..tostring(modelo).."("..tostring(vehicleID)..") durante 20 días.", source, 0, 255, 0)
				exports.sql:query_free("UPDATE vehicles SET dias = 20 WHERE vehicleID = "..tostring(vehicleID))
				exports.prestamos:pagarPrestamoSinQuitarDinero(source, 1, tonumber(costeRenovacion))
				exports.factions:giveFactionPresupuesto(5, tonumber(costeRenovacion))
			else
				outputChatBox("¡No tienes encima el coste de la renovación! ("..tostring(costeRenovacion).."$)", source, 255, 0, 0)
			end
		else
			outputChatBox("No se ha podido calcular el coste de la renovación. Acude a un staff.", source, 255, 0, 0)
		end
	end
end
addEvent("onRenovarVehiculo", true)
addEventHandler("onRenovarVehiculo", getRootElement(), renovarVehiculo)