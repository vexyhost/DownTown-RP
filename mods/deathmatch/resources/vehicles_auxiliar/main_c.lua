------------------------------------
-- QUANTUMZ - QUANTUMZ - QUANTUMZ --
------------------------------------
--         2011 - Romania	  	  -- 	    
------------------------------------
-- You can modify this file but   --
-- don't change the credits.      --
------------------------------------
------------------------------------
--  VEHICLECONTROL v1.0 for MTA   --
------------------------------------

GUIEditor_Window = {}
GUIEditor_Button = {}
GUIEditor_Label = {}
GUIEditor_Scrollbar = {}
local x, y = guiGetScreenSize()


GUIEditor_Window[1] = guiCreateWindow(709,236,272,288,"PUERTAS VEHICULO",false)
GUIEditor_Scrollbar[1] = guiCreateScrollBar(24,49,225,17,true,false,GUIEditor_Window[1])
GUIEditor_Label[1] = guiCreateLabel(86,30,135,15,"CAPO",false,GUIEditor_Window[1])
guiSetFont(GUIEditor_Label[1],"default-bold-small")
GUIEditor_Label[2] = guiCreateLabel(74,72,135,15,"PUERTA DELANTERA IZQUIERDA",false,GUIEditor_Window[1])
guiSetFont(GUIEditor_Label[2],"default-bold-small")
GUIEditor_Scrollbar[2] = guiCreateScrollBar(24,91,225,17,true,false,GUIEditor_Window[1])
GUIEditor_Label[3] = guiCreateLabel(68,112,135,15,"PUERTA DELANTERA DERECHA",false,GUIEditor_Window[1])
guiSetFont(GUIEditor_Label[3],"default-bold-small")
GUIEditor_Scrollbar[3] = guiCreateScrollBar(24,130,225,17,true,false,GUIEditor_Window[1])
GUIEditor_Label[4] = guiCreateLabel(71,151,135,15,"PUERTA TRASERA IZQUIERDA",false,GUIEditor_Window[1])
guiSetFont(GUIEditor_Label[4],"default-bold-small")
GUIEditor_Scrollbar[4] = guiCreateScrollBar(24,168,225,17,true,false,GUIEditor_Window[1])
GUIEditor_Label[5] = guiCreateLabel(68,189,135,15,"PUERTA TRASERA DERECHA",false,GUIEditor_Window[1])
guiSetFont(GUIEditor_Label[5],"default-bold-small")
GUIEditor_Scrollbar[5] = guiCreateScrollBar(24,206,225,17,true,false,GUIEditor_Window[1])
GUIEditor_Label[6] = guiCreateLabel(83,226,135,15,"MALETERO",false,GUIEditor_Window[1])
guiSetFont(GUIEditor_Label[6],"default-bold-small")
GUIEditor_Scrollbar[6] = guiCreateScrollBar(24,243,225,17,true,false,GUIEditor_Window[1])
GUIEditor_Button[1] = guiCreateButton(23,265,230,14,"CERRAR",false,GUIEditor_Window[1])
guiSetFont(GUIEditor_Button[1],"default-small")
guiWindowSetSizable ( GUIEditor_Window[1], false )
setElementData(GUIEditor_Scrollbar[1], "Type", 0)
setElementData(GUIEditor_Scrollbar[2], "Type", 2)
setElementData(GUIEditor_Scrollbar[3], "Type", 3)
setElementData(GUIEditor_Scrollbar[4], "Type", 4)
setElementData(GUIEditor_Scrollbar[5], "Type", 5)
setElementData(GUIEditor_Scrollbar[6], "Type", 1)
guiSetVisible(GUIEditor_Window[1], false)
showCursor(false)

function enableVehicleControl()
	if guiGetVisible(GUIEditor_Window[1]) == false then
		guiSetVisible(GUIEditor_Window[1], true)
		showCursor(true)
	else
		guiSetVisible(GUIEditor_Window[1], false)
		showCursor(false)
	end
end
addCommandHandler("puertas", enableVehicleControl)

function closeButton()
		guiSetVisible(GUIEditor_Window[1], false)
		showCursor(false)
