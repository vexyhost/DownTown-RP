----------------------------------------------
-- Author: Braydon Davis / xXMADEXx	y Javi	--
-- Project: Community - Ammunation DX		--
-- File: server-side.lua					--
-- Copyright (C) 2013-2014 					--
-- All Rights Reserved						--
----------------------------------------------

local balasCargador =
{
    [ 22 ] = 12,
    [ 23 ] = 12,
	[ 24 ] = 7,
	[ 25 ] = 1,
	[ 26 ] = 2,
	[ 27 ] = 4,
	[ 28 ] = 50,
	[ 29 ] = 45,
	[ 32 ] = 50,
	[ 30 ] = 30,
	[ 31 ] = 30,
	[ 33 ] = 1,
	[ 34 ] = 1,
}

function isCargadorCompradoHoy(player, weapon)
	local time = getRealTime()
	local ano = (time.year+1900)
	local dia = (time.yearday)
	local nombreArchivo = tostring(weapon).."-"..tostring(ano).."-"..tostring(dia).."-"..tostring(getPlayerName(player))
	if fileExists("registro/"..nombreArchivo) then
		return true
	else
		return false
	end
end

function registrarCargadorComprado(player, weapon)
	local time = getRealTime()
	local ano = (time.year+1900)
	local dia = (time.yearday)
	local nombreArchivo = tostring(weapon).."-"..tostring(ano).."-"..tostring(dia).."-"..tostring(getPlayerName(player))
	if fileExists("registro/"..nombreArchivo) then
		return false
	else
		local newFile = fileCreate("registro/"..nombreArchivo)
		if (newFile) then
			fileClose(newFile)
			return true
		end
	end
end

local ped = nil
local prices = {
	[22] = 20,
	[23] = 40,
	[25] = 10,
	[26] = 30,
	[27] = 50,
	[28] = 30,
	[29] = 50,
	[30] = 80,
	[31] = 100,
	[32] = 80,
	[33] = 10,
	[34] = 30,
	[500] = 200, -- Chaleco antibalas
}

local function createOurPed( )
	if ped then
		destroyElement( ped )
	end
	
	ped = createPed( 179, 295.267578125, -40.21484375, 1001.515625)
	setPedRotation (ped, 370)
	setElementDimension( ped, 354 )
	setElementData( ped, "npcname", "Jackson Gun")
	setElementFrozen( ped, true )
	setElementInterior( ped, 1 )
end

addEventHandler( "onPedWasted", resourceRoot, createOurPed )
addEventHandler( "onResourceStart", resourceRoot, createOurPed )

addEvent ( "Ammunation:onClientBuyWeapon", true )
addEventHandler ( "Ammunation:onClientBuyWeapon", root, function ( name, id, price )
	 if ( getPlayerMoney ( source ) >= price ) then
		-- Comprobamos si tiene licencia de arma para el id solicitado, o es un chaleco.
		local sql = exports.sql:query_assoc_single("SELECT licenciaID FROM licencias_armas WHERE status = 0 AND cID = "..tostring(exports.players:getCharacterID(source)).." AND weapon = "..tostring(id))
		if sql or id == 500 then
			if exports.players:takeMoney(source, prices[id]) then
				if id == 500 then
					-- Le damos un chaleco antibalas
					exports.items:give(source, 46, 100)
					outputChatBox("Has comprado un chaleco antibalas por "..tostring(prices[id]).." dólares.", source, 0, 255, 0)
				else
					if not isCargadorCompradoHoy(source, id) then
						local balas = balasCargador[tonumber(id)]
						exports.items:give( source, 43, tonumber(id), "Cargador Arma", tonumber(balas) )
						outputChatBox("Has comprado el cargador correctamente. ¡Recuerda, sólo 1 cargador diario/arma!", source, 0, 255, 0)
						registrarCargadorComprado(source, id)
					else
						outputChatBox("Ya has comprado 1 cargador de este arma. Vuelve mañana.", source, 255, 0, 0)
						exports.players:giveMoney(source, prices[id])
					end
					-- Le damos un cargador del arma elegida
				end
			else
				outputChatBox ( "No puedes permitirte un/a "..name..".", source, 255, 0, 0 )
			end
			-- Comprobamos precios de cada arma.
		else
			outputChatBox("No tienes licencia de armas para el arma especificada. Acude a Justicia.", source, 255, 0, 0)
		end
	 else
		 outputChatBox ( "No puedes permitirte un/a "..name..".", source, 255, 0, 0 )
	 end
end )