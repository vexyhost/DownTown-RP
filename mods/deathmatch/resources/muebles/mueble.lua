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

local p = { }
local muebles = { }
local blips = { }
local ch = { }
local camaT = { }
local chairData = 
{
	-- offset = { x, y, z }, rotation = rz
	-- Sillas --
	[1720] = { offset = { 0, 0.1, 1.4 }, rotation = 0 }, -- Silla 1
	[1739] = { offset = { -0.05, 0, 0.5 }, rotation = 270 }, -- Silla 2
	[1806] = { offset = { 0, 0.2, 1.4 }, rotation = 180 }, -- Silla 3
	[1810] = { offset = { -0.25, 0.05, 1.38 }, rotation = 0 }, -- Silla 4
	[2125] = { offset = { 0, 0, 0 }, rotation = 0 }, -- Silla 5
	[2079] = { offset = { -0.1, 0, 0.7 }, rotation = 270 }, -- Silla 6
	[2096] = { offset = { 0, 0.1, 1.3 }, rotation = 0 }, -- Silla 7
	[2120] = { offset = { 0, 0.02, 0.8 }, rotation = 270 }, -- Silla 8
	[2121] = { offset = { 0, -0.1, 0.9 }, rotation = 0 }, -- Silla 9
	[2123] = { offset = { -0.03, 0, 0.8 }, rotation = 270 }, -- Silla 10
	[2124] = { offset = { -0.05, 0, 0.6 }, rotation = 270 }, -- Silla 11
	[1671] = { offset = { 0, 0, 0.8 }, rotation = 0 }, -- Silla 12
	[1714] = { offset = { 0, -0.1, 1.3 }, rotation = 0 }, -- Silla 13
	[1715] = { offset = { 0, -0.2, 1.3 }, rotation = 0 }, -- Silla 14
	[1722] = { offset = { 0, 0.3, 1.35 }, rotation = 180 }, -- Silla 15
	[2350] = { offset = { 0, 0, 1.3 }, rotation = 0 }, -- Silla 16
	[1663] = { offset = { 0, 0, 0.8 }, rotation = 0 }, -- Silla 17
	[2636] = { offset = { -0.1, 0.05, 0.77 }, rotation = 270 }, -- Silla 18
	[2788] = { offset = { 0, 0, 0.8 }, rotation = 270 }, -- Silla 19
	
	[ 1735 ] = { offset = { 0, -0.1, 1.3 }, rotation = 0 }, -- Sillon 1
	[ 1754 ] = { offset = { 0, -0.25, 1.4 }, rotation = 0 }, -- Sillon 2
	[ 1755 ] = { offset = { 0.5, -0.05, 1.4 }, rotation = 0 }, -- Sillon 3
	[ 1758 ] = { offset = { 0.5, -0.05, 1.4 }, rotation = 0 }, -- Sillon 4
	[ 1759 ] = { offset = { 0.5, -0.05, 1.4 }, rotation = 0 }, -- Sillon 5
	[ 1762 ] = { offset = { 0.5, -0.15, 1.3 }, rotation = 0 }, -- Sillon 6
	[ 1765 ] = { offset = { 0.5, -0.15, 1.3 }, rotation = 0 }, -- Sillon 7
	[ 1767 ] = { offset = { 0.5, -0.15, 1.3 }, rotation = 0 }, -- Sillon 8
	[ 1769 ] = { offset = { 0.5, -0.15, 1.3 }, rotation = 0 }, -- Sillon 9
	[ 2291 ] = { offset = { 0.5, -0.15, 1.3 }, rotation = 0 }, -- Sillon 10
	[ 2292 ] = { offset = { 0.2, -0.2, 1.3 }, rotation = 45 }, -- Sillon 11
	[ 1704 ] = { offset = { 0.5, -0.25, 1.4 }, rotation = 0 }, -- Sillon 12
	[ 1727 ] = { offset = { 0.5, -0.2, 1.4 }, rotation = 0 }, -- Sillon 13
}

local sofaData = 
{
	[ 2290 ] = { offset = { 0.2, -0.2, 1.35 }, rotation = 0, plazas = 3, cPlaza = 0.8 }, -- Sofa 1
	[ 1768 ] = { offset = { 0.2, -0.2, 1.4 }, rotation = 0, plazas = 3, cPlaza = 0.8 }, -- Sofa 2
	[ 1766 ] = { offset = { 0.4, -0.15, 1.4 }, rotation = 0, plazas = 2, cPlaza = 1.2 }, -- Sofa 3
	[ 1764 ] = { offset = { 0.5, -0.15, 1.3 }, rotation = 0, plazas = 2, cPlaza = 1 }, -- Sofa 4
	[ 1763 ] = { offset = { 0.2, 0, 1.35 }, rotation = 0, plazas = 2, cPlaza = 0.9 }, -- Sofa 5
	[ 1761 ] = { offset = { 0.2, -0.2, 1.35 }, rotation = 0, plazas = 3, cPlaza = 0.8 }, -- Sofa 6
	[ 1760 ] = { offset = { 0.2, -0.15, 1.35 }, rotation = 0, plazas = 3, cPlaza = 0.8 }, -- Sofa 7
	[ 1757 ] = { offset = { 0.4, -0.15, 1.35 }, rotation = 0, plazas = 2, cPlaza = 1.2 }, -- Sofa 8
	[ 1756 ] = { offset = { 0.3, -0.15, 1.35 }, rotation = 0, plazas = 2, cPlaza = 1.2 }, -- Sofa 9
	[ 1753 ] = { offset = { 0.2, -0.2, 1.35 }, rotation = 0, plazas = 3, cPlaza = 0.8 }, -- Sofa 10
	[ 1713 ] = { offset = { 0.3, -0.2, 1.35 }, rotation = 0, plazas = 2, cPlaza = 1.2 }, -- Sofa 11
	[ 1712 ] = { offset = { 0.2, -0.2, 1.4 }, rotation = 0, plazas = 2, cPlaza = 1.1 }, -- Sofa 12
	[ 1710 ] = { offset = { 0.2, -0.2, 1.35 }, rotation = 0, plazas = 4, cPlaza = 1 }, -- Sofa 13
	[ 1709 ] = { offset = { 0.2, 0.8, 1.35 }, rotation = 0, plazas = 6, cPlaza = 1 }, -- Sofa 14
	[ 1707 ] = { offset = { 0.3, 0, 1.35 }, rotation = 0, plazas = 2, cPlaza = 1 }, -- Sofa 15
	[ 1706 ] = { offset = { 0, -0.2, 1.35 }, rotation = 0, plazas = 2, cPlaza = 1 }, -- Sofa 16
	[ 1703 ] = { offset = { 0.5, -0.2, 1.35 }, rotation = 0, plazas = 2, cPlaza = 1 }, -- Sofa 17
	[ 1702 ] = { offset = { 0.6, -0.2, 1.35 }, rotation = 0, plazas = 2, cPlaza = 0.8 }, -- Sofa 18

}

