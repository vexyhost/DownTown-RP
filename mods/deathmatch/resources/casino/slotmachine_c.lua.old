--[[
Casino - slot machine
@author Hyperion/R3fr3Sh <r3fr3sh123@gmail.com>
@copyright 2017 Hyperion/R3fr3Sh <r3fr3sh123@gmail.com>
@license GPLv3
]]    


-- source of the background:http://www.freepik.com/free-vector/valentine-s-background-design_1024958.htm#term=slot (for both internal and external drum parts)
-- background edited by MrDadosz mrdadosz@polish-real-life.xaa.pl using GIMP
local drum = "img/drum.png"
local druminteral = "img/cards.png"
-- general settings 
local settings = {}
settings.drumColor = tocolor(0, 100, 255)
settings.stake = 5 -- starting stake
settings.stakeMax = 100 -- maximum stake
settings.stakeMin = 5 -- minimum stake
settings.stakeStep = 5 -- step of a stake
settings.font = "font/Roboto.ttf"
settings.language = "english"
settings.jackpotSound = "sounds/jackpot.ogg" -- SOURCE: https://www.freesound.org/people/Robinhood76/sounds/51671/ "This work is licensed under the Attribution Noncommercial License."
settings.positionsCol = {  -- slot machine colshape positions
	-- {x, y, z, size, dimension, interior}
	{1124.87, 3, 1000.68, 0.5, 1, 12},
	{1125.89, 3, 1000.68, 0.5, 1, 12},
	{1126.93, 3, 1000.68, 0.5, 1, 12},
	{1127.92, 3, 1000.68, 0.5, 1, 12},
	{1132.89, -1.67, 1000.68, 0.5, 1, 12},
	{1134.94, 0.61, 1000.68, 0.5, 1, 12},
	{1135.09, -3.87, 1000.68, 0.5, 1, 12},
	--[[
	{1958.2,986.6,992.47,0.5, 1068, 10},
	{1963.06,991.47,992.47,0.5, 1068, 10},
	{1965.86,998.16,992.47,0.5, 1068, 10},
	{1963.83,998.55,992.47,0.5, 1068, 10},
	{1961.37,992.65,992.47,0.5, 1068, 10},
	{1957.01,988.28,992.47,0.5, 1068, 10},
	{1966.6,1004.55,992.47,0.5, 1068, 10},
	{1966.59,1005.45,992.47,0.5, 1068, 10},
	{1966.6,1006.41,992.47,0.5, 1068, 10},
	{1966.6,1007.26,992.47,0.5, 1068, 10},
	{1966.6,1008.09,992.47,0.5, 1068, 10},
	{1969.54,1008,992.47,0.5, 1068, 10},
	{1969.54,1007.12,992.47,0.5, 1068, 10},
	{1969.54,1006.35,992.47,0.5, 1068, 10},
	{1969.54,1005.55,992.47,0.5, 1068, 10},
	{1969.54,1004.71,992.47,0.5, 1068, 10},
	{1969.54,1012.27,992.47,0.5, 1068, 10},
	{1969.54,1013.13,992.47,0.5, 1068, 10},
	{1969.54,1014.03,992.47,0.5, 1068, 10},
	{1969.54,1014.81,992.47,0.5, 1068, 10},
	{1969.54,1015.67,992.47,0.5, 1068, 10},
	{1966.6,1015.73,992.47,0.5, 1068, 10},
	{1966.6,1014.93,992.47,0.5, 1068, 10},
	{1966.6,1013.98,992.47,0.5, 1068, 10},
	{1966.6,1013.2,992.47,0.5, 1068, 10},
	{1966.6,1012.32,992.47,0.5, 1068, 10},
	{1969.54,1019.98,992.47,0.5,1068,10},
	{1969.54,1020.9,992.47,0.5,1068,10},
	{1969.54,1021.63,992.47,0.5,1068,10},
	{1969.54,1022.5,992.47,0.5,1068,10},
	{1969.54,1023.36,992.47,0.5,1068,10},
	{1966.6,1023.44,992.47,0.5,1068,10},
	{1966.6,1022.6,992.47,0.5,1068,10},
	{1966.6,1021.7,992.47,0.5,1068,10},
	{1966.59,1020.84,992.47,0.5,1068,10},
	{1966.6,1020.04,992.47,0.5,1068,10},
	{1969.54,1027.98,992.47,0.5,1068,10},
	{1969.54,1028.79,992.47,0.5,1068,10},
	{1969.54,1029.62,992.47,0.5,1068,10},
	{1969.54,1030.48,992.47,0.5,1068,10},
	{1969.54,1031.33,992.47,0.5,1068,10},
	{1966.6,1031.37,992.47,0.5,1068,10},
	{1966.6,1030.54,992.47,0.5,1068,10},
	{1966.6,1029.7,992.47,0.5,1068,10},
	{1966.6,1028.8,992.47,0.5,1068,10},
	{1966.6,1028,992.47,0.5,1068,10},
	{1965.85,1037.53,992.47,0.5,1068,10},
	{1963.83,1037.09,992.47,0.5,1068,10},
	{1961.29,1042.93,992.47,0.5,1068,10},
	{1963.04,1044.04,992.47,0.5,1068,10},
	{1958.08,1049.04,992.47,0.5,1068,10},
	{1956.84,1047.39,992.47,0.5,1068,10},
	{1940.2,1031.26,992.47,0.5,1068,10},
	{1940.01,1030.56,992.47,0.5,1068,10},
	{1939.75,1029.6,992.47,0.5,1068,10},
	{1939.57,1028.92,992.47,0.5,1068,10},
	{1939.36,1028.16,992.47,0.5,1068,10},
	{1942.18,1027.27,992.47,0.5,1068,10},
	{1942.41,1028.11,992.47,0.5,1068,10},
	{1942.64,1028.97,992.47,0.5,1068,10},
	{1942.86,1029.8,992.47,0.5,1068,10},
	{1943.1,1030.69,992.47,0.5,1068,10},
	{1938.89,1023.16,992.47,0.5,1068,10},
	{1938.88,1022.27,992.47,0.5,1068,10},
	{1938.89,1021.46,992.47,0.5,1068,10},
	{1938.89,1020.59,992.47,0.5,1068,10},
	{1938.88,1019.7,992.47,0.5,1068,10},
	{1941.83,1019.75,992.47,0.5,1068,10},
	{1941.83,1020.6,992.47,0.5,1068,10},
	{1941.83,1021.43,992.47,0.5,1068,10},
	{1941.83,1022.25,992.47,0.5,1068,10},
	{1941.83,1023.12,992.47,0.5,1068,10},
	{1941.83,1015.88,992.47,0.5,1068,10},
	{1941.83,1015.06,992.47,0.5,1068,10},
	{1941.83,1014.27,992.47,0.5,1068,10},
	{1941.83,1013.41,992.47,0.5,1068,10},
	{1941.83,1012.57,992.47,0.5,1068,10},
	{1938.89,1012.49,992.47,0.5,1068,10},
	{1938.89,1013.4,992.47,0.5,1068,10},
	{1938.89,1014.22,992.47,0.5,1068,10},
	{1938.89,1015.11,992.47,0.5,1068,10},
	{1938.89,1015.95,992.47,0.5,1068,10},
	{1939.52,1007.47,992.47,0.5,1068,10},
	{1939.81,1006.69,992.47,0.5,1068,10},
	{1940.1,1005.9,992.47,0.5,1068,10},
	{1940.42,1005.02,992.47,0.5,1068,10},
	{1940.73,1004.16,992.47,0.5,1068,10},
	{1943.48,1005.22,992.47,0.5,1068,10},
	{1943.15,1006.11,992.47,0.5,1068,10},
	{1942.86,1006.91,992.47,0.5,1068,10},
	{1942.6,1007.63,992.47,0.5,1068,10},
	{1942.3,1008.48,992.47,0.5,1068,10},]]
}

