--[[
Copyright (C) 2019 DownTown RolePlay

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

function showCondiciones(version, texto)
		showCursor(true)
        toggleAllControls(false) 
	    setElementData(getLocalPlayer(), "nogui", true )
        ventana = guiCreateWindow(0.31, 0.18, 0.37, 0.70, "Condiciones del servicio. DownTown RolePlay. Versión "..tostring(version), true)
        guiWindowSetSizable(ventana, false)
		memocon = guiCreateMemo(0.04, 0.07, 0.94, 0.77, tostring(texto), true, ventana)
        guiMemoSetReadOnly(memocon, true)
		btodo = guiCreateButton(0.67, 0.85, 0.29, 0.14, "Acepto las condiciones.", true, ventana)
		addEventHandler( "onClientGUIClick", btodo, regulador )
        bnoacepto = guiCreateButton(0.05, 0.85, 0.29, 0.14, "No acepto las condiciones.", true, ventana)    
        addEventHandler( "onClientGUIClick", bnoacepto, regulador )
end
addEvent("onMostrarCondiciones", true)
addEventHandler("onMostrarCondiciones", getLocalPlayer(), showCondiciones)

function editarCondiciones(version, texto)
		showCursor(true)
        toggleAllControls(false) 
	    setElementData(getLocalPlayer(), "nogui", true )
        ventana2 = guiCreateWindow(0.31, 0.18, 0.37, 0.70, "Condiciones del servicio. DownTown RolePlay. Versión "..tostring(version), true)
        guiWindowSetSizable(ventana2, false)
		if texto then
		memocon = guiCreateMemo(0.04, 0.07, 0.94, 0.77, tostring(texto), true, ventana2)
       -- guiMemoSetReadOnly(memocon, true)
	--	else
		--memocon = guiCreateMemo(0.04, 0.07, 0.94, 0.77, "    CONDICIONES DEL SERVICIO. DOWNTOWN COUNTY ROLEPLAY. VERSIÓN "..tostring(version).."\n1. Términos.\nEn el siguiente escrito, se puede tratar a Bone County Roleplay como el \"servidor\", y al equipo administrativo como \"staff\". Cuando digamos \"foro\", nos referimos a http://bonecounty-rp.foroactivo.com/. Reglas generales.\nA continuación detallamos las reglas generales, que son obligatorias para entrar.\n\na) Usuarios.\n\n1. No se tolerará la mínima falta de respeto entre usuarios y/ o a la comunidad.\n\n2. Si te has sentido amenazado, o que te están faltando el respeto ( ya sea por medio de comentarios en temas como por mensajes privados ) puedes usar el botón que dice debajo del mensaje: \"Reportar al moderador\". Así podremos tomar medidas y sancionar al usuario severamente.\n\n3. Puedes contactar con un staff de dos maneras:\n\n- Dentro del juego usando /staff.\n- A través del foro, mandando un mensaje privado a cualquier administrador, moderador o colaborador.\n \n4. Si tienes alguna duda, deberás usar el comando /duda. Cabe destacar que tiene que haber un staff de servicio para que la reciba.\n\n5. Si tienes alguna incidencia con un jugador, deberás de reportarle publicando un reporte en el foro.\n \nb) Foro.\n\n1. En la categoría de \"Anuncios administrativos\" solo están autorizados crear un tema los staffs. Los usuarios normales solo pueden comentar.\n\n2. En las categorias que están clasificadas [IC] no está permitido hablar OOC, excepto en casos excepcionales, e indicado.\n\n3. En los reportes, no tienes derecho a comentar a menos que seas una de las siguientes personas:\n\n- Equipo administrativo\n- Usuario que reporta\n- Usuario reportado\n- Usuario directamente afectado. ( Que salga el nombre en los logs, eso no significa que sea \"directamente afectado\" )\n\n4. En las apelaciones de baneo, no tienes derecho a comentar a menos que seas una de las siguientes personas:\n\n- Equipo administrativo\n- Usuario que manda la apelacion\n\n5. Cualquier mensaje, en cualquier categoría que se considere como \"SPAM\", podrá ser bloqueado, movido o elimniado por parte de la administración.\n\n6. Es obligatorio tener el campo del \"Soy\" rellenado, y que sea válido. Puedes hacerlo mediante este enlace: http://bonecounty-rp.foroactivo.com/profile?mode=editprofile\n\n7. Un intento de \"hackeo\" o de manipulación del foro, haciendo que no funcione correctamente o como debería, se tomarán medidas drásticas, baneando a los participantes de dicha acción, y se reportará esta acción a las autoridades competentes.\n                                                               \n8. El equipo administrativo ( administradores, moderadores y gamemasters ) tiene acceso a partes, en las que puede ver tu dirección IP y tu dirección de correo electrónico con el fin de mantener la seguridad en el foro. Si no entiendes qué significa esto, puedes visitar http://blog.vermiip.es/2008/03/11/que-es-el-numero-ip-que-significa-ip/\n\n9. No está permitido compartir una cuenta con dos usuarios. Explicaré esto detalladamente con ejemplos:\n\nEjemplo 1: tengo una cuenta en el foro, pero tengo dos personajes. ¿Esto es válido? Sí. En una cuenta puedes tener todos los personajes que quieras, siempre y cuando sean tuyos.\n\nEjemplo 2: somos dos hermanos, y en el servidor, tenemos distintas cuentas. Dentro del foro, hemos creado solo una y la compartimos. ¿Esto es válido? No. Cada uno de los hermanos tiene que tener su propia cuenta en foro.\n\n10. Solo se permite una cuenta por dirección IP. Se incluyen las siguientes excepciones:\n\n-Un amigo ha venido un día a jugar a mi casa.\n-Somos varios hermanos.\n-El internet es compartido, dado que vivimos cerca.\n\nAVISO: Si es uno de los casos, hay que informar al administrador Jefferson mediante mensaje privado en foro o por mensaje privado en el servidor.\n\n11.Tras la modificación del apartado segundo del artículo 22 de la LSSI (Ley 34/2002, de 11 de julio, de servicios de la sociedad de la información y de comercio electrónico) por el Real Decreto-ley 13/2012, de 30 de marzo, se especifica que cualquier página web debe informar sobre el uso de cookies, así como solicitar su consentimiento. Esta página web almacena cookies con el fin de mantener la seguridad y la privacidad en el foro. Estas cookies solo se usarán con los fines nombrados anteriormente, y en ningún caso para usos frauduluentos. Si estás navegando en el foro, entendemos que aceptas el uso de éstas cookies. Si no estás de acuerdo, solicitamos que contactes con un administrador para eliminar tu cuenta y que no vuelvas a navegar por el foro.\n\nc) Servidor.\n\n1. Para poder entrar al servidor de Bone County Roleplay, necesitas saber una base de conceptos. Esos conceptos te los preguntaremos en el juego, así que no tienes el porqué preocuparte.\n\n2. El nombre dentro del servidor debe de ser \"Nombre Apellido\" ( sin las comillas ). Cualquier otro tipo de nombre, la administración ( administradores, moderadores y gamemasters ) nos veremos obligados a tomar medidas, ya sea jailear a ese jugador, cambiarle el nombre a otro, etcétera.\n\n3. Cualquier anomalía que se produzca en el servidor debe ser reportada en el foro, en la categoría de Soporte Técnico ( http://bonecounty-rp.foroactivo.com/f19-soporte-tecnico ). Si descubres un \"fallo\" o \"bug\", y te estás beneficiando de él, serás baneado permanentemente del servidor, sin opción a apelar.\n\n4. Un intento de \"hackeo\" o de manipulación del servidor, haciendo que no funcione correctamente o como debería, se tomarán medidas drásticas, baneando a los participantes de dicha acción, y se reportará esta acción a las autoridades competentes.\n\n5. A no ser que un staff te lo indique, solo se puede registrar una cuenta por persona en la vida real. Pongo ejemplos:\n\n-Somos dos hermanos, y solo tenemos un ordenador. Entonces, cada uno tiene su cuenta. ¿Está permitido? Si.\n\n-Soy un usuario, y, en vez de crear varios personajes en mi cuenta habitual, me he creado otra cuenta para tener los personajes en distintas cuentas. ¿Está permitido? No. Si descubrimos esto, serás baneado permanentemente del servidor sin optar a realizar una apelación.\n\n6. Solo y exclusivamente las facciones ilegales oficiales podrán rolear realizar cócteles molotov con el spec de un miembro del equipo administrativo con el siguiente rango (Moderador, Administrador o Developer) , con un máximo de 5, aportando 300$ por cada unidad. Siempre se deben tener razones de peso para utilizarlas\n\n7. Con el fin de mantener la seguridad del servidor, la estabilidad, y el correcto funcionamiento del mismo, se almacenan los siguientes datos:\n\n-Usuario \n-Contraseña cifrada(NO se puede descifrar) \n-Serial de MTA\n-IP \n\nDebido a que algunos usuarios pueden no estar de acuerdo con los datos que recogemos, a continuación por esta mísma vía podrás escoger si lo aceptas o lo deniegas.\nTen en cuenta que, como todos los datos son obligatorios, si no estás de acuerdo a que se almacenen alguno o algunos de los datos, tu cuenta procederá a ser eliminada.\n\n8. El staff puede tomar las medidas necesarias, accediendo a la IP, Serial de MTA y Usuario, exclusivamente en los casos que el staff lo vea necesario.\n\n9. Cualquier falta de respeto que se produzca hacia el servidor, usuarios, staff, foro o hacia alguno de nuestros sistemas, podrá ser sancionado por el staff.\n\n10. La no aceptación de estas condiciones supondrá la eliminación de cuenta del servidor.\n\n\n", true, ventana2)
		end
		bedit = guiCreateButton(0.67, 0.85, 0.29, 0.14, "Editar.", true, ventana2)
		addEventHandler( "onClientGUIClick", bedit, regulador )
        bsalir = guiCreateButton(0.05, 0.85, 0.29, 0.14, "Cancelar edición.", true, ventana2)    
        addEventHandler( "onClientGUIClick", bsalir, regulador )
end
addEvent("onEditarCondiciones", true)
addEventHandler("onEditarCondiciones", getLocalPlayer(), editarCondiciones)

function regulador(player)
	if source == btodo then
		showCursor(false)
		toggleAllControls(true) 
		triggerServerEvent("onAceptarCondiciones", getLocalPlayer(), getLocalPlayer())
		destroyElement(ventana)
		setElementData(getLocalPlayer(), "nogui", false) 
	--elseif source == bnoacepto or player then
		--triggerServerEvent("onNoAceptarNada", getLocalPlayer(), getLocalPlayer())
		--destroyElement(ventana)
	elseif source == bclose then
		showCursor(false)
		toggleAllControls(true)
		destroyElement(ventana)
		setElementData(getLocalPlayer(), "nogui", false)
	elseif source == bsalir then
		showCursor(false)
		toggleAllControls(true)
		destroyElement(ventana2)
		setElementData(getLocalPlayer(), "nogui", false)
	elseif source == bedit then
		local text = guiGetText(memocon)
		triggerServerEvent("onActualizarCondiciones", getLocalPlayer(), tostring(text))
	end
end
addCommandHandler("anularcon", regulador)

--[[
function revisarCondiciones()
	outputChatBox("Estas son las últimas condiciones que has aceptado. Si no estás de acuerdo con ellas usa /anularcon", 255, 255, 0)
    ventana = guiCreateWindow(0.31, 0.18, 0.37, 0.70, "Condiciones del servicio. Bone County Roleplay. Versión "..tostring(version), true)
    guiWindowSetSizable(ventana, false)
    memocon = guiCreateMemo(0.04, 0.07, 0.94, 0.77, "    CONDICIONES DEL SERVICIO. BONE COUNTY ROLEPLAY. VERSIÓN "..tostring(version).."\n1. Términos.\nEn el siguiente escrito, se puede tratar a Bone County Roleplay como el \"servidor\", y al equipo administrativo como \"staff\". Cuando digamos \"foro\", nos referimos a http://bonecounty-rp.foroactivo.com/. Reglas generales.\nA continuación detallamos las reglas generales, que son obligatorias para entrar.\n\na) Usuarios.\n\n1. No se tolerará la mínima falta de respeto entre usuarios y/ o a la comunidad.\n\n2. Si te has sentido amenazado, o que te están faltando el respeto ( ya sea por medio de comentarios en temas como por mensajes privados ) puedes usar el botón que dice debajo del mensaje: \"Reportar al moderador\". Así podremos tomar medidas y sancionar al usuario severamente.\n\n3. Puedes contactar con un staff de dos maneras:\n\n- Dentro del juego usando /staff.\n- A través del foro, mandando un mensaje privado a cualquier administrador, moderador o colaborador.\n \n4. Si tienes alguna duda, deberás usar el comando /duda. Cabe destacar que tiene que haber un staff de servicio para que la reciba.\n\n5. Si tienes alguna incidencia con un jugador, deberás de reportarle publicando un reporte en el foro.\n \nb) Foro.\n\n1. En la categoría de \"Anuncios administrativos\" solo están autorizados crear un tema los staffs. Los usuarios normales solo pueden comentar.\n\n2. En las categorias que están clasificadas [IC] no está permitido hablar OOC, excepto en casos excepcionales, e indicado.\n\n3. En los reportes, no tienes derecho a comentar a menos que seas una de las siguientes personas:\n\n- Equipo administrativo\n- Usuario que reporta\n- Usuario reportado\n- Usuario directamente afectado. ( Que salga el nombre en los logs, eso no significa que sea \"directamente afectado\" )\n\n4. En las apelaciones de baneo, no tienes derecho a comentar a menos que seas una de las siguientes personas:\n\n- Equipo administrativo\n- Usuario que manda la apelacion\n\n5. Cualquier mensaje, en cualquier categoría que se considere como \"SPAM\", podrá ser bloqueado, movido o elimniado por parte de la administración.\n\n6. Es obligatorio tener el campo del \"Soy\" rellenado, y que sea válido. Puedes hacerlo mediante este enlace: http://bonecounty-rp.foroactivo.com/profile?mode=editprofile\n\n7. Un intento de \"hackeo\" o de manipulación del foro, haciendo que no funcione correctamente o como debería, se tomarán medidas drásticas, baneando a los participantes de dicha acción, y se reportará esta acción a las autoridades competentes.\n                                                               \n8. El equipo administrativo ( administradores, moderadores y gamemasters ) tiene acceso a partes, en las que puede ver tu dirección IP y tu dirección de correo electrónico con el fin de mantener la seguridad en el foro. Si no entiendes qué significa esto, puedes visitar http://blog.vermiip.es/2008/03/11/que-es-el-numero-ip-que-significa-ip/\n\n9. No está permitido compartir una cuenta con dos usuarios. Explicaré esto detalladamente con ejemplos:\n\nEjemplo 1: tengo una cuenta en el foro, pero tengo dos personajes. ¿Esto es válido? Sí. En una cuenta puedes tener todos los personajes que quieras, siempre y cuando sean tuyos.\n\nEjemplo 2: somos dos hermanos, y en el servidor, tenemos distintas cuentas. Dentro del foro, hemos creado solo una y la compartimos. ¿Esto es válido? No. Cada uno de los hermanos tiene que tener su propia cuenta en foro.\n\n10. Solo se permite una cuenta por dirección IP. Se incluyen las siguientes excepciones:\n\n-Un amigo ha venido un día a jugar a mi casa.\n-Somos varios hermanos.\n-El internet es compartido, dado que vivimos cerca.\n\nAVISO: Si es uno de los casos, hay que informar al administrador Jefferson mediante mensaje privado en foro o por mensaje privado en el servidor.\n\n11.Tras la modificación del apartado segundo del artículo 22 de la LSSI (Ley 34/2002, de 11 de julio, de servicios de la sociedad de la información y de comercio electrónico) por el Real Decreto-ley 13/2012, de 30 de marzo, se especifica que cualquier página web debe informar sobre el uso de cookies, así como solicitar su consentimiento. Esta página web almacena cookies con el fin de mantener la seguridad y la privacidad en el foro. Estas cookies solo se usarán con los fines nombrados anteriormente, y en ningún caso para usos frauduluentos. Si estás navegando en el foro, entendemos que aceptas el uso de éstas cookies. Si no estás de acuerdo, solicitamos que contactes con un administrador para eliminar tu cuenta y que no vuelvas a navegar por el foro.\n\nc) Servidor.\n\n1. Para poder entrar al servidor de Bone County Roleplay, necesitas saber una base de conceptos. Esos conceptos te los preguntaremos en el juego, así que no tienes el porqué preocuparte.\n\n2. El nombre dentro del servidor debe de ser \"Nombre Apellido\" ( sin las comillas ). Cualquier otro tipo de nombre, la administración ( administradores, moderadores y gamemasters ) nos veremos obligados a tomar medidas, ya sea jailear a ese jugador, cambiarle el nombre a otro, etcétera.\n\n3. Cualquier anomalía que se produzca en el servidor debe ser reportada en el foro, en la categoría de Soporte Técnico ( http://bonecounty-rp.foroactivo.com/f19-soporte-tecnico ). Si descubres un \"fallo\" o \"bug\", y te estás beneficiando de él, serás baneado permanentemente del servidor, sin opción a apelar.\n\n4. Un intento de \"hackeo\" o de manipulación del servidor, haciendo que no funcione correctamente o como debería, se tomarán medidas drásticas, baneando a los participantes de dicha acción, y se reportará esta acción a las autoridades competentes.\n\n5. A no ser que un staff te lo indique, solo se puede registrar una cuenta por persona en la vida real. Pongo ejemplos:\n\n-Somos dos hermanos, y solo tenemos un ordenador. Entonces, cada uno tiene su cuenta. ¿Está permitido? Si.\n\n-Soy un usuario, y, en vez de crear varios personajes en mi cuenta habitual, me he creado otra cuenta para tener los personajes en distintas cuentas. ¿Está permitido? No. Si descubrimos esto, serás baneado permanentemente del servidor sin optar a realizar una apelación.\n\n6. Solo y exclusivamente las facciones ilegales oficiales podrán rolear realizar cócteles molotov con el spec de un miembro del equipo administrativo con el siguiente rango (Moderador, Administrador o Developer) , con un máximo de 5, aportando 300$ por cada unidad. Siempre se deben tener razones de peso para utilizarlas\n\n7. Con el fin de mantener la seguridad del servidor, la estabilidad, y el correcto funcionamiento del mismo, se almacenan los siguientes datos:\n\n-Usuario \n-Contraseña cifrada(NO se puede descifrar) \n-Serial de MTA\n-IP \n\nDebido a que algunos usuarios pueden no estar de acuerdo con los datos que recogemos, a continuación por esta mísma vía podrás escoger si lo aceptas o lo deniegas.\nTen en cuenta que, como todos los datos son obligatorios, si no estás de acuerdo a que se almacenen alguno o algunos de los datos, tu cuenta procederá a ser eliminada.\n\n8. El staff puede tomar las medidas necesarias, accediendo a la IP, Serial de MTA y Usuario, exclusivamente en los casos que el staff lo vea necesario.\n\n9. Cualquier falta de respeto que se produzca hacia el servidor, usuarios, staff, foro o hacia alguno de nuestros sistemas, podrá ser sancionado por el staff.\n\n10. La no aceptación de estas condiciones supondrá la eliminación de cuenta del servidor.\n\n\n", true, ventana)
    guiMemoSetReadOnly(memocon, true)
	bclose = guiCreateButton(0.67, 0.85, 0.29, 0.14, "Cerrar ventana.", true, ventana)
	addEventHandler( "onClientGUIClick", bclose, regulador )
   -- bnoacepto = guiCreateButton(0.05, 0.85, 0.29, 0.14, "No acepto las condiciones.", true, ventana)    
   -- addEventHandler( "onClientGUIClick", bnoacepto, regulador )
end
addCommandHandler("condiciones", revisarCondiciones)]]

function revisarCondiciones(version, texto)
		outputChatBox("Estas son las últimas condiciones que has aceptado. Si no estás de acuerdo con ellas usa /anularcon", 255, 255, 0)
		showCursor(true)
        toggleAllControls(false) 
	    setElementData(getLocalPlayer(), "nogui", true )
        ventana = guiCreateWindow(0.31, 0.18, 0.37, 0.70, "Condiciones del servicio. DownTown RolePlay. Versión "..tostring(version), true)
        guiWindowSetSizable(ventana, false)
		memocon = guiCreateMemo(0.04, 0.07, 0.94, 0.77, tostring(texto), true, ventana)
        guiMemoSetReadOnly(memocon, true)
		bclose = guiCreateButton(0.67, 0.85, 0.29, 0.14, "Cerrar ventana.", true, ventana)
		addEventHandler( "onClientGUIClick", bclose, regulador )
        bnoacepto = guiCreateButton(0.05, 0.85, 0.29, 0.14, "No acepto las condiciones.", true, ventana)    
        addEventHandler( "onClientGUIClick", bnoacepto, regulador )
end
addEvent("onReMostrarCondiciones", true)
addEventHandler("onReMostrarCondiciones", getLocalPlayer(), revisarCondiciones)