--[[
Copyright (C) 2019  DownTown RolePlay

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

impVeh = {
	[1] = 0,
	[2] = 450,
	[3] = 150,
	[4] = 150,
	[5] = 100,
	[6] = 150,
	[7] = 175,
	[8] = 125,
	[9] = 100,
	[10] = 0, 
	[11] = 300,
	[12] = 350,
}

function darPayday (player)
	local h, m = getTime()
	outputChatBox("#######FAAE20~~#FFFFFFPAY-DAY#FAAE20~~#7AADFF######",player, 122, 173, 255, true)
	bganador = math.random(1, 5)
	g = 0	
	if exports.players:isLoggedIn(player) then
		-- Aumento 1 hora
		exports.sql:query_free("UPDATE characters SET horas = horas + 1 WHERE characterID = "..tostring(exports.players:getCharacterID(player)))
		if exports.factions:takeFactionPresupuesto(5, 150) then
			outputChatBox("-Sueldo del Estado: #00FF00150 dólares", player, 255, 255, 255, true)
			darDinero(player, 150)
			g = g + 150
			exports.sql:query_free("UPDATE ajustes SET valor = valor + "..tostring(150).. " WHERE ajusteID = 3")
		else
			outputChatBox("-Sueldo del Estado: #FF00000 dólares", player, 255, 255, 255, true)
		end
		local tieneFac = 0
		for k2, v2 in ipairs(exports.factions:getPlayerFactions(player)) do
			if tonumber(v2) < 100 then
				local sueldo = exports.factions:getPlayerSueldo(player, tonumber(v2))
				if exports.factions:takeFactionPresupuesto(tonumber(v2), sueldo) then
					if tieneFac == 0 then
						tieneFac = tieneFac + 1
						darDinero(player, sueldo)
						outputChatBox("-Sueldo de "..tostring(exports.factions:getFactionName(v2))..": #00FF00"..tostring(sueldo).." dólares", player, 255, 255, 255, true)
						g = g + sueldo
						local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
						if sueldo >= 400 and nivel == 3 and not exports.objetivos:isObjetivoCompletado(28, exports.players:getCharacterID(player)) then
							exports.objetivos:addObjetivo(28, exports.players:getCharacterID(player), player)
						end
						if sueldo >= 600 and nivel == 4 and not exports.objetivos:isObjetivoCompletado(39, exports.players:getCharacterID(player)) then
							exports.objetivos:addObjetivo(39, exports.players:getCharacterID(player), player)
						end
					else
						if v2 < 11 then
							outputChatBox("Por normativa, SOLO se puede estar en una facción por personaje.", player, 255, 0, 0)
							outputChatBox("Te informamos de que podrás ser sancionado.", player, 255, 0, 0)
							exports.logs:addLogMessage("notificaciones", getPlayerName(player).. " DEBE DE SER EXPULSADO DE SUS F3")
						end
					end
				end
			end
		end
			--[[for k3, v3 in ipairs(exports.interiors:getInteriorsTipo(player, 1)) do
				outputChatBox("-Impuestos de "..tostring(v3.interiorName)..": #FF0000"..tostring(v3.interiorPrice/450).." dólares", player, 255, 255, 255, true)
				quitarDinero(player, v3.interiorPrice/450)
				exports.factions:giveFactionPresupuesto(5, (v3.interiorPrice/450)*0.4)
				exports.factions:giveFactionPresupuesto(10, (v3.interiorPrice/450)*0.6)
				g = g - v3.interiorPrice/450
			end]]
			tieneLocales = 0
		for k6, v6 in ipairs(exports.interiors:getInteriorsTipo(player, 2)) do
			if tieneLocales == 0 then -- LIMITE DE 1 LOCAL POR PERSONAJE
				outputChatBox("-Beneficios de "..tostring(v6.interiorName)..": #00FF00"..tostring(v6.interiorPrice*0.003).." dólares", player, 255, 255, 255, true)
				darDinero(player, v6.interiorPrice*0.003)
				g = g + v6.interiorPrice*0.003
			end
			tieneLocales = tieneLocales + 1
		end
		if tieneLocales > 1 then outputChatBox("Te recordamos que no está permitido tener más de 1 local por PJ.", player, 255, 0, 0) exports.logs:addLogMessage("localespd", getPlayerName(player).. " DEBE DE SER SANCIONADO, HA RECAUDADO DINERO DE " .. tostring(tieneLocales) .. " LOCALES") end
		tieneLocales = 0
		for k7, v7 in ipairs(exports.interiors:getInteriorsTipo(player, 3)) do
			outputChatBox("-Alquiler de "..tostring(v7.interiorName)..": #FF0000"..tostring(v7.interiorPrice).." dólares", player, 255, 255, 255, true)
			quitarDinero(player, v7.interiorPrice)
			g = g - v7.interiorPrice
		end
		local impuestos = 0
		local sql = exports.sql:query_assoc("SELECT vehicleID, model FROM vehicles WHERE characterID = "..tostring(exports.players:getCharacterID(player)))
		for k4, v4 in ipairs(sql) do			
			local clase = exports.vehicles_auxiliar:getClaseFromModel(getVehicleNameFromModel(v4.model))
			local sql2v = exports.sql:query_assoc_single("SELECT prestamoID FROM prestamos WHERE pagado < cantidad AND tipo = 1 AND objetoID = "..v4.vehicleID)
			if not clase and not sql2v then
				impuestos = impuestos + 100
			elseif not sql2v then
				impuestos = impuestos + (impVeh[clase])
			end
			sql2v = nil
		end
		if impuestos ~= 0 then 
			outputChatBox("-Impuestos por vehículos: #FF0000"..tostring(math.floor(impuestos)).." dólares", player, 255, 255, 255, true)
			quitarDinero(player, tonumber(math.floor(impuestos)))
			exports.factions:giveFactionPresupuesto(5, tonumber(math.floor(impuestos)))
			g = g - tonumber(math.floor(impuestos))
			exports.sql:query_free("UPDATE ajustes SET valor = valor + "..tostring(math.floor(impuestos)).. " WHERE ajusteID = 4")
		end
		local multas = exports.sql:query_assoc( "SELECT ind, cantidad, pagado FROM multas WHERE estado = 1 AND characterID = " .. exports.players:getCharacterID(player))
		for k5, v5 in ipairs ( multas ) do
			pagarMulta(player, tonumber(v5.ind), tonumber(v5.cantidad-v5.pagado))
		end
		for k6, v6 in ipairs (exports.sql:query_assoc("SELECT * FROM prestamos WHERE cantidad > pagado AND characterID = " .. exports.players:getCharacterID(player))) do
			if quitarDinero(player, v6.cuota) then
				exports.sql:query_free("UPDATE prestamos SET pagado = "..tonumber(v6.pagado+v6.cuota).." WHERE prestamoID = "..v6.prestamoID)
				outputChatBox("-Préstamo "..tostring(v6.prestamoID)..": #FF0000"..tostring(v6.cuota).." dólares", player, 255, 255, 255, true)
				g = g - v6.cuota
			else
				outputChatBox("No se ha podido pagar la cuota de tu préstamo "..tostring(v6.prestamoID)..".Usa /pagarcuota cuando puedas.", player, 255, 0, 0)
			end
		end
		local sqlloto = exports.sql:query_assoc_single("SELECT loteria FROM characters WHERE characterID = " .. exports.players:getCharacterID(player))
		if sqlloto and sqlloto.loteria and sqlloto.loteria >= 1 then 
			if bganador == sqlloto.loteria then
				outputChatBox("-Lotería Nº "..tostring(sqlloto.loteria).." (ganador): #00FF00400 dólares", player, 255, 255, 255, true)
				darDinero(player, 400)
				g = g + 400
			else
				outputChatBox("-Lotería Nº "..tostring(sqlloto.loteria).." (perdedor): #FF00000 dólares", player, 255, 255, 255, true)
			end
		else
			outputChatBox("-Lotería (sin boleto comprado): #FF00000 dólares", player, 255, 255, 255, true)
		end
		exports.sql:query_free("UPDATE characters SET loteria = 0 WHERE characterID = " .. exports.players:getCharacterID(player))
		if g > 0 then
			outputChatBox("Con esta paga has ganado "..tostring(math.abs(g)).." dólares.", player, 0, 255, 0)
		else
			outputChatBox("Con esta paga has perdido "..tostring(math.abs(g)).." dólares. ", player, 255, 0, 0)
		end
	end
end

function tiempoRestante(player)
	local minutos = getElementData(player, "tpd") or 1
	outputChatBox("Te faltan "..tostring(60-minutos).." minutos para recibir el PayDay en tu PJ.", player, 0, 255, 0)
end
addCommandHandler("payday", tiempoRestante)

function pagarMulta(player, mid, v)
	if paydayPrueba == true then return end
	if player and mid and v and v > 0 then
		local v5 = exports.sql:query_assoc_single( "SELECT * FROM multas WHERE estado = 1 AND cantidad > pagado AND ind = " .. mid)
		if getPlayerMoney(player) >= v then	
			if exports.players:takeMoney(player, tonumber(v)) then
				exports.factions:giveFactionPresupuesto(1, v)
				g = g - v
				exports.sql:query_free( "UPDATE multas SET pagado = "..v5.pagado+v.." WHERE ind = " .. v5.ind )
				outputChatBox ( "-Multa ID "..v5.ind..": #FF0000"..tostring(v).." dólares", player, 255, 255, 255, true )
				if tonumber(v5.pagado+v) == tonumber(v5.cantidad) then
					exports.sql:query_free( "UPDATE multas SET estado = '0' WHERE ind = " .. v5.ind )
				end
			end
		else
			if not quitarDinero(player, tonumber(v)) then
				local dinero = getPlayerMoney(player)
				if exports.players:takeMoney(player, dinero) then
					exports.factions:giveFactionPresupuesto(1, dinero)
					g = g - dinero
					exports.sql:query_free( "UPDATE multas SET pagado = "..v5.pagado+dinero.." WHERE ind = " .. v5.ind )
					outputChatBox ( "-Multa ID "..v5.ind..": #FF0000"..tostring(dinero).." dólares", player, 255, 255, 255, true )
					if tonumber(v5.pagado+dinero) == tonumber(v5.cantidad) then
						exports.sql:query_free( "UPDATE multas SET estado = '0' WHERE ind = " .. v5.ind )
					end
				end
			else
				exports.factions:giveFactionPresupuesto(1, v)
				g = g - v
				exports.sql:query_free( "UPDATE multas SET pagado = "..v5.pagado+v.." WHERE ind = " .. v5.ind )
				outputChatBox ( "-Multa ID "..v5.ind..": #FF0000"..tostring(v).." dólares", player, 255, 255, 255, true )
				if tonumber(v5.pagado+v) == tonumber(v5.cantidad) then
					exports.sql:query_free( "UPDATE multas SET estado = '0' WHERE ind = " .. v5.ind )
				end
			end
		end
	end
end

function darDinero(player, cantidad)
	if paydayPrueba == true then return end
	if exports.players:giveMoney(player, tonumber(cantidad)) then
		return true
	else
		return false
	end
end

function quitarDinero (player, cantidad) -- Aqui da igual el /paga, la cuestión es que se le retire el dinero al usuario.
	if paydayPrueba == true then return end
	if exports.players:takeMoney(player, tonumber(cantidad)) then 
		return true 
	else
		local v = exports.sql:query_assoc_single("SELECT banco FROM characters WHERE characterID = "..exports.players:getCharacterID(player))
		if v and v.banco and cantidad <= v.banco then
			local c, error = exports.sql:query_free("UPDATE characters SET banco = "..(v.banco-cantidad).." WHERE characterID = "..exports.players:getCharacterID(player))
			if error then
				return false
			else
				return true
			end
		else
			return false
		end
	end
end 