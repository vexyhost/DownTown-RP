function ventanaPrincipal(sql1, sql2, sql3, sql4, sql5)
	local screenW, screenH = guiGetScreenSize()
	setElementData(getLocalPlayer(), "GUIPol", true)
	showCursor(true)
    GUIPolicial = guiCreateWindow((screenW - 1075) / 2, (screenH - 665) / 2, 1075, 665, "Panel Policial - Red County Sheriff Department", false)
    guiWindowSetSizable(GUIPolicial, false)

    tabpanel = guiCreateTabPanel(51, 59, 979, 569, false, GUIPolicial)
--[[
    tabconsultas = guiCreateTab("Servicio de consultas", tabpanel)

    lmatriculas = guiCreateLabel(34, 34, 411, 49, "Consulta de matrículas", false, tabconsultas)
    guiSetFont(lmatriculas, "sa-header")
    ematriculas = guiCreateEdit(445, 44, 322, 29, "", false, tabconsultas)
    ltelefonos = guiCreateLabel(34, 104, 411, 49, "Consulta de teléfonos", false, tabconsultas)
    guiSetFont(ltelefonos, "sa-header")
    etelefonos = guiCreateEdit(445, 114, 322, 29, "", false, tabconsultas)
    lnombres = guiCreateLabel(34, 176, 411, 49, "Consulta de nombres", false, tabconsultas)
    guiSetFont(lnombres, "sa-header")
    enombres = guiCreateEdit(445, 186, 322, 29, "", false, tabconsultas)
    bconsultar = guiCreateButton(793, 46, 176, 164, "Consultar", false, tabconsultas)
]]
		tabordenes = guiCreateTab("Órdenes de búsqueda", tabpanel)

		gridordenes = guiCreateGridList(29, 16, 916, 427, false, tabordenes)
		guiGridListAddColumn(gridordenes, "Orden Nº", 0.05)
        guiGridListAddColumn(gridordenes, "Nombre/Matrícula buscados", 0.2)
        guiGridListAddColumn(gridordenes, "Estado", 0.1)
        guiGridListAddColumn(gridordenes, "Agente emisor", 0.15)
        guiGridListAddColumn(gridordenes, "Razon", 0.3)
		guiGridListAddColumn(gridordenes, "Fecha", 0.15)
		for k, v in ipairs(sql1) do
		    local r = guiGridListAddRow(gridordenes)
			guiGridListSetItemText(gridordenes, r, 1, tostring(v.ordenID), false, false)
			guiGridListSetItemText(gridordenes, r, 2, tostring(v.nombre), false, false)
			guiGridListSetItemText(gridordenes, r, 3, tostring(v.estado), false, false)
			if tostring(v.estado) == "Activa" then
				guiGridListSetItemColor(gridordenes, r, 3, 0, 255, 0)
			elseif tostring(v.estado) == "Urgente" then
				guiGridListSetItemColor(gridordenes, r, 3, 255, 255, 0)
			elseif tostring(v.estado) == "Suspendida" then
				guiGridListSetItemColor(gridordenes, r, 3, 255, 0, 0)
			elseif tostring(v.estado) == "Eliminada" then
				guiGridListSetItemColor(gridordenes, r, 3, 0, 0, 255)
			else
				guiGridListRemoveRow(gridordenes, r)
			end
			guiGridListSetItemText(gridordenes, r, 4, tostring(v.agente), false, false)
			guiGridListSetItemText(gridordenes, r, 5, tostring(v.razon), false, false)
			guiGridListSetItemText(gridordenes, r, 6, tostring(v.fecha), false, false)
		end
        bnuevaorden = guiCreateButton(188, 467, 179, 48, "Nueva orden", false, tabordenes)
        bmodiforden = guiCreateButton(402, 467, 179, 48, "Modificar orden", false, tabordenes)
        beliminorden = guiCreateButton(616, 467, 179, 48, "Eliminar orden", false, tabordenes)
		
		-- NUEVO TAB: VEHICULOS ROBADOS --
		tabvehrobados = guiCreateTab("Vehículos robados", tabpanel)
		
		gridrobados = guiCreateGridList(29, 16, 916, 467, false, tabvehrobados)
		guiGridListAddColumn(gridrobados, "Denuncia Nº", 0.33) 
		guiGridListAddColumn(gridrobados, "Matrícula", 0.33)
        guiGridListAddColumn(gridrobados, "Modelo", 0.33)
		--guiGridListAddColumn(gridrobados, "Fecha", 0.2)
		
		-- FIN VEHICULOS ROBADOS --

        tabarrestos = guiCreateTab("Historiales de arresto", tabpanel)
		
		gridarrestos = guiCreateGridList(29, 16, 916, 427, false, tabarrestos)
		guiGridListAddColumn(gridarrestos, "Histor. Nº", 0.06)
        guiGridListAddColumn(gridarrestos, "Nombre", 0.12)
        guiGridListAddColumn(gridarrestos, "DNI", 0.09)
        guiGridListAddColumn(gridarrestos, "Residencia", 0.15)
        guiGridListAddColumn(gridarrestos, "Profesion", 0.1)
		guiGridListAddColumn(gridarrestos, "Delitos", 0.3)
		guiGridListAddColumn(gridarrestos, "Agente emisor", 0.12)

        -- bnuevohistorial = guiCreateButton(296, 467, 179, 48, "Añadir historial", false, tabarrestos)
        -- bmodifhistorial = guiCreateButton(511, 467, 179, 48, "Modificar historial", false, tabarrestos)
		
		tabdepositos = guiCreateTab("Archivo del depósito", tabpanel)
		
		griddepositos = guiCreateGridList(29, 16, 916, 427, false, tabdepositos)
		guiGridListAddColumn(griddepositos, "Depo. Nº", 0.04)
        guiGridListAddColumn(griddepositos, "ID vehiculo", 0.04)
        guiGridListAddColumn(griddepositos, "Modelo", 0.08)
        guiGridListAddColumn(griddepositos, "Color", 0.08)
        guiGridListAddColumn(griddepositos, "Propietario", 0.1)
		guiGridListAddColumn(griddepositos, "Razon", 0.28)
		guiGridListAddColumn(griddepositos, "Estado", 0.1)
		guiGridListAddColumn(griddepositos, "Agente", 0.1)
		guiGridListAddColumn(griddepositos, "Fecha", 0.15)
		
        --bnuevodep = guiCreateButton(296, 467, 179, 48, "Añadir informe (/cepo)", false, tabdepositos)
		--guiSetEnabled ( bnuevodep, false )
        bretirdep = guiCreateButton(511, 467, 179, 48, "Retirar vehículo", false, tabdepositos)
		 
		 
		tabmultas = guiCreateTab("Registro de Multas", tabpanel)
		
		gridmultas = guiCreateGridList(29, 16, 916, 427, false, tabmultas)
		guiGridListAddColumn(gridmultas, "Multa Nº", 0.1)
        guiGridListAddColumn(gridmultas, "Agente", 0.15)
        guiGridListAddColumn(gridmultas, "DNI Sancionado", 0.1)
        guiGridListAddColumn(gridmultas, "Cantidad", 0.1)
        guiGridListAddColumn(gridmultas, "Razon", 0.3)
		guiGridListAddColumn(gridmultas, "Fecha", 0.15)
		
		tablicenciasarmas = guiCreateTab("Licencias de Armas", tabpanel)
		
		gridarmas = guiCreateGridList(29, 16, 916, 427, false, tablicenciasarmas)
		guiGridListAddColumn(gridarmas, "Licencia Nº", 0.05)
        guiGridListAddColumn(gridarmas, "Agente Judicial", 0.15)
        guiGridListAddColumn(gridarmas, "Nombre Titular", 0.15)
        guiGridListAddColumn(gridarmas, "Tipo Arma", 0.1)
        guiGridListAddColumn(gridarmas, "Coste", 0.15)
		guiGridListAddColumn(gridarmas, "Fecha", 0.15)
		guiGridListAddColumn(gridarmas, "Estado", 0.15)

        info = guiCreateLabel(597, 24, 182, 25, "Usuario: "..getPlayerName(getLocalPlayer()):gsub("_", " "), false, GUIPolicial)
        bcerrar = guiCreateButton(955, 25, 110, 44, "Cerrar", false, GUIPolicial)
		addEventHandler("onClientGUIClick", getRootElement(), botonPulsado)
