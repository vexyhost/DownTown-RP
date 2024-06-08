local rbWindow, rbList, bUse, bClose, tempObject, tempObjectID, tempObjectRot = nil
local tempObjectPosX, tempObjectPosY, tempObjectPosZ, tempObjectPosRot = nil

local roadblockID =     {   "978",          "3578",             "1422",             "1434",         "1459",     "1423",         "1228",         "1424",         "1282",         "1425",         "3091",         "1238", "1437"} -- objectid
local roadblockTypes =  {   "Barrera desvio","Barrera amarilla","Barrera pequeña x2","Barrera pequeña","Valla","Valla con luz","Valla pequeña","Valla metalica","Advertencia","Desvio pequeño","Desvio grande","Cono", "Escalera"} -- name
local roadblockRot =    {   "180",          "0",                "0",                "0",            "0",        "0",            "90",           "0",            "90",           "0",            "0",            "0",     "0"} -- rotation needed to face to player

--[[
local roadblockID = 	{	"978",					"981", 					"3578", 		"1228", 				"1282", 							"1422", 				"1424", 			"1425",			"1459", 			"3091"		} -- objectid
local roadblockTypes = 	{ 	"Pequena barrera", 		"Larga barrera", 		"Valla amarilla", "Valla pequena de advertencia", 	"Valla pequena de advertencia con luz", 	"Fea pequena valla", 	"Barre lateras", 	"Desvio ->", 	"Valla de advertencia", 	"Coches ->" 	} -- name
local roadblockRot = 	{	"180",					"0", 					"0",			"90",					"90",								"0",					"0",				"0",			"0",				"0"			} -- rotation needed to face to player
]]
local thePlayer = getLocalPlayer()

function enableRoadblockGUI(enable)
	if not (rbWindow) then
		local width, height = 300, 400
		local scrWidth, scrHeight = guiGetScreenSize()
		
		local x = scrWidth*0.8 - (width/2)
		local y = scrHeight*0.75 - (height/2)
	
		rbWindow = guiCreateWindow ( x, y, width, height, "Crear bloques", false)
		rbList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, rbWindow)
		addEventHandler("onClientGUIDoubleClick", rbList, selectRoadblockGUI, false)
		local column = guiGridListAddColumn(rbList, "ID", 0.2)
		local column2 = guiGridListAddColumn(rbList, "Tipo", 0.6)
		local column3 = guiGridListAddColumn(rbList, "Rotacion", 0.1)
		
		for key, value in ipairs(roadblockID) do
			local newRow = guiGridListAddRow(rbList)
			guiGridListSetItemText(rbList, newRow, column, roadblockID[key], true, false)
			guiGridListSetItemText(rbList, newRow, column2, roadblockTypes[key], false, false)
			guiGridListSetItemText(rbList, newRow, column3, roadblockRot[key], false, false)
		end

		bUse = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Usar", true, rbWindow)
		addEventHandler("onClientGUIClick", bUse, selectRoadblockGUI, false)
		
		bClose = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Cerrar", true, rbWindow)
		addEventHandler("onClientGUIClick", bClose, cancelRoadblockGUI, false)
	
		outputChatBox("Seleciona el bloqueo en el panel, ponlo en la carretera .", 0, 255, 0)
		outputChatBox("Presiona Alt izquierdo para guardar el bloqueo", 0, 255, 0)
	
		showCursor(true)
	else
		cleanupRoadblockGUI()
	end
end

function cleanupRoadblockGUI()
	cleanupRoadblock()
	destroyElement(rbWindow)
	rbWindow = nil
	showCursor(false)
end

function cleanupRoadblock()
	if (isElement(tempObject)) then
		destroyElement(tempObject)
		tempObjectPosX, tempObjectPosY, tempObjectPosZ, tempObjectPosRot = nil
		tempObjectID, tempObjectRot = nil
		unbindKey ( "lalt", "down", convertTempToRealObject)
	end
	removeEventHandler("onClientPreRender",getRootElement(),updateRoadblockObject)
end

function selectRoadblockGUI(button, state)
	if (source==bUse) and (button=="left") or (source==rbList) and (button=="left") then
		local row, col = guiGridListGetSelectedItem(rbList)
		
		if (row==-1) or (col==-1) then
			outputChatBox("Porfavor seleciona el tipo primero", 255, 0, 0)
		else
			if (isElement(tempObject)) then
				destroyElement(tempObject)
			end
			
			local objectid = tonumber(guiGridListGetItemText(rbList, guiGridListGetSelectedItem(rbList), 1))
			local objectrot = tonumber(guiGridListGetItemText(rbList, guiGridListGetSelectedItem(rbList), 3))
			spawnTempObject(objectid, objectrot)
			showCursor(false)
		end
	end
end

function spawnTempObject(objectid, objectrot)
	-- create temporary object
	tempObjectID = objectid
	tempObjectRot = objectrot
	tempObject = createObject( objectid, 0, 0, 0, 0, 0, 0)
	setElementAlpha(tempObject, 150)
	setElementInterior ( tempObject, getElementInterior ( thePlayer ) )
	setElementDimension ( tempObject, getElementDimension ( thePlayer ) )

	bindKey ( "lalt", "down", convertTempToRealObject)
	updateRoadblockObject()
	addEventHandler("onClientPreRender",getRootElement(),updateRoadblockObject)
end

function convertTempToRealObject(key, keyState)
	if (isElement(tempObject)) then
		triggerServerEvent("roadblockCreateWorldObject", thePlayer, tempObjectID, tempObjectPosX, tempObjectPosY, tempObjectPosZ, tempObjectPosRot)
		cleanupRoadblock()
		showCursor(true)
	end
end
         
function updateRoadblockObject(key, keyState)
	if (isElement(tempObject)) then
		local distance = 3
		local px, py, pz = getElementPosition ( thePlayer )
		local rz = getPedRotation ( thePlayer )    

		local x = distance*math.cos((rz+90)*math.pi/180)
		local y = distance*math.sin((rz+90)*math.pi/180)
		local b2 = 15 / math.cos(math.pi/180)
		local nx = px + x
		local ny = py + y
		local nz = pz - 0.5

		local objrot =  rz + tempObjectRot
		if (objrot > 360) then
			objrot = objrot-360
		end
		if tempObjectID == 1437 then
			setElementRotation ( tempObject, -25, 0, objrot )
		else
			setElementRotation ( tempObject, 0, 0, objrot )
		end
		moveObject ( tempObject, 10, nx, ny, nz)
		
		tempObjectPosX = nx
		tempObjectPosY = ny
		tempObjectPosZ = nz
		tempObjectPosRot = objrot
	end
end

function cancelRoadblockGUI(button, state)
	if (source==bClose) and (button=="left") then
		cleanupRoadblockGUI()
	end
end

addEvent( "enableRoadblockGUI", true )
addEventHandler( "enableRoadblockGUI", getRootElement(), enableRoadblockGUI )


function setBreakeable()
	setObjectBreakable(source, false)
	setElementFrozen(source, true)
	setElementCollisionsEnabled(source, true)
end

addEvent( "onSetBreakable", true )
addEventHandler( "onSetBreakable", getRootElement(), setBreakeable )