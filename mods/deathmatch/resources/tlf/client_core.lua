local sx, sy = guiGetScreenSize ( )
local phone_y = sy + 10
local to_phone_y = sy - 600
local phone_x = sx - 330
local moveSpeed = 18
local isOpen = false
local isRender = false
LoadedPage = nil
local RealTime = "00:00"
local backgroundPath = "images/backgrounds/background_1.png"
local tablaSMS = {}             
local tablaContactos = {}
local tablaVehiculos = {}
local numeroLlamado = nil
local saldoCuenta = nil
local timerLlamada = {}
local textoAgenda = ""
local soundLocal = nil
local typeSound = nil
local actualSound = nil


function recibirTablasNecesarias (tabla_sms, tabla_contactos, tabla_vehiculos, saldo_cuenta, texto_agenda)
	tablaSMS = tabla_sms
	tablaContactos = tabla_contactos
	tablaVehiculos = tabla_vehiculos
	saldoCuenta = saldo_cuenta
	textoAgenda = texto_agenda
end
addEvent("onEnviarTablasNecesarias", true)
addEventHandler("onEnviarTablasNecesarias", getRootElement(), recibirTablasNecesarias)

function numeroAContacto (numero)
	for k, v in ipairs(tablaContactos) do
		if tonumber(v.tlf_contacto) == tonumber(numero) then
			return tostring(v.nombre)
		end
	end
	if tonumber(numero) == 100 then
		return tostring("Llamadas Perdidas")
	elseif tonumber(numero) == 911 or tonumber(numero) == 112 then
		return tostring("S.O.S")
	else
		return tostring(numero)
	end
end

if ( fileExists ( "custombg.png" ) ) then
	backgroundPath = "custombg.png" 
elseif ( fileExists ( "custombg.jpg" ) ) then
	backgroundPath = "custombg.jpg"
end

base = guiCreateStaticImage (  phone_x, phone_y, 350, 600, "images/phone.png", false  )
background = guiCreateStaticImage ( 43, 92, 262, 422, backgroundPath, false, base )
RealTimeText = guiCreateLabel( 250, 78, 220, 60, RealTime, false, base )
guiSetFont ( RealTimeText, "default-bold-small" )
guiSetVisible ( base, false )
guiLabelSetColor ( RealTimeText, 0, 120, 255 )

local open = {
	startY = sy+5,
	endY = to_phone_y,
	startTime = nil,
	endTime = nil,
	allowClicking = true
}

function updateTimeTimer()
	local realTime = getRealTime ( )
	local hour = realTime['hour']
	local min = realTime['minute']
	local ending = "AM"
	if ( hour > 12 ) then
		hour = hour - 12
		ending = 'PM'
	end if ( min <  10 ) then
		min = 0 .. min
	end
	
	if ( tostring ( hour ) == '0' ) then
		hour = 12
	end
	
	local text = hour..":"..min .. ending
	guiSetText ( RealTimeText, text )
end
 
local appSize = 55
local margin_x = 62
local margin_y = 77
pages = { }
-- Home 
pages['home'] = { }

pages['home'].base_call = guiCreateStaticImage ( 5, 5, appSize, appSize, "images/app_call.png", false, background )
pages['home'].base_sms = guiCreateStaticImage ( 5+margin_x, 5, appSize, appSize, "images/app_sms.png", false, background )
pages['home'].base_contacts = guiCreateStaticImage ( 5+margin_x*2, 5, appSize, appSize, "images/app_contacts.png", false, background )
pages['home'].base_vehicles = guiCreateStaticImage ( 5+margin_x*3, 5, appSize, appSize, "images/app_vehicle.png", false, background )

pages['home'].base_2048 = guiCreateStaticImage ( 5, 5+margin_y, appSize, appSize, "images/app_2048.png", false, background )
pages['home'].base_flappy = guiCreateStaticImage ( 5+margin_x, 5+margin_y, appSize, appSize, "images/app_flappybird.png", false, background )
pages['home'].base_bank = guiCreateStaticImage ( 5+margin_x*2, 5+margin_y, appSize, appSize, "images/app_bank.png", false, background )
pages['home'].base_notes = guiCreateStaticImage ( 5+margin_x*3, 5+margin_y, appSize, appSize, "images/app_notes.png", false, background )

pages['home'].base_music = guiCreateStaticImage ( 5, 5+margin_y*2, appSize, appSize, "images/app_music.png", false, background )
pages['home'].base_calc = guiCreateStaticImage ( 5+margin_x, 5+margin_y*2, appSize, appSize, "images/app_calc.png", false, background )
--pages['home'].base_waypoints = guiCreateStaticImage ( 5+margin_x*2, 5+margin_y*2, appSize, appSize, "images/app_gps.png", false, background )
pages['home'].base_off = guiCreateStaticImage ( 5+margin_x*3, 5+margin_y*2, appSize, appSize, "images/app_off.png", false, background )

for i, v in pairs ( pages['home'] ) do
	if ( getElementType ( v ) == "gui-staticimage" ) then
		guiSetAlpha ( v, 0.8 )
	end
end
 
-- Llamadas
pages['call'] = { }
pages['call'].lbl1 = guiCreateLabel ( 0, 13, 270, 20, "Selecciona un contacto o pon un número.", false, background )
guiLabelSetHorizontalAlign(pages['call'].lbl1, "center", false)
pages['call'].grid = guiCreateGridList ( 4, 31, 257, 245, false, background )
pages['call'].lbl2 = guiCreateLabel ( 80, 280, 300, 20, "Numero a marcar:", false, background )
guiSetFont(pages['call'].lbl2 ,"default-bold-small")
pages['call'].number = guiCreateEdit ( 40, 300, 180, 20, "", false, background )
pages['call'].call = guiCreateButton ( 60, 336, 142, 60, "Llamar", false, background )

guiGridListAddColumn ( pages['call'].grid, "Nombre", 0.45 )
guiGridListAddColumn ( pages['call'].grid, "Telefono", 0.45 )
 
pages['calling'] = { }
pages['calling'].telefonica = guiCreateStaticImage ( 20, 40, 211, 78, "images/telefonica.png", false, background )
pages['calling'].lbl1 = guiCreateLabel ( 5, 140, 250, 100, "Llamando A", false, background )
pages['calling'].lbl2 = guiCreateLabel ( 30, 190, 200, 100, "", false, background )
guiLabelSetHorizontalAlign(pages['calling'].lbl1, "center", false)
guiLabelSetHorizontalAlign(pages['calling'].lbl2, "center", false)
local fuente = guiCreateFont("fuente.ttf", 35)
local fuente2 = guiCreateFont("fuente.ttf", 30)
guiSetFont(pages['calling'].lbl1, fuente)
guiSetFont(pages['calling'].lbl2, fuente2)
pages['calling'].colgar = guiCreateStaticImage ( 75, 260, 100, 100, "images/colgar.png", false, background )


pages['calling_r'] = { }
pages['calling_r'].telefonica = guiCreateStaticImage ( 20, 40, 211, 78, "images/telefonica.png", false, background )
pages['calling_r'].lbl1 = guiCreateLabel ( 5, 140, 250, 100, "", false, background )
pages['calling_r'].lbl2 = guiCreateLabel ( 30, 190, 200, 100, "", false, background )
guiLabelSetHorizontalAlign(pages['calling_r'].lbl1, "center", false)
guiLabelSetHorizontalAlign(pages['calling_r'].lbl2, "center", false)
local fuente = guiCreateFont("fuente.ttf", 32)
local fuente2 = guiCreateFont("fuente.ttf", 30)
guiSetFont(pages['calling_r'].lbl1, fuente)
guiSetFont(pages['calling_r'].lbl2, fuente2)
pages['calling_r'].colgar = guiCreateStaticImage ( 125, 260, 100, 100, "images/colgar.png", false, background )
pages['calling_r'].responder = guiCreateStaticImage ( 25, 260, 100, 100, "images/responder.png", false, background )

