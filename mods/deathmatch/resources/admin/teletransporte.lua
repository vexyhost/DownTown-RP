local screen = {guiGetScreenSize()}
local teleport_position =
    {        
	 {"LSPD / Corte / Ayto", 1546.54, -1670.93, 13.57},
	 {"LSMD", 1180.03, -1329.3, 14.18},
	 {"LSND", 772.08, -1328.31, 13.55},
	 {"LSMW", 1778.47, -1813.63, 13.55},
	 {"Playa", 837.89, -1798.98, 13.21},
	 {"Autoescuela", 1375.55, -1753.73, 13.55},
	 {"Banco LS", 1472.39, -1025.63, 23.83},
	 {"Job Pizzero", 2096.46, -1807, 13.55},
	 {"Job Barrendero", 1643.07, -1883.06, 13.55},
	 {"Concesionario", 549.37, -1258.07, 16.88},
	 {"TTL", 2239.07, -2216.39, 13.55}
	}
                     
window = guiCreateWindow((screen[1]/2)-(240/2), (screen[2]/2)-(320/2), 240, 320, "Lugares Actuales", false)
guiSetVisible(window, false)
teleport_button = guiCreateButton(0, 0.78, 1, 0.08, "Ir", true, window)
close_button = guiCreateButton(0, 0.88, 1, 0.08, "Cerrar", true, window)
gridlist = guiCreateGridList(0, 0.08, 1.5, 0.68, true, window)
guiGridListAddColumn(gridlist, "Lugares definidos", 0.85)
for key, teleports in pairs(teleport_position) do
local row = guiGridListAddRow(gridlist)
guiGridListSetItemText(gridlist, row, 1, teleports[1], false, false)
end

bindKey("F9", "down",
function ()
	if exports.players:isLoggedIn(getLocalPlayer()) and getElementData(getLocalPlayer(), "account:gmduty") == true then
		guiSetVisible(window, not guiGetVisible(window))
		showCursor(not isCursorShowing())
    end
end)

function reguladorTrans()
	if source == teleport_button then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local check_gridlist = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)
		for key, teleports in pairs(teleport_position) do
		  if teleports[1] == check_gridlist then
		  outputChatBox("Te has teletransportado a " ..teleports[1]..".", 0, 255, 0)
		  fadeCamera(false, 1.0)
		  setTimer(fadeCamera, 1000, 1, true)
		  setTimer(setElementPosition, 1000, 1, getLocalPlayer(), teleports[2], teleports[3], teleports[4])
			if vehicle then
			setTimer(setElementPosition, 1000, 1, vehicle, teleports[2], teleports[3], teleports[4])
				end
			end
		end
	elseif source == close_button then
		guiSetVisible(window, false)
		showCursor(false)
	end
end
addEventHandler("onClientGUIClick", teleport_button, reguladorTrans)
addEventHandler("onClientGUIClick", close_button, reguladorTrans)