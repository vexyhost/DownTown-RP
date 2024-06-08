mascotas = {}
mascotasIDs = {}
siguimientos = {}

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM mascotas ORDER BY ID ASC" )
			for x, t in ipairs (result) do
				RespawnMascota (t.ID, t.raza, t.name, t.owner, t.x, t.y, t.z, t.interior, t.dimension )
			end
	end
)

function revivirMascota(ammo, killer)
	setElementHealth(source, 1000)
	outputChatBox("Se ha dado alerta a la policía por entorno por haber matado a la mascota.", killer, 255, 255, 0)
end

function tipoMascotaToString(id)
	local name = ""
	if id==88 then
		name = "Pastor Alemán"
	elseif id==89 then
		name = "Pitbull"
	elseif id==243 then
		name = "Golden"
	elseif id==244 then
		name = "Rottweiler"
	elseif id==252 then
		name = "Dogo"
	end
	return name
end

function RespawnMascota(ID, R, name, char, x, y, z, int, dim, es)
	if ID and R and char and x and y and z and int and dim then
		local perro = createPed ( R, x, y, z )
		setElementDimension(perro, dim)
		setElementInterior(perro, int)
		setElementData(perro, "npcname", tipoMascotaToString(R).."\n"..tostring(name).." ("..ID..")")
		mascotas[ perro ] = { mascotaID = ID, mascotaRaza = R, mascotaOwner = char, mascotaName = tostring(name)}
		mascotasIDs[ ID ] = perro
		setTimer(setPedAnimation, 1500, 1, perro, "crack", "crckidle2")
		addEventHandler("onPedWasted", perro, revivirMascota)
	end
end

function createNewMascota(raza, name, characterID, x, y, z, int, dim, p)
	local mascotaID, error = exports.sql:query_insertid( "INSERT INTO mascotas (raza, name, owner, x, y, z, interior, dimension) VALUES ('"..raza.."','"..name.."','"..characterID.."','"..x.."','"..y.."','"..z.."','"..int.."','"..dim.."')")
	if error then
		outputDebugString(error)
	else
		outputChatBox("La mascota se creó satisfactoriamente con ID: ".. mascotaID, p, 0, 255, 0)
		local perro = createPed ( raza, x, y, z )
		addEventHandler("onPedWasted", perro, revivirMascota)
		setElementInterior(perro, int)
		setElementDimension(perro, dim)
		setElementData(perro, "npcname", tipoMascotaToString(raza).."\n"..name.." ("..mascotaID..")")
		mascotas[ perro ] = { mascotaID = mascotaID, mascotaRaza = raza, mascotaOwner = characterID, mascotaName = tostring(name)}
		mascotasIDs[ mascotaID ] = perro
	end
end

function comprarMascota(player, cmd, tipo, nombre)
	if not tipo or not nombre then
		outputChatBox("Sintaxis: /comprarmascota [raza] [nombre]", player, 255, 255, 255)
		outputChatBox("Razas disponibles:", player, 255, 255, 255)
		outputChatBox("1 - Pastor Alemán.", player, 255, 255, 255)
		outputChatBox("2 - Pitbull.", player, 255, 255, 255)
		outputChatBox("3 - Golden.", player, 255, 255, 255)
		outputChatBox("4 - Rottweiler.", player, 255, 255, 255)
		outputChatBox("5 - Dogo de Burdeos.", player, 255, 255, 255)
	else
		local sql = exports.sql:query_assoc_single("SELECT count(ID) AS cuenta FROM mascotas WHERE owner = "..exports.players:getCharacterID(player))
		if tonumber(sql.cuenta) == 0 then
			if getElementDimension(player) ~= 453 then
				outputChatBox("No estás en la tienda de mascotas.", player, 255, 0, 0)
				return
			end
			local tipo = tonumber(tipo)
			if (tipo~=1 and tipo~=2 and tipo~=3 and tipo~=4 and tipo~=5) then
				outputChatBox("Sintaxis: /comprarmascota [raza] [nombre]", player, 255, 255, 255)
				outputChatBox("Razas disponibles:", player, 255, 255, 255)
				outputChatBox("1 - Pastor Alemán.", player, 255, 255, 255)
				outputChatBox("2 - Pitbull.", player, 255, 255, 255)
				outputChatBox("3 - Golden.", player, 255, 255, 255)
				outputChatBox("4 - Rottweiler.", player, 255, 255, 255)
				outputChatBox("5 - Dogo de Burdeos.", player, 255, 255, 255)
				return
			end
			-- No tiene ninguna mascota más.
			if exports.players:takeMoney(player, 1500) then
				local characterID = exports.players:getCharacterID(player)
				local x, y, z = getElementPosition(player)
				local int = getElementInterior(player)
				local dim = getElementDimension(player)
				local raza = -1
				if (tipo==1) then
					raza = 88
				elseif (tipo==2) then
					raza = 89
				elseif (tipo==3) then
					raza = 243
				elseif (tipo==4) then
					raza = 244
				elseif (tipo==5) then
					raza = 252
				end
				if raza ~= -1 then
					createNewMascota(tonumber(raza), tostring(nombre), characterID, x, y, z, int, dim, player)
					outputChatBox("Usa /ayudamascotas para conocer los comandos de tu mascota.", player, 0, 255, 0)
				else
					outputChatBox("Error GRAVE, acuda al CAU con los logs!", player, 255, 0, 0)
				end
			else
				outputChatBox("¡La mascota cuesta 1500 dólares!", player, 255, 0, 0)
			end
		else
			outputChatBox("Sólo se permite una mascota por personaje.", player, 255, 0, 0)
		end
	end