-- SMS
pages['sms'] = { }
pages['sms'].grid = guiCreateGridList ( 4, 11, 257, 150, false, background )
pages['sms'].messages = guiCreateMemo ( 4, 220, 257, 150, "Selecciona un SMS de la lista para verlo.", false, background )
pages['sms'].delete = guiCreateButton ( 157, 376, 82, 30, "Borrar\nMensaje", false, background )
pages['sms'].new = guiCreateButton ( 27, 376, 82, 30, "Nuevo Mensaje", false, background )
pages['sms'].selectedSMS = nil
       
guiGridListAddColumn ( pages['sms'].grid, "SMS", 0.9 )
guiMemoSetReadOnly ( pages['sms'].messages, true )

pages['sms_new'] = { }
pages['sms_new'].lbl1 = guiCreateLabel ( 0, 6, 270, 20, "Selecciona un contacto o pon un número.", false, background )
guiLabelSetHorizontalAlign(pages['sms_new'].lbl1, "center", false)
pages['sms_new'].grid = guiCreateGridList ( 4, 26, 257, 130, false, background )
pages['sms_new'].lbl2 = guiCreateLabel ( 0, 170, 270, 20, "Numero Destinatario:", false, background )
guiLabelSetHorizontalAlign(pages['sms_new'].lbl2, "center", false)
guiSetFont(pages['sms_new'].lbl2 ,"default-bold-small")
pages['sms_new'].number = guiCreateEdit ( 40, 190, 180, 20, "", false, background )
pages['sms_new'].message = guiCreateMemo ( 4, 210, 257, 150, "Escribe aquí el mensaje a enviar.", false, background )
pages['sms_new'].cancel = guiCreateButton ( 157, 376, 82, 30, "Volver Atrás", false, background )
pages['sms_new'].send = guiCreateButton ( 27, 376, 82, 30, "Enviar SMS", false, background )

guiGridListAddColumn ( pages['sms_new'].grid, "Nombre", 0.45 )
guiGridListAddColumn ( pages['sms_new'].grid, "Telefono", 0.45 )

-- Contactos
pages['contacts'] = { }
pages['contacts'].grid = guiCreateGridList ( 4, 11, 257, 345, false, background )
pages['contacts'].delete = guiCreateButton ( 157, 376, 82, 30, "Borrar Contacto", false, background )
pages['contacts'].new = guiCreateButton ( 27, 376, 82, 30, "Nuevo Contacto", false, background )
pages['contacts'].selectedContacto = nil

guiGridListAddColumn ( pages['contacts'].grid, "Nombre", 0.45 )
guiGridListAddColumn ( pages['contacts'].grid, "Telefono", 0.45 )
        
pages['contacts_add'] = { }
pages['contacts_add'].lbl1 = guiCreateLabel ( 42, 80, 50, 20, "Nombre:", false, background )
pages['contacts_add'].add_name = guiCreateEdit ( 42, 120, 180, 20, "", false, background )
pages['contacts_add'].lbl2 = guiCreateLabel ( 42, 160, 50, 20, "Teléfono:", false, background )
pages['contacts_add'].add_number = guiCreateEdit ( 42, 200, 180, 20, "", false, background )
pages['contacts_add'].lbl3 = guiCreateLabel ( 32, 240, 500, 20, "", false, background )
pages['contacts_add'].cancel = guiCreateButton ( 42, 278, 168, 50, "Volver a Contactos", false, background )
pages['contacts_add'].add = guiCreateButton ( 42, 338, 168, 50, "Añadir Contacto", false, background )

-- Bank
pages['bank'] = { }
pages['bank'].bank_balance = guiCreateMemo ( 4, 11, 255, 70, "Actualmente, el saldo de tu cuenta es de: "..tostring(saldoCuenta).." dólares.", false, background)
guiMemoSetReadOnly ( pages['bank'].bank_balance, true )
          
-- Music
pages['music'] = { }
pages['music'].grid = guiCreateGridList ( 4, 8, 257, 210, false, background )
-- 1 fila
pages['music'].playord = guiCreateButton ( 87, 226, 80, 40, "Reproducir en orden", false, background  )
pages['music'].playrand = guiCreateButton ( 4, 226, 80, 40, "Reproducir aleatorio", false, background  )
pages['music'].play = guiCreateButton ( 170, 226, 88, 40, "Reproducir seleccionada", false, background  )
-- 2 fila  
pages['music'].stop = guiCreateButton ( 87, 276, 80, 40, "Parar", false, background  )
pages['music'].delete = guiCreateButton ( 4, 276, 80, 40, "Eliminar", false, background  )
pages['music'].help = guiCreateButton ( 170, 276, 88, 40, "Ayuda", false, background  )
pages['music'].lbl1 = guiCreateLabel ( 4, 321, 50, 20, "Nombre:", false, background )
pages['music'].lbl2 = guiCreateLabel ( 4, 346, 50, 20, "Palabras:", false, background )
pages['music'].add_name = guiCreateEdit ( 65, 321, 180, 20, "", false, background )
pages['music'].add_url = guiCreateEdit ( 65, 346, 180, 20, "", false, background )
pages['music'].add = guiCreateButton ( 57, 378, 138, 30, "Añadir canción", false, background )
--pages['music'].help = guiCreateButton ( 205, 378, 32, 32, "?", false, background )

guiGridListAddColumn ( pages['music'].grid, "Nombre", 0.45 )
guiGridListAddColumn ( pages['music'].grid, "Palabras clave", 0.45 )
guiSetFont ( pages['music'].lbl1, "default-bold-small" )
guiSetFont ( pages['music'].lbl2, "default-bold-small" )

-- Agenda
pages['notes'] = { }
pages['notes'].notes = guiCreateMemo ( 4, 11, 255, 370, "", false, background)
pages['notes'].save = guiCreateButton ( 130, 380, 120, 40, "Guardar", false, background  )
pages['notes'].exit = guiCreateButton ( 7, 380, 120, 40, "Salir", false, background  )

-- Vehicles
pages['vehicles'] = { }
pages['vehicles'].grid = guiCreateGridList ( 4, 11, 257, 330, false, background )
pages['vehicles'].locate = guiCreateButton ( 4, 383, 250, 25, "Localizar Vehículo", false, background )

guiGridListAddColumn ( pages['vehicles'].grid, "ID", 0.3 )
guiGridListAddColumn ( pages['vehicles'].grid, "Modelo", 0.6 )

-- GPS
pages['waypoints'] = { }
pages['waypoints'].grid = guiCreateGridList ( 4, 11, 257, 330, false, background )
pages['waypoints'].add_nameLbl = guiCreateLabel ( 4, 350, 257, 25, "Nombre:", false, background )
pages['waypoints'].add_name = guiCreateEdit ( 4, 375, 190, 25, "", false, background )
pages['waypoints'].add = guiCreateButton ( 197, 375, 50, 25, "Añadir", false, background )
guiGridListAddColumn ( pages['waypoints'].grid, "", 0.9 )
guiGridListSetSortingEnabled ( pages['waypoints'].grid, false )

-- flappy bird
pages['flappy'] = { }
pages['flappy'].lbl =  guiCreateLabel ( 10, 155, 200, 20, " ", false, background )

