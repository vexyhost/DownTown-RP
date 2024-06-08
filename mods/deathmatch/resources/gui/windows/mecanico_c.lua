local nPiezas = 0
local pInstalada = {}
local pQuitada = {}

function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

local slots = {
	["Hood"] = 0,
	["Vent"] = 1,
	["Spoiler"] = 2,
	["Sideskirt"] = 3,
	["Front Bullbar"] = 4,
	["Rear Bullbar"] = 5,
	["Headlights"] = 6,
	["Roof"] = 7,
	["Nitro"] = 8,
	["Hydraulics"] = 9,
	["Stereo"] = 10,
	["Unknown"] = 11,
	["Wheels"] = 12,
	["Exhaust"] = 13,
	["Front Bumper"] = 14,
	["Rear Bumper"] = 15,
	["Misc."] = 16,

}

--Upgrade names!!!
local upgradeNames = 
{
	[1000] = "Pro",
	[1001] = "Win",
	[1002] = "Drag",
	[1003] = "Alpha",
	[1004] = "Champ Scoop",
	[1005] = "Fury Scoop",
	[1006] = "Roof Scoop",
	[1007] = "Right Sideskirt",
	[1008] = "Nitro x5",
	[1009] = "Nitro x2",
	[1010] = "Nitro x10",
	[1011] = "Race Scoop",
	[1012] = "Worx Scoop",
	[1013] = "Round Fog",
	[1014] = "Champ",
	[1015] = "Race",
	[1016] = "Worx",
	[1017] = "Left Sideskirt",
	[1018] = "Upswept",
	[1019] = "Twin",
	[1020] = "Large",
	[1021] = "Medium",
	[1022] = "Small",
	[1023] = "Fury",
	[1024] = "Square Fog",
	[1025] = "Offroad",
	[1026] = "Right Alien Sideskirt",
	[1027] = "Left Alien Sideskirt",
	[1028] = "Alien",
	[1029] = "X-Flow",
	[1030] = "Left X-Flow Sideskirt",
	[1031] = "Right X-Flow Sideskirt",
	[1032] = "Alien Roof Vent",
	[1033] = "X-Flow Roof Vent",
	[1034] = "Alien",
	[1035] = "X-Flow Roof Vent",
	[1036] = "Right Alien Sideskirt",
	[1037] = "X-Flow",
	[1038] = "Alien Roof Vent",
	[1039] = "Left X-Flow Sideskirt",
	[1040] = "Left Alien Sideskirt",
	[1041] = "Right X-Flow Sideskirt",
	[1042] = "Right Chrome Sideskirt",
	[1043] = "Slamin",
	[1044] = "Chrome",
	[1045] = "X-Flow",
	[1046] = "Alien",
	[1047] = "Right Alien Sideskirt",
	[1048] = "Right X-Flow Sideskirt",
	[1049] = "Alien",
	[1050] = "X-Flow",
	[1051] = "Left Alien Sideskirt",
	[1052] = "Left X-Flow Sideskirt",
	[1053] = "X-Flow",
	[1054] = "Alien",
	[1055] = "Alien",
	[1056] = "Right Alien Sideskirt",
	[1057] = "ight X-Flow Sideskirt",
	[1058] = "Alien",
	[1059] = "X-Flow",
	[1060] = "X-Flow",
	[1061] = "X-Flow",
	[1062] = "Left Alien Sideskirt",
	[1063] = "Left X-Flow Sideskirt",
	[1064] = "Alien",
	[1065] = "Alien",
	[1066] = "X-Flow",
	[1067] = "Alien",
	[1068] = "X-Flow",
	[1069] = "Right Alien Sideskirt",
	[1070] = "Right X-Flow Sideskirt",
	[1071] = "Left Alien Sideskirt",
	[1072] = "Left X-Flow Sideskirt",
	[1073] = "Shadow",
	[1074] = "Mega",
	[1075] = "Rimshine",
	[1076] = "Wires",
	[1077] = "Classic",
	[1078] = "Twist",
	[1079] = "Cutter",
	[1080] = "Switch",
	[1081] = "Grove",
	[1082] = "Import",
	[1083] = "Dollar",
	[1084] = "Trance",
	[1085] = "Atomic",
	[1086] = "Stereo",
	[1087] = "Hydraulics",
	[1088] = "Alien",
	[1089] = "X-Flow",
	[1090] = "Right Alien Sideskirt",
	[1091] = "X-Flow",
	[1092] = "Alien",
	[1093] = "Right X-Flow Sideskirt",
	[1094] = "Left Alien Sideskirt",
	[1095] = "Right X-Flow Sideskirt",
	[1096] = "Ahab",
	[1097] = "Virtual",
	[1098] = "Access",
	[1099] = "Left Chrome Sideskirt",
	[1100] = "Chrome Grill",
	[1101] = "Left `Chrome Flames` Sideskirt",
	[1102] = "Left `Chrome Strip` Sideskirt",
	[1103] = "Covertible",
	[1104] = "Chrome",
	[1105] = "Slamin",
	[1106] = "Right `Chrome Arches`",
	[1107] = "Left `Chrome Strip` Sideskirt",
	[1108] = "`Chrome Strip` Sideskirt",
	[1109] = "Chrome",
	[1110] = "Slamin",
	[1111] = "Little Sign?",
	[1112] = "Little Sign?",
	[1113] = "Chrome",
	[1114] = "Slamin",
	[1115] = "Chrome",
	[1116] = "Slamin",
	[1117] = "Chrome",
	[1118] = "Right `Chrome Trim` Sideskirt",
	[1119] = "Right `Wheelcovers` Sideskirt",
	[1120] = "Left `Chrome Trim` Sideskirt",
	[1121] = "Left `Wheelcovers` Sideskirt",
	[1122] = "Right `Chrome Flames` Sideskirt",
	[1123] = "Bullbar Chrome Bars",
	[1124] = "Left `Chrome Arches` Sideskirt",
	[1125] = "Bullbar Chrome Lights",
	[1126] = "Chrome Exhaust",
	[1127] = "Slamin Exhaust",
	[1128] = "Vinyl Hardtop",
	[1129] = "Chrome",
	[1130] = "Hardtop",
	[1131] = "Softtop",
	[1132] = "Slamin",
	[1133] = "Right `Chrome Strip` Sideskirt",
	[1134] = "Right `Chrome Strip` Sideskirt",
	[1135] = "Slamin",
	[1136] = "Chrome",
	[1137] = "Left `Chrome Strip` Sideskirt",
	[1138] = "Alien",
	[1139] = "X-Flow",
	[1140] = "X-Flow",
	[1141] = "Alien",
	[1142] = "Left Oval Vents",
	[1143] = "Right Oval Vents",
	[1144] = "Left Square Vents",
	[1145] = "Right Square Vents",
	[1146] = "X-Flow",
	[1147] = "Alien",
	[1148] = "X-Flow",
	[1149] = "Alien",
	[1150] = "Alien",
	[1151] = "X-Flow",
	[1152] = "X-Flow",
	[1153] = "Alien",
	[1154] = "Alien",
	[1155] = "Alien",
	[1156] = "X-Flow",
	[1157] = "X-Flow",
	[1158] = "X-Flow",
	[1159] = "Alien",
	[1160] = "Alien",
	[1161] = "X-Flow",
	[1162] = "Alien",
	[1163] = "X-Flow",
	[1164] = "Alien",
	[1165] = "X-Flow",
	[1166] = "Alien",
	[1167] = "X-Flow",
	[1168] = "Alien",
	[1169] = "Alien",
	[1170] = "X-Flow",
	[1171] = "Alien",
	[1172] = "X-Flow",
	[1173] = "X-Flow",
	[1174] = "Chrome",
	[1175] = "Slamin",
	[1176] = "Chrome",
	[1177] = "Slamin",
	[1178] = "Slamin",
	[1179] = "Chrome",
	[1180] = "Chrome",
	[1181] = "Slamin",
	[1182] = "Chrome",
	[1183] = "Slamin",
	[1184] = "Chrome",
	[1185] = "Slamin",
	[1186] = "Slamin",
	[1187] = "Chrome",
	[1188] = "Slamin",
	[1189] = "Chrome",
	[1190] = "Slamin",
	[1191] = "Chrome",
	[1192] = "Chrome",
	[1193] = "Slamin"
}

