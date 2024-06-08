local closeButton =
{
	type = "button",
	text = "Cerrar",
	onClick = function( key )
			if key == 1 then
				hide( )
				windows.maletero = { widthScale = 0.5, closeButton }
			end
		end,
}

windows.maletero = {
	{
		type = "label",
		text = "Gestionar vehículo",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = { }
	},
}

function updateGUIVehiculo(option)
	windows.maletero[2].panes = { }
	if not option then return false end
		if option == 0 or option == 1 then
			table.insert( windows.maletero[2].panes,
				{
					image = ":gui/images/maletero.png",
					title = "Maletero",
					text = "Haz click aquí para sacar/guardar cosas en el maletero.",
					onHover = function( cursor, pos )
							dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
						end,
					onClick = function( key )
							if key == 1 then
								show("maletero_gui")
								updateMaletero()
								triggerServerEvent("onRolDeAbrirMaletero", getLocalPlayer())
							end
						end,
					wordBreak = true,
				}
			)
		end
		if option == 0 or option == 1 or option == 2 or option == 3 then
			table.insert( windows.maletero[2].panes,
				{
					image = ":gui/images/capo.png",
					title = "Capó",
					text = "Haz click aquí para abrir o cerrar el capó del vehículo.",
					onHover = function( cursor, pos )
							dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
						end,
					onClick = function( key )
							if key == 1 then
								hide( ) 
								showCursor( false ) 
								triggerServerEvent("onCapo", getLocalPlayer(), getLocalPlayer())
							end
						end,
					wordBreak = true,
				}
			)
		end
		if option == 1 or option == 3 or option == 4 then -- Policia
			table.insert( windows.maletero[2].panes,
			{
				image = ":gui/images/placa.png",
				title = "Revisar Maletero (Policía)",
				text = "Haz click aquí para revisar el maletero (sólo PD).",
				onHover = function( cursor, pos )
						dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
					end,
				onClick = function( key )
						if key == 1 then
							show("maletero_ver")
							updateMaleteroVer()
							triggerServerEvent("onRolDeAbrirMaletero", getLocalPlayer())
						end
					end,
				wordBreak = true,
			}
		)
		end
		table.insert( windows.maletero[2].panes,
			{
				image = ":gui/images/error.png",
				title = "Salir",
				text = "Haz click aquí para cerrar esta ventana.",
				onHover = function( cursor, pos )
						dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
					end,
				onClick = function( key )
						if key == 1 then
							hide( ) 
							showCursor( false ) 
							triggerServerEvent("onCerrarMaletero", getLocalPlayer())
						end
					end,
				wordBreak = true,
			}
		)
end
addEvent("onGUIVehiculo", true)
addEventHandler("onGUIVehiculo", getLocalPlayer(), updateGUIVehiculo)

windows.maletero_gui = {
	{
		type = "label",
		text = "Maletero",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{	
				image = "images/okay.png",
				title = "Sacar cosas",
				text = "Haz clic aquí para sacar cosas del maletero.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						show("maletero_coger")
						updateMaletero()
					end
				end,
			},
			{	
				image = "images/info.png",
				title = "Guardar cosas",
				text = "Haz clic aquí para guardar cosas en el maletero.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						show("maletero_guardar")
						updateInventarioMaletero()
					end
				end,
			},
			{	
				image = "images/error.png",
				title = "Cerrar maletero",
				text = "Haz clic aquí para cerrar el maletero.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onRolDeCerrarMaletero", getLocalPlayer()) triggerServerEvent("onCerrarMaletero", getLocalPlayer()) end,
			}
		}
	},
}

windows.maletero_coger =
{
	{
		type = "label",
		text = "Maletero",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "vpane",
		lines = 7,
		panes = { }
	},
	{
		type = "label",
		text = "Haz click en los objetos que quieras sacar.",
		alignX = "center",
	},
	{
		type = "button",
		text = "Cerrar",
		id = "mcboton",
		onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onRolDeCerrarMaletero", getLocalPlayer()) triggerServerEvent("onCerrarMaletero", getLocalPlayer()) end,
	},
}

function updateMaletero()
	local t = exports.vehicles:getMaletero()
	local nombre = {}
	windows.maletero_coger[2].panes = { }
	for k, v in ipairs (t) do		
		if v and v.item and v.item == 27 then 
			nombre[k] = exports.muebles:getNombreMueble(v.value)
		else                                                           
			if v.name and tostring(v.name) and tostring(v.name) ~= "" then 
				nombre[k] = v.name
			else 
				nombre[k] = exports.items:getName(v.item)	
			end
		end
		table.insert( windows.maletero_coger[2].panes,
			{
				onHover = function( cursor, pos )
				local width = dxGetTextWidth( nombre[k], 1, "default-bold" ) +5
				local height = 10 * ( 5 )
				dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( { 255, 255, 0, 63 } ) )
				dxDrawRectangle( pos[1] + 64, pos[2] - 52, width+65, height, tocolor( 0, 0, 0, 255 ), true )
				dxDrawText( "ID: "..tostring(v.value), pos[1] + 180, pos[2]+20 , pos[1] + width, pos[2] - height, tocolor( 160, 94, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )
				dxDrawText( "Nombre: "..tostring(nombre[k]), pos[1] + 200, pos[2]-15 , pos[1] + width, pos[2] - height, tocolor( 255, 255, 255, 255 ), 1, "default-bold", "center", "center", false, false, true )
				end,
				image = exports.items:getImage( v.item, v.value, tostring(nombre[k]) ) or ":players/images/skins/-1.png",
				onClick = function( key )
					if key == 1 then			
						triggerServerEvent( "items:getFromMaletero", getLocalPlayer(), v.index )
					end	
				end
			}
		)
	end
