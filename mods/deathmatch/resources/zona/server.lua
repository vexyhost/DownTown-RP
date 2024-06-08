addEvent("onJugadorFueraDeZonaDeRol", true)
addEventHandler("onJugadorFueraDeZonaDeRol", root,
function()
	if exports.admin:avisoStaff("ALERTA: El jugador "..getPlayerName(source):gsub("_", " ").. " ha salido de la ZONA de ROL.", 255, 0, 0) then
		outputChatBox("Aviso dado al staff.", source, 0, 255, 0)
	else
		if getElementData(source, "account:gmduty") == true then return end
		exports.jail:serverJail(source, 20, "#17 Fuera de Zona de Rol")
		local sancionID = exports.sql:query_insertid( "INSERT INTO sanciones (userID, staffID, regla, validez) VALUES (" .. table.concat( { tonumber(exports.players:getUserID(source)), -1, 17, 1 }, ", " ) .. ")" )
	end
end)