function getVehicleUpgradeBySlot(slot)
	local upgrades = {}
	local vehicle = getPedOccupiedVehicle ( localPlayer )
	if vehicle then
		if slot == "all" then
			for i=0,16 do
				if i ~= 12 then
					local t = getVehicleCompatibleUpgrades ( vehicle , i )
					for upgradeKey, upgradeValue in ipairs ( t ) do
						colorIn = { 255, 255, 255 }
						local upgradeValue2 = getVehicleUpgradeOnSlot (vehicle, i)
						if upgradeValue2 and upgradeValue2 == upgradeValue then
							colorIn = { 70, 255, 70 }
						elseif pQuitada[upgradeValue] == true then
							colorIn = { 255, 70, 70 }
						else
							colorIn = { 255, 255, 255 }
						end
						table.insert(upgrades, { 
							type = "text",
							upgradeNames[upgradeValue],
							getVehicleUpgradeSlotName ( i ),
							font = "default-bold",
							color = colorIn,
							onClick = function( key )
							if key == 1 then
								local slotModif = getVehicleUpgradeSlotName(upgradeValue)
								local piezaActual = getVehicleUpgradeOnSlot(vehicle, slots[slotModif])
								if piezaActual == upgradeValue then outputChatBox("Esta pieza ya está instalada.", 255, 0, 0) return end
								if not pInstalada[upgradeValue] == true then
									if piezaActual and pInstalada[piezaActual] == true then
										pInstalada[piezaActual] = nil
										pInstalada[upgradeValue] = true
										outputChatBox("Pieza de tunning instalada cambiada. Esta operación no tiene coste de piezas.", 0, 255, 0)
									elseif pQuitada[upgradeValue] == true then
										pQuitada[upgradeValue] = nil
										outputChatBox("Pieza de tunning reinstalada. Esta operación no tiene coste de piezas.", 0, 255, 0)
									else
										if piezaActual then
											pQuitada[piezaActual] = true
										end
										pInstalada[upgradeValue] = true
										nPiezas = nPiezas + 4
										outputChatBox("Pieza de tunning instalada (+4) Piezas que se te descontarán: "..tostring(nPiezas), 0, 255, 0)
										outputChatBox("Puedes cambiarla ahora sin coste de piezas si es del mismo tipo (Ej. Alerón)", 255, 255, 255)
									end
								end
								triggerServerEvent ( "onChangeUpgrade", localPlayer, upgradeValue )
							elseif key == 2 then
								local slotModif = getVehicleUpgradeSlotName(upgradeValue)
								local piezaActual = getVehicleUpgradeOnSlot(vehicle, slots[slotModif])
								if piezaActual and piezaActual == upgradeValue then
									if pInstalada[upgradeValue] == true then
										pInstalada[upgradeValue] = nil
										nPiezas = nPiezas - 4
										outputChatBox("Pieza de tunning desinstalada (-4) Piezas que se te descontarán: "..tostring(nPiezas), 0, 255, 0)
									else
										pQuitada[upgradeValue] = true
										outputChatBox("Pieza de tunning desinstalada. Esta operación no tiene coste de piezas.", 0, 255, 0)
										outputChatBox("Puedes volver a instalarla ahora mismo sin coste de piezas.", 255, 255, 255)
									end
									triggerServerEvent ( "onRemoveUpgrade", localPlayer, upgradeValue )
								else
									outputChatBox("No puedes desinstalar una pieza que no está instalada.", 255, 0, 0)
								end
							end
							end,
							onHover = function( cursor, pos )
								dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
							end}
						)
					end
				end
			end
		else
			local t = getVehicleCompatibleUpgrades ( vehicle , slot )
			for upgradeKey, upgradeValue in ipairs ( t ) do
					colorIn = { 255, 255, 255 }
					local upgradeValue2 = getVehicleUpgradeOnSlot (vehicle, slot)
					if upgradeValue2 and upgradeValue2 == upgradeValue then
						colorIn = { 70, 255, 70 }
					elseif pQuitada[upgradeValue] == true then
						colorIn = { 255, 70, 70 }
					else
						colorIn = { 255, 255, 255 }
					end
				table.insert(upgrades, {  
					type = "text",
					upgradeNames[upgradeValue],
					font = "default-bold",
					color =  colorIn,
					onClick = function(key)
						if key == 1 then
							local piezaActual = getVehicleUpgradeOnSlot(vehicle, slot)
							if piezaActual == upgradeValue then outputChatBox("Este tipo de llantas es el actual.", 255, 0, 0) return end
							if not pInstalada[upgradeValue] == true then
								if piezaActual and pInstalada[piezaActual] == true then
									pInstalada[piezaActual] = nil
									pInstalada[upgradeValue] = true
									outputChatBox("Llantas cambiadas. Esta operación no tiene coste de piezas.", 0, 255, 0)
								elseif pQuitada[upgradeValue] == true then
									pQuitada[upgradeValue] = nil
									outputChatBox("Llantas cambiadas. Esta operación no tiene coste de piezas.", 0, 255, 0)
								else
									if piezaActual then
										pQuitada[piezaActual] = true
									end
									pInstalada[upgradeValue] = true
									nPiezas = nPiezas + 4
									outputChatBox("Llantas nuevas instaladas (+4) Piezas que se te descontarán: "..tostring(nPiezas), 0, 255, 0)
									outputChatBox("Puedes cambiarlas ahora sin coste de piezas.", 255, 255, 255)
								end
							end
							triggerServerEvent ( "onChangeUpgrade", localPlayer, upgradeValue )
						elseif key == 2 then
							local piezaActual = getVehicleUpgradeOnSlot(vehicle, slot)
							if piezaActual and piezaActual == upgradeValue then
								if pInstalada[upgradeValue] == true then
									pInstalada[upgradeValue] = nil
									nPiezas = nPiezas - 4
									outputChatBox("Llantas desinstaladas (-4) Piezas que se te descontarán: "..tostring(nPiezas), 0, 255, 0)
								else
									pQuitada[upgradeValue] = true
									outputChatBox("Llantas desinstaladas. Esta operación no tiene coste de piezas.", 0, 255, 0)
									outputChatBox("Puedes volver a instalarlas ahora mismo sin coste de piezas.", 255, 255, 255)
								end
								triggerServerEvent ( "onRemoveUpgrade", localPlayer, upgradeValue )
							else
								outputChatBox("No puedes quitar unas llantas que no están instalada.", 255, 0, 0)
							end
						end
					end,
					onHover = function( cursor, pos )
						dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
					end}
				)
			end
		end
		return upgrades
	else
		table.insert(upgrades,{  
		type = "text",
		"Sube a un vehiculo",
		font = "default-bold",
		color =  { 255, 0, 0 }})
		return upgrades
	end
