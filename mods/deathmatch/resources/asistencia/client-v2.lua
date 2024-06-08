local ventanaAsis = false
local x, y = guiGetScreenSize()

function abrirVentanaAsistenciaV2()
	if ventanaAsis == false then
		triggerEvent("onCursor", getLocalPlayer())
		ventanaAsis = true
		vAsistenciaGeneral = guiCreateWindow(527/1920*x, 291/1080*y, 867/1920*x, 530/1080*y, "Panel de asistencia general - DownTown RolePlay", false)
		guiWindowSetSizable(vAsistenciaGeneral, false)

		tabPanelAsist = guiCreateTabPanel(20/1920*x, 34/1080*y, 825/1920*x, 475/1080*y, false, vAsistenciaGeneral)

		tabInicio = guiCreateTab("Inicio", tabPanelAsist)

		lInicioPanel = guiCreateLabel(31/1920*x, 25/1080*y, 760/1920*x, 85/1080*y, "Bienvenid@ al panel de asistencia general de DownTown RolePlay. Desde aquí podrás ver los conceptos de rol, los comandos del servidor, reportar a jugadores, ¡y muchos trámites más!\n\nSelecciona una categoría (ej. Comandos) para obtener más información. En caso de cualquier problema, siempre puedes dirigirte a un staff vía IG mediante /staff o vía IG y web a través del CAU.", false, tabInicio)
		guiLabelSetHorizontalAlign(lInicioPanel, "left", true)

		tabComandos = guiCreateTab("Comandos", tabPanelAsist)

		lComandos = guiCreateLabel(31/1920*x, 18/1080*y, 747/1920*x, 23/1080*y, "Selecciona una categoría para ver los comandos, así como una breve explicación.", false, tabComandos)
		guiLabelSetHorizontalAlign(lComandos, "left", true)
		gridComandos = guiCreateGridList(29/1920*x, 48/1080*y, 218/1920*x, 377/1080*y, false, tabComandos)
		addEventHandler("onClientGUIClick", gridComandos, regularBotonesAsistencia)
		guiGridListAddColumn(gridComandos, "Categoría", 0.9)
		for i = 1, 7 do
			guiGridListAddRow(gridComandos)
		end
		guiGridListSetItemText(gridComandos, 0, 1, "General", false, false)
		guiGridListSetItemText(gridComandos, 1, 1, "Vehículos", false, false)
		guiGridListSetItemText(gridComandos, 2, 1, "Facciones", false, false)
		guiGridListSetItemText(gridComandos, 3, 1, "Interiores", false, false)
		guiGridListSetItemText(gridComandos, 4, 1, "Otros Comandos", false, false)
		
		memoComandos = guiCreateMemo(257/1920*x, 50/1080*y, 545/1920*x, 375/1080*y, "", false, tabComandos)
		guiMemoSetReadOnly(memoComandos, true) 

		tabCAU = guiCreateTab("CAU", tabPanelAsist)
		labelCAU = guiCreateLabel(18/1920*x, 13/1080*y, 774/1920*x, 163/1080*y, "Desde aquí podrás acceder al CAU, Centro de Atención al Usuario. La mayoría de trámites se realizarán en este CAU, siendo un medio directo, seguro y privado de comunicación entre el usuario y el staff.\n\nUna vez vincules tu cuenta IG con tu cuenta del foro, tendrás acceso al CAU y desde él podras abrir casos. Un caso hace referencia a una queja, una petición algo peculiar, no estar de acuerdo con una sanción recibida, y diversos trámites puntuales que serán anunciados vía foro.\n\nCon el fin de garantizar el correcto funcionamiento de este servicio, al pulsar en el botón 'Acceder al CAU' aparecerá una ventana pidiendo permisos para poder acceder a *.dt-mta.com. Es necesario que marques la casilla de Remeber decision y des en Allow para permitirlo. En caso contrario, no podrás acceder al CAU vía IG.", false, tabCAU)
        guiLabelSetHorizontalAlign(labelCAU, "left", true)
        bAccesoCAU = guiCreateButton(250/1920*x, 180/1080*y, 310/1920*x, 60/1080*y, "Acceder al CAU", false, tabCAU)
		addEventHandler("onClientGUIClick", bAccesoCAU, regularBotonesAsistencia)
		

		tabOGestiones = guiCreateTab("Otras gestiones", tabPanelAsist)

		lGestiones = guiCreateLabel(18/1920*x, 16/1080*y, 776/1920*x, 38/1080*y, "Desde aquí obtendrás información sobre cómo realizar ciertas gestiones administrativas: eliminar personajes, cambiar contraseñas, entre otros. \nSimplemente selecciona un trámite para obtener información.", false, tabOGestiones)
		guiLabelSetHorizontalAlign(lGestiones, "left", true)
		gridGestiones = guiCreateGridList(22/1920*x, 58/1080*y, 177/1920*x, 254/1080*y, false, tabOGestiones)
		addEventHandler("onClientGUIClick", gridGestiones, regularBotonesAsistencia)
		guiGridListAddColumn(gridGestiones, "Listado de trámites", 0.9)
		for i = 1, 13 do
			guiGridListAddRow(gridGestiones)
		end
		guiGridListSetItemText(gridGestiones, 0, 1, "Cambiar mi clave", false, false)
		guiGridListSetItemText(gridGestiones, 1, 1, "Anular un préstamo", false, false)
		guiGridListSetItemText(gridGestiones, 2, 1, "Reportar un fallo", false, false)
		guiGridListSetItemText(gridGestiones, 3, 1, "Reportar un usuario", false, false)
		guiGridListSetItemText(gridGestiones, 4, 1, "Reportar un staff", false, false)
		guiGridListSetItemText(gridGestiones, 5, 1, "Solicitar un mapa", false, false)
		guiGridListSetItemText(gridGestiones, 6, 1, "Solicitar una facción", false, false)
		guiGridListSetItemText(gridGestiones, 7, 1, "Mejorar mi garaje", false, false)
		guiGridListSetItemText(gridGestiones, 8, 1, "Eliminar mi personaje", false, false)
		guiGridListSetItemText(gridGestiones, 9, 1, "Eliminar mi cuenta", false, false)
		guiGridListSetItemText(gridGestiones, 10, 1, "Vincular mi TS3", false, false)
		guiGridListSetItemText(gridGestiones, 11, 1, "Modificar mi personaje", false, false)
		guiGridListSetItemText(gridGestiones, 12, 1, "No aparece lo que busco", false, false)

		tabConceptos = guiCreateTab("Conceptos de rol", tabPanelAsist)

		lConceptos = guiCreateLabel(33/1920*x, 18/1080*y, 757/1920*x, 35/1080*y, "Desde aquí podrás consultar todos los conceptos de rol, así como ejemplos de cada uno.", false, tabConceptos)
		guiLabelSetHorizontalAlign(lConceptos, "left", true)
		memoConceptosRol = guiCreateMemo(254/1920*x, 53/1080*y, 546/1920*x, 363/1080*y, "\n", false, tabConceptos)
		gridConceptos = guiCreateGridList(31/1920*x, 54/1080*y, 207/1920*x, 362/1080*y, false, tabConceptos)
		addEventHandler("onClientGUIClick", gridConceptos, regularBotonesAsistencia)
		guiGridListAddColumn(gridConceptos, "Conceptos", 0.9)
		for i = 1, 13 do
			guiGridListAddRow(gridConceptos)
		end
		guiGridListSetItemText(gridConceptos, 0, 1, "Conceptos generales", false, false)
		guiGridListSetItemText(gridConceptos, 1, 1, "DM", false, false)
		guiGridListSetItemText(gridConceptos, 2, 1, "IC y OOC", false, false)
		guiGridListSetItemText(gridConceptos, 3, 1, "IG", false, false)
		guiGridListSetItemText(gridConceptos, 4, 1, "Flood, Spam y Flamming. IOOC.", false, false)
		guiGridListSetItemText(gridConceptos, 5, 1, "MG", false, false)
		guiGridListSetItemText(gridConceptos, 6, 1, "PG", false, false)
		guiGridListSetItemText(gridConceptos, 7, 1, "PK y CK", false, false)
		guiGridListSetItemText(gridConceptos, 8, 1, "RK", false, false)
		guiGridListSetItemText(gridConceptos, 9, 1, "Troll", false, false)
		guiGridListSetItemText(gridConceptos, 10, 1, "AA", false, false)
		guiGridListSetItemText(gridConceptos, 11, 1, "CJ", false, false)
		bCerrar = guiCreateButton(762/1920*x, 24/1080*y, 83/1920*x, 28/1080*y, "Cerrar", false, vAsistenciaGeneral)
		addEventHandler("onClientGUIClick", bCerrar, regularBotonesAsistencia)
	else
		cerrarVentanaAsist()
	end
