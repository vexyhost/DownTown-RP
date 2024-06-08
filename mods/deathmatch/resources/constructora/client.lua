local intsReforma = {}
local precioInt
local tipoInt
local IDActualRef = 1

function ventanaReformaInit()
    vConstruccion = guiCreateWindow(624, 348, 700, 306, "Sistema de Construcción y Reformas - DownTown RolePlay", false)
    guiWindowSetSizable(vConstruccion, false)

    lInfoConstr = guiCreateLabel(24, 39, 629, 21, "Bienvenido al sistema de Construcción y Reformas de DownTown, por favor selecciona una opción.", false, vConstruccion)
    guiLabelSetHorizontalAlign(lInfoConstr, "center", false)
    rConsultarDatosInt = guiCreateRadioButton(100, 96, 440, 15, "Quiero consultar los datos del interior actual", false, vConstruccion)
    rSolReforma = guiCreateRadioButton(100, 121, 440, 15, "Quiero solicitar la reforma del interior en el que estoy", false, vConstruccion)
    rSolCreaHab = guiCreateRadioButton(100, 146, 440, 15, "Quiero solicitar la creación de una habitación en el interior en el que estoy", false, vConstruccion)
    rSolDelHab = guiCreateRadioButton(100, 171, 440, 15, "Quiero solicitar la eliminación de una habitación en el interior en el que estoy", false, vConstruccion)
    rCerrarVentana = guiCreateRadioButton(100, 196, 440, 15, "No quiero hacer nada, cierra esta ventana", false, vConstruccion)
    bContinuar = guiCreateButton(235, 238, 206, 34, "Continuar", false, vConstruccion)
	addEventHandler("onClientGUIClick", getRootElement(), regularVentanaReforma)
end
addEvent("onAbrirVentanaConstructora", true)
addEventHandler("onAbrirVentanaConstructora", getRootElement(), ventanaReformaInit)

function resetVentanaReformas()
	if isElement(rConsultarDatosInt) then
		destroyElement(lInfoConstr)
		destroyElement(rConsultarDatosInt)
		destroyElement(rSolReforma)
		destroyElement(rSolCreaHab)
		destroyElement(rSolDelHab)
		destroyElement(rCerrarVentana)
		destroyElement(bContinuar)
	elseif isElement(rRefCasa) then
		destroyElement(lInfoConstr)
		destroyElement(rRefCasa)
		destroyElement(rRefLocal)
		destroyElement(rRefHabOfi)
		destroyElement(rRefGara)
		destroyElement(rCerrarVentana)
		destroyElement(bContinuar)
	elseif isElement(bContinuarVR) then
		destroyElement(lInfoConstr)
		destroyElement(bPrevisualizarVR)
		destroyElement(bContinuarVR)
		destroyElement(lNombre)
		destroyElement(lPrecioBase)
		destroyElement(lTiempReforma)
		destroyElement(lPrecioFinal)
		destroyElement(lNombreE)
		destroyElement(lPrecioBaseE)
		destroyElement(lTiempReformaE)
		destroyElement(lPrecioFinalE)
		destroyElement(bAtras)
		destroyElement(bDelante)
	else
	
	end
end

function closeVentanaReformas()
	if isElement(vConstruccion) then
		destroyElement(vConstruccion)
		removeEventHandler("onClientGUIClick", getRootElement(), regularVentanaReforma)
	end
end

