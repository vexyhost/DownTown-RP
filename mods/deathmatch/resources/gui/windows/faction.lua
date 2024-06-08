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

Copyright (C) 2017  DownTown County Roleplay

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local localPlayer = getLocalPlayer( )
local maxRanks = 20
--

local function leave( faction )
	triggerServerEvent( "faction:leave", localPlayer, faction )
	hide( )
	windows.faction[2].content = { }
end

--

windows.faction =
{
	widthScale = 2,
	{
		type = "label",
		text = "",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "grid",
		columns =
		{
			{ name = "Nombre", width = 0.2 },
			{ name = "Derechos", width = 0.2, alignX = "center" },
			{ name = "Rango", width = 0.2, alignX = "center" },
			{ name = "Sueldo", width = 0.2, alignX = "center" },
			{ name = "Actividad", width = 0.2, alignX = "center" }
		},
		content = { }
	},
	{
		type = "grid",
		columns = { },
		content = { }
	},
	{
		type = "label",
		text = "",
		font = "bankgothic",
		alignX = "center",
	},
}

local function isInLeftHalf( cursor, pos )
	return cursor[1] <= ( pos[1] + pos[3] ) / 2
end

local rightNames = { [0] = "-", [1] = "Lider", [2] = "Directivo" }
local rankNames = { }

