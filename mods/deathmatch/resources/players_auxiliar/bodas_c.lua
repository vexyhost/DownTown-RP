-- Client Sistema de matrimonio DTRP - FrankGT

addEventHandler( 'onClientResourceStart', resourceRoot,
function( )
	-------- Iglesia DTRP
	local iglesiaboda = playSound3D( "https://foro.fc-mta.com/servicios/musicaentorno/boda.mp3", 381.4716796875, 2323.720703125, 1889.5668945312, true )
	setElementDimension( iglesiaboda, 182 )
	setElementInterior(iglesiaboda,3)
	setSoundVolume( iglesiaboda, 5 )
	setSoundMaxDistance(iglesiaboda, 3000 )
end
)