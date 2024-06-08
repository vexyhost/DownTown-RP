--[[
Copyright (c) 2010 MTA: Paradise
Copyright (c) 2020 DownTown RolePlay
Copyright (c) 2016  DownTown County Roleplay

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

local messageTimer  
local messageCount = 0
local registro = true
local userLog = ""
local passLog = ""

local function setMessage( text )
	windows.login[#windows.login].text = text
	if messageTimer then
		killTimer( messageTimer )
	end
	messageCount = 0
	setTimer(
		function()
			messageCount = messageCount + 1
			if messageCount == 50 then
				windows.login[#windows.login].text = ""
				messageTimer = nil
			else
				windows.login[#windows.login].color = { 255, 255, 255, 5 * ( 50 - messageCount ) }
			end
		end, 100, 50
	)
end

local function tryLogin( key )
	if key ~= 2 and destroy and destroy['g:login:username'] and destroy['g:login:password'] then
		local u = guiGetText( destroy['g:login:username'] )
		local p = guiGetText( destroy['g:login:password'] )
		if u and p then
			if #u == 0 then
				setMessage( "Introduce un usuario." )
			elseif #p == 0 then
				setMessage( "Introduce una contraseña." )
			else
				userLog = u
				passLog = p
				triggerServerEvent( "players:login", getLocalPlayer( ), u, p )
			end
		end 
	end
end

local function tryRecuperacion( key )
	if key ~= 2 and destroy and destroy['g:login:username'] then
		local u = guiGetText( destroy['g:login:username'] )
		if u then
			if #u == 0 then
				setMessage( "Introduce un usuario." )
			else
				triggerServerEvent( "onEnviarDatosRecuperacion", getLocalPlayer(), u, getLocalPlayer() )
			end
		end
	end
end

windows.login =
{
	snapTop = true,
	snapBottom = true,
	onCreate = function( )
			for i = #windows.login, 1, -1 do
				if windows.login[i].text == "Registrarse" then
					table.remove( windows.login, i )
				end
			end
			
			if registro == true then
				table.insert( windows.login, #windows.login,
					{
						type = "button",
						text = "Registrarse",
						onClick = function( key )
								if key == 1 and destroy and destroy['g:login:username'] and destroy['g:login:password'] then
									local u = guiGetText( destroy['g:login:username'] )
									local p = guiGetText( destroy['g:login:password'] )
																		if u then
										if p then
											if #u < 3 then
												setMessage( "Tu usuario debe de tener 3 carácteres como mínimo." )
											elseif #p < 8 then
												setMessage( "Tu contraseña debe de tener 8 carácteres como mínimo." )
											else
												userLog = u
												passLog = p
												triggerServerEvent( "players:register", getLocalPlayer( ), u, p )
											end
										else
										setMessage( "Introduce una contraseña." )
										end	
									else
									setMessage( "Introduce un usuario." )
									end
								end
							end
					}
				)
			end
		end,
	{
		type = "image",
		image = "images/logo.png",  
		tam = 1.5,
		alignX = "center",
	},
	{
		type = "label",
		text = "Necesitas una cuenta para jugar en DownTown RolePlay\nSi tienes una cuenta, incia sesión.",
		alignX = "center",
	},
	{
		type = "label",
		text = "Si no tienes, registra ahora una.",
		alignX = "center",
	},
	{
		type = "edit",
		text = "Usuario:",
		id = "g:login:username",
		onAccepted = tryLogin,
	},
	{
		type = "edit",
		text = "Contraseña:",
		id = "g:login:password",
		masked = true,
		onAccepted = tryLogin,
	},
	{
		type = "button",
		text = "Iniciar sesión",
		onClick = tryLogin,
		
	},
	{
		type = "button",
		text = "Olvidé mi clave",
		onClick = tryRecuperacion,
	}
}
table.insert( windows.login, { type = "label", text = "", alignX = "center" } )

--[[function regularBG()
	if not exports.players:isLoggedIn() then
		--local bgX, bgY = guiGetScreenSize()
		--bg = dxDrawImage ( 0, 0, bgX, bgY, "images/bg.png" )
	end
end

function HandleTheRendering ( )
	addEventHandler("onClientRender", getRootElement(), regularBG)
end
addEventHandler("onClientResourceStart",resourceRoot, HandleTheRendering)]]


addEvent( "players:loginResult", true )
addEventHandler( "players:loginResult", getLocalPlayer( ),
	function( code )
		if code == 1 then
			setMessage( "Usuario o contraseña incorrectos." )
		elseif code == 2 then
			show( 'banned', true )
		elseif code == 3 then
            showChat(true)
            show( 'activation_required', false )
			iniTest()
		elseif code == 4 then
			setMessage( "Error desconocido." )
		elseif code == 5 then
			setMessage( "Otro usuario está\nusando en tu cuenta." )
		elseif code == 6 then
			show( 'deactivation', true )
		end
	end
)
	
addEvent( "players:registrationResult", true )
addEventHandler( "players:registrationResult", getLocalPlayer( ),
	function( code, message )
		if code == 0 then
			tryLogin( )
		elseif code == 1 then
			setMessage( "Prueba después." )
		elseif code == 2 then
			setMessage( "Registro deshabilitado." )
		elseif code == 3 then
			setMessage( "Este usuario ya existe." )
		elseif code == 4 then
			setMessage( "Inténtalo de nuevo." )
		elseif code == 5 then
			setMessage( "Solo se permite una\ncuenta por serial." )
		elseif code == 6 then
			setMessage( "Solo se permiten dos\ncuentas por direción IP." )
	    end
	end	
)

windows.banned =
{
	type = "label",
	text = "Estás baneado.",
	font = "bankgothic",
	color = { 255, 0, 0, 255 },
	alignX = "center",
}

windows.deactivation =
{
	type = "label",
	text = "Un staff te ha desactivado la cuenta.\nRazón: "..tostring(getElementData(getLocalPlayer(), "dcuenta")).."\nAcude a dcrp.cu.cc para solicitar su desbloqueo.",
	color = { 255, 255, 255, 255 },
	alignX = "center",
}

function iniTest()
	createlicenseTestIntroWindow() -- Iniciar el test.
	wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
	showCursor(true)
end
   ------------ TUTORIAL QUIZ SECTION - SCRIPTED BY PETER GIBBONS (AKA JASON MOORE), ADAPTED BY CHAMBERLAIN  AND EDITED BY JEFFERSON FOR DownTown COUNTY ROLEPLAY --------------                               
questions = { 
	{"¿Está permitido el uso de multicuentas?", "Sí, no hay ningún problema", "No, me pueden sancionar IC", "No, me pueden sancionar OOC", 3},
	{"¿Qué son las siglas CK?", "Car Kill", "Character Kill", "Clan Kill", 1},
	{"¿Cuándo se puede vender una facción?", "Nunca, no se puede vender", "Cuando el dueño quiera", "Cuando el dueño solicite permiso de forma IC y OOC", 3},
	{"¿Puede un líder de tu facción prohibirte ciertos roles?", "No, ya que se consideraría PG", "No, ya que se consideraría MG", "Sí, ya que se recoge en la normativa", 3},
	{"¿Cómo puedes borrar tu personaje?", "Acudiendo a un staff usando /duda", "Usando /borrarmipj", "Acudiendo a Soporte Técnico y pidiéndolo con la correspondiente plantilla", 2},
	{"Recibes una sanción por DM y crees que es excesivo el tiempo, ¿qué haces?", "Acudo a cualquier staff conectado para que me lo intente reducir", "Acudo a Soporte Técnico del foro exponiendo mi queja", "No puedo hacer nada, el staff no determina el tiempo de jail", 3},
	{"Vas por la calle, es de noche. Alguien se te pone detrás con una pistola silenciada y te pide tu dinero, ¿qué harías?", "Le doy todo mi dinero", "Pregunto al usuario para ver si tiene spec y si lo tiene continuo el rol", "Salgo huyendo dándole una patada y grito pidiendo auxilio", 1},
	{"A la hora de  robar un vehículo, ¿Cuándo tienes que usar /robar?", "Sólo cuando esté con el motor apagado", "Siempre hay que usar /robar", "Sólo cuando esté con el motor encendido", 2},
	{"A la hora de realizar un PK, ¿es necesario que haya un staff supervisándolo?", "Sí, puesto que puede haber problemas en el rol", "Sí, puesto que en caso contrario el PK no será válido", "No, ya que no hace falta supervisión para PK", 3},
	{"¿Qué es PG?", "Realizar acciones imposibles o que nunca harías en la vida real", "Realizar acciones imposibles o que nunca haría tu PJ", "Ambas respuestas son correctas", 2},
	{"Supongamos que vas conduciendo a más de 100 KM/H, te estrellas      y te vas del lugar. ¿Qué regla habrias incumplido?", "NRC", "NRE", "NRH", 1},
	{"Si un vehículo está abierto y arrancado, ¿se puede robar?", "Sí, usando /robar y pagando el 15% del valor del vehículo.", "Sí, usando /robar sin tener que pagar absolutamente nada", "No, no puedo robar el vehículo", 2},
	{"Si un vehículo está abierto y no arrancado, ¿se puede robar?", "Sí, usando /robar y pagando el 15% del valor del vehículo.", "Sí, usando /robar sin tener que pagar absolutamente nada", "No, no puedo robar el vehículo", 1},
	{"Si un vehículo está cerrado y no arrancado, ¿se puede robar?", "Sí, usando /robar y pagando el 15% del valor del vehículo.", "Sí, usando /robar sin tener que pagar absolutamente nada", "No, no puedo robar el vehículo", 3},
	{"Si un vehículo está cerrado y arrancado, ¿se puede robar?", "Sí, usando /robar y pagando el 15% del valor del vehículo.", "Sí, usando /robar sin tener que pagar absolutamente nada", "No, no puedo robar el vehículo", 3},
	{"Si una casa está cerrada, ¿se puede robar?", "Sí, usando /robar con supervisión de un staff", "No, no se pueden robar casas así", "Sí, sin staff y recogiendo todo lo de la casa", 2},
	{"Si una casa está abierta, ¿se puede robar?", "Sí, usando /robar con supervisión de un staff", "No, no se pueden robar casas así", "Sí, sin staff y recogiendo todo lo de la casa", 3},
	{"Estás en un rol y un usuario empieza a cortarlo por /b, ¿qué haces?", "Solicitar un /staff mediante F1, /duda o /pm", "Evadir el rol y darlo por finalizado. ¡Es imposible rolear con ese user!", "Reportarlo en foro para que no vuelva a suceder", 3},
	{"¿Cuánto cuesta un CK Policial?", "El CK Policial no tiene coste", "El CK Policial tiene un coste de 7.500$", "El CK Policial tiene un coste de 15.000$", 3},
	{"A la hora de realizar un CK, ¿es necesario que haya un staff supervisándolo?", "Sí, puesto que puede haber problemas en el rol", "Sí, puesto que en caso contrario el CK no será válido", "No, ya que no hace falta supervisión para CK", 3},
	{"¿Cuándo se debe de avisar a Emergencias tras un PK?", "Tras caer el muerto en estado de crack", "Antes de producirse el rol de asesinato", "Tiene que avisar a Emergencias el asesinado con /avisarmd", 1},
	{"¿Cada cuánto tiempo se puede robar un vehículo?", "Cada 24 horas", "Cada 48 horas", "Cada 72 horas", 3},
	{"¿Está permitido tener más de 1 negocio?", "Sí, se puede tener más de 1 negocio por personaje", "Sí, se puede tener más de 1 negocio por cuenta", "No, no está permitido", 2},
	{"¿Cuál es el nivel mínimo para poder realizar un robo a un interior?", "El nivel mínimo es el 2", "El nivel mínimo es el 3", "El nivel mínimo es el 4", 3},
	{"¿Cuál es el nivel mínimo para poder realizar un robo a un vehículo?", "El nivel mínimo es el 2", "El nivel mínimo es el 3", "El nivel mínimo es el 4", 2},
	{"Para realizar algún ataque contra la SD, ¿tiene que haber un mínimo de miembros ON?", "Sí, debe de haber un mínimo de 5 miembros conectados", "Sí, debe de haber un mínimo de 3 miembros conectados", "No, no debe de haber un número mínimo de agentes conectados", 2},
	{"¿Se puede realizar el robo de un vehículo que pertenece a una facción?", "Sí, previa autorización del staff", "No, no está permitido", "Sí, usando /robar y siguiendo los pasos del sistema", 3},
	{"¿Qué caso se puede considerar MG?", "Confundir canales IC y OOC", "Obtener beneficio IC de información obtenida OOC", "Ambas respuestas son correctas", 2},
	{"Estás en low-hp. ¿Debes de rolear heridas?", "Sí, tengo que rolear heridas en este caso", "No, no tengo por qué rolearlo aunque si puedo si quiero", "No, y además no está permitido rolear heridas estando en low-hp", 1},
	{"¿Qué es CJ?", "Carl Johnson", "Car Jacking", "Ambas respuestas son correctas", 2},
	{"¿Qué es BA?", "Ban Automatic", "Bug Admin", "Bug Abuser", 3},
	{"¿Qué es IG?", "In Game", "In Gear", "No es un término de rol", 1},
	{"¿Qué es MK?", "Correr saltando a un lugar sin cansarte", "Confundir canales IC y OOC", "Ninguna de las respuestas anteriores son correctas", 3},
	{"¿Cómo puedes actuar ante un staff que abusa?", "Reportándolo en foro con pruebas", "Enviando un MP en foro a un desarrollador con pruebas", "Acusar al staff de abusar en zona libre del foro", 1},
	{"¿Está permitida la suplantación de identidad para pertenecer a una facción?", "Sí, dado que es puro rol", "Sí, pero previa autorización del staff", "No, no está permitido", 3},
	{"¿Qué es MG2?", "Mini Game", "Meta Gaming 2", "No es un término de rol", 3},
	{"¿Qué sucede si el presupuesto de una facción llega a 0?", "La faccción debe de ser cedida a otro miembro", "La facción debe de ser subastada de forma IC", "La facción debe de pedir un rescate de forma IC", 3},
	{"¿Cuál es el nivel mínimo para poder realizar un robo a un usuario?", "El nivel mínimo es el 2", "El nivel mínimo es el 3", "El nivel mínimo es el 4", 2},
	{"Selecciona la opción correcta", "/me se agacha y se ata los cordones", "/do se agacha y se ata los cordones", "/b se agacha y se ata los cordones", 1},
	{"Selecciona la opción incorrecta", "/do el vehículo estaría pintado de verde", "/me el vehículo estaría pintado de verde", "/intentar pintar el vehículo de verde", 2},
	{"El hecho de actuar de forma incorrecta en foro, ¿puede acarrear sancion IG?", "Sí, puede acarrear sanción IG", "No, no puede acarrear sanción IG", "¿IG? ¿Qué es eso? No tiene sentido con la pregunta", 1},
	{"Supongamos que usas el /radio de forma troll, poniendo canciones que no deberías. ¿Te podrían sancionar?", "Sí, por la regla número 2", "Sí, por la regla número 7", "No, puesto que a mi personaje puede gustarle escuchar ese audio", 2},
	{"¿Cómo puedes entrar en una facción oficial legal?", "Enviando un MP al líder via foro", "Realizando currículum en foro", "Intentando rolear con esa facción IG", 2},
	{"¿Cómo puedes entrar en una facción oficial ilegal?", "Enviando un MP al líder via foro", "Realizando currículum en foro", "Intentando rolear con esa facción IG", 3},
	{"¿Se puede salir de la zona de rol?", "Sí, se puede salir dado que no hay zona de rol", "Sí, pero previa autorización del staff", "No, no se puede salir de la zona de rol bajo ningún concepto", 2},
	{"¿Un líder de facción puede moderar los subforos de su facción?", "Sí, puede moderarlos aunque debe dejar al staff intervenir primero", "Sí, y más que poder moderarlos, debe moderarlos", "No, el orden del foro corresponde únicamente al staff", 2},
	{"¿Qué es CZ?", "Correr saltando a un lugar sin cansarte", "Abusar de un bug", "No es un término de rol", 3},
	{"Selecciona el nombre válido", "Fernando Alonso", "manuel ruano", "Manuel Ruano", 3},
	{"Selecciona el nombre válido", "Roberto Linares", "roberto linares", "Roberto_Linares", 1},
	{"Selecciona el nombre válido", "Jennifer McDonald", "Carlos Sainz", "Rodolfo Chikilicuatre", 1},
	{"Vas al taller y el mecánico tiene prisa, así que te ofrece repararte    sin rol ¿qué haces?", "Me voy del taller y espero a otro mecánico", "Le hago caso al mecánico y que me repare", "Acudo a foro a reportar al jugador por intento de evasión de rol", 1},
	{"¿Qué número se debe usar para avisar al Servicio de Emergencias?", "911", "112", "Ambas respuestas son correctas", 3},
	{"El hecho de vender un bate por 4.000$ a un nuevo, ¿puede ser considerado estafa?", "Sí, puesto que es un nuevo, y más a ese precio", "No, ya que es rol IC. Si me compra el bate es su problema", "Ambas respuestas son incorrectas", 1},
	{"En caso de robar un vehículo que tiene alarma, ¿quién avisa a la policía?", "Obligatoriamente el usuario, y el sistema si lo ve oportuno", "Obligatoriamente el sistema, y el usuario si lo ve oportuno", "No se debe de avisar a la policía ante un robo, el sistema se encarga", 1},
	{"Selecciona la opción correcta", "/intentar tirar la moneda al aire y cogerla al vuelo", "/intentar quitarse las esposas con un clip", "/intentar sobrevivir al disparo del rifle", 1},
	{"El hecho de que un /intentar salga que sí, ¿implica que sea válido?", "Sí, ya que el /intentar es el que prevalece", "Sí, puesto que en caso contrario sería evasión de rol", "No, ya que en algunos casos se puede cometer faltas de rol", 3},
	{"¿Qué es FK?", "Free Kill", "Fahrenheit Kelvin", "No es un término de rol", 3},
	{"¿Qué es MA?", "El grande del equipo A", "Meta Abuse", "No es un término de rol", 3},
	{"¿Está permitido ceder / vender / prestar / intercambiar tu cuenta?", "Sí, siempre y cuando no haya ningún problema OOC", "No, y los que participen se irán baneados", "No, y las cuentas implicadas serán bloqueadas", 3},
	{"¿Qué es el derecho al olvido?", "Solicitud donde se te crea una cuenta nueva y empiezas de 0", "Hace referencia a que las sanciones se eliminarán cada 60 días", "Este término no existe", 1}
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

-- variable for the max number of possible questions
local NoQuestions = 60
local NoQuestionToAnswer = 20
local correctAnswers = 0
local passPercent = 16
		
selection = {}

-- functon makes the intro window for the quiz
function createlicenseTestIntroWindow()	
	showCursor(true)
	local screenwidth, screenheight = guiGetScreenSize ()	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Test de rol. DownTown RolePlay." , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, [[Vas a realizar el test de rol de DownTown RolePlay.
	Son 20 preguntas tipo test, pudiendo fallar 2. Te recomendamos ir a https://foro.dt-mta.com]], true, guiIntroWindow)	
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
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createLicenseQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButton = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Enviar Respuestas" , true ,guiQuestionWindow)
		                            
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
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
	local score = math.floor(correctAnswers)
	local screenwidth, screenheight = guiGetScreenSize ()
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "Test de rol finalizado.", false )
	if(score >= passPercent) then
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Has superado el test de rol.", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "Has acertado "..math.ceil(score).." de "..NoQuestionToAnswer.." preguntas." ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center", true)
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continuar" , true ,guiFinishWindow)
		addEventHandler('onClientGUIClick', guiFinalRegisterButton, procesar)
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
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
	else
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "No has aprobado. Te recomendamos que vayas a foro.dt-mta.com", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "Has acertado "..math.ceil(score).." preguntas, y para pasar el test necesitas acertar "..passPercent.." preguntas." ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center", true)
		guiFinalCloseButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Cerrar" , true ,guiFinishWindow)
		addEventHandler('onClientGUIClick', guiFinalCloseButton, procesar2)
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
	for i=1, 20 do
		local number = math.random(1, NoQuestions)
		if(testQuestionAlreadyUsed(number)) then
			repeat
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

function procesar() 
	if source == guiFinalRegisterButton then
		triggerServerEvent ( "onPCUAceptada", localPlayer, localPlayer )
		triggerServerEvent( "players:login", getLocalPlayer( ), userLog, passLog )
	end
end

function procesar2()
	triggerServerEvent ( "onPCURechazada", localPlayer, localPlayer )
end