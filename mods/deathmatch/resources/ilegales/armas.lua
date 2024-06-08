-------------------------------------- Sistema de importación de drogas DTRP ---------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
----------------- Autor: FrankGT - Jefferson -----------------------------------------------------------------------------------
-- Nueva edición 13/10/2017: se ha añadido por packs de armas 4 unidades por tipo de arma y fixeadas las balas.

function ComprarArmasIlegal(nombreArmasL)

	if exports.factions:isPlayerInFaction( source, 100 ) or exports.factions:isPlayerInFaction( source, 101 ) or exports.factions:isPlayerInFaction( source, 102 ) then
	
	    if(nombreArmasL == "arma_ak47") then
			if exports.players:takeMoney(source, 45000 ) then
				outputChatBox("Has comprado una caja con 4 AK-47 en 45000$ - revisa inventario.", source, 0, 255, 0)
			    outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de AK-47 en 45000$.")
				-- por ahora se ha definido por 45000 una caja con 4 aks con 200 balas
				exports.items:give(source, 29, "30", "Arma 30", 200)
				exports.items:give(source, 29, "30", "Arma 30", 200)
				exports.items:give(source, 29, "30", "Arma 30", 200)
				exports.items:give(source, 29, "30", "Arma 30", 200)
			else
				outputChatBox("(( Dinero Insuficiente para: AK-47 - 45000$ ))", source, 255, 0, 0)
			end
			
		elseif(nombreArmasL == "arma_uzi") then
			if exports.players:takeMoney(source, 36000 ) then
				outputChatBox("Has comprado una caja con 4 uzis en 36000$ - revisa inventario.", source, 0, 255, 0)
			    outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de UZI en 36000$")
			    -- por ahora se ha definido por 36000 una caja con 4 uzis con 130 balas
				exports.items:give(source, 29, "28", "Arma 28", 130)
				exports.items:give(source, 29, "28", "Arma 28", 130)
				exports.items:give(source, 29, "28", "Arma 28", 130)
				exports.items:give(source, 29, "28", "Arma 28", 130)
			else
				outputChatBox("(( Dinero Insuficiente para: UZI - 36000$ ))", source, 255, 0, 0)
			end
		elseif(nombreArmasL == "arma_silenciada") then
			if exports.players:takeMoney(source, 26000 ) then
				outputChatBox("Has comprado una caja con 4 silenciadas en 26000$ - revisa inventario.", source, 0, 255, 0)
			    outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
				exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de silenciadas en 26000$.")
			    -- por ahora se ha definido por 26000 una caja con 4 silenciadas con 90 balas
				exports.items:give(source, 29, "23", "Arma 23", 90)
				exports.items:give(source, 29, "23", "Arma 23", 90)
				exports.items:give(source, 29, "23", "Arma 23", 90)
				exports.items:give(source, 29, "23", "Arma 23", 90)
			else
				outputChatBox("(( Dinero Insuficiente para: Silenciada - 26000$ ))", source, 255, 0, 0)
			end	
			
		elseif(nombreArmasL == "arma_sniper") then
			if exports.players:takeMoney(source, 50000 ) then
				outputChatBox("Has comprado una caja con 4 snipers en 50000$ - revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de Sniper en 50000$.")
			    -- por ahora se ha definido por 50000 una caja con 4 snipers con 90 balas
				exports.items:give(source, 29, "34", "Arma 34", 90)
				exports.items:give(source, 29, "34", "Arma 34", 90)
				exports.items:give(source, 29, "34", "Arma 34", 90)
				exports.items:give(source, 29, "34", "Arma 34", 90)
			else
				outputChatBox("(( Dinero Insuficiente para: Sniper - 50000$ ))", source, 255, 0, 0)
			end	
			
		elseif(nombreArmasL == "arma_pistola") then
			if exports.players:takeMoney(source, 26000 ) then
				outputChatBox("Has comprado una caja con 4 pistolas en 26000$ -  revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de 9mm Colt.45 en 26000$.")
			    -- por ahora se ha definido por 26000 una caja con 4 pistolas con 100 balas
				exports.items:give(source, 29, "22", "Arma 22", 100)
				exports.items:give(source, 29, "22", "Arma 22", 100)
				exports.items:give(source, 29, "22", "Arma 22", 100)
				exports.items:give(source, 29, "22", "Arma 22", 100)
			else
				outputChatBox("(( Dinero Insuficiente para: Pistola Colt.45 - 26000$ ))", source, 255, 0, 0)
			end
			
		elseif(nombreArmasL == "arma_tec9") then
			if exports.players:takeMoney(source, 36000 ) then
				outputChatBox("Has comprado una caja con 4 tec-9 en 36000$ -  revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de Tec-9 en 36000$.")
				-- por ahora se ha definido por 36000 una caja con 4 tec9 con 130 balas.
				exports.items:give(source, 29, "32", "Arma 32", 130)
				exports.items:give(source, 29, "32", "Arma 32", 130)
				exports.items:give(source, 29, "32", "Arma 32", 130)
				exports.items:give(source, 29, "32", "Arma 32", 130)
			else
				outputChatBox("(( Dinero Insuficiente para: Tec-9 - 36000$ ))", source, 255, 0, 0)
			end
 
        elseif(nombreArmasL == "arma_molotov") then
			if exports.players:takeMoney(source, 12000 ) then
				outputChatBox("Has comprado una caja con cockteles molotov en 12000$ - revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de Cocktel Molotov en 12000$.")
			    -- por ahora se ha definido por 12000 una caja con 4 cockteles molotovs
				exports.items:give(source, 29, "18", "Arma 18", 1)
				exports.items:give(source, 29, "18", "Arma 18", 1)
				exports.items:give(source, 29, "18", "Arma 18", 1)
				exports.items:give(source, 29, "18", "Arma 18", 1)
			else
				outputChatBox("(( Dinero Insuficiente para: Cocktel Molotov - 12000$ ))", source, 255, 0, 0)
			end 
			
		elseif(nombreArmasL == "arma_katana") then
			if exports.players:takeMoney(source, 6000 ) then
				outputChatBox("Has comprado una caja con 4 katanas en 6000$ - revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de Katanas en 6000$.")
			    -- por ahora se ha definido por 6000 una caja con 4 katanas
				exports.items:give(source, 29, "8", "Arma 8", 1)
				exports.items:give(source, 29, "8", "Arma 8", 1)
				exports.items:give(source, 29, "8", "Arma 8", 1)
				exports.items:give(source, 29, "8", "Arma 8", 1)
			else
				outputChatBox("(( Dinero Insuficiente para: Katana - 6000$", source, 255, 0, 0)
			end	
		
		elseif(nombreArmasL == "arma_recortada") then
			if exports.players:takeMoney(source, 39000 ) then
				outputChatBox("Has comprado una caja con 4 recortadas en 39000$ - revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un pack de Recortadas en 39000$.")
			    -- por ahora se ha definido por 39000 una caja con 4 recortadas.
				exports.items:give(source, 29, "26", "Arma 26", 80)
				exports.items:give(source, 29, "26", "Arma 26", 80)
				exports.items:give(source, 29, "26", "Arma 26", 80)
				exports.items:give(source, 29, "26", "Arma 26", 80)
			else
				outputChatBox("(( Dinero Insuficiente para: Recortada - 39000$ ))", source, 255, 0, 0)
			end
			
		elseif(nombreArmasL == "arma_rifle") then
			if exports.players:takeMoney(source, 48000 ) then
				outputChatBox("Has comprado una caja con 4 rifles en 48000$ - revisa inventario.", source, 0, 255, 0)
				outputChatBox("Vladimir Tripalowsky te entrega una caja con armas.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compraarmas", getPlayerName(source).." ha comprado un Rifle de caza en 48000$.")
			    -- por ahora se ha definido por 48000 una caja con 4 rifles de caza.
				exports.items:give(source, 29, "33", "Arma 33", 50)
				exports.items:give(source, 29, "33", "Arma 33", 50)
				exports.items:give(source, 29, "33", "Arma 33", 50)
				exports.items:give(source, 29, "33", "Arma 33", 50)
			else
				outputChatBox("(( Dinero Insuficiente para: Rifle de Caza - 48000$ ))", source, 255, 0, 0)
			end
		end	
	else
		outputChatBox ("[Ruso] Vladimir Tripalowsky dice: ¿Tu quien eres y como has entrado? Verás!.", source, 230, 230, 230)
		outputChatBox("Vladimir Tripalowsky te pega con la culata de la pistola en la cabeza.", source, 255, 40, 80)
		outputChatBox("* Te meterían en una furgoneta de melocotones y te arrojarían en la carretera (( Vladimir Tripalowsky )).", source, 255, 255, 0)
        setElementPosition(source,348.615234375, 1001.5029296875, 28.721237182617)
		setElementDimension(source,0)
		setElementInterior(source,0)
	end

end
addEvent("onPanelCompraArma", true)
addEventHandler("onPanelCompraArma", getRootElement(), ComprarArmasIlegal)



local function crearPedArmasLoco( )
	if armamentoped then
		destroyElement( armamentoped )
	end
	armamentoped = createPed( 59,  -188.9287109375, 1125.1884765625, 225.94818115234, 179.78576660156, true )
	setElementInterior(armamentoped,36)
	setElementDimension(armamentoped,220)
	setElementData( armamentoped, "npcname", "Vladimir Tripalowsky" )
	setTimer(setElementFrozen, 2000, 1, armamentoped, true) 
end

addEventHandler( "onPedWasted", resourceRoot, crearPedArmasLoco )
addEventHandler( "onResourceStart", resourceRoot, crearPedArmasLoco )


addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			if getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) ) < 5 and getElementDimension( player ) == getElementDimension( source ) and source == armamentoped then
				triggerClientEvent(player, "AbrirPanelArmasIlegal", player)
			end
		end
	end
)