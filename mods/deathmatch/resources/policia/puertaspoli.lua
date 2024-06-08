-- Puertas definidas en la policia v1.
-- exports.items:has(thePlayer, 35,1)
function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end
-- 

pd1gate = createObject ( 3089, 253.1767578125, 107.607421875, 1003.5477294922, 0, 0, 90 )
setElementDimension ( pd1gate, 104 )
setElementInterior ( pd1gate, 10 )

function gatepd1c() 
	moveObject ( pd1gate, 2000, 253.1767578125, 107.607421875, 1003.5477294922 )
end
                                             
function gatepd1o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
	outputChatBox("Puerta 1 abierta.",thePlayer)   
	moveObject ( pd1gate, 2000, 253.17558288574, 106.58239746094, 1003.5477294922) 
	setTimer (gatepd1c, 3000, 1)
	end
end

addCommandHandler("pd1", gatepd1o)

pd2gate = createObject ( 3089, 253.1865234375, 110.580078125, 1003.5477294922, 0, 0, 270 )
setElementDimension ( pd2gate, 104 )
setElementInterior ( pd2gate, 10 )

function gatepd2c() 
	moveObject ( pd2gate, 2000, 253.1865234375, 110.580078125, 1003.5477294922 )
end
                                             
function gatepd2o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
	moveObject ( pd2gate, 2000, 253.19061279297, 111.58078765869, 1003.5477294922) 
	setTimer (gatepd2c, 3000, 1)
	end
end

addCommandHandler("pd1", gatepd2o)

-- 

pd3gate = createObject ( 3089, 239.625, 116.099609375, 1003.5477294922, 0, 0, 90 )
setElementDimension ( pd3gate, 104 )
setElementInterior ( pd3gate, 10 )

function gatepd3c() 
moveObject ( pd3gate, 2000, 239.625, 116.099609375, 1003.5477294922 )
end
                                             
function gatepd3o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
outputChatBox("Puerta 2 abierta.",thePlayer)   
moveObject ( pd3gate, 2000, 239.61683654785, 115.0743637085, 1003.5477294922) 
setTimer (gatepd3c, 3000, 1)
end
end

addCommandHandler("pd2", gatepd3o)

pd4gate = createObject ( 3089, 239.63491821289, 119.07646179199, 1003.5477294922, 0, 0, 270 )
setElementDimension ( pd4gate, 104 )
setElementInterior ( pd4gate, 10 )

function gatepd4c() 
moveObject ( pd4gate, 2000, 239.63491821289, 119.07646179199, 1003.5477294922 )
end
                                             
function gatepd4o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
moveObject ( pd4gate, 2000, 239.63238525391, 120.12748718262, 1003.5477294922) 
setTimer (gatepd4c, 3000, 1)
end
end

addCommandHandler("pd2", gatepd4o)

-- 

pd5gate = createObject ( 3089, 253.1669921875, 123.767578125, 1003.5477294922, 0, 0, 90 )
setElementDimension ( pd5gate, 104 )
setElementInterior ( pd5gate, 10 )

function gatepd5c() 
moveObject ( pd5gate, 2000, 253.1669921875, 123.767578125, 1003.5477294922 )
end
                                             
function gatepd5o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
outputChatBox("Puerta 3 abierta.",thePlayer)   
moveObject ( pd5gate, 2000, 253.1682434082, 122.74251556396, 1003.5477294922) 
setTimer (gatepd5c, 3000, 1)
end
end

addCommandHandler("pd3", gatepd5o)

pd6gate = createObject ( 3089, 253.17578125, 126.75, 1003.5477294922, 0, 0, 270 )
setElementDimension ( pd6gate, 104 )
setElementInterior ( pd6gate, 10 )

function gatepd6c() 
moveObject ( pd6gate, 2000, 253.17578125, 126.75, 1003.5477294922 )
end
                                             
function gatepd6o(thePlayer, command)
if exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
moveObject ( pd6gate, 2000, 253.18453979492, 127.77506256104, 1003.5477294922) 
setTimer (gatepd6c, 3000, 1)
end
end

addCommandHandler("pd3", gatepd6o)

--

pd7gate = createObject ( 3089, 239.6025390625, 123.599609375, 1003.5477294922, 0, 0, 90 )
setElementDimension ( pd7gate, 104 )
setElementInterior ( pd7gate, 10 )

function gatepd7c() 
moveObject ( pd7gate, 2000, 239.6025390625, 123.599609375, 1003.5477294922 )
end
                                             
function gatepd7o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
	outputChatBox("Puerta 4 abierta.",thePlayer)   
	moveObject ( pd7gate, 2000, 239.59878540039, 122.57454681396, 1003.5477294922) 
	setTimer (gatepd7c, 3000, 1)
	end
end

addCommandHandler("pd4", gatepd7o)

pd8gate = createObject ( 3089, 239.6123046875, 126.57421875, 1003.5477294922, 0, 0, 270 )
setElementDimension ( pd8gate, 104 )
setElementInterior ( pd8gate, 10 )

function gatepd8c() 
moveObject ( pd8gate, 2000, 239.6123046875, 126.57421875, 1003.5477294922 )
end
                                             
function gatepd8o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
		moveObject ( pd8gate, 2000, 239.62919616699, 127.59896850586, 1003.5477294922) 
		setTimer (gatepd8c, 3000, 1)
	end
end

addCommandHandler("pd4", gatepd8o)

--

pd10gate = createObject ( 969, 211.8448638916, 116.53050994873, 997.36499023438 )
setElementDimension ( pd10gate, 104 )
setElementInterior ( pd10gate, 10 )

function gatepd10c() 
moveObject ( pd10gate, 2000, 211.8448638916, 116.53050994873, 997.36499023438 )
end
                                             
function gatepd10o(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then
		outputChatBox("Puerta de las celdas abierta.",thePlayer)   
		moveObject ( pd10gate, 2000, 211.8448638916, 116.53050994873, 993.0107421875 ) 
		setTimer (gatepd10c, 3000, 1)
	end
end

addCommandHandler("pdc", gatepd10o)


pdjailgate1 = createObject ( 976, 227.71434020996, 133.72973632813, 1002.0435791016, 0, 0, 270 )
setElementDimension ( pdjailgate1, 104 )
setElementInterior ( pdjailgate1, 10, 227.71434020996, 133.72973632813, 1002.0435791016 )

	
function pdgatejailc() 
	moveObject ( pdjailgate1, 3000, 227.71434020996, 133.72973632813, 1002.0435791016 )
end
                                             
function pdgatejailo(thePlayer, command)
	if exports.factions:isPlayerInFaction( thePlayer, 1 ) then  
		moveObject ( pdjailgate1, 3000, 227.71434020996, 135.63565063477, 1002.0435791016) 
		setTimer (pdgatejailc, 5000, 1)
	end
end

addCommandHandler("pdj", pdgatejailo)