end
addEventHandler ( "onClientGUIClick", GUIEditor_Button[1], closeButton, false )

function updateRatio(Scrolled)
	local position = guiScrollBarGetScrollPosition(Scrolled)
	local door = getElementData(Scrolled, "Type")
	triggerServerEvent("moveThisShit", getLocalPlayer(), door, position)
end
addEventHandler("onClientGUIScroll", getRootElement(), updateRatio)

function cerrarVentanaGUIGVehs()
	triggerEvent("offCursor", getLocalPlayer())
	destroyElement(vGestVehiculo)
	setElementData(getLocalPlayer(), "GUIVehs", false)
end

function calcularPrecioVenta(modelo, fmotor, ffrenos)
	if modelo and fmotor and ffrenos then
		--[[ 40% del precio del vehículo + 50% del coste de las fases. El tunning no vale nada, porque no
		se sabe si el que lo compre lo quiere modificar o le gusta así.]]
		local precioVeh = 0
		local precioVehOriginal = tonumber(exports.vehicles_auxiliar:getPrecioFromModel(getVehicleNameFromModel(modelo)))*0.40
		local faseMotor = 6000
		local faseFrenos = 5000
		if fmotor > 0 then
			costeFasesMotor = (fmotor*faseMotor)+((fmotor-1)*faseMotor)
		else
			costeFasesMotor = 0
		end
		if ffrenos > 0 then
			costeFasesFrenos = (ffrenos*faseFrenos)+((ffrenos-1)*faseFrenos)
		else
			costeFasesFrenos = 0
		end
		local costeDosFases = costeFasesMotor+costeFasesFrenos
		local precioVeh = (costeDosFases*0.5)+precioVehOriginal
		return precioVeh
	end
end
            
function mostrarGUIGVehs(data)
	triggerEvent("onCursor", getLocalPlayer())
    vGestVehiculo = guiCreateWindow(390*x/1366, 140*y/768, 560*x/1366, 418*y/768, "Panel de Gestión de Vehículos - DownTown RolePlay", false)
	guiWindowSetSizable(vGestVehiculo, false)
    labelInfo = guiCreateLabel(13*x/1366, 31*y/768, 537*x/1366, 61*y/768, "Bienvenido al panel de gestión de vehículos de DownTown RolePlay.\n\nDesde aquí podrás ver los vehículos que tienes, ver su estado, y realizar trámites con ellos, como renovarlos o venderlos al sistema de concesionarios de 2º mano.", false, vGestVehiculo)
    guiLabelSetHorizontalAlign(labelInfo, "center", true)
    gridVehiculos2 = guiCreateGridList(31*x/1366, 104*y/768, 492*x/1366, 210*y/768, false, vGestVehiculo)
    guiGridListAddColumn(gridVehiculos2, "ID vehículo", 0.18)
    guiGridListAddColumn(gridVehiculos2, "Modelo", 0.28)
    --guiGridListAddColumn(gridVehiculos2, "Días restantes", 0.13)
    --guiGridListAddColumn(gridVehiculos2, "Coste renovación", 0.15)
    guiGridListAddColumn(gridVehiculos2, "Precio venta", 0.20)
	guiGridListAddColumn(gridVehiculos2, "¿Depósito?", 0.16)
	row = 0 
	for k, v in ipairs(data) do
		guiGridListAddRow(gridVehiculos2)
		guiGridListSetItemText(gridVehiculos2, row, 1, tostring(v.vehicleID), false, false)
		guiGridListSetItemText(gridVehiculos2, row, 2, tostring(getVehicleNameFromModel(v.model)), false, false)
		--guiGridListSetItemText(gridVehiculos2, row, 3, tostring(v.dias), false, false)
		--guiGridListSetItemText(gridVehiculos2, row, 4, tostring(exports.vehicles_auxiliar:getCosteRenovacionFromModel(tostring(getVehicleNameFromModel(v.model)))), false, false)
		guiGridListSetItemText(gridVehiculos2, row, 3, tostring(calcularPrecioVenta(v.model, tonumber(v.fasemotor), tonumber(v.fasefrenos))), false, false)
		if tonumber(v.cepo) == 1 then
			guiGridListSetItemText(gridVehiculos2, row, 4, "Sí", false, false)
		else
			guiGridListSetItemText(gridVehiculos2, row, 5, "No", false, false)
		end
		row = row+1
	end
    bCerrarVentana = guiCreateButton(30*x/1366, 327*y/768, 116*x/1366, 37*y/768, "Cerrar ventana", false, vGestVehiculo)
    bLocalizarVeh = guiCreateButton(156*x/1366, 327*y/768, 116*x/1366, 37*y/768, "Localizar vehículo", false, vGestVehiculo)
    --bRenovarVeh = guiCreateButton(282*x/1366, 327*y/768, 116*x/1366, 37*y/768, "Renovar vehículo", false, vGestVehiculo)
    bVenderVeh = guiCreateButton(282*x/1366, 327*y/768, 116*x/1366, 37*y/768, "Vender vehículo", false, vGestVehiculo)
	--bPasarOpcionA = guiCreateButton(408*x/1366, 370*y/768, 116*x/1366, 37*y/768, "Pasar a Opción A", false, vGestVehiculo)
	bCancelarPrestamo = guiCreateButton(156*x/1366, 370*y/768, 116*x/1366, 37*y/768, "Cancelar préstamo", false, vGestVehiculo)
	--bRetirarVeh = guiCreateButton(282*x/1366, 370*y/768, 116*x/1366, 37*y/768, "Retirar del depósito", false, vGestVehiculo)
	addEventHandler("onClientGUIClick", bCerrarVentana, regularGUIVehs)
	addEventHandler("onClientGUIClick", bLocalizarVeh, regularGUIVehs)
	--addEventHandler("onClientGUIClick", bRenovarVeh, regularGUIVehs)
	addEventHandler("onClientGUIClick", bVenderVeh, regularGUIVehs)
	--addEventHandler("onClientGUIClick", bPasarOpcionA, regularGUIVehs)
	addEventHandler("onClientGUIClick", bCancelarPrestamo, regularGUIVehs)
	addEventHandler("onClientGUIClick", bRetirarVeh, regularGUIVehs)
