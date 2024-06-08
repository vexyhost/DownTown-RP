-- Weather system for Concrete Jungle Roleplay, written by Peter Gibbons (aka. Jason) on 16/08/08 --


function createWeatherGUI(weather)
	
	local X = 0.35
		local Y = 0.35
		local Width = 0.3
		local Height = 0.3
	
		guiWeather = guiCreateWindow(X, Y, Width, Height, "Control del tiempo", true)

	if(weather == "cloudy") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "cloudy.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Tiempo actual: Nuboso", true, guiWeather )
	elseif(weather == "clear") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "clear.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Tiempo actual: Despejado", true, guiWeather )
	elseif(weather == "hot") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "hot.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Tiempo actual: Caluroso", true, guiWeather )
	elseif(weather == "rain") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "rain.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Tiempo actual: Lluvia", true, guiWeather )
	elseif(weather == "fog") then
		guiWeatherImage =   guiCreateStaticImage( 0.3 , 0.1, 0.4 , 0.4, "foggy.png", true, guiWeather )
		guiWeatherNowLabel =  guiCreateLabel  ( 0.25 , 0.5, 0.5, 0.1, "Tiempo actual: Niebla", true, guiWeather )
	end             

	guiLabelSetHorizontalAlign ( guiWeatherNowLabel , "center")
	
	guiWeatherLable =  guiCreateLabel  ( 0.05 , 0.6, 1, 0.1, "Haz click en uno de los botones para cambiar el tiempo:", true, guiWeather )
	
	HotButton = guiCreateButton( 0.05, 0.72, 0.15, 0.1, "Caluroso", true, guiWeather )
	ClearButton = guiCreateButton( 0.23, 0.72, 0.15, 0.1, "Despejado", true, guiWeather )
	CloudyButton = guiCreateButton( 0.41, 0.72, 0.15, 0.1, "Nuboso", true, guiWeather )
	FogButton = guiCreateButton( 0.59, 0.72, 0.15, 0.1, "Niebla", true, guiWeather )
	RainButton = guiCreateButton( 0.77, 0.72, 0.15, 0.1, "Lluvia", true, guiWeather )
	
	ExitButton = guiCreateButton( 0.4, 0.85, 0.2, 0.1, "Cerrar", true, guiWeather )
	guiLabelSetHorizontalAlign ( ExitButton , "center")
	
	addEventHandler ( "onClientGUIClick", HotButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(), getLocalPlayer(),"hot" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	addEventHandler ( "onClientGUIClick", ClearButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(), getLocalPlayer(), "clear" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	addEventHandler ( "onClientGUIClick", CloudyButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(),getLocalPlayer(),"cloudy" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	addEventHandler ( "onClientGUIClick", FogButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(),getLocalPlayer(),"fog" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	addEventHandler ( "onClientGUIClick", RainButton,  function() triggerServerEvent ( "onManualChangeWeatherType", getLocalPlayer(),getLocalPlayer(),"rain" )  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	
	addEventHandler ( "onClientGUIClick", ExitButton,  function()  guiSetInputEnabled ( false )  guiSetVisible(guiWeather, false ) end ,false)
	
	guiSetVisible(guiWeather, false)
	
end



function showWeatherControlGUI( weather)

	if(source == getLocalPlayer()) then
		createWeatherGUI(weather)
		guiSetInputEnabled ( true )
		guiSetVisible(guiWeather, true)
	end
		
end
addEvent ( "onCreateWeatherControlGUI", true )
addEventHandler("onCreateWeatherControlGUI", getLocalPlayer(), showWeatherControlGUI )




function createWeatherForecaseGUI(weather, nextWeather, laterWeather)
	local X = 0.35
	local Y = 0.35
	local Width = 0.3
	local Height = 0.3
	
	guiWeatherForecast = guiCreateWindow(X, Y, Width, Height, "Previsión meteorológica", true)
	
	guiWeatherForcecastTab = guiCreateTabPanel ( 0, 0.09, 1, 0.91 ,true,guiWeatherForecast )
	
	guiWeatherCurrentTab =  guiCreateTab ( "Current", guiWeatherForcecastTab )
	
	guiWeatherForcastNowLable = guiCreateLabel  ( 0.07 , 0.07, 0.5, 0.1, "Tiempo:", true, guiWeatherCurrentTab )
		
		if(weather == "cloudy") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "cloudy.png", true, guiWeatherCurrentTab )
			guiWeatherForecastNowLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Nuboso", true, guiWeatherCurrentTab )
		elseif(weather == "clear") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "clear.png", true, guiWeatherCurrentTab)
			guiWeatherForecastNowLabel  =  guiCreateLabel  ( 0.2 , 0.7, 0.6, 0.1, "Soleado", true, guiWeatherCurrentTab)
		elseif(weather == "hot") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "hot.png", true, guiWeatherCurrentTab )
			guiWeatherForecastNowLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Caluroso", true, guiWeatherCurrentTab )
		elseif(weather == "rain") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "rain.png", true, guiWeatherCurrentTab )
			guiWeatherForecastNowLabel  =  guiCreateLabel  ( 0.2 , 0.7, 0.6, 0.1, "Tormenta", true, guiWeatherCurrentTab )

		elseif(weather == "fog") then
			guiWeatherForecastNowImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "foggy.png", true, guiWeatherCurrentTab)
			guiWeatherForecastNowLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Niebla espesa", true, guiWeatherCurrentTab)
			
		end

		guiLabelSetHorizontalAlign (guiWeatherForecastNowLabel  , "center")
		
		guiWeatherForecastNowBack = guiCreateButton( 0.4, 0.85, 0.2, 0.1, "Cerrar", true, guiWeatherCurrentTab )
		addEventHandler ( "onClientGUIClick", guiWeatherForecastNowBack,  function()  guiSetInputEnabled ( false )  guiSetVisible( guiWeatherForecast, false ) end ,false)
		
	guiWeatherNextTab = guiCreateTab ( "Next" , guiWeatherForcecastTab)
		
		guiWeatherForcastNextLable = guiCreateLabel  ( 0.07 , 0.07, 0.8, 0.1, "En las próximas dos horas:", true, guiWeatherNextTab )
		
		if(nextWeather == "cloudy") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "cloudy.png", true, guiWeatherNextTab )
			guiWeatherForecastNextLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Nuboso", true, guiWeatherNextTab )
		elseif(nextWeather == "clear") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "clear.png", true, guiWeatherNextTab)
			guiWeatherForecastNextLabel   =  guiCreateLabel  ( 0.2 , 0.7, 0.6, 0.1, "Soleado", true, guiWeatherNextTab)
		elseif(nextWeather == "hot") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "hot.png", true, guiWeatherNextTab)
			guiWeatherForecastNextLabel  =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Caluroso", true, guiWeatherNextTab)
		elseif(nextWeather == "rain") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "rain.png", true, guiWeatherNextTab)
			guiWeatherForecastNextLabel   =  guiCreateLabel  ( 0.25 , 0.7, 0.5, 0.1, "Tormenta", true, guiWeatherNextTab )
		elseif(nextWeather == "fog") then
			guiWeatherForecastNextImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "foggy.png", true,guiWeatherNextTab)
			guiWeatherForecastNextLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Niebla espesa", true, guiWeatherNextTab)
			
		end

		guiLabelSetHorizontalAlign (guiWeatherForecastNextLabel  , "center")
		
		guiWeatherForecastNextBack = guiCreateButton( 0.4, 0.85, 0.2, 0.1, "Cerrar", true, guiWeatherNextTab)
		addEventHandler ( "onClientGUIClick", guiWeatherForecastNextBack,  function()  guiSetInputEnabled ( false )  guiSetVisible( guiWeatherForecast, false ) end ,false)
	
	
	guiWeatherLaterTab = guiCreateTab ( "Later", guiWeatherForcecastTab)
	
		guiWeatherForcastLaterLable = guiCreateLabel  ( 0.07 , 0.07, 0.8, 0.1, "En 4 horas o más:", true, guiWeatherLaterTab )
		
		if(laterWeather == "cloudy") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "cloudy.png", true, guiWeatherLaterTab )
			guiWeatherForecastLastLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Nuboso", true, guiWeatherLaterTab)
		elseif(laterWeather  == "clear") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "clear.png", true, guiWeatherLaterTab)
			guiWeatherForecastLastLabel  =  guiCreateLabel  ( 0.2 , 0.7, 0.6, 0.1, "Soleado", true, guiWeatherLaterTab)
		elseif(laterWeather == "hot") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "hot.png", true, guiWeatherLaterTab)
			guiWeatherForecastLastLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Caluroso", true, guiWeatherLaterTab)
		elseif(laterWeather  == "rain") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "rain.png", true, guiWeatherLaterTab)
			guiWeatherForecastLastLabel   =  guiCreateLabel  ( 0.25 , 0.7, 0.5, 0.1, "Tormenta", true, guiWeatherLaterTab )
		elseif(laterWeather  == "fog") then
			guiWeatherForecasLastImage =   guiCreateStaticImage( 0.3 , 0.2, 0.4 , 0.4, "foggy.png", true,guiWeatherLaterTab)
			guiWeatherForecastLastLabel =  guiCreateLabel  ( 0.35 , 0.7, 0.3, 0.1, "Niebla espesa", true, guiWeatherLaterTab)
			
		end

		guiLabelSetHorizontalAlign (guiWeatherForecastLastLabel  , "center")
		
		guiWeatherForecastLaterBack = guiCreateButton( 0.4, 0.85, 0.2, 0.1, "Cerrar", true, guiWeatherLaterTab)
		addEventHandler ( "onClientGUIClick", guiWeatherForecastLaterBack,  function()  guiSetInputEnabled ( false )  guiSetVisible( guiWeatherForecast, false ) end ,false)
	
	
	guiSetVisible(guiWeatherForecast, false)
