--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
  
You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

local localPlayer = getLocalPlayer( )
local screenX, screenY = guiGetScreenSize( )

addEventHandler( "onClientRender", root,
	function( )
		if getPedAnimation( localPlayer ) and exports.players:isLoggedIn( ) and not guiGetInputEnabled( ) and not getElementData(localPlayer, "hud") == false then
			if getElementData(localPlayer, "muerto") == true then
				return
			else
				textanim = "Pulsa espacio para parar la animación."
			end
			if getElementData(localPlayer, "tazed") == true then
				textanim = "Estás tazeado."
			elseif getElementData(localPlayer, "sexbot") == true then
				textanim = "Di al bot terminar para parar."
			--elseif getElementData(localPlayer, "muerto") == true then
				--textanim = "Estás gravemente herido o muerto. No puedes moverte."
			elseif getElementData(localPlayer, "gym_bici_estatica") == true or getElementData(localPlayer, "gym_banco_pesas") == true then
				textanim = "Pulsa espacio para dejar de hacer ejercicio."
			end
			dxDrawText( textanim, 4, 4, screenX, screenY * 0.95 + 2, tocolor( 0, 0, 0, 255 ), 1, "pricedown", "center", "bottom", false, false, true )
			dxDrawText( textanim, 0, 0, screenX, screenY * 0.95, tocolor( 255, 255, 255, 255 ), 1, "pricedown", "center", "bottom", false, false, true )
		end
	end
)

function verAnimaciones ()
	outputChatBox ("/bar [1-7] /batear [1-7] /bomba /crack [1-4] /rcp /bailar [1-11] /reparar /salida", 255, 255, 255)
	outputChatBox ("/manos [1-11] /hablar [1-17] /gimnasio [1-9] /esperarse [1-8] /besar [1-6]", 0, 255, 0)
	outputChatBox ("/tumbarse [1-4] /apoyarse /no /revisarse [1-4] /sentarse [1-14] /fumar [1-4]", 255, 255, 255)
	outputChatBox ("/pensar /vomitar /cansado /esperar /saluda [1-2] /si /control [1-2] /coche [1-6]", 0, 255, 0)
	outputChatBox ("/rendirse [1-2] /apuntar [1-2] /patada /pelea [1-6] /karate [1-6] /callejero [1-6]", 255, 255, 255)
	outputChatBox ("/crack [1-5] /escuchar /gritar /animar [1-2] /asustado [1-2]", 0, 255, 0)
	outputChatBox ("También puedes usar /anims para ver un panel con TODAS las animaciones.", 255, 255, 0)
end
addCommandHandler ("veranims", verAnimaciones)
addCommandHandler ("veranimaciones", verAnimaciones)

-- Sistema de animaciones tipo GUI --

local actual_block = nil
ani_all = {}

function xmlToTable(xmlFile, index)
	local xml = getResourceConfig(xmlFile)
	if not xml then
		return false
	end
	local result
	if index then
		result = dumpXMLToTable(xmlFindChild(xml, "group", index), "anim")
	else
		result = dumpXMLToTable(xml, "group")
	end
	
	xmlUnloadFile(xml)
	return result
end

function dumpXMLToTable(parentNode, key)
	local results = {}
	local i = 0
	local groupNode = xmlFindChild(parentNode, key, i)
	while groupNode do
		local group = {'group', name=xmlNodeGetAttribute(groupNode, 'name'), index=i}
		table.insert(results, group)
		i = i + 1
		groupNode = xmlFindChild(parentNode, key, i)
	end
	return results
end

