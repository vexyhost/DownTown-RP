local localPlayer = getLocalPlayer()
             
function solicitarLicencia(cmd, licencia)
	if getElementDimension(localPlayer) ~= 60 then outputChatBox("¡No estás en la autoescuela!", 255, 0, 0) return end
	if not licencia then
		outputChatBox("Listado de Licencias Disponibles", 255, 255, 0)
		outputChatBox("Usa /licencia [ID de licencia] para acceder.", 255, 255, 255)
		outputChatBox("ID 1 - Licencia de Coche/Moto/Camión.", 0, 255, 0)
		--outputChatBox("ID 2 - Licencia de Camión.", 0, 255, 0)
		--outputChatBox("ID 3 - Licencia de Barco.", 0, 255, 0)
		--outputChatBox("ID 4 - Licencia de Helicóptero.", 0, 255, 0)
	else
		if getElementData(getLocalPlayer(), "tryPractico") == true then outputChatBox("¡Tienes un exámen práctico pendiente! Sal y realízalo.", 255, 255, 0) return end
		if tonumber(licencia) == 1 then
			if getElementData(getLocalPlayer(),"license.car") == 0 then
				if getPlayerMoney(getLocalPlayer()) < 100 then outputChatBox("¡Necesitas $100 dólares para el teórico de esta licencia!", 255, 0, 0) return end
				triggerServerEvent("payFee", getLocalPlayer(), 100)
				createlicenseTestIntroWindow()
				showCursor(true)
			elseif getElementData(getLocalPlayer(),"license.car") == 16 then
				-- Ya tiene el teórico
				if getPlayerMoney(getLocalPlayer()) < 150 then outputChatBox("¡Necesitas $150 dólares para el práctico de esta licencia!", 255, 0, 0) return end
				initiateDrivingTest()
			else
				outputChatBox("Ya tienes la licencia de conducir Coche/Moto/Camión.", 255, 0, 0)
			end
		else
			outputChatBox("Tipo inválido. Usa /licencia (sin s al final) para ver las licencias disponibles.", 255, 0, 0)
		end
	end
end
addCommandHandler("licencia", solicitarLicencia)
   
questions = {
	{"¿Cuándo se deben de dar los intermitentes?", "Al sufrir un accidente.", "Al realizar un adelantamiento.", "Todas las opciones son correctas.", 3},
	{"¿Quién tiene la preferencia en un cruce?", "Los vehículos que están a tu izquierda.", "Los vehículos que están a tu derecha.", "Quien llega al cruce primero.", 2}, 
	{"Si el semáforo está en rojo deberías ...", "Parar el coche del todo.", "Continuar.", "Continuar si no hay peatones.", 1},
	{"Los conductores deben ceder el paso a los peatones:", "Siempre.", "En propiedad privada.", "Nunca.", 1},
	{"Cuando un policia viene por detras con las sirenas sonoras encendidas debes...", "Ponerte al lado derecho de la carretera.", "Ponerte al lado izquierdo de la carretera.", "No dejarle paso colocandote en medio." , 1},
	{"La máxima velocidad permitida en zonas pobladas o urbanas es de:", "80km/h", "60km/h", "70km/h", 2},
	{"En una carretera con dos o más carriles que viajan en la misma dirección, el conductor debe:", "Conducir en cualquier carril.", "Conducir en el carril izquierdo.", "Conducir en el carril derecho, excepto para pasar.", 3},
	{"Cuando hay niebla debe:", "Poner los faros para poder ver mejor.", "Poner los faros e ir mas despacio.", "No encender los faros pero si ir mas despacio.", 2},
	{"Al entrar en un coche tienes que...", "Arrancar el vehículo, ponerse el cinturón y circular.", "Ponerse el cinturón, arrancar el vehículo y circular.", "Empujar el coche por detras para que arranque solo.", 2},
	{"Vas conduciendo y ves que un camión va en carril contrario, kamikaze. ¿Qué haces?", "Ignorarlo y seguir con tu ruta.", "Sacar el teléfono móvil y avisar al 112.", "Parar en un lado de la carretera y avisar al 112.", 3},
	{"Estás en un cruce y tienes una señal triangular roja, apuntando hacia abajo. ¿Que significa?", "Significa que hay que parar el vehículo.", "Significa que debes de ceder el paso.", "Ambas son incorrectas.", 2},
	{"¿Qué significa ver un semáforo en ambar parpadeando?", "Significa que hay que parar el vehículo.", "Significa que la carretera está cortada.", "Ambas son incorrectas.", 3},
	{"¿Está permitido conducir bajo los efectos del alcohol?", "Sí, pero no una cantidad superior a 0.2 g/l.", "No, no se permite.", "No hay límite de alcoholemia, se puede conducir.", 2},
	{"¿Qué debes hacer si sufres un golpe con otro conductor?", "Perder los nervios e ir a agredirle.", "Acelerar e ir corriendo al taller.", "Revisar los daños y si es necesario avisar al 112.", 3},
	{"¿Es obligatorio llevar el cinturón de seguridad?", "Sí, en todos los casos.", "No, puedes no llevarlo.", "Sí, a excepción de la policía, médicos...", 3},
	{"¿Tienes el deber de socorrer a quien necesite auxilio en la carretera?", "Sí.", "No.", "Depende de la gravedad.", 1}
}

