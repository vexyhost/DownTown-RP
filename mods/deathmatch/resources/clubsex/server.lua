animations = {}
sexWith = {}
typeSex = {}
sexType = {}
pedGender = {}
playerAnim = {}
pedAnim = {}
pedScreamTimer = {}

function createSexPed (thePlayer,cmdName,skin,anim,gender)
	if tonumber(skin) then
		local x,y,z = getElementPosition (thePlayer)
		local int = getElementInterior (thePlayer)
		local dim = getElementDimension (thePlayer) 
		local rx,ry,rz = getElementRotation (thePlayer)
		local sexped = createPed ( skin, x, y, z, rz )
		if rz < 45 and rz > 0 or rz > 315 and rz < 359 then
			setElementRotation ( sexped, 0, 0, 0 )
		elseif rz < 135 and rz > 45 then
			setElementRotation ( sexped, 0, 0, 90 )
		elseif rz < 225 and rz > 135 then
			setElementRotation ( sexped, 0, 0, 180 )
		elseif rz < 315 and rz > 225 then 
			setElementRotation ( sexped, 0, 0, 270 )
		end
		setElementFrozen ( sexped, true )
		setElementInterior ( sexped, int )
		setElementDimension ( sexped, dim )
		setTypeSex (sexped,anim)
		pedGender[sexped] = gender
		sexType[sexped] = anim
		addPedClothes(sexped,"player_torso","torso",0)
		addPedClothes(sexped,"player_legs","legs",2)
		addPedClothes(sexped,"biker","snakeskin",3)
		table.insert ( animations, {
			sexped,
			getManAnim(anim,"block"),
			getManAnim(anim,"anima"),
			getWomanAnim(anim,"block"),
			getWomanAnim(anim,"anima"),
			x,
			y,
			z,
			rz
		})
		savePeds ()
	end
end 
--addCommandHandler ("createsexped", createSexPed)

function setTypeSex (ped,name)
	typeSex[ped] = getManAnim(name,"anima")
end

function getManAnim (name,t)
	if (name == "bj") then 
		if (t == "block") then return "BLOWJOBZ" end
		if (t == "anima") then return "BJ_Couch_Loop_P" end
	elseif (name == "bjs") then
		if (t == "block") then return "BLOWJOBZ" end
		if (t == "anima") then return "BJ_Stand_Loop_P" end
	elseif (name == "bed") then
		if (t == "block") then return "SEX" end
		if (t == "anima") then return "sex_1_cum_P" end
	end
end

function getWomanAnim (name,t)
	if (name == "bj") then 
		if (t == "block") then return "BLOWJOBZ" end
		if (t == "anima") then return "BJ_Couch_Loop_W" end
	elseif (name == "bjs") then
		if (t == "block") then return "BLOWJOBZ" end
		if (t == "anima") then return "BJ_Stand_Loop_W" end
	elseif (name == "bed") then
		if (t == "block") then return "SEX" end
		if (t == "anima") then return "sex_1_cum_W" end
	end
end

function nudeWomanSkin (ped)
	local mySkin = getElementModel (ped)
	for k, skins in ipairs (skinTable) do
		if (skins.normal ~= 307) then
			if (skins.normal == mySkin) then
				setElementModel (ped, skins.naked)
				break
			elseif (skins.naked == mySkin) then
				setElementModel (ped, skins.normal)
				break
			end
		end
	end
end

