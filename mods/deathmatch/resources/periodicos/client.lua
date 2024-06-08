setElementData(getLocalPlayer(), "newspaper", false)

--NEWS STAND GUI
function standGUIFunc(text)
	if newsImg and (guiGetVisible(newsImg)) then
		showCursor(false)
		guiSetVisible(newsImg, false)
		guiSetVisible(closeButt, false)
		guiSetVisible(newsLabel, false)
	else                
		showCursor(true)
		newsLabel = guiCreateLabel(254,284,488,220,tostring(text),false)
		guiLabelSetColor(newsLabel,77,77,77)
		guiLabelSetVerticalAlign(newsLabel,"top")
		guiLabelSetHorizontalAlign(newsLabel,"left",false)
		guiSetFont(newsLabel,"clear-normal")
		closeButt = guiCreateButton(261,661,39,19,"Cerrar",false)
		newsImg = guiCreateStaticImage(144,123,728,578,"BlankPaper.png",false)
		guiMoveToBack(newsImg)
		addEventHandler("onClientGUIClick", closeButt, closeFunc, false)
		addEventHandler("onClientGUIClick", newsImg, moveToBackAgain, false)
		setElementData(getLocalPlayer(), "newspaper", true)
	end
end
addEvent("showStandGUI", true)
addEventHandler("showStandGUI", getLocalPlayer(), standGUIFunc)


function moveToBackAgain(button, state)
	if (state == "up" or "down") then
		guiMoveToBack(newsImg)
	end
end


--TRIGGERED WHEN THE PLAYER CLICKS ON THE EXIT BUTTON
function closeFunc()
	showCursor(false)
	guiSetVisible(newsImg, false)
	guiSetVisible(closeButt, false)
	guiSetVisible(newsLabel, false)
end

-------------EDITOR

function newsPaperEdit()
    if exports.factions:isPlayerInFaction(player, 4) then
	    guiSetVisible(newsWnd, false)
	    guiSetInputEnabled(false)
	    showCursor(false)
	else
	    showCursor(true)
	    guiSetInputEnabled(true)
		newsWnd = guiCreateWindow(494,144,523,496,"Redacción San Fierro News Deparment",false)
		guiWindowSetSizable(newsWnd,false)
		changeButt = guiCreateButton(13,460,157,25,"Publicar",false,newsWnd)
		closeButt = guiCreateButton(357,460,157,25,"Cerrar",false,newsWnd)

		local readTxt = fileOpen("text.txt", true)
		local messageShit = fileRead(readTxt, 10000)
		editMemo = guiCreateMemo(10,24,504,436,tostring(messageShit),false,newsWnd)
		fileClose(readTxt)

		addEventHandler("onClientGUIClick", closeButt, closeEditorWnd, false)
		addEventHandler("onClientGUIClick", changeButt, changeNewsPaper, false)
    end
end
function newsPaperEditor(player)
    if ( not isElement ( newsWnd ) ) then
        newsPaperEdit ( )
    else
        guiSetVisible ( newsWnd, not guiGetVisible ( newsWnd ) )
    end
end
addEvent("ShowEditor", true)
addEventHandler("ShowEditor", getRootElement(), newsPaperEditor)

function changeNewsPaper()
	local message = guiGetText(editMemo)
	triggerServerEvent("saveNewsText", getRootElement(), getLocalPlayer(), message)
	outputChatBox("Has actualizado los periodicos.", 0, 255, 0, false)
end

function closeEditorWnd()
	showCursor(false)
	guiSetVisible(newsWnd, false)
	guiSetInputEnabled(false)
end