end

windows.maletero_ver =
{
	{
		type = "label",
		text = "Maletero (PD)",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "vpane",
		lines = 7,
		panes = { }
	},
	{
		type = "label",
		text = "Por seguridad, sólo puedes ver el maletero.",
		alignX = "center",
	},
	{
		type = "button",
		text = "Cerrar",
		id = "mcboton2",
		onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onRolDeCerrarMaletero", getLocalPlayer()) triggerServerEvent("onCerrarMaletero", getLocalPlayer()) end,
	},
}

function updateMaleteroVer()
	local t = exports.vehicles:getMaletero()
	local nombre = {}
	windows.maletero_ver[2].panes = { }
	for k, v in ipairs (t) do	
		if v and v.item and v.item == 27 then 
			nombre[k] = exports.muebles:getNombreMueble(v.value)
		else
			if v.name and tostring(v.name) and tostring(v.name) ~= "" then 
				nombre[k] = v.name
			else 
				nombre[k] = exports.items:getName(v.item)	
			end
		end
		table.insert( windows.maletero_ver[2].panes,
			{
				onHover = function( cursor, pos )
				local width = dxGetTextWidth( nombre[k], 1, "default-bold" ) +5
				local height = 10 * ( 5 )
				dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( { 255, 255, 0, 63 } ) )
				dxDrawRectangle( pos[1] + 64, pos[2] - 52, width+65, height, tocolor( 0, 0, 0, 255 ), true )
				dxDrawText( "ID: "..tostring(v.value), pos[1] + 180, pos[2]+20 , pos[1] + width, pos[2] - height, tocolor( 160, 94, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )
				dxDrawText( "Nombre: "..tostring(nombre[k]), pos[1] + 200, pos[2]-15 , pos[1] + width, pos[2] - height, tocolor( 255, 255, 255, 255 ), 1, "default-bold", "center", "center", false, false, true )
				end,
				image = exports.items:getImage( v.item, v.value, tostring(nombre[k]) ) or ":players/images/skins/-1.png"
			}
		)
	end
end


windows.maletero_guardar =
{
	{
		type = "label",
		text = "Maletero",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "vpane",
		lines = 7,
		panes = { }
	},
	{
		type = "label",
		text = "Haz click en los objetos que quieras guardar.",
		alignX = "center",
	},
	{
		type = "button",
		text = "Cerrar",
		id = "mgboton",
		onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onRolDeCerrarMaletero", getLocalPlayer()) triggerServerEvent("onCerrarMaletero", getLocalPlayer()) end,
	},
}

function updateInventarioMaletero()
	local t = exports.items:get( getLocalPlayer( ) )
	local nombre = {}
	windows.maletero_guardar[2].panes = { }
	for k, v in ipairs (t) do
		if v and v.item and v.item == 27 then 
			nombre[k] = exports.muebles:getNombreMueble(v.value)
		else
			if v.name and tostring(v.name) and tostring(v.name) ~= "" then 
				nombre[k] = v.name
			else 
				nombre[k] = exports.items:getName(v.item)	
			end
		end
		table.insert( windows.maletero_guardar[2].panes,
			{
				onHover = function( cursor, pos )
				local width = dxGetTextWidth( nombre[k], 1, "default-bold" ) +5
				local height = 10 * ( 5 )
				dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( { 255, 255, 0, 63 } ) )
				dxDrawRectangle( pos[1] + 64, pos[2] - 52, width+65, height, tocolor( 0, 0, 0, 255 ), true )
				dxDrawText( "ID: "..tostring(v.value), pos[1] + 180, pos[2]+20 , pos[1] + width, pos[2] - height, tocolor( 160, 94, 0, 255 ), 1, "default-bold", "center", "center", false, false, true )
				dxDrawText( "Nombre: "..tostring(nombre[k]), pos[1] + 200, pos[2]-15 , pos[1] + width, pos[2] - height, tocolor( 255, 255, 255, 255 ), 1, "default-bold", "center", "center", false, false, true )
				end,
				image = exports.items:getImage( v.item, v.value, tostring(nombre[k]) ) or ":players/images/skins/-1.png",
				onClick = function( key )
					if key == 1 then
						local idveh = getElementData(getLocalPlayer(), "mid")
						if v.item == 1 and tonumber(v.value) == tonumber(idveh) then
							outputChatBox("No puedes guardar la llave de tu vehículo en el maletero.", 255, 0, 0)
						else
							triggerServerEvent( "items:giveToMaletero", getLocalPlayer(), k )
						end
					end	
				end
			}
		)
	end
end
