local weather
local nextWeather
local laterWeather
local delay = 1
local delay2 = 1

-- Function run on resource start to set the weather to a particular type
function startWeather(resource)
	-- tempoarily set the weather to cloudy
	setWeather(10)
	
	local choice = math.random(1, 3)
		 
		 -- On server startup, set the weather to a certain type, use the delay variable since its pointless creating a new one.
		if(choice==1) then
			weather = "clear"
		elseif(choice ==2 ) then
			weather = "hot"
		elseif(choice == 3) then
			weather = "cloudy"
		elseif(choice ==4) then
			weather = "rain"
		else
			weather = "fog"
		end
		
	-- trigger event to select the next best weather type
	triggerEvent("onChangeLaterWeatherType", getRootElement())
	triggerEvent("onChangeNextWeatherType", getRootElement())
	triggerEvent("onChangeWeatherType", getRootElement())
	-- trigger event to blend into the weather ID
	setTimer( triggerEvent, 200, 1, "onChangeWeather", getRootElement() )
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), startWeather)



-- Function changes the weather type currently being used, and updates the weather
function changeWeatherType()
	
	local rand = math.random(1, 10) -- Pick a random number
				
	-- if prediced weather is clear, change next weather
	if(nextWeather == "clear") then
		
		if(rand < 9) then -- 80% chance of it staying clear
			weather = "clear"
		else
			weather = "cloudy"
		end
	
	elseif(nextWeather == "hot") then
	
		if(rand < 8) then -- 70% chance of hot
			weather = "hot"
		elseif(rand == 8 or rand == 9)  then-- 20% chance of clear
			weather = "clear" 
		else					-- 10% chance of cloud
			weather = "cloudy"
		end	
	
	elseif(nextWeather == "cloudy") then
		
		if(rand < 8) then -- 70% chance of cloud
			weather = "cloudy"
		elseif(rand == 8 or rand == 9) then-- 20% chance of clear
			weather = "clear" 
		else					-- 10% chance of rain
			weather = "rain"
		end
		
	elseif(nextWeather == "rain") then
		
		if(rand < 9) then -- 80% chance of rain
			weather = "rain"
		elseif(rand == 8 ) then-- 10% chance of cloud
			weather = "cloudy" 
		else					-- 10% chance of cloud
			weather = "fog"
		end
	
	elseif(nextWeather == "fog" )then
	
		if(rand < 9) then -- 80% chance of fog
			weather = "fog"
		elseif(rand == 8 ) then-- 10% chance of cloud
			weather = "cloudy" 
		else					-- 10% chance of rain
			weather = "rain"
		end
	
	end
	
	local realtime = getRealTime() -- Get the current time since the weather will depend on the time of day
	
	local latertime = realtime.hour
	
	-- Now we have what we want the next weather type to be, but we need to check that this fits in with the time of day.
	if(latertime > 17 or latertime < 9) then  -- if it is night time, and the weater is hot, set it to clear
		if(weather == "hot") then
			weather= "clear"
		end
	end
	
	
	-- We don't want it to be foggy during the day
	if(latertime > 7 and latertime < 20) then
		if(weather == "fog") then
			weather = "cloudy"
		end
	end
	
	delay2 = math.random(-30, 30)
end
addEvent ( "onChangeWeatherType", true )
addEventHandler ( "onChangeWeatherType", getRootElement(), changeWeatherType )



