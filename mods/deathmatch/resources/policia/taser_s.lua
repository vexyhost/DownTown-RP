DURACION = 30 -- En segundos.

function toggleTazer(player)
	if exports.factions:isPlayerInFaction(player, 1) or exports.factions:isPlayerInFaction(player, 5) then
		setElementData(player, "tazerOn", not getElementData(player, "tazerOn"))
		outputChatBox("Has "..(getElementData(player, "tazerOn") and "activado" or "desactivado").." el tazer.", player, 255, 255, 0)
	end
end
addCommandHandler("tazer", toggleTazer)

function toggleGoma(player) 
	if exports.factions:isPlayerInFaction(player, 1) then
		setElementData(player, "gomaOn", not getElementData(player, "gomaOn"))
		outputChatBox("Has "..(getElementData(player, "gomaOn") and "cargado" or "descargado").." los cartuchos de goma.", player, 255, 255, 0)
	end
end
addCommandHandler("goma", toggleGoma)

function ejecutarTazer(attacker, weapon, parte)
	if not attacker or not weapon or getElementType(attacker) ~= "player" or not exports.factions:isPlayerInFaction(attacker, 1) then return end
	if (getElementData(attacker, "tazerOn") and weapon == 24) or (getElementData(attacker, "gomaOn") and weapon == 25) then
		if not getElementData(source, "tazed") then
			setElementData (source, "tazed", true)
			setElementFrozen (source, true)
			setPedAnimation(source, "crack", "crckidle1", DURACION*1000, true, true, false)
			setTimer ( 		function (p)
			removeElementData(p, "tazed")
			setElementFrozen(p, false)
			end
			, DURACION*1000, 1, source )
		end
	end
end
addEvent("onPlayerTazed", true)
addEventHandler("onPlayerTazed", getRootElement(), ejecutarTazer)