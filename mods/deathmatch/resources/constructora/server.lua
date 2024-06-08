 
function abrirVentanaConstructora(player)
	if player and exports.factions:isPlayerInFaction(player, 9) then
		if getElementDimension(player) > 0 then
			triggerClientEvent(player, "onAbrirVentanaConstructora", player)
		else
			outputChatBox("Debes de estar en un interior para usar este comando.", player, 255, 0, 0)
		end
	end
end
addCommandHandler("reformar", abrirVentanaConstructora)


function getInfoInterior()
	if source and client and client == source and exports.factions:isPlayerInFaction(source, 9) then
		local int = exports.interiors:getInterior(getElementDimension(source))
		local interior = getElementInterior( int.inside )
		local x, y, z = getElementPosition( int.inside )
		local name, i = exports.interiors:getInteriorIDAt( x, y, z, interior )
		outputChatBox( "-- Datos del Interior (Constructora) --", source, 255, 255, 255 )	
		outputChatBox( "Nombre: " .. int.name, source, 255, 255, 255 )
		outputChatBox( "Espacio: " .. name, source, 255, 255, 255 )
		outputChatBox( "Tipo: " .. int.type, source, 255, 255, 255 )
		if exports.players:getCharacterName(int.characterID) then
			outputChatBox( "Titular: " .. exports.players:getCharacterName(int.characterID), source, 255, 255, 255 )
		end
		outputChatBox( "Precio: " .. int.price, source, 255, 255, 255 )
		if tonumber(int.idasociado) >= 1 then
			outputChatBox( "ID del interior asociado: " .. int.idasociado, source, 255, 255, 255 )
		else
			outputChatBox( "No tiene ningún interior asociado.", source, 255, 255, 255 )
		end
	end
end
addEvent("onRequestInfoInterior", true)
addEventHandler("onRequestInfoInterior", getRootElement(), getInfoInterior)

function calcularPrecioInterior(interiorID)
	if interiorID and tonumber(interiorID) then
		local cantidad = 0
		-- Primero comprobamos si tiene préstamo en vigor.
		local sql = exports.sql:query_assoc_single("SELECT prestamoID, pagado FROM prestamos WHERE tipo = 2 AND pagado < cantidad AND objetoID = "..interiorID)
		if sql and sql.prestamoID then 
			cantidad = tonumber(sql.pagado)
		else
			local int = exports.interiors:getInterior(interiorID)
			cantidad = tonumber(int.priceCompra)
		end
		return cantidad
	end
end

function getInteriorType2(interiorID)
	local int = exports.interiors:getInterior(interiorID)
	local interior = getElementInterior( int.inside )
	local x, y, z = getElementPosition( int.inside )
	local name, i = exports.interiors:getInteriorIDAt( x, y, z, interior )
	if string.find(tostring(name), "house") then
		return 1
	elseif string.find(tostring(name), "room") then
		return 2
	elseif string.find(tostring(name), "garage") then
		return 3
	elseif string.find(tostring(name), "local") then
		return 4
	elseif string.find(tostring(name), "office") then
		return 5
	else
		return 0
	end
end

function solicitarGUIReforma()
	if source and client and client == source and exports.factions:isPlayerInFaction(source, 9) then
		-- Obtenemos el ID del interior
		local interiorID = getElementDimension(source)
		-- Consultamos el tipo del interior e informamos al cliente.
		local tipo = getInteriorType2(interiorID)
		local ints_conjunto = exports.interiors:getInteriorPositions()
		local ints_disponibles = {}
		if tipo == 1 then --house
			for i=1, 30 do
				table.insert(ints_disponibles, ints_conjunto["house"..tostring(i)])
			end
		elseif tipo == 2 then --room
			for i=1, 6 do
				table.insert(ints_disponibles, ints_conjunto["room"..tostring(i)])
			end
		elseif tipo == 3 then --garage
			for i=1, 5 do
				table.insert(ints_disponibles, ints_conjunto["garage"..tostring(i)])
			end
		elseif tipo == 4 then --local
			for i=1, 21 do
				table.insert(ints_disponibles, ints_conjunto["local"..tostring(i)])
			end
		elseif tipo == 5 then --office
			for i=1, 2 do
				table.insert(ints_disponibles, ints_conjunto["office"..tostring(i)])
			end
		end
		local precio_int = calcularPrecioInterior(interiorID)
		-- Hacemos un array con la lista de interiores disponibles, su precio, y comprobamos valor actual del interior.
		triggerClientEvent(source, "onAbrirVentanaReforma", source, tipo, ints_disponibles, precio_int)
	end
end
addEvent("onSolicitarGUIReforma", true)
addEventHandler("onSolicitarGUIReforma", getRootElement(), solicitarGUIReforma)

