--[[
Sistema de bodas - Downtown Roleplay - FrankGT
]]


-- Estados
-- 0 Soltero
-- 1 Divorciado
-- Mayor a 1 significa un charachter id lo cual el estado es Casado


-- vamos a casarnos , a ver lo que duran :v luego se pelean por el perro.
-- Ya no se pelean por el perro
-- http://www.diarioinformacion.com/vida-y-estilo/mascotas/2017/12/12/nueva-ley-mascotas-tendran-custodia/1967271.html
function casarse ( thePlayer, commandName, otherPlayer )
		local other, name = exports.players:getFromName( thePlayer, otherPlayer )
		if thePlayer ~= other then
			if other then
				local nivel = exports.objetivos:getNivel(exports.players:getCharacterID(thePlayer))
				local nivel2 = exports.objetivos:getNivel(exports.players:getCharacterID(other))
				if nivel < 3 or nivel2 < 3 then outputChatBox("O tú o con quien te vas a casar no tiene el nivel 3, y no podéis casaros (/objetivos).", thePlayer, 255, 0, 0) return end
				local s = exports.sql:query_assoc_single("SELECT casadocon FROM characters WHERE characterID = "..exports.players:getCharacterID(thePlayer))
				if tonumber(s.casadocon) == 0 then
					if getElementDimension(thePlayer) ~= 182 then outputChatBox("(( Tienes que estar en la iglesia ))", thePlayer, 255, 0, 0) return end
					if getElementDimension(other) ~= 182 then outputChatBox("(( Tiene que estar tu pareja en la iglesia ))", thePlayer, 255, 0, 0) return end
					if exports.players:takeMoney(thePlayer, 15000 ) then
						exports.sql:query_free("UPDATE characters SET casadocon = " .. exports.players:getCharacterID(thePlayer).." WHERE characterID = " .. exports.players:getCharacterID(other))
						exports.sql:query_free("UPDATE characters SET casadocon = " .. exports.players:getCharacterID(other).." WHERE characterID = " .. exports.players:getCharacterID(thePlayer))
						exports.logs:addLogMessage("bodas", getPlayerName(thePlayer).." se ha casado con "..getPlayerName(other)..".")
						exports.factions:giveFactionPresupuesto(5, 15000)
						outputChatBox("[Inglés] [FCND] Reportero dice: Tenemos noticias ciudadanos de San Fierro!", root, 62, 184, 255)
						outputChatBox("[Inglés] [FCND] Reportero dice: Tenemos un nuevo matrimonio! , se ha casado "..getPlayerName(thePlayer):gsub("_", " ").." con "..getPlayerName(other):gsub("_", " ").." Felicidades", root, 62, 184, 255)
					    outputChatBox("Has contraido matrimonio con "..getPlayerName(other):gsub("_", " ").."",thePlayer,0,255,0)
						outputChatBox("Has contraido matrimonio con "..getPlayerName(thePlayer):gsub("_", " ").."",other,0,255,0)
						if nivel == 3 and not exports.objetivos:isObjetivoCompletado(27, exports.players:getCharacterID(thePlayer)) then
							exports.objetivos:addObjetivo(27, exports.players:getCharacterID(thePlayer), thePlayer)
						end
						if nivel2 == 3 and not exports.objetivos:isObjetivoCompletado(27, exports.players:getCharacterID(other)) then
							exports.objetivos:addObjetivo(27, exports.players:getCharacterID(other), other)
						end
					else
						outputChatBox("(( Tu futuro marido no tiene ni para pagar la boda! ))",other,255 , 0 , 0)
						outputChatBox("(( No tienes dinero para pagar la boda - 15000$ ))",thePlayer,255 , 0 , 0)
					end
				else
				outputChatBox("(( Ya estás casado deja la bigamia es delito ))",thePlayer,255 , 0 , 0)
				end
		    end
		else
		outputChatBox ( "(( No puedes casarte contigo mismo ))", thePlayer, 255, 0, 0 )
		end
end
addCommandHandler ( "casarse", casarse )


-- Ped de la iglesia
local padremendez = createPed ( 68, 366.87841796875, 2324.01953125, 1890.6047363281, 269.68826293945, false )
setElementData( padremendez, "npcname", "Padre Mendez" )
setElementInterior(padremendez,3)
setElementDimension(padremendez,182)
---------------------