-- don't modify these unless you know what you are doing
settings.gamesPlayed = 0  --anticheat - games played
settings.rolling = false
settings.cardsize = 256  -- Whenever you rescale cards, change this.


-- source of the cards: http://www.freepik.com/free-vector/set-of-slot-machine-cards_756468.htm scaled down
local cards = {
	-- 1 5 10 25
	-- {icon name, multiplier for 2x combo, multiplier for 3x combo}, with these settings avg ~=~ 1.1
	-- bars
	{"slotMachineCards/goldbar.png", 10, 25},
	{"slotMachineCards/redbar.png", 5, 10},
	{"slotMachineCards/greenbar.png", 1, 5},
	-- luck related
	{"slotMachineCards/bell.png", 3, 7},
	{"slotMachineCards/heart.png", 3, 7},
	{"slotMachineCards/horseshoe.png", 3, 7},
	{"slotMachineCards/goldclover.png", 5, 15},
	{"slotMachineCards/greenclover.png", 3, 7},
	-- sevens
	{"slotMachineCards/goldenseven.png", 10, 25},
	{"slotMachineCards/redseven.png", 3, 15},
	-- gems
	{"slotMachineCards/ruby.png", 5, 15},
	{"slotMachineCards/emerald.png", 5, 15},
	{"slotMachineCards/diamond.png", 10, 20},
	-- vegetables and fruits
	{"slotMachineCards/cherry.png", 1, 3},
	{"slotMachineCards/grape.png", 1, 3},
	{"slotMachineCards/lemon.png", 1, 3},
	{"slotMachineCards/plum.png", 1, 3},
	{"slotMachineCards/watermelon.png", 1, 3},
}