end
addCommandHandler("ayuda", abrirVentanaAsistenciaV2)
addCommandHandler("asistencia", abrirVentanaAsistenciaV2)
bindKey("F1", "down", abrirVentanaAsistenciaV2)
            
function limpiarVentana()
	-- Meter condicionales que eliminen todo lo que se genera en la ventana de gestiones.
	if isElement(lRespuestaOGestiones) then destroyElement(lRespuestaOGestiones) end
	if isElement(bAceptoCondAnulPrest) then destroyElement(bAceptoCondAnulPrest) end
	if isElement(lAceptoCondicionesPrest) then destroyElement(lAceptoCondicionesPrest) end
	if isElement(bAnularPrestamoVeh) then destroyElement(bAnularPrestamoVeh) end
	if isElement(bAnularPrestamoInterior) then destroyElement(bAnularPrestamoInterior) end
	if isElement(memoComandos) then destroyElement(memoComandos) end
end

function cerrarVentanaAsist()
	if isElement(vAsistenciaGeneral) then
		destroyElement(vAsistenciaGeneral)
		ventanaAsis = false
		triggerEvent("offCursor", getLocalPlayer())
	end
end

function regularBotonesAsistencia()         
	if source == bCerrar then
		cerrarVentanaAsist()
	elseif source == gridComandos then
		limpiarVentana()
		local comandosSel = guiGridListGetItemText ( gridComandos, guiGridListGetSelectedItem ( gridComandos ), 1 )
		if comandosSel == "General" then
			memoComandos = guiCreateMemo(257/1920*x, 50/1080*y, 545/1920*x, 375/1080*y, "Bienvenid@ a DownTown RolePlay. Vamos a tratar de explicarte cómo jugar en cuanto a comandos y uso del servidor.\n\nSi no sabes que es el RolePlay o tienes dudas, antes de seguir es recomendable que te pases por la pestaña situada arriba, 'Conceptos de rol', donde te explicaremos todo lo necesario para empezar.\n\n~~ PRIMEROS PASOS ~~\n\n- /autoescuela > Marca la posición de la autoescuela en el F11 y en el minimapa.\n- /trabajos > Muestra el listado de trabajos disponibles que no dependen de foro ni necesitas currículum.\n- /id > Muestra tu ID por pantalla. En muchos comandos son necesarios el ID, que identifica de forma temporal a cada usuario.\n- /pagar [jugador] [cantidad] > Permite pagar al jugador elegido la cantidad estipulada. En jugador se puede poner el ID o parte del nombre del jugador.\n- /duda [texto] > Permite preguntar al equipo administrativo cualquier duda que se tenga.\n\n~~ CONSEGUIR UN BUEN TRABAJO ~~\n\nAunque con /trabajos tenemos algunos trabajos, lo divertido de verdad es ser médico, reportero, policía... y para ello es necesario tener cuenta en foro. Se tarda 5 minutos, simplemente abre tu navegador y visita foro.dt-mta.com\n\n~~ PERSONALIZA TU PERSONAJE ~~\n\nCon el comando /andar, podrás elegir un estilo con el que quieras que se mueva tu personaje. \nAdemás, hay dos tiendas de ropa (una en cada pueblo) en donde podrás personalizar la cara, el pelo, la ropa... el físico en general de tu personaje.\n\n~~ INTERACCÍON CON EL ENTORNO ~~\n\n- Para salir y entrar de un interior, deberás de ponerte en la flecha blanca que gira y pulsar la tecla P. \n\n- Hay en todo el mapa bots o NPC. Puedes interactuar con ellos primero pulsando la tecla M para mostrar el ratón, y posteriormente haciendo click en ellos.\n\n- Para ver tu inventario, pulsa la tecla I.\n\n- Para ver tus idiomas, pulsa la tecla L.\n\n- Para recargar tu arma, pulsa la tecla R.\n\n- Para hablar IC, pulsa la tecla T.\n\n- Para hablar OOC, pulsa la tecla B.\n\n- Para dejar de escuchar la música / sirenas especiales, usa /STOP (en mayúsculas) o /noradio.\n\n- Para ver la lista de staff conectados, usa /staff.\n- Para ver el mapa, pulsa F11.\n\n- Para ver la lista de jugadores conectados, pulsa tabulador.\n\n~~ COMPRA UN VEHÍCULO ~~\n\nExiste un sistema de préstamos con el que podrás comprar un vehículo e ir pagándolo poco a poco. Para ello, dirígete al concesionario. Está marcado con el icono de un coche en el mapa (F11), y ¡ten cuidado de no confundirte con el icono de coche de la autoescuela!\n", false, tabComandos)
			guiMemoSetReadOnly(memoComandos, true) 
		elseif comandosSel == "Vehículos" then
			memoComandos = guiCreateMemo(257/1920*x, 50/1080*y, 545/1920*x, 375/1080*y, "El sistema de vehículos tiene numerosos comandos, aunque te haremos un resumen a continuación:\n\n- /misvehiculos > Panel donde podrás ver los vehículos a tu nombre y realizar gestiones con ellos.\n\n- Tecla J o /toggleengine > Apagar / encender el motor.\n\n- Tecla L o /togglelights > Apagar / encender las luces.\n\n- Tecla K o /lockvehicle > Abrir / cerrar el vehículo.\n\nObservación: hay algunos comandos / teclas que sólo pueden ser usados estando subidos a un vehículo (ejemplo, la J sólo funcionará estando como conductor)\n\nSin embargo, la K funcionará también cuando por ejemplo estemos cerca de nuestro vehículo y tengamos llave. Daremos a la K y automáticamente se abrirá / cerrará, sin tener que abrir el inventario y dar click en la llave.\n\n- Tecla N > Poner / quitar el freno de mano.\n\n- Tecla H > Tocar el claxón.\n\n- Tecla C o /cinturon > Permite abocharte o desabrocharte el cinturón.\n\n- /refaseo > Permite aplicar de nuevo las fases del motor y de freno al vehículo.\n\n- /uc > Permite ver el último conductor del vehículo. ¡OJO! Esto sólo indica que fue el último en subirse y bajarse del vehículo.\n\n- /ug > Permite ver el último que ha golpeado al vehículo. Esto registra golpes tipo puñetazos a las puertas estando bajado, pero no los choques por ejemplo con una farola u otro vehículo.\n\n- Flechas izquierda y derecha / botones del ratón izquierdos y derechos > Permite dar los intermitentes izquierdos / derechos.\n\n- /limitador > Permite limitar la velocidad máxima del vehículo. Con /limitador 0 se desactiva.\n\n- /vehid > Permite obtener el ID del vehículo en el que estás subido.\n\n- /oldvehid > Permite obtener el ID del vehículo en el que estabas subido antes.", false, tabComandos)
			guiMemoSetReadOnly(memoComandos, true)
		end
	elseif source == gridGestiones then
		limpiarVentana()
		local gestionSel = guiGridListGetItemText ( gridGestiones, guiGridListGetSelectedItem ( gridGestiones ), 1 )
		if gestionSel == "Cambiar mi clave" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Para cambiar tu clave, simplemente utiliza el comando /cambiarclave [nueva clave de tu cuenta]\n\nTen en cuenta que por seguridad sólo se puede cambiar la clave de tu cuenta si estás desde el PC que se creó.\n\nTambién recordarte que el cambio de clave cambiará tu clave IG, pero no la clave de tu cuenta en foro. Si quieres cambiar tu clave de foro, deberás de hacerlo desde el foro.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Anular un préstamo" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Para anular tu préstamo, debes de seleccionar primero el tipo de préstamo que es (vehículo o interior) y hacer clic en continuar.\n\nTen en cuenta que la anulación de un préstamo conllleva la pérdida del objeto relacionado con él (vehículo o interior), y que el dinero que ya has pagado NO se devolverá.\n\nPor último, recordarte que la anulación es instantánea, y no hay vuelta atrás.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)

			cAceptoCondAnulPrest = guiCreateCheckBox(90/1920*x, 112/1080*y, 15/1920*x, 15/1080*y, "", false, false, lRespuestaOGestiones)
			lAceptoCondicionesPrest = guiCreateLabel(115/1920*x, 112/1080*y, 330/1920*x, 17/1080*y, "He leído y acepto las condiciones de anulación de préstamo.", false, lRespuestaOGestiones)

			bAnularPrestamoVeh = guiCreateButton(272/1920*x, 218/1080*y, 167/1920*x, 57/1080*y, "Anular préstamo de mi vehículo", false, tabOGestiones)
			bAnularPrestamoInterior = guiCreateButton(579/1920*x, 218/1080*y, 167/1920*x, 57/1080*y, "Anular préstamo de mi interior", false, tabOGestiones)
			addEventHandler("onClientGUIClick", bAnularPrestamoVeh, regularBotonesAsistencia)
			addEventHandler("onClientGUIClick", bAnularPrestamoInterior, regularBotonesAsistencia)
		elseif gestionSel == "Reportar un fallo" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Para reportar un fallo, deberás de abrir una incidencia en el CAU, indicando todos los datos posibles.\n\nPuedes abrirla en el CAU vía web visitando https://cau.dt-mta.com y, en un futuro, de forma IG a través de la pestaña CAU de este panel.\n\nCuando abras la solicitud, primero será revisada por un GameOperator, que valorará si es un fallo o no, y elevará dicha incidencia si así lo estima oportuno.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Reportar un usuario" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Para reportar a un usuario, deberás de acudir al foro y rellenar el formato que allí encontrarás.\n\nLa dirección de nuestro foro es https://foro.dt-mta.com y te recordamos que sólo se puede tener 1 cuenta de foro / cuenta IG.\n\nTen en cuenta que llegar a un reporte debe de ser tu último recurso para solucionar un problema, y que el motivo del reporte debe de ser estrictamente el incumpliento de alguna de las normativas.\n\nUn GameOperator atenderá el reporte a la mayor brevedad posible y dará el veredicto final. Contra la decisión del GameOperator se podrá acudir como última instancia al CAU, en la que un administrador revisará el reporte y la resolución del GO.\n\nMientras que el reporte esté en el CAU, no se podrá tomar acabo ninguna acción ni por parte de los usuarios ni por parte del GO. Esto es, si por ejemplo un GO decidió una sanción, esta quedará paralizada hasta que se resuelva en el CAU dicho caso.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Reportar un staff" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Lo primero de todo es realizar una distinción entre si se reporta a un staff por sus actuaciones como staff, o simplemente por su actuación como usuario en un rol.\n\nUn staff no deja de ser un usuario más, por lo que en caso de que haya cometido alguna falta de rol (que no sea AA, lógicamente) se realizará reporte vía foro y seguirán los mismos procedimientos como si de un usuario fuera.\n\nAhora bien, en caso de no estar de acuerdo con la actuación de un staff administrando, abusos, etcétera, se deberá abrir un caso directamente en el CAU, que será revisado por administradores.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Solicitar un mapa" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Si tienes un mapeado y quieres que se ponga en el servidor, ¡estamos encantados! Sin embargo, hay una serie de requisitos para que estos puedan ser aceptados:\n\n1. Se deberá poner solicitud ante el CAU adjuntando el mapa (archivo .map), SS del mismo y su tamaño.\n\n2. Una vez puesta solicitud ante el CAU junto con el .map, aceptas que el .map es tuyo y/o que tienes autorización para usarlo, y que dicho mapa pasa a ser propiedad del servidor, sin poder luego exigir su eliminación y/o modificación.\n\n3. Sólo se permitirán mapeados de exteriores. En ningún caso se permitirán mapeados de interiores, a menos que se indique lo contrario en algún concurso o algo por estilo de forma OOC.\n\n4. No se podrá exigir que lo que esté mapeado sea tuyo. Es decir: el hecho de mapear un conjunto de chalets no te da derecho a decir que éstos sean tuyos. Otra cosa distinta es que compres (o ya tuvieras por haber un mapeo previo en ese mismo lugar) el interior/pickup que corresponde a esos chalets.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Solicitar una facción" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Añadir nuevas facciones es un tema muy delicado. Requiere reconfigurar todo el servidor, foro... y además los nuevos sistemas que trae dicha facción.\n\nSe podrá realizar solicitud para añadir una nueva facción vía CAU. Sólamente serán tratadas las que sean facciones ilegales y/o facciones innovadoras. Abstenerse de, por ejemplo, realizar la solicitud de una facción ya existente (otro taller, otra empresa de transporte, etcétera) ya que este tipo de facciones serán creadas a medida que el número de usuarios del servidor lo demande.\n\nSi finalmente se decide que se cree dicha facción, el solicitante deberá abonar IC 75.000$. Este coste se ha puesto con el fin de que haya, por ejemplo, 20 facciones ilegales.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Mejorar mi garaje" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "El interior de los garajes NO se podrá modificar bajo ningún concepto. Cuando se crean los interiores y se les añaden sus respectivos garajes, se pone un precio al interior de acuerdo al entorno que rodea el interior, como al propio interior de la casa y del garaje.\n\nDe la misma forma sucede con los garajes individuales: se establece el precio de éstos teniendo en cuenta su aspecto exterior e interior.\n\nLo único que sí puede ser objeto de mejora, es ver cómo por ejemplo dos casas colindantes, con mismo precio y mismo / similar interior, tengan un garaje totalmente distinto. Para eso se deberá ir al CAU informando de los ID de los interiores relacionados, y se decidirá finalmente cual es el que les corresponde.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Eliminar mi personaje" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Podrás eliminar tu personaje en cualquier momento. Para ello, deberás de utilizar el comando /borrarmipj y seguir las instrucciones que aparecen en pantallla.\n\nTen en cuenta que esta acción NO se puede deshacer, y que eliminar tu PJ cuesta 700$ ya que a la hora de crear un PJ se te dan de nuevo 700$, y con el fin de evitar abusos y multicuentas se cobra este importe al eliminar el personaje.\n\nEl sistema de /borrarmipj no deja de ser un sistema automático y en determinados casos no sabe cómo proceder a la eliminación del PJ (que si tiene préstamos pendientes, multas, verificaciones de seguridad...) por lo que, si no consigues eliminar tu PJ mediante este comando, deberás de abrir un caso en el CAU indicando nombre del PJ y teniendo en mano del PJ los 700$.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Eliminar mi cuenta" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Con el fin de evitar las multicuentas, no se pueden eliminar las cuentas.\n\nSi lo que quieres es empezar de nuevo, elimina todos tus PJ de tu cuenta.\n\nSi lo que quieres es eliminar definitivamente tu cuenta, podemos hacerlo. Sin embargo, procederemos a bloquear / banear por seguridad el serial que registró dicha cuenta, y no podrás volver a menos que te pongas en contacto con el staff vía foro.\n\n", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Vincular mi TS3" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Para proteger el TS3 de intrusos, spamers, y en general cualquier tipo de usuario no deseado, hemos decidido restringirlo sólo a usuarios de DownTown.\n\nPara obtener acceso al TS3, necesitas un token o clave de privilegio. Puedes solicitar este token a través de https://login.dt-mta.com/ts3/ o IG usando /tokents3.\n\nRecomendamos hacerlo vía web porque se explica cómo usar este token dentro de TS3.", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "Modificar mi personaje" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Puedes solicitar la modificación de ciertos aspectos de tu personaje. Dependiendo del aspecto que sea, es más que probable que un  staff IG pueda cambiártelo en el acto.\n\nTe recomendamos, por tanto, que utilices el canal /duda para solicitar el cambio.\n\nEn caso de que el cambio no sea posible vía /duda, deberás abrir un caso en el CAU. ", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		elseif gestionSel == "No aparece lo que busco" then
			lRespuestaOGestiones = guiCreateLabel(221/1920*x, 64/1080*y, 573/1920*x, 248/1080*y, "Si tienes alguna duda o deseas realizar algún trámite que no aparece aquí, utiliza el canal /duda para obtener respuesta de una forma rápida y efectiva.\n\nTambién podemos atenderte en el CAU, accesible vía IG (pestaña CAU de este panel) y en https://cau.dt-mta.com\n\n", false, tabOGestiones)
			guiLabelSetHorizontalAlign(lRespuestaOGestiones, "left", true)
		end
	elseif source == bAccesoCAU then
		--if ( isBrowserDomainBlocked ( "cau.dt-mta.com" ) ) then
			--requestBrowserDomains({ "cau.dt-mta.com", "login.dt-mta.com" })
		--else
			requestBrowserDomains({ "cau.dt-mta.com", "login.dt-mta.com" })
			triggerServerEvent("onPreAbrirPortalCAU", getLocalPlayer())
			-- Abrimos navegador interno hacia la web del login
		--end
	elseif source == bAnularPrestamoVeh then
		if guiCheckBoxGetSelected(cAceptoCondAnulPrest) then
			triggerServerEvent("onSolicitarAnulacionPrestamoViaAsistencia", getLocalPlayer(), 1)
		else
			outputChatBox("¡Necesitas primero aceptar las condiciones de eliminación!", 255, 0, 0)
		end
	elseif source == bAnularPrestamoInterior then
		if guiCheckBoxGetSelected(cAceptoCondAnulPrest) then
			triggerServerEvent("onSolicitarAnulacionPrestamoViaAsistencia", getLocalPlayer(), 2)
		else
			outputChatBox("¡Necesitas primero aceptar las condiciones de eliminación!", 255, 0, 0)
		end
	elseif source == gridConceptos then
		local conceptoSel = guiGridListGetItemText ( gridConceptos, guiGridListGetSelectedItem ( gridConceptos ), 1 )
		if conceptoSel == "Conceptos generales" then
			guiSetText(memoConceptosRol, [[ /me y /do:

Encontramos el /me como herramienta para describir acciones que no sean visibles o para detallar algo más en especifico, todo desde la neutralidad y objetividad de la misma. La definición clásica es sin descripciones psicológicas, pero a medida que el Roleplayse va innovando, está bien aceptado en entrar en consideraciones psicológicas y narrativas sin entrar mucho en profundidad ni nada que sea en rol "pensativo". 

Ejemplo de /me : /me se acerca hasta la puerta , así abriendo la misma.
Ejemplo de /me "Pensativo": /me se acerca hasta la puerta de forma dubitativa, así mismo abriendo esta.

Tenemos el /do es para describir clásicamente el entorno que nos rodea, detallar, describir, avisar a otros jugadores de algo que pueden estar captando con los cinco sentidos básicos del cuerpo humano y también preguntar si se pudo realizar cierta acción (explayada anteriormente en el /me) en el otro jugador. Está mal utilizado discutir o abreviar roles.

Ejemplo de /do para describir : /do Notarías como David estaría muy nervioso ante tal situación.
Ejemplo de /do para completar entorno junto a otro jugador:

Jugador 1: /do ¿Podría notar que David está enojado?
Jugador 2: /do Claramente, debido a su expresión facial. ]])
		elseif conceptoSel == "DM" then
			guiSetText(memoConceptosRol, [[DM:
Esta definición coincide con la de muchos otros servidores y juegos: DM significa DeathMatch, o lo que es lo mismo, atacar sin razón alguna, o incluso si hay una razón válida, hacerlo sin rol.

Un ejemplo puede ser cuando queremos golpear a otro jugador, en vez de utilizar (como mínimo) un /me le pega múltiples puñetazos y después golpearle, directamente le matamos y no roleamos nada.]])
		elseif conceptoSel == "IC y OOC" then
			guiSetText(memoConceptosRol, "")
		elseif conceptoSel == "IG" then
			guiSetText(memoConceptosRol, "")
		elseif conceptoSel == "Flood, Spam y Flamming. IOOC." then
			guiSetText(memoConceptosRol, "")
		elseif conceptoSel == "MG" then
			guiSetText(memoConceptosRol, [[MG:

MG, se conoce como el hecho de que nuestro personaje use en el ámbito IC conocimientos obtenidos por medios OOC, en resumen  utilizar información OOC para beneficiarse IC,esto puede ser duramente sancionado,  también se puede observar el MG de otras forma:

• Usar emoticones en canales de textos IC (/do, /me) es una variante de MG.

Ejemplo de MG: tienen las razones suficientes como para realizarte un CK , a lo que un amigo tuyo te habla por WhatsApp (Medio OOC) que te van a matar, a lo que te desconectas para evitar el CK.]])
		elseif conceptoSel == "PG" then
			guiSetText(memoConceptosRol, [[PG:

El PG consta de dos subdefiniciones, las cuales se van a plantear aquí.

Encontramos una que es la acción ilógica, irracional y desmedida en un Rol y acción incapaces de realizarse en nuestra vida cotidiana. Recuerda que puedes presenciar roles que parecen totalmente ilógicos pero se han llevado a la marcha en el día a día siempre y cuando está sea interpretada y se acepten las consecuencias, al realizar PG se te puede sancionar.

Ejemplo de PG: Te tiras de un edificio, y roleas que no te pasó absolutamente nada.

También es PG aquella acción que anule desproporcionadamente el rol a otro jugador (como puede ser un acción en el /me) que no le permita poder "contestar" al rol hecho por el otro.

Ejemplo de anular rol a otro jugador: /me le pega con tanta fuerza que no puede defenderse. ]])
		elseif conceptoSel == "PK y CK" then
			guiSetText(memoConceptosRol, [[PK total y parcial: 

Entendemos como Player Kill la muerte de su personaje, el cual se perderá una parte en específico de tu memoria sin llegar a un bloqueo. Podemos decir que PK cuenta con dos variantes: 
- En un PK parcial contemplaremos la pérdida de cierta parte de la memoria del personaje, obligando al usuario a olvidar toda relación que haya tenido con el asesino.

- En un PK total contemplaremos la pérdida TOTAL de la memoria del personaje. Este PK se aplicará cuando ambas partes (asesino y asesinado) mantienen - o - mantenieron una relación sólida y notable. Esta definición reemplazará el CK, pero ahorrando la creación de una cuenta o utilizar un nombre diferente, pero igualmente se borrará cada acontecimiento que ese personaje tuvo desde su comienzo.

Ejemplo PK parcial : Tú insultas a un tipo que es peligroso, a lo que el tipo reacciona mal y te empieza a disparar, al morir, perderás todo conocimiento y relación que tengas con él.

Ejemplo PK total: Tú eres el amante de la esposa de un tipo bastante peligroso, a lo que él reacciona mal y te manda a matar brutalmente, luego de que pase esto se realizará un cambio de nombre y se conservarán tus bienes (Pagando los 5k correspondientes), por eso el PK total se conoce como "CK fantasma".


CK:

CK, Denominamos esto como la muerte total, absoluta y oficial de nuestro personaje,este debe ser realizado con una razón fundamentada, el CK tiene las siguientes caracteristicas: 
• Nos desconectamos con toda la cronología del personaje. Está permitido que otros personajes sigan recordando al personaje muerto.
• No se podrá volver a utilizar el personaje.
• Una vez hecho, no hay ninguna posibilidad de ser revertido.
• Este será siempre specteado por un Staff.

Ejemplo de CK: Traicionas a una banda ilegal, a lo cual un día me siguen me pegan 2 tiros en la cabeza a lo cual debes rolear las heridas graves y al hacer esto ya se realizaría el CK ya que tienen los motivos suficientes para realizarlo y lo hicieron con un rol. ]])
		elseif conceptoSel == "RK" then
			guiSetText(memoConceptosRol, [[RK:

RK, "Revenge Kill" es cuando una persona te hace un PK (Player Kill) o CK (Con rol) y tu vienes y  tomas venganza, sin tener razones para realizar el CK, al hacer esto puedes ser duramente sancionado por lo siguiente: 

• Cuando te realizan un PK (Ya sea parcial o total) olvidas todo tipo de lazo con el asesino.
• Si te hacen un CK, como se dijo anteriormente mataron a tu personaje, por lo cual por razones logicas tu personaje muerto no puede saber quien fue, ya que está muerto.]])
		elseif conceptoSel == "Troll" then
			guiSetText(memoConceptosRol, "")
		elseif conceptoSel == "AA" then
			guiSetText(memoConceptosRol, "")
		elseif conceptoSel == "CJ" then
			guiSetText(memoConceptosRol, "")
		end
	end
end
                             