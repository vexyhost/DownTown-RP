local sX, sY = guiGetScreenSize()
--Eventos 
addEvent("ondxClientClick",true)


local event = false
local windows = {dxWindow = {}, dxButton = {}, dxEdit = {}, dxGirdlist = {}, dxCheckBox = {}}

function drawCompontentes()
	for i, k in ipairs(getElementsByType("dxGUI")) do
		local ID = getElementID ( k )
		local data = windows[ID][k]
		if ID == "dxWindow" then
			if isCursorHover(data.x, data.y-34, data.w, 34) and getKeyState("mouse1") then
				local cx, cy = getCursorPosition ()
				local cx = cx*sX - (cx*sX - data.x)
				local cy = cy*sY - (cy*sY - data.y)
				data.x = cx
				data.y = cy
			end
			dxDrawWindow(data.x, data.y, data.w, data.h, data.title, data.post)
		elseif getElementID ( k ) == "dxButton" then
			
			local pos = data.parent and {(windows.dxWindow[data.parent].x + data.x), (windows.dxWindow[data.parent].y + data.y)} or {data.x, data.y}
			local x, y = pos[1], pos[2]
			local c = isCursorHover(x, y, data.w, data.h) and true or false
			if c then
				data.hover = true
			else
				data.hover = false
			end
			local c = c and (getKeyState("mouse1") and "click" or "hover") or "normal"
			dxDrawButton(x, y, data.w, data.h, data.text, c, data.post)
		elseif getElementID ( k ) == "dxEdit" then
			if data.active == false then
				dxDrawEdit(data.x, data.y, data.w, data.h, (data.masked and string.rep("* ",string.len(data.text)) or data.text), data.empty, data.img, data.post)
			else
				dxDrawEdit(data.x, data.y, data.w, data.h, (data.masked and string.rep("* ",string.len(data.text)) or data.text), false, data.img, data.post)
			end
			if getKeyState("mouse1") then
				if isCursorHover(data.x, data.y, data.img and data.w - data.h or data.w, data.h) then
					data.active = true
				else
					data.active = false
				end
			end
			if data.tick > 0 and getKeyState("backspace") then
				if data.bfase == 0 and (getTickCount() - data.tick > 500) then
					data.text = string.sub(data.text,1,string.len(data.text)-1)
					data.tick = getTickCount()
					data.bfase = 1
				elseif data.bfase == 1 and (getTickCount() - data.tick > 50) then
					data.text = string.sub(data.text,1,string.len(data.text)-1)
					data.tick = getTickCount()			
				end
			end
			if data.active then
				local textEnd = (dxGetTextWidth ( (data.masked and string.rep("* ",string.len(data.text)) or data.text), 0.7, getMainFont() ) + 3) > (data.img and data.w - data.h or data.w) and (data.img and data.w - data.h or data.w) or dxGetTextWidth ( (data.masked and string.rep("* ",string.len(data.text)) or data.text), 0.7, getMainFont() ) + 3
				dxDrawLine((data.img and data.x + data.h or data.x) + textEnd, data.y + 1, (data.img and data.x + data.h or data.x) + textEnd, data.y + data.h,tocolor(0,0,0,255),1, data.post)
			end
		elseif getElementID ( k ) == "dxGirdlist" then
			if #data.items > 0 then
				if type(data.items[1]) ~= "table" then
					data[items] = prepareTableColor(data)
				end
				data = dxDrawGirdlist(data)
			end
		elseif getElementID ( k ) == "dxCheckBox" then
			local pos = data.parent and {(windows.dxWindow[data.parent].x + data.x), (windows.dxWindow[data.parent].y + data.y)} or {data.x, data.y}
			local x, y = pos[1], pos[2]
			local c = isCursorHover(x, y, data.w, data.h) and true or false
			if c then
				data.hover = true
			else
				data.hover = false
			end
			dxDrawCheckBox(x, y, data.w, data.h, data.text, data.active, data.post)
		end
		data.draw = false
		windows[ID][k] = data
	end
end

function prepareTableColor(data)
	for i, k in ipairs(data) do
		data[i] = {k, color = {204, 204, 204}, color2 = {255, 255, 255}}
	end
	return data
end

function dxClientClick(button, state)
	for i,k in pairs(windows.dxButton) do
		local data = k
		if data.hover then
			data.hover = false
			windows.dxButton[i] = data
			triggerEvent("ondxClientClick", i, button, state)
		end
	end
	for i,k in pairs(windows.dxCheckBox) do
		local data = k
		if data.hover and state == "down" then
			data.hover = false
			data.active = not data.active
			windows.dxCheckBox[i] = data
		end
	end
