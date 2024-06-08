--[[ LISTADO REVISIONES

CÓDIGO 1 CAMBIO DE ACEITE 10.000 KM 4 PIEZAS = 200 dólares
CÓDIGO 2 CAMBIO DE NEUMÁTICOS 60.000 KM 8 PIEZAS = 400 dólares
CÓDIGO 3 CAMBIO DE FILTRO DE ACEITE 10.000 KM 4 PIEZAS = 200 dólares
CÓDIGO 4 CAMBIO DE FILTRO DE AIRE 20.000 KM 4 PIEZAS = 200 dólares
CÓDIGO 5 CAMBIO DE FILTRO DE COMBUSTIBLE 20.000 KM 4 PIEZAS = 200 dólares
CÓDIGO 6 CAMBIO DE PASTILLAS DE FRENO 50.000 KM 6 PIEZAS = 300 dólares
CÓDIGO 7 CAMBIO DE DISCOS DE FRENO 100.000 KM 6 PIEZAS = 300 dólares
CÓDIGO 8 CAMBIO DE AMORTIGUADORES 70.000 KM 8 PIEZAS = 400 dólares
CÓDIGO 9 CAMBIO DE DISTRIBUCIÓN 90.000 KM 12 PIEZAS = 600 dólares

]]

local vehiculosExcluidos = {
	[478] = true,
	[574] = true,
	[436] = true,
	[453] = true,
	[448] = true,
}

local revisionesKM = {
	[1] = 10000,
	[2] = 60000,
	[3] = 10000,
	[4] = 20000,
	[5] = 20000,
	[6] = 50000,
	[7] = 100000,
	[8] = 70000,
	[9] = 90000,
}

local revisionesNombre = {
	[1] = "Cambio de aceite",
	[2] = "Cambio de neumáticos",
	[3] = "Cambio de filtro de aceite",
	[4] = "Cambio de filtro de aire",
	[5] = "Cambio de filtro de combustible",
	[6] = "Cambio de pastillas de freno",
	[7] = "Cambio de discos de freno",
	[8] = "Cambio de amortiguadores",
	[9] = "Cambio de distribución",
}

function isRevisionPendiente(vehicleID, averiaID)
	if vehicleID and averiaID then
		local vehicle = exports.vehicles:getVehicle(tonumber(vehicleID))
		if vehicle then
			local sql = exports.sql:query_assoc_single("SELECT COUNT(*) AS revisiones FROM vehicles_averias WHERE vehicleID = "..vehicleID.." AND operacionID = "..averiaID)
			local kmRev = revisionesKM[averiaID]
			local kmCar = tonumber(getElementData(vehicle, "km"))
			local revisionesEnTeoria = math.floor(kmCar/kmRev)
			if revisionesEnTeoria > tonumber(sql.revisiones) then
				local desfase = 2000 -- Margen de KM antes de que el vehículo no ande
				local kmCarConDesfase = kmCar-desfase
				local revisionesEnTeoriaConDesfase = math.floor(kmCarConDesfase/kmRev)
				if revisionesEnTeoria == revisionesEnTeoriaConDesfase then 
					-- SI se ha pasado del margen de 2000
					return 2
				else
					-- SI está en periodo de ir al taller.
					return 1
				end
			else
				return false
			end
		else
			return false
		end
	end
end

function comprobarRevisionesAlSubir ( thePlayer, seat, jacked )
   if thePlayer and source and seat == 0 then
		local vehicleID = getElementData(source, "idveh")
		local model = getElementModel(source)
		if vehiculosExcluidos[model] then
			removeElementData(source, "averiado")
			removeElementData(source, "chivato")
			return
		end
		for i=1, 9 do
			if (isRevisionPendiente(vehicleID, i) == 1) or (isRevisionPendiente(vehicleID, i) == 2) then
				local tipo = isRevisionPendiente(vehicleID, i)
				if tipo == 1 then 
					outputChatBox("Este vehículo tiene pendiente: "..revisionesNombre[i]..". Acude a un taller.", thePlayer, 255, 0, 0)
					setElementData(source, "chivato", true)
				elseif tipo == 2 then
					outputChatBox("ATENCIÓN: este vehículo está inmovilizado porque no se le hizo: "..revisionesNombre[i]..".", thePlayer, 255, 255, 0)
					setElementData(source, "averiado", true)
					setElementData(source, "chivato", true)
					setVehicleEngineState(source, false)
				end
			end
		end
   end
end
addEventHandler ( "onVehicleEnter", getRootElement(), comprobarRevisionesAlSubir )

