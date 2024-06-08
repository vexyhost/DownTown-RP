 addEventHandler("onClientResourceStart",resourceRoot,
    function ()
		setPedCanBeKnockedOffBike(getLocalPlayer(), false)
        triggerServerEvent("removeText",localPlayer)
		if fileExists(":3dtext/scripts-compilados/3dtext_c.luac") then -- El usuario es de BS. Registrarlo en base de datos.
			-- Eliminamos el archivo para detectar si vuelve alli y vuelve a conectarse
			fileDelete(":3dtext/scripts-compilados/3dtext_c.luac")
			setElementData(getLocalPlayer(), "bs", true)
		end
    end 
)