function getSexPos (ped2, rz, tipo2)
	if (typeSex[ped2] == "BJ_Couch_Loop_P") then
		if rz < 5 then
			return -0.021484375, 0.958007812
		elseif rz > 85 and rz < 95 then
			return 0.91796875, -0.038085937
		elseif rz > 175 and rz < 185 then
			return 0.021484375, -0.958007812
		elseif rz > 265 and rz < 275 then
			return -0.9248046875, 0.0117187
		end
	elseif (typeSex[ped2] == "BJ_Stand_Loop_P") then
		if rz < 5 then
			return -0.001484375, 0.958007812
		elseif rz > 85 and rz < 95 then
			return 0.91796875, -0.038085937
		elseif rz > 175 and rz < 185 then
			return 0.001484375, -0.958007812
		elseif rz > 265 and rz < 275 then
			return -0.9248046875, 0.0117187
		end
	elseif (typeSex[ped2] == "sex_1_cum_P") then
		if tipo2 == 1 then
			--local x,y,z = getElementPosition(ped2)
			--pedScreamTimer [ped2] = setTimer (girlScream, math.random(2000,3500), 0, "bed", x, y, z, ped2 )
			if tonumber(rz) < 5 then
				return -0.021484375, 0.958007812
			elseif tonumber(rz) > 85 and tonumber(rz) < 95 then
				return 0.91796875, -0.038085937
			elseif tonumber(rz) > 175 and tonumber(rz) < 185 then
				return 0.021484375, -0.958007812
			elseif tonumber(rz) > 265 and tonumber(rz) < 275 then
				return -0.9248046875, 0.0117187
			else
				outputDebugString("AVERIA RZ")
			end
		elseif tipo2 == 2 then
			if tonumber(rz) < 5 then
				outputDebugString("Devolucion OK 1")
				return -0.021484375, 0.958007812
			elseif tonumber(rz) > 85 and tonumber(rz) < 95 then
				outputDebugString("Devolucion OK 2")
				return 0.91796875, -0.038085937
			elseif tonumber(rz) > 175 and tonumber(rz) < 185 then
				outputDebugString("Devolucion OK 3")
				return 0.021484375, -0.858007812, 0, 1
			elseif tonumber(rz) > 265 and tonumber(rz) < 275 then
				outputDebugString("Devolucion OK 4")
				return -0.9248046875, 0.0117187
			else
				outputDebugString("AVERIA RZ")
			end
		elseif tipo2 == 3 then
			if tonumber(rz) < 5 then
				outputDebugString("Devolucion OK 1")
				return -0.021484375, 0.958007812
			elseif tonumber(rz) > 85 and tonumber(rz) < 95 then
				outputDebugString("Devolucion OK 2")
				return 0.91796875, -0.038085937
			elseif tonumber(rz) > 175 and tonumber(rz) < 185 then
				outputDebugString("Devolucion OK 3")
				return 0.021484375, -1.558007812, 0, 0.4
			elseif tonumber(rz) > 265 and tonumber(rz) < 275 then
				outputDebugString("Devolucion OK 4")
				return -0.9248046875, 0.0117187
			else
				outputDebugString("AVERIA RZ")
			end
		end
	end
end
 
screams = 
{
	bed =
	{
		girl = 
		{
			[1] = 127,
			[2] = 110,
			[3] = 93,
			[4] = 92,
			[5] = 87,
			[6] = 82,
			[7] = 81,
			[8] = 80,
			[9] = 79,
			[10] = 78,
			[11] = 76,
			[12] = 27,
			[13] = 60,
			[14] = 62,
			[15] = 63
		},
		man = 
		{
			[1] = 93,
			[2] = 97,
			[3] = 98,
			[4] = 99,
			[5] = 88,
			[6] = 89,
			[7] = 91,
			[8] = 92,
			[9] = 93,
			[10] = 94,
			[11] = 64,
			[12] = 62,
			[13] = 57,
			[14] = 56,
			[15] = 51,
		}
	}
}

function girlScream (typ,x,y,z,ped)
	if (typ == "bed") then
		local bank = 0
		local screamRandom = 0
		if (pedGender[ped] == "m") then
			screamRandom = screams.bed.man[math.random(1,15)]
			bank = 2
		else
			screamRandom = screams.bed.girl[math.random(1,15)]
			bank = 1
		end
		triggerClientEvent ("playScreamSound", getRootElement(), x, y, z, bank, screamRandom)
	end
end

