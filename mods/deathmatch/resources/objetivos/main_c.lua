--[[
Copyright (c) 2018 DownTown RolePlay

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
local x, y = guiGetScreenSize()
local sqlCache
local sqlCache2

function GUIObjetivos(sql,sql2, nivel)
	sqlCache = sql
	if sql2 then
		sqlCache2 = sql2
	end
	objetivosPorResolver = 10
	triggerEvent("onCursor", getLocalPlayer())
	vObjetivos = guiCreateWindow(274*x/1366, 132*y/768, 803*x/1366, 487*y/768, "Objetivos - Fort Carson RolePlay", false)
	guiWindowSetSizable(vObjetivos, false)
	gridObjetivos = guiCreateGridList(21*x/1366, 40*y/768, 753*x/1366, 196*y/768, false, vObjetivos)
	addEventHandler("onClientGUIClick", gridObjetivos, regularAccionGUIObjetivos)                              
	--0.96
	guiGridListAddColumn(gridObjetivos, "Nº Objetivo", 0.1)
	guiGridListAddColumn(gridObjetivos, "Título del Objetivo", 0.86)
	for k, v in ipairs(sqlCache) do
		local r = guiGridListAddRow(gridObjetivos)
		guiGridListSetItemText(gridObjetivos, r, 1, tostring(utf8.escape(v.objetivoID)), false, false)
		guiGridListSetItemText(gridObjetivos, r, 2, tostring(v.titulo), false, false)
		if sql2 then
			for k2, v2 in ipairs(sqlCache2) do
				if tonumber(v.objetivoID) == tonumber(v2) then -- Objetivo resuelto
					guiGridListSetItemColor(gridObjetivos, r, 1, 0, 255, 0)
					guiGridListSetItemColor(gridObjetivos, r, 2, 0, 255, 0)
					objetivosPorResolver = objetivosPorResolver - 1
				end
			end
		end 
	end                             
	lInfoUsuario = guiCreateLabel(33*x/1366, 247*y/768, 731*x/1366, 49*y/768, "Bienvenid@ al sistema de objetivos de Fort Carson RolePlay. Para subir tu nivel y poder hacer más cosas, debes de obtener\nal menos 10 objetivos para cada nivel. Los objetivos en verde significa que ya se han cumplido.\nNecesitas cumplir "..tostring(objetivosPorResolver).. " objetivos para subir del nivel "..nivel.." al nivel "..(nivel+1)..".", false, vObjetivos)
	bCerrarVentana = guiCreateButton(350*x/1366, 427*y/768, 137*x/1366, 42*y/768, "Cerrar Ventana", false, vObjetivos)
	addEventHandler("onClientGUIClick", bCerrarVentana, regularAccionGUIObjetivos)
	memoDescripcion = guiCreateMemo(31*x/1366, 299*y/768, 733*x/1366, 118*y/768, "Selecciona uno de los objetivos para ver su descripción.", false, vObjetivos)
	guiMemoSetReadOnly(memoDescripcion, true)
end
addEvent("onAbrirGuiObjetivos", true)
addEventHandler("onAbrirGuiObjetivos", getRootElement(), GUIObjetivos)
          
function regularAccionGUIObjetivos()
	if source == bCerrarVentana then
		destroyElement(vObjetivos)
		triggerEvent("offCursor", getLocalPlayer())
		sqlCache = nil
	elseif source == gridObjetivos then
		local row = guiGridListGetSelectedItem ( gridObjetivos )
		if not row then return end
		local objetivoID = tostring(guiGridListGetItemText ( gridObjetivos, row, 1 ))
		for k, v in ipairs(sqlCache) do
			if tostring(v.objetivoID) == objetivoID then
				guiSetText(memoDescripcion, tostring(v.descripcion))
				return
			end
		end
	end
end