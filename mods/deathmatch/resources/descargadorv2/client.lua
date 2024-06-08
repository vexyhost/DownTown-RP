local modGUI = {}
local downloads = {}
local downloadCount = 0
local currentSize = {}
local download2 = { current = 0, estimate = 0}

function addTab(tag)
	tag = tostring(tag)
	modGUI[tag] = guiCreateTab(tag, modGUI[2])
	modGUI[modGUI[tag]] = guiCreateGridList ( .02, .02, .96, .96, true, modGUI[tag] )
	guiGridListSetSelectionMode( modGUI[modGUI[tag]], 1 )
	guiGridListAddColumn( modGUI[modGUI[tag]], "ID", 0.15 )
	guiGridListAddColumn( modGUI[modGUI[tag]], "Nombre", 0.3 )
	guiGridListAddColumn( modGUI[modGUI[tag]], "Estado", 0.3 )
	guiGridListAddColumn( modGUI[modGUI[tag]], "Tamaño", 0.1 )
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		modGUI[1] = guiCreateWindow( .25, .1, .4, .8, "Descargador de Mods - DownTown RolePlay", true )
		guiSetVisible(modGUI[1], false)

		modGUI[2] = guiCreateTabPanel ( 0, .035, 1, .8, true, modGUI[1] )
		
		modGUI[3] = guiCreateButton( .02, .85, .2, .1, "Activar", true, modGUI[1] )
		modGUI[4] = guiCreateButton( .25, .85, .2, .1, "Desactivar", true, modGUI[1] )
		modGUI[5] = guiCreateButton( .50, .85, .2, .1, "Activar todos de esta categoría", true, modGUI[1] )
		modGUI[6] = guiCreateButton( .75, .85, .2, .1, "Desactivar todos de esta categoría", true, modGUI[1] )
		
		triggerServerEvent("requestModsData", localPlayer)
	end
)

addEvent("transferModsData", true)
addEventHandler("transferModsData", root,
	function(mods, groups)
	    for _, v in ipairs(groups) do
	        addTab( tostring(v) )
	    end
		mData = mods
		refresh()
	end
)

function refresh()
	for _, v in pairs(modGUI) do
		if getElementType(v) == "gui-gridlist" then
			guiGridListClear( v )
		end
	end
	for i, v in pairs(mData) do
		local row = guiGridListAddRow(modGUI[ modGUI[ v[3] ] ])
		guiGridListSetItemText ( modGUI[ modGUI[ v[3] ] ], row, 1, v[1], false, true )
		guiGridListSetItemText ( modGUI[ modGUI[ v[3] ] ], row, 2, i, false, false )
		guiGridListSetItemText ( modGUI[ modGUI[ v[3] ] ], row, 3, ( fileExists("mods/"..v[3].."/"..i:lower()..".txd") and fileExists("mods/"..v[3].."/"..i:lower()..".dff") ) and "Descargado" or "Pendiente Descarga", false, false )
		guiGridListSetItemText ( modGUI[ modGUI[ v[3] ] ], row, 4, sizeFormat(v[2]), false, true )
	end
end

addCommandHandler("mods", 
	function()
		-- local visible = not guiGetVisible(modGUI[1])
		-- guiSetVisible(modGUI[1], visible)
		-- showCursor(visible)
		-- refresh()
		outputChatBox("Sistema en reformas, disculpe las molestias.", 255, 0, 0)
	end
)

addEventHandler("onClientGUIClick", root,
	function()
		if source == modGUI[3] then --ACTIVAR
			local tab = guiGetSelectedTab(modGUI[2])
			local items = guiGridListGetSelectedItems(modGUI[tab])
			if #items > 0 then
				local files = {}
				local count = 0
				for _, v in ipairs(items) do
					if v.column == 2 then
						local id = guiGridListGetItemText ( modGUI[tab], v.row, 1 )
						local extension = guiGridListGetItemText ( modGUI[tab], v.row, 2 )
						addDownloadQueue(extension, id)
					end
				end
			end
		elseif source == modGUI[4] then --DESACTIVAR
			local tab = guiGetSelectedTab(modGUI[2])
			local items = guiGridListGetSelectedItems(modGUI[tab])
			if #items > 0 then
				for _, v in ipairs(items) do
					local id = guiGridListGetItemText ( modGUI[tab], v.row, 1 )
					engineRestoreModel( tonumber(id) )
				end
			end
		elseif source == modGUI[5] then --ACTIVAR TODOS
			local tab = guiGetSelectedTab(modGUI[2])
			local tag = guiGetText(tab)
			for i, v in pairs(mData) do
				if v[3] == tag then
					addDownloadQueue(i, v[1])
				end
			end
		elseif source == modGUI[6] then --DESACTIVAR TODOS
			local tab = guiGetSelectedTab(modGUI[2])
			local tag = guiGetText(tab)
			for i, v in pairs(mData) do
				if v[3] == tag then
					engineRestoreModel(v[1])
				end
			end
		end
	end
)