end

function isVehiculoDanado(vehicle)
	if not vehicle then return false end
	local isBroken = false
	for i=0,5 do
		local doorState = getVehicleDoorState(vehicle, i)
		if doorState == 2 or doorState == 3 or doorState == 4 then
			if getElementModel(vehicle) == 568 and doorState == 4 then
				return false
			end
			isBroken = true
		end
	end
	if getElementHealth(vehicle) <= 850 then 
		isBroken = true
	end
	return isBroken
end

windows.mecanico = {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/1.png",
				title = "Reparar",
				text = "Reparar el motor, la chapa o las ruedas del vehículo.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico_repair")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			},
			{
				image = "images/mecanico/4.png",
				title = "Ruedas",
				text = "Cambiar las ruedas del vehiculo.\nNecesitas 4 piezas.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						local vehicle = getPedOccupiedVehicle(getLocalPlayer())
						if isVehiculoDanado(vehicle) then outputChatBox("Debes de reparar el vehículo primero.", 255, 0, 0) return end
						nPiezas = 0
						pInstalada = {}
						pQuitada = {}
						show("mecanico_ruedas")
						setElementData(vehicle, "inTunning", true)
						setElementData(vehicle, "inTunningGUI", true)
						setElementData(localPlayer, "nocursor", true)
						triggerEvent("onCursor", localPlayer)
					end
				end,
			},
			{
				image = "images/mecanico/5.png",
				title = "Tunning",
				text = "Mejorar el aspecto exterior del vehiculo.\nNecesitas 4 piezas para cada pieza que instales.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						local vehicle = getPedOccupiedVehicle(getLocalPlayer())
						if isVehiculoDanado(vehicle) then outputChatBox("Debes de reparar el vehículo primero.", 255, 0, 0) return end
						nPiezas = 0
						pInstalada = {}
						pQuitada = {}
						show("mecanico_tunning")
						setElementData(vehicle, "inTunning", true)
						setElementData(vehicle, "inTunningGUI", true)
						setElementData(localPlayer, "nocursor", true)
						triggerEvent("onCursor", localPlayer)
					end
				end,
			},
			{
				image = "images/mecanico/6.png",
				title = "Color",
				text = "Cambiar el color del vehiculo.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico_color")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			},
			{
				image = "images/mecanico/7.png",
				title = "Fases",
				text = "Mejoras de motor y frenos para tu vehículo.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico_fases")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			},
			{
				image = ":items/images/34.png",
				title = "Más opciones",
				text = "Tienes numerosas opciones como los vinilos, cambio de cerradura, etcétera.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico_otras")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			},	
			{
				image = "images/mecanico/-2.png",
				title = "Cerrar",
				text = "Haz click aquí para cerrar el panel mecánico.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						hide()
						toggleAllControls(true)
						setElementData(localPlayer, "nocursor", nil)
					end
				end,
			}
		}
	}
}

