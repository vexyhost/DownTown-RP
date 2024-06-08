local sX, sY = guiGetScreenSize()

function dxCreateCheckBox(x, y, w, h, text, parent, postGUI)
	if x and y and w and h then
		local check = createElement ( "dxGUI", "dxCheckBox" )
		if check then
			local data = {}
			data.x = x
			data.y = y
			data.w = w
			data.h = h
			data.text = text or ""
			data.hover = false
			data.active = false
			data.post = postGUI
			data.parent = parent or false
			data.draw = false
			if addComponentToDraw(check, data, "dxCheckBox") then
				return check
			end
		else
			outputDebugString("dxLib: Can't create the element.")
		end
	else
		outputDebugString("dxLib: Wrong arguments defined on dxCheckBox.")
	end
	return false
end

function dxDrawCheckBox(x, y, w, h, text, c, postGUI)
	dxDrawRectangle(x, y, 16, 16, tocolor(88, 203, 142), postGUI)
	if c then
		dxDrawText("✗", x, y, 16 + x, y + 16, tocolor(255, 255, 255, 255), 1, getMainFont(), "center", "center", false, false, postGUI)
	end
	dxDrawText( text or "", x + 17, y, w - 17 + x, 16 + y, tocolor(88, 203, 142 ,255), 0.7, getMainFont(), "left", "center", true, true, postGUI )
end