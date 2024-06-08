local sX, sY = guiGetScreenSize()
local x, y, w, h = 0, sY - 128, sX, 64
local tick = 0
local salida = false
         
function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.              
   end
   return false
end
        
function reguladorZona ()
	if getElementData(getLocalPlayer(), "concamaraspd") then return end 
	if getElementData(getLocalPlayer(), "account:gmduty") then return end 
	if getElementDimension(getLocalPlayer()) > 0 then return end
	local px, py, pz = getElementPosition(getLocalPlayer())
	local ciudad = getZoneName(px, py, pz, true)
	local ciudad2 = getZoneName(px, py, pz)
	if exports.players:isLoggedIn(getLocalPlayer()) and ciudad2 ~= "Palomino Creek" and ciudad2 ~= "Montgomery" and not isElementInRange(getLocalPlayer(), 1748.02, 258.29, 17.87, 650) and not isElementInRange(getLocalPlayer(), 2770.72, 45.02, 20.91, 200) and not isElementInRange(getLocalPlayer(), 2673.27, 297.83, 39.36, 320) then    
		if salida == false then
			tick = getTickCount()
			salida = true
		end    
	--Text
		dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200))
		local endTime = tick + 30000
		local elapsedTime = getTickCount() - tick
		local duration = endTime - tick
		local left = duration - elapsedTime
		if left > 0 then
			dxDrawText("Has salido de la zona de rol, vuelve o serás sancionado en #FF0000".. math.ceil(left/1000) .. " #FFFFFFsegundos.", x, y, w + x, h + y, tocolor(255, 255, 255, 255), 0.7, "bankgothic", "center", "center", false, false, false, true)
		elseif left < 0 then
			dxDrawText("#FF0000ATENCIÓN: #FFFFFFSe ha alertado a todo el staff.", x, y, w + x, h + y, tocolor(255, 255, 255, 255), 0.7, "bankgothic", "center", "center", false, false, false, true)
			if not avisoEmitido then
				triggerServerEvent("onJugadorFueraDeZonaDeRol", localPlayer)
				avisoEmitido = true
			end
		end
	else
		if salida == true then salida = false avisoEmitido = nil end
	end
end
addEventHandler("onClientRender", root, reguladorZona)