end
addEvent("onVentanaPolicial", true)
addEventHandler("onVentanaPolicial", getLocalPlayer(), ventanaPrincipal)

function botonPulsado ()
	if source == bcerrar then
		guiGridListClear(gridordenes)
		guiGridListClear(gridarrestos)
		guiGridListClear(griddepositos)
		guiGridListClear(gridrobados)
		guiGridListClear(gridmultas)
		guiGridListClear(gridarmas)
		showCursor(false)
		destroyElement(GUIPolicial)
		setElementData(getLocalPlayer(), "GUIPol", false)
		setElementData(getLocalPlayer(), "nogui", false)
		toggleAllControls(true)
		removeEventHandler("onClientGUIClick", getRootElement(), botonPulsado)
	elseif source == bcancelar then
		destroyElement(GUINuevaOrden)
	elseif source == bnuevodep then
		nuevoDeposito()
	elseif source == beliminorden then
		eliminarOrden()
	elseif source == bnuevaorden then
		nuevaOrden()
	elseif source == bnuevohistorial then
		nuevoArresto()
	elseif source == bmodifhistorial then
		modArresto()
	elseif source == bcancelim then
		destroyElement(GUIElimOrden)
	elseif source == bcancelar3a then
		destroyElement(GUIModHistorialA)
	elseif source == bemitir then
		local nm = guiGetText(enm)
		local razon = guiGetText(erazon)
		triggerServerEvent("onOrdenBusqueda", getLocalPlayer(), tostring(nm), tostring(razon))
		destroyElement(GUINuevaOrden)
	elseif source == bcancmod then
		destroyElement(GUICambiarEstado)
	elseif source == bmodiforden then
		modOrden()
	elseif source == bsomod then
		local nm1 = tostring ( guiComboBoxGetItemText ( enm2 , guiComboBoxGetSelected ( enm2 ) ) )
		local razon1 = guiGetText(erazon2)
		local row = guiGridListGetSelectedItem ( gridordenes )
		local ordenID = guiGridListGetItemText ( gridordenes, row, 1 )
		triggerServerEvent("onModificarOrdenBusqueda", getLocalPlayer(), tostring(nm1), tostring(razon1), tostring(ordenID))
		destroyElement(GUICambiarEstado)
	elseif source == bcancelar3 then
		destroyElement(GUIHistorialArresto)
	elseif source == benviarhistoriala then
		local nm = guiGetText(enom)
		local dni = guiGetText(edni)
		local resi = guiGetText(eresid)
		local prof = guiGetText(eprof)
		local delitos = guiGetText(edelit)
		triggerServerEvent("onHistorialArrestos", getLocalPlayer(), tostring(nm), tostring(dni), tostring(resi), tostring(prof), tostring(delitos))
		destroyElement(GUIHistorialArresto)
	elseif source == benviarhistorialmod then
		local resi = guiGetText(eresid2)
		local prof = guiGetText(eprof2)
		local delitos = guiGetText(edelit2)
		local row = guiGridListGetSelectedItem ( gridarrestos )
		local historialID = guiGridListGetItemText ( gridarrestos, row, 1 )
		triggerServerEvent("onModificarHA", getLocalPlayer(), tostring(historialID), tostring(resi), tostring(prof), tostring(delitos))
		destroyElement(GUIModHistorialA)
	elseif source == bcancelar4a then
		destroyElement(GUIHistorialDeposito)
	elseif source == benviarhistorial then
		local idv = guiGetText(eidveh)
		local modelo = guiGetText(emodelo)
		local color = guiGetText(ecolor)
		local prop = guiGetText(eprop)
		local razon = guiGetText(erazonA)
		triggerServerEvent("onHistorialDeposito", getLocalPlayer(), tostring(idv), tostring(modelo), tostring(color), tostring(prop), tostring(razon))
		destroyElement(GUIHistorialDeposito)
	elseif source == bconfelim then
		local row = guiGridListGetSelectedItem ( gridordenes )
		local ordenID = guiGridListGetItemText ( gridordenes, row, 1 )
		triggerServerEvent("onEliminarOrden", getLocalPlayer(), tostring(ordenID))
		destroyElement(GUIElimOrden)
	elseif source == bcancret then
		destroyElement(GUIRetVeh)
	elseif source == bconfret then
		local row = guiGridListGetSelectedItem ( griddepositos )
		local depositoID = guiGridListGetItemText ( griddepositos, row, 1 )
		local vehicleID = guiGridListGetItemText ( griddepositos, row, 2 )
		local estado = guiGridListGetItemText ( griddepositos, row, 7 )
		if not string.find(estado, "etir") then -- Vehículo no retirado
			triggerServerEvent("onRetirarVehiculo", getLocalPlayer(), tostring(depositoID), tostring(vehicleID))
			guiGridListSetItemText(griddepositos, row, 7, "Retirado", false, false)
		end
		destroyElement(GUIRetVeh)
	elseif source == bretirdep then
		retirarVehiculo()
	elseif source == tabpanel then
		local tab = guiGetSelectedTab(tabpanel)
		if tab == tabordenes then -- 1
			code = 1
		elseif tab == tabarrestos then -- 2
			code = 2
		elseif tab == tabdepositos then -- 3
			code = 3
		elseif tab == tabvehrobados then -- 4
			code = 4
		elseif tab == tabmultas then -- 5
			code = 5
		elseif tab == tablicenciasarmas then -- 6
			code = 6
		end
		triggerServerEvent("onSolicitarDatosPanel", getLocalPlayer(), code)
		outputChatBox("Espere por favor, cargando datos...", 0, 255, 0)
	end