end
--addCommandHandler("comprarmascota", comprarMascota) Si se habilita el sistema de mascotas, reajustar el ID del interior de tienda (453)

--[[addCommandHandler("crearmascota", 
function( player, cmd, raza, name)
	if not raza or not name then outputChatBox("Sintaxis: /"..cmd.." [id mascota] [nombre]", player, 255, 255, 255) return end
	local characterID = exports.players:getCharacterID(player)
	local x, y, z = getElementPosition(player)
	local int = getElementInterior(player)
	local dim = getElementDimension(player)
	createNewMascota(tonumber(raza), tostring(name), characterID, x, y, z, int, dim, player)
end)]]

--[[addCommandHandler("borrarmascota", 
function( player, cmd, ID)
	if not ID then outputChatBox("Sintaxis: /"..cmd.." [id mascota]", player, 255, 255, 255) return end
	local perro = mascotasIDs[tonumber(ID)]
		if exports.sql:query_free( "DELETE FROM mascotas WHERE ID = " .. tonumber(ID) ) then
			if perro then
				destroyElement(perro)
				mascotas[perro] = nil
				mascotasIDs[tonumber(ID)] = nil
				siguimientos[perro] = nil
				outputChatBox("Borraste satisfactoriamente la mascota ID: "..tonumber(ID), player, 0, 255, 50)
			else
				outputChatBox("(( La mascota indicada no existe ))", player, 255, 0, 0)
			end
		end
end)]]

function dogFollow( theprisoner)
	if siguimientos[theprisoner] == nil then
	else
		local copx, copy, copz = getElementPosition ( siguimientos[theprisoner] )
		local prisonerx, prisonery, prisonerz = getElementPosition ( theprisoner )
		
		copangle = ( 360 - math.deg ( math.atan2 ( ( copx - prisonerx ), ( copy - prisonery ) ) ) ) % 360
		setPedRotation ( theprisoner, copangle )
		local dist = getDistanceBetweenPoints2D ( copx, copy, prisonerx, prisonery )	
		if getElementInterior(siguimientos[theprisoner]) ~= getElementInterior(theprisoner) then setElementInterior(theprisoner, getElementInterior(siguimientos[theprisoner])) end
		if getElementDimension(siguimientos[theprisoner]) ~= getElementDimension(theprisoner) then setElementDimension(theprisoner, getElementDimension(siguimientos[theprisoner])) end
		if dist >= 200 then
			local x,y,z = getElementPosition(siguimientos[theprisoner])
			setElementPosition(theprisoner, x, y, z)
		elseif dist >= 9 then
			setPedAnimation(theprisoner, "ped", "sprint_civi")
		elseif dist >= 6 then
			setPedAnimation(theprisoner, "ped", "run_player")
		elseif dist >= 3 then
			setPedAnimation(theprisoner, "ped", "WALK_player")
		else
			setPedAnimation(theprisoner, false)
		end
		if isPedInVehicle ( siguimientos[theprisoner] ) then
			local car = getPedOccupiedVehicle ( siguimientos[theprisoner] )
			for i = 0, getVehicleMaxPassengers( car ) do
			local p = getVehicleOccupant( car, i )
				if not p and not isVehicleLocked(car) and not isPedInVehicle(theprisoner) then
					warpPedIntoVehicle ( theprisoner, car, i )
				end
			end
		else
			if isPedInVehicle ( theprisoner ) then
				removePedFromVehicle ( theprisoner )
			end
		end
		local zombify = setTimer ( dogFollow, 750, 1, theprisoner )
	end
