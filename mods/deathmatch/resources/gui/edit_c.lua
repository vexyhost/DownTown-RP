local sX,sY = guiGetScreenSize()
local v = {}

function dxCreateButton (x, y, w, h, text, relative, parent)
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
	--local color = c and {230, 230, 230} or {200, 200, 200}
	dxDrawImageSection ( x, y, w, 31, 0, 0, 210, 32, "images/template.png", 0, 0, 0, tocolor(255, 255, 255, 255), postGUI )
	--shodow(x, y, w, h, {1, 1, 1, 1}, {0, 0, 0})
	if dxGetTextWidth ( text, 0.4, getMainFont() ) > w then
		alignX = "right"
	else
		alignX = "left"
	end
	dxDrawText( text or "", x + 2, y, w - 2 + x, y + 32, tocolor(255,255,255,255), 0.4, getMainFont(), alignX, "center", true, false, postGUI )
	
	if #text == 0 and empty then
		dxDrawText( empty, x + 2, y, w - 2 + x, y + 32, tocolor(255,255,255,255), 0.4, getMainFont(), alignX, "center", true, false, postGUI )
	end
	
	if img then
		dxDrawImage(x - 35, y, 32/1366*sX, 32/768*sY, img, 0, 0, 0, tocolor(255, 255, 255, 255), postGUI)
	end
end