end
         
function aplicarDatos(code, consulta, consulta2)
	guiGridListClear(gridordenes)
	guiGridListClear(gridarrestos)
	guiGridListClear(griddepositos)
	guiGridListClear(gridrobados)
	guiGridListClear(gridmultas)
	guiGridListClear(gridarmas)
	if code == 1 then -- Órdenes
		for k, v in ipairs(consulta) do
		    local r = guiGridListAddRow(gridordenes)
			guiGridListSetItemText(gridordenes, r, 1, tostring(v.ordenID), false, true)
			guiGridListSetItemText(gridordenes, r, 2, tostring(v.nombre), false, false)
			guiGridListSetItemText(gridordenes, r, 3, tostring(v.estado), false, false)
			if tostring(v.estado) == "Activa" then
				guiGridListSetItemColor(gridordenes, r, 3, 0, 255, 0)
			elseif tostring(v.estado) == "Urgente" then
				guiGridListSetItemColor(gridordenes, r, 3, 255, 255, 0)
			elseif tostring(v.estado) == "Suspendida" then
				guiGridListSetItemColor(gridordenes, r, 3, 255, 0, 0)
			elseif tostring(v.estado) == "Eliminada" then
				guiGridListSetItemColor(gridordenes, r, 3, 0, 0, 255)
			else
				guiGridListRemoveRow(gridordenes, r)
			end
			guiGridListSetItemText(gridordenes, r, 4, tostring(v.agente), false, false)
			guiGridListSetItemText(gridordenes, r, 5, tostring(v.razon), false, false)
			guiGridListSetItemText(gridordenes, r, 6, tostring(v.fecha), false, false)
		end
	elseif code == 2 then -- Arrestos
		for k, v in ipairs(consulta) do
		    local r = guiGridListAddRow(gridarrestos)
			guiGridListSetItemText(gridarrestos, r, 1, tostring(v.historialID), false, true)
			guiGridListSetItemText(gridarrestos, r, 2, tostring(v.nombre), false, false)
			guiGridListSetItemText(gridarrestos, r, 3, tostring(v.dni), false, true)
			guiGridListSetItemText(gridarrestos, r, 4, tostring(v.residencia), false, false)
			guiGridListSetItemText(gridarrestos, r, 5, tostring(v.profesion), false, false)
			guiGridListSetItemText(gridarrestos, r, 6, tostring(v.delitos), false, false)
			guiGridListSetItemText(gridarrestos, r, 7, tostring(v.agente), false, false)
		end
	elseif code == 3 then -- Deposito
		for k, v in ipairs(consulta) do
		    local r = guiGridListAddRow(griddepositos)
			guiGridListSetItemText(griddepositos, r, 1, tostring(v.depositoID), false, true)
			guiGridListSetItemText(griddepositos, r, 2, tostring(v.vehicleID), false, true)
			guiGridListSetItemText(griddepositos, r, 3, tostring(v.modelo), false, false)
			guiGridListSetItemText(griddepositos, r, 4, tostring(v.color), false, false)
			guiGridListSetItemText(griddepositos, r, 5, tostring(v.propietario), false, false)
			guiGridListSetItemText(griddepositos, r, 6, tostring(v.razon), false, false)
			guiGridListSetItemText(griddepositos, r, 7, tostring(v.estado), false, false)
			if tostring(v.estado) == "En deposito" then
				guiGridListSetItemColor(griddepositos, r, 7, 255, 0, 0)
			else
				guiGridListSetItemColor(griddepositos, r, 7, 0, 255, 0)
			end
			guiGridListSetItemText(griddepositos, r, 8, tostring(v.agente), false, false)
			guiGridListSetItemText(griddepositos, r, 9, tostring(v.fecha), false, false)
		end
	elseif code == 4 then -- Vehiculos robados
		for k, v in ipairs(consulta) do
			if v then
				local r = guiGridListAddRow(gridrobados)
				guiGridListSetItemText(gridrobados, r, 1, tostring(v.roboID), false, true)
				guiGridListSetItemText(gridrobados, r, 2, tostring(v.objetoID), false, true)
				guiGridListSetItemText(gridrobados, r, 3, tostring(getVehicleNameFromModel(v.model)) , false, false)
				--guiGridListSetItemText(gridrobados, r, 4, tostring(v.fecha), false, false)
			end
		end
	elseif code == 5 then -- Multas
		for k, v in ipairs(consulta) do
		    local r = guiGridListAddRow(gridmultas)
			guiGridListSetItemText(gridmultas, r, 1, tostring(v.ind), false, true)
			guiGridListSetItemText(gridmultas, r, 2, tostring(v.agente), false, false)
			guiGridListSetItemText(gridmultas, r, 3, tostring(v.characterID+20000000), false, true)
			guiGridListSetItemText(gridmultas, r, 4, tostring(v.cantidad), false, false)
			guiGridListSetItemText(gridmultas, r, 5, tostring(v.razon), false, false)
			guiGridListSetItemText(gridmultas, r, 6, tostring(v.fecha), false, false)
		end
	elseif code == 6 then -- Licencias                   
		for k, v in ipairs(consulta) do
		    local r = guiGridListAddRow(gridarmas)
			guiGridListSetItemText(gridarmas, r, 1, tostring(v.licenciaID), false, true)
			guiGridListSetItemText(gridarmas, r, 2, tostring(consulta2[tonumber(v.cIDJusticia)]), false, false)
			guiGridListSetItemText(gridarmas, r, 3, tostring(consulta2[tonumber(v.cID)]), false, false)
			guiGridListSetItemText(gridarmas, r, 4, tostring(getWeaponNameFromID(tonumber(v.weapon)).." - "..tostring(v.weapon)), false, false)
			guiGridListSetItemText(gridarmas, r, 5, tostring(v.cost), false, false)
			guiGridListSetItemText(gridarmas, r, 6, tostring(v.time), false, false)
			if tonumber(v.status) == 0 then
				guiGridListSetItemText(gridarmas, r, 7, "Válida", false, false)
				guiGridListSetItemColor(gridarmas, r, 7, 0, 255, 0)
			else
				guiGridListSetItemText(gridarmas, r, 7, "Anulada ("..tostring(consulta2[tonumber(v.cIDJusticiaNull)])..")", false, false)
				guiGridListSetItemColor(gridarmas, r, 7, 255, 0, 0)
			end
		end
	end	
