local x, y = guiGetScreenSize()
 
function openWindowLinkForum()
	setElementData(getLocalPlayer(), "nogui", true)
	triggerEvent("onCursor", getLocalPlayer())
	toggleAllControls(false)
	vGestForo = guiCreateWindow(x*541/1600, y*243/900, x*463/1600, y*405/900, "Vinculación de cuenta con foro - DownTown RolePlay", false)
	guiWindowSetSizable(vGestForo, false)

	lInfo = guiCreateLabel(x*24/1600, 36, x*414/1600, y*151/900, "Para poder disfrutar de todos los servicios DownTown, es necesario que dispongas de una cuenta de foro y, además, que esta cuenta esté vinculada a tu cuenta IG.\n\nSi ya tienes cuenta de foro, introduce tus datos abajo para vincularla a tu cuenta.\n\nSi no tienes cuenta, rellena el formulario del mismo modo y haz click en 'Vincular'. Te crearemos una y te la vincularemos.", false, vGestForo)
	guiLabelSetHorizontalAlign(lInfo, "left", true)
	lUforo = guiCreateLabel(x*66/1600, y*208/900, x*95/1600, y*19/900, "Usuario de foro:", false, vGestForo)
	lCforo = guiCreateLabel(x*66/1600, y*237/900, x*114/1600, y*18/900, "Contraseña de foro:", false, vGestForo)
	eUforo = guiCreateEdit(x*194/1600, y*208/900, x*196/1600, y*21/900, "", false, vGestForo)
	eCforo = guiCreateEdit(x*194/1600, y*237/900, x*196/1600, y*21/900, "", false, vGestForo)
	guiEditSetMasked(eCforo, true)
	bVincular = guiCreateButton(x*105/1600, y*277/900, x*250/1600, y*52/900, "Vincular", false, vGestForo)
	bCancelar = guiCreateButton(x*105/1600, y*339/900, x*250/1600, y*52/900, "Cancelar", false, vGestForo)
	addEventHandler("onClientGUIClick", bCancelar, regulateButtonsWindowLinkForum)
	addEventHandler("onClientGUIClick", bVincular, regulateButtonsWindowLinkForum)
end
addEvent("onRequestWindowLinkForum", true)
addEventHandler("onRequestWindowLinkForum", getRootElement(), openWindowLinkForum)
              
function regulateButtonsWindowLinkForum()
	if source == bCancelar then
		destroyElement(vGestForo)
		triggerEvent("offCursor", getLocalPlayer())
		setElementData(getLocalPlayer(), "nogui", nil)
		toggleAllControls(true)
	elseif source == bVincular then
		local uForo = guiGetText(eUforo)
		local cForo = guiGetText(eCforo)
		if uForo and cForo and tostring(cForo) ~= "" and tostring(uForo) ~= "" then
			triggerServerEvent("onRequestLinkWithAccountForum", getLocalPlayer(), tostring(uForo), tostring(cForo))
			destroyElement(vGestForo)
			triggerEvent("offCursor", getLocalPlayer())
			setElementData(getLocalPlayer(), "nogui", nil)
			toggleAllControls(true)
		else
			outputChatBox("Debes de introducir un usuario y una contraseña.", 255, 0, 0)
		end
	end
end