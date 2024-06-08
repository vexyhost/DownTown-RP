function sonidosarmascambiados(weaponID)
    local muzzleX, muzzleY, muzzleZ = getPedWeaponMuzzlePosition(source)
    local px, py, pz = getElementPosition ( source )
	local dim = getElementDimension(source)
	local int = getElementDimension(source)

	if weaponID == 22 then --colt45
		local sound = playSound3D("Sonidos/Colt45.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 95)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 23 then -- silenciada
		local sound = playSound3D("Sonidos/Silenced.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 15)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 24 then--deagle
		local sound = nil 
		if getElementData(source, "tazerOn") then
			sound = playSound3D("Sonidos/Tazer.wav", muzzleX, muzzleY, muzzleZ, false)
		else
			sound = playSound3D("Sonidos/Deagle.mp3", muzzleX, muzzleY, muzzleZ, false)
			setSoundVolume(sound, 0.3)
		end
		setSoundMaxDistance(sound, 120)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 25 then -- shotgun
		local sound = nil
		if getElementData(source, "gomaOn") then
			sound = playSound3D("Sonidos/beanbag.mp3", muzzleX, muzzleY, muzzleZ, false)
		else
			sound = playSound3D("Sonidos/Shotgun.mp3", muzzleX, muzzleY, muzzleZ, false)
			setSoundVolume(sound, 0.3)
		end
		setSoundMaxDistance(sound, 120)
		setElementDimension(sound, dim)
	elseif weaponID == 26 then--sawn-off
		local sound = playSound3D("Sonidos/Sawed-Off.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 95)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 27 then--combat shotgun
		local sound = playSound3D("Sonidos/Combat Shotgun.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 100)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 28 then--uzi
		local sound = playSound3D("Sonidos/UZI.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 105)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 32 then--tec-9
		local sound = playSound3D("Sonidos/tec9.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 105)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 29 then--mp5
		local sound = playSound3D("Sonidos/MP5.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 120)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 30 then--ak47
		local sound = playSound3D("Sonidos/AK-47.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 180)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 31 then--m4
		local sound = playSound3D("Sonidos/M4.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 170)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 33 then--rifle
		local sound = playSound3D("Sonidos/Rifle.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 175)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
	elseif weaponID == 34 then--sniper
		local sound = playSound3D("Sonidos/Sniper.mp3", muzzleX, muzzleY, muzzleZ, false)
		setSoundMaxDistance(sound, 325)
		setElementDimension(sound, dim)
		setSoundVolume(sound, 0.3)
    end
end
addEventHandler("onClientPlayerWeaponFire", root, sonidosarmascambiados)

---------------------
--------------------
----------------------
----------------------
----------------------
------------------------
---------------------------
-------------------------
------------------------
----------------------