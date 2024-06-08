-- Soporte Administrativo para poder ver los comandos mediante un panel.

VadminInfo = guiCreateWindow(406, 218, 339, 367, "Soporte - Administración DTRP", false)
guiWindowSetSizable(VadminInfo, false)

ComandosInfoM = guiCreateMemo(144, 22, 185, 335, "Pulsa tu rango.", false, VadminInfo)
guiMemoSetReadOnly ( ComandosInfoM, true )
BoGO = guiCreateButton(10, 141, 125, 40, "GAMEOPERATOR", false, VadminInfo)
BoADMIN = guiCreateButton(9, 191, 125, 40, "ADMINISTRADOR", false, VadminInfo)
CerrarVentanaInfo = guiCreateButton(36, 308, 72, 43, "CERRAR", false, VadminInfo)
TextoInferiorB = guiCreateLabel(14, 24, 121, 17, "Comandos definidos:", false, VadminInfo)
guiSetFont(TextoInferiorB, "default-bold-small")
guiSetVisible (VadminInfo,false) 


function abrirPanelStaffHelp ()
  if exports.players:isLoggedIn(getLocalPlayer()) then
	if guiGetVisible (VadminInfo) == true then
		showCursor (false)
		guiSetVisible (VadminInfo,false)
	else
		showCursor (true)
		guiSetVisible (VadminInfo,true)
	end
  end
end
addEvent("onAbrirPanelAyudaAdmin", true)
addEventHandler("onAbrirPanelAyudaAdmin", getRootElement(), abrirPanelStaffHelp)

function ayudaMemoComandos ()
	if source == CerrarVentanaInfo then
		showCursor (false)
		guiSetVisible (VadminInfo,false)
	elseif source == BoGO then
		guiSetText ( ComandosInfoM, [[ Comandos GameOperator
		/m - modchat.
		/jp: jetpack para poder moverse.
		/goto: ir a un jugador.
		/get: traer un jugador.
		/gotoveh: ir a un vehículo.
		/getveh: traer un vehículo.
		/gotoint: ir a un interior.
		/radiostaff: poner musica general.
		/sethp: definir vida jugador.
		/freeze: congelar usuario.
		/unfreeze: descongelar usuario.
		/revivir: revivir usuario.
		/conectados: miembros conectados.
		/factions: ver facciones totales.
		/low: ver jugadores en lowHP.
		/titular: ver dueño interior o vehículo.
		/verjailde: ver tiempo jail IC u OOC.
		/togglemodchat: apagar modchat.
		/togglepm: cerrar mensajes privados.
		/mutepm: cerrar los pms a.
		/sancionar: sancionar a un usuario.
		/kick: echar un usuario.
		/spec: spectear un jugador.
		/fixveh: reparar un vehículo.
		/respawnvehicles: respawnear todo.
		/refillvehicles: llenar gasolina global.
		/rv: respawnear vehiculo ID.
		/staffduty: ponerse en servicio.
		/datos: ver info de jugador.
		/fecha: ver inactividad de usuario.
		/freecam: camara libre.
		/giveitem: dar un item.
		/liberar: arresto IC.
		/createtext: crear info.
		/deletetext: borrar info.
		/nearbytexts: infos cercanos.
		/createshop: crear npc tienda.
		/deleteshop: borrar npc tienda.
		/nearbyshops: ver npcs cercanos.
		/delveh: borrar vehículo negativo.
		/veh: crear vehículo negativo.
		/vehsf: ver vehículos de facciones.
		/sancionar: sancionar a un usuario.
		/color: cambiar raza negro o blanco.
		/edad: cambiar edad a un personaje.
		/genero: cambiar sexo a un personaje.
		/createint: crear interior.
		/deleteint: borrar interior.
		/getint: ver información del interior.
		/setintprice: asignar precio al interior.
		/nearbyints: interiores cercanos.
		/createperiodico: crear stants periodicos.
		/nearbyperiodicos: stants periodicos cercanos.
		/deleteperiodico: borrar stants periodicos.
		/createatm: crear cajero.
		/deleteatm: borrar cajero.
		/nearbyatms: cajeros cercanos.
		/createcabina: crear cabina telefonica.
		/deletecabina: borrar cabina telefonica.
		/nearbycabinas: cabinas cercanas.
		/markteleport: marcar teleport.
		/createteleport: crear teleport.
		/nearbyteleports: teleports cercanos.
		/setintowner: hacer dueño interior usuario.
		/setintname: cambia nombre del interior.
		/setfaction: añadir un jugador a una facción.
		F9 > Panel de TP.
		]] )
    elseif source == BoADMIN then
		guiSetText ( ComandosInfoM, [[ Comandos Administrador
		/makeveh: crear vehículo positivo.
		/faleatorio: crear fuego aleatorio a los bomberos.
		/fquitar: apagar fuego aleatorio creado.
		/createfuelpoint: crear estación gasolina.
		/delveh: borrar vehículo activo o negativo.
		/setvehiclefaction: poner vehóculo en una facción.
		/setvehcolor: cambiar color a un vehículo.
		/setowner: cambiar dueño vehículo.
		F9 > Panel de TP.		]])
    end
end
addEventHandler ("onClientGUIClick", root, ayudaMemoComandos)