windows.mecanico_repair =  {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/3.png",
				title = "Chasis",
				text = "Reparar la chapa del vehículo.\nNecesitas 2 piezas.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						triggerServerEvent( "mecanico:repair", localPlayer, 1 )
					end
				end,
			},
			{
				image = "images/mecanico/2.png",
				title = "Motor",
				text = "Reparar el motor del vehiculo.\nNecesitas 3 piezas.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						triggerServerEvent( "mecanico:repair", localPlayer, 2 )
					end
				end,
			},
			{
				image = "images/mecanico/4.png",
				title = "Ruedas",
				text = "Reparar cualquier rueda del vehículo.\nNecesitas 4 piezas por cada rueda.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						local tipo = getVehicleType(getPedOccupiedVehicle(getLocalPlayer()))
						if tipo == "Automobile" or tipo == "Trailer" or tipo == "Quad" then
							show("mecanico_repair_ruedas_1")
						else
							show("mecanico_repair_ruedas_2")
						end
						triggerEvent("onCursor", localPlayer)
					end
				end,
			},
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver atrás al menú general.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		}
	}
}

windows.mecanico_repair_ruedas_1 =  {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/4.png",
				title = "Rueda delantera derecha",
				text = "Reparar la rueda delantera derecha.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						triggerServerEvent( "mecanico:repair_rueda", localPlayer, 1 )
					end
				end,
			},
			{
				image = "images/mecanico/4.png",
				title = "Rueda delantera izquierda",
				text = "Reparar la rueda delantera izquierda.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						triggerServerEvent( "mecanico:repair_rueda", localPlayer, 2 )
					end
				end,
			}, 
			{
				image = "images/mecanico/4.png",
				title = "Rueda trasera derecha",
				text = "Reparar la rueda trasera derecha.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						triggerServerEvent( "mecanico:repair_rueda", localPlayer, 3 )
					end
				end,
			},
			{
				image = "images/mecanico/4.png",
				title = "Rueda trasera izquierda",
				text = "Reparar la rueda trasera derecha.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						triggerServerEvent( "mecanico:repair_rueda", localPlayer, 4 )
					end
				end,
			},
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver al menú de reparación.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico_repair")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		}
	}
}

