local vPrev
   
local impVeh = {
	[1] = 0,
	[2] = 450,
	[3] = 150,
	[4] = 150,
	[5] = 100,
	[6] = 150,
	[7] = 175,
	[8] = 125,
	[9] = 100,
	[10] = 50, 
	[11] = 300,
	[12] = 350,
}

function abrirGUIConcesionario (vip)
	if vPrev and isElement(vPrev) then destroyElement(vPrev) end
	triggerEvent("onCursor", getLocalPlayer())
	ventanaConce = guiCreateWindow(400, 95, 594, 558, "Concesionario de vehículos nuevos - DownTown RolePlay", false)
	guiWindowSetSizable(ventanaConce, false)
	lAyuda = guiCreateLabel(36, 32, 519, 164, "Bienvenido al concesionario de vehículos nuevos. Puedes comprar un vehículo con préstamo o en efectivo. Te vamos a explicar cada opción:\n\nOpción con préstamo: tendrás que pagar una entrada, y en cada PayDay (cada hora) irás pagándolo poco a poco, sin intereses.\n\nOpción en efectivo: no tienes préstamo ninguno, y lo pagas de una vez. No es recomendable esta opción, ya que tener un préstamo no te condiciona nada.\n\nDebes de tener en cuenta que, además del préstamo (si no lo compras en efectivo), se te cobrará cada PayDay una cantidad de impuestos.", false, ventanaConce)
	guiLabelSetHorizontalAlign(lAyuda, "center", true)
	gridConce = guiCreateGridList(36, 220, 399, 304, false, ventanaConce)
	guiGridListAddColumn(gridConce, "Modelo", 0.22)
	guiGridListAddColumn(gridConce, "Precio", 0.22)
	guiGridListAddColumn(gridConce, "Entrada Préstamo", 0.22)
	guiGridListAddColumn(gridConce, "Impuestos", 0.22)
	bCerrarConce = guiCreateButton(447, 223, 137, 38, "Cerrar ventana", false, ventanaConce)
	--bConceCompraA = guiCreateButton(447, 271, 137, 38, "Comprar en efectivo (opción A)", false, ventanaConce)
	bConceCompraB = guiCreateButton(447, 319, 137, 38, "Comprar en efectivo ", false, ventanaConce)
	bConceCompraBPre = guiCreateButton(447, 367, 137, 38, "Comprar en préstamo", false, ventanaConce)
	bConcePrev = guiCreateButton(447, 415, 137, 38, "Previsualizar vehículo.", false, ventanaConce)
	bAyuda = guiCreateButton(447, 463, 137, 38, "No lo entiendo. Quiero que me lo expliquen.", false, ventanaConce)
	addEventHandler('onClientGUIClick', bCerrarConce, regularBotonesConce)
	--addEventHandler('onClientGUIClick', bConceCompraA, regularBotonesConce)
	addEventHandler('onClientGUIClick', bConceCompraB, regularBotonesConce)
	addEventHandler('onClientGUIClick', bConceCompraBPre, regularBotonesConce)
	addEventHandler('onClientGUIClick', bConcePrev, regularBotonesConce)
	addEventHandler('onClientGUIClick', bAyuda, regularBotonesConce)
	rAct = 0
	for k, v in ipairs(exports.vehicles_auxiliar:getDatos()) do
		guiGridListAddRow(gridConce)
		guiGridListSetItemText(gridConce, rAct, 1, tostring(v.m), false, false)
		if vip == true then
			--guiGridListSetItemText(gridConce, rAct, 2, tostring(math.floor((v.p*5)*0.75)), false, false)
			--guiGridListSetItemText(gridConce, rAct, 3, tostring(math.floor(v.p*0.75)), false, false)
			--guiGridListSetItemText(gridConce, rAct, 4, tostring(math.floor(v.p*0.1667)), false, false)
		else
			guiGridListSetItemText(gridConce, rAct, 2, tostring(v.p), false, false)
			guiGridListSetItemText(gridConce, rAct, 3, tostring(v.p*0.3), false, false)
			local clase = exports.vehicles_auxiliar:getClaseFromModel(tostring(v.m))
			guiGridListSetItemText(gridConce, rAct, 4, tostring(impVeh[clase]), false, false)
		end
		--[[if v.vip == true then
			guiGridListSetItemColor(gridConce, rAct, 1, 180, 0, 255)
			guiGridListSetItemColor(gridConce, rAct, 2, 180, 0, 255)
			guiGridListSetItemColor(gridConce, rAct, 3, 180, 0, 255)
			guiGridListSetItemColor(gridConce, rAct, 4, 180, 0, 255)
		end]]
		rAct = rAct + 1
	end