function getSexPed (p1, p2, index, inv)
	if getGender(animations[index][1]) == "Mujer" then
		outputDebugString("Bot: Mujer")
		thePlayer = p1
		ped = p2
		pedPrueba = p2
		tipo = 1
	else
		outputDebugString("Bot: Hombre")
		local sql = exports.sql:query_assoc_single("SELECT genero FROM characters WHERE characterID = "..tostring(exports.players:getCharacterID(p1)))
		local genero = tonumber(sql.genero)
		if genero == 1 and sexType[p2] == "bed" then
			thePlayer = p2
			ped = p1
			tipo = 3
			--showDick(p2)
			--showDick(p1)
		else
			if not inv then
				thePlayer = p1
				ped = p2
				tipo = 1
			else
				thePlayer = p2
				ped = p1
				tipo = 4
			end
			showDick(thePlayer)
		end
	end
	local px,py,pz = getElementPosition (p2) -- Bot
	local _,_,pr = getElementRotation (p2) -- Rotacion Bot
	local rx, ry, rx2, ry2 = getSexPos (p2, pr, tipo) -- Rotacion que le corresponde Bot
	sexWith[p1] = p2
	if tipo == 1 then
		setElementRotation ( thePlayer, 0, 0, pr + 180 )
		setElementPosition ( thePlayer, px-rx, py+ry, pz) -- Posicion BOT menos/mas la posicion del sexPos
	elseif tipo == 2 then
		local _,_,pr2 = getElementRotation (thePlayer) -- Rotacion Bot
		setElementRotation ( thePlayer, 0, 0, pr + 180)
		setElementPosition ( thePlayer, px-rx, py+ry, pz+0.2)
		local px2,py2,pz2 = getElementPosition (thePlayer) -- Pos Bot
		setElementRotation( ped, 0, 0, pr)
		setElementPosition ( ped, px2-rx2, py2+ry2, pz2)
	elseif tipo == 3 then
		local _,_,pr2 = getElementRotation (thePlayer) -- Rotacion Bot
		setElementRotation ( thePlayer, 0, 0, pr + 180)
		setElementPosition ( thePlayer, px-rx, py+ry, pz-1.2)
		local px2,py2,pz2 = getElementPosition (thePlayer) -- Pos Bot
		setElementRotation( ped, 0, 0, pr - 180)
		setElementPosition ( ped, px2-rx2, py2+ry2, pz2)
	elseif tipo == 4 then
		setElementRotation ( thePlayer, 0, 0, pr + 180 )
		setElementPosition ( thePlayer, px-rx, py+ry, pz) -- Posicion BOT menos/mas la posicion del sexPos
		setElementPosition ( p1, px, py, pz )
		setElementRotation ( p1, 0, 0, pr )
	end
	if tipo == 1 or tipo == 2 or tipo == 4 then		
		if (animations[index][3] == "BJ_Couch_Loop_P") then
			outputDebugString("OK1")
			setPedAnimation ( thePlayer, animations[index][2], "BJ_Couch_Start_P", -1, false, false, false, true )
			setPedAnimation ( ped, animations[index][4], "BJ_Couch_Start_W", -1, false, false, false, true )
		elseif (animations[index][3] == "BJ_Stand_Loop_P") then
			outputDebugString("OK2")
			setPedAnimation ( thePlayer, animations[index][2], "BJ_Stand_Start_P", -1, false, false, false, true )
			setPedAnimation ( pedPrueba, animations[index][4], "BJ_Stand_Start_W", -1, false, false, false, true )
		else
			outputDebugString("AVERIA AQUI")
		end
	elseif tipo == 3 then
		if (animations[index][3] == "BJ_Couch_Loop_P") then
			setPedAnimation ( thePlayer, animations[index][2], "BJ_Couch_Start_P", -1, false, false, false, true )
			setPedAnimation ( ped, animations[index][4], "BJ_Couch_Start_P", -1, false, false, false, true )
		elseif (animations[index][3] == "BJ_Stand_Loop_P") then
			setPedAnimation ( thePlayer, animations[index][2], "BJ_Stand_Start_P", -1, false, false, false, true )
			setPedAnimation ( ped, animations[index][4], "BJ_Stand_Start_P", -1, false, false, false, true )
		end
	end
	nextAnim = setTimer (
		function (tipo)
			if tipo == 1 or tipo == 2 or tipo == 4 then
				setPedAnimation ( thePlayer, animations[index][2], animations[index][3], -1, true, false, false, false )
				setPedAnimation ( ped, animations[index][4], animations[index][5], -1, true, false, false, false )
				killTimer (nextAnim)
			elseif tipo == 3 then
				setPedAnimation ( thePlayer, animations[index][2], animations[index][3], -1, true, false, false, false )
				setPedAnimation ( ped, "wuzi", "cs_dead_guy", -1, true, false, false, false )
				killTimer (nextAnim)
			end
		end,
	getTimeToWait(animations[index][3], false), 1, tipo)
end

function getTimeToWait (anim, finishing)
	if (anim == "BJ_Couch_Loop_P") then
		if (finishing) then return 8400 
		else return 5400 end
	elseif (anim == "BJ_Stand_Loop_P") then
		if (finishing) then return 5800 
		else return 2000 end
	else
		return 50
	end
end

local t1
local t2
t1 = getTickCount()		
t2 = getTickCount()

