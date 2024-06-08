puertapeajeb1a = createObject ( 968, 2581.6005859375, 34.2998046875, 26.39999961853, 0, 90, 90 )
markerpeajeba = createMarker(2576.833984375, 38.337890625, 26.3359375, 'cylinder', 4.5, 255, 0, 0, 1)
estateBa = 0


function moveba (thePlayer)
if estateBa == 0 then
local conductor = getVehicleOccupant ( thePlayer )
if ( conductor ) then
 if exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
  exports.chat:me (conductor, "muestra su tarjeta de peajes")
  moveObject ( puertapeajeb1a, 1500, 2581.6005859375, 34.2998046875, 26.39999961853, 0, -90, 0 )
		setTimer (
            function ( )
  moveObject ( puertapeajeb1a, 1500, 2581.6005859375, 34.2998046875, 26.39999961853, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeb1a )
					if y ~= 0 then
						setElementRotation(puertapeajeb1a, 0, 90, 90)
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
  moveObject ( puertapeajeb1a, 1500, 2581.6005859375, 34.2998046875, 26.39999961853, 0, -90, 0 )
				setTimer (
            function ( )
  moveObject ( puertapeajeb1a, 1500, 2581.6005859375, 34.2998046875, 26.39999961853, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeb1a )
					if y ~= 0 then
						setElementRotation(puertapeajeb1a, 0, 90, 90)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		     end
		     if getPlayerMoney ( conductor ) <= 14 then			 
			outputChatBox ("No tienes dinero para pagar el peaje!", conductor, 255, 255, 255 )
			setElementRotation(puertapeajeb1a, 0, 90, 90)
				end

end
end
end
end

addEventHandler( "onMarkerHit", markerpeajeba, moveba )

puertapeajeb1b = createObject ( 968, 2585.7998046875, 49, 26.39999961853, 0, 90, 270 )
markerpeajebb = createMarker(2589.806640625, 44.0322265625, 26.3359375, 'cylinder', 4.5, 255, 0, 0, 1)
estateBb = 0

function movebb (thePlayer)
if estateBb == 0 then
local conductor = getVehicleOccupant ( thePlayer )
if ( conductor ) then
 if exports.items:has( conductor, 22) and getElementData ( conductor, "sirenas" ) == false then
  exports.chat:me (conductor, "muestra su tarjeta de peajes")
  moveObject ( puertapeajeb1b, 1500, 2585.7998046875, 49, 26.39999961853, 0, -90, 0 )
		setTimer (
            function ( )
  moveObject ( puertapeajeb1b, 1500, 2585.7998046875, 49, 26.39999961853, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeb1b )
					if y ~= 0 then
						setElementRotation(puertapeajeb1b, 0, 90, 270)
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
  moveObject ( puertapeajeb1b, 1500, 2585.7998046875, 49, 26.39999961853, 0, -90, 0 )
				setTimer (
            function ( )
  moveObject ( puertapeajeb1b, 1500, 2585.7998046875, 49, 26.39999961853, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajea1a )
					if y ~= 0 then
						setElementRotation(puertapeajeb1b, 0, 90, 270)
					end
				end, 1500, 1)
            end
            ,1500,1
        )
		     end
		     if getPlayerMoney ( conductor ) <= 14 then			 
			outputChatBox ("No tienes dinero para pagar el peaje!", conductor, 255, 255, 255 )
			setElementRotation(puertapeajeb1b, 0, 90, 270)
				end

end
end
end
end

addEventHandler( "onMarkerHit", markerpeajebb, movebb )



-- Funcion sirenas peaje B1A

markerpolipba = createMarker( 2581.22, 38.6, 26.33, 'cylinder', 5.5, 255, 0, 0, 0)

function polipeajeba ( thePlayer )
	if not getElementData ( thePlayer, "sirenas" ) == true then
	return nil
	else
	exports.chat:me (thePlayer, "pasa rápidamente por tener las sirenas")
	triggerEvent ( "onPoliciaPeajeB1", thePlayer )
	end
end
addEventHandler( "onMarkerHit", markerpolipba, polipeajeba )

function movebapolicia (source)
  exports.chat:me (source, "pasa rápidamente por tener las sirenas")
  moveObject ( puertapeajeb1a, 650, 2581.6005859375, 34.2998046875, 26.39999961853, 0, -90, 0 )
		setTimer (
            function ( )
  moveObject ( puertapeajeb1a, 650, 2581.6005859375, 34.2998046875, 26.39999961853, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeb1a )
					if y ~= 0 then
						setElementRotation(puertapeajeb1a, 0, 90, 0)
					end
				end, 650, 1)
            end
            ,650,1
        )
end
addEvent( "onPoliciaPeajeB1", true )
addEventHandler( "onPoliciaPeajeB1", root, movebapolicia )

-- Funcion sirenas peaje B1A

-- Funcion sirenas peaje B2B

markerpolipbb = createMarker( 2586.17, 45.58, 26.33, 'cylinder', 5.5, 255, 0, 0, 0)

function polipeajebb ( thePlayer )
	if not getElementData ( thePlayer, "sirenas" ) == true then
	return nil
	else
	exports.chat:me (thePlayer, "pasa rápidamente por tener las sirenas")
	triggerEvent ( "onPoliciaPeajeB2", thePlayer )
	end
end

addEventHandler( "onMarkerHit", markerpolipbb, polipeajebb )

function movebbpolicia (source)
  exports.chat:me (source, "pasa rápidamente por tener las sirenas")
moveObject ( puertapeajeb1b, 650, 2585.7998046875, 49, 26.39999961853, 0, -90, 0 )
		setTimer (
            function ( )
  moveObject ( puertapeajeb1b, 650, 2585.7998046875, 49, 26.39999961853, 0, 90, 0 )
				setTimer (
				function ()
					local x,y,z = getElementRotation ( puertapeajeb1b )
					if y ~= 0 then
						setElementRotation(puertapeajeb1b, 0, 90, 270)
					end
				end, 650, 1)
            end
            ,650,1
        )
end
addEvent( "onPoliciaPeajeB2", true )
addEventHandler( "onPoliciaPeajeB2", root, movebbpolicia )

-- Funcion sirenas peaje B2B
