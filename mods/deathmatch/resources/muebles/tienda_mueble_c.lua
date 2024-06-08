local window = {}
local edit = {}
local grid = {}
local but = {}
local lbl = {}
local categoria = { [0] = "Armarios", [1] = "Camas", [2] = "Sofás", [3] = "Sillas y Sillones", [4] = "TVs y Estantes", [5] = "Otros Muebles", [6] = "Deporte", [7] = "Mis Muebles Comprados" }
local tipoG = 1

function tiendaMuebleGUI()
	window[1] = guiCreateWindow(0.01,0.4,0.35,0.6,"Sistema de Tienda de Muebles - DownTown RolePlay.",true)
	lbl[1] = guiCreateLabel(0.01,0.01,0.95,0.18,"Si tiene algún problema con el sistema, utilice F1.",true,window[1])
	guiLabelSetColor(lbl[1],3,249,61)
	guiLabelSetHorizontalAlign(lbl[1],"center",true)
	guiLabelSetVerticalAlign(lbl[1],"center",true)
	 
	grid[2] = guiCreateGridList(0.05,0.15,0.9,0.7,true,window[1])
	guiGridListSetSortingEnabled(grid[2], false)
	addEventHandler("onClientGUIClick",grid[2],selectMuebleMode,false)
	but[4] = guiCreateButton(0.7,0.88,0.3,0.08,"Cerrar",true,window[1])
	guiGridListAddColumn(grid[2],"Selecciona la categoría de muebles que quieras.",0.9)
		for i, v in pairs(categoria) do
	   		local row = guiGridListAddRow(grid[2])
			guiGridListSetItemText(grid[2],row,1,v,false,false)
			guiGridListSetItemData(grid[2],row,1,i)
		end 
	window[2] = guiCreateWindow(0.68,0.57,0.3,0.4,"Muebles del tipo seleccionado",true)
	lbl[3] = guiCreateLabel(0.01,0.01,0.95,0.2,"Selecciona un mueble para previsualizarlo.",true,window[2])
	guiLabelSetColor(lbl[3],3,249,61)
	guiLabelSetHorizontalAlign(lbl[3],"center",true)   
	guiLabelSetVerticalAlign(lbl[3],"center",true)
	grid[1] = guiCreateGridList(0.05,0.22,0.94,0.5,true,window[2])
	guiGridListSetSortingEnabled(grid[1], false)
	but[23] = guiCreateButton(0.075,0.8,0.25,0.15,"Comprar Mueble",true,window[2])
	but[24] = guiCreateButton(0.375,0.8,0.25,0.15,"Cerrar",true,window[2])
	but[25] = guiCreateButton(0.675,0.8,0.25,0.15,"Previsualizar Mueble",true,window[2])
	addEventHandler("onClientGUIClick",but[4],closemueble,false)
	addEventHandler("onClientGUIClick",but[24],closemueble,false)
	addEventHandler("onClientGUIClick",but[23],trymueble,false)
	addEventHandler("onClientGUIClick",but[25],trymueble,false)
	
	guiGridListAddColumn(grid[1],"Nombre",0.72)
	guiGridListAddColumn(grid[1],"Precio",0.22)

	guiSetVisible(window[1],false)
	guiSetVisible(window[2],false)
end

addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),
function()
	tiendaMuebleGUI()
end)
------------------------------------------tidy this code plz----------------------------------------------------------
function closemueble(button,state)
	if button == "left" and state =="up" then
		if mueblePrev then destroyElement(mueblePrev) end
		guiSetVisible(window[1],false)
		guiSetVisible(window[2],false)
		showCursor(false)
		setElementData(getLocalPlayer(), "guiMueble", false)
	end
end

function isguivisible(thePlayer,command)
	if mueblePrev then destroyElement(mueblePrev) end
	if guiGetVisible(window[1]) == true then
		guiSetVisible(window[1],false)
		guiSetVisible(window[2],false)
		
		showCursor(false)
	else
		guiSetVisible(window[1],true)
		guiSetVisible(window[2],true)
		
		showCursor(true)
		guiGridListSetSelectedItem(grid[1], 0, 0)
	end
end
addEvent("showTiendaMuebles",true)
addEventHandler("showTiendaMuebles",root,isguivisible)

function selectMuebleMode(button,state)
	if button == "left" and state == "up" then
		local row,col = guiGridListGetSelectedItem(grid[2])
		if row and col and row ~= -1 and col ~= -1 then
			local categoria = guiGridListGetItemData(grid[2],row,1)
			triggerServerEvent("displaymuebles",getLocalPlayer(),categoria)
		end
	end
end
  
function trymueble(button,state)
	if button == "left" and state == "up" then
		if source == but[23] or source == but[25] then -- Comprar Mueble
			local row,col = guiGridListGetSelectedItem(grid[1])
			if row and col and row ~= -1 and col ~= -1 then
				local IDMueble = guiGridListGetItemData(grid[1],row,1)
				local Nombre = guiGridListGetItemText(grid[1], row, 1)
				if tipoG == 1 then
					if source == but[23] then -- Comprar
						triggerServerEvent("onGestionMueble", getLocalPlayer(), IDMueble, 1)
					elseif source == but[25] then -- Previsualizar
						local x, y, z = getElementPosition(getLocalPlayer())
						if mueblePrev then destroyElement(mueblePrev) end
						mueblePrev = createObject(IDMueble, x + 0.75, y + 0.75, z-0.5)
						setElementDimension(mueblePrev, getElementDimension(getLocalPlayer()))
						setElementInterior(mueblePrev, getElementInterior(getLocalPlayer()))
						outputChatBox("Estás previsualizando el Mueble "..tostring(Nombre)..".", 0, 255, 0)
					else
						outputChatBox("Se ha producido un error. Utiliza F1 y acude al CAU.", 255, 0, 0)
					end 
				elseif tipoG == 2 then
					if source == but[23] then -- Colocar
						if mueblePrev then destroyElement(mueblePrev) end
						triggerServerEvent("onGestionMueble", getLocalPlayer(), IDMueble, 3)
						guiSetVisible(window[1],false)
						guiSetVisible(window[2],false)
						showCursor(false)
					elseif source == but[25] then -- Vender
						triggerServerEvent("onGestionMueble", getLocalPlayer(), IDMueble, 4)
						guiGridListRemoveRow(grid[1], row)
					else
						outputChatBox("Se ha producido un error. Utiliza F1 y acude al CAU.", 255, 0, 0)
					end 
				end
			end
		end
	end
end

function displaymbon(tabla, tipo)
	if guiGetVisible(window[2]) then
		guiGridListClear(grid[1])
		guiSetText(lbl[3],categoria[tipo])
		for i, v in pairs(tabla) do
			local row = guiGridListAddRow(grid[1])
			local IDMueble = v["IDMueble"]
			local nombre = v["Nombre"]
			local precio = v["Precio"]
			guiGridListSetItemText(grid[1],row,1,nombre,false,false)
			guiGridListSetItemText(grid[1],row,2,precio,false,false)
			guiGridListSetItemData(grid[1],row,1, IDMueble)
		end
		if tipo == 7 then
			tipoG = 2
			guiSetText(but[23], "Colocar Mueble")
			guiSetText(but[25], "Vender Mueble (Mitad del Precio)")
		else
			tipoG = 1
			guiSetText(but[23], "Comprar Mueble")
			guiSetText(but[25], "Previsualizar Mueble")
		end
	end
end
addEvent("displayMuebleOn",true)
addEventHandler("displayMuebleOn",root,displaymbon)