end

function addComponentToDraw(element, data, type)
	windows[type][element] = data
	if not event then
		addEventHandler("onClientRender", root, drawCompontentes)
		addEventHandler("onClientCharacter", getRootElement(), updateEdits)
		addEventHandler("onClientClick",getRootElement(), dxClientClick)
		event = true
	end
	return true
end

 
function dxDestroyed()
	if getElementType(source) == "dxGUI" then
		local ID = getElementID ( source )
		windows[ID][source] = nil
		if #getElementsByType("dxGUI") - 1 <= 0 then
			removeEventHandler("onClientRender", root, drawCompontentes)
			removeEventHandler("onClientCharacter", getRootElement(), updateEdits)
			removeEventHandler("onClientClick",getRootElement(), dxClientClick)
			event = false
		end
	end
end
addEventHandler("onClientElementDestroy", root, dxDestroyed)

function updateEdits(character)
	for i,k in pairs(windows.dxEdit) do
		local data = k
		if data.active then
			data.text = data.text..""..character
			windows.dxEdit[i] = data
		end
	end
end

function updateEditsKey(button, press)
    if button == "backspace" then
        for i,k in pairs(windows.dxEdit) do
			local data = k
			if data.active then
				if press then
					data.text = string.sub(data.text,1,string.len(data.text)-1)
					data.tick = getTickCount()
					data.bfase = 0
					windows.dxEdit[i] = data
				else
					data.tick = 0
					data.bfase = 0
					windows.dxEdit[i] = data
				end
			end
		end
    end
end
addEventHandler("onClientKey", root, updateEditsKey)


function scrollup()
	for i,k in pairs(windows.dxGirdlist) do
		local data = k
		if isCursorHover(data.x, data.y, data.w, data.h) then
			if #data.items*25 > data.h then
				local scrollSize = #data.items*25 - data.h
				local perScroll = math.ceil(data.h/25)
				data.cache = math.max(data.cache-((perScroll/scrollSize)*3),0)
				windows.dxGirdlist[i] = data
			end
		end
	end
end
bindKey( "num_8", "down", scrollup)
bindKey( "mouse_wheel_up", "down", scrollup)
 

function scrolldown()
	for i,k in pairs(windows.dxGirdlist) do
		local data = k
		if isCursorHover(data.x, data.y, data.w, data.h) then
			if #data.items*25 > data.h then
				--data.cache = math.min( data.cache + 20, #data.items*25 - data.h )
				local scrollSize = #data.items*25 - data.h
				local perScroll = math.ceil(data.h/25)
				data.cache = math.min(data.cache+((perScroll/scrollSize)*3),1)
				windows.dxGirdlist[i] = data
			end
		end
	end
end
bindKey( "num_2", "down", scrolldown)
bindKey( "mouse_wheel_down", "down", scrolldown)

function getDXPosition(element)
	if getElementType(element) == "dxGUI" then
		local ID = getElementID ( element )
		return windows[ID][element].x, windows[ID][element].y
	end
	return false
end

function setDXPosition(element, x, y)
	if getElementType(element) == "dxGUI" then
		local ID = getElementID ( element )
		windows[ID][element].x = x
		windows[ID][element].y = y
		return true
	end
	return false
end

function getEditText(element)
	if getElementType(element) == "dxGUI" then
		local ID = getElementID ( element )
		return windows[ID][element].text
	end
	return false
end

function setEditText(element, t)
	if getElementType(element) == "dxGUI" then
		local ID = getElementID ( element )
		windows[ID][element].text = t
		return true
	end
	return false
end

function setEditMasked(element, s)
	if getElementType(element) == "dxGUI" then
		local ID = getElementID ( element )
		windows[ID][element].masked = s
		return true
	end
	return false
end

function getCheckBoxState(element)
	if getElementType(element) == "dxGUI" then
		local ID = getElementID ( element )
		return windows.dxCheckBox[element].active and 1 or 0
	end
	return false
end

function setCheckBoxState(element, s)
	if getElementType(element) == "dxGUI" then
		local ID = getElementID ( element )
		windows[ID][element].active = s
		return true
	end
	return false
end

function crearAll()
	for i, k in ipairs(getElementsByType("dxGUI")) do
		destroyElement(k)
	end
end

function updateGirdlist(element, newList)
	if getElementType(element) == "dxGUI" then
		local ID = getElementID ( element )
		local newList = fromJSON(newList)
		if type(newList[1]) ~= "table" then
			newList = prepareTableColor(newList)
		end
		windows[ID][element].items = newList
		return true
	end
	return false
end