local setList = { --staring cards, don't delete them
{{0.215, 0, "slotMachineCards/bell.png"}, {0.215, 0.36, "slotMachineCards/goldbar.png"}}, -- left set
{{0.422, 0, "slotMachineCards/bell.png"}, {0.422, 0.36, "slotMachineCards/goldbar.png"}}, -- central set
{{0.628, 0, "slotMachineCards/bell.png"}, {0.628, 0.36, "slotMachineCards/goldbar.png"}}, -- right set
}

local setSettings = { --settings, don't modify these unless you know what you are doing
{speedBasic = 0.004, count = 75, xstart = 0.215},
{speedBasic = 0.0045, count = 100, xstart = 0.422},
{speedBasic = 0.005, count = 133, xstart = 0.628},
}

local gui = {}
local dumpedCards = {}
local localisation = {}

localisation["english"] = {
	winenthiusastic = "¡Has sacado las tres cartas en línea! Has ganado %d$!",
	win = "¡Uy, casi! Has sacado dos cartas en línea. Has ganado %d$",
	lose = "No has tenido suerte, lo siento.",
	stakeMax = "¡No puedes apostar más de %d$!",
	stakeMin = "¡Necesitas apostar al menos una cantidad de %d$!",
	notEnoughCash = "¡No tienes suficiente dinero para apostar eso!",
	notEnoughCashOnRoll = "¡No tienes suficiente dinero para girar!",
	stakeInfo = "Apuesta\nactual\n%d$",
	roll = "Jugar",
	leave = "Salir",
	whenRolling = "No puedes hacer eso mientras está girando",
}

-- MISC FUNCTIONS

local function outputOnScreen(str, r, g, b)
	local labels = {{},{},{}}
	labels[1] = {str, r, g, b}
	labels[2] = {guiGetText(gui.labelList1), guiLabelGetColor(gui.labelList1)}
	labels[3] = {guiGetText(gui.labelList2), guiLabelGetColor(gui.labelList2)}
	for k,v in ipairs(labels) do
		guiLabelSetColor(gui["labelList"..k], v[2], v[3], v[4])
		guiSetText(gui["labelList"..k], v[1])
	end
end

local function copyTable() end -- recursive copyTable function
copyTable = function(t1)
	local newTable = {}
	for k, v in ipairs(t1) do
		if type(v) ~= "table" then
			newTable[k] = v
		else
			newTable[k] = copyTable(v)
		end
	end
	return newTable
end

local function getFontSizeFromResolution(w, h, base)
	local w = w/base
	local h = h/base
	local result = math.floor(math.sqrt(h*w))
	return result
end

--MAIN FUNCTIONS

