local fireModel = 2023
local isFireOn = false
   
local tablafuegos = {
		--  { x, y, z, "Lugar incendio", "descripción de los hechos", "tipo incendio", id vehículo si es un accidente vehícular , si no ignorar sintaxis }
        { 2332.56, 93.44, 26.33, "Cerca de Pizzeria La Esquina", "Hay un vehículo echando humo, ¡seguramente ardiendo!", "regular", 401 },
         { 1844.42, 358.72, 19.66, "TTL, en las cercanias.", "Hay un vehículo echando humo, ¡seguramente ardiendo!", "regular", 401 },
		{ 2543.61, 49.53, 26.48, "Alrededores del taller", "Algun bandalo ha tirado un cocktel molotov a una ventana!", "special" },
}

function iniciarfuegoaleatorioAdmin()
    math.randomseed(getTickCount())
    local randomfire = math.random(1,#tablafuegos)
    local fX, fY, fZ = tablafuegos[randomfire][1],tablafuegos[randomfire][2],tablafuegos[randomfire][3]
                exports.factions:sendMessageToFaction(2, "(( Radio: PCMD )) CENTRAL: Se ha recibido una llamada de emergencia un posible incendio se requieren todas las unidades.",127, 127, 255 )
				exports.factions:sendMessageToFaction(2, "(( Radio: PCMD )) CENTRAL: Es de gravedad: "..tablafuegos[randomfire][5].."("..tablafuegos[randomfire][6]..").",127, 127, 255 )
                exports.factions:sendMessageToFaction(2, "(( Radio: PCMD )) CENTRAL: "..tablafuegos[randomfire][4].." ir de urgencia , se han enviado las cordenadas al GPS.",127, 127, 255 )

			if (tablafuegos[randomfire][7]) then
				local fireveh = createVehicle(tablafuegos[randomfire][7], fX, fY, fZ)
				setTimer( function ()
					destroyElement(fireveh)
				end, 1800000, 1)
				blowVehicle(fireveh)				
			end
			if (tablafuegos[randomfire][6] == "special") then
				local fireElem1 = createObject(fireModel,fX+2,fY+2,fZ)
				setElementCollisionsEnabled(fireElem1,false)
				local col1 = createColSphere(fX+2,fY+2,fZ+1,2)
				setTimer ( function ()
					destroyElement(fireElem1)
					destroyElement(col1)
				end, 420000, 1)

				local fireElem2 = createObject(fireModel,fX+4,fY+4,fZ+2)
				setElementCollisionsEnabled(fireElem2,false)
				local col2 = createColSphere(fX+4,fY+4,fZ+2,2)
				setTimer ( function ()
					destroyElement(fireElem2)
					destroyElement(col2)
				end, 420000, 1)		

				local fireElem3 = createObject(fireModel,fX-2,fY-2,fZ)
				setElementCollisionsEnabled(fireElem3,false)
				local col3 = createColSphere(fX-2,fY-2,fZ+1,2)
				setTimer ( function ()
					destroyElement(fireElem3)
					destroyElement(col3)
				end, 420000, 1)		

				local fireElem4 = createObject(fireModel,fX-4,fY-4,fZ+2)
				setElementCollisionsEnabled(fireElem4,false)
				local col4 = createColSphere(fX-4,fY-4,fZ+1,2)
				setTimer ( function ()
					destroyElement(fireElem4)
					destroyElement(col4)
				end, 420000, 1)		

				local fireElem5 = createObject(fireModel,fX,fY-4,fZ+2)
				setElementCollisionsEnabled(fireElem5,false)
				local col5 = createColSphere(fX,fY-4,fZ+1,2)
				setTimer ( function ()
					destroyElement(fireElem5)
					destroyElement(col5)
				end, 420000, 1)		

				local fireElem6 = createObject(fireModel,fX-4,fY,fZ+2)
				setElementCollisionsEnabled(fireElem6,false)
				local col6 = createColSphere(fX-4,fY,fZ+1,2)
				setTimer ( function ()
					destroyElement(fireElem6)
					destroyElement(col6)
				end, 420000, 1)						
			end
			-- Sincronismo del fuego.
			local fireElem = createObject(fireModel,fX,fY,fZ)
			setElementCollisionsEnabled(fireElem,false)
			local col = createColSphere(fX,fY,fZ+1,2)
			setTimer ( function ()
				destroyElement(fireElem)
				destroyElement(col)
			end, 420000, 1)
		
            triggerClientEvent("startTheFire", getRootElement(),fX,fY,fZ)
            local blip = exports.factions:createFactionBlip2(fX,fY,fZ, 2)
            setTimer ( function ()
                destroyElement(blip)
            end, 900000, 1)
			
			isFireOn = true
			setTimer ( function ()
				isFireOn = false
			end, 900000, 1)
        
end

-- /faleatorio - inicia un fuego aleatorio definido en la tabla de fuegos.
function iniciarfuegoRamdon (thePlayer)
	if thePlayer and hasObjectPermissionTo(thePlayer, "command.reloadpermissions", false) then
		outputDebugString(isFireOn)
		if (isFireOn) then			
			outputChatBox ("(( Actualmente hay un fuego activo ))", thePlayer,255,0,0)
		else
			iniciarfuegoaleatorioAdmin()
			outputChatBox ("INFO: Has activado un fuego ramdon a los bomberos", thePlayer,0,255,0)
			outputChatBox ("si quieres apagarlo administrativamente usa /fquitar", thePlayer,0,255,0)
		end
	else
    outputChatBox("(( Acceso denegado solo Administradores ))", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("faleatorio", iniciarfuegoRamdon)

-- /fquitar - basicamente lo que hace es reiniciar el resource y reiniciar los fuegos
function cancelarfuegoiniciado (thePlayer)
	if thePlayer and hasObjectPermissionTo(thePlayer, "command.reloadpermissions", false) then
		outputDebugString(isFireOn)
		if (isFireOn) then	
			local thisResource = getThisResource()
			outputChatBox ("Sistema de fuegos Downtown Roleplay", thePlayer,255,255,0)
			outputChatBox ("Has apagado correctamente el fuego aleatorio", thePlayer,255,0,0)
			restartResource(thisResource)
			isFireOn = false
		else
			outputChatBox ("(( Actualmente no hay ningún fuego usa /faleatorio )).", thePlayer,255,0,0)
		end
	else
    outputChatBox("(( Acceso denegado solo Administradores ))", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("fquitar", cancelarfuegoiniciado)
