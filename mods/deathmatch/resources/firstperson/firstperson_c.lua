SD = false
SD_CLOCK_ROT = 0

screenWidth, screenHeight = guiGetScreenSize()

function isQuietWeapon(weaponid)
	if(weaponid >= 0 and weaponid <= 8 or weaponid == 23 or weaponid == 15 or weaponid == 41) then
		return true
	end
	return false
end

	dxDrawText(tostring(ammo), screenWidth-180, screenHeight-90, 180, 90, tocolor(255, 255, 255, 255), 2)
	dxDrawText(tostring(clips), screenWidth-120, screenHeight-90, 120, 90, tocolor(255, 255, 255, 255), 2)

local x, y, z, x1, y1, z1
local fpcam = false
 
bindKey( "F2", "down",
	function()
		if exports.players:isLoggedIn() and not getElementData(getLocalPlayer(), "muerto") == true then
			if fpcam then
				setCameraTarget(getLocalPlayer(), getLocalPlayer())
			end
				fpcam = not fpcam
			end
		end
)
 
addEventHandler("onClientPreRender", root,
	function()
		if fpcam then
			x, y, z = getPedBonePosition(getLocalPlayer(), 6)
			setCameraMatrix(x, y, z, x + x1, y + y1, z + z1)
			dxDrawImage(screenWidth/2-10, screenHeight/2-10, 20, 20, "images/aimer.png")
			local tarX, tarY, tarZ = getWorldFromScreenPosition(screenWidth/2, screenHeight/2, 30)
			setPedAimTarget(getLocalPlayer(), tarX, tarY, tarZ)
		end
	end
)

addEventHandler("onClientCursorMove", root,
	function( _, _, _, _, wx, wy, wz )
		local cx, cy, cz = getCameraMatrix()
		x1 = ( wx - cx ) / 300
		y1 = ( wy - cy ) / 300
		z1 = ( wz - cz ) / 300
	end
)

function isReloadWeapon(weapon)
	id = tonumber(weapon)
	if(id == 22 or id == 23 or id == 24 or id == 26 or id == 27 or id == 28 or id == 29 or id == 32 
		or id == 30 or id == 31 or id == 37 or id == 38 or id == 41 or id == 42 or id == 43) then
		return true
	else
		return false
	end
end

function isNotReloadWeapon(weapon)
	id = tonumber(weapon)
	if(id == 25 or id == 33 or id == 34 or id == 35 or id == 36) then --Projectiles isn't count
		return true
	else
		return false
	end
end