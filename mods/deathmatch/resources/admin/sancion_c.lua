local nUsuario = ""
local nUsuario2 = ""
local x, y = guiGetScreenSize()

local sanciones = {
	[-1] = "Liberación de Jail",
	[1] = "#1 DM",
	[2] = "#2 PG / Forzar Rol",
	[3] = "#3 MG",
	[4] = "#4 RK",
	[5] = "#5 Flamming / IOOC / Mentir o ignorar Staff",
	[6] = "#6 Abuso Canal OOC / Cortar Rol",
	[7] = "#7 Troll / BD / CJ",
	[8] = "#8 SPAM (Publicidad)",
	[9] = "#9 BA",
	[10] = "#10 Multicuentas",
	[11] = "#11 NRE / NRH / NRC",
	[12] = "#12 Evasión De Rol",
	[13] = "#13 Reporte Innecesario (Reportante)",
	[14] = "#14 NA",
	[15] = "#15 Mal Uso /AD",
	[16] = "#16 Tener 2 PJ en una facción",
	[17] = "#17 Fuera de Zona de Rol",
	[18] = "#18 Buen rol / buena actuación",
}

function GUISancionar(nombrep)
	if nombrep then
		triggerEvent("onCursor", getLocalPlayer())
		nUsuario = nombrep
        vSancion = guiCreateWindow(x*535/1366, y*252/768, x*274/1366, y*256/768, "Sancionar Usuario", false)
        guiWindowSetSizable(vSancion, false)
        lUsuarioSancionado = guiCreateLabel(24*x/1366, 30*y/768, 222*x/1366, 18*y/768, "Usuario: "..tostring(nombrep), false, vSancion)
        guiLabelSetHorizontalAlign(lUsuarioSancionado, "center", true)
        cboxSanciones = guiCreateComboBox(34*x/1366, 64*y/768, 204*x/1366, 114*y/768, "", false, vSancion)
        guiComboBoxAddItem(cboxSanciones, "#1 DM")
		guiComboBoxAddItem(cboxSanciones, "#2 PG / Forzar Rol")
		guiComboBoxAddItem(cboxSanciones, "#3 MG")
		guiComboBoxAddItem(cboxSanciones, "#4 RK")
		guiComboBoxAddItem(cboxSanciones, "#5 Flamming / IOOC / Mentir o ignorar Staff")
		guiComboBoxAddItem(cboxSanciones, "#6 Abuso Canal OOC / Cortar Rol")
		guiComboBoxAddItem(cboxSanciones, "#7 Troll / BD / CJ")
		guiComboBoxAddItem(cboxSanciones, "#8 SPAM (Publicidad)")
		guiComboBoxAddItem(cboxSanciones, "#9 BA")
		guiComboBoxAddItem(cboxSanciones, "#10 Multicuentas")
		guiComboBoxAddItem(cboxSanciones, "#11 NRE / NRH / NRC")
		guiComboBoxAddItem(cboxSanciones, "#12 Evasión de Rol")
		guiComboBoxAddItem(cboxSanciones, "#13 Reporte Innecesario (Reportante)")
		guiComboBoxAddItem(cboxSanciones, "#14 NA")
		guiComboBoxAddItem(cboxSanciones, "#15 Mal Uso /AD")
		guiComboBoxAddItem(cboxSanciones, "#16 Tener 2 PJ en una facción")
		guiComboBoxAddItem(cboxSanciones, "#17 Fuera de Zona de Rol")
		guiComboBoxAddItem(cboxSanciones, "#18 Buen rol / buena actuación")
        bCerrarSancionar = guiCreateButton(23*x/1366, 204*y/768, 99*x/1366, 42*y/768, "Cerrar", false, vSancion)
        bAplicarSancion = guiCreateButton(149*x/1366, 204*y/768, 99*x/1366, 42*y/768, "Sancionar", false, vSancion)
		addEventHandler("onClientGUIClick", bCerrarSancionar, regularSancionarGUI)
		addEventHandler("onClientGUIClick", bAplicarSancion, regularSancionarGUI)
	end
end
addEvent("onAbrirGUISancionar", true)
addEventHandler("onAbrirGUISancionar", getRootElement(), GUISancionar)

function regularSancionarGUI()
	if source == bCerrarSancionar then
		destroyElement(vSancion)
		triggerEvent("offCursor", getLocalPlayer())
	elseif source == bAplicarSancion then
		local norma = guiComboBoxGetSelected(cboxSanciones)
		if norma == -1 then
			outputChatBox("¡Selecciona una norma primero!", 255, 0, 0)
		else
			local textonorma = tostring(guiComboBoxGetItemText(cboxSanciones, norma))
			triggerServerEvent("onAplicarSancionAUsuario", getLocalPlayer(), nUsuario, norma+1, textonorma)
			destroyElement(vSancion)
			triggerEvent("offCursor", getLocalPlayer())
		end
	end
end


