catVeh = {
	[1] = {"Casas/Viviendas", 1},
	[2] = {"Locales/Negocios", 2}
}

function abrirGUIConcesionario(sql)
	showCursor(true)
    ventana = guiCreateWindow(431, 215, 429, 455, "Interiores a la venta - DownTown RolePlay", false)
    guiWindowSetSizable(ventana, false)
    listatodos = guiCreateGridList(30, 44, 245, 387, false, ventana)
    guiGridListAddColumn(listatodos, "ID", 0.2)
	guiGridListAddColumn(listatodos, "Nombre", 0.5)
    guiGridListAddColumn(listatodos, "Precio", 0.2) 
	rAct = 0 
	sigCat = 0
	-- Categoría --
	for i = 1, 2 do
		guiGridListAddRow(listatodos)
		if sigCat == 1 then 
			rAct = rAct + 1
			sigCat = 0
		end
		guiGridListSetItemText(listatodos, rAct, 2, tostring(catVeh[i][1]), false, false)
		guiGridListSetItemColor(listatodos, rAct, 2, 0, 255, 0)
		for k, v in ipairs(sql) do
			if tonumber(v.interiorType) == tonumber(i) then  
				rAct = (rAct+1)
				guiGridListAddRow(listatodos)
				guiGridListSetItemText(listatodos, rAct, 1, tostring(v.interiorID), false, false)
				guiGridListSetItemText(listatodos, rAct, 2, tostring(v.interiorName), false, false)
				guiGridListSetItemText(listatodos, rAct, 3, tostring(v.interiorPrice), false, false)
			end
			sigCat = 1
		end
	end
	-- Fin Categoría --
	botonmarcar = guiCreateButton(300, 290, 119, 56, "Marcar Posición", false, ventana)
	addEventHandler('onClientGUIClick', botonmarcar, regularBotonGUI)
	botoncerrar = guiCreateButton(300, 375, 119, 56, "Cerrar", false, ventana)
	addEventHandler('onClientGUIClick', botoncerrar, regularBotonGUI)
	precio = guiCreateLabel(257, 88, 152, 21, "", false, ventana)    
end
addEvent("abririnmo", true)    
addEventHandler("abririnmo", root, abrirGUIConcesionario)

function regularBotonGUI ()
	if source == botonmarcar or source == botoncerrar then
		seleccion = guiGridListGetSelectedItem ( listatodos )
		local r, g = guiGridListGetItemColor( listatodos, seleccion, 1 )	
		local interiorID = tostring(guiGridListGetItemText( listatodos, seleccion, 1))
		if source == botonmarcar then
			if r and g and g == 255 and r == 0 then return end
			triggerServerEvent("marcarInterior", getLocalPlayer(), tonumber(interiorID))
		end
		destroyElement(ventana)
		setElementData(getLocalPlayer(), "abririnmo", false)
		showCursor(false)
	end
end