-- 2048
pages['_2048'] = { }
pages['_2048'].newGameButton = guiCreateButton(10, 322, 100, 30, "New Game", false, background)
pages['_2048'].closeButton = guiCreateButton(120, 540, 100, 50, "Close", false, background)
pages['_2048'].scoreLabel = guiCreateLabel(10, 362, 80, 50, "Score: 0", false, background)
pages['_2048'].gameState = guiCreateLabel(100, 250, 400, 200, "", false, background)
guiSetProperty(pages['_2048'].gameState,"AlwaysOnTop","true")
guiSetFont(pages['_2048'].gameState,"sa-gothic")
pages['_2048'].bg2048 = guiCreateStaticImage(0, 50, 262, 262, "images/2048/background.png", false, background)
pages['_2048'].dummyLabel = guiCreateLabel(30, 25, 80, 20, "2048", false, background)
guiSetFont(pages['_2048'].dummyLabel, "default-bold-small" )

-- Calc
pages['calc'] = { }
pages['calc'].lbl1 = guiCreateLabel ( 0, 13, 270, 20, "Introduce las operaciones y pulsa calcular", false, background )
guiLabelSetHorizontalAlign(pages['calc'].lbl1, "center", false)
--pages['calc'].grid = guiCreateGridList ( 4, 31, 257, 245, false, background )
pages['calc'].b1 = guiCreateButton ( 15, 31, 55, 55, "1", false, background )
pages['calc'].b2 = guiCreateButton ( 75, 31, 55, 55, "2", false, background )
pages['calc'].b3 = guiCreateButton ( 135, 31, 55, 55, "3", false, background )
pages['calc'].bmas = guiCreateButton ( 195, 31, 55, 55, "+", false, background )
pages['calc'].b4 = guiCreateButton ( 15, 91, 55, 55, "4", false, background )
pages['calc'].b5 = guiCreateButton ( 75, 91, 55, 55, "5", false, background )
pages['calc'].b6 = guiCreateButton ( 135, 91, 55, 55, "6", false, background )
pages['calc'].bmenos = guiCreateButton ( 195, 91, 55, 55, "-", false, background )
pages['calc'].b7 = guiCreateButton ( 15, 151, 55, 55, "7", false, background )
pages['calc'].b8 = guiCreateButton ( 75, 151, 55, 55, "8", false, background )
pages['calc'].b9 = guiCreateButton ( 135, 151, 55, 55, "9", false, background )
pages['calc'].bmulti = guiCreateButton ( 195, 151, 55, 55, "*", false, background )
pages['calc'].b0 = guiCreateButton ( 15, 211, 55, 55, "0", false, background )
pages['calc'].bpunto = guiCreateButton ( 75, 211, 55, 55, ".", false, background )
pages['calc'].bap = guiCreateButton ( 135, 211, 55, 55, "(", false, background )
pages['calc'].bcp = guiCreateButton ( 195, 211, 55, 55, ")", false, background )
pages['calc'].bexp = guiCreateButton ( 15, 271, 55, 55, "^", false, background )
pages['calc'].bdiv = guiCreateButton ( 75, 271, 55, 55, "/", false, background )
pages['calc'].bdelatr = guiCreateButton ( 135, 271, 55, 55, "<", false, background )
pages['calc'].bc = guiCreateButton ( 195, 271, 55, 55, "C", false, background )
pages['calc'].lbl2 = guiCreateLabel ( 80, 324, 300, 20, "Operación a realizar:", false, background )
guiSetFont(pages['calc'].lbl2 ,"default-bold-small")
pages['calc'].operacion = guiCreateEdit ( 40, 345, 180, 20, "", false, background )
pages['calc'].calc = guiCreateButton ( 60, 381, 142, 30, "Calcular", false, background )
  

for i, v in pairs ( pages['home'] ) do
	local w, h = guiGetSize ( v, false )
	local x, y = guiGetPosition ( v, false )
	local d = { pos = { x = x, y = y }, size = { w = w, h = h } }
	setElementData ( v, "NGPhone:Home:OriginalAppData", d )
end

function onPhoneRender ( )
	local x, y = guiGetPosition ( base, false )
	local now = getTickCount()
	if ( isOpen ) then
		local elapsedTime = now - open.startTime
		local duration = open.endTime - open.startTime
		local progress = elapsedTime / duration
		local sY, eY = open.startY, open.endY
		x, y, _ = interpolateBetween ( x, sy+10, 100, x, eY, 150,  progress, "OutBounce" )
		guiSetPosition ( base, x, y, false )
		if ( now >= open.endTime ) then
			open.allowClicking = true
		end
	else
		local elapsedTime = now - open.startTime
		local duration = open.endTime - open.startTime
		local progress = elapsedTime / duration
		local sY, eY = open.startY, open.endY
		x, y, _ = interpolateBetween ( x, eY, 100, x, sY, 150,  progress, "InBack" )
		guiSetPosition ( base, x, y, false )
		if ( now >= open.endTime ) then
			open.allowClicking = true
			isOpen = false
			guiSetVisible ( base, false )
			isRender = false
			showCursor ( false )
			if ( isElement( updateTimeTimer ) ) then
				killTimer ( updateTimeTimer )
			end
			removeEventHandler ( "onClientPreRender", root, onPhoneRender )
			removeEventHandler ( "onClientClick", root, clickingHandler )
			removeEventHandler ( "onClientGUIClick", root, clickingHandler2 )
		end
	end
	phone_x = x
	phone_y = y
	dxDrawFixedText ( "Telefónica de Los Santos",  x, y+78, 350, 20, tocolor ( 255, 255, 255, 255 ), 1, "default-bold", "center", "top", false, false, true )
	Draw2048Images ( )
	if ( LoadedPage == "home" ) then
		local x1, y1 = guiGetPosition ( base, false )
		local x2, y2 = guiGetPosition ( background, false )
		local x1, y1 = x1 + x2, y2 + y1
		for i, v in pairs ( pages [ 'home' ]  ) do
			local org = getElementData ( v, "NGPhone:Home:OriginalAppData" )
			local a = guiGetAlpha ( v )
			if ( getElementData ( v, "isHoveringOnGUIElement" ) ) then
				guiSetSize ( v, appSize + 6, appSize + 6, false )
				guiSetPosition ( v, org.pos.x-3, org.pos.y-3, false )
				local x, y = guiGetPosition ( v, false )
				local w, h = guiGetSize ( v, false )
				dxDrawText ( getElementData ( v, "tooltip-text" ), x+x1+1, y+h+3+y1, x+w+x1, y+h+5+y1, tocolor ( 0, 0, 0, a * 255 ), 1, "default-bold", "center", "top", false, false, true )
				dxDrawText ( getElementData ( v, "tooltip-text" ), x+x1, y+h+2+y1, x+w+x1, y+h+4+y1, tocolor ( 255, 255, 255, a * 255 ), 1, "default-bold", "center", "top", false, false, true )
				if ( a ~= 1 ) then
					a = a + 0.008
					if ( a > 1 ) then
						a = 1
					end
				end
			else
				guiSetSize ( v, org.size.w, org.size.h, false )
				guiSetPosition ( v, org.pos.x, org.pos.y, false )
				if ( a ~= 0.8 ) then
					a = a - 0.008
					if ( a < 0.8 ) then
						a = 0.8
					end
				end
			end
			guiSetAlpha ( v, a )
		end
	end
end

function clickingHandler ( s, b, x, y )
	if ( s == "left" and b == "up" ) then
		-- home page
		if ( x >= phone_x + 160 and x <= phone_x + 190 and y >= phone_y + 522 and y <= phone_y + 545 ) then
			if ( LoadedPage ~= "home" ) then
				setPhonePageOpen ( "home" )
			else
				setPhoneOpen ( false )
			end
		elseif ( x >= phone_x + 75 and x <= phone_x + 105 and y >= phone_y + 523 and y <= phone_y + 548 ) then
			setPhoneOpen ( false )
		end
	end
end

