-- Velocimetro Base : AsuS
-- Edicion del mismo: Downtown RP

local sX, sY = guiGetScreenSize( )
local drawing = true

addEventHandler("onClientRender", root,
    function()
		if getElementData(localPlayer, "nohud") then return end
		if not drawing then return end
		if isPedInVehicle(localPlayer) then
			local vehicle = getPedOccupiedVehicle( localPlayer )
			if vehicle then
				-- Velocimetro
				local speed = getVehicleSpeed(getElementVelocity( vehicle ))
				local location = getZoneName ( getElementPosition(localPlayer) )
				dxDrawImage((1134/1366)*sX, (552/768)*sY, (232/1366)*sX, (125/768)*sY, "images/background.png", 0, 0, 0, tocolor(0, 0, 0, 200), true)
				dxDrawText("Velocimetro", (1134/1366)*sX, (552/768)*sY, (1368/1366)*sX, (584/768)*sY, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, true, false, false)
				dxDrawText(speed.." KM/H", (1145/1366)*sX, (584/768)*sY, (1244/1366)*sX, (616/768)*sY, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, true, false, false)
				-- Estado del motor (Arrancado - Apagado)
				if getVehicleEngineState ( vehicle ) then
					dxDrawImage((1143/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/engine.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
				else
					dxDrawImage((1143/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/engine.png", 0, 0, 0, tocolor(255, 255, 255, 100), true)
				end
				-- Freno de mano
				if isElementFrozen ( vehicle ) then
					dxDrawImage((1182/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/break.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
				else
					dxDrawImage((1182/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/break.png", 0, 0, 0, tocolor(255, 255, 255, 100), true)
				end
				-- Estado de las luces
				local lights = getVehicleOverrideLights ( vehicle )
				if lights then
					if lights == 2 then
						dxDrawImage((1222/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/lights.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
					else
						dxDrawImage((1222/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/lights.png", 0, 0, 0, tocolor(255, 255, 255, 100), true)
					end
				end
				dxDrawImage((1257/1366)*sX, (585/768)*sY, (33/1366)*sX, (27/768)*sY, ":vehicles/fuelpoint.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
				-- Indicador de Gasolina
				vehFuel = getElementData ( vehicle, "fuel" )
				if not vehFuel then
					setElementData ( vehicle, "fuel", 100 )
					vehFuel = 100
				end
				dxDrawText(vehFuel.."%", (1284/1366)*sX, (584/768)*sY, (1363/1366)*sX, (616/768)*sY, tocolor(255, 255, 255, 255), 0.45, "bankgothic", "center", "center", false, false, true, false, false)
				if vehFuel then
						if getTickCount() % 1000 < 500 and vehFuel < 20 then
							dxDrawImage((1263/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/fuel.png", 0, 0, 0, tocolor ( 255, 255, 255, 255 ), true)
						else
							dxDrawImage((1263/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/fuel.png", 0, 0, 0, tocolor ( 255, 255, 255, 100 ), true)
						end
				end
			    -- Estádo del vehículo (Abierto - Cerrado)
				if isVehicleLocked( vehicle ) then
					dxDrawImage((1304/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/cerrado.png", 0, 0, 0, tocolor ( 255, 255, 255, 255 ), true)
					else
					dxDrawImage((1304/1366)*sX, (649/768)*sY, (35/1366)*sX, (25/768)*sY, "images/cerrado.png", 0, 0, 0, tocolor ( 255, 255, 255, 100 ), true)
				end
				-- Información de motor dañado
				if  getTickCount() % 1000 < 500 and (getElementHealth( vehicle ) <= 500 or getElementData(vehicle, "chivato")) then
					dxDrawImage((1304/1366)*sX, (616/768)*sY, (35/1366)*sX, (25/768)*sY, "images/averia.png", 0, 0, 0, tocolor ( 255, 255, 255, 255 ), true)
					else
					dxDrawImage((1304/1366)*sX, (616/768)*sY, (35/1366)*sX, (25/768)*sY, "images/averia.png", 0, 0, 0, tocolor ( 255, 255, 255, 100 ), true)
				end
				-- Contador de KM
				if getVehicleType(vehicle) ~= "BMX" then
				km = getElementData( vehicle, "km" )
				if km then
				dxDrawText("KM: "..km, (1020/1366)*sX, (616/768)*sY, (1368/1366)*sX, (648/768)*sY, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, true, false, false)
				end
				end
			end
		end
    end
)

function getVehicleSpeed(x, y, z)
	if x and y and z  then
		return math.floor( math.sqrt( x*x + y*y + z*z ) * 155 )
	else
		return 0
	end
end