function ani_start()
	ani_window = guiCreateWindow(0.8,0.30,0.20,0.40,"Animaciones - DownTown RolePlay",true)
		guiWindowSetSizable(ani_window,false)
   
	ani_tab_panel = guiCreateTabPanel(0.05, 0.07, 0.90, 0.90, true, ani_window)

	ani_tab_all = guiCreateTab("Animaciones", ani_tab_panel)
		ani_grid = guiCreateGridList(0.02,0.02,0.96,0.77,true,ani_tab_all)
			guiGridListAddColumn(ani_grid, "", 0.85)
			guiGridListSetSelectionMode(ani_grid, 0)
			addEventHandler("onClientGUIDoubleClick", ani_grid, ani_animation, false)
		         
		ani_info = guiCreateLabel(0.05,0.8,0.85,0.08,"Doble click para poner una animación.",true,ani_tab_all)
		ani_loop = guiCreateCheckBox(0.10,0.90,0.45,0.08,"¿Repetir?",true,true,ani_tab_all)
			
		ani_add_favourites = guiCreateButton(0.40,0.92,0.25,0.06, "Añadr",true,ani_tab_all)
			addEventHandler("onClientGUIClick", ani_add_favourites, ani_add, false)
		
		ani_close = guiCreateButton(0.70,0.92,0.25,0.06,"Cerrar",true,ani_tab_all)
			addEventHandler("onClientGUIClick", ani_close, ani_zamknij, false)

	ani_tab_favourites = guiCreateTab("Animaciones Favoritas", ani_tab_panel)
		addEventHandler("onClientGUITabSwitched", ani_tab_favourites, ani_getfavourites)
		ani_grid_fav = guiCreateGridList(0.02,0.02,0.96,0.77,true,ani_tab_favourites)
			guiGridListAddColumn(ani_grid_fav, "", 0.40)
			guiGridListAddColumn(ani_grid_fav, "", 0.45)
			guiGridListSetSelectionMode(ani_grid_fav, 0)
			addEventHandler("onClientGUIDoubleClick", ani_grid_fav, ani_animation, false)

		ani_loop_fav = guiCreateCheckBox(0.10,0.83,0.45,0.08,"¿Repetir?",true,true,ani_tab_favourites)

		ani_button_fav = guiCreateButton(0.10,0.92,0.25,0.06, "Aplicar",true,ani_tab_favourites)
			addEventHandler("onClientGUIClick", ani_button_fav, ani_animation, false)
			
		ani_add_favourites_fav = guiCreateButton(0.40,0.92,0.25,0.06, "Eliminar",true,ani_tab_favourites)
			addEventHandler("onClientGUIClick", ani_add_favourites_fav, ani_del, false)
		
		ani_close_fav = guiCreateButton(0.70,0.92,0.25,0.06,"Cerrar",true,ani_tab_favourites)
			addEventHandler("onClientGUIClick", ani_close_fav, ani_zamknij, false)

	guiSetVisible(ani_window,false)
	
	ani_getall()
	
	xmlFile = ani_loadfile()
	ani_aktualizuj(true)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), ani_start)

function ani_loadfile()
	local file = xmlLoadFile("favourite.xml")
	if not file then
		file = xmlCreateFile("favourite.xml", "favourites")
	end
	
	xmlSaveFile(file)
	
	if xmlFindChild(file, "animation", 0) then
		local childrens = xmlNodeGetChildren(file)
		
		for key, node in pairs(childrens) do
			local anim = xmlNodeGetAttribute(node, "animation")
			local block = xmlNodeGetAttribute(node, "block")
			
			if not isAnimation(block, anim) then
				xmlDestroyNode(node)
				xmlSaveFile(file)
			end
		end
	end

	return file
end

function isAnimation(block, name)
	for key, value in pairs(ani_all) do
		if value.group == block and value.anim == name then
			return true
		end
	end
	return false
end

function ani_zamknij()
	if guiGetVisible(ani_window) then
		guiSetVisible(ani_window, false)
		showCursor(false)	
	end
end

function ani_otworz()
	if not guiGetVisible(ani_window) then
		guiSetVisible(ani_window, true)
		showCursor(true)
	end
end
	
function ani_add()
	local tekst = guiGridListGetItemText(ani_grid, guiGridListGetSelectedItem(ani_grid), 1)
	if tekst ~= "" then
		if tekst ~= "..." then
			if actual_block and tekst then
				if isAnimation(actual_block, tekst) then
					local child = xmlCreateChild(xmlFile, "animation")
				
					xmlNodeSetAttribute(child, "block", actual_block)
					xmlNodeSetAttribute(child, "animation", tekst)
					
					xmlSaveFile(xmlFile)
				end
			end
		end
	end
end

