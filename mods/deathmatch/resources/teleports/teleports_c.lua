local localPlayer = getLocalPlayer( )
local pickups = { }

local function destroy( colshape )
	if pickups[ colshape ] then
		destroyElement( pickups[ colshape ].pickup )
		pickups[ colshape ] = nil
	end
end
                      
addEventHandler( "onClientRender", getRootElement( ),
	function( )
		local cx, cy, cz = getCameraMatrix( )
		local dimension = getElementDimension( localPlayer )
		for key, colshape in ipairs ( getElementsByType( "colshape", resourceRoot ) ) do
			if getElementDimension( colshape ) == dimension then
				local px, py, pz = getElementPosition( colshape )
				local distance = getDistanceBetweenPoints3D( px, py, pz, cx, cy, cz )
				if distance <= 17.5 then
					if not pickups[ colshape ] then
						pickup = createPickup( px, py, pz, 3, 1318 )
						setElementInterior( pickup, getElementInterior( localPlayer ) )
						setElementDimension( pickup, dimension ) 
						
						pickups[ colshape ] = { pickup = pickup }  
					end
						local text = getElementData( colshape, "name" )
						if text and text ~= "false" then
							local sx, sy = getScreenFromWorldPosition( px, py, pz + 0.6 )
								if sx and sy then
									local width = dxGetTextWidth( tostring( text ) )
									local height =  dxGetFontHeight( )
									-- if tostring(text) == "Puerta de emergencia Medical Department" then
										-- outputDebugString(dxGetTextWidth( tostring( text ) ))
									-- end
									dxDrawRectangle( sx - width, sy - height, width+(width*15/234), height*2, tocolor( 0, 0, 0, 200 ) )							
									dxDrawText( tostring( text ), sx-220, sy, sx, sy, tocolor( 255, 255, 255, 255 ), 1, "default", "center", "center" )
								end
						end
					
				else
					destroy( colshape )
				end
			else
				destroy( colshape )
			end
		end
	end
)

addEventHandler( "onClientElementDestroy", resourceRoot,
	function( )
		destroy( source )
	end
)