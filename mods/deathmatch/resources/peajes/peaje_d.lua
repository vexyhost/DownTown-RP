puertapeajed1a = createObject ( 968, -595.06990000000, 641.78692626953, 16.30000038147, 0, 90, 65.40000038147 )
markerpeajeda = createMarker(-589.728515625, 642.94921875, 16.72034072876, 'cylinder', 4.5, 255, 0, 0, 1)
estateDa = 0


function moveda (thePlayer)
if estateDa == 0 then
local conductor = getVehicleOccupant ( thePlayer )
if ( conductor ) then
 if exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
  exports.chat:me (conductor, "muestra su tarjeta de peajes")
  moveObject ( puertapeajed1a, 1500, -595.06990000000, 641.78692626953, 16.30000038147, 0, -90, 0 )
		setTimer (
            function ( )
  moveObject ( puertapeajed1a, 1500, -595.06990000000, 641.78692626953, 16.30000038147, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajed1a )
					if y ~= 0 then
						setElementRotation(puertapeajed1a, 0, 90, 65.40000038147)
					end
				end, 2500, 1)
            end
            ,2500,1
        )
		elseif not exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
         if getPlayerMoney ( conductor ) >= 15 then
		exports.chat:me (conductor, "paga el peaje")
		outputChatBox ("El peaje te ha costado $15", conductor, 255, 255, 255 )
		takePlayerMoney ( conductor, 15 )
  moveObject ( puertapeajed1a, 1500, -595.06990000000, 641.78692626953, 16.30000038147, 0, -90, 0 )
				setTimer (
            function ( )
  moveObject ( puertapeajed1a, 1500, -595.06990000000, 641.78692626953, 16.30000038147, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajed1a )
					if y ~= 0 then
						setElementRotation(puertapeajed1a, 0, 90, 65.40000038147)
					end
				end, 2500, 1)
            end
            ,2500,1
        )
		end
		     if getPlayerMoney ( conductor ) <= 14 then			 
			outputChatBox ("No tienes dinero para pagar el peaje!", conductor, 255, 255, 255 )
			setElementRotation(puertapeajed1a, 0, 90, 65.40000038147)
				end
end
end
end
end

addEventHandler( "onMarkerHit", markerpeajeda, moveda )

puertapeajed1b = createObject ( 968, -599.1279296875, 633.92578125, 16.30000038147, 0, 90, 246.51831054688 )
markerpeajedb = createMarker(-605.7939453125, 633.2587890625, 16.639162063599, 'cylinder', 4.5, 255, 0, 0, 1)
estateDb = 0

function movedb (thePlayer)
if estateDb == 0 then
local conductor = getVehicleOccupant ( thePlayer )
if ( conductor ) then
 if exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
  exports.chat:me (conductor, "muestra su tarjeta de peajes")
  moveObject ( puertapeajed1b, 1500, -599.1279296875, 633.92578125, 16.30000038147, 0, -90, 0 )
		setTimer (
            function ( )
  moveObject ( puertapeajed1b, 1500, -599.1279296875, 633.92578125, 16.30000038147, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajed1b )
					if y ~= 0 then
						setElementRotation(puertapeajed1b, 0, 90, 246.51831054688)
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
  moveObject ( puertapeajed1b, 1500, -599.1279296875, 633.92578125, 16.30000038147, 0, -90, 0 )
				setTimer (
            function ( )
  moveObject ( puertapeajed1b, 1500, -599.1279296875, 633.92578125, 16.30000038147, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajed1b )
					if y ~= 0 then
						setElementRotation(puertapeajed1b, 0, 90, 246.51831054688)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		     end
		     if getPlayerMoney ( conductor ) <= 14 then			 
			outputChatBox ("No tienes dinero para pagar el peaje!", conductor, 255, 255, 255 )
			setElementRotation(puertapeajed1b, 0, 90, 246.51831054688)
				end

end
end
end
end

addEventHandler( "onMarkerHit", markerpeajedb, movedb )



-- Funcion sirenas peaje D1A

markerpolipda = createMarker( -589.728515625, 642.94921875, 16.72034072876, 'cylinder', 5.5, 255, 0, 0, 0)

function polipeajeda ( thePlayer )
	if not getElementData ( thePlayer, "sirenas" ) == true then
	return nil
	else
	exports.chat:me (thePlayer, "pasa rápidamente por tener las sirenas")
	triggerEvent ( "onPoliciaPeajeD1", thePlayer )
	end
end
addEventHandler( "onMarkerHit", markerpolipda, polipeajeda )

function movedapolicia (source)
  exports.chat:me (source, "pasa rápidamente por tener las sirenas")
moveObject ( puertapeajed1a, 650, -595.06990000000, 641.78692626953, 16.30000038147, 0, -90, 0 )
		setTimer (
            function ( )
  moveObject ( puertapeajed1a, 650, -595.06990000000, 641.78692626953, 16.30000038147, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajed1a )
					if y ~= 0 then
						setElementRotation(puertapeajed1a, 0, 90, 65.40000038147)
					end
				end, 2500, 1)
            end
            ,2500,1
        )
end
addEvent( "onPoliciaPeajeD1", true )
addEventHandler( "onPoliciaPeajeD1", root, movedapolicia )

-- Funcion sirenas peaje D1A

-- Funcion sirenas peaje D2B

markerpolipdb = createMarker( -605.7939453125, 633.2587890625, 16.639162063599, 'cylinder', 5.5, 255, 0, 0, 0)

function polipeajedb ( thePlayer )
	if not getElementData ( thePlayer, "sirenas" ) == true then
	return nil
	else
	exports.chat:me (thePlayer, "pasa rápidamente por tener las sirenas")
	triggerEvent ( "onPoliciaPeajeD2", thePlayer )
	end
end

addEventHandler( "onMarkerHit", markerpolipdb, polipeajedb )

function movedbpolicia (source)
  exports.chat:me (source, "pasa rápidamente por tener las sirenas")
moveObject ( puertapeajed1b, 650, -599.1279296875, 633.92578125, 16.30000038147, 0, -90, 0 )
		setTimer (
            function ( )
  moveObject ( puertapeajed1b, 650, -599.1279296875, 633.92578125, 16.30000038147, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajed1b )
					if y ~= 0 then
						setElementRotation(puertapeajed1b, 0, 90, 246.51831054688)
					end
				end, 2500, 1)
            end
            ,2500,1
        )
end
addEvent( "onPoliciaPeajeD2", true )
addEventHandler( "onPoliciaPeajeD2", root, movedbpolicia )

-- Funcion sirenas peaje D2B
