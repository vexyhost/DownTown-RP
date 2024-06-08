local ventanaAsis = false  
local x, y = guiGetScreenSize()
local datosPrestamo = 0

function finalizarAsistencia()
	destroyElement(vAsistencia)
	ventanaAsis = false
	triggerEvent("offCursor", getLocalPlayer())
	outputChatBox("¡Gracias por haber usado la Asistencia al Usuario de Fort Carson Roleplay!", 0, 255, 0)
end

function regeneraVentana()
	destroyElement(vAsistencia)
	vAsistencia = guiCreateWindow(428*x/1366, 188*y/768, 583*x/1366, 456*y/768, "Asistencia al Usuario - Fort Carson Roleplay", false)
	guiWindowSetSizable(vAsistencia, false)
	datosPrestamo = 0
end

function mostrarGUIAsistencia()
	if exports.players:isLoggedIn() then
		if ventanaAsis == false then
			ventanaAsis = true
			triggerEvent("onCursor", getLocalPlayer())
			vAsistencia = guiCreateWindow(428*x/1366, 188*y/768, 583*x/1366, 456*y/768, "Asistencia al Usuario - Fort Carson RolePlay", false)
			guiWindowSetSizable(vAsistencia, false)
			lInfo = guiCreateLabel(117*x/1366, 41*y/768, 346*x/1366, 38*y/768, "Bienvenid@ al sistema de Asistencia al Usuario de Fort Carson. \nPor favor, selecciona en la lista el problema que tienes.", false, vAsistencia)
			rSoyNuevo = guiCreateRadioButton(44*x/1366, 102*y/768, 463*x/1366, 18*y/768, "Soy nuev@ en el servidor, ¿cómo se juega?", false, vAsistencia)
			rDuda = guiCreateRadioButton(44*x/1366, 130*y/768, 463*x/1366, 18*y/768, "Tengo una duda puntual / Mi problema no está en la lista", false, vAsistencia)
			rNecesitoStaff = guiCreateRadioButton(44*x/1366, 158*y/768, 463*x/1366, 18*y/768, "Necesito un staff en mi posición. ¡No puedo rolear aquí!", false, vAsistencia)
			rPerdido = guiCreateRadioButton(44*x/1366, 186*y/768, 463*x/1366, 18*y/768, "He perdido algún arma / vehículo / objeto y quiero recuperarlo", false, vAsistencia)
			rAnularPrestamo = guiCreateRadioButton(44*x/1366, 214*y/768, 463*x/1366, 18*y/768, "Quiero anular el préstamo de mi vehículo / casa", false, vAsistencia)
			rQueja = guiCreateRadioButton(44*x/1366, 242*y/768, 463*x/1366, 18*y/768, "Tengo una queja hacia algún miembro del staff, o del staff en general", false, vAsistencia)
			rSugerencia = guiCreateRadioButton(44*x/1366, 270*y/768, 463*x/1366, 18*y/768, "Tengo una sugerencia para el servidor", false, vAsistencia)
			rFallo = guiCreateRadioButton(44*x/1366, 298*y/768, 463*x/1366, 18*y/768, "He encontrado un fallo en el servidor", false, vAsistencia)
			--rNuevaSkin = guiCreateRadioButton(44*x/1366, 270, 463*x/1366, 18, "Soy VIP y quiero que pongan / actualicen mi skin", false, vAsistencia)
			bContinuar = guiCreateButton(353*x/1366, 404*y/768, 99*x/1366, 42*y/768, "Continuar", false, vAsistencia)       
			bSalir = guiCreateButton(103*x/1366, 404*y/768, 99*x/1366, 42*y/768, "Salir", false, vAsistencia)   
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bContinuar, regularBoton)
		else
			finalizarAsistencia()
		end
	end
end

