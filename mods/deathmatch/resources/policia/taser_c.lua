addEventHandler("onClientPlayerWasted", getRootElement(),
function(attacker, weapon, bodypart)
	if getElementModel(source) == 279 and weapon == 53 then return end 
	if (not attacker or getElementType(attacker) ~= "player" or not weapon) then return end
	if (getElementData(attacker, "tazerOn") and weapon == 24) or (getElementData(attacker, "gomaOn") and weapon == 25) then
		triggerServerEvent("onPlayerTazed", source, attacker, weapon, bodypart, 0)
	end
end)