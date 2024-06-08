-- Sistema de camaras de seguridad.



----- Definición del panel.
function VerCamaras()
		local x,y = guiGetScreenSize()
		local width,height = 450,470
		x = x-width
		y = (y-height)/2
		cams_wnd = guiCreateWindow(x,y,width,height, "Camaras de Seguridad", false)
		button_cam_one = guiCreateButton(38,30,180,30, "Gal Cars", false,cams_wnd)
		button_cam_two = guiCreateButton(38,75,180,30, "S.F.P.D D-1", false,cams_wnd)
		button_cam_three = guiCreateButton(38,120,180,30, "Mufflers", false,cams_wnd)
		button_cam_four = guiCreateButton(38,165,180,30, "Xoomer", false,cams_wnd)
		button_cam_five = guiCreateButton(38,210,180,30, "TTL", false,cams_wnd)
		button_cam_six = guiCreateButton(38,255,180,30, "Taxistas", false,cams_wnd)
		button_cam_seven = guiCreateButton(38,300,180,30, "Puerto", false,cams_wnd)
		button_cam_eight = guiCreateButton(38,345,180,30, "Hospital", false,cams_wnd)
		button_cam_nine = guiCreateButton(38,390,180,30, "Ayuntamiento", false,cams_wnd)
		button_cam_close = guiCreateButton(38,435,180,30, "Cerrar", false,cams_wnd)
		button_vid_normal = guiCreateButton(233,30,180,30, "Normal", false,cams_wnd)
		button_vid_night = guiCreateButton(233,75,180,30, "Nocturna", false,cams_wnd)
		button_vid_teplo = guiCreateButton(233,120,180,30, "Termica", false,cams_wnd)
		showCursor(true)
		setElementFrozen(getLocalPlayer(),true)
end
addEvent("VerCamarasPolicia", true)
addEventHandler("VerCamarasPolicia", getLocalPlayer(), VerCamaras)


-------- Camaras Definidas
addEventHandler("onClientGUIClick",getRootElement(),function()
	if (source == button_vid_normal) then
        setCameraGoggleEffect("normal")
	end
	if (source == button_vid_night) then
        setCameraGoggleEffect("nightvision")
	end
	if (source == button_vid_teplo) then
        setCameraGoggleEffect("thermalvision")
	end
	if (source == button_cam_one) then
        fadeCamera (true)
        setCameraMatrix(-1968.5283203125, 278.8525390625, 40.431369781494, -2056.7568359375 , 318.5869140625 , 15.192873001099 , 0 , 70 )
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de Gal Cars",0,255,0)
	end
	if (source == button_cam_two) then
        fadeCamera (true)
        setCameraMatrix( -1615.0302734375, 713.2802734375, 18.659585952759, -1533.166015625, 762.693359375, -10.608016967773 , 0 , 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del distrito 1",0,255,0)
	end
	if (source == button_cam_three) then
        fadeCamera (true)
        setCameraMatrix(-1511.4951171875, 779.3291015625, 10.316791534424, -1454.212890625, 858.783203125, -9.8239154815674, 0, 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del Concesionario Mufflers",0,255,0)
	end
	if (source == button_cam_four) then
        fadeCamera (true)
        setCameraMatrix(-2018.705078125, 375.248046875, 41.388759613037, -2111.203125, 339.1494140625, 29.513427734375, 0, 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de Industrias Xoomer",0,255,0)
	end
	if (source == button_cam_five) then
        fadeCamera (true)
        setCameraMatrix( -2056.546875, -18.58984375, 41.745937347412, -2098.64453125, -105.71484375, 16.507440567017, 0, 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de TurboTransLogistic",0,255,0)
	end
	if (source == button_cam_six) then
        fadeCamera (true)
        setCameraMatrix( -2308.5556640625, -81.5556640625, 53.222747802734, -2376.9140625, -131.2490234375, -0.23512749373913, 0, 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad de Taxistas",0,255,0)
	end
	if (source == button_cam_seven) then
        fadeCamera (true)
        setCameraMatrix(-1693.189453125, -115.44921875, 17.116069793701, -1680.4990234375, -21.48046875, -14.644105911255, 0 , 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del Puerto SF",0,255,0)
	end
	if (source == button_cam_eight) then
        fadeCamera (true)
        setCameraMatrix(-2671.357421875, 619.4384765625, 29.240600585938, -2614.69140625, 679.3935546875, -27.277629852295, 0, 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del Hospital SF",0,255,0)
	end
	if (source == button_cam_nine) then
        fadeCamera (true)
        setCameraMatrix(-2767.3154296875, 368.853515625, 18.269708633423, -2676.369140625, 390.162109375, -17.432621002197, 0, 70)
		setElementInterior(getLocalPlayer(),0)
		setElementDimension(getLocalPlayer(),0)
		outputChatBox("Estás vigilando la cámara de seguridad del Ayuntamiento",0,255,0)
	end
	if (source == button_cam_close) then
        fadeCamera (true)
		setCameraTarget (getLocalPlayer())
	    showCursor(false)
		guiSetVisible(cams_wnd,false)
		setCameraGoggleEffect("normal")
		setElementInterior(getLocalPlayer(),10)
		setElementDimension(getLocalPlayer(),8)
		setElementFrozen(getLocalPlayer(),false)
		setElementPosition(getLocalPlayer(),2019.826171875, 1962.9951171875, -12.739062309265)
	    outputChatBox("Has Apagado el ordenador de las cámaras",0,255,0)
	    setElementData(getLocalPlayer(),"concamaraspd",false)
	end
end)