local camaData = 
{
	[ 1700 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 1
	[ 1701 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 2
	[ 1725 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 3
	[ 1794 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 4
	[ 1798 ] = { offset = { 0.6, 2.5, 1 }, rotation = 270, plazas = 1, cPlaza = 0 }, -- Cama 5
	[ 2299 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 6
	[ 2603 ] = { offset = { 0.15, 0.2, 0.5 }, rotation = 270, plazas = 1, cPlaza = 0 }, -- Cama 7
	[ 2302 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 8
	[ 14866 ] = { offset = { -0.2, 0.4, 0.4 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 9
	[ 2300 ] = { offset = { 1.2, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 10
	[ 2301 ] = { offset = { 0.3, 2.1, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 11
	[ 2090 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 12
	[ 14446 ] = { offset = { -0.6, 0.6, 0.5 }, rotation = 270, plazas = 2, cPlaza = 1.25 }, -- Cama 13
	[ 2298 ] = { offset = { 1.4, 2.7, 0.95 }, rotation = 270, plazas = 1, cPlaza = 0 }, -- Cama 14
	[ 1812 ] = { offset = { 0.1, 1.5, 0.75 }, rotation = 270, plazas = 1, cPlaza = 0 }, -- Cama 15
	[ 1797 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 16
	[ 1745 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 17
	[ 1793 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 18
	[ 1796 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 1, cPlaza = 0 }, -- Cama 19
	[ 1795 ] = { offset = { 0.3, 2.5, 0.8 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 20
	[ 1799 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 21
	[ 1800 ] = { offset = { 0.3, 2.5, 1.1 }, rotation = 270, plazas = 1, cPlaza = 0 }, -- Cama 22
	[ 1801 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 23
	[ 1802 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 24
	[ 1803 ] = { offset = { 0.3, 2.5, 1 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 25
	[ 14861 ] = { offset = { -0.6, 0, 0.6 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 26
	[ 2575 ] = { offset = { 1.2, 1.6, 0.5 }, rotation = 270, plazas = 2, cPlaza = 0.5 }, -- Cama 27
	[ 1646 ] = { offset = { 0.05, 0, 0.4 }, rotation = 270, plazas = 1, cPlaza = 0 }, -- Cama 28

}

local armario =
{
    [ 1741 ] = true,
	[ 2167 ] = true,
	[ 2025 ] = true,
	[ 2131 ] = true,
	[ 2336 ] = true,
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

local telefono =
{
    [ 11705 ] = true,
	[ 11728 ] = true,
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
	[ 1704 ] = true,
	[ 1727 ] = true,
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
    [ 1720 ] = true,
	[ 1739 ] = true,
	[ 1806 ] = true,
	[ 1810 ] = true,
	[ 2125 ] = true,
	[ 2079 ] = true,
	[ 2096 ] = true,
	[ 2120 ] = true,
	[ 2121 ] = true,
	[ 2123 ] = true,
	[ 2124 ] = true,
	[ 1671 ] = true,
	[ 1714 ] = true,
	[ 1715 ] = true,
	[ 1722 ] = true,
	[ 2350 ] = true,
	[ 1663 ] = true,
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

local function loadMueble( id, x, y, z, rx, ry, rz, interior, dimension, skin, created )
	mueble = createObject( skin, x, y, z, rx, ry, rz )
	setElementDoubleSided( mueble, true )
	setElementData( mueble, "mueble", true )
	setElementInterior( mueble, interior )
	setElementDimension( mueble, dimension )
	
	muebles[ id ] = { mueble = mueble, skin = skin}
	muebles[ mueble ] = id
	if skin == 2629 then
		local pesas = createObject( 2913, x, y, z, rx, ry, rz )
		setElementInterior( pesas, interior )
		setElementDimension( pesas, dimension )
		setElementData(pesas, "muebleVinculado", id)
		attachElements(pesas, mueble, -0.45, 0.5, 0.93, 90, 90, 0)
		-- Hacemos attach de un object paralelo que serán las pesas.
	end
	if created then return mueble end
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		local result = exports.sql:query_assoc( "SELECT * FROM muebles ORDER BY muebleID ASC" )
		if result then
			for key, value in ipairs( result ) do
				loadMueble( value.muebleID, value.x, value.y, value.z, value.rx, value.ry, value.rz, value.interior, value.dimension, value.skin)
			end
		end
	end
)

function createMueble (player, skin)
	local x, y, z = getElementPosition( player )
	local interior = getElementInterior( player )
	local dimension = getElementDimension( player )
	local rx, ry, rz = getElementRotation( player )
	local muebleID, error = exports.sql:query_insertid( "INSERT INTO muebles (x, y, z, rx, ry, rz, interior, dimension, skin) VALUES (" .. table.concat( { x, y, z+1, rx, ry, rz, interior, dimension, skin}, ", " ) .. ")" )
	if muebleID then
		mueble = loadMueble(muebleID, x, y+1, z+1, rx, ry, rx, interior, dimension, skin, true)
		setElementData(player, "moviendoMueble", 1)
		local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
		if nivel == 4 and not exports.objetivos:isObjetivoCompletado(43, exports.players:getCharacterID(player)) then
			exports.objetivos:addObjetivo(43, exports.players:getCharacterID(player), player)
		end
		outputChatBox("Estás colocando un mueble. Utiliza WASD y los botones del ratón. Espacio para guardar.", player, 0, 255, 0)
		triggerClientEvent ( player, "onStartMovingFurniture", player, mueble )
		setElementData(player, "nogui", true)
	end
end
addEvent("onCrearMueble", true)
addEventHandler("onCrearMueble", root, createMueble)

function deleteMueble ( player, muebleID, aviso )
	muebleConCosas = false
	muebleID = tonumber( muebleID )
	if muebleID then
		local mueble = muebles[ muebleID ]
		if mueble then
			if getElementType( mueble.mueble ) == "object" and getElementDimension(player) == getElementDimension(mueble.mueble) then
				-- Devolución cosas si se borra solo el armario
				if not aviso then
					for k2, v2 in ipairs(exports.sql:query_assoc("SELECT * FROM items_muebles WHERE muebleID = "..tonumber(muebleID))) do
						if v2.index then
							muebleConCosas = true
							exports.items:give(player, v2.item, v2.value, v2.name, v2.value2 )
							exports.sql:query_free("DELETE FROM items_muebles WHERE index = "..tonumber(v2.index))
						end
					end
					if muebleConCosas == true then
						outputChatBox("Al ser un armario, hemos devuelto todo lo que tenía a tu inventario.", player, 0, 255, 0)
					end
					-- Hacer que al eliminar la caja fuerte de el dinero en mano del PJ
					
					if getElementModel(mueble.mueble) == 2332 and tonumber(getDineroCaja(player, muebleID)) > 0 then 
						exports.players:giveMoney(player, tonumber(getDineroCaja(player, muebleID)))
						outputChatBox("Se te ha dado en mano el dinero de la caja ID "..tostring(muebleID).." ($"..tostring(getDineroCaja(player, muebleID))..")", player, 255, 255, 0)
						exports.logs:addLogMessage("/caja/"..getElementDimension(player).." - "..tostring(cajaID), "CAJA ELIMINADA DEVOLUCIÓN - $"..tostring(cantidad).." - Nombre PJ: "..tostring(getPlayerName(player):gsub("_", " "))..".")
					end
				end
				if exports.sql:query_free( "DELETE FROM muebles WHERE muebleID = " .. muebleID ) then
				    local nom = exports.muebles:getNombreMueble(tonumber(getElementModel(mueble.mueble)))
					if not aviso then
						outputChatBox("Has guardado un/a "..tostring(nom), player, 0, 255, 0)
					end
					exports.items:give(player, 27, mueble.skin, nom)
					destroyElement( mueble.mueble ) 
					muebles[ muebleID ] = nil
					muebles[ mueble.mueble ] = nil
				else
					outputChatBox( "Se ha producido un error. Inténtalo de nuevo.", player, 255, 255, 255 )
				end
			end
		end
	end
end


function usarMueble( button, state, player )
	if ( not p[ player ] ) and button == "left" and state == "up" then
		local muebleID = muebles[ source ]
		local model = getElementModel(source)
		if muebleID or silla[model] or sillon[model] or cama[model] then
		local mueble = muebles[ muebleID ]
			if mueble or silla[model] or sillon[model] or cama[model] then
				local x, y, z = getElementPosition( player )
				local ox, oy, oz = getElementPosition( source )
				if getDistanceBetweenPoints3D( x, y, z, ox, oy, oz ) <= 6 and getElementDimension( player ) == getElementDimension( source ) and not getElementData(player, "muebleintID") and not getElementData(player, "muebleID") then				
					if getElementType( source ) == "object" then
						local estado = getElementData(mueble.mueble, "estado")
						if lavadora[model] then
							if not estado then
								exports.chat:me(player, "pone ropa en la lavadora y clickea un botón", "(Lavadora)")
								setElementData(mueble.mueble, "estado", 1)
								exports.chat:ame(player, "Lavadora", "Podrás notar que el tambor empieza a girar a una gran velocidad.")
							else
								exports.chat:me(player, "pulsa un botón de la lavadora", "(Lavadora)")
								exports.chat:ame(player, "Lavadora", "Podrás notar que el tambor se para.")
								removeElementData(mueble.mueble, "estado")
							end
						elseif armario[model] or estantetv[model] then
							if not estado then
								setElementData(mueble.mueble, "estado", 1)
								local sql = exports.sql:query_assoc("SELECT `index`, item, value, value2, name FROM items_muebles WHERE muebleID = "..muebleID)
								triggerClientEvent(player, "onAbrirMueble", player, player, muebleID, 1, sql)
								setElementData(player, "muebleID", muebleID)
								exports.chat:me(player, "abre las puertas del armario.", "(Mueble)")
								setElementData(player, "nogui", true)
							else
								outputChatBox("Otro jugador ya tiene abierto el armario.", player, 255, 0, 0)
							end
						elseif silla[model] or sillon[model] then
							sitOnChair(player, source)
						elseif sofa[model] then
							sitOnSofa(player, source)
						elseif cama[model] then
							usarCama(player, source)
						elseif model == 2332 then
							outputChatBox("Comandos caja fuerte: /cretirar /cingresar /csaldo.", player, 255, 255, 255)
						elseif model == 2630 then
							-- Bicicleta estática
							local another = getAttachedElements(source)
							if #another == 0 then
								usarBiciletaEstatica(player, source)
							else
								outputChatBox("¡Esta bicicleta ya está siendo utilizada!", player, 255, 0, 0)
							end
						elseif model == 2629 then
							local pesas = -1
							for k, v in ipairs(getAttachedElements(source)) do
								pesas = v
							end
							-- Banco de pesas (sentado)
							usarBancoPesas(player, source, pesas)
						else
							exports.chat:me(player, "mira el mueble detenidamente. No pasa nada.", "(Mueble)")
						end
					end
                end
			end
		end
	end
end
addEventHandler( "onElementClicked", resourceRoot, usarMueble)
addEvent("onUsarMueble", true)
addEventHandler("onUsarMueble", getRootElement(), usarMueble)

addEvent( "mueble:close", true )
addEventHandler( "mueble:close", root,
	function( )
		if source == client then
			if p[ source ] then
				if p[ source ].ignoreUpdate then
					p[ source ].ignoreUpdate = nil
				else
					p[ source ].muebleID = nil
				end
			end
		end
	end
)

function gestionarMuebles (player)
	if exports.players:isLoggedIn(player) then
		local dimension = getElementDimension(player)
		if not dimension then outputChatBox("No estás en un interior.", player, 255, 0, 0) return end
		local int = exports.interiors:getInterior(getElementDimension(player))
		if (int and int.characterID == exports.players:getCharacterID(player)) or exports.items:has(player, 2, getElementDimension(player)) then
			if getElementData(player, "muebleintID") then
				outputChatBox("Has desactivado el modo para gestionar los muebles.", player, 255, 0, 0)
				removeElementData(player, "muebleintID")
			else
				outputChatBox("Has activado el modo para gestionar los muebles.", player, 0, 255, 0)
				outputChatBox("Usa /emuebles para comprar, vender o colocar muebles.", player, 255, 255, 255)
				outputChatBox("Pulsa con el botón izquierdo para mover un mueble.", player, 255, 255, 255)
				outputChatBox("Pulsa con el botón derecho para guardar un mueble.", player, 255, 255, 255)
				outputChatBox("Usa /guardarmuebles para guardar todos tus muebles.", player, 255, 255, 255)
				setElementData(player, "muebleintID", tonumber(getElementDimension(player)))
			end
		else
			outputChatBox("No eres el dueño del interior, y tampoco tienes llaves del mismo.", player, 255, 0, 0) return
		end
	end
end
addCommandHandler("muebles", gestionarMuebles)

addEventHandler( "onElementClicked", getRootElement(),
	function( button, state, player ) 
		local muebleID = muebles[ source ]
		if button == "left" and state == "down" and muebleID and source and getElementDimension(player) == getElementData(player, "muebleintID") and not getElementData(player, "moviendoMueble") and not getElementData(player, "guiMueble") then
			setElementData(player, "moviendoMueble", 1)
			setElementData(player, "nogui", true)
			outputChatBox("Usa WASD y los botones del ratón para mover el mueble. Espacio para guardar.", player, 0, 255, 0)
			triggerClientEvent ( player, "onStartMovingFurniture", player, source )
		elseif button == "right" and state == "down" and muebleID and source and getElementDimension(player) == getElementData(player, "muebleintID") and not getElementData(player, "moviendoMueble") and not getElementData(player, "guiMueble") then
			deleteMueble(player, muebles[source])
		end
	end
)

function comprarMuebles(player)
	if exports.players:isLoggedIn(player) then
		local dimension = getElementDimension(player)
		if not dimension or dimension == 0 then outputChatBox("No estás en un interior.", player, 255, 0, 0) return end
		if not getElementData(player, "muebleintID") then outputChatBox("Usa primero /muebles para acceder al modo de edición de muebles.", player, 255, 0, 0) return end
		local int = exports.interiors:getInterior(getElementDimension(player))
		if (int and int.characterID == exports.players:getCharacterID(player)) or exports.items:has(player, 2, getElementDimension(player)) then
			setElementData(player, "guiMueble", true)
			triggerClientEvent(player,"showTiendaMuebles",player)
		else
			outputChatBox("No eres el dueño del interior, y tampoco tienes llaves del mismo.", player, 255, 0, 0) return
		end
	end
end
addCommandHandler("emuebles", comprarMuebles)

function guardarMuebles (player)
	if exports.players:isLoggedIn(player) then
		local dimension = getElementDimension(player)
		if not dimension or dimension == 0 then outputChatBox("No estás en un interior.", player, 255, 0, 0) return end
		local int = exports.interiors:getInterior(getElementDimension(player))
		if (int and int.characterID == exports.players:getCharacterID(player)) or exports.items:has(player, 2, getElementDimension(player)) then
			local nM = 0
			for k, v in ipairs(exports.sql:query_assoc("SELECT muebleID, skin, extra FROM muebles WHERE dimension = "..tonumber(dimension))) do
				for k2, v2 in ipairs(exports.sql:query_assoc("SELECT * FROM items_muebles WHERE muebleID = "..tonumber(v.muebleID))) do
					if v2.index then
						exports.items:give(player, v2.item, v2.value, v2.name, v2.value2 )
						exports.sql:query_free("DELETE FROM items_muebles WHERE index = "..tonumber(v2.index))
					end
				end
				if v.skin == 2332 and tonumber(v.extra) > 0 then -- Hacer que al eliminar la caja fuerte de el dinero en mano del PJ
					exports.players:giveMoney(player, tonumber(v.extra))
					outputChatBox("Se te ha dado en mano el dinero de la caja ID "..tostring(v.muebleID).." ($"..tostring(v.extra)..")", player, 255, 255, 0)
					exports.logs:addLogMessage("/caja/"..getElementDimension(player).." - "..tostring(cajaID), "CAJA ELIMINADA DEVOLUCIÓN - $"..tostring(cantidad).." - Nombre PJ: "..tostring(getPlayerName(player):gsub("_", " "))..".")
				end
				deleteMueble(player, tonumber(v.muebleID), true)
				nM = nM + 1
			end
			outputChatBox("Has guardado tus muebles ("..tostring(nM).." muebles), junto con lo que había dentro.", player, 0, 255, 0)
		else
			outputChatBox("No eres el dueño del interior, y tampoco tienes llaves del mismo.", player, 255, 0, 0) return
		end
	end
end
addCommandHandler("guardarmuebles", guardarMuebles)
addCommandHandler("recogermuebles", guardarMuebles)
addEvent("onGuardarMuebles", true)
addEventHandler("onGuardarMuebles", getRootElement(), guardarMuebles)

addEvent( "onStopMovingFurniture", true )
addEventHandler( "onStopMovingFurniture", getRootElement(),
	function( element, x, y, z, rx, ry, rz )
		if element then
			local muebleID = muebles[ element ]
			if x and y and z then
				removeElementData(source, "moviendoMueble")
				removeElementData(source, "nocursor")
				removeElementData(source, "nogui")
				setElementPosition(element, x, y, z)
				setElementRotation(element, rx, ry, rz)
				local sql, error = exports.sql:query_free("UPDATE muebles SET x = " .. x ..", y = " .. y ..", z = " .. z ..", rx = " .. rx ..", ry = " .. ry ..", rz = " .. rz .." WHERE muebleID = "..muebleID)
				if sql and not error then
					outputChatBox("Has movido el mueble correctamente.", source, 0, 255, 0)
					if getElementData(source, "guiMueble") then
						triggerClientEvent(source,"showTiendaMuebles",source)
					end
				end
			end
		end
	end
)

addEvent( "onRotateMueble", true )
addEventHandler( "onMoveMueble", getRootElement(),
	function( element )
		if element then
			local muebleID = muebles[ element ]
			local x, y, z = getElementRotation(element)
			if x and y and z then
				setElementRotation(element, x, y, z+5)
			end
		end
	end
)

addEvent( "onMoveMueble", true )
addEventHandler( "onMoveMueble", getRootElement(),
	function( element, x, y, z )
		if element then
			local muebleID = muebles[ element ]
			if x and y and z then
				setElementPosition(element, x, y, z)
			end
		end
	end
)

addEventHandler( "onCharacterLogout", root,
	function( )
		p[ source ] = nil
		if getElementData(source, "muebleID") then
			local muebleID = getElementData(source, "muebleID")
			setTimer(function(source, muebleID) local mueble = muebles[ muebleID ] removeElementData(mueble.mueble, "estado") end, 500, 1, source, muebleID)
		end
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		p[ source ] = nil
		if getElementData(source, "muebleID") then
			local muebleID = getElementData(source, "muebleID")
			setTimer(function(source, muebleID) local mueble = muebles[ muebleID ] removeElementData(mueble.mueble, "estado") end, 500, 1, source, muebleID)
		end
	end
)

function cerrarMueble()
	exports.chat:me(source, "cierra el mueble.", "(Mueble)")
	removeElementData(source, "nogui")
	setTimer(function(source) local mueble = muebles[ getElementData(source, "muebleID") ] removeElementData(mueble.mueble, "estado") removeElementData(source, "muebleID") end, 500, 1, source)
end 
addEvent("onCerrarMueble", true)
addEventHandler("onCerrarMueble", getRootElement(), cerrarMueble)

function sitOnChair(player, chair)
	if not ch[player] then
		for k, v in ipairs(getElementsByType("player")) do
			if ch[v] == chair then 
				outputChatBox("Esta silla está ocupada.", player, 255, 0, 0) return
			end
		end
		local rx, ry, rz = getElementRotation(chair)
		local model = getElementModel(chair)
		local data = chairData[model]
		ch[player] = chair
		setPedRotation(player, (rz+data.rotation)-180)
		setPedAnimation(player, "FOOD", "FF_Sit_Look", -1, true, false, true)
		if silla[model] then
			exports.chat:me(player, "se acerca y se sienta en la silla.")
		elseif sillon[model] then
			exports.chat:me(player, "se acerca y se sienta en el sillón.")
		end
		setElementData(player, "sentado", true)
		attachElements(player, chair, unpack(data.offset))
		bindKey(player, "space", "down", standUp)
	end
end

function sitOnSofa(player, sofa)
	if not ch[player] then
		local data = sofaData[getElementModel(sofa)]
		local plazasDisponibles = data.plazas
		local plazasOcupadas = 0
		for k, v in ipairs(getElementsByType("player")) do
			if ch[v] == sofa then
				plazasOcupadas = plazasOcupadas + 1
			end
		end
		if plazasOcupadas == plazasDisponibles then
			outputChatBox("Este sofá está ocupado.", player, 255, 0, 0) return
		else
			local plazaAOcupar = (plazasOcupadas+1)
			local rx, ry, rz = getElementRotation(sofa)
			local x, y, z = unpack(data.offset)
			if getElementModel(sofa) == 1709 then
				if plazaAOcupar == 5 then
					x = x + 4.3
					rz = rz - 22
				elseif plazaAOcupar == 6 then
					x = x + 4.9
					y = y - 0.6
					rz = rz - 50
				else
					x = x + (data.cPlaza*(plazaAOcupar-1))
				end
			else
				x = x + (data.cPlaza*(plazaAOcupar-1))
			end
			ch[player] = sofa
			setPedRotation(player, (rz+data.rotation)-180)
			setPedAnimation(player, "FOOD", "FF_Sit_Look", -1, true, false, true)
			exports.chat:me(player, "se acerca y se sienta en el sofá.")
			setElementData(player, "sentado", true)
			attachElements(player, sofa, x, y, z)
			bindKey(player, "space", "down", standUp)
		end
	end
end


function usarCama(player, cama)
	if not ch[player] then
		local data = camaData[getElementModel(cama)]
		local plazasDisponibles = data.plazas
		local plazasOcupadas = 0
		for k, v in ipairs(getElementsByType("player")) do
			if ch[v] == cama then
				plazasOcupadas = plazasOcupadas + 1
			end
		end
		if plazasOcupadas == plazasDisponibles then
			outputChatBox("Esta cama está ocupada.", player, 255, 0, 0) return
		else
			local plazaAOcupar = (plazasOcupadas+1)
			local rx, ry, rz = getElementRotation(cama)
			local x, y, z = unpack(data.offset)
			if plazaAOcupar == 1 then
				setPedRotation(player, (rz+data.rotation)-180)
				setPedAnimation(player, "int_house", "bed_loop_l", -1, true, false, true)
			elseif plazaAOcupar == 2 then	
				x = x + data.cPlaza
				setPedRotation(player, (rz+data.rotation))
				setPedAnimation(player, "int_house", "bed_loop_r", -1, true, false, true)
			end
				ch[player] = cama
				camaT[player] = setTimer(
				function(player, cama)
					if player and cama and ch[player] and ch[player] == cama and isElement(player) then
						if getElementData(player, "cansancio") <= 95 then
							setElementData(player, "cansancio", getElementData(player, "cansancio")+5)
						else
							setElementData(player, "cansancio", 100)
						end
					else
						killTimer(camaT[player])
					end
				end, 15000, 0, player, cama)
				exports.chat:me(player, "se acerca y se tumba en la cama.")
				setElementData(player, "tumbado", true)
				attachElements(player, cama, x, y, z)
				bindKey(player, "space", "down", standUp)
		end
	end
end

function standUp(player)
	local model = getElementModel(ch[player])
	if silla[model] then
		exports.chat:me(player, "se levanta de la silla.")
	elseif sillon[model] then
		exports.chat:me(player, "se levanta del sillón.")
	elseif sofa[model] then
		exports.chat:me(player, "se levanta del sofá.")
	elseif cama[model] then
		exports.chat:me(player, "se levanta de la cama.")
		killTimer(camaT[player])
	end
	detachElements(player, ch[player])
	ch[player] = nil
	unbindKey(player, "space", "down", standUp)
end

function radioCercana( player )
	if exports.players:isLoggedIn ( player ) then
		local x, y, z = getElementPosition ( player )
		for key, value in pairs( muebles ) do
			if isElement( key ) and radio[getElementModel(key)] then
				local x2, y2, z2 = getElementPosition ( key )
				local distance = getDistanceBetweenPoints3D ( x, y, z, x2, y2, z2 )
				local comp = 2
				if distance <= comp then
					return key, muebles[ key ]
				end
			end
		end
		return false
	end
end

-- Script CAJA FUERTE --
function getDineroCaja ( player, muebleID )
	if muebleID then
		local sql = exports.sql:query_assoc_single("SELECT extra FROM muebles WHERE muebleID = " .. muebleID)
		if sql and sql.extra then
			return tonumber(sql.extra)
		else
			return false
		end
	else 
		return false 
	end
end

function cajaCercana( player )
	if exports.players:isLoggedIn ( player ) then
		local int = exports.interiors:getInterior(getElementDimension(player))
		if (int and int.characterID == exports.players:getCharacterID(player)) or exports.items:has(player, 2, getElementDimension(player)) then
			local x, y, z = getElementPosition ( player )
			for key, value in pairs( muebles ) do
				if isElement( key ) and getElementModel(key) == 2332 then
					local x2, y2, z2 = getElementPosition ( key )
					local distance = getDistanceBetweenPoints3D ( x, y, z, x2, y2, z2 )
					local comp = 2
					if distance <= comp and getElementDimension(key) == getElementDimension(player) then
						return key, muebles[ key ]
					end
				end
			end
			return false
		else
			return false
		end
	end
end

function cingresarDinero ( player, cmd, cantidad )
	if exports.players:isLoggedIn( player ) then
		if getElementDimension(player) == 0 then outputChatBox("No estás en un interior.", player, 255, 0, 0) return end
		local int = exports.interiors:getInterior(getElementDimension(player))
		if (int and int.characterID == exports.players:getCharacterID(player)) or exports.items:has(player, 2, getElementDimension(player)) then
			local caja, cajaID = cajaCercana(player)
			local cantidadActual = getDineroCaja( player, cajaID )
			if not cajaCercana( player ) then outputChatBox("No estás cerca de una caja fuerte que te pertenezca.", player, 255, 0, 0) return end
			if not cantidad then outputChatBox("Sintaxis: /"..tostring(cmd).." [cantidad]", player, 255, 255, 255) return end
			local cantidad = tonumber(math.floor(cantidad))
			if cantidad < 1 then outputChatBox("No puedes ingresar esta cantidad de dinero.", player, 255, 0, 0) return end
			if not cantidadActual then outputChatBox("Se ha producido un error, inténtalo de nuevo más tarde.", player, 255, 0, 0) return end
			if exports.players:takeMoney( player, cantidad ) then
				if exports.sql:query_free("UPDATE muebles SET extra = " .. (cantidadActual + cantidad) .. " WHERE muebleID = " .. cajaID) then
					exports.chat:me(player, "abre su caja fuerte y guarda dinero en ella.")
					local time = getRealTime()
					local fecha = tostring(time.year+1900).."-"..tostring(time.month+1).."-"..tostring(time.monthday).." H: "..tostring(time.hour)..":"..tostring(time.minute)..":"..tostring(time.second)
					outputChatBox("Has ingresado $" .. tostring ( cantidad ) .. " en tu caja ID "..tostring(cajaID)..".", player, 0, 255, 0)
					outputChatBox("Balance actual ("..tostring(fecha).."): $" .. tostring (cantidadActual + cantidad) .. ".", player, 0, 255, 0)
					exports.logs:addLogMessage("/caja/"..getElementDimension(player).." - "..tostring(cajaID), "Ingreso - $"..tostring(cantidad).." - Nombre PJ: "..tostring(getPlayerName(player):gsub("_", " "))..".")
				else
					outputChatBox("Se ha producido un ERROR GRAVE. Pulsa F12 y reclama tus $" .. tostring( cantidad ) .. " perdidos.", player, 255, 0, 0)
				end
			else
				outputChatBox("No tienes tanto dinero para ingresar.", player, 255, 0, 0)
			end
		else
			outputChatBox("No eres el dueño del interior, y tampoco tienes llaves del mismo.", player, 255, 0, 0) return
		end
	end
end
addCommandHandler("cingresar", cingresarDinero)

function csacarDinero ( player, cmd, cantidad )
	if exports.players:isLoggedIn( player ) then
		if getElementDimension(player) == 0 then outputChatBox("No estás en un interior.", player, 255, 0, 0) return end
		local int = exports.interiors:getInterior(getElementDimension(player))
		if (int and int.characterID == exports.players:getCharacterID(player)) or exports.items:has(player, 2, getElementDimension(player)) then
			local caja, cajaID = cajaCercana(player)
			local cantidadActual = getDineroCaja( player, cajaID )
			if not cajaCercana( player ) then outputChatBox("No estás cerca de una caja fuerte.", player, 255, 0, 0) return end
			if not cantidad then outputChatBox("Sintaxis: /"..tostring(cmd).." [cantidad]", player, 255, 255, 255) return end
			local cantidad = tonumber(math.floor(cantidad))
			if cantidad < 1 then outputChatBox("No puedes retirar esta cantidad de dinero.", player, 255, 0, 0) return end
			if not cantidadActual then outputChatBox("Se ha producido un error, inténtalo de nuevo más tarde.", player, 255, 0, 0) return end
			if ( cantidadActual - cantidad ) < 0 then outputChatBox("No tienes tanto dinero en tu caja fuerte.", player, 255, 0, 0) return end
			if exports.sql:query_free("UPDATE muebles SET extra = " .. (cantidadActual - cantidad) .. " WHERE muebleID = " .. cajaID) then
				if exports.players:giveMoney( player, cantidad ) then
					exports.chat:me(player, "abre su caja fuerte y retira dinero de ella.")
					local time = getRealTime()
					local fecha = tostring(time.year+1900).."-"..tostring(time.month+1).."-"..tostring(time.monthday).." H: "..tostring(time.hour)..":"..tostring(time.minute)..":"..tostring(time.second)
					outputChatBox("Has retirado $" .. tostring ( cantidad ) .. " de tu caja ID "..tostring(cajaID)..".", player, 0, 255, 0)
					outputChatBox("Balance actual: ("..tostring(fecha).."): $" .. tostring (cantidadActual - cantidad) .. ".", player, 0, 255, 0)
					exports.logs:addLogMessage("/caja/"..getElementDimension(player).." - "..tostring(cajaID), "Retiro - $"..tostring(cantidad).." - Nombre PJ: "..tostring(getPlayerName(player):gsub("_", " "))..".")
				else 
					outputChatBox("Se ha producido un ERROR GRAVE. Pulsa F12 y reclama tus $" .. tostring( cantidad ) .. " perdidos.", player, 255, 0, 0)
				end
			else
				outputChatBox("No tienes tanto dinero para ingresar.", player, 255, 0, 0)
			end
		else
			outputChatBox("No eres el dueño del interior, y tampoco tienes llaves del mismo.", player, 255, 0, 0) return
		end
	end
end
addCommandHandler("cretirar", csacarDinero)

function consultarCajaSaldo ( player )
	local caja, cajaID = cajaCercana(player)
	local cantidadActual = getDineroCaja( player, cajaID )
	if not cajaCercana( player ) then outputChatBox("No estás cerca de una caja.", player, 255, 0, 0) return end
	if not cantidadActual then outputChatBox("Se ha producido un error, inténtalo de nuevo más tarde.", player, 255, 0, 0) return end
	local time = getRealTime()
	local fecha = tostring(time.year+1900).."-"..tostring(time.month+1).."-"..tostring(time.monthday).." H: "..tostring(time.hour)..":"..tostring(time.minute)..":"..tostring(time.second)	
	outputChatBox("El balance de tu caja ID "..tostring(cajaID).." ("..tostring(fecha)..") es de $" .. tostring (cantidadActual) .. ".", player, 0, 255, 0)
end
addCommandHandler("csaldo", consultarCajaSaldo)

-- FIN Script CAJA FUERTE --

-- Inicio código gimnasio --
local timer_bicicleta = {}
local timer_banco_pesas = {}

function toggleControlesGym (player,state)
	toggleControl(player,'left',state)
	toggleControl(player,'right',state)
	toggleControl(player,'backwards',state)
	toggleControl(player,'forwards',state)
	toggleControl(player,'fire',state)
	toggleControl(player,'jump',state)
end

function usarBiciletaEstatica(player, bicicleta)
	if getElementData(player, "gym_bici_estatica") == true then return end
	local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(player))
	if nivel < 2 then outputChatBox("No puedes usar el gimnasio porque necesitas nivel 2. Usa /objetivos.", player, 255, 0, 0) return end
	if nivel == 2 and not exports.objetivos:isObjetivoCompletado(14, exports.players:getCharacterID(player)) then
		exports.objetivos:addObjetivo(14, exports.players:getCharacterID(player), player)
	end
	setElementData(player,'gym_bici_estatica',true)
	setPedStat(player, 23, getElementData(player, "musculatura"))
	setPedStat(player, 21, getElementData(player, "gordura"))
	toggleControlesGym(player, false)
	local _,_,rz = getElementRotation(bicicleta)
	setPedRotation(player,rz+180)
	attachElements(player,bicicleta,0,0.6,1)
	setTimer(function()
		setPedAnimation(player,'GYMNASIUM','gym_bike_geton')
	end,50,1)
	setElementFrozen(player,true)
	setTimer(function()
		setElementData(player, "musculatura", getPedStat(player, 23))
		setElementData(player, "gordura", getPedStat(player, 21))
		bindKey(player,'w','up',reguladorEntrenamiento)
		bindKey(player,'w','down',reguladorEntrenamiento)
		bindKey(player,'space','down',pararEntrenamiento)
		triggerClientEvent(player,'mostrarTextoGym',player)
		setPedAnimation(player,'GYMNASIUM','gym_bike_still')
	end,1000,1)
end


function sinA(grados)
	return math.sin(math.rad(grados))
end

function cosA(grados)
	return math.cos(math.rad(grados))
end

function usarBancoPesas(player, banco, pesas)
	if getElementData(player, "gym_banco_pesas") == true then return end
	local bx, by, bz = getElementPosition(banco)
	local rx, ry, rz = getElementRotation(banco)
	setPedStat(player, 23, getElementData(player, "musculatura"))
	setPedStat(player, 21, getElementData(player, "gordura"))
	toggleControlesGym(player, false)
	setElementData(player, "gym_banco_pesas", true)
	removeElementData(player, "gym_fix_pos_pesas")
	setElementPosition(player, bx+sinA(rz), by-cosA(rz), bz+1, true)
	setElementRotation(player, 0, 0, rz, "default", true)
	setElementFrozen(player, true)
	setPedAnimation(player,'benchpress','gym_bp_geton', -1, false, false, false, true)
	setTimer(function()
		detachElements(pesas)
		setElementData(player, "musculatura", getPedStat(player, 23))
		setElementData(player, "gordura", getPedStat(player, 21))
		bindKey(player,'w','up',reguladorEntrenamiento)
		bindKey(player,'w','down',reguladorEntrenamiento)
		bindKey(player,'space','down',pararEntrenamiento, banco, pesas)
		triggerClientEvent(player,'mostrarTextoGym',player)
		exports.bone_attach:attachElementToBone(pesas,player,12,0.1,0,0,0,270,0)
		end, 4500, 1)
end

function reguladorEntrenamiento(player,key,keyState)
	triggerClientEvent(player,'onResetAFKTime',player)
	if(getElementData(player,'gym_banco_pesas')==true)then
		if not getElementData(player, 'gym_fix_pos_pesas') then
			local px, py, pz = getElementPosition(player)
			local rx, ry, rz = getElementRotation(player)
			setElementPosition(player, px, py, pz, true)
			setElementData(player, 'gym_fix_pos_pesas', true)
		end
		if(isTimer(timer_banco_pesas[player]))then 
			killTimer(timer_banco_pesas[player])
		end
		if(keyState=='down')then
			setPedAnimation(player,'benchpress','gym_bp_up_A', 2500, false, false, false, true)
			timer_banco_pesas[player]=setTimer(function()
				if not isElement(player) and isTimer(timer_banco_pesas[player]) then killTimer(timer_banco_pesas[player]) return end
				setPedAnimation(player,'benchpress','gym_bp_down', 2500, false, false, false, true)
				setPedAnimationProgress(player,'gym_bp_down',0.5)
				if not getElementData(player, "gym_musc_temp") then
					setElementData(player, "gym_musc_temp", 1)
				else
					setElementData(player, "gym_musc_temp", 1+getElementData(player, "gym_musc_temp"))
					if getElementData(player, "gym_musc_temp") >= 10 then
						removeElementData(player, "gym_musc_temp")
						setElementData(player,'musculatura',getElementData(player,'musculatura')+1)
					end
				end
			end,2500,1)
		end
	elseif(getElementData(player,"gym_bici_estatica")==true)then
		if(keyState=='down')then
			setPedAnimation(player,'GYMNASIUM','gym_bike_slow')
			timer_bicicleta[player]=setTimer(function()
				if not isElement(player) and isTimer(timer_bicicleta[player]) then killTimer(timer_bicicleta[player]) return end
				if(getElementData(player,'musculatura')<1000)then
					setElementData(player,'musculatura',getElementData(player,'musculatura')+1)
				end
			    if(getElementData(player,'gordura')>= 1)then
					setElementData(player,'gordura',getElementData(player,'gordura')-1)
				end
			end,30000,0)
		elseif(keyState=='up')then
			setPedAnimation(player,'GYMNASIUM','gym_bike_still')
			if(isTimer(timer_bicicleta[player]))then killTimer(timer_bicicleta[player]) end
		end
	end
end

function pararEntrenamiento (player, _, _, banco_pesas, pesas)
	if(getElementData(player,"gym_banco_pesas")==true)then
		removeElementData(player,"gym_banco_pesas")
		setElementCollisionsEnabled(banco_pesas, false)
		local px, py, pz = getElementPosition(player)
		local rx, ry, rz = getElementRotation(player)
		setElementPosition(player, px-sinA(rz), py+cosA(rz), pz, true)
		setPedAnimation(player,'benchpress','gym_bp_getoff', -1, false, true, false, true)
		setTimer(function()
			setElementFrozen(player, false)
			unbindKey(player,'w','up',reguladorEntrenamiento)
			unbindKey(player,'w','down',reguladorEntrenamiento)
			unbindKey(player,'space','down',pararEntrenamiento)
			setPedStat(player,23,getElementData(player,'musculatura'))
			setPedStat(player,21,getElementData(player,'gordura'))
			toggleControlesGym(player, true)
			exports.bone_attach:detachElementFromBone(pesas)
			attachElements(pesas, banco_pesas, -0.45, 0.5, 0.93, 90, 90, 0)
		end,2500,1)
		setTimer(setElementCollisionsEnabled, 3500, 1, banco_pesas, true)
	elseif (getElementData(player,"gym_bici_estatica")==true) then
		setElementFrozen(player,false)
		removeElementData(player, "gym_bici_estatica")
		setPedAnimation(player,'GYMNASIUM','gym_bike_getoff')
		setTimer(function()
			setPedAnimation(player)
			toggleControlesGym(player, true)
			unbindKey(player,'w','up',reguladorEntrenamiento)
			unbindKey(player,'w','down',reguladorEntrenamiento)
			unbindKey(player,'space','down',pararEntrenamiento)
			setPedStat(player,23,getElementData(player,'musculatura'))
			setPedStat(player,21,getElementData(player,'gordura'))
			detachElements(player)
			if(isTimer(timer_bicicleta[player]))then killTimer(timer_bicicleta[player]) end
		end,1500,1)
	end
	setCameraTarget(player,player)
	triggerClientEvent(player,'quitarTextoGym',player)
end
-- Fin código gimnasio --