function clickingHandler2 ( b, s )
	if ( b ~= "left"  or s ~= "up" ) then
		return
	end
	if ( LoadedPage == "home" ) then
		if ( source == pages['home'].base_sms ) then
			setPhonePageOpen ( 'sms' )
			guiGridListClear ( pages['sms'].grid )
			for i, v in ipairs ( tablaSMS ) do
				local r = guiGridListAddRow ( pages['sms'].grid )
				guiGridListSetItemText ( pages['sms'].grid, r, 1, tostring ( "SMS de "..tostring(numeroAContacto(v.tlf_emisor)) ), false, false )
				guiGridListSetItemData ( pages['sms'].grid, r, 1, tonumber(v.sms_ID))
			end
		elseif ( source == pages['home'].base_call ) then
			setPhonePageOpen ( 'call' )
			guiGridListClear ( pages['call'].grid )
			for i, v in ipairs ( tablaContactos ) do
				local r = guiGridListAddRow ( pages['call'].grid )
				guiGridListSetItemText ( pages['call'].grid, r, 1, tostring ( v.nombre ), false, false )
				guiGridListSetItemText ( pages['call'].grid, r, 2, tostring ( v.tlf_contacto ), false, false )
				guiGridListSetItemData ( pages['call'].grid, r, 1, tonumber(v.contacto_ID) )
			end
		elseif ( source == pages['home'].base_contacts ) then
			setPhonePageOpen ( 'contacts' )
			guiGridListClear ( pages['contacts'].grid )
			for i, v in ipairs ( tablaContactos ) do
				local r = guiGridListAddRow ( pages['contacts'].grid )
				guiGridListSetItemText ( pages['contacts'].grid, r, 1, tostring ( v.nombre ), false, false )
				guiGridListSetItemText ( pages['contacts'].grid, r, 2, tostring ( v.tlf_contacto ), false, false )
				guiGridListSetItemData ( pages['contacts'].grid, r, 1, tonumber(v.contacto_ID) )
			end
		elseif ( source == pages['home'].base_bank ) then
			setPhonePageOpen ( "bank" )
			guiSetText(pages['bank'].bank_balance, "Actualmente, el saldo de tu cuenta es de: "..tostring(saldoCuenta).." dólares.")
		elseif ( source == pages['home'].base_music ) then
			setPhonePageOpen ( 'music' )
			guiGridListClear ( pages['music'].grid )
			ncanc = 0
			for i, v in ipairs ( getRadioStations ( ) ) do 
				local name, url = unpack ( v )
				local row = guiGridListAddRow ( pages['music'].grid )
				guiGridListSetItemText ( pages['music'].grid, row, 1, name, false, false )
				guiGridListSetItemText ( pages['music'].grid, row, 2, url, false, false )
				guiGridListSetItemData ( pages['music'].grid, row, 2, tonumber(ncanc) )
				ncanc = ncanc+1
			end
		elseif ( source == pages['home'].base_notes ) then
			setPhonePageOpen ( 'notes' )
			guiSetText(pages['notes'].notes, textoAgenda)
		elseif ( source == pages['home'].base_waypoints ) then
			setPhonePageOpen ( "waypoints" )
			guiGridListClear ( pages['waypoints'].grid )
			appFunctions.waypoints:onPanelLoad ( )
		elseif ( source == pages['home'].base_vehicles ) then
			setPhonePageOpen ( "vehicles" )
			guiGridListClear(pages['vehicles'].grid)
			for i, v in ipairs ( tablaVehiculos ) do                       
				local r = guiGridListAddRow ( pages['vehicles'].grid )
				guiGridListSetItemText ( pages['vehicles'].grid, r, 1, tostring ( v.vehicleID ), false, false )
				guiGridListSetItemText ( pages['vehicles'].grid, r, 2, tostring ( getVehicleNameFromModel(v.model) ), false, false )
				guiGridListSetItemData ( pages['vehicles'].grid, r, 1, tonumber(v.vehicleID) )
			end
		elseif ( source == pages['home'].base_off ) then
			outputChatBox("Has apagado tu teléfono correctamente.", 255, 0, 0)
			setPhoneOpen(false)
			triggerServerEvent("onApagarTelefono", getLocalPlayer(), getLocalPlayer())
		elseif ( source == pages['home'].base_flappy ) then
			setPhonePageOpen ( "flappy" )
			appFunctions.flappy:onPageOpen()
		elseif ( source == pages['home'].base_2048 ) then
			setPhonePageOpen ( "_2048" )
			appFunctions._2048:onPageOpen()
		elseif ( source == pages['home'].base_calc ) then
			setPhonePageOpen ( "calc" )
		end
	elseif ( LoadedPage == "call" ) then	
		if ( source == pages['call'].grid ) then
			local row, col = guiGridListGetSelectedItem ( source )
			if ( row ~= -1 ) then
				local numero = guiGridListGetItemText(source, row, 2)
				if numero and tonumber(numero) then
					guiSetText(pages['call'].number, tostring(numero))
				end
			end
		elseif ( source == pages['call'].call ) then
			local numero = guiGetText(pages['call'].number)
			if numero then
				reproducirSonidoTLF(0)
				local noculto = string.upper(string.sub(tostring(numero), 1, 4))
				if noculto and noculto == "#31#" then
					numero2 = tonumber(string.sub(tostring(numero), 5))
				else
					numero2 = tonumber(numero)
				end
				timerLlamada[getLocalPlayer()] = setTimer(triggerServerEvent, 6000, 1, "onRealizarLlamada", getLocalPlayer(), getLocalPlayer(), tonumber(getElementData(getLocalPlayer(), "numeroTelefono")), numero, 1)
				guiSetText(pages['calling'].lbl1, "Llamando A")
				guiSetText(pages['calling'].lbl2, numeroAContacto(tonumber(numero2)))
			end
			setPhonePageOpen ( 'calling' )
		end	
	elseif ( LoadedPage == "calling" ) then
		if ( source == pages['calling'].colgar ) then
			triggerServerEvent("onColgarLlamada", getLocalPlayer(), getLocalPlayer(), true)
			pararSonidoTLF()
			setPhonePageOpen ( 'home' )
			if timerLlamada[getLocalPlayer()] and isTimer(timerLlamada[getLocalPlayer()]) then killTimer(timerLlamada[getLocalPlayer()]) timerLlamada[getLocalPlayer()] = nil end
		end
	elseif ( LoadedPage == "calling_r" ) then
		if ( source == pages['calling_r'].colgar ) then
			triggerServerEvent("onColgarLlamada", getLocalPlayer(), getLocalPlayer())
			pararSonidoTLF()
			setPhonePageOpen ( 'home' )
		elseif	( source == pages['calling_r'].responder ) then
			local numero = guiGetText(pages['calling_r'].lbl2)
			setPhonePageOpen ( 'calling' )
			guiSetText(pages['calling'].lbl1, "En Llamada")
			if tostring(tonumber(numero)) == "nil" then
				guiSetText(pages['calling'].lbl2, numeroAContacto("N. Privado"))
			else
				guiSetText(pages['calling'].lbl2, numeroAContacto(tonumber(numero)))
			end
			triggerServerEvent("onContestarLlamada", getLocalPlayer(), getLocalPlayer())
		end
	elseif ( LoadedPage == "sms" ) then
		if ( source == pages['sms'].grid ) then
			local row, col = guiGridListGetSelectedItem ( source )
			guiSetText ( pages['sms'].messages, "" )
			pages['sms'].selectedSMS = nil
			if ( row ~= -1 ) then
				pages['sms'].selectedSMS = guiGridListGetItemData(pages['sms'].grid, row, col)
				for k, v in ipairs(tablaSMS) do
					if tonumber(v.sms_ID) == tonumber(pages['sms'].selectedSMS) then
						guiSetText(pages['sms'].messages, "SMS de : "..tostring(numeroAContacto(v.tlf_emisor)).."\nFecha y Hora: "..tostring(v.fecha).."\nMensaje: "..tostring(v.msg))
					end
				end
			end
		elseif ( source == pages['sms'].delete ) then
			local row, col = guiGridListGetSelectedItem ( pages['sms'].grid )
			pages['sms'].selectedSMS = nil
			if ( row ~= -1 ) then
				pages['sms'].selectedSMS = guiGridListGetItemData(pages['sms'].grid, row, col)
				if pages['sms'].selectedSMS and tonumber(pages['sms'].selectedSMS) then
					triggerServerEvent("onEliminarSMS", getLocalPlayer(), tonumber(pages['sms'].selectedSMS))
					for k, v in ipairs(tablaSMS) do
						if tonumber(v.sms_ID) == tonumber(pages['sms'].selectedSMS) then
							table.remove(tablaSMS, k)
						end
					end
					guiGridListRemoveRow(pages['sms'].grid, row)
				end
			end
		elseif ( source == pages['sms'].new ) then
			setPhonePageOpen('sms_new')
			destroyElement(pages['sms_new'].grid)
			pages['sms_new'].grid = guiCreateGridList ( 4, 26, 257, 130, false, background )
			guiGridListAddColumn ( pages['sms_new'].grid, "Nombre", 0.45 )
			guiGridListAddColumn ( pages['sms_new'].grid, "Telefono", 0.45 )
			for i, v in ipairs ( tablaContactos ) do
				local r = guiGridListAddRow ( pages['sms_new'].grid )
				guiGridListSetItemText ( pages['sms_new'].grid, r, 1, tostring ( v.nombre ), false, false )
				guiGridListSetItemText ( pages['sms_new'].grid, r, 2, tostring ( v.tlf_contacto ), false, false )
				guiGridListSetItemData ( pages['sms_new'].grid, r, 1, tonumber(v.contacto_ID) )
			end
		end 
	elseif ( LoadedPage == "sms_new" ) then
		if ( source == pages['sms_new'].grid ) then
			local row, col = guiGridListGetSelectedItem ( source )
			if ( row ~= -1 ) then
				local numero = guiGridListGetItemText(source, row, 2)
				if numero and tonumber(numero) then
					guiSetText(pages['sms_new'].number, tostring(numero))
				end
			end
		elseif ( source == pages['sms_new'].send ) then
			local mensaje = guiGetText(pages['sms_new'].message)
			if tostring(mensaje) == "Escribe aquí el mensaje a enviar." then
				outputChatBox("Por favor, escribe el mensaje a enviar.", 255, 0, 0)
				return
			end
			local numero = guiGetText(pages['sms_new'].number)
			if numero then
				if tonumber(numero) then
					triggerServerEvent("onRealizarSMS", localPlayer, localPlayer, getElementData(localPlayer, "numeroTelefono"), numero, mensaje)
					guiSetText(pages['sms_new'].message, "Escribe aquí el mensaje a enviar.")
				else
					outputChatBox("El número introducido no es válido.", 255, 0, 0)
				end
			else
				outputChatBox("Introduce un número o selecciona un contacto.", 255, 0, 0)
			end
		elseif ( source == pages['sms_new'].cancel ) then
			setPhonePageOpen('sms')
		end
	elseif ( LoadedPage == "contacts" ) then
		if ( source == pages['contacts'].delete ) then
			local row, col = guiGridListGetSelectedItem ( pages['contacts'].grid )
			pages['contacts'].selectedContacto = nil
			if ( row ~= -1 ) then
				pages['contacts'].selectedContacto = guiGridListGetItemData(pages['contacts'].grid, row, col)
				if pages['contacts'].selectedContacto and tonumber(pages['contacts'].selectedContacto) then
					triggerServerEvent("onEliminarContacto", getLocalPlayer(), tonumber(pages['contacts'].selectedContacto))
					for k, v in ipairs(tablaContactos) do
						if tonumber(v.contacto_ID) == tonumber(pages['contacts'].selectedContacto) then
							table.remove(tablaContactos, k)
						end
					end
					guiGridListRemoveRow(pages['contacts'].grid, row)
				end
			end
		elseif ( source == pages['contacts'].new ) then
			setPhonePageOpen ( 'contacts_add' )
		end
	elseif ( LoadedPage == "contacts_add" ) then
		if (  source == pages['contacts_add'].add ) then
			local nombre = guiGetText(pages['contacts_add'].add_name)
			local telefono = guiGetText(pages['contacts_add'].add_number)
			if tostring (nombre) == "" or tostring(telefono) == "" then
				guiSetText(pages['contacts_add'].lbl3, "No puedes dejar ningún dato en blanco.")
			elseif not tonumber(telefono) then
				guiSetText(pages['contacts_add'].lbl3, "El número introducido no es válido.")
			else
				guiSetText(pages['contacts_add'].lbl3, "Contacto añadido correctamente.")
				triggerServerEvent("onAñadirContacto", getLocalPlayer(), nombre, telefono)
				guiSetText(pages['contacts_add'].add_name, "")
				guiSetText(pages['contacts_add'].add_number, "")
				triggerServerEvent("onSoliciarTablasNecesarias", getLocalPlayer())
			end
		elseif ( source == pages['contacts_add'].cancel ) then
			guiSetText(pages['contacts_add'].lbl3, "")
			setPhonePageOpen ( 'contacts' )
			guiGridListClear ( pages['contacts'].grid )
			for i, v in ipairs ( tablaContactos ) do
				local r = guiGridListAddRow ( pages['contacts'].grid )
				guiGridListSetItemText ( pages['contacts'].grid, r, 1, tostring ( v.nombre ), false, false )
				guiGridListSetItemText ( pages['contacts'].grid, r, 2, tostring ( v.tlf_contacto ), false, false )
				guiGridListSetItemData ( pages['contacts'].grid, r, 1, tonumber(v.contacto_ID) )
			end
		end	
	elseif ( LoadedPage == "notes" ) then	
		if ( source == pages['notes'].save ) then
			local texto = guiGetText(pages['notes'].notes)
			if texto then
				triggerServerEvent("onActualizarAgendaMovil", localPlayer, texto)
				textoAgenda = texto
			end
		elseif ( source == pages['notes'].exit ) then
			setPhonePageOpen("home")
		end
	elseif ( LoadedPage == "music" ) then
		if ( source == pages['music'].add ) then
			local name = tostring ( guiGetText ( pages['music'].add_name ) )
			local url = tostring ( guiGetText ( pages['music'].add_url ) )
			if ( name:gsub(" ", "" ) == "" or url:gsub(" ","" ) == "" ) then
				return outputChatBox("Necesitas introducir nombre y palabras de búsqueda de la canción.", 255, 0, 0)
			end 
			local scroll = guiGridListGetVerticalScrollPosition ( pages['music'].grid )
			addRadioStation ( name, url )
			outputChatBox( "¡Canción añadida! "..name.." -> "..url, 200, 255, 200 )
			
			guiGridListClear ( pages['music'].grid )
			for i, v in ipairs ( getRadioStations ( ) ) do 
				local name2, url2 = unpack ( v )
				local row = guiGridListAddRow ( pages['music'].grid )
				guiGridListSetItemText ( pages['music'].grid, row, 1, name2, false, false )
				guiGridListSetItemText ( pages['music'].grid, row, 2, url2, false, false )
				if ( name2 == name and url2 == url ) then
					guiGridListSetSelectedItem ( pages['music'].grid, row, 1 )
				end
			end
			guiGridListSetVerticalScrollPosition ( pages['music'].grid, scroll )
		elseif ( source == pages['music'].help ) then
			outputChatBox("=== REPRODUCTOR DE MÚSICA V.1 ===", 255, 255, 255)
			outputChatBox("Con él, podrás crear tu propia playlist y escucharla cuando quieras.", 0, 255, 0)
			outputChatBox("Para añadir una canción, pon en nombre como quieras llamar la canción", 255, 255, 0)
			outputChatBox("Y en palabras, lo que usas en el /radio para que suene, ejemplo:", 255, 255, 0)
			outputChatBox("Nombre: mi cancion favorita. Palabras: daddy yankee limbo", 255, 255, 255)
			outputChatBox("Cualquier duda más, acude al foro para más información o usa /duda.", 0, 255, 0)
		elseif ( source == pages['music'].delete ) then
			local row, col = guiGridListGetSelectedItem ( pages['music'].grid )
			if ( row ~= -1 ) then
				local scroll = guiGridListGetVerticalScrollPosition ( pages['music'].grid )
				local name = guiGridListGetItemText ( pages['music'].grid, row, 1 )
				local url = guiGridListGetItemText ( pages['music'].grid, row, 2 )
				removeRadioStation ( name, url )
				guiGridListClear ( pages['music'].grid )
				for i, v in ipairs ( getRadioStations ( ) ) do 
					local name2, url2 = unpack ( v )
					local row = guiGridListAddRow ( pages['music'].grid )
					guiGridListSetItemText ( pages['music'].grid, row, 1, name2, false, false )
					guiGridListSetItemText ( pages['music'].grid, row, 2, url2, false, false )
				end
				guiGridListSetVerticalScrollPosition ( pages['music'].grid, scroll )
			else
				outputChatBox( "No has seleccionado ninguna canción.", 255, 0, 0 )
			end
		elseif ( source == pages['music'].play ) then
			local row, col = guiGridListGetSelectedItem ( pages['music'].grid )
			if ( row ~= -1 ) then
				if soundLocal==true then
					typeSound=nil
					actualSound = nil
					triggerEvent ( "onStopPlayLocalMusic", getLocalPlayer(), getLocalPlayer() )
				end
				local cancionAct = guiGridListGetItemData ( pages['music'].grid, row, 2 )
				soundLocal = true
				typeSound = 1 -- Tipo 1, única canción.
				actualSound = cancionAct
				outputChatBox ( "Vas a escuchar "..guiGridListGetItemText ( pages['music'].grid, row, 1 ).." @ "..guiGridListGetItemText ( pages['music'].grid, row, 2 ), 0, 255, 0 )
				triggerServerEvent("onRadioLocal", getLocalPlayer(), tostring(guiGridListGetItemText ( pages['music'].grid, row, 2 )))
			else
				outputChatBox( "No has seleccionado ninguna canción.", 255, 0, 0 )
			end
		elseif ( source == pages['music'].playord ) then -- Una canción tras otra.
			local row, col = guiGridListGetSelectedItem ( pages['music'].grid )
			if ( row ~= -1 ) then
				if soundLocal==true then
					typeSound=nil
					actualSound = nil
					triggerEvent ( "onStopPlayLocalMusic", getLocalPlayer(), getLocalPlayer() )
				end
				local cancionAct = guiGridListGetItemData ( pages['music'].grid, row, 2 )
				soundLocal = true
				typeSound = 2 -- Tipo 2, en orden.
				actualSound = cancionAct
				outputChatBox ( "Vas a escuchar "..guiGridListGetItemText ( pages['music'].grid, row, 1 ).." @ "..guiGridListGetItemText ( pages['music'].grid, row, 2 ), 0, 255, 0 )
				triggerServerEvent("onRadioLocal", getLocalPlayer(), tostring(guiGridListGetItemText ( pages['music'].grid, row, 2 )))
			else
				outputChatBox( "No has seleccionado ninguna canción.", 255, 0, 0 )
			end
		elseif ( source == pages['music'].playrand ) then -- Canciones aleatorias
			local maximo = guiGridListGetRowCount(pages['music'].grid)
			if maximo < 3 then outputChatBox("Ten al menos 3 canciones para activar el modo aleatorio.", 255, 0, 0) return end
			local row = math.random(0, maximo)
			if soundLocal==true then
				typeSound=nil
				actualSound = nil  
				triggerEvent ( "onStopPlayLocalMusic", getLocalPlayer(), getLocalPlayer() )
			end
			local cancionAct = guiGridListGetItemData ( pages['music'].grid, row, 2 )
			soundLocal = true
			typeSound = 3 -- Tipo 2, en orden.
			actualSound = cancionAct
			outputChatBox ( "Vas a escuchar "..guiGridListGetItemText ( pages['music'].grid, row, 1 ).." @ "..guiGridListGetItemText ( pages['music'].grid, row, 2 ), 0, 255, 0 )
			triggerServerEvent("onRadioLocal", getLocalPlayer(), tostring(guiGridListGetItemText ( pages['music'].grid, row, 2 )))
		elseif ( source == pages['music'].stop ) then
			outputChatBox ( "Has parado el reproductor de música.", 255, 255, 0 )
			soundLocal = false
			typeSound=nil
			actualSound = nil				
			triggerEvent ( "onStopPlayLocalMusic", getLocalPlayer(), getLocalPlayer() )
		end
	elseif ( LoadedPage == "waypoints" ) then
		 exports.NGPlayerFunctions:waypointUnlocate()
		 appFunctions.waypoints:onPanelLoad ( ) 
		if ( source == pages['waypoints'].grid ) then
			
			local row, col = guiGridListGetSelectedItem ( source );
			local text = nil;
			
			if ( row == -1 and exports.ngplayerfunctions:waypointIsTracking( ) ) then 
				exports.ngmessages:sendClientMessage ( "Un-locating current target!" );
				exports.NGPlayerFunctions:waypointUnlocate( );
			end 
			
			if ( row > -1 ) then 
				text = guiGridListGetItemText ( source, row, 1 );
			end 
			
			if ( WaypointPage == "main" ) then 
				if ( WayPointLocs [ text ] ) then 
					guiGridListClear ( source )
					
					guiGridListSetItemText ( source, guiGridListAddRow ( source ), 1, "<< Back <<", false, false  );
					guiGridListSetItemText ( source, guiGridListAddRow ( source ), 1, "", true, true  );
					
					WaypointPage = text;
					if ( WaypointPage == "Locations" ) then 
						for location, data in pairs ( WayPointLocs [ 'Locations' ] ) do 
							guiGridListSetItemText ( source, guiGridListAddRow ( source ), 1, tostring ( location ), true, true  );
							for index, _data in ipairs ( data ) do 
								local row = guiGridListAddRow ( source );
								guiGridListSetItemText ( source, row, 1, tostring ( _data [ 1 ] ), false, false );
								guiGridListSetItemData ( source, row, 1, table.concat({_data[2], _data[3], _data[4]},"," ) );
							end 
						end 
					else
						for index, _data in ipairs ( WayPointLocs [ text ] ) do 
							local row = guiGridListAddRow ( source );
							guiGridListSetItemText ( source, row, 1, tostring ( _data [ 1 ] ), false, false );
							guiGridListSetItemData ( source, row, 1, table.concat({_data[2], _data[3], _data[4]},"," ) );
						end 
					end 
					
				end 
			end 
			
			if ( text == "<< Back <<" ) then 
				guiGridListClear ( source );
				appFunctions.waypoints:onPanelLoad ( );
				WaypointPage = "main";
			elseif ( guiGridListGetItemData ( source, row, 1 ) ) then 
				local pos = split ( guiGridListGetItemData ( source, row, 1 ), "," );
				if ( #pos == 3 ) then 
					if ( WaypointPage ~= "Players" ) then
						local x, y, z = tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3])
						if ( exports.ngplayerfunctions:createWaypointLoc ( x, y, z ) ) then
							exports.ngmessages:sendClientMessage( "Now tracking '"..tostring(guiGridListGetItemText(source,row,1)).."'", 255, 255, 0 );
						end
					else 
						if ( getPlayerFromName ( text ) ) then
							if ( exports.ngplayerfunctions:createWaypointLoc ( 0, 0, 0 ) and exports.ngplayerfunctions:setWaypointAttachedToElement ( getPlayerFromName ( text ) ) ) then
								exports.ngmessages:sendClientMessage( "Now tracking "..tostring(text), 255, 255, 0 );
							else 
								exports.ngmessages:sendClientMessage ( "Unable to track this player!", 200, 60, 60 );
							end
						else 
							exports.ngmessages:sendClientMessage ( "Sorry, that player has changed their name or has disconnected", 200, 60, 60 );
						end 
					end 
				end 
			end 
			
			
		elseif ( source == pages['waypoints'].add ) then
			appFunctions.waypoints:addWaypoint ( )
		end
	elseif ( LoadedPage == "vehicles" ) then
		if ( source == pages['vehicles'].locate ) then
			local row, col = guiGridListGetSelectedItem ( pages['vehicles'].grid )
			if ( row ~= -1 ) then
				local vehicleID = guiGridListGetItemData ( pages['vehicles'].grid, row, 1 )
				triggerServerEvent ( "onLocalizarVehiculo", localPlayer, localplayer, "lveh", tonumber(vehicleID))
			end
		end
	elseif ( LoadedPage == "calc" ) then
		if ( source == pages['calc'].b1 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."1")
		elseif ( source == pages['calc'].b2 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."2")
			elseif ( source == pages['calc'].b3 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."3")
		elseif ( source == pages['calc'].b4 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."4")
		elseif ( source == pages['calc'].b5 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."5")
		elseif ( source == pages['calc'].b6 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."6")
		elseif ( source == pages['calc'].b7 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."7")
		elseif ( source == pages['calc'].b8 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."8")
		elseif ( source == pages['calc'].b9 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."9")
		elseif ( source == pages['calc'].b0 ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."0")
		elseif ( source == pages['calc'].bmas ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."+")
		elseif ( source == pages['calc'].bmenos ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."-")
		elseif ( source == pages['calc'].bpunto ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text..".")
		elseif ( source == pages['calc'].bap ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."(")
		elseif ( source == pages['calc'].bcp ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text..")")
		elseif ( source == pages['calc'].bmulti ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."*")
		elseif ( source == pages['calc'].bdiv ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."/")
		elseif ( source == pages['calc'].bdelatr ) then -- Borrar ultimo caracter
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text:sub(1, -2))
		elseif ( source == pages['calc'].bexp ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, text.."^")
		elseif ( source == pages['calc'].bc ) then
			local text = guiGetText(pages['calc'].operacion)
			guiSetText(pages['calc'].operacion, "")
		elseif ( source == pages['calc'].calc ) then
			local text = guiGetText(pages['calc'].operacion)
			if calculate(text) then
				guiSetText(pages['calc'].lbl2, tostring("Resultado: "..tostring(calculate(text))))
			else
				guiSetText(pages['calc'].lbl2, tostring("Operación inválida."))
			end
		end
	end
