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

function solicitar ( key ) 
 if destroy and destroy['g:cabina:numero'] then
	local numero = tonumber( guiGetText( destroy['g:cabina:numero'] ) )
	if numero then
	triggerServerEvent("llamadaCabina", getLocalPlayer( ), getLocalPlayer( ), numero)
	hide( )
	end
 end
end

function solicitarPhone ( key ) 
 if destroy and destroy['g:phones:numero'] then
	local numero = tostring(guiGetText( destroy['g:phones:numero'] ))
	if numero then
	triggerServerEvent("onRealizarLlamada", getLocalPlayer(), getLocalPlayer(), numero) 
	hide( ) 
	end
 end
end


windows.cabina_mostrarmenu =
{
	{
		type = "label",
		text = "Cabina",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "label",
		text = "Introduce el número al que deseas llamar.",
		alignX = "center",
	},
	{
		type = "edit",
		text = "Número:",
		id = "g:cabina:numero",
		onAccepted = solicitar,
	},
	{
		type = "button",
		text = "Llamar",
		onClick = solicitar,
	},
	{
		type = "button",
		text = "Colgar",
		onClick = function( )
		hide( ) 
		setElementData(getLocalPlayer( ), "cabina", false)
		end,
	}
}


windows.cabina_marcador =
{
	{
		type = "label",
		text = "Marcador",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "label",
		text = "Introduce el número al que deseas llamar.",
		alignX = "center",
	},
	{
		type = "edit",
		text = "Número:",
		id = "g:phones:numero",
		onAccepted = solicitarPhone,
	},
	{
		type = "button",
		text = "Llamar",
		onClick = solicitarPhone,
	},
	{
		type = "button",
		text = "Cancelar",
		onClick = function( )
		hide( ) 
		end,
	}
}