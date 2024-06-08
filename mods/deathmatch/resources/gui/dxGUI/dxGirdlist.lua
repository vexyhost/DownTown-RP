local sX, sY = guiGetScreenSize()
local render = dxCreateRenderTarget ( sX, sY, true)

function dxCreateGirdlist(x, y, w, h, items, selectable, postGUI)
	if x and y and w and h then
		local gird = createElement ( "dxGUI", "dxGirdlist" )
		if gird then
			local data = {}
			data.x = x
			data.y = y
			data.w = w
			data.h = h
			data.items = items or {}
			data.active = 0
			data.hover = false
			data.cache = 0
			data.cacheN = 0
			data.Ly = 0
			data.selectable = selectable or false
			data.scrollActive = false
			data.scrollHover = false
			data.scrollSize = 2
			data.postGUI = postGUI or false
			data.draw = false
			if addComponentToDraw(gird, data, "dxGirdlist") then
				return gird
			end
		else
			outputDebugString("dxLib: Can't create the element.")
		end
	else
		outputDebugString("dxLib: Wrong arguments defined on dxGirdlist.")
	end
	return false
end

function colorRenew(color1, color2)
	--R
	if color2[1] > color1[1] then
		color1[1] = math.min( color1[1] + 5, color2[1] )
	elseif color2[1] < color1[1] then
		color1[1] = math.max( color1[1] - 5, color2[1] )
	end
	--G
	if color2[2] > color1[2] then
		color1[2] = math.min( color1[2] + 5, color2[2] )
	elseif color2[2] < color1[2] then
		color1[2] = math.max( color1[2] - 5, color2[2] )
	end
	--B
	if color2[3] > color1[3] then
		color1[3] = math.min( color1[3] + 5, color2[3] )
	elseif color2[3] < color1[3] then
		color1[3] = math.max( color1[3] - 5, color2[3] )
	end
	
	return color1
end

function dxDrawGirdlist(data)
	data.Ly = 0
	local maxScroll = #data.items*25 - data.h
	--dxDrawImageSection ( data.x, data.y, data.w, data.h, 200, 0, 352, 205, "images/template.png" )
		for i, k in ipairs(data.items) do
			dxSetRenderTarget( render )
				if data.selectable then
					local hover = false
					if isCursorHover(data.x, data.y, data.w, data.h) then
						hover = isCursorHover(data.x, data.y + data.Ly - (data.cacheN*maxScroll), data.w, 25)
					end
					if hover then
						data.items[i].color = colorRenew(k.color, {192, 216, 74})
						data.items[i].color2 = colorRenew(k.color2, {0, 0, 0})
						data.hover = true
					else
						if i ~= data.active then
							data.items[i].color = colorRenew(k.color, {17, 17, 17})
							data.items[i].color2 = colorRenew(k.color2, {255, 255, 255})
							data.hover = false
						else
							data.items[i].color = colorRenew(k.color, {192, 216, 74})
							data.items[i].color2 = colorRenew(k.color2, {0, 0, 0})
						end
					end
					if getKeyState("mouse1") and data.hover then
						data.hover = false
						data.active = i
					end
				end
				dxDrawRectangle(0, (data.Ly - (data.cacheN*maxScroll)), data.w, 25, tocolor(k.color[1], k.color[2], k.color[3], 255))
				dxDrawText( k[1] or "", 0, (data.Ly - (data.cacheN*maxScroll)), data.w, 25 + (data.Ly - (data.cacheN*maxScroll)), tocolor(k.color2[1], k.color2[2], k.color2[3],255), 0.5, getMainFont(), alignX, "center", true, falseI )
				data.Ly = data.Ly + 25
			dxSetRenderTarget()
		end
		if data.cache*maxScroll > data.cacheN*maxScroll then
			data.cacheN = math.min( data.cacheN*maxScroll + 5, (data.cache*maxScroll) )/maxScroll
			outputDebugString(data.cacheN)
		elseif data.cache*maxScroll < data.cacheN*maxScroll then
			data.cacheN = math.max( data.cacheN*maxScroll - 5, (data.cache*maxScroll) )/maxScroll
		end
		dxDrawRectangle(data.x, data.y, data.w, data.h, tocolor(204, 204, 204, 255), data.postGUI)
		if data.Ly < data.h then
			dxDrawImageSection ( data.x, data.y, data.w, data.Ly, 0, 0, data.w, data.Ly, render, 0, 0, 0, tocolor(255, 255, 255, 255), data.postGUI )
			data.scrollbar = false
		elseif data.Ly > data.h then
			dxDrawImageSection ( data.x, data.y, data.w, data.h, 0, 0, data.w, data.h, render, 0, 0, 0, tocolor(255, 255, 255, 255), data.postGUI )
			data.scrollbar = true
		end
		if #data.items*25 > data.h then
			--Scrollbar defined
			local scrollSize = (data.h/data.Ly)*data.h
			
			if data.scrollActive and getKeyState("mouse1") then
				local x,y = getCursorPosition()
				local y = y*sY
				data.cacheN = (y-data.y-data.scrollActive)/(data.h-scrollSize)
				data.cache = (y-data.y-data.scrollActive)/(data.h-scrollSize)
				if data.cache > 1 then
					data.cache = 1
				elseif data.cache < 0 then
					data.cache = 0
				end
				
				if data.cacheN > 1 then
					data.cacheN = 1
				elseif data.cacheN < 0 then
					data.cacheN = 0
				end
			else
				data.scrollActive = false
			end
			local scrollPosition = (data.h-scrollSize)*data.cacheN
			if isCursorHover(data.x + data.w + 1, data.y+scrollPosition, 10, scrollSize) then
				barAlpha = 200
				local x,y = getCursorPosition()
				data.scrollActive = (y*sY)-data.y-scrollPosition
			end
			
			if isCursorHover(data.x + data.w, data.y, 12, data.h) or data.scrollActive then
				if data.scrollSize < 10 then
					data.scrollSize = data.scrollSize + 1
				end
			else
				if data.scrollSize > 2 then
					data.scrollSize = data.scrollSize - 1
				end
			end
			--Background
			dxDrawRectangle(data.x + data.w, data.y, data.scrollSize + 2, data.h, tocolor(255, 255, 255, 255), data.postGUI)
			--Scrollbar
			dxDrawRectangle(data.x + data.w + 1, data.y+scrollPosition, data.scrollSize, scrollSize, tocolor(0, 0, 0, 255), data.postGUI)
		end
	return data
end