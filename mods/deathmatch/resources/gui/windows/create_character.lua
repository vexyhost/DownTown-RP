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

local messageTimer
local messageCount = 0
local timer

local function setMessage( text )
	windows.create_character[#windows.create_character].text = text
	if messageTimer then
		killTimer( messageTimer )
	end
	messageCount = 0
	setTimer(
		function()
			messageCount = messageCount + 1
			if messageCount == 50 then
				windows.create_character[#windows.create_character].text = ""
				messageTimer = nil
			else
				windows.create_character[#windows.create_character].color = { 255, 255, 255, 5 * ( 50 - messageCount ) }
			end
		end, 100, 50
	)
end

local function tryCreate( key )
	local name = destroy["g:createcharacter:name"] and guiGetText( destroy["g:createcharacter:name"] )
	local edad = destroy["g:createcharacter:edad"] and math.floor(tonumber(guiGetText( destroy["g:createcharacter:edad"] )))
	local genero = destroy["g:createcharacter:genero"] and string.lower(guiGetText( destroy["g:createcharacter:genero"] ))
	local color = destroy["g:createcharacter:color"] and string.lower(guiGetText( destroy["g:createcharacter:color"] ))
	if tostring(genero) ~= "hombre" and tostring(genero) ~= "mujer" then setMessage ( "Género no válido. Pon Mujer o Hombre." ) return end
	if tostring(color) ~= "blanco" and tostring(color) ~= "negro" then setMessage ( "Color no válido. Pon Blanco o Negro." ) return end
	if not tonumber(edad) or tonumber(edad) <= 9 or tonumber(edad) >= 101 then setMessage ( "La edad debe de estar entre 10 y 100." ) return end
	local error = verifyCharacterName( name )
	if not error then
		if tostring(genero) == "hombre" then gen = 1 else gen = 2 end
		if tostring(color) == "negro" then col = 0 else col = 1 end
		triggerServerEvent( "gui:createCharacter", getLocalPlayer( ), name, edad, gen, col )
	else
		setMessage( error )
	end
end          

local function cancelCreate( )
	if exports.players:isLoggedIn( ) then
		hide( )
	else
		show( 'characters', true, true, true )
	end
end

--[[windows.create_character =
{
	{
		type = "label",
		text = "Ups, ups...",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "label",
		text = "Aún DownTown no ha abierto, así\nque no puedes crear nuevos personajes.\n\nPodrás crearlo cuando abramos.\nVisita foro.dt-mta.com para saber cuando.\n\nAdemás, ya puedes activar tu cuenta de foro. Haz clic en 'Activa tu cuenta' en el foro.\nSi no te aparece, es que ya está activada\n\n",
		alignX = "center",
	},
	{
		type = "button",
		text = "Atrás",
		onClick = cancelCreate,
	}  
}]]

windows.create_character =
{
	{
		type = "label",
		text = "Nuevo personaje",
		font = "bankgothic",
		alignX = "center",
	},
	{
		type = "label",
		text = "ATENCIÓN: Estos Datos son los de tu\nPersonaje, no los tuyos como Jugador.",
		alignX = "center",
	},
	{
		type = "label",
		text = "Nombre (Nombre Apellido)",
		alignX = "center",
	},
	{
		type = "edit",
		text = "Respuesta > ",
		id = "g:createcharacter:name",
		onAccepted = tryCreate,
	},
	{
		type = "label",
		text = "Edad ",
		alignX = "center",
	},
	{
		type = "edit",
		text = "Respuesta > ",
		id = "g:createcharacter:edad",
		onAccepted = tryCreate,
	},
	{
		type = "label",
		text = "Género (Hombre o Mujer)",
		alignX = "center",
	},
	{
		type = "edit",
		text = "Respuesta > ",
		id = "g:createcharacter:genero",
		onAccepted = tryCreate,
	},
		{
		type = "label",
		text = "Color (Blanco o Negro)",
		alignX = "center",
	},
	{
		type = "edit",
		text = "Respuesta > ",
		id = "g:createcharacter:color",
		onAccepted = tryCreate,
	},
	{
		type = "button",
		text = "Crear",
		onClick = tryCreate,
	},
	{
		type = "button",
		text = "Cancelar",
		onClick = cancelCreate,
	},                                
	{
		type = "label",
		text = "",
		alignX = "center",
	}
}
                             
addEvent( "players:characterCreationResult", true )
addEventHandler( "players:characterCreationResult", getLocalPlayer( ),
	function( code )
		if code == 0 then
			if exports.players:isLoggedIn( ) then
				show( 'characters', false, false, true )
			else
				show( 'characters', true, true, true )
			end
		elseif code == 1 then
			setMessage( "Ya existe un personaje con ese nombre." )
		end
	end
)