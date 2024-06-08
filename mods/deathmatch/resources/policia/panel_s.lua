function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end


function vercamaritas(player)
	if exports.factions:isPlayerInFaction(player, 1) then
		if not isElementInRange(player,  2019.6669921875, 1962.9921875, -12.739062309265, 2) then outputChatBox("(( No estás en el ordenador policial ))", player, 255, 0, 0) return end
		setElementData(player,"concamaraspd",true)
		triggerClientEvent(player, "VerCamarasPolicia", player)
	else
		outputChatBox("(( No eres Policia ))", player, 255, 0, 0)
	end
end
addCommandHandler("cseguridad", vercamaritas)

function abrirPanel(player)
	if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 6) then
		if not getElementData(player, "GUIPol") == true then
			local sql1 = exports.sql:query_assoc("SELECT * FROM ordenes")
			setElementData(player, "nogui", true)
			toggleAllControls(player, false)
			triggerClientEvent("onVentanaPolicial", player, sql1)
		end
	else
		outputChatBox("No eres agente de policía ni formas parte de Justicia.", player, 255, 0, 0)
	end
end
addCommandHandler("panel", abrirPanel)
addEvent("onActualizarPanel", true)
addEventHandler("onActualizarPanel", getRootElement(), abrirPanel)

function solicitarDatos(code)
	local consulta = 0
	if tonumber(code) == 1 then
		consulta = exports.sql:query_assoc("SELECT * FROM ordenes")
	elseif tonumber(code) == 2 then
		consulta = exports.sql:query_assoc("SELECT * FROM historiales")
	elseif tonumber(code) == 3 then
		consulta = exports.sql:query_assoc("SELECT * FROM deposito")
	elseif tonumber(code) == 4 then
		consulta = exports.sql:query_assoc("SELECT * FROM robos WHERE tipo = 1")
		for k, v in ipairs(consulta) do
			local sqlv = exports.sql:query_assoc_single("SELECT vehicleID FROM vehicles WHERE inactivo = 1 AND vehicleID = "..tostring(v.objetoID))
			if sqlv then
				table.remove(consulta, k)
			end
		end
	elseif tonumber(code) == 5 then
		consulta = exports.sql:query_assoc("SELECT * FROM multas")
	elseif tonumber(code) == 6 then
		consulta = exports.sql:query_assoc("SELECT * FROM licencias_armas")
		consulta2 = {}
		for k, v in ipairs(consulta) do
			local sql = exports.sql:query_assoc_single("SELECT characterName, characterID FROM characters WHERE characterID = "..tostring(v.cID))
			local sql2 = exports.sql:query_assoc_single("SELECT characterName, characterID FROM characters WHERE characterID = "..tostring(v.cIDJusticia))
			if tonumber(v.cIDJusticiaNull) > 0 then
				local sql3 = exports.sql:query_assoc_single("SELECT characterName, characterID FROM characters WHERE characterID = "..tostring(v.cIDJusticiaNull))
				table.insert(consulta2, tonumber(sql3.characterID), tostring(sql3.characterName))
			end
			table.insert(consulta2, tonumber(sql.characterID), 1 and tostring(sql.characterName) or "null")
			table.insert(consulta2, tonumber(sql2.characterID), 1 and tostring(sql2.characterName) or "null")
		end
	end
	triggerClientEvent(source, "onEnviarDatosPanel", source, tonumber(code), consulta, consulta2)
end
addEvent("onSolicitarDatosPanel", true)
addEventHandler("onSolicitarDatosPanel", getRootElement(), solicitarDatos)

--[[function arregloModel()
	local sql = exports.sql:query_assoc("SELECT * FROM robos WHERE tipo = 1")
	for k, v in ipairs(sql) do
		local sql2 = exports.sql:query_assoc_single("SELECT model FROM vehicles WHERE vehicleID = "..tostring(v.objetoID))
		if sql2 then
			exports.sql:query_free("UPDATE robos SET model = "..tostring(sql2.model).." WHERE roboID = "..tostring(v.roboID))
		end
	end
end
addCommandHandler("am", arregloModel)
]]
function solicitarNuevaOrden (nombre, razon)
	if source and nombre and razon then
		local agente = tostring(getPlayerName(source):gsub("_", " "))
		local sql, error = exports.sql:query_insertid("INSERT INTO `ordenes` (`ordenID`, `nombre`, `razon`, `agente`, `estado`, `fecha`) VALUES (NULL, '%s', '%s', '%s', 'Activa', CURRENT_TIMESTAMP);", nombre, razon, agente)
		if error then outputDebugString(error) else outputChatBox("Se ha emitido la orden de búsqueda correctamente.", source, 0, 255, 0) end
	end