function ani_del()
	local selected = guiGridListGetSelectedItem(ani_grid_fav)
	if tekst ~= -1 then
		local tekst = guiGridListGetItemText(ani_grid_fav, selected, 1)
		if tekst ~= "" then
			if tekst ~= "..." then
				local block = guiGridListGetItemText(ani_grid_fav, selected, 1)
				local index = tonumber(guiGridListGetItemData(ani_grid_fav, selected, 1))
				local animation = guiGridListGetItemText(ani_grid_fav, selected, 2)
				
				if block and animation then
					local node = xmlFindChild(xmlFile, "animation", index-1)
					if node then
						xmlDestroyNode(node)
					end
					xmlSaveFile(xmlFile)
					ani_getfavourites()
				end
			end
		end
	end
end

function ani_getfavourites()
	if xmlFile then
		if guiGridListClear(ani_grid_fav) then
			for key, node in pairs(xmlNodeGetChildren(xmlFile)) do
				local block = xmlNodeGetAttribute(node, "block")
				local anim = xmlNodeGetAttribute(node, "animation")
			
				local row = guiGridListAddRow(ani_grid_fav)
				guiGridListSetItemText(ani_grid_fav, row, 1, tostring(block), false, false)
				guiGridListSetItemData(ani_grid_fav, row, 1, tostring(key))
				guiGridListSetItemText(ani_grid_fav, row, 2, tostring(anim), false, false)
			end
		end
	end
end

function ani_animation()
	if source == ani_grid then
		local tekst = guiGridListGetItemText(ani_grid, guiGridListGetSelectedItem(ani_grid), 1)
		if teskt ~= "" then
			if tekst == "..." then
				ani_aktualizuj(true)
				actual_block = nil
			else
				if guiGridListGetItemText(ani_grid, 0, 1) ~= "..." then
					actual_block = tekst
					ani_aktualizuj(false,tonumber(guiGridListGetItemData(ani_grid, guiGridListGetSelectedItem(ani_grid), 1)))
				else
					if tekst == "" then
						applyAnimation()
					else
						applyAnimation(actual_block,tekst,guiCheckBoxGetSelected(ani_loop))
					end
				end
			end
		end
	else
		local block = guiGridListGetItemText(ani_grid_fav, guiGridListGetSelectedItem(ani_grid_fav), 1)
		local anim = guiGridListGetItemText(ani_grid_fav, guiGridListGetSelectedItem(ani_grid_fav), 2)
		if teskt ~= "" then
			applyAnimation(block,anim,guiCheckBoxGetSelected(ani_loop_fav))
		end
	end
end

function ani_getall()
	for key, node in pairs(xmlToTable("animations.xml")) do
		for index, grupa in pairs(xmlToTable("animations.xml", node.index)) do
			table.insert(ani_all, { ["group"] = node.name, ["anim"] = grupa.name } )
		end
	end
end

function ani_aktualizuj(stan,index)
	if guiGridListClear(ani_grid) then
		if stan then
			for _, grupa in pairs(xmlToTable("animations.xml")) do
				local row = guiGridListAddRow(ani_grid)
				guiGridListSetItemText(ani_grid, row, 1, tostring(grupa["name"]), false, false)
				guiGridListSetItemData(ani_grid, row, 1, tostring(grupa["index"]))
			end
		else
			if index then
				local row = guiGridListAddRow(ani_grid)
				guiGridListSetItemText(ani_grid, row, 1, "...", false, false)
				
				for _, grupa in pairs(xmlToTable("animations.xml", index)) do
					local row = guiGridListAddRow(ani_grid)
					guiGridListSetItemText(ani_grid, row, 1, tostring(grupa["name"]), false, false)
					guiGridListSetItemData(ani_grid, row, 1, tostring(grupa["index"]))
				end
			end
		end
	end
end

function applyAnimation(block,ani,loop)
	triggerServerEvent("AnimationSet", getLocalPlayer(), tostring(block), tostring(ani), loop)
end

function ani_init()
	if not guiGetVisible(ani_window) then
		ani_otworz()
		outputChatBox("Recuerda que también puedes usar /veranims para ver un resumen de estas.", 0, 255, 0)
	else
		ani_zamknij()
	end
end
addCommandHandler("anims", ani_init)
addCommandHandler("animaciones", ani_init)