end
addEvent("onAbrirGUIGestVehs", true)
addEventHandler("onAbrirGUIGestVehs", getRootElement(), mostrarGUIGVehs)
                    
function regularGUIVehs()
	local r, c = guiGridListGetSelectedItem(gridVehiculos2)
	if source == bCerrarVentana then
		cerrarVentanaGUIGVehs()
	elseif source == bLocalizarVeh then
		if tonumber(r) == -1 then
			outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			return
		end
		local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
		triggerServerEvent("onSolicitarLocVehViaAsistencia", getLocalPlayer(), vehicleID)
		cerrarVentanaGUIGVehs()
	-- elseif source == bRenovarVeh then
		-- if tonumber(r) == -1 then
			-- outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			-- return
		-- end
		-- local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
		-- local modelo = guiGridListGetItemText(gridVehiculos2, r, 2)
		-- local dias = guiGridListGetItemText(gridVehiculos2, r, 3)
		-- triggerServerEvent("onRenovarVehiculo", getLocalPlayer(), vehicleID, modelo)
	-- elseif source == bVenderVeh then
		-- if tonumber(r) == -1 then
			-- outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			-- return
		-- end
		-- local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
		-- TODO
	-- elseif source == bPasarOpcionA then
		-- if tonumber(r) == -1 then
			-- outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			-- return
		-- end	
		-- local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
	elseif source == bCancelarPrestamo then
		cerrarVentanaGUIGVehs()
		outputChatBox("Para cancelar el préstamo de tu vehículo, pulsa F1.", 0, 255, 0)
		outputChatBox("Se hará efectivo inmediatamente. ¡Sin hay esperas!", 0, 255, 0)
	elseif source == bRetirarVeh then
		if tonumber(r) == -1 then
			outputChatBox("Selecciona primero un vehículo de la lista.", 255, 0, 0)
			return
		end
		local vehicleID = guiGridListGetItemText(gridVehiculos2, r, 1)
		triggerServerEvent("onRetirarDepo", getLocalPlayer(), getLocalPlayer(), "cmd", vehicleID)
	end
end