function regularVentanaReforma()
	if source == bContinuar then
		-- Petición desde ventana principal
		if guiRadioButtonGetSelected(rConsultarDatosInt) then
			triggerServerEvent("onRequestInfoInterior", getLocalPlayer())
			closeVentanaReformas()
		elseif guiRadioButtonGetSelected(rSolReforma) then
			resetVentanaReformas()
			triggerServerEvent("onSolicitarGUIReforma", getLocalPlayer())
		elseif guiRadioButtonGetSelected(rSolCreaHab) then
			resetVentanaReformas()
			triggerServerEvent("onSolicitarGUINuevaHab", getLocalPlayer())
		elseif guiRadioButtonGetSelected(rSolDelHab) then
			resetVentanaReformas()
			lInfoConstr = guiCreateLabel(24, 39, 629, 34, "Introduce el ID de la habitación a eliminar.\nSe solicitará la confirmación al dueño.", false, vConstruccion)
			guiLabelSetHorizontalAlign(lInfoConstr, "center", false)
			bFinalizar = guiCreateButton(249, 216, 206, 34, "Finalizar", false, vConstruccion)
			lNombre = guiCreateLabel(265, 84, 23, 15, "ID:", false, vConstruccion)
			checkOK = guiCreateCheckBox(97, 169, 14, 15, "", false, false, vConstruccion)
			lCheck = guiCreateLabel(121, 169, 524, 15, "Yo, como constructor, doy el visto bueno de la eliminación y me hago responsable de la misma", false, vConstruccion)
			eIDInt = guiCreateEdit(298, 84, 133, 18, "", false, vConstruccion)  
		elseif guiRadioButtonGetSelected(rCerrarVentana) then
			closeVentanaReformas()
		end
		-- Fin petición desde ventana principal
	elseif source == bPrevisualizarVR then
		local config_INT
		if tipoInt == 1 then
			config_INT = "house"..tostring(IDActualRef)
		elseif tipoInt == 2 then
			config_INT = "room"..tostring(IDActualRef)
		elseif tipoInt == 3 then
			config_INT = "garage"..tostring(IDActualRef)
		elseif tipoInt == 4 then
			config_INT = "local"..tostring(IDActualRef)
		elseif tipoInt == 5 then
			config_INT = "office"..tostring(IDActualRef)
		end
		guiSetEnabled(bPrevisualizarVR, false)
		setTimer(guiSetEnabled, 60000, 1, bPrevisualizarVR, true)
		triggerServerEvent("setInteriorRemote", getLocalPlayer(), getElementDimension(getLocalPlayer()), config_INT, 1)
	elseif source == bAtras or source == bDelante then
		local l_min = 1
		local l_max
		if tipoInt == 1 then
			l_max = 30
		elseif tipoInt == 2 then
			l_max = 6
		elseif tipoInt == 3 then
			l_max = 5
		elseif tipoInt == 4 then
			l_max = 21
		elseif tipoInt == 5 then
			l_max = 2
		end
		if source == bDelante then
			if IDActualRef == l_max then
				IDActualRef = l_min
			else
				IDActualRef = IDActualRef+1
			end
		elseif source == bAtras then
			if IDActualRef == l_min then
				IDActualRef = l_max
			else
				IDActualRef = IDActualRef-1
			end
		end
		actualizarVentanaReforma(IDActualRef)
	elseif source == bContinuarVR then
		-- Reutilizamos contenido ya creado.
		guiSetText(lInfoConstr, "Estos son los datos de la reforma a realizar.\nSe pedirá permiso al dueño del interior, si lo autoriza se te informará vía chat.")
        destroyElement(bContinuarVR)
		bCancelarVR = guiCreateButton(235, 200, 206, 34, "Cancelar", false, vConstruccion)
        bFinalizarVR = guiCreateButton(235, 238, 206, 34, "Finalizar", false, vConstruccion)
        checkOK = guiCreateCheckBox(103, 180, 14, 15, "", false, false, vConstruccion)
        lCheck = guiCreateLabel(127, 180, 488, 15, "Yo, como constructor, doy el visto bueno de la obra y me hago responsable de la misma", false, vConstruccion)
		--actualizarVentanaRefFinal()
	elseif source == bFinalizarVR then
		-- Enviamos todos los datos a server para que verifique todos los datos, localice al titular...
		if guiCheckBoxGetSelected(checkOK) then
			triggerServerEvent("requestReforma", getLocalPlayer(), getElementDimension(getLocalPlayer()), tipoInt, IDActualRef)
		else
			outputChatBox("Debes marcar la casilla de que das el visto bueno de la obra.", 255, 0, 0)
		end
	elseif source == bCancelarVR then
		closeVentanaReformas()
		outputChatBox("Has decidido cancelar la reforma.", 255, 0, 0)
	end
end

function ventanaReforma(tipo, ints_disponibles, precio_int)
	-- Actualizamos la ventana
    lInfoConstr = guiCreateLabel(24, 39, 635, 17, "Selecciona el interior con los botones izquierda y derecha, y pulsa continuar.", false, vConstruccion)
    guiLabelSetHorizontalAlign(lInfoConstr, "center", false)
	bPrevisualizarVR = guiCreateButton(235, 200, 206, 34, "Previsualizar", false, vConstruccion)
    bContinuarVR = guiCreateButton(235, 238, 206, 34, "Continuar", false, vConstruccion)
    lNombre = guiCreateLabel(186, 78, 53, 16, "Nombre:", false, vConstruccion)
    lPrecioBase = guiCreateLabel(186, 104, 72, 15, "Precio Base:", false, vConstruccion)
    lTiempReforma = guiCreateLabel(186, 129, 116, 16, "Tiempo en Reforma:", false, vConstruccion)
    lPrecioFinal = guiCreateLabel(186, 155, 116, 16, "Precio Final:", false, vConstruccion)
    lNombreE = guiCreateLabel(385, 78, 53, 16, "Casa 1", false, vConstruccion)
    guiLabelSetHorizontalAlign(lNombreE, "right", false)
    lPrecioBaseE = guiCreateLabel(366, 104, 72, 15, "25000", false, vConstruccion)
    guiLabelSetHorizontalAlign(lPrecioBaseE, "right", false)
    lTiempReformaE = guiCreateLabel(322, 129, 116, 16, "X dias", false, vConstruccion)
    guiLabelSetHorizontalAlign(lTiempReformaE, "right", false)
    lPrecioFinalE = guiCreateLabel(322, 155, 116, 16, "2500", false, vConstruccion)
    guiLabelSetHorizontalAlign(lPrecioFinalE, "right", false)
    bAtras = guiCreateButton(139, 238, 86, 34, "<", false, vConstruccion)
    bDelante = guiCreateButton(451, 238, 86, 34, ">", false, vConstruccion)
	-- Actualizamos valores recibidos por el servidor, en el cliente
	tipoInt = tipo
	intsReforma = ints_disponibles
	precioInt = precio_int
	IDActualRef = 1
	-- Llamamos a la function actualizarVentanaReforma(IDActualRef) para que cargue los datos con el 1.
	actualizarVentanaReforma(IDActualRef)