end

function cancionTerminadaMovil()
	if soundLocal == true then
		if typeSound == 2 then -- En orden
			row = actualSound+1
			local cancionAct = guiGridListGetItemData ( pages['music'].grid, row, 2 )
			if cancionAct then
				actualSound = cancionAct
				outputChatBox ( "Ahora estás escuchando "..guiGridListGetItemText ( pages['music'].grid, row, 1 ).." @ "..guiGridListGetItemText ( pages['music'].grid, row, 2 ), 0, 255, 0 )
				triggerServerEvent("onRadioLocal", getLocalPlayer(), tostring(guiGridListGetItemText ( pages['music'].grid, row, 2 )))
			else
				row=0
				cancionAct=guiGridListGetItemData ( pages['music'].grid, row, 2 )
				actualSound = cancionAct
				outputChatBox ( "Ahora estás escuchando "..guiGridListGetItemText ( pages['music'].grid, row, 1 ).." @ "..guiGridListGetItemText ( pages['music'].grid, row, 2 ), 0, 255, 0 )
				triggerServerEvent("onRadioLocal", getLocalPlayer(), tostring(guiGridListGetItemText ( pages['music'].grid, row, 2 )))	
			end
		elseif typeSound == 3 then              
			local maximo = guiGridListGetRowCount( pages['music'].grid)
			local row = math.random(0, maximo)
			if row == actualSound then
				if actualSound > 0 then
					row = 0
				else
					row = 1
				end
			end
			if soundLocal==true then
				typeSound=nil
				actualSound = nil
				triggerEvent ( "onStopPlayLocalMusic", getLocalPlayer(), getLocalPlayer() )
			end
			local cancionAct = guiGridListGetItemData ( pages['music'].grid, row, 2 )
			soundLocal = true
			typeSound = 3 -- Tipo 3, en orden aleatorio.
			actualSound = cancionAct
			outputChatBox ( "Vas a escuchar "..guiGridListGetItemText ( pages['music'].grid, row, 1 ).." @ "..guiGridListGetItemText ( pages['music'].grid, row, 2 ), 0, 255, 0 )
			triggerServerEvent("onRadioLocal", getLocalPlayer(), tostring(guiGridListGetItemText ( pages['music'].grid, row, 2 )))
		end
	end
