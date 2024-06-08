local window = {}
local edit = {}
local grid = {}
local but = {}
local lbl = {}
local style = { [0] = "Camisetas", [1] = "Peinados y Accesorios Cabeza(Gorros, Bandanas...)", [2] = "Pantalones", [3] = "Zapatos", [4] = "Tatuajes: Brazo Izquierdo (Arriba)", [5] = "Tatuajes: Brazo Izquierdo (Abajo)", [6] = "Tatuajes: Brazo Derecho (Arriba)", [7] = "Tattoos: Brazo Derecho (Abajo)", [8] = "Tatuajes: Espalda (Arriba)", [9] = "Tatuajes: Pectoral Izquierdo", [10] = "Tatuajes: Pectoral Derecho", [11] = "Tatuajes: Estómago", [12] = "Tatuajes: Espalda (Abajo)", [13] = "Cadenas/Collares", [14] = "Relojes", [15] = "Gafas", [16] = "Sombreros/Gorras", [18] = "Conjuntos / SKINS Antiguas" }
-- [17] = "Extra" Lo quitamos porque son uniformes de facciones ;)

function newSkinGui()
	window[1] = guiCreateWindow(0.01,0.4,0.35,0.6,"Sistema de Ropas - DownTown RolePlay.",true)
	lbl[1] = guiCreateLabel(0.01,0.01,0.95,0.18,"Si tienes algún problema con el sistema, acude a Soporte Técnico.",true,window[1])
	guiLabelSetColor(lbl[1],3,249,61)
	guiLabelSetHorizontalAlign(lbl[1],"center",true)
	guiLabelSetVerticalAlign(lbl[1],"center",true)
	 
	grid[2] = guiCreateGridList(0.05,0.15,0.9,0.7,true,window[1])
	guiGridListSetSortingEnabled(grid[2], false)
	addEventHandler("onClientGUIClick",grid[2],selectClothMode,false)
	but[4] = guiCreateButton(0.7,0.88,0.3,0.08,"Cerrar",true,window[1])
	guiGridListAddColumn(grid[2],"Selecciona la categoría de ropa que quieras.",0.9)
		for i, v in pairs(style) do
	   		local row = guiGridListAddRow(grid[2])
			guiGridListSetItemText(grid[2],row,1,v,false,false)
			guiGridListSetItemData(grid[2],row,1,i)
		end 
	window[2] = guiCreateWindow(0.68,0.57,0.3,0.4,"Ropas del tipo seleccionado",true)
	lbl[3] = guiCreateLabel(0.01,0.01,0.95,0.2,"Selecciona la ropa de abajo para previsualizarla.",true,window[2])
	guiLabelSetColor(lbl[3],3,249,61)
	guiLabelSetHorizontalAlign(lbl[3],"center",true)   
	guiLabelSetVerticalAlign(lbl[3],"center",true)
	grid[1] = guiCreateGridList(0.05,0.22,0.94,0.5,true,window[2])
	guiGridListSetSortingEnabled(grid[1], false)
	but[23] = guiCreateButton(0.075,0.8,0.25,0.15,"Comprar Ropa",true,window[2])
	but[24] = guiCreateButton(0.375,0.8,0.25,0.15,"Cerrar",true,window[2])
	but[25] = guiCreateButton(0.675,0.8,0.25,0.15,"Quitar Ropa",true,window[2])
	addEventHandler("onClientGUIClick",but[4],closecloth,false)
	addEventHandler("onClientGUIClick",but[24],closecloth,false)
	addEventHandler("onClientGUIClick",but[23],trycloth,false)
	addEventHandler("onClientGUIClick",but[25],trycloth,false)
	
	guiGridListAddColumn(grid[1],"Nombre",0.9)
	--guiGridListAddColumn(grid[1],"Nombre",0.72)
	--guiGridListAddColumn(grid[1],"Precio",0.22)

	guiSetVisible(window[1],false)
	guiSetVisible(window[2],false)
end

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),
function()
	newSkinGui()
end)
------------------------------------------tidy this code plz----------------------------------------------------------
function closecloth(button,state)
	if button == "left" and state =="up" then
		guiSetVisible(window[1],false)
		guiSetVisible(window[2],false)
		showCursor(false)
	end
end

function isguivisible(thePlayer, genero)
	if guiGetVisible(window[1]) == true then
		guiSetVisible(window[1],false)
		guiSetVisible(window[2],false)
		
		showCursor(false)
	else
		guiSetVisible(window[1],true)
		guiSetVisible(window[2],true)
		
		showCursor(true)
	end
end
addEvent("showDemClothGui",true)
addEventHandler("showDemClothGui",root,isguivisible)

