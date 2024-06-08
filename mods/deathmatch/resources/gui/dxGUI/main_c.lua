local sX, sY = guiGetScreenSize()
local font = dxCreateFont("dxGUI/fonts/main.ttf", (16/1366*sX + 16/768*sY) / 2)

function getMainFont()
	return font
end

function isCursorHover(posX,posY,sizeX,sizeY)
	if posX and posY and sizeX and sizeY then
		if isCursorShowing() then
			local x,y = getCursorPosition()
			local x,y = x*sX,y*sY
			if x>=posX and x<=posX+sizeX and y>=posY and y<=posY+sizeY then
				return true
			end
		else
			return false
		end
	else
		return false
	end
end

function shodow(x, y, w, h, draw, color)
	--Sombra Superior.
	if draw[1] == 1 then 
		dxDrawRectangle ( x, y, w, 1, tocolor(color[1], color[2], color[3], 125) )
	end
	--Sombra Izquierda.
	if draw[2] == 1 then 
		dxDrawRectangle ( x, y, 1, h, tocolor(color[1], color[2], color[3], 125) )
	end
	--Sombra Derecha.
	if draw[3] == 1 then 
		dxDrawRectangle ( x + w - 1, y, 1, h, tocolor(color[1], color[2], color[3], 125) )
	end
	--Sombra Inferior.
	if draw[4] == 1 then 
		dxDrawRectangle ( x, y + h, w, 1, tocolor(color[1], color[2], color[3], 125) )
	end
end