end
addEvent("onCancionLocalTerminada", true)
addEventHandler("onCancionLocalTerminada", getLocalPlayer(), cancionTerminadaMovil)

function calculate(text)
    text = text..'€'
    local number = ''
    for i,sinal,result in text:gmatch("(%(*%d+%.*%d*%)*)%s*([+-/%*^%%])") do
    number = number ..i..sinal
    end
    if text:match(".+%s*(%([-]*%d+%)*)€") then
    number = number..text:match(".+%s*(%([-]*%d+%)*)€")
    elseif text:match('.+%s*(%(*[-]%d+%.*%d*%)*)€') then
    if number:sub(number:len(),number:len()) ~= '-' then
    number = number..text:match('%l*(%(*[-]%d+%.*%d*%)*)€')
    else
    number = number..text:match('%l*(%(*%d+%.*%d*%)*)€')
    end
    elseif text:match("%l*(%(*[-]*%d+%.*%d*%)*)€") then
    number = number..text:match('%l*(%(*[-]*%d+%)*)€')
    end
    if number == "" then
    return false
    end
    local f,result = loadstring("return "..number)
    if not f and result then
    return false
    end
    local f,result = pcall(f)
    if not f and result then    return false
    end
    return tostring(result)
end

function getThisTime ( )
	local time = getRealTime ( )
	local s = time.second
	local m = time.minute
	local h = time.hour
	if ( s < 10 ) then s = "0"..s end
	if ( m < 10 ) then m = "0"..m end
	if ( h < 10 ) then h = "0"..h end
	return s, m, h
