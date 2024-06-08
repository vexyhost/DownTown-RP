function ComprarDrogas(nombreDroga)

	if exports.factions:isPlayerInFaction( source, 100 ) or exports.factions:isPlayerInFaction( source, 101 ) or exports.factions:isPlayerInFaction( source, 102 ) then
	
	    if(nombreDroga == "droga_marihuana") then
			if exports.players:takeMoney(source, 350 ) then
				outputChatBox("Has comprado una bolsa de Marihuana 5g revisa el inventario.", source, 0, 255, 0)
			    outputChatBox("Marcus Douglas te da una bolsa de marihuana.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado marihuana en 350$.")
				exports.items:give(source, 22, 1)
			else
				outputChatBox("(( Dinero Insuficiente para: Marihuana - 350$ ))", source, 255, 0, 0)
			end
			
		elseif(nombreDroga == "droga_setas") then
			if exports.players:takeMoney(source, 300 ) then
				outputChatBox("Has comprado un saco de setás alucinogenas revisa el inventario.", source, 0, 255, 0)
			    outputChatBox("Marcus Douglas te da una seta alucinogena.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado setas alucinogenas en 300$")
			    exports.items:give(source, 19, 1)
			else
				outputChatBox("(( Dinero Insuficiente para: Setas - 300$ ))", source, 255, 0, 0)
			end
			
		elseif(nombreDroga == "droga_cocaina") then
			outputChatBox("(( Mantenimiento del Item ))", source, 255, 0, 0)
			--if exports.players:takeMoney(source, 900 ) then
			--	outputChatBox("Has comprado un paquete de Cocaina revisa el inventario.", source, 0, 255, 0)
			--    outputChatBox("Marcus Douglas te da un faldo de cocaina.", source, 255, 40, 80)
			--    exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado cocaina en 900$.")
			--    exports.items:give(source, 37, 1)
			--else
			--	outputChatBox("(( Dinero Insuficiente para: Cocaina - 900$ ))", source, 255, 0, 0)
			--end	
			
		elseif(nombreDroga == "droga_extasis") then
			if exports.players:takeMoney(source, 500 ) then
				outputChatBox("Has comprado Extasis revisa el inventario.", source, 0, 255, 0)
				outputChatBox("Marcus Douglas te da una bolsita de extasis.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado extasis en 500$.")
			    exports.items:give(source, 20, 1)
			else
				outputChatBox("(( Dinero Insuficiente para: Extasis - 500$ ))", source, 255, 0, 0)
			end	
			
		elseif(nombreDroga == "droga_lsd") then
			outputChatBox("(( Mantenimiento del Item ))", source, 255, 0, 0)
			--if exports.players:takeMoney(source, 500 ) then
				--outputChatBox("Has comprado LSD revisa el inventario.", source, 0, 255, 0)
			--	outputChatBox("Marcus Douglas te da una bolsa de LSD.", source, 255, 40, 80)
			 --   exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado lsd en 500$.")
			 --   exports.items:give(source, 40, 1)
		--	else
			--	outputChatBox("(( Dinero Insuficiente para: LSD - 500$ ))", source, 255, 0, 0)
		--	end
			
		elseif(nombreDroga == "droga_speed") then
			outputChatBox("(( Mantenimiento del Item ))", source, 255, 0, 0)
			--if exports.players:takeMoney(source, 500 ) then
				--outputChatBox("Has comprado Speed revisa el inventario.", source, 0, 255, 0)
				--outputChatBox("Marcus Douglas te da una bolsa de Speed.", source, 255, 40, 80)
			   -- exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado speed en 500$.")
			   -- exports.items:give(source, 36, 1)
		--	else
			--	outputChatBox("(( Dinero Insuficiente para: Speed - 500$ ))", source, 255, 0, 0)
			--end
 
        elseif(nombreDroga == "droga_heroina") then
			outputChatBox("(( Mantenimiento del Item ))", source, 255, 0, 0)
			--if exports.players:takeMoney(source, 900 ) then
			--	outputChatBox("Has comprado Heroina revisa el inventario.", source, 0, 255, 0)
			--	outputChatBox("Marcus Douglas te da un faldo de heroina.", source, 255, 40, 80)
			--    exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado heroina en 900$.")
			--    exports.items:give(source, 39, 1)
			--else
			--	outputChatBox("(( Dinero Insuficiente para: Heroina - 900$ ))", source, 255, 0, 0)
			--end 
			
		elseif(nombreDroga == "droga_anfetas") then
			outputChatBox("(( Mantenimiento del Item ))", source, 255, 0, 0)
			--if exports.players:takeMoney(source, 600 ) then
			--	outputChatBox("Has comprado Anfetaminas revisa el inventario.", source, 0, 255, 0)
			--	outputChatBox("Marcus Douglas te da un bote de anfetas.", source, 255, 40, 80)
			--    exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado anfetas en 600$.")
			--    exports.items:give(source, 41, 1)
			--else
			--	outputChatBox("(( Dinero Insuficiente para: Anfetas - 600$", source, 255, 0, 0)
		--	end	
		
		elseif(nombreDroga == "droga_meta") then
			if exports.players:takeMoney(source, 600 ) then
				outputChatBox("Has comprado Meta revisa el inventario.", source, 0, 255, 0)
				outputChatBox("Marcus Douglas te da una bolsa de meta.", source, 255, 40, 80)
			    exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado meta en 600$.")
			    exports.items:give(source, 23, 1)
			else
				outputChatBox("(( Dinero Insuficiente para: Meta - 600$ ))", source, 255, 0, 0)
			end
			
		elseif(nombreDroga == "droga_hachi") then
			outputChatBox("(( Mantenimiento del Item ))", source, 255, 0, 0)
			--if exports.players:takeMoney(source, 350 ) then
			--	outputChatBox("Has comprado una tableta de Hachi revisa el inventario.", source, 0, 255, 0)
			--	outputChatBox("Marcus Douglas te da una tableta de hachis.", source, 255, 40, 80)
			--    exports.logs:addLogMessage("compradroga", getPlayerName(source).." ha comprado hachi en 350$.")
			--    exports.items:give(source, 38, 1)
			--else
			--	outputChatBox("(( Dinero Insuficiente para: Hachis - 350$ ))", source, 255, 0, 0)
			--end
		end	
	else
		outputChatBox ("[Ingles] Marcus Douglas dice: ¿Tu quien eres y como has entrado? Verás!.", source, 230, 230, 230)
		outputChatBox("Marcus Douglas te pega con la culata de la pistola en la cabeza.", source, 255, 40, 80)
		outputChatBox("* Unos hombres te sacarían de la caravana y te meterían en un coche dejandote tirado por la calle (( Marcus Douglas )).", source, 255, 255, 0)
        setElementPosition(source,-652.71484375, 1231.0751953125, 12.249881744385)
		setElementDimension(source,0)
		setElementInterior(source,0)
	    outputChatBox("Marcus Douglas se baja del vehículo y saca su cuchillo asín apuñalandote.", source, 255, 40, 80)
		setElementHealth(source,10)
	    outputChatBox("* Un vagabundo te vería tirado sangrando y pediría socorro llamando al 112 (( Marcus Douglas )).", source, 255, 255, 0)
	end

end
addEvent("onDrogasIlegalesAbierto", true)
addEventHandler("onDrogasIlegalesAbierto", getRootElement(), ComprarDrogas)



local function crearPedDrogas( )
	if drogataped then
		destroyElement( drogataped )
	end
	drogataped = createPed( 142,  -2027.845703125, -114.3193359375, 1039.1955566406, 241.38703918457, true )
	setElementInterior(drogataped,26)
	setElementDimension(drogataped,219)
	setElementData( drogataped, "npcname", "Marcus Douglas" )
	setTimer(setElementFrozen, 2000, 1, drogataped, true) 
end

addEventHandler( "onPedWasted", resourceRoot, crearPedDrogas )
addEventHandler( "onResourceStart", resourceRoot, crearPedDrogas )


addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			if getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) ) < 5 and getElementDimension( player ) == getElementDimension( source ) and source == drogataped then
				triggerClientEvent(player, "AbrirPanelDrogasIlegal", player)
			    --outputChatBox("Sistema en creación , disculpa las molestias DIA A DÍA PARA EL USUARIO DTRP!", player, 0, 0, 255)
			end
		end
	end
)