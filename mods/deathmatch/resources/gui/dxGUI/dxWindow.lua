local sX, sY = guiGetScreenSize()

function dxCreateWindow(x, y, w, h, title, postGUI)
	if x and y and w and h then
		local window = createElement ( "dxGUI", "dxWindow" )
		if window then
			local data = {}
			data.x = x
			data.y = y
			data.w = w
			data.h = h
			data.post = postGUI
			data.title = title or ""
			data.draw = false
			if addComponentToDraw(window, data, "dxWindow") then
				return window
			end
		else
			outputDebugString("dxLib: Can't create the element.")
		end
	else
		outputDebugString("dxLib: Wrong arguments defined on dxWindow.")
	end
	return false
end


function dxDrawWindow(x, y, w, h, title, postGUI)
	if h > 123 then
		dxDrawRectangle ( x, y-16, w, 24, tocolor(46, 50, 56, 255), postGUI )
		local count = math.ceil((h-16)/50)
		for i = 1, count do
			dxDrawImageSection ( x, y-42+ (i*50), w, 50, 0, 145, 395, 50, "images/template.png", 0, 0, 0, tocolor(255, 255, 255, 255), postGUI )
		end
	else
		dxDrawImageSection ( x, y, w, h, 0, 129, 395, 123, "images/template.png", 0, 0, 0, tocolor(255,255,255,255), postGUI )
	end
	dxDrawText( title or "", x, y - 4, w + x, y - 4, tocolor(255,255,255,255), 0.5, getMainFont(), "center", "center", false, false, postGUI )
end