windows.mecanico_repair_ruedas_2 =  {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/4.png",
				title = "Rueda delantera",
				text = "Reparar la rueda delantera.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						triggerServerEvent( "mecanico:repair_rueda", localPlayer, 2 )
					end
				end,
			},
			{
				image = "images/mecanico/4.png",
				title = "Rueda trasera",
				text = "Reparar la rueda trasera.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						triggerServerEvent( "mecanico:repair_rueda", localPlayer, 4 )
					end
				end,
			}, 
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver al menú de reparación.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico_repair")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		}
	}
}

windows.mecanico_ruedas = {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "grid",
		columns =
		{
			{ name = "Ruedas", width = 1, alignX = "center" },
		},
		content = 
		function ()
			return getVehicleUpgradeBySlot(12)
		end
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/-1.png",
				title = "Guardar",
				text = "Guardar las llantas actual. ATENCIÓN: si has instalado llantas, se te restarán piezas e instalarán en el vehículo definitivamente.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						setElementData(getPedOccupiedVehicle(localPlayer), "inTunningGUI", nil)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:savetunning", localPlayer, getPedOccupiedVehicle(localPlayer), pInstalada, pQuitada, nPiezas)
						hide()
					end
				end,
			},
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver atrás al menú general.",wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						setElementData(getPedOccupiedVehicle(localPlayer), "inTunningGUI", nil)
						triggerServerEvent( "mecanico:canceltunning", localPlayer, getPedOccupiedVehicle(localPlayer))
						show("mecanico")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		}
	}
}