function addDownloadQueue(file, id)
	local f = string.lower(file)
	downloads["mods/"..mData[file][3].."/"..f..".txd"] = { id, f, mData[file][3], mData[file][2] }
	downloads["mods/"..mData[file][3].."/"..f..".dff"] = { id, f, mData[file][3], mData[file][2] }
	downloadCount = downloadCount + 2
	downloadFile( "mods/"..mData[file][3].."/"..f..".txd" )
	downloadFile( "mods/"..mData[file][3].."/"..f..".dff" ) 
end

function removeDownloadQueue(file)
	for i,v in pairs(downloads) do
		if i == file and v then
			downloads[i] = false
			break
		end
	end
	downloadCount = downloadCount - 1
end

addEventHandler("onClientFileDownloadComplete", root,
	function(filename, success)
		if success then
			local name = tostring( downloads[filename][2] )
			if filename:find(".txd") then
				local txd = engineLoadTXD( filename )
				engineImportTXD( txd, downloads[filename][1] ) --Pending
				removeDownloadQueue(name)
			elseif filename:find(".dff") then
				local dff = engineLoadDFF ( filename )
				engineReplaceModel ( dff, downloads[filename][1] ) --Pending
				removeDownloadQueue(name)
			end
			local file = fileOpen(filename)
			currentSize[filename] = fileGetSize(file)
			fileClose(file)
			refresh()
		end
	end
)

function fUpper(str)
    return tostring((str:gsub("^%l", string.upper)))
end

addEventHandler("onClientRender", root,
	function()
		if downloadCount > 0 then
			if not tick then
				tick = getTickCount()
			end
			
			local downloadSize = 0
			if getTickCount()-tick >= 1000 then
				for i, v in pairs(downloads) do
					if v then
						local f = i:gsub("mods/"..v[3].."/", "")
						f = f:gsub(".txd", "")
						f = f:gsub(".dff", "")
						local size = v[4]
						downloadSize = downloadSize + tonumber(size/2)
						--[[if fileExists(i) then
							while fileIsEOF(i) do
								local file = fileOpen(i)
								currentSize[i] = fileGetSize(file)
								fileClose(file)
								break
							end
						end]]
	                end
	            local sizeCount = 0
		        for _, s in pairs(currentSize) do
		            sizeCount = sizeCount + s
		        end
			    download2.current = sizeCount
			    download2.estimate = download2.estimate < downloadSize and downloadSize or download2.estimate
			    end
			tick = getTickCount()
    	    end
			dxDrawProgressBar(.25, .8, .5, .05, ((download2.current*100)/download2.estimate), tocolor(0, 0, 0, 200), tocolor(255, 255, 255, 150))
        else    
            if download2.estimate > 0 then
                download2.estimate = 0
                download2.current = 0
                p = 0
            end
		end
	end
)

local p = 0
local x, y = guiGetScreenSize()

function dxDrawProgressBar( startX, startY, width, height, progress )
    if progress >= 0 then 
        startX, startY, width, height = startX*x, startY*y, width*x, height*y
        p = p < progress and p+0.3 or progress
        dxDrawRectangle( startX-5, startY-5, width+10, height+10, tocolor(0, 0, 0, 100), true )
        dxDrawRectangle( startX, startY, width, height, tocolor(255, 255, 255, 100), true )
        dxDrawRectangle( startX, startY, (p*width)/100, height, tocolor(255, 255, 255, 255), true )
        dxDrawText ( sizeFormat(download2.current).. "/"..sizeFormat(download2.estimate).." | "..math.floor(p).."%", startX+width/2, startY+height/4, 0, 0, tocolor ( 0, 0, 0, 255 ), 1.02, "default-bold", _, _, _, _, true)
    end
end

function sizeFormat(size)
	local size = tostring(size)
	if size:len() >= 4 then		
		if size:len() >= 7 then
			if size:len() >= 9 then
				local returning = size:sub(1, size:len()-9)
				if returning:len() <= 1 then
					returning = returning.."."..size:sub(2, size:len()-7)
				end
				return returning.." GB";
			else				
				local returning = size:sub(1, size:len()-6)
				if returning:len() <= 1 then
					returning = returning.."."..size:sub(2, size:len()-4)
				end
				return returning.." MB";
			end
		else		
			local returning = size:sub(1, size:len()-3)
			if returning:len() <= 1 then
				returning = returning.."."..size:sub(2, size:len()-1)
			end
			return returning.." KB";
		end
	else
		return size.." B";
	end
end