end

function setPhonePageOpen ( page )
	LoadedPage = page
	guiSetInputMode ( "no_binds_when_editing" )
	for i, v in pairs ( pages ) do
		for k, e in pairs ( v ) do
			if ( isGUIElement ( e ) ) then
				guiSetVisible ( e, false )
			end
		end
	end
	for i, v  in pairs ( pages[page] ) do
		if ( isGUIElement ( v ) ) then
			guiSetVisible ( v, true )
		end
	end
	if ( page ~= "flappy" and flappy ) then
		flappyBirdGame:Destructor();
		flappy = false
	end
end

function setPhoneOpen ( bool )
	open.startTime = getTickCount ( )       
	open.endTime = getTickCount ( ) + 1000
	if bool then
		isOpen = true
		triggerServerEvent("onSoliciarTablasNecesarias", getLocalPlayer())
		if not isRender then
			isRender = true
			guiSetVisible ( base, true )
			updateTimeTimer()
			updateTimeTimerPhone = setTimer ( updateTimeTimer, 1000, 0 )
			setPhonePageOpen ( "home" )
			addEventHandler ( "onClientPreRender", root, onPhoneRender )
			addEventHandler ( "onClientClick", root, clickingHandler )
			addEventHandler ( "onClientGUIClick", root, clickingHandler2 )
		end
	else
		if ( page ~= "flappy" and flappy ) then
			flappyBirdGame:Destructor();
			flappy = false
		end
		isOpen = false
		if ( isTimer ( updateTimeTimerPhone ) ) then
			killTimer ( updateTimeTimerPhone )
		end
	end