end
addEvent("onEnviarDatosPanel", true)
addEventHandler("onEnviarDatosPanel", getRootElement(), aplicarDatos)

function nuevaOrden()
	local screenW, screenH = guiGetScreenSize()
    GUINuevaOrden = guiCreateWindow((screenW - 256) / 2, (screenH - 268) / 2, 256, 268, "Nueva orden de búsqueda", false)
    guiWindowSetSizable(GUINuevaOrden, false)

    lnm = guiCreateLabel(10, 49, 236, 16, "Nombre o Matrícula", false, GUINuevaOrden)
    guiLabelSetHorizontalAlign(lnm, "center", false)
    enm = guiCreateEdit(22, 76, 214, 23, "", false, GUINuevaOrden)
    lrazon = guiCreateLabel(10, 109, 236, 16, "Razón", false, GUINuevaOrden)
    guiLabelSetHorizontalAlign(lrazon, "center", false)
    erazon = guiCreateEdit(22, 135, 214, 23, "", false, GUINuevaOrden)
    bemitir = guiCreateButton(34, 219, 192, 35, "Emitir orden", false, GUINuevaOrden)
    bcancelar = guiCreateButton(34, 174, 192, 35, "Cancelar", false, GUINuevaOrden)    
end

function eliminarOrden()
	local screenW, screenH = guiGetScreenSize()
    GUIElimOrden = guiCreateWindow((screenW - 397) / 2, (screenH - 120) / 2, 397, 120, "Eliminar orden de búsqueda", false)
    guiWindowSetSizable(GUIElimOrden, false)
		lal2 = guiCreateLabel(16, 40, 377, 15, "ATENCIÓN: ¿Estás seguro de eliminar la orden seleccionada?\n Esta acción no se podrá deshacer.", false, GUIElimOrden)
		guiLabelSetHorizontalAlign(lal2, "center", false)
		guiLabelSetColor(lal2, 255, 0, 0)
    bconfelim = guiCreateButton(218, 75, 162, 39, "Eliminar orden", false, GUIElimOrden)
    bcancelim = guiCreateButton(26, 75, 162, 39, "Cancelar", false, GUIElimOrden)    
