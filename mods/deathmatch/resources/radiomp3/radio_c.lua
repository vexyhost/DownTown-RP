local vr = {}
local ir = {}
local lr = {}
local stations = {
	{ link = "http://kissfm.kissfmradio.cires21.com/kissfm.mp3", name = "Kiss FM" },
	{ link = "http://playerservices.streamtheworld.com/api/livestream-redirect/M80RADIO_SC", name = "M80 Radio" },
	{ link = "http://playerservices.streamtheworld.com/api/livestream-redirect/CADENADIAL_SC", name = "Cadena Dial" },
	{ link = "http://playerservices.streamtheworld.com/api/livestream-redirect/LOS40_SC", name = "Los 40 principales" },
	{ link = "http://playerservices.streamtheworld.com/api/livestream-redirect/RADIOLE_SC", name = "Radio Olé" },
	{ link = "https://cadena100-cope-rrcast.flumotion.com/cope/cadena100-low.mp3", name = "Cadena 100" },
	{ link = "http://195.10.10.213/rtva/canalfiestaradio_master.mp3", name = "Canal fiesta radio" },
	{ link = "http://hitfm.kissfmradio.cires21.com/hitfm.mp3", name = "Hit FM" },
	{ link = "http://listen.radionomy.com/1-radio-dance.m3u", name = "Radio Dance" },
	{ link = "http://radiostream.flaixfm.cat:8000/", name = "Flaix FM" },
	{ link = "http://playerservices.streamtheworld.com/api/livestream-redirect/MAXIMAFM_SC", name = "Maxima FM" },
	{ link = "http://listen.radionomy.com/radioanimex-musicaanimeymuchomas-.m3u", name = "Radio Animex" },
	{ link = "http://listen.radionomy.com/hotmixradio-sunny-128.m3u", name = "HotmixRadio" },
	{ link = "http://212.129.60.86:9968/stream/1/", name = "Europa FM" },
	{ link = "http://listen.radionomy.com/quemando-antena.m3u", name = "QuemandoAntena" },
	{ link = "http://listen.radionomy.com/1000classicalhits.m3u", name = "ClassicHits" },
	{ link = "http://listen.radionomy.com/cheche-reggaeton-radio.m3u", name = "CheChe Radio" },
	{ link = "http://listen.radionomy.com/el-flow-reggaeton.m3u", name = "ElFlow Radio" },
	{ link = "http://listen.radionomy.com/HardbaseFM.m3u", name = "HardBass Radio" },
	{ link = "http://listen.radionomy.com/mix247edm.m3u", name = "Edm Radio" },
	{ link = "http://listen.radionomy.com/dancenow-.m3u", name = "DanceNow Radio" },
	{ link = "http://listen.radionomy.com/r1dubstep.m3u", name = "Dubstep Radio" },
	{ link = "http://listen.radionomy.com/ilovedance24-7morethan100000hitsarlearadio.m3u", name = "Dance90's Radio" },
	{ link = "http://listen.radionomy.com/90stechnogeneration2016.m3u", name = "90sTechno Radio" },
}

function startPlayLocalMusic( localp, station, player, yt )
	if yt then
		x, y, z = getElementPosition(localp)
		lr[localp] = {playSound3D(tostring(station), x, y, z, false), 100}
		setElementData(lr[localp][1], "radioSystem", true)
		outputChatBox("Ahora estás escuchando "..tostring(yt), 0, 255, 0 )
		attachElements(lr[localp][1], localp)
		setSoundMaxDistance(lr[localp][1], 20)
		setSoundMinDistance(lr[localp][1], 15)
	end
end
addEvent("onStartPlayLocalMusic", true)
addEventHandler("onStartPlayLocalMusic", getRootElement(), startPlayLocalMusic)

function stopPlayLocalMusic ( localp )
	if localp and lr[localp] and lr[localp][1] and isElement(lr[localp][1]) then
		stopSound(lr[localp][1])
		stopSonidos()
		lr[localp] = nil
	end
end
addEvent( "onStopPlayLocalMusic", true )
addEventHandler( "onStopPlayLocalMusic", getRootElement(), stopPlayLocalMusic )

