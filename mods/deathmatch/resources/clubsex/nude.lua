dicks = {}

function showDick (thePlayer)
	if (not dicks[thePlayer]) then
		dicks[thePlayer] = createObject (1337, 0, 0, 0)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		setElementDimension(dicks[thePlayer], dimension)
		setElementInterior(dicks[thePlayer], interior)
		exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, -0.03, -0.05, -0.075, 360, 80, 85)
	else
		exports.bone_attach:detachElementFromBone(dicks[thePlayer])
		destroyElement (dicks[thePlayer])
		dicks[thePlayer] = nil
	end
end
addCommandHandler("pene", showDick)

function nudeMyWomanSin (thePlayer)
	nudeWomanSkin (thePlayer)
end
addCommandHandler ("nudeme", nudeMyWomanSin)


--[[local rx,ry,rz = 360, 80, 85
local x, y, z = -0.03, -0.05, -0.09

function rotateY (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	ry = ry + 5
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, rx, ry, rz)
	
end
addCommandHandler ("ry", rotateY)

function rotateY1 (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	ry = ry - 5
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, rx, ry, rz)
	
end
addCommandHandler ("ry1", rotateY1)

function RotateZ (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	rz = rz + 5
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, rx, ry, rz)
	
end
addCommandHandler ("rz", RotateZ)

function RotateZ1 (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	rz = rz - 5
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, rx, ry, rz)
	
end
addCommandHandler ("rz1", RotateZ1)

function RotateX (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	rx = rx + 5
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, rx, ry, rz)
	
end
addCommandHandler ("rx", RotateX)

function RotateX1 (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	rx = rx - 5
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, rx, ry, rz)
	
end
addCommandHandler ("rx1", RotateX1)

function moveRight (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	x = x + 0.05
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, 355, 110, 85)
	
end
addCommandHandler ("rightw", moveRight)

function moveLeft (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	x = x - 0.05
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, 355, 110, 85)
	
end
addCommandHandler ("leftw", moveLeft)

function moveForwards (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	local x,y,z = getElementPosition (dicks[thePlayer])
	y = y + 0.05
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, 355, 110, 85)
	
end
addCommandHandler ("forw", moveForwards)

function moveBackwards (thePlayer)
	exports.bone_attach:detachElementFromBone(dicks[thePlayer])
	y = y - 0.05
	exports.bone_attach:attachElementToBone(dicks[thePlayer], thePlayer, 4, x, y, z, 355, 110, 85)
	
end
addCommandHandler ("backw", moveBackwards)

function getPos (thePlayer)
	outputChatBox (" ( "..(x)..", "..(y)..", "..(z)..")", root, 0, 255, 0)
	outputChatBox (" ( "..(rx)..", "..(ry)..", "..(rz)..")", root, 0, 255, 0)
end
addCommandHandler ("geta", getPos)]]--