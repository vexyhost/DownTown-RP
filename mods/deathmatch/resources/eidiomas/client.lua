local x, y = guiGetScreenSize()

function abrirVentanaIdiomas(idiomas, nivel_idiomas)
	triggerEvent("onCursor", getLocalPlayer())
	vIdiomas = guiCreateWindow(418*x/1366, 228*y/768, 520*x/1366, 326*y/768, "Escuela Oficial de Idiomas - DownTown RolePlay", false)
	guiWindowSetSizable(vIdiomas, false)

	lInfoIdi = guiCreateLabel(33*x/1366, 39*y/768, 454*x/1366, 33*y/768, "Selecciona el idioma que quieras aprender, cuesta 200 dólares / día, y sólo se puede 1 lección / día.", false, vIdiomas)
	guiLabelSetHorizontalAlign(lInfoIdi, "left", true)
	gridIdiomas = guiCreateGridList(32*x/1366, 82*y/768, 455*x/1366, 204*y/768, false, vIdiomas)
	guiGridListAddColumn(gridIdiomas, "Idioma", 0.45)
	guiGridListAddColumn(gridIdiomas, "Cód. Idioma", 0.15)
	guiGridListAddColumn(gridIdiomas, "Porcentaje", 0.35)
	for k, v in ipairs(idiomas) do
		local r = guiGridListAddRow(gridIdiomas)
		guiGridListSetItemText(gridIdiomas, r, 1, tostring(v[1]), false, false)
		guiGridListSetItemText(gridIdiomas, r, 2, tostring(v[2]), false, false)
		guiGridListSetItemText(gridIdiomas, r, 3, nivel_idiomas[tostring(v[2])]/10, false, false)
	end    
	bCerrarVentanaIdioma = guiCreateButton(35*x/1366, 291*y/768, 158*x/1366, 25*y/768, "Cerrar ventana", false, vIdiomas)
	bAprenderIdioma = guiCreateButton(329*x/1366, 291*y/768, 158*x/1366, 25*y/768, "Aprender idioma", false, vIdiomas)
	addEventHandler("onClientGUIClick", bCerrarVentanaIdioma, reguladorBotonIdiomas)
	addEventHandler("onClientGUIClick", bAprenderIdioma, reguladorBotonIdiomas)
end
addEvent("onSolicitarAbrirVentanaIdioma", true)
addEventHandler("onSolicitarAbrirVentanaIdioma", getRootElement(), abrirVentanaIdiomas)

function reguladorBotonIdiomas()
	if source == bCerrarVentanaIdioma then
		destroyElement(vIdiomas)
		triggerEvent("offCursor", getLocalPlayer())
		setElementData(getLocalPlayer(), "GUIeDI", nil)
	elseif source == bAprenderIdioma then
		local row = guiGridListGetSelectedItem ( gridIdiomas )
		if row > -1 then
			local idioma = guiGridListGetItemText(gridIdiomas, row, 2)
			local porcentaje = guiGridListGetItemText(gridIdiomas, row, 3)
			local idioma2 = guiGridListGetItemText(gridIdiomas, row, 1)
			if tostring(porcentaje) == "100" then
				outputChatBox("¡Ya sabes este idioma!", 255, 0, 0)
				return
			else
				triggerServerEvent("onAprenderIdioma", getLocalPlayer(), idioma, tonumber(porcentaje)*10, idioma2)
				destroyElement(vIdiomas)
				triggerEvent("offCursor", getLocalPlayer())
				setElementData(getLocalPlayer(), "GUIeDI", nil)
			end
		else
			outputChatBox("¡Selecciona primero un idioma!", 255, 0, 0)
		end
	end
end