end

function guiComboBoxAdjustHeight ( combobox, itemcount )
    if getElementType ( combobox ) ~= "gui-combobox" or type ( itemcount ) ~= "number" then error ( "Invalid arguments @ 'guiComboBoxAdjustHeight'", 2 ) end
    local width = guiGetSize ( combobox, false )
    return guiSetSize ( combobox, width, ( itemcount * 20 ) + 20, false )
end


function modOrden()
		local screenW, screenH = guiGetScreenSize()
        GUICambiarEstado = guiCreateWindow((screenW - 256) / 2, (screenH - 268) / 2, 256, 268, "Modificar orden de búsqueda", false)
        guiWindowSetSizable(GUICambiarEstado, false)

        lnm2 = guiCreateLabel(10, 49, 236, 16, "Seleccionar estado", false, GUICambiarEstado)
        guiLabelSetHorizontalAlign(lnm2, "center", false)
        enm2 = guiCreateComboBox(22, 76, 214, 23, "", false, GUICambiarEstado)
		guiComboBoxAdjustHeight(enm2, 3)
		guiComboBoxAddItem(enm2, "Urgente")
		guiComboBoxAddItem(enm2, "Activa")
		guiComboBoxAddItem(enm2, "Suspendida")
		guiComboBoxSetSelected(enm2, 1)
        lrazon2 = guiCreateLabel(10, 109, 236, 16, "Razón", false, GUICambiarEstado)
        guiLabelSetHorizontalAlign(lrazon2, "center", false)
		local row1 = guiGridListGetSelectedItem ( gridordenes )
		local razonA = tostring(guiGridListGetItemText ( gridordenes, row1, 5 ))
        erazon2 = guiCreateEdit(22, 135, 214, 23, tostring(razonA), false, GUICambiarEstado)
        bsomod = guiCreateButton(34, 219, 192, 35, "Solicitar modificación", false, GUICambiarEstado)
        bcancmod = guiCreateButton(34, 174, 192, 35, "Cancelar", false, GUICambiarEstado)    
