function CrearVentanaDrogas()
	PanelDrogaVenta = guiCreateWindow(350,250,450,490,"Pedir Importación Ilegal",false)
	guiCreateLabel(35,35,340,60,"Drogras disponibles - Facciones Ilegales Oficiales",false,PanelDrogaVenta)
	textito = guiCreateLabel(35,50,360,60,"Estás drogas son precios facciónarios luego tu asigna tus precios",false,PanelDrogaVenta)
	guiLabelSetColor(textito, 255, 0, 0)
	BotonCerrar = guiCreateButton(185,390,70,60,"CERRAR",false,PanelDrogaVenta)
		
		Comprar_Marihuana    = guiCreateButton(29,210,60,40,"Marihuana\n350$",false,PanelDrogaVenta)
		Comprar_Setas     = guiCreateButton(109,210,70,40,"Setas\n300$",false,PanelDrogaVenta)
		Comprar_Cocaina     = guiCreateButton(189,210,60,40,"Cocaina\n900$",false,PanelDrogaVenta)
		Comprar_Extasis    = guiCreateButton(269,210,60,40,"Extasis\n500$",false,PanelDrogaVenta)
		Comprar_LSD   = guiCreateButton(29,330,60,40,"Lsd\n500$",false,PanelDrogaVenta)
		Comprar_Speed     = guiCreateButton(109,330,60,40,"Speed\n500$",false,PanelDrogaVenta)
		Comprar_Heroina = guiCreateButton(189,330,60,40,"Heroina\n900$",false,PanelDrogaVenta)
		Comprar_Anfetas   = guiCreateButton(269,330,60,40,"Anfetas\n600$",false,PanelDrogaVenta)
		Comprar_Meta  = guiCreateButton(349,330,60,40,"Meta\n600$",false,PanelDrogaVenta)
		Comprar_Hachi   = guiCreateButton(349,210,60,40,"Hachis\n350$",false,PanelDrogaVenta)

		
		addEventHandler("onClientGUIClick", Comprar_Marihuana, ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_Setas, ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_Cocaina, ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_Extasis , ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_LSD, ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_Speed, ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_Heroina, ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_Anfetas, ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_Meta, ComprarDrogas)
		addEventHandler("onClientGUIClick", Comprar_Hachi, ComprarDrogas)
		addEventHandler("onClientGUIClick", BotonCerrar, abrirpaneldrogas)

		
		
		
		guiCreateStaticImage(30,140,60,60,"imagenesD/maria.png", false,PanelDrogaVenta )
		guiCreateStaticImage(110,140,60,60,"imagenesD/setas.png", false,PanelDrogaVenta )
		guiCreateStaticImage(190,140,60,60,"imagenesD/cocaina.png", false,PanelDrogaVenta )
		guiCreateStaticImage(270,140,60,60,"imagenesD/extasis.png", false,PanelDrogaVenta )
		guiCreateStaticImage(110,260,60,60,"imagenesD/speed.png", false,PanelDrogaVenta )
		guiCreateStaticImage(190,260,60,60,"imagenesD/heroina.png", false,PanelDrogaVenta )
		guiCreateStaticImage(30,260,60,60,"imagenesD/lsd.png", false,PanelDrogaVenta )
		guiCreateStaticImage(270,260,60,60,"imagenesD/anfetas.png", false,PanelDrogaVenta )
		guiCreateStaticImage(350,260,60,60,"imagenesD/meta.png", false,PanelDrogaVenta )
		guiCreateStaticImage(350,140,60,60,"imagenesD/hachi.png", false,PanelDrogaVenta )
		guiCreateStaticImage(20,80,800,80,"imagenesD/logodrogas.png", false,PanelDrogaVenta )
		
	guiWindowSetSizable(PanelDrogaVenta,false)
	guiSetVisible(PanelDrogaVenta,false)
end
addEventHandler("onClientResourceStart", getRootElement(), CrearVentanaDrogas)


function ComprarDrogas(button, state)

	if (button == "left") then
	
		if(source == Comprar_Marihuana) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_marihuana")	
		elseif(source == Comprar_Setas) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_setas")
		elseif(source == Comprar_Cocaina) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_cocaina")
		elseif(source == Comprar_Extasis) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_extasis")
		elseif(source == Comprar_LSD) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_lsd")
		elseif(source == Comprar_Speed) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_speed")
		elseif(source == Comprar_Heroina) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_heroina")
		elseif(source == Comprar_Anfetas) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_anfetas")
        elseif(source == Comprar_Meta) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_meta")
	    elseif(source == Comprar_Hachi) then
			triggerServerEvent("onDrogasIlegalesAbierto", localPlayer, "droga_hachi")
		end
	
	end
end

function abrirpaneldrogas ( )
	guiSetVisible ( PanelDrogaVenta, not guiGetVisible ( PanelDrogaVenta ) )
    showCursor ( not isCursorShowing( ) )
end
addEvent("AbrirPanelDrogasIlegal", true)
addEventHandler("AbrirPanelDrogasIlegal", getLocalPlayer(), abrirpaneldrogas)




