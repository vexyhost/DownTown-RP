--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2019 DownTown Roleplay

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

function RGB2HEX(r,g,b)
	local hex = string.format("#%02X%02X%02X", r,g,b)
	return hex
end

function HEX2RGB(hextring)
	hextring = tostring(hextring)
	if string.len(hextring) < 4 then return 0,0,0 end
	hextring = string.gsub(hextring,"#","")
	local r,g,b = tonumber("0x"..string.sub(hextring, 1, 2)) or 0, tonumber("0x"..string.sub(hextring, 3, 4)) or 0, tonumber("0x"..string.sub(hextring, 5, 6)) or 0
	return r,g,b
end


function getTunning(vehicle)
	local sql = exports.sql:query_assoc_single("SELECT tunning FROM vehicles WHERE vehicleID = "..tostring(getElementData(vehicle, "idveh")))
	if not sql then return "" end
	if sql.tunning then
		return split(tostring(sql.tunning), ",")
	else
		return ""
	end
end

function saveTunning(vehicle)
	if not vehicle then return false end
	local strTuning = ''
	local t = 0
	for k, v in ipairs(getVehicleUpgrades(vehicle)) do
		if t == 0 then
			strTuning = tostring(v)
			t = t + 1
		else -- Último slot ()
			strTuning = strTuning..','..tostring(v)
		end
	end
	exports.sql:query_free( "UPDATE vehicles SET tunning = '%s' WHERE vehicleID = " .. tostring(getElementData(vehicle, "idveh")), strTuning )
	local neon = getElementData(vehicle, "neon")
	if neon == true then
		exports.sql:query_free("UPDATE vehicles SET neon = 1 WHERE vehicleID = " .. tostring(getElementData(vehicle, "idveh")))
	end
end
 
function applyTunning(vehicle)
	local tunning = getTunning(vehicle)
	-- Primero eliminamos todo lo que tenga el vehículo
	for k, v in ipairs(getVehicleUpgrades(vehicle)) do
		removeVehicleUpgrade(vehicle, tonumber(v))
	end
	-- Ahora sí añadimos lo que haga falta.
	if tostring(tunning) ~= "" then
		for k2, v2 in ipairs(tunning) do
			addVehicleUpgrade(vehicle, tonumber(v2))
		end
	end
	-- Sistema de Vinilos --
	local sql = exports.sql:query_assoc_single("SELECT pinturas FROM vehicles WHERE vehicleID = "..tostring(getElementData(vehicle, "idveh")))
	if sql then
		if sql.pinturas and tonumber(sql.pinturas) >= 0 then
			setVehiclePaintjob(vehicle, tonumber(sql.pinturas))
		end
	end
	return true
end

function isVehiculoDanado(vehicle)
	if not vehicle then return false end
	local isBroken = false
	for i=0,5 do
		local doorState = getVehicleDoorState(vehicle, i)
		if doorState == 2 or doorState == 3 or (doorState == 4 and getElementModel(vehicle) ~= 471) then
			isBroken = true
		end
	end
	if getElementHealth(vehicle) <= 950 then 
		isBroken = true
	end
	return isBroken
end

function applyTunningOnEnter ( thePlayer, seat, jacked )
    if seat == 0 and getElementData(source, "idveh") and tonumber(getElementData(source, "idveh")) > 0 and not isVehiculoDanado(source) then
        applyTunning(source)
    end
end
addEventHandler ( "onVehicleEnter", getRootElement(), applyTunningOnEnter )

-- Sistema de Guardado de Colores --
function saveColors (vehicle)
	if vehicle then
		local vehicleID = getElementData(vehicle, "idveh")
		if not vehicleID or tonumber(vehicleID) < 1 then return end
		local r, g, b, r2, g2, b2 = getVehicleColor( vehicle, true )
		local r3, g3, b3 = getVehicleHeadLightColor ( vehicle )
		local c1 = RGB2HEX (r, g, b)
		local c2 = RGB2HEX (r2, g2, b2)
		local c3 = RGB2HEX (r3, g3, b3)
		local success, error = exports.sql:query_free( "UPDATE vehicles SET color1 = '" .. c1 .. "', color2 = '" .. c2 .. "', color3 = '" .. c3 .. "' WHERE vehicleID = " .. vehicleID )
		if success and not error then
			return true
		else
			return false
		end
	end
end

function applyColors (vehicle)
	if vehicle then
		local vehicleID = getElementData(vehicle, "idveh")
		if not vehicleID or tonumber(vehicleID) < 1 then return end
		local data = exports.sql:query_assoc_single("SELECT color1, color2, color3 FROM vehicles WHERE vehicleID = "..tostring(vehicleID))
		if data.color1 and data.color2 then
			r, g, b = HEX2RGB(data.color1)
			r2, g2, b2 = HEX2RGB(data.color2)
			setVehicleColor( vehicle, r, g, b, r2, g2, b2 )
		end
		if data.color3 then
			r, g, b = HEX2RGB(data.color3)
			setVehicleHeadLightColor ( vehicle, r, g, b )
		end
		return true
	end
end

-- Sistema de guardado de Vinilos --

function saveVinilos (vehicle)
	if vehicle then
		local vehicleID = getElementData(vehicle, "idveh")
		if not vehicleID or tonumber(vehicleID) < 1 then return end
		local success, error = exports.sql:query_free( "UPDATE vehicles SET pinturas = " .. getVehiclePaintjob ( vehicle ) .. " WHERE vehicleID = " .. vehicleID )
		if success and not error then
			return true
		else
			return false
		end
	end
end