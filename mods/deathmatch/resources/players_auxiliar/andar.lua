local andarHombre =
    {
		[ 65 ] = true,
		[ 118 ] = true,
		[ 121 ] = true,
		[ 122 ] = true,
		[ 123 ] = true,
		[ 124 ] = true,
		[ 125 ] = true,
		[ 126 ] = true,
    }

	
local andarMujer =
    {
		[ 64 ] = true,
		[ 129 ] = true,
		[ 131 ] = true,
		[ 132 ] = true,
		[ 133 ] = true,
		[ 134 ] = true,
		[ 135 ] = true,  
		[ 136 ] = true,
		[ 137 ] = true,
    }

function cambiarAndar (player, cmd, id)
	local sql = exports.sql:query_assoc_single("SELECT genero FROM characters WHERE characterID = "..exports.players:getCharacterID(player))
	if id then
		if sql.genero == 1 then -- Hombre
			if andarHombre[tonumber(id)] then
				setPedWalkingStyle(player, tonumber(id))
				outputChatBox("Has establecido el estilo de andar "..tostring(id).." para tu personaje.", player, 0, 255, 0)
				exports.sql:query_free("UPDATE characters SET andar = '%s' WHERE characterID = "..exports.players:getCharacterID(player), tonumber(id))
			else
				outputChatBox("Estilo no válido. Usa /andar para ver los que puedes utilizar según tu género (Hombre)", player, 255, 0, 0)
			end
		elseif sql.genero == 2 then -- Mujer
			if andarMujer[tonumber(id)] then
				setPedWalkingStyle(player, tonumber(id))
				outputChatBox("Has establecido el estilo de andar "..tostring(id).." para tu personaje.", player, 0, 255, 0)
				exports.sql:query_free("UPDATE characters SET andar = '%s' WHERE characterID = "..exports.players:getCharacterID(player), tonumber(id))
			else
				outputChatBox("Estilo no válido. Usa /andar para ver los que puedes utilizar según tu género (Mujer)", player, 255, 0, 0)
			end
		end
	else
		outputChatBox("Usa /andar  [estilo]. Estilo acutal: "..tostring(getPedWalkingStyle(player)), player, 255, 255, 255)
		if sql.genero == 1 then -- Hombre
			outputChatBox("Estilos: 65, 118, 121, 122, 123, 124, 125, 126", player, 255, 255, 255)
		elseif sql.genero == 2 then -- Mujer
			outputChatBox("Estilos: 64, 129, 132, 133, 134, 135, 136, 137", player, 255, 255, 255)
		end
	end	
end
addCommandHandler("andar", cambiarAndar)

function onConectarseConPJ()
	local sql, error = exports.sql:query_assoc_single("SELECT genero, andar FROM characters WHERE characterID = "..exports.players:getCharacterID(source))
	if error then outputDebugString(error) return end
	if sql and not sql.andar then
		outputChatBox("ATENCIÓN: no tienes asignado un estilo de andar. Utiliza /andar para escoger uno.", source, 255, 0, 0)
		outputChatBox("Se te ha asignado uno por defecto según tu género.", source, 255, 0, 0)
		if sql.genero == 1 then -- Hombre
			setPedWalkingStyle(source, 65)
		elseif sql.genero == 2 then -- Mujer
			setPedWalkingStyle(source, 129)
		end
	elseif sql.andar then
		if sql.genero == 1 then
			if andarHombre[tonumber(sql.andar)] then
				setPedWalkingStyle(source, tonumber(sql.andar))
			else
				outputChatBox("ATENCIÓN: tu /andar no es válido. Utiliza /andar para escoger uno.", source, 255, 0, 0)
				outputChatBox("Se te ha asignado uno por defecto según tu género.", source, 255, 0, 0)
				setPedWalkingStyle(source, 65)
			end
		elseif sql.genero == 2 then
			if andarMujer[tonumber(sql.andar)] then
				setPedWalkingStyle(source, tonumber(sql.andar))
			else
				outputChatBox("ATENCIÓN: tu /andar no es válido. Utiliza /andar para escoger uno.", source, 255, 0, 0)
				outputChatBox("Se te ha asignado uno por defecto según tu género.", source, 255, 0, 0)
				setPedWalkingStyle(source, 129)
			end
		end
	end
end
addEventHandler("onCharacterLogin", getRootElement(), onConectarseConPJ) 