-- function changes the next weather, based on the current weather
function changeNextWeatherType()

	local rand = math.random(1, 10)
	
	-- if prediced weather is clear, change next weather
	if(laterWeather == "clear") then
		
		if(rand < 9) then -- 80% chance of it staying clear
			nextWeather = "clear"
		else	
			nextWeather = "cloudy"
		end
	
	elseif(laterWeather == "hot") then
	
		if(rand < 8) then -- 70% chance of hot
			nextWeather = "hot"
		elseif(rand == 8 or rand == 9) then -- 20% chance of clear
			nextWeather = "clear" 
		else					-- 10% chance of cloud
			nextWeather = "cloudy"
		end
	
	elseif(laterWeather == "cloudy") then
		
		if(rand < 8) then -- 70% chance of cloud
			nextWeather = "cloudy"
		elseif(rand == 8 or rand == 9) then -- 20% chance of clear
			nextWeather = "clear" 
		else					-- 10% chance of rain
			nextWeather = "rain"
		end
		
	elseif(laterWeather == "rain") then
		
		if(rand < 9) then -- 80% chance of rain
			nextWeather = "rain"
		elseif(rand == 8 ) then-- 10% chance of cloud
			nextWeather = "cloudy" 
		else					-- 10% chance of cloud
			nextWeather = "fog"
		end
	
	elseif(laterWeather == "fog" )then
	
		if(rand < 9) then -- 80% chance of fog
			nextWeather = "fog"
		elseif(rand == 8 ) then -- 10% chance of cloud
			nextWeather = "cloudy" 
		else					-- 10% chance of rain
			nextWeather = "rain"
		end
	
	end
	
	local realtime = getRealTime() -- Get the current time since the weather will depend on the time of day
				
	local latertime = realtime.hour + 2
	
	-- Now we have what we want the next weather type to be, but we need to check that this fits in with the time of day.
	if(latertime > 17 or latertime < 9) then  -- if it is night time, and the weater is hot, set it to clear
		if(nextWeather == "hot") then
			nextWeather= "clear"
		end
	end
	
		
	-- We don't want it to be foggy during the day
	if(latertime > 7 and latertime < 20) then
		if(nextWeather == "fog") then
			nextWeather = "cloudy"
		end
	end
end
addEvent ( "onChangeNextWeatherType", true )
addEventHandler ( "onChangeNextWeatherType", getRootElement(), changeNextWeatherType )


-- function changes the later weather, based on the current weather
function changeLaterWeatherType()

	local rand = math.random(1, 10)

	-- if it is currently clear or hot
	if(weather == "clear" or weather == "hot") then-- If the weather is sunny or very hot
			
		if(rand < 4) then -- 30% chance of clear
			laterWeather = "clear"
		elseif(rand == 5 or rand == 6 or rand ==7) then
			laterWeather= "hot" -- 30% chance of hot
		else
			laterWeather = "cloudy" -- 40% chance of clouds
		end
	-- If weather is currently cloudy
	elseif(weather == "cloudy") then 
			
		if(rand < 6) then -- 50% chance of it turning clear
			laterWeather = "clear"
		elseif(rand == 6 or rand == 7) then -- 20% chance of rain
			laterWeather= "rain"
		elseif(rand == 8) then		-- 10% chance of fog
			laterWeather = "fog"
		else
			laterWeather = "cloudy"	-- 20% chance of more clouds
		end
			
	-- if the wather ic currently raining
	elseif(weather == "rain") then -- if it is raining
			
		if(rand < 3) then -- 20% chance of rain again
			laterWeather = "rain"
		elseif(rand == 3 or rand == 4 or rand == 5 or rand == 6 or rand == 7 or  rand == 8) then
			laterWeather = "cloudy" -- 60% chance of clouds
		else
			laterWeather = "fog" -- 20% chance of fog
		end
			
	-- if it is currently foggy
	elseif(weather == "fog") then -- if its foggy
			
		if(rand < 3) then -- 20% chance of rain
			laterWeather = "rain"
		elseif(rand > 3 ) then -- 70% chance of clouds
			laterWeather = "cloudy"
		else		-- 10% chance of more fog
			laterWeather = "fog"
		end
		
	end
	
	local realtime = getRealTime() -- Get the current time since the weather will depend on the time of day
				
	local latertime = realtime.hour + 4
	
		-- Now we have what we want the next weather type to be, but we need to check that this fits in with the time of day.
		if(latertime > 17 or latertime < 9) then  -- if it is night time, and the weater is hot, set it to clear
			if(laterWeather == "hot") then
				laterWeather= "clear"
			end
		end

		
		-- We don't want it to be foggy during the day
		if(latertime > 7 and latertime < 20) then
			if(laterWeather == "fog") then
				laterWeather = "cloudy"
			end
		end
end
addEvent ( "onChangeLaterWeatherType", true )
addEventHandler ( "onChangeLaterWeatherType", getRootElement(), changeLaterWeatherType )


