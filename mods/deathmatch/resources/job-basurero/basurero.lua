--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

local vehicles = { "Trashmaster" } -- load the civilian vehicles that'll automatically trigger the delivery mission if being entered
local max_earnings = 2
local delay = 3

-- put it in a for us better format
local vehicles2 = { }
for key, value in ipairs( vehicles ) do
	local model = getVehicleModelFromName( value )
	if model then
		vehicles2[ model ] = true
	else
		outputDebugString( "Vehicle '" .. tostring( value ) .. " does not exist." )
	end
end
vehicles = vehicles2
vehicles2 = nil

local function isJobVehicle( vehicle )
	return vehicle and vehicles[ getElementModel( vehicle ) ] and not exports.vehicles:getOwner( vehicle ) or false
end

--

local p = { }

local function advanceRoute( player, earnings )
	if p[ player ] and p[ player ].route and p[ player ].checkpoint then
		local cp = p[ player ].checkpoint + 1
		local c = p[ player ].route[ cp ]
		local n = p[ player ].route[ cp + 1 ]
		if c then
			if p[ player ].route[ p[ player ].checkpoint ] then
				if p[ player ].route[ p[ player ].checkpoint ].stop and earnings and earnings > 0 then
					exports.players:giveMoney( player, earnings )
				end
				
				if p[ player ].route[ p[ player ].checkpoint ].hint then
					triggerClientEvent( player, "gui:hint", player, "Tu trabajo: Basurero", p[ player ].route[ p[ player ].checkpoint ].hint )
				end
			end
			
			if not n then
				-- last checkpoint
				triggerClientEvent( player, getResourceName( resource ) .. ":set", player, c.x, c.y, c.z, c.stop and true )
				exports.objetivos:addObjetivo(7, exports.players:getCharacterID(player), player)
			else
				triggerClientEvent( player, getResourceName( resource ) .. ":set", player, c.x, c.y, c.z, c.stop and true, n.x, n.y, n.z, n.stop and true )
			end
		else
			if earnings then
				exports.players:giveMoney( player, earnings )
			end
			triggerClientEvent( player, getResourceName( resource ) .. ":set", player )
			p[ player ] = nil
			return false
		end
		p[ player ].checkpoint = cp
		return true
	end
end

local function newRoute( player )
	p[ player ].vehicleOnResourceStart = nil
	local route = math.random( #routes )
	p[ player ].route = routes[ route ]
	p[ player ].checkpoint = 0
	
	advanceRoute( player )
end

addEventHandler( "onVehicleEnter", root,
	function( player, seat )
		if seat == 0 and isJobVehicle( source ) then
			if not p[ player ] then
				p[ player ] = { }
			end
			
			if not p[ player ].route then
				newRoute( player )
			else
				triggerClientEvent( player, getResourceName( resource ) .. ":show", player )
			end
		end
	end
)

--

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		if not routes or routes == 0 then
			cancelEvent( )
			return
		end
		
		--
		
		setElementData( resourceRoot, "delay", delay )
		
		--
		
		for key, value in ipairs( getElementsByType( "player" ) ) do
			local vehicle = getPedOccupiedVehicle( value )
			if vehicle and getPedOccupiedVehicleSeat( value ) == 0 and isJobVehicle( vehicle ) then
				p[ value ] = { vehicleOnResourceStart = vehicle }
			end
		end
		
		setTimer(
			function( )
				for key, value in pairs( p ) do
					p[ key ].vehicleOnResourceStart = nil
				end
			end, 10000, 1
		)
	end
)

addEvent( getResourceName( resource ) .. ":ready", true )
addEventHandler( getResourceName( resource ) .. ":ready", root,
	function( )
		if source == client then
			if p[ source ] and getPedOccupiedVehicle( source ) == p[ source ].vehicleOnResourceStart and getPedOccupiedVehicleSeat( source ) == 0 then
				newRoute( source )
			end
		end
	end
)

--

addEvent( getResourceName( resource ) .. ":complete", true )
addEventHandler( getResourceName( resource ) .. ":complete", root,
	function( )
		if source == client then
			local vehicle = getPedOccupiedVehicle( source )
			if p[ source ] and p[ source ].route and isJobVehicle( vehicle ) and getPedOccupiedVehicleSeat( source ) == 0 then
				-- distance check
				if not p[ source ].route[ p[ source ].checkpoint ].stop or getDistanceBetweenPoints2D( p[ source ].route[ p[ source ].checkpoint ].x, p[ source ].route[ p[ source ].checkpoint ].y, getElementPosition( vehicle ) ) < 5 then
					local health = math.min( 1000, getElementHealth( vehicle ) )
					if health > 350 then
						-- calculate earnings based on vehicle health
						local earnings = p[ source ].route[ p[ source ].checkpoint ].stop and math.ceil( ( health - 350 ) / 650 * max_earnings ) or 0
						
						-- get a checkpoint
						advanceRoute( source, earnings )
					end
				end
			end
		end
	end
)

addEventHandler( "onCharacterLogout", root,
	function( )
		if p[ source ] and p[ source ].route then
			triggerClientEvent( source, getResourceName( resource ) .. ":set", source )
		end
		p[ source ] = nil
	end
)

addEventHandler( "onPlayerQuit", root,
	function( )
		p[ source ] = nil
	end
)

--

addEventHandler( "onVehicleStartEnter", root,
	function( player, seat )
		if seat == 0 and isJobVehicle( source ) and "job-" .. tostring( exports.players:getJob( player ) ) ~= getResourceName( resource ) and not getElementData(source, "account:gmduty") == true then
			outputChatBox( "(( No tienes este trabajo. Acercate al bot del trabajo. ))", player, 255, 0, 0 )
			cancelEvent( )
		end
	end
)

--

function introduce( player )
	triggerClientEvent( player, getResourceName( resource ) .. ":introduce", player )
end

local PedBasurero = nil

local function createPedBasurero( )
	if PedBasurero then
		destroyElement( PedBasurero )
	end
	PedBasurero = createPed( 16, -1822.9365234375, 114.5126953125, 15.1171875, 0, false )
	setElementData( PedBasurero, "npcname", "Tino Svenson" )
	setElementRotation(PedBasurero,0,0,90)
	setTimer(setElementFrozen, 2000, 1, PedBasurero, true)
end

addEventHandler( "onPedWasted", resourceRoot, createPedBasurero )
addEventHandler( "onResourceStart", resourceRoot, createPedBasurero )

function desbugBot(player)
	setElementPosition(PedBasurero, -1822.9365234375, 114.5126953125, 15.1171875)
end
--addCommandHandler("rbot", desbugBot)

addEventHandler( "onElementClicked", resourceRoot,
	function( button, state, player )
		if button == "left" and state == "up" then
			local x, y, z = getElementPosition( player )
			if getDistanceBetweenPoints3D( x, y, z, getElementPosition( source ) ) < 5 and getElementDimension( player ) == getElementDimension( source ) and source == PedBasurero then
				triggerClientEvent("onAbrirJob", player, "basurero")
			end
		end
	end
)