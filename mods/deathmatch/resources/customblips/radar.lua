local pCreados = false
local pVisibles = false
local bSur = false
local bEste = false
local bOeste = false
-- { x = 1184.21, y = -6454.42, z = 83.5, stop = true },
-- { x = 4384.96, y = -1593.35, z = 61.33, stop = true },
-- { x = -4410.96, y = -1667.97, z = -133.79, stop = true },

function showCardinalPoints()
	if pCreados == true then
		pVisibles = true
		setCustomBlipVisible(bSur, true)
		setCustomBlipVisible(bEste, true)
		setCustomBlipVisible(bOeste, true)
	else
		bSur = exports.customblips:createCustomBlip ( 1184, -8192, 16, 16, "sur.png", 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 )
		bEste = exports.customblips:createCustomBlip ( 8192, -1593.35, 16, 16, "este.png", 9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 )
		bOeste = exports.customblips:createCustomBlip ( -4410, -1593.35, 16, 16, "oeste.png", 99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 )
		pCreados = true
		pVisibles = true
	end
end
addEvent("onMostrarPuntosCardinales", true)
addEventHandler ( "onMostrarPuntosCardinales", getRootElement(), showCardinalPoints)

function hideCardinalPoints()
	if pCreados == true and pVisibles == true then
		pVisibles = false
		setCustomBlipVisible(bSur, pVisibles)
		setCustomBlipVisible(bEste, pVisibles)
		setCustomBlipVisible(bOeste, pVisibles)
	end
end
addEvent("onRequestLoginPanel", true)
addEventHandler ( "onRequestLoginPanel", getRootElement(), hideCardinalPoints)

function toggleCardinalPoints()
	if pVisibles == true then
		hideCardinalPoints()
	else
		showCardinalPoints()
	end
end
addCommandHandler("hud", toggleCardinalPoints)