function dxDrawEmptyRectangle(startX, startY, endX, endY, color, width, postGUI)
	dxDrawRectangle(startX-width,startY-width,endX+width,width,color,postGUI) -- top
	dxDrawRectangle(startX-width,startY+endY,endX+width,width,color,postGUI) -- bottom
	dxDrawRectangle(startX-width,startY,width,endY,color,postGUI) -- left
	dxDrawRectangle(startX+endX,startY-width,width,endY+width+width,color,postGUI) -- right
end

function dxDrawText2(t,x,y,w,h,...)
	return dxDrawText(t,x,y,x+w,y+h,...)
end

function isMouseInPosition ( x, y, width, height )
    if ( not isCursorShowing ( ) ) then
        return false
    end
 
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end

local function getn(table)
	local a7 = 0
	for k,v in pairs(table) do
		a7 = a7+1
	end
	return a7
end


----- ALw7sH dxlib 1.0.0
--- dx button

local button = {
data = {}
}

function dxCreateButton(x,y,w,h,text,color,textSize,postGUI)
	local theButton = createElement("dxButton")
	if getn(button.data) < 1 then
		addEventHandler("onClientClick",root,buttonClick)
	end
	button.data[theButton] = {x=x,y=y,w=w,h=h,text=text,color=color,textSize=textSize,postGUI=postGUI or false,alpha=0,hover=false,enabled=true}
	return theButton
end

function dxDrawButton(Button)
	if isElement(Button) and getElementType(Button) == "dxButton" then
		local d = button.data[Button]
		
		if isMouseInPosition(d.x,d.y,d.w,d.h) and d.enabled then
			button.data[Button].hover = true
		else
			button.data[Button].hover = false
		end
		dxDrawRectangle(d.x,d.y,d.w,d.h,d.color,d.postGUI)
		dxDrawText(d.text,d.x,d.y,d.x+d.w,d.y+d.h,tocolor(255,255,255,255),d.textSize or 2,"default-bold","center","center",true,false,d.postGUI)
	end
end

function dxSetButtonEnabled(Button,bool)
	if isElement(Button) and getElementType(Button) == "dxButton" then
		button.data[Button].enabled = bool
	end
end

function dxDestroyButton(Button)
	if isElement(Button) and getElementType(Button) == "dxButton" then
		button.data[Button] = nil
		destroyElement(button)
	end
end


function buttonClick(bttn,state)
	if bttn == "left" and state == "down" then
		local buttons = getElementsByType("dxButton")
		if #buttons > 0 then
			for i=1,#buttons do
				if button.data[buttons[i]] then
					local hover = button.data[buttons[i]].hover
					if hover == true then
						triggerEvent("onClientdxButtonClick",buttons[i],localPlayer)
						button.data[buttons[i]].hover = false
						break
					end
				end
			end
		end
	end
end

--- edit

local edit = {
data = {}
}

function dxCreateEdit(x,y,w,h,textSize,defaulttext,icon,maxlength,mask,postGUI)
	local theEdit = createElement("dxEdit")
	if getn(edit.data) < 1 then
		addEventHandler("onClientCharacter", getRootElement(), addCharacterToEdit)
		addEventHandler("onClientKey", root, backspace)
	end
	edit.data[theEdit] = {x=x,y=y,w=w,h=h,textSize=textSize,dt=defaulttext,icon=icon,ml=maxlength,mask=mask or false,postGUI=postGUI or false, text="",hover=false,clicked=false,selectAll=false,enabled=true}
	return theEdit
end

