function setClientAnim (element,isPlayer)
	local _, anim = getPedAnimation (element)
	if (not anim) then anim = false end
	triggerServerEvent ("setAnim", getLocalPlayer(), element, anim, isPlayer)
end
addEvent ("setClientAnim", true)
addEventHandler ("setClientAnim", getRootElement(), setClientAnim)

function replaceModels ()
	local dick = engineLoadTXD("files/dickwhite.txd")
	engineImportTXD(dick, 1337)
	local dick = engineLoadDFF("files/dick.dff", 1337)
	engineReplaceModel(dick, 1337)
end
addEventHandler ("onClientResourceStart", getResourceRootElement(getThisResource()), replaceModels)

data = {
	{id=1,name="1",texture="1"},
	{id=266,name="266",texture="266"},
	{id=267,name="267",texture="267"},
	{id=268,name="268",texture="268"},
	{id=270,name="270",texture="270"},
	{id=271,name="271",texture="271"},
	{id=272,name="272",texture="272"},
	{id=290,name="290",texture="290"},
	{id=291,name="291",texture="291"},
	{id=292,name="292",texture="292"},
	{id=293,name="293",texture="293"},
	{id=294,name="294",texture="294"},
	{id=295,name="295",texture="295"},
	{id=296,name="296",texture="296"},
	{id=297,name="297",texture="297"},
	{id=298,name="298",texture="298"},
	{id=299,name="299",texture="299"},
	{id=300,name="300",texture="300"},
	{id=301,name="301",texture="301"},
	{id=302,name="302",texture="302"},
	{id=303,name="303",texture="303"},
	{id=304,name="304",texture="304"}
}

function replaceNakedSkin ()
	for key, v in ipairs (data) do
		if engineImportTXD ( engineLoadTXD ("files/skins/"..(v.texture)..".txd"), v.id ) then
			engineReplaceModel ( engineLoadDFF ("files/skins/"..(v.name)..".dff", v.id ), v.id )
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), replaceNakedSkin)


function playScreamSound (x,y,z,bank,id)
	scream = playSFX3D ( "pain_a", tonumber(bank), tonumber(id), x, y, z )
	setSoundMaxDistance (scream, 25)
end
addEvent ("playScreamSound", true)
addEventHandler ("playScreamSound", getRootElement(), playScreamSound)