function GUIVerSanciones(datos, nombreu, staff)
	nUsuario2 = nombreu
	vVerSanciones = guiCreateWindow(325*x/1366, 181*y/768, 692*x/1366, 413*y/768, "Sanciones de "..tostring(nombreu), false)
	guiWindowSetSizable(vVerSanciones, false)
	triggerEvent("onCursor", getLocalPlayer())
	gridVerSanciones = guiCreateGridList(46*x/1366, 49*y/768, 599*x/1366, 306*y/768, false, vVerSanciones)
	guiGridListAddColumn(gridVerSanciones, "ID Sanción", 0.3)
	guiGridListAddColumn(gridVerSanciones, "Regla incumplida", 0.2)
	guiGridListAddColumn(gridVerSanciones, "Fecha y Hora", 0.23)
	guiGridListAddColumn(gridVerSanciones, "ID Staff", 0.2)
	for k, v in ipairs(datos) do
		local r = guiGridListAddRow(gridVerSanciones)
		guiGridListSetItemText(gridVerSanciones, r, 2, tostring(sanciones[v.regla]), false, false)
		guiGridListSetItemText(gridVerSanciones, r, 3, tostring(v.fecha), false, false)
		guiGridListSetItemText(gridVerSanciones, r, 4, tostring(v.staffID), false, false)
		if v.validez == 1 then
			if string.find(tostring(sanciones[v.regla]), "Buen rol") then
				guiGridListSetItemColor(gridVerSanciones, r, 2, 66, 137, 244)
				guiGridListSetItemColor(gridVerSanciones, r, 3, 66, 137, 244)
				guiGridListSetItemColor(gridVerSanciones, r, 4, 66, 137, 244)
				guiGridListSetItemText(gridVerSanciones, r, 1, tostring(v.sancionID), false, false)
				guiGridListSetItemColor(gridVerSanciones, r, 1, 66, 137, 244)
			else
				guiGridListSetItemColor(gridVerSanciones, r, 2, 0, 255, 0)
				guiGridListSetItemColor(gridVerSanciones, r, 3, 0, 255, 0)
				guiGridListSetItemColor(gridVerSanciones, r, 4, 0, 255, 0)
				guiGridListSetItemText(gridVerSanciones, r, 1, tostring(v.sancionID), false, false)
				guiGridListSetItemColor(gridVerSanciones, r, 1, 0, 255, 0)
			end
		else
			guiGridListSetItemColor(gridVerSanciones, r, 2, 255, 0, 0)
			guiGridListSetItemColor(gridVerSanciones, r, 3, 255, 0, 0)
			guiGridListSetItemColor(gridVerSanciones, r, 4, 255, 0, 0)
			guiGridListSetItemText(gridVerSanciones, r, 1, tostring(v.sancionID)..(" (Anulada)"), false, false)
			guiGridListSetItemColor(gridVerSanciones, r, 1, 255, 0, 0)
		end
		--
	end
	bCerrarvVerSanciones = guiCreateButton(48*x/1366, 367*y/768, 111*x/1366, 36*y/768, "Cerrar ventana", false, vVerSanciones)
	addEventHandler("onClientGUIClick", bCerrarvVerSanciones, regularVerSancionesGUI)
	if staff == true then
		bAnularSancion = guiCreateButton(169*x/1366, 367*y/768, 111*x/1366, 36*y/768, "Anular sanción", false, vVerSanciones)
		addEventHandler("onClientGUIClick", bAnularSancion, regularVerSancionesGUI)
	end
end
addEvent("onAbrirGUIVerSanciones", true)
addEventHandler("onAbrirGUIVerSanciones", getRootElement(), GUIVerSanciones)

function regularVerSancionesGUI()
	if source == bCerrarvVerSanciones then
		destroyElement(vVerSanciones)
		triggerEvent("offCursor", getLocalPlayer())
	elseif source == bAnularSancion then
		local row = guiGridListGetSelectedItem ( gridVerSanciones )
		if row > -1 then
			local sancionID = guiGridListGetItemText ( gridVerSanciones, row, 1 )
			triggerServerEvent("onRemoverSancionAUsuario", getLocalPlayer(), nUsuario2, sancionID)
			destroyElement(vVerSanciones)
			triggerEvent("offCursor", getLocalPlayer())
		else
			outputChatBox("¡Selecciona primero la sanción a anular!", source, 255, 0, 0)
		end
	end
end

function addLogMessage(type, message)
	local type = string.lower(type)
	local r = getRealTime( )
	local fecha = "[" .. ("%04d-%02d-%02d %02d:%02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute, r.second) .. "] "
	if fileExists ( type..".txt" ) then
		local file = fileOpen(type..".txt")
		local size = fileGetSize(file)
		fileSetPos (file, size)
		fileWrite(file, fecha..message.."\n")
		fileClose(file)
	else
		local file = fileCreate(type..".txt")
		fileWrite(file, fecha..message.."\n")
		fileClose(file)
	end
end