end

function abrirTelefono()
	exports.gui:hide()
	guiSetText ( pages['notes'].notes, tostring ( getSetting ( "notes" ) ) )
	setPhoneOpen ( true )
	setPhonePageOpen ( 'home' )
end
addEvent("onAbrirTelefono", true)
addEventHandler("onAbrirTelefono", getRootElement(), abrirTelefono)

function cerrarTelefono()
	setPhoneOpen( false )
end
addEvent("onCerrarTelefono", true)
addEventHandler("onCerrarTelefono", getRootElement(), cerrarTelefono)

function dxDrawFixedText ( text, x, y, w, h, c, scale, font, ax, ay, clip, wordBreak, postGUI )
	local c =c or tocolor ( 255, 255, 255, 255 )
	local scale = scale or 1
	local font = font or "default"
	local ax = ax or "left"
	local ay = ay or "top"
	local clip = clip or false
	local wordBreak = wordBreak or false
	local postGUI = postGUI or false
	return dxDrawText ( text, x, y, x+w, y+h, c, scale, font, ax, ay, clip, wordBreak, postGUI )
end

function isGUIElement ( element )
	if ( element and isElement ( element ) ) then
		local t = tostring ( getElementType ( element ) )
		if ( string.sub ( t, 1, 4 ) == "gui-" ) then
			return true
		end
	end
	return false
end

----------------------------------------------------------
-- Confirmation WIndow									--
----------------------------------------------------------
local confirmWindowArgs = { } 
local confirm = {}
confirm.window = guiCreateWindow( ( sx / 2 - 324 / 2 ), ( sy / 2 - 143 /2 ), 324, 143, "Confirm", false)
confirm.text = guiCreateLabel(10, 35, 304, 65, "", false, confirm.window)
guiSetVisible ( confirm.window, false )
guiSetFont(confirm.text, "default-bold-small")
guiLabelSetHorizontalAlign(confirm.text, "left", true)
guiWindowSetSizable ( confirm.window, false )
confirm.yes = guiCreateButton(10, 100, 108, 25, "Confirm", false, confirm.window)
confirm.no = guiCreateButton(128, 100, 108, 25, "Deny", false, confirm.window)

function onConfirmClick( ) 
	if ( source ~= confirm.yes and source ~= confirm.no ) then return end
	
	removeEventHandler ( "onClientGUIClick", root, onConfirmClick )
	guiSetVisible ( confirm.window, false )
	local v = false
	if ( source == confirm.yes ) then
		v = true
	end
	confirmWindowArgs.callback ( v, unpack ( confirmWindowArgs.args ) )
	confirmWindowArgs.args = nil
	confirmWindowArgs.callback = nil
end

function askConfirm ( question, callback_, ... )
	if ( not callback_ or type ( callback_ ) ~= "function" ) then
		return false
	end
	
	guiSetVisible ( confirm.window, true )
	guiSetText ( confirm.text, tostring ( question ) )
	confirmWindowArgs.callback = callback_
	confirmWindowArgs.args = { ... }
	addEventHandler ( "onClientGUIClick", root, onConfirmClick )
	guiBringToFront ( confirm.window )
	return true
end

--[[
	CASOS POSIBLES:
	- 0 SONIDO LLAMANDO
	- 1 AVERIA
	- 2 NO EXISTE
	- 3 APAGADO O FUERA DE COBERTURA
	- 4 RESTRINGIDAS: SALIENTES
	- 5 RESTRINGIDAS: ENTRANTES
	- 6 COMUNICANDO
	- 7 TONO ESPECIAL
]]

function reproducirSonidoTLF (caso)
	pararSonidoTLF()
	if caso then
		sonido = playSound("audio/"..tostring(caso)..".mp3")
		if caso == 0 then -- Un fix especial
		
		elseif caso == 7 then
			triggerServerEvent("onColgarLlamada", getLocalPlayer(), getLocalPlayer())
			setPhonePageOpen ( 'home' )
		end
	end
end
addEvent("reproducirSonidoTLF", true)
addEventHandler("reproducirSonidoTLF", getRootElement(), reproducirSonidoTLF)

function pararSonidoTLF ()
	if sonido and isElement(sonido) then
		stopSound(sonido)
	end
end
addEvent("pararSonidoTLF", true)
addEventHandler("pararSonidoTLF", getRootElement(), pararSonidoTLF)

function recibirLlamada (numero)
	if numero then
		triggerServerEvent("onSoliciarTablasNecesarias", getLocalPlayer())
		setPhoneOpen(true)
		setPhonePageOpen('calling_r')
		local nombre = numeroAContacto(tonumber(numero))
		if tostring(nombre) == tostring(numero) then
			guiSetText(pages['calling_r'].lbl1, "Desconocido")
		else
			if tostring(nombre) == "nil" then
				guiSetText(pages['calling_r'].lbl1, "")
			else
				guiSetText(pages['calling_r'].lbl1, tostring(nombre))
			end
		end
		guiSetText(pages['calling_r'].lbl2, tostring(numero))
	end
end
addEvent("onRecibirLlamada", true)
addEventHandler("onRecibirLlamada", getRootElement(), recibirLlamada)     


function realizarLlamadaGUIEXT (numero)
	if numero then
		triggerServerEvent("onSoliciarTablasNecesarias", getLocalPlayer())
		setPhoneOpen(true)
		reproducirSonidoTLF(0)
		local noculto = string.upper(string.sub(tostring(numero), 1, 4))
		if noculto and noculto == "#31#" then
			numero2 = tonumber(string.sub(tostring(numero), 5))
		else
			numero2 = tonumber(numero)
		end
		timerLlamada[getLocalPlayer()] = setTimer(triggerServerEvent, 6000, 1, "onRealizarLlamada", getLocalPlayer(), getLocalPlayer(), tonumber(getElementData(getLocalPlayer(), "numeroTelefono")), numero, 1)
		guiSetText(pages['calling'].lbl1, "Llamando A")
		guiSetText(pages['calling'].lbl2, numeroAContacto(tonumber(numero2)))
		setPhonePageOpen('calling')
	end
end
addEvent("onRealizarLlamadaGUIEXT", true)
addEventHandler("onRealizarLlamadaGUIEXT", getRootElement(), realizarLlamadaGUIEXT) 

-- define the event handler function
function onWasted(killer, weapon, bodypart)
    if ( killer and getElementType(killer) == "player" and getElementType(source) == "ped" ) and killer == getLocalPlayer() then
        triggerServerEvent("onRealizarSMS", killer, killer, 000, 112, "((Atacante: "..getPlayerName(killer):gsub("_", " ")..")) ¡Un NPC ha muerto debido a una agresión, acudan!")
    end
end

-- add the event handler
addEventHandler("onClientPedWasted", getRootElement(), onWasted)    