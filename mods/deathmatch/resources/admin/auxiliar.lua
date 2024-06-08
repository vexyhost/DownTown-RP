function avisoStaff (mensaje, r, g, b)
	hayStaff = 0
	for k, v in ipairs(getElementsByType("player")) do
		if hasObjectPermissionTo( v, "command.modchat", false ) then
			hayStaff = 1
			outputChatBox(tostring(mensaje), v, r, g, b)
		end
	end
	if hayStaff == 1 then return true else return false end
end
addEvent("onMensajeStaff", true)
addEventHandler("onMensajeStaff", getRootElement(), avisoStaff)
     
function anularLlaves(objetoID, tipo)
	if tonumber(objetoID) and tonumber(tipo) then		
		exports.sql:query_free("DELETE FROM items WHERE item = "..tostring(tipo).." AND value = " .. objetoID )
		exports.sql:query_free("DELETE FROM items_muebles WHERE item = "..tostring(tipo).." AND value = " .. objetoID )
		exports.sql:query_free("DELETE FROM items_mochilas WHERE item = "..tostring(tipo).." AND value = " .. objetoID )
		exports.sql:query_free("DELETE FROM maleteros WHERE item = "..tostring(tipo).." AND value = " .. objetoID )
		for k, v in ipairs(getElementsByType("player")) do
			if exports.players:isLoggedIn(v) then
				exports.items:load(v, true)
			end
		end
	end  
end