-- Function looks to see what the current weather type is, and then chooses a weather from that category
function changeWeather()

	local scrap, blend = getWeather()
	
	local ID

	-- check what type the weather is currently in, and then choose a new weather from the categories
	-- If the weater type is clear
		if(weather == "clear") then
		
			rand = math.random(0, 8) 
			
			-- Equal chances of all types of clear weather
			if(rand < 8) then
				ID = rand
			else
				ID = 10
			end
		
		-- If the weather is hot, then....
		elseif(weather == "hot") then
			rand = math.random(16, 18)
			
			-- equal chance of either of the 2 hot weathers happening
			if(rand > 16) then
				ID= rand
			else
				ID = 11
			end
		
		-- If it is raining, equal chance of it being the 2 different types of rain
		elseif(weather == "rain") then
			rand = math.random(8, 9)
			
			if(rand ==8) then
				ID = rand
			else
				ID = 16
			end
		
		--- if it is cloudy, equal chance of all the different cloud weathers
		elseif(weather == "cloudy") then
		
			rand = math.random(12, 15)
			ID = rand
			
		--- if it is cloudy, equal chance of all the different cloud weathers
		elseif(weather == "fog") then
			ID = 9
			
		end

		-- Blend into the new weather
		setWeather(ID)
		local players = getElementsByType("player")
		for k, thePlayer in ipairs(players) do
			triggerClientEvent("onServerChangesWeather", getRootElement(), ID)
		end
		
		-- Set the delay variable for the next time
		delay = math.random(-15, 15)
end
addEvent ( "onChangeWeather", true )
addEventHandler ( "onChangeWeather", getRootElement(), changeWeather )

-- function returns the current weather type
function getWeatherType(thePlayer)
	outputChatBox("Tiempo actual: "..weather, thePlayer)
end
--addCommandHandler("getweather", getWeatherType)
addEvent("getWeatherType", true)
addEventHandler ( "getWeatherType", getRootElement(), getWeatherType )

-- function sets the weather to a certain type
function setWeatherType(thePlayer, command)
	if ( hasObjectPermissionTo ( thePlayer, "command.kick", false ) ) then
		triggerClientEvent ( thePlayer, "onCreateWeatherControlGUI", thePlayer, weather )
	end
end
addCommandHandler("clima", setWeatherType)


function manualChangeWeatherType(thePlayer, weathertype)
	
	if (weathertype == "clear" or 
	weathertype == "hot" or 
	weathertype == "rain" or 
	weathertype == "cloudy" or 
	weathertype == "fog" ) then
	
		weather = weathertype
		changeNextWeatherType()
		changeLaterWeatherType()

		changeWeather()
	
		outputChatBox("Has cambiado el clima a: "..weathertype, thePlayer, 0, 255, 0, true)
		
	else
		outputChatBox("Invalid weather type given", thePlayer, 255, 0,0 , true)
		outputChatBox("Valid weather is: clear, hot, rain, cloudy or fog", thePlayer)
	end
end
addEvent ( "onManualChangeWeatherType", true )
addEventHandler("onManualChangeWeatherType", getRootElement() , manualChangeWeatherType )


-- function sets the weather to a certain type
function showForecast(thePlayer, command)
	if exports.players:isLoggedIn(thePlayer) then
		if ( hasObjectPermissionTo ( thePlayer, "command.kick", false ) ) or exports.factions:isPlayerInFaction(thePlayer, 4) then
			triggerClientEvent ( thePlayer, "onCreateWeatherForecastGUI", thePlayer, weather , nextWeather , laterWeather )
		else
			outputChatBox("No puedes usar ese comando!", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("prevision", showForecast)


-- Timers to change the weather every so often. Change the weather every 30 mins +- 15 mins
setTimer(changeWeather, 600*60*1000 + (delay*1000*60), 0) 
-- Change the weater type every 2 hours +- 45 mins.
setTimer(function()
changeWeatherType()
changeNextWeatherType()
changeLaterWeatherType()
end , 1200*60*1000 + (delay2*1000*60) , 0)

addEvent( "requestCurrentWeather", true )
addEventHandler( "requestCurrentWeather", getRootElement( ),
	function( )
		triggerClientEvent(source, "onServerChangesWeather", getRootElement(), getWeather())
	end
)