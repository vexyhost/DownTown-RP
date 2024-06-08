function newsPaperEditt(player) 
	if exports.factions:isPlayerInFaction ( player, 4) then
		triggerClientEvent(player, "ShowEditor", player)
		outputChatBox("Se ha abierto el editor del periódico de Palomino Creek News Department.", player, 0, 255, 0, false)
	else
		outputChatBox("(( No perteneces a PCND ))", player, 255, 0, 0, false)
	end
end
addCommandHandler("editarperiodico", newsPaperEditt)

function leerperiodico(player)
	if getElementData(player, "newspaper") == true then
		exports.chat:me(player, "saca el periodico y empieza a leerlo.")
		local textFile = fileOpen("text.txt", true)
        local text = fileRead(textFile, 20000)
		triggerClientEvent(player, "showStandGUI", player, tostring(text))
		fileClose(textFile)
	else
		outputChatBox("(( No tienes un periódico comprado. ))", player, 255, 0, 0, false)
	end
end
addCommandHandler("leerperiodico", leerperiodico)

function tirarperiodico(player)
	if not getElementData(player, "newspaper") == true then outputChatBox("(( Cómo vas a tirar algo que no tienes... ))", player, 255, 0, 0) return end
	   exports.chat:me(player, "coge y tira el periódico a la papelera.")
	   setElementData(player, "newspaper", false)
end
addCommandHandler("tirarperiodico", tirarperiodico)


function setDaNewsText(p, message)
local newsTxd = fileOpen("text.txt", false)
	if newsTxd then
	fileWrite(newsTxd, "")
	fileWrite(newsTxd, tostring(message))
	fileClose(newsTxd)
	else
	fileCreate("text.txt")
	fileOpen("text.txt", false)
	fileWrite(newsTxd, "")
	fileWrite(newsTxd, tostring(message))
	fileClose(newsTxd)
	outputChatBox("¡Has actualizado el diario!", p, 0, 255, 0, false)
	setElementData (player, "newspaper", false)
	end
end
addEvent("saveNewsText", true)
addEventHandler("saveNewsText", getRootElement(), setDaNewsText)


function showAgain(player)
	local textFile = fileOpen("text.txt", true)
    local text = fileRead(textFile, 10000) 
	triggerClientEvent(player, "showStandGUI", player, tostring(text))
	fileClose(textFile)
end
addEvent("loadNewsText", true)
addEventHandler("loadNewsText", getRootElement(), showAgain)