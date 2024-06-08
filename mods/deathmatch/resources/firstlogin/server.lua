tx1 = "Bienvenid@ a DownTown RolePlay" --- the text up
tx2 = "Estamos preparando todo para jugar" --- the text in medium
tx3 = "Mientras, visita foro.dt-mta.com" --- the text under

dis = textCreateDisplay()
sx1 = textCreateTextItem(tx1, 0.1, 0.15, "medium", 0, 0, 0, 255, 3, "left", "top", 127)
textDisplayAddText(dis,sx1)

dis1 = textCreateDisplay()
sx2 = textCreateTextItem(tx2, 0.2, 0.35, "medium", 0, 0, 0, 255, 3, "left", "top", 127)
textDisplayAddText(dis1,sx2)

dis2 = textCreateDisplay()
sx3 = textCreateTextItem(tx3, 0.3, 0.55, "medium", 0, 0, 0, 255, 3, "left", "top", 127)
textDisplayAddText(dis2,sx3)

red = false
green = false
blue = false
setTimer(
	function ()
		local r, g, b = textItemGetColor(sx1)
		if r == 255 or red == true then
			if g == 255 or green == true then
				if b == 255 or blue == true then
					blue = true
					if b == 5 then
						red = false
						green = false
						blue = false
					end
					textItemSetColor(sx1, r+5, 0, b-5, 255)
					textItemSetColor(sx2, r+5, 0, b-5, 255)
					textItemSetColor(sx3, r+5, 0, b-5, 255)
				else
					green = true
					textItemSetColor(sx1, 0, g-5, b+5, 255)
					textItemSetColor(sx2, 0, g-5, b+5, 255)
					textItemSetColor(sx3, 0, g-5, b+5, 255)
				end
			else
				red = true
				textItemSetColor(sx1, r-5, g+5, 0, 255)
				textItemSetColor(sx2, r-5, g+5, 0, 255)
				textItemSetColor(sx3, r-5, g+5, 0, 255)
			end
		else
			textItemSetColor(sx1, r+5, 0, 0, 255)
			textItemSetColor(sx2, r+5, 0, 0, 255)
			textItemSetColor(sx3, r+5, 0, 0, 255)
		end
	end
, 200, 0)


addEventHandler("onResourceStart",resourceRoot,
    function ()
        for i,p in ipairs(getElementsByType("player")) do
			if not exports.players:isLoggedIn(p) then
				setPlayerHudComponentVisible(p, "radar", false)
				textDisplayAddObserver(dis,p)
				textDisplayAddObserver(dis1,p)
				textDisplayAddObserver(dis2,p)
			end
		end
    end
)


addEventHandler("onPlayerJoin",root,
    function ()  
		textDisplayAddObserver(dis,source)
        textDisplayAddObserver(dis1,source)
        textDisplayAddObserver(dis2,source)
		setPlayerHudComponentVisible(source, "radar", false)
		showChat(source, false)
		fadeCamera(source, true, 5)
		setElementInterior(source,0)
		setElementDimension(source,0)
		setCameraMatrix( source, 2638.927734375, -23.5126953125, 82.543014526367, 2546.4130859375, 14.1376953125, 77.696334838867, 0, 70)
		--setCameraMatrix( source, 1570.5653076172, -1786.5192871094, 205.96751403809, 1648.2738037109, -1730.7985839844, 176.69990539551, 0, 70)
	end
)
 
addEvent("removeText",true)
addEventHandler("removeText",root,
    function ()
        textDisplayRemoveObserver(dis,source)
        textDisplayRemoveObserver(dis1,source)
        textDisplayRemoveObserver(dis2,source)
    end
)