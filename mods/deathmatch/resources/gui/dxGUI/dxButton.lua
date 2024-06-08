local sX, sY = guiGetScreenSize()

function dxCreateButton(x, y, w, h, text, parent, postGUI)
	if x and y and w and h then
		local button = createElement ( "dxGUI", "dxButton" )
		if button then
			local data = {}
			data.x = x
			data.y = y
			data.w = w
			data.h = h
			data.text = text or ""
			data.hover = false
			data.post = postGUI
			data.parent = parent or false
			data.draw = false
			if addComponentToDraw(button, data, "dxButton") then
				return button
			end
		else
			outputDebugString("dxLib: Can't create the element.")
		end
	else
		outputDebugString("dxLib: Wrong arguments defined on dxButton.")
	end
	return false
end

function dxDrawButton(x, y, w, h, text, c, postGUI)
	if c == "normal" then
		dxDrawRectangle(x, y, w, h, tocolor(74, 80, 255), postGUI)
	elseif c == "hover" then
		dxDrawRectangle(x+3, y+3, w-6, h-6, tocolor(31, 38, 255), postGUI)
		dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0), false)
	elseif c == "click" then
		dxDrawRectangle(x, y, w, h, tocolor(74, 80, 255), postGUI)
	end
	dxDrawText( text or "", x, y, w + x, y + h, tocolor(255, 255, 255 ,255), 1, getMainFont(), "center", "center", false, true, postGUI )
end