local groups = { "Skins", "Vehs Facciones", "Vehs LowPoly" } -- Name of groups(also that are the folders). Example: { "Cars", "Bikes", "Planes" }

local mods = {
-- [Name of the file without extension] = {model ID, name of group also is the name of the folder inside mods}
["Uniforme PD Masculino"] = {280, "Skins"},
["Uniforme Sheriff 1"] = {282, "Skins"},
["uniforme pd swat"] = {285, "Skins"},
["uniforme pd negro"] = {265, "Skins"},
["Uniforme Sheriff 2"] = {281, "Skins"},
["Ambulancia"] = {416, "Vehs Facciones"},
["Camion Bomberos"] = {544, "Vehs Facciones"},
["Patrulla 1"] = {596, "Vehs Facciones"},
["Patrulla 2"] = {597, "Vehs Facciones"},
["Patrulla 3"] = {598, "Vehs Facciones"},
["Patrulla 4"] = {599, "Vehs Facciones"},
["fbi rancher"] = {490, "Vehs Facciones"},
["Servicios Municipales"] = {552, "Vehs Facciones"},
["Taxi"] = {420, "Vehs Facciones"},
["Buffalo"] = {402, "Vehs LowPoly"},
["Burrito"] = {482, "Vehs LowPoly"},
["Caravana"] = {508, "Vehs LowPoly"},
["Club"] = {589, "Vehs LowPoly"},
["Comet"] = {480, "Vehs LowPoly"},
["Faggio"] = {462, "Vehs LowPoly"},
["Huntley"] = {579, "Vehs LowPoly"},
["Landstalker"] = {400, "Vehs LowPoly"},
["Merit"] = {551, "Vehs LowPoly"},
["Premier"] = {426, "Vehs LowPoly"},
["Sentinel"] = {405, "Vehs LowPoly"},
["Stafford"] = {580, "Vehs LowPoly"},
["Super GT"] = {506, "Vehs LowPoly"},
["Washington"] = {421, "Vehs LowPoly"},
["Windsor"] = {555, "Vehs LowPoly"},
["ZR-350"] = {477, "Vehs LowPoly"},
["Elegant"] = {507, "Vehs LowPoly"},
["Cadrona"] = {527, "Vehs LowPoly"},
["Freeway"] = {463, "Vehs LowPoly"},
["Wayfarer"] = {586, "Vehs LowPoly"}
}

local nMods

addEventHandler("onResourceStart", resourceRoot,
	function()
		nMods = {}
		for i, v in pairs(mods) do
			nMods[i] = {}
			local txd = fileOpen("mods/"..v[2].."/"..i:lower()..".txd", true)
			local dff = fileOpen("mods/"..v[2].."/"..i:lower()..".dff", true)
			local size = fileGetSize(txd) + fileGetSize(dff)
			nMods[i] = { v[1], size, v[2] }
			fileClose(txd)
			fileClose(dff)
		end
	end
)

addEvent("requestModsData", true)
addEventHandler("requestModsData", root,
	function()
		triggerClientEvent(client, "transferModsData", client, nMods, groups)
	end
)