guiIntroLabel1 = nil
guiIntroProceedButton = nil
guiIntroWindow = nil
guiQuestionLabel = nil
guiQuestionAnswer1Radio = nil
guiQuestionAnswer2Radio = nil
guiQuestionAnswer3Radio = nil
guiQuestionWindow = nil
guiFinalPassTextLabel = nil
guiFinalFailTextLabel = nil
guiFinalRegisterButton = nil
guiFinalCloseButton = nil
guiFinishWindow = nil

local NoQuestions = 17
local NoQuestionToAnswer = 10
local correctAnswers = 0
local passPercent = 50
selection = {}
function createlicenseTestIntroWindow()
	showCursor(true)
	outputChatBox("Has pagado la tasa de entrada al test teórico", 255, 194, 14)
	local screenwidth, screenheight = guiGetScreenSize ()
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Test teórico de conducción" , false )
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, [[Ahora vas a proceder a hacer el test teórico,
	para aprobar el test tienes que sacar un 50%
	de 10 preguntas que se te harán

	Buena suerte.]], true, guiIntroWindow)
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center", true )
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	guiIntroProceedButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Empezar" , true ,guiIntroWindow)
	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
			startLicenceTest()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)
end

function createLicenseQuestionWindow(number)
	local screenwidth, screenheight = guiGetScreenSize ()
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Pregunta "..number.." de "..NoQuestionToAnswer , false )
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.2, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	guiLabelSetHorizontalAlign ( guiQuestionLabel, "left", true)
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Siguente" , true ,guiQuestionWindow)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				else
					selectedAnswer = 0
				end
				if(selectedAnswer ~= 0) then
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
					guiSetVisible(guiQuestionWindow, false)
					createLicenseQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButton = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Enviar Respuestas" , true ,guiQuestionWindow)
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButton,  function(button, state)
			if(button == "left" and state == "up") then
				local selectedAnswer = 0
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				if(selectedAnswer ~= 0) then
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
					guiSetVisible(guiQuestionWindow, false)
					createTestFinishWindow()
				end
			end
		end, false)
	end
end

function createTestFinishWindow()
	local score = math.floor((correctAnswers/NoQuestionToAnswer)*100)
	local screenwidth, screenheight = guiGetScreenSize ()
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "Fin de la prueba.", false )
	if(score >= passPercent) then
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "¡Enhorabuena! Has aprobado el examen teórico de conducir.", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "Tu porcentaje de aciertos es del "..score.."%,\n y el mínimo exigido es "..passPercent.."%. ¡Bien hecho!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center", true)
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continuar" , true ,guiFinishWindow)
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				initiateDrivingTest()
				correctAnswers = 0
				toggleAllControls ( true )
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalPassTextLabel)
				destroyElement(guiFinalRegisterButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalPassTextLabel = nil
				guiFinalRegisterButton = nil
				guiFinishWindow = nil
				correctAnswers = 0
				selection = {}
				showCursor(false)
			end
		end, false)	
	else -- player has failed, 
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Lo sentimos, pero no has conseguido aprobar.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "Tu porcentaje de aciertos es "..math.ceil(score).."%, y el mínimo exigido es "..passPercent.."%." ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center", true)
		guiFinalCloseButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Cerrar" , true ,guiFinishWindow)
		addEventHandler ( "onClientGUIClick", guiFinalCloseButton,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalFailTextLabel)
				destroyElement(guiFinalCloseButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalFailTextLabel = nil
				guiFinalCloseButton = nil
				guiFinishWindow = nil
				selection = {}
				correctAnswers = 0
				showCursor(false)
			end
		end, false)
	end
end

function startLicenceTest()
	chooseTestQuestions()
	createLicenseQuestionWindow(1)
end