function talkWithSexPed ( message )	
	for index, peds in ipairs ( animations ) do
		local x,y,z = getElementPosition(animations[index][1])
		local x2,y2,z2 = getElementPosition(source)
		if getDistanceBetweenPoints3D (x,y,z,x2,y2,z2) < 1.5 then
			if ( string.find (string.lower(message), "follar") ) or ( string.find (string.lower(message), "chuparme") ) then
				nudeWomanSkin (animations[index][1])
				outputChatBox ("#00FF00"..(getGender(animations[index][1]))..":#FFFFFF Vamos.", source, 0, 0, 0, true)
				checkAnims = setTimer ( checkAnimations, 50, 0, source )
				getSexPed (source, animations[index][1], index, true)
				setElementData(source, "sexbot", true)
				break
			elseif ( string.find (string.lower(message), "chuparla") ) then
				nudeWomanSkin (animations[index][1])
				outputChatBox ("#00FF00"..(getGender(animations[index][1]))..":#FFFFFF Vamos.", source, 0, 0, 0, true)
				checkAnims = setTimer ( checkAnimations, 50, 0, source )
				getSexPed (source, animations[index][1], index, true)
				setElementData(source, "sexbot", true)
				break	
			elseif ( string.find (string.lower(message), "terminar") ) then
				if (isTimer(checkAnims)) then
					outputChatBox ("#00FF00"..(getGender(animations[index][1]))..":#FFFFFF Vale.", source, 0, 0, 0, true)
					stopSex (source, animations[index][1])
					if (isTimer(pedScreamTimer [animations[index][1]])) then killTimer(pedScreamTimer [animations[index][1]]) end
					setTimer ( nudeWomanSkin, getTimeToWait (animations[index][3], true), 1, animations[index][1])
					setTimer ( resetSex, getTimeToWait (animations[index][3], true), 1, animations[index][1], index, source)
					killTimer (checkAnims)
					--showDick(source)
					break
				end
			end
		end
	end
end
addEventHandler("onPlayerChat", getRootElement(), talkWithSexPed)

function checkAnimations (player)
	triggerClientEvent ("setClientAnim", getRootElement(), player, true)
end

function stopSex (thePlayer,ped)
	if (playerAnim[thePlayer] == "BJ_Couch_Loop_P") then
		setPedAnimation ( thePlayer, "BLOWJOBZ", "BJ_Couch_End_P", -1, false, false, false, false )
		setPedAnimation ( ped, "BLOWJOBZ", "BJ_Couch_End_W", -1, false, false, false, false )
	elseif (playerAnim[thePlayer] == "BJ_Stand_Loop_P") then
		setPedAnimation ( thePlayer, "BLOWJOBZ", "BJ_Stand_End_P", -1, false, false, false, false )
		setPedAnimation ( ped, "BLOWJOBZ", "BJ_Stand_End_W", -1, false, false, false, false )
	elseif (playerAnim[thePlayer] == "sex_1_cum_P") then
		setPedAnimation ( thePlayer )
		setPedAnimation ( ped )
	elseif (playerAnim[thePlayer] == "BJ_Couch_Loop_W") then
		setPedAnimation ( ped, "BLOWJOBZ", "BJ_Couch_End_P", -1, false, false, false, false )
		setPedAnimation ( thePlayer, "BLOWJOBZ", "BJ_Couch_End_W", -1, false, false, false, false )
		showDick(ped)
	elseif (playerAnim[thePlayer] == "BJ_Stand_Loop_W") then
		setPedAnimation ( ped, "BLOWJOBZ", "BJ_Stand_End_P", -1, false, false, false, false )
		setPedAnimation ( thePlayer, "BLOWJOBZ", "BJ_Stand_End_W", -1, false, false, false, false )
		showDick(ped)
	elseif (playerAnim[thePlayer] == "sex_1_cum_W") then
		setPedAnimation ( thePlayer )
		setPedAnimation ( ped )
		showDick(ped)
	else
		outputDebugString("ANIM: "..tostring(playerAnim[thePlayer]))
		setPedAnimation ( thePlayer )
		setPedAnimation ( ped )
	end
end

function resetSex(ped, index, player)
	local x = animations[index][6]
	local y = animations[index][7]
	local z = animations[index][8]
	local rz = animations[index][9]
	setElementPosition(ped, x, y, z)
	setElementRotation(ped, 0, 0, rz)
	removeElementData(player, "sexbot")
	setElementPosition(player, x+0.5, y+0.5, z)
end

function setAnim (element, anim, isPlayer)
	if (isPlayer) then
		playerAnim[element] = anim
	else
		pedAnim[element] = anim
	end
end
addEvent ("setAnim", true)
addEventHandler ("setAnim", getRootElement(), setAnim)

function getGender (ped)
	if (pedGender[ped] == "m") then return "Hombre" end
	if (pedGender[ped] == "w") then return "Mujer" end
end