end

addCommandHandler("msigueme",
function(player, cmd, ID)
	if not ID then outputChatBox("Sintaxis: /"..cmd.." [id mascota]", player, 255, 255, 255) return end
		local perro = mascotasIDs[tonumber(ID)]
		local IDC = exports.players:getCharacterID(player)
		local Id2 = mascotas[perro].mascotaOwner
		if IDC == Id2 or (getElementData(player, "account:gmduty")==true) then
			siguimientos[perro] = player
			if isPedInVehicle ( perro ) then
				removePedFromVehicle ( perro )
			end
			dogFollow(perro)
			outputChatBox("Ahora el perro(".. ID.. ") te esta siguendo.", player, 0, 255, 0)
			exports.chat:me( player, "le engancha las trinches a su mascota y la lleva de paseo.")
		else
			outputChatBox("(( Esta mascota no te pertenece ))", player, 255, 0, 0)
			x, y, z = getElementPosition(perro)
			int = getElementInterior(perro)
			dim = getElementDimension(perro)
			setPedAnimation(perro, "ped", "JUMP_launch", 18000, true, false)
			triggerClientEvent ( "onSonido", getRootElement(), x, y, z, int, dim )
		end
end)

--[[addCommandHandler("mespera",
function(player, cmd, ID)
	if not ID then outputChatBox("Sintaxis: /"..cmd.." [id mascota]", player, 255, 255, 255) return end
	local perro = mascotasIDs[tonumber(ID)]
	siguimientos[perro] = nil
	local x, y, z = getElementPosition(perro)
	local int = getElementInterior(perro)
	local dim = getElementDimension(perro)
	exports.chat:me( player, "deja a su perro durmiendo.")
	setPedAnimation(perro, "beach", "sitnwait_loop_w")
	if exports.sql:query_free( "UPDATE mascotas SET x = " .. x .. ", y = "..y..", z = "..z..", interior = "..int..", dimension = "..dim.." WHERE ID = " .. ID ) then
		outputChatBox("Has dejado a tu perro durmiendo en este lugar.", player, 0, 255, 0 )
	end
end)]]

addCommandHandler("mdormir",
function(player, cmd, ID)
	if not ID then outputChatBox("Sintaxis: /"..cmd.." [id mascota]", player, 255, 255, 255) return end
	local perro = mascotasIDs[tonumber(ID)]
	siguimientos[perro] = nil
	local x, y, z = getElementPosition(perro)
	local int = getElementInterior(perro)
	local dim = getElementDimension(perro)
	exports.chat:me( player, "deja a su perro durmiendo.")
	setPedAnimation(perro, "crack", "crckidle2")
	if exports.sql:query_free( "UPDATE mascotas SET x = " .. x .. ", y = "..y..", z = "..z..", interior = "..int..", dimension = "..dim.." WHERE ID = " .. ID ) then
		outputChatBox("Has dejado a tu perro durmiendo en este lugar.", player, 0, 255, 0 )
	end
end)


function helpmascotas(player)
	outputChatBox("Ayuda sistema de mascotas DownTown Roleplay",player, 255, 255, 0)
	outputChatBox("/mdormir /msigueme /mcollar",player, 0, 255, 0)
	--outputChatBox("Recuerda que debes alimentar tu mascota con items de comida.", player, 0, 255, 0)
end
addCommandHandler("ayudamascotas", helpmascotas)


addCommandHandler("gotom",
function(player, cmd, ID)
	if not ID then outputChatBox("Sintaxis: /"..cmd.." [id mascota]", player, 255, 255, 255) return end
	if not getElementData(player, "account:gmduty") == true then outputChatBox("Solo para staff de servicio.", player, 255, 0, 0) return end
	local perro = mascotasIDs[tonumber(ID)]
	if perro then
		local x, y, z = getElementPosition(perro)
		local dim = getElementDimension(perro)
		local inte = getElementInterior(perro)
		setElementPosition(player, x+1, y, z)
		setElementDimension(player,dim)
		setElementInterior(player,inte)
		outputChatBox("Te teleportaste a la mascota ID: "..ID, player, 0, 255, 0)
	else
		outputChatBox("(( La mascota indicada no existe. ))", player, 255, 0, 0)
	end
end)