end

function nuevoArresto()
		local screenW, screenH = guiGetScreenSize()
        GUIHistorialArresto = guiCreateWindow((screenW - 397) / 2, (screenH - 383) / 2, 397, 383, "Nuevo historial de arrestos", false)
        guiWindowSetSizable(GUIHistorialArresto, false)

        lnom = guiCreateLabel(16, 28, 377, 15, "Nombre", false, GUIHistorialArresto)
        guiLabelSetHorizontalAlign(lnom, "center", false)
        
        ldni = guiCreateLabel(16, 83, 377, 15, "DNI", false, GUIHistorialArresto)
        guiLabelSetHorizontalAlign(ldni, "center", false)
		
        lresidencia = guiCreateLabel(16, 138, 377, 15, "Residencia", false, GUIHistorialArresto)
        guiLabelSetHorizontalAlign(lresidencia, "center", false)
		
        lprof = guiCreateLabel(16, 193, 377, 15, "Profesion", false, GUIHistorialArresto)
        guiLabelSetHorizontalAlign(lprof, "center", false)
		
        ldelit = guiCreateLabel(16, 248, 377, 15, "Delitos", false, GUIHistorialArresto)
        guiLabelSetHorizontalAlign(ldelit, "center", false)
		
		lal = guiCreateLabel(16, 350, 377, 15, "ATENCIÓN: El nombre y el DNI NO se podrá modificar.", false, GUIHistorialArresto)
		guiLabelSetHorizontalAlign(lal, "center", false)
		guiLabelSetColor(lal, 255, 0, 0)
		
		enom = guiCreateEdit(26, 53, 354, 20, "", false, GUIHistorialArresto)
        edni = guiCreateEdit(26, 108, 354, 20, "", false, GUIHistorialArresto)
        eresid = guiCreateEdit(26, 163, 354, 20, "", false, GUIHistorialArresto)
        eprof = guiCreateEdit(26, 218, 354, 20, "", false, GUIHistorialArresto)
        edelit = guiCreateEdit(26, 273, 354, 20, "", false, GUIHistorialArresto)
        benviarhistoriala = guiCreateButton(218, 308, 162, 39, "Enviar", false, GUIHistorialArresto)
        bcancelar3 = guiCreateButton(26, 308, 162, 39, "Cancelar", false, GUIHistorialArresto)    
