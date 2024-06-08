--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2016 DownTown County Roleplay

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

local armario =
{
    [ 1741 ] = true,
	[ 2167 ] = true,
	[ 2025 ] = true,
	[ 2131 ] = true,
	[ 2336 ] = true,
}

local cajafuerte =
{
    [ 2332 ] = true,
}

local cama =
{
    [ 1700 ] = true,
	[ 1701 ] = true,
	[ 1725 ] = true,
	[ 1794 ] = true,
	[ 1798 ] = true,
	[ 2299 ] = true,
	[ 2603 ] = true,
	[ 2302 ] = true,
	[ 14866 ] = true,
	[ 2300 ] = true,
	[ 2301 ] = true,
	[ 2090 ] = true,
	[ 14446 ] = true,
	[ 2298 ] = true,
	[ 1812 ] = true,
	[ 1797 ] = true,
	[ 1745 ] = true,
	[ 1793 ] = true,
	[ 1796 ] = true,
	[ 1795 ] = true,
	[ 1799 ] = true,
	[ 1800 ] = true,
	[ 1801 ] = true,
	[ 1802 ] = true,
	[ 1803 ] = true,
	[ 14861 ] = true,
	[ 2575 ] = true,
	[ 1646 ] = true,
}

local wc =
{
    [ 2514 ] = true,
}

local lavadora =
{
    [ 1208 ] = true,
}

local radio =
{
    [ 2099 ] = true,
	[ 2100 ] = true,
}

local extintor =
{
    [ 2690 ] = true,
}

local sofa =
{
    [ 2290 ] = true,
	[ 1768 ] = true,
	[ 1766 ] = true,
	[ 1764 ] = true,
	[ 1763 ] = true,
	[ 1761 ] = true,
	[ 1760 ] = true,
	[ 1757 ] = true,
	[ 1756 ] = true,
	[ 1753 ] = true,
	[ 1713 ] = true,
	[ 1712 ] = true,
	[ 1710 ] = true,
	[ 1709 ] = true,
	[ 1707 ] = true,
	[ 1706 ] = true,
	[ 1703 ] = true,
	[ 1702 ] = true,
}

local sillon =
{
    [ 1735 ] = true,
	[ 1754 ] = true,
	[ 1755 ] = true,
	[ 1758 ] = true,
	[ 1759 ] = true,
	[ 1762 ] = true,
	[ 1765 ] = true,
	[ 1767 ] = true,
	[ 1769 ] = true,
	[ 2291 ] = true,
	[ 2292 ] = true,
}

local tv =
{
    [ 1518 ] = true,
	[ 1747 ] = true,
	[ 1748 ] = true,
	[ 1749 ] = true,
	[ 1750 ] = true,
	[ 1751 ] = true,
	[ 1752 ] = true,
	[ 1781 ] = true,
	[ 1786 ] = true,
	[ 2595 ] = true,
}

local estantetv =
{
    [ 2311 ] = true,
	[ 2313 ] = true,
	[ 2314 ] = true,
	[ 2315 ] = true,
	[ 2321 ] = true,
	[ 2346 ] = true,
}

local silla =
{
	[ 1714 ] = true,
    [ 1720 ] = true,
	[ 1739 ] = true,
	[ 1806 ] = true,
	[ 1810 ] = true,
	[ 1811 ] = true,
	[ 2079 ] = true,
	[ 2096 ] = true,
	[ 2120 ] = true,
	[ 2121 ] = true,
	[ 2123 ] = true,
	[ 2124 ] = true,
	[ 2636 ] = true,
	[ 2788 ] = true,
}

local pc =
{
	[ 1998 ] = true,
    [ 1999 ] = true,
	[ 2008 ] = true,
	[ 2009 ] = true,
	[ 2165 ] = true,
	[ 2605 ] = true,
}

function cuadro (objectID)
	if objectID and objectID >= 2254 and objectID <= 2289 then
		return true
	else
		return false
	end
end


local mueble = {}
local localPlayer = getLocalPlayer()
mueblesC = {}

addEvent( "mueble:open", true )
addEventHandler( "mueble:open", resourceRoot,
	function( )
		exports.gui:hide( )
		exports.gui:show( 'mueble_mostrarmenu', true )
	end
)

function abrirMueble(player, muebleID, tipo, sql)
	for k in pairs (mueblesC) do
		mueblesC [k] = nil
	end
	if muebleID and sql then
		for k, v in ipairs(sql) do
			table.insert(mueblesC, v)
		end
		if tipo == 1 then
			exports.gui:show("mueble_armario")
		elseif tipo == 2 then
			exports.gui:updateArmario()
		elseif tipo == 3 then
			exports.gui:updateInventarioArmario()
		end
	end
end
addEvent("onAbrirMueble", true)
addEventHandler("onAbrirMueble", getRootElement(), abrirMueble)

function getMueble()
	return mueblesC
end

local obj = nil
local offset = 0
local offsetr = 0
local offsety = 0
local offsetx = 0
for i = 0, 4 do
    setInteriorFurnitureEnabled(i, false)
