function Ladrar ( x, y, z, int, dim )
    playSound3D ( "ladridos.mp3", x, y, z )
end
addEvent( "onSonido", true )
addEventHandler( "onSonido", getRootElement(), Ladrar )

setTimer(function()
	--HAU HAU HAU ;3
	for k,v in ipairs(getElementsByType("ped")) do
		if math.random(1,5) == 1 then
			if getElementModel(v) == 88 or getElementModel(v) == 89 or getElementModel(v) == 94 then
				local smp3 = playSound3D("ladridos.mp3", 0, 0, 0)
				setElementInterior(smp3, getElementInterior(v))
				setElementDimension(smp3, getElementDimension(v))
				attachElements(smp3, v)
			end
		end
	end
end, 8000, 0)