end

function showWeatherForecastGUI(weather, nextWeather, laterWeather)

	if(source == getLocalPlayer()) then
		createWeatherForecaseGUI(weather, nextWeather, laterWeather)
		guiSetInputEnabled ( true )
		guiSetVisible(guiWeatherForecast, true)
	end
		
end
addEvent ( "onCreateWeatherForecastGUI", true )
addEventHandler("onCreateWeatherForecastGUI", getLocalPlayer(), showWeatherForecastGUI )
         
local currentWeather = 10
local interior = false
function ChangePlayerWeather(weather)
	currentWeather = weather
	interior = false
end
addEvent( "onServerChangesWeather", true )
addEventHandler( "onServerChangesWeather", getRootElement(), ChangePlayerWeather )

addEventHandler( "onClientRender", getRootElement( ),
	function( )
		if getElementInterior( getLocalPlayer( ) ) > 0 and not interior then
			interior = true
			setWeather( 3 )
			setSkyGradient( 0, 0, 0, 0, 0, 0 )
		elseif getElementInterior( getLocalPlayer( ) ) == 0 and interior then
			interior = false
			setWeather( currentWeather )
			resetSkyGradient( )
		end
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		triggerServerEvent( "requestCurrentWeather", getLocalPlayer( ) )
	end
)