function startPlayRadioMusic ( vehicle, station, player, yt )
	if vehicle and station then
		if yt then 
			if getElementType(vehicle) == "vehicle" then
				x, y, z = getElementPosition(vehicle)
				vr[vehicle] = {playSound3D(tostring(station), x, y, z, false), 100}
				local veh = getPedOccupiedVehicle(getLocalPlayer())
				if veh and veh == vehicle then
					outputChatBox("Ahora estás escuchando "..tostring(yt), 0, 255, 0 )
				end
				attachElements(vr[vehicle][1], vehicle, 0, 0, 3)
				setElementData(vr[vehicle][1], "radioSystem", true)
				setSoundMaxDistance(vr[vehicle][1], 20)
				setSoundMinDistance(vr[vehicle][1], 15)
			elseif getElementType(vehicle) == "object" then
				x, y, z = getElementPosition(vehicle)
				vr[vehicle] = {playSound3D(tostring(station), x, y, z, false), 100}
				attachElements(vr[vehicle][1], vehicle)
				setElementData(vr[vehicle][1], "radioSystem", true)
				setSoundMaxDistance(vr[vehicle][1], 6000)
				setSoundMinDistance(vr[vehicle][1], 500)
				setElementDimension(vr[vehicle][1], getElementDimension(getLocalPlayer()))
				setElementInterior(vr[vehicle][1], getElementInterior(getLocalPlayer()))
				local px, py, pz = getElementPosition(getLocalPlayer())
				if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 6000 then
					outputChatBox("(Altavoz) Ahora estás escuchando "..tostring(yt), 0, 255, 0 )
				end
			end
		else
			if getElementType(vehicle) == "vehicle" then
				if stations[station] == nil then
					station = 1
				end
				x, y, z = getElementPosition(vehicle)
				vr[vehicle] = {playSound3D(stations[station].link, x, y, z, false), station}
				local veh = getPedOccupiedVehicle(getLocalPlayer())
				if veh and veh == vehicle then
					outputChatBox("Ahora estás escuchando "..tostring(stations[station].name), 0, 255, 0 )
				end
				attachElements(vr[vehicle][1], vehicle)
				setElementData(vr[vehicle][1], "radioSystem", true)
			elseif getElementType(vehicle) == "object" then
				if stations[station] == nil then
					station = 1
				end
				x, y, z = getElementPosition(vehicle)
				vr[vehicle] = {playSound3D(stations[station].link, x, y, z, false), station}
				attachElements(vr[vehicle][1], vehicle)
				setElementData(vr[vehicle][1], "radioSystem", true)
				setSoundMaxDistance(vr[vehicle][1], 150)
				setSoundMinDistance(vr[vehicle][1], 100)
				local px, py, pz = getElementPosition(getLocalPlayer())
				if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 150 then
					outputChatBox("(Altavoz) Ahora estás escuchando "..tostring(stations[station].name), 0, 255, 0 )
				end
			end
		end
	end
end
addEvent( "onStartPlayVehicleMusic", true )
addEventHandler( "onStartPlayVehicleMusic", getRootElement(), startPlayRadioMusic )

function startPlayRadioMusic2 ( vehicle, station )
	if vehicle and type(station) == "number" and getElementType(vehicle) == "vehicle" then
		if stations[station] == nil or station >= 24 then
			station = 1
		end
		x, y, z = getElementPosition(vehicle)
		if vr[vehicle] then
			stopSound ( vr[vehicle][1] )
		end
		local veh = getPedOccupiedVehicle(getLocalPlayer())
		if veh and veh == vehicle then
			outputChatBox("Ahora estás escuchando "..tostring(stations[station].name), 0, 255, 0 )
		end
		vr[vehicle] = {playSound3D(stations[station].link, x, y, z, false), station}
		attachElements(vr[vehicle][1], vehicle)
		setElementData(vr[vehicle][1], "radioSystem", true)
	elseif vehicle and type(station) == "number" and getElementType(vehicle) == "object" then
		if stations[station] == nil or station >= 24 then
			station = 1
		end
		x, y, z = getElementPosition(vehicle)
		if vr[vehicle] then
			stopSound ( vr[vehicle][1] )
		end
		vr[vehicle] = {playSound3D(stations[station].link, x, y, z, false), station}
		attachElements(vr[vehicle][1], vehicle)
		setElementData(vr[vehicle][1], "radioSystem", true)
		setSoundMaxDistance(vr[vehicle][1], 150)
		setSoundMinDistance(vr[vehicle][1], 100)
		local px, py, pz = getElementPosition(getLocalPlayer())
		if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 150 then
			outputChatBox("(Altavoz) Ahora estás escuchando "..tostring(stations[station].name), 0, 255, 0 )
		end
	end
end
addEvent( "onChangeVehicleMusic", true )
addEventHandler( "onChangeVehicleMusic", getRootElement(), startPlayRadioMusic2 )

function stopPlayRadioMusic ( vehicle )
	if vehicle and vr[vehicle] and vr[vehicle][1] and isElement(vr[vehicle][1]) then
		stopSound(vr[vehicle][1])
		vr[vehicle] = nil
	end
end
addEvent( "onStopPlayVehicleMusic", true )
addEventHandler( "onStopPlayVehicleMusic", getRootElement(), stopPlayRadioMusic )

