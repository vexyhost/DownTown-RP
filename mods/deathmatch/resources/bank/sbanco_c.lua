-- Guardias
seguratanumero1 = createPed ( 71, -302.30584716797, 1483.9251708984, 1071.1059570312, 320.40740966797, false )
setElementData( seguratanumero1, "npcname", "Guardia Banco" )
setElementInterior( seguratanumero1,14)
setElementDimension( seguratanumero1, 53)

seguratanumero2 = createPed ( 71, -292.30291748047, 1483.3460693359, 1071.1059570312, 32.621643066406, false )
setElementData( seguratanumero2, "npcname", "Guardia Banco" )
setElementInterior( seguratanumero2,14)
setElementDimension( seguratanumero2, 53)


seguratanumero3 = createPed ( 71, -301.67205810547, 1496.5677490234, 1071.1059570312, 182.30166625977, false )
setElementData( seguratanumero3, "npcname", "Guardia Banco" )
setElementInterior( seguratanumero3,14)
setElementDimension( seguratanumero3, 53)


seguratanumero4 = createPed ( 71, -295.40838623047, 1501.1429443359, 1071.1059570312, 182.30166625977, false )
setElementData( seguratanumero4, "npcname", "Guardia Banco" )
setElementInterior( seguratanumero4,14)
setElementDimension( seguratanumero4, 53)


seguratanumero5 = createPed ( 71,  -298.38592529297, 1501.1419677734, 1071.1059570312, 182.30166625977, false )
setElementData( seguratanumero5, "npcname", "Guardia Banco" )
setElementInterior( seguratanumero5,14)
setElementDimension( seguratanumero5, 53)




function dispararalpendejo ( )
alarmabanco = playSound3D( 'alarmabanco.mp3', -297.02, 1490.22, 1071.11, true )
setSoundMaxDistance( alarmabanco, 100 )
setElementInterior(alarmabanco,14)
setElementDimension(alarmabanco,53)
outputChatBox("ATENCIÓN: El detector de armas ha saltado y la alarma empezaría a sonar",255,255,0)
end
addEvent("dispararporllevararmasbanco", true)
addEventHandler("dispararporllevararmasbanco", getLocalPlayer(), dispararalpendejo)

function apagaralarma ()
setPedControlState(seguratanumero1,"fire", false)
setPedControlState(seguratanumero2,"fire", false)
setPedControlState(seguratanumero3,"fire", false)
setPedControlState(seguratanumero4,"fire", false)
setPedControlState(seguratanumero5,"fire", false)
stopSound( alarmabanco )
outputChatBox("(( Has apagado la alarma del banco correctamente Agente ))",0,255,0)
end
addCommandHandler ( "apagaralarma", apagaralarma )














