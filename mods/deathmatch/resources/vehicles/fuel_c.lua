--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2017 Downtown Roleplay
]]

local fuelRoot
local fuelStation
local screenX, screenY = guiGetScreenSize( )
local refilling = 0
local xfuel = false
local tick = false
-- Reforma del DX realizada el 17/10/2017
local function renderFuelStation( )
	local vehicle = getPedOccupiedVehicle( getLocalPlayer( ) )
	if vehicle and getVehicleOccupant( vehicle ) == getLocalPlayer( ) and doesVehicleHaveFuel( vehicle ) then
		local fuel = xfuel or getElementData( vehicle, "fuel" )
		dxDrawImage((1134/1366)*screenX, (400/768)*screenY, (232/1366)*screenX, (125/768)*screenY, "images/background.png", 0, 0, 0, tocolor(0, 0, 0, 200), true)
		dxDrawText("Gasolinera", (1194/1366)*screenX, (250/768)*screenY, (1368/1366)*screenX, (584/768)*screenY, tocolor(255, 255, 255, 255), 0.50, "bankgothic", "center", "center", false, false, true, false, false)
		dxDrawImage((1134/1366)*screenX, (400/768)*screenY, (60/1366)*screenX, (60/768)*screenY, "fuelpoint.png", 0, 0, 0, tocolor(255, 255, 255, 255), true)
		dxDrawText( tostring( getElementData( fuelStation, "name" ) or "" ),(1194/1366)*screenX, (425/768)*screenY, (1368/1366)*screenX, (584/768)*screenY, tocolor( 255, 255, 255, 255 ), 0.95, "bankgothic", "center", nil, false, false, true, false, false)
		
		dxDrawText("Fuel: " .. ( fuel + refilling ) .. "%", (1194/1366)*screenX, (450/768)*screenY, screenX - 20, 20, tocolor( 255, 255, 255, 255 ), 0.50, "bankgothic", "center", nil, false, false, true, false, false)
		if getVehicleEngineState( vehicle ) then
			refilling = 0
			dxDrawText( "Apaga\nel motor.", (1194/1366)*screenX, (490/768)*screenY, (1368/1366)*screenX, (584/768)*screenY, tocolor( 255, 255, 255, 255 ), 0.50, "bankgothic", "center", nil, false, false, true, false, false)
		else
			if fuel + refilling < 100 and getPlayerMoney( ) >= math.ceil( refilling * 1.2 ) then
				dxDrawText( "Pulsa 'Espacio'\npara recargar.", (1194/1366)*screenX, (470/768)*screenY, screenX - 20, 20, tocolor( 255, 255, 255, 255 ), 0.50, "bankgothic", "center", nil, false, false, true, false, false)
			end
			
			if refilling > 0 then
				dxDrawText( "Precio: $" .. math.ceil( refilling * 1.2 ), (1194/1366)*screenX, (500/768)*screenY, (1368/1366)*screenX, (584/768)*screenY, tocolor( 255, 255, 255, 255 ), 0.5, "bankgothic", "center" )
			end
			
			if getTickCount( ) - tick > 160 then
				tick = getTickCount( )
				if getKeyState( 'space' ) and refilling + fuel < 100 and math.ceil(  refilling * 1.2 ) <= getPlayerMoney( ) then
					refilling = refilling + 1
					
					if fuel + refilling == 100 then
						triggerServerEvent( "vehicles:fill", fuelStation, refilling )
						xfuel = fuel + refilling
						refilling = 0
					end
				elseif not getKeyState( 'space' ) and refilling > 0 and fuel + refilling <= 100 then
					triggerServerEvent( "vehicles:fill", fuelStation, refilling )
					xfuel = fuel + refilling
					refilling = 0
				end
			end
		end
	end
end

addEventHandler( "onClientElementDataChange", root,
	function( name )
		if name == "fuel" and source == getPedOccupiedVehicle( getLocalPlayer( ) ) then
			xfuel = false
		end
	end
)

addEventHandler( "onClientResourceStart", resourceRoot,
	function( )
		fuelRoot = getElementsByType( "fuelpoint" )[ 1 ]
		if fuelRoot then
			addEventHandler( "onClientColShapeHit", fuelRoot,
				function( element )
					if element == getLocalPlayer( ) then
						fuelStation = source
						tick = getTickCount( )
						addEventHandler( "onClientRender", root, renderFuelStation )
					end
				end
			)
			
			addEventHandler( "onClientColShapeLeave", fuelRoot,
				function( element )
					if element == getLocalPlayer( ) then
						removeEventHandler( "onClientRender", root, renderFuelStation )
						xfuel = nil
						fuelStation = nil
					end
				end
			)
		else
			outputDebugString( "No fuelRoot", 1 )
		end
	end
)