end
addEvent("onAbrirVentanaReforma", true)
addEventHandler("onAbrirVentanaReforma", getRootElement(), ventanaReforma)

function actualizarVentanaReforma(idCarga)
	if intsReforma[idCarga] then
		-- lNombreE
		if tipoInt == 1 then
			guiSetText(lNombreE, "Casa "..tostring(idCarga))
		elseif tipoInt == 2 then
			guiSetText(lNombreE, "Habitación "..tostring(idCarga))
		elseif tipoInt == 3 then
			guiSetText(lNombreE, "Garaje "..tostring(idCarga))
		elseif tipoInt == 4 then
			guiSetText(lNombreE, "Local "..tostring(idCarga))
		elseif tipoInt == 5 then
			guiSetText(lNombreE, "Oficina "..tostring(idCarga))
		end
		-- lPrecioBaseE
		guiSetText(lPrecioBaseE, tostring(intsReforma[idCarga].price))
		-- lTiempReformaE
		-- Cada 4k del precio base, 1 día OOC, y se redondea a la alta.
		guiSetText(lTiempReformaE, tostring(math.ceil(intsReforma[idCarga].price/4000)).. " días")
		-- lPrecioFinalE
		-- Lo suyo es que la constructora se lleve un 20% del coste del precio base.
		-- Y que se le reste la cantidad que se ha llevado.
		guiSetText(lPrecioFinalE, tostring((intsReforma[idCarga].price-precioInt)+intsReforma[idCarga].price*0.2))
	end
end

function ventanaSeleccionNuevoInt()
    --lInfoConstr = guiCreateLabel(24, 39, 635, 17, "Selecciona el interior con los botones izquierda y derecha, y pulsa continuar.", false, vConstruccion)
    --guiLabelSetHorizontalAlign(lInfoConstr, "center", false)
	bPrevisualizar = guiCreateButton(205, 238, 206, 34, "Previsualizar", false, vConstruccion)
    bContinuar = guiCreateButton(235, 238, 206, 34, "Continuar", false, vConstruccion)
    lNombre = guiCreateLabel(186, 78, 53, 16, "Nombre:", false, vConstruccion)
    lPrecioBase = guiCreateLabel(186, 104, 72, 15, "Precio Base:", false, vConstruccion)
    lTiempReforma = guiCreateLabel(186, 129, 116, 16, "Tiempo en Reforma:", false, vConstruccion)
    lPrecioFinal = guiCreateLabel(186, 155, 116, 16, "Precio Final:", false, vConstruccion)
    lNombreE = guiCreateLabel(385, 78, 53, 16, "Casa 1", false, vConstruccion)
    guiLabelSetHorizontalAlign(lNombreE, "right", false)
    lPrecioBaseE = guiCreateLabel(366, 104, 72, 15, "25000", false, vConstruccion)
    guiLabelSetHorizontalAlign(lPrecioBaseE, "right", false)
    lTiempReformaE = guiCreateLabel(322, 129, 116, 16, "X dias", false, vConstruccion)
    guiLabelSetHorizontalAlign(lTiempReformaE, "right", false)
    lPrecioFinalE = guiCreateLabel(322, 155, 116, 16, "2500", false, vConstruccion)
    guiLabelSetHorizontalAlign(lPrecioFinalE, "right", false)
    bAtras = guiCreateButton(139, 238, 86, 34, "<", false, vConstruccion)
    bDelante = guiCreateButton(451, 238, 86, 34, ">", false, vConstruccion)    
end


    function ventana4()
        vConstruccion = guiCreateWindow(624, 348, 700, 306, "Sistema de Construcción y Reformas - DownTown RolePlay", false)
        guiWindowSetSizable(vConstruccion, false)

    
    end



    function ventana5()
        vConstruccion = guiCreateWindow(624, 348, 700, 306, "Sistema de Construcción y Reformas - DownTown RolePlay", false)
        guiWindowSetSizable(vConstruccion, false)

  
    end