end
addEvent("abrirconce", true)    
addEventHandler("abrirconce", root, abrirGUIConcesionario)

function cerrarGUIConce()
	triggerEvent("offCursor", getLocalPlayer())
	destroyElement(ventanaConce)
	setElementData(getLocalPlayer(), "abrirconce", false)
end

function regularBotonesConce()
	if source == bCerrarConce then
		cerrarGUIConce()
	elseif source == bConceCompraA then
		local fila = guiGridListGetSelectedItem ( gridConce )
		if fila == -1 then 
			outputChatBox("Debes seleccionar primero un vehículo de la lista.", 255, 0, 0)
			return
		end
		local model = tostring(guiGridListGetItemText( gridConce, fila, 1))
		local model2 = getVehicleModelFromName(model)
		local precio = tonumber(guiGridListGetItemText( gridConce, fila, 2))
		triggerServerEvent("comprarVehiculo", getLocalPlayer(), getLocalPlayer(), tostring(model), tonumber(precio), tonumber(model2), 1)
		cerrarGUIConce()           
	elseif source == bConceCompraB then
		local fila = guiGridListGetSelectedItem ( gridConce )
		if fila == -1 then 
			outputChatBox("Debes seleccionar primero un vehículo de la lista.", 255, 0, 0)
			return
		end
		local model = tostring(guiGridListGetItemText( gridConce, fila, 1))
		local model2 = getVehicleModelFromName(model)
		local precio = tonumber(guiGridListGetItemText( gridConce, fila, 2))
		triggerServerEvent("comprarVehiculo", getLocalPlayer(), getLocalPlayer(), tostring(model), tonumber(precio), tonumber(model2), 2)
		cerrarGUIConce()
	elseif source == bConceCompraBPre then
		local fila = guiGridListGetSelectedItem ( gridConce )
		if fila == -1 then 
			outputChatBox("Debes seleccionar primero un vehículo de la lista.", 255, 0, 0)
			return
		end
		local model = tostring(guiGridListGetItemText( gridConce, fila, 1))
		local model2 = getVehicleModelFromName(model)
		local precio = tonumber(guiGridListGetItemText( gridConce, fila, 2))
		triggerServerEvent("comprarVehiculoPrestamo", getLocalPlayer(), getLocalPlayer(), tostring(model), tonumber(precio), tonumber(model2))
		cerrarGUIConce()
	elseif source == bConcePrev then
		local fila = guiGridListGetSelectedItem ( gridConce )
		if fila == -1 then 
			outputChatBox("Debes seleccionar primero un vehículo de la lista.", 255, 0, 0)
			return 
		end
		if vPrev and isElement(vPrev) then destroyElement(vPrev) end
		local model = tostring(guiGridListGetItemText( gridConce, fila, 1))
		local model2 = getVehicleModelFromName(model)
		vPrev = createVehicle(model2, 1779.1943359375, 112.126953125, 34.458763122559, 359.8681640625, 359.99450683594, 159.97192382812)
		outputChatBox("Estás previsualizando un "..tostring(model)..".", 0, 255, 0)
		outputChatBox("Puedes volver al punto para realizar la compra o ver otro vehículo.", 0, 255, 0)
	elseif source == bAyuda then
		cerrarGUIConce()
		triggerServerEvent("onEnviarDudaViaAsistencia", getLocalPlayer(), "No entiendo como funciona la compra de vehículos nuevos.")
		outputChatBox("Acabamos de mandar /duda por ti, espera a que un staff te atienda.", 0, 255, 0)
	end
end