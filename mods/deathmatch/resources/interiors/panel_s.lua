function guiInmobiliaria( player )
	if not getElementData(player, "abririnmo") == true then
		local sql = exports.sql:query_assoc("SELECT interiorID, interiorName, interiorPrice, interiorType FROM interiors WHERE characterID = 0 AND (interiorType = 1 OR interiorType = 2)")
		triggerClientEvent(player, "abririnmo", player, sql)
		setElementData(player, "abririnmo", true)
	end
end
addCommandHandler("locales", guiInmobiliaria)
addCommandHandler("casas", guiInmobiliaria)
addCommandHandler("negocios", guiInmobiliaria)
 
function marcarInterior (interiorID)
	if client and client == source and interiorID then
		local sql = exports.sql:query_assoc_single("SELECT * FROM interiors WHERE interiorID = "..tostring(interiorID))
		if sql then
			marcarInt(interiorID)
			outputChatBox("Se ha marcado el interior '"..tostring(sql.interiorName).."' en el mapa (Casa Verde)", source, 0, 255, 0)
		else
			outputChatBox("Error grave. Abre incidencia en el F1.", source, 255, 0, 0)
		end
	end
end
addEvent( "marcarInterior", true )
addEventHandler( "marcarInterior", root, marcarInterior )


function marcarInt(interiorID)
	if interiorID then
		local sql = exports.sql:query_assoc_single("SELECT * FROM interiors WHERE interiorID = "..tostring(interiorID))
		if sql then
			if sql.outsideDimension == 0 then -- El interior está en el exterior.
				createBlip( sql.outsideX, sql.outsideY, sql.outsideZ, 31, 2, 0, 0, 255, 255, 0, 99999.0, source )
			else
				marcarInt(sql.outsideDimension)
			end
		end
	end
end