local function buildRanksWindow( fnum )
	windows.faction_ranks =
	{
		{
			type = "label",
			text = "Rangos",
			font = "bankgothic",
			alignX = "center",
		}
	}
	
	for key, value in ipairs( rankNames ) do
		table.insert( windows.faction_ranks,
			{
				type = "edit",
				text = "Rango #" .. key,
				id = "g:faction_ranks:" .. key,
				default = value,
				maxlength = 64,
			}
		)
	end
	
	table.insert( windows.faction_ranks,
		{
			type = "button",
			text = "Crear rango",
			onClick = function( key )
					if key == 1 then
						local endEdits = #windows.faction_ranks - 3
						if endEdits <= maxRanks then
							table.insert( windows.faction_ranks, endEdits + 1,
								{
									type = "edit",
									text = "Rango #" .. endEdits,
									id = "g:faction_ranks:" .. endEdits,
									maxlength = 64,
								}
							)
						end
					end
				end
		}
	)
	table.insert( windows.faction_ranks,
		{
			type = "button",
			text = "Guardar y volver",
			onClick = function( key )
					if key == 1 then
						-- collect all ranks
						local ranks = { }
						for i = 1, 20 do
							if destroy[ "g:faction_ranks:" .. i ] then
								ranks[ i ] = guiGetText( destroy[ "g:faction_ranks:" .. i ] )
							else
								break
							end
						end
						
						-- cut empty ranks at the rock bottom
						for i = #ranks, 1, -1 do
							if ranks[ i ] == "" then
								ranks[ i ] = nil
							else
								break
							end
						end
						
						if #ranks > 0 then
							-- update for ourselves
							rankNames = ranks
							
							-- refresh our view
							for key, value in ipairs( windows.faction[2].content ) do
								value[3].text = ranks[ value[3].numRank ] or ranks[ #ranks ]
								value[3].ctext = value[3].text
							end
							
							-- tell the server
							triggerServerEvent( "faction:updateranks", localPlayer, fnum, ranks )
						else
							outputChatBox( "Necesitas introducir al menos un rango.", 255, 0, 0 )
						end
						-- back to the faction menu
						show( 'faction', true )
					end
				end
		}
	)
	table.insert( windows.faction_ranks,
		{
			type = "button",
			text = "Cancelar",
			onClick = function( key )
					if key == 1 then
						show( 'faction', true )
					end
				end
		}
	)
end 

function updateFaction( fnum, members, presupuesto, name, ranks )
	local presupuesto = tostring(presupuesto)
	local buttons = { { "Dejar empresa", function( ) leave( fnum ) end }, { "Cerrar ventana", hide } }
	rankNames = ranks
	windows.faction[1].text = name
	windows.faction[4].text = "PRESUPUESTO: "..tostring(presupuesto).."$"
	local grid = { }
	local ownRights = 0
	local ownName = getPlayerName( localPlayer ):gsub( "_", " " )
	local duty = getElementData( localPlayer, "account:gmduty" )
	for key, value in ipairs( members ) do
		if value[1] == ownName then
			ownRights = value[2]
			break
		end
	end
	for key, value in ipairs( members ) do
		local t = { }
		
		table.insert( t, value[1] )
		
		-- promote/demote rights
		local rights = rightNames[ value[2] ]
		if ownRights == 2 and value[1] ~= ownName or duty == true then
			local a =
			{
				numRights = value[2],
				text = rights
			}
			
			a.onRender = function( cursor, pos )
				a.text = rights
				a.color = nil
			end
			
			a.onHover = function( cursor, pos )
				if isInLeftHalf( cursor, pos ) then
					if a.numRights > 0 then
						a.text = rightNames[ a.numRights - 1 ]
						a.color = { 255, 127, 127 }
					end
				else
					if a.numRights < 2 then
						a.text = rightNames[ a.numRights + 1 ]
						a.color = { 255, 127, 127 }
					end
				end
			end
			
			a.onClick = function( key, cursor, pos )
				if key == 1 then
					if isInLeftHalf( cursor, pos ) then
						if a.numRights > 0 then
							if triggerServerEvent( "faction:demoterights", localPlayer, fnum, value[1], a.numRights - 1 ) then
								a.numRights = a.numRights - 1
								rights = rightNames[ a.numRights ]
							end
						end
					else
						if a.numRights < 2 then
							if triggerServerEvent( "faction:promoterights", localPlayer, fnum, value[1], a.numRights + 1 ) then
								a.numRights = a.numRights + 1
								rights = rightNames[ a.numRights ]
							end
						end
					end
				end
			end
			table.insert( t, a )
		else
			table.insert( t, { text = rights, numRights = value[2] } )
		end
		table.insert( t, a )
		
		local rank = rankNames[ value[3] ] or value[3]
		if ownRights >= 1 or duty == true then
			local a =
			{
				text = rank,
				numRank = value[3],
				ctext = rank
			}
			
			a.onRender = function( cursor, pos )
				a.text = a.ctext
				a.color = nil
			end
			
			a.onHover = function( cursor, pos )
				if isInLeftHalf( cursor, pos ) then
					if a.numRank > 1 then
						a.text = rankNames[ a.numRank - 1 ]
						a.color = { 255, 127, 127 }
					end
				else
					if a.numRank < #rankNames then
						a.text = rankNames[ a.numRank + 1 ]
						a.color = { 255, 127, 127 }
					end
				end
			end
			
			a.onClick = function( key, cursor, pos )
				if key == 1 then
					if isInLeftHalf( cursor, pos ) then
						if a.numRank > 1 then
							if triggerServerEvent( "faction:demote", localPlayer, fnum, value[1], a.numRank - 1 ) then
								a.numRank = a.numRank - 1
								a.ctext = rankNames[ a.numRank ]
							end
						end
					else
						if a.numRank < #rankNames then
							if triggerServerEvent( "faction:promote", localPlayer, fnum, value[1], a.numRank + 1 ) then
								a.numRank = a.numRank + 1
								a.ctext = rankNames[ a.numRank ]
							end
						end
					end
				end
			end
			
			table.insert( t, a )
		else
			table.insert( t, { text = rankNames[ value[3] ] or value[3], numRank = value[3], ctext = rankNames[ value[3] ] or value[3] } )
		end
		local sueldo = value[4]
		if ownRights == 2 or duty == true then
			local a = { text = sueldo }
			a.onRender = function( cursor, pos )
				a.text = sueldo.."$"
				a.color = nil
			end
			
			a.onHover = function( cursor, pos )
				if ownRights == 2 or duty == true then
					a.text = "Cambiar sueldo"
					a.color = { 255, 127, 127 }
				end
			end
			local function click( ) 
			local sueldo = tonumber(guiGetText( destroy[ "g:faction_sueldo:cantidad" ] ))
				if sueldo and math.floor(sueldo) > 199 and math.floor(sueldo) < 801 then
					hide( )
					triggerServerEvent( "faction:cambiarsueldo", localPlayer, fnum, getElementData(localPlayer, "nsueldo"), math.floor(sueldo) )
					triggerServerEvent( "faction:show", localPlayer, -fnum )
				end
			end
			windows.faction_sueldo =
		{
			{
				type = "label",
				text = "Cambiar sueldo",
				font = "bankgothic",
				alignX = "center",
			},
			{
				type = "label",
				text = "Máximo 800$ y mínimo 200$.",
				alignX = "center",
			},
			{
				type = "edit",
				text = "Sueldo:",
				id = "g:faction_sueldo:cantidad",
				onAccepted = click,
			},
			{
				type = "button",
				text = "Cambiar",
				onClick = click,
			},
			{
				type = "button",
				text = "Cerrar",
				onClick = function( ) show( 'faction' ) end,
			},
		}
			
			a.onClick = function( k, cursor, pos )
				if k == 1 then
					if ownRights == 2 or duty == true then
						setElementData(localPlayer, "nsueldo", value[1])
						show( 'faction_sueldo', true )
					end
				end
			end
			table.insert( t, a )
		else
			table.insert( t, tostring(sueldo).."$" )
		end
		local lastOnline = value[5] == -1 and "Conectado" or value[5] == 0 and "Hoy" or value[5] == 1 and "Ayer" or value[5] and ( value[5] .. " días antes" ) or "Nunca"
		if ownRights >= 1 and value[1] ~= ownName or duty == true then
			local a = { text = lastOnline }
			
			a.onRender = function( cursor, pos )
				a.text = lastOnline
				a.color = nil
			end
			
			a.onHover = function( cursor, pos )
				if ownRights > t[2].numRights or duty == true then
					a.text = "Expulsar"
					a.color = { 255, 127, 127 }
				end
			end
			
			a.onClick = function( k, cursor, pos )
				if k == 1 then
					if ownRights > t[2].numRights or duty == true then
						if triggerServerEvent( "faction:kick", localPlayer, fnum, value[1] ) then
							table.remove( windows.faction[2].content, key )
						end
					end
				end
			end
			
			table.insert( t, a )
		else
			table.insert( t, lastOnline )
		end
		
		if value[5] == -1 then
			t.color = { 2, 224, 2 }
		end
		
		table.insert( grid, t )
	end
	
	windows.faction[2].content = grid
	
	if ownRights >= 1 or duty == true then
		local function click( )
			local player = getPlayerFromName( guiGetText( destroy[ "g:faction_invite:player" ] ):gsub( " ", "_" ) )
			if player and player ~= localPlayer then
				triggerServerEvent( "faction:join", player, fnum )
				hide( )
				triggerServerEvent( "faction:show", localPlayer, -fnum )
			end
		end
		
		windows.faction_invite =
		{
			{
				type = "label",
				text = "Invitar jugador",
				font = "bankgothic",
				alignX = "center",
			},
			{
				type = "edit",
				text = "Nombre",
				id = "g:faction_invite:player",
				onAccepted = click,
			},
			{
				type = "button",
				text = "Invitar",
				onClick = click,
			},
			{
				type = "button",
				text = "Cerrar",
				onClick = function( ) show( 'faction' ) end,
			},
		}
		
		table.insert( buttons, { "Invitar jugador", function( ) show( 'faction_invite', true ) end } )
		
		--
		
		if ownRights == 2 or duty == true then
			table.insert( buttons, { "Editar rangos", function( ) buildRanksWindow( fnum ) show( 'faction_ranks', true ) end } )
		else
			windows.faction_ranks = nil
		end
	else
		windows.faction_invite = nil
	end

	-- custom button stuff
	windows.faction[3].columns = { { name = "", width = 0.1 }, { name = "", width = 0.1 } }
	windows.faction[3].content = { { "", "" } }
	local buttonwidth = 0.8 / #buttons
	for k, v in ipairs( buttons ) do
		table.insert( windows.faction[3].columns, k + 1, { name = "", width = buttonwidth, alignX = "center" } )
		local a = { text = v[1], onClick = function( key ) if key == 1 then v[2]( ) end end }
		a.onRender = function( ) a.color = nil end
		a.onHover = function( ) a.color = { 255, 127, 127 } end
		table.insert( windows.faction[3].content[1], k + 1, a )
	end
end
