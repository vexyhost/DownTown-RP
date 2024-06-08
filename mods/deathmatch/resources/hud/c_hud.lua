local active = true
local screenWidth, screenHeight = guiGetScreenSize()
local localPlayer = getLocalPlayer()
local estadohud = getElementData(localPlayer, "hud")
r,g,b=255,255,255
alpha=200
           
function drawHUD()
	if getElementData(localPlayer, "nohud") then return end
	if active and not isPlayerMapVisible() and not estadohud or estadohud == true then
		local ax, ay = screenWidth - 122, 0	
		local health = getElementHealth( localPlayer )
		if (health <= 30) then
			dxDrawImage(ax,ay,32,37,"images/hud/lowhp.png")
			ax = ax - 34
		end
		local armour = getPedArmor( localPlayer )
		if armour > 0 then
			dxDrawImage(ax,ay,32,37,"images/hud/armour.png")
			ax = ax - 34
		end
		local dutyPol = getElementData(localPlayer, "duty")
		local dutyMed = getElementData(localPlayer, "dutymedico")
		if dutyPol == true or dutyMed == true then
			dxDrawImage(ax,ay,32,37,"images/hud/badge2.png")
			ax = ax - 34
		end
        local isGM = getElementData( localPlayer,"account:gmduty")
        if isGM  then
			dxDrawImage(ax,ay,32,37,"images/hud/gm.png")
			ax = ax - 34
        end
        local isHelper = getElementData( localPlayer,"account:helpduty")
        if isHelper  then
			dxDrawImage(ax,ay,32,37,"images/hud/helper.png")
			ax = ax - 34
		end
		if getElementData( localPlayer,"Cascos") then
			dxDrawImage(ax,ay,32,37,"images/hud/helmet.png")
			ax = ax - 34
		end	
        if getElementData( localPlayer,"mascara") then
             dxDrawImage(ax,ay,32,37,"images/hud/mask.png")
			ax = ax - 34
        end
        if getElementData( localPlayer,"buzo") then
             dxDrawImage(ax,ay,32,37,"images/hud/scuba.png")
			ax = ax - 34
        end
		if getElementData( localPlayer,"programandos") then
             dxDrawImage(ax,ay,32,37,"images/hud/dev.png")
			ax = ax - 34
        end
		if getElementData(localPlayer, "player.cinturon") == true then
            dxDrawImage(ax,ay,32,37,"images/hud/cinturon.png")
			ax = ax - 34
		end
		if (getPedWeapon(localPlayer) == 24) and (getPedTotalAmmo(localPlayer) > 0) then
			local deagleMode = getElementData(localPlayer, "tazerOn")
			if deagleMode == true then
				dxDrawImage(ax,ay,32,37,"images/hud/dtazer.png")
			end
			ax = ax - 34
		end
		if getPedOccupiedVehicle(getLocalPlayer()) and getVehicleSirensOn(getPedOccupiedVehicle(getLocalPlayer())) == true then
			dxDrawImage(ax,ay,32,37,"images/hud/siren.png")
			ax = ax - 34
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), drawHUD)

function drawStates ()
    addEventHandler ( "onClientRender", root, pingAndFPSState )
end
addEventHandler ( "onClientResourceStart", resourceRoot, drawStates )
  