function chooseTestQuestions()
	for i=1, 10 do
		local number = math.random(1, NoQuestions)
		if(testQuestionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (testQuestionAlreadyUsed(number) == false)
		end
		selection[i] = questions[number]
	end
end
 
function testQuestionAlreadyUsed(number)
	local same = 0
	for i, j in pairs(selection) do
		if(j[1] == questions[number][1]) then
			same = 1
		end
	end
	if(same == 1) then
		return true
	else
		return false
	end
end

---------------------------------------
------ Ruta de autoescuela ---------
---------------------------------------
testRoute = {                     
	{2340.72,183.17,25.99},
	{2341.7,58.81,25.99},
	{2369.34,-29.98,25.99},
	{2466.08,29.26,25.99},
	{2396.61,55.59,25.99},
	{2346.8,121.69,25.99},
	{2301.74,215.7,23.84},
	{2068.54,255.61,24.42},
	{1908.37,357.78,19.98},
	{1640.69,385.21,19.45},
	{1426.14,423.76,19.54},
	{1341.33,368.83,19.06},
	{1276.79,349.49,19.06},
	{1214.17,331.1,19.06},
	{1234.61,256.52,19.06},
	{1248.39,188.08,19.05},
	{1306.49,237.55,19.06},
	{1493.06,156.23,30.47},
	{1586.43,124.2,29.28},
	{1789.58,80.72,34.24},
	{2072.52,40.06,26.02},
	{2219.44,40.08,25.99},
	{2296.26,74.59,25.99},
	{2346.5,151.76,25.99},
	{2324.05,191.77,26.1},
}

testVehicle = { [436]=true } -- Previons need to be spawned at the start point.

local blip = nil
local marker = nil

function initiateDrivingTest()
	triggerServerEvent("theoryComplete", getLocalPlayer(), 1)
	setElementData(getLocalPlayer(), "tryPractico", true)
	local x, y, z = testRoute[1][1], testRoute[1][2], testRoute[1][3]
	blip = createBlip(x, y, z, 0, 2, 0, 255, 0, 255)
	marker = createMarker(x, y, z, "checkpoint", 4, 0, 255, 0, 150) -- start marker.
	addEventHandler("onClientMarkerHit", marker, startDrivingTest)
	outputChatBox("Salga de la sala, súbase a un vehiculo de pruebas y haga su examen práctico. ¡Buena suerte!", 0, 255, 0, true)
end

function startDrivingTest(element)
	if element == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("#FF9933Debe estar en un vehículo de la autoescuela para realizar el examen práctico.", 255, 0, 0, true ) -- Wrong car type.
		elseif getPlayerMoney(localPlayer) >= 150 then
			destroyElement(blip)
			destroyElement(marker)
			outputChatBox("Se te han descontado 150 dólares como cuota del exámen.", 255, 194, 14)
			triggerServerEvent("payFee", getLocalPlayer(), 150)
			
			local vehicle = getPedOccupiedVehicle ( getLocalPlayer() )
			setElementData(getLocalPlayer(), "drivingTest.marker", 2, false)

			local x1,y1,z1 = nil -- Setup the first checkpoint
			x1 = testRoute[2][1]
			y1 = testRoute[2][2]
			z1 = testRoute[2][3]
			setElementData(getLocalPlayer(), "drivingTest.checkmarkers", #testRoute, false)

			blip = createBlip(x1, y1 , z1, 0, 2, 255, 0, 255, 255)
			marker = createMarker( x1, y1,z1 , "checkpoint", 4, 255, 0, 255, 150)
				
			addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
				
			outputChatBox("#FF9933Tendrá que completar la ruta sin dañar el vehículo de pruebas. Buena suerte.", 255, 194, 14, true)
			outputChatBox("¡Recuerda, abróchate el cinturón!", 255, 255, 0)
		else
			outputChatBox("Necesitas 150 dólares para aprobar el examen práctico.", 255, 0, 0 )
		end
	end
end

function UpdateCheckpoints(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("Tienes que estar en un auto de prueba DMV al pasar por los puntos de verificación.", 255, 0, 0) -- Wrong car type.
		else
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
			local m_number = getElementData(getLocalPlayer(), "drivingTest.marker")
			local max_number = getElementData(getLocalPlayer(), "drivingTest.checkmarkers")
			if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
				outputChatBox("#FF9933Estacione su auto #FF66CCen el estacionamiento #FF9933para completar la prueba.", 255, 194, 14, true)
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
				local x2, y2, z2 = nil
				x2 = testRoute[newnumber][1]
				y2 = testRoute[newnumber][2]
				z2 = testRoute[newnumber][3]
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				addEventHandler("onClientMarkerHit", marker, EndTest)
			else
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)	
				local x2, y2, z2 = nil
				x2 = testRoute[newnumber][1]
				y2 = testRoute[newnumber][2]
				z2 = testRoute[newnumber][3]	
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
			end
		end
	end
end

function EndTest(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("No está subido a un vehículo de la autoescuela.", 255, 0, 0)
		else
			local vehicleHealth = getElementHealth ( vehicle )
			if (vehicleHealth >= 980) then
				if getElementData(getLocalPlayer(), "player.cinturon") == true then
					outputChatBox("Enhorabuena, ya tiene su carnet de conducir.", 0, 255, 0)
					triggerServerEvent("acceptLicense", getLocalPlayer(), 1, 100)
				else
					outputChatBox("Lo sentimos, no has aprobado el examen práctico.", 255, 0, 0)
					outputChatBox("Razón: conducir sin abrocharse el cinturón.", 255, 255, 255)
					outputChatBox("Estaciona y acude a la autoescuela para repetir el práctico.", 255, 255, 0)
				end
			else
				outputChatBox("Lo sentimos, no has aprobado el examen práctico.", 255, 0, 0)
				outputChatBox("Razón: conducir teniendo al menos un choque leve.", 255, 255, 255)
				outputChatBox("Estaciona y acude a la autoescuela para repetir el práctico.", 255, 255, 0)
			end
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
			setElementData(localPlayer, "tryPractico", nil)
			setElementData(localPlayer, "drivingTest.vehicle", nil)
			setElementData( localPlayer, "drivingTest.marker", nil)
			setElementData( localPlayer, "drivingTest.checkmarkers", nil)
		end 
	end
end