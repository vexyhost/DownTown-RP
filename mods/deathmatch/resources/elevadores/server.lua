local root = getRootElement()
------------------------------------------------ Configuration ------------------------------------------------
-- A stands for Arm, which is the bars holding the lift.                                                     -- 
-- B stands for Base, this is the lift that pushes the vehicle up and lets it down.                          --
-- Just for reference if you get confused on this config..                                                   --
-- Ax,Ay,Az,Arx,Ary,Arz = Arm location and rotation.                                                         --
-- Bx,By,Bz,Brx,Bry,Brz = Base location and rotation.                                                        --
-- I just used offedit by Offroader23 and got the element position that way, but do what you want :D         --
---------------------------------------------------------------------------------------------------------------
lifts = {
    {Ax =  -100.423828125,Ay = 1118.470703125,Az = 18.80354385376,Bx = -100.423828125,By = 1118.470703125,Bz = 15.20354385376,Brx = 0,Bry = 0,Brz = 180,Arx = 0,Ary = 0,Arz = 180},
}
distance = 20 -- This is the distance you want it to read from the player to the lift.
-- So if the player is 6 (whatever) away from any lift, it will trigger the lift on command.
----------------------------------------------------------------------------------------------------------------
data = {}
nE = 1
for i,l in pairs(lifts) do
	table.insert(data,{Arm = createObject(2597,l.Ax,l.Ay,l.Az,l.Arx,l.Ary,l.Arz),Base = createObject(2231,l.Bx,l.By,l.Bz,l.Brx,l.Bry,l.Brz)})
end

for i,s in pairs(data) do
	local x,y,z = getElementPosition(s.Base)
	setElementData(s.Base,"eID", nE)
	nE = nE + 1
	setElementData(s.Base,"state","down")
	setElementData(s.Base,"reset",z)
	setElementData(s.Base,"reset2",z+2.371852874756)
	setElementCollisionsEnabled(s.Arm, false)
end

addCommandHandler("elevador1", function(player)
	if not exports.factions:isPlayerInFaction(player, 3) then return end
	for i,d in pairs(data) do
		if getElementData(d.Base, "eID") == 1 then
			local vx,vy,vz = getElementPosition(d.Base)
			for k, v in ipairs(getElementsByType("vehicle")) do
				local x2, y2, z2 = getElementPosition(v)
				if getDistanceBetweenPoints3D(x2, y2, z2, vx, vy, vz) <= 10 then
					setElementFrozen(v, false)
				end
			end
			local x,y,z = getElementPosition(player)
			local sx = getElementData(d.Base,"reset")
			local sy = getElementData(d.Base,"reset2")
			local de = getDistanceBetweenPoints3D(x,y,z,vx,vy,vz)
			if de < distance then
				if (getElementData(d.Base,"state") == "up") then
					moveObject(d.Base,5000,vx,vy,sx)
					setElementData(d.Base,"state","down")
				elseif (getElementData(d.Base,"state") == "down") then
					moveObject(d.Base,5000,vx,vy,sy)
					setElementData(d.Base,"state","up")
				end
			end
		end
	end
end)