end
addEvent("onOrdenBusqueda", true)
addEventHandler("onOrdenBusqueda", getRootElement(), solicitarNuevaOrden)

--[[function solicitarNuevoHA (nombre, dni, residencia, profesion, delitos)
	if source and nombre and dni and residencia and profesion and delitos then
		local agente = tostring(getPlayerName(source):gsub("_", " "))
		local sql, error = exports.sql:query_insertid("INSERT INTO `historiales` (`historialID`, `nombre`, `dni`, `residencia`, `profesion`, `delitos`, `agente`, `fecha`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', '%s', CURRENT_TIMESTAMP);", nombre, dni, residencia, profesion, delitos, agente)
		if error then outputDebugString(error) else outputChatBox("Se ha archivado el historial delictivo correctamente.", source, 0, 255, 0) end
	end
end
addEvent("onHistorialArrestos", true)
addEventHandler("onHistorialArrestos", getRootElement(), solicitarNuevoHA)

function solicitarNuevoDeposito (idv, modelo, color, propietario, razon)
	if source and idv and modelo and color and propietario and razon then
		--local agente = tostring(getPlayerName(source):gsub("_", " "))
		--local sql, error = exports.sql:query_insertid("INSERT INTO `deposito` (`depositoID`, `vehicleID`, `modelo`, `color`, `propietario`, `razon`, `agente`, `fecha`, `estado`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', '%s', CURRENT_TIMESTAMP, 'En deposito');", idv, modelo, color, propietario, razon, agente)
		--if error then outputDebugString(error) else outputChatBox("Se ha añadido el vehículo al depósito correctamente.", source, 0, 255, 0) end
		outputChatBox("Este sistema ha sido desactivado. Disculpe las molestias.", source, 255, 0, 0)
	end
end
addEvent("onHistorialDeposito", true)
addEventHandler("onHistorialDeposito", getRootElement(), solicitarNuevoDeposito)]]

function modificarOrden (estado, razon, ordenID)
	if source and ordenID and estado and razon then
		local agente = tostring(getPlayerName(source):gsub("_", " "))
		local sql, error = exports.sql:query_free("UPDATE `ordenes` SET `razon` = '%s' WHERE `ordenes`.`ordenID` = "..ordenID, razon.."("..agente..")")
		local sql2, error = exports.sql:query_free("UPDATE `ordenes` SET `estado` = '%s' WHERE `ordenes`.`ordenID` = "..ordenID, estado)
		if error then outputDebugString(error) else outputChatBox("Se ha modificado la orden de búsqueda correctamente.", source, 0, 255, 0) end
	end
end
addEvent("onModificarOrdenBusqueda", true)
addEventHandler("onModificarOrdenBusqueda", getRootElement(), modificarOrden)

function eliminarOrden (ordenID)
	if source and ordenID then
		local agente = tostring(getPlayerName(source):gsub("_", " "))
		local estado = "Eliminada"
		local sql, error = exports.sql:query_free("UPDATE `ordenes` SET `estado` = '%s' WHERE `ordenes`.`ordenID` = "..ordenID, estado.."("..agente..")") -- Por seguridad, NO se borrará ninguna orden emitida.
		if error then outputDebugString(error) else outputChatBox("Se ha eliminado la orden de búsqueda correctamente.", source, 0, 255, 0) end
	end
end
addEvent("onEliminarOrden", true)
addEventHandler("onEliminarOrden", getRootElement(), eliminarOrden)