windows.mecanico_tunning = {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "grid",
		columns =
		{
			{ name = "Name", width = 0.5, alignX = "center" },
			{ name = "Type", width = 0.5, alignX = "center" },
		},
		content = 
		function ()
			return getVehicleUpgradeBySlot("all")
		end
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/-1.png",
				title = "Guardar",
				text = "Guardar el tunning actual. ATENCIÓN: si has instalado piezas, se te restarán e instalarán en el vehículo definitivamente.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						setElementData(getPedOccupiedVehicle(localPlayer), "inTunningGUI", nil)
						triggerServerEvent( "mecanico:savetunning", localPlayer, getPedOccupiedVehicle(localPlayer), pInstalada, pQuitada, nPiezas)
						hide()
					end
				end,
			},
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver atrás al menú general.",wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						setElementData(getPedOccupiedVehicle(localPlayer), "inTunningGUI", nil)
						triggerServerEvent( "mecanico:canceltunning", localPlayer, getPedOccupiedVehicle(localPlayer))
						show("mecanico")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		} 
	},
	{
		type = "label",
		text = "Click izquierdo para añadir una mejora.",
		font = "default-bold",
		alignX = "center",
		onRender = function( pos )
			dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
		end,
	},
	{
		type = "label",
		text = "Click derecho para quitar una mejora.",
		font = "default-bold",
		alignX = "center",
		onRender = function( pos )
			dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 31 } ) ) )
		end,
	},
}

windows.mecanico_color = {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{
				image = "images/mecanico/6.png",
				title = "Color 1#",
				text = "Se cambia el color primario del vehiculo.\nNecesitas 4 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						exports.colorblender:openPicker(1, 0, "Color primario, selecciona para previsualizar.")
						hide()
					end
				end
			}, 
			{
				image = "images/mecanico/6.png",
				title = "Color 2#",
				text = "Se cambia el color secundario del vehiculo.\nNecesitas 3 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						local vehicle = getPedOccupiedVehicle(getLocalPlayer())
						local _, _, _, r, g, b = getVehicleColor ( vehicle, true )
						setElementData(vehicle, "pr2", r)
						setElementData(vehicle, "pg2", g)
						setElementData(vehicle, "pb2", b)
						exports.colorblender:openPicker(2, 0, "Color secundario, selecciona para previsualizar.")
						hide()
					end
				end
			},
			{
				image = "images/mecanico/6.png",
				title = "Color 3#",
				text = "Se cambia el color de los faros.\nNecesitas 2 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						local vehicle = getPedOccupiedVehicle(getLocalPlayer())
						local r, g, b = getVehicleHeadLightColor ( vehicle, true )
						setElementData(vehicle, "pr3", r)
						setElementData(vehicle, "pg3", g)
						setElementData(vehicle, "pb3", b)
						exports.colorblender:openPicker(3, 0, "Color de faros, selecciona para previsualizar.")
						hide()
					end
				end
			},
		}
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver atrás al menú general.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		}
	},
	
}









windows.mecanico_vinilos = {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{
				image = "images/mecanico/vini.png",
				title = "Quitar Capa Vinilo",
				text = "Se quitará el vinilo que tenga puesto.\nNecesitas 50 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:quitarviniloS", getLocalPlayer())
						hide()
					end
				end
			}, 
			{
				image = "images/mecanico/vini.png",
				title = "Vinilo número 1#",
				text = "Se pintará el vehículo con vinilos.\nNecesitas 200 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:vinilos2", getLocalPlayer(), 0 )
						hide()
					end
				end
			}, 
			{
				image = "images/mecanico/vini.png",
				title = "Vinilo número 2#",
				text = "Se pintará el vehículo con vinilos.\nNecesitas 200 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:vinilos2", localPlayer, 1 )
						hide()
					end
				end
			},
			{
				image = "images/mecanico/vini.png",
				title = "Vinilo número 3#",
				text = "Se pintará el vehículo con vinilos.\nNecesitas 200 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
					    triggerServerEvent( "mecanico:vinilos2", localPlayer, 2 )
						hide()
					end
				end
			},
		}
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver atrás al menú general.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		}
	},
	
}


windows.mecanico_fases = {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{
				image = "images/mecanico/5.png",
				title = "Mejora del motor",
				text = "Aumentará una fase de mejora del motor.\nNo consume piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:mejora", localPlayer, 1 )
						hide()
					end
				end
			}, 
			{
				image = "images/mecanico/5.png",
				title = "Mejora de los frenos",
				text = "Aumentará una fase de mejora de los frenos.\nNo consume piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:mejora", localPlayer, 2 )
						hide()
					end
				end
			},
		}
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver atrás al menú general.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		}
	},
	
}

