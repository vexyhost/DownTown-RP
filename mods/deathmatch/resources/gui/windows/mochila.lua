windows.mochila = {
	{
		type = "label",
		text = "Mochila",
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
				text = "Haz clic aquí para sacar cosas de la mochila.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						show("mochila_sacar", false, false, true, true)
						updateMochila()
					end
				end,
			},
			{
				image = "images/info.png",
				title = "Guardar cosas",
				text = "Haz clic aquí para guardar cosas en la mochila.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						show("mochila_guardar", false, false, true, true)
						updateInventarioMochila()
					end
				end,
			},
			{
				image = "images/error.png",
				title = "Tirar mochila",
				text = "Haz clic aquí para tirar la mochila al suelo.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function( ) hide() showCursor( false ) triggerServerEvent("onTirarMochila", getLocalPlayer()) end,
			},
			{	
				image = "images/error.png",
				title = "Cerrar mochila",
				text = "Haz clic aquí para cerrar la mochila.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function( ) hide() showCursor( false ) triggerServerEvent("onCerrarMochila", getLocalPlayer()) end,
			}
		}
	},
}

windows.mochila_sacar =
{
	{
		type = "label",
		text = "Mochila",
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
		id = "mocboton",
		onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onCerrarMochila", getLocalPlayer()) end,
	},
}

function updateMochila()
	local t = exports.items:getMochila()
	local nombre = {}
	windows.mochila_sacar[2].panes = { }
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
		table.insert( windows.mochila_sacar[2].panes,
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
						triggerServerEvent( "items:getFromMochila", getLocalPlayer(), v.index )
					end	  
				end
			}
		)
	end
end
     
windows.mochila_guardar =
{
	{
		type = "label",
		text = "Mochila",
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
		id = "mocboton2",
		onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onCerrarMochila", getLocalPlayer()) end,
	},
}

function updateInventarioMochila()
	local t = exports.items:get( getLocalPlayer( ) )
	local nombre = {}
	windows.mochila_guardar[2].panes = { }
	for k, v in ipairs (t) do
		if v.item ~= 12 then
			if v and v.item and v.item == 27 then 
				nombre[k] = exports.muebles:getNombreMueble(v.value)
			else                                                           
				if v.name and tostring(v.name) and tostring(v.name) ~= "" then 
					nombre[k] = v.name
				else 
					nombre[k] = exports.items:getName(v.item)	
				end
			end
			table.insert( windows.mochila_guardar[2].panes,
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
						triggerServerEvent( "items:giveToMochila", getLocalPlayer(), k )
						end	  
					end
				}
			)
		end
	end
end 


windows.mochila_sacar_otro =
{
	{
		type = "label",
		text = "Mochila (Otro)",
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
		text = "Solo puedes ver cosas, no usarlas.",
		alignX = "center",
	},
	{
		type = "button",
		text = "Cerrar",
		id = "mocboton",
		onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onCerrarMochila", getLocalPlayer()) end,
	},
}

function updateMochila2(t)
	local nombre = {}
	windows.mochila_sacar_otro[2].panes = { }
	if t then
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
			table.insert( windows.mochila_sacar_otro[2].panes,
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
							outputChatBox("No puedes interactuar con cosas de la mochila.", 255, 0, 0)
						end	  
					end
				}
			)
		end
	end
	triggerEvent("onCursor", getLocalPlayer())
	show("mochila_sacar_otro")
end
addEvent("onRequestAnotherMochila", true)
addEventHandler("onRequestAnotherMochila", getRootElement(), updateMochila2)