function onSoundStopped ( reason )
	if lr[getLocalPlayer()] then
		if lr[getLocalPlayer()][1] then
			if source == lr[getLocalPlayer()][1] then -- El sonido local se ha detenido, informar al movil.
				if ( reason == "destroyed" ) then
					triggerEvent ( "onCancionLocalTerminada", getLocalPlayer() )    
				elseif ( reason == "finished" ) then
				   triggerEvent ( "onCancionLocalTerminada", getLocalPlayer() )    
				elseif ( reason == "paused" ) then
					--REMATAR; SI ESTA EN PAUSA NANAI.
				   --.triggerEvent ( "onCancionLocalTerminada", getLocalPlayer() )  
				end
			end
		end
	end
end
addEventHandler ( "onClientSoundStopped", getRootElement(), onSoundStopped )

addEventHandler( "onClientVehicleStartEnter", resourceRoot,
	function( player, seat )
		if seat == 0 and player == localPlayer then
			if getElementData(source, "sinGasolina") then
				setVehicleEngineState(source, false)
				setElementFrozen(source, true)
				setTimer(setVehicleEngineState, 50, 10, source, false)
			end
		end
	end
)
-- Sistema de radios para interiores --

function startPlayRadioMusic3 ( dimension, station, player, yt )
	if dimension and station then
		if not yt then
			if stations[station] == nil then
				station = 1
			end
			x, y, z = getElementPosition(player)
			ir[dimension] = {playSound3D(stations[station].link, x, y, z, false), station}
			setElementDimension(ir[dimension][1], dimension)
			attachElements(ir[dimension][1], getLocalPlayer())
			setElementData(ir[dimension][1], "radioSystem", true)
			local dim = getElementDimension(getLocalPlayer())
			if dim and dim == dimension and dimension > 0 and dim > 0 then
				outputChatBox("Ahora estás escuchando "..tostring(stations[station].name), 0, 255, 0 )
			end
		else
			x, y, z = getElementPosition(player)
			ir[dimension] = {playSound3D(tostring(station), x, y, z, false), 100}
			setElementDimension(ir[dimension][1], dimension)
			attachElements(ir[dimension][1], getLocalPlayer())
			setElementData(ir[dimension][1], "radioSystem", true)
			setSoundMaxDistance(ir[dimension][1], 60)
			setSoundMinDistance(ir[dimension][1], 35)
			local dim = getElementDimension(getLocalPlayer())
			if dim and dim == dimension and dimension > 0 and dim > 0 then
				outputChatBox("Ahora estás escuchando "..tostring(yt), 0, 255, 0 )
			end
		end
	end
end
addEvent( "onStartPlayInteriorMusic", true )
addEventHandler( "onStartPlayInteriorMusic", getRootElement(), startPlayRadioMusic3 )

function startPlayRadioMusic4 ( dimension, station, player )
	if dimension and type(station) == "number" then
		if stations[station] == nil or station >= 24 then
			station = 1
		end
		if ir[dimension] then
			stopSound ( ir[dimension][1] )
		end
		x, y, z = getElementPosition(player)
		ir[dimension] = {playSound3D(stations[station].link, x, y, z, false), station}
		setElementDimension(ir[dimension][1], dimension)
		attachElements(ir[dimension][1], getLocalPlayer())
		setElementData(ir[dimension][1], "radioSystem", true)
		local dim = getElementDimension(getLocalPlayer())
		if dim and dim == dimension and dimension > 0 and dim > 0 then
			outputChatBox("Ahora estás escuchando "..tostring(stations[station].name), 0, 255, 0 )
		end
	end
end
addEvent( "onChangeInteriorMusic", true )
addEventHandler( "onChangeInteriorMusic", getRootElement(), startPlayRadioMusic4 )

function stopPlayRadioMusic2 ( dimension )
	if dimension and ir[dimension] then
		stopSound(ir[dimension][1])
	end
end
addEvent( "onStopPlayInteriorMusic", true )
addEventHandler( "onStopPlayInteriorMusic", getRootElement(), stopPlayRadioMusic2 )


function reconnectRadio ()
	if source then
		local dimension = getElementDimension(source)
		if not ir[dimension] then return end
		if ir[dimension][1] then
			detachElements(getLocalPlayer(), ir[dimension][1])
			setElementDimension(ir[dimension][1], dimension)
			attachElements(ir[dimension][1], getLocalPlayer())
			setElementData(ir[dimension][1], "radioSystem", true)
		end
	end
end
addEvent("onReconnectRadioInterior", true)
addEventHandler("onReconnectRadioInterior", getRootElement(), reconnectRadio)
-- Fin Sistema de radio de Interiores --

function stopSonidos()
	for k, v in ipairs(getElementsByType("sound")) do
		stopSound(v)
	end
	outputChatBox("Has parado todos los sonidos.", 0, 255, 0)
end
addCommandHandler("STOP", stopSonidos)
addCommandHandler("nomusic", stopSonidos)
addCommandHandler("noradio", stopSonidos)