function retirarVehiculo (depositoID, vehicleID)
	if source and depositoID and vehicleID then
		if not exports.factions:isPlayerInFaction(source, 1) then outputChatBox("Solo un agente de policía puede retirar vehículos del deposito.", source, 255, 0, 0) return end
		if not exports.vehicles:reloadVehicle(vehicleID) then
			outputChatBox("El vehículo ID "..tostring(vehicleID).." no existe. Si crees que es un error, acude al CAU.", source, 255, 0, 0)
			return
		end
		local vehiculoExportar = exports.vehicles:getVehicle(tonumber(vehicleID))
		removeElementData(vehiculoExportar, "cepo")
		local agente = tostring(getPlayerName(source):gsub("_", " "))
		local estado = "Retirado"
		local sql, error = exports.sql:query_free("UPDATE `deposito` SET `estado` = '%s' WHERE `depositoID` = "..depositoID, estado.."("..agente..")") -- Por seguridad, NO se borrará ninguna orden emitida.
		if error then outputDebugString(error) else outputChatBox("Se ha retirado el vehículo correctamente.", source, 0, 255, 0) end
		local sql2 = exports.sql:query_assoc_single("SELECT characterID FROM vehicles WHERE vehicleID = "..vehicleID)
		local sql3 = exports.sql:query_assoc_single("SELECT roboID FROM robos WHERE tipo = 1 AND objetoID = "..vehicleID)
		if not sql3 then
			if getElementData(source, "subasta") == true then
				outputChatBox("Vehiculo retirado sin multa, será subastado.", source, 0, 255, 0)
				local sql, error = exports.sql:query_free("UPDATE `deposito` SET `estado` = '%s' WHERE `depositoID` = "..depositoID, "Subastado") -- Por seguridad, NO se borrará ninguna orden emitida.
			else
				exports.policia:addMulta(sql2.characterID, 1000, "Retirada Deposito", 1, "Retirada Deposito (dID "..tostring(depositoID).." - vID "..tostring(vehicleID)..")")
				outputChatBox("Multa de 1000$ puesta al titular automáticamente.", source, 255, 255, 0)
			end
		else
			if getElementData(source, "subasta") == true then
				exports.sql:query_free("DELETE FROM robos WHERE roboID = "..sql3.roboID)
				outputChatBox("Vehiculo retirado sin multa, será subastado (con denuncia previa)", source, 0, 255, 0)
				local sql, error = exports.sql:query_free("UPDATE `deposito` SET `estado` = '%s' WHERE `depositoID` = "..depositoID, "Subastado") -- Por seguridad, NO se borrará ninguna orden emitida.
			else
				exports.sql:query_free("DELETE FROM robos WHERE roboID = "..sql3.roboID)
				outputChatBox("No se ha puesto multa debido a que el vehículo tenía denuncia por robo.", source, 255, 255, 0)
			end
		end
		exports.sql:query_free("UPDATE vehicles SET cepo = 0 WHERE vehicleID = "..vehicleID)
	end
end
addEvent("onRetirarVehiculo", true)
addEventHandler("onRetirarVehiculo", getRootElement(), retirarVehiculo)

--[[
function modificarHA (historialID, residencia, profesion, delitos)
	if source and historialID and residencia and profesion and delitos then
		local agente = tostring(getPlayerName(source):gsub("_", " "))
		local sql2, error = exports.sql:query_free("UPDATE `historiales` SET `residencia` = '%s' WHERE `historialID` = "..historialID, residencia)
		local sql3, error = exports.sql:query_free("UPDATE `historiales` SET `profesion` = '%s' WHERE `historialID` = "..historialID, profesion)
		local sql, error = exports.sql:query_free("UPDATE `historiales` SET `delitos` = '%s' WHERE `historialID` = "..historialID, delitos.."("..agente..")")
		if error then outputDebugString(error) else outputChatBox("Se ha modificado el  historial correctamente.", source, 0, 255, 0) end
	end
end
addEvent("onModificarHA", true)
addEventHandler("onModificarHA", getRootElement(), modificarHA)]]

function burn(p)
   if p then
		if not hasObjectPermissionTo( p, "command.modchat", false ) then outputChatBox("Acceso denegado", p, 255, 0, 0) return end
		outputDebugString("El jugador "..getPlayerName(p):gsub("_", " ").." ha usado el comando /fuego y ha creado fuego.")
		px, py, pz = getElementPosition(p)
		px2, py2, pz2 = px, py, pz
		setTimer(function ()
			for k, v in ipairs(getElementsByType("player")) do
				px = px+math.random(-1, 1)
				py = py+math.random(-1, 1)
				triggerClientEvent(v, "onCreateFireDCRP", v, px, py, pz)
			end
		end, 1500, 240)
   end
end 
addCommandHandler("fuego2", burn)