windows.mecanico_otras = {
	{
		type = "label",
		text = "Montgomery Motor Workshop",
		font = "default-bold",
		alignX = "center",
	},
	{
		type = "pane",
		panes = 
		{
			{
				image = "images/mecanico/1.png",
				title = "Revisar vehículo",
				text = "Realizar mantenimiento y cambio de piezas necesarias.\nHaz click para calcular piezas (no se hará nada sin confirmar).",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 0, 255, 0, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:revision", localPlayer )
						hide()
					end
				end,
			},
			{
				image = "images/mecanico/9.png",
				title = "Cambiar cerradura",
				text = "Todas las llaves anteriores quedarán anuladas,\ny el dueño recibirá una nueva.\nNecesitas 4 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:cerradura", localPlayer )
						hide()
					end
				end
			},
			{
				image = "images/mecanico/10.png",
				title = "Instalar alarma",
				text = "Con esta alarma sonora, si le pasa algo a tu coche\nse enterará media ciudad.\nNecesitas 5 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:alarma", localPlayer )
						hide()
					end
				end
			},
			{
				image = "images/mecanico/8.png",
				title = "Marchas (Modo Automático)",
				text = "Así no tendrás que preocuparte por la marcha que\nllevas. Este modo es el normal del servidor\nNecesitas 100 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:marchas", localPlayer, 1 )
						hide()
					end
				end
			}, 
			{
				image = "images/mecanico/8.png",
				title = "Marchas (Modo Manual)",
				text = "Este modo es para los fanáticos de la conducción.\nNecesitas 100 piezas.",
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 31 } ) ) )
				end,
				onClick = function ( key )
					if key == 1 then
						setElementData(localPlayer, "nocursor", nil)
						triggerEvent("offCursor", localPlayer)
						toggleAllControls(true)
						triggerServerEvent( "mecanico:marchas", localPlayer, 0 )
						hide()
					end
				end
			},
		    {
				image = "images/mecanico/vini.png",
				title = "Vinilos",
				text = "Pinturas modificadas con pegatinas en vehículos.\nNecesitas 200 piezas.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 75, 255, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico_vinilos")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			},
		}
	},
	{
		type = "pane",
		panes = {
			{
				image = "images/mecanico/-1.png",
				title = "Atrás",
				text = "Volver atrás al menú general.",
				wordBreak = true,
				onHover = function( cursor, pos )
					dxDrawRectangle( pos[1], pos[2], pos[3] - pos[1], pos[4] - pos[2], tocolor( unpack( { 255, 75, 75, 50 } ) ) )
				end,
				onClick = function( key )
					if key == 1 then
						show("mecanico")
						triggerEvent("onCursor", localPlayer)
					end
				end,
			}
		}
	},
	
}

function TriggerChangeColor( id, hex, r, g, b )
	toggleAllControls(true)
	triggerEvent("offCursor", localPlayer)
	if id == 1 then
		triggerServerEvent ( "onChangeVehicleColor", localPlayer, 1, r, g, b )
	elseif id == 2 then
		triggerServerEvent ( "onChangeVehicleColor", localPlayer, 2, r, g, b )
	elseif id == 3 then
		triggerServerEvent ( "onChangeVehicleColor", localPlayer, 3, r, g, b )
	end
end
addEventHandler("onColorPickerOK", root, TriggerChangeColor)

function TriggerViewColor( id, hex, r, g, b )
	if id == 1 then
		triggerServerEvent ( "onViewVehicleColor", localPlayer, 1, r, g, b )
	elseif id == 2 then
		triggerServerEvent ( "onViewVehicleColor", localPlayer, 2, r, g, b )
	elseif id == 3 then
		triggerServerEvent ( "onViewVehicleColor", localPlayer, 3, r, g, b )
	end
end
addEvent("onColorPickerPreOK", true)
addEventHandler("onColorPickerPreOK", root, TriggerViewColor)

addEvent("onPlayerOpenMecanico", true)
addEventHandler("onPlayerOpenMecanico", localPlayer,
function()
	if not exports.gui:getShowing() then
		toggleAllControls(false)
		setElementData(localPlayer, "nocursor", true)
		triggerEvent("onCursor", localPlayer)
		show("mecanico")
	else
		toggleAllControls(true)
		setElementData(localPlayer, "nocursor", nil)
		triggerEvent("offCursor", localPlayer)
		hide()
	end
end
)