function regularBoton()
	if source == bSalir then
		finalizarAsistencia()
	elseif source == bContinuar then
		-- Estados --
		local s_rSoyNuevo = guiRadioButtonGetSelected(rSoyNuevo)
		local s_rDuda = guiRadioButtonGetSelected(rDuda)
		local s_rNecesitoStaff = guiRadioButtonGetSelected(rNecesitoStaff)
		local s_rPerdido = guiRadioButtonGetSelected(rPerdido)
		local s_rAnularPrestamo = guiRadioButtonGetSelected(rAnularPrestamo)
		local s_rQueja = guiRadioButtonGetSelected(rQueja)
		--local s_rNuevaSkin = guiRadioButtonGetSelected(rNuevaSkin)
		local s_rSugerencia = guiRadioButtonGetSelected(rSugerencia)
		local s_rFallo = guiRadioButtonGetSelected(rFallo)
		-- Recreación de ventana --
		regeneraVentana()
		-- Gran condicional --
		if s_rSoyNuevo == true then
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 182*y/768, "¡Bienvenid@ a Fort Carson RolePlay! Podríamos contarte cómo jugar aquí, pero... ¿No es mejor que te lo explique alguien?\n\nPor eso, dentro del staff o equipo administrativo hay miembros especializados para esto. Ellos se encargan de ayudar a los nuevos en su andadura por el servidor.\n\nHemos avisado a todos los staff de servicio para que acuda uno lo antes posible. Mientras, puedes cerrar esta ventana y echar un ojo al F7. Ahí está todo lo necesario para jugar. Y si quieres ponerte en acción y comenzar ya, usa /objetivos.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bSalir = guiCreateButton(241*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Ok, cierra esta ventana", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			triggerServerEvent("onSolicitarStaffViaAsistencia", getLocalPlayer(), 1)
		elseif s_rDuda == true then
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 129*y/768, "¿Tienes una duda? ¡No te preocupes! Contamos con numeroso staff para que te la puedan resolver lo antes posible.\n\nPuedes detallar aquí abajo tu duda y pulsar en enviar duda. Ya de paso, te recordamos que puedes mandar duda sin abrir el F1 con el comando /duda [duda que tienes]\n\nPor favor, te pedimos consideración a la hora de que te resuelvan la duda. Es posible que haya staff conectados y de servicio, pero estarán ocupados.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bEnviarDuda = guiCreateButton(376*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Enviar duda", false, vAsistencia)
			eDuda = guiCreateEdit(91*x/1366, 238*y/768, 459*x/1366, 21*y/768, "", false, vAsistencia)
			guiEditSetMaxLength(eDuda, 120)
			lDuda = guiCreateLabel(43*x/1366, 242*y/768, 43*x/1366, 17*y/768, "Duda > ", false, vAsistencia)
			bSalir = guiCreateButton(111*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bEnviarDuda, regularBoton)
		elseif s_rNecesitoStaff == true then
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 129*y/768, "Te informamos de que acabamos de lanzar una alerta general a todos los staffs de servicio. Esperamos que le hayas llamado con razón, porque en caso contrario podrás ser sancionado.\n\nPor otro lado, ten en cuenta que un staff no podrá actuar ante un rol en la mayoría de los casos. Se deberá de ir al foro (https://foro.fc-mta.com) e interponer el reporte correspondiente.\n\nGracias por confiar en Fort Carson. Por favor, espera a que acuda el staff.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bSalir = guiCreateButton(239*x/1366, 272*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			triggerServerEvent("onSolicitarStaffViaAsistencia", getLocalPlayer(), 2)
		elseif s_rPerdido == true then
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 33*y/768, "Lamentamos que hayas perdido un arma, un vehículo o un objeto. Para que podamos ayudarte, necesitamos que nos indiques qué es lo que has perdido.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bEnviarPerdido1 = guiCreateButton(376*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Continuar", false, vAsistencia)
			bSalir = guiCreateButton(111*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			rArmaPerdida = guiCreateRadioButton(60*x/1366, 86*y/768, 480*x/1366, 18*y/768, "He perdido un arma", false, vAsistencia)
			rVehPerdido = guiCreateRadioButton(60*x/1366, 114*y/768, 480*x/1366, 18*y/768, "He perdido un vehículo", false, vAsistencia)
			rItemPerdido = guiCreateRadioButton(60*x/1366, 142*y/768, 480*x/1366, 18*y/768, "He perdido un item / objeto", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bEnviarPerdido1, regularBoton)
		elseif s_rAnularPrestamo == true then
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 33*y/768, "Para que podamos ayudarte, necesitamos que nos indiques de qué es el préstamo: de una casa o de un vehículo.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bAnularPrestamo1 = guiCreateButton(376*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Continuar", false, vAsistencia)
			bSalir = guiCreateButton(111*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			rCasaPres = guiCreateRadioButton(60*x/1366, 86*y/768, 480*x/1366, 18*y/768, "El préstamo es de una casa", false, vAsistencia)
			rVehPres = guiCreateRadioButton(60*x/1366, 114*y/768, 480*x/1366, 18*y/768, "El préstamo es de un vehículo", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bAnularPrestamo1, regularBoton)
		--[[elseif s_rQueja == true then
			lInfo = guiCreateLabel(28, 45, 527, 176, "Lamentamos que tengas una queja hacia alguno de los staffs, o hacia el staff en general.\n\nAntes de enviar una queja, por favor, ten en cuenta que el hecho de que haya varios staffs conectados no significa que te vayan a atender más rapido, pues en muchas ocasiones estamos desbordados.\n\nEn caso de acusar a un staff de algún abuso, por favor, aportar pruebas, como si de un usuario se tratara.\n\nTras dar a continuar, se procederá a abrir Incidencia, pudiendo consultar su estado en https://incidencias.dt-mta.com", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bEnviarQueja = guiCreateButton(376, 371, 99, 42, "Enviar queja", false, vAsistencia)
			bSalir = guiCreateButton(111, 371, 99, 42, "Cerrar ventana", false, vAsistencia)
			memoQueja = guiCreateMemo(28, 227, 527, 129, "Escribe aquí tu queja. Detalla hacia quién o quienes va dirigida, y aporta pruebas si es posible.", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bEnviarQueja, regularBoton)]]
		--[[elseif s_rNuevaSkin == true then
			lInfo = guiCreateLabel(28, 45, 527, 97, "Para que no pierdas tiempo de tu VIP esperando a un Desarrollador, hemos diseñado este novedoso sistema. Tú mismo podrás cambiar de skin.\n\nPara ello, deberás de ir a https://dt-mta.com/vip/ y subir tu skin VIP. Tras esto, te será entregado un Código Único de Skin (CUS). Simplemente, escribe tu CUS abajo y tendrás tu nueva skin VIP al instante. Si no tienes ninguna skin asignada, utiliza primero /skinvip y vuelve a repetir el proceso.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bEnviarCUS = guiCreateButton(376, 371, 99, 42, "Continuar", false, vAsistencia)
			bSalir = guiCreateButton(111, 371, 99, 42, "Cerrar ventana", false, vAsistencia)
			eCUS = guiCreateEdit(79, 146, 459, 23, "", false, vAsistencia)
			lCUS = guiCreateLabel(33, 152, 36, 15, "CUS >", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bEnviarCUS, regularBoton)]]
		--[[elseif s_rSugerencia == true then
			lInfo = guiCreateLabel(28, 45, 527, 176, "Bienvenido al sistema de sugerencias de DownTown RolePlay. Aquí nos gusta que la opinión de cada uno cuente, y para eso creamos este sistema, que funciona así.\n\n1. Envías tu sugerencia (o todas las que quieras) a través de este panel.\n2. Tanto tú como todos los usuarios podéis usar /sugerencias y votar las mejores sugerencias, o las que te gustaría que se implantaran en el servidor.\n3. Cuando un Desarrollador se ponga a mejorar el servidor, se irá a /sugerencias y las que más votos tengan y sean factibles y posibles se implementarán en el servidor.\n\n¡Qué buena forma de mejorar el servidor entre todos!\n\nDetalla a continuación tu sugerencia:", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bEnviarSugerencia = guiCreateButton(376, 371, 99, 42, "Enviar sugerencia", false, vAsistencia)
			bSalir = guiCreateButton(111, 371, 99, 42, "Cerrar ventana", false, vAsistencia)
			memoSugerencia = guiCreateMemo(28, 227, 527, 129, "", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bEnviarSugerencia, regularBoton)
		elseif s_rFallo == true then
			lInfo = guiCreateLabel(28, 45, 527, 176, "Lamentamos que hayas encontrado un fallo que haya afectado a la experiencia de juego de DownTown\n\nPor favor, detalla exactamente en qué consiste el fallo, cómo se produce o cúando pasa. Todos los detalles que aportes serán útiles para un desrrollador, así que contra más, mejor.\n\nTras dar a continuar, se procederá a abrir Incidencia, pudiendo consultar su estado en https://incidencias.dt-mta.com", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bEnviarFallo = guiCreateButton(376, 371, 99, 42, "Enviar fallo", false, vAsistencia)
			bSalir = guiCreateButton(111, 371, 99, 42, "Cerrar ventana", false, vAsistencia)
			memoFallo = guiCreateMemo(28, 227, 527, 129, "", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bEnviarFallo, regularBoton)]]
		elseif s_rQueja == true or s_rSugerencia == true or s_rFallo == true then
			regeneraVentana()
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 73*y/768, "Para atender tu solicitud de bug, sugerencia o queja, debes de ir al foro.\n\nPor favor, acude a foro.fc-mta.com y acude a Soporte Técnico, donde te ayudaremos.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bSalir = guiCreateButton(245*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
		else
			outputChatBox("Selecciona primero una opción.", 255, 0, 0)
			lInfo = guiCreateLabel(117*x/1366, 41*y/768, 346*x/1366, 38*y/768, "Bienvenid@ al sistema de Asistencia al Usuario de Fort Carson. \nPor favor, selecciona en la lista el problema que tienes.", false, vAsistencia)
			rSoyNuevo = guiCreateRadioButton(44*x/1366, 102*y/768, 463*x/1366, 18*y/768, "Soy nuev@ en el servidor, ¿cómo se juega?", false, vAsistencia)
			rDuda = guiCreateRadioButton(44*x/1366, 130*y/768, 463*x/1366, 18*y/768, "Tengo una duda puntual / Mi problema no está en la lista", false, vAsistencia)
			rNecesitoStaff = guiCreateRadioButton(44*x/1366, 158, 463*x/1366, 18*y/768, "Necesito un staff en mi posición. ¡No puedo rolear aquí!", false, vAsistencia)
			rPerdido = guiCreateRadioButton(44*x/1366, 186*y/768, 463*x/1366, 18*y/768, "He perdido algún arma / vehículo / objeto y quiero recuperarlo", false, vAsistencia)
			rAnularPrestamo = guiCreateRadioButton(44*x/1366, 214*y/768, 463*x/1366, 18*y/768, "Quiero anular el préstamo de mi vehículo / casa", false, vAsistencia)
			rQueja = guiCreateRadioButton(44*x/1366, 242*y/768, 463*x/1366, 18*y/768, "Tengo una queja hacia algún miembro del staff, o del staff en general", false, vAsistencia)
			rSugerencia = guiCreateRadioButton(44*x/1366, 270*y/768, 463*x/1366, 18*y/768, "Tengo una sugerencia para el servidor", false, vAsistencia)
			rFallo = guiCreateRadioButton(44*x/1366, 298*y/768, 463*x/1366, 18*y/768, "He encontrado un fallo en el servidor", false, vAsistencia)
			--rNuevaSkin = guiCreateRadioButton(44, 270, 463, 18, "Soy VIP y quiero que pongan / actualicen mi skin", false, vAsistencia)
			bContinuar = guiCreateButton(353*x/1366, 404*y/768, 99*x/1366, 42*y/768, "Continuar", false, vAsistencia)       
			bSalir = guiCreateButton(103*x/1366, 404*y/768, 99*x/1366, 42*y/768, "Salir", false, vAsistencia)   
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bContinuar, regularBoton)
		end
	elseif source == bEnviarDuda then
		local duda = guiGetText(eDuda)
		if duda and tostring(duda) ~= "" then
			triggerServerEvent("onEnviarDudaViaAsistencia", getLocalPlayer(), duda)
			finalizarAsistencia()
		else
			outputChatBox("¡Escribe primero tu duda en el recuadro!", 255, 0, 0)
		end
	elseif source == bEnviarPerdido1 then
		local s_rArmaPerdida = guiRadioButtonGetSelected(rArmaPerdida)
		local s_rVehPerdido = guiRadioButtonGetSelected(rVehPerdido)
		local s_rItemPerdido = guiRadioButtonGetSelected(rItemPerdido)
		if s_rVehPerdido == true then
			regeneraVentana()
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 147*y/768, "Lamentamos que hayas perdido un vehículo. Por favor, selecciona tu vehículo de la lista.\n\nEl sistema tratará de buscarlo, pero para ello no debe de haber sido robado con rol, y además tiene un coste de 50 dólares IC (gratuito para usuarios VIP) en caso de encontrarlo. Si está en el depósito tampoco tendrás que pagar nada por localizarlo, seas VIP o no.\n\nAdemás, ten en cuenta que el sistema detectará la posición del vehículo en el momento de darle a continuar. Sin embargo, no se garantiza que el vehículo esté ahi, ya que mientras que acudes puede que alguien lo mueva, o que el vehículo esté en movimiento.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bVehiculoPerdido = guiCreateButton(376*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Continuar", false, vAsistencia)
			bSalir = guiCreateButton(111*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			gridVehiculos = guiCreateGridList(89*x/1366, 197*y/768, 412*x/1366, 155*y/768, false, vAsistencia)
			guiGridListAddColumn(gridVehiculos, "ID del vehículo", 0.3)
			guiGridListAddColumn(gridVehiculos, "Modelo del Vehículo", 0.66)
			guiGridListAddRow(gridVehiculos)
			guiGridListSetItemText(gridVehiculos, 0, 1, "-", false, false)
			guiGridListSetItemText(gridVehiculos, 0, 2, "No aparece mi vehículo en la lista", false, false)
			guiGridListSetItemData(gridVehiculos, 0, 1, -1)
			guiGridListSetItemData(gridVehiculos, 0, 1, -1)
			triggerServerEvent("onSolicitarVehiculosViaAsistencia", getLocalPlayer())
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bVehiculoPerdido, regularBoton)
		elseif s_rArmaPerdida == true or s_rItemPerdido == true then
			regeneraVentana()
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 73*y/768, "Lo sentimos. El sistema automático de asistencia no puede gestionar la recuperación en este caso.\n\nPor favor, acude a foro.fc-mta.com para obtener ayuda y hacer posible la recuperación.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bSalir = guiCreateButton(245*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
		else
			outputChatBox("Selecciona primero una opción.", 255, 0, 0)
		end
	elseif source == bVehiculoPerdido then
		local r, c = guiGridListGetSelectedItem(gridVehiculos)
		if tonumber(r) == -1 then
			outputChatBox("Selecciona una opción de la lista de vehículos.", 255, 0, 0)
			return
		end
		if r == 0 then
			regeneraVentana()
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 73*y/768, "Lo sentimos. El sistema automático de asistencia no puede gestionar la recuperación en este caso.\n\nPor favor, acude a foro.fc-mta.com para obtener ayuda y hacer posible la recuperación.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			bSalir = guiCreateButton(245*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
		end
		if r > 0 then
			local vehicleID = guiGridListGetItemData(gridVehiculos, r, c)
			if vehicleID then
				triggerServerEvent("onSolicitarLocVehViaAsistencia", getLocalPlayer(), vehicleID)
			end
		end
	elseif source == bAnularPrestamo1 then
		local s_rCasaPres = guiRadioButtonGetSelected(rCasaPres)
		local s_rVehPres = guiRadioButtonGetSelected(rVehPres)
		if s_rCasaPres == true then
			regeneraVentana()
			bAnularPrestamo2 = guiCreateButton(241*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Continuar", false, vAsistencia)
			bSalir = guiCreateButton(111*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bAnularPrestamo2, regularBoton)
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 176*y/768, "Tras borrar el préstamo, al ser de un interior se pondrá a la venta automáticamente.\n\nAdemás, una vez solicitado no se puede anular y no se devolverá ningún importe ya pagado. Acuérdate de recoger todos tus muebles antes de anular tu préstamo.\n\nPara consultar exactamente de qué interior vas a anular el préstamo, puedes usar /préstamo 2 \n\nPulsa Continuar para confirmar la anulación del préstamo. \n\nESTA OPERACIÓN NO SE PUEDE DESHACER.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			datosPrestamo = 2
		elseif s_rVehPres == true then
			regeneraVentana()
			bAnularPrestamo2 = guiCreateButton(241*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Continuar", false, vAsistencia)
			bSalir = guiCreateButton(111*x/1366, 371*y/768, 99*x/1366, 42*y/768, "Cerrar ventana", false, vAsistencia)
			addEventHandler("onClientGUIClick", bSalir, regularBoton)
			addEventHandler("onClientGUIClick", bAnularPrestamo2, regularBoton)
			lInfo = guiCreateLabel(28*x/1366, 45*y/768, 527*x/1366, 176*y/768, "Tras borrar el préstamo, al ser de un vehículo se borrará automáticamente.\n\nAdemás, una vez solicitado no se puede anular y no se devolverá ningún importe ya pagado.\n\nPara consultar exactamente de qué vehículo vas a anular el préstamo, puedes usar /préstamo 1 \n\nPulsa Continuar para confirmar la anulación del préstamo. ESTA OPERACIÓN NO SE PUEDE DESHACER.", false, vAsistencia)
			guiLabelSetHorizontalAlign(lInfo, "center", true)
			datosPrestamo = 1
		else
			outputChatBox("Selecciona primero el tipo de préstamo a anular.", 255, 0, 0)
		end 
	elseif source == bAnularPrestamo2 then
		if datosPrestamo > 0 then                  
			triggerServerEvent("onSolicitarAnulacionPrestamoViaAsistencia", getLocalPlayer(), datosPrestamo)
			finalizarAsistencia()
		end
	elseif source == bEnviarQueja then
		local queja = guiGetText(memoQueja)
		if queja and tostring(queja) ~= "" then
			triggerServerEvent("onSolicitarIncidencia", getLocalPlayer(), 3, queja)
			finalizarAsistencia()
		else
			outputChatBox("¡Escribe primero tu queja en el recuadro!", 255, 0, 0)
		end
	elseif source == bEnviarSugerencia then
		local sugerencia = guiGetText(memoSugerencia)
		if sugerencia and tostring(sugerencia) ~= "" then
			triggerServerEvent("onSolicitarIncidencia", getLocalPlayer(), 1, sugerencia)
			finalizarAsistencia()
		else
			outputChatBox("¡Escribe primero tu sugerencia en el recuadro!", 255, 0, 0)
		end
	elseif source == bEnviarFallo then
		local fallo = guiGetText(memoFallo)
		if fallo and tostring(fallo) ~= "" then
			triggerServerEvent("onSolicitarIncidencia", getLocalPlayer(), 2, fallo)
			finalizarAsistencia()
		else
			outputChatBox("¡Escribe primero tu sugerencia en el recuadro!", 255, 0, 0)
		end
	elseif source == bEnviarCUS then
		local CUS = guiGetText(eCUS)
		if CUS and tostring(CUS) ~= "" and string.len(tostring(CUS)) == 6 then
			triggerServerEvent("onEnviarCUSViaAsistencia", getLocalPlayer(), CUS)
			finalizarAsistencia()
		else
			outputChatBox("¡Escribe primero tu CUS en el recuadro! Además, su longitud es de 6 carácteres.", 255, 0, 0)
		end
	end
end  

function enviarVehiculosViaAsistencia(sql)
	if sql then
		r = 1
		for k, v in ipairs(sql) do
			guiGridListAddRow(gridVehiculos)
			guiGridListSetItemText(gridVehiculos, r, 1, tostring(v.vehicleID), false, false)
			guiGridListSetItemText(gridVehiculos, r, 2, tostring(getVehicleNameFromModel(v.model)), false, false)
			guiGridListSetItemData(gridVehiculos, r, 1, tonumber(v.vehicleID))
			guiGridListSetItemData(gridVehiculos, r, 2, tonumber(v.vehicleID))
			r = r + 1
		end
	end
end
addEvent("onEnviarVehiculosViaAsistencia", true)
addEventHandler("onEnviarVehiculosViaAsistencia", getRootElement(), enviarVehiculosViaAsistencia)

--[[
local sqlCache
local sqlCache2
local sqlCache3
local IDUsuario

function GUIVotaciones(dev, sql, sql2, sql3, idu)
	sqlCache = sql
	sqlCache2 = sql2
	sqlCache3 = sql3
	IDUsuario = idu
	triggerEvent("onCursor", getLocalPlayer())
	vIncidencias = guiCreateWindow(274, 132, 803, 487, "Servicio de Votación de Sugerencias - Fort Carson RolePlay", false)
	guiWindowSetSizable(vIncidencias, false)
	gridIncidencias = guiCreateGridList(21, 40, 753, 196, false, vIncidencias)
	addEventHandler("onClientGUIClick", gridIncidencias, regularAccionGUIVotaciones)
	guiGridListAddColumn(gridIncidencias, "Nº Sugerencia", 0.48)
	guiGridListAddColumn(gridIncidencias, "Nº de Votos", 0.48)
	for k, v in ipairs(sqlCache) do
		local r = guiGridListAddRow(gridIncidencias)
		guiGridListSetItemText(gridIncidencias, r, 1, tostring(v.id), false, false)
		local nvotos = 0
		for k2, v2 in ipairs(sqlCache2) do
			if tostring(v2.bug_id) == tostring(v.id) then
				nvotos = nvotos + 1
			end
		end
		guiGridListSetItemText(gridIncidencias, r, 2, tostring(nvotos), false, false)
	end
	lInfoUsuario = guiCreateLabel(33, 247, 731, 49, "Bienvenid@ al sistema de votación de sugerencias de Fort Carson RolePlay.\nA partir de ahora, vosotros sois los que daréis la prioridad a los nuevos sistemas.\nPara votar una sugerencia, simplemente seleccionala en la lista. Abajo verás de qué va y podrás dar tu voto positivo (si quieres)", false, vIncidencias)
	bCerrarVentana = guiCreateButton(106, 427, 137, 42, "Cerrar Ventana", false, vIncidencias)
	addEventHandler("onClientGUIClick", bCerrarVentana, regularAccionGUIVotaciones)
	bDarVoto = guiCreateButton(253, 427, 137, 42, "Dar Voto", false, vIncidencias)
	addEventHandler("onClientGUIClick", bDarVoto, regularAccionGUIVotaciones)
	memoDescripcion = guiCreateMemo(31, 299, 733, 118, "Selecciona una de las sugerencias de arriba para ver su descripción.", false, vIncidencias)
	guiMemoSetReadOnly(memoDescripcion, true)
	if dev == true then
		bCerrarIncidencia = guiCreateButton(400, 427, 137, 42, "Cerrar Incidencia", false, vIncidencias)
		bAprobarIncidencia = guiCreateButton(547, 427, 137, 42, "Asignar Incidencia", false, vIncidencias)
		addEventHandler("onClientGUIClick", bCerrarIncidencia, regularAccionGUIVotaciones)
		addEventHandler("onClientGUIClick", bAprobarIncidencia, regularAccionGUIVotaciones)
	end
end
addEvent("onAbrirGuiVotaciones", true)
addEventHandler("onAbrirGuiVotaciones", getRootElement(), GUIVotaciones)
          
function regularAccionGUIVotaciones()
	if source == bCerrarVentana then
		destroyElement(vIncidencias)
		triggerEvent("offCursor", getLocalPlayer())
		sqlCache = nil
		sqlCache2 = nil
		sqlCache3 = nil
	elseif source == gridIncidencias then
		local row = guiGridListGetSelectedItem ( gridIncidencias )
		if not row then return end
		local IDIncidencia = tostring(guiGridListGetItemText ( gridIncidencias, row, 1 ))
		for k, v in ipairs(sqlCache3) do
			if tostring(v.id) == IDIncidencia then
				guiSetText(memoDescripcion, tostring(v.description))
				return
			end 
		end
	elseif source == bDarVoto then
		local row = guiGridListGetSelectedItem ( gridIncidencias )
		if not row then return end
		local IDIncidencia = tostring(guiGridListGetItemText ( gridIncidencias, row, 1 ))
		for k, v in ipairs(sqlCache2) do
			if tostring(v.bug_id) == IDIncidencia and IDUsuario == tostring(v.user_id) then
				outputChatBox("¡Ya has dado tu voto a esta sugerencia anteriormente!", 255, 0, 0)
				return
			end
		end
		triggerServerEvent("onDarVotoASugerencia", getLocalPlayer(), IDUsuario, IDIncidencia)
	end
end]]