function dxDrawEdit(Edit)
	if isElement(Edit) and getElementType(Edit) == "dxEdit" then
		local d = edit.data[Edit]
		d.text = tostring(d.text)
		local text = (d.clicked and (d.mask and string.rep("*",#d.text) or d.text)) or (string.len(d.text) > 0 and (d.mask and string.rep("*",#d.text) or d.text)) or (d.dt ~= nil and d.dt or d.text)
		
		if getKeyState("mouse1") then
			if isMouseInPosition ( d.x, d.y, d.w, d.h ) and d.enabled then
				if not d.clicked then
					edit.data[Edit].clicked = true
					guiSetInputEnabled(true)
				end
			else
				if d.clicked then
					edit.data[Edit].clicked = false
					guiSetInputEnabled(false)
				end
			end
		end
		if d.clicked then if not guiGetInputEnabled() then guiSetInputEnabled(true) end end
		
		dxDrawRectangle(d.x,d.y,d.w,d.h,tocolor(231,231,239,255),d.postGUI)
		
		local tX = type(d.icon) == "string" and d.x+d.h+(d.h/3) or d.x+(d.h/3)
		local tXx = d.x+d.h-((d.h/2)*3)
		dxDrawText(text,tX,d.y,(tXx)+d.w,d.y+d.h,tocolor(0,0,0,255),d.textSize or 1,"default-bold","left","center",true,false,d.postGUI)
		if d.selectAll then
			local tW = dxGetTextWidth(text,d.textSize or 1,"default-bold")
			local tH = dxGetFontHeight(d.textSize or 1,"default-bold")
			dxDrawRectangle(tX,d.y+(tH/2),tW,tH,tocolor(63,63,63,100),d.postGUI)
		end
	end
end
guiSetInputEnabled(false)

function dxDestroyEdit(Edit)
	if isElement(Edit) and getElementType(Edit) == "dxEdit" then
		edit.data[Edit] = nil
		destroyElement(Edit)
	end
end

function dxSetEditEnabled(Edit,en)
	if isElement(Edit) and getElementType(Edit) == "dxEdit" then
		edit.data[Edit].enabled = en
	end
end

function dxSetEditMask(Edit,m)
	if isElement(Edit) and getElementType(Edit) == "dxEdit" then
		edit.data[Edit].mask = m
	end
end

function dxSetEditText(Edit,text)
	if isElement(Edit) and getElementType(Edit) == "dxEdit" then
		edit.data[Edit].text = text
	end
end

function dxGetEditText(Edit)
	if isElement(Edit) and getElementType(Edit) == "dxEdit" then
		return edit.data[Edit].text
	end            
end                                                                                      

function addCharacterToEdit(character)
	--if character == " " then return end
	if string.byte(character) < 32 or string.byte(character) > 127 then return end
	local Edit = getElementsByType("dxEdit")
	for i=1,#Edit do	
		if edit.data[Edit[i]] then
			if edit.data[Edit[i]].clicked == true then
				if edit.data[Edit[i]].selectAll == true then
					edit.data[Edit[i]].selectAll = false
					edit.data[Edit[i]].text = ""
				end
				if edit.data[Edit[i]].ml ~= nil then
					if #edit.data[Edit[i]].text < edit.data[Edit[i]].ml then
					edit.data[Edit[i]].text = edit.data[Edit[i]].text..character
					end
				else
					edit.data[Edit[i]].text = edit.data[Edit[i]].text..character
				end
			end
		end
	end
end

function backspace(key,sm)
	if sm then
		local Edit = getElementsByType("dxEdit")
		for i=1,#Edit do	
			if edit.data[Edit[i]] then
				if edit.data[Edit[i]].clicked == true then
					if string.len(edit.data[Edit[i]].text) > 0 and key == "backspace" then
						if edit.data[Edit[i]].selectAll == false then
							edit.data[Edit[i]].text = string.sub(edit.data[Edit[i]].text,1,string.len(edit.data[Edit[i]].text)-1)
						else
							edit.data[Edit[i]].selectAll = false
							edit.data[Edit[i]].text = ""
						end
					elseif getKeyState("lctrl") and key == "a" or getKeyState("rctrl") and key == "a" then
						edit.data[Edit[i]].selectAll = not edit.data[Edit[i]].selectAll
					end
				end
			end
		end
	end
end