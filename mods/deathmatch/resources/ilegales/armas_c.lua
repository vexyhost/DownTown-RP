function CrearVentanaArmasA()
	PanelArmasVenta = guiCreateWindow(350,250,450,490,"Pedir Importación Ilegal",false)
	guiCreateLabel(35,35,340,60,"Cajas de armas con 4 unidades disponibles",false,PanelArmasVenta)
	textito = guiCreateLabel(35,50,360,60,"Estás Armas son precios facciónarios luego tu asigna tus precios",false,PanelArmasVenta)
	guiLabelSetColor(textito, 255, 0, 0)
	BotonCerrar = guiCreateButton(185,390,70,60,"CERRAR",false,PanelArmasVenta)
		
		
		Comprar_AK47    = guiCreateButton(29,210,60,40,"AK-47\n45000$",false,PanelArmasVenta)
		Comprar_UZI     = guiCreateButton(109,210,70,40,"UZI\n36000$",false,PanelArmasVenta)
		Comprar_Silenciada     = guiCreateButton(189,210,60,40,"Pistola-S\n26000$",false,PanelArmasVenta)
		Comprar_Sniper    = guiCreateButton(269,210,60,40,"Sniper\n50000$",false,PanelArmasVenta)
		Comprar_Pistola   = guiCreateButton(29,330,60,40,"Pistola\n26000$",false,PanelArmasVenta)
		Comprar_TEC9     = guiCreateButton(109,330,60,40,"TEC-9\n36000$",false,PanelArmasVenta)
		Comprar_Molotov = guiCreateButton(189,330,60,40,"Molotov\n12000$",false,PanelArmasVenta)
		Comprar_Katana   = guiCreateButton(269,330,60,40,"Katana\n6000$",false,PanelArmasVenta)
		Comprar_Recortada  = guiCreateButton(349,330,60,40,"Recortada\n39000$",false,PanelArmasVenta)
		Comprar_Rifle   = guiCreateButton(349,210,60,40,"Rifle\n48000$",false,PanelArmasVenta)

		
		addEventHandler("onClientGUIClick", Comprar_AK47, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_UZI, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Silenciada, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Sniper , ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Pistola, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_TEC9, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Molotov, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Katana, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Recortada, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", Comprar_Rifle, ComprarArmasIlegalesBoton)
		addEventHandler("onClientGUIClick", BotonCerrar, abrirpanelarmasNew)

		
		
		
		guiCreateStaticImage(30,140,60,60,"imagenesA/30.png", false,PanelArmasVenta )
		guiCreateStaticImage(110,140,60,60,"imagenesA/28.png", false,PanelArmasVenta )
		guiCreateStaticImage(190,140,60,60,"imagenesA/23.png", false,PanelArmasVenta )
		guiCreateStaticImage(270,140,60,60,"imagenesA/34.png", false,PanelArmasVenta )
		guiCreateStaticImage(110,260,60,60,"imagenesA/32.png", false,PanelArmasVenta )
		guiCreateStaticImage(190,260,60,60,"imagenesA/18.png", false,PanelArmasVenta )
		guiCreateStaticImage(30,260,60,60,"imagenesA/22.png", false,PanelArmasVenta )
		guiCreateStaticImage(270,260,60,60,"imagenesA/8.png", false,PanelArmasVenta )
		guiCreateStaticImage(350,260,60,60,"imagenesA/26.png", false,PanelArmasVenta )
		guiCreateStaticImage(350,140,60,60,"imagenesA/33.png", false,PanelArmasVenta )
		guiCreateStaticImage(20,80,800,80,"imagenesA/logoarmas.png", false,PanelArmasVenta )
		
	guiWindowSetSizable(PanelArmasVenta,false)
	guiSetVisible(PanelArmasVenta,false)
end
addEventHandler("onClientResourceStart", getRootElement(), CrearVentanaArmasA)


function ComprarArmasIlegalesBoton(button, state)

	if (button == "left") then
	
		if(source == Comprar_AK47) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_ak47")	
		elseif(source == Comprar_UZI) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_uzi")
		elseif(source == Comprar_Silenciada) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_silenciada")
		elseif(source == Comprar_Sniper) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_sniper")
		elseif(source == Comprar_Pistola) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_pistola")
		elseif(source == Comprar_TEC9) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_tec9")
		elseif(source == Comprar_Molotov) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_molotov")
		elseif(source == Comprar_Katana) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_katana")
        elseif(source == Comprar_Recortada) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_recortada")
	    elseif(source == Comprar_Rifle) then
			triggerServerEvent("onPanelCompraArma", localPlayer, "arma_rifle")
		end
	
	end
end

function abrirpanelarmasNew ( )
	guiSetVisible ( PanelArmasVenta, not guiGetVisible ( PanelArmasVenta ) )
    showCursor ( not isCursorShowing( ) )
end
addEvent("AbrirPanelArmasIlegal", true)
addEventHandler("AbrirPanelArmasIlegal", getLocalPlayer(), abrirpanelarmasNew)