end


function modArresto()
		local screenW, screenH = guiGetScreenSize()
        GUIModHistorialA = guiCreateWindow((screenW - 397) / 2, (screenH - 363) / 2, 397, 383, "Modificar historial de arrestos", false)
        guiWindowSetSizable(GUIModHistorialA, false)
		local row = guiGridListGetSelectedItem ( gridarrestos )

        lnom = guiCreateLabel(16, 28, 377, 15, "Nombre", false, GUIModHistorialA)
        guiLabelSetHorizontalAlign(lnom, "center", false)
        
        ldni = guiCreateLabel(16, 83, 377, 15, "DNI", false, GUIModHistorialA)
        guiLabelSetHorizontalAlign(ldni, "center", false)
		
        lresidencia = guiCreateLabel(16, 138, 377, 15, "Residencia", false, GUIModHistorialA)
        guiLabelSetHorizontalAlign(lresidencia, "center", false)
		
        lprof = guiCreateLabel(16, 193, 377, 15, "Profesion", false, GUIModHistorialA)
        guiLabelSetHorizontalAlign(lprof, "center", false)
		
        ldelit = guiCreateLabel(16, 248, 377, 15, "Delitos", false, GUIModHistorialA)
        guiLabelSetHorizontalAlign(ldelit, "center", false)
		
		lal = guiCreateLabel(16, 350, 377, 15, "ATENCIÓN: El nombre y el DNI NO se puede modificar.", false, GUIModHistorialA)
		guiLabelSetHorizontalAlign(lal, "center", false)
		guiLabelSetColor(lal, 255, 0, 0)
		
		enom = guiCreateEdit(26, 53, 354, 20, tostring(guiGridListGetItemText ( gridarrestos, row, 2 )), false, GUIModHistorialA)
		guiSetProperty( enom, "Disabled", "True" )
        edni = guiCreateEdit(26, 108, 354, 20, tostring(guiGridListGetItemText ( gridarrestos, row, 3 )), false, GUIModHistorialA)
		guiSetProperty( edni, "Disabled", "True" )
        eresid2 = guiCreateEdit(26, 163, 354, 20, tostring(guiGridListGetItemText ( gridarrestos, row, 4 )), false, GUIModHistorialA)
        eprof2 = guiCreateEdit(26, 218, 354, 20, tostring(guiGridListGetItemText ( gridarrestos, row, 5 )), false, GUIModHistorialA)
        edelit2 = guiCreateEdit(26, 273, 354, 20, tostring(guiGridListGetItemText ( gridarrestos, row, 6 )), false, GUIModHistorialA)
        benviarhistorialmod = guiCreateButton(218, 308, 162, 39, "Enviar", false, GUIModHistorialA)
        bcancelar3a = guiCreateButton(26, 308, 162, 39, "Cancelar", false, GUIModHistorialA)    
