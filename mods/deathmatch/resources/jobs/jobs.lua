function conseguirEmpleo (job)
	local actualjob = exports.players:getJob(source)
	if exports.players:setJob(source, job) then
		if job == "limpieza" then
			if job ~= actualjob then
			outputChatBox("[English] Ricardo Edmundo dice: Enhorabuena. Ya eres parte de esta empresa.", source, 230, 230, 230 )
			outputChatBox("Ricardo Edmundo le entrega las llaves del vehículo a "..getPlayerName(source):gsub("_", " "), source, 255, 40, 80)
			else
			outputChatBox("[English] Ricardo Edmundo dice: ¿Cómo dices? Si ya trabajas aquí...", source, 230, 230, 230 )
			outputChatBox("Ricardo Edmundo suspira", source, 255, 40, 80)
			end
		elseif job == "pescador" then
			if job ~= actualjob then
			outputChatBox("[English] John Pescanova dice: Enhorabuena. Ya puedes salir a trabajar.", source, 230, 230, 230 )
			outputChatBox("John Pescanova le entrega las llaves del barco a "..getPlayerName(source):gsub("_", " "), source, 255, 40, 80)
			else
			outputChatBox("[English] John Pescanova dice: ¿Cómo dices? Si ya trabajas aquí...", source, 230, 230, 230 )
			outputChatBox("John Pescanova suspira", source, 255, 40, 80)
			end
		elseif job == "repartidor" then
			if job ~= actualjob then
			outputChatBox("[English] Pedro Hidalgo dice: De puta madre, colega. Ya sabes, a currar.", source, 230, 230, 230 )
			outputChatBox("Pedro Hidalgo le entrega las llaves del vehículo a "..getPlayerName(source):gsub("_", " "), source, 255, 40, 80)
			else
			outputChatBox("[English] Pedro Hidalgo dice: ¿Qué dices, tronco? Si ya trabajas aquí...", source, 230, 230, 230 )
			outputChatBox("Pedro Hidalgo suspira", source, 255, 40, 80)
			end
		elseif job == "conductor" then
			if job ~= actualjob then
			outputChatBox("[English] Antonio Kelvin dice: Enhorabuena. Ya puedes salir a trabajar.", source, 230, 230, 230 )
			outputChatBox("Antonio Kelvin le entrega las llaves del vehículo a "..getPlayerName(source):gsub("_", " "), source, 255, 40, 80)
			else
			outputChatBox("[English] Antonio Kelvin dice: ¿Cómo dices? Si ya trabajas aquí...", source, 230, 230, 230 )
			outputChatBox("Antonio Kelvin suspira", source, 255, 40, 80)
		   end
		elseif job == "butanero" then
			if job ~= actualjob then
			outputChatBox("[English] Daniel Martinez dice: Enhorabuena. Ya puedes salir a trabajar.", source, 230, 230, 230 )
			outputChatBox("Daniel Martinez le entrega las llaves del vehículo a "..getPlayerName(source):gsub("_", " "), source, 255, 40, 80)
			else
			outputChatBox("[English] Daniel Martinez dice: ¿Cómo dices? Si ya trabajas aquí...", source, 230, 230, 230 )
			outputChatBox("Daniel Martinez suspira", source, 255, 40, 80)
		   end
		elseif job == "basurero" then
			if job ~= actualjob then
			outputChatBox("[English] Tino Svenson dice: Enhorabuena. Ya puedes salir a trabajar.", source, 230, 230, 230 )
			outputChatBox("Tino Svenson le entrega las llaves del vehículo a "..getPlayerName(source):gsub("_", " "), source, 255, 40, 80)
			else
			outputChatBox("[English] Tino Svenson dice: ¿Cómo dices? Si ya trabajas aquí...", source, 230, 230, 230 )
			outputChatBox("Tino Svenson suspira", source, 255, 40, 80)
		   end
		end
	end
end
addEvent("onConseguirEmpleo", true)
addEventHandler("onConseguirEmpleo", getRootElement(), conseguirEmpleo)

function dejarEmpleo()
	if exports.players:setJob(source, nil) then
		outputChatBox("Has dejado tu trabajo correctamente ya no trabajas en está empresa", source, 0, 255, 0)
		outputChatBox("Si quieres volver a trabajar con nosotros no dudes en venir!", source, 0, 255, 0)
	else
		outputChatBox("Ha ocurrido un error. Contacta con un staff lo antes posible.", source, 255, 0, 0)
	end
end
addEvent("onDejarEmpleo", true)
addEventHandler("onDejarEmpleo", getRootElement(), dejarEmpleo)
