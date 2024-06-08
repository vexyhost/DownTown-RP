puertapeajeaa1 = createObject ( 968, 2333.32, 288, 26.3, 0, -90, 90 )
puertapeajeaa2 = createObject ( 968, 2333.32, 277.80, 26.3, 0, 90, 90 )
markerpeajeaa = createMarker(2323.71, 282.74, 26.42, 'cylinder', 8.0, 255, 0, 0, 1)
estadoaa = 0


function moveaa (thePlayer)
if estadoaa == 0 then
local conductor = getVehicleOccupant ( thePlayer )
if ( conductor ) then
 if exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
  exports.chat:me (conductor, "muestra su tarjeta de peajes")
  moveObject ( puertapeajeaa1, 1500, 2333.32, 288, 26.3, 0, 90, 0 )
  moveObject ( puertapeajeaa2, 1500, 2333.32, 277.80, 26.3, 0, -90, 0 )
		setTimer (
            function ( )
                moveObject ( puertapeajeaa1, 1500, 2333.32, 288, 26.3, 0, -90, 0 )
				moveObject ( puertapeajeaa2, 1500, 2333.32, 277.80, 26.3, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeaa1 )
					if y ~= 0 then
						setElementRotation(puertapeajeaa1, 0, -90, 90)
						setElementRotation(puertapeajeaa2, 0, 90, 90)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		elseif not exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
         if getPlayerMoney ( conductor ) >= 15 then
		exports.chat:me (conductor, "paga el peaje")
		outputChatBox ("El peaje te ha costado $15", conductor, 255, 255, 255 )
		takePlayerMoney ( conductor, 15 )
        moveObject ( puertapeajeaa1, 1500, 2333.32, 288, 26.3, 0, 90, 0 )
        moveObject ( puertapeajeaa2, 1500, 2333.32, 277.80, 26.3, 0, -90, 0 )
				setTimer (
            function ( )
                moveObject ( puertapeajeaa1, 1500, 2333.32, 288, 26.3, 0, -90, 0 )
				moveObject ( puertapeajeaa2, 1500, 2333.32, 277.80, 26.3, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeaa1 )
					if y ~= 0 then
						setElementRotation(puertapeajeaa1, 0, -90, 90)
						setElementRotation(puertapeajeaa2, 0, 90, 90)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		     end
		     if getPlayerMoney ( conductor ) <= 14 then			 
			outputChatBox ("No tienes dinero para pagar el peaje!", conductor, 255, 255, 255 )
			setElementRotation(puertapeajeaa1, 0, -90, 90)
			setElementRotation(puertapeajeaa2, 0, 90, 90)
				end

end
end
end
end

addEventHandler( "onMarkerHit", markerpeajeaa, moveaa )



puertapeajeab1 = createObject ( 968, 2416.91, 301.59, 32.7, 0, 90, -77 )
puertapeajeab2 = createObject ( 968, 2419.1, 291.52, 32.69, 0, -90, -77 )
estadoab = 0
marketpeajeab = createMarker(2411.81, 294.53, 32.27, 'cylinder', 8.0, 255, 0, 0, 0) 



function moveab ( thePlayer )
if estadoab == 0 then
local conductor = getVehicleOccupant ( thePlayer )
if ( conductor ) then
 if exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
 moveObject ( puertapeajeab1, 1500, 2416.91, 301.59, 32.7, 0, -90, 0 )
 moveObject ( puertapeajeab2, 1500, 2419.1, 291.52, 32.69, 0, 90, 0 )
 exports.chat:me (conductor, "muestra su tarjeta de peajes")
 setTimer (
            function ( )
                moveObject ( puertapeajeab1, 1500, 2416.91, 301.59, 32.7, 0, 90, 0 )
				moveObject ( puertapeajeab2, 1500, 2419.1, 291.52, 32.69, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeab1 )
					if y ~= 0 then
						setElementRotation(puertapeajeab1,0,0,0)
						setElementRotation(puertapeajeab2,0,0,0)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		elseif not exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
         if getPlayerMoney ( conductor ) >= 15 then
		exports.chat:me (conductor, "paga el peaje")
		outputChatBox ("El peaje te ha costado $15", conductor, 255, 255, 255 )
		takePlayerMoney ( conductor, 15 )
        moveObject ( puertapeajeab1, 1500, 2416.91, 301.59, 32.7, 0, -90, 0 )
        moveObject ( puertapeajeab2, 1500, 2419.1, 291.52, 32.69, 0, 90, 0 )
				setTimer (
            function ( )
                moveObject ( puertapeajeab1, 1500, 2416.91, 301.59, 32.7, 0, 90, 0 )
				moveObject ( puertapeajeab2, 1500, 2419.1, 291.52, 32.69, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeab1 )
					if y ~= 0 then
						setElementRotation(puertapeajeab1,0,0,0)
						setElementRotation(puertapeajeab2,0,0,0)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		     end
		     if getPlayerMoney ( conductor ) <= 14 then			 
			outputChatBox ("No tienes dinero para pagar el peaje!", conductor, 255, 255, 255 )
						setElementRotation(puertapeajeab1,0,90,-77)
						setElementRotation(puertapeajeab2,0,-90,-77)
				end
end
end		
end
end
addEventHandler( "onMarkerHit", marketpeajeab, moveab)




puertapeajeac1 = createObject ( 968, 2404.162109375, 337.546875, 32.8359375, 0, 90, 126.670166015625 )
puertapeajeac2 = createObject ( 968, 2397.744140625, 346.0009765625, 32.67185211181, 0, -90, 126.670166015625 )
estadoac = 0
marketpeajeac = createMarker(2407.39, 346.06, 32.73, 'cylinder', 8.0, 255, 0, 0, 0)


function moveac ( thePlayer )
if estadoac == 0 then
local conductor = getVehicleOccupant ( thePlayer )
if ( conductor ) then
 if exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
 moveObject ( puertapeajeac1, 1500, 2404.162109375, 337.546875, 32.8359375, 0, -90, 0 )
 moveObject ( puertapeajeac2, 1500, 2397.744140625, 346.0009765625, 32.67185211181, 0, 90, 0 )
 exports.chat:me (conductor, "muestra su tarjeta de peajes")
setTimer (
            function ( )
                moveObject ( puertapeajeac1, 1500, 2404.162109375, 337.546875, 32.8359375, 0, 90, 0 )
                moveObject ( puertapeajeac2, 1500, 2397.744140625, 346.0009765625, 32.67185211181, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeac1 )
					if y ~= 0 then
						setElementRotation(puertapeajeac1,0,0,0)
						setElementRotation(puertapeajeac2,0,0,0)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		elseif not exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
         if getPlayerMoney ( conductor ) >= 15 then
		exports.chat:me (conductor, "paga el peaje")
		outputChatBox ("El peaje te ha costado $15", conductor, 255, 255, 255 )
		takePlayerMoney ( conductor, 15 )
        moveObject ( puertapeajeac1, 1500, 2404.162109375, 337.546875, 32.8359375, 0, -90, 0 )
        moveObject ( puertapeajeac2, 1500, 2397.744140625, 346.0009765625, 32.67185211181, 0, 90, 0 )
				setTimer (
            function ( )
                moveObject ( puertapeajeac1, 1500, 2404.162109375, 337.546875, 32.8359375, 0, 90, 0 )
                moveObject ( puertapeajeac2, 1500, 2397.744140625, 346.0009765625, 32.67185211181, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeac1 )
					if y ~= 0 then
						setElementRotation(puertapeajeac1,0,0,0)
						setElementRotation(puertapeajeac2,0,0,0)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		     end
		     if getPlayerMoney ( conductor ) <= 14 then			 
			outputChatBox ("No tienes dinero para pagar el peaje!", conductor, 255, 255, 255 )
						setElementRotation(puertapeajeac1,0,90,126.670166015625)
						setElementRotation(puertapeajeac2,0,-90,126.670166015625)
				end
end
end		
end
end
addEventHandler( "onMarkerHit", marketpeajeac, moveac )


puertapeajead1 = createObject ( 968, 2344.3662109375, 375.1611328125, 26.686999511719, 0, 90, 199.670166015625 )
puertapeajead2 = createObject ( 968, 2334.845703125, 371.640625, 26.586999511719, 0, -90, 199.670166015625 )
estadoad = 0
marketpeajead = createMarker(2338.58, 378.39, 26.8, 'cylinder', 8.0, 255, 0, 0, 0)

function movead ( thePlayer )
if estadoad == 0 then
local conductor = getVehicleOccupant ( thePlayer )
if ( conductor ) then
 if exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
 moveObject ( puertapeajead1, 1500, 2344.3662109375, 375.1611328125, 26.686999511719, 0, -90, 0 )
 moveObject ( puertapeajead2, 1500, 2334.845703125, 371.640625, 26.586999511719, 0, 90, 0 )
 exports.chat:me (conductor, "muestra su tarjeta de peajes")
setTimer (
            function ( )
                moveObject ( puertapeajead1, 1500, 2344.3662109375, 375.1611328125, 26.686999511719, 0, 90, 0 )
                moveObject ( puertapeajead2, 1500, 2334.845703125, 371.640625, 26.586999511719, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajead1 )
					if y ~= 0 then
						setElementRotation(puertapeajead1,0,0,0)
						setElementRotation(puertapeajead2,0,0,0)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		elseif not exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
         if getPlayerMoney ( conductor ) >= 15 then
		exports.chat:me (conductor, "paga el peaje")
		outputChatBox ("El peaje te ha costado $15", conductor, 255, 255, 255 )
		takePlayerMoney ( conductor, 15 )
        moveObject ( puertapeajead1, 1500, 2344.3662109375, 375.1611328125, 26.686999511719, 0, -90, 0 )
        moveObject ( puertapeajead2, 1500, 2334.845703125, 371.640625, 26.586999511719, 0, 90, 0 )
				setTimer (
            function ( )
                moveObject ( puertapeajead1, 1500, 2344.3662109375, 375.1611328125, 26.686999511719, 0, 90, 0 )
                moveObject ( puertapeajead2, 1500, 2334.845703125, 371.640625, 26.586999511719, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajead1 )
					if y ~= 0 then
						setElementRotation(puertapeajead1,0,0,0)
						setElementRotation(puertapeajead2,0,0,0)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		     end
		     if getPlayerMoney ( conductor ) <= 14 then			 
			outputChatBox ("No tienes dinero para pagar el peaje!", conductor, 255, 255, 255 )
						setElementRotation(puertapeajead1,0,90,199.670166015625)
						setElementRotation(puertapeajead2,0,-90,199.670166015625)
				end
end
end		
end
end
addEventHandler( "onMarkerHit", marketpeajead, movead )


-- Funcion sirenas peaje AA

markerpolipaa = createMarker(2332.93, 282.62, 26.32, 'cylinder', 15.0, 255, 0, 0, 0)

function polipeajeaa ( thePlayer )
	if not getElementData ( thePlayer, "sirenas" ) == true then
	return nil
	else
	exports.chat:me (thePlayer, "pasa rápidamente por tener las sirenas")
	triggerEvent ( "onPoliciaPeajeAA", thePlayer )
	end
end
addEventHandler( "onMarkerHit", markerpolipaa, polipeajeaa )

function moveaapolicia (source)
  exports.chat:me (source, "pasa rápidamente por tener las sirenas")
  moveObject ( puertapeajeaa1, 900, 2333.32, 288, 26.3, 0, 90, 0 )
  moveObject ( puertapeajeaa2, 900, 2333.32, 277.80, 26.3, 0, -90, 0 )
		setTimer (
            function ( )
                moveObject ( puertapeajeaa1, 900, 2333.32, 288, 26.3, 0, -90, 0 )
				moveObject ( puertapeajeaa2, 900, 2333.32, 277.80, 26.3, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeaa1 )
					if y ~= 0 then
						setElementRotation(puertapeajeaa1, 0, -90, 90)
						setElementRotation(puertapeajeaa2, 0, 90, 90)
					end
				end, 900, 1)
            end
            ,900,1
        )
end
addEvent( "onPoliciaPeajeAA", true )
addEventHandler( "onPoliciaPeajeAA", root, moveaapolicia )

-- Funcion sirenas peaje AA

-- Funcion sirenas peaje AB

markerpolipab = createMarker(2417.81, 296.45, 32.68, 'cylinder', 15.0, 255, 0, 0, 0)

function polipeajeab ( thePlayer )
	if not getElementData ( thePlayer, "sirenas" ) == true then
	return nil
	else
	exports.chat:me (thePlayer, "pasa rápidamente por tener las sirenas")
	triggerEvent ( "onPoliciaPeajeAB", thePlayer )
	end
end
addEventHandler( "onMarkerHit", markerpolipab, polipeajeab )

function moveabpolicia (source)
 exports.chat:me (source, "pasa rápidamente por tener las sirenas")
 moveObject ( puertapeajeab1, 900, 2416.91, 301.59, 32.7, 0, -90, 0 )
 moveObject ( puertapeajeab2, 900, 2419.1, 291.52, 32.69, 0, 90, 0 )
 setTimer (
            function ( )
                moveObject ( puertapeajeab1, 900, 2416.91, 301.59, 32.7, 0, 90, 0 )
				moveObject ( puertapeajeab2, 900, 2419.1, 291.52, 32.69, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeab1 )
					if y ~= 0 then
						setElementRotation(puertapeajeab1,0,0,0)
						setElementRotation(puertapeajeab2,0,0,0)
					end
				end, 900, 1)
            end
            ,900,1
        )
end
addEvent( "onPoliciaPeajeAB", true )
addEventHandler( "onPoliciaPeajeAB", root, moveabpolicia )

-- Funcion sirenas peaje AB


-- Funcion sirenas peaje AC

markerpolipac = createMarker(2401.22, 340.68, 32.74, 'cylinder', 15.0, 255, 0, 0, 0)

function polipeajeac ( thePlayer )
	if not getElementData ( thePlayer, "sirenas" ) == true then
	return nil
	else
	exports.chat:me (thePlayer, "pasa rápidamente por tener las sirenas")
	triggerEvent ( "onPoliciaPeajeAC", thePlayer )
	end
end
addEventHandler( "onMarkerHit", markerpolipac, polipeajeac )

function moveacpolicia (source)
 exports.chat:me (source, "pasa rápidamente por tener las sirenas")
 moveObject ( puertapeajeac1, 900, 2404.162109375, 337.546875, 32.8359375, 0, -90, 0 )
 moveObject ( puertapeajeac2, 900, 2397.744140625, 346.0009765625, 32.67185211181, 0, 90, 0 )
 setTimer (
            function ( )
                moveObject ( puertapeajeac1, 900, 2404.162109375, 337.546875, 32.8359375, 0, 90, 0 )
                moveObject ( puertapeajeac2, 900, 2397.744140625, 346.0009765625, 32.67185211181, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeac1 )
					if y ~= 0 then
						setElementRotation(puertapeajeac1,0,0,0)
						setElementRotation(puertapeajeac2,0,0,0)
					end
				end, 900, 1)
            end
            ,900,1
        )
end
addEvent( "onPoliciaPeajeAC", true )
addEventHandler( "onPoliciaPeajeAC", root, moveacpolicia )

-- Funcion sirenas peaje AC

-- Funcion sirenas peaje AD

markerpolipad = createMarker(2339.52, 372.91, 26.67, 'cylinder', 15.0, 255, 0, 0, 0)

function polipeajead ( thePlayer )
	if not getElementData ( thePlayer, "sirenas" ) == true then
	return nil
	else
	exports.chat:me (thePlayer, "pasa rápidamente por tener las sirenas")
	triggerEvent ( "onPoliciaPeajeAD", thePlayer )
	end
end
addEventHandler( "onMarkerHit", markerpolipad, polipeajead )

function moveadpolicia (source)
 exports.chat:me (source, "pasa rápidamente por tener las sirenas")
 moveObject ( puertapeajead1, 900, 2344.3662109375, 375.1611328125, 26.686999511719, 0, -90, 0 )
 moveObject ( puertapeajead2, 900, 2334.845703125, 371.640625, 26.586999511719, 0, 90, 0 )
setTimer (
            function ( )
                moveObject ( puertapeajead1, 900, 2344.3662109375, 375.1611328125, 26.686999511719, 0, 90, 0 )
                moveObject ( puertapeajead2, 900, 2334.845703125, 371.640625, 26.586999511719, 0, -90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajead1 )
					if y ~= 0 then
						setElementRotation(puertapeajead1,0,0,0)
						setElementRotation(puertapeajead2,0,0,0)
					end
				end, 900, 1)
            end
            ,900,1
        )
end
addEvent( "onPoliciaPeajeAD", true )
addEventHandler( "onPoliciaPeajeAD", root, moveadpolicia )

-- Funcion sirenas peaje AD