addCommandHandler("getm",
function(player, cmd, ID)
	if not ID then outputChatBox("Sintaxis: /"..cmd.." [id mascota]", player, 255, 255, 255) return end
	if not getElementData(player, "account:gmduty") == true then outputChatBox("Solo para staff de servicio.", player, 255, 0, 0) return end
	local perro = mascotasIDs[tonumber(ID)]
	if perro then
		local x, y, z = getElementPosition(player)
		local dim = getElementDimension(player)
		local inte = getElementInterior(player)
		setElementPosition(perro, x+1, y, z)
		setElementDimension(perro,dim)
		setElementInterior(perro,inte)
		outputChatBox("Has teletransportado a ti la mascota ID: "..ID, player, 0, 255, 0)
	else
		outputChatBox("(( La mascota indicada no existe. ))", player, 255, 0, 0)
	end
end)


function collarperro(player, cmd, ID)
	if not ID then outputChatBox("Sintaxis: /"..cmd.." [id mascota]", player, 255, 255, 255) return end
	perro = mascotasIDs[tonumber(ID)]
	if perro then
		local x1, y1, z1 = getElementPosition ( player )
		local x2, y2, z2 = getElementPosition ( perro )
		local distance = getDistanceBetweenPoints3D ( x1, y1, z1, x2, y2, z2 )
		 if ( distance < 2) then
			local namedueno = exports.players:getCharacterName( mascotas[perro].mascotaOwner )
			exports.chat:me( player, "se agacha y revisa el collar de "..tostring(mascotas[perro].mascotaName)..".")
			outputChatBox("==== Collar de "..tostring(mascotas[perro].mascotaName).." ====",player, 255, 255, 0)
			outputChatBox("Dueño de la mascota: ".. namedueno .."",player, 0, 255, 0)
			outputChatBox("Raza del animal: "..tostring(tipoMascotaToString(mascotas[perro].mascotaRaza)),player, 0, 255, 0)
		else
		outputChatBox("(( No estás cerca de la mascota ))", player, 255, 0, 0)
		end
	else
	outputChatBox("(( La mascota indicada no existe ))", player, 255, 0,0)
	end
end
addCommandHandler("mcollar",collarperro)

-- Mascotas entorno de la perrera
function cargarmascotasperrera()
	local ped88 = createPed( 88, -2028.56640625, -118.7607421875, 1035.171875, 103.11102294922, true )
	setElementData(ped88, "npcname", "Pastor Alemán\nSin Nombre")
	setElementInterior(ped88,3)
	setElementDimension(ped88,453)
	
	local ped89 = createPed( 89, -2028.697265625, -117.1669921875, 1035.171875, 120.41473388672, true )
	setElementData(ped89, "npcname", "Pitbull\nSin Nombre")
	setElementInterior(ped89,3)
	setElementDimension(ped89,453)
	
	local ped243 = createPed( 243, -2028.830078125, -115.6708984375, 1035.171875, 121.37603759766, true )
	setElementData(ped243, "npcname", "Golden\nSin Nombre")
	setElementInterior(ped243,3)
	setElementDimension(ped243,453)
	
	local ped244 = createPed( 244, -2031.2412109375, -119.4013671875, 1035.171875, 31.138488769531, true )
	setElementData(ped244, "npcname", "Rottweiler\nSin Nombre")
	setElementInterior(ped244,3)
	setElementDimension(ped244,453)
	
	local ped252 = createPed( 252, -2033.51171875, -118.8349609375, 1035.171875, 327.57611083984, true )
	setElementData(ped252, "npcname", "Dogo\nSin Nombre")
	setElementInterior(ped252,3)
	setElementDimension(ped252,453)
	
	addEventHandler("onPedWasted", ped88, revivirMascota)
	addEventHandler("onPedWasted", ped89, revivirMascota)
	addEventHandler("onPedWasted", ped243, revivirMascota)
	addEventHandler("onPedWasted", ped244, revivirMascota)
	addEventHandler("onPedWasted", ped252, revivirMascota)

end
--addEventHandler( "onResourceStart", resourceRoot, cargarmascotasperrera ) DESCOMENTAR SI SE IMPLEMENTA EL SISTEMA DE MASCOTAS