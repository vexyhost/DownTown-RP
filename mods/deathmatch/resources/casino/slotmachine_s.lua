--[[ 
Casino - slot machine
@author Hyperion/R3fr3Sh <r3fr3sh123@gmail.com>
@copyright 2017 Hyperion/R3fr3Sh <r3fr3sh123@gmail.com>
@license GPLv3
]]

local function takeStake(stake)
	if source ~= client then
		return
	end
	if exports.players:takeMoney(client, stake) then
		exports.factions:giveFactionPresupuesto(5, stake)
		triggerClientEvent(client, "onSendResponseCobroCasinoOK", client)
		--local c = exports.sql:query_assoc_single("SELECT * FROM ajustes WHERE ajusteID = 2")
		--exports.sql:query_free("UPDATE ajustes SET valor = " ..tonumber(stake+tonumber(c.valor)).. " WHERE ajusteID = 2")
		--if not getElementData(source, "gananciaCasino") then
			--local cID = exports.players:getCharacterID(source)
			--local c2 = exports.sql:query_assoc_single("SELECT gananciaCasino FROM characters WHERE characterID = "..cID)
			--setElementData(source, "gananciaCasino", tonumber(c2.gananciaCasino))
		--end
	else
		triggerClientEvent(client, "onSendResponseCobroCasinoNOK", client)
	end
end

local function givePrize(prize)
	if source ~= client then
		return
	end
	if exports.players:giveMoney(client, prize) then
		exports.factions:takeFactionPresupuesto(5, prize)
		--local c = exports.sql:query_assoc_single("SELECT * FROM ajustes WHERE ajusteID = 1")
		--exports.sql:query_free("UPDATE ajustes SET valor = " ..tonumber(prize+tonumber(c.valor)).. " WHERE ajusteID = 1")
		--local cID = exports.players:getCharacterID(source)
		--local c2 = exports.sql:query_assoc_single("SELECT gananciaCasino FROM characters WHERE characterID = "..cID)
		--exports.sql:query_free("UPDATE characters SET gananciaCasino = "..tonumber(c2.gananciaCasino+prize).." WHERE characterID = "..cID)
		--setElementData(source, "gananciaCasino", tonumber(c2.gananciaCasino+prize))
	end
end

addEvent("casinoTakePlayerMoney", true)
addEvent("casinoGivePlayerMoney", true)
addEventHandler("casinoTakePlayerMoney", root, takeStake)
addEventHandler("casinoGivePlayerMoney", root, givePrize)
