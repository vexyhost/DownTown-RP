function savePeds ()
	local checkFile = xmlLoadFile("database/peds.xml")
	if checkFile then
		xmlUnloadFile(checkFile)
		fileDelete (":database/peds.xml")
	end
	pedsXML = xmlCreateFile("database/peds.xml", "data")
	xmlLoadFile("database/peds.xml")
	for key, peds in ipairs (getElementsByType("ped")) do
		local child = xmlCreateChild(pedsXML, "ped")
		local skin = getElementModel(peds)
		local x,y,z = getElementPosition(peds)
		local _,_,rz = getElementRotation(peds)
		local int, dim = getElementInterior(peds), getElementDimension (peds)
		xmlNodeSetAttribute ( child, "skin", tonumber(skin) )
		xmlNodeSetAttribute ( child, "x", tonumber(x) )
		xmlNodeSetAttribute ( child, "y", tonumber(y) )
		xmlNodeSetAttribute ( child, "z", tonumber(z) )
		xmlNodeSetAttribute ( child, "rz", tonumber(rz) )
		xmlNodeSetAttribute ( child, "int", tonumber(int) )
		xmlNodeSetAttribute ( child, "dim", tonumber(dim) )
		xmlNodeSetAttribute ( child, "sextype", tostring(sexType[peds]) )
		xmlNodeSetAttribute ( child, "gender", tostring(pedGender[peds]) )
	end
	xmlSaveFile(pedsXML)
end
--addCommandHandler("savepeds", savePeds)

function createSexPedFromXML (skin, x, y, z, rz, anim, gender, int, dim)
	if tonumber(skin) then
		local sexped = createPed ( tonumber(skin), x, y, z, tonumber(rz) )
		--setElementFrozen ( sexped, true )
		setElementInterior ( sexped, tonumber(int) )
		setElementDimension ( sexped, tonumber(dim) )
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
	end
end
 
function loadPeds ()
	local checkFile = xmlLoadFile("database/peds.xml")
	if checkFile then
		for i = 0, 2000 do
			local child = xmlFindChild ( checkFile, "ped", i )
			if child then
				local skin = xmlNodeGetAttribute ( child, "skin" )
				local x = xmlNodeGetAttribute ( child, "x" )
				local y = xmlNodeGetAttribute ( child, "y" )
				local z = xmlNodeGetAttribute ( child, "z" )
				local rz = xmlNodeGetAttribute ( child, "rz" )
				local int = xmlNodeGetAttribute ( child, "int" )
				local dim = xmlNodeGetAttribute ( child, "dim" )
				local sextype = xmlNodeGetAttribute ( child, "sextype" )
				local gender = xmlNodeGetAttribute ( child, "gender" )
				createSexPedFromXML (tonumber(skin), x, y, z, rz, sextype, gender, int, dim )
			end
		end
	else
		outputChatBox("peds.xml doesn't exist!",getRootElement(),255,0,0)
	end
end
--addCommandHandler("loadpeds", loadPeds)

loadPeds ()