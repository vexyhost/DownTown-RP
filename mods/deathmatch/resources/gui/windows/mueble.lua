windows.mueble = {
	{
		type = "label",
		text = "Gestionar mueble",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = { }
	},
}

windows.mueble_armario = {
	{
		type = "label",
		text = "Armario",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{	
				image = "images/okay.png",
				title = "Coger cosas",
				text = "Haz clic aquí para coger cosas del armario.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						show("armario_coger", false, false, true, true)
						updateArmario()
					end
				end,
			},
			{	
				image = "images/info.png",
				title = "Guardar cosas",
				text = "Haz clic aquí para guardar cosas en el armario.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function (key)
					if key == 1 then
						show("armario_guardar", false, false, true, true)
						updateInventarioArmario()
					end
				end,
			},
			{	
				image = "images/error.png",
				title = "Cerrar armario",
				text = "Haz clic aquí para cerrar el armario.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
				end,
				onClick = function( ) hide() showCursor( false ) triggerServerEvent("onCerrarMueble", getLocalPlayer()) end,
			}
		}
	},
}

windows.armario_coger =
{
	{
		type = "label",
		text = "Armario",
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
		text = "Haz click en los objetos que quieras coger.",
		alignX = "center",
	},
	{
		type = "button",
		text = "Cerrar",
		id = "mcboton",
		onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onCerrarMueble", getLocalPlayer()) end,
	},
}

function updateArmario()
	local t = exports.muebles:getMueble()
	local nombre = {}
	windows.armario_coger[2].panes = { }
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
		table.insert( windows.armario_coger[2].panes,
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
						triggerServerEvent( "items:getFromMueble", getLocalPlayer(), v.index )
					end	
				end
			}
		)
	end
end



windows.armario_guardar =
{
	{
		type = "label",
		text = "Armario",
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
		onClick = function( ) hide( ) showCursor( false ) triggerServerEvent("onCerrarMueble", getLocalPlayer()) end,
	},
}
function updateInventarioArmario()
	local t = exports.items:get( getLocalPlayer( ) )
	local nombre = {}
	windows.armario_guardar[2].panes = { }
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
		table.insert( windows.armario_guardar[2].panes,
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
					triggerServerEvent( "items:giveToMueble", getLocalPlayer(), k )
					end	
				end
			}
		)
	end
end
