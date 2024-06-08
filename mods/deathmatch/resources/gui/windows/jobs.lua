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

local closeButton =
{
	type = "button",
	text = "Cerrar",
	onClick = function( key )
			if key == 1 then
				hide( )
				
				windows.jobs = { widthScale = 0.5, closeButton }
			end
		end,
}

windows.jobs = { closeButton }

function updateJobs( content )
	-- scrap what we had before
	windows.jobs = {
		widthScale = 0.5,
		onClose = function( )
				triggerServerEvent( "jobs:close", getLocalPlayer( ) )
				windows.jobs = { widthScale = 0.5, closeButton }
			end,
		{
			type = "label",
			text = "Empleos",
			font = "bankgothic",
			alignX = "center",
		},
		{
			type = "pane",
			panes = { }
		}
	}
	
	-- let's add all items
	for k, value in ipairs( content ) do
		local description = value.description or exports.items:getDescription( value.itemID )
		table.insert( windows.jobs[2].panes,
			{
				image = exports.items:getImage( value.itemID, value.itemValue, value.name ) or ":players/images/skins/-1.png",
				title = value,
				onHover = function( cursor, pos )
						dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 31 } ) ) )
					end,
				onClick = function( key )
						if key == 1 then
							triggerServerEvent( "jobs:select", getLocalPlayer( ), value:lower( ) )
							
							
							setTimer( hide, 50, 1 )
							windows.jobs = { widthScale = 0.5, closeButton }
						end
					end,
			}
		)
	end
	
	-- add a close button as well
	table.insert( windows.jobs, closeButton )
end


windows.jobs_limpieza = {
	{
		type = "label",
		text = "Limpieza",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{	
				image = "images/okay.png",
				title = "Conseguir empleo",
				text = "¿Necesitas dinero? La empresa de limpieza de\nBlueberry está buscando a gente.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						triggerServerEvent("onConseguirEmpleo", getLocalPlayer(), "limpieza")
					end
				end,
			},
			{	
				image = "images/error.png",
				title = "Dejar empleo",
				text = "¿Has encontrado un trabajo mejor?¿No te llega el\nsueldo? Ha llegado la hora de que dejes tu empleo",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function (key)
					triggerServerEvent("onDejarEmpleo", getLocalPlayer(), "limpieza")
				end,
				onCreate = function ()
				table.insert( windows.jobs_limpieza, closeButton )
				end,
			}
		}
	},
	{
	  closeButton
	},
}

windows.jobs_pescador = {
	{
		type = "label",
		text = "Pescador",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{	
				image = "images/okay.png",
				title = "Conseguir empleo",
				text = "¿Necesitas dinero? Te damos la oportunidad de \nconseguirlo pescando.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						triggerServerEvent("onConseguirEmpleo", getLocalPlayer(), "pescador")
					end
				end,
			},
			{	
				image = "images/error.png",
				title = "Dejar empleo",
				text = "¿Has encontrado un trabajo mejor?¿No te llega el\nsueldo? Ha llegado la hora de que dejes tu empleo",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function (key)
					triggerServerEvent("onDejarEmpleo", getLocalPlayer(), "pescador")
				end,
				onCreate = function ()
				table.insert( windows.jobs_pescador, closeButton )
				end,
			}
		}
	},
	{
	  closeButton
	},
}


windows.jobs_repartidor = {
	{
		type = "label",
		text = "Repartidor",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{	
				image = "images/okay.png",
				title = "Conseguir empleo",
				text = "¿Necesitas dinero? Estamos que no damos a basto chico. Trabaja aquí, por favor.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						triggerServerEvent("onConseguirEmpleo", getLocalPlayer(), "repartidor")
					end
				end,
			},
			{	
				image = "images/error.png",
				title = "Dejar empleo",
				text = "¿Has encontrado un trabajo mejor?¿No te llega el\nsueldo? Ha llegado la hora de que dejes tu empleo",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function (key)
					triggerServerEvent("onDejarEmpleo", getLocalPlayer(), "repartidor")
				end,
				onCreate = function ()
				table.insert( windows.jobs_repartidor, closeButton )
				end,
			}
		}
	},
	{
	  closeButton
	},
}


windows.jobs_conductor = {
	{
		type = "label",
		text = "Conductor",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{	
				image = "images/okay.png",
				title = "Conseguir empleo",
				text = "¿Necesitas dinero? Te damos la oportunidad de \nconseguirlo conduciendo.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						triggerServerEvent("onConseguirEmpleo", getLocalPlayer(), "conductor")
					end
				end,
			},
			{	
				image = "images/error.png",
				title = "Dejar empleo",
				text = "¿Has encontrado un trabajo mejor?¿No te llega el\nsueldo? Ha llegado la hora de que dejes tu empleo",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function (key)
					triggerServerEvent("onDejarEmpleo", getLocalPlayer(), "conductor")
				end,
				onCreate = function ()
				table.insert( windows.jobs_conductor, closeButton )
				end,
			}
		}
	},
	{
	  closeButton
	},
}


windows.jobs_butanero = {
	{
		type = "label",
		text = "Butanero",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{	
				image = "images/okay.png",
				title = "Conseguir empleo",
				text = "¿Necesitas dinero? Te damos la oportunidad de \nconseguirlo conduciendo.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						triggerServerEvent("onConseguirEmpleo", getLocalPlayer(), "butanero")
					end
				end,
			},
			{	
				image = "images/error.png",
				title = "Dejar empleo",
				text = "¿Has encontrado un trabajo mejor?¿No te llega el\nsueldo? Ha llegado la hora de que dejes tu empleo",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function (key)
					triggerServerEvent("onDejarEmpleo", getLocalPlayer(), "butanero")
				end,
				onCreate = function ()
				table.insert( windows.jobs_butanero, closeButton )
				end,
			}
		}
	},
	{
	  closeButton
	},
}



windows.jobs_basurero = {
	{
		type = "label",
		text = "Vertedero San Fierro",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{	
				image = "images/okay.png",
				title = "Conseguir empleo",
				text = "¿Necesitas dinero? Te damos la oportunidad de \nconseguirlo conduciendo camiones de basura.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						triggerServerEvent("onConseguirEmpleo", getLocalPlayer(), "basurero")
					end
				end,
			},
			{	
				image = "images/error.png",
				title = "Dejar empleo",
				text = "¿Has encontrado un trabajo mejor?¿No te llega el\nsueldo? Ha llegado la hora de que dejes tu empleo",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function (key)
					triggerServerEvent("onDejarEmpleo", getLocalPlayer(), "basurero")
				end,
				onCreate = function ()
				table.insert( windows.jobs_basurero, closeButton )
				end,
			}
		}
	},
	{
	  closeButton
	},
}