function pingAndFPSState()
	if getElementData(localPlayer, "nohud") then return end
	local ping = getPlayerPing(getLocalPlayer())
    posx= screenWidth-44
    posy= 20
	alpha2=255
	dxDrawRectangle ( posx, posy, 4, 4, tocolor ( r, g, b, alpha ) )
	dxDrawRectangle ( posx+5, posy-4, 4,8, tocolor ( r, g, b, alpha ) )
	dxDrawRectangle ( posx+10, posy-8, 4,12, tocolor ( r, g, b, alpha ) )
	dxDrawRectangle ( posx+15, posy-12, 4,16, tocolor ( r, g, b, alpha ) )
	dxDrawRectangle ( posx+20, posy-16, 4,20, tocolor ( r, g, b, alpha ) )
	if ping <= 80 then
		r2,g2,b2=0,255,0
		dxDrawRectangle ( posx, posy, 4, 4, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+5, posy-4, 4,8, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+10, posy-8, 4,12, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+15, posy-12, 4,16, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+20, posy-16, 4,20, tocolor ( r2, g2, b2, alpha2 ) )
	elseif ping >=81 and ping <= 150 then
		r2,g2,b2=0,204,0   
		dxDrawRectangle ( posx, posy, 4, 4, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+5, posy-4, 4,8, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+10, posy-8, 4,12, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+15, posy-12, 4,16, tocolor ( r2, g2, b2, alpha2 ) )
	elseif ping >=151 and ping <= 200 then
		r2,g2,b2=255,204,0
		dxDrawRectangle ( posx, posy, 4, 4, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+5, posy-4, 4,8, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+10, posy-8, 4,12, tocolor ( r2, g2, b2, alpha2 ) )
	elseif ping >=201 and ping <= 300 then
		r2,g2,b2=179,0,0
		dxDrawRectangle ( posx, posy, 4, 4, tocolor ( r2, g2, b2, alpha2 ) )
		dxDrawRectangle ( posx+5, posy-4, 4,8, tocolor ( r2, g2, b2, alpha2 ) )
	elseif ping >=301 then
		r2,g2,b2=255,0,0
		dxDrawRectangle ( posx, posy, 4, 4, tocolor ( r2, g2, b2, alpha2 ) )
	end
	posx2= screenWidth-68
    posy2= 13
	local fps = getElementData(getLocalPlayer(),"FPS")
	if fps then
		if fps >= 40 then
			dxDrawText ( fps, posx2-12, posy2-6, screenWidth, y, tocolor ( 0, 255, 0, 255 ), 1.4, "default-bold" )
		elseif fps >= 30 and fps <= 39 then
			dxDrawText ( fps, posx2-12, posy2-6, screenWidth, y, tocolor ( 0, 204, 0, 255 ), 1.4, "default-bold" )
		elseif fps >= 20 and fps <= 29 then
			dxDrawText ( fps, posx2-12, posy2-6, screenWidth, y, tocolor ( 255, 204, 0, 255 ), 1.4, "default-bold" )
		elseif fps < 20 then
			dxDrawText ( fps, posx2-12, posy2-6, screenWidth, y, tocolor ( 255, 0, 0, 255 ), 1.4, "default-bold" )
		end
	end
	dxDrawText ( "FPS", posx2-13, posy2+10, screenWidth, y, tocolor ( 255, 255, 255, 255 ), 1.0, "default-bold" )
	dxDrawText ( "PING", posx2+23, posy2+10, screenWidth, y, tocolor ( 255, 255, 255, 255 ), 1.0, "default-bold" )
end
      
addCommandHandler( "hud",
	function( )
		active = not active
		if active then
			outputChatBox( "(( Has activado las opciones visuales ))", 0, 255, 0 )
			setElementData(localPlayer, "hud", true)
			setElementData(localPlayer, "nohud", false)
			setPlayerHudComponentVisible("ammo", true)
			setPlayerHudComponentVisible("armour", true)
			setPlayerHudComponentVisible("breath", true)
			if getElementData(localPlayer,"tieneReloj") then
			setPlayerHudComponentVisible("clock", true)
			end
			setPlayerHudComponentVisible("health", true)
			setPlayerHudComponentVisible("money", true)
			setPlayerHudComponentVisible("radar", true)
			setPlayerHudComponentVisible("vehicle_name", true)
			setPlayerHudComponentVisible("weapon", true)   
			setPlayerHudComponentVisible("radio", true)
			setPlayerHudComponentVisible("wanted", true)
		else
			outputChatBox( "(( Has desactivado las opciones visuales ))", 255, 0, 0 )
			setElementData(localPlayer, "hud", false)
			setElementData(localPlayer, "nohud", true)
			setPlayerHudComponentVisible("ammo", false)
			setPlayerHudComponentVisible("armour", false)
			setPlayerHudComponentVisible("breath", false)
			setPlayerHudComponentVisible("clock", false)
			setPlayerHudComponentVisible("health", false)
			setPlayerHudComponentVisible("money", false)
			setPlayerHudComponentVisible("radar", false)
			setPlayerHudComponentVisible("vehicle_name", false)
			setPlayerHudComponentVisible("weapon", false)
			setPlayerHudComponentVisible("radio", false)
			setPlayerHudComponentVisible("wanted", false)
		end
	end
)