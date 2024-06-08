local sX, sY = guiGetScreenSize()
local edits = {}

function dxCreateEdit(x, y, w, h, text, relative , empty, img, postGUI)
	if x and y and w and h then
		local edit = createElement ( "dxGUI", "dxEdit" )
		if edit then
			local data = {}
			data.x = x
			data.y = y
			data.w = w
			data.h = h
			data.text = text or ""
			data.active = false
			data.tick = 0
			data.bfase = 0
			data.hover = false
			data.masked = false
			data.empty = empty or ""
			data.post = postGUI
			data.img = img or false
			data.draw = false
			if addComponentToDraw(edit, data, "dxEdit") then
				return edit
			end
		else
			outputDebugString("dxLib: Can't create the element.")
		end
	else
		outputDebugString("dxLib: Wrong arguments defined on dxEdit.")
	end
	return false
end


function dxDrawEdit(x, y, w, h, text, empty, img, postGUI)
	local x = img and x + h or x
	local y = y
	local w = img and w - h or w
	local h = h
	shodow(x, y, w, h, {1, 1, 1, 1}, {0, 0, 0}, true)
	if dxGetTextWidth ( text, 0.7, getMainFont() ) > w then
		alignX = "right"
	else
		alignX = "left"
	end
	dxDrawText( text or "", x + 2, y, w - 2 + x, y + h, tocolor(0,0,0,255), 0.7, getMainFont(), alignX, "center", true, false, postGUI )
	
	if #text == 0 and empty then
		dxDrawText( empty, x + 2, y, w - 2 + x, y + h, tocolor(0,0,0,255), 0.7, getMainFont(), alignX, "center", true, false, postGUI )
	end
	
	if img then
		dxDrawRectangle(x - h, y, h, h, tocolor(88, 203, 142, 255), postGUI)
		dxDrawImage(x - h, y, h, h, img, 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
	end
end