end
-- NUEVO DEPOSITO


function nuevoDeposito()
	local screenW, screenH = guiGetScreenSize()
        GUIHistorialDeposito = guiCreateWindow((screenW - 397) / 2, (screenH - 363) / 2, 397, 383, "Nuevo historial del depósito", false)
        guiWindowSetSizable(GUIHistorialDeposito, false)

		lid = guiCreateLabel(16, 28, 377, 15, "ID del vehículo", false, GUIHistorialDeposito)
        guiLabelSetHorizontalAlign(lid, "center", false)
		
		lmodelo = guiCreateLabel(16, 83, 377, 15, "Modelo", false, GUIHistorialDeposito)
        guiLabelSetHorizontalAlign(lmodelo, "center", false)
		
		lcolor = guiCreateLabel(16, 138, 377, 15, "Color", false, GUIHistorialDeposito)
        guiLabelSetHorizontalAlign(lcolor, "center", false)
		
		lpropietario = guiCreateLabel(16, 193, 377, 15, "Propietario", false, GUIHistorialDeposito)
        guiLabelSetHorizontalAlign(lpropietario, "center", false)
		
        lrazon = guiCreateLabel(16, 248, 377, 15, "Razón", false, GUIHistorialDeposito)
        guiLabelSetHorizontalAlign(lrazon, "center", false)  
		
        	
		eidveh = guiCreateEdit(26, 53, 354, 20, "", false, GUIHistorialDeposito)
		emodelo = guiCreateEdit(26, 108, 354, 20, "", false, GUIHistorialDeposito)
		ecolor = guiCreateEdit(26, 163, 354, 20, "", false, GUIHistorialDeposito)
		eprop = guiCreateEdit(26, 218, 354, 20, "", false, GUIHistorialDeposito)
		erazonA = guiCreateEdit(26, 273, 354, 20, "", false, GUIHistorialDeposito)
		
        benviarhistorial = guiCreateButton(218, 308, 162, 39, "Enviar", false, GUIHistorialDeposito)
        bcancelar4a = guiCreateButton(26, 308, 162, 39, "Cancelar", false, GUIHistorialDeposito)  

		infol = guiCreateLabel(16, 350, 377, 15, "ATENCIÓN: Los historiales de depósito NO se pueden modificar.", false, GUIHistorialDeposito)
		guiLabelSetHorizontalAlign(infol, "center", false)
		guiLabelSetColor(infol, 255, 0, 0)
end

function retirarVehiculo()
	local screenW, screenH = guiGetScreenSize()
    GUIRetVeh = guiCreateWindow((screenW - 397) / 2, (screenH - 120) / 2, 397, 120, "Retirar vehículo del depósito", false)
    guiWindowSetSizable(GUIRetVeh, false)
	lal2 = guiCreateLabel(16, 40, 377, 15, "ATENCIÓN: ¿Estás seguro de retirar el vehículo seleccionado?\n Esta acción no se podrá deshacer.", false, GUIRetVeh)
	guiLabelSetHorizontalAlign(lal2, "center", false)
	guiLabelSetColor(lal2, 255, 0, 0)
    bconfret = guiCreateButton(218, 75, 162, 39, "Retirar vehículo", false, GUIRetVeh)
    bcancret = guiCreateButton(26, 75, 162, 39, "Cancelar", false, GUIRetVeh)    
end


function hacerFuego(x, y, z) 
    createFire(x, y, z, 25)
end
addEvent("onCreateFireDCRP", true)
addEventHandler("onCreateFireDCRP", getRootElement(), hacerFuego)