function selectClothMode(button,state)
	if button == "left" and state == "up" then
		local row,col = guiGridListGetSelectedItem(grid[2])
		if row and col and row ~= -1 and col ~= -1 then
			local style = guiGridListGetItemData(grid[2],row,1)
			triggerServerEvent("displayclothes",getLocalPlayer(),style)
		end
	end
end

function trycloth(button,state)
	if button == "left" and state == "up" then
		if source == but[23] then
		local row,col = guiGridListGetSelectedItem(grid[1])
		if row and col and row ~= -1 and col ~= -1 then
			local idUnico = guiGridListGetItemData(grid[1],row,1)
			triggerServerEvent("aplicarRopaServidor", getLocalPlayer(), idUnico)
		end
		elseif source == but[25] then
			local row,col = guiGridListGetSelectedItem(grid[2])
			if row and col and row ~= -1 and col ~= -1 then
				local tipo = guiGridListGetItemData(grid[2],row,1)
				if getElementModel(getLocalPlayer()) == 0 then
					triggerServerEvent("aplicarRopaServidor", getLocalPlayer(), -tipo)
				else
					if tipo == 18 then -- Skin antigua, le asignamos skin CJ
						triggerServerEvent("aplicarRopaServidor", getLocalPlayer(), 99999)
					else
						outputChatBox("Se ha producido un error. Contacta con Jefferson.", 255, 0, 0)
					end
				end 
			else
				outputChatBox("Selecciona primero un tipo de ropa.", 255, 0, 0)
			end
		end
	end 
end

-- Generos: 1 hombre, 2 mujer
-- Color: 1 blanco, 0 negro
 
function displaymodeon(tabla, tipo, genero, color)
	if guiGetVisible(window[2]) then
		guiGridListClear(grid[1])
		guiSetText(lbl[3],style[tipo])
		for i, v in pairs(tabla) do
			if tonumber(tipo) < 18 then
				if genero == 1 then -- Hombre
					local row = guiGridListAddRow(grid[1])
					local idUnico = v["idUnico"]
					local nombre = v["Nombre"]
					--local precio = v["price"]
					guiGridListSetItemText(grid[1],row,1,nombre,false,false)
					--guiGridListSetItemText(grid[1],row,2,precio,false,false)
					guiGridListSetItemData(grid[1],row,1, idUnico)
				else
					outputChatBox("Lo sentimos, esta opción no está disponible para el género de tu PJ.", 255, 0, 0)
					break
				end
			else -- Skins, filtrar las mostradas según género/color
				local generoSkin = tostring(v["Texture"])
				local nombre = v["Nombre"]
				if generoSkin == "BAJA" then -- Si está dada de baja que no aparezca
					-- Nada que hacer
				else
					if genero == 1 and generoSkin == "SKINHOMBRE" then -- Hombre
						if color == 1 then -- Blanco
							if string.find(nombre, "Blanco") then
								local row = guiGridListAddRow(grid[1])
								local idUnico = v["idUnico"]
								--local precio = v["price"]
								guiGridListSetItemText(grid[1],row,1,nombre,false,false)
								--guiGridListSetItemText(grid[1],row,2,precio,false,false)
								guiGridListSetItemData(grid[1],row,1, idUnico)
							end
						elseif color == 0 then -- Negro
							if string.find(nombre, "Negro") then
								local row = guiGridListAddRow(grid[1])
								local idUnico = v["idUnico"]
								--local precio = v["price"]
								guiGridListSetItemText(grid[1],row,1,nombre,false,false)
								--guiGridListSetItemText(grid[1],row,2,precio,false,false)
								guiGridListSetItemData(grid[1],row,1, idUnico)
							end
						end
					elseif genero == 2 and generoSkin == "SKINMUJER" then
						if color == 1 then -- Blanca
							if string.find(nombre, "Blanca") then
								local row = guiGridListAddRow(grid[1])
								local idUnico = v["idUnico"]
								--local precio = v["price"]
								guiGridListSetItemText(grid[1],row,1,nombre,false,false)
								--guiGridListSetItemText(grid[1],row,2,precio,false,false)
								guiGridListSetItemData(grid[1],row,1, idUnico)
							end
						elseif color == 0 then -- Negra
							if string.find(nombre, "Negra") then
								local row = guiGridListAddRow(grid[1])
								local idUnico = v["idUnico"]
								--local precio = v["price"]
								guiGridListSetItemText(grid[1],row,1,nombre,false,false)
								--guiGridListSetItemText(grid[1],row,2,precio,false,false)
								guiGridListSetItemData(grid[1],row,1, idUnico)
							end
						end
					end
				end
			end
		end
	end
end
addEvent("displayClothOn",true)
addEventHandler("displayClothOn",root,displaymodeon)