function createHabitacion()
	if source and client and source == client and exports.players:isPlayerInFaction(source, 9) then
		-- Obtenemos el ID del interior
		local interiorID = getElementDimension(source)
		-- Consultamos el tipo del interior (sólo se permiten crear habitaciones en casas.
		local tipo = getInteriorType2(interiorID)
		local ints_conjunto = exports.interiors:getInteriorPositions()
		local ints_disponibles = {}
		if tipo == 1 then --house
			for i=1, 6 do
				table.insert(ints_disponibles, ints_conjunto["room"..tostring(i)])
			end
		else
			outputChatBox("Sólo se pueden crear habitaciones dentro de casas.", source, 255, 0, 0)
		end
		local precio_int = calcularPrecioInterior(interiorID)
		-- Hacemos un array con la lista de interiores disponibles, su precio, y comprobamos valor actual del interior.
		triggerClientEvent(source, "onAbrirVentanaNuevaHab", source, ints_disponibles)
	end
end
addEvent("onSolicitarGUINuevaHab", true)
addEventHandler("onSolicitarGUINuevaHab", getRootElement(), createHabitacion)

function getIntName(tipoInt, IDActualRef)
	nombreInt = ""
	if tipoInt == 1 then
		nombreInt = "Casa "..tostring(IDActualRef)
	elseif tipoInt == 2 then
		nombreInt = "Habitación "..tostring(IDActualRef)
	elseif tipoInt == 3 then
		nombreInt = "Garaje "..tostring(IDActualRef)
	elseif tipoInt == 4 then
		nombreInt = "Local "..tostring(IDActualRef)
	elseif tipoInt == 5 then
		nombreInt = "Oficina "..tostring(IDActualRef)
	end
	return nombreInt
end

function getIntName2(tipoInt, IDActualRef)
	nombreInt = ""
	if tipoInt == 1 then
		nombreInt = "house"..tostring(IDActualRef)
	elseif tipoInt == 2 then
		nombreInt = "room"..tostring(IDActualRef)
	elseif tipoInt == 3 then
		nombreInt = "garage"..tostring(IDActualRef)
	elseif tipoInt == 4 then
		nombreInt = "local"..tostring(IDActualRef)
	elseif tipoInt == 5 then
		nombreInt = "office"..tostring(IDActualRef)
	end
	return nombreInt
end

function getPrecioInt2 (tipoInt2)
	local ints_conjunto = exports.interiors:getInteriorPositions()
	return ints_conjunto[tostring(tipoInt2)].price
end

function requestReforma(interiorID, tipoInt, IDActualRef)
	if source and client and source == client and exports.factions:isPlayerInFaction(source, 9) and interiorID and tipoInt and IDActualRef and getElementDimension(source) == interiorID and getInteriorType2(interiorID) == tipoInt then
		-- Primer filtro de seguridad pasado.
		-- 1. Localizamos el titular del interior, comprobamos que está on y que además está en el interior.
		local sql = exports.sql:query_assoc_single("SELECT characterName FROM characters WHERE characterID = (SELECT characterID FROM interiors WHERE interiorID = "..tostring(interiorID)..")")
		if sql and sql.characterName then
			local nameTitular = sql.characterName:gsub(" ", "_")
			local titular = getPlayerFromName(nameTitular)
			local precioActualInt = calcularPrecioInterior(interiorID)
			local precioNuevoInt = getPrecioInt2(getIntName2(tipoInt, IDActualRef))
			if (titular) then
				if getElementDimension(titular) == interiorID then
					outputChatBox("~~ Presupuesto sobre Reforma (interiorID "..tostring(interiorID)..") ~~", titular, 255, 255, 255)
					outputChatBox("- Nuevo interior: "..tostring(getIntName(tipoInt, IDActualRef))..".", titular, 0, 255, 0)
					outputChatBox("- Tiempo de reforma: "..tostring(math.ceil(precioNuevoInt/4000)).." días.", titular, 0, 255, 0)
					outputChatBox("- Coste del nuevo interior: "..tostring(precioNuevoInt).." $", titular, 255, 255, 255)
					outputChatBox("- Coste descontado por valoración del interior actual: "..tostring(precioActualInt).." $", titular, 255, 255, 255)
					outputChatBox("- Coste de mano de obra: "..tostring(precioNuevoInt*0.2)" $", titular, 255, 255, 255)
					outputChatBox("- Coste TOTAL: "..tostring((precioNuevoInt-precioActualInt)+precioNuevoInt*0.2).." $", titular, 255, 255, 0)
					outputChatBox("Utiliza /confirmar 1 para aceptar la Reforma y pagar el coste total en efectivo.", titular, 255, 255, 0)
					outputChatBox("Utiliza /solprestamo para obtener la posibilidad de pagar el coste total con un préstamo.", titular, 255, 255, 0)
					-- Guardamos todos los datos necesarios en elementData del titular, que será el que ponga el comando /confirmar
				else
					outputChatBox("El titular de este interior no está dentro del interior a reformar. Reforma cancelada.", source, 255, 0, 0)
				end
			else
				outputChatBox("El titular de este interior no está conectado. Reforma cancelada.", source, 255, 0, 0)
			end
		else
			outputChatBox("Este interior no admite una reforma mediante este sistema. Acude al CAU.", source, 255, 0, 0)
		end
	end
end
addEvent("requestReforma", true)
addEventHandler("requestReforma", getRootElement(), requestReforma)