local sw, sh = guiGetScreenSize()
local function drawImage(x, y, card) --pretty complicated function, generally draws only cards that one can see.
	local topy = y - 0.23
	local bottomy = 0.75 - y
	if topy < 0 then
		local hrr = (0.25+topy)/0.25
		dxDrawImageSection(x*sw, (y-topy)*sh, 0.15*sw, (0.25+topy)*sh, 0, (1-hrr)*settings.cardsize, settings.cardsize, hrr*settings.cardsize, card)
	elseif bottomy > 0 and bottomy < 0.25 then
		dxDrawImageSection(x*sw, y*sh, 0.15*sw, bottomy*sh, 0, 0, settings.cardsize, (bottomy/0.25)*settings.cardsize, card)
	else
		dxDrawImageSection(x*sw, y*sh, 0.15*sw, 0.25*sh, 0, 0, settings.cardsize, settings.cardsize, card)
	end
end

local function generateSets()
	for i = 1, #setList do  
		for i2 = 1, setSettings[i].count do
			local newcard = {0, 0, "str"}
			newcard[1] = setSettings[i].xstart
			newcard[2] = 0.4*i2+0.25
			newcard[3] = cards[math.random(1, #cards)][1]
			table.insert(setList[i], newcard)
		end
		setSettings[i].speed = setSettings[i].speedBasic * 40
	end
	if getElementData(getLocalPlayer(), "gananciaCasino") and tonumber(getElementData(getLocalPlayer(), "gananciaCasino")) >= 50000 then -- El que mucho corre, pronto para :D
		setList[1][setSettings[1].count - 1][3] = cards[math.random(1,4)][1]
		setList[2][setSettings[2].count - 1][3] = cards[math.random(5,8)][1]
		setList[3][setSettings[3].count - 1][3] = cards[math.random(9,12)][1]
	end
	collectgarbage("collect")
end


local function calculateRewards()
	local multiplier = {name, multiplier = 0, columns = 0}
	--there might be more sophisticated way to do that, but i don't know it (yet)
	multiplier.columns = multiplier.columns + ((setList[1][2][3] == setList[2][2][3] and setList[1][2][3] == setList[3][2][3] and 3)  or (setList[1][2][3] == setList[2][2][3] and 2) or (setList[2][2][3] == setList[3][2][3] and 2) or (setList[1][2][3] == setList[3][2][3] and 2) or 0)
	
	multiplier.name = (setList[1][2][3] == setList[2][2][3] and setList[1][2][3] == setList[3][2][3] and setList[1][2][3]) or (setList[1][2][3] == setList[2][2][3] and setList[1][2][3]) or (setList[2][2][3] == setList[3][2][3] and setList[2][2][3]) or (setList[1][2][3] == setList[3][2][3] and setList[3][2][3])
	if multiplier.columns ~= 0 then
		for k,v in ipairs(cards) do
			if v[1] == multiplier.name then
				multiplier.multiplier = v[multiplier.columns]
			end
		end
	end
	
	dumpedCards = {}  --dumps all cards
	collectgarbage("collect") --collects garbage at the end, so game doesn't get lagged
	
	if multiplier.columns == 3 then
		outputOnScreen(string.format(localisation[settings.language].winenthiusastic, settings.stake*multiplier.multiplier), 255, 255, 0)
		triggerServerEvent("casinoGivePlayerMoney", localPlayer, settings.stake*multiplier.multiplier)
		guiSetText(gui.labelMoney, getPlayerMoney() + settings.stake*multiplier.multiplier.."$")
		playSound(settings.jackpotSound)
	elseif multiplier.columns == 2 then
		outputOnScreen(string.format(localisation[settings.language].win, settings.stake*multiplier.multiplier), 220, 220, 0)
		triggerServerEvent("casinoGivePlayerMoney", localPlayer, settings.stake*multiplier.multiplier)
		guiSetText(gui.labelMoney, getPlayerMoney() + settings.stake*multiplier.multiplier.."$")
		playSound(settings.jackpotSound)
	else
		outputOnScreen(localisation[settings.language].lose, 250, 168, 0)
	end
	settings.gamesPlayed = settings.gamesPlayed + 1
end	


local delta = getTickCount()
local function main()
	delta = (getTickCount() - delta)  --calculates delta time diffrence between last 2 frames
	delta = delta < 34 and delta or 34  -- if he has less than 30 fps his game will run slower, but it will prevent any drum related drawing problems(at least those major ones)
	dxDrawRectangle(0, 0, sw, sh, tocolor(0, 0, 0 ,150)) --grey background
	dxDrawImage(0.15*sw, 0.2*sh, 0.7*sw, 0.6*sh, druminteral)  --draws drum internal part
	for key, set in ipairs (setList) do
		if #set == 2 and key == #setList then --stops when there are only 2 cards left in the right set and ends roll.
			if settings.rolling then
				calculateRewards()  --calculates prize
				settings.rolling = false --allows to roll again
			end
		end
		for index, card in ipairs(set) do
			if settings.rolling then -- if we roll
				if #set < 40 then
					setSettings[key].speed = setSettings[key].speedBasic * #set --used to slowdown drums near end of roll
				end
				if #set ~= 2 then  -- drum works till there are more than 2 cards in a set
					card[2] = card[2] - setSettings[key].speed * delta/17 --change position of card
				end
			end
			if card[2] < 0.75 and card[2] >= 0 then -- draw cards only when picture can is seeable
				drawImage(card[1], card[2], card[3]) --draws image
			elseif card[2] < -0.42 then --if the card is over the top of the screen
				table.insert(dumpedCards, table.remove(set, index)) -- remove useless cards from set and move it to dumpedCards
			end
		end
	end
	dxDrawImage(0.1*sw, 0.2*sh, 0.8*sw, 0.6*sh, drum, 0, 0, 0, settings.drumColor) --draws drum external part
	delta = getTickCount()
end

-- Win table generator // part of gui
local prizesPanel = {}
prizesPanel.labels = {}
prizesPanel.images = {}

local function generatePrizesPanel()
	local offsetx = 0
	local offsety = 0
	local icons = copyTable(cards)
	-- 2x in columns
	table.sort(icons, function (a,b) return a[2] < b[2] end)
	for k,v in ipairs(icons) do
		if icons[k-1] and v[2] ~= icons[k-1][2] then
			local label = guiCreateLabel(0.145 + offsetx, 0.006 + offsety, 0.03, sw/sh*0.03, icons[k-1][2].."x", true)
			table.insert(prizesPanel.labels, label)
			offsety = offsety + 0.046
			offsetx = 0
		end
		local img = guiCreateStaticImage(0.15 + offsetx, 0.01 + offsety, 0.03, sw/sh*0.026, v[1], true)
		table.insert(prizesPanel.images, img)
		offsetx = offsetx + 0.04
		if k == #icons then
			local label = guiCreateLabel(0.145 + offsetx, 0.006 + offsety, 0.03, sw/sh*0.03, v[2].."x", true)
			table.insert(prizesPanel.labels, label)
		end
	end 
	
	for k,v in ipairs(prizesPanel.labels) do
		guiLabelSetColor(v, 255, 50, 50)
	end
	local count = #prizesPanel.labels
	
	
	table.sort(icons, function (a,b) return a[3] > b[3] end)
	offsetx = 0
	offsety = 0
	for k,v in ipairs(icons) do
		if icons[k-1] and v[3] ~= icons[k-1][3] then
			local label = guiCreateLabel(0.815 - offsetx, 0.006 + offsety, 0.04, sw/sh*0.03, icons[k-1][3].."x", true)
			table.insert(prizesPanel.labels, label)
			offsety = offsety + 0.046
			offsetx = 0
		end
		local img = guiCreateStaticImage(0.815 - offsetx, 0.01 + offsety, 0.03, sw/sh*0.026, v[1], true)
		table.insert(prizesPanel.images, img)
		offsetx = offsetx + 0.04
		if k == #icons then
			local label = guiCreateLabel(0.815 - offsetx, 0.006 + offsety, 0.04, sw/sh*0.03, v[3].."x", true)
			table.insert(prizesPanel.labels, label)
		end
	end 
	
	local font = guiCreateFont(settings.font, getFontSizeFromResolution(sw, sh, 70))
	for k,v in ipairs(prizesPanel.labels) do
		guiSetFont(v, font)
		if count < k then 
			guiLabelSetColor(v, 255, 255, 50)
		end
	end
	
	local label1 = guiCreateLabel(0.32, 0.145, 0.12, 0.05, "¡DOBLE!", true)
	local label2 = guiCreateLabel(0.56, 0.015, 0.12, 0.05, "¡TRIPLE!", true)
	font = guiCreateFont(settings.font, getFontSizeFromResolution(sw, sh, 40))
	guiSetFont(label1, font)
	guiSetFont(label2, font)
	guiLabelSetColor(label1, 255, 50, 50)
	guiLabelSetColor(label2, 255, 255, 50)
	table.insert(prizesPanel.labels, label1)
	table.insert(prizesPanel.labels, label2)
	for k,v in ipairs(prizesPanel.labels) do
		guiLabelSetHorizontalAlign(v, "center") 
		guiLabelSetVerticalAlign(v, "center")
	end

	for k,v in ipairs(prizesPanel.labels) do
		guiSetVisible(v, false)
	end
	for k,v in ipairs(prizesPanel.images) do
		guiSetVisible(v, false)
	end
	
	collectgarbage("collect")
end
generatePrizesPanel()

-- GUI RELATED FUNCTIONS

local function onPlayerStartRoll()
	if settings.rolling then -- we can't allow a new roll when there is one currently ongoing.
		outputOnScreen(localisation[settings.language].whenRolling, 250, 50, 50)
		return
	end
	if settings.stake > getPlayerMoney() then
		outputOnScreen(localisation[settings.language].notEnoughCashOnRoll, 255, 50, 50)
		return
	end
	triggerServerEvent("casinoTakePlayerMoney", localPlayer, settings.stake)
end

local function onPlayerStartRoll2()
	-- Pago en server realizado correctamente
	settings.rolling = true --starts a roll
	guiSetText(gui.labelMoney, getPlayerMoney() - settings.stake.."$")
	setList = { --uses two rows of card from last roll
		{setList[1][2]}, -- left set
		{setList[2][2]}, -- central set
		{setList[3][2]}, -- right set
	}	
	generateSets() --generate sets	
end
addEvent("onSendResponseCobroCasinoOK", true)
addEventHandler("onSendResponseCobroCasinoOK", getRootElement(), onPlayerStartRoll2)

local function onPlayerStartRoll3()
	-- Pago en server rechazado
	outputOnScreen(localisation[settings.language].notEnoughCashOnRoll, 255, 50, 50)
end
addEvent("onSendResponseCobroCasinoNOK", true)
addEventHandler("onSendResponseCobroCasinoNOK", getRootElement(), onPlayerStartRoll3)


local function onPlayerLeave()
	if settings.rolling then -- we can't allow a new roll when there is one currently ongoing.
		outputOnScreen(localisation[settings.language].whenRolling, 250, 50, 50)
		return
	end
	for k,v in pairs(gui) do
		guiSetVisible(v, false)
	end
	showCursor(false, false)
	removeEventHandler("onClientRender", root, main)
	setElementFrozen(localPlayer, false)
	showChat(true)
	showPlayerHudComponent("all", true)
	for k,v in ipairs(prizesPanel.labels) do
		guiSetVisible(v, false)
	end
	for k,v in ipairs(prizesPanel.images) do
		guiSetVisible(v, false)
	end
end

local function stakeUp()
	if settings.rolling then
		outputOnScreen(localisation[settings.language].whenRolling, 250, 50, 50)
		return
	end
	local potencialStake = settings.stake + settings.stakeStep
	if potencialStake > getPlayerMoney() then
		outputOnScreen(localisation[settings.language].notEnoughCash, 250, 50, 50)
		return
	elseif potencialStake > settings.stakeMax then
		outputOnScreen(string.format(localisation[settings.language].stakeMax, settings.stakeMax), 255, 168, 0)
		return
	end
	settings.stake = potencialStake
	guiSetText(gui.labelStake, string.format(localisation[settings.language].stakeInfo, settings.stake))
end

local function stakeDown()
	if settings.rolling then
		outputOnScreen(localisation[settings.language].whenRolling, 250, 50, 50)
		return
	end
	local potencialStake = settings.stake - settings.stakeStep
	if potencialStake < settings.stakeMin then
		outputOnScreen(string.format(localisation[settings.language].stakeMin, settings.stakeMin), 255, 168, 0)
		return
	end
	settings.stake = potencialStake
	guiSetText(gui.labelStake, string.format(localisation[settings.language].stakeInfo, settings.stake))
end

local function createGUI()
	gui.buttonRoll = guiCreateButton(0.6, 0.792, 0.23, 0.1, localisation[settings.language].roll, true) --start roll
	gui.buttonLeave = guiCreateButton(0.37, 0.792, 0.23, 0.1, localisation[settings.language].leave, true) --leave
	gui.buttonStakeUp = guiCreateButton(0.32, 0.792, 0.05, 0.1, ">", true)
	gui.buttonStakeDown = guiCreateButton(0.17, 0.792, 0.05, 0.1, "<", true)

	gui.labelStake = guiCreateLabel(0.22, 0.792, 0.10, 0.1, string.format(localisation[settings.language].stakeInfo, settings.stake), true) --current stake
	guiLabelSetHorizontalAlign(gui.labelStake, "center") 
	guiLabelSetVerticalAlign(gui.labelStake, "center")
	gui.labelMoney = guiCreateLabel(0.79, 0, 0.2, 0.2, getPlayerMoney().."$", true)
	guiLabelSetHorizontalAlign(gui.labelMoney, "right") 
	guiLabelSetVerticalAlign(gui.labelMoney, "top")
	guiLabelSetColor(gui.labelMoney, 133, 187, 101)

	gui.labelList1 = guiCreateLabel(0, 0.9, 1, 0.03, "", true)
	gui.labelList2 = guiCreateLabel(0, 0.93, 1, 0.03, "", true)
	gui.labelList3 = guiCreateLabel(0, 0.96, 1, 0.03, "", true)
	for i = 1, 3 do
		guiLabelSetHorizontalAlign(gui["labelList"..i], "center") 
		guiLabelSetVerticalAlign(gui["labelList"..i], "center")
	end
	
	local font = guiCreateFont(settings.font, getFontSizeFromResolution(sw, sh, 75))
	for k,v in pairs(gui) do
		guiSetFont(v, font)
	end
	guiSetFont(gui.labelMoney, "sa-header")
	
	addEventHandler("onClientGUIMouseUp", gui.buttonRoll, onPlayerStartRoll)
	addEventHandler("onClientGUIMouseUp", gui.buttonLeave, onPlayerLeave)
	addEventHandler("onClientGUIMouseUp", gui.buttonStakeUp, stakeUp)
	addEventHandler("onClientGUIMouseUp", gui.buttonStakeDown, stakeDown)
	for k,v in pairs(gui) do
		guiSetVisible(v, false)
	end
end
createGUI()

local function setGUIlanguage(language) --use that to change language settings. It is not exported.
	settings.language = language
	guiSetText(gui.labelStake, string.format(localisation[settings.language].stakeInfo, settings.stake))
	guiSetText(gui.buttonRoll, localisation[settings.language].roll)
	guiSetText(gui.buttonLeave, localisation[settings.language].leave)
end

local function showGUI(el, md)
	if not md or getElementType(el) ~= "player" or el ~= localPlayer then
		return
	end
	for k,v in pairs(gui) do
		guiSetVisible(v, true)
	end
	showCursor(true, true)
	addEventHandler("onClientRender", root, main)
	setElementFrozen(localPlayer, true)
	showChat(false)
	showPlayerHudComponent("all", false)
	guiSetText(gui.labelMoney, getPlayerMoney().."$")
	for k,v in ipairs(prizesPanel.labels) do
		guiSetVisible(v, true)
	end
	for k,v in ipairs(prizesPanel.images) do
		guiSetVisible(v, true)
	end
end

local function setup()
	for k,v in ipairs(settings.positionsCol) do
		local col = createColSphere(v[1], v[2], v[3], v[4])
		setElementDimension(col, v[5])
		setElementInterior(col, v[6])
		addEventHandler("onClientColShapeHit", col, showGUI)
	end
end
setup()