end
--setInteriorFurnitureEnabled(3, false)
--setInteriorFurnitureEnabled(4, false)
--setInteriorFurnitureEnabled(2, false)


function startDrawing ( mueble )
	triggerEvent("offCursor", getLocalPlayer())
	toggleControl("fire", false)
	setElementData(getLocalPlayer(), "nocursor", true)
	obj = mueble
	setElementAlpha(obj, 150)
	setElementCollisionsEnabled(obj, false)
	bindKey("space", "up", stopDrawing)
	offset = 0
	offsetr = 0
	offsetx = 0
	offsety = 0
	addEventHandler("onClientRender", root, startMoving)
end
addEvent( "onStartMovingFurniture", true )
addEventHandler( "onStartMovingFurniture", localPlayer, startDrawing )

elevacion = 0

function startMoving ()
	if obj then
		local distance = 1
		local objectID = tonumber(getElementModel(obj))
		local px, py, pz = getElementPosition ( localPlayer )
		local rz = getPedRotation ( localPlayer )    

		local x = distance*math.cos((rz+90)*math.pi/180)
		local y = distance*math.sin((rz+90)*math.pi/180)
		local b2 = 15 / math.cos(math.pi/180)
		local nx = (px + x)+offsetx
		local ny = (py + y)+offsety
		local nz = (pz - 1)+offset+elevacion
		if cuadro(objectID) == true then
			nz = (pz + 1.3)+offset
		elseif lavadora[objectID] == true then
			rz = (rz-180)
		end
		if getKeyState ( "mouse1") then
			elevacion=elevacion+0.05
		elseif getKeyState ( "mouse2") then
			elevacion=elevacion-0.05
		end
		local objrot =  rz + 0
		if (objrot > 360) then
			objrot = objrot-360
		end
		
		setElementRotation ( obj, 0, 0, objrot+offsetr )
		moveObject ( obj, 10, nx, ny, nz)
	end
end           

function stopDrawing ()
	local x, y, z = getElementPosition(obj)
	local rx, ry, rz = getElementRotation(obj)
	setElementAlpha(obj, 255)
	setElementCollisionsEnabled(obj, true)
	toggleControl("fire", true)
	triggerServerEvent ( "onStopMovingFurniture", localPlayer, obj, x, y, z, rx, ry, rz )
	obj = nil
	removeEventHandler("onClientRender", root, startMoving)
	unbindKey("space", "up", stopDrawing)
end

function clickedAnything(button, state, absX, absY, wx, wy, wz, element)
	if ( button == "left" and state == "down" and element ) then
		local model = getElementModel(element)
		if silla[model] or sillon[model] or cama[model] then
			triggerServerEvent("onUsarMueble", element, button, state, getLocalPlayer())
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickedAnything)

local pX, pY = guiGetScreenSize()
function textosGimnasio()        
	--local musculatura = getPedStat(getLocalPlayer(), 23)
	--local gordura = getPedStat(getLocalPlayer(), 21)          
	local musculatura = getElementData(localPlayer,'musculatura')
    dxDrawRectangle(20*(pX/1440), 190*(pY/900), 280*(pX/1440), 240*(pY/900), tocolor(0, 0, 0, 225), false)
    dxDrawText("Deporte", 78*(pX/1440), 100*(pY/900), 225*(pX/1440), 363*(pY/900), tocolor(2, 200, 255, 255), 2.00, "pricedown", "center", "center", false, false, false, false, false)
	dxDrawText("Musculatura", 78*(pX/1440), 160*(pY/900), 225*(pX/1440), 363*(pY/900), tocolor(0, 255, 0, 255), 2.00, "ariel", "center", "center", false, false, false, false, false)
    dxDrawText(musculatura.."/1000", 28*(pX/1440), 158*(pY/900), 290*(pX/1440), 422*(pY/900), tocolor(255, 255, 255, 255), 2.00, "ariel", "center", "center", false, false, false, false, false)
    local gordura = getElementData(localPlayer,'gordura')
    dxDrawText("Gordura", 78*(pX/1440), 270*(pY/900), 225*(pX/1440), 363*(pY/900), tocolor(255, 0, 0, 255), 2.00, "ariel", "center", "center", false, false, false, false, false)
    dxDrawText(gordura.."/1000", 28*(pX/1440), 268*(pY/900), 290*(pX/1440), 422*(pY/900), tocolor(255, 255, 255, 255), 2.00, "ariel", "center", "center", false, false, false, false, false)
	dxDrawText("Pulsa 'W' para hacer ejercicio y 'espacio' para finalizar.", 20*(pX/1440), 340*(pY/900), 300*(pX/1440), 449*(pY/900), tocolor(255, 255, 255, 255), 1.00, "ariel", "center", "center", false,false, false, false, false)
end

addEvent('mostrarTextoGym',true)
addEventHandler('mostrarTextoGym',root,function()
	addEventHandler('onClientRender',root,textosGimnasio)
end)

addEvent('quitarTextoGym',true)
addEventHandler('quitarTextoGym',root,function()
	removeEventHandler('onClientRender',root,textosGimnasio)
end)